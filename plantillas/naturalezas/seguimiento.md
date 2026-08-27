# Naturaleza: `seguimiento`

Un caso real que **evoluciona en el tiempo** y del que se toman mediciones
periódicas para decidir un ajuste: entrenamiento, dieta, un caso clínico
familiar, cualquier cosa donde el sistema medido es una persona o una
situación viva.

Se lee al entrar a cualquier proyecto de esta clase, antes del `PROYECTO.md`.

## Lo que define a esta naturaleza

Tres cosas que no aparecen en las otras dos:

- **El sistema tiene retardo largo.** Lo que se cambia hoy se ve en semanas.
- **La medición tiene ruido grande comparado con la señal.** Un dato aislado
  casi nunca significa nada.
- **Los datos son de una persona real**, y eso manda sobre dónde viven.

## Lo que se lee siempre

| Archivo | Por qué |
|---|---|
| `PROTOCOLO.md` | qué se está haciendo hoy, y desde cuándo |
| `ESTADO_ACTUAL.md` | dónde estamos, qué se ajustó la última vez y por qué |
| `registro/` (lo último) | los datos recientes, no la serie entera |

La serie histórica completa **no** se lee al abrir: se consulta cuando toca
decidir un ajuste, y ahí se mira la tendencia, no el último punto.

## Las cinco cosas que no se negocian

1. **En un sistema con retardo, reaccionar más rápido y más fuerte amplifica
   la oscilación.** Ante un resultado malo se aplica una **fracción** de la
   corrección, no la corrección entera: lo que se cambió la semana pasada
   recién está actuando. Acortar el tiempo de reacción empeora el problema; lo
   arregla alargarlo.

2. **Un punto no es una tendencia.** Nada se ajusta por una sola medición.
   Antes de tocar el protocolo: cuántos datos hay, en qué ventana, y si el
   cambio supera el ruido normal de esa medición.

3. **El período de ajuste se declara antes de empezarlo.** "Esto se sostiene
   N semanas y recién ahí se evalúa" se escribe **antes**, no cuando los
   números empiezan a no gustar. Es la puerta de la fase, igual que en
   ingeniería.

4. **Se mide lo que se decidió medir, siempre igual.** Misma hora, mismas
   condiciones, mismo instrumento. Una medición tomada distinto no es un dato
   peor: es un dato de otra serie, y mezclarlas fabrica tendencias que no
   existen.

5. **Los datos son personales y no salen de la máquina** salvo decisión
   explícita. La carpeta va en `.gitignore` del repo público, o el proyecto
   tiene su propio repo privado. Se decide **al crear el proyecto**, no
   después del primer push.

## La trampa propia de esta naturaleza

**Confundir adherencia con resultado.** "Cumplí el plan" es esfuerzo; "el
número se movió" es resultado. Un sistema medido por esfuerzo produce
esfuerzo. Las dos cosas se registran, pero el criterio de salida de una fase
es siempre el resultado — y si el plan se cumplió y el resultado no llegó, el
que está mal es el plan.

## Verificación y validación

- **Verificación:** ¿se está haciendo lo que el protocolo dice?
- **Validación:** ¿el protocolo sirve para lo que la persona realmente quería?

Alguien puede cumplir un plan a la perfección durante meses y que el plan
nunca haya apuntado a lo que le importaba. Cada revisión de fase pregunta las
dos, en ese orden, y la segunda en voz alta.

## Lo que este proyecto NO es

No es consejo médico ni sustituye a un profesional. Lo que se produce acá es
**registro, tendencia y protocolo**: los datos ordenados para que la persona
—y quien la atienda— decidan mejor. Cuando aparece algo fuera de rango o un
síntoma nuevo, la acción es consultar, no ajustar el protocolo.
