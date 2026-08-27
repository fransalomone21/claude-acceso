# Herramientas externas — el instrumental que no escribimos nosotros

Qué se adoptó, con qué versión exacta, cómo se monta y —sobre todo— **cómo se
verifica que funciona**. Levantado el 2026-08-16, reescrito el 2026-08-16
después del barrido de instrumental.

Las herramientas de `black/herramientas/` son nuestras y se prueban con
`pruebas/prueba_herramientas.py`. Éstas son de terceros: el riesgo no es que
tengan bugs, es que **funcionen mal en silencio**. Cada una de acá abajo lleva
su control positivo, que es un caso cuya respuesta ya conocemos por otra vía.

---

## REGLA NUEVA: el inventario se corre, no se lee

```powershell
python herramientas/inventario.py
```

**Antes de decir que algo "no está instalado", se corre esto.** No alcanza con
leer este documento.

El 2026-08-16 Fran señaló un error de proceso real: `PCSX2-MCP` estaba bajado y
descomprimido en `Descargas` desde el 2026-08-15 y varias sesiones seguidas lo
dieron por ausente, porque el repo decía que no se había instalado. **El repo
es la memoria del proyecto, no la de la máquina.** Un documento no puede
enterarse de que apareció una carpeta nueva en Descargas.

`inventario.py` mira la máquina de verdad y contesta cuatro cosas:

1. qué instrumental está presente, con versión y ruta;
2. **qué está BAJADO PERO SIN INCORPORAR** — la categoría que se nos escapó;
3. qué falta del runbook de este documento;
4. qué carpetas del proyecto siguen adentro de OneDrive.

---

## Estado de instalación — verificado 2026-08-16

| Herramienta | Estado | Dónde |
|---|---|---|
| Ghidra 12.1.2 | instalado | `C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC` |
| extensión EE Reloaded v2.1.36 | instalado | `…\Ghidra\Extensions\ghidra-emotionengine-reloaded` |
| pyghidra 3.1.0 | instalado | pip |
| capstone 5.0.9 | instalado | pip |
| numpy 2.5.2 | instalado | pip |
| **pycdlib 1.20.0** | **instalado 2026-08-16** | pip |
| **ImHex 1.38.1** | **instalado 2026-08-16** | winget `WerWolv.ImHex` |
| **ffmpeg 9.0** | ya estaba | winget `Gyan.FFmpeg` |
| **zstandard** | **instalado 2026-08-16** | pip |
| **kaitaistruct** | **instalado 2026-08-16** | pip |
| vgmstream r2117 | instalado | `C:\Users\frans\herramientas\vgmstream\vgmstream-cli.exe` |
| copia del ELF | presente | `C:\Users\frans\herramientas\SLUS_213.76` |
| proyecto Ghidra analizado | presente | `C:\Users\frans\herramientas\ghidra-proyectos2\BLACK` |

**Trampa de winget con ImHex:** `--scope user` falla con
`No applicable installer found` y sale con código 16. El paquete trae un
instalador **wix (MSI) de máquina**, no de usuario. Va sin `--scope`.

---

## Ghidra 12.1.2 + Emotion Engine Reloaded — decompilar el ELF

**Lo más importante que se sumó al proyecto.** `mips.py` y `capstone`
desensamblan; Ghidra **decompila**: devuelve C con variables, control de flujo
y llamadas resueltas. La diferencia práctica es leer treinta líneas en vez de
514 instrucciones.

### Qué se instaló

