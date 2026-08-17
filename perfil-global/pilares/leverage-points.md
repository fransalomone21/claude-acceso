# Leverage Points — Donella Meadows (1999)

**Fuente:** `Leverage_Points.pdf`, 21 pp. Sustainability Institute, diciembre
1999. Versión corta en *Whole Earth*, invierno 1997.
**Leído entero el 2026-08-17.** Extraído con PyMuPDF a texto; control
positivo: los 12 encabezados numerados aparecen completos.

Ficha: los conceptos que **cambian una decisión** en nuestro sistema. Lo que
se entiende y no cambia nada no está acá. El pilar —lo que sube a la capa que
se lee sola— está al final.

---

## La tesis, en una frase

Un *leverage point* es un lugar de un sistema complejo donde **un cambio chico
produce un cambio grande en todo lo demás**. Existen, se pueden ordenar por
potencia, y —esto es lo importante— **son contraintuitivos**: la gente los
encuentra por instinto y después *empuja en la dirección equivocada*.

> "Time after time I've done an analysis of a company and figured out a
> leverage point […] Then I've gone to the company and discovered that
> there's already a lot of attention to that point. Everyone is trying very
> hard to push it in the wrong direction!" — Jay Forrester

Y el dato que más duele:

> "Probably 90 —no 95— no 99 percent of our attention goes to parameters, but
> there's not a lot of leverage in them."

Los parámetros son el **puesto 12 de 12**. El último.

---

## Los doce, de menor a mayor potencia — y qué es cada uno acá adentro

La columna de la derecha es el aporte de esta ficha: dónde está ese punto en
*nuestro* sistema (Fran + Claude + el repo + la máquina).

| # | Meadows | En nuestro sistema |
|---|---|---|
| **12** | Constantes, parámetros, números | qué modelo, qué effort, cuántos tokens, cuántos agentes, el tamaño de la ventana |
| **11** | Tamaño de los buffers respecto de sus flujos | el margen de contexto que se deja sin usar; el `--cuantas` de un digesto |
| **10** | Estructura de stocks y flujos físicos | la estructura de carpetas del repo, qué archivo carga qué, `kb/` vs `docs/` vs `sesiones/` |
| **9** | Longitud de los retardos, respecto de la velocidad de cambio | **cuánto tarda algo aprendido en estar disponible al abrir la sesión siguiente** |
| **8** | Fuerza de los lazos de realimentación negativa | `verify-install.ps1`, `pruebas/`, el chequeo de desactualización, el aviso de costo de los workflows |
| **7** | Ganancia de los lazos de realimentación positiva | la re-derivación: cuanto más contexto se quema, más hay que resumir, más se pierde, más hay que re-derivar |
| **6** | **Estructura de los flujos de información** | **los hooks.** Quién recibe qué, sin tener que pedirlo |
| **5** | Las reglas del sistema | los permisos, las validaciones, `pnach.py` negándose a compilar sin `version_activa` |
| **4** | El poder de agregar, cambiar y auto-organizar la estructura | `aprender.py` + `install.ps1`: el sistema modificándose a sí mismo |
| **3** | Las metas del sistema | el triángulo de hierro: costo, planning y performance **por encima** de velocidad de respuesta |
| **2** | El paradigma del que sale el sistema | "el repo es la memoria, el chat es efímero" · "confirmado = efecto visto" |
| **1** | El poder de trascender paradigmas | "si una lección nueva contradice a una vieja, se corrige la vieja: esto no es historial" |

---

## Hallazgo 1 — la escalera de la lección 11 ya era esta lista, cortada

La lección 11 (*una regla que depende de recordarla no es una regla*) tiene
una tabla de mecanismos ordenados por confiabilidad:

| Nivel | Mecanismo | Meadows |
|---|---|---|
| 1 | skill de consulta | información que existe y **no fluye** al punto de decisión |
| 2 | línea en `CLAUDE.md` | flujo de información pasivo |
| 3 | **hook** | **#6 — estructura de los flujos de información** |
| 4 | permiso denegado / validación | **#5 — las reglas del sistema** |

