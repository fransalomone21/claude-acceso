"""Respalda /mc/0/ de la PS2 (uLE ps2ftpd) a la PC, recursivo.
Una conexion nueva por operacion: ps2ftpd falla al reabrir el canal de datos."""
import ftplib, os, sys, time

HOST = '192.168.137.50'
SRC = '/mc/0/'
DST = sys.argv[1]

def con():
    f = ftplib.FTP(); f.connect(HOST, 21, timeout=30); f.login(); return f

def listar(path):
    for intento in range(3):
        try:
            f = con(); lines = []
            f.retrlines('LIST ' + path, lines.append); f.close()
            return lines
        except Exception as e:
            print('  reintento LIST', path, e); time.sleep(2)
    raise RuntimeError('no pude listar ' + path)

def bajar(remote, local, size):
    for intento in range(3):
        try:
            f = con()
            with open(local, 'wb') as out:
                f.retrbinary('RETR ' + remote, out.write)
            f.close()
            got = os.path.getsize(local)
            if got == size:
                return got
            print('  tamano distinto', remote, got, size)
        except Exception as e:
            print('  reintento RETR', remote, e)
        time.sleep(2)
    raise RuntimeError('no pude bajar ' + remote)

total = [0, 0]
fallas = []
def recorrer(rpath, lpath):
    os.makedirs(lpath, exist_ok=True)
    for line in listar(rpath):
        parts = line.split(None, 8)
        if len(parts) < 9: continue
        name = parts[8]
        if name in ('.', '..'): continue
        if line.startswith('d'):
            recorrer(rpath + name + '/', os.path.join(lpath, name))
        else:
            size = int(parts[4])
            try:
                bajar(rpath + name, os.path.join(lpath, name), size)
                total[0] += 1; total[1] += size
                print(f'{rpath}{name}  {size}')
            except Exception as e:
                fallas.append(rpath + name); print('FALLA', rpath + name, e)

t = time.time()
recorrer(SRC, DST)
print(f'\nARCHIVOS {total[0]}  BYTES {total[1]}  SEGUNDOS {time.time()-t:.0f}  FALLAS {len(fallas)}')
for x in fallas: print('FALLA', x)
