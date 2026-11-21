"""Oir la PC: graba lo que sale por los parlantes (WASAPI loopback) y anota el nivel cada medio segundo.
Corre en la PC (C:\\Users\\Fran\\lp-todo\\oir.py), por SSH, sin ventana. Requiere: pip install soundcard numpy.
uso: python oir.py <segundos> <salida_sin_extension>
Deja <salida>.wav (48 kHz estereo, 16 bits) y <salida>.csv (t_s, rms_dbfs). Imprime un resumen."""
import sys, wave, numpy as np, soundcard as sc

seg = float(sys.argv[1]); out = sys.argv[2]; sr = 48000
spk = sc.default_speaker()
mic = sc.get_microphone(id=str(spk.name), include_loopback=True)
print("dispositivo:", spk.name)
with mic.recorder(samplerate=sr, channels=2) as rec:
    data = rec.record(numframes=int(seg * sr))
pcm = np.clip(data, -1, 1)
with wave.open(out + ".wav", "wb") as w:
    w.setnchannels(2); w.setsampwidth(2); w.setframerate(sr)
    w.writeframes((pcm * 32767).astype("<i2").tobytes())
mono = pcm.mean(axis=1); paso = sr // 2
filas = []
for i in range(0, len(mono) - paso + 1, paso):
    r = float(np.sqrt(np.mean(mono[i:i + paso] ** 2)))
    filas.append((i / sr, 20 * np.log10(max(r, 1e-9))))
with open(out + ".csv", "w") as f:
    f.write("t_s,rms_dbfs\n")
    for t, db in filas:
        f.write(f"{t:.1f},{db:.1f}\n")
dbs = [d for _, d in filas]
print(f"ventanas: {len(dbs)}  min {min(dbs):.1f}  mediana {np.median(dbs):.1f}  max {max(dbs):.1f} dBFS")
