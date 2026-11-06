"""Sube archivos a la tarjeta de la PS2 por el FTP de uLaunchELF (ps2ftpd) y verifica el tamano.
Uso: python subir_mc.py local1=/mc/0/DIR/NOMBRE [local2=/mc/0/...] ...
Una conexion por archivo: ps2ftpd no reabre bien el canal de datos."""
import ftplib, os, sys, time

HOST = '192.168.137.50'


def con():
    f = ftplib.FTP(); f.connect(HOST, 21, timeout=30); f.login(); return f


def tam_remoto(path):
    d, n = path.rsplit('/', 1)
    f = con(); lines = []
    f.retrlines('LIST ' + d + '/', lines.append); f.close()
    for l in lines:
        p = l.split(None, 8)
        if len(p) == 9 and p[8] == n:
            return int(p[4])
    return None


fallas = 0
for par in sys.argv[1:]:
    local, remoto = par.split('=', 1)
    size = os.path.getsize(local)
    for intento in range(3):
        try:
            f = con()
            try: f.delete(remoto)
            except ftplib.error_perm: pass
            with open(local, 'rb') as src:
                f.storbinary('STOR ' + remoto, src)
            f.close()
            got = tam_remoto(remoto)
            print(f'{remoto}  local {size}  tarjeta {got}  {"OK" if got == size else "DISTINTO"}')
            if got == size:
                break
        except Exception as e:
            print('  reintento', remoto, e); time.sleep(2)
    else:
        fallas += 1
print('FALLAS', fallas)
