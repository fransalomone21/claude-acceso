# Predicciones de (116) — COOP-C pieza 2a: el disparo de J2 suena

Escritas **antes** de abrir el emulador (2026-10-02). Diseño: `docs/16` «La pieza 2 a nivel instrucción»;
código: `herramientas/coop_sonido.py` (13 palabras en `0x0046EE00`), el envoltorio 4 del aislador sale por
`j SONJ2`. Banco: `herramientas/sonido_pieza_banco.py` (Town, nivel 2: el de la S4 de (111), sin tiroteo de fondo;
Wilderness no sirve: pistola con silenciador).

## Mecanismo (por qué la variable llega a la métrica)

J2 aprieta disparar (mando falso 2) → su código de armas llama `FUN_001D6F90(V)` mientras el por cuadro tiene
`AISLAR_BANDERA` prendida → el gancho de la entrada salta al envoltorio 4 → cuenta «salteada»
(`AISLAR_CUENTAS + 8·4 + 4` = `0x0046E064`) → **con la pieza**: `j SONJ2` → la guarda `*(*(X+0x24)+0x1E54)` (la misma
que usa J, que suena) → `FUN_001D7020(V)` crea una de las dos muestras del disparo en el emisor `V+0x40` → se oye
(WASAPI loopback, `grabar_audio.py` adentro de `inspeccion_coop.py`). **Sin la pieza** (`--sin-sonido`): el envoltorio
vuelve con `jr ra` y sólo se oyen los impactos (la S4 de (111)).

## P1 — con la pieza, J2 suena (carga 1)

- **Predicción:** en `fuego-J2` (3 s), el nivel de audio medio sube como el de `fuego-J`: del orden de **≥ 6000**
  (en (111) sin el aislador: 8349; `fuego-J`: ~9000), **continuo**, contra `quieto` (~2300–2800). La cuenta salteada
  del envoltorio 4 sube con los disparos de J2 (> 0 en la escena).
- **Refuta:** media de `fuego-J2` en el rango del control (~3000, sólo ráfagas de impacto) con la cuenta salteada
  subiendo → `SONJ2` corre pero `FUN_001D7020` no suena (la guarda en 1 para J2, o `V+0x1C44` = 0); o la cuenta en 0
  → J2 no pasó por el envoltorio (el disparo de J2 no llama a `FUN_001D6F90` en esa ventana).

## P2 — control: sin la pieza, J2 callado

- **Predicción:** `--sin-sonido`, misma escena: `fuego-J2` en ~3000 (impactos sueltos), `fuego-J` ~9000. Es la S4 de
  (111) repetida: si da distinto, el banco cambió y P1 no se puede leer.

## P3 — dos cargas seguidas

- **Predicción:** la segunda carga de Town arma a J2 (`fase 2`, `estado 3`) sin colgar, y `fuego-J2` vuelve a sonar
  (≥ 6000). La pieza no aloja nada ni guarda estado entre cargas: no hay alta ni baja que pueda quedar colgada.

## P4 — nada se rompe para J

- **Predicción:** `fuego-J` con la pieza ≈ `fuego-J` sin ella (± 15 %). Riesgo a mirar: si el emisor de `V` tiene una
  sola voz, en un tiroteo de los dos un disparo cortaría al otro (no se mide acá: J y J2 disparan en escenas separadas).

## P5 — agregada DESPUÉS de la primera corrida de la pieza y ANTES del control: el seam en RAM

La primera corrida (abajo) dio un audio ambiguo: en (111) los impactos solos, con el aislador, ya llegaban a ~8000 en
ráfagas. Un discriminador que no dependa del micrófono: `FUN_001D7020(V)` avanza el generador al azar `V+0x2A0/+0x2A4`
cada vez que corre (con `V+0x1C44` ≠ 0) y nada más del disparo lo toca (en frío, (116)).
- **Predicción:** por escena separada: `quieto` → el azar **no** cambia; `fuego-J` → cambia (control positivo: J
  suena); `fuego-J2` → cambia **con la pieza** y **no** cambia con `--sin-sonido`.
- **Refuta:** `fuego-J2` sin la pieza también lo avanza (otra cosa lo mueve: el seam no discrimina) o con la pieza
  no lo avanza con las salteadas subiendo (`SONJ2` no llega a `FUN_001D7020`).

## Resultado

**Corrida 1 de la pieza** (`volcados/inspeccion/banco-sonido-pieza-20261002-124946.json`; Town, dos cargas):
- **P3 cumplida:** dos cargas seguidas de Town, J2 armado en las dos, el fork vivo después.
- El seam del envoltorio: **90 disparos de J2 salteados** en cada carga (y 90 «pasadas» de J): los disparos de J2 llegan
  al envoltorio 4, que sale por `j SONJ2` (`0x0811BB80` leído en RAM).
- **P1 por audio: NO se cumple como estaba escrita.** `fuego-J2` media **4062** (carga 1) y **5798** (carga 2) contra
  la predicha ≥ 6000 continua; ventanas > 6000: 11 y 27 de 49 (en (111) sin aislador: 39; con aislador: 6). `fuego-J`
  9083 / 9197 (P4: igual que en (111), 9028–9163). La forma no es la de (111) sin aislador (continua desde el primer
  segundo): sube tarde y oscila. Ambiguo entre «suena a veces» y «son impactos»: por eso P5.

**Control** (`--sin-sonido`; `volcados/inspeccion/banco-sonido-control-20261002-125241.json`; Town, carga 1):
- **P2 cumplida:** `fuego-J2` media **3871** (máx 9743), `fuego-J` 9181, `quieto` 2066: lo de (111). Y la pieza no
  se distingue de esto por audio: 4062 / 5798 contra 3871 → **P1 refutada** (los picos son impactos).
- **P5 refuta la premisa, no sólo la pieza:** el azar de `V` **no avanza ni cuando dispara J** (control positivo en
  rojo), con `V+0x1C44` = **0** y la guarda en 0. `FUN_001D7020` vuelve sin hacer nada: **no es el sonido que se oye
  del disparo de J.** Comprobado en frío en los 16 volcados: `V` = `0x00657180` en todos (es la buena), `V+0x1C44` = 0 en
  7 y 1 en 9, y el volumen `V+0x1C48` = 0 en 15 de 16 → `FUN_001D7020` es un sonido aparte (apagado casi siempre).
- **Lo que queda en pie:** S4 de (111) (sin el aislador entero J2 suena) + esto → el sonido audible sale de otra de las
  cosas que el aislador corta en `FUN_001D6F90`: la pista de animación de la vista (`FUN_001F0678(V+0x1BE0)`, cuyos
  eventos serían los sonidos: `hipótesis`) o el conjunto del arma (`FUN_001D6E78`). El callback de eventos del cuerpo
  (`FUN_001E80C0`, (93m)) no crea sonido (en frío: sólo rearranca la pista de la vista). Si es la pista, sonido y
  animación vienen juntos, que es justo lo que `V2` separaría.
- **Lección de proceso:** la guarda de la rutina (`V+0x1C44`) y su volumen se podían leer en los volcados ANTES de
  fabricar (costaba un script); se leyó el código y no el estado.
