"""Borra de la tarjeta (FTP de uLE) SOLO las entradas de /mc/0/ que se pasan por nombre exacto.
Carpetas: borra sus archivos y despues la carpeta. Una conexion por operacion.
Uso: python borrar_mc.py NOMBRE [NOMBRE ...]   (siempre con el respaldo hecho antes)"""
import ftplib, sys

HOST = '192.168.137.50'
RAIZ = '/mc/0/'
NUNCA = {'BOOT', 'OPL', 'SYS-CONF', 'APPS', 'BADATA-SYSTEM', 'BAEXEC-SYSTEM', 'BCEXEC-SYSTEM',
         'BEEXEC-SYSTEM', 'BIEXEC-SYSTEM'}


def con():
    f = ftplib.FTP(); f.connect(HOST, 21, timeout=30); f.login(); return f


def listar(path):
    f = con(); L = []; f.retrlines('LIST ' + path, L.append); f.close()
    out = []
    for l in L:
        p = l.split(None, 8)
        if len(p) == 9 and p[8] not in ('.', '..'):
            out.append((l[0] == 'd', p[8]))
    return out


FMCB = {'APPS', 'BAEXEC-SYSTEM', 'BCEXEC-SYSTEM', 'BEEXEC-SYSTEM', 'BIEXEC-SYSTEM'}
if '--fmcb' in sys.argv:  # sacar el Free McBoot viejo (ROM 2.30 no lo arranca), sólo si se pide
    NUNCA -= FMCB
    sys.argv.remove('--fmcb')
raiz = dict((n, d) for d, n in listar(RAIZ))
fallas = 0
for nombre in sys.argv[1:]:
    if nombre in NUNCA or '/' in nombre:
        print('NO SE TOCA', nombre); fallas += 1; continue
    if nombre not in raiz:
        print('NO ESTA', nombre); continue
    try:
        if raiz[nombre]:
            for es_dir, n in listar(RAIZ + nombre + '/'):
                assert not es_dir, 'subcarpeta inesperada en ' + nombre
                f = con(); f.delete(RAIZ + nombre + '/' + n); f.close()
            f = con(); f.rmd(RAIZ + nombre); f.close()
        else:
            f = con(); f.delete(RAIZ + nombre); f.close()
        print('BORRADO', nombre)
    except Exception as e:
        print('FALLA', nombre, e); fallas += 1
quedan = sorted(n for _, n in listar(RAIZ))
print('QUEDAN', quedan)
print('FALLAS', fallas)
