# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para el instrumental, a
`docs/06-herramientas-externas.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Lo primero de cualquier sesión

```powershell
python herramientas/inventario.py          # qué hay en LA MÁQUINA
python herramientas/decompilar.py info     # control positivo de Ghidra
```

**El repo es la memoria del proyecto, no la de la máquina.** Antes de decir
que una herramienta "no está instalada", se corre `inventario.py`. Esa regla
nació de un error real: PCSX2-MCP estaba bajado en `Descargas` desde el
2026-08-15 y varias sesiones seguidas lo dieron por ausente porque el repo lo
decía.

---

## Mapa de fases — de mayor a menor abstracción

Cuatro niveles. Se baja de nivel sólo cuando el de arriba tiene su criterio de
salida cumplido. `docs/04-plan.md` tiene el detalle histórico por fase; **este
mapa manda**.

```
N0  OBJETIVO       Modificar BLACK con criterio, y que el cambio sobreviva
                   a cerrar el emulador.
     └─ cierra cuando exista un artefacto (ISO o pnach) que alguien más
        pueda usar sin repetir la investigación.

N1  CAPACIDADES    Cuatro, independientes entre sí.
     ├─ A. LEER LA MÁQUINA VIVA .......................... CERRADA
     │     PINE, escaneo diferencial, savestates, watchpoints.
     ├─ B. LEER EL CÓDIGO ................................ CERRADA
     │     Ghidra + r5900, 9842 funciones. Y desde 2026-08-16,
     │     la RAM viva ADENTRO de Ghidra (`decompilar.py estado`).
     ├─ C. LEER EL ISO ................................... ABIERTA  <-- acá estamos
     │     Contenedor .BIN resuelto. Faltan .WDD .DB .BKS .SSH .SLB.
     └─ D. ESCRIBIR .......................................ABIERTA
           pnach: listo para probar. ISO permanente: falta el in-place.

N2  FASES DEL JUEGO
     0  entorno ........................................... cerrada
     1  ancla: vida del jugador ........................... cerrada
     2  rutina de daño del jugador ........................ cerrada, por efecto
     3  enemigos .......................................... cerrada, por efecto
     4  tabla de armas .................................... cerrada (daño AL jugador)
     4b daño de SALIDA del jugador ........................ cerrada, por efecto
     5a mod de daño ...................................... PARQUEADA (ver abajo)
     5b qué elige la zona de impacto ..................... pendiente, es Opus
     6  exprimir el ISO ................................... ABIERTA, es la prioridad

N3  TAREAS CONCRETAS DE LA FASE 6         (criterio de salida de cada una)
     6.1  ¿el ELF tiene LBAs hardcodeados?  -> decide in-place vs rebuild
     6.2  .DB  : firma '..FT' en 6-7        -> qué son los 139 archivos
     6.3  .WDD : byte1 = 0x02, 16K/64K      -> qué es el byte 0
     6.4  .SLB : magia "KING"               -> buscar el formato por esa magia
     6.5  patrón de ImHex del contenedor .BIN -> commitear en `patrones/`
     6.6  parche in-place de GLOBDATA.BIN sobre una COPIA del ISO
