# Plan: incorporar las clases 8 y 9 al apunte

**Registrado el 2026-10-05, a pedido de Fran: solo el plan y los contenidos
clasificados, sin redactar ningún módulo.** Redactar es la fase 7 del
[`PDP.md`](PDP.md) y cuesta una sesión por unidad (regla propia 6).

Fuentes leídas: `IISE Clase 8 - 2026.pptx` (98 diapositivas) e
`IISE clase 9 - 2026.pptx` (54), con sus notas de orador. Cobertura medida con
grep sobre `apunte/modulos/*.typ` y `fuentes/glosario.md` el 2026-10-05.

## 0. Antes de escribir una sola línea (paso mecánico, una vez)

1. **Los números de diapositiva de abajo son del `.pptx`.** El PDF de la clase 8
   tiene **97 páginas** y el `.pptx` 98: la diapositiva 44 del `.pptx` es una
   lámina vacía y, de ahí en adelante, **página del PDF = diapositiva − 1**
   (medido en dos puntos: PDF p.49 = «ConOp LDCM» = pptx 50; PDF p.81 =
   «Sumergible ROV, Ejemplo Diagrama Funcional» = pptx 82). El extractor numera
   por PDF. Regla propia 2: **ningún número se cita sin haber mirado el PNG.**
2. Clase 8: copiar `IISE Clase 8 - 2026.pdf` a `fuentes/pdf/` (hoy está en
   Descargas). Clase 9: **no hay PDF**, sólo `.pptx`; exportarlo desde
   PowerPoint (Archivo → Exportar → PDF) a `fuentes/pdf/IISE clase 9 - 2026.pdf`.
3. `python extraer-clases.py --figuras` → `clase-8.txt`, `clase-9.txt`,
   `titulos.md` y los PNG de las láminas-figura.
4. **Las notas de orador no están en el PDF** y tienen contenido que las láminas
   no traen (ver §4). Si hacen falta, volver a leer el `.pptx` con `python-pptx`
   (las notas están en `slide.notes_slide`).

## 1. Qué hay y qué ya está en el apunte

Medido: **WBS, PBS, Gantt, camino crítico, holgura, SIR, LDCM, TESS, SRL, NAR /
Confirmation Review, FMEA/FTA y COTS: 0 apariciones** en el apunte. Lo que sí
está: el triángulo de hierro (M02), la rationale de un requerimiento (M21,
«La rationale»), PDR/CDR/TRR/KDP y baseline alojado (M15), Falcon 9, NOAA, cofia
y *clean room* en el ConOps (M20), TRL con una mención suelta (M13).

### Clase 8 — el plan de trabajo, las estimaciones y ejemplos de sistemas

| Diapositivas (pptx) | Tema | Estado | Destino |
|---|---|---|---|
| 4, 7–14, 20–26, 34, 36–40, 92 | Plan de trabajo: WBS (bottom-up/top-down, niveles, paquetes de trabajo), red de actividades, camino crítico, forward/backward pass, holgura, diagrama de Gantt. Ejemplos: «Haciendo el té» (253 s → 83 s con tecnología nueva), WBS de un CubeSat, WBS estándar NASA/JPL | **nuevo** (0) | **M28** |
| 35 | PBS vs WBS: *de qué está hecho* vs *qué hay que hacer*; cada elemento de la PBS con actividades en la WBS | **nuevo** | M28 |
| 5–6 | Triángulo de hierro | ya está | sólo referencia cruzada a M02 |
| 17–19, 27–33 | Estimación: top-down/bottom-up, pasos, directrices, estimación por fase, tipos de costo (directos, directos generales, G&A), costos de interacción, órdenes de estimación (ROM ±35 % → ±15 % → ±10 %), cuatro categorías de recurso | **nuevo** | **M29** |
| 41–42 | Ciclo de vida con baselines y revisiones (SRR → PDR → CDR → TRR/FRR → ORR); progresión de requerimientos y artefactos por fase | **parcial** (M15 ya tiene las siete fases, las revisiones y los baselines) | sección nueva en **M15**: «Qué congela cada baseline» |
| 43–65 | **LDCM** (satélite Landsat): objetivos de misión, requerimientos de alto nivel, evolución del concepto en Fase A, diagrama de interfaz plataforma–carga útil (C&DH, SSR, S/X-band, buses HSSDB/HSIDB), ConOps con tres segmentos, jerarquía de requerimientos L1–L3, arquitectura del sistema de tierra, subsistemas del S/C, plataforma vs carga útil, integración | **nuevo** | **M30**, un ejemplo de punta a punta como M13 |
| 66–77 | Lanzadores: SZ / SZS / SZZS (diagrama funcional de etapas, ciclo de vida del SZ con SRR/SDR/PDR/CDR/FRR) y Falcon 9 (ConOps, 1.ª etapa reutilizable, ConOps de tierra) | **parcial** (Falcon 9 ya está en M20 como ConOps) | **M31**; el Falcon 9 se cruza con M20, no se repite |
| 78–91, 93 | ROV sumergible: diagramas funcionales (potencia, datos, SW), ejemplo comercial, velocidades de comunicación | **nuevo** | **M32** — *el diagrama funcional como herramienta* |
| 94–98 | Caso NOAA-N′: el satélite se cae del carro de volteo por 24 tornillos sacados sin documentar y un procedimiento de verificación de configuración que no se hizo | **nuevo** | caja de caso en **M36** (une con gestión de configuración) |
| 1–3 | Carátula, temario, videos del TRMM | sin contenido | no entra |

