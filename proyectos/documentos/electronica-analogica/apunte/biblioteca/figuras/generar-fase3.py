# -*- coding: utf-8 -*-
u"""Genera los cuatro graficos cuantitativos de los modulos 16, 17 y 18.

    polos-plano-s.svg      M16: donde caen los polos del RLC serie segun zeta
    rlc-tres-salidas.svg   M16: |H| del mismo RLC con la salida en R, en L y en C
    butterworth.svg        M17: Butterworth de orden 1 a 4 y la plantilla del Ejercicio 17.1
    trifasico-fasores.svg  M18: las tres tensiones de fase y una de linea

Por que matplotlib y no cetz-plot: los ejes logaritmicos (PDP §6, 2026-08-23).

Desde electronica-analogica/apunte:

    LIBERTINUS=<carpeta con LibertinusSerif-Regular.otf e -Italic.otf> \
        python biblioteca/figuras/generar-fase3.py

Diferencia con generar-bode.py, y es a proposito: aca el texto va como CURVAS
(svg.fonttype = "path"), con la Libertinus Serif cargada en matplotlib desde el
.otf. Con "none" el SVG lleva <text> y el visor lo arma con sus propias
metricas: las letras salen separadas (skill pdf-con-codigo, pagado en otro
proyecto). La fuente no se commitea (es la que Typst trae adentro); si no se
encuentra, el script ABORTA en vez de caer a otra letra en silencio.

Los SVG SE COMMITEAN: el apunte compila sin Python. Los numeros de los
ejercicios no salen de aca sino de ../../../fase3-cuentas.py.
"""

import os
import sys

import matplotlib

matplotlib.use("Agg")
from matplotlib import font_manager
import matplotlib.pyplot as plt
import numpy as np

AQUI = os.path.dirname(os.path.abspath(__file__))

# --- la letra del apunte, o nada -------------------------------------------
DIR = os.environ.get("LIBERTINUS", "")
REG = os.path.join(DIR, "LibertinusSerif-Regular.otf")
ITA = os.path.join(DIR, "LibertinusSerif-Italic.otf")
if not (os.path.isfile(REG) and os.path.isfile(ITA)):
    sys.exit("ABORTA: falta la Libertinus Serif (variable LIBERTINUS). Sin ella la figura sale con otra letra.")
for f in (REG, ITA):
    font_manager.fontManager.addfont(f)
plt.rcParams.update({
    "font.family": "Libertinus Serif",
    "mathtext.fontset": "custom",
    "mathtext.rm": "Libertinus Serif",
    "mathtext.it": "Libertinus Serif:italic",
    "svg.fonttype": "path",
    "font.size": 9,
    "axes.linewidth": 0.6,
    "xtick.major.width": 0.6,
    "ytick.major.width": 0.6,
    "axes.formatter.use_locale": False,
})

# --- los colores de biblioteca/paleta.typ ----------------------------------
C_DATO = "#B03A2E"
C_AUX = "#2471A3"
C_VERDE = "#1E8449"
C_AMBAR = "#B9770E"
C_GUIA = "#9AA0A6"
C_TRAZO = "#111111"


def coma(x, dec=0):
    """Numero con coma decimal, como el resto del apunte."""
    return ("%.*f" % (dec, x)).replace(".", ",")


def guardar(fig, nombre):
    ruta = os.path.join(AQUI, nombre)
    fig.savefig(ruta, format="svg", bbox_inches="tight", pad_inches=0.04, metadata={"Date": None})
    plt.close(fig)
    texto = open(ruta, encoding="utf-8").read()
    assert "<text" not in texto, nombre + ": quedo texto como <text>; tiene que ser path"
    print("escrito", nombre)


