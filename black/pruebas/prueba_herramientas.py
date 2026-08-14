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
import shutil
import struct
import subprocess
import sys
import tempfile
import zipfile

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


# =============================================================================
print("== escanear: flujo completo con savestates sintéticos ==")
import escanear  # noqa: E402

try:
    import numpy  # noqa: F401
    hay_numpy = True
except ImportError:
    hay_numpy = False
print(f"   (numpy {'presente' if hay_numpy else 'ausente'}: se prueba ese camino)")

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
shutil.rmtree(ses_dir, ignore_errors=True)


# =============================================================================
print("== inspeccionar: volcado desde savestate ==")
r = correr(["herramientas/inspeccionar.py", "volcar", "0x200000",
            "--antes", "0x10", "--largo", "0x40", "--desde", sa])
ok(r.returncode == 0, "inspeccionar volcar", (r.stderr or "").strip()[:300])
ok("0x00200000" in r.stdout and "100" in r.stdout, "muestra el valor del ancla")
ok("2.5" in r.stdout, "detecta el float 2.5 en el entorno")


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
shutil.rmtree(os.path.join(RAIZ, "construido"), ignore_errors=True)


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


shutil.rmtree(tmp, ignore_errors=True)

# =============================================================================
print()
if fallos:
    print(f"FALLARON {len(fallos)} de {len(fallos) + pasadas}:")
    for f_ in fallos:
        print(f"  ✗ {f_}")
    raise SystemExit(1)
print(f"todo bien: {pasadas} comprobaciones")
