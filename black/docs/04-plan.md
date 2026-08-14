# Plan de trabajo

Cómo está organizado el proyecto, en qué orden conviene atacarlo, y cómo
trabajar con Claude sin quemar tokens al pedo.

---

## Las fases

Cada fase es **una misión = un chat**. Empieza con un objetivo concreto y
termina con algo escrito en `kb/` y commiteado. No se pasa a la siguiente sin
cerrar la anterior, porque cada una es el cimiento de la que sigue.

### Fase 0 — Identidad y entorno  ·  ~30 min  ·  Haiku o Sonnet

Lo más aburrido y lo más importante: sin esto, todo lo que anotes después puede
no servir en la otra máquina.

- [ ] `docs/01-entorno.md` completo en la notebook (PINE, savestates sin
      comprimir, Python 3.11+, `pip install numpy`)
- [ ] `python3 pruebas/prueba_herramientas.py` en verde
- [ ] `python3 herramientas/pine.py info` con el juego corriendo
- [ ] **serial y CRC reales volcados a `kb/objetivo.json`**, con `version_activa`
- [ ] Recuperar lo de la sesión anterior en la PC de Fran: las 4-5 direcciones
      de vida y la rutina de daño. Si no aparecen, se rehacen en la Fase 1 —
      son veinte minutos, no vale la pena pelearse con eso.

> **Ojo con lo viejo.** Si aquellos valores salieron de una versión distinta del
> juego (PAL vs NTSC-U), no sirven. Antes de confiar en ellos, leé una de esas
> direcciones con `pine.py leer` y fijate si tiene algo parecido a una vida.

### Fase 1 — El ancla  ·  ~1 h  ·  Sonnet

- [ ] Vida del jugador **confirmada**: escribirle un valor y ver la barra moverse
- [ ] Determinar si la dirección es estática o dinámica (reiniciar nivel y releer)
- [ ] Anotada en `kb/mapa-memoria.json` con evidencia

Método: `docs/02-metodologia.md`, escalón 1.

### Fase 2 — La rutina de daño y la estructura del jugador  ·  ~2-3 h  ·  **Opus**

Es la fase que más rinde de todo el proyecto. Acá se leen instrucciones y se
forman hipótesis: conviene el modelo bueno.

- [ ] Breakpoint de escritura sobre la vida → instrucción que la escribe
- [ ] Subir al prólogo → dirección de la rutina, a `kb/rutinas.json`
- [ ] Del `sw rt, off(rs)` salen el puntero al jugador y el offset de la vida
- [ ] Volcar la estructura e identificar campos (`inspeccionar.py`)

**Desbloquea:**
- **Vida máxima** — el campo que está al lado de la vida actual
- **Vida infinita** — `nop` sobre el `sw`
- **Multiplicador de daño** — un `sra` insertado antes de la resta
- **Regeneración** — ver abajo

> ### Sobre la regeneración
> **Todavía no sabemos si BLACK regenera vida, ni con qué reglas.** Es una
> pregunta empírica, no algo que se pueda dar por sabido. Se contesta midiendo,
> antes de tocar nada:
> ```bash
> python3 herramientas/vigilar.py grabar --de-kb vida_jugador --hz 20 --segundos 60
> python3 herramientas/vigilar.py analizar ../volcados/vigilancia-*.csv
> ```
> Quedate quieto y a cubierto después de recibir daño. El análisis dice si hay
> escalones, de qué tamaño y cada cuánto. Si sale "salto CONSTANTE de N" y
> "ritmo REGULAR", hay regeneración y ya tenés la tasa y el intervalo medidos.
> Si no cambia nada, no hay regeneración y el objetivo pasa a ser *agregarla*,
> que es un problema distinto (y más divertido).

### Fase 3 — Enemigos  ·  ~2-3 h  ·  Opus para el análisis, Sonnet para la carga

- [ ] vtable del jugador y de un enemigo
- [ ] Escanear por vtable → todos los objetos de esa clase
- [ ] Estructura del enemigo: vida, estado, equipo
- [ ] Encontrar la lista o el array de entidades activas

**Desbloquea:** cantidad de enemigos, vida de enemigos, enemigos de cristal o
de acero, y —siguiendo quién escribe en la lista— la rutina de spawn.

### Fase 4 — La tabla de armas  ·  ~2-4 h  ·  **Opus**

El premio grande. Método: `docs/02-metodologia.md`, escalón 5.

- [ ] Localizar la estadística de un arma (daño o cargador; el cargador es más
      fácil porque lo ves en el HUD)
- [ ] Verificar que el patrón se repita a intervalos fijos → es una tabla
- [ ] Mapear el layout de una entrada en `kb/estructuras.json`
- [ ] Volcar la tabla entera y etiquetar cada arma

**Desbloquea de un saque:** daño, cadencia, cargador, dispersión y retroceso de
**todas** las armas. Un solo hallazgo, veinte mods.

### Fase 5 — Daño de enemigos por arma  ·  Opus

Es el cruce de las fases 2, 3 y 4: en la rutina de daño, quién es el atacante y
qué arma usó. Con la tabla de armas ya mapeada, esto es casi cargar datos.

