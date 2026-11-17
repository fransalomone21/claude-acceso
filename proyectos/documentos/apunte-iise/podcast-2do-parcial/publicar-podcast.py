"""P9 de PROBLEMAS.md: junta las partes en un COMPLETO, transcribe el comienzo de una parte contra su
guion (porcentaje del guion que se oye) y sube todo al Drive privado, listando de vuelta.

Uso (python del tts-venv, en la notebook):
  python publicar-podcast.py --partes DIR --base "Nombre base" --guion guion.md --drive "remote:carpeta" [--muestra 1]
Las partes se llaman "<base> - parte NN.m4a". Sale en 1 si falta una parte, si la muestra oye menos
del 85 % de su texto, o si el listado del Drive no tiene todo lo subido.
"""
import argparse, difflib, importlib.util, re, subprocess, sys, unicodedata
from pathlib import Path

AQUI = Path(__file__).parent
RCLONE = ["rclone", "--config", str(Path.home() / ".config/rclone/rclone.conf")]


LETRAS = {"be": "b", "ce": "c", "de": "d", "efe": "f", "ge": "g", "hache": "h", "jota": "j", "ka": "k",
          "ele": "l", "eme": "m", "ene": "n", "pe": "p", "cu": "q", "erre": "r", "ese": "s", "te": "t",
          "ve": "v", "equis": "x"}


def pal(t):
    """Palabras normalizadas. Las letras deletreadas («ese erre erre») y las siglas que escribe whisper
    («SRR») se llevan a la misma forma: letras sueltas pegadas (P13: el medidor contaba como error lo
    que se oia bien)."""
    t = "".join(c for c in unicodedata.normalize("NFD", t.lower()) if unicodedata.category(c) != "Mn")
    out = []
    for w in re.findall(r"[a-zñ]+", t):
        w = LETRAS.get(w, w)
        if len(w) == 1 and out and len(out[-1]) <= 4 and out[-1].isalpha() and out[-1] not in ("y", "o", "a", "e", "u"):
            out[-1] += w
        else:
            out.append(w)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--partes", required=True); ap.add_argument("--base", required=True)
    ap.add_argument("--guion", required=True); ap.add_argument("--drive", required=True)
    ap.add_argument("--muestra", type=int, default=1); ap.add_argument("--segundos", type=int, default=120)
    ap.add_argument("--titulos", help="archivo con un titulo por parte, en orden")
    a = ap.parse_args()
    d = Path(a.partes).resolve()   # absoluta: el ffmpeg de WinGet no ve rutas relativas (2026-11-17)
    spec = importlib.util.spec_from_file_location("s", AQUI / "sintetizar-local.py")
    s = importlib.util.module_from_spec(spec); spec.loader.exec_module(s)
    s.GUION = Path(a.guion)
    secciones = s.secciones()
    partes = [d / f"{a.base} - parte {k:02d}.m4a" for k in range(1, len(secciones) + 1)]
    falta = [p.name for p in partes if not p.exists()]
    if falta:
        print("FALTAN PARTES:", falta); sys.exit(1)

    completo = d / f"{a.base} - COMPLETO.m4a"
    lista = d / "concat.txt"
    lista.write_text("".join(f"file '{p.as_posix()}'\n" for p in partes), encoding="utf-8")
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "concat", "-safe", "0", "-i", str(lista),
                    "-c", "copy", str(completo)], check=True)
    dur = float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0",
                                str(completo)], capture_output=True, text=True).stdout.strip())
    print(f"COMPLETO {dur / 60:.1f} min -> {completo.name}")

    from faster_whisper import WhisperModel
    m = WhisperModel("small", device="cpu", compute_type="int8")
    segs, _ = m.transcribe(str(partes[a.muestra - 1]), language="es", clip_timestamps=[0, a.segundos])
    oido = pal(" ".join(x.text for x in segs))
    ref = pal(" ".join(s.pronunciar(t) for q, t in secciones[a.muestra - 1] if q != "PAUSA"))
    sm = difflib.SequenceMatcher(None, ref, oido, autojunk=False)
    # se compara contra el tramo del guion que la muestra alcanza a cubrir (hasta la ultima coincidencia)
    ult = max((b.a + b.size for b in sm.get_matching_blocks() if b.size), default=1)
    ok = sum(b.size for b in sm.get_matching_blocks())
    pct = ok / ult * 100
    print(f"MUESTRA parte {a.muestra}, {a.segundos} s: se oye el {pct:.1f} % del guion")

    # nombres por tema (Fran, 2026-11-17): "NN - <titulo>.m4a" y "00 - Completo (N min).m4a"
    titulos = Path(a.titulos).read_text(encoding="utf-8").strip().splitlines() if a.titulos else []
    if titulos and len(titulos) != len(partes):
        print(f"TITULOS: {len(titulos)} para {len(partes)} partes"); sys.exit(1)
    nombres = [f"{k:02d} - {t}.m4a" for k, t in enumerate(titulos, 1)] or [p.name for p in partes]
    nombre_completo = f"00 - Completo ({dur / 60:.0f} min).m4a" if titulos else completo.name
    for p, n in zip(partes + [completo], nombres + [nombre_completo]):
        subprocess.run(RCLONE + ["copyto", str(p), f"{a.drive}/{n}"], check=True)
    remoto = subprocess.run(RCLONE + ["lsf", a.drive], capture_output=True, text=True).stdout.split("\n")
    subidos = nombres + [nombre_completo]
    no = [n for n in subidos if n not in remoto]
    print(f"DRIVE: {len(subidos) - len(no)} de {len(subidos)} listados" + (f"; faltan {no}" if no else ""))
    sys.exit(1 if no or pct < 85 else 0)


if __name__ == "__main__":
    main()
