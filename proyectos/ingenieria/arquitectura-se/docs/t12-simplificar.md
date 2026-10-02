# T12 — Simplificar la arquitectura: concepción (sin construir)

**2026-10-02.** Pedido de Fran después de aceptar la crítica: *«ingeniá vos la
simplificación, con los libros; yo aporto intuición; sensatez antes que
orgullo»*. Esto es la **concepción**: el problema, el criterio y los
candidatos como **hipótesis**. Lo diseña y lo decide la sesión T12; nada de
acá está medido todavía salvo lo marcado.

## 1. El problema

El método crece por acumulación: cada falla suma una regla, un hook, una línea
del cuadro o un medidor, y casi nunca se saca nada. **Medido el 2026-10-02:**
para editar un párrafo de `arquitectura-se` la puerta exigió releer ~37 K
tokens; el cuadro PARA VOS + el de fase van en **cada** respuesta, incluso en
una pregunta personal; la sesión del día se comió casi toda la ventana de 5 h
mayormente en el método, no en un proyecto.

## 2. El criterio, escrito antes de elegir

- **Lo que importa es el costo por unidad de valor**, no el costo solo. Tres
  presupuestos distintos, que no se suman (lección: «un costo que se paga una
  vez y uno que se paga por turno no van en el mismo total»): **por sesión**
  (lo inyectado al abrir), **por turno** (el recordatorio de cada mensaje, los
  cuadros), **por entrada a proyecto** (lo que exige la puerta).
- **Se saca o se poda si** su costo es alto y la falla contra la que fue
  diseñada **no reaparece** sin él, o la cubre otra pieza que mide el efecto.
  Un freno no se saca sin escribir contra qué impacto fue diseñado (regla 6).
- **Éxito de T12:** el costo por turno y por sesión baja de forma medible y,
  en las 5 sesiones de validación, no sube ninguna de las fallas que hoy se
  miden (cascada salteada, inyección cortada, correcciones de Fran por algo
  ya escrito).

## 3. Los libros que mandan (ya están en `perfil-global/pilares/`)

- **NASA, tailoring y matriz de cumplimiento** (`nasa-seh/tailoring.md`): la
  herramienta para **restar** requisitos con su justificación escrita. Cada
  regla y cada freno pasa por la matriz: se cumple, se recorta (con su resta)
  o se saca.
- **Rechtin & Maier** (`rechtin-maier/heuristicas.md`): «Simplify. Simplify.
  Simplify.» y las heurísticas de partición.
- **Saltzer, economía de mecanismo**: casi todo el mecanismo está en las capas
  que menos garantizan.
- **Meadows**: sacar una capa que no mueve nada es subir de nivel, no bajar.
- **Hunt & Thomas**: DRY y ortogonalidad (un dato o una regla en un solo lugar).

## 4. Candidatos, como HIPÓTESIS a medir (no decididos)

| # | Candidato | Por qué sospecho | Qué hay que medir antes |
|---|---|---|---|
| C1 | El recordatorio de **cada mensaje** (`recordatorio-transversal.md`) | Se paga por turno y repite lo que ya dicen `CLAUDE.md` y `apertura-proyecto.md` | Su tamaño exacto; si los cuadros se siguen poniendo con una versión de 10 líneas (fue diseñado contra cuadros sin formato: no se saca, se achica) |
| C2 | Los cuadros en respuestas que no tocan un proyecto | Una pregunta suelta paga ~25 líneas | Si una forma corta («sin cambios») alcanza para Fran |
| C3 | Las reglas del perfil con su historia adentro (la 10 ocupa una pantalla) | El porqué va al pilar; la regla, en una línea | Que el texto que queda siga cumpliéndose |
| C4 | Capas que dicen lo mismo: `arranque.md`, `CLAUDE.md`, `apertura-proyecto.md`, el recordatorio | DRY violado por el método mismo | Mapa de qué frase vive en cuántos lados |
| C5 | Lo que la puerta exige para `metodo` y `diseno` (~37 K) | Fichas enteras donde alcanzaría el índice | Si las sesiones usan lo leído (correcciones de Fran) |
| C6 | Filas del enrutador y estados largos (T3) | BLACK: 11 K en una fila, 121 K de estado | Ya medido en el diagnóstico (A2) |
| C7 | T11b entero | Suma 4 piezas más | Quedarse sólo con lo barato y con freno (el `--nivel` de la regla 15) |

## 5. Orden

1. Medir el peso real (por sesión, por turno, por entrada) con lo que ya
   existe (`medir-inyeccion.py`, `cascada_puerta.py --exige`) — no a ojo.
2. Matriz de cumplimiento de **todo el método**: cada pieza con su impacto
   original, su costo y su veredicto (cumple / recortada con resta / sale).
3. Podar en ese orden, con saboteador corrido después de cada poda: lo que
   frenaba tiene que seguir frenando.
4. De T11b, sólo lo que sobreviva.
5. Validar en 5 sesiones reales con `medir-cascada.py` y `medir-inyeccion.py`.
