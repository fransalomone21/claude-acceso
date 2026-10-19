# PDP — Apunte de IISE

Plan de Desarrollo de Proyecto. Apunte general de **Introducción a la
Ingeniería de Sistemas Espaciales** (UNSAM, 2026), unidades 1 a 7.

## 1. El problema

La materia se cursa sobre 7 presentaciones — **590 diapositivas, 360.000
caracteres, 540 imágenes** — y no hay apunte. El material tiene tres
propiedades que lo hacen difícil de estudiar tal como está:

1. **Es léxico, no matemático.** Lo que se rinde son distinciones entre
   palabras parecidas: necesidad ≠ meta ≠ objetivo ≠ misión ≠ restricción ≠
   requerimiento; forma ≠ función; arquitectura ≠ diseño; verificación ≠
   validación; sistema ≠ subsistema ≠ sistema de sistemas. Un sinónimo mal
   usado no es un error de estilo: es un error de contenido.
2. **El 30% del contenido está en las figuras.** 177 de las 590 diapositivas
   tienen menos de 150 caracteres de texto: el concepto vive en el diagrama.
3. **Las definiciones están dispersas y a veces repetidas con otras palabras.**
   «Arquitectura de sistemas» aparece definida en las clases 1, 2, 4 y 7, con
   redacciones distintas.

**Destinatario:** el alumno que cursa IISE y va a rendir los parciales y los
parcialitos. No es material de consulta para alguien que ya sabe.

## 2. Qué NO es

- **No es un resumen de las diapositivas.** Un resumen hereda la ambigüedad
  del original; el apunte tiene que resolverla.
- **No es un libro de ingeniería de sistemas.** No reemplaza a NASA SP-2016-6105
  ni al INCOSE SEH: los usa para desambiguar lo que la diapositiva dice a medias.
- **No incluye material que la cátedra no dio.** Si un concepto no está en las
  7 clases, no entra, salvo como nota al pie que aclara una definición.

## 3. Naturaleza, y el rigor POR ASPECTO

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md).

| Aspecto | Rigor | Por qué |
|---|---|---|
| Definiciones de términos controlados | **máximo** | es lo que se rinde; un sinónimo mal usado invalida la respuesta del parcial |
| Descripción de figuras | alto | el 30% del contenido; y el ancla a la diapositiva se confirma mirando el PNG |
| Ejemplos y casos (ISS, Apollo, Falcon 9) | medio | ilustran, no se rinden textuales |
| Prosa de enlace | medio | tiene que leerse bien, pero no arrastra riesgo de error |
| Datos numéricos citados (LEO 185–401 km, etc.) | **máximo** | se copian de la diapositiva y se marcan con su origen |

## 4. Las fases

**Fase 9 — PROPUESTA, sin abrir (Fran, 2026-10-19, SUMAMENTE IMPORTANTE):** «cómo se escribe el alcance», con evidencia de la práctica (NASA) marcada aparte de lo de la cátedra. Qué entra y las fuentes: `HANDOFF.md`, primera entrada. Criterio de salida a escribir al abrirla.

**Fase en curso:** ninguna — la 8 (resumen para el parcialito del 14/10) cerró el 2026-10-14. Mantenimiento (tipo: **Fase E**): si llega la clase 11, un parcialito nuevo u otro pedido de resumen, se abre la fase 9 con su criterio escrito antes de empezar.

### Fase 0 — Material asegurado en el repo ✅ CERRADA (2026-09-20)

**Criterio de salida:** los 7 PDF extraídos a `.txt` con el número de
diapositiva real, las diapositivas-figura exportadas a PNG, y el material de
NotebookLM guardado y **medido**.

Resultado: 590 diapositivas en `fuentes/clases/`, 177 PNG en `fuentes/figuras/`,
`titulos.md` con el índice completo, y los dos entregables de NotebookLM en
`fuentes/externo/`, con su medición de anclas.

### Fase 1 — El glosario controlado (M00) y su verificador ✅ CERRADA (2026-09-20)

**Criterio de salida:** `fuentes/glosario.md` con cada término controlado
definido una sola vez, con su fuente (clase + diapositiva verificada) y sus
confundibles; `verificar-lexico.py` en verde; y **el saboteador
`probar-verificar-lexico.py` poniéndolo en rojo a propósito**.