| Pieza | Versión | De dónde |
|---|---|---|
| Ghidra | **12.1.2** (`ghidra_12.1.2_PUBLIC_20260605.zip`, 546 MB) | [releases de la NSA](https://github.com/NationalSecurityAgency/ghidra/releases) |
| Extensión PS2 | **v2.1.36**, asset `ghidra_12.1.2_PUBLIC_20260607_...zip` | [chaoticgd/ghidra-emotionengine-reloaded](https://github.com/chaoticgd/ghidra-emotionengine-reloaded) |
| Puente a Python | `pyghidra` 3.1.0 (`pip install pyghidra`) | PyPI |
| Java | 21.0.7 (ya estaba) | — |

**La versión de la extensión tiene que coincidir con la de Ghidra.** El
release trae un zip por versión de Ghidra; agarrar el que no es no da error,
da comportamiento raro.

### Montaje

```powershell
# 1. Ghidra
tar -xf ghidra_12.1.2_PUBLIC_20260605.zip -C C:\Users\<vos>\herramientas

# 2. La extensión — OJO CON LA CARPETA
tar -xf ghidra_12.1.2_PUBLIC_20260607_ghidra-emotionengine-reloaded.zip `
    -C C:\Users\<vos>\herramientas\ghidra_12.1.2_PUBLIC\Ghidra\Extensions

# 3. El puente
python -m pip install pyghidra

# 4. Importar y analizar. EL -processor NO ES OPCIONAL.
& C:\Users\<vos>\herramientas\ghidra_12.1.2_PUBLIC\support\analyzeHeadless.bat `
    C:\Users\<vos>\herramientas\ghidra-proyectos2 BLACK `
    -import C:\Users\<vos>\herramientas\SLUS_213.76 `
    -processor "r5900:LE:32:default" -analysisTimeoutPerFile 3600
```

Tarda ~150 s. No hace falta abrir la GUI ni tener permisos de administrador.

### Las dos trampas, que se pagaron las dos

**1. `Ghidra\Extensions\`, no `Extensions\Ghidra\`.** Las dos carpetas
existen. La segunda guarda los zips distribuibles de las extensiones de
ejemplo; Ghidra **no la carga**. Descomprimir ahí deja la extensión
"instalada" y no disponible — lección 7.

El verificador correcto no es "¿existe el archivo?" sino "¿aparece el
lenguaje?":

```powershell
python herramientas/decompilar.py info    # tiene que decir r5900:LE:32:default
```

**2. Sin `-processor`, Ghidra elige mal y dice que salió bien.** La
autodetección desde el ELF da `MIPS:LE:64:64-32R6addr` — MIPS Release 6, otra
ISA. Y el resultado es:

```
INFO REPORT: Analysis succeeded for file: .../SLUS_213.76
```

...con **1 función** en 2,6 MB de `.text`, cero decompilación, y una lluvia de
`ERROR Pcode error ... Program does not contain referenced instruction` que
parece ruido y es el síntoma. Con `-processor "r5900:LE:32:default"`:
**9842 funciones y 16514 símbolos**.

Es lección 14 con otra cara: la herramienta eligió sola un parámetro crítico,
la elección era una hipótesis suya, y reportó éxito igual.

### El control positivo

`decompilar.py info` lo corre solo. Decompila **`0x00142B90`**, que es la
rutina de daño por zona de impacto, y busca el `100.0`. Sabemos que está
—Fase 4b, confirmada por efecto en pantalla— así que si no aparece, lo que
está roto es Ghidra y no el juego.

```
=== CONTROL POSITIVO sobre 0x00142B90 ===
función    : FUN_00142b90 @ 0x00142B90
el 100.0 aparece en la decompilación: SI -> BIEN
```

### Qué aportó de entrada

- El mapa de memoria del EE completo: `.text`/`.data`/`.rodata`/`.lit4`/
  `.sdata`/`.sbss`/`.bss` **más** `vu0.code`, `vu0.data`, `vu1.code`,
  `vu1.data`, `scratchpad` (`0x70000000`), `registers.gs`, `iop_ram`. Coincide
  exactamente con la tabla de secciones que ya habíamos leído a mano: son dos
  fuentes independientes diciendo lo mismo.
- Resuelve los accesos por `$gp` que `xref.py` no ve (aparecen como
  `uGpffff81ac` y compañía).
- 16514 símbolos donde el ELF no trae **ninguno**.

---

## La RAM viva adentro del decompilador — `decompilar.py estado`

La extensión trae `PCSX2SaveStateImporter.java`, un script de GUI que carga un
savestate de PCSX2 en los bloques de memoria del programa. **Estuvo instalado
y sin usar varias sesiones.** Ahora está envuelto en la CLI del proyecto, sin
GUI y con control positivo propio:

```powershell
python herramientas/decompilar.py estado --savestate "...\SLUS-21376 (5C891FF1).06.p2s"
python herramientas/decompilar.py c 0x00142B90 --estado
```

**Qué destraba.** El ELF estático tiene `.bss` en cero y el heap directamente
no existe. Con el savestate encima, el decompilador ve los valores reales de
los 561 globales por `$gp`, y **los 31,5 MB de heap quedan como un bloque
`.other` navegable**: la tabla de armas, la tabla de zonas y el pool de
enemigos dejan de ser offsets en un `.bin` y pasan a ser memoria con
referencias cruzadas y tipos.

**Nunca toca el programa limpio.** Copia `/SLUS_213.76` a
`/SLUS_213.76_estado` y trabaja sobre la copia, así el control positivo de
`info` sigue corriendo contra el ELF tal como salió del ISO.

### Tres cosas que costaron, anotadas

1. **El paquete Java `ghidra` no existe hasta que arranca la JVM.** Un
   `from ghidra.util.task import ConsoleTaskMonitor` arriba del archivo, o
   antes de `pyghidra.start()`, da `ModuleNotFoundError: No module named
   'ghidra'` y parece que falta la instalación. Los imports de Java van
   **adentro** de la función, después de abrir el proyecto.
2. **`DomainFolder.createFile` no tiene overload para `DomainFile`.** Sus dos
   firmas son `(String, DomainObject, TaskMonitor)` y
   `(String, java.io.File, TaskMonitor)`. Para duplicar un programa del
   proyecto va `DomainFile.copyTo(carpeta, monitor)` y después `setName`.
3. **El script de la extensión no filtra por espacio de direcciones.** Los
   pseudo-bloques del ELF (`_elfHeader`, `_elfSectionHeaders`) arrancan todos
   en `0x00000000` y entrarían al reemplazo. Nuestra versión sólo toca bloques
   del espacio por defecto, y saltea el bloque que se pase del final del
   buffer.

### El control positivo

Dos hechos de la Fase 2, confirmados por efecto, que **viven en el heap** — o
sea que no pueden dar bien si el savestate no se cargó, o se cargó corrido:

```
jugador+0x10 = 0x003DC5F8   (el puntero de clase del jugador)
vida 0x005A8DA8             (f32 plausible, 0 < v <= 1200)
```

Si alguno falla, **no guarda la copia**. Un importador que carga mal en
silencio es peor que uno que no carga.

---

## vgmstream r2117 — abrir los `.AWD`

Es el parser certificado de audio de videojuegos, y trae soporte de
**`RenderWare AWD header`** de fábrica. Con eso, uno de los formatos opacos
del ISO dejó de serlo sin escribir una línea de parser.

```powershell
# vgmstream-win64.zip de https://github.com/vgmstream/vgmstream/releases
tar -xf vgmstream.zip -C C:\Users\<vos>\herramientas\vgmstream
python herramientas/awd.py listar "D:/LEVELS/LEVEL_01/STG_0001/AIWPNS.AWD"
```

**Control positivo:** `AIWPNS.AWD` del nivel 1 tiene que devolver 29 streams
con nombres legibles. Si devuelve streams sin nombre (`1`, `2`, `3`…) el
archivo no tiene tabla de nombres — que es lo que pasa con `PAUDIO.AWD`, y es
un resultado honesto, no una falla.

Qué **no** abre: `.SSH`, `.BKS`, `.SLB`, `.WDD`, `.DB`. Devuelve
`failed opening` limpio. Ver `05-iso.md`.

---

## ImHex 1.38.1 — el editor hexadecimal con lenguaje de patrones

Para lo que queda opaco: `.WDD`, `.DB`, `.BKS`, `.SSH`, `.SLB`. Permite
escribir el layout como un patrón y verlo aplicado sobre el archivo, que es
mucho más rápido que iterar con scripts de Python.

**Primer trabajo concreto, ya definido:** escribir el patrón del contenedor
`.BIN` ya resuelto (ver `05-iso.md`) y aplicarlo a `GLOBDATA.BIN` para
etiquetar las seis secciones de una. El patrón se guarda en el repo, en
`patrones/`, no en la carpeta de ImHex — si no está commiteado, no existe.

---

## El frente RenderWare — barrido del 2026-08-16

BLACK corre sobre **RenderWare**, de la propia Criterion. Eso significa que
buena parte de lo que queda opaco (`.WDD`, `.DB`, y probablemente los modelos)
**no es un formato de BLACK: es un formato de RenderWare**, y RenderWare está
documentado y tiene herramientas hechas por la comunidad de GTA desde hace
veinte años.

Es el cambio de encuadre más útil que salió del barrido: dejamos de buscar
"herramientas para BLACK" —que no existen— y pasamos a buscar "herramientas
para RenderWare", que sobran.

### Lo que hay, en orden de valor

| Herramienta | Qué es | Dónde |
|---|---|---|
| **RenderWare SDK 3.10 PS2** | el SDK original de Criterion, con headers y docs. **La fuente de verdad de los formatos.** | [archive.org/details/rw310-ps2](https://archive.org/details/rw-310-ps2) |
| **RenderWare Engine v36** | otra copia del engine, versión 3.6 | [archive.org/details/rw-36-031126](https://archive.org/details/rw-36-031126) |
| **RW Analyze 0.4** | visor **y editor** de RW binary streams: jerarquía de chunks, hex, exportar/importar secciones | [steve-m.com](http://steve-m.com/downloads/tools/rwanalyze/) · [GTAForums](https://gtaforums.com/topic/128451-reltool-rw-analyze/) |
| **Magic.TXD** | editor universal de texture dictionaries, **soporta PS2** | [ps2-home](https://www.ps2-home.com/forum/viewtopic.php?t=1060) |
| **RWview** | visor de jerarquía RW por consola — scriptable, que es lo que nos sirve | [misternebula/RWview](https://github.com/misternebula/RWview) |
| **rw-parser / rw-parser-ng** | parsers de RW binary stream en TypeScript, código legible | [Timic3/rw-parser](https://github.com/Timic3/rw-parser) · [DepsCian/rw-parser-ng](https://github.com/DepsCian/rw-parser-ng) |
| **rwsreader** | lector de RenderWare 3.7 Binary Stream | [sourceforge](https://rwsreader.sourceforge.net/) |
| **Heavy Iron Modding wiki** | la mejor referencia abierta del formato RW | [heavyironmodding.org/wiki/RenderWare](https://heavyironmodding.org/wiki/RenderWare) |

**La hipótesis barata que sale de acá, y que hay que matar primero:** un RW
binary stream arranca con una cabecera de chunk de 12 bytes —tipo (u32),
tamaño (u32), versión (u32)—. Los `.WDD` de `FPGUNS/` miden **65536 bytes
exactos**, que es sospechoso de "búfer de tamaño fijo", no de stream. Leer los
primeros 12 bytes de uno y ver si el tipo cae en la tabla de chunks conocida
(`0x16` = TXD/texture dictionary, `0x10` = clump/DFF) decide el camino en un
minuto. Está pendiente.

---

## ISO de PS2 — el hallazgo que decide el mod permanente

| Herramienta | Qué hace | Dónde |
|---|---|---|
| **pycdlib** (instalado) | leer/escribir ISO9660 desde Python | pip |
| **mkps2iso** | constructor **y dumper** de imágenes UDF de PS2. El hermano PS2 de mkpsxiso | [N4gtan/mkps2iso](https://github.com/N4gtan/mkps2iso) |
| **mkpsxiso / dumpsxiso** | el de PSX. Documenta la estructura a XML y reconstruye | [Lameguy64/mkpsxiso](https://github.com/lameguy64/mkpsxiso) |
| **isodump** | extracción + layout XML | [Lameguy64/isodump](https://github.com/Lameguy64/isodump) |

**El hallazgo que importa, y que confirma lo que ya intuíamos:** reconstruir un
ISO **reasigna los LBA de los archivos**, aunque no cambie ningún contenido. Y
en la era PS2 era práctica corriente que el ejecutable llevara **LBAs
hardcodeados** en vez de leer la TOC de ISO9660. O sea: un ISO reconstruido
puede arrancar y fallar más tarde, en un nivel cualquiera, sin decir por qué.

**Conclusión operativa: el parche in-place es el camino, y no por comodidad.**
Los `Power` de la tabla de armas son f32 de 4 bytes: el archivo no cambia de
tamaño, el layout no se toca, los LBA quedan donde estaban. Reconstruir con
`mkps2iso` es el plan B, y sólo si el in-place resulta imposible.

**Test barato pendiente, y es el que decide todo:** buscar en el ELF si hay
LBAs hardcodeados. Si los hay, reconstruir queda descartado formalmente y se
anota como callejón cerrado antes de entrar.

---

## Lo que se evaluó y se DESCARTÓ

Está acá para que nadie lo vuelva a investigar.

### El hilo de ResHax — verificado de nuevo el 2026-08-16

[ResHax #514](https://reshax.com/topic/514-black-ps2xbox-bin-db/) sigue siendo
el único lugar donde se habla del tema, y **sigue sin tener una sola línea
técnica**: ni cabeceras, ni offsets, ni magic bytes, ni scripts, ni plugins.

Lo que sí aporta, y es nuevo para nosotros:

- **h3x3r** (2024-02-20) dice haberlo reverseado hace años y **que la versión
  de Xbox es más fácil**. No publicó nada.
- **shak-otay** (2024-04-25) confirma lo de Xbox y muestra un modelo convertido
  (`Unit_02.bin`). Tampoco publicó método.
- Cuatro usuarios distintos pidieron importadores entre abril y agosto de 2024.
  Nadie contestó con nada técnico.

**Dato accionable:** dos personas independientes dicen que **la versión de
Xbox del mismo juego tiene formatos más simples**. Si los `.BIN` de geometría
se traban, comparar contra el build de Xbox es una entrada barata — el
contenido es el mismo juego, y las diferencias de empaquetado suelen delatar
la estructura. Es hipótesis de terceros, sin verificar.

**Confirmado: el formato de los `.BIN` de BLACK es nuestro para resolver.** Y
se resolvió leyendo el parser con Ghidra — ver `05-iso.md`.

### PCSX2-MCP (`hkmodd/PCSX2-MCP`) — bajado por Fran, pendiente de que él lo corra

Promete 30 herramientas de depuración por MCP: breakpoints, registros de 128
bits, desensamblado, watchpoints, call stacks.

**Estado real al 2026-08-16** (lo dice `inventario.py`, no este documento):

```
C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\      (descomprimido)
C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64.zip   (54,9 MB)
C:\Users\frans\Downloads\node-v24.19.0-x64.msi        (Node, que hace falta)
```

Trae `pcsx2-qt.exe` (12,9 MB), `setup-mcp.bat` y `pcsx2-mcp-server/` con su
`node_modules` ya poblado. **Fran lo bajó el 2026-08-15 y las sesiones
siguientes no lo miraron** — ese es el error que originó `inventario.py`.

**Lo que falta, y lo hace Fran, no la sesión:** correr `setup-mcp.bat` y
arrancar ese `pcsx2-qt.exe`. Es un ejecutable **sin firmar** que reemplaza al
emulador entero; bajarlo y ejecutarlo es una decisión del usuario, con el
riesgo a la vista. Una vez que él lo corre, la sesión lo usa sin problema.

Y hay un antecedente que pesa: ya está documentado que el servidor de
depuración del **PCSX2 oficial** corrompe el heap (`DebugServer.cpp` muta
`CBreakPoints` desde el hilo del socket sin mutex) y que los breakpoints de
ejecución matan el proceso. Un fork no auditado de esa misma capa no es la
forma de arreglarlo.

**Lo que ya lo reemplaza en gran parte:** `decompilar.py estado`, arriba. La
RAM viva adentro de Ghidra, con las 9842 funciones y el decompilador encima,
es mejor que un lector de memoria por MCP para todo lo que sea análisis.

### mcp-pine (`dmang-dev/mcp-pine`) — descartado por redundante

MCP que habla PINE con PCSX2 y RPCS3. Limpio, no necesita build modificado,
se instala con `claude mcp add pine --scope user mcp-pine` (Node 22+).

Expone lectura/escritura de memoria de 8/16/32/64 bits, lectura por rango, y
savestates. **`herramientas/pine.py` ya hace todo eso** y además vuelca los 32
MB en ~3 s, que es la operación que este proyecto usa de verdad. Sumarlo no
destraba nada.

Queda anotado como alternativa si alguna vez hace falta manejar PCSX2 desde
un cliente que no sea Claude Code.

### QuickBMS y Noesis — no hay script para BLACK

Se buscó script `.bms` o plugin de Noesis. **No existe público**, reverificado
el 2026-08-16. Prioridad baja y encuadre cambiado: lo que hay que probar no es
"un script de BLACK" sino **los plugins de RenderWare**, que es la sección de
arriba.

---

## Bases de datos de códigos — evidencia de terceros, gratis

`gamehacking.org` y `supercheats` devuelven 403 a un fetch directo, pero los
códigos son públicos y verificables. Los que se recuperaron para
`SLUS-21376` / CRC `5C891FF1` cruzan con lo nuestro:

| Código publicado | Traducción | Qué confirma |
|---|---|---|
| `205A8DA8 44960000` | escribir `1200.0` f32 en `0x005A8DA8` | **la vida del jugador**, que teníamos confirmada por efecto. Confirmación independiente. Y fija el "lleno" en 1200.0 |
| `2015515C 240303E7` | `addiu $v1, $zero, 999` en `0x0015515C` | hay lógica de **munición** ahí |
| `2015787C 00000000` | `nop` en `0x0015787C` | hay lógica de **recarga** ahí |
| `205A8A9C 3C888889` | `0.0166667` f32 = 1/60 en `0x005A8A9C` | **delta de tiempo por frame**, global, a `-0x14` del objeto del jugador |
| `1040DF74 00000002` | u16 = 2 en `0x0040DF74` | está en `.sdata`: coherente con que ahí viven los globales chicos |

Son **hipótesis fuertes de terceros**, no hallazgos nuestros: nadie de este
proyecto los verificó por efecto todavía. Van a `kb/` con esa etiqueta.

Aviso: los códigos de Action Replay MAX vienen cifrados y necesitan
`omniconvert` para pasarlos a crudo. Los de arriba ya están en crudo (formato
`.pnach`, que es el que usa PCSX2).
