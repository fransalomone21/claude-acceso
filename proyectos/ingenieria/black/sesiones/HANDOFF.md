# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/kb/stage-modulos.json` — **entero**. Es el entregable acumulado: los
   61 tipos con handler, instancias, tamaño de blob, familia de nombre **y, de
   esta sesión, el `sitio_de_llamada` de cada uno** (destino, contador, acción,
   qué consume).
2. `black/docs/03-bitacora.md`, **sólo las entradas (38) y (37)**.
3. `black/ESTADO_ACTUAL.md`, sólo el bloque **7e** de N2.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(36), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7e — el índice de módulos del nivel.** Sigue abierta, **por la mitad (b)**.

- **(a) los tipos identificados en `kb/stage-modulos.json` — qué estructura
  consume cada uno y qué subsistema toca: HECHO el 2026-08-29.** Los 61 tipos
  despachados tienen destino, contador, acción y argumentos, todo por
  **lectura de instrucciones**.
- **(b) al menos UN tipo distinto del `0x0A` verificado POR EFECTO: FALTA.**
  **Necesita el emulador.** En frío 7e no se puede cerrar.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

### 3.1 El subsistema está en el SITIO DE LLAMADA, no en el handler

**Es el hallazgo estructural de la sesión, y refuta el plan que traía el
retome.** Se construyó el call graph completo (9842 funciones, 20.205 aristas
`jal`) y se midió el cierre transitivo de `FUN_00175980` —el handler del
`0x2D`— a profundidad 0, 1, 2 y 3: **no alcanza `0x0040F4D4` en ninguna**, que
es la base del registro de física ya medida el 2026-08-28. El handler recibe un
puntero y no sabe de dónde salió. Quien lo materializa es el despachador:

```
0015F778  lw    v0,4(s1)        ; blob del registro
0015F780  lbu   v1,30(v0)       ; la guarda blob[0x1E] == 1
0015F78C  lui   v1,0x0041
0015F790  ld    a1,8(s1)        ; a1 = id64 del NOMBRE
0015F794  lw    a0,-2860(v1)    ; a0 = *(0x0040F4D4)   <-- EL SUBSISTEMA
0015F79C  jal   0x00175980
0015F7A0  addiu a0,a0,2632      ; DELAY SLOT: + 0xA48
```

### 3.2 La tabla de saltos, y las tres coordenadas

**Tabla de saltos: `0x003F4E90`, 69 entradas** (de `lui v0,0x3F; addiu
v0,v0,20112` en `0x0015F030`–`0x0015F038`, y el tope de `sltiu v0,v1,69` en
`0x0015F024`). **61 tipos despachados en 55 bloques distintos**; **8 caen en el
`default`** (`0x0015FBDC`): `0x00 0x01 0x02 0x0D 0x0E 0x21 0x24 0x33`.

| coordenada | qué es |
|---|---|
| **destino** | array de handles `P1+0xNN`, o singleton de `.bss` |
| **contador** | qué índice avanza; mismo array + mismo contador = mismo subsistema |
| **acción** | handler directo `FUN_xxxxxx`, o método virtual `vtable+0xNN` |

Los 60 tipos de módulo (todos menos el `0x35`) caen en **23 grupos**. Firma
típica: `handler(destino, id64_del_nombre, blob, …)`. El `0x2D` **no recibe el
blob**, lo que concuerda con que busca **por nombre**.

Herramienta: **`herramientas/casos_dispatcher.py`** — `mapa` / `familias` /
`arrays` / `caso 0xNN` / `tabla` / `autotest`. Autotest con **6 casos
confirmados por otra vía y 4 sabotajes, los cuatro vistos en rojo**. Salida
también en `kb/casos-dispatcher.json`.

### 3.3 La cola virtual — diez casos sin `jal` propio

`0x0B 0x0C 0x12 0x16 0x17 0x18 0x30 0x31 0x32 0x43` saltan a una cola
compartida en `0x0015F968` / `0x0015F974`:

```
lw v1,16(a3) ; lh a0,176(v1) ; lw v0,180(v1) ; jalr v0 ; addu a0,a3,a0
```

