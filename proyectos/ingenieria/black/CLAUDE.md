# Proyecto BLACK — contrato de contexto

Ingeniería reversa de **BLACK** (PS2, Criterion Games, 2006) sobre PCSX2, para
modificarlo con criterio. Este archivo se carga solo al empezar una sesión.
Es el índice, no el manual: leelo entero, y de ahí saltá a lo que haga falta.

**Naturaleza:** `ingenieria`. Antes de trabajar acá se lee
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md):
evidencia, confirmado-por-efecto, versión del dato, y las trampas de creerle a
una herramienta.

> **`PDP.md` existe desde el 2026-08-28**, y es donde vive el **criterio de
> salida de la fase abierta** — lo que antes estaba repartido entre
> `ESTADO_ACTUAL.md` y `docs/04-plan.md`. No duplica el mapa de fases: ése
> sigue en `ESTADO_ACTUAL.md`, que se actualiza cada vez que cambia algo real.
> De la próxima fase en adelante, el criterio de salida se escribe **antes** de
> empezarla, no después.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar el proyecto, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué cierra la fase abierta, o por qué se decidió algo | `PDP.md` |
| entender cómo se llegó a algo, o qué no funcionó antes | `docs/03-bitacora.md` |
| buscar una dirección o rutina nueva | `docs/02-metodologia.md` |
| configurar una máquina desde cero | `docs/01-entorno.md` |
| planificar, priorizar, decidir qué sigue | `docs/04-plan.md` |
| tocar el ISO, un formato de archivo, o el ELF | `docs/05-iso.md` |
| montar Ghidra, vgmstream, o algo de terceros | `docs/06-herramientas-externas.md` |
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
| `xref.py` | quién toca un dato: referencias cruzadas en frío sobre un volcado. **Probalo antes de abrir el debugger** |
| `vigilar.py` | series temporales. Contesta "¿cada cuánto?" y "¿de a cuánto?" |
| `mips.py` | ensamblar/desensamblar R5900. **No decodifica FPU** — para eso, `capstone` (ver `docs/05-iso.md`) |
| `decompilar.py` | **Ghidra desde Python: el ELF en C.** Correr `info` primero — trae el control positivo |
| `tablas.py` | buscar tablas en frío sobre el ELF o un volcado, sin partir de un dato conocido |
| `registro_fisica.py` | el **control en frío** del registro que llena el tipo `0x2D`: 48 ranuras, cuántas están ocupadas, y sobre todos los volcados a la vez |
| `lbas.py` | la tabla de LBAs del ISO, y buscarlos en un binario **con control positivo y piso de ruido**. Con eso se cerró 6.1 |
| `parche_iso.py` | **el mod permanente**: editar un archivo adentro del ISO, in-place, sin reconstruirlo. `preparar` / `armas` / `verificar` |
| `awd.py` | los `.AWD` de audio vía vgmstream. Ahí están los nombres que puso Criterion |
| `clases.py` | clases de entidad por vtable: qué objetos hay de cada clase y cuál es su rutina de daño |
| `estado.py` | leer `eeMemory.bin` de un savestate |
| `pnach.py` | compilar `mods/*.toml` al `.pnach` que carga PCSX2 |
| `fijar_objetivo.py` | confirma serial/CRC contra PCSX2 y actualiza `kb/objetivo.json` solo |
| `aprender.py` | **autoaprendizaje**: registra y lista las lecciones de proceso. `digesto` es lo que se lee al abrir sesión |
| `windows/preparar_entorno.ps1` | Windows: automatiza el checkpoint 0 completo (pide UAC) |

`salida.py` está en la misma carpeta pero **no es un comando**: es la
biblioteca que usan las demás para no morirse imprimiendo cuando la consola
de Windows no sabe escribir un carácter. Si agregás un símbolo raro a la
salida de una herramienta, leé su encabezado primero.

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

## Autoaprendizaje — se corre solo, no se pregunta

**Al abrir no hay que hacer nada:** el hook `SessionStart` del perfil global
inyecta `chequeo-de-trabajo.md`, la síntesis de las 31 lecciones. Si hace
falta el listado completo:
`python ../../../perfil-global/herramientas/aprender.py digesto`.

Al cerrar, si algo falló **por cómo se trabajó** y no por lo que decía el
código, se registra en el **registro global**, no en el del proyecto:

```
python ../../../perfil-global/herramientas/aprender.py agregar --proyecto black \
    --grupo evidencia|busqueda|medicion|herramientas|proceso|entorno \
    --titulo ... --costo ... --sintoma ... --regla ...
```

El síntoma se escribe como se veía **antes** de entenderlo, que es la única
forma de reconocerlo la próxima vez.

`herramientas/aprender.py` y `kb/aprendizaje.jsonl` quedan **deprecados**: sus
5 lecciones ya están migradas al registro global. Escribir ahí crearía una
segunda fuente de verdad. Ver lección 25 de `/lecciones-aprendidas`.

## Al cerrar cualquier sesión

1. Actualizar `kb/` con lo que se haya averiguado.
2. Agregar una entrada arriba de todo en `docs/03-bitacora.md`.
3. Registrar las lecciones de proceso con `aprender.py agregar`.
4. Actualizar `ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md`.
5. Commit y push a `main`.

Sin esos pasos, la próxima sesión arranca de cero.
