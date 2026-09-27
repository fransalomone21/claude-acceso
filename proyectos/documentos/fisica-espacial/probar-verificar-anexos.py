#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
probar-verificar-anexos.py -- rompe cada chequeo de verificar-anexos.py a
proposito y exige verlo en ROJO, y por el motivo correcto. Un chequeo que
nunca fallo esta sin verificar.

    python probar-verificar-anexos.py

Mismo molde que probar-verificar-apunte.py: cada sabotaje se hace sobre el
archivo real, con una copia al costado que se restaura pase lo que pase
(try/finally), y el control positivo corre al principio y al final. El del
final es el que prueba que ningun sabotaje dejo suciedad.

El sabotaje 1b es el que importa mas: una ecuacion etiquetada SIN un `$`
pegado a la etiqueta (`#math.equation(...) <x>`) es exactamente lo que la
regex del fuente no puede ver, y la unica que la ve es el segundo camino,
el compilado. Si ese sabotaje da verde, el chequeo 1 es decorativo.
"""

import io
import os
import shutil
import subprocess
import sys
import tempfile

RAIZ = os.path.dirname(os.path.abspath(__file__))
VERIF = os.path.join(RAIZ, 'verificar-anexos.py')
MODULOS = os.path.join(RAIZ, 'apunte', 'modulos')
ANEXOS = os.path.join(RAIZ, 'apunte', 'anexos')
M14 = os.path.join(MODULOS, 'm14-esfera-influencia.typ')
M21 = os.path.join(MODULOS, 'm21-peonza.typ')
FORM = os.path.join(ANEXOS, 'a2-formulario.typ')
CONST = os.path.join(ANEXOS, 'a3-constantes.typ')


def correr():
    env = dict(os.environ, PYTHONIOENCODING='utf-8')
    p = subprocess.run([sys.executable, VERIF], cwd=RAIZ, env=env,
                       capture_output=True, text=True, encoding='utf-8')
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
    """Aplica `transformar` al texto de `ruta`, exige rojo con `espera` en la
    salida, y restaura el archivo byte por byte."""
    orig = io.open(ruta, encoding='utf-8', newline='').read()
    fd, tmp = tempfile.mkstemp()
    os.close(fd)   # Windows: mkstemp deja el descriptor abierto y os.remove falla
    shutil.copy2(ruta, tmp)
    try:
        io.open(ruta, 'w', encoding='utf-8', newline='').write(transformar(orig))
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


def reemplazar(a, b):
    def f(t):
        assert t.count(a) == 1, 'el ancla del sabotaje no esta, o esta repetida: %r' % a[:60]
        return t.replace(a, b)
    return f


def agregar(texto):
    return lambda t: t + texto


def main():
    ok = [control_positivo('antes')]

    # 1a. una "ecuacion" que solo existe para la regex: comentada, el
    #     compilado no la tiene.
    ok.append(sabotear('1a. ecuacion comentada (solo la ve la regex)', M21,
                       agregar('\n// $ x = 1 $ <sabotaje-comentada>\n'),
                       'el compilado no la tiene'))

    # 1b. una ecuacion que solo existe para el compilado: etiquetada sin un
    #     `$` pegado. Es el punto ciego de la regex, el que dio 124 contra 136.
    ok.append(sabotear('1b. ecuacion sin $ pegado (solo la ve el compilado)', M21,
                       agregar('\n#math.equation(block: true, $ x = 1 $) <sabotaje-sin-dolar>\n'),
                       'la regex del fuente no la ve'))

    # 1c. el compilado no corre: el formulario pide una etiqueta que no
    #     existe. Prueba dos cosas -- que `#ec()` rompe la compilacion en vez
    #     de imprimir un hueco, y que sin compilado el chequeo falla CERRADO.
    ok.append(sabotear('1c. sin compilado no hay verde', FORM,
                       agregar('\n#ec(<no-existe-esta-ecuacion>)[sabotaje]\n'),
                       'typst query no corrio'))

    # 2. una ecuacion del formulario desaparece.
    ok.append(sabotear('2. ecuacion sin referenciar', FORM,
                       reemplazar('#ec(<grav-vcirc>)', '// #ec(<grav-vcirc>)'),
                       '<grav-vcirc>'))

    # 3. el formulario apunta a una seccion: compila en verde en Typst.
    ok.append(sabotear('3. referencia a una seccion', FORM,
                       agregar('\n#link(<vec-polares>)[sabotaje]\n'),
                       'que es una SECCION'))

    # 4a. una excluida pasa a estar tambien en el formulario.
    ok.append(sabotear('4a. excluida y referenciada a la vez', FORM,
                       agregar('\n#ec(<soi-suma>)[sabotaje]\n'),
                       'o una o la otra'))

    # 4b. una excluida deja de existir en su modulo (se renombro la etiqueta).
    ok.append(sabotear('4b. excluida que ya no existe', M14,
                       reemplazar('$ <soi-suma>', '$ <soi-suma-renombrada>'),
                       'ya no es una ecuacion'))

    # 4c. una excluida sin motivo.
    ok.append(sabotear('4c. excluida sin motivo', VERIF,
                       reemplazar("'orb-T': 'paso intermedio: la cinetica en polares, que <orb-E> ya '\n"
                                  "             'contiene entera',",
                                  "'orb-T': '',"),
                       'sin motivo'))

    # 5. una constante pierde la pagina.
    ok.append(sabotear('5. constante sin pagina', CONST,
                       reemplazar('[Curtis pág. 14]', '[Curtis]'),
                       'no dice de que pagina sale'))

    ok.append(control_positivo('despues'))

    print('')
    if all(ok):
        print('Los cinco chequeos se pusieron en rojo cuando correspondia (nueve '
              'sabotajes), y el verificador quedo limpio.')
        return 0
    print('Algo no se puso en rojo. El verificador esta ciego en esa mitad.')
    return 1


if __name__ == '__main__':
    sys.exit(main())
