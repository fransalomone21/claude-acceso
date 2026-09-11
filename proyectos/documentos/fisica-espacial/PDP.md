# PDP — Apunte general de Física Espacial

Plan de Desarrollo de Proyecto. Acá viven **el plan de fases, el criterio de
salida de cada una y las decisiones de contenido con su porqué**. Si el
`HANDOFF.md` y este archivo se contradicen, gana el PDP y el handoff se
corrige en el mismo turno.

---

## 1. Qué se produce

Un **apunte general** de la materia *Física Espacial* (UNSAM — Ingeniería en
Sistemas Espaciales, cátedra Feder–Valenti, ciclo 2026), en Typst, compilado a
un solo PDF.

No es un resumen de citas ni un formulario: es un texto que **explica**. La
regla de contenido que lo define, dicha por el destinatario:

> «Si estás explicando por qué con cierta $v$ tangencial un objeto orbita en
> una circunferencia sin caer, no me tires la fórmula en la cara: hacé la
> deducción de cómo llegar hasta ahí.»

Y su contrapeso, dicho en la misma frase:

> «No necesito demostraciones extensas de todo, ni pasos intermedios tontos.»

Traducido a criterio operativo: **se deduce lo que cambia el entendimiento y
se cita lo que sólo cambia el álgebra.** Toda fórmula que aparece por primera
vez llega desde algo anterior; ningún desarrollo se escribe línea por línea
cuando el paso es una cuenta mecánica.

## 2. Para quién es, y para quién no

**Es para Fran**, alumno de la materia, que cursa en paralelo Teoría de
Circuitos y ya tiene Análisis Matemático y Física I–III. Sabe derivar e
integrar, sabe qué es un producto vectorial, y **no** necesita que se le
explique qué es una derivada. Sí necesita:

- de dónde sale cada resultado, no sólo cuál es;
- la geometría y el álgebra vectorial del planteo, que es donde se pierde el
  tiempo en el parcial (qué versor, qué ángulo, respecto de qué punto);
- las trampas de notación entre los tres libros que la cátedra mezcla, que ya
  costaron confusión real (Beer llama $H$ al momento angular y $L$ a la
  cantidad de movimiento — exactamente al revés que la cátedra).

**No es** un libro de texto ni material de divulgación. No repite lo que ya
está bien en S&Z; lo usa y cita.

## 3. Decisiones de contenido, con su porqué

| Decisión | Por qué |
|---|---|
| **Cubre el plan de las 17 semanas completo**, cuerpo rígido incluido | el pedido fue «apunte general de la materia», y las semanas 10–14 (CR, precesión, peonza) son la mitad del segundo parcial. Cortar en la primera evaluación entregaría medio apunte |
| **Dos ejemplos por módulo: uno simple y uno complejo** | pedido explícito. El simple fija el mecanismo; el complejo es del nivel de la guía de la cátedra |
| Los ejemplos **se calcan de la guía de problemas**, no se inventan | la guía es el examen. Un ejemplo inventado enseña a resolver algo que no se va a tomar |
| **Cuadros de Cuidado geométricos y vectoriales** | pedido explícito, y coincide con dónde falla el planteo: respecto de qué punto se toma $L$, qué versor es radial, qué ángulo entra en el $sen$ |
| **Figuras dibujadas en CeTZ**, no importadas | mismo criterio que el apunte de Electrónica: la figura vive en el fuente, se regenera y se corrige. Un PNG pegado no se puede arreglar |
| **Estilo calcado del apunte de Electrónica Analógica** | pedido explícito. Se copia la arquitectura (`plantilla.typ` + `biblioteca/` + `modulos/`), no los archivos: los colores y las cajas cambian de semántica |
| **Se recicla el `resumen.typ` previo** (16 pág., verificado contra los libros con página) como *fuente*, no como base | ese documento es un mapa de citas de cátedra ya verificado — tirarlo sería tirar trabajo medido. Pero su forma es de resumen, no de apunte: el texto se reescribe |
| **El apunte no lleva demostración de la ecuación de Kepler en tiempo** (anomalía excéntrica) más allá del enunciado y su uso | no está en el plan de 17 semanas ni en la guía; entra como anexo si sobra |

