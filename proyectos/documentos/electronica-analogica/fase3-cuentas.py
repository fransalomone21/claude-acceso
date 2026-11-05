# -*- coding: utf-8 -*-
"""fase3-cuentas.py -- los numeros de los modulos 16, 17 y 18, por DOS caminos.

Fase 3 del PDP (los temas que faltan del programa de Teoria de Circuitos). La
fase exige que cada ejercicio resuelto tenga su resultado comprobado por un
segundo camino independiente. Este script es ese segundo camino, corrido:

  - camino 1: la formula cerrada que el apunte escribe (la que el lector usa);
  - camino 2: otra cosa que no comparte la cuenta (integracion numerica de la
    ecuacion diferencial, raices del polinomio, barrido en frecuencia, analisis
    nodal resuelto como sistema lineal, balance de potencia);
  - y PUBLICADO: el numero tal como esta TIPEADO en el .typ, comparado contra el
    camino 1 con la tolerancia de su redondeo. Sin esto, un numero mal copiado
    al apunte pasa con los dos caminos en verde (leccion de teoria-circuitos,
    2026-10-23: "un numero publicado sin control propio puede estar mal").

Uso (desde electronica-analogica/):
    python fase3-cuentas.py             # todos los controles; exit 1 si alguno da rojo
    python fase3-cuentas.py --sabotaje  # cambia UN dato del camino 1 de cada ejercicio
                                        # y exige ROJO en ese ejercicio (y que lo diga)

Necesita numpy y scipy.
"""

import math
import sys

import numpy as np
from scipy.integrate import solve_ivp
from scipy import signal

TOL = 1e-3          # entre los dos caminos: relativo
SAB = "--sabotaje" in sys.argv
resultados = []     # (ejercicio, nombre, ok, detalle)


def ctrl(ej, nombre, a, b, tol=TOL):
    """Dos caminos para el mismo numero."""
    ok = abs(a - b) <= tol * max(abs(a), abs(b), 1e-12)
    resultados.append((ej, nombre, ok, "%.6g vs %.6g" % (a, b)))
    return ok


def pub(ej, nombre, valor, publicado, decimales):
    """El numero tipeado en el apunte, contra el calculado, con su redondeo."""
    ok = abs(valor - publicado) <= 0.5 * 10 ** (-decimales) + 1e-12
    resultados.append((ej, "publicado " + nombre, ok, "calc %.6g, apunte %s" % (valor, publicado)))
    return ok


# ------------------------------------------------------------------ 16.1
def ej_16_1(sab=False):
    """RLC serie, escalon de 12 V, condiciones iniciales nulas. Laplace."""
    E = "16.1"
    V, R, L, C = 12.0, 6.0, 1.0, 0.125
    # camino 1: I(s) = V/(L s^2 + R s + 1/C) = 12/((s+2)(s+4)); fracciones parciales
    Rf = R + (1.0 if sab else 0.0)          # sabotaje: el dato que usa la formula
    a1 = Rf / L
    b1 = 1.0 / (L * C)
    disc = math.sqrt(a1 * a1 / 4 - b1)
    p1, p2 = -a1 / 2 + disc, -a1 / 2 - disc  # -2 y -4
    K1 = (V / L) / (p1 - p2)
    K2 = (V / L) / (p2 - p1)
    i = lambda t: K1 * math.exp(p1 * t) + K2 * math.exp(p2 * t)
    # vC(s) = I(s)/(sC): residuos en 0, p1, p2
    r0 = (V / (L * C)) / (p1 * p2)
    rp1 = (V / (L * C)) / (p1 * (p1 - p2))
    rp2 = (V / (L * C)) / (p2 * (p2 - p1))
    vc = lambda t: r0 + rp1 * math.exp(p1 * t) + rp2 * math.exp(p2 * t)
    tmax = math.log(p2 / p1) / (p1 - p2)
    # camino 2: integrar la ecuacion diferencial en el tiempo (sin Laplace)
    def f(t, y):
        il, v = y
        return [(V - R * il - v) / L, il / C]
    sol = solve_ivp(f, (0, 3), [0.0, 0.0], rtol=1e-10, atol=1e-12, dense_output=True)
    for t in (0.1, 0.3466, 1.0, 2.0):
        ctrl(E, "i(%g)" % t, i(t), sol.sol(t)[0])
        ctrl(E, "vC(%g)" % t, vc(t), sol.sol(t)[1])
    ts = np.linspace(0, 3, 30001)
    k = np.argmax(sol.sol(ts)[0])
    ctrl(E, "t de la corriente maxima", tmax, ts[k], tol=2e-3)
    ctrl(E, "corriente maxima", i(tmax), sol.sol(ts)[0][k])
    pub(E, "p1", p1, -2, 0)
    pub(E, "p2", p2, -4, 0)
    pub(E, "K1", K1, 6, 0)
    pub(E, "K2", K2, -6, 0)
    pub(E, "residuo vC en 0", r0, 12, 0)
    pub(E, "residuo vC en -2", rp1, -24, 0)
    pub(E, "residuo vC en -4", rp2, 12, 0)
    pub(E, "tmax", tmax, 0.347, 3)
    pub(E, "imax", i(tmax), 1.5, 2)


