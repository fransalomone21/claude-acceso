"""verificar-figuras.py -- mide en el PDF que los rótulos de las figuras se lean.

Pedido de Fran (2026-10-29): «siempre estás ajustando, tendrías que haber
desarrollado una herramienta que resuelva siempre». Mirar cada figura a ojo y
mover rótulos de a uno es la pinza pico de loro; esto es la llave: compila
una galería (una figura por página), saca del PDF cada rótulo con su caja y
cada trazo dibujado, y da ROJO si

  1. dos rótulos distintos se pisan (las cajas se superponen más que un
     borde), o
  2. un trazo (línea, arco, flecha, contorno) pasa por adentro de un rótulo.

Un rótulo es una línea de texto del PDF (sus spans juntos: un acento o un
subíndice no cuentan como «otro rótulo»). Para el cruce, la caja se achica un
18 % por lado: una flecha que termina pegada al nombre no cuenta; lo que se
busca es la línea que pasa POR ENCIMA de las letras.

Lo que mide, de dónde y qué no ve:
  - entra: el .typ de una galería; el PDF lo compila typst a un temporal;
  - LLEGÓ: imprime cuántos rótulos y trazos leyó por figura; una figura con
    cero rótulos o cero trazos es REVENTÓ (la extracción no leyó nada), no
    verde;
  - no ve: un rótulo legible pero lejos de lo que nombra, ni un texto blanco
    sobre fondo oscuro. Eso sigue siendo de mirar.

Uso:
    python verificar-figuras.py                 # galeria-cr3d.typ
    python verificar-figuras.py otra-galeria.typ
    python verificar-figuras.py --sabotaje      # exige ver el rojo

Sale 0 en verde, 1 en rojo, 2 si no compiló o no leyó nada.
"""
import os
import shutil
import subprocess
import sys
import tempfile

import pymupdf

AQUI = os.path.dirname(os.path.abspath(__file__))
ACHIQUE = 0.18      # fracción de la caja que se descuenta por lado (cruces)
MIN_SOLAPE = 0.12   # fracción del rótulo menor que tiene que tapar el otro


def compilar(entrada, raiz, salida):
    r = subprocess.run(['typst', 'compile', '--root', raiz, entrada, salida],
                       capture_output=True, text=True, encoding='utf-8')
    if r.returncode != 0:
        print(r.stderr)
        return False
    return True


def rotulos(pagina):
    cajas = []
    for b in pagina.get_text('dict')['blocks']:
        for ln in b.get('lines', []):
            txt = ''.join(s['text'] for s in ln['spans']).strip()
            if txt:
                cajas.append((txt, pymupdf.Rect(ln['bbox'])))
    return cajas


def orden_texto(pagina):
    """(caja, seqno) de cada tramo de texto: dice CUÁNDO se dibujó cada letra."""
    return [(pymupdf.Rect(t['bbox']), t['seqno']) for t in pagina.get_texttrace()]


def _bezier(p0, p1, p2, p3, k=6):
    pts = []
    for i in range(k + 1):
        t = i / k
        x = (1-t)**3*p0.x + 3*(1-t)**2*t*p1.x + 3*(1-t)*t**2*p2.x + t**3*p3.x
        y = (1-t)**3*p0.y + 3*(1-t)**2*t*p1.y + 3*(1-t)*t**2*p2.y + t**3*p3.y
        pts.append(pymupdf.Point(x, y))
    return list(zip(pts[:-1], pts[1:]))


def halos(pagina):
    """Rellenos blancos (el halo de un rótulo): (rect, orden de dibujo)."""
    hs = []
    for dib in pagina.get_drawings():
        f = dib.get('fill')
        if f and all(c > 0.97 for c in f[:3]) and dib.get('type') in ('f', 'fs'):
            hs.append((dib['rect'], dib['seqno']))
    return hs