Resultado: 29 términos de las unidades 1 a 3; `verificar-lexico.py` mide las
tres cosas —término marcado sin entrada, par prohibido, doble definición— y el
saboteador pone las tres en rojo, más dos controles positivos (árbol intacto en
verde, y la excepción `// lexico-ok` respetada). El verificador encontró cinco
defectos reales en su primera corrida.

### Fase 2 — Redacción, una unidad por sesión ✅ CERRADA (2026-09-20)

**Criterio de salida por unidad:** sus módulos escritos en Typst, compilando,
con **cada página mirada**, cada figura citada con su diapositiva confirmada
contra el PNG, y `verificar-lexico.py` en verde sobre esos módulos.

Resultado: **las 7 unidades escritas** en la misma sesión de trabajo
continuada (7 sub-sesiones, una por unidad, el mismo 2026-09-20): 28 módulos
(M00–M27), 71 términos de glosario, 115 páginas de PDF, `verificar-lexico.py`
en verde en cada cierre de unidad. La unidad 6 salió con 5 módulos en vez de
los 4 previstos (nota en §8); las demás, con los previstos. Modelo Sonnet,
esfuerzo medium-high, sin fan-out.

### Fase 3 — Cobertura contra los parcialitos ✅ CERRADA (2026-09-20)

**Criterio de salida:** cada pregunta de los parcialitos **que sí están** (1, 2
y 3; 16 preguntas) mapeada a un módulo que la responde; ninguna pregunta
huérfana. Es la **validación** del apunte (¿sirve para rendir?), distinta de la
verificación (¿dice lo que tenía que decir y compila bien?).

**Reinterpretada el 2026-09-20, por decisión de Fran.** La versión anterior
esperaba los parcialitos 4 a 7 y dejaba la fase *bloqueada*. No habían llegado
—y este PDP escribió que **no iban a llegar**, que era una predicción y se
anotó como un hecho; el 2026-09-21 llegaron el 4 y el 5, ver fase 6—. El
argumento de fondo, en cambio, sigue en pie y es el que vale: el encargo es
**un apunte general de la materia**, no un preparador de parcialitos, y la
cátedra puede tomar otra cosa. Así que la
cobertura pasa a ser un **piso, no un techo** — un módulo que ningún parcialito
toca no sobra, y la fase ya no bloquea a ninguna otra.

Resultado: las **16 preguntas mapeadas, ninguna huérfana** y **ningún hueco de
contenido** — las tres clases que sí tienen parcialito están cubiertas por los
módulos ya escritos, sin agregar una línea de contenido nuevo. Lo que sí
apareció fue un defecto del **mapeo**: estaba mal en **9 de las 16**, escrito
el mismo día desde los parcialitos y sin abrir un módulo, y con la numeración
anterior a que la unidad 6 creciera a cinco módulos (la tabla N² aplicada
apuntaba a M26, que son las revisiones de la fase A, en vez de M27).

**Por eso la fase cerró con un medidor y no con una lista**, en contra de lo
que sugería el HANDOFF («las 16 preguntas son estáticas, no hace falta un
script»). No hacía falta por las preguntas: hace falta por los **módulos**, que
se renumeran — y ya se renumeraron una vez, en silencio. `verificar-cobertura.py`
exige el **título exacto de la sección**, que es lo único que no se puede
escribir de memoria, y `probar-verificar-cobertura.py` pone sus cuatro chequeos
en rojo a propósito. El saboteador encontró un agujero real en su primera
corrida: el sabotaje (b) rompía una mención de ejemplo en la **prosa** del
banco, no una fila de la tabla, y el verificador daba verde con razón.

### Fase 4 — Publicación ✅ CERRADA (2026-09-20)

**Criterio de salida:** el PDF declarado en `.claude/apuntes-publicos.json`,
subido a la carpeta `IISE` del Drive, y `publicar-apuntes.ps1 -Verificar` en
verde.

Resultado: **publicado y verificado por MD5** — 10,3 MB, 115 páginas, en la
carpeta `IISE` del Drive de los compañeros, por pedido de Fran. La entrada del
apunte pasó de `no-se-publican` a `apuntes` cumpliendo el criterio que ella
misma declaraba («pasa cuando estén escritas las 7 unidades»), y queda como
`ACTIVO`: si el apunte se toca, el medidor de cada arranque avisa que el Drive
quedó atrasado.

**El medidor se puso en rojo antes de subir**, con el apunte ya declarado y
todavía sin subir (`IISE: SIN PUBLICAR en Drive`, `RESULTADO: 1 cosa(s) sin
resolver`). Eso no es un trámite: es la única corrida que prueba que el verde
posterior significa algo.