# ------------------------------------------------------------------ 16.2
def ej_16_2(sab=False):
    """RLC serie, salida en C: polos, zeta, Q, sobrepico."""
    E = "16.2"
    R, L, C = 100.0, 10e-3, 1e-6
    Rf = R * (1.1 if sab else 1.0)
    w0 = 1 / math.sqrt(L * C)
    alfa = Rf / (2 * L)
    zeta = alfa / w0
    Q = 1 / (2 * zeta)
    wd = w0 * math.sqrt(1 - zeta ** 2)
    theta = math.degrees(math.acos(zeta))
    sp = math.exp(-math.pi * zeta / math.sqrt(1 - zeta ** 2))
    # camino 2: raices del polinomio, y la respuesta al escalon simulada
    raices = np.roots([1, R / L, 1 / (L * C)])
    p = raices[np.argmax(raices.imag)]
    ctrl(E, "parte real del polo", -alfa, p.real)
    ctrl(E, "parte imaginaria del polo", wd, p.imag)
    ctrl(E, "|p| = w0", w0, abs(p))
    ctrl(E, "zeta = cos(theta)", zeta, -p.real / abs(p))
    sis = signal.lti([1 / (L * C)], [1, R / L, 1 / (L * C)])
    t, y = signal.step(sis, T=np.linspace(0, 2e-3, 200001))
    ctrl(E, "sobrepico", sp, y.max() - 1, tol=2e-3)
    pub(E, "w0", w0, 10000, 0)
    pub(E, "alfa", alfa, 5000, 0)
    pub(E, "zeta", zeta, 0.5, 2)
    pub(E, "Q", Q, 1, 2)
    pub(E, "wd", wd, 8660, 0)
    pub(E, "theta", theta, 60, 0)
    pub(E, "sobrepico %", 100 * sp, 16.3, 1)


# ------------------------------------------------------------------ 16.3
def ej_16_3(sab=False):
    """El mismo RLC serie con R = 20: tres salidas, el pico de H_C."""
    E = "16.3"
    R, L, C = 20.0, 10e-3, 1e-6
    w0 = 1 / math.sqrt(L * C)
    Q = w0 * L / (R * (1.05 if sab else 1.0))
    wpico = w0 * math.sqrt(1 - 1 / (2 * Q * Q))
    hpico = Q / math.sqrt(1 - 1 / (4 * Q * Q))
    wpico_l = w0 / math.sqrt(1 - 1 / (2 * Q * Q))
    bw = R / L
    # camino 2: barrido numerico de las tres transferencias
    w = np.linspace(5000, 15000, 2000001)
    s = 1j * w
    D = s * s + (R / L) * s + 1 / (L * C)
    HC = np.abs((1 / (L * C)) / D)
    HL = np.abs(s * s / D)
    HR = np.abs((R / L) * s / D)
    ctrl(E, "w del pico de H_C", wpico, w[np.argmax(HC)])
    ctrl(E, "valor del pico de H_C", hpico, HC.max())
    ctrl(E, "w del pico de H_L", wpico_l, w[np.argmax(HL)])
    ctrl(E, "valor del pico de H_L", hpico, HL.max())
    i0 = np.argmin(abs(w - w0))
    ctrl(E, "|H_C(w0)| = Q", Q, HC[i0])
    ctrl(E, "|H_L(w0)| = Q", Q, HL[i0])
    ctrl(E, "|H_R(w0)| = 1", 1.0, HR[i0])
    arriba = w[HR >= 1 / math.sqrt(2)]
    ctrl(E, "ancho de banda de H_R", bw, arriba.max() - arriba.min(), tol=2e-3)
    pub(E, "Q", Q, 5, 2)
    pub(E, "w pico C", wpico, 9899, 0)
    pub(E, "f pico C", wpico / (2 * math.pi), 1576, 0)
    pub(E, "H pico", hpico, 5.025, 3)
    pub(E, "w pico L", wpico_l, 10102, 0)
    pub(E, "BW", bw, 2000, 0)


