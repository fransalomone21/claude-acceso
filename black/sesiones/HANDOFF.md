# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-22**, PC, **sin correr el juego**.
La lista de personajes está volcada y el campo que los nombra, identificado.
**7b sigue abierta**: cierra por efecto, y todavía no se escribió un byte.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/docs/03-bitacora.md`, **sólo la entrada (31)**. La (30) y la (29)
   están resumidas acá abajo.
3. `python herramientas/id64.py --help` — **no es un documento, es la
   herramienta nueva**, y es la llave de todo lo que sigue.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, la entrada (30), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**Fase 7b — qué dato fija QUÉ TIPO de enemigo aparece.**

**Cierra POR EFECTO**, no por lectura: cambiar `+0x18` de un registro de
personaje y ver que cambia el registro de arma que le toca en
`0x006E18B8 + n*0x24 + 0x04`, leíble con `pine.py` sin mirar la pantalla.
Observable de error más barato: `'AI gun model not found: %s'` (`0x003F4848`).

La parte de lectura **ya está hecha**. Lo que falta es la escritura.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

**Todo `probable`: cero escrituras.**

### El campo que nombra al personaje es `+0x18`, y es un id64

**No es `+0x00`.** `+0x00` es el destino del `sprintf` `'Enemy%d_%s'`: se
llena en runtime y en disco está vacío. Por eso la (29) barrió el ISO y no
encontró los nombres.

```
registro de PERSONAJE (paso 0xB0)
  +0x00  buffer que el sprintf pisa en runtime  -- INUTIL en frio
  +0x18  id64 del MODELO  <-- EL NOMBRE. Lo que 7b buscaba
  +0x20 / +0x28 / +0x30   id64 de las variantes M1 / M2 / M3
  +0x68 / +0x70           id64 de las variantes S0 / E0
  +0x78  id64 de otra familia: MGNDST0 / MGNDST2 / DISTANT0 / RPG0
  +0x88  indice de tipo (FUN_001E3018 exige < 0x21). En L00: 0,0,2,2,1,0x10,8,0,4
  +0x94  parametro de sonido (FUN_0027B950)

registro de UNIDAD (paso 0x28)
  +0x00  nombre ASCII       +0x10  el MISMO nombre como id64 (control cruzado)
  +0x18  ptr enemigos       +0x20  cantidad
  +0x1C  ptr companeros     +0x24  cantidad
  (si la cantidad es 0, el puntero es BASURA -- 0xFF072380 en L00 -- no un nulo)

objeto de stage = la cabecera del contenedor, en 0x01412400
  +0x04  ptr array de unidades    +0x08  cantidad (7 en L00)
  +0x10  seccion de nombres: +0x08 cantidad, +0x0C offset RELATIVO A LA SECCION
