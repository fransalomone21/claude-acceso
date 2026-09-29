"""Valida la guia completa y los modelos de parcial ANTES de publicarlos.

Cuatro chequeos, y cualquiera en rojo sale con 1:

  1. ESTRUCTURA -- todo ejercicio de ejercicios.toml tiene recortes, tip de
     UNA oracion y resultado; y todo recorte existe en recortes/.
  2. NUMEROS -- cada numero impreso tiene su cuenta aca, hecha de cero y sin
     mirar la ficha del Anexo A. Se busca el texto EXACTO en el documento
     (si no esta, rojo: el control no mide nada) y se compara contra la
     cuenta con la tolerancia de su ultima cifra (o 0,2 %).
  3. COBERTURA -- todo ejercicio tiene controles o esta en SIN_NUMERO con su
     motivo (demostraciones, lecturas de grafico, dibujos).
  4. TERMINOLOGIA -- "impulso angular" solo puede aparecer al lado de
     "momento angular" (la aclaracion), o como la integral del torque /
     el cambio de L. Pedido de Fran, 2026-09-27: L es el momento angular.

    python validar.py            # todo
    python validar.py --toml X   # otro archivo de datos (lo usa el saboteador)
    python validar.py --mostrar  # imprime cada cuenta (para escribir los parciales)
"""
import io
import math as m
import os
import re
import sys
import tomllib

AQUI = os.path.dirname(os.path.abspath(__file__))
MU = 398600.0          # km^3/s^2 (Curtis, el del apunte)
RT = 6378.0            # km
G0 = 9.81              # m/s^2
GM_BEER = 9.81e-3 * 6370.0 ** 2   # km^3/s^2: el Beer usa GM = g R^2, R = 6370 km
deg = m.degrees
rad = m.radians


def norm(v):
    return m.sqrt(sum(x * x for x in v))


