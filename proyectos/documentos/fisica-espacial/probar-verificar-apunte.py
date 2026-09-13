#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
probar-verificar-apunte.py -- rompe cada chequeo de verificar-apunte.py a
proposito y exige verlo en ROJO. Un chequeo que nunca fallo esta sin
verificar.

    python probar-verificar-apunte.py

Cada sabotaje se hace sobre una COPIA temporal del archivo, y el original se
restaura pase lo que pase (try/finally). El control positivo --que en verde
el verificador da verde-- se corre al principio y al final: la segunda vez es
la que prueba que el sabotaje no dejo suciedad, que es la falla que ya se
pago una vez en este repo con probar-chequeo-lecciones.ps1.
"""

import io
import os
import re
import shutil
import subprocess
import sys
import tempfile

RAIZ = os.path.dirname(os.path.abspath(__file__))
VERIF = os.path.join(RAIZ, 'verificar-apunte.py')
APUNTE = os.path.join(RAIZ, 'apunte', 'apunte.typ')
MODULOS = os.path.join(RAIZ, 'apunte', 'modulos')


def correr():
    env = dict(os.environ, PYTHONIOENCODING='utf-8')
    p = subprocess.run([sys.executable, VERIF], cwd=RAIZ, env=env,
                       capture_output=True, text=True)
    return p.returncode, (p.stdout or '') + (p.stderr or '')


def control_positivo(cuando):
    rc, out = correr()
    if rc == 0:
        print('[OK]    control positivo (%s): en verde da verde' % cuando)
        return True
    print('[FALLA] control positivo (%s): deberia dar 0 y dio %d' % (cuando, rc))
    print(out)
    return False


def sabotear(titulo, ruta, transformar, espera):
    """Aplica `transformar` al texto de `ruta`, exige rojo, y restaura."""
    orig = io.open(ruta, encoding='utf-8').read()
    fd, tmp = tempfile.mkstemp()
    os.close(fd)   # Windows: mkstemp deja el descriptor abierto y os.remove falla
    shutil.copy2(ruta, tmp)
    try:
        io.open(ruta, 'w', encoding='utf-8').write(transformar(orig))
        rc, out = correr()
        if rc == 0:
            print('[FALLA] %s: el verificador NO se puso en rojo' % titulo)
            return False
        if espera not in out:
            print('[FALLA] %s: se puso en rojo pero por otra cosa' % titulo)
            print(out)
            return False
        print('[OK]    %s: rojo, y por el motivo correcto' % titulo)
        return True
    finally:
        shutil.copy2(tmp, ruta)
        os.remove(tmp)


def main():
    ok = [control_positivo('antes')]

    # 1. el numero del archivo deja de coincidir con el orden: se dan vuelta
    #    dos #include y ningun compilador puede ver el problema.
    def dar_vuelta(t):
        a = '#include "modulos/m18-inercia.typ"\n#include "modulos/m19-euler-giroscopo.typ"'
        b = '#include "modulos/m19-euler-giroscopo.typ"\n#include "modulos/m18-inercia.typ"'
        assert t.count(a) == 1, 'el sabotaje 1 no encontro su ancla'
        return t.replace(a, b)

    ok.append(sabotear('1. numero de archivo vs. orden', APUNTE, dar_vuelta,
                       'deberia llamarse'))

    # 2. una clave que no existe
    m01 = os.path.join(MODULOS, 'm01-vectores.typ')

    def clave_mala(t):
        m = re.search(r'#M\("([a-z-]+)"\)', t)
        assert m, 'el sabotaje 2 no encontro ningun #M()'
        return t[:m.start()] + '#M("no-existe-este-modulo")' + t[m.end():]

    ok.append(sabotear('2. clave inexistente en #M()', m01, clave_mala,
                       'no existe'))

    # 3. dos modulos con la misma clave
    m03 = os.path.join(MODULOS, 'm03-cantidad-movimiento.typ')

    def clave_repetida(t):
        return t.replace('clave: "cantidad-movimiento"', 'clave: "vectores"', 1)

    ok.append(sabotear('3. clave declarada dos veces', m03, clave_repetida,
                       'esta declarada dos veces'))

    ok.append(control_positivo('despues'))

    print('')
    if all(ok):
        print('Los tres chequeos se pusieron en rojo cuando correspondia, y el '
              'verificador quedo limpio.')
        return 0
    print('Algo no se puso en rojo. El verificador esta ciego en esa mitad.')
    return 1


if __name__ == '__main__':
    sys.exit(main())
