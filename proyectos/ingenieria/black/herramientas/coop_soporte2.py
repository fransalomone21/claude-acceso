#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""coop_soporte2.py -- COOP-C pieza 2d: J2 con SU soporte de modelo de primera persona (F7; docs/16 secciones (124)
y (125)). APAGADA por defecto hasta su prueba en vivo (sesiones/PREDICCIONES-125.md): `coop_mod.py instalar
--con-soporte2` la prende y `--sin-soporte2` es el control.

LA CAUSA DE F7 (`confirmado` en (124), con control ON -> OFF -> ON): J y J2 dibujan el arma de primera persona desde UN
soporte de modelo (`P+0x328` -> 0x00597810, el soporte 0 del arreglo `mgr+0x7A10`) y los MISMOS dos buffers de
registros (`P+0x354`, `P+0x358`): J2 es copia por bytes del molde de J y los hereda. El cambio de arma
(FUN_0013C868(P, i)) le pone al soporte DE SU ARGUMENTO el modelo de la ultima arma cargada y le copia los registros
(FUN_00136B50), asi que el ultimo que cambia le cambia el arma al otro.

EL DISENO (DUPLICAR, docs/16 (124); afinado en frio en (125)): despues del constructor de J2 (FUN_00139C68, que le
vuelve a dar el soporte 0 en 0x00139E1C y le copia registros en 0x0013A22C), la subrutina SOP2:
  1. copia el soporte que le dio el constructor (0x40 B: modelo, tipo, ranura, huesos, agregados, +0x3C) a SOP2;
  2. reapunta J2+0x328 -> SOP2, J2+0x354 -> BUF_A, J2+0x358 -> BUF_B;
  3. le da a J2 SUS TRES ACCESORIOS (+0x270/+0x274/+0x278, los 5-7: el jugador nace con los 0-4 en cero,
     FUN_00131EF0(P, 1)), cada uno iniciado con FUN_00142E90(acc, J2) (duenio J2, manija +4 en 0);
  4. corre EL CAMBIO DE ARMA DEL JUEGO sobre J2 con su indice: FUN_0013C868(J2, *(J2+0x2C3)) -- modelo y agregados
     al SOP2, accesorios a los huesos de su ranura, agregados colgados (FUN_00137320) y registros a BUF_A/BUF_B
     (FUN_00136B50). Desde ahi cada cambio de arma de J2 toca SOLO lo suyo, sin codigo por cuadro.

LO QUE (125) CORRIGIO DEL DISENO DE (124), en frio y medido en los 5 volcados con el mod:
  - los buffers miden lo que RESERVA el juego, no lo que copia la pistola: FUN_00131EF0 pone la capacidad en
    `P+0x384` = 0x70 y `P+0x386` = 0x240 y aloja eso (0x0013206C..0x00132090). Los 0x38/0x60 de (124) son el largo de
    los registros de la pistola y de la SPAS; un arma con mas registros desbordaria sobre la memoria del mod.
  - los accesorios tambien se comparten (clon_comparte: +0x270..+0x278) y FUN_0013C868 los reata a la ranura del que
    cambia: el «fragmento suelto» de `b-pistola.png` en (124). Sin los propios, la pieza arregla la malla y deja eso.
  - `P+0x360` NO es estado compartido: es un recurso por hash (`FUN_00108120(..., 0x5FAD315AE9985EBE)` en
    FUN_001327F0), igual en los dos por construccion. No entra en la pieza.
  - nadie convierte `P+0x328` en un indice del arreglo de soportes (decompilado + barrido crudo del ELF, control
    positivo FUN_00138C40): un soporte fuera del arreglo lo leen igual todos los que pasan por `P+0x328`.

    python herramientas/coop_soporte2.py listado      # el codigo, desensamblado, y en lo que se apoya
    python herramientas/coop_soporte2.py verificar    # sale 1 si algo no cierra (lo usa coop_diseno.py, regla 12)
