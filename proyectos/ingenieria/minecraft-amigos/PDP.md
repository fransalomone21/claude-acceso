# PDP — minecraft-amigos

## 1. El problema

Jugar hoy (2026-10-02) con amigos en un server propio, mundo nuevo y con mods
que renueven Minecraft sin volverlo "otro juego", sin perder la noche
arreglando launchers.

**Para quién es:** Fran y 3-4 amigos: la notebook de Fran (host, RTX 4060), su
PC, una notebook gamer y dos notebooks sin placa (i5 e i7 de 12.ª).

**Cómo sabremos que sirvió (validación):** jugaron la noche entera; nadie se
quedó afuera por instalación ni por FPS.

## 2. Qué NO es

- Nada de armas de fuego, tecnología ni mods de sistemas complejos (pedido de Fran).
- No es un server público: sólo ZeroTier / misma red.
- La sesión no automatiza el truco de la cuenta offline de Prism.

## 3. Naturaleza, y el rigor por aspecto

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `pack` (mods) | se rehace barato | requisitos conocidos | mínimo: directo | `armar_pack.py` lo reconstruye |
| `mundo` | un solo tiro una vez que se juega | conocidos | pleno: backup antes de cambiar mods | un mod de worldgen sacado a mitad rompe chunks |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 1 | La juntada — **Fase D** (armar, probar y poner en marcha) | un amigo instaló con el .bat y entró al server sin tocar nada a mano | `rcon.py list` muestra al amigo conectado | abierta |
| 2 | Server permanente (backups, más sesiones) | PENDIENTE: se escribe si Fran lo quiere | | |

**Fase en curso:** 1 — La juntada. Tipo: **Fase D** (fabricación, integración y prueba).

**Qué la cierra, exactamente:** `python herramientas\rcon.py list` devuelve al
menos un jugador que no es Fran, entrado con la instancia del paquete.

**Cómo se certifica:** ese comando, corrido por la sesión con la juntada en
marcha. En rojo se ve como `There are 0 of a max of 8 players online`.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Dos miembros de ZeroTier con la misma IP (kevo y apreta, ambos .8) | alta | media | mitigar: Fran le cambia la IP a uno en el panel | uno de los dos no ve el server |
| Notebook sin placa con pocos FPS | media | media | perfiles ALTO/MEDIO/BAJO del instalador | F3 < 30 fps → `instalar-juntada.bat bajo` |
| La notebook host se queda sin RAM (server 6 GB + cliente 6 GB) | baja | alta | 24 GB medidos; vigilar | tirones en todos a la vez → bajar el cliente de Fran a MEDIO |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-02 | Quedarse en Fabric 1.21.4 | 1.21.1 (más mods) / 26.x | la base de Fran ya andaba en 1.21.4 y todo lo elegido existe ahí; migrar costaba la noche |
| 2026-10-02 | Paquete = zip de la instancia + instalador .bat | .mrpack / importar a mano en Prism | el .bat además fija RAM, gráficos, Java y entra directo al server |
| 2026-10-02 | Sin mods de terreno nuevos (Terralith, Tectonic) | sumarlos | ya hay Promenade + Clifftree: apilar overhauls de terreno es la causa típica de mundos rotos |

## 7. Verificación

Server: arranque con `Done` en el log. Pack: sha1 de cada jar contra Modrinth.
Instalador: corrido en esta PC con dos perfiles, mirando los archivos que
escribe. **Límite:** no se probó en una PC sin Prism ni en una sin placa.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `plantillas/naturalezas/ingenieria.md` §Riesgo (backup antes de intervenir) | `mundo` | `cumple` | |
