"""Estimacion de masa y centro de masa del dobson armado, POR VOLUMEN.

No es una medicion: es el numero contra el que se va a comparar la pesada
(protocolo P1-P4). Sirve para saber en que rango tiene que caer, y para ver
cual pieza mueve mas el resultado.

Fuentes: medidas de Fran del 2026-10-04 (cinta), tablas de 2 cm; el hueco de
los tacos (1,5 cm) y el eje de altura 2,6 cm debajo del borde de la pared,
estimados de las fotos 19 y 35-36. Densidad del pino: 450-550 kg/m3. Tubo:
rango, porque no se sabe si es chapa de acero o de aluminio ni cuanto pesa la
celda de fundicion.

z = altura sobre el PISO del dobson (cara de abajo de la base fija).
Supone el tubo balanceado sobre el eje de altura (su CdM en el eje): si no
lo esta, el CdM total se corre y ademas cambia con la altura del tubo.

Uso: python docs/estimar-cdm.py   (primero lo compuesto con las pesadas del
2026-10-05; despues la estimacion vieja por volumen, que dio 27 kg y fallo)
"""
T = 0.02                      # espesor de todas las tablas (m)
GAP = 0.015                   # tacos de PVC + vinilo entre base fija y movil (foto 19)
Z_MOV = T + GAP               # cara de abajo de la base movil
Z_PISO_ROCKER = Z_MOV + T     # donde apoyan las paredes
Z_EJE = Z_PISO_ROCKER + 0.796 - 0.026   # eje de altura (fotos 35-36)

# (nombre, volumen m3, z del centro)
madera = [
    ("base fija 43 x 40", 0.43 * 0.40 * T, T / 2),
    ("base movil 40 x 40", 0.40 * 0.40 * T, Z_MOV + T / 2),
    ("pared grande 1 (visor) 40 x 79,6", 0.40 * 0.796 * T, Z_PISO_ROCKER + 0.796 / 2),
    ("pared grande 2 40 x 78,8", 0.40 * 0.788 * T, Z_PISO_ROCKER + 0.788 / 2),
    ("pared chica 1 (ocular) 20 x 40", 0.20 * 0.40 * T, Z_PISO_ROCKER + 0.20 / 2),
    ("pared chica 2 (cola) 19,8 x 40", 0.198 * 0.40 * T, Z_PISO_ROCKER + 0.198 / 2),
    ("caja: techo + piso 40 x 31", 2 * 0.40 * 0.31 * T, Z_EJE),
    ("caja: costados 40 x 27", 2 * 0.40 * 0.27 * T, Z_EJE),
]


def total(rho, m_tubo):
    piezas = [(n, v * rho, z) for n, v, z in madera] + [("tubo completo (espejo, celda, araña, focuser, buscador)", m_tubo, Z_EJE)]
    M = sum(m for _, m, _ in piezas)
    return piezas, M, sum(m * z for _, m, z in piezas) / M


def componer(m_tubo, m_montura, rho_pino=(450, 550)):
    """Compone el CdM con lo PESADO (2026-10-05): el tubo sin caja, balanceado
    en el eje; la montura con la caja. La madera de pino da menos de lo
    pesado: el resto son herrajes (rulemanes, bulones, tacos, vinilo, gomas)
    de ubicacion desconocida, asi que se acota: todo abajo o todo en el eje."""
    V = sum(v for _, v, _ in madera)
    zV = sum(v * z for _, v, z in madera) / V
    M = m_tubo + m_montura
    out = []
    for rho in rho_pino:
        m_mad = rho * V
        resto = m_montura - m_mad
        for nom, z_resto in (("abajo", T), ("en el eje", Z_EJE)):
            z = (m_mad * zV + resto * z_resto + m_tubo * Z_EJE) / M
            out.append((rho, resto, nom, z))
    uniforme = (m_montura * zV + m_tubo * Z_EJE) / M
    return M, uniforme, out


if __name__ == "__main__":
    M, zu, casos = componer(19.7, 19.7)
    print("COMPUESTO CON LO PESADO (tubo 19,7 con camara, montura 19,7 con caja):")
    print("  masa %.1f kg; CdM con la montura de densidad uniforme: %.1f cm" % (M, zu * 100))
    for rho, resto, nom, z in casos:
        print("  pino %d: herrajes %.1f kg %-9s -> CdM %.1f cm" % (rho, resto, nom, z * 100))
    print()
    piezas, M, z = total(500, 11.0)
    print("Caso central (pino 500 kg/m3, tubo 11 kg):")
    for n, m, zz in piezas:
        print("  %-58s %5.2f kg  a %5.1f cm" % (n, m, zz * 100))
    print("  %-58s %5.2f kg  CdM a %5.1f cm del piso del dobson" % ("TOTAL", M, z * 100))
    print("  eje de altura a %.1f cm" % (Z_EJE * 100))
    lo = total(450, 8.0)
    hi = total(550, 14.0)
    print("Rango (pino 450 / tubo 8 kg  ->  pino 550 / tubo 14 kg):")
    print("  masa %.1f a %.1f kg;  CdM a %.1f a %.1f cm" % (lo[1], hi[1], lo[2] * 100, hi[2] * 100))
