#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""armas_estado.py -- (122) el estado del MANEJADOR DE ARMAS, leido en los volcados, en frio.

    python herramientas/armas_estado.py            # tabla por volcado (J y, si esta, J2)
    python herramientas/armas_estado.py --autotest # control positivo y negativo

POR QUE EXISTE. (121) midio en vivo que, con la pieza 2b prendida, J2 dejo de cambiar de arma, y
anoto como sospechoso el gancho `0x001ACA2C` (dentro de `FUN_001AC960`, el camino del cambio).
Antes de creerle hay que descartar la explicacion trivial, que cuesta segundos (leccion 336 y «AL
LEER UN NEGATIVO»): el cambio de arma del juego **no puede ocurrir** si el arreglo de armas del
jugador no tiene una segunda entrada. Eso no depende de la pieza, y se mide en frio.

EL CAMINO DEL CAMBIO, leido (`FUN_0015bbd8` -> `FUN_00143d90` -> `FUN_001ac960`; el indice lo
escribe `FUN_0015be70`, que es el UNICO que lo escribe). El manejador esta embebido en `P+0x280`:

    mgr+0x1C (P+0x29C) el jugador dueno        mgr+0x40 (P+0x2C0) media palabra del guion
    mgr+0x20 (P+0x2A0) el ARREGLO de armas     mgr+0x42 (P+0x2C2) la CUENTA de armas
    mgr+0x24 (P+0x2A4) la de la MANO           mgr+0x43 (P+0x2C3) el INDICE
    mgr+0x28 (P+0x2A8) la pedida               mgr+0x45 (P+0x2C5) «hay un pedido en vuelo»
    mgr+0x38 (P+0x2B8) el pedido (0/1/2)       mgr+0x3C (P+0x2BC) el enfriamiento (float)

`FUN_0015bbd8` toma el indice contrario (`1 - mgr+0x43`), lee `arreglo[contrario]` y **SI ES NULO
VUELVE SIN HACER NADA**: no llama a `FUN_00143d90` ni a `FUN_0015be70`, asi que el indice se queda
igual. Un «el indice no cambio» con el arreglo a medio llenar es ese `return`, no la pieza.

EL INVARIANTE QUE HACE FALSABLE ESTO (kb/rutinas.json, FUN_00139c68): el directorio de tipos de
arma es `*(0x0040F4E0)`; su CANTIDAD es un byte en `+1` y su tabla esta en `+4` con paso 0x20. Cada
entrada del arreglo apunta a un objeto cuyo PRIMER BYTE es el indice de tipo, que
`FUN_0015bbd8` usa como `*entrada * 0x20 + tabla`.

Un BYTE en rango NO alcanza, y lo delato el control negativo en el PRIMER uso: con
`0 <= *(s8)entrada < 32` una direccion de RAM cualquiera pasaba por arma viva, y la palabra entera
tampoco alcanzo (67 de 200 direcciones pasaron: la RAM esta llena de ceros y el id 0 existe). El
discriminador que sirve mide la RELACION entre dos estructuras, no un campo suelto: volcando los
dos objetos vivos de `ee-e4.bin` aparecen DOS RETROPUNTEROS, y se cumplen en los dos jugadores

    *(obj+0xF0) == P          el jugador dueno
    *(obj+0xFC) == P + 0x280  su manejador

Medido: el arma de J da `+0xF0` = 0x005A8AB0 y `+0xFC` = 0x005A8D30; el arma de J2 en
`ee-parpadeo-quieto.bin` da 0x0046CDF0 y 0x0046D070. El control negativo es una POBLACION de 200
direcciones de RAM alineadas, no una direccion: un solo caso no mide nada.

ARMAS2 (`0x0046DBC0`): el arreglo propio de J2 que el mod le pone en `J2+0x2A0`. Este script mide
si sobrevive a la descarga (riesgo N26 de (121), `hipotesis` sin control) y, sobre todo, QUE MAS
queda del manejador de J2: el molde de `ENVOLTORIO_MOD` copia los 0x8C0 B de J y despues arregla
siete autopunteros, `+0xB0`, `+0x8A4` y `+0x2A0` -- pero NO `+0x2A4` (la mano), NI `+0x2C2` (la
cuenta), NI `+0x2C3` (el indice). Eso es lo que hay que mirar.

