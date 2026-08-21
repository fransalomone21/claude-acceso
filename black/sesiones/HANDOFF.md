# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-21 (noche)**, PC, **sin correr el juego**.
Fase 7b sigue abierta, pero por primera vez **hay una estructura concreta que
volcar**: la lista de personajes por unidad.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/docs/03-bitacora.md`, **sólo la entrada (30)**. La (29) ya está
   resumida acá abajo.
3. `python herramientas/ubicaciones.py` — **no es un documento, es un
   comando.** Si algo crítico sale en rojo, arreglar eso antes que nada.
4. Los volcados de esta sesión, que son la materia prima del próximo paso:
   `volcados/7b/fun-001e2d38.c` (el enumerador) y
   `volcados/7b/fun-00136848-aigun.c` (el cargador de armas de IA).

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, y nada de `perfil-global/`.

## 2. LA FASE QUE SIGUE ABIERTA, Y QUÉ LA CIERRA

**Fase 7b — qué dato fija QUÉ TIPO de enemigo aparece.**

**Cierra cuando** se cambie qué enemigo aparece y se vea **por efecto**: un
`so1` que pasa a ser `rg1` tiene que cambiar el registro de arma que le toca
en `0x006E18B8 + n*0x24 + 0x04`, leíble con `pine.py` sin mirar la pantalla.
Segundo observable, más barato: el camino de error
`'AI gun model not found: %s'` (`0x003F4848`) — si la sustitución rompe, el
juego lo dice.

**Lo que trababa el experimento —"falta la lista de puntos de spawn"— dejó de
ser un agujero y pasó a ser una dirección concreta a volcar.** Ver el punto 3.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

**Todo `probable`: es lectura de decompilado, no se escribió un byte.**

1. **`'Enemy%d_%s'` tiene UNA sola referencia**, `0x001E2DE4`, dentro de
   **`FUN_001E2D38`**. Es el enumerador de enemigos y compañeros del stage.

2. **El layout que faltaba, entero:**

   ```
   objeto de stage  (el recurso tipo 0x0B que carga FUN_00128480)
     +0x04  ptr -> array de registros de UNIDAD, paso 0x28
     +0x08  cantidad de unidades
     +0x10  ptr -> tabla de nombres (u64) : +0x08 cantidad, +0x0C array de 0x10

   registro de UNIDAD (paso 0x28)
     +0x18  ptr -> array ENEMIGOS   +0x20  cantidad
     +0x1C  ptr -> array COMPANEROS +0x24  cantidad

   registro de PERSONAJE (paso 0xB0)   <-- LA LISTA QUE FALTABA
     +0x00  buffer de nombre (destino del sprintf, FUN_0035D728)
     +0x88  INDICE DE TIPO   (lo que 7b busca)
     +0x94  se registra en el sistema de sonido (FUN_0027B950)
   ```

3. **`+0x88` es un enum de hasta 33 valores, no de 7.** `FUN_001E3018` acepta
   `idx < 0x21` y salta por la jumptable `PTR_LAB_003F8130`; la tabla de 7
   punteros de `0x003BD3F8` se lee **desde adentro** (`0x001E3044`, su única
   referencia). `None/Low/Mid/High/Matt/Tom/Carrie` **era el codominio, no el
   dominio**.

4. **Quién carga el stage:** `FUN_00128480`, en `0x00128958`. Máquina de
   estados con **nivel en `+0x5AAC` y stage en `+0x5AAD`** (los dos `u8`).
   Pide `FUN_00108458(DAT_0040F4C4, 0x0B, idx)` → `+0x5AF0`. Si falla, arma la
   ruta con `0x003F4388` y va al disco.

5. **El cargador de armas de IA, entero** (`FUN_00136848`):
   `id = FUN_00272610(nombre, 0xE69A1DD748000000)` → `FUN_00108120(...)` → si
   0, error `0x003F4848`; si no, `FUN_00135C78(actor,0,res,0)` y
   `actor+0x3B4 = 0`. El arma de IA se resuelve **por nombre**.

6. **El ID de 64 bits tiene codec de ida y vuelta y hay que desarchivarlo.**
   `FUN_00272610(texto, base)` codifica, **`FUN_00272488(id, buffer)`
   decodifica** — el bucle de `stage+0x10` la usa y después recorta espacios a
   la derecha: cadena empaquetada de ancho fijo. La (28) lo daba por "no vale
   la pena"; es la llave para escribir nombres nuevos en vez de sustituir 11
   bytes a ciegas.

**De la sesión anterior (29), sigue valiendo y NO se rehace:**

- Los nombres de escuadra **no están escritos en ningún archivo del ISO**: se
  arman en runtime. **No volver a barrer el disco.**
- **`+0x58` es espejo, no fuente**: esas cadenas son claves de sonido
  (`ValueDB/Sound/ps2/AIWeapon.cfg`). Esta sesión lo confirma: la llamada que
  las usa es `FUN_0027B950`, con
  `PTR_s____Export_ValueDB_Sound_ps2_AIWe_003BD3B8`.
- Rutas de nivel construidas con formato desde `0x003F4348`.
- Los dos grupos de los nombres `bc1_` (ninguno es lista de spawn):
  `so1` A=`0x175A8` tam `0x10700`, B=`0x8439C` tam `0x2AD9C` (STLEVEL);
  `lr1` A=`0x17A8` tam `0x15E40`, B=`0xB3AFC` tam `0x2F6FC` (STLEVEL);
  `rg1` A=`0x2A8` tam `0x15E70`, B=`0x3F65C` tam `0x292DC` (STUNIT01).
  **`rg1` tiene los dos con estructura idéntica a `so1`: la sustitución de 11
  bytes sigue en pie** — pero con el punto 6 quizá ya no haga falta.
- Los archivos de stage se cargan **literales** en RAM: `STLEVEL.BIN` de
  `LEVEL_00` → `0x01412400`; `STUNIT01.BIN` → `0x01053000`.
- El savestate slot 3 está en **`LEVEL_00`**, no en `LEVEL_01`.
- `kb/ubicaciones.json` + `herramientas/ubicaciones.py`, 13/13.

## 4. LO QUE SIGUE, CONCRETO — todo en frío, sin emulador

```
python herramientas/ubicaciones.py          # 13/13 antes de empezar
python herramientas/decompilar.py info      # control positivo de Ghidra
```

1. **El paso que cierra 7b: volcar el array de `0xB0`.** `volcados/stlevel-l00.bin`
   es la copia literal de `STLEVEL.BIN` de `LEVEL_00` (sale del ISO montado,
   **no hace falta el emulador**), y en RAM esa imagen vive en `0x01412400`.
   Los punteros del archivo en disco son offsets/IDs, no direcciones, así que
   conviene resolver el `stage+0x04 / +0x08` **sobre la imagen en RAM** o
   deducirlo del parser del contenedor `.BIN` (`kb/rutinas.json#fixup_contenedor_bin`).
   Una vez ubicado un registro de `0xB0`: **volcar el rango crudo hacia los dos
   lados hasta que deje de parsear** — no barrer por los valores que ya se
   conocen, que es cómo la tabla de 7 se hizo pasar por tabla de 6.
   **Qué campo del registro nombra al personaje (`so1`/`rg1`): eso cierra 7b.**