**Con esto el PDP quedó completo** — y al día siguiente se le agregó una fase
más, la 5, porque Fran pidió las figuras. Un PDP cerrado no es un PDP
clausurado: la fase nueva se abre, se le escribe su criterio de salida antes de
empezarla y se cierra, igual que las otras.

### Fase 5 — Figuras didácticas ✅ CERRADA (2026-09-21)

**Abierta y cerrada el mismo día, a pedido de Fran**, sobre un proyecto que ya
estaba cerrado: agregar imágenes de las presentaciones «sólo donde sean
didácticas, y que no entorpezcan».

**Criterio de salida:** cada figura nueva embebida con su diapositiva
confirmada *mirando el PNG*, **y su página compilada mirada** (regla propia 4);
`verificar-lexico.py` y `verificar-cobertura.py` en verde; el PDF republicado.

Resultado: **7 figuras nuevas** (de 11 a 18), 115 → **123 páginas**. Dónde, y
por qué cada una:

| Figura | Módulo | Qué aporta que el texto no podía |
|---|---|---|
| Forma y función, los 4 ejemplos (clase 2, dia. 41) | M06 | la unidad 2 no tenía **ninguna** figura, y el argumento es visual: cuatro sistemas de clases distintas en una lámina |
| Jerarquía del sistema satelital (clase 4, dia. 111) | M13 | las dos ramas (segmento espacio / terreno) y la nomenclatura de software, que la enumeración en prosa deja implícitas |
| El motor de la IS de NASA (clase 4, dia. 104) | M14 | la **geometría**: requerimientos que bajan y productos que suben sobre la misma estructura. La tabla que ya estaba lo ordena, pero no lo muestra |
| Diagrama en V (clase 5, dia. 7) | M15 | la **simetría** entre cada caja y la que la verifica. Un módulo que se llama «diagrama en V» y no lo mostraba |
| ConOps del DRM lunar (clase 5, dia. 70) | M18 | un ConOps **dibujado**, al lado de su definición |
| ConOps lunar anotado (clase 6, dia. 29) | M20 | el mismo ConOps **con Δv, masas y duraciones encima**: muestra que el ConOps dimensiona, no sólo describe |
| ConOps de comunicaciones end-to-end (clase 5, dia. 71) | M20 | el reparto de la lámina *es* el argumento: el satélite ocupa una esquina y todo el resto es segmento terreno |

**Lo que se descartó, y es la mitad del trabajo.** De los candidatos mirados:
una foto del Falcon 9 en el hangar (bonita, no enseña nada), dos diapositivas
separadoras que el extractor marca como figura porque casi no tienen texto, el
esquema de niveles N+1/N/N−1 (M03 **ya** lo tiene, dibujado en Typst y más
legible que la foto) y el clásico de precisión contra exactitud (el apunte no
desarrolla esa distinción, así que la figura no colgaba de nada).

**El extractor aprendió a pedir diapositivas por número.** `extraer-clases.py`
sólo exportaba PNG de las diapositivas *casi sin texto*, que es un buen
descubridor automático y a la vez deja afuera justo las más didácticas: las que
tienen un diagrama **y sus rótulos**. Cuatro de las siete figuras elegidas
—incluidos el motor y el diagrama en V— estaban de ese lado. Ahora hay
`--pagina cN:pM`, que es un camino aparte a propósito: uno se descubre solo, el
otro se elige mirando.

**Dos defectos de maquetación, atrapados mirando la página** (regla propia 4,
otra vez): la jerarquía satelital quedó sola al final de su módulo con media
página en blanco (se movió al principio de la sección) y el motor de NASA al
97% de ancho empujaba su tabla a la página siguiente (bajó a 78% y las dos
entran juntas). Las dos veces el PDF compiló en verde.

## 5. Riesgos