Sin numpy. Una linea por volcado y una por jugador.
"""
import glob
import os
import struct
import sys

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

J = 0x005A8AB0            # clon_jugador.J (sondas_coop.JUGADOR)
J2 = 0x0046CDF0           # clon_jugador.J2 (el del mod)
ARMAS2 = 0x0046DBC0       # jugador2.ARMAS2, 0x20 B
ARMAS2_TAM = 0x20
MGR = 0x280               # el manejador embebido en P+0x280
TIPOS_GLOBAL = 0x0040F4E0  # *(esto) = el directorio de tipos de arma
N_RANURAS = 8             # el arreglo que lee armas_j2.py

# los campos del manejador que el cambio de arma usa, en offsets del JUGADOR
OFF_DUENO, OFF_ARR, OFF_MANO, OFF_PEDIDA = MGR + 0x1C, MGR + 0x20, MGR + 0x24, MGR + 0x28
OFF_PEDIDO, OFF_ENFRIA = MGR + 0x38, MGR + 0x3C
OFF_CUENTA, OFF_INDICE, OFF_EN_VUELO = MGR + 0x42, MGR + 0x43, MGR + 0x45


def u32(m, a):
    if a is None or a < 0 or a + 4 > len(m):
        return None
    return struct.unpack_from("<I", m, a)[0]


def u8(m, a):
    if a is None or a < 0 or a + 1 > len(m):
        return None
    return m[a]


def s8(m, a):
    v = u8(m, a)
    return None if v is None else v - 256 if v > 127 else v


def en_ram(p):
    return p is not None and 0x00100000 <= p < 0x02000000


def tipos(m):
    """(cantidad, tabla) del directorio de tipos de arma, o (None, None)."""
    d = u32(m, TIPOS_GLOBAL)
    if not en_ram(d):
        return None, None
    return u8(m, d + 1), u32(m, d + 4)


OFF_DUENO_OBJ, OFF_MGR_OBJ = 0xF0, 0xFC   # los dos retropunteros del objeto de arma


def clasificar(m, p, cant, P):
    """'cero' | 'fuera' | 'viva' | 'colgada': una entrada del arreglo o la de la mano, de `P`."""
    if p in (0, None):
        return "cero"
    if not en_ram(p):
        return "fuera"
    if p % 0x10:
        return "colgada"
    idt = u32(m, p)
    if cant is None or idt is None or not (0 <= idt < cant):
        return "colgada"
    if u32(m, p + OFF_DUENO_OBJ) != P or u32(m, p + OFF_MGR_OBJ) != P + MGR:
        return "colgada"
    return "viva"


def leer_mgr(m, P, cant):
    arr = u32(m, P + OFF_ARR)
    ranuras = []
    if en_ram(arr):
        for i in range(N_RANURAS):
            p = u32(m, arr + 4 * i)
            ranuras.append((p, clasificar(m, p, cant, P)))
    return {
        "P": P, "dueno": u32(m, P + OFF_DUENO), "arr": arr, "ranuras": ranuras,
        "mano": u32(m, P + OFF_MANO), "mano_cl": clasificar(m, u32(m, P + OFF_MANO), cant, P),
        "pedida": u32(m, P + OFF_PEDIDA), "pedido": u32(m, P + OFF_PEDIDO),
        "enfria": u32(m, P + OFF_ENFRIA), "cuenta": s8(m, P + OFF_CUENTA),
        "indice": s8(m, P + OFF_INDICE), "en_vuelo": u8(m, P + OFF_EN_VUELO),
        "vivas": sum(1 for _, c in ranuras if c == "viva"),
        "colgadas": sum(1 for _, c in ranuras if c == "colgada"),
    }


def puede_cambiar(f):
    """El `return` de FUN_0015bbd8: con el arreglo o la entrada contraria en nulo, no cambia.
    Devuelve (bool, motivo). NO mide el enfriamiento ni el estado del cargador: eso es en vivo."""
    if not en_ram(f["arr"]):
        return False, "el arreglo (+0x2A0) no esta en RAM"
    if f["indice"] is None or not (0 <= f["indice"] < N_RANURAS):
        return False, "el indice (+0x2C3) = %s" % f["indice"]
    contrario = 1 - f["indice"]
    if not (0 <= contrario < len(f["ranuras"])):
        return False, "el contrario (1-%d) cae fuera del arreglo" % f["indice"]
    p, cl = f["ranuras"][contrario]
    if cl == "cero":
        return False, "arreglo[%d] = 0: FUN_0015bbd8 vuelve sin tocar el indice" % contrario
    if cl != "viva":
        return False, "arreglo[%d] = %#x, %s" % (contrario, p, cl)
    return True, "arreglo[%d] = %#x viva" % (contrario, p)


def leer(ruta):
    m = open(ruta, "rb").read()
    cant, tabla = tipos(m)
    fila = {"volcado": os.path.basename(ruta), "cant_tipos": cant, "tabla": tabla,
            "armas2_cero": all(v == 0 for v in m[ARMAS2:ARMAS2 + ARMAS2_TAM]),
            "armas2": [u32(m, ARMAS2 + 4 * i) for i in range(N_RANURAS)]}
    fila["J"] = leer_mgr(m, J, cant)
    # J2 solo existe con el mod puesto: su marca es que el autopuntero +0x29C apunte a J2
    j2 = leer_mgr(m, J2, cant)
    fila["J2"] = j2 if j2["dueno"] == J2 else None
    return fila


def _linea(nombre, f):
    ok, motivo = puede_cambiar(f)
    letra = {"cero": "-", "fuera": "F", "viva": "V", "colgada": "X"}
    rs = "".join(letra[c] for _, c in f["ranuras"])
    return ("    %-3s arr=%#010x cuenta=%-3s indice=%-3s mano=%#010x(%s) pedido=%s vuelo=%s "
            "vivas=%d colgadas=%d [%s]  (V viva, X colgada, - cero, F fuera de RAM)"
            "\n        cambia=%s -- %s"
            % (nombre, f["arr"] or 0, f["cuenta"], f["indice"], f["mano"] or 0, f["mano_cl"],
               f["pedido"], f["en_vuelo"], f["vivas"], f["colgadas"], rs, ok, motivo))


def main():
    rutas = sorted(glob.glob(os.path.join(RAIZ, "volcados", "ee-*.bin")))
    if "--autotest" in sys.argv:
        return autotest(rutas)
    print("manejador de armas en P+0x%X; tipos = *(%#010x); %d volcados" % (MGR, TIPOS_GLOBAL, len(rutas)))
    for r in rutas:
        f = leer(r)
        print("%-26s tipos=%s ARMAS2 en cero=%s" % (f["volcado"], f["cant_tipos"], f["armas2_cero"]))
        print(_linea("J", f["J"]))
        if f["J2"]:
            print(_linea("J2", f["J2"]))
    return 0


def autotest(rutas):
    """Dos mitades. CONTROL POSITIVO: en algun volcado de juego, J tiene al menos UNA entrada viva
    y el discriminador la llama viva (si no, el invariante o el offset estan mal y todo lo de abajo
    es ruido). CONTROL NEGATIVO, una POBLACION y no una direccion: 200 direcciones de RAM alineadas
    a 0x10, ninguna tiene que pasar por viva; mas un arreglo con la entrada contraria en cero, que
    tiene que hacer que `puede_cambiar` de False por el motivo correcto."""
    rojos, vivos, con_dos = [], 0, 0
    for r in rutas:
        f = leer(r)
        vivos += f["J"]["vivas"]
        ok, _ = puede_cambiar(f["J"])
        con_dos += 1 if ok else 0
    if vivos == 0:
        rojos.append("control positivo: NINGUN volcado tiene una entrada de arma viva -- el "
                     "invariante (los retropunteros +0xF0/+0xFC) o el offset %#x estan mal" % OFF_ARR)
    # negativo 1: una POBLACION de punteros a RAM que no son armas (un solo caso no mide nada)
    m = open(rutas[0], "rb").read()
    cant, _ = tipos(m)
    import random
    rnd = random.Random(1987)
    falsos = [rnd.randrange(0x00100000, 0x01F00000) & ~0xF for _ in range(200)]
    pasan = [p for p in falsos if clasificar(m, p, cant, J) == "viva"]
    if pasan:
        rojos.append("control negativo: %d de %d direcciones de RAM cualquiera pasaron por arma "
                     "viva (p. ej. %#x)" % (len(pasan), len(falsos), pasan[0]))
    # negativo 2: el arreglo con la entrada contraria en cero
    f = leer(rutas[0])
    g = dict(f["J"])
    g["indice"] = 0
    g["ranuras"] = [(0x01800000, "viva"), (0, "cero")] + g["ranuras"][2:]
    ok, motivo = puede_cambiar(g)
    if ok or "vuelve sin tocar el indice" not in motivo:
        rojos.append("control negativo: con arreglo[1] = 0, puede_cambiar dio (%s, %s)" % (ok, motivo))
    # negativo 3: el mismo arreglo con la contraria viva SI tiene que poder cambiar
    g2 = dict(g)
    g2["ranuras"] = [(0x01800000, "viva"), (0x01800100, "viva")] + g["ranuras"][2:]
    ok2, _ = puede_cambiar(g2)
    if not ok2:
        rojos.append("control positivo del par: con las dos entradas vivas, puede_cambiar dio False")
    for x in rojos:
        print("ROJO:", x)
    print("armas_estado autotest: %d entradas vivas en %d volcados, %d volcados con el par; "
          "%d problema(s)" % (vivos, len(rutas), con_dos, len(rojos)))
    return 1 if rojos else 0


if __name__ == "__main__":
    sys.exit(main())
