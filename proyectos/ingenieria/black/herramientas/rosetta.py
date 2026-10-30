"""La piedra Rosetta PS2 <-> Xbox, por ESTRUCTURA (sesion 132).

El mismo C++ de Criterion compilado para el EE (MIPS) y para el Pentium III (x86). Dos funciones son la misma si
tocan los mismos CAMPOS: de cada una se toma el conjunto de desplazamientos de memoria entre 0x10 y 0x2000 sobre
un registro base que no sea la pila, y se compara por Jaccard. El control es una POBLACION: la funcion de una
plataforma contra TODAS las de la otra; la pareja tiene que salir primera, no "parecida".

    python herramientas/rosetta.py par 0x001404A8 0x001BD3F0     # PS2 contra Xbox: rango de cada uno
    python herramientas/rosetta.py buscar-xbox 0x001404A8        # la funcion PS2 contra todo el XBE
    python herramientas/rosetta.py buscar-ps2 0x001EEFD0         # la funcion Xbox contra todo el ELF
    python herramientas/rosetta.py campo 0x2A4                   # accesos float/entero con ese desplazamiento
    python herramientas/rosetta.py --autotest                    # control positivo y negativo

Fuentes: el ELF (`elf_copia`), el grafo de funciones de black-datos, el default.xbe NTSC-U adentro del paquete
de black-pc 0.2.0 (`port_paquete_tercero`, se lee del zip sin extraer) y la lista de funciones de
black-pc/notes/functions.csv (`referencias_black`). Todo de terceros es DATO.

Salida: codigo 0 = verde, 1 = rojo (el autotest no discrimina), 2 = ENTORNO (falta un archivo).
"""
from __future__ import annotations

import csv
import io
import statistics
import struct
import sys
import zipfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

LO, HI = 0x10, 0x2000

# MIPS: opcodes de carga/guardado tipo I (base en rs, desplazamiento en el inmediato) y si son de float
MIPS_MEM = {0x20: 0, 0x21: 0, 0x23: 0, 0x24: 0, 0x25: 0, 0x27: 0, 0x37: 0, 0x1E: 0, 0x1F: 0,
            0x28: 0, 0x29: 0, 0x2B: 0, 0x3F: 0, 0x31: 1, 0x39: 1, 0x36: 1, 0x3E: 1}
SP = 29


def s16(x: int) -> int:
    return x - 0x10000 if x & 0x8000 else x


def entorno(msg: str):
    print(f"ENTORNO: {msg}")
    raise SystemExit(2)


def rutas():
    datos = ubicaciones.cargar().get("rutas", {})
    def r(clave):
        try:
            return Path(datos[clave]["ruta"])
        except KeyError:
            entorno(f"falta la clave {clave} en kb/ubicaciones.json")
    return r("elf_copia"), r("port_paquete_tercero"), r("referencias_black")


# ---------------------------------------------------------------- PS2
class Ps2:
    def __init__(self, elf: Path):
        import lectores_global as L
        if not elf.exists():
            entorno(f"no esta el ELF {elf}")
        self.elf = L.Elf(elf)
        g, self.ents = L.cargar_grafo()

    def fin(self, a: int) -> int:
        import bisect
        i = bisect.bisect_right(self.ents, a)
        return self.ents[i] if i < len(self.ents) else a + 0x400

    def campos(self, a: int, con_tipo=False):
        out = set()
        for p in range(a, self.fin(a), 4):
            try:
                w = self.elf.palabra(p)
            except KeyError:
                break
            op = w >> 26
            if op not in MIPS_MEM or (w >> 21) & 31 == SP:
                continue
            d = s16(w & 0xFFFF)
            if LO <= d < HI:
                out.add((d, MIPS_MEM[op]) if con_tipo else d)
        return out

    def funciones(self):
        return self.ents


