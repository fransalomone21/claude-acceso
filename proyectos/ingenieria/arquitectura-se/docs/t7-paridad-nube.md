# T7 — Paridad nube/local: pasar a la nube sin pensar el «cómo» cada vez

Pedido de Fran, 2026-10-02 (con el plan al 97 %): «un método correcto para
pasar a nube sin que tengas que pensar "cómo" cada vez». Es la T7 del camino
crítico (`diagnostico-2026-09-28.md` §3), adelantada por necesidad real.

## 1. Lo que se midió (2026-10-02, sesión `ecb1314f`)

| Hueco | Evidencia | Grado |
|---|---|---|
| En la nube no corre **ningún** hook | todos los comandos de `.claude/settings.json` llevan ruta absoluta `C:\Users\frans\...`; la sesión de la nube informó que la puerta no le pidió nada | confirmado (la nube lo vio) |
| No llega **el perfil** (reglas, pilares, núcleo, cuadro, skills) | vive en `~/.claude/` instalado desde `perfil-global`, que es repo **privado** y aparte | confirmado (`gh repo view`: PRIVATE) |
| `aprender.py` no existe en la nube | vive en `perfil-global/herramientas/` | confirmado (la nube lo informó) |
| `cascada.ps1` no corre en Linux | 20 K de PowerShell con rutas `\`; pero lo que exige ya lo calcula `cascada_puerta.py --exige` | probable |
| La puerta sólo reconoce `cascada.ps1` | regex `DECL` y `LECTURA` de `cascada_puerta.py` (líneas ~52 y ~414) | confirmado (leído) |
| Los criterios de cátedra viajan **pegados** en el retome | `catedras` es privado y **sin remote**: en la nube no existe | confirmado |
| `python` existe en la nube | la sesión de la nube corrió `verificar-ejemplos.py` | confirmado |

## 2. Requisitos (verificables)

- **R1** Una sesión en la nube (`CLAUDE_CODE_REMOTE=true`) recibe al arrancar
  lo mismo que la local: CLAUDE-global, pilares (2), apertura, núcleo (4) y el
  recordatorio por turno. *Se verifica:* `medir-costo.py` (o el transcript)
  de una sesión de la nube muestra los 8 bloques.
- **R2** La puerta de la cascada y `fase_activa` corren en la nube y frenan
  igual. *Se verifica:* en la nube, un Edit sobre un proyecto sin declarar
  sale denegado.
- **R3** Nada cambia en local: mismos hooks, mismo costo. *Se verifica:*
  `probar-hooks.ps1` en verde y un `claude -p` local con Haiku que intenta
  editar sin declarar sale denegado (la frontera real, no el autotest).
- **R4** Lo que la nube usa del perfil es una **copia generada** con dueño
  único (`perfil-global`) y un medidor que da **rojo** si quedó vieja (MD5
  contra la fuente), en la capa rápida del arranque local.
- **R5** Lo que la nube aprende vuelve: `aprender.py agregar` en la nube
  escribe a una **bandeja** en `claude-acceso` (`.claude/nube/bandeja.jsonl`);
  el arranque local avisa si no está vacía y la sesión local la registra en
  `perfil-global` y la vacía.
- **R6** Pasar a la nube es **un comando**: `.\pasar-a-nube.ps1 <proyecto>
  -Necesidad <a,b>` regenera la copia del perfil, corre el medidor, commitea,
  pushea y **escribe el retome** (lo que hoy se hace a mano cada vez).
- **R7** Lo privado no se publica: la copia excluye `lecciones.jsonl`,
  `LECCIONES.md`, `PENDIENTES.md` y todo lo que la regla 5 de
  `verificar-estructura.ps1` marque. Lo que la cátedra pide, si va a la nube,
  va como **resumen público fechado** en el proyecto de la materia, generado
  desde `catedras` (decisión de Fran: ver §4).

## 3. Diseño elegido

1. **`.claude/nube/perfil/`** — copia generada de los 6 `.md` inyectados +
   `chequeo-de-trabajo.md` (la puerta pide rangos de él) + las skills del
   perfil + `herramientas/aprender.py`. La genera `pasar-a-nube.ps1` (y
   `install.ps1`), con `MANIFIESTO.md5`.
2. **`.claude/nube/nube.py`** — un solo script, subcomandos:
   - `arranque`: si no es la nube, sale 0 sin hacer nada. Si es: copia
     `perfil/` a `~/.claude/` con **las mismas rutas** que local (así el
     catálogo de la puerta sirve igual), instala typst 0.15 si falta, mira gcc.
   - `emitir <archivo> [parte de]`: el equivalente de `emitir-contexto.ps1`,
     con el mismo corte en frontera de sección (sólo en la nube).
3. **`settings.json`**: las entradas `python "C:\..."` pasan a
   `python "$CLAUDE_PROJECT_DIR/.claude/hooks/..."` (sirven en los dos lados,
   sin duplicar), y se agregan las de `nube.py` para lo que en local da el
   perfil global. **Riesgo a medir primero (R3):** que en Windows los hooks
   corran por Git Bash y expandan `$CLAUDE_PROJECT_DIR` (`probable`); si no,
   la puerta local fallaría abierta en silencio. Se prueba con `claude -p`
   antes de dar nada por puesto.
4. **`cascada.sh`** — envoltorio de `cascada_puerta.py --exige` con la misma
   sintaxis (`-Necesidad`, `-Excepcion`); `DECL` y `LECTURA` aceptan
   `cascada\.(ps1|sh)`. Autotest con un caso nuevo.
5. **Lo que NO se lleva, declarado:** `guardia-iso` (el ISO no está en la
   nube), `guardia-heredoc` y `guardia-fanout` (PowerShell; el retome dice
   «sin fan-out»), rclone/Drive (lo publica la PC con un pull), los repos
   privados sin remote.

## 4. Pendiente de Fran (valor, no técnica)

- ¿Se publica la copia del perfil (método sin lecciones) en este repo
  público? `metodo-agustin` ya apunta a compartir el método filtrado, así que
  se asume **sí** salvo que diga lo contrario.
- ¿Los criterios de Leandro pueden ir como resumen público fechado en
  `software-de-vuelo/docs/`? (Ya están en parte en las cajas `#catedra` del
  apunte público.)

## 5. Orden de construcción

R3 (la prueba de la frontera en Windows) → 3 → 4 → 1-2 → R5 → R6. Los rojos
del arranque de hoy: `carrera` sin entrada en `.claude/cascada.json` (abierto).