```

**Por qué 5a está parqueada:** Fran decidió el 2026-08-16 exprimir el ISO
**antes** de volver al emulador. El pnach de `0x00142CA0` sigue siendo válido
y es media hora de trabajo cuando se retome; no se perdió nada.

---

## Fase 6 — el ISO. Lo que se sabe al 2026-08-16

### El hallazgo que decide el camino de escritura

Reconstruir un ISO de PS2 **reasigna los LBA de todos los archivos**, aunque
no cambie ningún byte de contenido. Y en la era PS2 era práctica corriente que
el ejecutable llevara **LBAs hardcodeados** en vez de leer la TOC de ISO9660.
Un ISO reconstruido puede arrancar bien y fallar tres niveles después, sin
decir por qué.

**Conclusión: el parche in-place es el camino, y no por comodidad.** Los
`Power` son f32 de 4 bytes; el archivo no cambia de tamaño, el layout no se
toca, los LBA quedan donde estaban. `mkps2iso` es el plan B.

**Tarea 6.1, la que decide todo:** buscar LBAs hardcodeados en el ELF. Si los
hay, "reconstruir el ISO" pasa a callejón cerrado formalmente.

### Firmas de cabecera — `herramientas/firmas.py` (nueva)

Se busca **por posición de byte**, no por u32: un entero en little-endian
mezcla los cuatro bytes y esconde justo la constante que uno busca.

| Familia | N | Tamaños | Firma encontrada |
|---|---|---|---|
| `.SLB` | 9 | 720 B – 23 KB | **`01 00 00 00` + `"KING"` + `00 00 00 00`**, los 12 bytes constantes en 9/9 |
| `.WDD` | 141 | **16384 o 65536 exactos** | **byte 1 = `0x02` en 141/141**; byte 0 varía (19 valores) |
| `.DB` | 139 | 504–725 KB | **byte 0 = `0x00`, bytes 6-7 = `"FT"` en 139/139**; byte 1 sólo `0x14`/`0x94`; byte 5 sólo `0x12`/`0x14`/`0x15` |

**Ninguno de los archivos del ISO es un RenderWare binary stream plano**
(0/141, 0/139, 0/9): los primeros 12 bytes no parsean como cabecera de chunk
RW con tamaño coherente. O sea que los formatos son contenedores de Criterion;
puede haber streams RW **adentro**, pero no en la primera capa.

`.WDD` con tamaño potencia de dos exacta = búfer de tamaño fijo, no stream.
`GRDPIN.WDD` es `0C 02 00 00` y después **todo ceros**: un búfer vacío. Eso
sostiene la lectura de "slot de tamaño fijo" y no la de "archivo comprimido".

### El encuadre que cambió

BLACK corre sobre **RenderWare**, de la propia Criterion. Dejamos de buscar
"herramientas para BLACK" —no existen— y pasamos a buscar "herramientas para
RenderWare", que sobran: RW Analyze, Magic.TXD, RWview, rw-parser, y **el SDK
original de RenderWare 3.10 para PS2 está en archive.org**, con headers. Ver
`docs/06-herramientas-externas.md`.

**Dato de terceros, sin verificar:** dos personas distintas en ResHax dicen
que **la versión de Xbox del mismo juego usa formatos más simples**. Si la
geometría se traba, comparar contra el build de Xbox es una entrada barata.

---

## Instrumental — verificado 2026-08-16 con `inventario.py`

| Herramienta | Estado |
|---|---|
| Ghidra 12.1.2 + extensión EE Reloaded v2.1.36 | instalado |
| pyghidra 3.1.0 · capstone 5.0.9 · numpy 2.5.2 | instalado |
| **pycdlib 1.20.0** · **zstandard** · **kaitaistruct** | **instalados 2026-08-16** |
| **ImHex 1.38.1** (winget, va SIN `--scope user`) | **instalado 2026-08-16** |
| ffmpeg 9.0 (winget `Gyan.FFmpeg`) | ya estaba |
| vgmstream r2117 | instalado |

**Bajado por Fran y pendiente de que lo corra ÉL:** `PCSX2-MCP-v1.0.0-win64`
en `Descargas`, descomprimido, con `setup-mcp.bat`, el `pcsx2-mcp-server/` ya
poblado y `node-v24.19.0-x64.msi` al lado. Trae un `pcsx2-qt.exe` sin firmar
que reemplaza al emulador: bajarlo y ejecutarlo es decisión suya. Una vez que
él lo corre, la sesión lo usa.

**La RAM viva adentro de Ghidra — funcionando desde el 2026-08-16.**
`decompilar.py estado` carga un savestate sobre una **copia** del programa
(`/SLUS_213.76_estado`), nunca sobre el limpio. Pisa `.data`, `.sdata`,
`.sbss`, `.bss`, `.lit4`, `.vudata`, `.gcc_except_table`, y crea **`.other`
con 28,7 MB de heap navegable** desde `0x0049BFBC`. Control positivo pasado:
`jugador+0x10 = 0x003DC5F8` y vida `437.57`.

---

## Formato del contenedor `.BIN` — RESUELTO (2026-08-16)

Cayó **decompilando el cargador**, no mirando bytes. El callback de
`GlobData.bin` (`0x00105D48`) no parsea: **relocaliza**. Los u32 de la
cabecera son offsets relativos que el cargador convierte en punteros absolutos
sumándoles la base, en el lugar:

```c
*(int *)(base + 0x04) += base;   // y +0x08, +0x0C, +0x10, +0x14, +0x18
```

Por eso fallaba la hipótesis de "tabla de offsets creciente": no es una tabla
ordenada, es una cabecera de layout fijo donde cada ranura es una sección.
Recursivo hacia adentro: cantidad en `+0x00` (u8), registros de paso fijo.

Verificado con dos controles que no se ajustaron para que dieran: la tabla de
armas (`0x00130E20`) cae dentro de la sección de `0x00130C80` a `+0x1A0`; y en
`STLEVEL.BIN` la sección de `0x80` arranca con `"bg1_shg"`. Ficha en
`kb/rutinas.json#fixup_contenedor_bin`.

