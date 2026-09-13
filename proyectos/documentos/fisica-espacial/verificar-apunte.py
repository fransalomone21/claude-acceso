#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
verificar-apunte.py -- mide que el orden del apunte siga diciendo la verdad.

Corre desde la carpeta del proyecto:

    python verificar-apunte.py

Mide TRES cosas, y las tres fallan en rojo (codigo de salida 1):

  1. El numero del ARCHIVO coincide con su posicion en apunte.typ.
     Es la unica de las tres que ningun compilador puede ver: mover un
     `#include` renumera el apunte y deja el nombre del archivo mintiendo,
     sin que nada se queje.

  2. Toda clave usada en `#M("...")` esta declarada por algun modulo.
     Typst tambien lo caza (M() hace panic), pero aca el mensaje dice en
     que ARCHIVO y en que LINEA esta la clave mala, que es lo que hace
     falta para arreglarla.

  3. Ningun modulo USA uno posterior. Esta no se puede automatizar entera
     --anticipar un modulo posterior es legitimo y deseable-- asi que el
     script IMPRIME el grafo y marca las referencias hacia adelante; la
     lectura es humana. Lo que si falla solo es una clave repetida.

Probarlo en rojo: `python probar-verificar-apunte.py`. Un chequeo que nunca
fallo esta sin verificar.
"""

import io
import os
import re
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
APUNTE = os.path.join(RAIZ, 'apunte', 'apunte.typ')
MODULOS = os.path.join(RAIZ, 'apunte', 'modulos')


def leer(p):
    return io.open(p, encoding='utf-8').read()


def main():
    fallas = []

    orden = re.findall(r'#include "modulos/(m\d+-[a-z-]+)\.typ"', leer(APUNTE))
    if not orden:
        print('[FALLA] apunte.typ no tiene ningun #include de modulo')
        return 1

    modulos = []          # (posicion, archivo, clave, texto)
    claves = {}
    for i, base in enumerate(orden, 1):
        ruta = os.path.join(MODULOS, base + '.typ')
        if not os.path.exists(ruta):
            fallas.append('apunte.typ incluye %s.typ y ese archivo no existe' % base)
            continue
        t = leer(ruta)
        m = re.search(r'clave: "([a-z-]+)"', t)
        if not m:
            fallas.append('%s.typ no declara `clave:` en su #modulo(...)' % base)
            continue
        c = m.group(1)
        if c in claves:
            fallas.append('la clave "%s" esta declarada dos veces: %s y %s'
                          % (c, claves[c][1], base))
        claves[c] = (i, base)
        modulos.append((i, base, c, t))

    # --- 1. el numero del archivo dice la verdad -------------------------
    print('1. el numero del archivo coincide con el orden de apunte.typ')
    for i, base, c, _ in modulos:
        n = int(re.match(r'm(\d+)-', base).group(1))
        if n != i:
            fallas.append('%s.typ esta en la posicion %d: el archivo deberia '
                          'llamarse m%02d-%s.typ' % (base, i, i, c))
    print('   %d modulos, %d con el numero mal' % (len(modulos),
          sum(1 for i, b, c, _ in modulos if int(re.match(r'm(\d+)-', b).group(1)) != i)))

    # --- 2. toda clave referida existe -----------------------------------
    print('2. toda clave usada en #M("...") esta declarada')
    malas = 0
    for i, base, c, t in modulos:
        for ln, linea in enumerate(t.split('\n'), 1):
            for ref in re.findall(r'#M\("([a-z-]+)"\)', linea):
                if ref not in claves:
                    fallas.append('%s.typ:%d usa la clave "%s", que no existe'
                                  % (base, ln, ref))
                    malas += 1
    print('   %d referencias malas' % malas)

    # --- 3. el grafo, para leerlo ----------------------------------------
    print('3. el grafo de referencias (la columna "usa" tiene que ir hacia atras)')
    print('   %-3s %-24s %-26s %s' % ('#', 'modulo', 'usa (atras)', 'anticipa (adelante)'))
    for i, base, c, t in modulos:
        refs = sorted(set(claves[x][0] for x in re.findall(r'#M\("([a-z-]+)"\)', t)
                          if x in claves and x != c))
        atras = [r for r in refs if r < i]
        adel = [r for r in refs if r > i]
        print('   %-3d %-24s %-26s %s' % (i, c, atras, adel))

    print('')
    if fallas:
        for f in fallas:
            print('[FALLA] ' + f)
        print('\n%d falla(s).' % len(fallas))
        return 1
    print('Apunte OK: el orden, los nombres y las claves dicen lo mismo.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
