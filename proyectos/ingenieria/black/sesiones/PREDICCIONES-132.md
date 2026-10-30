# Predicciones de (132) — escritas ANTES de medir

Sesión (132), 2026-10-30, PC en frío. Pre-Fase A del concepto de plataforma (KDP de plataforma; COOP-C en pausa).
Cada predicción con su control. El resultado va abajo de cada una, en el mismo lugar; si la medición la contradice,
se corrige acá diciendo que se corrigió.

## R — La piedra Rosetta (PS2 ↔ Xbox), por estructura y no por offsets sueltos

**Método** (`herramientas/rosetta.py`): de cada función se toma el **conjunto de desplazamientos** de memoria entre
`0x10` y `0x2000` sobre un registro base que no sea la pila (MIPS: `lw/sw/lwc1/swc1/...` con base ≠ `sp`; x86:
`[reg+disp]` con base ≠ `esp`/`ebp`). Dos funciones son la misma función de Criterion si comparten esos
conjuntos (Jaccard). **El control es una población**: la función PS2 contra **todas** las funciones Xbox (y al
revés), no contra una elegida a mano; la pareja tiene que salir **primera** de miles, no "parecida".

- **R1 — la mira (entrada del jugador).** PS2 `mira_actualizar` `0x001404A8` (curva, suavizado, aceleración, giro;
  `kb/rutinas.json`) contra las ~7600 funciones del XBE: **la primera es `FUN_001BD3F0`** (la que `black-pc/NOTES.md`
  describe con curva `+0xC8`, aceleración `+0xC0..+0xD4`, suavizado `+0xCC`, yaw `+0x18`, pitch `+0x1C`), con
  Jaccard ≥ 0,3 y la mediana de la población < 0,05.
- **R2 — la máquina de estados del arma.** Xbox `FUN_001EEFD0` (estado `+0xD8`, temporizador `+0xDC`; NOTES y
  XBERecomp) contra las ~11 000 funciones del ELF: **la primera escribe `arma+0xD8`** y compara estados del conjunto
  ya medido en PS2 {1, 4, 5, 8, 28} (`kb/estructuras.json`), Jaccard ≥ 0,3.
- **R3 — la pausa.** PS2 `FUN_0020AEA0` (el menú de pausa, máquina en `menu+0x3924`) contra el XBE: la primera tiene
  Jaccard ≥ 0,3 y le saca ≥ 0,1 a la segunda. Grado esperado: *probable* como mucho (el lado Xbox no tiene nombre
  en las fuentes; se contrasta por sus llamadas).
- **Criterio:** las tres casan → la Rosetta pasa a **confirmado** como método (por estructura). Dos de tres →
  *probable*. Si R1 —la de mejor fuente— no sale primera, el método está mal y no se concluye nada.

- **R0 — "los mismos offsets" de (131), uno por uno.** (131) anotó `jugador+0x2A4` = arma en la mano «en las dos».
  XBERecomp (código que corre) usa `jugador+0x29C` = arma y `jugador+0x2A4` = **zoom (float)**. Predicción: en el
  XBE, los accesos con desplazamiento `0x2A4` son mayormente de **float** (x87/SSE), y en el ELF mayormente de
  **entero** (`lw`, un puntero). Si sale así, el `+0x2A4` de (131) era una coincidencia de número y no de campo: la
  Rosetta vale por función, no por offset suelto. Control: el mismo conteo para `+0xD8` del arma (entero en los
  dos: el estado).

### Resultados de R (medidos el 2026-10-30, `herramientas/rosetta.py`)

**El instrumento falló primero, y se vio antes de creerle.** La primera versión excluía `ebp` del lado x86 como si
fuera el puntero de pila; el XBE es MSVC sin frame pointer y usa `ebp` como registro común (el arma vive en
`[ebp+0xDC]`, NOTES). El control positivo de entonces comparaba PS2 contra sí misma: era **ciego al lector x86**.
Arreglado en la herramienta: `ebp` entra y el autotest exige que `FUN_001EEFD0` del XBE toque `+0xD8` y `+0xDC`
(control que cruza la plataforma). Los números de abajo son con el lector corregido.