2. `decompilar.py c 0x00272488` y `0x00272610` — el codec de nombres de 64 bits.
3. `decompilar.py c 0x00108458` — cómo se indexa el recurso de stage tipo `0x0B`.
4. Recién con eso: escritura de prueba **en RAM, reversible**. El ISO al final,
   con `parche_iso.py`.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **BLACK NO se corrió**: notebook sin cargador, y la sesión se cortó por
  batería. Toda la sesión fue en frío, sobre el ELF.
- **Cero escrituras, cero parches vivos.**
- `ubicaciones.py` **13/13**, medido esta sesión. `decompilar.py info` con el
  control positivo en verde (9842 funciones, `100.0` en `FUN_00142b90`).
- Ghidra: **`C:\Users\frans\herramientas\ghidra-proyectos2\BLACK.gpr`**
  (con `herramientas\` en el medio — el retome del 2026-08-21 lo tenía mal).
- Los dos ISO enteros. `D:` y `E:` montan **los dos el mismo `Black.iso`
  original** (md5 de `GLOBDATA.BIN` idéntico); el parcheado no está montado.
- **Trampa de Windows:** `Test-Path`/`Get-ChildItem` sin `-LiteralPath` dan
  `False`/vacío sobre `...\Black [NTSC]\...` **existiendo**. Verificar rutas
  desde Python (`ubicaciones.py`).
- `volcados/7b/` (nuevo) tiene los cuatro decompilados y los cuatro xrefs de
  esta sesión.
