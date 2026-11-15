"""Cuentas de resueltos-cr-extras.typ: los ejercicios de cuerpo rigido que se vieron en la materia
y NO estan en la guia (E1 a E6). Cada numero sale por DOS caminos (assert) y CONTROLES lleva, con
el formato de validar.py, el texto literal del .typ que empieza con el numero tal como se imprime.

    python cuentas_extras.py            # corre las cuentas y mide CONTROLES contra el .typ
    python cuentas_extras.py --mostrar  # ademas imprime cada valor

validar.py (de la sesion principal) suma CONTROLES; este archivo NO importa validar.py arriba
(validar.py lo importa a el): la medicion propia de abajo lo importa recien en __main__.
"""
import io
import math as m
import os
import sys

AQUI = os.path.dirname(os.path.abspath(__file__))
deg, rad = m.degrees, m.radians
RPM = 60 / (2 * m.pi)           # rad/s -> rpm
G0 = 9.81
DIA = 86400.0
T_SID = 86164.1                 # dia sideral, s (la Tierra respecto de las estrellas)


def norm(v):
    return m.sqrt(sum(x * x for x in v))


def cruz(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def punto(a, b):
    return sum(x * y for x, y in zip(a, b))


def cerca(a, b, rel=1e-9):
    return abs(a - b) <= rel * max(1.0, abs(a), abs(b))


def senos(w, th, ga):
    """Ley de los senos del Beer (§18.11): precesion y spin desde omega, theta y gamma."""
    return w * m.sin(ga) / m.sin(th), w * m.sin(th - ga) / m.sin(th)


# ---------------------------------------------------------------- E1: Beer PR 18.6
# Satelite de dos discos (m/2 cada uno, radio a), barra de 2a; meteorito m0 = m/1000 a v0 = 2000
# m/s paralelo a +z que se incrusta en C, con r_C = -a j (- a k, que no aporta: es paralelo a v0).
a1, mm1, v1, w01 = 0.8, 1.0, 2000.0, 60 / RPM
m01 = mm1 / 1000
I1, Ip1 = 0.5 * mm1 * a1 ** 2, 2 * (0.25 * mm1 / 2 * a1 ** 2 + mm1 / 2 * a1 ** 2)
H1 = tuple(p + q for p, q in zip(cruz((0, -a1, -a1), (0, 0, m01 * v1)), (0, 0, I1 * w01)))
w1 = (H1[0] / Ip1, H1[1] / Ip1, H1[2] / I1)
assert cerca(Ip1, 1.25 * mm1 * a1 ** 2) and cerca(w1[0], -0.8 * (m01 / mm1) * v1 / a1)   # Beer ec. (2)
wm1 = norm(w1)
ga1 = m.atan2(m.hypot(w1[0], w1[1]), w1[2])
th1 = m.atan2(m.hypot(H1[0], H1[1]), H1[2])
assert cerca(m.tan(th1), Ip1 / I1 * m.tan(ga1))                        # tan theta = (I'/I) tan gamma
fi1, ps1 = senos(wm1, th1, ga1)
assert cerca(fi1, norm(H1) / Ip1)                                     # camino 2: phidot = H/I'
assert cerca(ps1, (Ip1 - I1) / Ip1 * w1[2])                           # camino 2: psidot = (I'-I)/I' w_z
assert cerca(fi1 * m.cos(th1) + ps1, w1[2])                           # camino 3: w_z = psidot + phidot cos
fi1_libro, ps1_libro = senos(63.0, rad(38.5), rad(17.7))              # el libro, con angulos redondeados
assert H1[0] < 0                                                      # (-a j) x (m0 v0 k) = -m0 v0 a i
# ¿y si C estuviera en +a j? el eje de precesion se espeja hacia +x; theta y las velocidades, iguales
H1e = tuple(p + q for p, q in zip(cruz((0, a1, -a1), (0, 0, m01 * v1)), (0, 0, I1 * w01)))
assert H1e[0] > 0 and cerca(norm(H1e), norm(H1))

# ---------------------------------------------------------------- E2: Beer 18.127 (cuaderno de Anibal)
g2 = 32.2
ms2, mt2 = 800 / g2, 6 / 16 / g2
kx2, ky2 = 28.8 / 12, 32.4 / 12
I2, Ip2 = ms2 * ky2 ** 2, ms2 * kx2 ** 2              # axial (y) y transversal (x, z)
rB2, v02 = (42 / 12, -20 / 12, 0.0), (-1600.0, 1300.0, 4000.0)
Hsat2 = (0.0, I2 * 1.5, 0.0)
Hmet2 = tuple(mt2 * c for c in cruz(rB2, v02))
H2 = tuple(p + q for p, q in zip(Hsat2, Hmet2))
Hn2 = norm(H2)
w2 = (H2[0] / Ip2, H2[1] / I2, H2[2] / Ip2)
wn2 = norm(w2)
th2 = m.acos(H2[1] / Hn2)
ga2 = m.acos(w2[1] / wn2)
assert cerca(m.tan(ga2), I2 / Ip2 * m.tan(th2))                       # camino 2 de gamma (el del cuaderno)
fi2, ps2 = senos(wn2, th2, ga2)
assert cerca(fi2, Hn2 / Ip2)
assert cerca(ps2, (Ip2 - I2) / Ip2 * w2[1])
assert cerca(fi2 * m.cos(th2) + ps2, w2[1])
# el cuaderno de Anibal imprime estos numeros: los mismos, por su camino
assert abs(fi2 - 0.9455629858956991) < 1e-9 and abs(ps2 + 0.15932034465020548) < 1e-9
assert abs(wn2 - 0.8231570557458172) < 1e-9 and abs(deg(th2) - 36.599990409947246) < 1e-9
eje2 = [deg(m.acos(c / Hn2)) for c in H2]                             # angulos del eje de precesion
v0n2 = norm(v02)
assert cerca(v0n2, 4500.0)

# ---------------------------------------------------------------- E3: la Tierra, Beer 18.117 y 18.123
rho3, R3, eps3 = 5510.0, 6.37e6, rad(23.45)
M3 = rho3 * 4 / 3 * m.pi * R3 ** 3
I3 = 0.4 * M3 * R3 ** 2
w3 = 2 * m.pi / T_SID                                                 # spin respecto de las estrellas
ANIO = 365.25 * DIA
fi3 = 2 * m.pi / (25800 * ANIO)
Mc3 = I3 * w3 * fi3 * m.sin(eps3)                                     # camino 1: |dH/dt| = H sin(theta) phidot
Mc3_b = fi3 * m.sin(eps3) * (I3 * w3 - I3 * fi3 * m.cos(eps3))       # camino 2: ec. 18.44 entera (I' ~ I)
assert abs(Mc3 - Mc3_b) / Mc3 < 1e-6                                  # el segundo termino no pesa
Mc3_solar = I3 * (2 * m.pi / DIA) * fi3 * m.sin(eps3)                # con el dia solar de 24 h
H3 = I3 * w3
# sentido: eje inclinado eps hacia +X, cupla que achica eps (Sol tirando del abultamiento)
Hv3 = (m.sin(eps3), 0.0, m.cos(eps3))
Mdir3 = (0.0, -1.0, 0.0)                                              # (-Y) x X = +K: lleva H hacia K
assert cruz(Mdir3, (1, 0, 0))[2] > 0
# dH = M dt sobre -Y: la proyeccion horizontal de H va de +X hacia -Y: horario visto desde +K
assert cruz((1, 0, 0), Mdir3)[2] < 0                                  # X x (-Y) = -K: giro horario
# 18.123: precesion libre, vista desde la Tierra
Ip3 = 0.99671                                                         # I'/I del enunciado
lam3 = (1 - Ip3) / Ip3                                                # (I - I')/I'
Tlib3 = 2 * m.pi / (lam3 * w3) / DIA                                  # camino 1: n = (I-I')/I' w_z
Tlib3_b = Ip3 / (1 - Ip3) * T_SID / DIA                               # camino 2: I'/(I-I') vueltas de la Tierra
assert cerca(Tlib3, Tlib3_b)
Tlib3_solar = Ip3 / (1 - Ip3)                                         # con la vuelta de 1 dia solar
# en el espacio: el eje de figura gira alrededor de H con phidot = H/I' ~ (I/I') w (Beer 18.119)
Tesp3 = 2 * m.pi / (w3 / Ip3) / 3600                                  # horas
# Euler en el cuerpo: dw_perp/dt = lam w_z (k x w_perp): mismo sentido que el spin si lam > 0
wperp = (1.0, 0.0, 0.0)
dw = tuple(lam3 * w3 * c for c in cruz((0, 0, 1), wperp))
assert dw[1] > 0                                                      # de +x hacia +y: antihorario, progrado
obs3 = 432.5
exc3 = (obs3 / Tlib3 - 1) * 100
anios_vs_dias = 25800 * 365.25 / Tlib3

# ---------------------------------------------------------------- E4: satelite GEO con el spin a la Tierra
I4, I04 = 550.0, 225.0
p4 = 2 * m.pi / 60
Om4 = 2 * m.pi / DIA
Hz4 = -I4 * p4                                                        # H = I0 Om j - I p k
MG4 = cruz((0, Om4, 0), (0, I04 * Om4, Hz4))                          # Omega j x H
assert MG4[1] == 0 and MG4[2] == 0 and MG4[0] < 0                     # sobre -x
MGn4 = abs(MG4[0])
MGn4_b = Om4 * m.sin(rad(90)) * (I4 * p4 - I04 * Om4 * m.cos(rad(90)))   # ec. 18.44 con theta = 90
assert cerca(MGn4, MGn4_b, 1e-12)
Ip4 = I4 * p4
imp4 = MGn4 * DIA                                                     # impulso angular por dia
assert cerca(imp4, 2 * m.pi * Ip4)                                    # camino 2: girar 360 grados I p
prop4_dia = imp4 / 1.0 / (220 * G0)                                   # brazo 1 m, Isp 220 s
prop4_anio = prop4_dia * 365.25
prop4_15 = prop4_anio * 15
dip4 = MGn4 / 1e-7                                                    # B ~ 100 nT
gg4 = 3 * Om4 ** 2 * (I4 - I04)
srp4 = MGn4 / 1e-5
# con H sobre la normal a la orbita (rueda de momento), Omega j x H j = 0
assert cruz((0, Om4, 0), (0, 57.6, 0)) == (0.0, 0.0, 0.0)

# ---------------------------------------------------------------- E5: coning impulsivo (Martz, TN D-8452)
R25, Phf5 = 0.1309, 0.3327
sth5 = m.sin(R25 / 2) / m.sin(Phf5 / 2)
th5 = m.asin(sth5)
assert cerca(m.sin(th5) * m.sin(Phf5 / 2), m.sin(R25 / 2))
Ip5, I5 = 100.0, 60.0                                                 # transversal y axial (Beer)
dpsi5 = Phf5 * m.cos(th5) * (Ip5 / I5 - 1)
# camino 2: integrar psidot = (I'-I)/I' w_z con w_z = H cos(th)/I y Phidot = H/I'; con H = 1
Hx5 = 1.0
tf5 = Phf5 * Ip5 / Hx5
assert cerca(dpsi5, (Hx5 * m.cos(th5) / I5) * (Ip5 - I5) / Ip5 * tf5)
psf5 = dpsi5
suma5 = abs(m.sin(0)) + abs(m.cos(0)) + abs(m.sin(psf5)) + abs(m.cos(psf5))
trans5 = Phf5 * sth5 * suma5
axial5 = 2 * Phf5 * m.cos(th5)
Q5 = trans5 + axial5
psi05 = -0.2505
izq5 = m.tan(th5) ** 2 * m.cos(psi05) ** 2
umb5 = 160 * (100 - 60) / (60 * (160 - 100))
assert izq5 < umb5
# el Curtis, ej. 12.8: R2 = 90 grados con media vuelta de precesion -> theta0 = 45 (H en la bisectriz)
assert cerca(m.asin(m.sin(rad(45)) / m.sin(rad(90))), rad(45))
# el costo no depende de H: impulso ~ H, tiempo = Phi I'/H
costo_H = [(2 * H) * (Phf5 * Ip5 / H) / Ip5 for H in (0.5, 1.0, 7.0)]
assert all(cerca(c, costo_H[0]) for c in costo_H)

# ---------------------------------------------------------------- E6: CMG con los numeros del apunte de clase
h6, t6 = 4760.0, 258.0                                                # ISS
dd6 = t6 / h6
F6 = t6 / 0.5                                                         # par de fuerzas, rodamientos a 0,5 m
cap6 = 4 * h6
dd6_air = 45 / 15                                                     # Airbus CMG 15-45S
amp6 = 100 * 1.0
# desaturacion: par en tijera, h por rotor, J = 4 h s, k = 0,25 h/s durante 8 s (unidades de h)
J6, k6, T6 = 4.0, 0.25, 8.0
imp6 = k6 * T6
assert cerca(imp6, 2.0)                                               # justo lo que guardan los dos rotores
th6_fin = m.degrees(m.acos(1 - imp6 / 2))
assert cerca(th6_fin, 90.0)
def thdot6(th):                                                       # 2 h sin(th) thdot = k
    return k6 / (2 * m.sin(rad(th)))
# camino 2: derivar numericamente 2 cos(th(t)) con th(t) = acos(1 - k t / 2)
tt = 2 * (1 - m.cos(rad(15))) / k6
eps_ = 1e-6
th_a, th_b = m.acos(1 - k6 * (tt - eps_) / 2), m.acos(1 - k6 * (tt + eps_) / 2)
assert abs((th_b - th_a) / (2 * eps_) - thdot6(15)) < 1e-5
t6_15 = tt
w6_bloq = -imp6 / J6
assert cerca(deg(w6_bloq), -28.6478897565)


def fmt(x, dec):
    return ('%.*f' % (dec, x)).replace('.', ',')


VALORES = {
    'E1 I/Ip': I1 / Ip1, 'E1 wx': w1[0], 'E1 wz': w1[2], 'E1 w': wm1, 'E1 w rpm': wm1 * RPM,
    'E1 gamma': deg(ga1), 'E1 theta': deg(th1), 'E1 phidot rpm': fi1 * RPM, 'E1 psidot rpm': ps1 * RPM,
    'E1 phidot rad': fi1, 'E1 psidot rad': ps1, 'E1 libro': (fi1_libro, ps1_libro),
    'E1 tan th': m.tan(th1), 'E1 tan ga': m.tan(ga1),
    'E2 m': (ms2, mt2, mt2 / ms2 * 100), 'E2 I': (I2, Ip2), 'E2 Hsat': Hsat2, 'E2 Hmet': Hmet2, 'E2 H': H2,
    'E2 |H|': Hn2, 'E2 w': w2, 'E2 |w|': wn2, 'E2 th ga': (deg(th2), deg(ga2)), 'E2 fi ps': (fi2, ps2),
    'E2 eje': eje2, 'E2 v0': v0n2, 'E2 kg': (800 * 0.45359237, 6 * 28.349523125, 4500 * 0.3048),
    'E2 Ia/It': I2 / Ip2, 'E2 per': (2 * m.pi / fi2, 2 * m.pi / abs(ps2)),
    'E3 M': M3, 'E3 I': I3, 'E3 w': w3, 'E3 fi': fi3, 'E3 Mc': Mc3, 'E3 Mc solar': Mc3_solar, 'E3 H': H3,
    'E3 lam': lam3, 'E3 Tlib': Tlib3, 'E3 Tlib solar': Tlib3_solar, 'E3 Tesp h': Tesp3, 'E3 exc %': exc3,
    'E3 fi/w': fi3 / w3, 'E3 obs/calc': obs3 / Tlib3, 'E3 anios/dias': anios_vs_dias,
    'E4 p': p4, 'E4 Om': Om4, 'E4 MG': MGn4, 'E4 Ip': Ip4, 'E4 imp': imp4, 'E4 prop dia': prop4_dia,
    'E4 prop anio': prop4_anio, 'E4 prop 15': prop4_15, 'E4 dip': dip4, 'E4 gg': gg4, 'E4 srp': srp4,
    'E4 p/Om': p4 / Om4,
    'E5 sth': sth5, 'E5 th': th5, 'E5 th deg': deg(th5), 'E5 dpsi': dpsi5, 'E5 cos': m.cos(th5),
    'E5 suma': suma5, 'E5 trans': trans5, 'E5 axial': axial5, 'E5 Q': Q5, 'E5 izq': izq5,
    'E5 umb': umb5, 'E5 tan2': m.tan(th5) ** 2, 'E5 cos2': m.cos(psi05) ** 2,
    'E5 sinpsf': m.sin(psf5), 'E5 cospsf': m.cos(psf5), 'E5 R2 deg': deg(R25), 'E5 Phf deg': deg(Phf5),
    'E6 dd': dd6, 'E6 dd deg': deg(dd6), 'E6 F': F6, 'E6 cap': cap6, 'E6 air': dd6_air,
    'E6 air deg': deg(dd6_air), 'E6 thdot15': thdot6(15), 'E6 thdot90': thdot6(90), 'E6 thdot5': thdot6(5),
    'E6 t15': t6_15, 'E6 wbloq': w6_bloq, 'E6 wbloq deg': deg(w6_bloq), 'E6 cos15': 2 * m.cos(rad(15)),
}

# ---------------------------------------------------------------- CONTROLES (formato de validar.py)
# (texto, valor): texto es una subcadena LITERAL de resueltos-cr-extras.typ que empieza con el numero
# como se imprime; valor es la cuenta de arriba. Tolerancia: la de validar.coincide (ultima cifra o 0,2 %).
CONTROLES = [
    # E1 -- Beer PR 18.6
    ('6,283$ rad/s sobre el eje', w01), ('-2 " rad/s"', w1[0]), ('6,283 " rad/s" $', w1[2]),
    ('6,594$ rad/s', wm1), ('63,0$ rpm: el golpe', wm1 * RPM), ('0,3183 arrow.r.double gamma', m.tan(ga1)),
    ('17,7degree, quad', deg(ga1)), ('0,796 arrow.r.double theta', m.tan(th1)), ('38,5degree $', deg(th1)),
    ('38,5degree$ del eje del', deg(th1)), ('30,7 " rpm"', fi1 * RPM), ('36,0 " rpm" $', ps1 * RPM),
    ('0,4$ da', I1 / Ip1), ('0,6 dot.op 60 = 36,0', (Ip1 - I1) / Ip1), ('30,8$ rpm', fi1_libro),
    ('35,9$ rpm', ps1_libro), ('-2; 0; 6,283)$ rad/s', w1[0]),
    # E2 -- Beer 18.127
    ('24,84$ slug', ms2), ('0,375$ lb', 6 / 16), ('0,01165$ slug', mt2), ('2,4$ ft y', kx2), ('2,7$ ft, y', ky2),
    ('3,5; -1,667; 0)$ ft', rB2[0]), ('-1,667; 0)$ ft', rB2[1]), ('4500$ ft/s', v0n2),
    ('181,1 " slug·ft²"', I2), ('143,1 " slug·ft²"', Ip2), ('271,7; 0)$', Hsat2[1]),
    ('-6667; -14 thin 000; 1883)', cruz(rB2, v02)[0]), ('-14 thin 000; 1883)', cruz(rB2, v02)[1]),
    ('1883) " ft²/s"', cruz(rB2, v02)[2]), ('-77,6; -163,0; 21,9)$', Hmet2[0]), ('-163,0; 21,9)$', Hmet2[1]),
    ('21,9)$. Fijate', Hmet2[2]), ('60$ % de su momento', -Hmet2[1] / Hsat2[1] * 100),
    ('-77,6; 108,6; 21,9) " slug', H2[0]), ('108,6; 21,9) " slug', H2[1]), ('135,3 $', Hn2),
    ('-0,543; 0,600; 0,153)', w2[0]), ('0,600; 0,153)', w2[1]), ('0,153) " rad/s"', w2[2]),
    ('0,823 " rad/s"', wn2), ('125,0degree$, $theta_y', eje2[0]), ('36,6degree$, $theta_z', eje2[1]),
    ('80,7degree$.', eje2[2]), ('36,6degree, quad cos gamma', deg(th2)), ('43,2degree $', deg(ga2)),
    ('0,946 " rad/s"', fi2), ('-0,159 " rad/s"', ps2), ('6,64$ s', 2 * m.pi / fi2), ('39,4$ s', 2 * m.pi / abs(ps2)),
    ('0,94556$ y', fi2), ('-0,15932$ rad/s', ps2), ('-0,2656 dot.op', (Ip2 - I2) / Ip2),
    ('0,803 = 0,600', m.cos(th2)), ('0,05$ % de la masa', mt2 / ms2 * 100), ('170$ g a', 6 * 28.349523125),
    ('1,37$ km/s', v0n2 * 0.3048 / 1000), ('363$ kg', 800 * 0.45359237),
    # E3 -- la Tierra, Beer 18.117 y 18.123
    ('7,29 times 10^(-5)$ rad/s', w3), ('5,97 times 10^24', M3), ('9,68 times 10^37', I3),
    ('7,06 times 10^33', H3), ('7,72 times 10^(-12)', fi3), ('2,17 times 10^22 " N·m"', Mc3),
    ('1,06 times 10^(-7)', fi3 / w3), ('2,16 times 10^22$: la', Mc3_solar),
    ('0,3$ %, y',(Mc3 - Mc3_solar) / Mc3 * 100), ('0,00330$', lam3), ('302 " días"', Tlib3),
    ('303$: da igual', Tlib3_solar), ('23,9$ h. La misma', Tesp3), ('43$ % de más', exc3),
    ('0,33$ % del abultamiento', lam3 * 100),
    # E4 -- satelite GEO con el spin a la Tierra
    ('0,1047$ rad/s. Precesión', p4), ('7,27 times 10^(-5)$', Om4), ('1440$', p4 / Om4),
    ('4,19 times 10^(-3) " N·m"', MGn4), ('57,6$ N·m·s, tiene', Ip4), ('57,6$ N·m·s»', Ip4), ('362$ N·m·s. Y', imp4),
    ('362$ N·m·s. Las dos', 2 * m.pi * Ip4), ('0,17$ kg por día', prop4_dia), ('61$ kg por año', prop4_anio),
    ('920$ kg en', prop4_15), ('4,2 times 10^4$', dip4), ('419$ veces menos', srp4), ('5,2 times 10^(-6)$', gg4),
    ('0,3$ %. Y después', (DIA / T_SID - 1) * 100),
    # E5 -- coning impulsivo
    ('7,5degree$', deg(R25)), ('19,1degree$', deg(Phf5)), ('0,395$, así que', sth5),
    ('0,4061$ rad, $23,3degree$', th5), ('23,3degree$. Coincide', deg(th5)), ('0,9187 dot.op 0,667', m.cos(th5)),
    ('0,667 = 0,204$', Ip5 / I5 - 1), ('0,204$ rad. Positivo', dpsi5), ('0,185 dot.op 0,939', m.tan(th5) ** 2),
    ('0,939 = 0,174', m.cos(psi05) ** 2), ('0,174 quad', izq5), ('1,78 $', umb5), ('0,202 + 0,979', m.sin(psf5)),
    ('0,979 = 2,182$', m.cos(psf5)), ('2,182$; el término', suma5), ('0,287$; el axial', trans5),
    ('0,611$. Total', axial5), ('0,898$, el', Q5),
    # E6 -- CMG con los numeros del apunte de clase
    ('0,054$ rad/s, unos', dd6), ('3,1degree$/s', deg(dd6)), ('516$ N de', F6), ('516$ N por rodamiento', F6),
    ('19 thin 040$ N·m·s. *Airbus', cap6), ('3$ rad/s, $172degree', dd6_air), ('172degree$/s', deg(dd6_air)),
    ('0,125$ rad/s con', thdot6(90)), ('0,483$ rad/s', thdot6(15)), ('1,43$ rad/s con', thdot6(5)),
    ('0,125\\/sin theta$', k6 / 2), ('0,27$ s; en la', t6_15), ('-0,5$ rad/s, $-28,6degree$/s', w6_bloq),
    ('-28,6degree$/s', deg(w6_bloq)), ('0,5$ rad/s en este modelo', imp6 / J6),
]


def medir(controles, texto):
    """Mide cada control contra el .typ con el mismo criterio que validar.py. Devuelve (n_ok, rojos)."""
    from validar import coincide          # aca y no arriba: validar.py importa este archivo
    rojos, ok = [], 0
    for mostrado, calc in controles:
        if mostrado not in texto:
            rojos.append('no esta en el documento: "%s"' % mostrado)
            continue
        bien, det = coincide(mostrado, calc)
        if bien:
            ok += 1
        else:
            rojos.append('%s  (%s)' % (det, mostrado))
    return ok, rojos


if __name__ == '__main__':
    sys.path.insert(0, AQUI)
    texto = io.open(os.path.join(AQUI, 'resueltos-cr-extras.typ'), encoding='utf-8').read()
    if '--mostrar' in sys.argv:
        for k, v in VALORES.items():
            print('  %-14s %s' % (k, v))
    if '--sabotaje' in sys.argv:
        # un valor corrido 5 % y un texto que no esta: los dos tienen que salir en rojo, por SU motivo
        malo = [(t, v * 1.05) for t, v in CONTROLES[3:4]] + [('9,999$ rad/s', 9.999)]
        n, r = medir(malo, texto)
        vio = n == 0 and len(r) == 2 and 'impreso' in r[0] and 'no esta' in r[1]
        print('sabotaje: %d rojos: %s' % (len(r), r))
        print('SABOTAJE ' + ('EN ROJO, como tiene que ser' if vio else 'NO SE VIO: el control no discrimina'))
        sys.exit(0 if vio else 1)
    n, rojos = medir(CONTROLES, texto)
    print('controles de resueltos-cr-extras.typ: %d de %d en verde' % (n, len(CONTROLES)))
    for r in rojos:
        print('  [ROJO] ' + r)
    sys.exit(1 if rojos else 0)
