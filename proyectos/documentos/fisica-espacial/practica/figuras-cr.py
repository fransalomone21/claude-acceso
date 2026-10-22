#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
figuras-cr.py -- las figuras de datos de resueltos-cr-1-a-4.typ.

Las que son esquema (la derivada en un sistema que rota, las dos velocidades
angulares del disco) se reusan de la biblioteca del apunte, en CeTZ. Las que
son 3D o curvas salen de aca, en SVG vectorial y con el texto convertido a
trazos (svg.fonttype = path, trampa pagada en pdf-con-codigo). Deterministas:
sin fecha y con hashsalt fijo, para que regenerarlas sin cambios no cambie
los bytes.

    python figuras-cr.py        # escribe figuras-cr/*.svg
"""
import math as m
import os

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

AQUI = os.path.dirname(os.path.abspath(__file__))
SALIDA = os.path.join(AQUI, 'figuras-cr')

plt.rcParams.update({
    'svg.fonttype': 'path', 'svg.hashsalt': 'fisica-espacial-cr',
    'font.family': 'serif', 'font.serif': ['Libertinus Serif', 'DejaVu Serif'],
    'mathtext.fontset': 'dejavuserif', 'font.size': 10,
    'axes.spines.top': False, 'axes.spines.right': False,
})
AZUL, VERDE, ROJO, AMBAR, VIOLE, GRIS = '#1B4F72', '#1E8449', '#B03A2E', '#B9770E', '#6C3483', '#9AA0A6'


def guardar(fig, nombre):
    os.makedirs(SALIDA, exist_ok=True)
    fig.savefig(os.path.join(SALIDA, nombre), format='svg', bbox_inches='tight', metadata={'Date': None})
    plt.close(fig)


def flecha3(ax, a, b, color, lw=2.0, ls='-', etiqueta=None, dx=(0, 0, 0)):
    a, b = np.array(a, float), np.array(b, float)
    ax.quiver(*a, *(b - a), color=color, lw=lw, linestyle=ls, arrow_length_ratio=0.12, normalize=False)
    if etiqueta:
        p = b + np.array(dx)
        ax.text(*p, etiqueta, color=color, fontsize=11, ha='center', va='center')


def ejes3(ax, lim):
    ax.set_xlim(-lim, lim); ax.set_ylim(-lim, lim); ax.set_zlim(-lim, lim)
    ax.set_box_aspect((1, 1, 1))
    ax.set_axis_off()


# ------------------------------------------------------------ Problema 1
def cubo():
    fig = plt.figure(figsize=(5.2, 4.6))
    ax = fig.add_subplot(projection='3d')
    ax.view_init(elev=20, azim=-58)
    # aristas del cubo de 2 m, centro en G
    v = [(x, y, z) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)]
    for p in v:
        for q in v:
            if sum(abs(p[i] - q[i]) for i in range(3)) == 2 and p < q:
                ax.plot(*zip(p, q), color='#555555', lw=0.9)
    # ejes por G
    for e, nombre in (((1.9, 0, 0), 'x'), ((0, 1.9, 0), 'y'), ((0, 0, 1.9), 'z')):
        ax.plot(*zip((0, 0, 0), e), color=GRIS, lw=0.8, ls='--')
        ax.text(*[1.05 * c for c in e], nombre, color='#555555', fontsize=10)
    ax.scatter([0], [0], [0], color='k', s=10)
    ax.text(0.08, -0.25, -0.2, 'G', fontsize=10)
    # el thruster en (1,1,1) y su empuje sobre +x
    ax.scatter([1], [1], [1], color=ROJO, s=22)
    flecha3(ax, (1, 1, 1), (1.85, 1, 1), ROJO, etiqueta=r'$\mathbf{F}$ = 4 N', dx=(-0.55, 0, 0.32))
    ax.plot([0, 1], [0, 1], [0, 1], color=ROJO, lw=0.9, ls=':')
    ax.text(0.45, 0.6, 0.72, r'$\mathbf{r}$', color=ROJO, fontsize=11)
    # tau y omega: los dos sobre (0, 1, -1)/sqrt2
    n = np.array((0, 1, -1)) / m.sqrt(2)
    flecha3(ax, (0, 0, 0), 1.75 * n, AZUL, lw=2.6, etiqueta=r'$\boldsymbol{\tau}\ \parallel\ \boldsymbol{\omega}$', dx=(0, 0.35, -0.2))
    # circulo que recorre el vertice alrededor del eje de giro
    c = np.dot((1, 1, 1), n) * n
    rr = np.array((1, 1, 1)) - c
    u = rr / np.linalg.norm(rr); w = np.cross(n, u)
    s = np.linspace(0, 2 * m.pi, 200)
    pts = c[:, None] + np.linalg.norm(rr) * (np.outer(u, np.cos(s)) + np.outer(w, np.sin(s)))
    ax.plot(*pts, color=AMBAR, lw=1.0, ls='--')
    ax.text(*(pts[:, 60] + np.array((0, 0, 0.2))), 'recorrido del vértice', color=AMBAR, fontsize=8.5)
    ejes3(ax, 1.6)
    ax.set_box_aspect((1, 1, 1), zoom=1.15)
    guardar(fig, 'cr1-cubo.svg')


def empuje_que_gira():
    """El empuje esta clavado al cuerpo y gira con el: durante los 4 s barre
    32 grados en el plano perpendicular al eje de giro."""
    alfa = 4 * m.sqrt(2) / 80
    fig, ax = plt.subplots(figsize=(5.6, 3.2))
    for t in (0, 1, 2, 3, 4):
        th = 0.5 * alfa * t * t
        ax.annotate('', xy=(m.cos(th), m.sin(th)), xytext=(0, 0),
                    arrowprops=dict(arrowstyle='-|>', color=ROJO, lw=1.4, alpha=0.35 + 0.16 * t))
        if t >= 2:
            ax.text(1.04 * m.cos(th), 1.04 * m.sin(th), 't = %d s' % t, fontsize=8.5, color=ROJO,
                    ha='left', va='center')
    ax.text(1.04, -0.02, 't = 0 y 1 s', fontsize=8.5, color=ROJO, ha='left', va='center')
    ax.text(0.22, 0.03, '32°', fontsize=8.5, color=ROJO)
    # el impulso lineal: aprox (F fijo) vs exacto (F que gira)
    N = 4000; dt = 4 / N
    px = sum(m.cos(0.5 * alfa * ((k + .5) * dt) ** 2) for k in range(N)) * dt / 4
    py = sum(m.sin(0.5 * alfa * ((k + .5) * dt) ** 2) for k in range(N)) * dt / 4
    ax.annotate('', xy=(1.0, -0.42), xytext=(0, -0.42), arrowprops=dict(arrowstyle='-|>', color=GRIS, lw=2))
    ax.text(1.04, -0.42, r'$F\,\Delta t / m$ = 0,133 m/s (si $\mathbf{F}$ no girara)', fontsize=8.5, color='#555555', va='center')
    ax.annotate('', xy=(px, py - 0.42), xytext=(0, -0.42), arrowprops=dict(arrowstyle='-|>', color=VERDE, lw=2))
    ax.text(px + 0.04, py - 0.42 + 0.07, r'$\Delta\mathbf{v}$ real = 0,131 m/s, a 10,8°', fontsize=8.5, color=VERDE)
    ax.set_xlim(-0.05, 2.2); ax.set_ylim(-0.6, 0.75); ax.set_aspect('equal'); ax.set_axis_off()
    ax.text(0, 0.72, r'Plano perpendicular al eje de giro (visto desde la punta de $\boldsymbol{\omega}$)',
            fontsize=8.5, color='#333333')
    guardar(fig, 'cr1-empuje.svg')


# ------------------------------------------------------------ Problema 2
def disco():
    fig = plt.figure(figsize=(7.2, 3.4))
    # (a) en el plano j-k de la horquilla, con omega2 = omega1 para que se vea
    ax = fig.add_subplot(1, 2, 1)
    w1 = w2 = 1.0
    om = (w1, w2)                  # (k, j)
    H = (0.5 * w1 * 2 / 2, 0.25 * w2 * 2 / 2)   # en unidades de m r^2: (1/2 w1, 1/4 w2) escalado
    H = (0.5 * w1 * 2, 0.25 * w2 * 2)
    ax.annotate('', xy=om, xytext=(0, 0), arrowprops=dict(arrowstyle='-|>', color=VERDE, lw=2))
    ax.annotate('', xy=H, xytext=(0, 0), arrowprops=dict(arrowstyle='-|>', color=AZUL, lw=2.4))
    ax.text(om[0] + 0.03, om[1] + 0.05, r'$\boldsymbol{\omega}=\omega_2\hat{\jmath}+\omega_1\hat{k}$', color=VERDE, fontsize=10)
    ax.text(H[0] + 0.05, H[1] - 0.12, r'$\mathbf{H}_G$', color=AZUL, fontsize=11)
    ax.plot([0, 1.25], [0, 0], color=GRIS, lw=0.9); ax.text(1.27, -0.03, r'$\hat{k}$ (eje del disco)', fontsize=9)
    ax.plot([0, 0], [0, 1.15], color=GRIS, lw=0.9); ax.text(-0.05, 1.18, r'$\hat{\jmath}$ (vertical)', fontsize=9)
    # k a la derecha y j arriba: i = j x k ENTRA en la hoja
    ax.scatter([0], [0], s=90, facecolors='white', edgecolors=ROJO, zorder=5)
    ax.scatter([0], [0], s=60, marker='x', color=ROJO, zorder=6)
    ax.text(-0.06, -0.18, r'$\hat{\imath}$ y $\dot{\mathbf{H}}_G$ entran en la hoja', color=ROJO, fontsize=9)
    ax.set_xlim(-0.2, 1.9); ax.set_ylim(-0.3, 1.3); ax.set_aspect('equal'); ax.set_axis_off()
    ax.text(-0.2, 1.42, r'(a) En la horquilla (dibujado con $\omega_2=\omega_1$)', fontsize=9.5)
    # (b) desde el sistema inercial: H_G barre un cono alrededor de Y
    ax = fig.add_subplot(1, 2, 2, projection='3d')
    ax.view_init(elev=20, azim=-58)
    hy, hk = 0.25, 0.5          # componentes de H_G / (m r^2) con w1 = w2 = 1
    s = np.linspace(0, 2 * m.pi, 200)
    # en el dibujo: X,Z horizontales -> ejes x,y de matplotlib; Y vertical -> z
    ax.plot(hk * np.sin(s), hk * np.cos(s), hy * np.ones_like(s), color=AZUL, lw=0.8, ls='--')
    for e, nombre in (((0.8, 0, 0), 'X'), ((0, 0.8, 0), 'Z'), ((0, 0, 0.75), 'Y')):
        ax.plot(*zip((0, 0, 0), e), color=GRIS, lw=0.8)
        ax.text(*[1.08 * c for c in e], nombre, fontsize=9, color='#555555')
    fi = 0.6
    Hp = (hk * m.sin(fi), hk * m.cos(fi), hy)
    flecha3(ax, (0, 0, 0), Hp, AZUL, lw=2.2, etiqueta=r'$\mathbf{H}_G$', dx=(0.02, 0.06, 0.08))
    tang = np.array((m.cos(fi), -m.sin(fi), 0)) * 0.28
    flecha3(ax, Hp, np.array(Hp) + tang, ROJO, lw=1.8, etiqueta=r'$\dot{\mathbf{H}}_G$', dx=(0.08, -0.02, -0.07))
    ax.plot([0, hk * m.sin(fi)], [0, hk * m.cos(fi)], [0, 0], color=VIOLE, lw=2.5, alpha=0.6)
    ax.text(hk * m.sin(fi) * 0.5 + 0.05, hk * m.cos(fi) * 0.5, -0.07, 'eje del disco', fontsize=8, color=VIOLE)
    ax.set_xlim(-0.55, 0.55); ax.set_ylim(-0.55, 0.55); ax.set_zlim(-0.1, 0.75)
    ax.set_box_aspect((1, 1, 0.75)); ax.set_axis_off()
    ax.text2D(0.02, 0.95, r'(b) Desde el sistema inercial: un cono alrededor de $Y$', fontsize=9.5,
              transform=ax.transAxes)
    guardar(fig, 'cr2-disco.svg')


# ------------------------------------------------------------ Problema 3
def gimbal():
    fig = plt.figure(figsize=(7.4, 3.4))
    ax = fig.add_subplot(1, 2, 1, projection='3d')
    ax.view_init(elev=20, azim=-62)
    for e, nombre in (((1.25, 0, 0), 'x'), ((0, 1.25, 0), 'y'), ((0, 0, 1.25), 'z')):
        ax.plot(*zip((0, 0, 0), e), color=GRIS, lw=0.8, ls='--')
        ax.text(*[1.07 * c for c in e], nombre, fontsize=10, color='#555555')
    flecha3(ax, (0, 0, 0), (0, 0, 1.0), AZUL, lw=3, etiqueta=r'$\mathbf{H}\approx I_z\omega_s\,\hat{k}$ = 1000', dx=(0.0, 0.0, 0.2))
    flecha3(ax, (0, 0, 0), (0, 0.6, 0), VERDE, lw=2, etiqueta=r'$\boldsymbol{\Omega}=\omega_p\hat{\jmath}$', dx=(0, 0.25, -0.1))
    flecha3(ax, (0, 0, 0), (0.83, 0, 0), AMBAR, lw=2.4, etiqueta=r'$\boldsymbol{\Omega}\times\mathbf{H}$ = 500', dx=(0.05, 0, -0.2))
    flecha3(ax, (0, 0, 0.12), (1.0, 0, 0.12), ROJO, lw=1.6, etiqueta=r'$M_x$ = 600', dx=(0.1, 0, 0.14))
    ax.set_xlim(-0.2, 1.1); ax.set_ylim(-0.2, 1.1); ax.set_zlim(-0.1, 1.2)
    ax.set_box_aspect((1, 1, 1)); ax.set_axis_off()
    ax.text2D(0.0, 0.97, '(a) Los vectores, en los ejes del gimbal', fontsize=9.5, transform=ax.transAxes)
    # (b) el reparto de la cupla
    ax = fig.add_subplot(1, 2, 2)
    ax.barh([0], [500], color=AMBAR, height=0.5)
    ax.barh([0], [100], left=[500], color=ROJO, height=0.5)
    ax.text(250, 0, 'girar $\\mathbf{H}$ con la\nplataforma: 500', ha='center', va='center', color='white', fontsize=9)
    ax.text(550, 0.0, 'acelerar\n100', ha='center', va='center', color='white', fontsize=8.5)
    ax.barh([1], [600], color=GRIS, height=0.5)
    ax.text(300, 1, 'cupla aplicada: 600 N·m', ha='center', va='center', color='white', fontsize=9)
    ax.set_yticks([]); ax.set_xlim(0, 620); ax.set_xlabel('N·m')
    ax.spines['left'].set_visible(False)
    ax.set_title(r'(b) $M_x = \omega_p I_z \omega_s + I_x\,\dot{\Omega}_x$:  600 = 500 + 100', fontsize=9.5)
    fig.tight_layout()
    guardar(fig, 'cr3-gimbal.svg')


def barrido_spin():
    ws = np.linspace(0, 200, 201)
    a = (600 - 0.5 * 10 * ws) / 5
    fig, ax = plt.subplots(figsize=(5.6, 2.9))
    ax.plot(ws, a, color=AZUL, lw=2)
    ax.axhline(0, color='#555555', lw=0.7)
    for x, y, txt, dx, dy in ((0, 120, 'sin giro: 600/5 = 120', 12, -4), (100, 20, 'el problema: 20', -55, 14),
                              (120, 0, r'$\omega_s$ = 120: el gimbal no se mueve', 6, 18),
                              (200, -80, 'acelera para el otro lado', -95, 14)):
        ax.plot([x], [y], 'o', color=ROJO, ms=5)
        ax.text(x + dx, y + dy, txt, fontsize=8.5, color=ROJO)
    ax.set_xlabel(r'velocidad del volante $\omega_s$ [rad/s]')
    ax.set_ylabel(r'$\dot{\Omega}_x$ del gimbal [rad/s²]')
    ax.set_xlim(0, 205); ax.set_ylim(-95, 135)
    guardar(fig, 'cr3-barrido.svg')


# ------------------------------------------------------------ Problema 4
def _cono(ax, eje, semi, largo, color, alfa):
    eje = np.array(eje, float); eje /= np.linalg.norm(eje)
    a = np.cross(eje, (1, 0, 0)) if abs(eje[0]) < 0.9 else np.cross(eje, (0, 1, 0))
    a /= np.linalg.norm(a); b = np.cross(eje, a)
    s = np.linspace(0, 2 * m.pi, 60); h = np.linspace(0, largo, 2)
    S, Hh = np.meshgrid(s, h)
    R = Hh * m.tan(semi)
    X = Hh * eje[0] + R * (np.cos(S) * a[0] + np.sin(S) * b[0])
    Y = Hh * eje[1] + R * (np.cos(S) * a[1] + np.sin(S) * b[1])
    Z = Hh * eje[2] + R * (np.cos(S) * a[2] + np.sin(S) * b[2])
    ax.plot_surface(X, Y, Z, color=color, alpha=alfa, linewidth=0, shade=False)
    ax.plot(X[-1], Y[-1], Z[-1], color=color, lw=0.8)


def conos():
    fig = plt.figure(figsize=(7.4, 3.9))
    casos = ((r'(a) Este problema: achatado, $I_z > I_\perp$' '\nretrógrada (espacial adentro del corporal)', 16 / 9),
             (r'(b) Si fuera alargado, $I_z < I_\perp$' '\ndirecta (conos que se tocan por afuera)', 9 / 16))
    gam = m.radians(14)            # angulo H-z, EXAGERADO (el real es 2 grados)
    for k, (titulo, q) in enumerate(casos):
        ax = fig.add_subplot(1, 2, k + 1, projection='3d')
        ax.view_init(elev=14, azim=-90)
        th = m.atan(q * m.tan(gam))   # angulo omega-z: tan th = (Iz/Iperp) tan gam
        Hdir = np.array((0, 0, 1.0))
        zdir = np.array((m.sin(gam), 0, m.cos(gam)))
        # omega en el plano de H y z, a th de z, del mismo lado que H
        wdir = np.array((m.sin(gam - th), 0, m.cos(gam - th)))
        _cono(ax, Hdir, abs(th - gam), 1.15, AMBAR, 0.30)     # espacial: omega alrededor de H
        _cono(ax, zdir, th, 1.15, VIOLE, 0.18)                # corporal: omega alrededor de z
        flecha3(ax, (0, 0, 0), 1.45 * Hdir, AZUL, lw=2.4, etiqueta=r'$\mathbf{H}_G$', dx=(0, 0, 0.09))
        flecha3(ax, (0, 0, 0), 1.35 * zdir, '#333333', lw=1.6, etiqueta='z', dx=(0.06, 0, 0.07))
        flecha3(ax, (0, 0, 0), 1.3 * wdir, VERDE, lw=2.0, etiqueta=r'$\boldsymbol{\omega}$', dx=(-0.08, 0, 0.07))
        ax.set_xlim(-0.6, 0.6); ax.set_ylim(-0.6, 0.6); ax.set_zlim(0, 1.5)
        ax.set_box_aspect((1, 1, 1.25)); ax.set_axis_off()
        ax.set_title(titulo, fontsize=9)
    fig.text(0.5, 0.02, 'Ángulos exagerados para que se vean (en el problema, z está a 2° de H). '
             'Ámbar: cono espacial; violeta: cono corporal.', ha='center', fontsize=8.5, color='#444444')
    guardar(fig, 'cr4-conos.svg')


if __name__ == '__main__':
    cubo(); empuje_que_gira(); disco(); gimbal(); barrido_spin(); conos()
    print('figuras en', SALIDA, ':', ', '.join(sorted(os.listdir(SALIDA))))