# ---------------------------------------------------------------- Xbox
class Xbox:
    def __init__(self, paquete: Path, refs: Path):
        import capstone
        if not paquete.exists():
            entorno(f"no esta el paquete {paquete}")
        with zipfile.ZipFile(paquete) as z:
            nombre = next((n for n in z.namelist() if n.lower().endswith("game/default.xbe")), None)
            if not nombre:
                entorno("el paquete no trae game/default.xbe")
            self.xbe = z.read(nombre)
        d = self.xbe
        if d[:4] != b"XBEH":
            entorno("el default.xbe no empieza con XBEH")
        base, = struct.unpack_from("<I", d, 0x104)
        nsec, hdrs = struct.unpack_from("<II", d, 0x11C)
        self.secs = []
        for i in range(nsec):
            o = hdrs - base + i * 0x38
            _fl, va, vsz, raw, rsz = struct.unpack_from("<5I", d, o)
            self.secs.append((va, va + rsz, raw))
        csvp = refs / "black-pc-src" / "notes" / "functions.csv"
        if not csvp.exists():
            entorno(f"no esta {csvp}")
        self.fun = {}
        with open(csvp, newline="", encoding="utf-8") as f:
            for fila in csv.DictReader(f):
                self.fun[int(fila["address"], 16)] = int(fila["size"])
        self.cs = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
        self.cs.detail = True
        self.X86 = capstone.x86

    def bytes_de(self, a: int, n: int) -> bytes:
        for lo, hi, raw in self.secs:
            if lo <= a < hi:
                return self.xbe[raw + a - lo: raw + min(a + n, hi) - lo]
        return b""

    def campos(self, a: int, con_tipo=False):
        X = self.X86
        out = set()
        n = self.fun.get(a, 0x400)
        for ins in self.cs.disasm(self.bytes_de(a, n), a):
            for op in ins.operands:
                if op.type != X.X86_OP_MEM:
                    continue
                m = op.mem
                # (132) ebp NO se excluye: el XBE es MSVC sin frame pointer y usa ebp como registro comun
                # (NOTES de black-pc: el arma en [ebp+0xDC]). Excluirlo dejaba la maquina del arma sin +0xD8
                if m.base in (0, X.X86_REG_ESP) or m.index != 0:
                    continue
                if LO <= m.disp < HI:
                    es_f = ins.mnemonic.startswith("f") or ins.mnemonic.endswith("ss") or "xmm" in ins.op_str
                    out.add((m.disp, int(es_f)) if con_tipo else m.disp)
        return out

    def funciones(self):
        return sorted(self.fun)


PESO: dict | None = None  # --idf: el peso de un campo es su rareza en las dos plataformas (log N/df)


def jaccard(a: set, b: set) -> float:
    if PESO is None:
        return len(a & b) / len(a | b) if a or b else 0.0
    w = lambda s: sum(PESO.get(x, 0.0) for x in s)  # noqa: E731
    u = w(a | b)
    return w(a & b) / u if u else 0.0


def preparar_idf(ps2, xbox, caches):
    """Metodo 2 de (132): el plano pesa igual 0x1C (en miles de funciones) que 0xC8 (en pocas). Se pesa cada
    campo por log(N / df) sobre las dos plataformas juntas."""
    import math
    global PESO
    df, n = {}, 0
    for plat, cache in zip((ps2, xbox), caches):
        for f in plat.funciones():
            if f not in cache:
                cache[f] = plat.campos(f)
            if len(cache[f]) >= 3:
                n += 1
                for d in cache[f]:
                    df[d] = df.get(d, 0) + 1
    PESO = {d: math.log(n / c) for d, c in df.items()}


def ranking(q: set, otra, cache: dict) -> list[tuple[float, int]]:
    res = []
    for f in otra.funciones():
        if f not in cache:
            cache[f] = otra.campos(f)
        c = cache[f]
        if len(c) >= 3:
            res.append((jaccard(q, c), f))
    res.sort(reverse=True)
    return res


