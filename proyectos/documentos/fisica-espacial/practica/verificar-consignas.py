#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
verificar-consignas.py -- ninguna consigna partida entre dos paginas.

Regla propia 10 del proyecto (Fran, 2026-10-13): en un parcialito o modelo de
parcial, la consigna entera (titulo, enunciado, figura e incisos) va en UNA
pagina; nunca el enunciado arriba y la figura en la pagina siguiente.

    python verificar-consignas.py            # todos los .typ de OBLIGADOS
    python verificar-consignas.py --sabotaje # prueba que se pone en rojo

Mide dos cosas, las dos en ROJO (codigo 1):

  1. COBERTURA, en el fuente: en cada archivo de OBLIGADOS, todo #ejercicio(
     de la parte de enunciados esta adentro de un #consigna[ ... ]. Un
     ejercicio nuevo sin envolver es justo como se rompe la regla sin que
     nadie lo vea.
  2. EL EFECTO, en el documento compilado: `typst query` devuelve la pagina
     del principio y del final de cada consigna (las marcas <consigna-borde>
     de estilo.typ). Si difieren, la consigna quedo partida -- pasa si una
     consigna no entra en una pagina, y entonces hay que acortarla o partirla
     a mano en dos ejercicios.

El sabotaje copia la carpeta a un temporal, le saca el `breakable: false` a
consigna() en estilo.typ y exige ver el rojo del chequeo 2 (sobre el
parcialito 4 eso parte los ejercicios 1, 4 y 7, como estaba antes del
arreglo). El original no se toca.
"""

import io
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile

AQUI = os.path.dirname(os.path.abspath(__file__))

# Los que ya cumplen la regla. Todo modelo o parcialito NUEVO entra aca el dia
# que nace; los viejos, cuando se vuelvan a tocar.
OBLIGADOS = ('parcialito-4-momento-angular.typ', 'resueltos-cr-1-a-4.typ')


def cobertura(texto):
    enunciados = texto.split('\n= Resoluci')[0]
    fallas, dentro = [], False
    for n, linea in enumerate(enunciados.split('\n'), 1):
        if linea.startswith('#consigna['):
            dentro = True
        elif linea.strip() == ']':
            dentro = False
        elif linea.startswith('#ejercicio(') and not dentro:
            fallas.append('renglon %d: #ejercicio fuera de #consigna[...]' % n)
    return fallas


def paginas(dirx, archivo):
    p = subprocess.run(['typst', 'query', '--root', '..', archivo,
                        '<consigna-borde>', '--field', 'value'],
                       cwd=dirx, capture_output=True, text=True, encoding='utf-8')
    if p.returncode != 0:
        return None, p.stderr.strip()
    return json.loads(p.stdout), ''


def verificar(dirx):
    rojos, total = [], 0
    for archivo in OBLIGADOS:
        texto = io.open(os.path.join(dirx, archivo), encoding='utf-8').read()
        rojos += ['%s: %s' % (archivo, f) for f in cobertura(texto)]
        bordes, err = paginas(dirx, archivo)
        if bordes is None:
            rojos.append('%s: typst query fallo: %s' % (archivo, err))
            continue
        inis = [b['pagina'] for b in bordes if b['que'] == 'ini']
        fins = [b['pagina'] for b in bordes if b['que'] == 'fin']
        if not inis or len(inis) != len(fins):
            rojos.append('%s: %d principios y %d finales de consigna' % (archivo, len(inis), len(fins)))
            continue
        for k, (a, b) in enumerate(zip(inis, fins), 1):
            total += 1
            if a != b:
                rojos.append('%s: consigna %d PARTIDA entre las paginas %d y %d' % (archivo, k, a, b))
    return rojos, total


def main():
    if '--sabotaje' in sys.argv:
        tmp = tempfile.mkdtemp()
        try:
            raiz = os.path.dirname(AQUI)
            copia = os.path.join(tmp, os.path.basename(raiz))
            shutil.copytree(raiz, copia, ignore=shutil.ignore_patterns('salida', '*.pdf', '.git'))
            dirx = os.path.join(copia, 'practica')
            # los recortes de la guia SON pdf y los resueltos los incluyen: sin
            # ellos el control positivo revienta (medido el 2026-10-22)
            shutil.copytree(os.path.join(AQUI, 'recortes'), os.path.join(dirx, 'recortes'), dirs_exist_ok=True)
            limpio, _ = verificar(dirx)
            est = os.path.join(dirx, 'estilo.typ')
            t = io.open(est, encoding='utf-8').read()
            ancla = 'block(breakable: false, width: 100%)[#borde("ini")'
            assert t.count(ancla) == 1, 'el sabotaje no encontro su ancla en estilo.typ'
            io.open(est, 'w', encoding='utf-8').write(t.replace(ancla, ancla.replace('false', 'true')))
            roto, _ = verificar(dirx)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
        ok_limpio = not limpio
        ok_roto = any('PARTIDA' in r for r in roto)
        print('[%s] control positivo: la copia sin tocar da verde' % ('OK' if ok_limpio else 'FALLA'))
        for r in limpio:
            print('   ' + r)
        print('[%s] sabotaje (consigna partible): rojo por PARTIDA' % ('OK' if ok_roto else 'FALLA'))
        for r in roto:
            print('   ' + r)
        return 0 if (ok_limpio and ok_roto) else 1

    rojos, total = verificar(AQUI)
    if rojos:
        for r in rojos:
            print('[ROJO] ' + r)
        print('RESULTADO: %d problema(s).' % len(rojos))
        return 1
    print('RESULTADO: %d consignas en %d archivo(s), ninguna partida.' % (total, len(OBLIGADOS)))
    return 0


if __name__ == '__main__':
    sys.exit(main())