| Riesgo | Cómo se mide | Estado |
|---|---|---|
| Citar una diapositiva equivocada | `verificar-anclas.py`; el ancla se confirma mirando el PNG | **vivo y medido**: de 149 anclas de NotebookLM, sólo 4 coincidían con la página real |
| Usar dos palabras para el mismo concepto | `verificar-lexico.py` | **medido y en verde** desde el 2026-09-20; el saboteador lo pone en rojo |
| Dejar afuera un tema que el parcialito sí toca | `verificar-cobertura.py`, contra los parcialitos **1 a 5** | **medido**: 28 preguntas, ninguna huérfana. El riesgo bajó el 2026-09-21, cuando llegaron dos parcialitos más y el apunte los contestaba casi entero: un hueco real (la 6.ª categoría de requerimientos) sobre 12 preguntas nuevas |
| Copiar una plantilla de otro proyecto y heredar su **contenido** | mirar la página compilada (regla propia 4) | **ocurrido y corregido** el 2026-09-20: la portada hablaba de Beer y de mecánica orbital, y Typst compilaba en verde |
| Que el material de NotebookLM traiga algo que la clase no dice | se verifica contra `fuentes/clases/clase-N.txt` antes de entrar | permanente |

## 6. Decisiones

- **2026-09-20 — «requerimiento», no «requisito».** Medido sobre las 7 clases:
  `requerimiento` 342 + `requer.` 400 = **742**, contra `requisito` **8**.
  Igual: **«interesado» (38) y no «stakeholder» (5)**. No se preguntó: estaba
  en la fuente.
- **2026-09-20 — los `[pN]` de NotebookLM no se citan.** 4 de 149 coincidían
  con la página real, y el corrimiento no es constante, así que no hay offset
  que lo arregle. El inventario se usa por sus **descripciones**; el número lo
  pone quien escribe el módulo, mirando el PNG.
- **2026-09-20 — el glosario es el módulo 0, no un anexo.** En una materia que
  se rinde sobre distinciones léxicas, el glosario es el contenido; ponerlo al
  final lo convierte en algo que se consulta cuando ya se entendió mal.
- **2026-09-20 — se reusa la infraestructura de `fisica-espacial`**:
  `plantilla.typ`, la paleta, las cajas técnicas, el cuadro `#posta`, las
  referencias `#M("clave")` que rompen la compilación si están mal, y
  `indice-temas.py`.

## 7. Verificación

| Qué | Con qué | Y su saboteador |
|---|---|---|
| el material fuente está completo | `extraer-clases.py` (590 diapositivas) | — |
| las anclas a diapositivas | `verificar-anclas.py` | — |
| el léxico controlado | `verificar-lexico.py` (fase 1) | `probar-verificar-lexico.py` |
| el orden y las referencias cruzadas | `verificar-apunte.py` (adaptado) | `probar-verificar-apunte.py` |
| el render | mirar la página compilada, `/pdf-con-codigo` | — |

## 8. Matriz de cumplimiento

**`MNN` es la clave de archivo y de planificación, no el número impreso.** El
apunte numera los módulos por su posición: el glosario es el *módulo 1*
impreso, y M01 es el *módulo 2*. No hay dos fuentes del número — la prosa nunca
escribe uno, usa `#M("clave")` y el número sale del orden de los `#include` de
`apunte.typ`.

| Unidad | Diapositivas | Módulos | Estado |
|---|---|---|---|
| 1 — Introducción, CDIO, historia de la IS | 41 | M01–M03 | **escrita** (2026-09-20) |
| 2 — Pensamiento sistémico, forma y función | 97 | M04–M07 | **escrita** (2026-09-20) |
| 3 — Rol del arquitecto, ambigüedad, PDP | 48 | M08–M10 | **escrita** (2026-09-20) |
| 4 — Necesidad de la IS, SoS, ISS, motor NASA | 124 | M11–M14 | **escrita** (2026-09-20) |
| 5 — Ciclo de vida, requerimientos, márgenes, alcance | 71 | M15–M18 | **escrita** (2026-09-20) |
| 6 — Familia de requerimientos, interfaces, modelos de ciclo | 155 | M19–M23 | **escrita** (2026-09-20) — 5 módulos, no los 4 previstos: ver nota abajo |
| 7 — Creación de arquitecturas, Fase A, N² | 54 | M24–M27 | **escrita** (2026-09-20) |
| 8 — Plan de trabajo, estimaciones, LDCM, lanzadores, ROV | 98 | M28–M32 (+ M15) | **plan registrado** (2026-10-05), sin redactar: ver `PLAN-CLASES-8-9.md` |
| 9 — Fase B, TRL/IRL/SRL, Fase C, CDR y SIR | 54 | M33–M36 (+ M15, M19, M21) | **plan registrado** (2026-10-05), sin redactar |
| 0 — Glosario controlado | transversal | M00 | **escrito** (2026-09-20), 71 terminos |

