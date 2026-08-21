# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-21**, PC, **sin correr el juego**. Fase 7b
sigue abierta y volvió a cambiar de forma: ahora se ataca **en frío, desde el
ELF**.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/docs/03-bitacora.md`, **sólo la entrada (29)**.
3. `python herramientas/ubicaciones.py` — **no es un documento, es un
   comando.** Dónde vive cada archivo que no está en el repo, medido. Si algo
   crítico está en rojo, arreglar eso antes de cualquier otra cosa.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md` hasta que haga falta desensamblado, y nada de
`perfil-global/`.

## 2. LA FASE QUE SIGUE ABIERTA, Y QUÉ LA CIERRA

**Fase 7b — qué dato fija QUÉ TIPO de enemigo aparece.**

**Cierra cuando** se cambie qué enemigo aparece y se vea **por efecto**: un
`so1` que pasa a ser `rg1` tiene que cambiar el registro de arma que le toca
en `0x006E18B8 + n*0x24 + 0x04`, leíble con `pine.py` sin mirar la pantalla.

**Ahora hay un segundo observable, más barato**: el ELF tiene un camino de
error explícito (`'AI gun model not found: %s'`, `0x003F4848`). Si la
sustitución rompe, el juego lo dice.

**Lo único que traba el experimento sigue siendo el mismo:** falta la lista de
puntos de spawn.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

1. **`Enemy0_Mid` y compañía NO están escritos en ningún lado.** Cero
   ocurrencias en `STLEVEL.BIN`, cero en `STUNIT01.BIN`, cero en los ~2.900
   archivos del ISO. **Se arman en runtime**, con estos formatos del ELF:

   ```
   va 0x003F8108  'Enemy%d_%s'      va 0x003F8118  'Team%d_%s'
   ```

   **No volver a barrer el disco buscándolos.**

2. **Tabla de piezas en `.data`: `0x003BD3F8`**, siete `char*` consecutivos:

   ```
   [0]None  [1]Low  [2]Mid  [3]High  [4]Matt  [5]Tom  [6]Carrie
   ```

   (cadenas en `0x003F7EA8`, `..EB0`, `..EB8`, `..EC0`, `..EC8`, `..ED0`,
   `..ED8`). Índices 0-3 = grado de amenaza; 4-6 = nombres propios.

3. **REENCUADRE IMPORTANTE — `+0x58` es candidato a espejo, no a fuente.**
   Esas cadenas viven en el bloque de
   `../Export/ValueDB/Sound/ps2/AIWeapon.cfg`, rodeadas de `EnemyWeapon`,
   `MaxEnemiesSoundedPerFrame`, `Emphasis Decay Frames`, `BulletBy`, `Rate`:
   son **claves de configuración de sonido de arma de IA**. Que la partición
   por `+0x58` coincida exacto con la de registro de arma de 7a se explica
   sin invocar "descriptor de escuadra": **dos enemigos con la misma arma
   comparten grupo de mezcla**. El handoff anterior lo daba como la vía de
   entrada a 7b; **hay que tratarlo con más desconfianza**.

4. **Hay una lista de armas POR NIVEL, y el ELF la nombra:**

   ```
   0x003F4848  'AI gun model not found: %s'
   0x003F4864  'Please ask a designer to add it to the '
   0x003F488D  'weaponList.txt file for this level'
   ```

   Es el directorio `STLEVEL+0x80` (7 registros de paso `0x28`) que ya
   conocíamos. Y es **el modo de falla que E5 predecía, con mensaje propio**.

5. **Las rutas de nivel se construyen** (`.rodata`, desde `0x003F4348`):
   `Levels\Level_%02u\Stg_%04u\StLevel.bin`, `...\StUnit%02d.bin`,
   `...\Guns%s.bin`, `...\LevelDat.bin`, `...\Unit_%02d.bin`, `...\fpguns\`.

6. **Los dos grupos de los nombres `bc1_`, caracterizados — ninguno es lista
   de spawn.** Los dos son entradas de recurso con tamaño declarado:

   | | grupo A (cabecera de chunk) | grupo B (`1.0f` + tamaño) |
   |---|---|---|
   | `so1` | `0x175a8` tam `0x10700` | `0x8439c` tam `0x2ad9c` |
   | `lr1` | `0x17a8` tam `0x15e40` | `0xb3afc` tam `0x2f6fc` |
   | `rg1` | **STUNIT01** `0x2a8` tam `0x15e70` | **STUNIT01** `0x3f65c` tam `0x292dc` |

   Grupo A lleva `flags = 0x00101001` en `-8` y el tamaño en `-4`. Grupo B
   lleva tres pares `008a0105`/`3f800000` antes del tamaño. **`rg1` tiene los
   dos y con estructura idéntica a `so1`: la sustitución de 11 bytes sigue en
   pie.**

7. **`kb/ubicaciones.json` + `herramientas/ubicaciones.py`** — dónde vive cada
   archivo del proyecto, en un solo lugar, verificado por medición. 13/13.
   Probado rompiéndolo en tres formas distintas.

## 4. LO QUE SIGUE, CONCRETO — todo en frío, sin emulador

```
python herramientas/ubicaciones.py          # 13/13 antes de empezar
python herramientas/decompilar.py info      # control positivo de Ghidra
```

Después, la pregunta que desatasca 7b: **¿quién arma el nombre, y de dónde
saca el índice?**

1. `xref.py` / Ghidra sobre **`0x003BD3F8`** (la tabla) y sobre
   **`0x003F8108`** (`'Enemy%d_%s'`). La función que hace ese `sprintf` recibe
   el índice de algún lado — ese "algún lado" es el campo que 7b busca.
2. Lo mismo con **`0x003F4848`** (`'AI gun model not found'`): quien emite ese
   error es el cargador de armas de IA, y por ahí pasa la resolución
   nombre→recurso que el negativo de punteros del 2026-08-17 ya había
   señalado.
3. Recién con eso, la escritura de prueba: **en RAM, 11 bytes, reversible**.
   El ISO al final.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 abierto por Fran, pero BLACK NO se corrió a propósito**: notebook
  sin cargador. Toda esta sesión fue en frío.
- **Cero escrituras, cero parches vivos.**
- Los dos ISO están **enteros y en su lugar** (`ubicaciones.py` lo mide).
  `D:` y `E:` montan **los dos el mismo `Black.iso` original** — verificado
  por huella, no por letra: `GLOBDATA.BIN` de las dos unidades tiene el mismo
  md5 `e48221c5d55af24abe41399fad359500`. El ISO parcheado **no** está
  montado.
- **Trampa que costó dos turnos:** `Test-Path` sin `-LiteralPath` da `False`
  sobre `...\Black [NTSC]\...` **existiendo**, porque los corchetes son
  wildcard. Para verificar rutas, `ubicaciones.py` (Python) o `-LiteralPath`.
- `volcados/stlevel-l00.bin` es la copia de `STLEVEL.BIN` de `LEVEL_00`
  (2.502.240 B, md5 `b76664fc21769443103bb3ee88a41363`). Sale del ISO montado,
  así que **no hace falta el emulador** para volver a sacarla.
