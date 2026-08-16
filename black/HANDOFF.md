# Handoff — arrancar el chat que sigue

Copiá el bloque de abajo como primer mensaje del chat nuevo.

```
Proyecto BLACK, rama claude/black-game-reverse-engineering-ricv3t.
Working dir: C:\Users\frans\Desktop\claude-acceso

Leé en este orden y NADA más:
  black/CLAUDE.md
  black/ESTADO_ACTUAL.md                     (entero, es corto)
  black/HANDOFF.md                           (entero)
  black/docs/05-iso.md                       (el ISO es la fase)
No leas la bitácora ni 06-herramientas-externas.md salvo que algo no cierre:
el instrumental está todo instalado y verificado.

FASE 6 — exprimir el ISO hasta la última gota, ANTES de volver al emulador.
Cierra cuando (a) esté decidido con evidencia si el ELF tiene LBAs
hardcodeados, y (b) al menos dos de las tres familias opacas (.DB, .WDD,
.SLB) tengan su layout escrito en docs/05-iso.md con un control positivo.
Modelo: OPUS. Es formato nuevo y desensamblado del cargador, territorio sin
mapear. No es ejecutar un runbook.

PRIMER COMANDO, control positivo del entorno (los dos tienen que dar bien):
    python herramientas/inventario.py
    python herramientas/decompilar.py info

ESTADO DE LA MÁQUINA (no está en el repo, se pierde si no lo leés acá):
- Ghidra 12.1.2 en C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC
  con la extensión EE en Ghidra\Extensions\ghidra-emotionengine-reloaded
- Proyecto analizado (9842 funciones) en
  C:\Users\frans\herramientas\ghidra-proyectos2\BLACK
  Dos programas adentro: /SLUS_213.76 (limpio) y /SLUS_213.76_estado
  (con la RAM viva del slot 6 encima, 28,7 MB de heap en el bloque .other).
  OJO: ghidra-proyectos SIN el 2 tiene el análisis MALO de MIPS R6. No usarlo.
- vgmstream en C:\Users\frans\herramientas\vgmstream\vgmstream-cli.exe
- pip: pyghidra, capstone, numpy, pycdlib, zstandard, kaitaistruct
- ImHex 1.38.1 y ffmpeg 9.0 por winget
- ISO montado en D:. Original en
  "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"
- Savestates en C:\Users\frans\OneDrive\Documents\PCSX2\sstates\ (slot 6 es
  el punto de trabajo). SIN COMPRIMIR: no hace falta zstandard, pero está.
- PCSX2 2.6.3, PINE en 28011. Parche vivo en memoria: 0x0013BD20 en nop =
  vida infinita del jugador PUESTA. Se pierde al recargar. Resto restaurado.
- PCSX2-MCP está BAJADO en C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\
  descomprimido, con setup-mcp.bat. Lo corre Fran, no la sesión.

NO REHACER — está confirmado por efecto:
  vida del jugador 0x005A8DA8 · daño al jugador 0x0013BD20 · daño al enemigo
  0x00134654 · clase en objeto+0x10 · tabla de armas 17 x 0x1E0 con Power en
  bloque+0x18 · daño de salida = zona * 100.0 en 0x00142B90, escala en
  0x00142CA0 · contenedor .BIN resuelto (relocaliza, no parsea).
Los callejones cerrados están en ESTADO_ACTUAL.md: leelos ANTES de investigar.

ARRANCÁ POR ACÁ, en este orden:
1. Tarea 6.1 — ¿el ELF tiene LBAs hardcodeados? Decide todo el camino de
   escritura. Si los hay, "reconstruir el ISO" queda cerrado formalmente y
   sólo vale el parche in-place.
2. Tarea 6.2 — los 139 .DB: byte 0 = 0x00 y bytes 6-7 = "FT" en 139/139.
   Entrada buena: xref de la cadena ".DB" en el ELF y decompilar su callback,
   que es exactamente como cayó el contenedor .BIN.
3. Tarea 6.6 — parche in-place de GLOBDATA.BIN + 0x00130E20 sobre una COPIA
   del ISO. NUNCA el original.

PARQUEADO A PROPÓSITO: la Fase 5a (pnach sobre 0x00142CA0, lui $at,0x42C8 =
100.0 -> 0x4396 = 300.0). Está lista para hacerse en media hora cuando Fran
quiera volver al emulador. No se perdió nada.
```

**No pegues el chat anterior.** El `kb/`, `ESTADO_ACTUAL.md` y la bitácora son
la memoria; el historial no hace falta y cuesta diez veces más.

---

## Las tres líneas, ya resueltas para el chat nuevo

**Fase** — **6, exprimir el ISO.** Cierra con el criterio de arriba: la
decisión sobre LBAs con evidencia, y dos de las tres familias opacas con
layout escrito y control positivo.

**Modelo** — **Opus.** Es formato nuevo y lectura del cargador en C. La Fase 5a
era Sonnet porque no había nada que descubrir; ésta es al revés.

