#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
modelo.py -- LOS VERTICES. Decodifica la geometria de un modelo de Unit_NN.bin.

QUE CIERRA ESTO
    unit.py resolvio el CONTENEDOR y llego hasta el header del modelo, y ahi
    paro: "el grueso de un modelo vive entre su +0x58 y su +0x48, y ese bloque
    no esta desarmado". Esto lo desarma. Se llego igual que la vez anterior --
    por el CODIGO, siguiendo punteros del cargador -- y no adivinando bytes.

LA CADENA, DESDE EL HEADER DEL MODELO HASTA UN VERTICE
    modelo+0x48   array de count(+0x68, u8) registros de 0xD0: las SUBMALLAS.
       |          Cada registro reloca sus +0xC0, +0xC4 y +0xC8.
       v
    submalla+0xC0 -> FUN_0027e760 (0x0027E760). Reloca +0x20 y +0x24 con una
       |             cuenta u16 en +0x28, y llama FUN_0027f6d8 / FUN_0027f708
       |             sobre cada registro de 0x10 del array de +0x24.
       v
    FUN_0027f6d8 y FUN_0027f708 (0x0027F6D8 / 0x0027F708) son LA MISMA
    FUNCION, byte por byte: relocan +0x00 y +0x04 del registro contra el
    registro mismo. O sea que cada registro de 0x10 tiene DOS punteros, y ahi
    terminan las relocaciones: mas abajo ya son datos.
    (El selector es blk+0x2C, y vale 1 en las 5883 submallas del ISO. La rama
    de FUN_0027f6d8 no se ejercita nunca en estos datos.)

EL BLOQUE DE GEOMETRIA (blk = submalla+0xC0)
        +0x00  3 f32   caja envolvente MAXIMA (x, y, z)
        +0x10  3 f32   caja envolvente MINIMA
        +0x20  ptr     arbol BIH: count(+0x2A, u16) nodos de 0x18
        +0x24  ptr     hojas: count(+0x28, u16) registros de 0x10
        +0x28  u16     cuenta de hojas
        +0x2A  u16     cuenta de nodos = hojas - 1  (arbol binario lleno)
        +0x2C  i32     selector de relocador (1 en todo el ISO)
    Los +0x0C y +0x1C son constantes que no se tocan (0x1000C1C4 en la unidad
    medida); no se interpretan y no hacen falta.

EL NODO DEL ARBOL (0x18) -- dos mitades de 0xC, una por hijo
        mitad izquierda:  f32 max, f32 min, u8 hijo, u8 0, u8 eje, u8 tipo
        mitad derecha  :  f32 min, f32 max, u8 hijo, u8 0, u8 eje, u8 tipo
    tipo 0xFF = 'hijo' es indice de NODO; tipo 0x01 = indice de HOJA.
    eje: 0 = X, 2 = Z (nunca 1 en la unidad medida). Es un BIH: cada mitad
    guarda el intervalo EXACTO de su hijo sobre ese eje.
    Medido en CO01TRUCK/submalla 1: 108 nodos, 109 hojas, y los tipos dan
    exactamente 107 hijos-nodo (todos menos la raiz) y 109 hijos-hoja.

LA HOJA (0x10)
        +0x00  i32  offset a las CARAS,     relativo al registro
        +0x04  i32  offset a los VERTICES,  relativo al registro
        +0x08  u16  tamano total en bytes, desde las caras hasta el final
        +0x0A  u8   sesgo del eje X   (0x00 o 0xFF)
        +0x0B  u8   sesgo del eje Y
        +0x0C  u8   sesgo del eje Z
        +0x0D  u8   tamano del registro de cara -- 8 en las 57845 hojas del ISO
        +0x0E  u8   cuenta de caras
        +0x0F  u8   cuenta de vertices
    Cierra por construccion: vertices - caras == 8 * (+0x0E), y
    tamano - 8*(+0x0E) == 6 * (+0x0F) redondeado a 4. Eso ata cinco campos
    independientes, que es lo que hace que el layout no sea una coincidencia.

LA CARA (8 bytes)          4 x u8 indice de vertice + u32 id de superficie
LA VERTICE (6 bytes)       3 x u16, uno por eje, SESGADOS

