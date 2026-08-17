# Experimentos: cómo se prueba algo acá

Este documento es el compañero de `00-conops.md`. Aquél dice **qué** hay que
validar; éste dice **cómo**, y sobre todo cómo no engañarse.

---

## Las tres fallas de instrumento del 2026-08-17, y su arreglo

Ninguna de las tres fue un error de análisis. Las tres fueron el instrumento.

| falla | qué pasó | arreglo |
|---|---|---|
| **la muerte trunca la ventana** | se midieron 60 s de "jugador bajo fuego"; murió al segundo 55, y la condición B entera midió una pantalla de derrota | inflar la vida durante la medición: acá la vida **no es la vida, es un contador de impactos** |
| **condición inicial irrepetible** | "ponete cerca de dos tiradores" no vuelve a ser el mismo estado nunca | arrancar cada ventana cargando **el mismo savestate** |
| **n = 10** | con diez impactos por condición, cualquier diferencia entra en el ruido | alternar A/B/A/B y repetir |

Los tres están implementados en **`herramientas/experimento.py`**:

```bash
python herramientas/experimento.py campo-arma --slot 10 --offset 0x20 \
    --factor 0.2 --repeticiones 4 --segundos 40 \
    --predigo "si +0x20 son segundos entre balas, suben los impactos por minuto"
```

### Las cuatro reglas que la herramienta impone

1. **Verificar la precondición antes de escribir.** La tabla de armas vive en
   el heap. Antes de tocar 17 registros, se comprueba que el registro 2 sea el
   Magnum (`Range 1000 / Power 500`). Si no lo es, aborta. Una dirección que
   "casi siempre" está bien es la que un día no está.
2. **Alternar, no agrupar.** Nunca A,A,A y después B,B,B: si algo se degrada
   con el tiempo —enemigos que mueren, munición que se acaba— eso se lee como
   efecto del tratamiento.
3. **Predicción registrada ANTES de correr** (`--predigo`, va al informe). Una
   hipótesis formulada después de ver el resultado siempre acierta.
4. **Restaurar pase lo que pase.** El `finally` devuelve los valores
   originales aunque el experimento explote. La máquina no queda modificada.

### Cómo se lee el resultado

No por el promedio: por **la separación entre las medias medida en unidades de
dispersión**. Si control y tratamiento difieren menos de lo que varían entre
repeticiones, no hay resultado. La herramienta lo imprime y lo dice con esas
palabras.

---

## La batería que sigue, ordenada por lo que abre

### E1 · `+0x20` es `Time Between Bullets` — **CONFIRMADO 2026-08-17**

**Predicción, registrada antes de correr:** si `+0x20` son segundos entre
balas, el hueco **dentro** de la ráfaga cae y el hueco **entre** ráfagas
—cubrirse y recargar— queda igual.

**Diseño:** savestate slot 3 (jugador pegado a dos tiradores, vida ya inflada
en el propio estado), 4 repeticiones alternando A/B de 35 s.

| | control | ×0.2 | |
|---|---|---|---|
| hueco **dentro** de la ráfaga | 133.17 ms (±0.04) | **66.53 ms** (±0.08) | ×0.50, **555 dispersiones** |
| hueco **entre** ráfagas | 850 ms (±16) | 1017 ms (±96) | 1.5 dispersiones: **no supera el ruido** |
| impactos por ráfaga | 11.5 | 23.95 | ×2.08 |
| impactos por minuto | 270.9 | 408.4 | ×1.51 |

Réplicas: **158 · 157 · 158 · 159** impactos en control y **238 · 237 · 238 ·
240** en tratamiento. El savestate da una réplica casi determinista, y esa
reproducibilidad es la que permite afirmar algo con cuatro corridas.

**El control se comportó como control:** el hueco entre ráfagas no se movió
más allá del ruido. Si se hubiera movido, el efecto sería de otra cosa.

> **Y salió algo que no se buscaba: la cadencia está CUANTIZADA A FRAMES y
> tiene PISO.** `133.2 ms` son exactamente 4 frames a 30 fps y `66.6 ms` son 2.
> Se pidió un factor `0.2` y el motor entregó `0.5`. O sea que **este campo
> tiene un techo de dificultad de ~15 disparos por segundo**, y bajarlo más
> allá de dos frames no hace absolutamente nada. Un tunable con tope es una
> cosa que hay que saber antes de diseñar una curva de dificultad alrededor
> de él.

**Lo que la métrica ingenua habría dicho:** el primer intento midió *impactos
por minuto* y dio "sin diferencia", porque el volumen total lo gobierna el
ciclo de cobertura. La métrica equivocada no falsifica una hipótesis: mide
otra cosa y lo dice con cara de resultado.

