#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
verificar-anexos.py -- mide que el formulario (Anexo B) no quede a medias y
que las constantes (Anexo C) digan de donde salen.

Corre desde la carpeta del proyecto:

    python verificar-anexos.py

Un formulario incompleto es peor que ninguno: se usa sin desconfiar. Por eso
el Anexo B no se da por escrito, se da por MEDIDO. Cinco chequeos, y todos
fallan en rojo (codigo de salida 1):

  1. Las etiquetas de ecuacion se cuentan por DOS CAMINOS y tienen que
     coincidir: una regex sobre el fuente de modulos/*.typ y un
     `typst query` sobre el documento compilado. Existe porque el primer
     conteo -- `grep '\\$ <[a-z0-9-]*>'`, un renglon -- daba 124 y son 136:
     en m19 y m20 la etiqueta va en el renglon de ABAJO del `$`, y ocho
     llevan mayusculas (<grav-E>, <orb-Uef>). Cada camino
     tapa la ceguera del otro: la regex no sabe que es un comentario, el
     compilado no sabe en que archivo esta.

  2. Toda etiqueta de ecuacion de los modulos esta referenciada en
     anexos/a2-formulario.typ -- con `#ec(<clave>)`, `@clave` o
     `#link(<clave>)` -- o esta en EXCLUIDAS, abajo, con su motivo.

  3. Todo lo que el formulario referencia es una ECUACION de un modulo. Las
     etiquetas de seccion (`== Titulo <clave>`) y de figura tambien son
     `<clave>`: un `#link()` a una seccion compila en verde y deja una fila
     del formulario apuntando a un titulo.

  4. EXCLUIDAS no se pudre: cada entrada es una etiqueta de ecuacion que
     existe, tiene motivo, y no esta ademas referenciada (las dos cosas a la
     vez es una contradiccion, no una redundancia).

  5. Cada constante del Anexo C (`#cte(...)`) dice de que libro y de que
     pagina sale: la llamada tiene que contener "pág." o "págs.".

Probarlo en rojo: `python probar-verificar-anexos.py`. Un chequeo que nunca
fallo esta sin verificar.
"""

import io
import json
import os
import re
import subprocess
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
APUNTE_DIR = os.path.join(RAIZ, 'apunte')
MODULOS = os.path.join(APUNTE_DIR, 'modulos')
ANEXOS = os.path.join(APUNTE_DIR, 'anexos')
FORMULARIO = os.path.join(ANEXOS, 'a2-formulario.typ')
CONSTANTES = os.path.join(ANEXOS, 'a3-constantes.typ')

# Typst admite mayusculas, `_`, `.` y `:` en una etiqueta. El primer conteo
# (`[a-z0-9-]`) dejaba afuera <grav-E>, <orb-Uef> y otras seis: 124 contra
# 136, y lo encontro el chequeo 1 la primera vez que corrio.
ETIQ = r'[A-Za-z_][A-Za-z0-9_.:-]*'
# En `@clave.` el punto es de la oracion, no de la etiqueta.
ETIQ_REF = r'[A-Za-z_][A-Za-z0-9_-]*'

# Ecuaciones etiquetadas que NO van al formulario, con el motivo. Declarar
# una exclusion es un acto, no un silencio: lo que no esta ni aca ni en el
# formulario sale en rojo.
EXCLUIDAS = {
    'dosc-cm': 'paso intermedio: la condicion del CM en el origen, que '
               'sirve solo para llegar a <dosc-posiciones>',
    'orb-T': 'paso intermedio: la cinetica en polares, que <orb-E> ya '
             'contiene entera',
    'soi-ingenua': 'criterio INGENUO de la esfera de influencia (igualar '
                   'fuerzas), que el modulo presenta para refutarlo: en un '
                   'formulario se usaria sin desconfiar',
    'soi-suma': 'paso de la deduccion de r_SOI: la suma de posiciones',
    'soi-vista1': 'paso de la deduccion de r_SOI: la ecuacion vista desde '
                  'el Sol, antes de separar principal y perturbacion',
    'soi-razon1': 'paso de la deduccion de r_SOI: el primer cociente',
    'soi-vista2': 'paso de la deduccion de r_SOI: la ecuacion vista desde '
                  'el planeta',
    'soi-razon2': 'paso de la deduccion de r_SOI: el segundo cociente',
    'soi-soi-tierra': 'no es una formula sino <soi-soi> evaluada para la '
                      'Tierra: el numero va a la tabla del Anexo C',
    'perif-r': 'paso intermedio: la definicion x = r cos nu, contenida en '
               '<perif-r-orbita>',
    'perif-h-inicial': 'paso de la deduccion de f y g: h con las '
                       'condiciones iniciales',
    'perif-coefs-xy': 'paso de la deduccion de f y g: fpunto y gpunto en '
                      'coordenadas, antes de pasar a Delta nu',
    'tres-equilatero': 'paso intermedio: r1 = r2 = r12, que <tres-l45> ya '
                       'da resuelto',
    'iner-hg-integral': 'paso intermedio: la integral de la que sale '
                        '<iner-tensor>',
}


def leer(p):
    return io.open(p, encoding='utf-8').read()


def linea_de(texto, pos):
    return texto.count('\n', 0, pos) + 1


def etiquetas_fuente():
    """(ecuaciones, secciones) definidas en modulos/*.typ, por regex.

    Una etiqueta de ecuacion es `<clave>` pegada a un `$` que cierra, con
    blancos -- incluido un salto de renglon -- en el medio. Una de seccion
    es `<clave>` al final de un renglon que empieza con `=`.
    """
    ecs, secs = {}, {}
    for nombre in sorted(os.listdir(MODULOS)):
        if not nombre.endswith('.typ'):
            continue
        t = leer(os.path.join(MODULOS, nombre))
        for m in re.finditer(r'\$\s*<(%s)>' % ETIQ, t):
            ecs.setdefault(m.group(1), []).append('%s:%d' % (nombre, linea_de(t, m.start(1))))
        for m in re.finditer(r'(?m)^[ \t]*=+[^\n]*<(%s)>[ \t]*$' % ETIQ, t):
            secs[m.group(1)] = '%s:%d' % (nombre, linea_de(t, m.start(1)))
    return ecs, secs


def etiquetas_anexos():
    """Etiquetas DEFINIDAS en los anexos (no referencias): se descuentan del
    compilado, porque el criterio es sobre las ecuaciones de los modulos."""
    defs = set()
    if not os.path.isdir(ANEXOS):
        return defs
    for nombre in os.listdir(ANEXOS):
        if nombre.endswith('.typ'):
            t = leer(os.path.join(ANEXOS, nombre))
            defs.update(re.findall(r'\$\s*<(%s)>' % ETIQ, t))
    return defs


def etiquetas_compilado():
    """Etiquetas de toda `math.equation` del documento compilado."""
    p = subprocess.run(
        ['typst', 'query', os.path.join('apunte', 'apunte.typ'), 'math.equation',
         '--field', 'label', '--root', 'apunte'],
        cwd=RAIZ, capture_output=True, text=True, encoding='utf-8')
    if p.returncode != 0:
        return None, (p.stderr or p.stdout or '').strip()
    labs = [x for x in json.loads(p.stdout) if x]
    return set(l.strip('<>') for l in labs), None


def sin_comentarios(t):
    """Borra los comentarios de Typst sin mover ningun renglon: un
    `#ec(<clave>)` dentro de un comentario no referencia nada (lo encontro
    el chequeo 3 en la primera corrida, sobre la nota del propio helper)."""
    t = re.sub(r'/\*.*?\*/', lambda m: re.sub(r'[^\n]', ' ', m.group(0)), t,
               flags=re.S)
    return re.sub(r'(?m)(?<!:)//.*$', '', t)