EL SESGO, Y POR QUE NO ES UN s16 PELADO
    Cada eje de cada hoja trae su byte de sesgo en +0x0A/+0x0B/+0x0C, y vale
    0x00 o 0xFF (medido: no hay un tercer valor en las 57845 hojas del ISO).
    0xFF significa que ese eje esta guardado en binario desplazado: hay que
    restarle 0x8000 antes de leerlo como entero con signo.

        v = ((crudo - (0x8000 si el byte de sesgo != 0 else 0)) mod 0x10000)
        v = v - 0x10000 si v >= 0x8000

    Sin eso, los ejes negativos de una hoja se leen como +32700 y la malla
    explota. Con eso, las coordenadas de una hoja caen en el rango de dos o
    tres cientos que corresponde al tamano real de un prop.

LA ESCALA, MEDIDA Y NO SUPUESTA
    metros = (v + 0.5) * 1000/65536

    1000/65536 = 15.2588 mm es el quantum: un s16 cubre exactamente +-500 m,
    que es el tamano del mundo de BLACK (el 500.0 aparece literal en el
    registro de submalla, en +0x38). El +0.5 es el medio quantum del
    cuantizador: el exportador trunca, no redondea, y sin ese termino el error
    contra la caja del archivo queda sistematicamente en 0.99 quanta en vez de
    0.49. Salio de un ajuste por minimos cuadrados sobre las 66 cotas de las 11
    submallas de CO01TRUCK -- a = 0.0152563 (1/65.547) y b = +0.0079 -- y de
    ahi se leyeron las dos constantes limpias.

LA VERIFICACION, Y CUAL ES LA FUERTE
    1. CONTENCION: los 630379 vertices del ISO caen adentro de la caja que el
       propio archivo declara para su bloque. CERO desbordes, con tolerancia
       de un quantum. Esta es la fuerte: un decodificador mal escalado o mal
       sesgado desparrama vertices afuera en la primera submalla.
    2. CAJA: la caja calculada reproduce la del archivo con menos de un
       quantum de error en 5850 de las 5883 submallas.
    3. ESFERA: el registro de submalla trae en +0xB0 un centro y en +0xBC un
       radio que NO es el de la caja. La distancia maxima de los vertices
       decodificados a ese centro reproduce ese radio -- en CO01TRUCK, las 11
       submallas dentro de medio quantum. Es independiente de la caja y de
       min/max, asi que no se puede pasar por casualidad.

    LAS 33 QUE NO CIERRAN LA CAJA SON 13 MODELOS, Y 11 SON LUCES
    CO03RNDLIGHT, CO04STLIGHT, CO04STLIGHT2, CO06DWN_LIGH, CO06CRN_LIGH,
    CO06LP_FLOOD, CO06STRLIGHT, CO08STLIGHT... mas CO04BUNKER_A y
    CO08BUNKERII. Repetidos en varias unidades, por eso son 33 casos y no 13.
    En todos, la caja del archivo es MAS GRANDE que la geometria y los
    vertices siguen adentro: es una caja floja (probable: cubre la corona de
    la luz, no la malla), no un error de decodificacion. Se dice y no se tapa.

LO QUE SIGUE SIN RESOLVER, Y NO SE DISFRAZA
    - Donde se COLOCA cada submalla. Las submallas 2..7 de CO01TRUCK son
      identicas byte a byte (219 vertices, misma caja centrada en el origen,
      radio 0.58): son las seis ruedas, y su posicion NO esta en el registro
      de 0xD0. Falta el array de transformaciones.
    - El u32 de la cara (0x0000000A en todo lo mirado) es "probable id de
      superficie", no confirmado.
    - Si esto es la malla de colision o la de render. La caja floja de las
      luces y las caras de 4 indices con un id de superficie empujan para
      colision; que este colgado del header del modelo empuja para lo otro.
      No se afirma ninguna de las dos.
    - +0xC4 y +0xC8 del registro de submalla: relocados por el cargador,
      sin abrir. Solo 2 de las 11 submallas de CO01TRUCK tienen +0xC4.

