#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pruebas de las herramientas del proyecto. No necesitan PCSX2: fabrican
savestates sintéticos y verifican la lógica contra codificaciones conocidas.

    python3 pruebas/prueba_herramientas.py

Lo único que NO se puede probar acá es PINE, que necesita PCSX2 abierto con
un juego cargado. Para eso: `python3 herramientas/pine.py info`.
"""

from __future__ import annotations

import io
import json
import os
import platform
import shutil
import struct
import subprocess
import sys
import tempfile
import zipfile

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
HERR = os.path.join(RAIZ, "herramientas")
sys.path.insert(0, HERR)

import estado  # noqa: E402
import mips  # noqa: E402

fallos: list[str] = []
pasadas = 0


def ok(condicion: bool, descripcion: str, detalle: str = "") -> None:
    global pasadas
    if condicion:
        pasadas += 1
    else:
        fallos.append(f"{descripcion}{'  — ' + detalle if detalle else ''}")


def correr(args: list[str], **kw) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable] + args, capture_output=True, text=True, cwd=RAIZ, **kw
    )


# Correr un comando con la salida redirigida y codificada como la página de
# códigos de Windows. Es la frontera donde se rompen los comandos que imprimen
# 'Δ' (ver herramientas/salida.py): un print entero muere con
# UnicodeEncodeError y se lleva puesto el comando. Llamar a las funciones en
# proceso NO lo detecta, porque un StringIO no codifica nada — por eso los dos
# bugs de este tipo llegaron a producción con las pruebas en verde.
CP1252 = {
    "env": dict(os.environ, PYTHONIOENCODING="cp1252"),
    "encoding": "cp1252",
    "errors": "replace",
}


# =============================================================================
print("== mips: codificaciones conocidas ==")
# Valores verificados a mano contra el formato de instrucción MIPS I/R/J.
CASOS = [
    ("nop", 0x00000000),
    ("addiu v0, zero, 100", 0x24020064),
    ("lui a0, 0x1234", 0x3C041234),
    ("jr ra", 0x03E00008),
    ("sw v0, 0x1C(s0)", 0xAE02001C),
    ("lw a1, -8(sp)", 0x8FA5FFF8),
    # or rd,rs,rt -> rs=a0(4)<<21 | rt=a1(5)<<16 | rd=v1(3)<<11 | fn=0x25
    ("or v1, a0, a1", 0x00851825),
    ("sll t0, t1, 4", 0x00094100),
    ("addu s0, s1, s2", 0x02328021),
    ("andi t0, t1, 0xFF", 0x312800FF),
]
for texto, esperado in CASOS:
    try:
        obtenido = mips.ensamblar(texto)
    except mips.MipsError as e:
        obtenido = f"error: {e}"
    ok(obtenido == esperado, f"ensamblar('{texto}')",
       f"esperaba 0x{esperado:08X}, dio "
       f"{obtenido if isinstance(obtenido, str) else f'0x{obtenido:08X}'}")

# 'or v1, a0, a1': rs=a0=4<<21=0x00800000, rt=a1=5<<16=0x00050000, rd=v1=3<<11=0x1800, fn=0x25
ok(mips.ensamblar("or v1, a0, a1") == 0x00851825, "or v1, a0, a1",
   f"dio 0x{mips.ensamblar('or v1, a0, a1'):08X}")

print("== mips: ida y vuelta ==")
for texto, palabra in CASOS:
    txt = mips.desensamblar(palabra)
    try:
        revuelta = mips.ensamblar(txt)
    except mips.MipsError as e:
        revuelta = f"error: {e}"
    ok(revuelta == palabra, f"des->ens de 0x{palabra:08X}",
       f"'{txt}' volvió a "
       f"{revuelta if isinstance(revuelta, str) else f'0x{revuelta:08X}'}")

ok(mips.desensamblar(0x24020064) == "li v0, 100", "addiu con rs=zero se muestra como li",
   mips.desensamblar(0x24020064))
ok(mips.desensamblar(0x00000000) == "nop", "0 es nop")

# saltos: el destino depende de la dirección de la instrucción
b = mips.ensamblar("beq a0, a1, 0x00100010", direccion=0x00100000)
ok(mips.desensamblar(b, 0x00100000) == "beq a0, a1, 0x00100010",
   "branch relativo ida y vuelta", mips.desensamblar(b, 0x00100000))
j = mips.ensamblar("jal 0x00123456", direccion=0x00100000)
ok(mips.desensamblar(j, 0x00100000) == "jal 0x00123454", "jal alinea a 4",
   mips.desensamblar(j, 0x00100000))

# li de 32 bits tiene que dar dos instrucciones
sec = mips.li32("v0", 0x00123456)
ok(len(sec) == 2 and sec[0][1] == 0x3C020012, "li32 genera lui+ori",
   str([hex(w) for _, w in sec]))

# error claro cuando el inmediato no entra
try:
    mips.ensamblar("li v0, 70000")
    ok(False, "li con inmediato grande debería fallar")
except mips.MipsError:
    ok(True, "li con inmediato grande falla con mensaje")


# =============================================================================
print("== estado: lectura de savestates ==")
tmp = tempfile.mkdtemp(prefix="black-prueba-")


def hacer_savestate(ruta: str, ram: bytes, metodo: int = zipfile.ZIP_STORED) -> str:
    with zipfile.ZipFile(ruta, "w", compression=metodo) as z:
        z.writestr("PCSX2 Savestate Version", b"\x00" * 4)
        z.writestr("eeMemory.bin", ram)
        z.writestr("iopMemory.bin", b"\x00" * 16)
    return ruta


ram_a = bytearray(estado.TAM_EE)
struct.pack_into("<I", ram_a, 0x00200000, 100)      # "vida"
struct.pack_into("<I", ram_a, 0x00200004, 100)      # "vida max"
struct.pack_into("<I", ram_a, 0x00300000, 100)      # señuelo que no se mueve
struct.pack_into("<f", ram_a, 0x00200010, 2.5)
ram_a[0x00400000:0x00400008] = b"BLACKtxt"

ram_b = bytearray(ram_a)
struct.pack_into("<I", ram_b, 0x00200000, 80)       # bajó 20
struct.pack_into("<I", ram_b, 0x00250000, 999)      # ruido nuevo

sa = hacer_savestate(os.path.join(tmp, "a.p2s"), bytes(ram_a))
sb = hacer_savestate(os.path.join(tmp, "b.p2s"), bytes(ram_b))
sd = hacer_savestate(os.path.join(tmp, "d.p2s"), bytes(ram_a), zipfile.ZIP_DEFLATED)

leida = estado.leer_ee(sa)
ok(len(leida) == estado.TAM_EE, "eeMemory.bin mide 32 MB", str(len(leida)))
ok(struct.unpack_from("<I", leida, 0x00200000)[0] == 100,
   "el offset del archivo es la dirección EE")
ok(len(estado.leer_ee(sd)) == estado.TAM_EE, "savestate con deflate también se lee")

entradas = dict((n, m) for n, _, m in estado.listar(sa))
ok("eeMemory.bin" in entradas, "listar() ve eeMemory.bin")

try:
    hacer_savestate(os.path.join(tmp, "vacio.p2s"), b"")
    with zipfile.ZipFile(os.path.join(tmp, "sin-ee.p2s"), "w") as z:
        z.writestr("otracosa.bin", b"x")
    estado.leer_ee(os.path.join(tmp, "sin-ee.p2s"))
    ok(False, "savestate sin eeMemory.bin debería fallar")
except estado.EstadoError:
    ok(True, "savestate sin eeMemory.bin falla con mensaje claro")

print("== estado: ubicar 'Documentos' aunque OneDrive lo haya redirigido ==")
# La API de Windows (SHGetFolderPathW) no se puede probar fuera de Windows:
# platform.system() != "Windows" hace que _documentos_windows() devuelva None
# de entrada, sin tocar ctypes. Lo que SÍ se prueba acá, en cualquier
# sistema, es que ante eso el resto de la lógica no se cae: cae a las rutas
# heredadas (~/Documents y ~/OneDrive/Documents), sin duplicados.
if platform.system() != "Windows":
    ok(estado._documentos_windows() is None,
       "fuera de Windows, _documentos_windows() no intenta nada y da None")
candidatos_docs = estado._candidatos_documentos_windows()
esperado_base = os.path.join(os.path.expanduser("~"), "Documents")
esperado_onedrive = os.path.join(os.path.expanduser("~"), "OneDrive", "Documents")
ok(esperado_base in candidatos_docs, "incluye ~/Documents como candidato")
ok(esperado_onedrive in candidatos_docs, "incluye ~/OneDrive/Documents como candidato")
ok(len(candidatos_docs) == len(set(candidatos_docs)), "sin candidatos duplicados")


# =============================================================================
print("== escanear: flujo completo con savestates sintéticos ==")
import escanear  # noqa: E402

try:
    import numpy  # noqa: F401
    hay_numpy = True
except ImportError:
    hay_numpy = False
print(f"   (numpy {'presente' if hay_numpy else 'ausente'}: se prueba ese camino)")

# Los "próximo paso: corré..." que imprime el script tienen que decir el
# comando que YA está corriendo, no "python3" fijo -en Windows suele ser
# "python", donde "python3" ni existe (pasó de verdad: llevó a un usuario
# real a un error). No se puede fingir sys.executable de Windows acá, pero
# sí probar que la limpieza del ".exe" funciona como debería.
ok(not escanear.PY.lower().endswith(".exe"), "PY nunca incluye el sufijo .exe")
_py_esperado = os.path.basename(sys.executable)
if _py_esperado.lower().endswith(".exe"):
    _py_esperado = _py_esperado[:-4]
ok(escanear.PY == _py_esperado,
   "en esta máquina PY coincide con el intérprete real", escanear.PY)

ok(escanear.parsear_filtro("=100", "u32") == {"clase": "valor", "op": "==", "val": 100},
   "parsear '=100'")
ok(escanear.parsear_filtro("bajo", "u32")["op"] == "bajo", "parsear 'bajo'")
ok(escanear.parsear_filtro("bajo=20", "u32")["delta"] == 20, "parsear 'bajo=20'")
ok(escanear.parsear_filtro("entre=10:200", "u32")["b"] == 200, "parsear 'entre=10:200'")
try:
    escanear.parsear_filtro("qué onda", "u32")
    ok(False, "un filtro inválido debería fallar")
except escanear.EscaneoError:
    ok(True, "filtro inválido falla con mensaje")

offs = escanear.buscar_exacto_bytes(bytes(ram_a), 100, "u32", 0x00100000, 0x02000000, 4)
ok(0x00200000 in offs and 0x00200004 in offs and 0x00300000 in offs,
   "buscar_exacto_bytes encuentra los tres 100", str([hex(o) for o in offs[:8]]))

ses_dir = os.path.join(RAIZ, "volcados", "escaneo-prueba")
shutil.rmtree(ses_dir, ignore_errors=True)

r = correr(["herramientas/escanear.py", "nuevo", "prueba", "--tipo", "u32", "--desde", sa])
ok(r.returncode == 0, "escanear nuevo", r.stderr.strip()[:300])

r = correr(["herramientas/escanear.py", "filtrar", "prueba", "=100", "--desde", sa])
ok(r.returncode == 0 and "candidatos" in r.stdout, "escanear filtrar '=100'",
   (r.stderr or r.stdout).strip()[:300])

r = correr(["herramientas/escanear.py", "filtrar", "prueba", "bajo", "--desde", sb])
ok(r.returncode == 0, "escanear filtrar 'bajo'", (r.stderr or r.stdout).strip()[:300])
ok("0x00200000" in r.stdout, "el filtro 'bajo' deja justo la dirección que bajó",
   r.stdout.strip()[:300])
ok("0x00300000" not in r.stdout, "descarta el señuelo que no se movió")

r = correr(["herramientas/escanear.py", "listar", "prueba"])
ok(r.returncode == 0 and "0x00200000" in r.stdout, "escanear listar",
   (r.stderr or r.stdout).strip()[:300])

# bajo=N exacto
shutil.rmtree(ses_dir, ignore_errors=True)
correr(["herramientas/escanear.py", "nuevo", "prueba", "--tipo", "u32", "--desde", sa])
correr(["herramientas/escanear.py", "filtrar", "prueba", "=100", "--desde", sa])
r = correr(["herramientas/escanear.py", "filtrar", "prueba", "bajo=20", "--desde", sb])
ok("0x00200000" in r.stdout, "filtro 'bajo=20' (delta exacto)",
   (r.stderr or r.stdout).strip()[:300])

# float
shutil.rmtree(ses_dir, ignore_errors=True)
r = correr(["herramientas/escanear.py", "nuevo", "prueba", "--tipo", "f32", "--desde", sa])
r = correr(["herramientas/escanear.py", "filtrar", "prueba", "=2.5", "--desde", sa])
ok("0x00200010" in r.stdout, "escaneo de f32 encuentra el 2.5",
   (r.stderr or r.stdout).strip()[:300])

# Foto repetida: comparar un savestate contra sí mismo con un filtro relativo.
# Pasó de verdad en la notebook y devolvía "0 candidatos" sin ninguna señal de
# que el problema era el procedimiento y no los datos.
shutil.rmtree(ses_dir, ignore_errors=True)
correr(["herramientas/escanear.py", "nuevo", "prueba", "--tipo", "u32", "--desde", sa])
r = correr(["herramientas/escanear.py", "filtrar", "prueba", "bajo", "--desde", sa])
ok(r.returncode != 0, "filtro relativo sobre la MISMA foto falla en vez de dar 0",
   (r.stdout or r.stderr).strip()[:300])
ok("MISMO savestate" in (r.stderr + r.stdout),
   "el error dice explícitamente que la foto está repetida",
   (r.stderr or r.stdout).strip()[:300])
ok("0 candidatos" not in r.stdout, "no se reporta un 0 engañoso")

# ...pero un filtro de valor exacto SÍ puede reusar la misma foto: no compara
# contra nada anterior.
r = correr(["herramientas/escanear.py", "filtrar", "prueba", "=100", "--desde", sa])
ok(r.returncode == 0, "filtro de valor exacto sí puede reusar la misma foto",
   (r.stderr or r.stdout).strip()[:300])
shutil.rmtree(ses_dir, ignore_errors=True)


# =============================================================================
print("== inspeccionar: volcado desde savestate ==")
r = correr(["herramientas/inspeccionar.py", "volcar", "0x200000",
            "--antes", "0x10", "--largo", "0x40", "--desde", sa])
ok(r.returncode == 0, "inspeccionar volcar", (r.stderr or "").strip()[:300])
ok("0x00200000" in r.stdout and "100" in r.stdout, "muestra el valor del ancla")
ok("2.5" in r.stdout, "detecta el float 2.5 en el entorno")

print("== inspeccionar: comparar con la salida redirigida en cp1252 ==")
# El 'Δ' de la cabecera de `comparar` mataba el comando entero: imprimía
# "N campo(s) cambiaron" y moría antes de mostrar un solo campo, que es todo
# lo que el comando tiene para dar. Dentro de la región comparada, ram_b
# difiere de ram_a en 0x00200000: 100 -> 80.
bin_a = os.path.join(tmp, "comparar-a.bin")
r = correr(["herramientas/inspeccionar.py", "comparar", "0x200000",
            "--largo", "0x40", "--desde", sa, "--guardar", bin_a], **CP1252)
ok(r.returncode == 0, "comparar --guardar toma la primera instantánea",
   (r.stderr or r.stdout).strip()[-300:])

r = correr(["herramientas/inspeccionar.py", "comparar", "0x200000",
            "--largo", "0x40", "--desde", sb, "--contra", bin_a], **CP1252)
ok(r.returncode == 0, "comparar --contra en cp1252 no revienta",
   (r.stderr or r.stdout).strip()[-400:])
ok("0x00200000" in r.stdout, "la tabla de cambios se imprime, no sólo el conteo",
   (r.stderr or r.stdout).strip()[-400:])
ok("100 ->" in r.stdout and "80" in r.stdout, "muestra el antes y el después",
   r.stdout.strip()[-400:])


# =============================================================================
print("== pnach: lectura de carpetas reales desde PCSX2.ini ==")
import pnach  # noqa: E402

ini_prueba = os.path.join(tmp, "PCSX2-prueba", "inis", "PCSX2.ini")
os.makedirs(os.path.dirname(ini_prueba), exist_ok=True)
with open(ini_prueba, "w") as f:
    f.write(
        "[Folders]\n"
        "Cheats = cheats_ws\n"
        "Savestates = sstates\n"
        "[EmuCore]\n"
        "EnablePINE = true\n"
    )

ok(pnach._leer_carpeta_de_ini("Cheats", "cheats", ruta_ini=ini_prueba)
   == os.path.join(tmp, "PCSX2-prueba", "cheats_ws"),
   "lee la carpeta real del .ini en vez de asumir el nombre de fábrica",
   pnach._leer_carpeta_de_ini("Cheats", "cheats", ruta_ini=ini_prueba))
ok(pnach._leer_carpeta_de_ini("Savestates", "sstates", ruta_ini=ini_prueba)
   == os.path.join(tmp, "PCSX2-prueba", "sstates"),
   "resuelve rutas relativas contra la raíz de datos (padre de inis/)")
ok(pnach._leer_carpeta_de_ini("Patches", "patches", ruta_ini=ini_prueba)
   == os.path.join(tmp, "PCSX2-prueba", "patches"),
   "clave ausente del .ini cae al valor de fábrica, no revienta")
ok(pnach._leer_carpeta_de_ini("Cheats", "cheats", ruta_ini="/no/existe/PCSX2.ini") is None,
   ".ini inexistente devuelve None en vez de tirar una excepción")


# =============================================================================
print("== pnach: compilación ==")
ruta_obj = os.path.join(RAIZ, "kb", "objetivo.json")
with open(ruta_obj) as f:
    obj_original = f.read()
obj = json.loads(obj_original)
obj["version_activa"] = "NTSC-U"
with open(ruta_obj, "w") as f:
    json.dump(obj, f, indent=2, ensure_ascii=False)

mod_prueba = os.path.join(RAIZ, "mods", "zz-prueba.toml")
with open(mod_prueba, "w") as f:
    f.write(
        'nombre = "Prueba"\n'
        'habilitado = true\n'
        'cuando = "continuo"\n\n'
        "[[parche]]\n"
        "direccion = 0x00200000\n"
        'tipo = "u32"\n'
        "valor = 500\n"
        'nota = "vida"\n\n'
        "[[parche]]\n"
        "direccion = 0x0010A2B4\n"
        'asm = "nop"\n'
        'nota = "anula el sw"\n\n'
        "[[parche]]\n"
        "direccion = 0x00200010\n"
        'tipo = "f32"\n'
        "valor = 2.5\n"
    )

r = correr(["herramientas/pnach.py", "compilar", "--solo", "zz-prueba"])
salida_pnach = os.path.join(RAIZ, "construido", "SLUS-21376_5C891FF1.pnach")
ok(r.returncode == 0, "pnach compilar", (r.stderr or r.stdout).strip()[:400])
if os.path.exists(salida_pnach):
    texto = open(salida_pnach).read()
    ok("patch=1,EE,00200000,word,000001F4" in texto,
       "parche de dato: 500 -> 0x1F4 en 32 bits", texto[:400])
    ok("patch=1,EE,0010A2B4,word,00000000" in texto,
       "parche de código: nop ensamblado", texto[:400])
    ok("patch=1,EE,00200010,word,40200000" in texto,
       "parche f32: 2.5 -> IEEE 0x40200000", texto[:400])
    ok("gametitle=" in texto and "[Prueba]" in texto, "cabecera y grupo del cheat")
else:
    ok(False, "pnach compilar no generó el archivo", (r.stderr or r.stdout)[:400])

# sin version_activa tiene que fallar con un mensaje útil, no con un KeyError
obj["version_activa"] = None
with open(ruta_obj, "w") as f:
    json.dump(obj, f, indent=2, ensure_ascii=False)
r = correr(["herramientas/pnach.py", "compilar", "--solo", "zz-prueba"])
ok(r.returncode != 0 and "version_activa" in (r.stderr + r.stdout),
   "sin version_activa falla explicando por qué", (r.stderr or r.stdout)[:200])

with open(ruta_obj, "w") as f:
    f.write(obj_original)
os.remove(mod_prueba)
# Sólo el .pnach que generó esta prueba: rmtree() sobre toda la carpeta se
# llevaba puesto construido/.gitkeep, que está trackeado en git.
if os.path.exists(salida_pnach):
    os.remove(salida_pnach)


# =============================================================================
print("== salida: elegir símbolos que la consola sepa escribir ==")
import salida  # noqa: E402


class _FlujoFalso:
    def __init__(self, encoding):
        self.encoding = encoding


ok(salida.simbolo_delta(_FlujoFalso("utf-8")) == "Δ", "con UTF-8 se usa 'Δ'")
ok(salida.simbolo_delta(_FlujoFalso("cp1252")) == "d",
   "con cp1252 cae a 'd' en vez de reventar")
ok(salida.simbolo_delta(_FlujoFalso("ascii")) == "d", "con ASCII también cae a 'd'")
ok(salida.simbolo_delta(_FlujoFalso(None)) == "d", "flujo sin encoding: 'd'")

# Las dos herramientas que imprimen deltas tienen que usar la MISMA función:
# la primera versión de esto vivía suelta en vigilar.py y por eso
# inspeccionar.py se quedó con el bug.
import inspeccionar  # noqa: E402

ok(inspeccionar.simbolo_delta is salida.simbolo_delta,
   "inspeccionar usa la función compartida, no una copia")


# =============================================================================
print("== vigilar: análisis de series temporales ==")
csv_prueba = os.path.join(tmp, "regen.csv")
with open(csv_prueba, "w") as f:
    f.write("t,vida\n")
    vida = 40
    t = 0.0
    # regeneración simulada: +5 cada 2 segundos, durante 24 s (12 escalones)
    for i in range(241):
        f.write(f"{t:.4f},{vida}\n")
        t += 0.1
        if i and i % 20 == 0:
            vida += 5
import contextlib  # noqa: E402
import vigilar  # noqa: E402

buf = io.StringIO()
with contextlib.redirect_stdout(buf):
    vigilar.analizar(csv_prueba, "vida", 0.0)
salida = buf.getvalue()
ok("salto CONSTANTE de 5" in salida, "detecta el escalón constante de +5", salida[:400])
ok("REGULAR" in salida, "detecta que el ritmo es regular", salida[:400])
ok("2.50 unidades/segundo" in salida, "calcula la tasa (5 cada 2 s = 2.5/s)", salida[:400])

ok(vigilar.parsear_objetivo("0x2038A0:vida:u32")["direccion"] == 0x2038A0,
   "parsear objetivo con nombre y tipo")
ok(vigilar.parsear_objetivo("0x2038A0")["tipo"] == "u32", "tipo por defecto u32")

# El 'Δ' de la línea "primeros:" mataba el comando entero con
# UnicodeEncodeError cuando la salida se redirigía en Windows (cp1252, sin
# U+0394). El análisis se imprimía hasta "intervalo" y ahí cortaba. La prueba
# de arriba no lo veía porque llama a analizar() en proceso contra un
# StringIO, que no codifica nada: hay que cruzar la misma frontera que el uso
# real —un subproceso con la salida redirigida— o el bug queda invisible.
r = correr(["herramientas/vigilar.py", "analizar", csv_prueba, "--columna", "vida"],
           **CP1252)
ok(r.returncode == 0, "analizar por CLI con la salida en cp1252 no revienta",
   (r.stderr or r.stdout).strip()[-400:])
ok("primeros:" in r.stdout and "t=" in r.stdout.split("primeros:")[1],
   "la línea 'primeros:' se imprime entera", (r.stderr or r.stdout).strip()[-400:])
ok("2.50 unidades/segundo" in r.stdout,
   "el análisis llega hasta el final por CLI", r.stdout.strip()[-400:])


# =============================================================================
print("== pine: armado del protocolo (sin PCSX2) ==")
import pine  # noqa: E402

ok(pine._OP_LEER[4] == 0x02 and pine._OP_ESCRIBIR[4] == 0x06, "opcodes de 32 bits")
cmd = struct.pack("<BI", pine.MSG_READ32, 0x00200000)
ok(len(cmd) == 5, "un comando de lectura mide 5 bytes")
marco = struct.pack("<I", 4 + len(cmd)) + cmd
ok(struct.unpack("<I", marco[:4])[0] == 9, "el prefijo de tamaño se incluye a sí mismo")
rutas = pine.rutas_socket(28011)
ok(any(r.endswith("pcsx2.sock") for r in rutas), "rutas de socket por defecto sin sufijo")
ok(all(r.endswith(".28100") for r in pine.rutas_socket(28100)),
   "slot no estándar agrega sufijo", str(pine.rutas_socket(28100)))


# =============================================================================
print("== fijar_objetivo: persistencia de identidad (sin PCSX2) ==")
import fijar_objetivo  # noqa: E402

objetivo_base = {
    "version_activa": None,
    "versiones": {
        "NTSC-U": {
            "serial": "SLUS-21376",
            "crc": "5C891FF1",
            "confirmada": False,
            "fuente_crc": "comunidad, sin confirmar",
        },
        "PAL": {"serial": "SLES-53831", "crc": None, "confirmada": False},
    },
}

# caso 1: serial conocido, CRC coincide -> se confirma y queda activa
info_ok = {"serial": "SLUS-21376", "crc": "5c891ff1", "titulo": "Black",
           "version_pcsx2": "PCSX2 2.0.0", "version_juego": "1.00", "estado": "corriendo"}
act, msgs = fijar_objetivo.aplicar_info(objetivo_base, info_ok)
ok(act["version_activa"] == "NTSC-U", "serial conocido activa esa versión")
ok(act["versiones"]["NTSC-U"]["confirmada"] is True, "la marca confirmada")
ok(act["versiones"]["NTSC-U"]["crc"] == "5C891FF1", "normaliza el CRC a mayúsculas")
ok(objetivo_base["versiones"]["NTSC-U"]["confirmada"] is False,
   "no muta el dict original (función pura)")

# caso 2: CRC no coincide con el anotado -> avisa fuerte, pisa con el observado
info_distinto = dict(info_ok, crc="AABBCCDD")
act2, msgs2 = fijar_objetivo.aplicar_info(objetivo_base, info_distinto)
ok(act2["versiones"]["NTSC-U"]["crc"] == "AABBCCDD", "pisa el CRC con el observado")
ok(any("AVISO" in m and "5C891FF1" in m and "AABBCCDD" in m for m in msgs2),
   "avisa la discrepancia con ambos valores", str(msgs2))

# caso 3: serial que no está en ninguna versión conocida -> crea entrada nueva
info_nuevo = {"serial": "SLES-99999", "crc": "11223344", "titulo": "Black",
              "version_pcsx2": "PCSX2 2.0.0", "version_juego": "1.00", "estado": "corriendo"}
act3, msgs3 = fijar_objetivo.aplicar_info(objetivo_base, info_nuevo)
ok("SLES-99999" in act3["versiones"], "serial desconocido crea una entrada nueva")
ok(act3["version_activa"] == "SLES-99999", "la nueva entrada queda activa")
ok(act3["versiones"]["SLES-99999"]["confirmada"] is True, "la entrada nueva nace confirmada")
ok("PAL" in act3["versiones"], "no borra las otras versiones ya anotadas")

# caso 4: sin serial (PCSX2 en el menú, sin juego) -> error claro, no un KeyError
try:
    fijar_objetivo.aplicar_info(objetivo_base, {"serial": "", "crc": ""})
    ok(False, "sin serial debería fallar")
except fijar_objetivo.FijarObjetivoError as e:
    ok("juego cargado" in str(e), "el mensaje explica que hay que cargar el juego", str(e))

r = correr(["herramientas/fijar_objetivo.py", "--help"])
ok(r.returncode == 0, "fijar_objetivo.py --help no rompe", (r.stderr or r.stdout)[:200])


# =============================================================================
print("== armas: encontrar la tabla en un volcado sintético (sin PCSX2) ==")
import armas  # noqa: E402


def _escribir_registro_arma(d, base, power_jugador, power_ia,
                             rango=50.0, fall=0.5, codigo=b"ASR"):
    for blo, power in ((armas.BLOQUES[0], power_jugador), (armas.BLOQUES[1], power_ia)):
        struct.pack_into("<f", d, base + blo + armas.OFF_RANGE, rango)
        struct.pack_into("<f", d, base + blo + armas.OFF_POWER, power)
        struct.pack_into("<f", d, base + blo + armas.OFF_FALLOFF, fall)
    d[base + armas.OFF_CODIGO:base + armas.OFF_CODIGO + len(codigo)] = codigo


dump_armas = bytearray(armas.HEAP_FIN)
base0 = armas.HEAP_INI + 0x100000
N_REGISTROS = 8
for i in range(N_REGISTROS):
    _escribir_registro_arma(dump_armas, base0 + i * armas.PASO,
                             power_jugador=100.0 + i, power_ia=50.0 + i)

bases = armas.buscar_tabla(dump_armas)
ok(bases == [base0 + i * armas.PASO for i in range(N_REGISTROS)],
   f"buscar_tabla encuentra los {N_REGISTROS} registros sintéticos, en orden",
   str([hex(b) for b in bases]))

campos = armas.campos_power(bases)
ok(len(campos) == N_REGISTROS * 2, "campos_power: dos Power por registro (jugador + IA)")
ok(struct.unpack_from("<f", dump_armas, campos[0])[0] == 100.0,
   "el primer campo Power es el del jugador, registro 0")

# control negativo: un Power = NaN invalida el registro entero, no sólo el campo
saboteado = bytearray(dump_armas)
struct.pack_into("<f", saboteado, base0 + armas.BLOQUES[0] + armas.OFF_POWER, float("nan"))
ok(armas._registro_valido(saboteado, base0) is False,
   "un Power = NaN invalida el registro (regla del saboteador)")
ok(len(armas.buscar_tabla(saboteado)) < N_REGISTROS,
   "con un registro roto, la corrida ya no mide 8 -> buscar_tabla no la cuenta entera")


# =============================================================================
print("== zonas: cadena de punteros hasta la tabla de zonas (sin PCSX2) ==")
import zonas  # noqa: E402

dump_zonas = bytearray(zonas.RAM_FIN)
enemigo_base = 0x00500000
componente_addr = 0x00510000
personaje_ptr_addr = 0x00520000
zona_base = 0x00530000

struct.pack_into("<I", dump_zonas, enemigo_base + zonas.OFF_VTABLE, zonas.CLASE_ENEMIGO)
struct.pack_into("<I", dump_zonas, enemigo_base + zonas.OFF_COMPONENTE, componente_addr)
struct.pack_into("<I", dump_zonas, componente_addr + zonas.OFF_PERSONAJE, personaje_ptr_addr)
struct.pack_into("<I", dump_zonas, personaje_ptr_addr, zona_base)
struct.pack_into("<f", dump_zonas, zona_base + 0 * zonas.PASO_ZONA + zonas.OFF_A, 1.5)
# señuelo: un denormal en OFF_B de la zona 1, con la forma de "basura reinterpretada"
struct.pack_into("<f", dump_zonas, zona_base + 1 * zonas.PASO_ZONA + zonas.OFF_B, 1e-43)

enemigos = zonas.bases_de_enemigos(dump_zonas)
ok(enemigos == [enemigo_base], "bases_de_enemigos sigue el puntero de clase en +0x10",
   str([hex(e) for e in enemigos]))

tablas_zonas = zonas.buscar_tablas(dump_zonas)
ok(tablas_zonas == {zona_base: [0]},
   "buscar_tablas sigue la cadena componente->personaje->tabla",
   str({hex(k): v for k, v in tablas_zonas.items()}))

dirs_zonas = zonas.campos(dump_zonas, [zona_base])
ok(dirs_zonas == [zona_base + zonas.OFF_A],
   "campos() sólo lista el factor plausible, descarta el denormal señuelo",
   str([hex(d) for d in dirs_zonas]))


# =============================================================================
print("== tablas: funciones puras de recorte y detección ==")
import tablas  # noqa: E402

ok(tablas.recorte(b"\x00" * 100, base=0x1000, desde=0x1010, hasta=0x1020) == (0x10, 0x20),
   "recorte convierte direcciones EE a offsets de archivo")
try:
    tablas.recorte(b"\x00" * 100, base=0, desde=0x50, hasta=0x10)
    ok(False, "recorte con rango vacío debería fallar")
except SystemExit:
    ok(True, "recorte con rango invertido falla en vez de devolver basura")

datos_tabla = b"XX" + b"Hola\x00" + b"resto"
ok(tablas.cadena_en(datos_tabla, 2) == "Hola", "cadena_en lee una cadena ASCII con NUL")
ok(tablas.cadena_en(b"A" * 100, 0) is None,
   "cadena_en: sin NUL dentro del largo máximo, no hay cadena")
ok(tablas.cadena_en(b"\x01\x02\x00", 0) is None,
   "cadena_en rechaza bytes no imprimibles aunque terminen en NUL")

ok(tablas.float_plausible(0.0) is True, "float_plausible: cero es válido (campo sin usar)")
ok(tablas.float_plausible(3.5) is True, "float_plausible: valor típico de parámetro")
ok(tablas.float_plausible(1e-43) is False, "float_plausible rechaza denormales (basura)")
ok(tablas.float_plausible(float("nan")) is False, "float_plausible rechaza NaN")
ok(tablas.fmt_float(5.0) == "5", "fmt_float sin parte decimal se ve como entero")
ok(tablas.fmt_float(2.5) == "2.5", "fmt_float conserva decimales")

ok(tablas.parece_nombre_de_campo("MaxYawSpeed") is True,
   "parece_nombre_de_campo acepta CamelCase de una palabra")
ok(tablas.parece_nombre_de_campo("Num Bullets In Clip") is True,
   "parece_nombre_de_campo acepta varias palabras con mayúscula inicial")
ok(tablas.parece_nombre_de_campo("hola") is False,
   "parece_nombre_de_campo rechaza minúscula inicial")
ok(tablas.parece_nombre_de_campo("a") is False, "parece_nombre_de_campo rechaza muy corto")

archivo_vecinos = os.path.join(tmp, "vecinos.bin")
buf_vecinos = bytearray(0x40)
struct.pack_into("<f", buf_vecinos, 0x10, 3.5)
with open(archivo_vecinos, "wb") as f:
    f.write(bytes(buf_vecinos))
r = correr(["herramientas/tablas.py", "vecinos", archivo_vecinos, "0x10", "--radio", "0x10"])
ok(r.returncode == 0, "tablas.py vecinos no rompe", (r.stderr or r.stdout)[:300])
ok("f32 3.5" in r.stdout and "<--" in r.stdout,
   "vecinos marca el centro y decodifica el float plantado", r.stdout[:400])


# =============================================================================
print("== firmas: firma por posición de byte, y detección de RW stream (sin PCSX2) ==")
import firmas  # noqa: E402

tmp_firmas = tempfile.mkdtemp(prefix="black-firmas-")
for i in range(3):
    with open(os.path.join(tmp_firmas, f"archivo{i}.TST"), "wb") as f:
        f.write(bytes([0xAB, 0x10 + i]) + b"\x00" * 30)

r_tst = firmas.analizar(tmp_firmas, "TST", 4)
ok(r_tst is not None and len(r_tst["archivos"]) == 3, "firmas: encuentra los 3 .TST")
ok(r_tst["columnas"][0][0xAB] == 3, "firmas: byte 0 constante en 3/3 archivos")
ok(len(r_tst["columnas"][1]) == 3, "firmas: byte 1 varía, 3 valores distintos")
ok(r_tst["rw"] == 0, "firmas: los .TST sintéticos no son RenderWare binary stream")

rw_payload = b"\x00" * 20
rw_bytes = struct.pack("<III", 0x0F, len(rw_payload), 0x1803FFFF) + rw_payload
with open(os.path.join(tmp_firmas, "geo.RW"), "wb") as f:
    f.write(rw_bytes)
r_rw = firmas.analizar(tmp_firmas, "RW", 12)
ok(r_rw is not None and r_rw["rw"] == 1,
   "firmas: control positivo — SÍ detecta un RW stream plano armado a mano")

ok(firmas.es_rw_stream(rw_bytes[:12], len(rw_bytes)) == (True, "Geometry"),
   "es_rw_stream reconoce chunk Geometry con tamaño coherente")
ok(firmas.es_rw_stream(b"\xff" * 12, 100) == (False, ""),
   "es_rw_stream rechaza una cabecera sin tipo RW conocido")
shutil.rmtree(tmp_firmas, ignore_errors=True)


# =============================================================================
print("== inventario: el chequeo de OneDrive mira la carpeta EN USO, no una vieja ==")
import inventario  # noqa: E402

_orig_carpeta_savestates = estado.carpeta_savestates
try:
    estado.carpeta_savestates = lambda: r"C:\Users\alguien\Documents\PCSX2\sstates"
    fila = next(f for f in inventario.revisar_onedrive() if "savestates" in f["nombre"])
    ok(fila["en_onedrive"] is False,
       "carpeta en uso fuera de OneDrive: no se marca en riesgo (el falso positivo original)")

    estado.carpeta_savestates = lambda: r"C:\Users\alguien\OneDrive\Documents\PCSX2\sstates"
    fila2 = next(f for f in inventario.revisar_onedrive() if "savestates" in f["nombre"])
    ok(fila2["en_onedrive"] is True,
       "carpeta en uso SÍ redirigida a OneDrive: la alarma prende (probado rompiéndola)")

    estado.carpeta_savestates = lambda: None
    fila3 = next(f for f in inventario.revisar_onedrive() if "savestates" in f["nombre"])
    ok(fila3["existe"] is False and fila3["en_onedrive"] is False,
       "sin ninguna candidata en el sistema: no revienta, no reporta un riesgo falso")
finally:
    estado.carpeta_savestates = _orig_carpeta_savestates

r = correr(["herramientas/inventario.py", "--help"])
ok(r.returncode == 0, "inventario.py --help no rompe", (r.stderr or r.stdout)[:200])


# =============================================================================
print("== ubicaciones: se pone en rojo cuando una ruta se rompe (probado rompiéndolo) ==")
import ubicaciones  # noqa: E402

tmp_ub = tempfile.mkdtemp(prefix="black-ub-")
_archivo = os.path.join(tmp_ub, "existe.bin")
with open(_archivo, "wb") as _fh:
    _fh.write(b"0123456789")

# el caso sano: existe, es archivo, y el tamaño declarado coincide
ok(ubicaciones.revisar_una("x", {"ruta": _archivo, "tipo": "archivo",
                                 "tam": 10, "critico": True})["ok"] is True,
   "ruta sana con tamaño correcto: verifica")

# los tres sabotajes. Si alguno diera ok=True, el verificador no verifica nada.
ok(ubicaciones.revisar_una("x", {"ruta": os.path.join(tmp_ub, "no-esta.bin"),
                                 "tipo": "archivo", "critico": True})["ok"] is False,
   "ruta ausente: se marca en rojo")
ok(ubicaciones.revisar_una("x", {"ruta": _archivo, "tipo": "archivo",
                                 "tam": 999, "critico": True})["ok"] is False,
   "existe pero con OTRO tamaño: se marca en rojo (el archivo cambió abajo)")
ok(ubicaciones.revisar_una("x", {"ruta": tmp_ub, "tipo": "archivo",
                                 "critico": True})["ok"] is False,
   "carpeta declarada como archivo: se marca en rojo")
ok(ubicaciones.revisar_una("x", {"ruta": tmp_ub, "tipo": "carpeta",
                                 "critico": True})["ok"] is True,
   "esa misma carpeta declarada como carpeta: verifica")

# la trampa que originó la herramienta: corchetes en la ruta.
_con_corchetes = os.path.join(tmp_ub, "Black [NTSC]")
os.makedirs(_con_corchetes)
ok(ubicaciones.revisar_una("x", {"ruta": _con_corchetes, "tipo": "carpeta",
                                 "critico": True})["ok"] is True,
   "ruta CON CORCHETES: verifica igual (en PowerShell sin -LiteralPath daría False)")

r = correr(["herramientas/ubicaciones.py", "ruta", "clave-que-no-existe"])
ok(r.returncode == 2, "pedir una clave inexistente falla con código 2",
   (r.stderr or r.stdout)[:200])

shutil.rmtree(tmp_ub, ignore_errors=True)


shutil.rmtree(tmp, ignore_errors=True)

# =============================================================================
print()
if fallos:
    print(f"FALLARON {len(fallos)} de {len(fallos) + pasadas}:")
    for f_ in fallos:
        print(f"  ✗ {f_}")
    raise SystemExit(1)
print(f"todo bien: {pasadas} comprobaciones")
