# Bitácora

Registro del proyecto. **Lo nuevo va arriba.** Al retomar, alcanza con leer las
dos primeras entradas.

Formato de cada entrada:

```
## AAAA-MM-DD — título corto
**Máquina:** PC / notebook / nube · **Modelo:** Opus / Sonnet / Haiku
**Objetivo:** qué se venía a hacer
**Resultado:** qué se logró
**No funcionó:** los callejones sin salida. Esta parte no es opcional.
**Sigue:** el próximo paso concreto
```

---

## 2026-08-14 (2) — Automatización del checkpoint 0 en Windows

**Máquina:** nube (sin PCSX2) · **Modelo:** Sonnet

**Objetivo:** que el checkpoint 0 (entorno + confirmar identidad del juego)
se pueda correr con un solo comando en Windows, con UAC, sin que el usuario
tenga que tocar el `.ini` de PCSX2 a mano.

**Resultado:**

- `herramientas/fijar_objetivo.py`: conecta por PINE, compara el serial/CRC
  observado contra `kb/objetivo.json` y lo actualiza solo (marca
  `confirmada`, fija `version_activa`, o crea la entrada si el serial es
  nuevo). La lógica de decisión (`aplicar_info`) es una función pura, sin
  tocar disco ni red — 13 comprobaciones nuevas en
  `pruebas/prueba_herramientas.py` (total: 77), incluyendo el caso de CRC
  que no coincide con el anotado.
- `herramientas/windows/preparar_entorno.ps1`: se re-lanza pidiendo UAC,
  detecta Python 3.11+ e instala numpy, corre la batería de pruebas, busca
  PCSX2 (por atajo del escritorio/inicio o por carpetas típicas), le activa
  PINE y le apaga la compresión de savestates en el `.ini` —con backup
  automático antes de tocarlo—, abre PCSX2 si hace falta, espera a que PINE
  conteste y corre `fijar_objetivo.py` al final. Todo queda en un log bajo
  `volcados/`.

**Verificación hecha (sin tener Windows a mano):**

- Claves reales del `.ini` de PCSX2 confirmadas contra el código fuente
  (`Pcsx2Config.cpp`) y un `.ini` real de ejemplo: sección `[EmuCore]`,
  `EnablePINE`, `PINESlot` (default 28011), `SavestateZstdCompression`,
  formato `Clave = Valor` con espacios.
- Confirmado contra `PINE.cpp` que `MsgID` devuelve el serial y `MsgUUID`
  devuelve el CRC en minúsculas — importante porque `fijar_objetivo.py`
  depende de esa asignación para no cruzar los campos.
- Sintaxis del `.ps1` validada con el parser real de PowerShell (instalé
  `pwsh` portátil para esto, 0 errores).
- La función `Set-ValorIni` (la que edita el `.ini` línea por línea) se
  probó de verdad —no sólo se leyó— con 21 casos: reemplazo, inserción,
  sección nueva, límites del array (sección al final, clave al final,
  archivo de una sola línea), y que `PINESlot` no se confunda con
  `EnablePINE` por ser substring. Encontré y arreglé ahí un bug real de
  `$Matches` que podía arrastrar el resultado de una iteración anterior del
  loop de detección de Python, y dos bloques de escritura de archivo sin
  `try/catch` que hubieran tirado el script entero sin aviso limpio ante un
  permiso denegado o un archivo bloqueado.
- Lo que **no** se pudo probar, porque no hay Windows ni PCSX2 en esta
  sesión: el flujo completo de punta a punta, la búsqueda real de PCSX2 por
  atajos/carpetas, y si el script realmente dispara el diálogo de UAC como
  se espera.

**No funcionó / limitación conocida:**

- No hay forma de ejecutar `preparar_entorno.ps1` de punta a punta desde acá.
  Toda la confianza viene de verificar cada pieza por separado (fuente de
  PCSX2, parser de sintaxis, ejecución real de la función de edición del
  ini) — no de una corrida completa. Si algo falla al usarlo, es información
  valiosa para la próxima entrada de esta bitácora.

**Sigue:** correr `preparar_entorno.ps1` en la notebook y reportar qué pasó.
Si algo se traba, mejor pegar el contenido de
`volcados/diagnostico-entorno-*.txt` que una descripción de memoria.

---

## 2026-08-14 — Armado del proyecto

**Máquina:** nube (sin acceso a PCSX2) · **Modelo:** Opus

**Objetivo:** montar la arquitectura del proyecto: herramientas, base de
conocimiento, documentación y plan, para que el trabajo sea portable entre la
PC y la notebook.

**Resultado:**

- Instrumental completo en `herramientas/`, con pruebas: `pine.py` (cliente
  PINE), `estado.py` (savestates), `escanear.py` (escaneo diferencial),
  `inspeccionar.py` (estructuras), `vigilar.py` (series temporales),
  `mips.py` (ensamblador R5900), `pnach.py` (compilador de mods).
- Base de conocimiento en `kb/`, con campos de confianza y evidencia
  obligatorios.
- Documentación: entorno, metodología (la "escalera" de 5 escalones), plan por
  fases, glosario del EE.
- `pruebas/prueba_herramientas.py`: 65 comprobaciones, todas en verde, sin
  necesitar PCSX2. Se probaron los dos caminos, con numpy y sin numpy.
- Verificado end-to-end contra RAM sintética de 32 MB con ruido realista
  (200.000 palabras cambiando entre fotos): el escaneo por "bajó" va de
  8.126.464 posiciones a 98.256 y después a 1, en 2,2 segundos.

**Datos técnicos confirmados contra las fuentes** (no de memoria):

- Protocolo PINE, contra `pcsx2/PINE.cpp`: marco de 4 bytes little-endian que
  se incluye a sí mismo; comandos encadenables; **un solo** código de resultado
  por respuesta; lectura = 1 byte de opcode + 4 de dirección.
- Formato `.pnach`, contra `pcsx2/Patch.cpp`: `patch=<cuándo>,<cpu>,<dir>,<tipo>,<valor>`,
  con `cuándo` 0-3 y tipos `byte`/`short`/`word`/`double`/`extended`/`bytes`.
- Savestate = ZIP con `eeMemory.bin` adentro; el offset del archivo es la
  dirección EE.
- CRC de BLACK NTSC-U (`SLUS-21376`) = `5C891FF1`, **según la comunidad, sin
  confirmar contra la copia de Fran**. Está anotado con `confirmada: false`.

**No funcionó / no se pudo hacer:**

- Nada verificado contra el juego real: esta sesión corre en un contenedor en
  la nube, sin acceso al PCSX2 de la notebook. Todo lo que dice `kb/` sobre
  BLACK es hipótesis hasta que se confirme en la máquina.
- No se recuperaron las 4-5 direcciones de vida ni la rutina de daño de la
  sesión anterior en la PC de Fran: no están en este repositorio. Quedaron
  anotadas como "pendiente de importar" en `kb/mapa-memoria.json` y
  `kb/rutinas.json`.

**Sigue:** Fase 0 del plan, en la notebook con PCSX2 abierto:

1. `python3 pruebas/prueba_herramientas.py`
2. `python3 herramientas/pine.py info` con el juego corriendo
3. Volcar serial y CRC reales a `kb/objetivo.json` y poner `version_activa`
