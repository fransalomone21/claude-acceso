"""Recorta cada ejercicio de la guia de la catedra, tal como lo pego Anibal.

Lee `ejercicios.toml` (campo `recortes = [[pagina, y0, y1], ...]`, en puntos
PDF de la guia) y escribe un PDF de una pagina por recorte en `recortes/`,
copiando la region de la pagina original (vectorial: no se rasteriza nada).

La guia NO se commitea (no es nuestra, igual que los libros; ver
fuentes/RUTAS.md), y por eso tampoco los recortes: salen de este script.

    python recortar.py            # usa la guia mas nueva de Downloads
    python recortar.py --guia X   # otra ruta

Ademas MIDE cada recorte: si un borde corta un renglon de texto o una
imagen por la mitad, lo dice y sale con 1. Un recorte que se come media
linea compila igual y nadie lo nota hasta tenerlo impreso.
"""
import glob
import io
import os
import sys
import tomllib

import pymupdf

AQUI = os.path.dirname(os.path.abspath(__file__))
X0, X1 = 66, 572  # todo el ancho util de la guia, igual para todos los recortes


def guia_mas_nueva():
    base = os.path.join(os.path.expanduser('~'), 'Downloads')
    cands = glob.glob(os.path.join(base, 'PROBLEMAS F*SICA ESPACIAL*.pdf'))
    if not cands:
        sys.exit('[ROJO] no encuentro la guia en Downloads')
    return max(cands, key=os.path.getmtime)


def cortes(pagina, y0, y1):
    """Lo que el borde del recorte parte al medio: renglones e imagenes."""
    malos = []
    for bloque in pagina.get_text('dict')['blocks']:
        if bloque['type'] == 0:
            for linea in bloque['lines']:
                a, b = linea['bbox'][1], linea['bbox'][3]
                texto = ''.join(s['text'] for s in linea['spans']).strip()
                if not texto:
                    continue
                if (a < y0 < b - 1) or (a + 1 < y1 < b):
                    malos.append('renglon "%s" (%.0f-%.0f)' % (texto[:40], a, b))
    for img in pagina.get_image_info():
        a, b = img['bbox'][1], img['bbox'][3]
        if (a + 1 < y0 < b - 1) or (a + 1 < y1 < b - 1):
            malos.append('imagen (%.0f-%.0f)' % (a, b))
    return malos


def main():
    ruta = sys.argv[sys.argv.index('--guia') + 1] if '--guia' in sys.argv else guia_mas_nueva()
    datos = tomllib.load(io.open(os.path.join(AQUI, 'ejercicios.toml'), 'rb'))
    guia = pymupdf.open(ruta)
    salida = os.path.join(AQUI, 'recortes')
    if '--solo-medir' in sys.argv:   # lo usa el saboteador: mide sin escribir
        salida = None
    if salida:
        os.makedirs(salida, exist_ok=True)
    print('guia:', os.path.basename(ruta), guia.page_count, 'pag.')
    problemas = 0
    n = 0
    for ej in datos['ej']:
        for k, (pag, y0, y1) in enumerate(ej.get('recortes', []), 1):
            pagina = guia[pag - 1]
            for m in cortes(pagina, y0, y1):
                print('  [ROJO] %s recorte %d (pag %d): el borde corta %s' % (ej['id'], k, pag, m))
                problemas += 1
            if not salida:
                continue
            clip = pymupdf.Rect(X0, y0, X1, y1)
            nuevo = pymupdf.open()
            hoja = nuevo.new_page(width=clip.width, height=clip.height)
            hoja.show_pdf_page(hoja.rect, guia, pag - 1, clip=clip)
            nuevo.save(os.path.join(salida, '%s-%d.pdf' % (ej['id'], k)), garbage=4, deflate=True)
            n += 1
    print('%d recortes escritos en recortes/' % n)
    if problemas:
        print('RESULTADO: %d borde(s) mal puesto(s).' % problemas)
        sys.exit(1)
    print('RESULTADO: ningun borde corta texto ni imagen.')


if __name__ == '__main__':
    main()
