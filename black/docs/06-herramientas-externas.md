# Herramientas externas — el instrumental que no escribimos nosotros

Qué se adoptó, con qué versión exacta, cómo se monta y —sobre todo— **cómo se
verifica que funciona**. Levantado el 2026-08-16.

Las herramientas de `black/herramientas/` son nuestras y se prueban con
`pruebas/prueba_herramientas.py`. Éstas son de terceros: el riesgo no es que
tengan bugs, es que **funcionen mal en silencio**. Cada una de acá abajo lleva
su control positivo, que es un caso cuya respuesta ya conocemos por otra vía.

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

### Cómo se usa

`herramientas/decompilar.py` — `info`, `c <dir>`, `funciones`, `xref <dir>`.
No se llama `ghidra.py` a propósito: taparía el paquete Java `ghidra` que
importa `pyghidra`, que es la misma trampa que `dis.py`.

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

## Lo que se evaluó y se DESCARTÓ

Está acá para que nadie lo vuelva a investigar.

### PCSX2-MCP (`hkmodd/PCSX2-MCP`) — descartado por riesgo

Promete 30 herramientas de depuración por MCP: breakpoints, registros de 128
bits, desensamblado, watchpoints, call stacks. Suena perfecto para este
proyecto.

**No se instaló, y la razón no es técnica.** Funciona con un
**`pcsx2-qt.exe` pre-compilado que hay que bajar del release** de un
repositorio de 18 estrellas: un ejecutable sin firmar, de un tercero sin
reputación, que reemplaza al emulador. Bajar y ejecutar binarios de fuentes
no verificadas no es una decisión que tome la herramienta: la toma el usuario,
con el riesgo a la vista.

Y hay un antecedente que pesa: ya está documentado en `ESTADO_ACTUAL.md` que
el servidor de depuración del **PCSX2 oficial** corrompe el heap
(`DebugServer.cpp` muta `CBreakPoints` desde el hilo del socket sin mutex) y
que los breakpoints de ejecución matan el proceso. Un fork no auditado de esa
misma capa no es la forma de arreglarlo.

Si algún día se quiere, la decisión es de Fran, no de la sesión.

### mcp-pine (`dmang-dev/mcp-pine`) — descartado por redundante

MCP que habla PINE con PCSX2 y RPCS3. Limpio, no necesita build modificado,
se instala con `claude mcp add pine --scope user mcp-pine` (Node 22+).

Expone lectura/escritura de memoria de 8/16/32/64 bits, lectura por rango, y
savestates. **`herramientas/pine.py` ya hace todo eso** y además vuelca los 32
MB en ~3 s, que es la operación que este proyecto usa de verdad. Sumarlo no
destraba nada.

Queda anotado como alternativa si alguna vez hace falta manejar PCSX2 desde
un cliente que no sea Claude Code.

### QuickBMS y los foros — no hay script para BLACK

Se buscó script `.bms` o plugin de Noesis para los formatos de BLACK. **No
existe público.** El hilo de referencia es
[ResHax #514](https://reshax.com/topic/514-black-ps2xbox-bin-db/), donde
varios piden lo mismo y un usuario dice haberlo reverseado hace años sin
publicar nada. Nadie posteó cabecera, offsets ni herramienta.

Conclusión operativa: **el formato de los `.BIN` de BLACK es nuestro para
resolver.** Y se resolvió leyendo el parser con Ghidra — ver `05-iso.md`.

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
