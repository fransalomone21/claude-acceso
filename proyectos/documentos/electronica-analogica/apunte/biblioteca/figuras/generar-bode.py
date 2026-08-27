# -*- coding: utf-8 -*-
u"""Genera bode-amplificador.svg — el diagrama de Bode del Ejercicio 12.1.

POR QUÉ ESTO NO ESTÁ EN cetz-plot, como el resto de los gráficos del apunte:
cetz-plot no hace bien los ejes logarítmicos, y un Bode sin décadas reales no
es un Bode. La decisión la tomó Fran y está registrada en HANDOFF.md, fase 4.
El resto de las curvas —las cualitativas— siguen en cetz-plot, que ahí anda.

CÓMO SE REGENERA (desde electronica-analogica/apunte). El SVG vive adentro
de biblioteca/ y no al lado del apunte porque al compilar SOLO la galería el
root de Typst es biblioteca/, y un `../` desde ahí queda fuera del sandbox:

    python biblioteca/figuras/generar-bode.py

El SVG resultante SE COMMITEA: el apunte tiene que compilar en una máquina sin
Python ni matplotlib. Este script está para poder volver a generarlo, no para
correr en cada compilación.

DOS COSAS QUE NO SON OBVIAS Y YA COSTARON TIEMPO:

1. `svg.fonttype = "none"` deja el texto como texto y con el NOMBRE de la
   familia adentro del SVG, en vez de convertirlo a curvas. Typst resuelve esa
   familia con su propio catálogo de fuentes al compilar, así que la figura
   termina escrita en la MISMA tipografía que el cuerpo del apunte.

2. Libertinus Serif la trae Typst adentro; no es una fuente del sistema y
   matplotlib no la ve. Por eso matplotlib maqueta con Times New Roman —que
   tiene métricas parecidas— y después se reescribe la familia en el SVG.
   Verificado por render: si esto se rompe, el texto de la figura sale con
   otra letra que el resto de la página y se nota a simple vista.
"""

import io
import os
import re

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

# --- los mismos colores que biblioteca/paleta.typ -------------------------
C_DATO = "#B03A2E"   # la asíntota, que es el tema de la figura
C_AUX = "#2471A3"    # la curva exacta
C_GUIA = "#9AA0A6"   # líneas de construcción
C_TRAZO = "#111111"

AQUI = os.path.dirname(os.path.abspath(__file__))
SALIDA = os.path.join(AQUI, "bode-amplificador.svg")

# --- la transferencia del Ejercicio 12.1 ----------------------------------
#   H(jw) = 200 * (jw/100) / ((1 + jw/100)(1 + jw/1e5))
K = 200.0
WP1 = 1.0e2
WP2 = 1.0e5


def h_exacta(w):
    jw = 1j * w
    return K * (jw / WP1) / ((1 + jw / WP1) * (1 + jw / WP2))


def db(x):
    return 20.0 * np.log10(np.abs(x))


# Los tres tramos de la asíntota, en los vértices que los definen.
#   w << wp1 : |H| ~ K*w/wp1  -> +20 dB/déc, y en w = 1 vale 20 log(2) = 6 dB
#   wp1 << w << wp2 : |H| ~ K -> 20 log 200 = 46 dB, plano
#   w >> wp2 : -20 dB/déc
W_MIN, W_MAX = 1.0, 1.0e7
BANDA = db(K)                                    # 46,02 dB
ASINTOTA = [
    (W_MIN, BANDA - 20.0 * np.log10(WP1 / W_MIN)),  # 6,02 dB en w = 1
    (WP1, BANDA),
    (WP2, BANDA),
    (W_MAX, BANDA - 20.0 * np.log10(W_MAX / WP2)),
]