def segmentos(pagina):
    """Cada tramo con el orden de dibujo de su trazo (seqno)."""
    segs = []
    for dib in pagina.get_drawings():
        if dib.get('type') == 'f':          # sólo relleno: no tapa letras con una línea
            continue
        sq = dib['seqno']
        antes = len(segs)
        for it in dib['items']:
            if it[0] == 'l':
                segs.append((it[1], it[2]))
            elif it[0] == 'c':
                segs += _bezier(*it[1:5])
            elif it[0] == 're':
                r = it[1]
                q = [r.tl, r.tr, r.br, r.bl, r.tl]
                segs += list(zip(q[:-1], q[1:]))
            elif it[0] == 'qu':
                q = it[1]
                pts = [q.ul, q.ur, q.lr, q.ll, q.ul]
                segs += list(zip(pts[:-1], pts[1:]))
        segs[antes:] = [(s, sq) for s in segs[antes:]]
    return segs


def cruza(seg, caja):
    """¿El segmento entra al rectángulo? (recorte de Liang-Barsky)"""
    a, b = seg
    dx, dy = b.x - a.x, b.y - a.y
    t0, t1 = 0.0, 1.0
    for p, q in ((-dx, a.x - caja.x0), (dx, caja.x1 - a.x), (-dy, a.y - caja.y0), (dy, caja.y1 - a.y)):
        if p == 0:
            if q < 0:
                return False
        else:
            t = q / p
            if p < 0:
                t0 = max(t0, t)
            else:
                t1 = min(t1, t)
            if t0 > t1:
                return False
    return True


def achicar(r, f):
    dx, dy = r.width * f, r.height * f
    return pymupdf.Rect(r.x0 + dx, r.y0 + dy, r.x1 - dx, r.y1 - dy)


def medir(pdf):
    problemas, llegadas = [], []
    for n, pag in enumerate(pymupdf.open(pdf), 1):
        rs, segs, hs, ot = rotulos(pag), segmentos(pag), halos(pag), orden_texto(pag)
        llegadas.append((n, len(rs), len(segs)))
        for i in range(len(rs)):
            for j in range(i + 1, len(rs)):
                a, b = rs[i][1], rs[j][1]
                inter = a & b
                if inter.is_empty:
                    continue
                menor = min(a.get_area(), b.get_area()) or 1
                if inter.get_area() / menor > MIN_SOLAPE:
                    problemas.append(f'figura {n}: «{rs[i][0]}» pisa a «{rs[j][0]}»')
        for txt, caja in rs:
            c = achicar(caja, ACHIQUE)
            if c.is_empty:
                continue
            # con halo, sólo cuenta lo que se dibujó DESPUÉS (encima del blanco)
            # el halo que tapa a este rótulo (cubre casi toda su caja achicada)
            debajo = max([sq for r, sq in hs if (r & c).get_area() > 0.6 * c.get_area()], default=-1)
            # tipografía del propio rótulo (la barra de una media, la raya de
            # una fracción): un trazo dibujado ENTRE las letras del rótulo, en
            # el orden de dibujo del PDF, y con las dos puntas adentro
            sqs = [sq for r, sq in ot if (r & caja).get_area() > 0.5 * r.get_area()]
            lo, hi = (min(sqs) - 1, max(sqs) + 1) if sqs else (0, -1)
            propio = pymupdf.Rect(caja.x0 - 1, caja.y0 - 2, caja.x1 + 1, caja.y1 + 1)

            def es_tipografia(s, sq):
                return lo <= sq <= hi and propio.contains(s[0]) and propio.contains(s[1])

            if any(sq > debajo and cruza(s, c) and not es_tipografia(s, sq) for s, sq in segs):
                problemas.append(f'figura {n}: una línea cruza el rótulo «{txt}»')
    return problemas, llegadas


def correr(entrada, raiz, eco=True):
    tmp = tempfile.mkdtemp(prefix='verfig-')
    pdf = os.path.join(tmp, 'galeria.pdf')
    try:
        if not compilar(entrada, raiz, pdf):
            return 2, ['no compiló']
        p, ll = medir(pdf)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    if eco:
        print('llegó: ' + ', '.join(f'fig {n}: {r} rótulos / {s} trazos' for n, r, s in ll))
    vacias = [n for n, r, s in ll if r == 0 or s == 0]
    if not ll or vacias:
        return 2, [f'figura(s) {vacias or "todas"}: no se leyó ningún rótulo o trazo']
    return (1 if p else 0), p