# ------------------------------------------------------------------ 17.1
def sk_nodal(s, R1, R2, C1, C2):
    """Sallen-Key de ganancia unitaria por nodos: vin=1, incognitas vA, vB (vo = vB)."""
    A = np.array([[1 / R1 + 1 / R2 + s * C1, -1 / R2 - s * C1],
                  [-1 / R2, 1 / R2 + s * C2]], dtype=complex)
    b = np.array([1 / R1, 0], dtype=complex)
    vA, vB = np.linalg.solve(A, b)
    return vB


def ej_17_1(sab=False):
    """Butterworth de orden 3 por plantilla, con un RC + seguidor y un Sallen-Key."""
    E = "17.1"
    fp, Amax, fs, Amin = 1000.0, 3.0, 5000.0, 40.0
    n_real = math.log10((10 ** (0.1 * Amin) - 1) / (10 ** (0.1 * Amax) - 1)) / (2 * math.log10(fs / fp))
    n = math.ceil(n_real)
    wc = 2 * math.pi * fp
    C = 10e-9
    R_rc = 1 / (wc * C)
    C2 = 10e-9
    C1 = 4 * C2
    R_sk = 1 / (wc * math.sqrt(C1 * C2)) * (1.05 if sab else 1.0)
    Q_sk = 0.5 * math.sqrt(C1 / C2)
    at = lambda f: 10 * math.log10(1 + (f / fp) ** (2 * n))   # Butterworth ideal, dB

    # camino 2: el circuito con los valores elegidos, resuelto por nodos
    def h_circ(f):
        s = 2j * math.pi * f
        h1 = 1 / (1 + s * R_rc * C)
        return h1 * sk_nodal(s, R_sk, R_sk, C1, C2)
    for f in (500.0, 1000.0, 2000.0, 5000.0):
        ctrl(E, "atenuacion en %g Hz" % f, at(f), -20 * math.log10(abs(h_circ(f))), tol=2e-3)
    # los polos del circuito sobre la circunferencia de radio wc
    den = np.polymul([R_rc * C, 1], [R_sk * R_sk * C1 * C2, R_sk * C2 * 2, 1])
    for p in np.roots(den):
        ctrl(E, "polo sobre la circunferencia", wc, abs(p))
    pub(E, "n calculado", n_real, 2.86, 2)
    pub(E, "R del RC (kohm)", R_rc / 1e3, 15.92, 2)
    pub(E, "R del Sallen-Key (kohm)", R_sk / 1e3, 7.96, 2)
    pub(E, "Q del Sallen-Key", Q_sk, 1.0, 1)
    pub(E, "atenuacion en 5 kHz", at(5000), 41.9, 1)
    pub(E, "atenuacion en 1 kHz", at(1000), 3.0, 1)


# ------------------------------------------------------------------ 17.2
def restador_nodal(v1, v2, R1, R2, R1p, R2p):
    """Restador con operacional ideal, por nodos: vp por divisor, LKC en el nodo inversor."""
    vp = v2 * R2p / (R1p + R2p)
    # (vp - v1)/R1 + (vp - vo)/R2 = 0
    return vp + R2 * (vp - v1) / R1


def instrumentacion_nodal(v1, v2, R3, RG, R4, R5, R5p):
    """Tres operacionales ideales: primera etapa resuelta como sistema lineal."""
    # incognitas: vs1, vs2 (salidas de la primera etapa). Las patas inversoras valen v1 y v2.
    # nodo inversor del AO1 (v1): (v1 - vs1)/R3 + (v1 - v2)/RG = 0
    # nodo inversor del AO2 (v2): (v2 - vs2)/R3 + (v2 - v1)/RG = 0
    A = np.array([[-1 / R3, 0], [0, -1 / R3]])
    b = np.array([-(v1 / R3 + (v1 - v2) / RG), -(v2 / R3 + (v2 - v1) / RG)])
    vs1, vs2 = np.linalg.solve(A, b)
    return restador_nodal(vs1, vs2, R4, R5, R4, R5p)