### Las fuentes, y cómo se citan

Los seis libros están en el disco (ver `fuentes/RUTAS.md`). Toda afirmación
lleva su origen entre paréntesis con **sección y página impresa**.

| Cita | Libro |
|---|---|
| S&Z | Young & Freedman, *Física universitaria* Vol. 1 y 2 (Pearson 2018) |
| Roederer | Roederer, *Mecánica elemental* (Eudeba 2008) |
| Beer | Beer & Johnston, *Mecánica vectorial para ingenieros: Dinámica* |
| Bate | Bate, Mueller & White, *Fundamentals of Astrodynamics* (Dover 1971) |
| Curtis | Curtis, *Orbital Mechanics for Engineering Students* (Elsevier 2020) |
| Clase | apuntes manuscritos de la cátedra (potencial eficaz, masa reducida) |

## 4. Las fases, y qué cierra cada una

El criterio de salida de una fase es un **resultado verificable**, nunca una
cantidad de trabajo hecho. Una fase no se abre con la anterior sin cerrar.

### Fase 0 — encuadre  ·  CERRADA (2026-08-30)

Cierra con: proyecto creado, fila en el enrutador, PDP escrito, inventario de
libros y de herramientas **medido** contra el disco.

### Fase 1 — andamiaje y módulo piloto

Cierra con: `apunte.pdf` compilando, con carátula, índice, plantilla,
biblioteca de figuras con al menos tres figuras propias, y el **Módulo 1
(Vectores y cinemática)** escrito entero — sus dos ejemplos incluidos — y
**mirado en el render**, no sólo compilado.

Por qué un piloto y no el esqueleto de los quince: el estilo se decide una
vez, y se decide sobre una página real. Escribir quince módulos con un estilo
que no se miró es quince módulos para corregir.

### Fase 2 — Parte II: los teoremas de conservación (M2–M5)

Cierra con: los cuatro módulos escritos, con sus ocho ejemplos, y el PDF
mirado página por página.

### Fase 3 — Parte III: gravitación y órbitas (M6–M11)  ·  CERRADA (2026-08-31)

Cierra con: los seis módulos escritos y mirados, incluido el diagrama de
flujo del Road Map (Curtis, ap. B) redibujado en CeTZ. *(Esta fila decía
«M6–M10, cinco módulos» hasta el 2026-08-31 — divergía de §5, que ya listaba
M11 «Maniobras» adentro de la Parte III. Ganó §5, que es donde vive la
estructura real de quince módulos; el número de acá se corrigió en el mismo
turno en que se detectó, por la regla 4 del enrutador.)*

### Fase 4 — Parte IV: cuerpo rígido (M12–M15)

Cierra con: los cuatro módulos escritos y mirados.

### Fase 5 — Parte V: de la cónica al viaje real (M16–M19)  ·  LOS CUATRO MÓDULOS ESCRITOS (2026-09-11); falta la sesión de cierre

**Por qué existe.** El 2026-09-07 Fran trajo la lista de temas de gravitación
actualizada (`Lista de temas Gravitación (2).pdf`, ver `fuentes/RUTAS.md`),
que agrega dos filas que la versión anterior no tenía: **«Todo — Curtis cap.
2»** y los **parámetros orbitales del Bate** (pág. 19–40 y 53–74). Y pidió,
además, órbitas parcheadas, esfera de influencia y su relación con Hohmann y
con la gravedad de la Tierra — que es el capítulo 8 de Curtis, no el 2.

**El hueco medido** (grep sobre los quince módulos, 2026-09-07): de Curtis
cap. 2, los apartados 2.2 a 2.7 están cubiertos por los módulos 6 a 10; lo
que **no estaba en ninguna parte del apunte** es 2.8–2.9 (parábola e
hipérbola más allá de una fila de tabla), 2.10 (marco perifocal), 2.11
(coeficientes de Lagrange) y 2.12 (tres cuerpos restringido y puntos de
Lagrange). Ni «perifocal», ni «Lagrange», ni «parcheada», ni «esfera de
influencia» aparecían una sola vez en los 5189 renglones de `modulos/`.

