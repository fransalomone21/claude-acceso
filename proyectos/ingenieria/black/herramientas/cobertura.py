# -*- coding: utf-8 -*-
import os, re, collections
BASE = r"C:\Users\frans\Documents\PCSX2\textures\SLUS-21376"
A = os.path.join(BASE, "dumps-A2-pack-activo")   # pedidas SIN reemplazo
B = os.path.join(BASE, "dumps-B-pack-off")       # TODAS las pedidas
P = os.path.join(BASE, "replacements")           # el pack

PSM = {0:"PSMCT32",1:"PSMCT24",2:"PSMCT16",10:"PSMCT16S",19:"PSMT8",20:"PSMT4",
       27:"PSMT8H",36:"PSMT4HL",44:"PSMT4HH",48:"PSMZ32",49:"PSMZ24",50:"PSMZ16",58:"PSMZ16S"}
PAL = {19,20,27,36,44}

# <tex0>[-<clut>][-rWxH]-<bits>
RX = re.compile(r"^([0-9a-f]{1,16})(?:-([0-9a-f]{1,16}))?(?:-r(\d+)x(\d+))?-([0-9a-f]{8})\.(dds|png)$", re.I)

def leer(d):
    out = {}
    for n in os.listdir(d):
        m = RX.match(n)
        if not m:
            print("  NO PARSEA:", n); continue
        tex0, clut, rw, rh, bits = m.group(1), m.group(2), m.group(3), m.group(4), m.group(5)
        b = int(bits, 16)
        clave = (tex0.lower().lstrip("0"), (clut or "").lower().lstrip("0"), rw or "", rh or "", b & ~0x4000)  # bit14 = unused0, PCSX2 lo normaliza con RemoveUnusedBits()
        out[clave] = dict(psm=b & 0x3F, ow=1 << ((b >> 6) & 0xF), oh=1 << ((b >> 10) & 0xF),
                          rw=rw, rh=rh, nombre=n)
    return out

a, b_, p = leer(A), leer(B), leer(P)
print("A (pedidas SIN reemplazo) :", len(a))
print("B (TODAS las pedidas)     :", len(b_))
print("pack                      :", len(p))
print()

falta = set(a) - set(b_)
print("CONTROL 1 -- A subset de B :", "OK" if not falta else "FALLA, %d fuera: %s" % (len(falta), list(falta)[:3]))

cubiertas = set(b_) - set(a)
print("cubiertas (B - A)          :", len(cubiertas))
en_pack = sum(1 for k in cubiertas if k in p)
print("CONTROL 2 -- cubiertas que estan en el pack: %d/%d %s" % (
    en_pack, len(cubiertas), "OK" if en_pack == len(cubiertas) else "<-- FALLA"))
if en_pack != len(cubiertas):
    for k in list(set(cubiertas) - set(p))[:5]:
        print("     no esta en el pack:", b_[k]["nombre"])
print()
print("COBERTURA = %d/%d = %.1f %%" % (len(cubiertas), len(b_), 100.0 * len(cubiertas) / len(b_)))
print()

def tabla(titulo, dic):
    print("===", titulo, "(n=%d) ===" % len(dic))
    c = collections.Counter(v["psm"] for v in dic.values())
    for psm, n in c.most_common():
        print("   %-9s (%2d) %4d  %s" % (PSM.get(psm, "?"), psm, n, "paletizado" if psm in PAL else "COLOR DIRECTO"))
    nopal = sum(n for psm, n in c.items() if psm not in PAL)
    print("   -> no paletizadas: %d/%d = %.1f %%" % (nopal, len(dic), 100.0 * nopal / len(dic)))
    reg = sum(1 for v in dic.values() if v["rw"])
    print("   -> con region (framebuffer/RT): %d" % reg)
    print()

tabla("LOS NO CUBIERTOS (A)", a)
tabla("TODAS LAS PEDIDAS (B)", b_)
tabla("LOS CUBIERTOS (B-A)", {k: b_[k] for k in cubiertas})

print("=== detalle de los no cubiertos ===")
for k, v in sorted(a.items(), key=lambda x: -x[1]["ow"]):
    print("   %-9s %4dx%-4d %s" % (PSM.get(v["psm"], "?"), v["ow"], v["oh"], v["nombre"]))
