# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para qué hacer después, a
`docs/04-plan.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — entorno | cerrada |
| 1 — ancla (vida del jugador) | cerrada |
| 2 — rutina de daño del jugador | **cerrada, confirmada por efecto** |
| 3 — enemigos | **cerrada, confirmada por efecto** (2026-08-16) |
| 4 — tabla de armas | **cerrada**, pero sólo gobierna el daño que se le hace AL jugador |
| 4b — daño de SALIDA del jugador | **cerrada, confirmada por efecto** (2026-08-16) |
| 5 — qué elige la zona de impacto | siguiente |

**Fase 4 — lo que se cerró, y con qué alcance.** La tabla de armas: **17
registros de `0x1E0`**, con dos bloques de parámetros de `0x30` (`+0x90`
jugador, `+0xC0` IA) y `Power` en `+0x18` de cada bloque. Escribir
`Power = 300` cambió el daño que el jugador **recibe** (reacción de arma
pesada en pantalla) — eso está confirmado. **No** cambió el daño que el
jugador **hace**, y nunca iba a cambiarlo: son dos sistemas distintos. Ficha
en `kb/estructuras.json#arma`, cálculo en
`kb/rutinas.json#calcular_dano_por_arma`.

**Fase 4b — la respuesta.** El daño de salida del jugador sale de una tabla
por **zona de impacto** colgada del personaje de la víctima, no de `Power`:

```
daño = factor_de_zona * 100.0        calculado en 0x00142B90
```

Esa función **ignora** el daño que le llega en `$f12`. Torso = `0.255` → los
`25.5` medidos; cabeza = `1.02` → 102, mata de un tiro. **Confirmado por
efecto:** con los 36 factores en `3.0` los enemigos mueren de una bala, y el
parche se releyó después del test (seguía en 3.0). Fichas en
`kb/estructuras.json#zona_impacto` y `kb/rutinas.json#calcular_dano_zona`.
Herramienta: `herramientas/zonas.py`.

**Para el mod de daño, la palanca es otra.** Los factores por zona son **por
tipo de personaje** y viven en el heap: hay que buscarlos por cadena en cada
arranque, así que no sirven para un `.pnach`. El `100.0` de **`0x00142CA0`**
(`lui $at,0x42C8`) es código del ELF, dirección fija, y escala **todo** el
daño de salida de una sola vez. Ese es el que va al pnach.

**Ninguna de las dos tablas tiene dirección fija:** las dos viven en el heap y
se mueven entre niveles y partidas. Siempre se buscan sobre un volcado fresco:

```
python herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin
python herramientas/armas.py listar volcados/ee-vivo.bin
python herramientas/zonas.py listar volcados/ee-vivo.bin
```

**Lo que sigue:** Fase 5 — qué elige el número de zona. Ver `HANDOFF.md`.

---

## Instrumental externo (2026-08-16) — el proyecto ahora DECOMPILA

Detalle y montaje en `docs/06-herramientas-externas.md`.

| Herramienta | Versión | Para qué | Control positivo |
|---|---|---|---|
| **Ghidra + Emotion Engine Reloaded** | 12.1.2 / v2.1.36 | decompilar el ELF a C. **9842 funciones, 16514 símbolos** donde el ELF no trae ninguno | `decompilar.py info` decompila `0x00142B90` y busca el `100.0` de la Fase 4b |
| **pyghidra** | 3.1.0 | manejar Ghidra desde Python, sin GUI | — |
| **vgmstream** | r2117 | abrir los `.AWD` (RenderWare Audio) | `AIWPNS.AWD` del nivel 1 = 29 streams con nombre |

