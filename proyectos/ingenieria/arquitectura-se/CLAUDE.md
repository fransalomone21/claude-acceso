# `arquitectura-se` — reformar el método con ingeniería de sistemas

Contrato de contexto. **Índice de qué leer según la tarea**, no explicación de
cómo se trabaja (eso es el perfil global, que se carga solo).

## Qué es este proyecto

Rehacer la arquitectura de trabajo —cascada, PDP, naturalezas, cuadro de fase,
frenos— contrastándola contra el cuerpo formal de ingeniería de sistemas:
NASA SP-2016-6105 Rev2, INCOSE SEH 5.ª ed., INCOSE GtWR, Rechtin & Maier.

**Las necesidades que generaron la arquitectura actual siguen vigentes y no se
negocian.** Cada freno que hoy existe entra a la arquitectura nueva con su
impacto original escrito, o no sale.

## Qué leer, según la tarea

| Si la tarea es… | Leer |
|---|---|
| **Cualquier cosa** | `ESTADO_ACTUAL.md` entero, primero |
| Saber en qué fase estamos y qué la cierra | `PDP.md` § 4 |
| **Reformar la arquitectura: qué estaba roto el 2026-09-28, medido** | [`docs/diagnostico-2026-09-28.md`](docs/diagnostico-2026-09-28.md) — A1–A11 y el N² de interfaces; su camino crítico quedó reemplazado (el orden vigente: la fila de la lluvia, abajo) |
| **T1: qué ve de verdad la sesión de lo inyectado, el umbral del harness y el diseño elegido (núcleo + al paso, medidor)** | [`docs/t1-presupuesto-inyeccion.md`](docs/t1-presupuesto-inyeccion.md) — §7 es el orden de construcción |
| **T11: la puerta de la cascada** — qué se exige leer según la necesidad, cómo frena, cómo se valida | [`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md); el catálogo es `.claude/cascada.json` |
| **T12: simplificar el método** — el costo medido (por turno, sesión y entrada), la matriz de todo el método y qué se poda | [`docs/t12-simplificar.md`](docs/t12-simplificar.md); el instrumento es [`medir-costo.py`](medir-costo.py) |
| **T7: paridad nube/local** — qué llega a la nube y qué no, los hooks trackeados con `$CLAUDE_PROJECT_DIR`, el libro que se trae solo | [`docs/t7-paridad-nube.md`](docs/t7-paridad-nube.md) — §4 quinquies es lo construido y medido; §5 el orden |
| Insumos de validación (P10): sesiones reales que mostraron lo que la arquitectura no veía | [`docs/insumo-2026-09-29-sesion-ides.md`](docs/insumo-2026-09-29-sesion-ides.md), [`docs/insumo-2026-09-29-cambio-externo.md`](docs/insumo-2026-09-29-cambio-externo.md), [`docs/insumo-2026-10-12-nasa-por-etiqueta.md`](docs/insumo-2026-10-12-nasa-por-etiqueta.md) |
| **Sesión de arquitectura creativa, en ultracode: encontrar, registrar y arreglar defectos conceptuales del método** (Fran, 2026-10-12) | [`RETOME.md`](RETOME.md) — el mensaje de retome y la forma de los workflows; el registro es `perfil-global/DEFECTOS-ARQUITECTURA.md` |
| **T13, «la fase manda»: que NASA se ejecute por la FASE del PDP y falle cerrado** (requisitos, alcance, V&V por fase; no por una palabra ni un campo opcional) | [`docs/insumo-2026-10-12-nasa-por-etiqueta.md`](docs/insumo-2026-10-12-nasa-por-etiqueta.md) §2-3; el instrumento es [`medir-fases.py`](medir-fases.py) |
| **Los requisitos del método** (N, L0, L1 y los L2 de cada T-n): contra qué se diseña y se verifica | [`docs/10-requisitos.md`](docs/10-requisitos.md) |
| **El orden de lo que sigue** y las decisiones de Fran | [`docs/lluvia-de-ideas-2026-10-12.md`](docs/lluvia-de-ideas-2026-10-12.md) §6-§7 — dueño del orden; el resto apunta acá |
| El mapa del método y los hallazgos de la búsqueda de defectos (DA-039..DA-053) | [`docs/mapa-metodo-2026-10-12.md`](docs/mapa-metodo-2026-10-12.md), [`docs/hallazgos-2026-10-12.md`](docs/hallazgos-2026-10-12.md) |
| **T14: la puerta infiere sólo de lo que tipea Fran** (construido, `e6d58bb`) | [`docs/t14-lo-que-pide-fran.md`](docs/t14-lo-que-pide-fran.md); el saboteador es [`probar-t14.py`](probar-t14.py) |
| **T14b: mencionar no es pedir** — `cascada -Mencion`, qué libera y qué no (construido, `dade03b`) | [`docs/t14b-mencionar-no-es-pedir.md`](docs/t14b-mencionar-no-es-pedir.md); el saboteador de la auditoría es [`probar-t14b.py`](probar-t14b.py) |
| **T16: el estado se prueba** — requisitos con resultado (verificado / predicho / sin resultado) por nivel, la prueba del producto al entrar, la matriz generada (construido) | [`docs/t16-estado-verificable.md`](docs/t16-estado-verificable.md); el medidor es `matriz-verificacion.py` (raíz), su saboteador [`probar-t16.py`](probar-t16.py) |
| **T17: los conectores bajo la puerta** — compartir o publicar por conector sólo lo declarado; cómo se declara un par o una carpeta (construido, `180821c`) | [`docs/t17-conectores-bajo-la-puerta.md`](docs/t17-conectores-bajo-la-puerta.md); el catálogo es `.claude/conectores.json`, la declaración `.claude/estructura-drive.json`, el saboteador [`probar-t17.py`](probar-t17.py) |
| **T19a: los proyectos de materia no se frenan por la fase NASA** (N-09, construido) | [`docs/t19a-materia-sin-freno-nasa.md`](docs/t19a-materia-sin-freno-nasa.md) |
| **T20: cero divergencias** — cada dato con un dueño, las copias como vista o puntero, el medidor | [`docs/t20-cero-divergencias.md`](docs/t20-cero-divergencias.md) |
| **Migrar (fase 6): qué pieza se instala y qué defecto cierra** | [`docs/arquitectura.md`](docs/arquitectura.md) — el diseño, las 10 piezas P1-P10 y los 14 defectos medidos |
| **Por qué se eligió esta arquitectura y no otra** | [`docs/trade-study.md`](docs/trade-study.md) — criterios ponderados escritos antes, y por qué perdieron A y C |
| **Llenar la matriz de un proyecto, o saber qué rigor le toca a un aspecto** | [`docs/matriz-cumplimiento.md`](docs/matriz-cumplimiento.md) — el molde, el selector de dos ejes y la instancia llenada |
| Diseñar la matriz de cumplimiento (la fuente) | `perfil-global/pilares/nasa-seh/tailoring.md` |
| **Escribir o auditar un requisito** | `perfil-global/pilares/incose-gtwr/reglas.md` — las 41 reglas del GtWR. Y se **mide**: `python perfil-global/pilares/incose-gtwr/verificar-requisito.py <archivo>` |
| Qué mira y qué NO mira ese chequeo | `verificar-requisito.py --cobertura` (matriz de las 41) |
| **Alinear el método con ISO/IEC/IEEE 15288**, o saber qué proceso de NASA equivale a cuál | `perfil-global/pilares/incose-seh/mapeo-15288.md` — el mapeo 17 ↔ 30, con las 10 filas que **no** son 1:1 |
| **Ciclo iterativo, incremental, evolutivo o ágil**; criterios de entrada/salida de una fase ágil | `.../incose-seh/mapeo-15288.md` § 4.3 |
| Tailoring desde INCOSE (proceso con IPO, y las 5 trampas) | `.../incose-seh/mapeo-15288.md` § 4.5 y § 6 |
| Buscar una página del SEH, o regenerar su `.txt` | `perfil-global/pilares/incose-seh/README.md` |
| **El problema está mal planteado y no hay análisis que lo cierre**; qué hacer cuando no hay procedimiento | `perfil-global/pilares/rechtin-maier/heuristicas.md` — las heurísticas de arquitectura que aplican a un sistema de **una persona**, cada una con su caso propio ya vivido |
| Qué cuenta como heurística y qué no (los 5 criterios), y qué le falta a `lecciones.jsonl` | `.../rechtin-maier/heuristicas.md` § 1 y § 4 |
| Buscar una página de Rechtin & Maier, o regenerar su `.txt` | `perfil-global/pilares/rechtin-maier/README.md` |
| Requisitos desde la óptica de NASA | `.../nasa-seh/requisitos.md` + `.../glosario.md` (apéndice C) |
| Definir verificación o validación | `.../nasa-seh/verificacion.md`, `.../validacion.md` |
| Puertas, revisiones y criterios de salida | `.../nasa-seh/ciclo-vida.md` |
| Trade study antes de una decisión | `.../nasa-seh/datos-decision.md` (cap. 6.8) |
| **Escribir un plan** (SEMP, integración, V&V, IRD, CM) | `.../nasa-seh/planes.md` (ap. H-P) |
| **ConOps**, HSI, o el sistema ya en operación | `.../nasa-seh/conops-fase-e.md` (ap. R-T) |
| Riesgo con disparador observable | `.../nasa-seh/riesgo-config.md` |
| Interfaces entre piezas del método | `.../nasa-seh/req-interfaz.md` |
| Una definición exacta | `.../nasa-seh/glosario.md` |
| Buscar una página del handbook | `python perfil-global/pilares/nasa-seh/pag.py <desde> <hasta>` |

Ninguno se lee "por las dudas": los de `nasa-seh/` solos son ~900 KB. Se abre
el que la tarea pide. **Y en la carpeta de cada pilar, entre comillas va sólo
ese libro**: el medidor de citas corre contra un `.txt` por vez, así que una
cita del otro libro da un rojo que no significa nada. Las citas cruzadas se
referencian por su ficha, sin comillas.

## Reglas propias de este proyecto

1. **Nada se cita sin ancla de página, y el ancla es de CADA libro.** Es la
   página **impresa**, la que se puede chequear después. Handbook NASA:
   `PDF = impresa + 10`. INCOSE GtWR: `PDF = impresa + 1`, medida sobre 101
   páginas. INCOSE SEH 5.ª ed.: `PDF = impresa + 25`, medida por **dos**
   caminos (321 encabezados y 41 de 41 entradas del índice). Douglass **no es
   constante** (+9, +8, +7): ahí se lee de la página. Heredar el offset de otro
   libro produce anclas inventadas, y ya van **cinco** libros y **cinco**
   offsets. Rechtin & Maier: `PDF = impresa + 27`, constante, medida por los
   dos caminos (422 encabezados sin una sola excepción y 191 de 191 entradas
   del índice).
2. **El medidor de citas corre antes de cerrar cualquier fase de lectura.**
   Un destilado infiel se ve idéntico a uno fiel; la única diferencia medible
   son las citas textuales. Y el medidor tiene su propio saboteador
   (`probar-verificar-citas.ps1`): un medidor que nunca dijo otra cosa que
   "OK" está sin verificar, y este ya mintió una vez — daba 75,3% mirando el
   27% de las citas.
3. **Inline, sin fan-out.** La fase 0 gastó 2,07 M tokens y un límite de 5 h
   en 6,6 minutos. Compró lo que no se podía comprar de otro modo (297
   páginas no entran en una ventana) y no se repite.
4. **Nada vivo se toca antes de la fase 6.** El diseño y el trade study van
   primero; migrar sin diseño es la falla que este proyecto existe para no
   cometer.
5. **Lo que el destilado agrega o saca va AFUERA de las comillas.** Adentro va
   lo que dice el libro, aunque esté mal escrito — con el `[sic]` afuera. Los
   8 defectos reales que encontró la fase 1 son casi todos esa misma falla.