def ej_17_2(sab=False):
    """Restador con un resistor desapareado 1 %: modo comun y CMRR; y el de instrumentacion."""
    E = "17.2"
    R1 = R1p = 10e3
    R2 = 100e3
    R2p = 101e3
    R2f = R2p * (1.01 if sab else 1.0)
    k = R2f / (R1p + R2f)
    Acm = k * (1 + R2 / R1) - R2 / R1
    Ad = 0.5 * (k * (1 + R2 / R1) + R2 / R1)
    cmrr = Ad / Acm
    aprox = (1 + R2 / R1) / 0.01
    # camino 2: el circuito por nodos, con v1 = v2 = 1 V (modo comun puro) y con vd = 1 V
    acm2 = restador_nodal(1, 1, R1, R2, R1p, R2p)
    ad2 = restador_nodal(-0.5, 0.5, R1, R2, R1p, R2p)
    ctrl(E, "Acm", Acm, acm2)
    ctrl(E, "Ad", Ad, ad2)
    ctrl(E, "CMRR aproximado (1+Ad)/eps", cmrr, aprox, tol=0.02)
    # instrumentacion: primera etapa con ganancia 10, la misma resta desapareada
    R3, RG = 4.5e3, 1e3
    g1 = 1 + 2 * R3 / RG
    acm_i = instrumentacion_nodal(1, 1, R3, RG, R1, R2, R2p)
    ad_i = instrumentacion_nodal(-0.5, 0.5, R3, RG, R1, R2, R2p)
    ctrl(E, "instrumentacion: Acm no cambia", Acm, acm_i)
    ctrl(E, "instrumentacion: Ad = G1 * Ad", g1 * Ad, ad_i)
    pub(E, "k", k, 0.9099, 4)
    pub(E, "Acm", Acm, 0.0090, 4)
    pub(E, "Ad", Ad, 10.005, 3)
    pub(E, "CMRR", cmrr, 1110, -1)
    pub(E, "CMRR dB", 20 * math.log10(cmrr), 60.9, 1)
    pub(E, "G1", g1, 10, 0)
    pub(E, "CMRR instrumentacion dB", 20 * math.log10(ad_i / acm_i), 80.9, 1)


# ------------------------------------------------------------------ 18.1
def ej_18_1(sab=False):
    """Carga trifasica equilibrada 8 + j6 en estrella y en triangulo, red 3 x 380 V."""
    E = "18.1"
    VL = 380.0
    Z = complex(8, 6)
    a = complex(math.cos(2 * math.pi / 3), math.sin(2 * math.pi / 3))
    Vf = VL / math.sqrt(3) * (1.02 if sab else 1.0)
    If = Vf / abs(Z)
    cos_t = Z.real / abs(Z)
    P_y = math.sqrt(3) * VL * If * cos_t
    Q_y = math.sqrt(3) * VL * If * math.sqrt(1 - cos_t ** 2)
    # camino 2: las tres fases con fasores, I^2 R sumado, y el neutro
    Van = VL / math.sqrt(3)
    Vs = [Van, Van * a.conjugate(), Van * a]          # secuencia abc: 0, -120, +120
    Is = [v / Z for v in Vs]
    ctrl(E, "estrella: corriente de linea", If, abs(Is[0]))
    ctrl(E, "estrella: P por I^2 R", P_y, sum(abs(i) ** 2 * Z.real for i in Is))
    ctrl(E, "estrella: Q por I^2 X", Q_y, sum(abs(i) ** 2 * Z.imag for i in Is))
    ctrl(E, "estrella: |Vab| = sqrt(3) Vf", VL, abs(Vs[0] - Vs[1]))
    resultados.append((E, "estrella: corriente de neutro = 0", abs(sum(Is)) < 1e-9, "%.2e A" % abs(sum(Is))))
    # triangulo: la misma Z entre lineas
    Ifd = VL / abs(Z)
    ILd = math.sqrt(3) * Ifd
    P_d = math.sqrt(3) * VL * ILd * cos_t
    Vab, Vbc, Vca = Vs[0] - Vs[1], Vs[1] - Vs[2], Vs[2] - Vs[0]
    Iab, Ibc, Ica = Vab / Z, Vbc / Z, Vca / Z
    Ia = Iab - Ica
    ctrl(E, "triangulo: corriente de linea", ILd, abs(Ia))
    ctrl(E, "triangulo: P por I^2 R", P_d, sum(abs(i) ** 2 * Z.real for i in (Iab, Ibc, Ica)))
    ctrl(E, "triangulo: el triple de potencia", 3 * P_y, P_d)
    ang = math.degrees(math.atan2(Ia.imag, Ia.real)) - math.degrees(math.atan2(Iab.imag, Iab.real))
    ctrl(E, "triangulo: Ia atrasa 30 grados de Iab", -30.0, ang)
    pub(E, "Vf", Vf, 219.4, 1)
    pub(E, "I estrella", If, 21.94, 2)
    pub(E, "P estrella", P_y, 11552, 0)
    pub(E, "Q estrella", Q_y, 8664, 0)
    pub(E, "S estrella", math.sqrt(3) * VL * If, 14440, 0)
    pub(E, "I fase triangulo", Ifd, 38.0, 1)
    pub(E, "I linea triangulo", ILd, 65.82, 2)
    pub(E, "P triangulo", P_d, 34656, 0)


