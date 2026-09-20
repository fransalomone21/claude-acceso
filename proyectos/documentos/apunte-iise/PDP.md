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

### Fase 2 — Redacción, una unidad por sesión 🔵 ABIERTA (2026-09-20)

**Criterio de salida por unidad:** sus módulos escritos en Typst, compilando,
con **cada página mirada**, cada figura citada con su diapositiva confirmada
contra el PNG, y `verificar-lexico.py` en verde sobre esos módulos.

Siete sesiones, una por unidad. Modelo Sonnet, esfuerzo high, sin fan-out.

### Fase 3 — Cobertura contra los parcialitos

**Criterio de salida:** cada pregunta de los parcialitos **que sí están** (1, 2
y 3; 16 preguntas) mapeada a un módulo que la responde; ninguna pregunta
huérfana. Es la **validación** del apunte (¿sirve para rendir?), distinta de la
verificación (¿dice lo que tenía que decir y compila bien?).

**Reinterpretada el 2026-09-20, por decisión de Fran.** La versión anterior
esperaba los parcialitos 4 a 7 y dejaba la fase *bloqueada*. No llegaron y no
van a llegar, y además el encargo es **un apunte general de la materia**, no un
preparador de parcialitos: la cátedra puede tomar otra cosa. Así que la
cobertura pasa a ser un **piso, no un techo** — un módulo que ningún parcialito
toca no sobra, y la fase ya no bloquea a ninguna otra.

### Fase 4 — Publicación

**Criterio de salida:** el PDF declarado en `.claude/apuntes-publicos.json`,
subido a la carpeta `IISE` del Drive, y `publicar-apuntes.ps1 -Verificar` en
verde.

## 5. Riesgos

| Riesgo | Cómo se mide | Estado |
|---|---|---|
| Citar una diapositiva equivocada | `verificar-anclas.py`; el ancla se confirma mirando el PNG | **vivo y medido**: de 149 anclas de NotebookLM, sólo 4 coincidían con la página real |
| Usar dos palabras para el mismo concepto | `verificar-lexico.py` | **medido y en verde** desde el 2026-09-20; el saboteador lo pone en rojo |
| Dejar afuera un tema que el parcialito sí toca | cobertura de la fase 3, contra los parcialitos 1 a 3 | **acotado**: los parcialitos 4 a 7 no van a llegar, y el apunte no se escribe en función de ellos (ver fase 3) |
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
| 7 — Creación de arquitecturas, Fase A, N² | 54 | M24–M27 | pendiente |
| 0 — Glosario controlado | transversal | M00 | **escrito** (2026-09-20), 65 terminos |

**Nota sobre la unidad 6 (2026-09-20):** el plan original preveía M19–M22
(cuatro módulos). Al escribirla, la ingeniería concurrente y la mecatrónica
—155 diapositivas en total, la clase más larga— no cabían en ninguno de los
otros cuatro sin diluirlos, así que se agregó un quinto módulo (M23). La
unidad 7 corre en consecuencia un módulo más tarde (M24–M27 en vez de
M23–M26). Es el número de módulos por unidad el que se ajustó — una
estimación, no un contrato —; el criterio de cierre de cada fase no cambió.