**Dos trampas del montaje, las dos ya pagadas.** La extensión va en
`Ghidra\Extensions\`, **no** en `Extensions\Ghidra\` (las dos carpetas
existen). Y el import necesita **`-processor "r5900:LE:32:default"`**: sin
eso Ghidra elige MIPS Release 6, dice `Analysis succeeded` y deja **1
función** en 2,6 MB de código. Lección 18.

**Descartadas a propósito:** `PCSX2-MCP` exige correr un `pcsx2-qt.exe`
parcheado de un repo de 18 estrellas — no se instaló, y la decisión de hacerlo
es de Fran. `mcp-pine` es limpio pero redundante con `pine.py`. **No existe
script de QuickBMS ni plugin de Noesis para BLACK**: el formato era nuestro.

---

## Formato del contenedor `.BIN` — RESUELTO (2026-08-16)

Estuvo días anotado como "falta entender". Cayó **decompilando el cargador**,
no mirando bytes. El callback de `GlobData.bin` (`0x00105D48`) no parsea:
**relocaliza**. Los u32 de la cabecera son offsets relativos que el cargador
convierte en punteros absolutos sumándoles la base, en el lugar:

```c
*(int *)(base + 0x04) += base;   // y +0x08, +0x0C, +0x10, +0x14, +0x18
```

Por eso fallaba la hipótesis de "tabla de offsets creciente": no es una tabla
ordenada, es una cabecera de layout fijo donde cada ranura es una sección.
Recursivo hacia adentro: cantidad en `+0x00` (u8), registros de paso fijo.

Verificado con dos controles que no se ajustaron para que dieran: la tabla de
armas (`0x00130E20`, conocida de antes) cae dentro de la sección de
`0x00130C80` a `+0x1A0`; y en `STLEVEL.BIN` la sección de `0x80` arranca con
`"bg1_shg"`. Ficha en `kb/rutinas.json#fixup_contenedor_bin`.

**No aplica a `LEVELDAT.BIN` ni a `GUNS.BIN`**: usan otro layout. Se resuelven
igual — xref de su cadena de ruta, decompilar su callback.

---

## Barrido del ISO (2026-08-16) — reconocimiento, nada confirmado por efecto

Cinco cosas que cambian dónde buscar. Detalle en `docs/05-iso.md`, cómo se
llegó en la entrada 23 de la bitácora.

1. **La tabla de armas está en `GLOBDATA.BIN + 0x00130E20`** — 17 registros de
   `0x1E0`, mismo conteo y mismo paso que en RAM, paso verificado por dos
   anclas (Magnum en `+2`, HVY en `+10`). Habilita un mod **permanente** por
   ISO. `probable`: nadie editó el archivo ni vio el efecto.
   **Corrige un callejón que estaba anotado como cerrado** — ver abajo.
2. **Nombres de hueso en `0x003BCE70`** (`const char*[11]`: `NECK`,
   `MIDSPINE`, `LOWERSPINE`, `SHOULDER/ELBOW/UPPERLEG/KNEE_LT/RT`). Los
   resuelve a índices `0x001381E0` y los cachea en `personaje+0x0C..+0x38`.
   El esqueleto tiene la cantidad en `+0x5C` y el arreglo de nombres en
   `+0x60`. Es material de Fase 5b, **no** la respuesta: 11 nombres contra 24
   registros de zona.
3. **Mapa exacto del ELF** desde la tabla de secciones: `.data 0x003BC380`,
   `.rodata 0x003F2280`, `.lit4 0x0040D800`, `.sdata 0x0040D980`,
   `.bss 0x0040EC80`. Y **`$gp = 0x004157F0`** (sección `.reginfo`).
4. **561 globales se direccionan por `$gp`** (3051 accesos). Ninguno aparece
   buscando `lui`+`addiu`. Si `xref.py absoluto` da NADA entre `0x0040D7F0` y
   `0x0041D7F0`, la hipótesis buena es `$gp`.
5. **El middleware de IA es Kynapse** y trae los nombres de sus tunables:
   `CShooterAgent` declara `GunRange` y `MaxInaccuracy`. Ahí empieza el hilo
   de "enemigos que erran más".

