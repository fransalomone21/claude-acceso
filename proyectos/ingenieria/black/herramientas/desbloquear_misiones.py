"""Las 8 misiones desbloqueadas en las 4 dificultades del perfil de BLACK-XBERecomp (BLACK (135c)).

El perfil es hdd/E/UDATA/45410083/<id>/Profile (6144 B, datos hasta +0x778). Desde +0x120, 4 dificultades x 8
misiones de 0x20 B; en cada una +0x04 es el estado (FFFFFFFF sin jugar, 2 terminada, con tiempo y puntaje
despues) y +0x1E el byte de desbloqueada. Leido en el perfil de Fran el 2026-10-31: 1,1,1,0,0,0,0,0 en las tres
primeras dificultades y 0 en la cuarta (Black Ops), con las misiones 1 y 2 terminadas en la tercera. Grado:
probable (la forma cierra; el efecto en el menu lo mira Fran).

Con el juego CERRADO (al salir escribe el perfil que tiene en memoria). Deja un respaldo Profile.respaldo-135c.

    python herramientas/desbloquear_misiones.py [carpeta del juego]      (C:\\Games\\BLACK\\coop)
    python herramientas/desbloquear_misiones.py --restaurar [carpeta]
"""
import pathlib
import shutil
import sys

BASE, DIFICULTADES, MISIONES, PASO_D, PASO_M, DESBLOQUEADA = 0x120, 4, 8, 0x100, 0x20, 0x1E


def perfiles(juego):
    return sorted(pathlib.Path(juego, 'hdd', 'E', 'UDATA', '45410083').glob('*/Profile'))


def banderas(b):
    return [[b[BASE + d * PASO_D + m * PASO_M + DESBLOQUEADA] for m in range(MISIONES)] for d in range(DIFICULTADES)]


def main():
    args = [a for a in sys.argv[1:] if a != '--restaurar']
    juego = args[0] if args else r'C:\Games\BLACK\coop'
    lista = perfiles(juego)
    if not lista:
        print(f'no hay perfil en {juego}')
        return 1
    for p in lista:
        resp = p.with_name('Profile.respaldo-135c')
        if '--restaurar' in sys.argv:
            shutil.copyfile(resp, p)
            print(f'{p}: restaurado')
            continue
        b = bytearray(p.read_bytes())
        if len(b) != 6144 or int.from_bytes(b[4:8], 'little') != 0x778:
            print(f'{p}: no tiene la forma conocida; no lo toco')
            return 1
        if not resp.exists():
            shutil.copyfile(p, resp)
        antes = banderas(b)
        for d in range(DIFICULTADES):
            for m in range(MISIONES):
                b[BASE + d * PASO_D + m * PASO_M + DESBLOQUEADA] = 1
        p.write_bytes(b)
        print(f'{p}\n  antes   {antes}\n  despues {banderas(b)}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