Se derivó sola, empíricamente, a fuerza de repetir un error dos sesiones
seguidas. Y coincide con la lista de Meadows en el tramo que cubre. Pero
**termina en el #5**: no tiene los tres escalones de arriba.

Lo que falta, y ahora tiene nombre:

| Nivel | Mecanismo | Meadows | Ejemplo real de este repo |
|---|---|---|---|
| 5 | **auto-organización** | #4 | `aprender.py` + el chequeo de `install.ps1`: el perfil ahora puede escribir sus propias reglas y detectar cuándo la síntesis quedó vieja |
| 6 | **la meta** | #3 | el triángulo de hierro. Cambiar la meta reordena todo lo de abajo sin tocarlo |
| 7 | **el paradigma** | #2 | "el repo es la memoria" no es una regla: es de dónde salen las siete reglas |

Y la de Meadows sobre el #6 explica **por qué el hook funcionó** cuando la
skill no, mejor que como estaba escrito. Su ejemplo es el medidor eléctrico:
casas idénticas, precio idéntico, la única diferencia era si el medidor estaba
en el sótano o en la entrada, a la vista. **30% menos de consumo** en las de la
entrada.

> "It's not a parameter adjustment, not a strengthening or weakening of an
> existing loop. It's a new loop, delivering information to a place where it
> wasn't going before."

El hook `SessionStart` es el medidor mudado a la entrada. La skill de consulta
era el medidor en el sótano: la información estaba, completa y correcta, y no
llegaba al lugar donde se decide.

