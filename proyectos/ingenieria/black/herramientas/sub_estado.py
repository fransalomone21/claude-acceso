#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sub_estado.py -- (118) el estado de lo que el SUB3 va a tocar, leido en los volcados, en frio.

    python herramientas/sub_estado.py            # tabla por volcado
    python herramientas/sub_estado.py --autotest # control positivo y negativo

La leccion de (116)/(117): ANTES de fabricar sobre una rutina elegida leyendo el codigo, se leen
en los volcados las guardas y los valores de los que depende su efecto. La pieza 2b (sub3) depende
de la regla del DUENO DE PLANTILLA (`docs/16` "sub3: la receta leida"), y esa regla supone tres cosas
que este script mide:

  1. `pers` = `*(0x0040F50C)` es el sistema de personajes, y los subs del aparejo viven en
     `pers+0x398 + i*0x6C` (`FUN_001A80F8` los construye una vez por arranque).
  2. Cada sub tiene `+4` = su ARENA (18 000 B) y `+8` = su PLANTILLA (un recurso del nivel,
     compartido por cualquiera que tenga esa arma).
  3. `FUN_001A8168` instancia la plantilla DENTRO de la arena del sub y guarda los punteros
     EN LA PLANTILLA (`FUN_00342A80`: plantilla `+0x20`, `+0x24`, `+0x28`, `+0x2C`).
     El invariante que hace falsable todo esto: esa cuadrupla apunta ADENTRO de la arena del sub
     que la armo ultimo. Es lo que el ruido no puede cumplir de casualidad.

Mide ademas lo que decide si el peligro es real: cuantos subs COMPARTEN plantilla hoy (en el juego
original tiene que ser 0: un jugador no tiene dos armas iguales), y que las dos reservas del sub3
(`0x0046ED00` codigo, `0x0046EF00` datos) esten en CERO.

HALLAZGO DE (118), medido aca: el sub que NO esta en la mano deja `sub+8` COLGADO -- apunta a
memoria que el nivel ya reciclo (en 14 de 16 volcados el objeto apuntado es ruido: su cabecera no
tiene la forma de una plantilla). Es inocuo en el juego original porque `FUN_001AC960` rearma el sub
--y con el `sub+8` y la cuadrupla-- antes de que su ranura se use. Pero la regla del dueno de
plantilla, escrita en `docs/16`, iba a ESCRIBIR cuatro palabras en `T+8` cuando `T+8` = Bo: sobre un
puntero colgado eso corrompe lo que hoy vive ahi. De ahi sale la GUARDA que este script valida:
una plantilla viva cumple `*(p+0x1C) == p+0x4C` (un puntero relativo a si misma, invariante POR
CONSTRUCCION). Discrimina 16/16 contra 0/14.

