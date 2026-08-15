# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para
eso, `docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva,
sin memoria del chat anterior, retome exactamente donde quedó esta.

Última actualización: 2026-08-15 (tarde), notebook local (Opus), rutina de
daño localizada con el PCSX2 parcheado.

---

**OBJECTIVE**
Fase 2 — rutina de daño. **Localizada, falta confirmarla con efecto.**

**CURRENT STATE**
Se instaló el PCSX2 parcheado (PCSX2-MCP) que expone un `DebugServer` en TCP
21512, y se escribió `herramientas/depurador.py` para hablarle directo desde
Python. **No hace falta registrar ningún MCP ni reiniciar la sesión.**

Con eso cayó la pieza que faltaba: **la base del objeto del jugador estaba
mal**. Era `0x005A8AB0`, no `0x005A8D80`, y la vida es `+0x2F8`, no `+0x28`.
Los 69 candidatos de la sesión anterior buscaban el offset equivocado.

**CONFIRMED FACTS**
Ver `ESTADO_ACTUAL.md`. Lo nuevo:
- Base real del jugador: `0x005A8AB0`. Vida = `+0x2F8`. Leído del registro
  base EN VIVO (`a2`) al disparar un watchpoint de lectura, no inferido.
- `gp = 0x004157F0`.
- Los watchpoints funcionan, y el PC de la pausa **es** la instrucción que
  accedió (probado: `gp-0x7150` = la dirección vigilada, exacto).
- `1200.0` y `750.0` están hardcodeados en el lector de vida del HUD.

**ACTIVE HYPOTHESES**
- La rutina de daño puede ser **genérica** (jugador Y enemigos): el offset
  `0x2F8` se usa con `s0`, `s1`, `s2`, `a1` y `a2` como base. Si lo es, se
  ganan las Fases 3 y 5 juntas.
- Vida máxima = **1200.0** (no `FLT_MAX`). Falta ver qué elige la rama entre
  1200.0 y 750.0.
- `0x0065F458` = el ratio del HUD (`vida / 1200.0`).

**IMPORTANT ADDRESSES**
```
0x005A8AB0  base   objeto del jugador          CONFIRMADO (leido de a2 en vivo)
0x005A8DA8  f32    vida (= base+0x2F8)         CONFIRMADO
0x0013C120  code   swc1 f22,0x2F8(s0) DANO     PROBABLE  <- nopear = vida infinita
0x0013C0DC  code   sub.s f22,f22,f21           PROBABLE  <- multiplicador de dano
0x0013C0F0  code   swc1 f20,0x2F8(s0) MUERTE   PROBABLE
0x001F93E0  code   lector de vida del HUD      PROBABLE
0x004157F0  ptr    gp del juego                CONFIRMADO
0x006CF54C  u32    segmentos del HUD           derivado — NO escribir fuera de 0..8
0x005A8D80  ---    BASE VIEJA, DESCARTADA
```

**NEXT ACTION — PASO 0 PRIMERO, es el que puede estar rompiendo todo**

El emulador murió DOS veces en la sesión anterior. El sospechoso número uno no
es el debugger sino **OneDrive**: el data dir de PCSX2 está en
`C:\Users\frans\OneDrive\Documents\PCSX2` (337 MB) y cada savestate son ~32 MB
sin comprimir que OneDrive agarra para subir mientras PCSX2 los usa. Los dos
crashes vinieron después de un `savestate`, y el segundo ocurrió **sola, sin
que el watchpoint disparara y sin que el usuario tocara nada**.

**Paso 0 (2 min, riesgo cero):** en PCSX2, `Settings > Folders` (o el .ini),
mover el data dir a algo fuera de OneDrive, por ejemplo `C:\PCSX2-datos`.
Después repetir el experimento. Si no vuelve a crashear, era eso — anotarlo.

**Paso 1** — necesita al usuario jugando. **Con WATCHPOINT, no con breakpoint
de ejecución** (el de ejecución crashea seguro — ver DO NOT REPEAT):
```
python herramientas/depurador.py vigilante poner 0x005A8DA8 --tipo write --accion break
python herramientas/depurador.py esperar --segundos 120
```
Recibir un golpe. Al pausar, `esperar` imprime el PC y el código alrededor.
**Si el PC es `0x0013C120` → confirmado.** Es evidencia independiente: no se
puso el breakpoint sobre la dirección sospechada, se dejó que el juego la
delatara. Después: `vigilante quitar 0x005A8DA8` y `continuar`.

**Plan B si sigue crasheando** (no depende del debugger, y es el método que ya
cerró la Fase 1): `vigilar.py` muestreando la vida a 20 Hz mientras el usuario
juega y narra los golpes, más `volcar_vivo.py` para el análisis en frío. Más
lento, pero cero riesgo de crash.

**DO NOT REPEAT**
- **NO relanzar el emulador y reintentar lo mismo sin diagnosticar.** Paso dos
  veces en la misma sesion: crasheo, se relanzo a ciegas, volvio a crashear.
  La segunda muerte fue la que dio el dato bueno (murio SOLA, sin daño, sin
  error) y recien ahi aparecio la hipotesis de OneDrive. Diagnosticar primero.
- **NO usar breakpoints de EJECUCION (`bp poner`): matan el emulador.**
  `bp poner 0x0013C120` corto la conexion a mitad del comando y el proceso
  desaparecio. Los **watchpoints** (`vigilante`) en cambio pausan y resumen
  limpio decenas de veces — es el camino. `depurador.py` ahora exige
  `--se-que-crashea` para dejarte poner uno de ejecucion.
- **NO lanzar flujos multi-agente sin sondear primero.** Van dos sesiones
  seguidas quemando cientos de miles de tokens en paralelizar preguntas que se
  contestaban con cuatro comandos secuenciales. Lección 9 de
  `/lecciones-aprendidas` — leerla ANTES de empezar, no después.
- **No inferir la base de un struct por escaneo de punteros.** Se hizo eso y
  dio `0x005A8D80`, que era falso y costó una sesión entera. La forma correcta:
  watchpoint sobre el campo conocido y leer el **registro base** al disparar.
- **Un watchpoint de LECTURA es mejor punto de entrada que uno de escritura**:
  dispara solo (el HUD lee cada frame) y no necesita que el usuario provoque
  nada.
- **`--accion log` no cuenta hits**: es un stub. Usar `--accion break`.
- **`OnBreakpointHit()` del parche es un stub**: no hay aviso asincrónico,
  `esperar` hace polling.
- **Los savestates de la build parcheada y los de la 2.6.3 oficial NO son
  intercambiables** (la parcheada se declara versión "Unknown").
- No usar `escanear.py poner` con valores arbitrarios: crasheó el emulador.
- No escribir en `0x006CF54C` fuera del rango 0..8.

**OPEN QUESTIONS**
- ¿Parchear `0x0013C120` da vida infinita en pantalla? (el test que cierra la fase)
- ¿La rutina de daño es genérica o sólo del jugador?
- ¿Qué elige la rama entre 1200.0 y 750.0?
- ¿Dónde está el prólogo de la rutina de daño? (se localizó el cuerpo, no el inicio)
- ¿`0x0042C3AC` es la tabla de armas? Ahora es barato: watchpoint de lectura.

**TOOLS / ENVIRONMENT**
Python 3.13 (`python`, no `python3`), numpy instalado. Node.js v24.19.0.
**PCSX2 PARCHEADO** en `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
— es el que hay que abrir, NO el de Program Files. DebugServer en 21512, PINE
en 28011. Herramientas nuevas: `depurador.py`, `volcar_vivo.py`.
`gh` NO está instalado. Claude Code LOCAL.

**REPO / RAMAS**
La rama de trabajo es `claude/black-game-reverse-engineering-ricv3t`. El
proyecto del teléfono está **suspendido** y el **PR #1 queda abierto sin
mergear a propósito**: mergearlo mezclaría los dos proyectos, y el usuario
pidió explícitamente que no se mezclen. `gh` no está instalado, así que el
panel de CI no puede leer el estado del PR — es esperable, no es un problema.

**MODEL RECOMMENDATION**
**Sonnet** para ejecutar los runbooks. Opus sólo si hay que leer desensamblado
nuevo de verdad.

**EFFORT RECOMMENDATION**
Medio.

---

READY FOR NEW SESSION
