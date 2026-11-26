"""Cuentas de los dos modelos del 2.o parcial (2026-11-25): modelo-2do-parcial-a.typ y
modelo-2do-parcial-b.typ. Cada numero sale por DOS caminos (assert) y CONTROLES_A / CONTROLES_B
llevan, con el formato de validar.py, el texto literal del .typ que EMPIEZA con el numero tal como
se imprime.

    python cuentas_2do_parcial.py            # corre las cuentas y mide los CONTROLES contra los .typ
    python cuentas_2do_parcial.py --mostrar  # ademas imprime cada valor

Mismo molde que cuentas_extras.py: validar.py importa este archivo (no al reves).
"""
import io
import math as m
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
deg, rad = m.degrees, m.radians
RPM = 60 / (2 * m.pi)
G0 = 9.81
T_SID = 86164.1   # dia sideral, s


def norm(v):
    return m.sqrt(sum(x * x for x in v))


def cruz(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def suma(a, b):
    return tuple(x + y for x, y in zip(a, b))


def cerca(a, b, rel=1e-9):
    return abs(a - b) <= rel * max(1.0, abs(a), abs(b))


# =====================================================================
#  MODELO A
# =====================================================================
# --- A1: la sonda alargada y el pulso mal alineado --------------------
mA, kaA, ktA = 900.0, 0.80, 1.20
IA, IpA = mA * kaA ** 2, mA * ktA ** 2            # 576 y 1296 kg m^2 (alargada: I < I')
w0A = 0.50                                         # rad/s, alrededor de z
H0A = (0.0, 0.0, IA * w0A)                         # 288
rAA = (0.0, 0.80, 1.50)
JA = (80.0, 0.0, 0.0)                              # N s, en +x (400 N durante 0,20 s)
dHA = cruz(rAA, JA)                                # (0, 120, -64)
HA = suma(H0A, dHA)                                # (0, 120, 224)
HnA = norm(HA)
thA = m.atan2(HA[1], HA[2])
wA = (HA[0] / IpA, HA[1] / IpA, HA[2] / IA)
wnA = norm(wA)
gaA = m.atan2(wA[1], wA[2])
assert cerca(m.tan(gaA), IA / IpA * m.tan(thA))                    # camino 2 de gamma
fiA = HnA / IpA                                                    # precesion
psA = wA[2] - fiA * m.cos(thA)                                     # spin
assert cerca(psA, (IpA - IA) / (IA * IpA) * HA[2])                 # camino 2: (I'-I)/(I I') H cos(theta)
assert cerca(fiA, wnA * m.sin(gaA) / m.sin(thA))                   # camino 3: ley de los senos (directa)
assert cerca(psA, wnA * m.sin(thA - gaA) / m.sin(thA))
assert thA > gaA                                                   # directa
dvA = JA[0] / mA
T0A = 0.5 * IA * w0A ** 2
T1rA = 0.5 * (IpA * wA[1] ** 2 + IA * wA[2] ** 2)
T1tA = 0.5 * mA * dvA ** 2
# camino 2 de la energia: trabajo del pulso = J . (v_A antes + v_A despues) / 2
vA0 = cruz((0.0, 0.0, w0A), rAA)
vA1 = suma((dvA, 0.0, 0.0), cruz(wA, rAA))
WA = JA[0] * (vA0[0] + vA1[0]) / 2
assert cerca(WA, T1rA + T1tA - T0A)
perA = 2 * m.pi / w0A                                              # periodo de giro antes del pulso

# --- A2: el giroscopo en cardanes, precesion estable ------------------
fpA2, thA2, ppA2 = 2.0, rad(60), 50.0
I2, Ip2 = 2.0e-3, 1.0e-3
wA2 = (-fpA2 * m.sin(thA2), 0.0, ppA2 + fpA2 * m.cos(thA2))
OmA2 = (-fpA2 * m.sin(thA2), 0.0, fpA2 * m.cos(thA2))
HA2 = (Ip2 * wA2[0], Ip2 * wA2[1], I2 * wA2[2])
MA2 = cruz(OmA2, HA2)                                              # sum M = Omega x H (dH/dt relativa = 0)
assert cerca(MA2[1], (I2 * wA2[2] - Ip2 * fpA2 * m.cos(thA2)) * fpA2 * m.sin(thA2))  # Beer 18.44
assert abs(MA2[0]) < 1e-15 and abs(MA2[2]) < 1e-15

# --- A3: la Tierra libre (periodo de Euler) ---------------------------
lamA3 = 1 / 305                                                    # (I - I')/I', dato
wzA3 = 2 * m.pi / T_SID
TeA3 = 2 * m.pi / (lamA3 * wzA3)
assert cerca(TeA3 / T_SID, 305)
TeA3_dias = TeA3 / 86400
chandler = 433.0
desfA3 = 100 * (chandler / TeA3_dias - 1)

# --- A extra: CMG de un cardan ----------------------------------------
IrA, nA = 0.010, 6000.0
hA = IrA * nA / RPM
ddA = 1.0
tauA = hA * ddA
alfa_ruedaA = tauA / IrA                                           # lo que tendria que acelerar una rueda
IsatA = 400.0
alfa_satA = tauA / IsatA
assert cerca(alfa_ruedaA, ddA * nA / RPM)

# =====================================================================
#  MODELO B
# =====================================================================
# --- B1: el meteorito sobre el satelite achatado ----------------------
mB, kaB, ktB = 600.0, 1.00, 0.80
IB, IpB = mB * kaB ** 2, mB * ktB ** 2            # 600 y 384 (achatado: I > I')
w0B = 1.50
H0B = (0.0, 0.0, IB * w0B)                         # 900
mmet, vmet = 0.30, 2000.0
pB = (0.0, 0.0, -mmet * vmet)                      # -600 k
rCB = (0.0, 1.00, 0.40)
dHB = cruz(rCB, pB)                                # (-600, 0, 0)
HB = suma(H0B, dHB)
HnB = norm(HB)
thB = m.atan2(-HB[0], HB[2])                       # medido desde z, hacia -x
wB = (HB[0] / IpB, HB[1] / IpB, HB[2] / IB)
wnB = norm(wB)
gaB = m.atan2(-wB[0], wB[2])
assert cerca(m.tan(gaB), IB / IpB * m.tan(thB))
assert gaB > thB                                                   # retrograda
fiB = HnB / IpB
psB = wB[2] - fiB * m.cos(thB)
assert cerca(psB, (IpB - IB) / (IB * IpB) * HB[2])
assert psB < 0
assert cerca(fiB, wnB * m.sin(gaB) / m.sin(thB))                   # ley de los senos (retrograda)
assert cerca(-psB, wnB * m.sin(gaB - thB) / m.sin(thB))
dvB = mmet * vmet / mB
T0B = 0.5 * IB * w0B ** 2
T1rB = 0.5 * (IpB * wB[0] ** 2 + IB * wB[2] ** 2)
assert cerca(T1rB, 0.5 * (HB[0] ** 2 / IpB + HB[2] ** 2 / IB))
T1tB = 0.5 * mB * dvB ** 2
KmetB = 0.5 * mmet * vmet ** 2
fracB = 100 * (T1rB + T1tB - T0B) / KmetB
corrG = mmet / mB * norm(rCB) * 1000                               # mm que se corre G

# --- B2: el disco torcido en su eje -----------------------------------
mD, rD, beD, nD, LD = 3.0, 0.12, rad(5), 1200.0, 0.40
ID, IpD = 0.5 * mD * rD ** 2, 0.25 * mD * rD ** 2
wD = nD / RPM
Hn_ = ID * wD * m.cos(beD)                 # sobre la normal del disco
Hd_ = IpD * wD * m.sin(beD)                # sobre el diametro
H_par = Hn_ * m.cos(beD) + Hd_ * m.sin(beD)         # sobre omega
H_perp = Hn_ * m.sin(beD) - Hd_ * m.cos(beD)        # perpendicular a omega
assert cerca(H_perp, (ID - IpD) * wD * m.sin(beD) * m.cos(beD))
HnD = m.hypot(Hn_, Hd_)
angHD = deg(m.atan2(H_perp, H_par))                 # angulo entre H_G y omega
angHn = deg(beD) - angHD                            # angulo entre H_G y el eje del disco
assert cerca(m.tan(beD - rad(angHD)), (IpD / ID) * m.tan(beD))
MD = wD * H_perp                                    # |omega x H|
FD = MD / LD
WD = mD * G0

# --- B3: el trompo en precesion estable -------------------------------
mT, cT, IT, IpT, thT, psT = 0.30, 0.040, 1.2e-4, 6.0e-4, rad(60), 150.0
WcT = mT * G0 * cT
aT = (IT - IpT) * m.cos(thT)          # coeficiente de phidot^2
bT = IT * psT
disc = bT ** 2 + 4 * aT * WcT          # a phi^2 + b phi - Wc = 0
f_lenta = (-bT + m.sqrt(disc)) / (2 * aT)
f_rapida = (-bT - m.sqrt(disc)) / (2 * aT)
for f in (f_lenta, f_rapida):
    wz = psT + f * m.cos(thT)
    assert cerca((IT * wz - IpT * f * m.cos(thT)) * f * m.sin(thT), WcT * m.sin(thT))   # Beer 18.44
f_aprox = WcT / (IT * psT)
err_aprox = 100 * (f_lenta / f_aprox - 1)
ps_min = m.sqrt(4 * (IpT - IT) * m.cos(thT) * WcT) / IT
f_90 = WcT / (IT * psT)               # theta = 90: exacta

# --- B extra: el CMG que reorienta el satelite --------------------------
hB_, ddB, IsB, deB = 20.0, 0.30, 500.0, rad(30)
tauB = hB_ * ddB
alfaB = tauB / IsB
wy_B = hB_ * m.sin(deB) / IsB            # lo que gana el satelite sobre el eje de maniobra
wx_B = hB_ * (1 - m.cos(deB)) / IsB      # la fuga sobre el eje del rotor
wsatB_max = hB_ / IsB                    # delta = 90: saturacion
# camino 2: integrando la cupla h deltadot cos(delta) en el tiempo
pasos = 20000
tB = deB / ddB
wy2 = sum(hB_ * ddB * m.cos(ddB * (i + 0.5) * tB / pasos) * tB / pasos for i in range(pasos)) / IsB
assert abs(wy2 - wy_B) < 1e-8

# =====================================================================
#  CONTROLES: el texto literal del .typ (empieza con el numero) y su cuenta
# =====================================================================
CONTROLES_A = [
    # A1
    ('576$ kg·m² (axial)', IA), ('1296$ kg·m² (transversal)', IpA), ('288 hat(k)$ kg·m²/s', H0A[2]),
    ('12,6$ s', perA), ('120; -64)', dHA[1]), ('-64) " kg·m²/s"', dHA[2]), ('224) " kg·m²/s"', HA[2]),
    ('254,1 " kg·m²/s"', HnA), ('0,536$, así que', m.tan(thA)), ('28,2 degree$.', deg(thA)),
    ('0,0926 " rad/s"', wA[1]), ('0,389 " rad/s"', wA[2]), ('0,400$ rad/s, y', wnA),
    ('0,238$: $gamma = 13,4', m.tan(gaA)), ('13,4 degree$.', deg(gaA)), ('14,8 degree$ (lo barre', deg(thA - gaA)),
    ('0,196 " rad/s", quad', fiA), ('0,216 " rad/s". $', psA), ('32,0$ s.', 2 * m.pi / fiA),
    ('0,0889$ m/s sobre', dvA), ('72,0$ J. Después', T0A), ('49,1$ J de rotación', T1rA),
    ('3,56$ J de traslación', T1tA), ('52,7 J: *perdió*', T1rA + T1tA), ('19,3 J. ¿Cómo', -WA),
    ('-0,40 hat(i)$ m/s', vA0[0]), ('-19,3$ J, con', WA), ('-0,0833 hat(i)$ m/s', vA1[0]),
    # A2
    ('-1,732$ rad/s,', wA2[0]), ('51,0$ rad/s. El', wA2[2]),
    ('-1,73 times 10^(-3); 0; 0,102)$ kg·m²/s. Casi', HA2[0]), ('0,102)$ kg·m²/s. Casi', HA2[2]),
    ('0,175 hat(j) " N·m"', MA2[1]), ('0,175$ N·m. Coincide', MA2[1]),
    # A3
    ('2,628\ntimes', TeA3 / 1e7), ('304 días', TeA3_dias), ('42 % más largo', desfA3),
    # extra
    ('6,28$ N·m·s, sobre', hA), ('628$ rad/s², pasar', alfa_ruedaA), ('0,0157$ rad/s².', alfa_satA),
]
CONTROLES_B = [
    # B1
    ('600$ kg·m² (axial)', IB), ('384$ kg·m²', IpB), ('900 hat(k)$ kg·m²/s', H0B[2]), ('-600 hat(k)$ kg·m/s', pB[2]),
    ('0,05$ % de la', 100 * mmet / mB), ('0,54$ mm', corrG), ('-600; 0; 0) " kg·m²/s"', dHB[0]),
    ('1081,7 " kg·m²/s"', HnB), ('0,667$: $theta = 33,7', -HB[0] / HB[2]), ('33,7 degree$, del lado', deg(thB)),
    ('-1,5625 " rad/s"', wB[0]), ('1,50 " rad/s", $', wB[2]), ('2,166$ rad/s y', wnB),
    ('1,042$: $gamma = 46,2', m.tan(gaB)), ('46,2 degree$. La', deg(gaB)), ('12,5 degree$; el corporal', deg(gaB - thB)),
    ('2,817 " rad/s",', fiB), ('0,844 " rad/s". $', -psB), ('-0,844$ rad/s: el satélite', psB),
    ('-1,0 hat(k)$ m/s', -dvB), ('675$ J a', T0B), ('1143,75$ J, más', T1rB), ('300 J de traslación', T1tB),
    ('600 thin 000$ J', KmetB), ('0,128 %', fracB), ('1,0 m/s hacia', dvB),
    # B2
    ('0,0216$ kg·m²) y', ID), ('0,0108$ kg·m²)', IpD), ('125,7$ rad/s, y', wD), ('2,704 thin hat(n)', Hn_),
    ('0,1183 thin hat(d)', Hd_), ('0,1178$ kg·m²/s, y', H_perp), ('2,50 degree$ (la mitad', angHD),
    ('14,8$ N·m. Esa', MD), ('37,0$ N cada una', FD), ('29,4$ N: con', WD),
    # B3
    ('0,1177$ N·m;', WcT), ('2,4 times 10^(-4)$;', -aT), ('0,018$. Las raíces', bT),
    ('7,24 " rad/s" quad', f_lenta), ('67,8 " rad/s". $', f_rapida), ('6,54$ rad/s: la lenta', f_aprox),
    ('10,7 % más grande', err_aprox), ('88,6$ rad/s.', ps_min), ('6,54 rad/s con este spin', f_90),
    # extra
    ('-6,0 hat(j)$ N·m', -tauB), ('0,012$ rad/s².', alfaB), ('-2,68; 10,0; 0)$ N·m·s', hB_ * (m.cos(deB) - 1)),
    ('10,0; 0)$ N·m·s', hB_ * m.sin(deB)), ('-0,0200 " rad/s", quad', -wy_B), ('0,00536 " rad/s". $', wx_B),
    ('0,040$ rad/s. Ahí', wsatB_max),
]


def _medir(nombre, controles):
    texto = io.open(os.path.join(AQUI, nombre), encoding='utf-8').read()
    sys.path.insert(0, AQUI)
    from validar import coincide
    rojos = 0
    for mostrado, calc in controles:
        if mostrado not in texto:
            print('  [ROJO] %s: "%s" no esta' % (nombre, mostrado)); rojos += 1; continue
        ok, det = coincide(mostrado, calc)
        if '--mostrar' in sys.argv:
            print('  %-40s %s' % (mostrado, det))
        if not ok:
            print('  [ROJO] %s: %s' % (nombre, det)); rojos += 1
    return rojos


if __name__ == '__main__':
    if '--valores' in sys.argv:
        for k, v in sorted(globals().items()):
            if not k.startswith('_') and isinstance(v, (int, float, tuple)) and k not in ('AQUI',):
                print('%-12s %s' % (k, v))
        sys.exit(0)
    r = _medir('modelo-2do-parcial-a.typ', CONTROLES_A) + _medir('modelo-2do-parcial-b.typ', CONTROLES_B)
    print('controles: %d, rojos: %d' % (len(CONTROLES_A) + len(CONTROLES_B), r))
    sys.exit(1 if r else 0)