def cruz(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def punto(a, b):
    return sum(x * y for x, y in zip(a, b))


def ang(a, b):
    return deg(m.acos(punto(a, b) / (norm(a) * norm(b))))


# ---------------------------------------------------------------- cuentas
def c_vec():
    A, B = (4, 7, 0), (5, -2, 0)
    D = (A[0] - B[0], A[1] - B[1], 0)
    Ab, Db = (0, -8, 0), (-10 * m.cos(rad(53)), 10 * m.sin(rad(53)), 0)
    F = [(100 * m.cos(rad(30)), 100 * m.sin(rad(30))), (-80 * m.sin(rad(30)), 80 * m.cos(rad(30))),
         (-40 * m.cos(rad(53)), -40 * m.sin(rad(53)))]
    S = (sum(f[0] for f in F), sum(f[1] for f in F))
    PA, PB, PC, PD = (0, -600, 0), (450, 0, 0), (0, 0, -320), (-500, 0, 360)
    AB = tuple(b - a for a, b in zip(PA, PB)); AC = tuple(c - a for a, c in zip(PA, PC))
    AD = tuple(d - a for a, d in zip(PA, PD))
    a11 = (1, -1, 3); a13 = cruz((0, 1, 5), (-3, 0, 2))
    A15, B15, C15 = (2, 0, -3), (-1, 5, 2), (0, -4, 1)
    AxB = cruz(A15, B15)
    return {
        'vec-1': [('8,06', norm(A)), ('5,39', norm(B)), ('-1,00 hat(i)', D[0]), ('9,00 hat(j)', D[1]),
                  ('9,06', norm(D)), ('96,3', deg(m.atan2(D[1], D[0])))],
        'vec-2': [('6,00', punto(A, B)), ('82,1', ang(A, B))],
        'vec-3': [('48,1', abs(cruz(Ab, Db)[2]))],  # signo: z de A x D
        'vec-4': [('90,2', norm(S)), ('255,5', deg(m.atan2(-S[1], -S[0])) % 360),
                  ('75,5', deg(m.atan2(S[1], S[0])))],
        'vec-5': [('109,5', ang((1, 1, 1), (1, -1, -1)))],
        'vec-6-8': [('77,9', ang(AB, AD)), ('65,3', ang(AC, AD)), ('45,1', ang(AC, AB)),
                    ('197,6', 280 * punto(AC, AB) / (norm(AC) * norm(AB)))],
        'vec-11': [('0,302', a11[0] / norm(a11)), ('-0,302', a11[1] / norm(a11)), ('0,905', a11[2] / norm(a11))],
        'vec-13': [('(2, -15, 3)', None), ('0,130', a13[0] / norm(a13)), ('-0,972', a13[1] / norm(a13)),
                   ('0,194', a13[2] / norm(a13))],
        'vec-14': [('1,581', 5 / m.sqrt(10)), ('(0,5; 0; -1,5)', None)],
        'vec-15': [('i) $14$', None), ('(3, -47, 2)', None), ('(39, -15, -60)', None), ('(-3, -65, -2)', None),
                   ('(-120, 8, -80)', None), ('(28, 0, -42)', None)],
        '_vec3_signo': cruz(Ab, Db)[2],
        '_vec13': a13,
        '_vec15': (punto(A15, cruz(B15, C15)), cruz(A15, cruz(B15, C15)), cruz(AxB, C15),
                   cruz(A15, AxB), tuple(punto(A15, B15) * x for x in AxB), cruz(AxB, cruz(A15, C15))),
    }


def tsiolkovsky_altura(M0, mu, vr, t_fin, g=G0, pasos=20000):
    dt = t_fin / pasos
    y = 0.0
    for i in range(pasos):
        t = (i + 0.5) * dt
        y += (vr * m.log(M0 / (M0 - mu * t)) - g * t) * dt
    return y


def c_cm():
    va = -2.25 * 3.20 / 68.5
    # asteroides: vA sin30 = vB sin45 ; vA cos30 + vB cos45 = 40
    vB = 40 / (m.sin(rad(45)) / m.sin(rad(30)) * m.cos(rad(30)) + m.cos(rad(45)))
    vA = vB * m.sin(rad(45)) / m.sin(rad(30))
    disip = 1 - (vA ** 2 + vB ** 2) / 40 ** 2
    vag = 4.75 * 2.5 / 1.75
    K = 0.5 * 4.75 * 2.5 ** 2 + 0.5 * 1.75 * vag ** 2
    f4 = 180 * 0.029
    t1 = 17800 / 225
    V1 = 3600 * m.log(19540 / 1740) - G0 * t1
    r1, r2 = 19540 / 10640, 10040 / 1140
    V2 = 3600 * m.log(r1 * r2) - G0 * t1
    y9 = tsiolkovsky_altura(19540, 225, 3600, t1)
    v3 = (600 * 18000 - 200 * 18060) / 400
    vs = -800 * 0.3 / 90800
    Fp = 800 * (0.3 + vs) / 4
    Ma = 220 * 900 / (6 + G0)
    Ftot = 2 * 11.8e6 + 3 * 2e6
    return {
        'cm-1': [('-0,105', va)],
        'cm-2': [('29,3', vA), ('20,7', vB), ('19,6', 100 * disip)],
        'cm-3': [('6,79', vag), ('55,1', K)],
        'cm-4': [('5,22', f4), ('1,07 times 10^(-2)', f4 / 490), ('0,053', f4 / 490 * 5)],
        'cm-5': [('e^(-150)', None), ('7,2 times 10^(-66)', m.exp(-3.00e8 * 1e-3 / 2000)),
                 ('0,223', m.exp(-1.5))],
        'cm-6': [('31,9', 12.5 * 4000 / 1200 - G0), ('240', 12.5 * 4000 / 200 - G0)],
        'cm-7-8': [('11,23', 19540 / 1740), ('1,836', r1), ('8,807', r2),
                   ('7,93', V1 / 1000), ('9,24', V2 / 1000)],
        'cm-9': [('187', y9 / 1000)],
        'cm-ad1': [('17 thin 970', v3), ('-90', v3 - 18060)],
        'cm-ad2': [('-2,64 times 10^(-3)', vs), ('59,5', Fp)],
        'cm-ad3': [('12,5 times 10^3', Ma), ('29,6 times 10^6', Ftot), ('4,70', Ftot / 2.04e6 - G0),
                   ('448', 2e6 / (455 * G0))],
    }


def c_ma():
    tau = [4 * 10 * m.sin(rad(a)) for a in (90, 120, 30)] + [2 * 10 * m.sin(rad(60))]
    F = (0.140 + 0.025) * 9.80
    tq = F * 0.04
    Om = 2 * m.pi / 2.20
    L = tq / Om
    rpm = L / 1.20e-4 * 60 / (2 * m.pi)
    h = 6778 * 8.435
    rS = h / (6.970 * m.cos(rad(12.05)))
    rI = h / (6.817 * m.cos(rad(12.11)))
    I7 = 2.0 * 0.025 ** 2
    L7 = I7 * 19200 * 2 * m.pi / 60
    Om7 = rad(1e-6) / (5 * 3600)
    return {
        'ma-1': [('40,0', tau[0]), ('34,6', tau[1]), ('20,0', tau[2]), ('17,3', tau[3])],
        'ma-4': [('1,62', F), ('0,0647', tq), ('2,86', Om), ('0,0226', L), ('1800', rpm)],
        'ma-5': [('57 thin 170', h), ('8387', rS), ('2009', rS - RT), ('8578', rI), ('2200', rI - RT)],
        'ma-7': [('1,25 times 10^(-3)', I7), ('2,51', L7), ('9,7 times 10^(-13)', Om7), ('2,4 times 10^(-12)', L7 * Om7)],
    }


def c_grav():
    G = 6.674e-11
    Msol = 4 * m.pi ** 2 * 1.496e11 ** 3 / (G * (365.25 * 86400) ** 2)
    # sonda (Beer): millas y horas
    g_mih = 32.2 / 5280 * 3600 ** 2
    GMmi = g_mih * 3960 ** 2
    vB2 = m.sqrt((20.2e3) ** 2 - 2 * GMmi * (1 / 6660 - 1 / 11860))
    Tsid = 23.934 * 3600
    ageo = (GM_BEER * Tsid ** 2 / (4 * m.pi ** 2)) ** (1 / 3)
    rp, ra = RT + 400, RT + 4000
    a4 = (rp + ra) / 2
    vp = m.sqrt(2 * MU * ra / (rp * (rp + ra)))
    va = vp * rp / ra
    # Hohmann Tierra-Marte (S&Z, apendice F)
    GMs = G * 1.99e30
    aT = (149.6e9 + 228e9) / 2
    ttr = m.pi * m.sqrt(aT ** 3 / GMs) / 86400
    fase = 180 - ttr * 360 / 687.0
    # Beer 13.85 -- con el mu del apunte (m07), y de control con el gR^2 del Beer
    GMb = MU * 1e9  # m^3/s^2
    E300 = -GMb * 3600 / (2 * 6670e3)
    Egeo = -GMb * 3600 / (2 * 42140e3)
    Esup = -GMb * 3600 / 6370e3
    Gb = GM_BEER * 1e9
    dA_beer = (-Gb * 3600 / (2 * 42140e3) + Gb * 3600 / (2 * 6670e3)) / 1e9
    dB_beer = (-Gb * 3600 / (2 * 42140e3) + Gb * 3600 / 6370e3) / 1e9
    # rendez-vous con el r del apunte (m12)
    af_ap = 42140 * 0.75 ** (2 / 3)
    dv_ap = 2 * (m.sqrt(MU / 42140) - m.sqrt(MU * (2 / 42140 - 1 / af_ap)))
    # Jupiter
    GMj = 319 * GM_BEER
    vpar = m.sqrt(2 * GMj / 350e3)
    vel = m.sqrt(2 * GMj * 100e3 / (350e3 * 450e3))
    # LEM
    GMl = 0.01230 * GM_BEER
    rA, rB = 1748.0, 1880.0
    vA = m.sqrt(2 * GMl * rB / (rA * (rA + rB)))
    vBl = vA * rA / rB
    vc = m.sqrt(GMl / rB)
    vB9 = vc - 0.200
    vC = m.sqrt(vB9 ** 2 + 2 * GMl * (1 / 1740 - 1 / rB))
    phi = deg(m.asin(rB * vB9 / (1740 * vC)))
    # rendez-vous geoestacionario, blanco 90 grados adelante
    rg = (MU * (86164.0 / (2 * m.pi)) ** 2) ** (1 / 3)
    af = rg * 0.75 ** (2 / 3)
    dv1 = m.sqrt(MU / rg) - m.sqrt(MU * (2 / rg - 1 / af))
    # adicionales
    e1 = 90000 / 110000; a1 = 55000.0
    h1 = m.sqrt(2 * MU * 10000 * 100000 / 110000)
    nu1 = m.acos((h1 ** 2 / (MU * (RT + 10000)) - 1) / e1)
    h2 = (RT + 500) * 10
    e2 = h2 ** 2 / (MU * (RT + 500)) - 1
    r120 = h2 ** 2 / MU / (1 + e2 * m.cos(rad(120)))
    g120 = deg(m.atan(e2 * m.sin(rad(120)) / (1 + e2 * m.cos(rad(120)))))
    a3 = (MU * 6000.0 ** 2 / (4 * m.pi ** 2)) ** (1 / 3)
    r1_, r2_ = RT + 1000, RT + 2000
    e4 = (r2_ - r1_) / (r1_ * m.cos(rad(40)) - r2_ * m.cos(rad(150)))
    p4 = r1_ * (1 + e4 * m.cos(rad(40)))
    h5 = 8000 * 7.5 * m.cos(rad(10))
    ec5 = h5 ** 2 / (MU * 8000) - 1
    es5 = 7.5 * m.sin(rad(10)) * h5 / MU
    return {
        'g-0': [('1,99 times 10^30', Msol / 1e30 * 1e30)],
        'g-2': [('15 thin 650', vB2), ('7,00', vB2 * 1.609344 / 3600)],
        'g-3': [('35 thin 780', ageo - 6370), ('3,07', 2 * m.pi * ageo / Tsid)],
        'g-4': [('7907', 2 * m.pi * m.sqrt(a4 ** 3 / MU)), ('1,531', ra / rp), ('8,435', vp), ('5,509', va),
                ('10,85', m.sqrt(2 * MU / rp)), ('2,41', m.sqrt(2 * MU / rp) - vp),
                ('3,26', m.sqrt(2 * MU / ra) - va)],
        'g-5': [('258,8', ttr), ('44,4', fase)],
        'g-6': [('-107,6', E300 / 1e9), ('-17,0', Egeo / 1e9), ('-225,3', Esup / 1e9),
                ('90,6', (Egeo - E300) / 1e9), ('208,3', (Egeo - Esup) / 1e9),
                ('sale $90,4$', dA_beer), ('y $208,0$', dB_beer)],
        'g-7': [('12,70', vel), ('26,9', vpar), ('14,2', vpar - vel)],
        'g-8': [('1,704', vA), ('1,584', vBl), ('1,614', vc), ('30', (vc - vBl) * 1000)],
        'g-9': [('1,555', vC), ('79,2', phi)],
        'g-10': [('42 thin 164', rg), ('34 thin 806', af), ('0,344', dv1), ('0,689', 2 * dv1), ('da $0,688$', dv_ap)],
        'g-ad1': [('85 thin 130', h1), ('0,818', e1), ('55 thin 000', a1),
                  ('35,7', 2 * m.pi * m.sqrt(a1 ** 3 / MU) / 3600), ('-3,62', -MU / (2 * a1)),
                  ('82,3', deg(nu1)), ('5,20', h1 / (RT + 10000)), ('3,80', MU / h1 * e1 * m.sin(nu1)),
                  ('8,51', h1 / 10000), ('0,851', h1 / 100000)],
        'g-ad2': [('0,7255', e2), ('44,6', g120), ('12 thin 250', r120 - RT)],
        'g-ad3': [('7136', a3), ('6578', RT + 200), ('0,0782', 1 - (RT + 200) / a3)],
        'g-ad4': [('7816', p4), ('0,0775', e4), ('876', p4 / (1 + e4) - RT), ('7863', p4 / (1 - e4 ** 2))],
        'g-ad5': [('63,8', deg(m.atan2(es5, ec5))), ('0,215', m.hypot(es5, ec5))],
    }


def c_cr():
    I = 120 * 4 / 6
    L = cruz((1, 1, 1), (4, 0, 0))
    w = tuple(4 * x / I for x in L)
    Ix, Iz = 0.54 ** 2, 0.72 ** 2
    fi4 = 1.5 / ((Ix - Iz) / Iz * m.cos(rad(2)))
    I7x, I7z = 1000 * 1.0, 1000 * 1.25 ** 2
    H7 = (0, 50 * -1.25, -50 * 2.0)            # r_A = (x, 2, -1.25) m, F = 50 N en +x, 1 s
    H8 = (0, I7x * 0.02 + 50 * 2.0, I7z * 0.10 - 50 * 1.25)   # r_B = (x, 1.25, 2)
    w0 = 36 * 2 * m.pi / 3600
    apot = 1.2 / (2 * m.tan(rad(22.5)))
    H9 = (20 * 2 * 2 * apot, 2400 * w0, 0)
    w9 = (H9[0] / 2000, w0, 0)
    return {
        'cr-1': [('80', I), ('(0; 0,2; -0,2)', None), ('0,283', norm(w)), ('8,16', 4 / (50 * G0) * 1000),
                 ('_w', w)],
        'cr-3': [('alpha = 20', (600 - 0.5 * 10 * 100) / 5)],
        'cr-4': [('3,431', abs(fi4)), ('1,832', 2 * m.pi / abs(fi4))],
        'cr-5': [('0,628', 6 * 2 * m.pi / 60), ('10,0', 60 / 6)],
        'cr-6': [('2,45', m.sqrt(6))],
        'cr-7': [('-62,5', H7[1]), ('-100', H7[2]), ('-0,0625', H7[1] / I7x), ('-0,064', H7[2] / I7z),
                 ('148,0', ang(H7, (0, 0, 1))), ('0,118', norm(H7) / I7x),
                 ('0,036', (H7[2] / I7z) * (I7x - I7z) / I7x)],
        'cr-8': [('120', H8[1]), ('93,75', H8[2]), ('0,12', H8[1] / I7x), ('0,06', H8[2] / I7z),
                 ('52,0', ang(H8, (0, 0, 1))), ('0,152', norm(H8) / I7x),
                 ('-0,034', (H8[2] / I7z) * (I7x - I7z) / I7x)],
        'cr-9': [('2,897', 2 * apot), ('115,9', H9[0]), ('150,8', H9[1]), ('0,0580', w9[0]), ('0,0628', w0),
                 ('37,5', ang(H9, (0, 1, 0))), ('42,7', ang(w9, (0, 1, 0))), ('0,0951', norm(H9) / 2000),
                 ('-0,0126', w0 * (2000 - 2400) / 2000)],
    }


# Ejercicios sin numero que controlar, con su motivo (chequeo 3).
SIN_NUMERO = {
    'vec-9': 'formula', 'vec-10': 'formula', 'vec-12': 'trivial (0,0,+-1)',
    'ma-2': 'demostracion', 'ma-3': 'demostracion', 'ma-6': 'demostracion y pregunta conceptual',
    'g-1': 'lectura de grafico', 'cr-2': 'formula simbolica',
}


# ------------------------------------------------ parcialito y modelo
def c_parciales():
    # Parcialito, ej. 1
    Lz = lambda r, p: r[0] * p[1] - r[1] * p[0]
    p1, p2 = (2 * 3, 0), (-2 * 3, 0)
    # Parcialito, ej. 2
    rp, ra = RT + 600, RT + 2000
    vp = m.sqrt(2 * MU * ra / (rp * (rp + ra)))
    vp_d = round(vp, 3)
    h = rp * vp_d
    va = h / ra
    a = (rp + ra) / 2
    r3 = 7600.0
    v3 = m.sqrt(MU * (2 / r3 - 1 / a))
    g3 = deg(m.acos(h / (r3 * v3)))
    v3_d, g3_d = round(v3, 3), round(g3, 2)
    r3c = h / (v3_d * m.cos(rad(g3_d)))
    vc = m.sqrt(MU / ra)
    J = 500 * ra * (vc - va) * 1e6   # kg km^2/s -> kg m^2/s
    h30 = ra * vc * m.cos(rad(30))                     # misma rapidez, gamma = 30
    e30 = m.sqrt(1 + 2 * (-MU / (2 * ra)) * h30 ** 2 / MU ** 2)
    rp30 = ra * (1 - e30)
    e1 = (ra - rp) / (ra + rp)
    g_b = deg(m.acos(m.sqrt(1 - e1 ** 2)))             # gamma en r = a_1
    # Parcialito, ej. 3
    Irot = 0.5 * 0.200 * 0.030 ** 2
    w = 3000 * 2 * m.pi / 60
    Lg = Irot * w
    tq = 0.200 * 9.8 * 0.050
    Om = tq / Lg
    # Modelo, ej. 1
    r1, r2 = RT + 300, 42164.0
    at = (r1 + r2) / 2
    v1 = m.sqrt(MU / r1); vtp = m.sqrt(MU * (2 / r1 - 1 / at))
    vta = m.sqrt(MU * (2 / r2 - 1 / at)); v2 = m.sqrt(MU / r2)
    dv = (vtp - v1) + (v2 - vta)
    ve = 320 * G0 / 1000
    m0 = 1500 * m.exp(dv / ve)
    tt = m.pi * m.sqrt(at ** 3 / MU)
    m_tras_1 = 1500 * m.exp((v2 - vta) / ve)
    # Modelo, ej. 2
    r, v, gm = 7500.0, 8.2, 5.0
    hh = r * v * m.cos(rad(gm))
    eps = v ** 2 / 2 - MU / r
    aa = -MU / (2 * eps)
    ec = hh ** 2 / (MU * r) - 1
    es = v * m.sin(rad(gm)) * hh / MU
    ee = m.hypot(ec, es)
    nu = deg(m.atan2(es, ec))
    rpp, raa = aa * (1 - ee), aa * (1 + ee)
    T2 = 2 * m.pi * m.sqrt(aa ** 3 / MU)
    # Modelo, ej. 3 -- cilindro macizo 800 kg, R = 1 m, alto 3 m
    Iz3 = 0.5 * 800 * 1.0 ** 2
    Ix3 = 800 * (3 * 1.0 ** 2 + 3.0 ** 2) / 12
    H0 = Iz3 * 2.0
    dH = 100 * 1.0 * 1.5
    H3 = m.hypot(H0, dH)
    th = deg(m.atan(dH / H0))
    wx = dH / Ix3
    thw = deg(m.atan(wx / 2.0))
    phid = H3 / Ix3
    psid = 2.0 * (Ix3 - Iz3) / Ix3
    T0 = 0.5 * Iz3 * 2.0 ** 2
    T1 = T0 + 0.5 * Ix3 * wx ** 2
    # Modelo, ej. 4 -- yo-yo: cilindro I = 40, dos masas de 1 kg de 0,5 m a 3 m
    I0, I1 = 40 + 2 * 1 * 0.5 ** 2, 40 + 2 * 1 * 3.0 ** 2
    w0 = 60 * 2 * m.pi / 60
    w1 = w0 * I0 / I1
    K0, K1 = 0.5 * I0 * w0 ** 2, 0.5 * I1 * w1 ** 2
    Jc = 40 * (w1 - w0)
    return {
        'parcialito': [
            ('-24', Lz((0, 4), p1)), ('-18', Lz((0, 3), p1)), ('-36', Lz((0, 4), p1) + Lz((0, -2), p2)),
            ('36', 2 * 3 * 6), ('-12', Lz((0, -2), p2)),
            ('%s' % fmt(vp_d, 3), vp), ('%s' % miles(round(h)), h), ('%s' % fmt(round(va, 3), 3), va),
            ('%s' % fmt(v3_d, 3), v3), ('%s' % fmt(g3_d, 2), g3), ('%s' % fmt(round(r3c), 0), r3c),
            ('%s' % fmt(round(r3c - RT), 0), r3c - RT), ('%s' % fmt(round(vc, 3), 3), vc),
            ('1,35 times 10^12', J), ('%s' % fmt(round((vc - va) * 1000), 0), (vc - va) * 1000),
            # aclaracion del punto 4: energia fija a, no e
            ('= %s$ km y' % fmt(round(a), 0), a),
            ('= %s$ km²/s²; la' % fmt(round(-MU / (2 * a), 2), 2), -MU / (2 * a)),
            ('= %s$ km²/s², mayor' % fmt(round(-MU / (2 * ra), 2), 2), -MU / (2 * ra)),
            ('$e = %s$' % fmt(e30, 2), e30), ('$%s$ km del centro' % fmt(round(rp30), 0), rp30),
            ('= %s$ km/s, la rapidez' % fmt(round(m.sqrt(MU / a), 3), 3), m.sqrt(MU / a)),
            ('= %s°$ (muy' % fmt(round(g_b, 2), 2), g_b),
            ('%s' % fmt(round(Irot * 1e5, 1), 1), Irot * 1e5), ('%s' % fmt(round(w, 1), 1), w),
            ('%s' % fmt(round(Lg, 4), 4), Lg), ('%s' % fmt(round(tq, 3), 3), tq),
            ('%s' % fmt(round(Om, 2), 2), Om), ('%s' % fmt(round(2 * m.pi / Om, 2), 2), 2 * m.pi / Om),
            ('%s' % fmt(round(0.200 * 9.8, 2), 2), 0.200 * 9.8),
            ('%s' % fmt(round(m.sqrt(2) * Lg, 4), 4), m.sqrt(2) * Lg),
        ],
        'modelo': [
            ('%s' % fmt(round(v1, 3), 3), v1), ('%s' % fmt(round(vtp, 3), 3), vtp),
            ('%s' % fmt(round(vta, 3), 3), vta), ('%s' % fmt(round(v2, 3), 3), v2),
            ('%s' % fmt(round(vtp - v1, 3), 3), vtp - v1), ('%s' % fmt(round(v2 - vta, 3), 3), v2 - vta),
            ('%s' % fmt(round(dv, 3), 3), dv), ('%s' % fmt(round(ve, 3), 3), ve),
            ('%s' % miles(round(m0)), m0), ('%s' % miles(round(m0 - 1500)), m0 - 1500),
            ('%s' % fmt(round(tt / 3600, 2), 2), tt / 3600), ('%s' % miles(round(m_tras_1)), m_tras_1),
            ('%s' % miles(round(at)), at),
            ('%s' % miles(round(hh)), hh), ('%s' % fmt(round(eps, 3), 3), eps), ('%s' % miles(round(aa)), aa),
            ('%s' % fmt(round(ee, 4), 4), ee), ('%s' % fmt(round(nu, 1), 1), nu),
            ('%s' % miles(round(rpp)), rpp), ('%s' % miles(round(raa)), raa),
            ('%s' % miles(round(rpp - RT)), rpp - RT), ('%s' % miles(round(raa - RT)), raa - RT),
            ('%s' % fmt(round(T2 / 60, 1), 1), T2 / 60),
            ('%s' % fmt(round(ec, 4), 4), ec), ('%s' % fmt(round(es, 4), 4), es),
            ('I_z = %d' % Iz3, Iz3), ('I_x = %d' % Ix3, Ix3), ('%s' % fmt(round(H3, 1), 1), H3),
            ('%s' % fmt(round(th, 2), 2), th), ('%s' % fmt(round(wx, 4), 4), wx), ('%s' % fmt(round(thw, 2), 2), thw),
            ('%s' % fmt(round(phid, 3), 3), phid), ('%s' % fmt(round(psid, 3), 3), psid),
            ('%s' % fmt(round(T1 - T0, 2), 2), T1 - T0),
            ('%s' % fmt(round(I0, 2), 2), I0), ('%s' % fmt(round(w0, 3), 3), w0), ('%s' % fmt(round(w1, 3), 3), w1),
            ('%s' % fmt(round(w1 * 60 / (2 * m.pi), 1), 1), w1 * 60 / (2 * m.pi)),
            ('%s' % fmt(round(K0, 1), 1), K0), ('%s' % fmt(round(K1, 1), 1), K1),
            ('%s' % fmt(round(100 * (1 - K1 / K0), 1), 1), 100 * (1 - K1 / K0)),
            ('%s' % fmt(round(Jc, 1), 1), Jc),
        ],
    }


PARCIALES_NUEVOS = ('modelo-parcial-1.typ', 'modelo-parcial-2.typ', 'modelo-parcial-3.typ')


def c_modelos():
    """Modelos de parcial 1, 2 y 3 (2026-09-29). Cada texto empieza con el
    numero que se compara: valor_de() toma el PRIMERO del texto."""
    G = 6.674e-11
    # ------------------------------------------------------------ modelo 1
    r = RT + 300; v0 = m.sqrt(MU / r); v4 = v0 + 0.060; v3 = v0 - 0.030
    a4 = 1 / (2 / r - v4 ** 2 / MU); a3 = 1 / (2 / r - v3 ** 2 / MU)
    mr = 400 * 200 / 600
    vr = 300 * G0; F = 200 * vr; ideal = vr * m.log(5); Vb = ideal - G0 * 80
    F2 = 60 * vr; Md = F2 / G0; tesp = (20000 - Md) / 60; Vb2 = vr * m.log(Md / 4000) - G0 * (16000 / 60 - tesp)
    muS = MU * 1e9; r1, r2 = (RT + 300) * 1e3, 26560e3
    E1, E2, E0 = -muS * 2000 / (2 * r1), -muS * 2000 / (2 * r2), -muS * 2000 / (RT * 1e3)
    rr, vv, gg = 8000.0, 7.5, rad(10)
    h4 = rr * vv * m.cos(gg); eps4 = vv ** 2 / 2 - MU / rr; aa4 = -MU / (2 * eps4)
    ec4 = h4 ** 2 / (MU * rr) - 1; es4 = vv * m.sin(gg) * h4 / MU; e4 = m.hypot(ec4, es4)
    rp4, ra4 = aa4 * (1 - e4), aa4 * (1 + e4)
    at5 = (6678 + 26560) / 2; vpt5 = m.sqrt(MU * (2 / 6678 - 1 / at5)); vat5 = m.sqrt(MU * (2 / 26560 - 1 / at5))
    d1, d2 = vpt5 - v0, m.sqrt(MU / 26560) - vat5; ve5 = 310 * G0 / 1000
    m05 = 2000 * m.exp((d1 + d2) / ve5); mm5 = 2000 * m.exp(d2 / ve5)
    wrel = 2000 * 2 * m.pi / 60; ws = 0.06 * wrel / 150.06; ww = wrel - ws
    rampa = deg(0.5 * ws * 10)
    # ------------------------------------------------------------ modelo 2
    vf = (1200 / 4000, 300 / 4000); K1 = 0.5 * 4000 * (vf[0] ** 2 + vf[1] ** 2)
    v1 = 2500 * m.log(2.5) - G0 * 60
    yi1 = 2500 * (60 - 40 * m.log(2.5)); y1 = yi1 - 0.5 * G0 * 3600
    v2 = v1 + 3000 * m.log(3) - G0 * 100
    yi2 = 3000 * (100 - 50 * m.log(3)); y2 = y1 + v1 * 100 + yi2 - 0.5 * G0 * 1e4
    rb = RT + y2 / 1000; rmax = 1 / (1 / rb - (v2 / 1000) ** 2 / (2 * MU))
    muL = 0.01230 * MU; rmL = 1 / (1 / 1740 - 4 / (2 * muL)); gL = muL / 1740 ** 2 * 1000
    rp, ra = RT + 600, RT + 20000.0; e24 = (ra - rp) / (ra + rp); a24 = (ra + rp) / 2
    h24 = m.sqrt(2 * MU * rp * ra / (rp + ra)); p24 = h24 ** 2 / MU
    nu24 = m.acos((p24 / 13000 - 1) / e24); vr24 = MU / h24 * e24 * m.sin(nu24); vp24 = h24 / 13000
    rp5, ra5 = RT + 300, RT + 3000.0
    vp5 = m.sqrt(2 * MU * ra5 / (rp5 * (rp5 + ra5))); va5 = vp5 * rp5 / ra5
    ep5, ea5 = m.sqrt(2 * MU / rp5), m.sqrt(2 * MU / ra5); ve2 = 300 * G0 / 1000
    Ir = 2.4 * 0.35 ** 2; Lr = Ir * 30
    # ------------------------------------------------------------ modelo 3
    vB = (20 * m.cos(rad(120)), 20 * m.sin(rad(120)))
    vC = (-(600 + 30 * vB[0]) / 50, -(30 * vB[1]) / 50)
    vl = lambda t: -60 + 3000 * m.log(4000 / (4000 - 5 * t)) - 1.62 * t
    lo, hi = 0.0, 100.0
    for _ in range(100):
        md = (lo + hi) / 2
        lo, hi = (md, hi) if vl(md) < 0 else (lo, md)
    ts = lo; Ms = 4000 - 5 * ts
    yint = 3000 * (ts - Ms / 5 * m.log(4000 / Ms)); ys = 2000 - 60 * ts + yint - 0.5 * 1.62 * ts ** 2
    MT = 4 * m.pi ** 2 * 3.844e8 ** 3 / (G * (27.32 * 86400) ** 2)
    Ts = 23.934 * 3600; rg = (MU * Ts ** 2 / (4 * m.pi ** 2)) ** (1 / 3)
    r1b, r2b = RT + 900, RT + 4500.0
    eb = (r2b - r1b) / (r1b * m.cos(rad(45)) - r2b * m.cos(rad(150))); pb = r1b * (1 + eb * m.cos(rad(45)))
    ab = pb / (1 - eb ** 2); hb = m.sqrt(MU * pb); vpb = hb / r1b; vrb = MU / hb * eb * m.sin(rad(45))
    q1, q2 = RT + 250, RT + 420.0; aq = (q1 + q2) / 2
    vq1, vq2 = m.sqrt(MU / q1), m.sqrt(MU / q2)
    vqp, vqa = m.sqrt(MU * (2 / q1 - 1 / aq)), m.sqrt(MU * (2 / q2 - 1 / aq))
    tq = m.pi * m.sqrt(aq ** 3 / MU); T1q, T2q = 2 * m.pi * m.sqrt(q1 ** 3 / MU), 2 * m.pi * m.sqrt(q2 ** 3 / MU)
    fase = 180 - 360 * tq / T2q; rel = 360 / (T1q / 60) - 360 / (T2q / 60)
    Ig = 2.0 * 0.025 ** 2; Lg = Ig * 19200 * 2 * m.pi / 60; Omg = rad(1e-6) / 18000
    return {
        'modelo-parcial-1.typ': [
            ('7,726', v0), ('7,786', v4), ('7,696', v3), ('90$ m/s: la', (v4 - v3) * 1000),
            ('540 thin 000', 0.5 * mr * 90 ** 2), ('1,791 times 10^(10)', 0.5 * 600 * (v0 * 1000) ** 2),
            ('133,3', mr), ('6784', a4), ('6890', 2 * a4 - r), ('512$ km de altura', 2 * a4 - r - RT),
            ('6627', a3), ('6575', 2 * a3 - r), ('197$ km de altura', 2 * a3 - r - RT),
            ('0,0156', (r * v4) ** 2 / (MU * r) - 1), ('0,00775', 1 - (r * v3) ** 2 / (MU * r)),
            ('2943', vr), ('588,6', F / 1000), ('196,2', 20000 * G0 / 1000), ('19,62', F / 20000 - G0),
            ('137,3', F / 4000 - G0), ('4737', ideal), ('3952', Vb), ('784,8', G0 * 80),
            ('16,6', 100 * G0 * 80 / ideal), ('176,6', F2 / 1000), ('18 thin 000$ kg: después', Md),
            ('33,3$ s. Desde', tesp), ('266,7', 16000 / 60), ('233,3', 16000 / 60 - tesp), ('2137', Vb2),
            ('2600$ m/s', ideal - Vb2),
            ('-59,69', E1 / 1e9), ('-15,01', E2 / 1e9), ('44,68', (E2 - E1) / 1e9), ('-125,0', E0 / 1e9),
            ('110,0', (E2 - E0) / 1e9), ('-30,02', 2 * E2 / 1e9), ('+89,36', 2 * (E2 - E1) / 1e9),
            ('-119,38', 2 * E1 / 1e9), ('9,746', m.sqrt(2 * MU * (1 / RT - 1 / 26560))),
            ('11,18', m.sqrt(2 * MU / RT)), ('3,874', m.sqrt(MU / 26560)),
            ('7,386', vv * m.cos(gg)), ('1,302', vv * m.sin(gg)), ('59 thin 088', h4), ('-21,70', eps4),
            ('9184', aa4), ('0,0949', ec4), ('0,1931', es4), ('0,2151', e4), ('63,8', deg(m.atan2(es4, ec4))),
            ('7209', rp4), ('831$ km', rp4 - RT), ('11 thin 160', ra4), ('4782', ra4 - RT),
            ('8,197', h4 / rp4), ('5,295', h4 / ra4), ('146,0', 2 * m.pi * m.sqrt(aa4 ** 3 / MU) / 60),
            ('29 thin 544', h4 / 2),
            ('16 thin 619', at5), ('9,767', vpt5), ('2,456', vat5), ('2,041', d1), ('1,418', d2),
            ('3,459', d1 + d2), ('3,041', ve5), ('6238', m05), ('4238', m05 - 2000), ('3188', mm5),
            ('3050', m05 - mm5), ('1188', mm5 - 2000), ('2,96', m.pi * m.sqrt(at5 ** 3 / MU) / 3600),
            ('209,4', wrel), ('-0,08374', -ws), ('4,798', deg(ws)), ('209,36', ww), ('1,256', 0.06 * ww / 10),
            ('+12,56', 0.06 * ww), ('24,0°', rampa), ('42,0°', 90 - 2 * rampa),
            ('8,76', (90 - 2 * rampa) / deg(ws)), ('0,53 + 1315', 0.5 * 150 * ws ** 2),
            ('1315 "J"', 0.5 * 150 * ws ** 2 + 0.5 * 0.06 * ww ** 2), ('-0,08378', -0.06 * wrel / 150),
            ('0,04$ %', 100 * (0.06 * wrel / 150 - ws) / ws),
        ],
        'modelo-parcial-2.typ': [
            ('0,300 "m/s"', vf[0]), ('0,075 "m/s"', vf[1]), ('0,3092', m.hypot(*vf)),
            ('14,04', deg(m.atan2(vf[1], vf[0]))), ('285$ J', 285.0), ('191,3', K1), ('93,75', 285 - K1),
            ('32,9', 100 * (285 - K1) / 285), ('750$ kg', 750.0), ('375$ N·s', m.hypot(300, 225)), ('250$ N', 375 / 1.5),
            ('750 thin 000 "N"', 300 * 2500), ('294,3', 30000 * G0 / 1000), ('15,19', 750000 / 30000 - G0),
            ('52,69', 750000 / 12000 - G0), ('2290,7', 2500 * m.log(2.5)), ('1702$ m/s', v1),
            ('58 thin 371', yi1), ('17 thin 658', 0.5 * G0 * 3600), ('40 thin 713', y1),
            ('10,19', 180000 / 9000 - G0), ('3295,8', 3000 * m.log(3)), ('4017', v2),
            ('170 thin 213', v1 * 100), ('135 thin 208', yi2), ('49 thin 050', 0.5 * G0 * 1e4), ('297 thin 084', y2),
            ('2801', v1 + 3000 * m.log(2) - G0 * 100), ('1216', 3000 * m.log(1.5)),
            ('822,4', v2 ** 2 / (2 * G0) / 1000), ('1120$ km', (y2 + v2 ** 2 / (2 * G0)) / 1000),
            ('7718', rmax), ('1340', rmax - RT), ('8,95', MU / rb ** 2 * 1000),
            ('220$ km', rmax - RT - (y2 + v2 ** 2 / (2 * G0)) / 1000), ('2315', 3000 * m.log(3) - G0 * 100),
            ('4903', muL), ('1,619', gL), ('2,374', m.sqrt(2 * muL / 1740)), ('5996', rmL), ('4256', rmL - 1740),
            ('1235', 4e6 / (2 * gL) / 1000), ('0,136', muL / rmL ** 2 * 1000),
            ('3,4$ veces', (rmL - 1740) / (4e6 / (2 * gL) / 1000)), ('1,087', m.sqrt(4 - muL / 1740)),
            ('6978', rp), ('26 thin 378', ra), ('0,5816', e24), ('16 thin 678', a24),
            ('5,954', 2 * m.pi * m.sqrt(a24 ** 3 / MU) / 3600), ('-11,95', -MU / (2 * a24)), ('66 thin 326', h24),
            ('9,505', h24 / rp), ('2,514', h24 / ra), ('11 thin 036', p24), ('105,1', deg(nu24)),
            ('5,102', vp24), ('3,375', vr24), ('6,117', m.hypot(vp24, vr24)), ('33,5', deg(m.atan2(vr24, vp24))),
            ('33 thin 163', h24 / 2),
            ('8,350', vp5), ('5,946', va5), ('10,926', ep5), ('2,576', ep5 - vp5), ('9,220', ea5),
            ('3,274', ea5 - va5), ('24,83', MU / (rp5 + ra5)), ('2,943', ve2),
            ('583$ kg', 1000 * (1 - m.exp(-(ep5 - vp5) / ve2))), ('671$ kg', 1000 * (1 - m.exp(-(ea5 - va5) / ve2))),
            ('6,519', m.sqrt(MU / ra5)), ('0,573', m.sqrt(MU / ra5) - va5),
            ('0,294', Ir), ('8,82', Lr), ('17,64', 2 * Lr), ('2,94 "rad/s"', 2 * Lr / 6),
            ('28,1', 2 * Lr / 6 * 60 / (2 * m.pi)), ('132,3', 0.5 * Ir * 900),
            ('158,2', 0.5 * Ir * 900 + 0.5 * 6 * (2 * Lr / 6) ** 2), ('25,93', 0.5 * 6 * (2 * Lr / 6) ** 2),
            ('22,05', 2 * Lr / 0.8), ('1,47', Lr / 6),
        ],
        'modelo-parcial-3.typ': [
            ('17,32', vB[1]), ('-6,00', vC[0]), ('-10,39', vC[1]), ('12,0$ m/s', m.hypot(*vC)),
            ('240°', deg(m.atan2(vC[1], vC[0])) % 360),
            ('18 thin 600', 0.5 * 20 * 900 + 0.5 * 30 * 400 + 0.5 * 50 * (vC[0] ** 2 + vC[1] ** 2)),
            ('173,2', 10 * vB[1]), ('-103,9', 10 * vC[1]),
            ('15 thin 000', 5 * 3000), ('6480', 4000 * 1.62), ('2,13$ m/s', 15000 / 4000 - 1.62),
            ('-0,74', vl(27)), ('+1,52', vl(28)), ('27,33', ts), ('3863', Ms), ('136,6', 5 * ts),
            ('1639,7', 60 * ts), ('1416,5', yint), ('604,9', 0.5 * 1.62 * ts ** 2), ('1172', ys),
            ('828', 2000 - ys), ('28,17', 60 / 2.13), ('845', 60 ** 2 / (2 * 2.13)),
            ('3,4$ %', 100 * 5 * ts / 4000), ('0,0348', m.log(4000 / Ms)),
            ('6,40', 2000 * 8.0 / 2500), ('64,0', 0.5 * 2000 * 8000 ** 2 / 1e9), ('51,2', 0.5 * 2500 * 6400 ** 2 / 1e9),
            ('12,8', (0.5 * 2000 * 8000 ** 2 - 0.5 * 2500 * 6400 ** 2) / 1e9),
            ('140,6', (2000 * 1e6 + 0.5 * 5e-4 * 1e12) / (2000 * 8000)), ('32$ kN', 5e-4 * 8000 ** 2 / 1000),
            ('6,030 times 10^24', MT), ('5,979 times 10^24', G0 * (RT * 1e3) ** 2 / G), ('86 thin 162', Ts),
            ('42 thin 164', rg), ('35 thin 786', rg - RT), ('3,075', m.sqrt(MU / rg)),
            ('42 thin 241', (MU * 86400 ** 2 / (4 * m.pi ** 2)) ** (1 / 3)),
            ('77$ km', (MU * 86400 ** 2 / (4 * m.pi ** 2)) ** (1 / 3) - rg), ('57,77', MU / RT - MU / (2 * rg)),
            ('0,465', 2 * m.pi * RT / Ts), ('0,108', 0.5 * (2 * m.pi * RT / Ts) ** 2),
            ('42 thin 300', 384400 * (Ts / (27.32 * 86400)) ** (2 / 3)),
            ('7278', r1b), ('10 thin 878', r2b), ('0,2471', eb), ('8550', pb), ('6856', pb / (1 + eb)),
            ('478$ km', pb / (1 + eb) - RT), ('11 thin 356', pb / (1 - eb)), ('4978', pb / (1 - eb) - RT),
            ('9106', ab), ('144,1', 2 * m.pi * m.sqrt(ab ** 3 / MU) / 60), ('58 thin 378', hb),
            ('8,021', vpb), ('1,193', vrb), ('8,109', m.hypot(vpb, vrb)), ('8,46', deg(m.atan2(vrb, vpb))),
            ('8,515', hb / (pb / (1 + eb))),
            ('7,755', vq1), ('7,804', vqp), ('7,609', vqa), ('7,657', vq2), ('48,9', (vqp - vq1) * 1000),
            ('48,6', (vq2 - vqa) * 1000), ('97,6', (vqp - vq1 + vq2 - vqa) * 1000), ('45,6', tq / 60),
            ('92,97', T2q / 60), ('176,6', 360 * tq / T2q), ('3,37', fase), ('89,50', T1q / 60),
            ('0,1499', rel), ('244$ min', (40 - fase) / rel), ('4,07', (40 - fase) / rel / 60),
            ('39,9', (360 - (fase - 2)) / rel / 60), ('40,0$ h', 360 / rel / 60),
            ('1,25 times 10^(-3)', Ig), ('2011', 19200 * 2 * m.pi / 60), ('2,513', Lg),
            ('9,70 times 10^(-13)', Omg), ('2,44 times 10^(-12)', Lg * Omg), ('22,56', 2.3 * 9.81),
            ('0,9025', 0.04 * 2.3 * 9.81), ('0,3591', 0.04 * 2.3 * 9.81 / Lg),
            ('17,5$ s', 2 * m.pi * Lg / (0.04 * 2.3 * 9.81)), ('1,745 times 10^(-8)', rad(1e-6)),
        ],
    }


def fmt(x, dec):
    s = ('%.' + str(dec) + 'f') % x
    return s.replace('.', ',')


def miles(n):
    s = str(int(n))
    neg = s.startswith('-')
    s = s.lstrip('-')
    if len(s) > 4:
        partes = []
        while s:
            partes.insert(0, s[-3:]); s = s[:-3]
        s = ' thin '.join(partes)
    return ('-' if neg else '') + s


# ---------------------------------------------------------------- lectura
NUM = re.compile(r'(-?\d+(?: thin \d{3})*(?:,\d+)?)(?: times 10\^\(?(-?\d+)\)?)?')


def valor_de(texto):
    """El primer numero del texto mostrado, como float."""
    t = texto.replace('−', '-')
    for mt in NUM.finditer(t):
        base = float(mt.group(1).replace(' thin ', '').replace(',', '.'))
        if mt.group(2):
            base *= 10 ** int(mt.group(2))
        return base, mt.group(1)
    return None, None


def coincide(mostrado, calc):
    v, crudo = valor_de(mostrado)
    if v is None:
        return False, 'no hay numero en "%s"' % mostrado
    dec = len(crudo.split(',')[1]) if ',' in crudo else 0
    if 'times 10^' in mostrado:
        # mantisa: tolerancia de su ultima cifra, escalada
        exp = int(re.search(r'times 10\^\(?(-?\d+)', mostrado).group(1))
        unidad = 10 ** (exp - dec)
    else:
        unidad = 10 ** (-dec)
    tol = max(0.51 * unidad, 0.002 * abs(v))
    return abs(abs(v) - abs(calc)) <= tol and (v == 0 or calc == 0 or (v > 0) == (calc > 0) or abs(calc) < tol), \
        'impreso %s, cuenta %.6g' % (crudo, calc)


def main():
    ruta = sys.argv[sys.argv.index('--toml') + 1] if '--toml' in sys.argv else os.path.join(AQUI, 'ejercicios.toml')
    mostrar = '--mostrar' in sys.argv
    datos = tomllib.load(io.open(ruta, 'rb'))
    rojos = []
    ejs = {e['id']: e for e in datos['ej']}

    # 1. estructura
    for e in datos['ej']:
        for campo in ('titulo', 'tip', 'resultado', 'recortes', 'seccion'):
            if not e.get(campo):
                rojos.append('%s: falta "%s"' % (e['id'], campo))
        tip = e.get('tip', '')
        # una oracion: ningun punto seguido de espacio y mayuscula adentro
        if re.search(r'\.\s+[A-ZÁÉÍÓÚ¿]', tip.strip().rstrip('.')):
            rojos.append('%s: el tip tiene mas de una oracion' % e['id'])
        for k in range(len(e.get('recortes', []))):
            f = os.path.join(AQUI, 'recortes', '%s-%d.pdf' % (e['id'], k + 1))
            if not os.path.exists(f):
                rojos.append('%s: falta el recorte %s (correr recortar.py)' % (e['id'], os.path.basename(f)))

    # 2 y 3. numeros y cobertura
    controles = {}
    for fn in (c_vec, c_cm, c_ma, c_grav, c_cr):
        controles.update(fn())
    extra = {k: controles.pop(k) for k in list(controles) if k.startswith('_')}
    if extra['_vec3_signo'] >= 0:
        rojos.append('vec-3: A x D deberia salir en -z')
    n_ok = 0
    for id_, lista in controles.items():
        if id_ not in ejs:
            rojos.append('control para "%s", que no existe en el toml' % id_)
            continue
        res = ejs[id_]['resultado']
        for mostrado, calc in lista:
            if mostrado.startswith('_'):
                continue
            if mostrado not in res:
                rojos.append('%s: "%s" no esta en el resultado' % (id_, mostrado))
                continue
            if calc is None:
                n_ok += 1
                continue
            ok, det = coincide(mostrado, calc)
            if mostrar:
                print('  %-8s %-24s %s' % (id_, mostrado, det))
            if ok:
                n_ok += 1
            else:
                rojos.append('%s: %s' % (id_, det))
    # vec-13 y vec-15: los vectores exactos
    if tuple(extra['_vec13']) != (2, -15, 3):
        rojos.append('vec-13: A x B no da (2, -15, 3)')
    esperado15 = (14, (3, -47, 2), (39, -15, -60), (-3, -65, -2), (-120, 8, -80), (28, 0, -42))
    if tuple(extra['_vec15']) != esperado15:
        rojos.append('vec-15: los productos no dan lo impreso: %s' % (extra['_vec15'],))
    for id_ in ejs:
        if id_ not in controles and id_ not in SIN_NUMERO:
            rojos.append('%s: sin controles numericos y sin motivo en SIN_NUMERO' % id_)

    # parciales
    cuentas = dict(c_parciales())
    cuentas.update(c_modelos())
    for clave, archivo in (('parcialito', 'parcialito-momento-angular.typ'), ('modelo', 'modelo-parcial-integrador.typ'),
                           *((a, a) for a in PARCIALES_NUEVOS)):
        f = os.path.join(AQUI, archivo)
        if not os.path.exists(f):
            rojos.append('falta %s' % archivo)
            continue
        texto = io.open(f, encoding='utf-8').read()
        for mostrado, calc in cuentas[clave]:
            if mostrar:
                print('  %-10s %-24s %.6g' % (clave, mostrado, calc))
            if mostrado not in texto:
                rojos.append('%s: "%s" no esta en el documento' % (archivo, mostrado))
                continue
            ok, det = coincide(mostrado, calc)
            if ok:
                n_ok += 1
            else:
                rojos.append('%s: %s' % (archivo, det))

    # 4. terminologia
    textos = [('toml:' + e['id'], e.get(c, '')) for e in datos['ej'] for c in ('tip', 'resultado', 'nota', 'titulo')]
    textos += [('toml:seccion ' + s['id'], s['bajada']) for s in datos['seccion']]
    for archivo in ('guia.typ', 'parcialito-momento-angular.typ', 'modelo-parcial-integrador.typ', *PARCIALES_NUEVOS):
        f = os.path.join(AQUI, archivo)
        if os.path.exists(f):
            for i, parr in enumerate(io.open(f, encoding='utf-8').read().split('\n\n')):
                textos.append(('%s parrafo %d' % (archivo, i + 1), parr))
    for donde, t in textos:
        tl = ' '.join(t.lower().split())   # un salto de linea no separa palabras
        if 'impulso angular' in tl:
            # Solo cuenta como aclaracion lo que NOMBRA la diferencia: el
            # momento angular, la integral del torque o Delta L. Hasta el
            # saboteador tambien valia 'r) times' (por r x F dt), y dejaba
            # pasar "el impulso angular L" en un tip que derivaba r x p.
            permitido = ('momento angular' in tl or 'integral' in tl
                         or 'delta bold(l)' in tl or 'delta bold(h)' in tl)
            if not permitido:
                rojos.append('terminologia: "impulso angular" sin aclarar en %s' % donde)

    print('controles numericos en verde: %d' % n_ok)
    if rojos:
        for r in rojos:
            print('  [ROJO] ' + r)
        print('RESULTADO: %d problema(s).' % len(rojos))
        sys.exit(1)
    print('RESULTADO: todo en verde.')


if __name__ == '__main__':
    main()
