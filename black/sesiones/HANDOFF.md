# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para
eso, `docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva,
sin memoria del chat anterior, retome exactamente donde quedó esta.

Última actualización: 2026-08-15, notebook local (Sonnet → Opus), cierre del
checkpoint 1.

---

**OBJECTIVE**
Checkpoint 1 (encontrar la vida del jugador) — **CERRADO**. Lo que sigue es
determinar si la dirección es estable o dinámica, y de ahí al primer mod.

**CURRENT STATE**
`0x005A8DA8` = vida del jugador, `f32`, NTSC-U, **confirmado en pantalla**.
Daño por golpe = 26.0 constante. El HUD (`0x006CF54C`) es un valor derivado.
Todo anotado en `kb/mapa-memoria.json` con evidencia completa.

También quedó instalado y verificado el perfil global de skills en
`~/.claude/skills/` (`/engineering-orchestrator`, `/spec-interview`,
`/verify-before-build`).

**CONFIRMED FACTS**
Ver tabla completa en `ESTADO_ACTUAL.md`. Resumen: `SLUS-21376` / `5C891FF1`
/ v1.00 NTSC-U · vida en `0x005A8DA8` (f32) · daño 26.0 · HUD derivado en
`0x006CF54C` · PINE ok en 28011.

**ACTIVE HYPOTHESES**
- Vida máxima sin determinar (se vio ~440 y 649.79 en curaciones distintas).
- `0x0065F458` (f32, 0.23..0.59) sin identificar.

**RECENT EXPERIMENTS**
`volcados/correlacion-vida-2.csv` — 900 muestras a 10 Hz sobre 6 candidatos,
90s, con eventos de curación y daño narrados. Es la evidencia principal.
(`volcados/` está en `.gitignore`; el CSV vive sólo en la notebook.)

**IMPORTANT ADDRESSES**
```
0x005A8DA8  f32  vida del jugador          CONFIRMADO
0x006CF54C  u32  segmentos del HUD         derivado — NO escribirle valores fuera de 0..8
0x0040E6A0  f32  timer del motor           DESCARTADO
0x0065F458  f32  sin identificar           abierto
```

**NEXT ACTION**
```powershell
cd black
python herramientas\pine.py leer 0x005A8DA8 --tipo f32
# recargar el nivel en el juego
python herramientas\pine.py leer 0x005A8DA8 --tipo f32
```
Si mantiene vida coherente → estática → `.pnach` de escritura constante da
vida infinita sin tocar la rutina. Si da basura → dinámica → escalón 3
(puntero).

**DO NOT REPEAT**
- **No usar `escanear.py poner` con valores arbitrarios para confirmar
  candidatos.** Crasheó el emulador (999 en `0x006CF54C`, que es un índice de
  render). El camino seguro: muestrear con `vigilar.py` primero, y escribir
  sólo valores dentro del rango ya observado.
- **No buscar la forma de que Claude ponga breakpoints solo.** Ya se auditó:
  PINE no tiene opcodes de breakpoint (tabla contigua `0x00`-`0x0F`), y el
  `DebugServer` que sí los tiene (puerto 21512) es una build custom de PCSX2
  que **no está instalada** en esta máquina (se verificó con
  `Get-NetTCPConnection`). Los breakpoints son manuales salvo que se decida
  instalar esa build.
- **No hace falta el debugger para correlacionar un valor con un evento.**
  `vigilar.py` (muestreo por PINE) lo resuelve, es sólo lectura y no puede
  crashear nada. El debugger se necesita para el escalón 2 (la rutina), no
  para el escalón 1.
- No reabrir `~/Documents` en Windows (resuelto: OneDrive).
- No asumir `python3`, `.` en `.pnach`, ni `cheats` como nombre fijo.
- No confiar en el recuerdo de "vida máxima ~1200": es falso (~440+).

**OPEN QUESTIONS**
- ¿`0x005A8DA8` es estable entre cargas de nivel?
- ¿Cuál es la vida máxima real?
- ¿Qué es `0x0065F458`?
- **Bug pendiente**: `vigilar.py analizar` crashea al imprimir la sección
  "primeros" de los escalones.

**TOOLS / ENVIRONMENT**
Python 3.13 (`python`, no `python3`), numpy instalado. PCSX2 2.6.3 oficial en
`C:\Program Files\PCSX2\PCSX2\pcsx2-qt.exe`, PINE en slot 28011.
Todo en la notebook. Claude Code LOCAL, no cloud.

**MODEL RECOMMENDATION**
**Sonnet.** El checkpoint 1 se cerró entero sin abrir el debugger — se cambió
a Opus previendo desensamblado y no hizo falta. El próximo paso (estable vs
dinámica, y el primer `.pnach`) también es Sonnet. Subir a Opus recién si se
decide encarar el escalón 2 y hay que leer MIPS real.

**EFFORT RECOMMENDATION**
Medio.

---

READY FOR NEW SESSION
