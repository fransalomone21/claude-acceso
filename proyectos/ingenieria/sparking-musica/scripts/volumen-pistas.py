"""Volumen (RMS y percentil 90 en dBFS) y duracion de pistas de un .awb, decodificadas con vgmstream.
Sirve para ver si una pista quedo casi muda (un interludio) donde el juego espera un tema de pelea.
uso: python volumen-pistas.py <archivo.awb> <indice,indice,...>   (indice de onda base 0)"""
import subprocess, sys, tempfile, os, wave
import numpy as np

VG = r"C:\Users\frans\herramientas\vgmstream\vgmstream-cli.exe"
awb, idx = sys.argv[1], [int(x) for x in sys.argv[2].split(",")]
for i in idx:
    out = os.path.join(tempfile.gettempdir(), f"vp_{i}.wav")
    r = subprocess.run([VG, "-s", str(i + 1), "-o", out, awb], capture_output=True, text=True)
    if not os.path.exists(out):
        print(f"onda {i:3d}: NO DECODIFICA {r.stderr[-120:]}")
        continue
    with wave.open(out) as w:
        sr, ch = w.getframerate(), w.getnchannels()
        a = np.frombuffer(w.readframes(w.getnframes()), dtype="<i2").astype(np.float32) / 32768
    os.unlink(out)
    a = a.reshape(-1, ch).mean(axis=1)
    seg = a[: len(a) // sr * sr].reshape(-1, sr)
    rms = 20 * np.log10(np.sqrt((seg ** 2).mean(axis=1)) + 1e-9)
    print(f"onda {i:3d}: {len(a)/sr:6.1f} s  RMS medio {20*np.log10(np.sqrt((a**2).mean())+1e-9):6.1f} dBFS  "
          f"p10 {np.percentile(rms,10):6.1f}  p90 {np.percentile(rms,90):6.1f}")