`a3` = handle del array, `+0x10` = vtable. El par (ajuste del `this`, puntero
al método) **discrimina**: `0x0B` y `0x0C` comparten array y contador y llaman
`vtable+0xB0` y `vtable+0xB8`. **Un recorrido del bloque por direcciones
crecientes los pierde enteros** — fue un bug real, y ahora es el sabotaje (b)
del autotest.

### 3.4 `P1` es un directorio de pools, y el inventario está CERRADO

El dispatcher **no crea el objeto**: saca `handles[contador++]` del array que le
toca al tipo. **Doble control**: los offsets de `P1` que usan los casos
individuales y los que recorre el bloque del `0x35` son **los mismos 18** —
`0x00 08 10 14 18 1C 20 24 28 2C 30 34 38 3C 40 44 48 4C`. El `0x35` toca
además `0x94` y `0x9C`. `casos_dispatcher.py arrays`.

### 3.5 El `0x35` NO es un tipo de módulo: es el cierre del stream

Su bloque (`0x0015FB9C`) hace ~25 llamadas y recorre todos los arrays de `P1`
emparejados con offsets de `P2` (`P2+98` … `P2+138`). **0 instancias** en
LEVEL_00. El `switch` mezcla constructores con un paso de commit.

### 3.6 Singletons de `.bss` — un directorio, probable

| global | tipo | qué es |
|---|---|---|
| `0x0040F4D4` | `0x2D`, `0x35` | **registro de física/pathfinding. CONFIRMADO** por otra vía |
| `0x0040F4E4` | `0x2C` (41 inst.) | sin identificar; el preámbulo del dispatcher lo usa en `0x0015EFBC` |
| `0x0040F4F4` | `0x35` | sin identificar; es contra quien registra el cierre |
| `0x0040F510` | `0x2F` | sin identificar, dos indirecciones |
| `0x0040F514` | `0x0A` | **probable**: singleton de personajes |

Con `0x0040F4D0` y `0x0040F4E0` (de 7c y de la entrada (37)), el directorio
tendría al menos 7 entradas. **Probable, no medido.**

### 3.7 El cruce código-vs-datos, y una advertencia

- **`LW`**: los 256 van al `0x2D`, y el `0x2D` es el único que va al singleton
  de física. Exclusivo en los dos sentidos.
- **`SD`**: las 20 instancias son `0x2E` (5), `0x2F` (1) y `0x30` (14), y
  ningún tipo no-`SD` va a esos destinos — pero el sonido usa **tres destinos
  distintos**.
- **`WD`**: se reparte; la familia del nombre **no** determina el destino.

**Mismo array NO es misma struct.** Dentro de `P1+0x1C` conviven blobs de 16,
32, 48, 64, 80 y 96 B. El array es el **pool de destino**; el blob, la
**estructura de entrada**. Dos coordenadas independientes.

### 3.8 El eje de las CADENAS queda refutado POR MEDICIÓN

Sobre el cierre transitivo, no ya sólo al nivel 0: **prof. 3 → 2 handlers de 70
con cadena, 5 cadenas en total.** El eje está **agotado, no sub-explorado**.
Techo del instrumento: los `jalr` no son aristas de un call graph estático.

### 3.9 Sigue valiendo de antes, y no se toca

Layout del registro (`+0x00` tipo, `+0x04` ptr al blob, `+0x08` id64 del
nombre). Descriptor `0x01092800 = {count=857, array=0x0109F590}`, 41 tipos.
`FUN_0012dab8` arma `param_2` con doble indirección `*(u32*)(piVar4[4]+4)`;
cargador doble-buffereado en `base+0x4990` / `base+0x5210`, `0x880` cada uno,
alternados por `*(u8*)(iVar5+0x5aae) ^= 1` en `FUN_00129360`, tag `*piVar4 ==
0x1C`. El stream está **en el ISO**: `/LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN`,
LBA 1056910, 326.432 B, carga en `0x01053000`, 98,46 % disco-vs-RAM; punteros
auto-relativos que el cargador pasa a absolutos in situ. Registro de física
`0x004CB1C8 = *(0x0040F4D4) + 0xA48`, **48 ranuras, 0 ocupadas en los 9
volcados**. Todo 7d y todo 7c. El parche de ISO in-place **anda** (3×).
Observables muertos: `FUN_001A4F70` es un `printf` STUB; `'AI gun model not
found: %s'` hace `sprintf` sobre el stack y no lo usa.

