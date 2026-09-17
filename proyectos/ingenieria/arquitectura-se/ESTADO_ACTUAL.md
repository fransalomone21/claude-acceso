# ESTADO ACTUAL — arquitectura-se

**Fase 4 CERRADA** el 2026-09-17. Cerró por las **dos** cosas que la cerraban:
las heurísticas de arquitectura que aplican a un sistema de trabajo de **una
persona**, y **cada una con su caso propio ya vivido** del repo. Una
heurística sin caso no entró, y las que quedaron afuera están listadas con su
motivo. **Abre la fase 5** (diseñar la arquitectura nueva + trade study).

**Los cuatro libros de lectura están cerrados.** La fase 5 es la primera de
diseño.

## Dónde está todo

| Qué | Dónde |
|---|---|
| Destilados del handbook NASA (17 tramos) | `perfil-global/pilares/nasa-seh/` |
| Ficha del INCOSE GtWR (41 reglas) | `perfil-global/pilares/incose-gtwr/reglas.md` |
| Chequeo de requisitos | `perfil-global/pilares/incose-gtwr/verificar-requisito.py` |
| Ficha del INCOSE SEH 5.ª ed. — el mapeo | `perfil-global/pilares/incose-seh/mapeo-15288.md` |
| **Ficha de Rechtin & Maier — las heurísticas con caso propio** | `perfil-global/pilares/rechtin-maier/heuristicas.md` |
| **Cómo se leyó ese libro, y lo que se midió** | `perfil-global/pilares/rechtin-maier/README.md` |
| Medidor de fidelidad de citas (sirve para los **cuatro** libros) | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| Saboteador del medidor | `perfil-global/pilares/nasa-seh/probar-verificar-citas.ps1` |
| Las **10** fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## Medido, no supuesto

- **Rechtin: citas 99/99.** 87/87 por el medidor (mismo de las fases 1-3, con
  `--dir`) **y 12 citas cortas verificadas a mano**, después de auditar el
  denominador: 106 spans candidatos, 87 medidos, 19 descartados y los 19
  abiertos uno por uno. El medidor descarta lo de menos de 40 caracteres o
  menos de 7 palabras, y esta ficha tiene 12 citas cortas legítimas
  (*A model is not reality.*, *Constants aren't and variables don't.*).
  Saboteado: tres sabotajes en rojo, control positivo en verde, limpio al
  final.
- **Ancla de Rechtin: `impresa = PDF − 27`, CONSTANTE**, medida por **dos
  caminos**. 422 de 468 encabezados, **las 422 dan +27, cero excepciones**, y
  191 de 191 entradas del índice cruzadas contra el cuerpo (186 automáticas +
  5 abiertas a mano, que fallaban por el parser del índice). **Van cinco
  libros y cinco anclas: NASA +10, GtWR −1, SEH +25, Douglass no constante,
  Rechtin +27.**
- **Tamaño medido ANTES de decidir cómo leer:** 468 páginas, 1.130.793
  caracteres. Se leyeron **~40 páginas**: Apéndice A completo (el almacén de
  más de 180 heurísticas), capítulo 2 completo, p. 27 y Apéndice C hasta 417.
  Lo que no se leyó está declarado con su motivo en la sección 8 de la ficha.
- **Control positivo antes de creerle a la extracción:** `heuristic` 520 hits,
  `architect` 2299, `architecting` 879.
- **Partición de palabras: es la variante CON guion, la misma del SEH — y aun
  así se midió.** 1907 renglones terminan en guion y **0** casos de la
  variante de NASA. `extraer.py` se copió del SEH y sirvió **sin tocar una
  línea**: es el primer libro de los cinco que no trajo trampa nueva, y eso se
  midió en vez de suponerse. 1743 re-unidas, 129 dejadas, 35 de residuo
  declarado.

## Lo que la fase 4 encontró, y manda a la fase 5

- **Al molde de fase del PDP le falta un campo: CÓMO SE CERTIFICA el criterio
  de salida.** Hoy pide el criterio y no pide el medidor. El caso que lo
  cobró: una fase de `fisica-espacial` cerrada en falso por un `grep` que
  medía si la palabra estaba, no si el contenido estaba.