| | Resultado | Contra la predicción | Grado |
|---|---|---|---|
| **R1** mira | PS2 `0x001404A8` → XBE: **`FUN_001BD3F0` primera de 3642**, J = 0,28 (2.ª 0,26). Al revés, quinta de 3567. Campos comunes: `+0xB8 +0xBC` (velocidades), `+0xC0 +0xC4` (aceleración), `+0x105` (bandera de apuntar), `+0x2A4` (zoom), `+0x1C` (cabeceo): los que NOTES describe | primera sí; J ≥ 0,3 **no**; margen chico | *probable* (la función y sus campos casan; el discriminador es débil con 15 campos) |
| **R2** arma | Xbox `FUN_001EEFD0` → ELF: **PS2 `0x001575A8` primera de 3567, J = 0,59** (2.ª 0,34); al revés, `FUN_001EEFD0` **primera de 3642**, J = 0,59. `0x001575A8` escribe en `+0xD8` los valores {0, 3, 13, 22, 28}: el **0 (quieta) y el 28 (culatazo)** ya medidos en PS2 | cumplida (los estados 1/4/5/8 no salen como inmediatos en esa función) | **confirmado en frío por dos métodos** (ranking en las dos direcciones + los estados escritos) |
| **R3** pausa | PS2 `FUN_0020AEA0` tiene **4 campos**: la primera del XBE saca 0,24 y la segunda 0,23 | no discrimina | sin resultado: la función es demasiado chica para este método |
| **Control negativo** | los 15 campos de la mira corridos `+0x400` encuentran como mucho J = 0,25 en la población | — | el techo del ruido es 0,25: R2 (0,59) está muy arriba, R1 (0,28) apenas |
| **Método 2 (IDF)** | pesar cada campo por su rareza **no mejora**: R1 queda primera de un lado y segunda del otro, y el control negativo sube a 0,33 | — | descartado: el pesado no discrimina mejor que el conjunto llano |

**Veredicto de la Rosetta:** dos de tres → **probable como método**, y con su límite escrito: **funciona por
función, con funciones de ≥ 15–20 campos**; con pocas (la pausa) no discrimina. No es una tabla de offsets.

**R0 — refutado lo de (131).** Usos de cada desplazamiento en todo el código (float / entero):

| Campo | PS2 | Xbox |
|---|---|---|
| `+0x29C` | 2 / 11 | 0 / **65** |
| `+0x2A4` | 2 / **69** | 4 / 6 |
| `+0x2E0` | **20** / 8 | **27** / 6 |
| `+0x4F0` | 0 / 2 | 0 / 7 |
| `+0xD8` | 10 / 71 | 24 / 86 |

El puntero del arma en la mano, el campo más usado de esa zona, es **`+0x2A4` en PS2 y `+0x29C` en Xbox** (XBERecomp:
`kPlayerWeapon = 0x29C`, `kPlayerZoom = 0x2A4`). El «`+0x2A4` en las dos» de (131) era una coincidencia de número, no
de campo. Otros sí coinciden (`+0x2E0` float en las dos, `+0x4F0`, `+0xD8` del arma). **Grado: probable** (conteo
estático, sin intervenir). Consecuencia: un dato de Xbox se porta a PS2 **por la función que lo usa** (R2), nunca
copiando el offset.

## X — Las ISOs Xbox de Fran contra los dos ports

- **X1.** El `default.xbe` adentro de `Black (USA).iso` (Redump) tiene SHA-256 `df2739c3…68f6` (el que piden los
  dos ports y el que trae el paquete 0.2.0). Control positivo: el del paquete 0.2.0 da ese hash con el mismo código.
- **X2.** El de `Black (Europe)` da `67f35121…30f0` (PAL Europa, soportado).
- **X3.** El de la demo Europa/Australia **no** coincide con ninguno (ningún port la soporta).
- Método: sin extraer la ISO a disco (7,8 GB cada una): se lee el XDVDFS adentro del zip en flujo (partición de
  juego en `0x18300000`, descriptor en el sector 32 de la partición) y se hashea el archivo.

### Resultados de X (medidos el 2026-10-30, `herramientas/xbe_de_iso.py`, sin extraer nada a disco)

| ISO (zip de Fran) | `default.xbe` | Veredicto |
|---|---|---|
| control: el XBE del paquete 0.2.0 | `df2739c3…68f6` | OK (el NTSC-U del README) |
| `Black (USA)` | `df2739c3…68f6`, sector 1710590 de la partición `0x18300000`, 2 813 952 B | **X1 cumplida**: NTSC-U, sirve a los dos ports |
| `Black (Europe) (En,Fr,De,Es,It)` | `67f35121…30f0`, 2 813 952 B | **X2 cumplida**: PAL Europa, sirve a los dos |
| `Black (Europe, Australia) (Demo)` | `d74267af…69a5`, 2 564 096 B | **X3 cumplida**: ningún port la soporta (es el control negativo) |

Grado: **confirmado** (hash entero contra el publicado, con control positivo y negativo).

## P — Los ports lanzados una vez

- **P1.** Ninguno se lanza en esta sesión por la sesión: son ejecutables bajados de GitHub (repos de dos y cuatro
  semanas); ejecutarlos lo decide y lo hace Fran. La sesión deja el lanzador y mide el efecto en los registros
  después. (Predicción de método, no del port.)

## C — Dónde se engancha un segundo jugador en el port (en frío, sin código)

- **C1.** En XBERecomp cada *seam* tiene un *enabling point* nombrable: `X86_FUNC(sub_XXXXXXXX)` reemplaza una
  función entera y `[[hook]]` engancha una instrucción; el renderer tiene `gpu::Extension` para pasadas propias.
  Predicción: los cuatro seams del coop (lectura de mandos, controlador del jugador, cámara/vista, viewport por
  cuadro) tienen cada uno una función Xbox ya nombrada en NOTES o en el código de XBERecomp.
