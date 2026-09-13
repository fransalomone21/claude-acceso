# PDP — Plan de Desarrollo de Proyecto — Taller de Física

**El PDP se escribe antes de la primera línea de trabajo y se corrige cuando
la realidad lo contradice.** No es un documento de arranque que después queda
viejo: es donde vive el criterio de salida de la fase en curso.

## El método: waterfall en las puertas, agile adentro

- **Waterfall entre fases.** Las fases son secuenciales y cada una tiene una
  **puerta**: un criterio de salida escrito *antes* de empezarla. No se pasa a
  la siguiente sin cerrar la anterior. Una fase abierta y una fase cerrada no
  se parecen en nada, y confundirlas es lo que hace que un proyecto quede
  "95% listo" semana tras semana.
- **Agile adentro de la fase.** Dentro de una fase se itera corto: se prueba,
  se mide el efecto, se ajusta. El plan de las fases *siguientes* se reescribe
  con lo aprendido — eso es lo que lo hace híbrido y no waterfall a secas.
- **El criterio de salida es un RESULTADO, nunca una cantidad de trabajo.**
  "Escribir tres herramientas" no cierra nada. "El valor escrito cambia lo que
  se ve en pantalla, y quedó registrado" sí.

---

## 1. El problema

El Taller de Física es una materia aparte de Física Espacial (distinta
cátedra, y las clases las arma la cátedra del Taller, no un profesor
individual — la dinámica es armar la clase antes de darla). Fran quiere un
apunte propio para sostener esas clases, con el mismo estándar de rigor que
ya tiene el apunte de Física Espacial: toda fórmula se deduce o se cita
explícitamente, nunca hay que "ir a internet" a entender de dónde sale una
ecuación o para qué sirve.

**Para quién es:** Fran, para armar y dar las clases del Taller.

**Cómo sabremos que sirvió (validación):** Fran arma una clase del Taller
apoyándose sólo en este apunte, sin volver a abrir los libros fuente para
entender de dónde sale una fórmula.

## 2. Qué NO es

- **No es una ampliación del apunte de Física Espacial.** Nace como proyecto
  propio a propósito: el otro ya cerró su fase 5 con 149 páginas verificadas
  y un título que no le queda bien a un tercer libro ajeno a esa materia.
- **No arranca todavía.** Fran lo dijo explícito el 2026-09-13: "todo lo de
  taller de física es para un plazo más largo, yo te voy a decir cuándo
  empezarlo". Esta sesión sólo deja la estructura lista — carpeta, PDP,
  fuentes localizadas — no escribe un solo módulo de contenido.
- **No cubre el libro entero de ninguna de las tres fuentes.** Fran pidió
  "lo más importante, sin ir al detalle de todo".

## 3. Naturaleza y criticidad

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |
| Criticidad | `importante` — un apunte con una deducción mal hecha cuesta horas de clase mal armada, pero no es irrecuperable |
| Rigor que le corresponde | mismo que Física Espacial: toda fórmula se deduce o se cita con página exacta; ninguna verificación de render se salta |

## 4. Las fases

> Se escriben todas las que se ven hoy, pero **sólo la próxima lleva criterio
> de salida detallado**. Las de más adelante se reescriben cuando llegue su
> turno: escribirlas en detalle ahora es planificar con la información de hoy
> un trabajo que se hace con la de mañana.

| # | Fase | Criterio de salida (resultado verificable) | Estado |
|---|---|---|---|
| 0 | Estructura y fuentes | Proyecto creado (este PDP), las tres fuentes localizadas en el disco con ruta exacta, y el recorte de temas de cada una confirmado por Fran | **CERRADA (2026-09-13)** |
| 1 | Escribir (bloqueada) | Sin detallar todavía — el recorte ya está confirmado, falta sólo que Fran dé la luz verde para empezar | **bloqueada, sin arrancar a propósito** |

**Fase en curso:** ninguna — la 0 está cerrada y la 1 está bloqueada a
propósito hasta que Fran lo pida.
**Qué cerró la fase 0:** las tres fuentes con ruta confirmada en
`fuentes/RUTAS.md`; Ferraro con alcance fijo (caps. 1-3, el PDF que Fran
pasó); Young-Freedman como referencia general sin capítulos fijos; y
Pisacane con su recorte confirmado por Fran el 2026-09-13: **"correlativo =
continúa un tema ya confirmado, sumá el 5"** — 7 capítulos: **3, 4, 5, 6, 8,
9, 11** de 12. Detalle completo en `docs/bitacora.md`.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Una sesión futura arranca a escribir sin que Fran haya dado la luz verde | media | alta — trabajo tirado o que hay que rehacer con el recorte que corresponde | evitar | este PDP dice explícito "fase 1 bloqueada"; toda sesión nueva lee esta sección antes de escribir un módulo |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-09-13 | Documento propio, proyecto separado de Física Espacial | Parte VI del mismo `apunte.typ` | El Taller es materia aparte (palabras de Fran); mezclar rompe el título del apunte ya cerrado (149 pág., fase 5 verificada) y no hace falta tocarlo |
| 2026-09-13 | Ferraro entra completo: los 3 capítulos que Fran pasó (1: pre-Einstein e incl. Galileo; 2: búsqueda del éter; 3: relatividad especial) | Recortar más adentro de esos 3 capítulos | Fran los confirmó como bloque cerrado — el PDF que pasó ya viene pre-recortado a esos 3 de los 9 del libro completo |
| 2026-09-13 | Young & Freedman ("Física universitaria 2") entra como referencia general, sin capítulos fijos | Acotar a un rango de capítulos (física moderna, o electromagnetismo) | Fran: "tenelo de referencia para los temas que hay que desarrollar", no una fuente con recorte propio como las otras dos |
| 2026-09-13 | "Correlativo" = continúa un tema ya confirmado (no "mismo dominio") | La lectura "mismo dominio", que daba 6 capítulos sin el 5 | Fran lo confirmó explícito: "correlativo = continúa un tema ya confirmado, sumá el 5" |
| 2026-09-13 | Recorte de Pisacane CERRADO: 7 capítulos — **3, 4, 5, 6, 8, 9, 11** de 12 | Los 6 capítulos sin el 5 (propuesta original de la sesión) | El M6 de Física Espacial sólo cubre gravitación básica de Newton; Pisacane cap. 5 agrega potencial de orden superior, WGS84, mareas y precesión por J2, que sí continúan ese tema confirmado |
| 2026-09-13 | Fase 1 (escribir) queda bloqueada a propósito, sin fecha, aun con el recorte ya cerrado | Arrancar ya que el recorte está confirmado | Fran: "todo lo de taller de física es para un plazo más largo, yo te voy a decir cuándo empezarlo" — esa condición no cambió con la confirmación del recorte |

## 7. Verificación

**PENDIENTE** — no hay entregable de contenido todavía. Cuando la fase 1
arranque, la verificación es la misma que ya usa Física Espacial (mirar la
página compilada, nunca confiar en que Typst compiló) — ver
`../fisica-espacial/CLAUDE.md`, regla propia 1.