## 4. LO QUE SIGUE, CONCRETO

```
cd C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black
python herramientas/casos_dispatcher.py autotest
python herramientas/casos_dispatcher.py familias
```

### Paso 3b — EN FRÍO, y va PRIMERO. No necesita emulador.

**Localizar `P1` en `volcados/ee-e4.bin` y contar los pools.** `P1 = piVar4 +
0x40`, y `piVar4` se reconoce por el tag `*piVar4 == 0x1C` dentro de
`base+0x4990` / `base+0x5210`. Con `P1` en la mano se leen los 18 punteros de
arrays y se contrastan contra **la predicción numérica que ya sale del stream**:

| array | contador | instancias predichas en LEVEL_00 |
|---|---|---|
| `P1+0x1C` | `c_s5` | **131** |
| `P1+0x3C` | `c_s7` | **118** |
| `P1+0x24` | `c_fp` | **73** |
| `P1+0x08` | `sp+408` | **60** |
| `P1+0x10` | `sp+412` | **57** |
| `P1+0x18` | `sp+416` | **33** |
| `P1+0x14` | `sp+420` | **21** |
| `P1+0x30` | `sp+432` | **20** |
| `P1+0x34` | `sp+440` | **14** |
| `P1+0x4C` | `sp+464` | **6** |
| `P1+0x2C` | `sp+428` | **5** |
| `P1+0x48` | `sp+460` | **4** |
| `P1+0x44` | `sp+456` | **3** |
| `P1+0x28` | **índice fijo 0** | **5** (tipo `0x34`; no lleva contador: siempre `handles[0]`) |
| `P1+0x20` | `sp+424` | **2** |
| `P1+0x00`, `P1+0x38`, `P1+0x40` | `sp+452`, `sp+444`, `sp+448` | **0** |

Son **18 predicciones simultáneas** de una sola medición, con tres ceros
esperados que son el control negativo. (Aparte, el tipo `0x2B` —9 instancias—
no usa un array de punteros sino un **array inline de structs de `0x10`** en
`P1+0xB0`, indexado por `sp+436`: es otra forma y conviene mirarla por
separado.) Si dan, "array de handles" deja de ser
lectura y pasa a ser **medición**, y de paso queda un instrumento para la
mitad (b). Si no dan, el que está mal es el modelo, y se entera acá y no
después de gastar un arranque del emulador.

### Paso 4 — POR EFECTO. NECESITA EL EMULADOR.

**El candidato barato ya no es el `0x2D`**: su registro está vacío en los 9
volcados y el observable no se ve. Los dos que el mapa habilita, en orden de
costo:

1. **Neutralizar un módulo cambiando su `tipo` a un case del `default`**
   (`0x0D`, `0x0E`, `0x21` o `0x24` — están vacíos y no hacen nada). Es **un
   byte** en `STUNIT01.BIN` dentro del ISO, con `parche_iso.py`, que ya se
   confirmó 3 veces. El módulo simplemente no se construye. Escribir la
   predicción ANTES: qué tipo, qué instancia, qué se espera dejar de ver.
2. **Los tipos `SD`** (`0x2E` con 5 instancias, `0x30` con 14): el observable
   es **audible**, que es más barato de juzgar que la geometría, y ya hay
   `awd.py` para los nombres de audio.

### Sigue abierto, y no hay que darlo por sabido

- **CERO registros `0x0A` en el stream**, y LEVEL_00 tiene cinco enemigos. El
  `0x0A` sigue confirmado por 7d pero **no sale de acá**.
- **`P2` tiene campos hasta `+0x8A`** (los usa el `0x35`), y la `kb` lo
  describe como `{count, array}` de 8 B. **No medido.**
- **¿El array de 48 del registro de física se llena y se vacía, o no se llena
  nunca?** El `0` es **confirmado como medición**; "siempre vacío" es
  **probable**. Sigue sin instrumento que haya visto una ranura ocupada.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 NO está corriendo** y no se abrió en toda la sesión. Ejecutable
  correcto (NO el de Program Files):
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
- **RAM limpia, cero parches vivos.** La sesión **no escribió un solo byte** ni
  en memoria ni en ningún ISO. Todo en frío sobre el ELF (`SLUS_213.76`) y
  sobre `volcados/ee-e4.bin`.