```

Los 9 personajes de `LEVEL_00`, con su unidad:

```
bg1_pst      ENEM  PSTL0          +0x88=0     @0x01412600
bg1_shg      ENEM  SHTG0          +0x88=0     @0x01412700
0001_bg1_smg ENEM  E_MAC10_M0     +0x88=2     @0x01412800
0001_bg1_ak1 ENEM  E_BLACKHD_M0   +0x88=2     @0x01412900
0001_bg1_ak1 ENEM  E_LKISS2_M0    +0x88=1     @0x014129B0
0001_bg1_asr COMP  MCHNGNM0       +0x88=0x10  @0x01412A80
0001_bg1_asr COMP  SBMCHGNM0      +0x88=8     @0x01412B30
bg1_rpg      ENEM  RPG0           +0x88=0     @0x01412C00
0001_bg1_sm5 ENEM  E_UZI_M0       +0x88=4     @0x01412D00
```

### El codec de 64 bits: `herramientas/id64.py`

`FUN_00272488` es **base-40, 12 caracteres, escrito de atrás hacia adelante**.
`0=' '`, `1='-'`, `2='/'`, `3..12='0'..'9'`, `13..38='A'..'Z'`, `39='_'`.
**Sin minúsculas.** Ya está portado y con `autotest` **probado en rojo** (se
rompió a propósito de dos formas distintas).

```
python herramientas/id64.py decodificar 0xA79C744648E00000   # -> 'PSTL0'
python herramientas/id64.py codificar E_UZI_M0
python herramientas/id64.py buscar volcados/stlevel-l00.bin --min-relleno 2
python herramientas/id64.py autotest
```

### LAS TRAMPAS QUE YA SE PAGARON — no volver a caer

1. **En disco los punteros NO son offsets del archivo.** Son relativos a la
   sección `0x80`: el fixup hace `base + 0x80 + valor`. Sobre el ISO crudo el
   puntero de la unidad 0 da `0x180`, que cae **dentro del propio array de
   unidades**, y el parseo produce bloques plausibles pero **falsos**.
   **Trabajar sobre `volcados/ee-03.bin` en `0x01412400`**, donde el fixup ya
   está aplicado (99.60% idéntico al archivo en los primeros 64 KB).
2. **`+0x88 < 0x21` NO sirve como prueba de layout.** Con el layout equivocado
   daba 7/9 y un paso inventado de `0xAC` daba 8/9, porque casi todos los
   valores reales son `0` y el cero pasa cualquier test de rango. Con el
   layout correcto da 9/9. **Correr siempre el control negativo.**
3. **Buscar ids en un archivo sin exigir relleno es ruido**: el codec es
   total, así que "alfabeto válido" da 79.048 nombres distintos en
   `STLEVEL.BIN`. Con `--min-relleno 2` quedan 88 y son todos reales.

**De las sesiones (29) y (30), sigue valiendo y NO se rehace:**

- Los nombres de escuadra **no están escritos como texto en el ISO**.
  **No volver a barrer el disco** — ahora se sabe por qué: son id64.
- **`+0x58` es espejo, no fuente**: son claves de sonido
  (`ValueDB/Sound/ps2/AIWeapon.cfg`, vía `FUN_0027B950`).
- `'Enemy%d_%s'` (`0x003F8108`) tiene **una sola** referencia: `0x001E2DE4`,
  dentro de `FUN_001E2D38` (el enumerador).
- `FUN_001E3018`: `idx < 0x21` (**33** valores), jumptable `PTR_LAB_003F8130`.
  La tabla de 7 de `0x003BD3F8` (`None/Low/Mid/High/Matt/Tom/Carrie`) es el
  **codominio**, no el dominio.
- Carga de stage: `FUN_00128480`, nivel en `+0x5AAC` y stage en `+0x5AAD`
  (`u8`); `FUN_00108458(DAT_0040F4C4, 0x0B, idx)` → `+0x5AF0`.
  `FUN_00108458` es un **lookup en una tabla en RAM** (paso `0x0C`, hasta 17
  entradas, resultado en `+0xD40`): no ayuda a ubicar nada dentro del archivo.
- Cargador de arma de IA `FUN_00136848`:
  `id = FUN_00272610(nombre, 0xE69A1DD748000000)` → `FUN_00108120(...)`; si 0,
  error `0x003F4848`. El actor de IA llega al menos a `+0x3B4`.
- Grupos `bc1_` (ninguno es lista de spawn): `so1` A=`0x175A8`/`0x10700`,
  B=`0x8439C`/`0x2AD9C`; `lr1` A=`0x17A8`/`0x15E40`, B=`0xB3AFC`/`0x2F6FC`;
  `rg1` A=`0x2A8`/`0x15E70`, B=`0x3F65C`/`0x292DC` (STUNIT01).
- `STLEVEL.BIN` L00 → `0x01412400`; `STUNIT01.BIN` → `0x01053000`.
- Savestate slot 3 está en **`LEVEL_00`**.

## 4. LO QUE SIGUE, CONCRETO

```
python herramientas/ubicaciones.py          # 13/13 antes de empezar
python herramientas/decompilar.py info      # control positivo de Ghidra
python herramientas/id64.py autotest        # el codec
```

1. **Lo que cierra 7b: la escritura de prueba, EN RAM y reversible.**
   Con el juego en `LEVEL_00`, escribir en `0x01412600 + 0x18` el id64 de otro
   modelo (por ejemplo el de `E_UZI_M0`, `0x68C077EC2EA7B000`) y mirar el
   registro de arma en `0x006E18B8 + n*0x24 + 0x04`. Guardar el valor viejo
   antes: son 8 bytes, la vuelta atrás es trivial.
   **Pregunta abierta**: `+0x18` se lee durante la carga del stage, así que
   quizá haya que escribir **antes** de que se enumere — o forzar una recarga.
2. `decompilar.py c 0x00272610` — el lado codificador, para confirmar que
   `id64.py codificar` produce exactamente lo mismo que el juego.
3. Recién con el efecto visto: el ISO, con `parche_iso.py`.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **BLACK NO se corrió. Cero escrituras, cero parches vivos.**
- `ubicaciones.py` **13/13**, medido esta sesión. `decompilar.py info` en
  verde. `id64.py autotest` en verde, **y probado en rojo**.
- Ghidra: `C:\Users\frans\herramientas\ghidra-proyectos2\BLACK.gpr`.
- `D:` y `E:` montan **los dos el `Black.iso` original**; el parcheado no está
  montado.
- **Trampa de Windows:** `Test-Path`/`Get-ChildItem` sin `-LiteralPath` dan
  `False` sobre `...\Black [NTSC]\...` **existiendo**. Verificar desde Python.
- **OJO, fuera del proyecto:** `perfil-global/` está **desincronizado entre
  ramas**. La copia instalada en `~/.claude` tiene **45** lecciones; la rama de
  BLACK tiene **37** commiteadas. **Correr `perfil-global/install.ps1` desde
  esta rama pisaría la copia instalada y perdería 8 lecciones.** No se corrió.
  Las 2 lecciones nuevas de esta sesión están en `lecciones.jsonl` (39) pero
  **no** se foldearon en `chequeo-de-trabajo.md` por eso mismo.

---

READY FOR NEW SESSION