# 1. polos en el plano s ----------------------------------------------------
def polos_plano_s():
    fig, ax = plt.subplots(figsize=(5.6, 3.9))
    th = np.linspace(np.pi / 2, 3 * np.pi / 2, 200)
    ax.plot(np.cos(th), np.sin(th), color=C_GUIA, lw=0.7, ls="--")
    ax.axhline(0, color=C_TRAZO, lw=0.6)
    ax.axvline(0, color=C_TRAZO, lw=0.6)
    casos = [(0.2, C_AMBAR, r"$\zeta = 0{,}2$"), (0.5, C_DATO, r"$\zeta = 0{,}5$ (Ej. 16.2)")]
    for z, c, et in casos:
        re, im = -z, np.sqrt(1 - z * z)
        ax.plot([re, re], [im, -im], "x", color=c, ms=8, mew=1.6)
        if z < 0.3:
            ax.annotate(et, (re, im), xytext=(re + 0.05, im + 0.12), color=c, fontsize=8.5, ha="left")
        else:
            ax.annotate(et, (re, im), xytext=(re - 0.08, im + 0.12), color=c, fontsize=8.5, ha="right")
    ax.plot([-1], [0], "x", color=C_VERDE, ms=8, mew=1.6)
    ax.annotate(r"$\zeta = 1$: polo doble", (-1, 0), xytext=(-1.05, 0.12), color=C_VERDE, fontsize=8.5, ha="right")
    z = 2.0
    for re in (-z + np.sqrt(z * z - 1), -z - np.sqrt(z * z - 1)):
        ax.plot([re], [0], "x", color=C_AUX, ms=8, mew=1.6)
    ax.annotate(r"$\zeta = 2$: dos reales", (-0.268, 0), xytext=(-0.62, -0.22), color=C_AUX, fontsize=8.5)
    # el angulo theta para zeta = 0,5
    ax.plot([0, -0.5], [0, np.sqrt(0.75)], color=C_DATO, lw=0.7)
    a = np.linspace(np.pi, np.pi - np.pi / 3, 40)
    ax.plot(0.28 * np.cos(a), 0.28 * np.sin(a), color=C_DATO, lw=0.7)
    ax.text(-0.36, 0.13, r"$\theta$", color=C_DATO, fontsize=9.5)
    ax.text(-0.36, 0.5, r"$|p| = \omega_0$", color=C_DATO, fontsize=8.5, ha="right")
    ax.annotate("", xy=(-0.5, -0.98), xytext=(0, -0.98), arrowprops=dict(arrowstyle="<->", color=C_TRAZO, lw=0.6))
    ax.text(-0.25, -1.08, r"$\alpha = \zeta\,\omega_0$", ha="center", va="top", fontsize=8.5)
    ax.text(-3.9, 1.12, r"circunferencia de radio $\omega_0$", color=C_GUIA, fontsize=8)
    ax.set_xlim(-4.0, 0.4)
    ax.set_ylim(-1.25, 1.35)
    ax.set_aspect("equal")
    ax.set_xlabel(r"parte real $\sigma / \omega_0$")
    ax.set_ylabel(r"parte imaginaria $\omega / \omega_0$")
    ax.set_xticks([-4, -3, -2, -1, 0])
    ax.set_yticks([-1, 0, 1])
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    guardar(fig, "polos-plano-s.svg")


# 2. el RLC serie con tres salidas -------------------------------------------
def rlc_tres_salidas():
    Q = 5.0
    u = np.logspace(-1, 1, 2000)            # omega / omega0
    s = 1j * u
    D = s * s + s / Q + 1
    curvas = [
        (np.abs(1 / D), C_AUX, "salida en $C$: pasa bajos"),
        (np.abs(s / Q / D), C_VERDE, "salida en $R$: pasa banda"),
        (np.abs(s * s / D), C_DATO, "salida en $L$: pasa altos"),
    ]
    fig, ax = plt.subplots(figsize=(5.6, 3.2))
    for h, c, et in curvas:
        ax.semilogx(u, 20 * np.log10(h), color=c, lw=1.2, label=et)
    ax.axvline(1, color=C_GUIA, lw=0.6, ls="--")
    ax.axhline(20 * np.log10(Q), color=C_GUIA, lw=0.6, ls=":")
    ax.text(0.105, 20 * np.log10(Q) + 1.0, r"$20\log_{10} Q = 14$ dB", fontsize=8, color=C_GUIA)
    ax.set_xlim(0.1, 10)
    ax.set_ylim(-45, 20)
    ax.set_xlabel(r"$\omega / \omega_0$ (escala logarítmica)")
    ax.set_ylabel(r"$20\log_{10}|H|$  (dB)")
    ax.set_xticks([0.1, 0.2, 0.5, 1, 2, 5, 10])
    ax.set_xticklabels(["0,1", "0,2", "0,5", "1", "2", "5", "10"])
    ax.grid(True, which="major", color="#E5E7E9", lw=0.5)
    ax.legend(loc="lower center", fontsize=8, frameon=False, ncol=1)
    for sp in ("top", "right"):
        ax.spines[sp].set_visible(False)
    guardar(fig, "rlc-tres-salidas.svg")