**Los cuatro módulos, en el orden en que se escriben:**

| Módulo | Qué | Fuente | Estado |
|---|---|---|---|
| M16 | La hipérbola: escapar y llegar con velocidad de sobra | Curtis §2.8–2.9 | **escrito y verificado** (2026-09-07) |
| M17 | Esfera de influencia y órbitas parcheadas | Curtis §8.4–8.6 | **escrito y verificado** (2026-09-07) |
| M18 | Marco perifocal, vector de estado y coeficientes de Lagrange | Curtis §2.10–2.11, Bate §2.2.4 a §2.5 (pág. 57–73) | **escrito y verificado** (2026-09-08) |
| M19 | El problema restringido de tres cuerpos y los puntos de Lagrange | Curtis §2.12 | **escrito y verificado** (2026-09-11) |

El orden no es el del libro: M17 va segundo, antes que los dos de
herramientas, porque es lo que Fran pidió explícitamente y porque M16 es su
única precondición.

**Va al final del apunte y no entre las Partes III y IV.** Insertarla en el
medio renumeraría los módulos 12 a 15 y rompería **51 referencias de texto
plano** («módulo 12», «módulo 14», …) repartidas en siete archivos y en 105
páginas ya verificadas — un refactor de riesgo silencioso, fuera del alcance
de «ampliá el apunte». La Parte V se lee inmediatamente después del módulo
11: no usa nada de cuerpo rígido, y la bajada de la parte lo dice.

Cierra con: los cuatro módulos escritos, con sus ejemplos, compilados y
**mirados en el render**; el enlace numérico Hohmann ↔ hipérbola de escape
cerrado de punta a punta (el $v_oo$ del módulo 16 usado como entrada del 17);
y `docs/figuras.md` al día.

### Fase 6 — cierre

Cierra con: anexos (formulario, constantes, tabla de correspondencia con las
listas de temas de la cátedra), todas las referencias cruzadas validadas
contra el índice renderizado, y el PDF entregado.

## 5. La estructura del apunte

```
Parte I   — Herramientas
  M1  Vectores, coordenadas polares y curvilíneas
Parte II  — Los teoremas de conservación
  M2  Cantidad de movimiento, impulso y choques
  M3  Centro de masa y sistemas de partículas
  M4  Propulsión: la ecuación del cohete
  M5  Trabajo y energía
Parte III — Gravitación y mecánica orbital
  M6  Gravitación de Newton, peso y energía potencial
  M7  Momento angular y fuerzas centrales
  M8  El problema de dos cuerpos y la masa reducida
  M9  La ecuación de la órbita, las cónicas y el potencial eficaz
  M10 Leyes de Kepler y parámetros orbitales
  M11 Maniobras: Hohmann, phasing y rendez-vous
Parte IV  — Cuerpo rígido
  M12 Cinemática del cuerpo rígido y sistemas rotantes
  M13 Momento de inercia y ejes principales
  M14 Ecuaciones de Euler y el giróscopo
  M15 Peonza simétrica, precesión directa y retrógrada
Parte V   — De la cónica al viaje real
  M16 La hipérbola: escapar, y llegar con velocidad de sobra
  M17 Esfera de influencia y órbitas parcheadas
  M18 Marco perifocal, vector de estado y coeficientes de Lagrange
  M19 El problema restringido de tres cuerpos y los puntos de Lagrange
Anexos    — formulario · constantes · correspondencia con la cátedra
```

Diecinueve módulos. Eran quince hasta el 2026-09-07: la Parte V nació de las
dos filas nuevas de la lista de temas de gravitación (ver la fase 5). El de
Electrónica tiene catorce y 123 páginas; éste tiene **149 con los diecinueve
módulos adentro** (2026-09-11), sin los anexos.

## 6. Cómo se verifica

- **Verificación:** compila, y cada página se **mira** (regla propia del
  proyecto, ver `CLAUDE.md`). Que Typst compile no dice nada sobre si una
  figura entró o si una tabla se cortó.
- **Validación:** el destinatario lee un módulo entero y puede resolver el
  ejercicio de la guía correspondiente sin abrir el libro.
