# verificar.py -- corre las 17 simulaciones y compara CADA .meas contra el
# numero calculado a mano.
#
#   python verificar.py            regenera, corre y compara
#   python verificar.py --sin-correr   solo compara los .log que ya estan
#
# Por que existe: la guia pide "comparacion cuantitativa entre calculo y
# simulacion" (entregable minimo, punto 6). Eso se hizo una vez a mano, y
# una comparacion hecha a mano una vez no sobrevive al primer retoque de un
# archivo. Aca la prediccion esta ESCRITA y la comparacion la hace el
# programa: si alguien cambia un valor de un componente, un paso de
# integracion o una condicion inicial y el resultado se mueve, esto se pone
# en rojo.
#
# La tabla de abajo NO se completa mirando el .log. Cada numero sale del
# calculo analitico que esta escrito adentro de cada .asc, en el bloque
# CONTROL. Si un dia hay que "ajustar" un esperado para que pase, lo que
# hay que revisar es el circuito o la cuenta, no este archivo.

import os
import re
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
LTSPICE = Path(os.environ["LOCALAPPDATA"]) / "Programs/ADI/LTspice/LTspice.exe"
SPICE = RAIZ / "ltspice"

TOL = 0.02          # 2% por defecto: la comparacion es contra un calculo
                    # analitico, no contra otra simulacion.

# --------------------------------------------------------------------------
# La prediccion. (valor,) usa tolerancia relativa; (valor, "abs", eps) usa
# absoluta, que es lo unico que sirve cuando el esperado es cero.
# Para los archivos con .step, una lista con un valor por corrida, EN EL
# ORDEN EN QUE LTSPICE LAS INFORMA (que es el de la lista ordenada, no el
# que uno escribio: eso ya sorprendio una vez).
# --------------------------------------------------------------------------
ESPERADO = {
    "P6-01_bobina_pulso_triangular": {
        "il_pico": 0.25, "vl_sube": 1.0, "vl_baja": -1.0,
        "p_en_4ms": 0.2, "p_en_6ms": -0.2, "w_max": 625e-6,
    },
    "P6-02_bobina_tension_a_corriente": {
        "il_1ms": 25e-3, "il_2ms": 50e-3, "il_fin": 50e-3, "pend": 25.0,
    },
    "P6-17_capacitor_pulso_corriente": {
        "v_5us": 4.0, "v_20us": 28.0, "v_30us": 18.0, "v_50us": 10.0,
        "q_30us": 4.5e-6, "w_50us": 12.5e-6,
    },
    "P6-25_capacidad_equivalente": {
        "i_red": 37.6991e-3, "i_ref": 37.6991e-3, "ceq_medida": 6e-6,
    },
    "P7-01_conmutacion_continuidad_iL": {
        "i1_antes": 5e-3, "i2_antes": 15e-3,
        "i1_desp": 5e-3, "i2_desp": -5e-3,
        "vb_desp": -40.0, "tau": 50e-6,
    },
    "P7-04_RL_reconstruir_parametros": {
        "v_0": 400.0, "i_0": 10.0, "r_med": 40.0, "t63": 0.2,
        "l_med": 8.0, "w0": 400.0, "t80": 0.16094, "w_int": 320.0,
    },
    "P7-08_RL_descarga_balance_energia": {
        "io_0": -10.0, "v_0": -80.0, "t63": 200e-6, "w0": 0.4,
        "w_disip": 0.08, "t95": 299.6e-6, "n_taus": 1.498,
        "i8_fin": 8.0, "i2_fin": -8.0,
    },
    "P7-21_RC_energia_atrapada": {
        "i_0": 1.6e-3, "t63": 0.02, "v1_fin": 8.0, "v2_fin": 8.0,
        "w0": 800e-6, "w_atrap": 160e-6, "w_disip": 640e-6,
    },
    "P7-23_RC_identificar_R_C_tau": {
        "v_0": 48.0, "i_0": 12e-3, "r_med": 4000.0, "t368": 0.04,
        "c_med": 10e-6, "w0": 11.52e-3, "w60ms": 10.946e-3,
        "cociente": 4000.0,
    },
    "P7-25_RC_energia_disipada": {
        "vc_antes": 102.0, "w0": 17.34e-3, "w_12ms": 7.8236e-3,
        "pct_12ms": 45.12, "dt75": 27.73e-3, "t63": 0.09,
    },
    # --- con .step: una lista por medicion --------------------------------
    "P8-01_RLC_paralelo_clasificacion": {          # R = 1000, 1250, 1562.5
        "alfa": [250.0, 200.0, 160.0],
        "omega0": [200.0, 200.0, 200.0],
        "t_cruce1": [4.6210e-3, 5.0000e-3, 5.3625e-3],
        "t_cruce3": [None, None, 57.722e-3],
        "td": [None, None, 52.360e-3],
    },
    "P8-38_RLC_serie_critico": {                   # R = 640, 800, 960
        "r_critico": [800.0, 800.0, 800.0],
        "i_0": [30e-3, 30e-3, 30e-3],
        "didt_0": [8.36, -50.49, -108.87],
        "vc_150us": [11.475, 12.2815, 12.971],
        "vc_min": [-0.4301, (0.0, "abs", 1e-3), (6.1e-3, "abs", 1e-3)],
        "vc_1ms": [-0.34542, 0.40428, 1.3015],
    },
    "X1_no_ideal_RL_con_DCR": {                    # dcr = 1u, 25
        "v_0": [400.0, 400.0], "i_0": [10.0, 10.0],
        "t63": [0.2, 0.123077],
        "tau_teorico": [0.2, 0.123077],
        "error_pct": [(0.0, "abs", 0.01), -38.462],
    },
    "X2_no_ideal_RC_con_fuga": {                   # rfuga = 100k, 10M, 1G
        "v_0": [48.0, 48.0, 48.0],
        "t368": [38.455e-3, 39.977e-3, 39.993e-3],
        "tau_teorico": [38.462e-3, 39.984e-3, 40.000e-3],
    },
    "X3_no_ideal_RLC_con_DCR_ESR": {               # k = 0 (ideal), 1 (real)
        "r_total": [800.0, 806.2],
        "alfa": [5000.0, 5038.75],
        "omega0": [5000.0, 5000.0],
        "vc_1ms": [0.40428, 0.43727],
        "r_crit_real": [800.0, 793.8],
    },
}

