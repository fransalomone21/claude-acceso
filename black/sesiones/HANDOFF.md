# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-17**, PC con PCSX2 vivo. Fase 7 (a) cerrada.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/APRENDIZAJE.md` — **nuevo**: las lecciones de proceso acumuladas.
   Cinco, cortas. Se lee antes de diseñar un experimento, no después.
3. `black/docs/08-experimentos.md` — el método y la batería E1..E6.
4. `black/docs/00-conops.md` — sólo si hay que decidir **en qué** trabajar.

**NO leer** salvo que la tarea lo pida: la bitácora entera, `docs/90-glosario-ee.md`,
`docs/06-herramientas-externas.md`. La entrada (26) de la bitácora tiene el
detalle de cómo cayó E4, si hace falta.

## 2. LA FASE QUE SE ABRE, Y QUÉ LA CIERRA

**Fase 7 — arquitectura de entidades y de la IA.** La mitad (a) está cerrada.

- **7a — qué campo fija el ARMA de un enemigo: CERRADA 2026-08-17.**
  Es `0x006E18B8 + n*0x24 + 0x04`.
- **7b — qué dato fija QUÉ TIPO de enemigo aparece: ABIERTA.** ← *lo que sigue*
  **La cierra:** cambiar por efecto el tipo de enemigo que aparece en un nivel.
  Entrada barata: **E5**, `STLEVEL.BIN`, el truco de los 11 caracteres
  (`bc1_so1_mil` → `bc1_rg1_mil`, 11 bytes sobre 11, el LBA no se mueve).
- **7c — de dónde sale el puntero de `+0x04` al spawnear: ABIERTA.**
  Hace falta para hacer el cambio de arma **permanente en el ISO**, no sólo en
  RAM. Hoy el cambio se pierde al reiniciar.

## 3. MODELO

**Sonnet 5** para 7b: es correr `parche_iso.py` sobre `STLEVEL.BIN` y mirar el
resultado, con el banco ya construido.
**Opus** sólo para 7c, que es leer desensamblado para encontrar quién escribe
`0x006E18B8 + n*0x24 + 0x04` al spawnear.
**Fable: prohibido, sin excepción** (consume créditos aparte del plan).

Ver `perfil-global/enrutador-modelo/SKILL.md`.

## 4. ESTADO DE LA MÁQUINA

- **El emulador que corre NO es el de Program Files.** Es
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (build `d75a0ad`), con **DebugServer en 21512 y PINE en 28011**. Atajos en
  `C:\Users\frans\Desktop\BLACK\`: `ABRIR-BLACK-ORIGINAL.bat` y
  `ABRIR-BLACK-MOD-ARMAS.bat`.
- **OJO: lo que estaba corriendo esta sesión es `Black-mod-armas.iso`**, no el
  original. Se detectó por efecto: el escalón de daño era −5, no −26. Verificar
  siempre cuál está montado antes de interpretar una medición de daño.
- **Dos ISO** en `C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\`:
  `Black.iso` (original, 3.919.609.856 B, **nunca editar**) y
  `Black-mod-armas.iso` (`Power` de IA en `5.0` en los 17 registros).
  El original queda montado en `D:`.
- **Savestates** en `C:\Users\frans\Documents\PCSX2\sstates\`, se cargan con
  `python herramientas/pine.py cargarestado --slot N`. La carga es **asíncrona**:
  esperar leyendo `0x005A8DA8` hasta que dé ~999345.
  **Slot 3 = la condición experimental**, y ahora se sabe más de él: jugador con
  vida ~1e6, **ocho enemigos con arma**, de los cuales los del pool 0 y 1 tienen
  vida `FLT_MAX` y **no disparan** (usan el reg 4); los que disparan usan el
  **reg 5**. Slot 4 = distancia media, vida normal. Slot 10 = no sirve.
- **Parches vivos en memoria: NINGUNO.** Los 17 `Power` y los punteros se
  restauraron y se verificó la restauración por lectura.
- Ghidra 12.1.2 + EE Reloaded en `C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC`,
  proyecto en `...\ghidra-proyectos2\BLACK` (el de `ghidra-proyectos` **sin el 2**
  tiene análisis malo de MIPS R6: no usarlo). Copia del ELF en
  `C:\Users\frans\herramientas\SLUS_213.76`, mapeo `offset = vaddr - 0xFF000`.
- Volcado fresco del slot 3: **`volcados/ee-e4.bin`** (32 MB, desde la dirección 0).

## 5. LO QUE YA ESTÁ RESUELTO — NO REHACER

- **7a: el arma del enemigo se fija en `0x006E18B8 + n*0x24 + 0x04`**, el
  puntero al bloque de IA (`registro+0xC0`). Array de 10 entradas, paso `0x24`,
  1:1 y en el mismo orden con los objetos de arma de `0x006DE770 + n*0x110`.
  Confirmado por **dos** observables: daño 105→106 y cadencia 133 ms→3534 ms.
- **`arma_obj + 0x0C` NO es el arma.** Señuelo perfecto, falsificado por efecto.
  No volver a intentarlo.
- **Layout del registro de arma (`0x1E0`): dos bloques.** Jugador en `+0x90`,
  **IA en `+0xC0`**. `Power = bloque+0x18`, `TimeBetweenBullets = bloque+0x20`.
  O sea `Power` de IA en `+0xD8`, `TBB` de IA en `+0xE0`.
- **Directorio de armas en `0x01842084`**, 17 entradas de `0x20`, cinco punteros
  cada una. `probable`, sin tocar.
- **6.1: el ELF no lleva LBAs horneados.** Resuelve por nombre contra la TOC.
- **6.6: el parche in-place del ISO anda**, confirmado en las tres capas.
- **Kynapse está linkeado pero MUERTO**: 0 de 182 metaclases. No buscar sus
  objetos en RAM. El ELF no trae DWARF ni RTTI de Criterion.
- **Volcar SIEMPRE desde 0**: las herramientas asumen que el byte 0 del archivo
  es la dirección EE 0.
- Tabla de armas: `0x01842220` en RAM, `GLOBDATA.BIN + 0x00130E20` en el ISO,
  17 registros de `0x1E0`. Pool de enemigos: `0x0058FE90`, 32 objetos, paso `0x3C0`.

## 6. EL PRIMER COMANDO

```powershell
cd C:\Users\frans\Desktop\claude-acceso\black
python herramientas/inventario.py
python herramientas/aprender.py digesto
```

Y después **E5** (7b): el truco de los 11 caracteres sobre `STLEVEL.BIN`.

```powershell
python herramientas/lbas.py buscar LEVELS/LEVEL_01/STG_0001/STLEVEL.BIN
python herramientas/parche_iso.py preparar --help
```

La operación es reemplazar `bc1_so1_mil` por `bc1_rg1_mil` **in-place**, 11
bytes sobre 11, en una **copia** del ISO. Predicción a registrar antes: si el
nombre es una clave a una tabla del mismo nivel, funciona; si el modelo de ese
enemigo no está cargado en el stage, falta el modelo — y ahí se aprende dónde
vive la lista de recursos, que es lo que hace falta para R6.

**Y antes de medir cualquier daño, verificar qué ISO está montado.**
