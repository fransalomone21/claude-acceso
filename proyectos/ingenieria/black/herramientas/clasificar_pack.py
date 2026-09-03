# -*- coding: utf-8 -*-
"""Clasifica el pack de reemplazo de PCSX2 decodificando el 3er campo del nombre.

Layout confirmado contra GSTextureReplacements.cpp (struct TextureName, master):
  bits 0-5   TEX0_PSM
  bits 6-9   TEX0_TW    -> ancho original = 1 << TW
  bits 10-13 TEX0_TH    -> alto  original = 1 << TH
  bit  14    unused0 (era TCC)
  bits 15-22 TEXA_TA0
  bit  23    TEXA_AEM
  bits 24-31 TEXA_TA1
Nombre: <TEX0Hash>-<CLUTHash>-<bits>.dds  |  <TEX0Hash>-<bits>.dds (sin CLUT)
"""
import os, re, struct, sys, collections, json

PACK = r"C:\Users\frans\Documents\PCSX2\textures\SLUS-21376\replacements"

# GSLocalMemory / GS.h : nombres de PSM por valor
PSM = {0:"PSMCT32",1:"PSMCT24",2:"PSMCT16",10:"PSMCT16S",19:"PSMT8",20:"PSMT4",
       27:"PSMT8H",36:"PSMT4HL",44:"PSMT4HH",48:"PSMZ32",49:"PSMZ24",
       50:"PSMZ16",58:"PSMZ16S"}
# paletizados: los que tienen CLUT
PAL = {19,20,27,36,44}

RX = re.compile(r"^([0-9a-f]{1,16})(?:-([0-9a-f]{1,16}))?-([0-9a-f]{8})\.dds$", re.I)

def dds_dims(path):
    with open(path, "rb") as f:
        h = f.read(32)
    if len(h) < 32 or h[:4] != b"DDS ":
        return None
    # DDS_HEADER: dwSize(4) dwFlags(4) dwHeight(4) dwWidth(4) ...
    height, width = struct.unpack_from("<II", h, 12)
    return width, height

filas = []
malos = []
for n in os.listdir(PACK):
    if not n.lower().endswith(".dds"):
        continue
    m = RX.match(n)
    if not m:
        malos.append(n); continue
    tex0, clut, bits_s = m.group(1), m.group(2), m.group(3)
    b = int(bits_s, 16)
    psm  = b & 0x3F
    tw   = (b >> 6) & 0xF
    th   = (b >> 10) & 0xF
    ta0  = (b >> 15) & 0xFF
    aem  = (b >> 23) & 0x1
    ta1  = (b >> 24) & 0xFF
    d = dds_dims(os.path.join(PACK, n))
    filas.append(dict(nombre=n, tex0=tex0, clut=clut, bits=bits_s, psm=psm,
                      ow=1 << tw, oh=1 << th, ta0=ta0, aem=aem, ta1=ta1,
                      dw=d[0] if d else None, dh=d[1] if d else None))

print("archivos .dds            :", len(filas) + len(malos))
print("nombres que NO parsean   :", len(malos), malos[:5])
print("con CLUT (3 campos)      :", sum(1 for f in filas if f["clut"]))
print("sin CLUT (2 campos)      :", sum(1 for f in filas if not f["clut"]))
print()

print("=== por formato PS2 (PSM) ===")
for psm, n in collections.Counter(f["psm"] for f in filas).most_common():
    print("  %-10s (%2d)  %5d  %s" % (PSM.get(psm, "?"), psm, n,
                                      "paletizado" if psm in PAL else ""))
print()

print("=== dimension ORIGINAL PS2 (de TW/TH) ===")
for (w, h), n in collections.Counter((f["ow"], f["oh"]) for f in filas).most_common(20):
    print("  %4dx%-4d  %5d" % (w, h, n))
print()

print("=== dimension del DDS de reemplazo ===")
for (w, h), n in collections.Counter((f["dw"], f["dh"]) for f in filas).most_common(15):
    print("  %sx%-5s %5d" % (w, h, n))
print()

print("=== factor de upscale (DDS / original) ===")
fac = collections.Counter()
for f in filas:
    if f["dw"] and f["ow"]:
        fac[(round(f["dw"] / f["ow"], 2), round(f["dh"] / f["oh"], 2))] += 1
for k, n in fac.most_common(12):
    print("  %sx / %sy   %5d" % (k[0], k[1], n))
print()

print("=== variantes de CLUT del MISMO asset (mismo TEX0Hash) ===")
porTex0 = collections.Counter(f["tex0"] for f in filas)
dist = collections.Counter(porTex0.values())
print("  assets distintos (TEX0Hash unicos):", len(porTex0))
for k in sorted(dist):
    print("    %3d variante(s): %5d asset(s)  -> %5d archivos" % (k, dist[k], k * dist[k]))
extra = len(filas) - len(porTex0)
print("  archivos que son variante de CLUT de un asset ya presente:", extra)
print()

print("=== candidatos UI / fuentes (chico + paletizado 4bpp, o no cuadrado) ===")
ui = [f for f in filas if f["ow"] <= 64 and f["oh"] <= 64]
print("  originales <= 64x64        :", len(ui))
print("  originales <= 32x32        :", sum(1 for f in filas if f["ow"] <= 32 and f["oh"] <= 32))
print("  no cuadrados               :", sum(1 for f in filas if f["ow"] != f["oh"]))

with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "pack_clasificado.json"), "w") as f:
    json.dump(filas, f)
print("\nvolcado -> pack_clasificado.json")
