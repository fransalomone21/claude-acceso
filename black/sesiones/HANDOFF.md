# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-22**, PC, **con el juego corriendo**.
**7b sigue abierta**, pero ya no le falta pensar: le falta **jugar**. El
experimento que la cierra está armado, parcheado y verificado en un ISO.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — sólo el bloque de **7b** en N2 y las tres filas
   nuevas de la tabla de hechos (`+0x58`, `+0x78`, `+0x88`).
2. `black/docs/03-bitacora.md`, **sólo la entrada (32)**. La (31) está
   resumida acá abajo.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29), (30) y (31), y nada de
`perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**Fase 7b — qué dato fija QUÉ TIPO de enemigo aparece.**

**Cierra POR EFECTO, y el efecto ya no se puede ver en caliente.** Hay que
arrancar **`Black-mod-7b.iso`**, llegar a `LEVEL_00` **jugando** y leer:

```
python herramientas/pine.py leer 0x006E1948   # n=4, +0x04 -> bloque de IA
```

| entrada | qué tiene que pasar si la hipótesis vale |
|---|---|
| `n = 4, 5, 6, 7, 9` (`E_BLACKHD_M0`) | el bloque de IA **cambia**: deja de ser `0x01842C40` |
| `n = 3` (`E_LKISS2_M0`) | el bloque de IA **NO cambia**: sigue `0x01842C40` |

Ése es el par: una mitad mueve `+0x78`, la otra mueve `+0x18` y es el control.
Si cambian las dos, o no cambia ninguna, la hipótesis se cae y hay que mirar
`+0x8C` y `+0xA8`, que particionan igual.
Observable de error más barato: `'AI gun model not found: %s'` (`0x003F4848`).

**NO SIRVE cargar un savestate**: restaura toda la RAM y anula el parche.
Los slots 01 y 02 (15 MB, parecían anteriores) también están **dentro** de
`LEVEL_00` con el stage ya enumerado. **No hay atajo. Hay que jugar.**

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

### El plan viejo estaba apuntado a dos cosas equivocadas

1. **`+0x18` NO fija el arma.** Es el modelo **del personaje**. El campo que
   particiona exactamente como el bloque de IA es **`+0x78`**
   (`DISTANT0` / `MGNDST0` / `MGNDST2` / `RPG0`), junto con `+0x8C` y `+0xA8`.
   `+0x88` tampoco particiona. Encaja con `FUN_00136848`, que compone
   `<nombre>_LOD`: el id64 `0xE69A1DD748000000` **decodifica a `'_LOD'`**.
2. **`PSTL0` no está instanciado** en el savestate 3. Escribirle no podía
   producir efecto ni con la hipótesis correcta.

### `entidad+0x58` es el puntero al REGISTRO DE PERSONAJE, no una escuadra

Corrige la lectura de 7a. Sólo **4 de los 9** personajes están vivos:

| n | bloque IA | `+0x58` → personaje | `+0x00` en vivo | facción |
|---|---|---|---|---|
| 1 | `0x01842A60` | `0x01412A80` `MCHNGNM0` | `Team0_Tom` | `0x005A3890` |
| 2 | `0x01842A60` | `0x01412B30` `SBMCHGNM0` | `Team1_Matt` | `0x005A3890` |
| 3 | `0x01842C40` | `0x014129B0` `E_LKISS2_M0` | `Enemy1_Low` | `0x005A3870` |
| 4,5,6,7,9 | `0x01842C40` | `0x01412900` `E_BLACKHD_M0` | `Enemy0_Mid` | `0x005A3870` |

`n=0` y `n=8` son del jugador (`+0x00 == +0x04`, `+0x08 = 0`). El array está
**lleno, 10/10**.

### `+0x78` de los 9 personajes, y el mapeo de `+0x88` gratis

```
PSTL0, SHTG0                                    -> DISTANT0  (+0x8C = 4)
E_MAC10_M0, E_BLACKHD_M0, E_LKISS2_M0, E_UZI_M0 -> MGNDST0   (+0x8C = 4)
MCHNGNM0, SBMCHGNM0                             -> MGNDST2   (+0x8C = 6)
RPG0                                            -> RPG0      (+0x8C = 3)
```

**`+0x88` → etiqueta, leído en vivo** (esto era otra fase y salió gratis):
`0 → None`, `1 → Low`, `2 → Mid`, `8 → Matt`, `0x10 → Tom`. **No hace falta
mapear la jumptable `PTR_LAB_003F8130` para estos cinco.**

### Por qué la escritura en caliente NO puede cerrar 7b

Dos escrituras hechas, **las dos restauradas y releídas**:
`0x01412618` (`+0x18` de `PSTL0`) ← `E_UZI_M0`, y `0x01412978` (`+0x78` de
`E_BLACKHD_M0`) ← `RPG0`. **Sin cambios en el array de armas, las dos veces.**

**El negativo es real, no un instrumento muerto:** control positivo corrido
antes de creerle — 3 de 8 entidades cambiaron su XYZ en 3 s. El emulador
avanzaba.

La razón es estructural: **el campo se lee al spawnear**, en el slot 3 ya
está todo spawneado y el array está lleno. No es que la hipótesis esté mal.

### El ISO: cargado literal, offsets únicos

RAM `0x01412400` = offset **`0x000`** del archivo, **sin fixup**. Verificado:
el id64 de `PSTL0` aparece **una sola vez** en los 2,5 MB de `STLEVEL.BIN`,
en `0x218` = `0x01412618 - 0x01412400`.

`STLEVEL.BIN` de `LEVEL_00` dentro del ISO: offset **`0x804D6800`**, LBA
1051053.

**`Black-mod-7b.iso` YA ESTÁ PARCHEADO Y VERIFICADO** (`parche_iso.py
verificar`: 2 rangos de 7 B, sólo en `STLEVEL.BIN`, TOC intacta):

| qué | offset ISO | de | a |
|---|---|---|---|
| `+0x78` de `E_BLACKHD_M0` | `0x804D6D78` | `MGNDST0` | `RPG0` |
| `+0x18` de `E_LKISS2_M0` | `0x804D6DC8` | `E_LKISS2_M0` | `E_BLACKHD_M0` |

El modelo de reemplazo es `E_BLACKHD_M0` **a propósito**: está garantizado
residente (5 entidades lo usan), así que un fallo de carga no puede
confundirse con el resultado.

### De la (31), sigue valiendo y NO se rehace

- Registro de **personaje**, paso `0xB0`: `+0x00` buffer del `sprintf`
  (inútil en frío) · `+0x18` id64 del modelo · `+0x20/+0x28/+0x30` variantes
  M1/M2/M3 · `+0x68/+0x70` variantes S0/E0 · **`+0x78` modelo del arma** ·
  `+0x88` índice de tipo · `+0x94` sonido.
- Registro de **unidad**, paso `0x28`: `+0x00` nombre ASCII · `+0x10` el mismo
  en id64 · `+0x18` ptr enemigos · `+0x20` cant · `+0x1C` ptr compañeros ·
  `+0x24` cant (cantidad 0 ⇒ el puntero es **basura**, no un nulo).
- Stage = cabecera en `0x01412400`: `+0x04` ptr unidades, `+0x08` cantidad (7).
- **En disco los punteros son relativos a la sección `0x80`**, no al archivo.
  Sobre el ISO crudo el parseo da bloques plausibles pero **falsos**.
  Los **id64 sí** se pueden buscar directo, y son únicos.
- **No volver a barrer el ISO por texto**: los nombres son id64.
- `herramientas/id64.py` — base-40, 12 chars, de atrás hacia adelante.
  `0=' ' 1='-' 2='/' 3..12='0'..'9' 13..38='A'..'Z' 39='_'`. Sin minúsculas.
  `autotest` **probado en rojo** (13 casos).
- `+0x58` del **registro de arma** es espejo de sonido, no fuente.
- Buscar id64 sin `--min-relleno 2` es ruido (79.048 nombres en `STLEVEL.BIN`).

## 4. LO QUE SIGUE, CONCRETO

```
python herramientas/ubicaciones.py          # 13/13 el 2026-08-22
python herramientas/id64.py autotest        # 13 casos, 0 fallas
```

1. **Arrancar PCSX2 con `Black-mod-7b.iso`** y jugar hasta `LEVEL_00`.
   El ISO parcheado **no está montado en D: ni en E:** (los dos montan el
   original). Se carga desde PCSX2, no hace falta montarlo.
2. Leer el array y comparar contra la tabla de la sección 2.
3. Si cierra: `+0x78` pasa a `confirmado` y se abre el mod de tipos de enemigo.
   Si no cierra: los candidatos que quedan son `+0x8C` (4/4/6/3) y `+0xA8`
   (`7.0f` enemigos / `0.8f` compañeros), y se parchea `+0x8C` en un ISO nuevo.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 quedó abierto** con el **ISO ORIGINAL** y el savestate 3 cargado.
  Ejecutable: `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (NO el de Program Files). PINE 28011 responde.
