"""v6 (Ryo Framework): las 23 filas de tele (DLC Anime Music Pack: M_2000..M_2022) con un tema famoso de LP cada una.
Reemplazo por NOMBRE de pista en tiempo de ejecucion (Ryo), sin tocar los paquetes firmados del DLC.
Escribe, en el mod de Reloaded SZ.Tele.LinkinPark, ryo\\SparkingZERO-Win64-Shipping\\<acb>.acb\\<cue>.hca
(M_2000..M_2010 -> bgm_DLC_01.acb; M_2011..M_2022 -> bgm_DLC_02.acb), y la variante _SPK (musica del modo Sparking)
con el mismo audio. Actualiza los nombres BGM_M2xxx en el JSON de ZeroSpark. Uso: python armar-ryo.py [--solo-lista]"""
import glob, json, os, re, shutil, subprocess, sys

B = r"C:\Users\frans\herramientas\lp-trabajo\_intermedios"
MUS = r"C:\Users\frans\Desktop\00 - Personal\Musica"
MOD = r"C:\Users\frans\herramientas\reloaded\Reloaded-II\Mods\SZ.Tele.LinkinPark\ryo\SparkingZERO-Win64-Shipping"
VG = r"C:\Users\frans\herramientas\sz-audio\Tools\VGAudioCli.exe"
TMP = r"C:\Users\frans\herramientas\reloaded\descarga\tmp-ryo.wav"
JS = [r"C:\Users\frans\herramientas\lp-trabajo\LISTO\ZeroSpark\LinkinParkNombres.json"]
TEMAS = ["Numb", "Given Up", "Pushing Me Away", "A Place for My Head", "By Myself", "Forgotten", "Cure for the Itch",
         "Nobody's Listening", "Session", "In the End", "Crawling", "Papercut", "One Step Closer", "Faint",
         "Somewhere I Belong", "Breaking the Habit", "Shadow of the Day", "Leave Out All The Rest", "Lying from You",
         "Hit the Floor", "Points of Authority", "Runaway", "Easier to Run"]
assert len(TEMAS) == 23 and TEMAS[1] == "Given Up"
todos = sorted(glob.glob(os.path.join(B, "fuentes", "**", "*.mp3"), recursive=True)) + sorted(glob.glob(os.path.join(MUS, "*.mp3")))


def titulo(p):
    return re.sub(r"^(\d+ - |Linkin Park - )", "", os.path.basename(p)[:-4]).lower()


fuente = {}
for t in TEMAS:
    m = [p for p in todos if titulo(p) == t.lower()]
    if not m:
        raise SystemExit("FALTA el mp3 de: " + t)
    fuente[t] = m[0]
for i, t in enumerate(TEMAS):
    print("M_%d <- %s" % (2000 + i, t))
if "--solo-lista" in sys.argv:
    raise SystemExit(0)

for i, t in enumerate(TEMAS):
    n = 2000 + i
    acb = "bgm_DLC_01.acb" if n <= 2010 else "bgm_DLC_02.acb"
    d = os.path.join(MOD, acb)
    os.makedirs(d, exist_ok=True)
    r = subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", fuente[t], "-map", "0:a:0", "-ar", "48000", "-ac", "2",
                        "-c:a", "pcm_s16le", "-map_metadata", "-1", TMP], capture_output=True, text=True)
    if r.returncode:
        raise SystemExit("ffmpeg " + t + ": " + r.stderr[-300:])
    seg = float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", TMP],
                               capture_output=True, text=True).stdout)
    muestras = int(seg * 48000)
    out = os.path.join(d, "M_%d.hca" % n)
    r = subprocess.run([VG, "-i", TMP, "-o", out, "-l", "0-%d" % (muestras - 1), "--hcaquality", "Highest"],
                       capture_output=True, text=True)
    if not os.path.exists(out):
        raise SystemExit("VGAudio " + t + ": " + r.stdout[-300:])
    shutil.copy(out, os.path.join(d, "M_%d_SPK.hca" % n))
    print("%s M_%d %.0f s %.1f MB" % (acb, n, seg, os.path.getsize(out) / 1e6))
os.remove(TMP)
exe = os.path.join(os.path.dirname(MOD), "SparkingZERO-Win64-Shipping.exe")
if os.path.isdir(exe):
    shutil.rmtree(exe)

for p in JS:
    js = json.load(open(p, encoding="utf-8"))
    for blk in js.values():
        if isinstance(blk, dict) and "SetBGMNames" in blk:
            for i, t in enumerate(TEMAS):
                blk["SetBGMNames"]["BGM_M%d" % (2000 + i)] = t
                blk["SetBGMNames"]["BGM_M%d_SPK" % (2000 + i)] = t
    json.dump(js, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
print("nombres actualizados")
