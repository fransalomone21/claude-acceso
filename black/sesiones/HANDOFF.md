# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para
eso, `docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva,
sin memoria del chat anterior, retome exactamente donde quedó esta.

Última actualización: 2026-08-15, notebook local (Opus), Fase 2 avanzada sin
debugger.

---

**OBJECTIVE**
Fase 2 — rutina de daño y estructura del jugador. **3 de 4 objetivos cubiertos**
por análisis estático en frío. Falta identificar cuál instrucción escribe la
vida.

**CURRENT STATE**
La vida (`0x005A8DA8`, f32) **no es un global**: es el campo `+0x28` de un
objeto cuya base es `0x005A8D80`. "Estática" significa que el cargador de nivel
lo asigna siempre en el mismo lugar, no que sea una variable global. Esto se
determinó sin abrir el debugger, con `xref.py` sobre un savestate.

**CONFIRMED FACTS**
Ver `ESTADO_ACTUAL.md`. Lo nuevo de esta sesión:
- `xref.py absoluto 0x005A8DA8` → **cero**. Ninguna instrucción arma esa
  dirección; no figura como palabra suelta. Se llega por puntero.
- Base del jugador `0x005A8D80` (probable), vida en `+0x28`, layout coherente
  (cápsula de colisión +0x10/+0x14, altura 1.65 en +0x18).
- Código del juego: `0x00100000-0x003BFFFF`. Datos: `~0x0042xxxx-0x0045xxxx`.
- 69 candidatos a instrucción de escritura (`stores 0x28 --fpu`), todos dentro
  de la región de código.

**ACTIVE HYPOTHESES**
- `jugador+0x30` (`0x005A8DB0`) = vida máxima. Vale `FLT_MAX` → probablemente
  no hay techo.
- El 26.0 agrupado en `0x0042C3AC`+4 sitios más = tabla de armas.
- `0x005A8D80` puede no ser el inicio real del objeto (el primer u32 no parece
  vtable).

**RECENT EXPERIMENTS**
`volcados/ee-03.bin` — 32 MB extraídos de `SLUS-21376 (5C891FF1).03.p2s` con
`estado.py extraer`. Vida = 649.79345703125, coherente con la sesión anterior.
(`volcados/` está en `.gitignore`: el .bin vive sólo en la notebook, se
regenera en un comando.)

**IMPORTANT ADDRESSES**
```
0x005A8D80  base   objeto del jugador        PROBABLE
0x005A8DA8  f32    vida (= base+0x28)        CONFIRMADO
0x005A8DB0  f32    vida máxima? (base+0x30)  HIPOTESIS — vale FLT_MAX
0x006CF54C  u32    segmentos del HUD         derivado — NO escribir fuera de 0..8
0x0042C3AC  f32    26.0, ¿tabla de armas?    HIPOTESIS
0x0040E6A0  f32    timer del motor           DESCARTADO
```

**NEXT ACTION**
Ver `ESTADO_ACTUAL.md#próxima-acción`: tres caminos baratos (a/b/c), y el
breakpoint sólo al final para desempatar.

**DO NOT REPEAT**
- **No paralelizar una investigación antes de sondearla.** Se gastaron ~500k
  tokens en 10 agentes para preguntas que ya estaban contestadas en el
  contexto o que se resolvían con dos comandos locales. Lo que funcionó fueron
  cuatro comandos secuenciales. Ver lección 9 de `/lecciones-aprendidas`.
- **No asumir que una dirección estática se direcciona por absoluto.** Fue la
  hipótesis de trabajo y era falsa.
- **No planificar alrededor del checkbox "Log" del breakpoint de PCSX2**:
  `MemCheck::Log()` es un stub vacío, no imprime nada.
- **No buscar el debugger en el menú Tools.** En PCSX2 2.x:
  `Tools > Show Advanced Settings` → `Debug > Open Debugger`.
- **Si el dato es f32, el store es `swc1`, no `sw`.**
- **No usar `escanear.py poner` con valores arbitrarios.** Crasheó el emulador.
- **No confiar en el recuerdo de "vida máxima ~1200"**: es falso.

**OPEN QUESTIONS**
- ¿Cuál de los 69 candidatos escribe la vida?
- ¿`0x005A8DB0` es la vida máxima?
- ¿`0x0042C3AC` es la tabla de armas?
- ¿`0x005A8D80` es el inicio real del objeto?
- ¿Sigue vivo el issue #5343 de PCSX2 (breakpoints de memoria cuelgan la
  emulación en x64 Windows)? Figura cerrado, no se halló el commit que lo
  arregla. Probar con savestate y sobre una dirección inocua primero.

**TOOLS / ENVIRONMENT**
Python 3.13 (`python`, no `python3`), numpy instalado. PCSX2 2.6.3 oficial en
`C:\Program Files\PCSX2\PCSX2\pcsx2-qt.exe` (build del 28/01/2026), PINE en
28011. Data dir en `C:\Users\frans\OneDrive\Documents\PCSX2`.
**`gh` NO está instalado** — sin él no se puede mirar el PR ni el CI.
Herramienta nueva: `herramientas/xref.py`.
Claude Code LOCAL, no cloud.

**MODEL RECOMMENDATION**
**Sonnet** para (a), (b) y (c) — son correr herramientas y leer salidas. Opus
recién cuando haya que leer el desensamblado de la rutina de daño de verdad.

**EFFORT RECOMMENDATION**
Medio.

---

READY FOR NEW SESSION