---

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` en vivo + log de arranque → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`** (`jugador 0x005A8AB0 + 0x2F8`, f32) | escaneo diferencial + correlación temporal + escritura con efecto en pantalla. **Y confirmación independiente de terceros (2026-08-16):** el código público de vida infinita para este serial es `205A8DA8 44960000` — la misma dirección, con `1200.0` como valor de "lleno" |
| **Daño al jugador: `0x0013BD20`** (`swc1 f20,0x2F8(s2)`, `0xE65402F8`) | watchpoint de escritura + golpe real; nop = vida infinita, probado contra fuego de AK |
| **El puntero de clase está en `objeto+0x10`**, no en `+0x00` | vtable del jugador `0x003DC5F8`; reconfirmado en 2026-08-16 por `lw $v0,0x10($t3)` en `0x0015BAE4` |
| **Método virtual #8 (`vtable+0x4C`) = "recibir daño"** | censo de las 279 vtables: sólo dos clases escriben en `+0x2F8` |
| **Clase del enemigo = `0x003DCA78`** — 32 objetos, pool desde `0x0058FE90`, paso `0x3C0`, vida `100.0` en `+0x2F8` | `clases.py`, y confirmado por efecto |
| **Daño al enemigo: `0x00134654`** (`0xE61402F8`); clamp de muerte `0x00134514` | nop puesto → cargador entero de AK sin matarlo; nop seguía puesto al releerlo |
| **Tabla de armas: 17 registros de `0x1E0`, `Power` en bloque+`0x18`** — gobierna el daño que se le hace **al jugador** | `Power = 300` → reacción de arma pesada en pantalla al recibir disparos |
| **El daño de salida del jugador NO usa `Power`**: sale de `zona * 100.0` en `0x00142B90` | factores en 3.0 → mueren de UNA bala; cero valores intermedios en los 32 slots del pool; parche releído después del test y seguía puesto |
| **Objeto de arma por tirador: `0x006DE770 + n*0x110`**, descriptor en `+0x0C`, **dueño en `+0x10`**. El del jugador es `0x006DE770` | volcado: `+0x10` = `0x005A8AB0` (jugador); los siguientes, enemigos del pool |
| **Daño = `Power * (falloff + (1-falloff)*arg/Range)`**, calculado en `0x0015B20C` | desensamblado; con `falloff = 1` da constante, que es lo que se midió en la Fase 1 (10 escalones de 26.0) |
| **Cola de daño diferido = global `0x00414AD0`** (16 registros de `0x20`, contador en `0x00414CD0`) | `lui 0x41 + addiu 0x4AD0` en `0x0015B308`; único llamador de la encoladora |
| **El esquema de campos de arma está en texto en el ELF**, `0x004008A0`-`0x004009C8` | `Range`, `Power`, `Num Bullets In Clip`, `CommonParams`/`PlayerParams`/`AIParams`… rodata muerta pero legible |
| Daño de AK47 = 26.0 al jugador; 25.5 del jugador al enemigo | 10 escalones idénticos en `volcados/correlacion-vida-2.csv`; y medición del pool 2026-08-16 |
| `0x006CF54C` = segmentos del HUD (derivado, no fuente) | se recalculó solo al escribir en la vida |
| **1200.0 y 750.0 hardcodeados en el HUD** | `lui at,0x4496` / `lui at,0x443B`+`ori 0x8000` + `div.s` en los 3 sitios lectores |
| **Código del juego en `0x00100000-0x003BFFFF`**; datos `~0x0042xxxx-0x0045xxxx` | `xref.py mapa` + histograma de `lui` |
| **Mapeo del ELF: `offset_archivo = vaddr - 0xFF000`**, un solo `PT_LOAD` | verificado 6/6 contra encodings observados en vivo |
| **Los breakpoints de EJECUCIÓN crashean el emulador**; los watchpoints no | `bp poner` mató el proceso; los watchpoints aguantaron decenas de veces |
| **Los crashes son corrupción de heap del parche, no OneDrive** | Visor de eventos: `0xc0000374` en `ntdll.dll`; `DebugServer.cpp` muta `CBreakPoints` desde el hilo del socket sin mutex |
| **`--accion log` no cuenta hits** (es un stub) | `MemCheck::Log()` vacío en el fuente de PCSX2 |
| Un volcado completo de los 32 MB por PINE tarda **~3 s** | medido 2026-08-16 |