### Clase 9 — Fase B, madurez tecnológica y Fase C

| Diapositivas (pptx) | Tema | Estado | Destino |
|---|---|---|---|
| 9–19, 28–31, 34 | **Fase B**: propósito, requerimientos detallados y árbol trazable, TESS (cámaras y CCD que deben llegar a TRL ≥ 6), comprar o hacer, *trade-off* de la sombrilla dorada, ConOps consolidado, PDR (qué se revisa), revisiones de pares y de subsistema previas, Confirmation Review / NAR, KDP-C, PDR del ROV | **nuevo** (el apunte llega hasta M26, Fase A) | **M33**, espejo de M25 |
| 20–27, 52–54 | **TRL** (9 niveles, uno por uno), **IRL** (5 niveles de la cátedra), **SRL**; qué es «integrar» (la pendiente ascendente de la V); TRL sobre el modelo en V (material de estudio Yasseri y Bahai) | **parcial** (TRL: una mención en M13) | **M34** |
| 3 | Plantilla de requerimientos: ID, origen, enunciado, fuente/fecha, verificación, satisfacción/costo/riesgo 1–5, relacionados/conflictivos, rationale, aprobaciones | **parcial** (la rationale está en M21; faltan los demás campos) | sección en **M21** |
| 4–8 | Interfaces externas S/C–lanzador: adaptador/estructura de empuje, cargas secundarias (ESPA), cofia, Ariane IV, rideshare del Falcon 9 | **nuevo** (M19 trata interfaces en abstracto) | sección en **M19** |
| 32–33, 50–51 | Matriz «funciones clave de la IS por fase» (Pre-A a E) y sus notas, **repetida dos veces** en la clase | **nuevo** | sección en **M15**, junto a la de baselines |
| 35–43, 49 | **Fase C**: diseño final y fabricación, compatibilidad con el lanzador (firma ambiental, interfaces mecánica/eléctrica/datos), verificación de componentes (el thruster), baseline detallado y planes AIT/AIV, curva de costos, componentes de larga fabricación, integración del tanque del SDO y ensayos | **nuevo** | **M35** |
| 44–48 | **CDR** (siete criterios) y **SIR** (cinco criterios), acciones del PDR/CDR cerradas | **parcial** (M15 los nombra; no los desarrolla) | **M36** |

## 2. Propuesta de estructura

| Unidad | Módulos nuevos | Extensiones |
|---|---|---|
| **8** (clase 8) | M28 plan de trabajo · M29 estimaciones · M30 el LDCM · M31 lanzadores · M32 el diagrama funcional y el ROV | M15 (baselines y progresión de requerimientos) |
| **9** (clase 9) | M33 Fase B a fondo · M34 TRL, IRL y SRL · M35 Fase C a fondo · M36 CDR, SIR y el caso NOAA-N′ | M15 (matriz por fase), M19 (interfaces S/C–lanzador), M21 (plantilla) |

Tamaño, **a ojo**: la clase 8 pesa lo que la 6 (155 láminas → 5 módulos) y la 9
lo que la 7 (54 → 4); el apunte rinde ~4,5 páginas por módulo. **9 módulos
nuevos + 4 extensiones ≈ +40 a +55 páginas** (126 → ~170-180).

Cierra la deuda que `carrera/MATERIAS.md` marca para IISE: el **diagrama de
Gantt** pasa de 0 a una sección (M28). QFD y liderazgo **no** salen de estas
clases.

## 3. Cómo se ejecuta (una unidad por sesión)

Modelo Sonnet, esfuerzo medium-high, sin fan-out (igual que las siete primeras).

1. **Sesión A — unidad 8.** Paso 0 de §0. Glosario primero (fase 1 del PDP:
   los términos nuevos entran a `fuentes/glosario.md` con su diapositiva
   *mirada*): WBS, PBS, OBS, paquete de trabajo, red de actividades, evento,
   actividad, camino crítico, holgura, Gantt, estimación de arriba hacia abajo y
   de abajo hacia arriba, ROM, costos directos / directos generales / generales
   y administrativos, plataforma y carga útil, diagrama funcional. Después
   M28 → M32 y la sección de M15. Figuras candidatas (mirar antes de citar):
   pptx 10 (red de cajas), 24 y 26 (WBS), 49 (plataforma–carga útil), 50 (ConOps
   LDCM), 51 (jerarquía de requerimientos), 69–70 (lanzador), 82 (ROV).