- **Ningún ISO se tocó.** El nop de vida infinita de `0x0013BD20` sigue
  restaurado (`0xE65402F8`). `Black.iso` en ReadOnly + guardia `PreToolUse`.
- Controles de apertura en verde: `abrir-sesion.ps1` completo (integridad,
  `ubicaciones.py` 12/12, `inventario.py` 13/13, `decompilar.py info` con el
  control positivo sobre `0x00142B90`). El hook `SessionStart` corrió la capa
  de medidores de `chequeo-completo.ps1`: los tres en verde, saboteadores al
  día.
- Se pierde al reiniciar el emulador: cualquier parche escrito en RAM. Los ISO
  parcheados sobreviven.

## 6. LAS TRAMPAS YA PAGADAS — no volver a pagarlas

1. **Una búsqueda que da CERO acusa al PARÁMETRO, no al mundo.** **Se pagó dos
   veces más esta sesión, y las dos en un nivel más abajo del habitual: el
   parámetro que fallaba era el MODELO DEL ISA que tenía el instrumento.**
   (a) El cierre por handler no alcanzaba el global de física porque el dato
   vive en el sitio de llamada. (b) El barrido de cadenas daba 0 hasta para
   `FUN_00175980` porque limpiaba la sombra de registros **al ver el `jal`**,
   antes de procesar el **delay slot**, que es donde vive la mitad baja de la
   dirección (`lui a0,0x3F` / `jal` / `addiu a0,a0,21664`). En los dos casos
   fue el **control positivo** lo que lo atrapó, no la inspección del código.
2. **En MIPS, el delay slot corre ANTES.** Cualquier análisis de argumentos de
   una llamada tiene que incluirlo, y cualquier sombra de registros tiene que
   procesarlo antes de invalidar los caller-saved. Es el sabotaje (c) de
   `casos_dispatcher.py`.
3. **Un bloque de `switch` no termina donde termina en direcciones.** Diez
   casos saltan a una cola compartida. Recorrer por direcciones crecientes los
   pierde **en silencio**. Sabotaje (b).
4. **`capstone` NO sirve** para el `.text` del EE: `herramientas/barrer.py`, o
   decodificar los campos a mano (es lo que hace `casos_dispatcher.py`).
5. **Un xref sobre heap siempre da 0.** `.bss` termina en `0x0049BFBC`.
6. **Heredocs largos fallan en la Bash tool** (>~30 líneas): escribir el `.py`
   con Write y correrlo. Se volvió a pagar un turno esta sesión. El `cwd` se
   resetea entre llamadas: rutas absolutas.
7. **`comando | tail` devuelve el exit code de `tail`.** Para medir un rojo:
   `cmd > archivo 2>&1; echo $?` — sin pipe.
8. **Corchetes en rutas de Windows son wildcard:** `Test-Path` y
   `Get-ChildItem` dan `False`/vacío **sin error** sobre `Black [NTSC]`.
   `-LiteralPath`, o medir desde Python.
9. **Nombrar handlers por las cadenas rinde poco, y ahora está MEDIDO** sobre
   el cierre transitivo, no sólo al nivel 0: 2 de 70 a profundidad 3. No
   volver a proponer ese eje.
10. **`0x01412400` (STLEVEL.BIN cargado) NO es `piVar4[4]`.** Es una cabecera
    de pares `{count, ptr}` cuyo primer array es la lista de recursos de arma.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú, y el apagado del 2026-08-22.** Es entorno: **no
  mezclarlo con 7e.** Ya medido: evento **1074** lanzado por
  `SysWOW64\shutdown.exe` — apagado **ordenado**, **cero Kernel-Power 41**.
  Hipótesis viva: el cambio a GPU discreta conmuta MSHybrid↔Discrete y el
  panel del fabricante lo aplica llamando a `shutdown.exe`. **Criterio de
  salida, dos minutos:** reabrir BLACK ahora que el modo discreto quedó
  aplicado y medir los fps en el **mismo** menú.
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, lista para cuando Fran vuelva al emulador.
- **Vía C — validar 7d por efecto** (barata, no bloquea): parchear el literal
  `0x5446127297C60000` (`BG1_AK1`) por el de `BG1_RPG` con `parche_iso.py`.
  `bg1_rpg` está en la lista de recursos del nivel, ya confirmado.