def referencias_formulario(t):
    t = sin_comentarios(t)
    refs = {}
    for patron in (r'#ec\(\s*<(%s)>' % ETIQ,
                   r'#link\(\s*<(%s)>' % ETIQ,
                   r'(?<![\w.])@(%s)' % ETIQ_REF):
        for m in re.finditer(patron, t):
            refs.setdefault(m.group(1), linea_de(t, m.start(1)))
    return refs


def llamadas(t, nombre):
    """Texto de cada llamada `#nombre(...)`, con parentesis balanceados."""
    salida = []
    for m in re.finditer(r'#%s\(' % re.escape(nombre), t):
        i, prof = m.end(), 1
        while i < len(t) and prof:
            if t[i] == '(':
                prof += 1
            elif t[i] == ')':
                prof -= 1
            i += 1
        salida.append((linea_de(t, m.start()), t[m.end():i - 1]))
    return salida


def main():
    fallas = []

    ecs, secs = etiquetas_fuente()

    # --- 1. dos caminos -------------------------------------------------
    print('1. etiquetas de ecuacion: fuente vs. compilado')
    repetidas = {k: v for k, v in ecs.items() if len(v) > 1}
    for k, v in sorted(repetidas.items()):
        fallas.append('la etiqueta <%s> esta definida %d veces: %s'
                      % (k, len(v), ', '.join(v)))
    comp, err = etiquetas_compilado()
    if comp is None:
        fallas.append('typst query no corrio -- sin el compilado no hay '
                      'segundo camino: %s' % err[:300])
    else:
        comp -= etiquetas_anexos()
        solo_fuente = sorted(set(ecs) - comp)
        solo_comp = sorted(comp - set(ecs))
        for k in solo_fuente:
            fallas.append('<%s> (%s) parece ecuacion en el fuente y el compilado '
                          'no la tiene como ecuacion' % (k, ecs[k][0]))
        for k in solo_comp:
            fallas.append('<%s> es ecuacion en el compilado y la regex del fuente '
                          'no la ve -- el patron de etiquetas quedo corto' % k)
        print('   fuente %d, compilado %d, distintas %d'
              % (len(ecs), len(comp), len(solo_fuente) + len(solo_comp)))

    # --- 2. todas referenciadas o excluidas ------------------------------
    print('2. toda ecuacion etiquetada esta en el formulario o excluida')
    if os.path.exists(FORMULARIO):
        tf = leer(FORMULARIO)
    else:
        tf = ''
        fallas.append('no existe %s' % os.path.relpath(FORMULARIO, RAIZ))
    refs = referencias_formulario(tf)
    faltan = sorted(k for k in ecs if k not in refs and k not in EXCLUIDAS)
    for k in faltan:
        fallas.append('<%s> (%s) no esta en el formulario ni en EXCLUIDAS'
                      % (k, ecs[k][0]))
    print('   %d ecuaciones: %d referenciadas, %d excluidas, %d sin cubrir'
          % (len(ecs), sum(1 for k in ecs if k in refs),
             sum(1 for k in ecs if k in EXCLUIDAS), len(faltan)))

    # --- 3. lo referenciado es una ecuacion de un modulo -----------------
    print('3. el formulario solo apunta a ecuaciones')
    malas = 0
    for k, ln in sorted(refs.items()):
        if k in ecs:
            continue
        malas += 1
        if k in secs:
            fallas.append('a2-formulario.typ:%d apunta a <%s>, que es una SECCION '
                          '(%s), no una ecuacion' % (ln, k, secs[k]))
        else:
            fallas.append('a2-formulario.typ:%d apunta a <%s>, que no es ninguna '
                          'ecuacion de los modulos' % (ln, k))
    print('   %d referencias, %d que no son ecuacion' % (len(refs), malas))

    # --- 4. EXCLUIDAS sana ------------------------------------------------
    print('4. la lista de excluidas no se pudre')
    for k, motivo in sorted(EXCLUIDAS.items()):
        if k not in ecs:
            fallas.append('EXCLUIDAS tiene <%s>, que ya no es una ecuacion de '
                          'ningun modulo' % k)
        if len((motivo or '').strip()) < 15:
            fallas.append('EXCLUIDAS tiene <%s> sin motivo (o con uno de menos '
                          'de 15 caracteres)' % k)
        if k in refs:
            fallas.append('<%s> esta en EXCLUIDAS y tambien en el formulario '
                          '(linea %d): o una o la otra' % (k, refs[k]))
    print('   %d excluidas' % len(EXCLUIDAS))

    # --- 5. constantes con libro y pagina ---------------------------------
    print('5. cada constante del Anexo C dice libro y pagina')
    if os.path.exists(CONSTANTES):
        cs = llamadas(leer(CONSTANTES), 'cte')
        if not cs:
            fallas.append('a3-constantes.typ no tiene ninguna llamada #cte(...)')
        # "págs. 618 y 726" tambien es una pagina (el primer rojo de este
        # chequeo fue ese plural, no una constante sin fuente).
        sin = [ln for ln, cuerpo in cs if not re.search(r'págs?\.', cuerpo)]
        for ln in sin:
            fallas.append('a3-constantes.typ:%d: la constante no dice de que '
                          'pagina sale ("pág.")' % ln)
        print('   %d constantes, %d sin pagina' % (len(cs), len(sin)))
    else:
        fallas.append('no existe %s' % os.path.relpath(CONSTANTES, RAIZ))

    print('')
    if fallas:
        for f in fallas:
            print('[FALLA] ' + f)
        print('')
        print('ROJO: %d falla(s).' % len(fallas))
        return 1
    print('VERDE: el formulario cubre las %d ecuaciones etiquetadas y las '
          'constantes citan pagina.' % len(ecs))
    return 0


if __name__ == '__main__':
    sys.exit(main())