Recién acá se puede contestar bien lo que pediste: *"daño de todos los enemigos
con sus respectivas armas"*.

---

## Qué desbloquea qué

Sirve para no intentar algo que todavía no tiene cimiento.

| Lo que querés | Fase | Depende de |
|---|---|---|
| Vida infinita | 2 | rutina de daño |
| Vida máxima | 2 | estructura del jugador |
| Multiplicador de daño recibido | 2 | rutina de daño |
| Regeneración (medirla) | 2 | ancla (fase 1) |
| Regeneración (agregarla, si no existe) | 2+ | rutina de daño + hueco de código |
| Cantidad de enemigos | 3 | vtable + lista de entidades |
| Vida de enemigos | 3 | estructura del enemigo |
| Daño / cargador / cadencia por arma | 4 | tabla de armas |
| Daño de cada enemigo con cada arma | 5 | 2 + 3 + 4 |
| Munición infinita | 4 | estructura del jugador o del arma |

---

## Un chat por misión (y por qué no uno solo eterno)

**Un chat largo es peor, no mejor.** Cuando el contexto se llena, se resume — y
lo primero que se degrada en un resumen son los datos que no se pueden
aproximar: direcciones hexadecimales, offsets, valores de registros. Justo lo
único que no podemos permitirnos perder.

La regla:

- **Un chat = una fase**, o una pregunta acotada.
- La memoria del proyecto es `kb/` + la bitácora, **nunca** el historial del chat.
- Cerrar un chat no pierde nada, siempre que hayas hecho commit.

### Cómo arrancar un chat nuevo

```
Leé black/CLAUDE.md y las dos primeras entradas de black/docs/03-bitacora.md.
Vamos por la Fase 2: la rutina de daño.
```

Eso son unos pocos miles de tokens y deja a Claude exactamente donde estabas.
Copiar y pegar el chat anterior cuesta diez veces más y sirve menos.

---

## Modelos

| Modelo | Cuándo | Por qué |
|---|---|---|
| **Opus** | leer desensamblado, hipótesis sobre rutinas, diseñar structs, decidir arquitectura | es donde el razonamiento se paga solo |
| **Sonnet** | escribir herramientas, generar mods, cargar datos al `kb/`, documentar | trabajo definido, sin ambigüedad |
| **Haiku** | correr scripts y reportar salida, convertir formatos, renombrar | mecánico |

Se cambia con `/model` en el mismo chat. No hace falta abrir uno nuevo.

Regla simple: **si hay que decidir o interpretar, Opus. Si ya está decidido y
hay que ejecutar, bajá.** Fable queda afuera (consume créditos aparte).

---

## Economía de tokens

Lo que **más** cuesta, en orden:

1. **Capturas de pantalla del debugger.** Una imagen vale miles de tokens y se
   lee peor que el texto. Seleccioná el desensamblado y pegalo como texto.
2. **Volcados de memoria en el chat.** 200 líneas de hex son ~8000 tokens que
   además hay que releer en cada turno siguiente. Van a archivo, y se referencian
   por ruta y offset.
3. **Re-leer documentación ya leída.** Por eso `CLAUDE.md` es un índice y no un
   manual: se lee lo que hace falta y nada más.
4. **Explorar sin objetivo.** "Fijate qué encontrás en la memoria" no tiene
   final. "Buscá la vida máxima cerca de `0x2038A0`" sí.

Lo que **no** cuesta y conviene usar:

- Correr scripts: la salida ya viene resumida a propósito.
- Commitear seguido: es la alternativa barata a mantener todo en el chat.
- Cerrar un chat y abrir otro: el `kb/` sobrevive, el historial no hace falta.

**La regla de oro:** si algo se va a necesitar en dos semanas, va a un archivo.
Si sólo se necesita ahora, va al chat.

---

## Sobre dónde corre cada cosa

| Tarea | Dónde |
|---|---|
| Escanear, PINE, debugger, probar mods | **Claude Code local**, en la máquina que tenga PCSX2 |
| Escribir o arreglar herramientas | cualquiera de los dos |
| Documentar, planear, analizar volcados ya commiteados | cualquiera de los dos |
| Leer un ELF en Ghidra | local (Ghidra es una app de escritorio) |

Una sesión en la nube **no llega** al PCSX2 de tu máquina: corre en un
contenedor aislado. Para el trabajo en vivo, Claude Code local en la PC o en la
notebook. Lo que sincroniza las dos máquinas es git.

---

## Reglas de seguridad del proyecto

1. **Savestate antes de cada experimento.** Escribir en memoria al azar cuelga
   el emulador; no rompe nada permanente, pero perdés la partida.
2. **Un cambio por vez.** Dos parches simultáneos y un comportamiento raro =
   no sabés cuál fue.
3. **Nada entra a `mods/` sin estar `confirmado`.** `mods/` es la salida del
   trabajo, no el banco de pruebas. Para probar está `escanear.py poner`.
4. **Los callejones sin salida se anotan.** Saber que algo *no* es la vida
   máxima vale casi tanto como saber qué sí lo es.
