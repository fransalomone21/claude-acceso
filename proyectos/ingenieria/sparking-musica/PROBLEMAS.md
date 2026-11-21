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
| P1 | contenido | abierto | Voces en inglés en Whis, Vegeta Super/Ultra Ego y ~46 bancos más: los mods latinos de esos personajes pisan solo la voz japonesa y el juego está (probable) con voces en inglés | Fran, 2026-11-21 ~20:00; `docs/voces-cobertura.txt` (48 de 205 bancos solo en japonés) | inmediato: idioma de voces → japonés (lo hace Fran en Opciones; 136 bancos latinos, 69 en japonés). Completo: paquete que copie cada `_JP` latino como `_US` (pide `retoc`, descarga con su sí) |
| P2 | contenido | abierto | La música de fondo se va al tirar el ataque final de Vegeta | Fran, 2026-11-21 ~20:00 | hipótesis en `docs/investigacion-voces-y-ultimate.md` (Conclusion); lo primero, mirar qué música Sparking tiene elegida Vegeta en Personalización; si es eso, elegirle un tema LP; si no, el mod que saca la música Sparking |
| P3 | método | abierto | Ninguna versión de música (v1–v5, Ryo) se oyó antes de entregarse: la sesión no oye la PC | DA-150 | `pc-casa-control/scripts/oir.py` (loopback) escrito; por SSH da silencio exacto: falta correrlo en la sesión interactiva con un tono de control, con el juego cerrado |
