# Problemas técnicos — registro y clasificación

Lo que una sesión encuentra mal en el proyecto y **no** es estado: lo que se
corrigió sobre la marcha y lo estructural que queda para una sesión de
correcciones técnicas (Fran, 2026-10-23: «registrá y clasificá los problemas;
corregí los viables, y los estructurales informalos para otra sesión»). La
cascada lista los **abiertos** al entrar (`problemas.py aviso`, DA-080).

El arreglo de una clase de error es una herramienta que lo mide, no una nota
que hay que acordarse de leer («no acordarse de tener cuidado con la pico de
loro: comprarse la llave fija»).

**Clase:** `contenido` (lo que el producto dice) · `forma` (cómo se ve) ·
`herramienta` (la cadena que lo produce) · `método` (el sistema de trabajo de
todas las sesiones; también va a `defectos.py` y la fila nombra su DA).
**Estado:** `abierto` (para una sesión de correcciones técnicas) ·
`corregido` (con la evidencia) · `descartado` (con el motivo).

La cabecera de la tabla es la interfaz con `problemas.py`: no se le cambian
las cuatro primeras columnas.

| ID | Clase | Estado | Problema | Cómo se vio | Arreglo y a qué nivel, o qué tendría que pasar |
|---|---|---|---|---|---|
| P1 | herramienta | abierto | Las tareas `captura-pc`, `ps-pc` y `paso-sz` abren una ventana de consola visible (Windows Terminal ignora `-WindowStyle Hidden`) y la captura de las 20:16 la mostró encima de una pelea en curso | captura 2026-11-21 20:16 (Vegeta contra Whis, pantalla dividida) | DA-151. Arreglo listo, sin aplicar (frenado mientras jugaban): acción `conhost.exe --headless powershell.exe <mismos argumentos>` en las tres tareas; y un chequeo «está jugando» antes de cualquier tarea interactiva |
| P2 | herramienta | abierto | `oir.py` (grabar la salida de audio) por SSH da silencio exacto en las 6 salidas con el juego en plena pelea | corrida 2026-11-21 ~20:30, -180 dBFS en todas | DA-150. Probar en la sesión interactiva (tarea sin ventana) con un tono de control, con el juego cerrado |
