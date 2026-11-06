# PDP — ps2-casa

**El PDP se escribe antes de la primera línea de trabajo y se corrige cuando
la realidad lo contradice.** Waterfall en las puertas, ágil adentro; el
criterio de salida es un resultado, nunca trabajo hecho.

---

## 1. El problema

**Antecedentes.** En la casa hay dos PS2 Slim SCPH-90001 (NTSC U/C, las
últimas que salieron; códigos de fecha **8C** y **1C**, leídos de las etiquetas
en fotos de Fran, 2026-11-06), con el puerto Ethernet que traen todas las Slim.
Hay dos memory cards: una Sony original de 8 MB (SCPH-10020) y una que dice
«Sony 64 MB MagicGate» —**hipótesis: es un clon**, Sony no fabricó tarjetas de
64 MB para PS2—, y un pendrive de 16 GB. Fran ya instaló FreeMcBoot alguna vez y
tiene ISOs de PS2 en la PC.

**Necesidad (N-01):** que el hermano y la mamá de Fran puedan jugar en las dos
PS2 de la casa los juegos que Fran tiene en la PC.

**Meta (G-01):** que las dos consolas queden listas para el uso diario de la
familia, sin que Fran tenga que intervenir cada vez.

**Objetivos** (cada uno traza a G-01; los números van a L1, cuando haya
concepto):

- **O-01** — que cualquiera de los dos elija un juego de una lista y lo arranque
  desde el encendido de la consola.
- **O-02** — que las partidas guardadas sobrevivan a una falla de una tarjeta.
- **O-03** — aprovechar la red: el catálogo de juegos en un solo lugar, la
  administración de las consolas desde la PC, y el juego entre las dos
  consolas donde el juego lo permita.

**Criterio de éxito.** Mínimo: una consola arranca sola el cargador y la mamá
de Fran abre un juego sin ayuda. Completo: las dos, con el catálogo por red y
las partidas respaldadas en la PC.

**Para quién es:** el hermano y la mamá de Fran (usuarios); Fran (interesado
que decide y que administra). Rigor bajo: casi todo se rehace barato.

**Cómo sabremos que sirvió (validación):** la mamá de Fran enciende la consola,
elige un juego y juega, sin llamarlo. Se valida mirándola, no midiendo bytes.

## 2. Qué NO es

- No se modifica el hardware (sin modchip, sin soldar, sin disco interno: la
  Slim no lo admite sin cirugía).
- No se cubren juegos que Fran no tenga ya en la PC.
- No es BLACK: la ingeniería reversa de BLACK vive en su proyecto.
- No se garantiza el juego online por internet: se evalúa (O-03), no se promete.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `arranque` (exploit en la memory card) | se rehace barato | desconocida (depende del ROM de cada consola) | iterar corto y medir | instalar y borrar de la tarjeta no toca la consola |
| `partidas` (formatear o instalar sobre una tarjeta) | **un solo tiro** | conocida | rigor pleno | formatear borra las partidas que tenga: respaldo antes, siempre |
| `red` (juegos por SMB o UDPBD) | se rehace barato | desconocida (velocidad, compatibilidad) | iterar corto y medir | todo vive en la PC y en un archivo de configuración |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | **Pre-Fase A**, *Concept Studies* — estudio de conceptos | Fran elige el concepto de arranque y de carga de juegos para cada consola, con el ROM de las dos medido | ROMVER de las dos anotado en ESTADO; la elección de Fran en §6 con su fecha | **abierta** |
| 1 | A+B ligeras — requisitos L0/L1 y la consola 1 como trazador | un juego arranca de punta a punta en la consola 1 por el camino elegido | captura de Fran del juego corriendo | — |
| 2 | C/D — la consola 2 y la familia | validación: la mamá de Fran abre un juego sola | Fran lo confirma con foto o video | — |

**Fase en curso:** 0 — Pre-Fase A (*Concept Studies*). No se hace: instalar
nada en las consolas ni elegir el exploit antes de medir el ROM.

**Qué la cierra, exactamente:** ¿está escrito en §6, con fecha, qué concepto
eligió Fran para cada consola (exploit de arranque + carga de juegos), y en
ESTADO el ROMVER de las dos? Sí o no.

**Cómo se certifica:** leer §6 y la tabla «Lo confirmado» de ESTADO. En rojo se
ve así: §6 vacía, o un ROMVER escrito sin la captura de Fran que lo respalde.

**La fase también puede cancelarse:** si las dos consolas resultan de ROM que
no arranca solo (sólo a mano desde el navegador), el concepto cambia de base y
la fase se reescribe con eso.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| ROM 2.30 en la consola 1C: el exploit no arranca solo | alta | media | mitigar: OpenTuna/FunTuna o PS2BBL, y si no, lanzar a mano | uLaunchELF muestra ROMVER 0230 |
| La tarjeta de 64 MB es clon y no acepta el exploit | alta | media | evitar: el exploit va en la Sony de 8 MB; el clon guarda partidas | la instalación falla o no arranca desde el clon |
| Formatear borra partidas que importan | media | alta | mitigar: copiar la tarjeta a la PC antes | cualquier paso que diga «formatear» |
| Juegos por USB lentos (USB 1.1 de la PS2) | alta | baja | aceptar como respaldo; la red es el camino principal | videos o cargas que se cortan |
| La PC apagada cuando quieren jugar por red | media | alta | decisión de Fran (pregunta abierta) | — |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-11-06 | Se declara el proyecto: es viable | dejarlo como pregunta suelta | la red de la Slim da carga de juegos desde la PC, administración remota y juego en LAN: hay sistema, no una respuesta |

## 7. Verificación

Cada entregable se verifica contra su requisito (L0/L1, a escribir en la fase
1) con una captura o foto de Fran: la sesión no ve las consolas.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `nucleo-ise.md §4` requisitos L0/L1 escritos | todos | `recortado` | en la Pre-A van las NGO; los requisitos se escriben al abrir la fase 1. Resta: ganamos no escribir requisitos para un concepto que el ROM puede cambiar; arriesgamos nada, porque no se diseña ni instala en la fase 0 |