Sin numpy. Salida: una linea por volcado.
"""
import glob
import os
import struct
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

PERS_GLOBAL = 0x0040F50C   # *(esto) = el sistema de personajes (docs/16, (80))
SUBS_OFF = 0x398           # pers+0x398 + i*0x6C
SUB_PASO = 0x6C
N_SUBS = 2                 # las 2 ranuras = las 2 armas del unico jugador ((80))
ARENA_B = 18000            # FUN_001A80F8 aloja 18 000 B para la arena (+4)
CUAD = (0x20, 0x24, 0x28, 0x2C)   # la cuadrupla que FUN_00342A80 guarda en la plantilla

RES_SUB3_COD = (0x0046ED00, 0x0046EE00)
RES_SUB3_DAT = (0x0046EF00, 0x0046F000)

VIVA_OFF = 0x1C            # la guarda: *(p+0x1C) == p+0x4C en una plantilla viva
VIVA_REL = 0x4C


def u32(m, a):
    if a is None or a < 0 or a + 4 > len(m):
        return None
    return struct.unpack_from("<I", m, a)[0]


def en_ram(p):
    return p is not None and 0x00100000 <= p < 0x02000000


def cero(m, rango):
    a, b = rango
    if b > len(m):
        return None
    return all(v == 0 for v in m[a:b])


def leer(ruta, pers_off=SUBS_OFF):
    m = open(ruta, "rb").read()
    fila = {"volcado": os.path.basename(ruta), "subs": []}
    pers = u32(m, PERS_GLOBAL)
    fila["pers"] = pers
    fila["p940"] = u32(m, pers + 0x940) if en_ram(pers) else None
    fila["res_cod0"] = cero(m, RES_SUB3_COD)
    fila["res_dat0"] = cero(m, RES_SUB3_DAT)
    if not en_ram(pers):
        return fila
    for i in range(N_SUBS):
        s = pers + pers_off + i * SUB_PASO
        arena, plant = u32(m, s + 4), u32(m, s + 8)
        huesos = u32(m, s + 0x30)
        cuad = [u32(m, plant + o) for o in CUAD] if en_ram(plant) else [None] * 4
        # el invariante: la cuadrupla de la plantilla cae dentro de la arena del sub que la armo
        dentro = sum(1 for p in cuad if p is not None and arena is not None
                     and arena <= p < arena + ARENA_B)
        viva = (en_ram(plant) and u32(m, plant + VIVA_OFF) == plant + VIVA_REL)
        # la instancia que vive en la arena: su cabecera apunta adentro de la propia arena
        inst = 0
        if en_ram(arena) and arena + ARENA_B <= len(m):
            inst = sum(1 for off in (0x00, 0x20, 0x40, 0x60)
                       if arena <= (u32(m, arena + off) or 0) < arena + ARENA_B)
        fila["subs"].append({"i": i, "dir": s, "arena": arena, "plant": plant, "inst": inst,
                             "huesos": huesos, "cuad": cuad, "dentro": dentro, "viva": viva})
    plantillas = [d["plant"] for d in fila["subs"] if en_ram(d["plant"])]
    fila["comparten"] = len(plantillas) - len(set(plantillas))
    return fila


def main():
    rutas = sorted(glob.glob(os.path.join(RAIZ, "volcados", "ee-*.bin")))
    if "--autotest" in sys.argv:
        return autotest(rutas)
    print(f"pers = *(0x{PERS_GLOBAL:08X}); subs en pers+0x{SUBS_OFF:X}+i*0x{SUB_PASO:X}; "
          f"{len(rutas)} volcados")
    for r in rutas:
        f = leer(r)
        if not en_ram(f["pers"]):
            print(f"{f['volcado']:<26} pers fuera de RAM ({f['pers']})")
            continue
        cab = (f"{f['volcado']:<26} pers={f['pers']:#010x} p940={f['p940']:#010x} "
               f"comparten={f['comparten']} res(cod/dat en 0)={f['res_cod0']}/{f['res_dat0']}")
        print(cab)
        for d in f["subs"]:
            cu = "/".join("----" if p is None else f"{p:#x}" for p in d["cuad"])
            print(f"    sub{d['i']} @{d['dir']:#010x} arena={d['arena']:#010x} "
                  f"plant={d['plant']:#010x} viva={d['viva']} inst={d['inst']}/4 "
                  f"huesos={d['huesos']:#010x} cuad={cu} dentro={d['dentro']}/4")
    return 0


def autotest(rutas):
    """Control POSITIVO: en algun volcado de juego, un sub tiene su cuadrupla de plantilla apuntando
    ADENTRO de su arena (4 de 4). Es el invariante estructural sobre el que se apoya la regla del
    dueno de plantilla: si no se cumple en ningun volcado, la receta de docs/16 esta mal leida.
    Control NEGATIVO: el mismo lector con los subs corridos 0x10 (una direccion que no es un sub)
    no puede dar esa forma en ningun volcado.
    Tercer control: las dos reservas del sub3 en cero en TODOS los volcados (una reserva nueva se
    mide en cero antes de usarla).
    Cuarto control, el de (118) -- LA GUARDA: `*(p+0x1C) == p+0x4C` tiene que dar verde en el sub
    recien armado (sub0) en todos los volcados, y ROJO en el sub colgado (sub1) en todos. Si deja
    de discriminar, la regla del dueno de plantilla se queda sin su freno y hay que rehacerla."""
    buenos = [leer(r) for r in rutas]
    pos = sum(1 for f in buenos for d in f["subs"] if d["dentro"] == 4)
    vol_pos = sum(1 for f in buenos if any(d["dentro"] == 4 for d in f["subs"]))
    malos = sum(1 for r in rutas for d in leer(r, SUBS_OFF + 0x10)["subs"] if d["dentro"] == 4)
    res = [f["volcado"] for f in buenos if not (f["res_cod0"] and f["res_dat0"])]
    comp = max((f.get("comparten", 0) for f in buenos), default=0)
    # la guarda: sub0 = recien armado (positivo), sub1 con plantilla != 0 = colgado (negativo)
    g_pos = [d["viva"] for f in buenos for d in f["subs"] if d["i"] == 0 and en_ram(d["plant"])]
    g_neg = [d["viva"] for f in buenos for d in f["subs"] if d["i"] == 1 and en_ram(d["plant"])]
    print(f"positivo: {pos} sub(s) con cuadrupla 4/4 adentro de su arena, en {vol_pos}/{len(rutas)} volcados")
    print(f"negativo (subs corridos 0x10): {malos}")
    print(f"reservas del sub3 en cero: {len(rutas) - len(res)}/{len(rutas)}"
          + (f" -- NO en cero: {res}" if res else ""))
    print(f"subs que comparten plantilla hoy (maximo sobre los volcados): {comp}")
    print(f"GUARDA *(p+0x1C)==p+0x4C: viva en sub0 {sum(g_pos)}/{len(g_pos)} | "
          f"viva en sub1 colgado {sum(g_neg)}/{len(g_neg)} (tiene que ser 0)")
    guarda_ok = len(g_pos) > 0 and all(g_pos) and not any(g_neg)
    # el PASO entre subs es load-bearing y el control de arriba es ciego a el (sub0 va con i=0):
    # sub1 tiene que caer en OTRA arena valida, con su propia instancia adentro (los 714 B de (118))
    par = [f for f in buenos if len(f["subs"]) > 1]
    paso_ok = [f["volcado"] for f in par
               if not (en_ram(f["subs"][1]["arena"])
                       and f["subs"][1]["arena"] != f["subs"][0]["arena"]
                       and (f["subs"][1]["inst"] == 4 or f["subs"][1]["plant"] == 0))]
    print(f"paso entre subs: sub1 en otra arena con su instancia "
          f"{len(par) - len(paso_ok)}/{len(par)}" + (f" -- falla en {paso_ok}" if paso_ok else ""))
    ok = pos > 0 and malos == 0 and not res and guarda_ok and not paso_ok
    print("AUTOTEST", "OK" if ok else "FALLA")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