**Qué cambia:** ante una regla que se incumple, la pregunta deja de ser "¿cómo
la escribo más fuerte?" y pasa a ser, en este orden: *¿falta un flujo de
información (#6)? ¿falta una regla dura (#5)? ¿o lo que está mal es la meta
(#3)?*. Subir el volumen es #12 disfrazado.

---

## Hallazgo 2 — el documento del pipeline era, casi entero, el punto 12

Esto es incómodo y es el hallazgo más útil de la lectura.

El documento externo que se auditó esta misma sesión
(`referencias/auditoria-pipeline-metadev.md`) proponía: perfiles de esfuerzo,
ahorro de tokens, un bloque de telemetría por respuesta, umbrales de
saturación, elección de modelo. **Todos son parámetros: el puesto 12 de 12.**
Bien pensados, bien escritos, y en el escalón de menos apalancamiento que
existe.

Los dos ítems que sí eran nuevos y se adoptaron son justamente los que no son
parámetros: la autocalibración por fallo observado es **#8** (fortalecer un
lazo de realimentación negativa), y la jerarquía `Fundamentos → Pipeline →
Ejecución` que Fran propuso al final es **#2, el paradigma** — y es, de todo
lo que llegó, lo único de máximo apalancamiento.

Meadows lo predice con precisión: el 99% de la atención va a los parámetros, y
la gente encuentra el punto correcto y empuja para el lado que no es. La
versión nuestra de "empujar para el lado equivocado": *optimizar cuántos
tokens gasta una sesión, cuando el problema es que el conocimiento no llega
del final de una sesión al principio de la siguiente*. Eso último es **#9, un
retardo** — y hasta hoy, para todo lo que no fuera BLACK, ese retardo era
infinito.

**Qué cambia:** ante una propuesta de mejora —venga de un documento, de Fran o
mía— ubicarla en la lista **antes** de evaluarla. Si cae del 12 al 10, el
techo del beneficio ya está puesto, por bien argumentada que esté. La pregunta
no es "¿esto es una buena idea?" sino "¿en qué escalón está?".

---

## Hallazgo 3 — el freno que se saca porque "no se usa nunca"

Meadows, sobre el #8:

> "One of the big mistakes we make is to strip away these 'emergency' response
> mechanisms because they aren't used often and they appear to be costly. In
> the short term, we see no effect. In the long term, we drastically narrow
> the range of conditions over which the system can survive."

Esto ya nos pasó, textual: `skipWorkflowUsageWarning: true` estaba silenciando
el aviso de costo de los workflows del propio sistema. Había un freno y estaba
desconectado (lección 11). El síntoma fue exactamente el que describe: a corto
plazo, ningún efecto visible; el costo apareció después, en forma de dos
fan-outs de ~600k tokens combinados.

**Qué cambia:** un chequeo que "nunca salta" no es un chequeo inútil — es un
lazo de realimentación negativa inactivo, que es lo normal en un lazo de
emergencia. Antes de sacar un aviso, un test lento o una validación molesta,
preguntarse **contra qué impacto fue diseñado**, no cuántas veces saltó.

Corolario nuevo, del mismo párrafo: la fuerza del lazo negativo tiene que ser
**relativa al impacto que corrige**. Si el impacto crece, el freno tiene que
crecer con él. Un `verify-install.ps1` que alcanzaba con dos hooks tiene que
crecer cuando hay tres — y de hecho creció solo, porque itera sobre los
comandos que encuentra. Eso fue suerte de diseño; ahora es criterio.

---

## Los puntos que todavía no tenemos cubiertos

Honestidad sobre el mapa: hay escalones donde nuestro sistema no tiene nada, y
conviene saber cuáles.

- **#9, retardos.** Se acortó hoy el peor (lo aprendido → disponible al abrir),
  pero queda otro sin medir: el retardo entre que una herramienta se rompe y
  que alguien se entera. `verify-install.ps1` sólo corre si se lo invoca.
- **#7, ganancia de los lazos positivos.** El lazo de re-derivación
  (más contexto quemado → más resumen → más pérdida → más re-derivación) no
  tiene ningún freno explícito salvo el criterio de "chat nuevo". Meadows es
  clara: **bajar la ganancia de un lazo positivo apalanca más que fortalecer
  los negativos**. Traducido: cortar el chat a tiempo vale más que escribir
  mejores resúmenes.
- **#3, la meta.** El triángulo de hierro es una meta *declarada*. Meadows
  advierte que la meta real de un sistema no se deduce de lo que alguien dice
  sino **de lo que el sistema hace**. Lo que este sistema hace, medido por sus
  artefactos, sigue siendo mayormente *resolver el problema de hoy*. La meta
  declarada por Fran —*diseñar sistemas que resuelven problemas*— todavía no
  está escrita en ningún lado como meta. Ese es el hueco de mayor
  apalancamiento que queda abierto, y se cierra en la sesión de integración.

---

## Advertencias de la propia autora, que valen para no sobreactuar esto

1. **La lista es tentativa y el orden resbaladizo.** *"Every item has
   exceptions that can move it up or down."* No es un algoritmo.
2. **Los parámetros importan** cuando entran en rangos que disparan un ítem
   más arriba de la lista. Una tasa de interés es un parámetro *y* controla la
   ganancia de un lazo positivo. Nuestro caso: el porcentaje de ventana
   consumida es un parámetro, y pasado cierto punto dispara el lazo positivo
   de re-derivación.
3. **Cuanto más alto el punto, más resiste el sistema el cambio.** No hay
   pasajes baratos. Un cambio de paradigma en una persona puede tardar un
   milisegundo; en un sistema con historia, no.
4. Meadows aclara que tener la lista años en la cabeza no la convirtió en
   Superwoman. Sirve para **ubicar** una intervención, no para producirla.

---

## El pilar — lo que sube a la capa que se lee sola

Tres líneas, y nada más. El filtro fue: ¿cambia una decisión concreta que se
toma seguido?

1. **Antes de proponer una mejora, ubicarla en la escala.** Parámetros
   (modelo, effort, tokens, cuántos agentes) son el escalón más bajo que
   existe. Flujos de información, reglas, auto-organización, metas y
   paradigma están por encima, en ese orden.
2. **Una regla que se incumple no se escribe más fuerte: se le agrega el flujo
   de información que falta.** El medidor eléctrico en la entrada, no en el
   sótano.
3. **Un freno que nunca salta no es inútil: es un lazo de emergencia.** Antes
   de sacarlo, preguntar contra qué impacto fue diseñado.

Lo que **no** sube, y por qué: los stocks y flujos, los buffers, la teoría de
la bañera, el ejemplo del NAFTA y toda la parte política. Son lo que hace
entender el resto, y no cambian ninguna decisión de mañana. Están en esta
ficha, que es donde tienen que estar.