**No aplica a `LEVELDAT.BIN` ni a `GUNS.BIN`**: usan otro layout.

---

## Barrido del ISO (2026-08-16) — reconocimiento

1. **La tabla de armas está en `GLOBDATA.BIN + 0x00130E20`** — 17 registros de
   `0x1E0`, paso verificado por dos anclas (Magnum en `+2`, HVY en `+10`).
   Habilita el mod permanente. `probable`: nadie editó el archivo todavía.
2. **Nombres de hueso en `0x003BCE70`** (`const char*[11]`: `NECK`,
   `MIDSPINE`, `LOWERSPINE`, `SHOULDER/ELBOW/UPPERLEG/KNEE_LT/RT`). Los
   resuelve a índices `0x001381E0`. Material de Fase 5b, **no** la respuesta:
   11 nombres contra 24 registros de zona.
3. **Mapa exacto del ELF**: `.data 0x003BC380`, `.rodata 0x003F2280`,
   `.lit4 0x0040D800`, `.sdata 0x0040D980`, `.bss 0x0040EC80`, y
   **`$gp = 0x004157F0`**.
4. **561 globales se direccionan por `$gp`** (3051 accesos). Si
   `xref.py absoluto` da NADA entre `0x0040D7F0` y `0x0041D7F0`, la hipótesis
   buena es `$gp`.
5. **El middleware de IA es Kynapse**: `CShooterAgent` declara `GunRange` y
   `MaxInaccuracy`.

---

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` + log de arranque → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`** (`jugador 0x005A8AB0 + 0x2F8`, f32) | escaneo diferencial + escritura con efecto. **Confirmación independiente de terceros:** el código público es `205A8DA8 44960000` |
| **Daño al jugador: `0x0013BD20`** (`swc1 f20,0x2F8(s2)`) | watchpoint + golpe real; nop = vida infinita |
| **El puntero de clase está en `objeto+0x10`** | vtable del jugador `0x003DC5F8`; reconfirmado por el cargador de savestates el 2026-08-16 |
| **Método virtual #8 (`vtable+0x4C`) = "recibir daño"** | censo de las 279 vtables |
| **Clase del enemigo = `0x003DCA78`** — 32 objetos, pool `0x0058FE90`, paso `0x3C0`, vida `100.0` en `+0x2F8` | `clases.py`, confirmado por efecto |
| **Daño al enemigo: `0x00134654`**; clamp de muerte `0x00134514` | nop puesto → cargador entero de AK sin matarlo |
| **Tabla de armas: 17 registros de `0x1E0`, `Power` en bloque+`0x18`** — gobierna el daño que se le hace **al jugador** | `Power = 300` → reacción de arma pesada en pantalla |
| **El daño de salida del jugador NO usa `Power`**: sale de `zona * 100.0` en `0x00142B90` | factores en 3.0 → mueren de UNA bala; parche releído después del test |
| **Objeto de arma por tirador: `0x006DE770 + n*0x110`**, dueño en `+0x10` | volcado: `+0x10` = `0x005A8AB0` |
| **Cola de daño diferido = global `0x00414AD0`** (16 registros de `0x20`) | `lui 0x41 + addiu 0x4AD0` en `0x0015B308` |
| **Mapeo del ELF: `offset_archivo = vaddr - 0xFF000`**, un solo `PT_LOAD` | verificado 6/6 |
| **Los breakpoints de EJECUCIÓN crashean el emulador**; los watchpoints no | `bp poner` mató el proceso |
| Un volcado completo de los 32 MB por PINE tarda **~3 s** | medido 2026-08-16 |

