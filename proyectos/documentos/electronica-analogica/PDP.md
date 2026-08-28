# PDP — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

> Escrito el **2026-08-28**, con el proyecto ya en curso. Esto incumple la
> regla —el PDP se escribe *antes* de la primera línea de trabajo— y por eso se
> anota acá y no se disimula: lo que sigue es una **reconstrucción medida
> contra `ESTADO_ACTUAL.md` y `HANDOFF.md`**, no un plan escrito de antemano.
> De acá en adelante sí manda: el criterio de salida de la fase en curso vive
> en este archivo y no en el handoff.

## 1. El problema

El apunte oficial de la cátedra (`AEA_Conceptos.pdf`, Prof. Esteban Lemos, 42
pág.) **está incompleto a partir de la sección 7**: «El diodo», «El relé» y «El
transistor bipolar» son títulos sin contenido. En los hechos, **todo el segundo
cuatrimestre de la materia no tiene material escrito**. Y el temario de la
cátedra y las guías de TP no coinciden entre sí, así que ni siquiera juntando
los dos queda cubierto lo que se cursa.

**Para quién es:** primero el **docente**, que es quien decide si el apunte se
adopta; en segundo lugar los alumnos de 4.º año de la E.E.S.T. N.º 1 de Vicente
López. No es un apunte personal de estudio: eso cambia el rigor, y es la razón
de que la aritmética de cada ejercicio se compruebe por dos caminos.

**Cómo sabremos que sirvió (validación):** PENDIENTE de medir. Que compile y
que se vea bien es *verificación*, no validación. La pregunta abierta es si el
docente lo adopta y si el alumno entiende con él lo que no entendía sin él. El
único dato de validación que hay hasta hoy es indirecto y vale: **el alumno
reportó que la parte de nodos costaba**, y de ahí salió la reescritura
didáctica del Módulo 8 (2026-08-28). Ese canal —el alumno diciendo qué cuesta—
es la vía de validación real, y hay que usarla en vez de suponer.

## 2. Qué NO es

- **No reordena la Parte I.** Los módulos 1 a 6 siguen el orden del temario y
  de las guías de TP, y cada uno cierra con su práctico. Alterar la secuencia
  rompe la correspondencia con el laboratorio.
- **No reemplaza a las guías de TP** ni al apunte oficial: los cita.
- **No incluye simulación** todavía. El marco didáctico de Teoría de Circuitos
  pide tres perspectivas por concepto (teoría, simulación, experimento) y este
  apunte hoy cubre una y media. La simulación entra recién en la Fase 3.
- **No se le agregan temas «por las dudas».** El criterio, tomado el
  2026-08-28: el tratamiento didáctico extra —convenciones y ejemplo chico
  antes de la regla general— se le da a un módulo **cuando el alumno reporta
  que cuesta**, no preventivamente.
- **No se toca el toolchain.** Typst y nada más; CircuiTikZ ya se descartó por
  obligar a instalar LaTeX y a mantener un segundo toolchain.

## 3. Naturaleza y criticidad

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |
| Criticidad | `importante` |
| Rigor que le corresponde | test + evidencia registrada + reversible. Los cinco chequeos de `verificar.py` corren antes de cerrar, y **ninguna figura ni página nueva se da por buena sin mirarla en render**: que compile no prueba que se vea bien. La aritmética de cada ejercicio se comprueba por un **segundo camino independiente**. |

> Es `importante` y no `crítico` porque nada se pierde de forma irrecuperable
> —el fuente está versionado y el PDF se recompila—, pero un error publicado lo
> estudia un curso entero, y eso cuesta más que unas horas.

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Estado |
|---|---|---|---|
| 0 | Parte I — módulos 1 a 6 (dispositivos) | los seis módulos escritos, cada uno atado a su TP, y el apunte compila | **cerrada** |
| 1 | Parte II — módulos 7 a 13 (el método, en el orden de Teoría de Circuitos) | los siete módulos escritos, con la aritmética de cada ejercicio comprobada por un segundo camino | **cerrada** |
| 1b | Las figuras | cero circuitos en ASCII en todo el apunte (`ASCII_PENDIENTE` vacía y borrada), y las figuras miradas en una pasada **completa** de la galería posterior al último retoque | **cerrada 2026-08-23** |
| 2 | Convenciones y fasor en valor de pico | el bloque de convenciones al frente del apunte, el Módulo 11 convertido a pico con la equivalencia a eficaz publicada al lado, y los ejercicios recomprobados por dos caminos | **cerrada 2026-08-25** |
| 2b | Módulo 8 didáctico | convención explícita → ejemplo chico resuelto a mano → recién ahí la generalización, en los dos métodos; páginas nuevas miradas en render | **cerrada 2026-08-28** |
| 3 | Los temas que faltan del programa | ver abajo, «qué la cierra exactamente» | **EN CURSO** |
| 4 | El anexo de informes técnicos | el anexo publica los criterios de la guía de la cátedra —nada de capturas de pantalla, gráficos procesados por software (la guía nombra Veusz, Octave, Python, GNU Plot y Matlab), ejes rotulados con unidades, leyenda adentro de la figura, símbolos para mediciones y líneas para simulaciones, figuras numeradas con descripción al pie, A4 con páginas numeradas, máximo 10 páginas— y los gráficos del propio apunte los cumplen | pendiente |

