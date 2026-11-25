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
| 1 | La juntada — **Fase D** (armar, probar y poner en marcha) | un amigo instaló con el .bat y entró al server sin tocar nada a mano | `rcon.py list` muestra al amigo conectado | **cancelada** (2026-11-24) |
| 2 | El pack nuevo y la tienda de mods — **Fase C/D** (diseño de detalle, armar y probar) | (a) Fran arma una combinación desde la tienda y la instancia de la notebook y la de la PC quedan iguales al pack al abrir el juego; (b) los dos sabotajes de la tienda dan rojo; (c) Fran y Kevin juegan en el server de la notebook | (a) hash SHA-1 de los jars de cada instancia contra el pack; (b) la salida de los sabotajes; (c) `rcon.py list` con Kevin conectado | abierta |

**Por qué se canceló la fase 1:** Fran pidió (2026-11-24) otra versión y otro pack: la juntada 1.21.4 la
reemplaza la fase 2. Lo aprendido que sigue valiendo: «Abrir en LAN» patea las cuentas offline (se usa
server con `online-mode=false`), y Tough As Nails (frío, calor y sed) no le gustó a Fran. El server y los
mundos 1.21.4 quedan como están.

**Fase en curso:** 2 — El pack nuevo y la tienda. Tipo: **Fase C/D**. Requisitos:
`docs/10-requisitos.md`; diseño: `docs/fase-2-tienda.md`.

**Qué la cierra, exactamente:** las tres mitades de la fila 2.

**Cómo se certifica:** (a) un script compara el SHA-1 de cada jar de las dos instancias contra el pack
(en rojo: un jar de más o de menos, nombrado); (b) los sabotajes de L1-06 y L1-10 corren y salen en rojo
por el motivo esperado; (c) `rcon.py list` muestra a Kevin.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Dos miembros de ZeroTier con la misma IP (kevo y apreta, ambos .8) | alta | media | mitigar: Fran le cambia la IP a uno en el panel | uno de los dos no ve el server |
| Notebook sin placa con pocos FPS | media | media | perfiles ALTO/MEDIO/BAJO del instalador | F3 < 30 fps → `instalar-juntada.bat bajo` |
| La notebook host se queda sin RAM (server 6 GB + cliente 6 GB) | baja | alta | 24 GB medidos; vigilar | tirones en todos a la vez → bajar el cliente de Fran a MEDIO |
| La notebook no tiene disco para el server nuevo (9 GB libres el 2026-11-24) | alta | alta | mitigar: pasar las ISOs de PS2 a la PC antes (juegos-casa, Fran dijo sí) | menos de 15 GB libres en la notebook |
| Una combinación de mods rompe el mundo al sacar un mod de generación | media | alta | evitar: cada combinación con su mundo; respaldo del mundo antes de cambiar la lista | el server de prueba registra errores de chunks |
| Un mod de CurseForge prohíbe la descarga por terceros y packwiz no lo puede bajar | media | media | aceptar: se marca en la tienda como «descarga manual» | `packwiz` avisa «manual download» |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-02 | Quedarse en Fabric 1.21.4 | 1.21.1 (más mods) / 26.x | la base de Fran ya andaba en 1.21.4 y todo lo elegido existe ahí; migrar costaba la noche |
| 2026-10-02 | Paquete = zip de la instancia + instalador .bat | .mrpack / importar a mano en Prism | el .bat además fija RAM, gráficos, Java y entra directo al server |
| 2026-10-02 | Sin mods de terreno nuevos (Terralith, Tectonic) | sumarlos | ya hay Promenade + Clifftree: apilar overhauls de terreno es la causa típica de mundos rotos |
| 2026-11-24 | **Minecraft 1.21.1 con NeoForge** para el pack nuevo | 1.20.1 (más mods, dos años más vieja); 1.21.11 y 26.x (más nuevas, 40-65 % menos mods); seguir en 1.21.4 | medido en Modrinth (`docs/fase-2-tienda.md` §1): 1.21.1 es la más nueva a menos de 6 % del máximo, y NeoForge lleva los mods de contenido grande |
| 2026-11-24 | **La tienda de mods con packwiz**: una lista única publicada desde la notebook, cada Prism se sincroniza sola, nada se publica sin arrancar en un server de prueba (Fran: «sí, así, sencillo y probado») | el carrito de Prism por máquina; combinaciones fijas armadas por la sesión | el carrito de Prism no sincroniza las dos máquinas ni prueba; las fijas obligan a pedirle a la sesión cada cambio, que es lo que Fran no quiere |
| 2026-11-24 | **Better MC 5 entra como una combinación más**, sin Serene Seasons | adoptarlo como único pack | Fran pidió varias combinaciones; es pesado (8 GB) y trae estaciones |

## 7. Verificación

Server: arranque con `Done` en el log. Pack: sha1 de cada jar contra Modrinth.
Instalador: corrido en esta PC con dos perfiles, mirando los archivos que
escribe. **Límite:** no se probó en una PC sin Prism ni en una sin placa.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `plantillas/naturalezas/ingenieria.md` §Riesgo (backup antes de intervenir) | `mundo` | `cumple` | |