def informe(etiqueta: str, q: set, res, esperado: int | None):
    med = statistics.median(j for j, _ in res)
    print(f"{etiqueta}: {len(q)} campos; poblacion {len(res)} funciones, mediana Jaccard {med:.3f}")
    for i, (j, f) in enumerate(res[:5], 1):
        marca = "  <= la esperada" if f == esperado else ""
        print(f"   {i}. 0x{f:08X}  J={j:.3f}{marca}")
    if esperado is not None:
        rango = next((i for i, (_, f) in enumerate(res, 1) if f == esperado), None)
        print(f"   la esperada 0x{esperado:08X}: puesto {rango} de {len(res)}")
        return rango, med
    return None, med


def main(argv):
    if not argv:
        print(__doc__)
        return 0
    elf, paquete, refs = rutas()
    ps2, xbox = Ps2(elf), Xbox(paquete, refs)
    cps, cxb = {}, {}
    if "--idf" in argv:
        argv = [x for x in argv if x != "--idf"]
        preparar_idf(ps2, xbox, (cps, cxb))
        print("metodo 2: Jaccard pesado por rareza del campo (IDF)")
    cmd = argv[0]
    if cmd == "par":
        a, b = int(argv[1], 16), int(argv[2], 16)
        informe(f"PS2 0x{a:08X} contra el XBE", ps2.campos(a), ranking(ps2.campos(a), xbox, cxb), b)
        informe(f"Xbox 0x{b:08X} contra el ELF", xbox.campos(b), ranking(xbox.campos(b), ps2, cps), a)
        print(f"   comunes: {sorted(hex(x) for x in ps2.campos(a) & xbox.campos(b))}")
        return 0
    if cmd == "buscar-xbox":
        a = int(argv[1], 16)
        informe(f"PS2 0x{a:08X} contra el XBE", ps2.campos(a), ranking(ps2.campos(a), xbox, cxb), None)
        return 0
    if cmd == "buscar-ps2":
        b = int(argv[1], 16)
        res = ranking(xbox.campos(b), ps2, cps)
        informe(f"Xbox 0x{b:08X} contra el ELF", xbox.campos(b), res, None)
        for _, f in res[:3]:
            print(f"   0x{f:08X} campos: {sorted(hex(x) for x in cps[f])[:24]}")
        return 0
    if cmd == "campo":
        d = int(argv[1], 16)
        for nombre, plat in (("PS2", ps2), ("Xbox", xbox)):
            fl = en = 0
            for f in plat.funciones():
                for disp, es_f in plat.campos(f, con_tipo=True):
                    if disp == d:
                        fl += es_f
                        en += 1 - es_f
            print(f"{nombre}: +0x{d:X} en {fl} funciones como float, {en} como entero")
        return 0
    if cmd == "--autotest":
        # control positivo: una funcion contra su propia plataforma sale primera con J = 1
        a = 0x001404A8
        q = ps2.campos(a)
        res = ranking(q, ps2, cps)
        ok_pos = res[0][1] == a and abs(res[0][0] - 1.0) < 1e-9
        # control positivo QUE CRUZA la plataforma (el de arriba es ciego al lector x86): la maquina de estados del
        # arma del XBE tiene que tocar +0xD8 y +0xDC (NOTES de black-pc, FUN_001EEFD0)
        xb = xbox.campos(0x001EEFD0)
        ok_x86 = 0xD8 in xb and 0xDC in xb
        print(f"positivo x86 (FUN_001EEFD0 toca +0xD8 y +0xDC): {'OK' if ok_x86 else 'MAL'}")
        ok_pos = ok_pos and ok_x86
        # control negativo: el conjunto barajado (los mismos tamanos, otros valores) no encuentra pareja fuerte
        falso = {x + 0x400 for x in q}
        res_n = ranking(falso, xbox, cxb)
        ok_neg = res_n[0][0] < 0.3
        print(f"positivo (PS2 contra si misma, primera con J=1): {'OK' if ok_pos else 'MAL'}")
        print(f"negativo (campos corridos 0x400, mejor J {res_n[0][0]:.3f} < 0.3): {'OK' if ok_neg else 'MAL'}")
        return 0 if ok_pos and ok_neg else 1
    print(__doc__)
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