> La ex-«Fase 4 — Las figuras de la Parte II» del `HANDOFF.md` **ya está
> cumplida** por la fase 1b: la lista `ASCII_PENDIENTE` llegó a cero el
> 2026-08-23. Lo único que sobrevive de aquella fase es la decisión de
> herramienta —los gráficos **cuantitativos** nuevos (Bode con décadas reales,
> plantillas de Butterworth, mapas de polos y ceros) van en **matplotlib**
> exportado a SVG, porque cetz-plot no hace bien los ejes logarítmicos;
> cetz-plot se queda para las curvas cualitativas—, y eso se aplica adentro de
> la Fase 3. El plan de fases del handoff quedó viejo justo ahí: por eso vive
> acá ahora.

**Fase en curso: 3 — Los temas que faltan.** En el orden del programa de Teoría
de Circuitos (Prof. Gabriel Sanca, Ing. en Sistemas Espaciales, UNSAM):

1. sistemas trifásicos (estrella y triángulo, tensiones de fase y de línea,
   potencias);
2. la forma zpk y los polos y ceros en el plano complejo, con la relación
   unívoca entre la posición de los polos, ζ y Q;
3. la respuesta en frecuencia del RLC serie según de dónde se tome la salida;
4. el amplificador diferencial y el de instrumentación;
5. filtros activos: Butterworth de orden N, Sallen-Key, ganancia unitaria y
   diseño por plantillas;
6. la impedancia reflejada del transformador y los equivalentes serie y
   paralelo;
7. la simulación como tercera pata.

**Qué la cierra, exactamente:**

1. Los **siete temas** de esa lista están escritos en el apunte.
2. Cada uno tiene **al menos un ejercicio resuelto**, con su resultado
   comprobado por un **segundo camino independiente** (balance de potencias, el
   otro método de resolución, o sustitución en las ecuaciones originales).
3. `python verificar.py` da los **cinco chequeos en verde**.
4. **Todas las páginas nuevas se miraron en render**, no sólo compiladas — y
   las figuras nuevas, en una pasada completa de la galería *posterior* al
   último retoque.

Se contesta sí o no, tema por tema. Un tema escrito sin ejercicio comprobado no
cuenta como escrito.