# ------------------------------------------------------------------ 18.2
def ej_18_2(sab=False):
    """Parlante de 8 ohm en un amplificador de 800 ohm: transformador de adaptacion."""
    E = "18.2"
    Vth, Rth, RL = 10.0, 800.0, 8.0
    a = math.sqrt(Rth / RL) * (1.03 if sab else 1.0)
    Zin = a * a * RL
    P_directo = RL * (Vth / (Rth + RL)) ** 2
    P_trafo = Vth ** 2 * Zin / (Rth + Zin) ** 2
    # camino 2: las ecuaciones del transformador ideal resueltas como sistema
    # incognitas: I1, V1, V2, I2.  Vth = Rth I1 + V1;  V1 = a V2;  I2 = a I1;  V2 = RL I2
    ar = math.sqrt(Rth / RL)
    A = np.array([[Rth, 1, 0, 0], [0, 1, -ar, 0], [-ar, 0, 0, 1], [0, 0, 1, -RL]])
    I1, V1, V2, I2 = np.linalg.solve(A, np.array([Vth, 0, 0, 0]))
    ctrl(E, "P en el parlante", P_trafo, V2 ** 2 / RL)
    ctrl(E, "Zin = V1/I1", Zin, V1 / I1)
    ctrl(E, "la potencia entra entera (ideal)", V1 * I1, V2 * I2)
    pub(E, "a", a, 10, 0)
    pub(E, "P directo (mW)", 1000 * P_directo, 1.23, 2)
    pub(E, "P con trafo (mW)", 1000 * P_trafo, 31.25, 2)
    pub(E, "mejora", P_trafo / P_directo, 25.5, 1)
    # equivalentes serie y paralelo de la bobina real (Rs = 10, Xs = 100)
    Rs, Xs = 10.0, 100.0
    Rp = (Rs ** 2 + Xs ** 2) / Rs
    Xp = (Rs ** 2 + Xs ** 2) / Xs
    Y = 1 / complex(Rs, Xs)
    ctrl(E, "Rp = 1/G", Rp, 1 / Y.real)
    ctrl(E, "Xp = -1/B", Xp, -1 / Y.imag)
    ctrl(E, "Q serie = Q paralelo", Xs / Rs, Rp / Xp)
    pub(E, "Rp", Rp, 1010, 0)
    pub(E, "Xp", Xp, 101, 0)


EJERCICIOS = [ej_16_1, ej_16_2, ej_16_3, ej_17_1, ej_17_2, ej_18_1, ej_18_2]


def correr(sab_de=None):
    resultados.clear()
    for ej in EJERCICIOS:
        ej(sab=(ej is sab_de))
    return list(resultados)


if not SAB:
    res = correr()
    malos = [r for r in res if not r[2]]
    for e, n, ok, d in res:
        print("[%s] %-5s %-45s %s" % ("OK" if ok else "ROJO", e, n, d))
    print("\n%d controles, %d en rojo" % (len(res), len(malos)))
    sys.exit(1 if malos else 0)
else:
    fallas = 0
    for ej in EJERCICIOS:
        res = correr(sab_de=ej)
        nombre = ej.__name__.replace("ej_", "").replace("_", ".")
        rojos = [r for r in res if not r[2]]
        propios = [r for r in rojos if r[0] == nombre]
        ajenos = [r for r in rojos if r[0] != nombre]
        if propios and not ajenos:
            print("[ROJO OK] sabotaje de %s -> %d rojo(s), p. ej. '%s'" % (nombre, len(propios), propios[0][1]))
        else:
            fallas += 1
            print("[FALLA] sabotaje de %s: %d rojos propios, %d ajenos" % (nombre, len(propios), len(ajenos)))
    sana = [r for r in correr() if not r[2]]
    print("control positivo (sin sabotaje): %s" % ("verde" if not sana else "%d en rojo" % len(sana)))
    sys.exit(1 if fallas or sana else 0)
