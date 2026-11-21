"""v5: las 21 filas visibles del menu 'Musica de fondo' que viven en bgm_main_Cnk_00 (M_0102..M_0122) con UN tema
famoso de LP cada una (Hybrid Theory y Meteora predominan). Pedido de Fran 2026-11-21 (sparking-musica).
M_0123 (Invisible, bgm_main Cue_82) NO se toca. Fila -> onda: acb-cues.py (puerto 1, +84).
Escribe Cue_N.wav en todo\\bgm_main_Cnk_00 (mueve la N.hca y el Cue_N.wav viejos a respaldo-v4-filas) y
actualiza BGM_M0102..M0122 en los dos JSON de nombres de ZeroSpark. Uso: python armar-filas.py [--solo-lista]"""
import glob, json, os, re, shutil, subprocess, sys

B = r"C:\Users\frans\herramientas\lp-trabajo\_intermedios"
MUS = r"C:\Users\frans\Desktop\00 - Personal\Musica"
JS = [r"C:\Users\frans\herramientas\lp-trabajo\LISTO\ZeroSpark\LinkinParkNombres.json"]
# fila M_01xx -> (onda de Cnk_00 en el indice global, cancion)
FILAS = [(102, 93, "In the End"), (103, 94, "Numb"), (104, 95, "Crawling"), (105, 96, "Faint"),
         (106, 97, "One Step Closer"), (107, 98, "Papercut"), (108, 99, "Somewhere I Belong"),
         (109, 100, "Breaking the Habit"), (110, 103, "What I've Done"), (111, 104, "Points of Authority"),
         (112, 105, "Lying from You"), (113, 106, "Bleed It Out"), (114, 107, "Hit the Floor"), (115, 108, "Runaway"),
         (116, 109, "Easier to Run"), (117, 110, "From the Inside"), (118, 111, "With You"), (119, 112, "Don't Stay"),
         (120, 113, "Figure.09"), (121, 114, "Castle of Glass"), (122, 115, "Burn It Down")]
assert len(FILAS) == 21 and len({o for _, o, _ in FILAS}) == 21 and len({t for _, _, t in FILAS}) == 21
todos = sorted(glob.glob(os.path.join(B, "fuentes", "**", "*.mp3"), recursive=True)) + sorted(glob.glob(os.path.join(MUS, "*.mp3")))


def titulo(p):
    return re.sub(r"^(\d+ - |Linkin Park - )", "", os.path.basename(p)[:-4]).lower()


fuente = {}
for _, _, t in FILAS:
    m = [p for p in todos if titulo(p) == t.lower()]
    if not m:
        raise SystemExit("FALTA el mp3 de: " + t)
    fuente[t] = m[0]
for m, o, t in FILAS:
    print("M_%04d  onda %d  <- %s  (%s)" % (m, o, t, fuente[t]))
if "--solo-lista" in sys.argv:
    raise SystemExit(0)

d = os.path.join(B, "todo", "bgm_main_Cnk_00")
resp = os.path.join(B, "respaldo-v4-filas")
os.makedirs(resp, exist_ok=True)
for m, o, t in FILAS:
    for f in ("%d.hca" % o, "Cue_%d.wav" % o):
        s = os.path.join(d, f)
        if os.path.exists(s):
            shutil.move(s, os.path.join(resp, f))
    out = os.path.join(d, "Cue_%d.wav" % o)
    r = subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", fuente[t], "-map", "0:a:0", "-ar", "48000", "-ac", "2",
                        "-c:a", "pcm_s16le", "-map_metadata", "-1", out], capture_output=True, text=True)
    if r.returncode or not os.path.exists(out):
        raise SystemExit("fallo %s: %s" % (t, r.stderr[-400:]))
    print("Cue_%d.wav %.0f MB" % (o, os.path.getsize(out) / 1e6))

for p in JS:
    js = json.load(open(p, encoding="utf-8"))
    for blk in js.values():
        if isinstance(blk, dict) and "SetBGMNames" in blk:
            for m, o, t in FILAS:
                blk["SetBGMNames"]["BGM_M%04d" % m] = t
    json.dump(js, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("nombres actualizados en", JS)
