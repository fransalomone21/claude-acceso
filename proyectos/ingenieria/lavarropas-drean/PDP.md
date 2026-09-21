# PDP — Lavarropas Drean Next 6.06 ECO

**Abierto:** 2026-09-21

## 1. El problema

El lavarropas de casa hace un ruido fuerte al girar el tambor, y el ruido
**fue creciendo con el tiempo**. Hay que saber qué es antes de gastar, y
arreglarlo si se puede arreglar en casa.

**Para quién es:** Fran y su papá, trabajando los dos sobre la máquina. Eso
sube el rigor de la **guía** (tiene que poder ejecutarse sin la sesión
presente) y baja el de la documentación interna.

**Cómo sabremos que sirvió (validación):** la máquina lava una carga normal sin
el ruido, y **el cubo de la polea queda seco después del ciclo**. Las dos
cosas. Sin la segunda, se cambiaron rulemanes y se dejó puesta la causa.

## 2. Qué NO es

- **No es un proyecto de mantenimiento de electrodomésticos.** Es esta máquina,
  esta falla.
- **No incluye la placa electrónica** ni códigos de error: la falla es mecánica
  y audible.
- **No incluye el desarme si el eje resulta estar picado ni si el bidón resulta
  estar soldado** — en esos dos casos el proyecto entrega el presupuesto y la
  decisión, no la reparación.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` diagnóstico (los 7 tests) | se rehace gratis | alta: no sabemos qué falla | iterar corto y medir | Girar el tambor a mano cuesta cero y se puede repetir. El default más bajo alcanza |
| `b` compra de repuestos | un solo tiro (plata gastada) | baja, **una vez cerrado `a`** | pleno | Comprar antes de tener el rulemán viejo en la mano es el error de este dominio |
| `c` desarme (polea, eje, rulemanes) | un solo tiro | baja | pleno | La polea es de plástico y se parte; la punta del eje se aplasta. Nada de eso se deshace |
| `d` apertura del bidón, si es soldado | irreversible | **alta** — no sabemos si se abre | pleno + presupuesto externo antes | No hay prototipo posible. La única mitigación es medir (mirar el perímetro) antes de cortar |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Identificación y plan de diagnóstico | Cada causa candidata tiene un test cuyo resultado **negativo la descarta** | Recorrer la tabla de §2 de la guía: si alguna causa no tiene test que la elimine, la fase no cierra | **cerrada** |
| 1 | Diagnóstico medido | Los 7 tests corridos sobre la máquina, anotados, y **al menos una causa descartada por evidencia** | La tabla de resultados llena en `ESTADO_ACTUAL.md` §Lo confirmado. Si todas dan positivo, el diagnóstico no discriminó y la fase sigue abierta | **abierta** |
| 2 | Decisión de reparación | Sabido: (i) si el bidón se abre, (ii) si el eje está liso o picado, (iii) el número grabado del rulemán viejo | Los tres datos anotados literales. El (iii) se certifica con el número, no con "es un 6203" de memoria | pendiente |
| 3 | Reparación | Tambor gira suave a mano **y** ciclo completo sin ruido **y** cubo de la polea seco después del ciclo | Los 4 pasos de §5 de la guía, en ese orden | pendiente |
| 4 | Auditoría del éxito | 10 lavados normales sin ruido y sin humedad en el cubo, **y** escrito cuál de las cosas que se tocaron lo arregló | Conteo de lavados + la línea escrita. Si no se puede escribir cuál fue, la fase no cierra | pendiente |

**Fase en curso:** 1 — Diagnóstico medido.

**Qué la cierra, exactamente:** que estén anotados los resultados de T1 a T7 y
que **alguna** de las causas de la tabla de lectura haya quedado descartada por
un test negativo.

**Cómo se certifica:** Fran y su papá corren los tests con la máquina
desenchufada y anotan el resultado de cada uno en `ESTADO_ACTUAL.md`. El
medidor **en rojo** se ve así: si T1 (girar el tambor a mano) da *suave y
silencioso* y aun así se compra el kit de rulemanes, la fase se cerró en falso.

**La fase también puede CANCELARSE, y eso no es un fracaso.** Si T6 encuentra
una moneda entre el tambor y el bidón y el ruido se va al sacarla, las fases 2
y 3 dejan de hacer falta enteras. Ese es el mejor resultado posible del
proyecto y hay que estar dispuesto a aceptarlo sin haber comprado nada.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| El bidón viene soldado por ultrasonido | media | alta (cambia el costo de $20k a bidón completo) | vigilar y medir **antes** de comprar | El perímetro del bidón no tiene corona de tornillos ni grampas |
| El eje está picado donde apoya el retén | media | alta (el retén nuevo pierde igual en meses) | medir en el paso D, presupuestar antes de comprar | Se siente un surco o escalón pasando la uña por el eje |
| Se parte la polea de plástico al sacarla | media | media (repuesto extra + demora) | evitar: extractor o taco de madera, nunca palanca | Crujido al hacer fuerza |
| Se compra el kit equivocado | alta si se salta el paso G | media | evitar: comprar **después** de tener el rulemán viejo | Se está por comprar y nadie leyó un número grabado |
| El ruido resulta ser el motor | baja | media | T4 lo separa antes de abrir nada | El ruido áspero está en el eje del motor y no en el tambor |
| Alguien enchufa con la tapa sacada | baja | **muy alta** (220 V + resistencia de 1500 W) | evitar: desenchufar y dejar el cable a la vista | — |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-09-21 | Diagnosticar con 7 tests físicos antes de comprar nada | Comprar el kit de una y probar | El kit sale ~$20k y no descarta amortiguadores, objeto atrapado ni motor. Además el desarme es irreversible |
| 2026-09-21 | La guía va en Markdown en `docs/`, no en PDF | PDF con Typst | Se lee en el celular al lado de la máquina; el PDF agrega un paso de compilación y no agrega nada al uso |
| 2026-09-21 | Las medidas de rodamiento van con la advertencia de que son de la línea Blue/Excellent | Dar 6203/6204 como si fueran del Next 6.06 | No se pudo leer la ficha del kit específico del Next 6.06. Darlo por confirmado sería reportar un escalón más arriba de lo medido |

## 7. Verificación

**Cómo se verifica cada entregable:**

- *La guía* — se verifica por **ejecutabilidad**: Fran y su papá tienen que
  poder correr los 7 tests sin preguntar nada. Si aparece una pregunta, la guía
  tiene un hueco y se corrige ahí.
- *El diagnóstico* — se verifica por **discriminación**: un diagnóstico que no
  descarta nada no es un diagnóstico.
- *La reparación* — se verifica por **efecto y no por precondición**: el test
  no es "pusimos rulemanes nuevos", es "gira suave, no hace ruido y el cubo
  queda seco".

**Qué se registra de cada verificación:** resultado de T1–T7 con fecha, el
número grabado del rulemán, si el bidón se abre, si el eje estaba liso, y las
deficiencias que hayan quedado (por ejemplo: "los amortiguadores también están
gastados pero no se cambiaron").

**El verificador, ¿alguna vez falló?** Todavía no, **y eso es exactamente lo
que lo deja sin verificar.** El control negativo disponible y barato: girar el
eje del motor (T4) y una rueda cualquiera que se sepa sana — si T1 "detecta"
rugido en las dos, el test no discrimina y el oído no está calibrado. Se hace
**antes** de confiar en T1, no después.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `a` | `cumple` | |
| `CLAUDE.md §Las reglas #2` (el éxito se audita) | `c` | `cumple` | Es la fase 4 |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `a` | `recortado` | **Resta:** T5 (amortiguadores) y T7 (óxido) no tienen control negativo barato: ponerlos en rojo a voluntad exigiría dañar la máquina. Se acepta el recorte y se compensa **cruzándolos**: ninguno de los dos decide solo — sólo suman a un veredicto que T1/T2/T3 ya sostienen. El riesgo que se crea es un falso positivo de amortiguadores, que cuesta el par de amortiguadores; el riesgo que compraría hacerlo bien no justifica romper una máquina que funciona |
| `CLAUDE.md §Las reglas #4` (el repo es la memoria) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #6` (cambios mínimos) | `c` | `cumple` | No se toca la placa, ni el fuelle, ni la bomba, salvo que un test los señale |
| `plantillas/naturalezas/ingenieria.md` §Las cinco cosas #1 (confirmado = intervine y vi el efecto) | `a` | `cumple` | |
| `plantillas/naturalezas/ingenieria.md` §Lo que se lee siempre (bitácora) | `a` | `cumple` | `docs/bitacora.md` |