- **RAM LIMPIA: las dos escrituras fueron restauradas y releídas al cerrar**
  (`0x01412618` = `PSTL0`, `0x01412978` = `MGNDST0`). Cero parches vivos.
- **`Black-mod-7b.iso` es nuevo de esta sesión.** `Black-mod-armas.iso`
  (el mod de daño de 6.6) **no se tocó**. Quedan ~85 GB libres en `C:`.
- `ubicaciones.py` 13/13. Las rutas NO se copian a mano:
  `python herramientas/ubicaciones.py ruta iso_original`
- Ghidra: `C:\Users\frans\herramientas\ghidra-proyectos2\BLACK.gpr`.
- **Trampa de Windows:** `Test-Path`/`Get-ChildItem` sin `-LiteralPath` dan
  `False` sobre `...\Black [NTSC]\...` **existiendo**. Y **Git Bash convierte
  rutas tipo `/LEVELS/...` en `C:/Program Files/Git/LEVELS/...`**: los
  argumentos de ruta interna del ISO van por **PowerShell**, no por Bash.
- **OJO, fuera del proyecto:** `perfil-global/` sigue **desincronizado entre
  ramas**. La copia instalada en `~/.claude` tiene **45** lecciones; la rama
  de BLACK tiene 37. **No correr `perfil-global/install.ps1` desde esta rama.**

---

READY FOR NEW SESSION