- **La tercera forma de usar heurísticas —pegarlas a los PASOS del proceso—
  es la que falta.** Hoy `chequeo-de-trabajo.md` se inyecta entero y se lee en
  diagonal, que es la forma 1 a escala. El propio libro advierte el límite: no
  se pueden pegar las que dependen del dominio.
- **Al registro de lecciones le falta el criterio de ENTRADA.** Tiene
  `--triage` (decisión de salida) y no tiene los cinco criterios de selección
  del libro. El campo `triage` ya hace, sin criterio escrito, la distinción
  que el criterio 2 define.
- **El trade study de la fase 5 lleva sus criterios ponderados ESCRITOS
  ANTES**: si empata, lo que se rehace son los criterios, no el estudio.
- **«Chat nuevo cuando cambia la fase» tiene un fundamento nuevo**, y no es el
  costo de contexto: es el único reemplazo de equipo disponible en un sistema
  de una persona. El caso: `verificar-citas.py` v1 lo dio por bueno la sesión
  que lo escribió; los cinco defectos los encontró otra sesión en otra fase.
- **La revisión independiente NO tiene respuesta**, y se declara sin
  respuesta. Es el hueco más grande que encontró esta fase.
- **Cliente, arquitecto y constructor son la misma persona, y eso NO anula las
  heurísticas de cliente: las traduce.** Los dos roles son el que diseña el
  método y el que lo ejecuta el lunes, y ya divergieron: es exactamente por
  qué existe el cuadro PARA FRAN con tope duro y la línea `Cambió`.

## Lo que NO se hizo, y hay que saberlo

- No se tocó **ningún** archivo vivo de la arquitectura. `CLAUDE.md` de la
  raíz, `cascada.ps1`, las naturalezas y las plantillas siguen intactos: la
  migración es la fase 6. Lo único que se tocó afuera del proyecto es
  `pilares/`, que es material de lectura.
- **DEFECTO VIVO ENCONTRADO Y NO ARREGLADO, para la fase 6.**
  `perfil-global/chequeo-de-trabajo.md` línea 19 dice «las **186** lecciones»
  y `perfil-global/herramientas/aprender.py` línea 243 tiene el mismo `186`
  hardcodeado como literal. El registro tiene **201**. `CLAUDE.md` ya prohíbe
  explícitamente ese número, con el caso anterior documentado (decía 45,
  había 76) — y volvió a pasar en otro archivo. **No se arregló acá porque el
  arreglo correcto no es poner 201** (vuelve a diverger) **sino derivarlo del
  registro**, y eso toca una herramienta viva.
- No se leyó la Parte II de Rechtin (dominios, p. 57-215): son heurísticas de
  dominio, y el criterio de salida pedía las de un sistema de una persona. **El
  candidato más probable si la fase 5 lo pide es el capítulo 9** (p. 273-311),
  que elabora las tareas de arquitectura que la ficha usó desde el Apéndice A.
- `perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
  sigue en pie y **se escribió sin abrir el libro**. Contrastarlo es la fase 5.
- No se abrió la 4.ª ed. del SEH (2015). Ni Douglass ni Reinertsen ni Leveson.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  Compró lo que no se podía comprar de otra forma y **no se repite**.
- **Fase 1:** inline, sin fan-out, un solo hilo en Opus.
- **Fase 2:** inline, sin fan-out. 108 páginas, la ficha, la herramienta y dos
  saboteadores por **7 puntos** del límite de 5 h y **0** del semanal.
- **Fase 3:** inline, sin fan-out. ~112 páginas de un libro de 370, la ficha,
  el extractor y el ancla por dos caminos, por **11 puntos** del límite de 5 h
  y **1** del semanal.
- **Fase 4:** inline, sin fan-out. **~40 páginas de un libro de 468, la ficha
  con 99 citas, el extractor, el ancla por dos caminos, el saboteo y una mejora medida al
  medidor de citas, por **12 puntos** del límite de 5 h y **1** del semanal
  (13 % → 25 % y 79 % → 80 %, medidos al cerrar, no estimados).
  **Cuatro fases seguidas sin un solo subagente.**