# Los dos .op no dejan sus resultados en el .log: van al .raw. Se leen de
# ahi, en ASCII (por eso LTspice se llama con -ascii).
ESPERADO_OP = {
    "P7-01b_estado_previo_con_op": {
        "V(a)": 30.0, "I(L1)": 5e-3, "I(R1)": 20e-3,
        "I(R2)": 15e-3, "I(R3)": 5e-3,
    },
    "P7-08b_estado_previo_con_op": {
        "V(n1)": 300.0, "I(I1)": 12.0, "I(L1)": 10.0,
        "I(R150)": 2.0, "I(R30)": 10.0,
    },
}

# Avisos del .log que SI son aceptables, con el motivo. Cualquier otro
# aviso o error pone el archivo en rojo.
AVISOS_ESPERADOS = {
    "P6-17_capacitor_pulso_corriente": [
        ("Node vc is floating",
         "el nodo solo tiene un capacitor y una fuente de corriente; es el "
         "circuito del enunciado y .ic le fija el estado inicial"),
    ],
}

FATALES = re.compile(
    r"over-defined|singular|Timestep too small|Fatal|Analysis: |"
    r"is floating|Unknown|Error", re.I)


# --------------------------------------------------------------------------
def leer_log(ruta):
    """Devuelve (mediciones, lineas_de_aviso) de un .log de LTspice."""
    txt = ruta.read_bytes().replace(b"\x00", b"").decode("latin1")
    med, avisos = {}, []
    for l in txt.splitlines():
        if FATALES.search(l) and not l.lower().startswith("measurement:"):
            if not re.match(r"^\s*\w+:\s", l):        # no es una medicion
                avisos.append(l.strip())
    # --- mediciones sin .step -------------------------------------------
    for l in txt.splitlines():
        m = re.match(r"^([a-z_][a-z_0-9]*):\s*(.+)$", l)
        if not m:
            continue
        nombre, resto = m.group(1), m.group(2).strip()
        if resto.lower().startswith("failed") or "fail" in resto.lower():
            med[nombre] = None
            continue
        v = _valor(resto)
        if v is not None:
            med[nombre] = v
    # --- mediciones con .step -------------------------------------------
    bloques = re.split(r"^Measurement:\s*", txt, flags=re.M)[1:]
    for b in bloques:
        lineas = b.splitlines()
        nombre = lineas[0].strip()
        vals = []
        for l in lineas[1:]:
            if not l.strip():
                break
            campos = [c for c in l.split("\t") if c.strip()]
            if len(campos) < 2 or not campos[0].strip().isdigit():
                continue
            crudo = campos[1].strip()
            vals.append(None if crudo == "failed" else _num(crudo))
        if vals:
            med[nombre] = vals
    return med, avisos


def _valor(resto):
    """El numero que informa una linea de .meas sin .step."""
    if "(" in resto and "," in resto:                     # complejo: (mod,ang)
        m = re.search(r"\(([-\d.eE+]+)\s*,", resto)
        return _num(m.group(1)) if m else None
    m = re.search(r"\sAT\s+([-\d.eE+]+)\s*$", resto)      # WHEN: da el INSTANTE
    if m:
        return _num(m.group(1))
    resto = re.sub(r"\s+(at|FROM)\s+.*$", "", resto)      # saca la ventana
    m = re.search(r"=\s*([-\d.eE+]+[a-zA-Z]?)\s*$", resto)
    return _num(m.group(1)) if m else None


