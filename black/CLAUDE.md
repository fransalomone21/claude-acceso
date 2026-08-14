# Proyecto BLACK — contrato de contexto

Ingeniería reversa de **BLACK** (PS2, Criterion Games, 2006) sobre PCSX2, para
modificarlo con criterio. Este archivo se carga solo al empezar una sesión.
Es el índice, no el manual: leelo entero, y de ahí saltá a lo que haga falta.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar el proyecto, saber en qué anda | `docs/03-bitacora.md` (sólo las 2 entradas de arriba) + `kb/mapa-memoria.json` |
| buscar una dirección o rutina nueva | `docs/02-metodologia.md` |
| configurar una máquina desde cero | `docs/01-entorno.md` |
| planificar, priorizar, decidir qué sigue | `docs/04-plan.md` |
| leer desensamblado del EE | `docs/90-glosario-ee.md` |
| escribir o compilar un mod | `mods/ejemplo-plantilla.toml` + `herramientas/pnach.py --help` |

**No leas los cuatro documentos "por las dudas".** Cada uno cuesta contexto y
el contexto es lo que después falta para pensar el problema difícil.

## Las cinco reglas

1. **Una dirección sin evidencia no existe.** Toda entrada de `kb/` lleva
   `confianza` y `evidencia`. `confirmado` significa una sola cosa: se escribió
   el valor y se vio el efecto en pantalla. Nada más cuenta.
2. **Las direcciones son de una versión.** NTSC-U y PAL no comparten nada.
   Todo lo que se anota lleva su `version`. Sin `version_activa` en
   `kb/objetivo.json`, `pnach.py` se niega a compilar, y está bien que lo haga.
3. **El repo es la memoria; el chat no.** Un hallazgo que no quedó en `kb/` o
   en la bitácora se perdió. Anotarlo es parte de encontrarlo.
4. **Lo que no se sabe se dice.** "Probablemente sea la vida máxima" es una
   observación útil. "Es la vida máxima" sin haberlo escrito y mirado es una
   mentira que después cuesta tres horas desarmar. Preferimos `hipotesis`.
5. **Nada de volcados crudos en el chat.** Los hexdumps van a archivo y se
   referencian por ruta y offset. Pegar 200 líneas de hex quema el contexto
   que hace falta para razonar sobre ellas.

## Dónde está cada cosa

```
kb/            la verdad del proyecto, legible por scripts y por humanos
  objetivo.json      identidad del juego, versión activa, mapa de memoria del EE
  mapa-memoria.json  direcciones conocidas, con confianza y evidencia
  rutinas.json       funciones identificadas y sus puntos de parche
  estructuras.json   layouts de structs (jugador, enemigo, arma)
herramientas/  el instrumental (ver abajo)
mods/          definiciones de mods en TOML -> se compilan a .pnach
docs/          método, entorno, plan, bitácora
pruebas/       `python3 pruebas/prueba_herramientas.py` — no necesita PCSX2
volcados/      memoria y CSVs. Ignorado por git salvo lo que se fije a mano.
```

## Herramientas

Todas tienen `--help` y se corren desde `black/`.

| Comando | Para qué |
|---|---|
| `pine.py` | hablarle a PCSX2 en vivo: leer, escribir, volcar, pedir savestates |
| `escanear.py` | escaneo diferencial de los 32 MB. El reemplazo de Cheat Engine |
| `inspeccionar.py` | mirar el entorno de una dirección: punteros, floats, texto |
| `vigilar.py` | series temporales. Contesta "¿cada cuánto?" y "¿de a cuánto?" |
| `mips.py` | ensamblar/desensamblar R5900 para parches de código |
| `estado.py` | leer `eeMemory.bin` de un savestate |
| `pnach.py` | compilar `mods/*.toml` al `.pnach` que carga PCSX2 |

Requisitos: Python 3.11+. `numpy` es opcional pero conviene (sin él, el primer
filtro tiene que ser por valor exacto).

## Dónde corre esto

El trabajo **en vivo** (PINE, debugger, escaneo) necesita PCSX2 en la misma
máquina: **Claude Code local**, en la PC o en la notebook. Una sesión en la
nube no llega al PCSX2 de tu máquina; sirve para escribir herramientas, leer
volcados ya commiteados y documentar. Si en esta sesión no hay PCSX2 al
alcance, decilo en vez de simular resultados.

## Política de modelos

- **Opus** — leer desensamblado, formar hipótesis sobre rutinas, diseñar
  structs, decidir arquitectura. El pensamiento caro.
- **Sonnet** — escribir y refactorizar herramientas, generar mods, cargar datos
  al `kb/`, redactar documentación.
- **Haiku** — tareas mecánicas: correr scripts y reportar la salida, convertir
  formatos, renombrar.

Cambiá de modelo con `/model`. Fable queda fuera (consume créditos aparte).

## Al cerrar cualquier sesión

1. Actualizar `kb/` con lo que se haya averiguado.
2. Agregar una entrada arriba de todo en `docs/03-bitacora.md`.
3. Commit y push a `claude/black-game-reverse-engineering-ricv3t`.

Sin esos tres pasos, la próxima sesión arranca de cero.