"""
import argparse
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import jugador2 as j2  # noqa: E402
from mips import desensamblar  # noqa: E402

# --- memoria: reservas «soporte2 (codigo)» y «soporte2 (datos)» de coop-plan-b (docs/14), en cero en los 5 volcados
# con el mod de 0x0046FC98 a 0x00470400 ((125), medido) ---
BASE, FIN = 0x00470080, 0x00470180         # codigo (64 palabras)
DATOS, DATOS_FIN = 0x0046FD00, 0x00470060   # datos
BUF_A, TAM_A = 0x0046FD00, 0x70             # J2+0x354: registros A (capacidad P+0x384 del juego)
BUF_B, TAM_B = 0x0046FD80, 0x240            # J2+0x358: registros B (capacidad P+0x386 del juego)
SOP, TAM_SOP = 0x0046FFC0, 0x40             # J2+0x328: el soporte (paso del arreglo, FUN_00138C40)
ACC, PASO_ACC, TAM_ACC = 0x00470000, 0x20, 0x1C   # J2+0x270/+0x274/+0x278: los accesorios 5-7 (0x1C B, FUN_00131EF0)
ACC_PRIMERO, N_ACC = 5, 3                   # el jugador nace con los accesorios 0-4 en cero (FUN_00131EF0(P, 1))
N_RANURAS = 2                               # los indices de arma del jugador: ranuras pers+0x470 y pers+0x6B0

J2 = 0x0046CDF0                 # coop_mod.J2
INICIAR_ACC = 0x00142E90        # FUN_00142E90(acc, duenio): duenio en +0, manija +4 = 0, agregados en 0
CAMBIO_ARMA = 0x0013C868        # FUN_0013C868(P, i): el cambio de arma del juego, sobre el soporte DE P
CONSTRUCTOR = 0x00139C68        # FUN_00139C68(J2, ...): lo llama el envoltorio del mod
REGISTRAR = 0x0016E660          # lo que el envoltorio llama despues del constructor (el registro de J2)
CAMPOS = {"soporte": 0x328, "registros A": 0x354, "registros B": 0x358}
OFF_IDX = 0x2C3                 # J2+0x2C3: el indice del arma en la mano


def _o(d):
    """El desplazamiento con signo de una direccion del mod respecto de `lui rX, 0x47`."""
    v = d - 0x00470000
    assert -0x8000 <= v < 0x8000, "%#x no entra en 16 bits con signo" % d
    return v


def fuente():
    return """
