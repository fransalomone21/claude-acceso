# Metodología

Cómo se pasa de "quiero cambiar la vida máxima" a un parche que funciona, sin
dar vueltas y sin quedarse pegado en el nivel más bajo.

---

## La escalera

La idea central del proyecto: **no buscamos direcciones, buscamos estructura.**
Una dirección suelta sirve para un truco. Una estructura entendida sirve para
todos los trucos de esa familia, y sigue sirviendo cuando cambies de nivel o de
partida. Cada escalón de abajo desbloquea al de arriba.

```
5. TABLAS       la tabla de armas, la tabla de tipos de enemigo
      ↑         → mods de datos, masivos y estables
4. CLASES       vtables: qué objetos son "enemigo", cuántos hay, dónde
      ↑         → cantidad de enemigos, spawns
3. ESTRUCTURA   el objeto que contiene la vida: qué más tiene adentro
      ↑         → vida máxima, munición, estado
2. RUTINA       el código que escribe ese dato: quién lo llama y con qué
      ↑         → daño, regeneración, invulnerabilidad
1. DIRECCIÓN    un valor que se mueve como la vida
                → el ancla; por sí sola casi no sirve
```

Todo el proyecto es subir esta escalera. Cuando algo se traba, casi siempre es
porque se intentó saltar un escalón.

---

## Escalón 1 — Encontrar el ancla

Objetivo: una dirección cuyo valor se mueva igual que la vida en pantalla.

```bash
# Foto inicial (PCSX2 abierto, juego corriendo, guardá con F1 o usá --pedir)
python3 herramientas/escanear.py nuevo vida --tipo u32 --pedir

# Te pegan un tiro. Filtrás por "bajó".
python3 herramientas/escanear.py filtrar vida bajo --pedir

# Te curás. Filtrás por "subió". Repetí 3 o 4 veces alternando.
python3 herramientas/escanear.py filtrar vida subio --pedir
```

Sobre RAM realista, la primera pasada baja de 8.100.000 a unos 100.000, y cada
filtro siguiente divide por diez o más. Con cuatro o cinco pasadas quedan
menos de veinte.

**Detalles que ahorran tiempo:**

- Si no sabés el tipo, probá `u32` primero: es lo más común. Si no aparece,
  `u16`, después `f32`. Muchos juegos guardan la vida como flotante.
- **Alternar sube y baja es lo que separa la vida del ruido.** Filtrar tres
  veces seguidas por "bajó" deja todos los timers descendentes del juego.
- `igual` también filtra: quedarte quieto y filtrar por "igual" mata todo lo
  que oscila solo.
- Cuando queden pocos, la prueba definitiva es escribir:
  ```bash
  python3 herramientas/escanear.py poner vida --indice 0 --valor 500
  ```
  Si la barra de la pantalla se mueve, ese es. Si no se mueve pero el juego se
  comporta distinto, encontraste **una copia** (el valor que se dibuja) y no el
  original. Seguí buscando: el original es el que usa la lógica.

**Anotalo en `kb/mapa-memoria.json` antes de seguir.** Con `evidencia`.

> ### Estable o dinámica
> Reiniciá el nivel y volvé a leer la dirección. Si sigue teniendo la vida, es
> **estática**: sirve directo en un `.pnach`. Si tiene basura, el objeto se
> reubica en cada carga y hay que llegar por puntero (escalón 3). Anotá cuál de
> las dos es: cambia todo lo que viene después.

---

## Escalón 2 — De la dirección a la rutina

Acá entra el debugger de PCSX2, que es lo único que esta caja de herramientas
no reemplaza. `Tools > Show Debugger`.

1. En la pestaña **Memory**, andá a la dirección de la vida.
2. Click derecho → **Add breakpoint** → tipo **Write**.
3. Volvé al juego y hacé que te peguen. El emulador frena.
4. La instrucción donde frenó es la que escribe la vida. Va a ser algo como
   `sw v0, 0x1C(s0)`.

Eso ya te dice tres cosas:

- **`s0` es el puntero al objeto** que contiene la vida.
- **`0x1C` es el offset de la vida** dentro de ese objeto.
- **`v0` es la vida nueva**, o sea el resultado del cálculo de daño, que está
  unas instrucciones más arriba.

Ahora subí en el desensamblado hasta el prólogo de la función — la primera
instrucción `addiu sp, sp, -N`. **Esa** dirección es la que va a
`kb/rutinas.json`, no la del breakpoint.

