# Problemas técnicos — registro y clasificación

Lo que una sesión encuentra mal en el proyecto y **no** es estado: lo que se
corrigió sobre la marcha y lo estructural que queda para una sesión de
correcciones técnicas (Fran, 2026-10-23: «registrá y clasificá los problemas;
corregí los viables, y los estructurales informalos para otra sesión»). La
cascada lista los **abiertos** al entrar (`problemas.py aviso`, DA-080).

Desde el 2026-11-17 acá vive también **la evolución de la herramienta local de
podcasts** (Fran: «registrá errores de todo este proceso así en otras sesiones
optimizamos y evolucionamos la herramienta de podcasts local»): sintetizadores
en `podcast-2do-parcial/`, lanzadores en `podcast-resumen-2do/`, entorno en la PC
`C:\tts-iise` y en la notebook `%LOCALAPPDATA%\Temp\claude\tts-venv`.

El arreglo de una clase de error es una herramienta que lo mide, no una nota
que hay que acordarse de leer.

**Clase:** `contenido` · `forma` · `herramienta` · `método`.
**Estado:** `abierto` · `corregido` (con la evidencia) · `descartado` (con el motivo).

| ID | Clase | Estado | Problema | Cómo se vio | Arreglo y a qué nivel, o qué tendría que pasar |
|---|---|---|---|---|---|
| P1 | herramienta | corregido | Chatterbox sigue generando después de la última palabra: ruidos y respiraciones al final de las frases | Fran lo oyó en el podcast de la fase 12; medido con Whisper: 9 de 40 frases con ≥ 0,15 s de energía tras la última palabra (22 %) | `recortar_cola()` en `sintetizar-local.py`: corta 0,15 s después de la última palabra, con fundido de 40 ms; medido 10/40 → 3/40, la última palabra intacta en 39/40. Nivel herramienta. Qwen3-TTS lo tiene de fábrica en 1/15 (7 %) |
| P2 | herramienta | abierto | En la PC no entra más de un proceso de Chatterbox: con dos o tres a la vez se caen con 0xC0000005 | tres tandas caídas (en `safetensors.load_file` o generando mientras otro carga); medido: 7,4 GB de memoria comprometida por proceso, 15,3 GB de RAM, paginación que no crece con C: casi lleno (tope 27,6 GB) | `probable` (no se probó con disco libre). Tendría que pasar: que el lanzador mida la memoria comprometida libre y decida N solo; o liberar disco en C: (decisión de Fran) para que crezca la paginación. Medir cuánto compromete un proceso de Qwen antes de paralelizarlo |
| P3 | herramienta | abierto | Lanzar procesos desacoplados desde la PC (Win32_Process, Start-Process) «no andaba» | se cayeron igual que con SSH | `probable`: era P2 (se lanzaron tres a la vez), no el desacople. Probar UNO desacoplado; si anda, el lanzador no necesita un SSH abierto por proceso |
| P4 | herramienta | descartado | Hipótesis: Whisper en CUDA (ctranslate2) hacía caer a los procesos paralelos | con Whisper en CPU se cayeron igual | descartada por medición; Whisper queda en CPU igual (la CPU trabaja mientras la GPU genera) |
| P5 | herramienta | abierto | Dos entornos que divergen: la notebook (`tts-venv` en Temp, se borra si se limpia Temp) y la PC (`C:\tts-iise`); los scripts se copian a mano por scp | faltó faster-whisper en los dos; hubo que copiar `sintetizar-local.py` cuatro veces | un `sincronizar-pc.ps1` que copie guion, scripts y referencias y verifique MD5; el venv de la notebook fuera de Temp |
| P6 | herramienta | corregido | Qwen3-TTS pide transformers 4.57.3 y Chatterbox 5.2.0: no conviven en el mismo venv | conflicto de versiones al instalar | `C:\tts-iise\qwen-libs` con `pip --target` y `PYTHONPATH`, compartiendo torch; además huggingface-hub 0.36 y tokenizers 0.22.1 ahí adentro |
| P7 | herramienta | abierto | `loudnorm` de ffmpeg sube el WAV a 192 kHz: 53 MB por 2 min de muestra | tamaño de A/B/C-*.wav | agregar `-ar 44100` también a la salida .wav en `escribir()` |
| P8 | contenido | corregido | El guion y el PDF resumen v1 se escribieron sin inventario de conceptos: 26 de 56 términos del glosario afuera, y ejemplos mezclados como si fueran teoría | Fran: «no puede ser que leyendo 6 páginas apruebe» y «los ejemplos no son conceptos» | v2 medida contra `fuentes/glosario.md` por `resumenes/verificar-cobertura-resumen.py` (56/56, rojo si falta uno); ejemplos en cajas aparte. Nivel herramienta |
| P9 | herramienta | corregido | No había un paso que junte las partes en un COMPLETO, transcriba una muestra y suba al Drive: se hacía a mano | fases 12 y 13 | `podcast-2do-parcial/publicar-podcast.py`: concat con ffmpeg, faster-whisper sobre 2 min de una parte contra su guion (rojo si se oye menos del 85 %), `rclone copy` al Drive privado y `rclone lsf` de vuelta (rojo si falta algo) |
| P10 | herramienta | corregido | Qwen sin flash-attn en Windows usa poco la GPU (30 % con un proceso) y genera frase por frase | `nvidia-smi` durante la muestra | `medir-qwen.py` (2026-11-17, 3090, 8 frases): de a una 0,37 s de audio por s; **en lote 2,46** (6,6×). `sintetizar-qwen.py` genera en lote (`--lote`, 8 en la 3090). Costo: la memoria comprometida sube de 8,1 a 16,3 GB por proceso (ver P2): en la PC, un solo proceso de Qwen |
| P11 | herramienta | abierto | La pronunciación de siglas es un mapa a mano (`PRONUNCIA`), y la letra sola de una fase suena mal («la C» → «la sexo») | transcripción de la fase 12 | probar si Qwen lee bien las siglas sin el mapa (muestra transcripta); si no, el mapa va a un archivo propio compartido por los dos motores |
| P12 | método | abierto | `aprender.py agregar --triage propia` exige escribir antes la viñeta en `perfil-global/chequeo-de-trabajo.md`: dos lecciones quedaron sin registrar a fin de sesión | 2026-11-17 | ver HANDOFF; registrar en la próxima sesión de método |
| P13 | herramienta | corregido | El medidor de la muestra contaba como error lo que se oía bien: whisper escribe «SRR», «TRL», «B» donde el guion deletrea («ese erre erre»), y truncaba el guion a ojo | primera corrida de `publicar-podcast.py`: 80,8 % con el audio bien | letras deletreadas y siglas normalizadas a la misma forma, y comparación contra el tramo que la muestra cubre: 93,7 % en la misma parte. Lo que queda son homófonos reales («hacer o» → «acero», «vuele» → «duele»): a evitar en el guion |
