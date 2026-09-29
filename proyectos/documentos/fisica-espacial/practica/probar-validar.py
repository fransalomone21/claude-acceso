"""Saboteador de validar.py y de la medicion de bordes de recortar.py.

Copia practica/ a una carpeta temporal, rompe UNA cosa por vez en la copia
y exige que el chequeo correspondiente salga en rojo POR ESE MOTIVO (el
texto del rojo tiene que nombrar lo roto). Antes, el control positivo: la
copia sin tocar tiene que dar verde -- si no, los rojos no prueban nada.

    python probar-validar.py
"""
import io
import os
import shutil
import subprocess
import sys
import tempfile

AQUI = os.path.dirname(os.path.abspath(__file__))


def correr(dirx, script, *args):
    env = dict(os.environ, PYTHONIOENCODING='utf-8')
    p = subprocess.run([sys.executable, os.path.join(dirx, script), *args],
                       capture_output=True, text=True, encoding='utf-8', env=env)
    return p.returncode, p.stdout + p.stderr


def reemplazar(ruta, viejo, nuevo):
    # TODAS las apariciones: validar.py mide que cada numero correcto este
    # AL MENOS una vez. Un numero que se repite (en un paso y en el
    # resultado final) y se rompe en una sola copia NO lo ve -- es su limite
    # conocido, no algo que este sabotaje deba simular (2026-09-29).
    t = io.open(ruta, encoding='utf-8').read()
    assert viejo in t, 'el sabotaje no encontro "%s" en %s' % (viejo, ruta)
    io.open(ruta, 'w', encoding='utf-8', newline='\n').write(t.replace(viejo, nuevo))


SABOTAJES = [
    # (nombre, archivo, viejo, nuevo, script, lo que el rojo tiene que decir)
    ('numero mal en la guia', 'ejercicios.toml', '*(a)* $90,6$ GJ', '*(a)* $90,9$ GJ',
     'validar.py', 'g-6'),
    ('numero que desaparece', 'ejercicios.toml', '$abs(bold(A)) = 8,06$', '$abs(bold(A)) = 8,1$',
     'validar.py', 'vec-1: "8,06" no esta'),
    ('tip de dos oraciones', 'ejercicios.toml',
     "tip = '''El ángulo entre dos direcciones sale del producto escalar",
     "tip = '''Es fácil. El ángulo entre dos direcciones sale del producto escalar",
     'validar.py', 'vec-5: el tip tiene mas de una oracion'),
    ('ejercicio sin tip', 'ejercicios.toml',
     "tip = '''Con los vectores del Ej. 1, el producto escalar por componentes da $A B cos phi$, y de ahí se despeja el ángulo.'''",
     "tip = ''''''", 'validar.py', 'vec-2: falta "tip"'),
    ('impulso angular por L', 'ejercicios.toml',
     'Derivá $bold(L) = bold(r) times bold(p)$', 'Derivá el impulso angular $bold(L)$',
     'validar.py', 'terminologia'),
    ('numero mal en el parcialito', 'parcialito-momento-angular.typ', '$v_a = h\\/r_a = 6,576$',
     '$v_a = h\\/r_a = 6,590$', 'validar.py', 'parcialito-momento-angular.typ: "6,576" no esta'),
    ('numero mal en el modelo', 'modelo-parcial-integrador.typ', '171,0', '171,3',
     'validar.py', '"171,0" no esta'),
    ('numero mal en el modelo 2 (la integral por partes)', 'modelo-parcial-2.typ', '135 thin 208', '135 thin 280',
     'validar.py', '"135 thin 208" no esta'),
    ('numero mal en el modelo 3 (el descenso)', 'modelo-parcial-3.typ', '1416,5', '1461,5',
     'validar.py', '"1416,5" no esta'),
    ('impulso angular por L en el modelo 1', 'modelo-parcial-1.typ',
     'El módulo de $bold(r) times bold(p)$ es $p$ por el *brazo*',
     'El impulso angular $bold(r) times bold(p)$ vale $p$ por el *brazo*', 'validar.py', 'terminologia'),
    ('recorte que parte un renglon', 'ejercicios.toml', 'recortes = [[3, 381, 399]]',
     'recortes = [[3, 381, 390]]', 'recortar.py', 'vec-11 recorte 1'),
]


def main():
    tmp = tempfile.mkdtemp(prefix='sabot-practica-')
    base = os.path.join(tmp, 'limpio')
    shutil.copytree(AQUI, base, ignore=shutil.ignore_patterns('salida', '__pycache__'))
    fallas = 0
    # control positivo
    for script, args in (('validar.py', ()), ('recortar.py', ('--solo-medir',))):
        rc, out = correr(base, script, *args)
        if rc != 0:
            print('[ROJO] control positivo: %s da rojo sin sabotaje:\n%s' % (script, out))
            sys.exit(1)
    print('control positivo: validar.py y recortar.py en verde sobre la copia limpia')
    for i, (nombre, archivo, viejo, nuevo, script, motivo) in enumerate(SABOTAJES, 1):
        d = os.path.join(tmp, 's%d' % i)
        shutil.copytree(base, d)
        reemplazar(os.path.join(d, archivo), viejo, nuevo)
        rc, out = correr(d, script, *(('--solo-medir',) if script == 'recortar.py' else ()))
        ok = rc != 0 and motivo in out
        print('  [%s] %d. %s' % ('rojo, bien' if ok else 'NO SE VIO', i, nombre))
        if not ok:
            fallas += 1
            print('       rc=%d; se esperaba "%s" en:\n%s' % (rc, motivo, out[-600:]))
    shutil.rmtree(tmp, ignore_errors=True)
    if fallas:
        print('RESULTADO: %d sabotaje(s) que el chequeo NO vio.' % fallas)
        sys.exit(1)
    print('RESULTADO: %d de %d sabotajes en rojo por el motivo correcto.' % (len(SABOTAJES), len(SABOTAJES)))


if __name__ == '__main__':
    main()
