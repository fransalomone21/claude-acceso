"""Figuras anotadas del N² para el modulo el-diagrama-n2-aplicado (pedido de Fran, 2026-11-17).

Toma las laminas de la catedra (fuentes/figuras, las regenera extraer-clases.py --pagina 7:48
--pagina 7:49; la c02-p074 sale sola) y les escribe encima las aclaraciones. Salida en
apunte/figuras/n2-*.png. Uso: python anotar-n2.py
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

AQUI = Path(__file__).parent
FUENTE = AQUI / "fuentes" / "figuras"
SALIDA = AQUI / "apunte" / "figuras"
ROJO, AZUL, VERDE, GRIS = (200, 30, 40), (20, 70, 170), (20, 120, 60), (60, 60, 60)
F = lambda t, b=True: ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf" if b else "C:/Windows/Fonts/arial.ttf", t)


def lienzo(img, arriba=0, abajo=0, izq=0, der=0):
    c = Image.new("RGB", (img.width + izq + der, img.height + arriba + abajo), "white")
    c.paste(img, (izq, arriba))
    return c, ImageDraw.Draw(c)


def nota(d, xy, texto, color, tam=22, ancho=None, caja=True):
    """Texto en un recuadro blanco con borde del color: se lee arriba de la lamina."""
    f = F(tam)
    lineas = texto.split("\n")
    w = max(d.textlength(l, font=f) for l in lineas) + 16
    h = len(lineas) * (tam + 6) + 10
    x, y = xy
    if caja:
        d.rounded_rectangle((x, y, x + w, y + h), 8, fill=(255, 255, 255), outline=color, width=3)
    for i, l in enumerate(lineas):
        d.text((x + 8, y + 6 + i * (tam + 6)), l, font=f, fill=color)
    return (x, y, x + w, y + h)


def flecha(d, a, b, color, ancho=4):
    import math
    d.line((a, b), fill=color, width=ancho)
    ang = math.atan2(b[1] - a[1], b[0] - a[0])
    p = [b, (b[0] - 18 * math.cos(ang - 0.4), b[1] - 18 * math.sin(ang - 0.4)),
         (b[0] - 18 * math.cos(ang + 0.4), b[1] - 18 * math.sin(ang + 0.4))]
    d.polygon(p, fill=color)


# Grilla de la lamina 48 (medida sobre el PNG de 1100 x 825): columnas y filas de las celdas
X48 = [447, 555, 662, 770, 877]
Y48 = [232, 340, 447, 555, 662]


def celda(d, xs, ys, fila, col, color, dy=0, dx=0):
    d.rectangle((xs[col] + dx + 3, ys[fila] + dy + 3, xs[col + 1] + dx - 3, ys[fila + 1] + dy - 3), outline=color, width=5)


def figura_lectura():
    img = Image.open(FUENTE / "c07-p048.png").convert("RGB")
    c, d = lienzo(img, arriba=120, abajo=170)
    dy = 120
    nota(d, (20, 10), "Las flechitas NO son otra herramienta: son cómo se escribe una casilla.\n"
         "Fila = de quién SALE.   Columna = a quién ENTRA.\n"
         "Lo que entra de afuera baja por ARRIBA a una columna; lo que sale, por el COSTADO de una fila.", AZUL, 22)
    celda(d, X48, Y48, 0, 1, ROJO, dy)    # O1 -> I2: fila 1, columna 2
    celda(d, X48, Y48, 1, 0, VERDE, dy)   # O2 -> I1: fila 2, columna 1
    nota(d, (20, 825 + dy + 10), "Rojo, fila 1 y columna 2: «O1 → I2» = la salida de la Función 1 entra a la 2.\n"
         "Arriba de la diagonal, el flujo va «para adelante».", ROJO, 21)
    nota(d, (20, 825 + dy + 85), "Verde, fila 2 y columna 1: «O2 → I1» = la Función 2 le devuelve algo a la 1.\n"
         "Abajo de la diagonal, «para atrás»: si las dos están ocupadas, hay un lazo.", VERDE, 21)
    c.save(SALIDA / "n2-lectura-c07-p048.png")


def figura_comparacion():
    tabla = Image.open(FUENTE / "c02-p074.png").convert("RGB")
    diag = Image.open(FUENTE / "c07-p048.png").convert("RGB").crop((440, 120, 1100, 670))
    escala = 600 / diag.height
    diag = diag.resize((int(diag.width * escala), 600))
    tabla = tabla.resize((int(tabla.width * 600 / tabla.height), 600))
    W = tabla.width + diag.width + 60
    c = Image.new("RGB", (W, 600 + 330), "white")
    d = ImageDraw.Draw(c)
    c.paste(tabla, (10, 110))
    c.paste(diag, (tabla.width + 50, 110))
    nota(d, (20, 15), "La MISMA matriz N×N, escrita de dos maneras. «Tabla N²», «diagrama N²», «matriz N²» y «DSM» son la misma herramienta.", AZUL, 25)
    nota(d, (20, 60), "Unidad 2 (Crawley, la tabla)", GRIS, 22)
    nota(d, (tabla.width + 60, 60), "Unidad 7 (NASA, el diagrama)", GRIS, 22)
    y = 720
    nota(d, (20, y), "• Los nombres van en los ENCABEZADOS (1.ª fila y 1.ª columna).\n"
         "• La diagonal queda VACÍA: nadie se conecta consigo mismo.\n"
         "• Cada casilla dice QUÉ relación hay, con palabras.\n"
         "• Relación formal = simétrica: «conectado» aparece de los dos lados.", ROJO, 21)
    nota(d, (tabla.width + 60, y), "• Los nombres van SOBRE la diagonal (las cajas verdes).\n"
         "• Cada casilla trae una flechita «O → I»: QUÉ sale\n"
         "  de la fila y A QUIÉN le entra (la columna).\n"
         "• Sirve para flujos con sentido: datos, energía.\n"
         "• I = entrada (input), O = salida (output).", VERDE, 21)
    nota(d, (20, y + 140), "Las dos se leen igual: fila = sale de, columna = entra a, casilla en blanco = no hay interfaz.", AZUL, 23)
    c.save(SALIDA / "n2-comparacion-c02-p074-c07-p048.png")


def figura_lazo():
    img = Image.open(FUENTE / "c07-p049.png").convert("RGB")
    c, d = lienzo(img, arriba=95, abajo=150)
    dy = 95
    nota(d, (20, 12), "Un lazo de realimentación se ve como dos casillas ESPEJADAS respecto de la diagonal.", AZUL, 25)
    # grilla de la 49 (1100 x 825): columnas 481-589-697-805-912, filas 210-318-427-535-642
    X, Y = [481, 589, 697, 805, 912], [210, 318, 427, 535, 642]
    celda(d, X, Y, 0, 1, ROJO, dy); celda(d, X, Y, 1, 0, ROJO, dy)
    celda(d, X, Y, 1, 2, VERDE, dy); celda(d, X, Y, 2, 1, VERDE, dy)
    nota(d, (20, 825 + dy + 8), "Rojo: 1 → 2 y 2 → 1 (lazo entre las funciones 1 y 2).   Verde: 2 → 3 y 3 → 2 (lazo entre la 2 y la 3).\n"
         "Funciones muy acopladas, con lazos entre ellas, son candidatas a ir JUNTAS en un mismo subsistema:\n"
         "así el ida y vuelta queda adentro, y hacia afuera sale una interfaz sola.", GRIS, 21)
    c.save(SALIDA / "n2-lazos-c07-p049.png")


if __name__ == "__main__":
    figura_lectura(); figura_comparacion(); figura_lazo()
    print("OK: apunte/figuras/n2-*.png")