SUFIJOS = {"t": 1e12, "g": 1e9, "meg": 1e6, "k": 1e3, "m": 1e-3,
           "u": 1e-6, "n": 1e-9, "p": 1e-12, "f": 1e-15}


def _num(s):
    s = s.strip()
    m = re.match(r"^([-+]?[\d.]+(?:[eE][-+]?\d+)?)([a-zA-Z]*)$", s)
    if not m:
        return None
    v = float(m.group(1))
    suf = m.group(2).lower()
    if suf in SUFIJOS:
        v *= SUFIJOS[suf]
    return v


def leer_op(ruta):
    """Lee un .raw ASCII de punto de operacion."""
    txt = ruta.read_bytes().replace(b"\x00", b"").decode("latin1")
    nombres, on, vals = [], False, []
    for l in txt.splitlines():
        if l.startswith("Variables:"):
            on = True
            continue
        if l.startswith("Values:"):
            on = False
            continue
        if on:
            p = [c for c in l.split("\t") if c.strip()]
            if len(p) >= 2:
                nombres.append(p[1])
    for l in txt.split("Values:", 1)[-1].splitlines():
        p = [c for c in l.split("\t") if c.strip()]
        for c in p:
            try:
                vals.append(float(c))
            except ValueError:
                pass
    if len(vals) > len(nombres):          # la primera columna es el indice 0
        vals = vals[len(vals) - len(nombres):]
    return dict(zip(nombres, vals))


def comparar(medido, esperado):
    """None si coincide; el texto del desvio si no."""
    if esperado is None:
        return None if medido is None else f"esperaba que FALLARA, dio {medido:.6g}"
    if medido is None:
        return "no se midio (o el .meas fallo)"
    if isinstance(esperado, tuple):
        _, _, eps = esperado
        return (None if abs(medido - esperado[0]) <= eps
                else f"{medido:.6g} != {esperado[0]:.6g} (+-{eps:g})")
    ref = abs(esperado) if esperado else 1.0
    err = abs(medido - esperado) / ref
    return None if err <= TOL else f"{medido:.6g} != {esperado:.6g} ({err:.1%})"


# --------------------------------------------------------------------------
def main():
    correr = "--sin-correr" not in sys.argv
    if correr:
        print("Regenerando los .asc ...")
        subprocess.run([sys.executable, str(RAIZ / "herramientas/generar.py")],
                       check=True, stdout=subprocess.DEVNULL)
        if not LTSPICE.exists():
            print(f"[X] no esta LTspice en {LTSPICE}")
            return 1
        print("Corriendo LTspice ...")
        for asc in sorted(SPICE.glob("*.asc")):
            subprocess.run([str(LTSPICE), "-b", "-ascii", str(asc)],
                           check=False)

    fallas, revisados = [], 0
    for nombre, esperados in ESPERADO.items():
        log = SPICE / f"{nombre}.log"
        if not log.exists():
            fallas.append(f"{nombre}: no hay .log")
            continue
        med, avisos = leer_log(log)
        for a in avisos:
            if not any(pat in a for pat, _ in AVISOS_ESPERADOS.get(nombre, [])):
                fallas.append(f"{nombre}: aviso no esperado -- {a}")
        for clave, esp in esperados.items():
            revisados += 1
            got = med.get(clave)
            if isinstance(esp, list):
                if not isinstance(got, list) or len(got) != len(esp):
                    fallas.append(f"{nombre}.{clave}: esperaba {len(esp)} "
                                  f"corridas de .step, hay {got}")
                    continue
                for i, (g, e) in enumerate(zip(got, esp), 1):
                    d = comparar(g, e)
                    if d:
                        fallas.append(f"{nombre}.{clave}[paso {i}]: {d}")
            else:
                d = comparar(got, esp)
                if d:
                    fallas.append(f"{nombre}.{clave}: {d}")

    for nombre, esperados in ESPERADO_OP.items():
        raw = SPICE / f"{nombre}.raw"
        if not raw.exists():
            fallas.append(f"{nombre}: no hay .raw")
            continue
        op = leer_op(raw)
        for clave, esp in esperados.items():
            revisados += 1
            d = comparar(op.get(clave), esp)
            if d:
                fallas.append(f"{nombre}.{clave}: {d}")

    print()
    if fallas:
        print(f"[X] {len(fallas)} desvios sobre {revisados} controles:")
        for f in fallas:
            print("   ", f)
        print("\nUn desvio NO se arregla tocando la tabla de verificar.py.")
        print("Se arregla en el circuito o en la cuenta -- y si la cuenta")
        print("estaba mal, se corrige TAMBIEN el bloque CONTROL del .asc.")
        return 1
    print(f"[OK] {revisados} controles, todos dentro de {TOL:.0%}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
