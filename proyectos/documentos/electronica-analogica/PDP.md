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

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |

> **Migrado el 2026-09-22 al molde nuevo (piezas P3 y P4 de `arquitectura-se`).**
> Antes decía «Criticidad: `importante`» y de ahí salía un rigor único para
> todo el proyecto. Eso es justo lo que NASA p. 39 desaconseja: el tailoring
> va **por aspecto**, porque en este mismo proyecto reescribir un párrafo es
> gratis y publicar un PDF con un circuito mal dibujado no se deshace.

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` contenido y aritmética | se rehace gratis (fuente versionada) | baja: el temario y las dos guías de TP están escritos | mínimo: directo, **más el segundo camino** | El texto se corrige y se recompila. La aritmética lleva el agregado porque su error *no se ve*: un número mal compila igual, se imprime igual y se estudia igual |
| `b` figuras de circuito | se rehace gratis (son código) | baja | **pleno** | Es el único aspecto donde el rigor sube por encima de lo que los dos ejes piden, y no es «por las dudas»: una figura legible y **eléctricamente incorrecta** ya se publicó una vez (`fig-puente-graetz`, corregida el 2026-08-25) y los cinco chequeos la dieron por buena. Toda figura con semiconductor u operacional pasa por recorte de pixel |
| `c` publicación del PDF | **un solo tiro**: lo que se publicó, se estudió | baja | **pleno** | El costo de deshacer no es el del archivo, es el del lector. Ninguna página se cierra sin haberla mirado compilada |
| `d` cobertura de las guías de TP | se rehace gratis | **alta**: no se sabía qué faltaba hasta medirlo | iterar corto y medir el efecto | Se creía cubierta y la primera medición encontró seis consignas sin sección que las respondiera. Lo que corresponde no es más rigor sino **un medidor**, y es `verificar-cobertura.py` |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Parte I — módulos 1 a 6 (dispositivos) | los seis módulos escritos, cada uno atado a su TP, y el apunte compila | `typst compile apunte.typ` y la lista de los seis módulos en `ESTADO_ACTUAL.md` | **cerrada** |
| 1 | Parte II — módulos 7 a 13 (el método, en el orden de Teoría de Circuitos) | los siete módulos escritos, con la aritmética de cada ejercicio comprobada por un segundo camino | el segundo camino escrito **dentro** del ejercicio. En rojo se ve así: un ejercicio cuyo resultado aparece sin verificación al lado | **cerrada** |
| 1b | Las figuras | cero circuitos en ASCII en todo el apunte (`ASCII_PENDIENTE` vacía y borrada), y las figuras miradas en una pasada **completa** de la galería posterior al último retoque | chequeo 3 de `python verificar.py`, probado rompiéndolo | **cerrada 2026-08-23** |
| 2 | Convenciones y fasor en valor de pico | el bloque de convenciones al frente del apunte, el Módulo 11 convertido a pico con la equivalencia a eficaz publicada al lado, y los ejercicios recomprobados por dos caminos | las páginas del Módulo 11 miradas en render, no sólo compiladas | **cerrada 2026-08-25** |
| 2b | Módulo 8 didáctico | convención explícita → ejemplo chico resuelto a mano → recién ahí la generalización, en los dos métodos; páginas nuevas miradas en render | las páginas nuevas miradas una por una | **cerrada 2026-08-28** |
| 3 | Los temas que faltan del programa | ver abajo, «qué la cierra exactamente» | ver abajo, «cómo se certifica» | **abierta** |
| 3b | Cobertura medida de la guía del II cuatrimestre | toda consigna de `fuentes/consignas-tp.md` con una sección del apunte que la responda, o una excepción declarada con motivo | `python verificar-cobertura.py` en verde **y** `python probar-verificar-cobertura.py` con los 5 sabotajes en rojo | **cerrada 2026-09-22** |
| 3c | Lo mismo para la guía del I cuatrimestre (TP 1 a 5) | las consignas de `TP_I_cuatrimestre.pdf` itemizadas en el mismo banco y mapeadas | el mismo `verificar-cobertura.py`, con el conteo declarado subido | pendiente |
| 4 | El anexo de informes técnicos | el anexo publica los criterios de la guía de la cátedra —nada de capturas de pantalla, gráficos procesados por software (la guía nombra Veusz, Octave, Python, GNU Plot y Matlab), ejes rotulados con unidades, leyenda adentro de la figura, símbolos para mediciones y líneas para simulaciones, figuras numeradas con descripción al pie, A4 con páginas numeradas, máximo 10 páginas— y los gráficos del propio apunte los cumplen | recorrer la lista de criterios de la guía contra los gráficos del apunte, uno por uno. Cierra además la consigna 43 de `consignas-tp.md`, hoy diferida | pendiente |

> **Estado** es uno de: `abierta` / `cerrada` / `cancelada`.

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
7. ~~la simulación como tercera pata~~ — **hecho el 2026-09-04**: Módulo 15,
   con un ejercicio resuelto comprobado por balance de energía y los seis
   archivos de la cátedra recalculados uno por uno.

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

**Cómo se certifica:** los cuatro puntos de arriba, en este orden y con estos
comandos:

```bash
cd apunte && python verificar.py            # los SEIS chequeos, no cinco
cd .. && python verificar-cobertura.py      # que el apunte cubra las consignas
cd .. && python probar-verificar-cobertura.py
```

Y lo que ningún comando hace: **mirar el render** de toda página nueva, y
**recomprobar la aritmética por un segundo camino** escrito al lado del
resultado.

**El medidor en rojo se ve así.** Un tema de la lista escrito, con su ejercicio,
y `verificar.py` en verde — pero el ejercicio dando un resultado sin la
verificación independiente al lado. Ahí la fase no cierra aunque los seis
chequeos estén verdes: los chequeos miden que el apunte *compile y se vea bien*,
no que *diga lo que tenía que decir*. Ésa es la razón de que el chequeo de
cobertura sea un script aparte y no un sexto caso de `verificar.py`.


**Lo que entró el 2026-09-04 y no estaba en esta lista.** El profesor pasó material
de *bobinas, capacitores y circuitos dinámicos* —filminas, guía asincrónica de doce
problemas y seis archivos de LTspice— y de ahí salió, además del tema 7, una
ampliación grande del **Módulo 10** (de 8 a 21 páginas). No estaba en la lista porque
la lista enumera *temas que faltaban*, y el 10 ya existía: lo que faltaba adentro
eran las formas de onda vistas, el balance de energía, la inductancia mutua, el RLC
paralelo y la determinación de las dos constantes. Está detallado en
`ESTADO_ACTUAL.md`, sección «Módulos 10 y 15».

**La pasada de lectura eléctrica: hecha el 2026-09-04.** Las 72 figuras, una por
una, contra la pregunta «¿el circuito está bien?» —no «¿se lee bien?», que es la
verificación que ya existía y es una cosa distinta—: recorte de pixel sobre todo
componente con polaridad (diodo, zener, LED, BJT, entradas de operacional) y
recálculo de los siete gráficos de transitorios y del diagrama fasorial contra
los números que cada uno anota. **Resultado: 0 corregidas.** Detalle figura por
figura en `ESTADO_ACTUAL.md`, sección «Pasada de lectura eléctrica de las 72
figuras». Confirma la corrección de `fig-puente-graetz` del 2026-08-25 y revierte
un falso positivo propio sobre `fig-proteccion-polaridad` (a primera vista el
diodo de protección parecía al revés; el recorte mostró que está bien).

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Una figura es legible y **eléctricamente incorrecta** | media — ya pasó una vez (Graetz), y la pasada de las 72 del 2026-09-04 no encontró una segunda | alta: se publica un error a un curso entero | mitigar: **toda figura con semiconductor u operacional pasa por recorte de pixel** cuando se agrega o se toca, no sólo por render completo | una figura nueva con diodo, BJT o entrada de operacional que no haya pasado esa pasada |
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

## 8. Matriz de cumplimiento

> Escrita el **2026-09-22** al migrar el PDP. El default es silencio: la
> justificación se llena **sólo cuando se recorta**, y todo recorte lleva la
> resta escrita — lo mide `python perfil-global\herramientas\medir-matriz.py`.
> Una fila por **aspecto** de §3, no por proyecto.

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `a` | `cumple` | |
| `CLAUDE.md §Las reglas #1` (evidencia graduada) | `d` | `cumple` | La cobertura pasó de `hipótesis` a `confirmado` el día que se midió, y no antes |
| `CLAUDE.md §Las reglas #2` (el éxito se audita) | `b` | `cumple` | La pasada de lectura eléctrica del 2026-09-04 dio 0 corregidas sobre 72 figuras, y se auditó en vez de celebrarse: revirtió un falso positivo propio |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `a` | `cumple` | Los seis chequeos de `verificar.py` fueron probados en rojo; el 6 el 2026-09-22, con dos sabotajes |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `d` | `cumple` | `probar-verificar-cobertura.py`: 5 sabotajes en rojo + control positivo en verde |
| `CLAUDE.md §Las reglas #3` (toda alarma se prueba rompiéndola) | `c` | `recortado` | **Resta:** no hay alarma que se pueda romper para «se miró el render». Mirar es un acto humano y ningún script lo mide — lo más cerca que se llega es que exista el PNG, que es la precondición y no el efecto. Se acepta el recorte y se compensa **registrando qué páginas se miraron y sobre qué versión** en `ESTADO_ACTUAL.md`. El riesgo que se crea es que alguien escriba que miró sin mirar, y ya pasó: durante días el estado afirmó «las 30 figuras se ven bien» y era falso. El riesgo que compraría automatizarlo no se puede comprar a ningún precio |
| `CLAUDE.md §Las reglas #4` (el repo es la memoria) | todos | `cumple` | |
| `CLAUDE.md §Las reglas #6` (cambios mínimos) | `a` | `cumple` | No se reordena la Parte I ni se agregan temas «por las dudas»: §2 y la decisión del 2026-08-28 |
| `CLAUDE.md §Las reglas #7` (ubicar la intervención en la escala) | `d` | `cumple` | Lo que faltaba no era más esfuerzo revisando la guía a ojo: era el **flujo de información** que no existía. Por eso la respuesta fue un medidor y no una relectura más cuidadosa |
| `plantillas/naturalezas/documentos.md §Las cinco #1` (el destinatario está escrito) | todos | `cumple` | §1: primero el docente, después los alumnos |
| `plantillas/naturalezas/documentos.md §Las cinco #2` (el render se mira) | `c` | `cumple` | Es la regla propia del `CLAUDE.md` del proyecto |
| `plantillas/naturalezas/documentos.md §Las cinco #3` (toda afirmación tiene fuente anotada donde se usa) | `a` | `recortado` | **Resta:** el apunte cita la cátedra y los datasheets donde el dato es discutible ($V_Z$, $Z_(Z T)$, los parámetros del 1N4007), pero no lleva referencia al pie en cada afirmación de teoría general. La resta es que un dato de teoría copiado mal no tiene de dónde rastrearse; se acepta porque el destinatario es un alumno de 4.º año y una referencia por párrafo haría el apunte ilegible para él, que es el riesgo mayor. Se compensa con el segundo camino aritmético, que atrapa el error donde más cuesta |
| `plantillas/naturalezas/documentos.md §Las cinco #4` (las decisiones de contenido se registran) | todos | `cumple` | §6 de este PDP |
| `plantillas/naturalezas/documentos.md §Las cinco #5` (se escribe con código) | todos | `cumple` | Typst, fuente única |
| `plantillas/naturalezas/documentos.md §La trampa propia` (las referencias de texto plano no las valida el compilador) | `a` | `cumple` | Desde el 2026-09-22 lo mide el **chequeo 6** de `verificar.py`. Antes era una intención: la misma sesión que lo escribió rompió dos referencias al insertar un ejercicio en el medio |
| `plantillas/naturalezas/documentos.md §Verificación y validación` (validación ≠ verificación) | todos | `recortado` | **Resta:** la validación —¿el docente lo adopta, el alumno entiende?— sigue sin medirse, y está declarada como PENDIENTE en §1. El único dato que hay es indirecto (el alumno reportó que nodos costaba). Se acepta porque el canal de validación no depende del proyecto sino de que el docente lo mire; el riesgo que se crea es el más caro que tiene el proyecto: un apunte impecable que nadie usa |