## Callejones cerrados — no repetir

- **Los cinco `26.0` de `0x0042C3AC..0x0042D56C` NO son la tabla de armas.**
  Están en BSS, se les escribió 300.0 y no cambió nada; además ensucian el HUD.
- ~~**La tabla de armas no está en el ISO.**~~ **REABIERTO: sí está**, en
  `GLOBDATA.BIN + 0x00130E20`. Lo que sigue en pie: **`GUNS.BIN` no es la
  tabla** (es geometría).
- **`0x0013C120` es el método #9 de la clase del JUGADOR.** Falsificado por efecto.
- **El escaneo diferencial no sirve para la vida de un enemigo**: muere en 4 balas.
- **No hay script de QuickBMS ni plugin de Noesis para BLACK.** Reverificado
  2026-08-16 en ResHax #514: el hilo no tiene una sola línea técnica.
- **Los archivos del ISO no son RenderWare binary streams planos.** 0/141 `.WDD`,
  0/139 `.DB`, 0/9 `.SLB`. Medido con `firmas.py` el 2026-08-16.

## Hipótesis activas

- **Vida máxima = 1200.0**, hardcodeada. Falta qué elige entre 1200.0 y 750.0.
- `arma+0x18` (25, 10, 50) es candidato a **cargador**. Sin confirmar.
- El código de 3 letras de `arma+0x1C0` está **corrido un registro**.
- `.SLB` con magia `"KING"` es la tabla de nombres del sistema de audio; el
  trío `.BKS` (banco, hasta 117 MB) + `.SSH` (cabeceras) + `.SLB` (índice)
  parece ser un solo sistema. Sin verificar.

## Estado de la máquina

- **Fuera del repo:** `C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC`
  (extensión EE en `Ghidra\Extensions\ghidra-emotionengine-reloaded`),
  `...\vgmstream\vgmstream-cli.exe`, `...\SLUS_213.76` (copia del ELF),
  proyecto Ghidra en `...\ghidra-proyectos2\BLACK` — **y ahora también
  `/SLUS_213.76_estado`, la copia con la RAM viva encima**.
  `ghidra-proyectos` (sin el 2) tiene el análisis MALO de MIPS R6: no usarlo.
- **Autorización vigente de Fran:** instalar lo que haga falta sin preguntar.
- PCSX2 2.6.3, PINE en 28011. **ISO montado en `D:`.**
- **Parche vivo en memoria** (se pierde al recargar): `0x0013BD20` en nop =
  **vida infinita del jugador PUESTA**. Todo lo demás restaurado.
- Savestates en `C:\Users\frans\OneDrive\Documents\PCSX2\sstates\`. El del
  punto de trabajo es el **slot 6**.

## Problemas abiertos

- **ONEDRIVE.** `Escritorio`, `Documentos` e `Imágenes` siguen redirigidos a
  `C:\Users\frans\OneDrive\`. El proceso de OneDrive **no está corriendo**, así
  que el riesgo está dormido, pero el data dir de PCSX2 (savestates de 32 MB
  sin comprimir) vive adentro y es **sospechoso principal de las dos muertes
  de PCSX2 del 2026-08-15**. El repo sí está afuera y así tiene que quedar.
  Script listo y sin correr: `herramientas/windows/sacar-de-onedrive.ps1`.
  **Esto va en su propia sesión, no al final de una larga.**
- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`**, que está
  trackeado. Restaurarlo con `git checkout -- black/construido/.gitkeep`.
- `armas.py`, `zonas.py`, `tablas.py`, `firmas.py` e `inventario.py` no tienen
  test en `pruebas/`.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: índice de render, crashea.
- No escribir en `0x0042Cxxx`: zona de HUD, ensucia la pantalla.
- **Nunca editar el ISO original.** 3,9 GB por copia; hay 165 GB libres.