def main():
    plt.rcParams.update({
        "svg.fonttype": "none",
        "font.family": "serif",
        "font.serif": ["Times New Roman", "DejaVu Serif"],
        # Sin esto, matplotlib compone las formulas ($\omega$, $10^2$) con
        # DejaVu Sans: dentro de la misma figura conviven dos tipografias.
        "mathtext.fontset": "custom",
        "mathtext.rm": "Times New Roman",
        "mathtext.it": "Times New Roman:italic",
        "mathtext.bf": "Times New Roman:bold",
        "font.size": 8.5,
        "axes.linewidth": 0.6,
        "axes.edgecolor": C_TRAZO,
        "xtick.labelsize": 8.0,
        "ytick.labelsize": 8.0,
        "xtick.color": C_TRAZO,
        "ytick.color": C_TRAZO,
        "xtick.major.width": 0.6,
        "ytick.major.width": 0.6,
    })

    fig, ax = plt.subplots(figsize=(5.3, 3.0))

    w = np.logspace(np.log10(W_MIN), np.log10(W_MAX), 2000)
    ax.semilogx(w, db(h_exacta(w)), color=C_AUX, lw=1.0, label=u"$|H|$ exacto")
    ax.semilogx(
        [p[0] for p in ASINTOTA],
        [p[1] for p in ASINTOTA],
        color=C_DATO, lw=1.6, label=u"asíntotas",
    )

    # Los dos quiebres y la banda de paso.
    for wq, nombre in ((WP1, u"$\\omega_{p1}=10^2$"), (WP2, u"$\\omega_{p2}=10^5$")):
        ax.axvline(wq, color=C_GUIA, lw=0.5, ls=(0, (4, 3)))
        # Arriba y no abajo: abajo esta la leyenda y se tapaban. Visto en el
        # render, no en el codigo -- que compile no prueba que se lea.
        ax.annotate(
            nombre, xy=(wq, 56.5), ha="center", va="top",
            fontsize=8.0, color=C_GUIA,
        )
    ax.axhline(BANDA, color=C_GUIA, lw=0.5, ls=(0, (4, 3)))

    # Las pendientes, escritas sobre su propio tramo.
    ax.annotate(u"+20 dB/déc", xy=(6.0, 26), color=C_DATO, fontsize=8.0,
                rotation=32, rotation_mode="anchor", ha="left", va="bottom")
    ax.annotate(u"−20 dB/déc", xy=(7.0e5, 34), color=C_DATO, fontsize=8.0,
                rotation=-32, rotation_mode="anchor", ha="left", va="top")
    ax.annotate(u"banda de paso: 46 dB", xy=(2.2e3, 48.5), color=C_DATO,
                fontsize=8.0, ha="center", va="bottom")

    # El error de 3 dB en el quiebre, que es la corrección que pide el método.
    ax.annotate(
        u"−3 dB", xy=(WP2, BANDA - 3.0), xytext=(2.4e4, 26),
        fontsize=8.0, color=C_AUX, ha="right",
        arrowprops=dict(arrowstyle="->", color=C_AUX, lw=0.5,
                        shrinkA=1, shrinkB=2),
    )

    ax.set_xlabel(u"$\\omega$  [rad/s]", fontsize=8.5)
    ax.set_ylabel(u"$|H|$  [dB]", fontsize=8.5)
    ax.set_xlim(W_MIN, W_MAX)
    ax.set_ylim(-10, 58)
    ax.set_yticks([0, 10, 20, 30, 40, 46, 50])
    ax.grid(True, which="major", color=C_GUIA, lw=0.35, alpha=0.5)
    ax.grid(True, which="minor", axis="x", color=C_GUIA, lw=0.2, alpha=0.35)
    for lado in ("top", "right"):
        ax.spines[lado].set_visible(False)
    # Leyenda ADENTRO de la figura, como pide la guía de informes de la cátedra.
    leg = ax.legend(loc="lower center", fontsize=8.0, frameon=True,
                    framealpha=1.0, edgecolor=C_GUIA, borderpad=0.4)
    leg.get_frame().set_linewidth(0.4)

    fig.tight_layout(pad=0.3)
    fig.savefig(SALIDA, format="svg", transparent=True)
    plt.close(fig)

    # matplotlib escribe la familia que ENCONTRO, y la escribe entre comillas
    # simples: `font-family: 'Times New Roman';`. Se reemplaza CUALQUIER familia
    # por la del apunte, con expresion regular, para no depender de que nombre
    # eligio: eso ya fallo una vez con una lista de nombres a mano.
    svg = io.open(SALIDA, encoding="utf-8").read()
    familia = "Libertinus Serif, Georgia, Times New Roman, serif"
    svg, n1 = re.subn(r"font-family:\s*[^;\"]+;", "font-family: %s;" % familia, svg)
    svg, n2 = re.subn(r"font-family:\s*'[^']+'\"", "font-family: %s\"" % familia, svg)
    svg, n3 = re.subn(r"font-family=\"[^\"]+\"", 'font-family="%s"' % familia, svg)
    n = n1 + n2 + n3
    io.open(SALIDA, "w", encoding="utf-8", newline="\n").write(svg)

    print(u"escrito %s  (%d KB, %d familias de fuente reescritas)"
          % (os.path.relpath(SALIDA, AQUI), len(svg) // 1024, n))
    if n == 0:
        raise SystemExit(
            u"FALLA: no se reescribio ninguna familia de fuente. El SVG va a "
            u"salir con otra letra que el apunte. Mira que nombre puso "
            u"matplotlib y agregalo a la lista."
        )


if __name__ == "__main__":
    main()