## Callejones cerrados — no repetir

- **Los cinco `26.0` de `0x0042C3AC..0x0042D56C` NO son la tabla de armas.**
  Están en BSS, se les escribió 300.0 y no cambió ningún daño; además
  ensucian el HUD (aparecen dos barras negras en pantalla). Restaurados.
- ~~**La tabla de armas no está en el ISO ni en el ELF.**~~ **REABIERTO
  2026-08-16: sí está**, en `GLOBDATA.BIN + 0x00130E20`. Aquel resultado era un
  falso negativo: la prueba comparaba la ventana de 96 bytes alrededor del
  `26.0` de la RAM viva, y esa ventana arranca con tres punteros al heap que en
  el archivo son offsets chicos. Lo que sigue en pie es que **`GUNS.BIN` no es
  la tabla** (es geometría, cero apariciones del `26.0`) y que la tabla se
  copia al heap por stage.
- **`0x0013C120` es el método #9 de la clase del JUGADOR**, no el brazo de
  daño de los enemigos. Falsificado por efecto.
- **El escaneo diferencial no sirve para la vida de un enemigo**: muere en 4
  balas y el filtro necesita más rondas de las que da. Por clase salió en una
  pasada.
- Los saves de GameFAQs son Max Drive/CodeBreaker: no se pueden usar sin
  herramientas de terceros.

## Hipótesis activas

- **Vida máxima = 1200.0**, no `FLT_MAX`; está hardcodeada en el código que
  lee la vida. Falta determinar qué elige la rama entre 1200.0 y 750.0
  (¿dificultad? ¿tipo de entidad?).
- `arma+0x18` (valores 25, 10, 50) es candidato a **cargador**. Sin
  confirmar: no se comparó contra el número del HUD.
- El código de 3 letras de `arma+0x1C0` está **corrido un registro** respecto
  de los parámetros. Para identificar un arma, guiarse por el perfil de
  parámetros y no por ese campo.
- `0x0065F458` (f32, 0.23..0.59) sigue sin identificar; probable ratio del HUD.

## Estado de la máquina

- PCSX2 2.6.3 en la notebook, PINE en 28011. ISO montado en `D:`.
- **Parches vivos en memoria** (se pierden al recargar el emulador):
  `0x0013BD20` en nop = **vida infinita del jugador PUESTA**.
  `0x00134654` restaurado a `0xE61402F8` (los enemigos mueren normal).
  Los 34 `Power` de la tabla **restaurados 34/34**, sin discrepancias.
  Los 36 factores de zona **restaurados 36/36**, sin discrepancias.
- Savestate del punto de trabajo en el **slot 6**. `volcados/ee-06.bin` es su
  RAM. De esta sesión: `ee-4b.bin` (tabla de zonas intacta, el bueno para
  releer valores originales), `ee-4b-antes.bin` y `ee-4b-post.bin` (las dos
  puntas de la medición que cerró la Fase 4b).

## Problemas abiertos

- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`**, que está
  trackeado: hace `rmtree` de `construido/` al terminar. Restaurarlo a mano
  (`git checkout -- black/construido/.gitkeep`) antes de commitear.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.
- `armas.py`, `zonas.py` y `tablas.py` no tienen test en `pruebas/`.
- La cabecera del contenedor con alineación 128 (`GLOBDATA.BIN`, `STLEVEL.BIN`)
  sigue sin entenderse. No bloquea nada hoy: el contenido va sin comprimir.

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: es un índice del render
  del HUD y escribirle 999 crasheó el emulador a pantalla negra.
- No escribir en `0x0042Cxxx`: es zona de HUD, ensucia la pantalla.
