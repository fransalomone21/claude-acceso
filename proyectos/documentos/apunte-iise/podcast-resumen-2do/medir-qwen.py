"""P10 y P2 de PROBLEMAS.md: Qwen3-TTS frase por frase contra en lote, y su memoria.
En la PC: $env:PYTHONPATH="C:\\tts-iise\\qwen-libs"; python medir-qwen.py C:\\tts-iise\\qwen-modelo C:\\tts-iise\\podcast"""
import sys, time, os
import torch, psutil
sys.path.insert(0, sys.argv[2])
import importlib.util
spec = importlib.util.spec_from_file_location("q", os.path.join(sys.argv[2], "sintetizar-qwen.py"))
q = importlib.util.module_from_spec(spec); spec.loader.exec_module(q)

frases = [
    "La estructura de desglose del trabajo parte todo el trabajo del proyecto en un árbol.",
    "El camino crítico es el camino más largo de punta a punta, y no tiene holgura.",
    "La estimación de arriba hacia abajo la hace alguien con experiencia, por analogía.",
    "Verificar es construir el sistema correctamente; validar, construir el sistema correcto.",
    "La revisión de alistamiento para el vuelo da el ve o no ve del lanzamiento.",
    "Un riesgo puede pasar; un problema ya pasó.",
    "La carga útil es el cantante, y la plataforma son los plomos.",
    "El nivel de madurez seis es un prototipo demostrado en un ambiente relevante.",
]
m = q.Motor(sys.argv[1])
proc = psutil.Process()
print(f"cargado: RAM {proc.memory_info().rss/2**30:.2f} GB, comprometida {proc.memory_info().private/2**30:.2f} GB", flush=True)
p = m.prompts["CARO"]
torch.cuda.synchronize(); t = time.time(); dur = 0
for f in frases:
    w, sr = m.m.generate_voice_clone(text=f, language="Spanish", voice_clone_prompt=p, **q.PARAM)
    dur += len(w[0]) / sr
uno = time.time() - t
print(f"de a una: {uno:.1f} s de reloj para {dur:.1f} s de audio -> {dur/uno:.2f} s audio por s", flush=True)
try:
    torch.cuda.synchronize(); t = time.time()
    w, sr = m.m.generate_voice_clone(text=frases, language=["Spanish"] * len(frases), voice_clone_prompt=p, **q.PARAM)
    lote = time.time() - t; dur2 = sum(len(x) for x in w) / sr
    print(f"en lote: {lote:.1f} s de reloj para {dur2:.1f} s de audio -> {dur2/lote:.2f} s audio por s", flush=True)
except Exception as e:
    print("lote no anda:", type(e).__name__, str(e)[:200], flush=True)
print(f"pico VRAM {torch.cuda.max_memory_allocated()/2**30:.1f} GB; comprometida {proc.memory_info().private/2**30:.2f} GB", flush=True)