**Pendiente explícito que no pertenece a ninguna fase y no se puede perder:**
la **pasada de lectura eléctrica** sobre las **46 figuras** de la biblioteca
(número medido el 2026-08-28 contando los `fig-*` y `graf-*` de
`apunte/biblioteca/`; `ESTADO_ACTUAL.md` todavía dice 45 y está desactualizado).
Las figuras están verificadas *de legibilidad* —rótulos cruzados, guías encima
del texto, curvas pisando etiquetas— y **nunca se les preguntó si el circuito
es correcto**. Son dos verificaciones distintas y sólo se hizo una: el puente de
Graetz tenía un diodo al revés, compilaba perfecto, se veía prolijo, y lo
encontró Fran mirándolo — no ninguno de los cinco chequeos.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Una figura es legible y **eléctricamente incorrecta** | alta — ya pasó con el puente de Graetz | alta: se publica un error a un curso entero | mitigar con la pasada de lectura eléctrica de las 46, siguiendo la corriente y chequeando polaridades y sentidos | cualquier figura con semiconductores o fuentes que todavía no haya pasado esa pasada |
| Un defecto **sólo visible en render** se publica | alta — ya pasó una quincena de veces | media | mitigar: ninguna página nueva se cierra sin mirarla compilada | un cambio que toca `plantilla.typ`, el anexo, o una fórmula larga |
| El contenido se deriva de una **fuente equivocada** | media — ya pasó: la ficha web decía otra carrera y otro cuatrimestre | alta: se escribe el apunte para el programa que no es | mitigar: el contenido se contrasta contra los documentos de la cátedra, nunca contra la web | un tema nuevo cuya fuente no sea un documento que Fran haya aportado |
| Los chequeos de `verificar.py` **se oxidan** y dejan de discriminar | media | media | vigilar: cada chequeo se prueba rompiéndolo cuando se lo toca | un chequeo que nunca se vio en rojo |
| El apunte **no se adopta** y el trabajo queda sin usar | PENDIENTE de estimar | alta | vigilar: es el riesgo de validación, no de verificación | que pase un cuatrimestre sin que el docente lo mire |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| (inicio) | Fuente única en **Typst**, compilada a PDF | LaTeX; Word | Typst no pide un segundo toolchain y compila en un comando |
| (figuras) | `zap` + `cetz-plot` sobre `cetz`, **adentro de Typst** | CircuiTikZ | obligaba a instalar LaTeX y a mantener un paso de conversión por figura |
| 2026-08-23 | Los gráficos **cuantitativos** van en **matplotlib** exportado a SVG, con la tipografía del apunte reescrita en el SVG | cetz-plot para todo | cetz-plot no hace bien los ejes logarítmicos |
| 2026-08-23 | La Parte II sigue el orden de **Teoría de Circuitos** y no reordena la Parte I; los cruces se resuelven por referencia y no por repetición | fundir las dos partes en una sola secuencia | rompía la correspondencia de la Parte I con el laboratorio |
| 2026-08-23 | **Fasor en valor de pico** por defecto, con la conversión a eficaz publicada al lado | eficaz por defecto | es la convención de los cuatro libros de la cátedra (Nilsson-Riedel primero) |
| 2026-08-23 | Se adopta la **notación de la cátedra** ($R_m$, $I_m$, $R_S$, $R_M$) | la notación propia | si no, el alumno estudia con dos idiomas distintos |
| 2026-08-28 | El tratamiento didáctico extra se le da a un módulo **cuando el alumno reporta que cuesta** | dárselo a todos los módulos preventivamente | es trabajo caro y sin señal; el canal del alumno es el único dato de validación que hay |
| 2026-08-28 | **El plan de fases vive en este PDP**, y el `HANDOFF.md` apunta acá | mantenerlo escrito en el handoff | ya había divergido: el handoff seguía pidiendo los 15 circuitos en ASCII que se habían eliminado cinco días antes |

## 7. Verificación

**Cómo se verifica cada entregable:**

```bash
cd apunte && typst compile apunte.typ apunte.pdf          # que compile
cd apunte && python verificar.py                          # los cinco chequeos
typst watch biblioteca/galeria.typ biblioteca/galeria.pdf # mirar las figuras sin compilar todo
```

Los cinco chequeos: que el apunte compile; que la galería compile; que no quede
**ningún** circuito en ASCII; que toda figura de la biblioteca esté en la
galería (una figura que nadie mira se rompe sin que se entere nadie); y que
ningún rótulo de más de 18 caracteres haya quedado adentro de un
`plot.annotate`.

Y por encima de los cinco, las dos cosas que ninguna alarma hace: **mirar el
render** y **comprobar la aritmética por un segundo camino**.

**Qué se registra de cada verificación:** qué páginas se miraron y sobre qué
versión; qué chequeo se probó rompiéndolo esta vez; el resultado por requisito;
y **los defectos y límites detectados** — que es la parte que siempre se omite y
la que más vale después. `ESTADO_ACTUAL.md` la lleva.

**El verificador, ¿alguna vez falló?** Sí, y está anotado:

- El chequeo 3 (ASCII) se probó metiendo ASCII nuevo en un módulo de la Parte I:
  rojo, y verde al sacarlo.
- El chequeo 5 (rótulos largos) se probó con un rótulo de 27 caracteres adentro
  de un `plot.annotate`: rojo, y verde al restaurar. Y **encontró solo** un
  rótulo de 32 caracteres en `graf-respuesta-rc`, una figura que la sesión
  anterior daba por bien resuelta.
- El chequeo «toda figura de la biblioteca está en la galería» se probó el
  2026-08-28 sacando `fig-nodal-primero` de `galeria.typ`: rojo nombrando la
  figura, y verde al restaurarla.
- La alarma del script de Bode —abortar si no reescribe ninguna familia
  tipográfica en el SVG— **saltó de verdad** en el primer intento, porque
  matplotlib pone los nombres entre comillas simples.

**Y el caso que muestra el límite de todo lo anterior:** durante días
`ESTADO_ACTUAL.md` afirmó «las 30 figuras se ven bien, confirmado por render».
Era falso: la pasada del 2026-08-23 encontró ocho defectos en la Parte I, todos
previos a esa sesión. La afirmación equivocada quedó **tachada y no borrada** en
el estado, porque es el dato: es lo que hizo que la sesión siguiente no las
mirara.