# 3. Butterworth y la plantilla ---------------------------------------------
def butterworth():
    f = np.logspace(2, 4.3, 2000)
    fp, fs = 1000.0, 5000.0
    fig, ax = plt.subplots(figsize=(5.6, 3.3))
    # la plantilla: zonas prohibidas
    ax.fill_between([100, fp], [-3, -3], [-60, -60], color=C_DATO, alpha=0.12, lw=0)
    ax.fill_between([fs, 2e4], [-40, -40], [5, 5], color=C_DATO, alpha=0.12, lw=0)
    ax.text(130, -14, "prohibido: la banda\nde paso cae más de 3 dB", fontsize=7.5, color=C_DATO)
    ax.text(5400, -12, "prohibido: la banda\nde rechazo no\nbaja de 40 dB", fontsize=7.5, color=C_DATO)
    colores = {1: C_GUIA, 2: C_AMBAR, 3: C_AUX, 4: C_VERDE}
    for n in (1, 2, 3, 4):
        h = -10 * np.log10(1 + (f / fp) ** (2 * n))
        ax.semilogx(f, h, color=colores[n], lw=1.5 if n == 3 else 0.9, label="$n = %d$" % n)
    ax.plot([fs], [-10 * np.log10(1 + 5 ** 6)], "o", color=C_AUX, ms=3.5)
    ax.annotate(r"$n=3$: $-41{,}9$ dB en 5 kHz", (fs, -41.9), xytext=(1800, -56), fontsize=8, color=C_AUX,
                arrowprops=dict(arrowstyle="-", color=C_AUX, lw=0.5))
    ax.set_xlim(100, 2e4)
    ax.set_ylim(-60, 5)
    ax.set_xlabel("frecuencia (Hz, escala logarítmica)")
    ax.set_ylabel(r"$20\log_{10}|H|$  (dB)")
    ax.set_xticks([100, 1000, 5000, 10000])
    ax.set_xticklabels(["100", "1 k", "5 k", "10 k"])
    ax.grid(True, which="major", color="#E5E7E9", lw=0.5)
    ax.legend(loc="lower left", fontsize=8, frameon=False)
    for sp in ("top", "right"):
        ax.spines[sp].set_visible(False)
    guardar(fig, "butterworth.svg")


# 4. fasores trifasicos -----------------------------------------------------
def trifasico_fasores():
    fig, ax = plt.subplots(figsize=(4.4, 4.0))
    Vf = 1.0
    ang = {"a": 0, "b": -120, "c": 120}
    pts = {}
    for k, g in ang.items():
        x, y = Vf * np.cos(np.radians(g)), Vf * np.sin(np.radians(g))
        pts[k] = (x, y)
        ax.annotate("", xy=(x, y), xytext=(0, 0), arrowprops=dict(arrowstyle="-|>", color=C_AUX, lw=1.2))
    ax.text(0.78, -0.16, r"$\bar V_{an}$", color=C_AUX, fontsize=10)
    ax.text(-0.62, -0.98, r"$\bar V_{bn}$", color=C_AUX, fontsize=10)
    ax.text(-0.62, 0.9, r"$\bar V_{cn}$", color=C_AUX, fontsize=10)
    # Vab = Van - Vbn, dibujada desde el origen
    vab = (pts["a"][0] - pts["b"][0], pts["a"][1] - pts["b"][1])
    ax.annotate("", xy=vab, xytext=(0, 0), arrowprops=dict(arrowstyle="-|>", color=C_DATO, lw=1.3))
    ax.text(vab[0] + 0.04, vab[1] + 0.04, r"$\bar V_{ab} = $√3$\,V_f\,\angle 30°$", color=C_DATO, fontsize=9.5)
    # el -Vbn que se suma, punteado
    ax.annotate("", xy=vab, xytext=pts["a"], arrowprops=dict(arrowstyle="-|>", color=C_GUIA, lw=0.8, ls="--"))
    ax.text(1.36, 0.3, r"$-\bar V_{bn}$", color=C_GUIA, fontsize=9)
    a = np.linspace(0, np.radians(30), 30)
    ax.plot(0.45 * np.cos(a), 0.45 * np.sin(a), color=C_DATO, lw=0.7)
    ax.text(0.48, 0.1, "30°", color=C_DATO, fontsize=8.5)
    a = np.linspace(0, np.radians(120), 60)
    ax.plot(0.25 * np.cos(a), 0.25 * np.sin(a), color=C_GUIA, lw=0.6)
    ax.text(0.02, 0.29, "120°", color=C_GUIA, fontsize=8)
    ax.plot([-0.9, 2.0], [0, 0], color=C_TRAZO, lw=0.4)
    ax.plot([0, 0], [-1.0, 1.05], color=C_TRAZO, lw=0.4)
    ax.set_xlim(-1.0, 2.2)
    ax.set_ylim(-1.15, 1.25)
    ax.set_aspect("equal")
    ax.axis("off")
    ax.text(-0.95, -1.2, "secuencia positiva (abc): giran en sentido antihorario", fontsize=7.5, color=C_GUIA)
    guardar(fig, "trifasico-fasores.svg")


if __name__ == "__main__":
    polos_plano_s()
    rlc_tres_salidas()
    butterworth()
    trifasico_fasores()