**Nota sobre la unidad 6 (2026-09-20):** el plan original preveía M19–M22
(cuatro módulos). Al escribirla, la ingeniería concurrente y la mecatrónica
—155 diapositivas en total, la clase más larga— no cabían en ninguno de los
otros cuatro sin diluirlos, así que se agregó un quinto módulo (M23). La
unidad 7 corre en consecuencia un módulo más tarde (M24–M27 en vez de
M23–M26). Es el número de módulos por unidad el que se ajustó — una
estimación, no un contrato —; el criterio de cierre de cada fase no cambió.

### Fase 6 — Los parcialitos 4 y 5 ✅ CERRADA (2026-09-21)

**Abierta porque llegó evidencia nueva**: Fran trajo los parcialitos 4 (clase
5) y 5 (clase 6) corregidos, después de que el proyecto declarara —en cuatro
documentos distintos— que no iban a llegar.

**Criterio de salida:** las 12 preguntas nuevas mapeadas a sección exacta con
`verificar-cobertura.py` en verde; los huecos reales de contenido, cerrados; y
la afirmación «no van a llegar» corregida en todos los documentos que la
repetían.

Resultado: **28 preguntas, 62 anclas, ninguna huérfana.** De las 12 nuevas, 11
ya estaban contestadas por los módulos escritos. Los tres cambios de contenido:

| Qué faltaba | Dónde | Evidencia |
|---|---|---|
| La **sexta** categoría de requerimientos («otros»: factor humano, confiabilidad, seguridad) | M17 | el apunte decía «los cinco tipos»; la clase 5, dia. 60 cierra la lista con un «etc.» que *es parte de la lista* |
| La distinción **Fase E opera / Fase F cierra** | M15 | es el error que el parcialito 4 tiene marcado: describir la Fase F como «operación y mantenimiento» |
| Los elementos del alcance como **cadena ordenada** que termina en el ConOps | M18 | el parcialito 5 los pide en orden (pregunta 3) y por separado (pregunta 6): son dos preguntas distintas |

**El medidor se ganó el sueldo.** De las 11 anclas nuevas escritas para las
preguntas de estos dos parcialitos, `verificar-cobertura.py` puso **11 en
rojo**: se habían escrito de memoria, exactamente el mismo error que la fase 3
encontró a mano en 9 de 16. La diferencia es que esta vez lo atrapó la máquina
en la primera corrida, y costó un minuto en lugar de una sesión.

**Y el patrón del banco se validó solo.** Con 16 preguntas medidas, el banco
predecía la forma de los parcialitos que faltaran: un parcialito por clase,
cinco o seis preguntas, todas de definición. Llegaron 12 preguntas más y
**ninguna se salió de la forma** — una predicción escrita antes, confirmada
después, que es la única clase de validación que este proyecto puede producir.

### Fase 7 — Las clases 8, 9 y 10 ✅ CERRADA (2026-10-13)

**Abierta porque llegó material nuevo**: la clase 8 (98 diapositivas: plan de
trabajo, estimaciones, LDCM, lanzadores, ROV) y la clase 9 (54: Fase B, TRL/IRL,
Fase C). Fran pidió **sólo el plan y los contenidos clasificados**, no el apunte:
está en [`PLAN-CLASES-8-9.md`](PLAN-CLASES-8-9.md) (qué es nuevo, qué ya está,
destino por módulo, orden de sesiones y lo que hay que desconfiar de las notas
de orador).

**Criterio de salida (original):** los 9 módulos nuevos (M28 a M36) y las 4 extensiones
(M15 dos secciones, M19 y M21) compilan con **cada página mirada**; `verificar-lexico.py` y
`verificar-cobertura.py` en verde; los términos nuevos en el glosario con su
diapositiva mirada; el PDF republicado y verificado por MD5.

**Alcance ampliado el 2026-10-13, a pedido de Fran:** llegó la **clase 10**
(71 diapositivas: forma y función, ingeniería inversa, la PDR del ROV, gestión
del riesgo técnico) y la **consigna del trabajo final** (un MCR). La fase pasó
a cubrir las tres clases en la misma sesión. El criterio se mantuvo —módulos
compilando con cada página mirada, léxico y cobertura en verde, glosario con
diapositiva mirada, PDF publicado por MD5— sobre la estructura nueva.

**Resultado:** 12 módulos nuevos y una extensión, 128 → **191 páginas**:

| Unidad | Módulos | Fuente |
|---|---|---|
| 8 | M28 plan de trabajo (WBS, red, camino crítico con la cuenta hacia adelante y hacia atrás, Gantt) · M29 estimaciones · M30 el LDCM · M31 lanzadores · M32 diagrama funcional y el NOAA-N′ | clase 8 (97 diap.) |
| 8 | extensión de M15: qué congela cada revisión y la progresión de los requerimientos | clase 8, diap. 41-42 |
| 9 | M33 plantilla de requerimientos e interfaces con el lanzador · M34 Fase B · M35 TRL, IRL y SRL · M36 Fase C, CDR y SIR | clase 9 (54) |
| 10 | M37 forma, función e ingeniería inversa · M38 la PDR del ROV · M39 gestión del riesgo técnico | clase 10 (71) |
| — | Anexo A: cada sección del trabajo final con los módulos que la explican | consigna del TP |

28 términos nuevos en el glosario (71 → 99). `verificar-lexico.py`,
`verificar-cobertura.py` y sus dos saboteadores en verde; PDF publicado en el
Drive y verificado por MD5 (el hook `post-commit`, unidad por unidad).

**Desvíos respecto del plan del 2026-10-05, y por qué:**

- **Las extensiones de M19 y M21 no se hicieron**: la plantilla de
  requerimientos y las interfaces con el lanzador de la clase 9 son un módulo
  propio (M33), porque la clase las presenta juntas como repaso y cortarlas en
  dos módulos viejos las separaba de su contexto. Cambio mínimo: los módulos
  cerrados no se tocaron.
- **La clase 8 vigente es la del 12/10**: 97 diapositivas (la cátedra sacó la
  44 que había agregado el 05/10), con **la 39 y la 40 ocultas**. Un PDF
  exportado «normal» las saltea y corre todos los números; se exportó con las
  ocultas visibles, así que el número de página es el de la lámina.
- **La «transcripción» de la clase 8 no es la clase hablada**: igual que la de
  la clase 7, es el `.pptx` con notas de orador. No se usó como fuente.
- **El umbral de TRL 6** que el plan marcaba como «sólo de las notas» tiene
  fuente en la clase 10 (diap. 57: guías de NASA y de la GAO, TRL 6 al
  completar la PDR) y un contraejemplo (Mars 2020).

### Fase 8 — Resumen para el parcialito del 14/10 ✅ CERRADA (2026-10-14)

**Pedido de Fran (14/10):** un resumen para estudiar el parcialito de hoy:
la clase 8 hasta el LDCM (plan de trabajo, WBS, red, camino crítico, Gantt,
estimaciones y costos, baselines, LDCM) y la Fase B de la clase 9; en criollo
sin perder formalismo, con los ejemplos de la clase mejor contados, con humor,
y publicado clasificado en el Drive de los compañeros.

**Criterio de salida:** `resumenes/resumen-clases-8-9.pdf` compilado con
**cada página mirada**; cada número de un ejemplo de la clase verificado
contra la lámina (PNG o `clase-N.txt`) o contra el módulo que ya lo verificó;
léxico de la cátedra (requerimiento, interesado); declarado en
`.claude/apuntes-publicos.json` y `publicar-apuntes.ps1 -Verificar` en verde
por MD5.

Resultado: **12 páginas, las 12 miradas** (`resumenes/`, con un `estilo.typ`
propio que importa la paleta del apunte). Los números de los ejemplos se
verificaron contra la lámina: la WBS de LaACES (diap. 34: 14 d y 970 USD en la
1.5.2, total 710 d y 27 010 USD, y la rama 5.0 que falta en la lámina) y el té
(diap. 14: las dos ramas; 253 → 83 s, y en la bifurcación de la tetera el
crítico también cambia: recalentar 10 → saquitos 5). El resto sale de los
módulos que ya los verificaron. Dos cuentas son **del resumen y lo dicen**
(la reconciliación macro/micro y el grabador del LDCM: 291 Mbps × 600 s ≈ 175
Gbit, ~17 pasadas en 3,1 Tbit). El medidor dio **rojo antes de subir**
(«SIN PUBLICAR», 1 cosa sin resolver) y verde después, por MD5. Destino:
`IISE/Material de Estudio nuestro/Resumenes para parcialitos/Clases 8 y 9
(14-10)`, la clasificación nueva que pidió Fran («clasificadamente»).