**Contexto** — chat nuevo. La Fase 6 arranca leyendo decompilación, que es lo
que más come, y no necesita nada de lo hablado en la sesión de instrumental.

---

## Fase 6 — el método que ya funcionó dos veces

**No mirar bytes. Leer el cargador.** El contenedor `.BIN` estuvo días anotado
como "falta entender" y cayó en una tarde decompilando `0x00105D48`. La receta,
tal cual:

1. `xref.py` o `decompilar.py xref` sobre la **cadena de la ruta o la
   extensión** en `.rodata`.
2. Subir al llamador hasta encontrar el callback que registra el formato.
3. `decompilar.py c <dir>` y leerlo en C.
4. Control positivo con un dato que ya se conoce por otra vía.

**Y ahora hay una palanca nueva:** `--estado`. El heap vivo está adentro de
Ghidra, así que se puede decompilar el cargador **y mirar al mismo tiempo la
estructura que armó en memoria**. Eso no se tenía antes.

## Lo que se sabe de las familias opacas

| Familia | N | Tamaños | Firma (medida con `firmas.py`) |
|---|---|---|---|
| `.SLB` | 9 | 720 B – 23 KB | `01 00 00 00` + **`"KING"`** + `00 00 00 00`, los 12 bytes constantes |
| `.WDD` | 141 | **16384 / 65536 exactos** | **byte 1 = `0x02`** en 141/141; byte 0 varía (19 valores) |
| `.DB` | 139 | 504–725 KB | **byte 0 = `0x00`, bytes 6-7 = `"FT"`** en 139/139 |

**Ninguno es un RenderWare binary stream plano** — 0/141, 0/139, 0/9. Los
formatos son contenedores de Criterion. Puede haber streams RW adentro.

Entradas baratas, en orden:

1. **`"KING"` es una magia buscable.** Nueve archivos y doce bytes constantes.
   Es el mejor punto de entrada del trío de audio `.BKS` + `.SSH` + `.SLB`.
2. **`.WDD` de 16384 y 65536 exactos = búfer de tamaño fijo, no stream.**
   `GRDPIN.WDD` es `0C 02 00 00` y después todo ceros: un slot vacío. El
   byte 0 es el candidato a "tipo" y el byte 1 (`0x02` siempre) a "versión".
3. **`.DB` pesa 500–725 KB y hay 139**: es el grueso del contenido. Vale más
   que los otros dos juntos.

## Herramientas nuevas de esta sesión

- **`herramientas/inventario.py`** — qué instrumental hay en LA MÁQUINA, qué
  está **bajado y sin incorporar**, y qué carpetas siguen en OneDrive.
  **Se corre al abrir la sesión, antes de decir que algo falta.**
- **`herramientas/firmas.py`** — firmas de cabecera por familia de archivos,
  buscando **por posición de byte** (un u32 en little-endian esconde la
  constante). De acá salieron las tres firmas de arriba.
- **`herramientas/decompilar.py estado`** — la RAM viva de un savestate
  adentro de Ghidra, sobre una **copia** del programa. Ver `06-herramientas`.
- **`herramientas/windows/sacar-de-onedrive.ps1`** — listo y **sin correr**.
  Modo en seco por defecto. Va en su propia sesión.

## Trampas que ya se pagaron

- **El paquete Java `ghidra` no existe hasta que arranca la JVM.** Importarlo
  antes de `pyghidra.start()` da `ModuleNotFoundError` y parece que falta la
  instalación. Los imports de Java van adentro de la función.
- **`DomainFolder.createFile` no acepta un `DomainFile`.** Para duplicar un
  programa va `DomainFile.copyTo(carpeta, monitor)` y después `setName`.
- **winget + ImHex:** `--scope user` da `No applicable installer found` y
  código 16. El paquete trae MSI de máquina. Va sin `--scope`.
- **`lw $a0, 0x3c($a1)` es una CARGA, no `a1+0x3C`.** Comerse una indirección
  da tablas de ceros que parecen un hallazgo.
- **Un "NADA" de `xref.py absoluto` no prueba nada si el `--radio` es chico.**
  Ya está en 16; el reflejo tiene que ser subirlo antes de creerle a un negativo.
- **561 globales se direccionan por `$gp` (`0x004157F0`)** y ninguna aparece
  buscando `lui`+`addiu`.
- **Buscar una estructura por ventana de bytes crudos contra un archivo del
  ISO da falsos negativos.** Se busca por firma **estructural**.
- `capstone` necesita `CS_MODE_MIPS64 + skipdata=True`.
- **No llamar `dis.py` ni `ghidra.py` a un script**: tapan módulos reales.
- **Los breakpoints de EJECUCIÓN crashean PCSX2**; los watchpoints no.
- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`.** Restaurarlo
  con `git checkout -- black/construido/.gitkeep` antes de commitear.

## Deuda conocida

- `armas.py`, `zonas.py`, `tablas.py`, `firmas.py` e `inventario.py` sin test.
- No se validó `windows/preparar_entorno.ps1` de punta a punta.
- OneDrive sigue teniendo Escritorio, Documentos e Imágenes. Script listo.