def _mutar(nuevo_renglon, marca):
    """Copia la carpeta, reemplaza el renglón que tiene `marca` (debe haber
    uno solo) por `nuevo_renglon`, y corre el verificador sobre la copia."""
    tmp = tempfile.mkdtemp(prefix='verfig-sab-')
    try:
        dst = os.path.join(tmp, 'practica')
        shutil.copytree(AQUI, dst, ignore=shutil.ignore_patterns('salida', 'recortes', '__pycache__', '*.pdf'))
        shutil.copytree(os.path.join(os.path.dirname(AQUI), 'apunte', 'biblioteca'),
                        os.path.join(tmp, 'apunte', 'biblioteca'))
        f = os.path.join(dst, 'figuras-cr3d.typ')
        s = open(f, encoding='utf-8').read()
        if s.count(marca) != 1:
            return None, [f'no hay UN renglón con {marca!r}']
        ini = s.rfind('\n', 0, s.index(marca)) + 1
        fin = s.index('\n', ini)
        s = s[:ini] + nuevo_renglon + s[fin:]
        open(f, 'w', encoding='utf-8').write(s)
        return correr(os.path.join(dst, 'galeria-cr3d.typ'), tmp, eco=False)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def sabotaje():
    """Dos mutantes, uno por chequeo, y el control positivo.
    (1) el rótulo B' del giróscopo, movido encima del rótulo «y»: tiene que
        salir «pisa»; (2) una línea dibujada por ENCIMA del rótulo B' (en una
        capa más alta que su halo): tiene que salir «cruza». Cada uno exige ver
        su rojo POR ESE rótulo, no un rojo cualquiera."""
    rc0, p0 = correr(os.path.join(AQUI, 'galeria-cr3d.typ'), os.path.dirname(AQUI), eco=False)
    marca = "[$B'$], ancla:"
    rc1, p1 = _mutar('  rotulo3(v, esc3(R1 + 0.9, n), [$B\' "pisado"$], ancla: "north")', marca)
    rc2, p2 = _mutar(
        '  rotulo3(v, suma3(esc3(R1 + 0.2, n), (0, 0, 0.12)), [$B\' "tachado"$], ancla: "south")\n'
        '  { let q = p3(v, esc3(R1 + 0.2, n)); cetz.draw.on-layer(3, cetz.draw.line('
        '(q.at(0) - 0.6, q.at(1) + 0.45), (q.at(0) + 0.6, q.at(1) + 0.45), stroke: 1pt + black)) }', marca)
    ok0 = rc0 == 0
    v1 = [x for x in (p1 or []) if 'pisado' in x and 'pisa' in x]
    v2 = [x for x in (p2 or []) if 'tachado' in x and 'cruza' in x]
    ok1, ok2 = rc1 == 1 and bool(v1), rc2 == 1 and bool(v2)
    print(f'[{"OK" if ok0 else "FALLA"}] control positivo (la galería real): rc={rc0}')
    for x in p0:
        print('    ', x)
    print(f'[{"OK" if ok1 else "FALLA"}] sabotaje 1 (dos rótulos pisados): rc={rc1}; lo vio: {v1 or p1}')
    print(f'[{"OK" if ok2 else "FALLA"}] sabotaje 2 (línea encima del halo): rc={rc2}; lo vio: {v2 or p2}')
    return 0 if (ok0 and ok1 and ok2) else 1


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')   # los rótulos traen letras matemáticas
    if '--sabotaje' in sys.argv:
        sys.exit(sabotaje())
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    entrada = os.path.join(AQUI, args[0]) if args else os.path.join(AQUI, 'galeria-cr3d.typ')
    rc, p = correr(entrada, os.path.dirname(AQUI))
    if rc == 2:
        print('[REVENTÓ] ' + '; '.join(p))
    elif p:
        print(f'ROJO: {len(p)} problema(s)')
        for x in p:
            print('  ', x)
    else:
        print('VERDE: ningún rótulo pisado ni cruzado')
    sys.exit(rc)