Mirá el **call stack** del debugger: quién llamó a esta rutina es el atacante,
y sus argumentos (`a0`–`a3`) suelen incluir el daño y quién lo causó.

**Parches típicos que salen de este escalón:**

| Quiero | Parche |
|---|---|
| vida infinita | `nop` sobre el `sw` que guarda la vida nueva |
| daño reducido a la mitad | insertar un `sra` sobre el registro del daño antes de la resta |
| daño cero de un enemigo | `nop` en la llamada, en el llamador específico |

Para ver qué hay hoy en una dirección y armar el reemplazo:

```bash
python3 herramientas/pine.py leer 0x0010A2B4 --tipo u32
python3 herramientas/mips.py des 0x0010A2B4 0xAE02001C   # -> sw v0, 0x1C(s0)
python3 herramientas/mips.py ens "nop"
```

---

## Escalón 3 — Del objeto a la estructura

Ya sabés que la vida vive en `[s0 + 0x1C]`. Leé `s0` en el debugger: ese es el
puntero al jugador. Ahora mirá qué más hay adentro.

```bash
python3 herramientas/inspeccionar.py volcar <base> --antes 0 --largo 0x200
```

La salida marca lo que parece puntero, lo que parece flotante razonable y lo
que parece texto. Buscá:

- **La vida máxima**: casi siempre a pocos bytes de la vida actual, con un
  valor "redondo" (100, 150, 1000) que no se mueve cuando te pegan.
- **Tres flotantes seguidos** de magnitud parecida: es una posición XYZ.
- **El primer `u32` del objeto**, si es puntero: es la **vtable**. Anotala,
  porque es la llave del escalón 4.

Para identificar campos que no se ven a simple vista, usá la comparación:

```bash
python3 herramientas/inspeccionar.py comparar <base> --largo 0x200 --guardar antes.bin
# (recargás el arma en el juego)
python3 herramientas/inspeccionar.py comparar <base> --largo 0x200 --contra antes.bin
```

Lo que cambió es lo que hace eso. Un campo por experimento, y cada experimento
con una sola variable.

---

## Escalón 4 — Clases y listas de objetos

Si el jugador y los enemigos son objetos de C++ (lo habitual en un motor de
2006), todos los enemigos de un tipo comparten puntero a vtable. Eso da un
método directo para encontrarlos a todos:

1. Anotá la vtable de un enemigo (primer `u32` de su objeto).
2. Escaneá esa vtable como valor exacto: cada resultado es un objeto de esa
   clase.
   ```bash
   python3 herramientas/escanear.py nuevo enemigos --tipo u32 --pedir
   python3 herramientas/escanear.py filtrar enemigos =0x01A2B3C4 --pedir
   ```
3. Matá uno y volvé a filtrar por `igual`: el que desaparece era ese.

De ahí salen: cuántos enemigos hay, dónde está la lista, y —siguiendo quién
escribe en esa lista— la rutina de spawn.

---

## Escalón 5 — Tablas estáticas

Es el escalón con mejor relación esfuerzo/resultado y por eso es el objetivo
de fondo del proyecto.

Las estadísticas de armas (daño, cadencia, cargador, dispersión) casi nunca
están sueltas: están en una **tabla** de N entradas contiguas del mismo tamaño,
cargada del disco o compilada en el ELF. Encontrar **una** entrada te da las
demás gratis, porque el patrón se repite.

Cómo se reconoce: volcá alrededor del valor y fijate si el mismo patrón de
campos se repite cada 0x20, 0x40 u 0x80 bytes. Si se repite, encontraste la
tabla. Anotá en `kb/estructuras.json` el tamaño de entrada y el offset de cada
campo, y a partir de ahí todas las armas se modifican con aritmética.

Como estas tablas suelen ser estáticas, los parches salen con
`cuando = "arranque"`, que es el tipo de parche más limpio que hay.

---

## Registrar antes de festejar

Un hallazgo sin anotar se pierde. El orden es siempre el mismo:

1. `kb/` — el dato, con `confianza` y `evidencia`.
2. `docs/03-bitacora.md` — una entrada arriba de todo: qué se buscó, qué se
   encontró, **y qué no funcionó**. Los callejones sin salida valen tanto como
   los aciertos: evitan repetirlos.
3. `mods/*.toml` — sólo cuando el dato está `confirmado`.
4. Commit y push.
