"""Que tema de Linkin Park suena en una grabacion de la PC (oir.py), ventana por ventana.
Compara contra los mp3 fuente (los mismos con que se armaron v1..v5 y Ryo) por correlacion cruzada normalizada a
2 kHz sobre la senal derivada (la derivada le saca peso al bajo y al ruido grave de los efectos).
uso: python que-suena.py <grabacion.wav> [--ventana 4] [--paso 2]
Salida, una linea por ventana: t, nivel dBFS, tema mas parecido, segundo del tema, puntaje (0..1).
Un puntaje >= 0.25 es el tema (el control con la grabacion de un tema conocido da > 0.5; el ruido < 0.12).
La primera vez decodifica los mp3 a una cache (.npy) en lp-trabajo\\_intermedios\\huellas."""
import glob, os, re, subprocess, sys, wave
import numpy as np

SR = 2000
B = r"C:\Users\frans\herramientas\lp-trabajo\_intermedios"
MUS = r"C:\Users\frans\Desktop\00 - Personal\Musica"
CACHE = os.path.join(B, "huellas")


def prep(x):
    x = np.diff(x.astype(np.float32))
    return x / (np.std(x) + 1e-9)


def decod(path):
    r = subprocess.run(["ffmpeg", "-v", "error", "-i", path, "-map", "0:a:0", "-ac", "1", "-ar", str(SR),
                        "-f", "f32le", "-"], capture_output=True)
    return np.frombuffer(r.stdout, dtype=np.float32)


def biblioteca():
    os.makedirs(CACHE, exist_ok=True)
    mp3 = sorted(glob.glob(os.path.join(B, "fuentes", "**", "*.mp3"), recursive=True)) + \
        sorted(glob.glob(os.path.join(MUS, "*.mp3")))
    lib = {}
    for p in mp3:
        nom = re.sub(r"^(\d+ - |Linkin Park - )", "", os.path.basename(p)[:-4])
        c = os.path.join(CACHE, re.sub(r"[^\w.-]", "_", nom) + ".npy")
        if not os.path.exists(c):
            np.save(c, prep(decod(p)))
        lib.setdefault(nom, np.load(c))
    return lib


def leer_wav(p):
    with wave.open(p) as w:
        sr, ch = w.getframerate(), w.getnchannels()
        a = np.frombuffer(w.readframes(w.getnframes()), dtype="<i2").astype(np.float32) / 32768
    a = a.reshape(-1, ch).mean(axis=1)
    paso = sr // SR
    return a[: len(a) // paso * paso].reshape(-1, paso).mean(axis=1)


def ncc(x, y):
    """max de la correlacion normalizada de x (corto) contra y (largo), y su posicion."""
    n, m = len(x), len(y)
    if m < n:
        return 0.0, 0
    N = 1 << int(np.ceil(np.log2(n + m)))
    c = np.fft.irfft(np.fft.rfft(y, N) * np.conj(np.fft.rfft(x, N)), N)[: m - n + 1]
    e = np.concatenate([[0], np.cumsum(y.astype(np.float64) ** 2)])
    den = np.sqrt(e[n:] - e[:-n]) * np.linalg.norm(x) + 1e-9
    r = c / den
    k = int(np.argmax(r))
    return float(r[k]), k


def main():
    args = sys.argv[1:]
    ven = float(args[args.index("--ventana") + 1]) if "--ventana" in args else 4.0
    paso = float(args[args.index("--paso") + 1]) if "--paso" in args else 2.0
    crudo = leer_wav(args[0])
    rec = prep(crudo)
    lib = biblioteca()
    n, s = int(ven * SR), int(paso * SR)
    previo = None
    print(f"# {args[0]}  {len(rec)/SR:.0f} s  biblioteca: {len(lib)} temas")
    for i in range(0, len(rec) - n + 1, s):
        x = rec[i:i + n]
        db = 20 * np.log10(np.sqrt(np.mean(crudo[i:i + n] ** 2)) + 1e-9)
        mejor = (0.0, "-", 0)
        if previo:  # primero el tema de la ventana anterior: casi siempre sigue
            sc, k = ncc(x, lib[previo])
            mejor = (sc, previo, k)
        if mejor[0] < 0.25:
            for nom, y in lib.items():
                sc, k = ncc(x, y)
                if sc > mejor[0]:
                    mejor = (sc, nom, k)
        previo = mejor[1] if mejor[0] >= 0.25 else None
        tema = mejor[1] if mejor[0] >= 0.25 else "(ningun tema LP)"
        print(f"{i/SR:6.1f} s  {db:6.1f} dBFS  {tema[:40]:40s}  en {mejor[2]/SR:6.1f} s  puntaje {mejor[0]:.2f}")


if __name__ == "__main__":
    main()