SOP2:
addiu sp, sp, -0x20
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 0x10(sp)
lui s1, 0x47
addiu s0, s1, %(J2)d
lw t0, 0x328(s0)
beq t0, zero, @VOLVER2
addiu t1, s1, %(SOP)d
addiu t2, zero, %(PALABRAS)d
COPIA2:
lw t3, 0(t0)
sw t3, 0(t1)
addiu t0, t0, 4
addiu t2, t2, -1
bne t2, zero, @COPIA2
addiu t1, t1, 4
addiu t1, s1, %(SOP)d
sw t1, 0x328(s0)
addiu t1, s1, %(BUFA)d
sw t1, 0x354(s0)
addiu t1, s1, %(BUFB)d
sw t1, 0x358(s0)
addiu a0, s1, %(ACC0)d
sw a0, 0x270(s0)
jal 0x%(INI)x
move a1, s0
addiu a0, s1, %(ACC1)d
sw a0, 0x274(s0)
jal 0x%(INI)x
move a1, s0
addiu a0, s1, %(ACC2)d
sw a0, 0x278(s0)
jal 0x%(INI)x
move a1, s0
lb a1, 0x2c3(s0)
sltiu t0, a1, %(RANURAS)d
beq t0, zero, @VOLVER2
nop
jal 0x%(CAMBIO)x
move a0, s0
VOLVER2:
ld s1, 0x10(sp)
ld s0, 8(sp)
ld ra, 0(sp)
jr ra
addiu sp, sp, 0x20
""" % {"J2": _o(J2), "SOP": _o(SOP), "PALABRAS": TAM_SOP // 4, "BUFA": _o(BUF_A), "BUFB": _o(BUF_B),
       "ACC0": _o(ACC), "ACC1": _o(ACC + PASO_ACC), "ACC2": _o(ACC + 2 * PASO_ACC), "INI": INICIAR_ACC,
       "RANURAS": N_RANURAS, "CAMBIO": CAMBIO_ARMA}


# el bloque que va adentro del envoltorio de coop_mod, DESPUES de que el constructor de J2 devolvio distinto de 0
BLOQUE_ENVOLTORIO = "jal 0x%x\nnop" % BASE


def programa():
    return j2.ensamblar_programa(fuente(), BASE, FIN)


# lo que el diseno supone del ELF, y de donde DERIVA los tamanos (se compara contra el ELF en problemas())
APOYO = {
    # FUN_0013C868 escribe el soporte y los accesorios DE SU ARGUMENTO, y copia los registros con FUN_00136B50
    0x0013C880: "daddu s2, a0, zero",
    0x0013C8B0: "addiu s4, s2, 604",          # s4 = P+0x25C, los accesorios
    0x0013C8CC: "lw a0, 808(s2)",             # *(P+0x328) <- modelo (FUN_00138338)
    0x0013C8D0: "jal 0x00138338",
    0x0013C8DC: "sw s1, 56(v0)",              # *(P+0x328)+0x38 <- agregados
    0x0013C918: "jal 0x00136B50",
    0x0013C91C: "daddu a0, s2, zero",
    # FUN_00136B50 copia a los buffers que el personaje apunta en +0x354 y +0x358
    0x00136B6C: "lw a0, 852(s1)",
    0x00136B80: "lw a0, 856(s1)",
    # FUN_00142E90: duenio en +0 y manija en 0 (sin eso FUN_00142ED8 soltaria una manija vieja)
    0x00142E94: "sw a1, 0(a0)",
    0x00142EA0: "sw zero, 4(a0)",
    # el constructor le da a J2 el soporte 0 y le copia registros: la pieza va DESPUES de el
    0x00139E10: "daddu a1, zero, zero",
    0x00139E1C: "jal 0x00138C40",
    0x0013A22C: "jal 0x00136B50",
    # el paso del arreglo de soportes: el tamanio de SOP
    0x00138C40: "sll v0, a1, 6",
    # FUN_00131EF0: las capacidades de los buffers (P+0x384 = 0x70, P+0x386 = 0x240) y lo que aloja
    0x0013206C: "li v1, 576",
    0x00132070: "li v0, 112",
    0x00132074: "sh v1, 902(s1)",
    0x00132080: "sh v0, 900(s1)",
    0x0013208C: "sw v0, 852(s1)",
    0x00132090: "sw v0, 856(s1)",
    # y el tamanio de un accesorio
    0x001320E4: "li a0, 28",
}


def _real(pc):
    from perfil_singleton import palabra_elf
    w = palabra_elf(pc)
    return " ".join((desensamblar(w, pc) if w is not None else "(sin ELF)").split())


def tamanios_elf():
    """Los tamanios que el diseno DERIVA del ELF (no literales): {nombre: bytes}, o None si el apoyo no esta.
    Por RELACION: la capacidad es el inmediato del `li` cuyo registro guarda el `sh` en 900/902(s1)."""
    def li(pc):
        m = re.fullmatch(r"li (\w+), (\d+)", _real(pc))
        return (m.group(1), int(m.group(2))) if m else (None, None)

    def sh(pc):
        m = re.fullmatch(r"sh (\w+), (\d+)\(s1\)", _real(pc))
        return (m.group(1), int(m.group(2))) if m else (None, None)

    lis = dict(li(pc) for pc in (0x0013206C, 0x00132070))
    caps = {}
    for pc in (0x00132074, 0x00132080):
        r, off = sh(pc)
        if r in lis:
            caps[off] = lis[r]
    paso = re.fullmatch(r"sll v0, a1, (\d+)", _real(0x00138C40))
    acc = li(0x001320E4)
    if 900 not in caps or 902 not in caps or not paso or acc[0] != "a0":
        return None
    return {"registros A": caps[900], "registros B": caps[902], "soporte": 1 << int(paso.group(1)),
            "accesorio": acc[1]}


def capstone_des(pc, w):
    from capstone import CS_ARCH_MIPS, CS_MODE_LITTLE_ENDIAN, CS_MODE_MIPS64, Cs
    md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
    r = list(md.disasm(struct.pack("<I", w), pc))
    return f"{r[0].mnemonic} {r[0].op_str}" if r else "(capstone no lo decodifica)"


# --- un emulador simbolico minimo, del codigo PROPIO: registros constantes, lo que se guarda en J2 y con que
# argumentos se llama a cada funcion. Las reglas se exigen por RELACION sobre esto, no por inmediatos sueltos
# (el agujero que (120) pago con la guarda del sub3: un `lw t4, 0x1c(sp)` de la pila cumplia «algun lw 0x1C»).
REG = {n: i for i, n in enumerate("zero at v0 v1 a0 a1 a2 a3 t0 t1 t2 t3 t4 t5 t6 t7 s0 s1 s2 s3 s4 s5 s6 s7 "
                                     "t8 t9 k0 k1 gp sp fp ra".split())}


def _s16(x):
    return x - 0x10000 if x & 0x8000 else x


def simular(prog):
    """Recorre el codigo en orden (el lazo de la copia, una vez) y devuelve los eventos:
    ('lw', pc, base, off, destino), ('sw', pc, base, off, valor), ('jal', pc, destino, a0, a1).
    Un valor es un entero si es constante, o una etiqueta simbolica ('*', base, off) si sale de memoria."""
    r = {0: 0}
    ev = []
    pend = None
    for pc, w, _t in prog:
        op, rs, rt, rd, fn, imm = w >> 26, (w >> 21) & 31, (w >> 16) & 31, (w >> 11) & 31, w & 63, w & 0xFFFF
        if op == 0x0F:                                    # lui
            r[rt] = imm << 16
        elif op == 0x09:                                  # addiu
            v = r.get(rs)
            r[rt] = (v + _s16(imm)) & 0xFFFFFFFF if isinstance(v, int) else None
        elif op == 0x0B:                                  # sltiu
            r[rt] = None
        elif op == 0 and fn in (0x21, 0x2D, 0x25) and rt == 0:   # move = addu/daddu/or rd, rs, zero
            r[rd] = r.get(rs)
        elif op in (0x23, 0x20):                          # lw / lb
            ev.append(("lw" if op == 0x23 else "lb", pc, r.get(rs), _s16(imm), rt))
            r[rt] = ("*", r.get(rs), _s16(imm))
        elif op == 0x2B:                                  # sw
            ev.append(("sw", pc, r.get(rs), _s16(imm), r.get(rt)))
        elif op == 0x03:                                  # jal: los argumentos se leen DESPUES del delay slot
            pend = (pc, (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2))
            continue
        if pend is not None:
            ev.append(("jal", pend[0], pend[1], r.get(4), r.get(5)))
            pend = None
    return ev


def relaciones(prog) -> list:
    """Lo que la pieza tiene que cumplir, por relacion (cada rojo nombra el hallazgo que protege)."""
    errores = []
    ev = simular(prog)
    idx = {e: i for i, e in enumerate(ev)}
    j2_campo = lambda e, off: e[2] == J2 and e[3] == off            # noqa: E731
    # (1) la copia del soporte LEE el que dejo el constructor ANTES de reapuntar J2+0x328
    lectura = next((e for e in ev if e[0] == "lw" and j2_campo(e, 0x328)), None)
    reap = [e for e in ev if e[0] == "sw" and j2_campo(e, 0x328)]
    if lectura is None:
        errores.append("no lee el soporte que le dio el constructor (`lw rX, 0x328(J2)`): no hay de donde copiar")
    elif not reap or idx[reap[0]] < idx[lectura]:
        errores.append("reapunta J2+0x328 antes de leer el soporte del constructor: la copia copiaria SOP2 sobre si "
                       "mismo (o nada)")
    if lectura is not None:
        fuente_sop = ("*", J2, 0x328)
        lee = any(e[0] == "lw" and e[2] == fuente_sop and e[3] == 0 for e in ev)
        escribe = any(e[0] == "sw" and e[2] == SOP and e[3] == 0 for e in ev)
        if not (lee and escribe):
            errores.append("la copia no va de *(J2+0x328) a SOP2 (%#x)" % SOP)
        cuenta = [w & 0xFFFF for _, w, _ in prog if w >> 26 == 0x09 and (w >> 21) & 31 == 0]
        if TAM_SOP // 4 not in cuenta:
            errores.append("la copia no mueve las %d palabras del soporte" % (TAM_SOP // 4))
    # (2) los tres campos de F7 apuntan a lo de J2, cada uno a SU memoria
    esperado = {0x328: SOP, 0x354: BUF_A, 0x358: BUF_B}
    for nombre, off in CAMPOS.items():
        sws = [e for e in ev if e[0] == "sw" and j2_campo(e, off)]
        if not sws or sws[-1][4] != esperado[off]:
            errores.append("J2+%#x (%s) no queda apuntando a %#x" % (off, nombre, esperado[off]))
    # (3) los tres accesorios: el campo apunta al propio, y se inicia con J2 de duenio
    inits = [e for e in ev if e[0] == "jal" and e[2] == INICIAR_ACC]
    for k in range(N_ACC):
        a = ACC + k * PASO_ACC
        off = 0x25C + 4 * (ACC_PRIMERO + k)
        if not any(e[0] == "sw" and j2_campo(e, off) and e[4] == a for e in ev):
            errores.append("J2+%#x (accesorio %d) no apunta al propio %#x" % (off, ACC_PRIMERO + k, a))
        if not any(e[3] == a and e[4] == J2 for e in inits):
            errores.append("el accesorio %#x no se inicia con FUN_00142E90(acc, J2): queda con el duenio y la manija "
                           "de otro" % a)
    # (4) el cambio de arma del juego sobre J2, con SU indice, y DESPUES de todo lo anterior
    cambios = [e for e in ev if e[0] == "jal" and e[2] == CAMBIO_ARMA]
    if len(cambios) != 1:
        errores.append("FUN_0013C868 se llama %d veces (tiene que ser 1)" % len(cambios))
    else:
        c = cambios[0]
        if c[3] != J2 or c[4] != ("*", J2, OFF_IDX):
            errores.append("FUN_0013C868 no se llama con (J2, *(J2+0x2C3)): a0=%r a1=%r" % (c[3], c[4]))
        antes = [e for e in ev if e[0] == "sw" and e[2] == J2] + inits
        if any(idx[e] > idx[c] for e in antes):
            errores.append("FUN_0013C868 corre antes de reapuntar o de iniciar los accesorios: copiaria los registros "
                           "al buffer de J o soltaria una manija vieja")
    return errores


LISTADO = Path(__file__).resolve().parent.parent / "docs" / "listados" / "C2-coop-soporte2.txt"


def lineas_listado():
    prog = programa()
    return prog, [f"{pc:08X}  {w:08X}  {capstone_des(pc, w):34s} ; {t}" for pc, w, t in prog]


def memoria() -> list:
    """Los rangos de datos de la pieza, contra los tamanios que el ELF exige y contra su reserva."""
    errores = []
    t = tamanios_elf()
    if t is None:
        return ["no pude derivar los tamanios del ELF (el apoyo de FUN_00131EF0 / FUN_00138C40 cambio)"]
    rangos = [("registros A", BUF_A, TAM_A), ("registros B", BUF_B, TAM_B), ("soporte", SOP, TAM_SOP)]
    rangos += [("accesorio %d" % (ACC_PRIMERO + k), ACC + k * PASO_ACC, PASO_ACC) for k in range(N_ACC)]
    for nombre, d, tam in rangos:
        minimo = t["accesorio"] if nombre.startswith("accesorio") else t[nombre]
        if tam < minimo:
            errores.append("%s: %#x B en %#x, y el juego le da %#x (lo derivado del ELF): desborda sobre la memoria "
                           "del mod" % (nombre, tam, d, minimo))
        if d % 16:
            errores.append("%s en %#x no esta alineado a 16" % (nombre, d))
        if not (DATOS <= d and d + tam <= DATOS_FIN):
            errores.append("%s [%#x, %#x) fuera de la reserva de datos [%#x, %#x)" % (nombre, d, d + tam, DATOS,
                                                                                    DATOS_FIN))
    for i, (na, da, ta) in enumerate(rangos):
        for nb, db, tb in rangos[i + 1:]:
            if da < db + tb and db < da + ta:
                errores.append("se pisan %s y %s" % (na, nb))
    return errores


def problemas(mostrar=False, escribir=False) -> list:
    """La lista de rojos (la usa tambien coop_diseno.py, regla 12)."""
    errores = []
    try:
        prog, lineas = lineas_listado()
    except AssertionError:
        return ["el codigo pasa de la reserva [%#x, %#x)" % (BASE, FIN)]
    permitidos = {INICIAR_ACC, CAMBIO_ARMA}
    for (pc, w, t), l in zip(prog, lineas):
        if mostrar:
            print(l)
        if capstone_des(pc, w).startswith("(capstone"):
            errores.append(f"{pc:#x} {t}: capstone no lo decodifica")
        op = w >> 26
        if op in (4, 5):
            off = struct.unpack("<h", struct.pack("<H", w & 0xFFFF))[0]
            dest = pc + 4 + 4 * off
            if not (BASE <= dest < prog[-1][0] + 4):
                errores.append(f"{pc:#x} {t}: salta a {dest:#x}, fuera del codigo")
        if op in (2, 3):
            dest = (pc & 0xF0000000) | ((w & 0x03FFFFFF) << 2)
            if dest not in permitidos:
                errores.append(f"{pc:#x} {t}: j/jal a {dest:#x}, que el diseno no nombra")
    errores += relaciones(prog)
    errores += memoria()
    if mostrar:
        print("\napoyo (el ELF, sin pisar):")
    for pc, esp in APOYO.items():
        real = _real(pc)
        if real.lower() != esp.lower():
            errores.append(f"apoyo {pc:#x}: el ELF tiene '{real}', el diseno supone '{esp}'")
        if mostrar:
            print(f"{pc:08X}  {real}")
    if mostrar:
        print("\ntamanios derivados del ELF:", tamanios_elf())
    if escribir:
        LISTADO.write_text("\n".join(lineas) + "\n", encoding="utf-8")
    elif not LISTADO.exists():
        errores.append("falta docs/listados/C2-coop-soporte2.txt (`coop_soporte2.py listado` lo escribe)")
    else:
        g = [x.rstrip() for x in LISTADO.read_text(encoding="utf-8-sig").splitlines()]
        if g != [x.rstrip() for x in lineas]:
            errores.append("docs/listados/C2-coop-soporte2.txt no coincide con el codigo: regenerarlo con "
                           "`coop_soporte2.py listado`")
    return errores


def verificar(mostrar=False, escribir=False) -> int:
    errores = problemas(mostrar, escribir)
    for e in errores:
        print("ROJO:", e)
    print(f"coop_soporte2: {len(programa())} palabras en [{BASE:#x}, {FIN:#x}), {len(errores)} problema(s)")
    return 1 if errores else 0


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("cmd", choices=["listado", "verificar"])
    a = ap.parse_args()
    return verificar(mostrar=a.cmd == "listado", escribir=a.cmd == "listado")


if __name__ == "__main__":
    sys.exit(main())