2. **Sesión B — unidad 9.** M33 → M36 y las secciones de M15, M19 y M21. Figuras
   candidatas: 23 (escala TRL), 38 (lanzador y su ambiente), 42 (tanque del SDO),
   31 y 49 (puertas de control), 52 y 54 (TRL sobre la V).
3. **Sesión C — cierre.** `verificar-cobertura.py` con los parcialitos nuevos
   si llegaron (**el banco hoy tiene los parcialitos 1 a 5, que llegan hasta la
   clase 6**; no se mapea nada de las clases 8 y 9 hasta que haya preguntas
   reales), republicar
   en Drive con `publicar-apuntes.ps1` y verificar por MD5.

**Criterio de salida de la fase 7** (resultado, no trabajo): los 9 módulos y las
4 extensiones compilan, **cada página se miró**, `verificar-lexico.py` y
`verificar-cobertura.py` en verde, y el PDF nuevo publicado y verificado por MD5.

## 4. Lo que hay que desconfiar antes de escribir

**Las notas de orador no son fuente: son un insumo** (regla propia 3). Tienen
el formato de un texto generado (viñetas con emoji, «Diálogo sugerido»,
«Frase para remarcar en clase») y afirman cosas que **la lámina no dice**:
el rango de −100 a +100 °C en los ensayos térmicos (diap. 42, clase 9), que el
SZ es el Tronador II (diap. 71, clase 8), que «TRL < 6 no pasa a Fase C»
(diap. 11 y 28, clase 9) o que el CDR es «una revisión externa» (diap. 45).
Se contrastan con la lámina y con `perfil-global/pilares/nasa-seh/`; lo que no
se pueda sostener se marca `hipótesis` o no entra.

Contradicciones y errores que ya se ven en el material:

- **CDR y la Fase C.** La nota de la clase 8 (diap. 42) dice que el CDR «es la
  revisión de entrada a la Fase C, no previa a ella»; la clase 9 (diap. 37, 44)
  lo pone como la revisión primaria *de adentro* de la Fase C, con el SIR
  después. `hipótesis`: la nota de la clase 8 está mal. Resolver contra
  `nasa-seh/ciclo-vida.md` antes de escribir M36, y no copiar ninguna de las dos.
- **Siglas de las revisiones.** La clase 9 (diap. 10 y 36) define PLAR como
  «Operational Readiness Review» y repite ORR dos veces; el DR es
  «Decommissioning Review» ahí y «Disposal Review» en la diap. 33; MDR es
  «Mission Design Review» en la 10 y «Mission Definition Review» en la 33. Se
  usa el nombre que sostenga el SEH y lo que ya dice M15/M26, y se anota la
  discrepancia.
- **Tres escalas de madurez que no se mezclan.** TRL de la cátedra (1 a 9,
  diap. 21-23); IRL de la cátedra (**5** niveles, diap. 27); y la escala de
  Yasseri y Bahai (diap. 52-54), donde el TRL va de **0 a 7** sobre un modelo en
  V de petróleo y gas. Es otra escala con el mismo nombre: va aparte, rotulada.
- **Léxico controlado** (regla propia 1): *requerimiento*, no *requisito* (las
  notas dicen «requisitos»); *interesado*, no *stakeholder*. WBS se glosa
  «estructura de desglose de trabajo» una sola vez y después se usa la sigla;
  no se inventa una variante.
- Erratas de las láminas que no se copian: «ChagerCoupleDevice» (diap. 12,
  clase 9), «LDCN» (diap. 45, clase 8), «Activididad» (diap. 10, clase 8).

## 5. Lo que enseñan las clases sobre cómo piensa la cátedra

Se registra acá porque `catedras/` no tiene carpeta de IISE todavía (hoy sólo
Física Espacial, Software de Vuelo y Teoría de Circuitos).

- **Dicho** (grabación de la clase, transcripción que pasó Fran el 2026-10-05):
  en un diagrama de bloques, **conectar un pendrive con el programa cargado
  no es una «interfaz con el humano»: es una conexión de datos entre dos
  recuadros** (el pendrive y el sistema). No hace falta identificar a la
  persona; el ROV de la clase 8 muestra al operador, pero ahí la conexión se
  piensa «en este momento estático».
- **Inferido** (`hipótesis`): la cátedra enseña **los mismos tres artefactos
  una vez por fase** (la matriz de funciones de la IS por fase está repetida
  textualmente en las diap. 32 y 50 de la clase 9) y fija como **puerta**
  que la tecnología esté en TRL ≥ 6 antes de la Fase C. Es lo que más
  probablemente se tome.
- **Inferido**: el ROV (clase 8, diap. 78-93 y 34 de la clase 9) es el
  **ejemplo corriente del TP**: el PDR del ROV (clase 9, diap. 34) lista lo que
  el equipo tiene que demostrar.