### E2 · ¿Por qué el daño recibido es 4.50 y no 5.00?

Con `Power = 5` escrito en el ISO, los impactos a distancia media dieron
**exactamente 5.00**, y a quemarropa **4.50, con un mínimo de 1.90**. O sea que
el daño recibido **no es el `Power` pelado**: hay un factor que depende de algo
—distancia, zona de impacto, o el `falloff` de `+0x1C`—.

**Experimento:** dos savestates, uno lejos y uno pegado, mismo `Power`, medir
el tamaño del impacto en cada uno. Si el tamaño cambia con la distancia, el
responsable es la interpolación por `Range`/`falloff`; si no, es la zona.
**Qué abre:** la fórmula real del daño entrante, que es la mitad que falta del
modelo de dificultad.

### E3 · La regeneración de vida

Medida sin buscarla: **`+0.5` por tick, unos 3,6 por segundo**. Nunca estuvo
anotada en el proyecto y explica por qué el jugador se estabiliza en vez de
morir.

**Experimento:** buscar la constante `0.5` y el temporizador que la aplica
(`xref.py` sobre `0.5` en `.lit4`, y `stores` al offset `+0x2F8`).
**Qué abre:** subir la dificultad **sin tocar el daño** — un BLACK sin
regeneración es otro juego, y es un cambio de una constante.

### E4 · Cambiarle el arma a un enemigo

Idea de Fran. Cada tirador tiene su objeto de arma en `0x006DE770 + n*0x110`,
con el dueño en `+0x10` (ya establecido). Si ese objeto guarda un **índice a
los 17 registros**, escribirle otro índice le cambia el arma en el acto.

**Experimento:** volcar el objeto de arma de un enemigo conocido, buscar un
campo `0..16`, escribirle otro valor y mirar la pantalla. Con savestate de por
medio, es reversible y se puede repetir.
**Qué abre:** enemigos con RPG donde había pistolas, sin tocar el nivel.

### E5 · Sustituir un tipo de enemigo — **el truco del mismo largo**

Idea de Fran, y encaja perfecto con la restricción de parche in-place.

`STG_0001/STLEVEL.BIN` nombra las entidades **en texto plano**. En
`LEVELS/LEVEL_01/STG_0001/STLEVEL.BIN` hay 4 nombres `bc1_` distintos, 8
apariciones, y **los cuatro miden exactamente 11 caracteres**:

```
bc1_lr1_mil   bc1_rg1_mil   bc1_sk1_mil   bc1_so1_mil
      (x2)          (x2)          (x2)          (x2)
```

`bc1_rg1_mil` es **el del RPG**. Reemplazar `bc1_so1_mil` por `bc1_rg1_mil` es
**una escritura de 11 bytes sobre 11 bytes**: el archivo no cambia de tamaño,
el LBA no se mueve, la TOC no se toca. Es exactamente la operación que
`parche_iso.py` ya sabe hacer y que quedó verificada byte a byte.

**Predicción, y hay que decirla completa:** puede fallar, y el modo de falla
importa. Si el nombre es una clave a una tabla del mismo nivel, funciona. Si el
`.WDD`/`.DB` del modelo de ese enemigo no está cargado en ese nivel, va a
faltar el modelo — y ahí se aprende dónde vive la lista de recursos del stage,
que es lo que hace falta para meter algo nuevo.
**Qué abre:** cambiar la composición de un nivel sin herramientas nuevas. Es el
camino más corto a "remaster".

### E6 · Agudeza de la IA

Los nombres existen (`CEntityVisualAcuteness`, `CEntityHearingAcuteness`) pero
**Kynapse está linkeado y muerto** (ver `docs/07-ia-kynapse.md`): 0 de 182
metaclases inicializadas. Así que los valores hay que buscarlos en el código
propio de Criterion.

**Entrada barata:** `CShooterAgent` declara `GunRange` y `MaxInaccuracy` en
`0x00404458`. Antes de buscarlos en RAM, chequear si esos nombres están
referenciados por código, igual que se hizo con los de `Kaim`.

---

## Lo que no se hace más

- **Medir a ojo.** "Se siente más difícil" no entra en el repo. `vigilar.py`
  da el número.
- **Cambiar dos cosas a la vez.** El ISO parcheado tiene el daño en 5.0; por
  eso los experimentos de cadencia se hacen **en RAM**, que es reversible, y no
  encima del ISO ya modificado.
- **Concluir de una sola ventana.** Ni siquiera cuando el resultado gusta.