USO
    python herramientas/modelo.py submallas D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN CO01TRUCK
    python herramientas/modelo.py vertices  D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN CO01TRUCK -s 1
    python herramientas/modelo.py verificar D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN CO01TRUCK
    python herramientas/modelo.py obj       D:\\LEVELS\\LEVEL_01\\UNIT_01.BIN CO01TRUCK truck.obj
    python herramientas/modelo.py autotest
"""
from __future__ import annotations

import argparse
import math
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import unit  # noqa: E402

QUANTUM = 1000.0 / 65536.0   # metros por unidad de cuantizacion
MEDIO = 0.5                  # el exportador trunca: hay medio quantum de sesgo
REG_SUBMALLA = 0xD0
REG_HOJA = 0x10
REG_NODO = 0x18
REG_CARA = 8
REG_VERTICE = 6
SESGO = True                 # aplicar el byte de sesgo por eje de cada hoja


def desq(v: int) -> float:
    """Un entero cuantizado -> metros."""
    return (v + MEDIO) * QUANTUM


class Modelo:
    """Un elemento de la lista tipo 1 de una unidad, ya localizado."""

    def __init__(self, u: "unit.Unidad", nombre: str):
        self.u = u
        self.d = u.d
        for _, nom, p in u.modelos():
            if nom.upper() == nombre.upper():
                self.dir = p
                self.nombre = nom
                break
        else:
            raise KeyError(nombre)
        self.n_submallas = self.d[self.dir + 0x68]

    # -- lectores ----------------------------------------------------------
    def i32(self, o): return struct.unpack_from("<i", self.d, o)[0]
    def u16(self, o): return struct.unpack_from("<H", self.d, o)[0]
    def f32(self, o): return struct.unpack_from("<f", self.d, o)[0]
    def v3(self, o): return tuple(self.f32(o + 4 * k) for k in range(3))

    def submalla(self, i: int) -> int:
        """Direccion del registro de 0xD0 de la submalla i."""
        b = self.i32(self.dir + 0x48)
        if not b:
            raise IndexError("el modelo no tiene array de submallas")
        return self.dir + b + i * REG_SUBMALLA

    def bloque(self, i: int) -> int:
        """Direccion del bloque de geometria de la submalla i, o 0."""
        c = self.i32(self.submalla(i) + 0xC0)
        return self.dir + c if c else 0

    def esfera(self, i: int):
        r = self.submalla(i)
        return self.v3(r + 0xB0), self.f32(r + 0xBC)

    def caja_registro(self, i: int):
        r = self.submalla(i)
        return self.v3(r + 0xA0), self.v3(r + 0x90)

    def caja_bloque(self, b: int):
        return self.v3(b + 0x10), self.v3(b)

    # -- la geometria ------------------------------------------------------
    def hojas(self, b: int):
        """[(caras, vertices, tam, sesgos, n_caras, n_vertices)] del bloque."""
        arr = b + self.i32(b + 0x24)
        for j in range(self.u16(b + 0x28)):
            r = arr + j * REG_HOJA
            yield (r + self.i32(r), r + self.i32(r + 4), self.u16(r + 8),
                   (self.d[r + 0xA], self.d[r + 0xB], self.d[r + 0xC]),
                   self.d[r + 0xD], self.d[r + 0xE], self.d[r + 0xF])

    def malla(self, i: int):
        """(vertices en metros, caras) de la submalla i. Las caras son
        (i0, i1, i2, i3, superficie) con indices ya globales al submalla."""
        b = self.bloque(i)
        V, C = [], []
        if not b:
            return V, C
        for pc, pv, _tam, ses, _sz, nc, nv in self.hojas(b):
            base = len(V)
            for k in range(nv):
                c = struct.unpack_from("<3H", self.d, pv + k * REG_VERTICE)
                V.append(tuple(desq(_signo(c[a] - (0x8000 if (ses[a] and SESGO)
                                                   else 0)))
                               for a in range(3)))
            for k in range(nc):
                o = pc + k * REG_CARA
                idx = self.d[o:o + 4]
                sup = struct.unpack_from("<I", self.d, o + 4)[0]
                C.append((base + idx[0], base + idx[1],
                          base + idx[2], base + idx[3], sup))
        return V, C


def _signo(v: int) -> int:
    v &= 0xFFFF
    return v - 0x10000 if v >= 0x8000 else v


# --------------------------------------------------------------------------
# comandos


def _abrir(a):
    return Modelo(unit.Unidad(a.ruta), a.nombre)


def cmd_submallas(a):
    m = _abrir(a)
    print("%s @0x%07X   %d submallas" % (m.nombre, m.dir, m.n_submallas))
    print("  #   bloque     hojas  caras  verts   caja del bloque"
          "                              radio")
    for i in range(m.n_submallas):
        b = m.bloque(i)
        if not b:
            print("  %-3d (sin bloque)" % i)
            continue
        V, C = m.malla(i)
        mn, mx = m.caja_bloque(b)
        _, r = m.esfera(i)
        print("  %-3d 0x%07X %5d %6d %6d   [%7.3f %7.3f %7.3f]..[%7.3f %7.3f %7.3f] %7.3f"
              % (i, b, m.u16(b + 0x28), len(C), len(V),
                 mn[0], mn[1], mn[2], mx[0], mx[1], mx[2], r))
    return 0


def cmd_vertices(a):
    m = _abrir(a)
    subs = [a.submalla] if a.submalla is not None else range(m.n_submallas)
    for i in subs:
        V, C = m.malla(i)
        print("--- submalla %d: %d vertices, %d caras" % (i, len(V), len(C)))
        for k, v in enumerate(V):
            if a.limite and k >= a.limite:
                print("    ... (%d mas)" % (len(V) - a.limite))
                break
            print("    v%-5d %9.4f %9.4f %9.4f" % (k, v[0], v[1], v[2]))
    return 0


def cmd_verificar(a):
    m = _abrir(a)
    print("%s @0x%07X" % (m.nombre, m.dir))
    print("  #   verts  |caja-archivo|   |radio-archivo|   fuera de la caja")
    ok = True
    tot = 0
    for i in range(m.n_submallas):
        b = m.bloque(i)
        if not b:
            continue
        V, _ = m.malla(i)
        if not V:
            continue
        tot += len(V)
        mn, mx = m.caja_bloque(b)
        ecaja = max(max(abs(min(v[k] for v in V) - mn[k]),
                        abs(max(v[k] for v in V) - mx[k])) for k in range(3))
        c, r = m.esfera(i)
        erad = abs(max(math.dist(v, c) for v in V) - r)
        fuera = sum(1 for v in V for k in range(3)
                    if v[k] < mn[k] - QUANTUM or v[k] > mx[k] + QUANTUM)
        print("  %-3d %6d   %8.5f (%4.2fq)  %8.5f (%4.2fq)   %d"
              % (i, len(V), ecaja, ecaja / QUANTUM, erad, erad / QUANTUM, fuera))
        ok &= fuera == 0
    print("\n  %d vertices. contencion: %s" % (tot, "OK" if ok else "ROJO"))
    return 0 if ok else 1


def cmd_obj(a):
    m = _abrir(a)
    V, C, base = [], [], 0
    for i in range(m.n_submallas):
        v, c = m.malla(i)
        V += v
        C += [(x[0] + base, x[1] + base, x[2] + base, x[3] + base) for x in c]
        base += len(v)
    with open(a.salida, "w", encoding="ascii") as f:
        f.write("# %s de %s -- black/herramientas/modelo.py\n"
                % (m.nombre, os.path.basename(a.ruta)))
        for v in V:
            f.write("v %.6f %.6f %.6f\n" % v)
        for c in C:
            f.write("f %d %d %d %d\n" % (c[0] + 1, c[1] + 1, c[2] + 1, c[3] + 1))
    print("  %s: %d vertices, %d caras" % (a.salida, len(V), len(C)))
    return 0


def cmd_autotest(a):
    """Positivo: CONTENCION de todos los vertices del ISO en la caja que el
    propio archivo declara. Negativo: el mismo recorrido con la escala y con
    el sesgo saboteados -- si eso tambien 'pasa', la prueba no discrimina y
    es exactamente el error de las dos vias muertas por los datos."""
    global QUANTUM, SESGO
    q0 = QUANTUM

    def barrer():
        """(vertices, fuera de caja, submallas, cajas flojas)."""
        nv = fuera = nsub = sueltas = 0
        for ruta in unit.unidades():
            u = unit.Unidad(ruta)
            for _, nom, p in u.modelos():
                try:
                    m = Modelo(u, nom)
                except KeyError:
                    continue
                if not m.i32(m.dir + 0x48):
                    continue
                for i in range(m.n_submallas):
                    b = m.bloque(i)
                    if not b:
                        continue
                    V, _ = m.malla(i)
                    if not V:
                        continue
                    nsub += 1
                    nv += len(V)
                    mn, mx = m.caja_bloque(b)
                    e = max(max(abs(min(v[k] for v in V) - mn[k]),
                                abs(max(v[k] for v in V) - mx[k]))
                            for k in range(3))
                    if e > q0:
                        sueltas += 1
                    fuera += sum(1 for v in V for k in range(3)
                                 if v[k] < mn[k] - q0 or v[k] > mx[k] + q0)
        return nv, fuera, nsub, sueltas

    # En try porque un layout saboteado revienta con struct.error, y un
    # autotest que muere con traceback en vez de decir ROJO no es una alarma:
    # es la misma falla que encontro el sabotaje 3 de probar-unit.py.
    try:
        nv, fuera, nsub, sueltas = barrer()
    except (struct.error, IndexError, OSError) as e:
        print("  positivo  : NO SE PUDO BARRER -> %s: %s" % (type(e).__name__, e))
        print("\n  AUTOTEST EN ROJO")
        return 1
    print("  positivo  : %d unidades, %d submallas, %d vertices"
          % (len(unit.unidades()), nsub, nv))
    print("  positivo  : vertices FUERA de la caja del archivo = %d  (tiene que ser 0)"
          % fuera)
    print("  positivo  : cajas que no cierran a 1 quantum = %d de %d (%.2f%%) -- son"
          " cajas flojas, no errores: los vertices siguen adentro"
          % (sueltas, nsub, 100.0 * sueltas / max(nsub, 1)))
    ok = fuera == 0 and nv > 500000 and sueltas < nsub * 0.02

    # NEGATIVOS. Cada uno rompe UNA pieza distinta del decodificador. El de la
    # escala rompe el quantum; el del sesgo rompe la unica parte que no se
    # deduce del tamano de los registros y es la que mas facil se escribe mal.
    # (Un tercero -- quitar el medio quantum -- se probo y NO discrimina: mueve
    # todo medio quantum y la tolerancia de contencion es de uno entero. Un
    # control que no puede fallar no se deja puesto para hacer bulto.)
    for nombre, q, ses in (("escala x2", q0 * 2, True),
                           ("sin el sesgo por eje", q0, False)):
        QUANTUM, SESGO = q, ses
        try:
            _, f2, _, _ = barrer()
        except (struct.error, IndexError, OSError):
            f2 = -1
        QUANTUM, SESGO = q0, True
        if f2 < 0:
            print("  negativo  : %-22s -> revento (cae, bien)" % nombre)
            continue
        print("  negativo  : %-22s -> %d vertices fuera %s"
              % (nombre, f2, "(cae, bien)" if f2 else "PASA (mal)"))
        ok &= f2 > 0

    print("\n  " + ("AUTOTEST OK" if ok else "AUTOTEST EN ROJO"))
    return 0 if ok else 1


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    sub = ap.add_subparsers(dest="cmd", required=True)
    for nombre, f in (("submallas", cmd_submallas), ("verificar", cmd_verificar)):
        p = sub.add_parser(nombre)
        p.add_argument("ruta"); p.add_argument("nombre"); p.set_defaults(f=f)
    p = sub.add_parser("vertices")
    p.add_argument("ruta"); p.add_argument("nombre")
    p.add_argument("-s", "--submalla", type=int, default=None)
    p.add_argument("-n", "--limite", type=int, default=20)
    p.set_defaults(f=cmd_vertices)
    p = sub.add_parser("obj")
    p.add_argument("ruta"); p.add_argument("nombre"); p.add_argument("salida")
    p.set_defaults(f=cmd_obj)
    sub.add_parser("autotest").set_defaults(f=cmd_autotest)
    a = ap.parse_args(argv)
    return a.f(a)


if __name__ == "__main__":
    sys.exit(main())
