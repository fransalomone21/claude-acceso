# Mapa del método — 2026-10-12

Este documento es el **insumo de la búsqueda de defectos** de la sesión de arquitectura del 2026-10-12. Junta los mapas de siete lectores, uno por subsistema: inyección y arranque; puerta, cascada y fase; PDP, plantillas y cuadro; lecciones, defectos y auditoría; verificadores y saboteadores; estado, handoff y retomes; nube y paridad. **No falta ninguno.** El grado de cada dato (`leído`, `medido`, `declarado`, `hipótesis`) lo puso el lector, y acá se copia sin subirlo. Las evidencias (`ruta:línea`) también se copian tal cual. Si dos lectores se contradicen, van las dos versiones.

---

## 1. Inyección y arranque

**Resumen.** Hay dos capas de hooks que se suman.

- **La de usuario** (`~/.claude/settings.json`). En SessionStart, `emitir-contexto.ps1` inyecta pilares (2 partes), apertura y núcleo (4 partes), con un tope de 9 000 por parte. En cada UserPromptSubmit inyecta el recordatorio. Además corren al-paso.py en PreToolUse y puerta-afuera.py en los cuatro eventos.
- **La de proyecto.** Corre arranque-proyecto.ps1 y arranque-medicion.ps1, que hace chequeo-completo con `-SoloMedidores -FechaLimite 40` y un timeout de 60. También corren traer-perfil.sh (sólo en la nube) y cascada_puerta.py en los cuatro eventos.

Fuera de la puerta y los guardias, todo informa y nada frena. **Ninguna inyección se dispara por la fase ni por el proyecto.**

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| emitir-contexto: pilares 1/2, 2/2 | `~/.claude/hooks/emitir-contexto.ps1`; settings usuario :129-142 | SessionStart | informa | 12 865 B por sesión (~7 940 por parte, t12 §9) | medir-inyeccion.py; verify-install |
| emitir-contexto: apertura | settings usuario :149-150 | SessionStart | informa | 6 456 B | medir-inyeccion |
| emitir-contexto: núcleo 1..4/4 | settings usuario :157-182 | SessionStart | informa | 28 214 B, la pieza fija más grande | medir-inyeccion (rojo si una parte pasa el tope) |
| recordatorio-transversal | settings usuario :197-202 | UserPromptSubmit | informa | 1 790 B por turno | medir-inyeccion |
| al-paso.py | `~/.claude/hooks/al-paso.py:54-88` | PreToolUse por herramienta, patrón o ruta | informa | ≤9 000 por disparo; 0-16 044 por sesión; ~200 ms por llamada | disparos.log; dedup por session_id |
| puerta-afuera.py | settings usuario :190,210,250,262 | los 4 eventos | frena fuera del árbol | un proceso Python por evento | no verificado |
| guardia-fanout / guardia-heredoc | settings usuario :222-232 | PreToolUse | frena (pregunta o niega) | un PowerShell por llamada | probar-guardia-fanout |
| arranque-proyecto.ps1 | `.claude/settings.json:8-9` | SessionStart | informa | 3 078 B; 15 s | medir-inyeccion |
| arranque-medicion.ps1 | `.claude/hooks/arranque-medicion.ps1:1,28,55` | SessionStart (startup/resume/clear) | informa | ≤40 s de pared; 109,7 s en serie | saboteadores, por antigüedad |
| chequeo-completo -SoloMedidores | `chequeo-completo.ps1:36-95,160-163` | lo llama el arranque, o a mano | informa (sale con 1 y nadie lo consume) | 109,7 s en serie, ~40 s en paralelo | capa lenta, manual |
| cascada_puerta.py (vía lanzador) | `.claude/settings.json:38,49,72,95` | los 4 eventos | frena | lo exigido: 105 697 car. hoy; 448 352 en una de BLACK | probar-cascada; --verificar |
| traer-perfil.sh | `.claude/settings.json:28` | SessionStart, sin PowerShell | no (exit 0) | 60 s, sólo nube | estado-nube --simular |
| CLAUDE.md ×3 + MEMORY.md | nativos del harness | inicio; nested al leer una subcarpeta | no | 14 439 + 16 613 + 8 878 B; nested 0-32 997 | ninguno propio; medir-costo.py |

**Interfaces**
- perfil-global → `~/.claude` → emitir-contexto. Dueño: perfil-global, vía install.ps1 (`emitir-contexto.ps1:50-52`).
- settings (cantidad N de partes) ↔ tamaño del archivo. Hay dos dueños. Si hacen falta más partes, la última se lleva el resto y pasa el tope (`emitir-contexto.ps1:117-120`).
- emitir-contexto y al-paso → `hooks/disparos.log` (`:57-71`; `al-paso.py:59`).
- arranque-medicion → chequeo-completo: veredicto verde, rojo o SIN MEDIR (`arranque-medicion.ps1:55`; `chequeo-completo.ps1:41-46,160-163`).
- chequeo-completo → `.claude/ultimo-chequeo.json` (`:51`).
- medir-inyeccion → hooks: caracteres emitidos contra el corte de 10 000 / 2 000 (`chequeo-completo.ps1:82-86`).
- harness (session_id) → `al-paso-estado/` (`al-paso.py:21-30,179-187`).
- Los dos settings registran hooks en el mismo evento (usuario :190-263; proyecto :38-95).

**Mediciones**
- Bytes que entran solos: **92 333** (wc -c).
- Hooks por evento: SessionStart 8+4, UserPromptSubmit 2+1, PreToolUse 4+2, PostToolUse 1+2.
- Timeouts: los de proyecto son 15, 60, 60 y 15. Los de usuario no declaran ninguno (60 por defecto, hipótesis t1 :233).
- Fecha límite interna: 40 s.

**Modos de falla (Leveson)**
- *Tarde.* publicar-apuntes es bimodal (10-11 s o 45-46 s): en el modo lento queda SIN MEDIR y la causa no está medida (`chequeo-completo.ps1:57-60`). Leído; medido por la sesión que lo escribió.
- *Actúa mal.* Si una parte crece por encima del tope, el harness la corta a 2 000 y sólo lo detecta el arranque siguiente (`emitir-contexto.ps1:34-37,117-120`). Leído.
- *No actúa.* Un rojo del arranque no impide trabajar (DA-019) (`arranque-medicion.ps1:55-66`). Leído.
- *Deja de actuar.* Los hooks de usuario no tienen timeout. Si emitir-contexto falla, sale con 1 sin texto y el aviso va a stderr (`emitir-contexto.ps1:73-77`). Leído; el efecto en la sesión es hipótesis.
- *Actúa mal.* El núcleo y los pilares entran igual en cualquier tarea, y al-paso se dispara por palabra o ruta, nunca por fase (`al-paso.py:64-83`). Leído.
- *Tarde.* Procesos por evento: al-paso suma ~200 ms por herramienta, ~17 s por sesión (`t1-presupuesto-inyeccion.md:279`). Declarado.

**Observaciones conceptuales**
1. **Dos puertas en los mismos cuatro eventos** (puerta-afuera y cascada_puerta). Que la de afuera se abstenga adentro no tiene prueba de efecto. Evidencia: settings usuario :190,210,250,262; proyecto :38,49,72,95. Grado: hipótesis. Relación: nuevo, cerca de DA-010.
2. **La capa rápida creció más de 15 veces.** El encabezado dice ~7 s; lo medido es 109,7 s en 12 medidores. No hay techo por medidor ni criterio de admisión. Evidencia: `chequeo-completo.ps1:16-17,29`; t12 :298. Grado: leído contra medido. Relación: DA-012, DA-016.
3. **Ningún medidor tiene presupuesto propio.** La fecha límite es global: sumar uno lento deja a otros SIN MEDIR sin que nadie lo decida. Evidencia: `chequeo-completo.ps1:41-46,53-95`. Grado: leído. Relación: nuevo, complementa DA-011.
4. **SIN MEDIR no se persiste.** No se registra como deuda ni se acumula. Evidencia: `chequeo-completo.ps1:160-163`; `arranque-medicion.ps1:19`. Grado: leído; la acumulación es hipótesis. Relación: DA-001.
5. **El número de partes y el tamaño tienen dos dueños.** Evidencia: settings :157-182; `emitir-contexto.ps1:117-120`. Grado: leído. Relación: DA-017.
6. **~92 K fijos por sesión más 1,8 K por turno, sin inyección por fase**, aunque arranque-proyecto ya conoce el árbol. Evidencia: wc -c; `al-paso.py:64-83`. Grado: medido y leído. Relación: DA-033.
7. **MEMORY.md (8 878 B) crece sin tope**, y medir-inyeccion no mira la carga nativa. Evidencia: `chequeo-completo.ps1:82-86`. Grado: medido y leído. Relación: DA-016.
8. **La especificación del cuadro vive en cuatro lugares**: reglas 10-12, apertura, recordatorio y la skill. Evidencia: `t12-simplificar.md:118-121`. Grado: declarado. Relación: DA-017.

---

## 2. Puerta, cascada y fase

**Resumen.** La puerta decide a qué proyecto se le cobra cada acción, en dos pasos.

1. `proyecto_de` mira la ruta, el comando, el cwd y las carpetas locales.
2. Si eso no alcanza, usa `st['inferidos']`: el primer proyecto que nombró algún pedido por señal (l.516-519). Ese estado **sólo acumula y no vence**.

Hoy pasó así: un retome pegado que decía BLACK ató la sesión a BLACK. Las señales son regex sobre todo el pedido y no distinguen si el texto es una cita.

El lanzador fija una sola política de falla: en PreToolUse falla cerrado (salvo una lista de reparación) y en los demás eventos falla abierto. Fuera del árbol corre puerta-afuera. El costo de lo exigido lo domina la base (sobre todo el contrato) y los conceptos por archivo: requisitos hasta ~100 K, freno ~25 K. **Ningún disparador mira la fase (DA-033).**

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| proyecto_de | `.claude/hooks/cascada_puerta.py:278-318` | PreToolUse (Edit/Write/Bash/PS) | alimenta a pre() | ms | autotest (casos 2026-10-07) |
| inferidos_de + prompt() | `cascada_puerta.py:321-345,663-690` | UserPromptSubmit (palabra; lo pegado cuenta) | informa | una línea por proyecto | caso 15 + dos mutantes (t11 §4.6) |
| pre(): fallback al inferido | `cascada_puerta.py:508-534` | PreToolUse con inferidos | frena | deny de 1-2 K | lección 331 en rojo; nada prueba que venza |
| Catálogo de señales | `.claude/cascada.json:148-205` | se lee en cada evento | dato | 206 líneas | no mide lo específico de las señales |
| exigido(): base | `cascada.json:7-14` | primera escritura sobre un proyecto | frena | 25-35 K (arquitectura-se); >50 K (black) | autotest |
| Necesidades | `cascada.json:16-106` | manual (cascada.ps1 -Necesidad) | frena | 0 a ~50 K | autotest |
| Conceptos | `cascada.json:108-146` | archivo o patrón de comando | frena | 25-100 K de una vez | autotest |
| Salida de sólo lectura | `t11-cascada-obligatoria.md:130-134` | PreToolUse | deja pasar | nulo | controles positivos |
| Excepción | `t11:136-140` | manual | abre | un comando | caso 15 |
| Estado (caja negra) | `cascada_puerta.py:349-426` | cada evento | no | una línea por evento | concurrencia (1 057 de 1 200 sin candado) |
| puerta-lanzador.py | `.claude/hooks/puerta-lanzador.py:91-124` | todo evento | frena con la puerta rota | un intérprete; 12 s | --autotest (l.127-201) |
| puerta-afuera.py | `perfil-global/hooks/puerta-afuera.py:123-168` | eventos fuera del árbol | frena | 3 intérpretes por evento | --autotest (l.171-244) |
| toca_arbol | `puerta-afuera.py:117-120` | PreToolUse afuera | frena | nulo | un caso |
| fase_activa.py | `.claude/hooks/fase_activa.py` | PostToolUse sobre un proyecto | informa (falla abierto) | un bloque por sesión | afuera l.207-209 |
| cascada.ps1 | `t11:101` | manual | no | lista + lecciones | ninguno propio (hipótesis) |

**Interfaces**
- UserPromptSubmit → `st['inferidos']` (`:674-677`).
- inferidos → pre() (`:516-519`).
- tool_input + cwd → proyecto_de (`:278-318`).
- cascada.json → exigido() (t11 l.99).
- PostToolUse Read → estado (t11 l.142-147).
- cascada.ps1 → estado y excepciones (t11 l.136-140).
- settings → lanzador (`puerta-lanzador.py:1-27`).
- Perfil → puerta-afuera → lanzador y fase_activa. La raíz sale de origen.txt o de CLAUDE_ACCESO_DIR (`puerta-afuera.py:37-46,139-149`).
- lanzador y afuera → estado → auditar-sesion. **La escritura está duplicada en tres piezas** (`puerta-lanzador.py:69-88`; `puerta-afuera.py:85-103`).

**Mediciones**
- Techo de exigidos: **291 550 B** sumados.
- Por archivo: nucleo-ise 11 410; black/CLAUDE 22 539; GtWR 38 997; NASA requisitos 46 839; lecciones-aprendidas 43 364; etc. (wc -c).
- Tamaños: lanzador 207 líneas, puerta-afuera 250, cascada.json 206.
- Proyectos con señal: **17 de 22**. Sin señal: arquitectura-se, catedras, repaso-iise, diagnostico-msi y telefono-samsung.
- Intérpretes por evento: 2 adentro, 3 afuera.

**Modos de falla**
- *Actúa mal.* La inferencia no vence nunca: un retome con BLACK ata la sesión (`:420-425,516-519`). Leído; el caso de hoy, declarado.
- *Actúa mal.* Las señales corren sobre todo el prompt, y hay palabras comunes que cuentan como señal fuerte (`:333`; `cascada.json:188,193,200,204`). Leído.
- *Actúa mal.* Con varios inferidos manda el primero, no el último (`:519`). Leído.
- *No actúa.* Los proyectos sin señal no se infieren, y una acción fuera del árbol pasa (`cascada.json:158,171,182,189,194`). Leído; que haya ocurrido es hipótesis.
- *No actúa.* Una ruta armada con variables no se atribuye (`:294-295`). Leído.
- *Actúa mal.* toca_arbol decide por substring (`puerta-afuera.py:117-120`). Leído.
- *Tarde.* Un concepto cobra 25-100 K en medio de la tarea y se vuelve a cobrar después de compactar (`cascada.json:109-134`; t11 l.142-144). Medido y leído.
- *Deja de actuar.* Sin origen.txt ni la variable, puerta-afuera calla (`puerta-afuera.py:37-46,129-131`). Leído.

**Observaciones conceptuales**
1. **La inferencia por palabra es un estado sin vencimiento**: una sospecha vieja pesa lo mismo que una declaración, y para soltarla hay que hacer un acto falso. Evidencia: `:420-425,516-534`. Grado: leído. Relación: extiende DA-033 y DA-001; nuevo.
2. **Atribuir una acción sin dueño no mira la acción.** Se diseñó para la lección 331 y termina cobrándole todo al primer proyecto nombrado. Evidencia: `:513-519`; t11 l.164-168. Grado: leído. Relación: nuevo, junto a DA-033.
3. **El sensor no distingue autoría**: un retome, un log o la salida de un workflow pesan como pedido de Fran. Evidencia: `:674`; t11 l.162-192. Grado: leído. Relación: nuevo; DA-033, DA-023.
4. **El costo se gradúa por archivo tocado, no por fase ni por tarea.** Evidencia: `cascada.json:109-134`. Grado: medido y leído. Relación: DA-033, DA-005.
5. **El catálogo cablea lecturas entre proyectos** (m24 de apunte-iise, el contrato de fisica-espacial). Evidencia: `cascada.json:24,94`. Grado: leído. Relación: DA-017, DA-010.
6. **El nombre del estado y el registro de caídas están copiados en tres piezas.** Evidencia: `puerta-lanzador.py:69-88`; `puerta-afuera.py:85-103`; `cascada_puerta.py:349-350`. Grado: leído. Relación: DA-017.
7. **Una puerta sana pero lenta (>12 s, tres intérpretes) se lee como REVENTO**, y no hay caso de lentitud en el autotest. Evidencia: `puerta-lanzador.py:40,109-110`. Grado: hipótesis. Relación: nuevo; DA-023.
8. **arquitectura-se no tiene señal**, y el método se cambia en perfil-global y .claude/, que no son proyecto: lo cubre el concepto `freno`. Evidencia: `cascada.json:182-183,127-129`. Grado: leído. Relación: DA-010.

---

## 3. PDP, plantillas, naturalezas y cuadro

**Resumen.** El subsistema tiene:
- una plantilla de PDP (9 576 B, 8 secciones) y tres naturalezas (11 429 B);
- un generador manual y 19 PDP reales;
- dos medidores de forma (medir-fase y medir-matriz);
- la compuerta fase_activa (PostToolUse, falla abierto);
- la especificación del cuadro.

**Nada frena.** Las mediciones:
- medir-fase: 12 OK, 0 rojo, 7 «viejo» (37 % fuera del medidor).
- medir-matriz: 14 matrices, 114 filas, 10 recortes, todos con su resta.
- La compuerta encuentra el tipo NASA en 8 de 19. En 8 lee la fase sin tipo, y en 3 no hay fase activa; teoria-circuitos tiene el parseo roto.

El tipo NASA no tiene campo en la plantilla: vive en prosa. El PDP de arquitectura-se no tiene §6 ni §7. apunte-iise está CERRADO y tiene una fase abierta.

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| Plantilla PDP | `plantillas/PDP.md` | manual (nuevo-proyecto) | no | 9 576 B | indirecto: medir-fase (`:56-73`) |
| Naturalezas | `plantillas/naturalezas/*.md` | entrada al proyecto | sólo vía la puerta | 2 998 / 4 908 / 3 523 B | no encontrado |
| nuevo-proyecto.ps1 | `nuevo-proyecto.ps1` | manual | avisa si el JSON es inválido (l.125-175) | 212 líneas | no encontrado |
| PDP reales (19) | `proyectos/*/*/PDP.md` | los leen fase_activa y la puerta | no | 39 a 508 líneas | medir-fase y medir-matriz |
| medir-fase.py | `perfil-global/herramientas/medir-fase.py` | `chequeo-completo.ps1:81` | informa | 170 líneas | no visto |
| medir-matriz.py | `perfil-global/herramientas/medir-matriz.py` | `chequeo-completo.ps1:78` | informa | 218 líneas | no visto |
| fase_activa.py | `.claude/hooks/fase_activa.py` | PostToolUse, primer toque por sesión y proyecto | no (falla abierto, l.15) | pocas líneas | --autotest (l.160-190) |
| Especificación del cuadro | `perfil-global/apertura-proyecto.md` | SessionStart | no | 6 456 B | no encontrado |
| Recordatorio | hook UserPromptSubmit | cada turno | no | 1 154-1 683 car. | no evaluado |
| Skill cuadro-de-fase | `perfil-global/cuadro-de-fase/SKILL.md` | invocación | no | 5 944 B | no |
| nucleo-ise | `perfil-global/pilares/nucleo-ise.md` | la puerta lo exige | vía la puerta | 11 410 B | el de la puerta |
| arquitectura.md | `arquitectura-se/docs/arquitectura.md` | necesidad metodo | no | >600 líneas | n/a |
| matriz-cumplimiento.md | `arquitectura-se/docs/matriz-cumplimiento.md` | necesidad metodo | no | no medido | medir-matriz |

**Interfaces**
- Plantilla → PDP: copia única al nacer (`nuevo-proyecto.ps1:109-120`).
- nuevo-proyecto → cascada.json: **no escribe `requisitos`** (`:133-150`).
- PDP → fase_activa: tipo NASA por regex (`fase_activa.py:70-118`).
- fase_activa → línea Fase del cuadro (`:123-124`; `apertura-proyecto.md:33-34`).
- PDP §4 → medir-fase (`:75-107`).
- PDP §8 → medir-matriz (`plantillas/PDP.md:201-203`).
- Medidores → chequeo-completo (`:78,81`).
- apertura → recordatorio (`apertura-proyecto.md:1-3`).
- nucleo-ise §2/§2b → plantilla: **no hay sección de alcance, de requisitos ni de plan de V&V por fase** (`nucleo-ise.md:38-60`).

**Mediciones**
- 19 PDP: 12 verdes y 7 sin migrar (catedras, clase-asincronica-3, clases-aed, fisica-espacial, taller-de-fisica, teoria-circuitos, coaching).
- 14 matrices. minecraft-amigos tiene 1 sola fila.
- Tipo NASA legible en 8 de 19.
- 6 PDP sin §8. arquitectura-se no tiene §6 ni §7. clases-aed tiene 5 secciones y fisica-espacial 6, con estructura propia.
- Tamaños: 39 a 508 líneas.

**Modos de falla**
- *Actúa mal.* En teoria-circuitos inyecta «NINGUNA (la 9 (tipo **Fase C**: los requisitos `G1-01` a)». Medido.
- *No actúa.* 8 PDP sin tipo salen verdes, porque medir-fase no exige el tipo (`medir-fase.py:75-107`). Medido.
- *Deja de actuar.* «Viejo» es una amnistía sin vencimiento: 37 % (`:28-35`). Medido.
- *Actúa mal.* apunte-iise está CERRADO y la compuerta inyecta «7 -- Las clases 8 y 9», Fase B. Medido.
- *Tarde.* La compuerta corre en PostToolUse: la primera acción ya se hizo sin ella (`fase_activa.py:13-15`). Leído.
- *No actúa.* «Cómo se certifica» acepta cualquier texto más largo que MINIMO (`medir-fase.py:36-40,101-106`). Leído.
- *No actúa.* Un proyecto nace sin `requisitos` en cascada.json (`nuevo-proyecto.ps1:133-150`). Leído.
- *Deja de actuar.* Nada detecta un PDP que dejó la estructura de la plantilla. Medido.

**Observaciones conceptuales**
1. **El tipo NASA, que es lo que activa la compuerta, no tiene campo en la plantilla.** Evidencia: `plantillas/PDP.md:96-99`; `fase_activa.py:93-118`. Grado: leído y medido. Relación: DA-024, DA-030, DA-033.
2. **El ciclo NASA se aplica por analogía a los documentos**, sin productos de fase definidos para un apunte. Evidencia: software-de-vuelo «Fase D», carrera «Fase E»; `nucleo-ise.md:38-45`. Grado: medido; la consecuencia es hipótesis. Relación: DA-004, DA-027.
3. **«Venimos» pide cuánto falta para la meta, y la plantilla detalla sólo la próxima fase.** Evidencia: apertura (Venimos) contra `plantillas/PDP.md:91-94`. Grado: leído. Relación: nueva, cerca de DA-002.
4. **Los medidores miden existencia, no vigencia ni coherencia.** Evidencia: apunte-iise. Grado: medido. Relación: DA-018, DA-011, DA-017.
5. **«Viejo» no tiene vencimiento ni dueño.** Evidencia: `medir-fase.py:28-35`. Grado: medido. Relación: DA-001, DA-019.
6. **arquitectura-se no cumple su propia plantilla.** Evidencia: grep `^## `. Grado: medido. Relación: DA-008, DA-031.
7. **La plantilla es una copia al nacer**: si cambia el molde, los PDP no se enteran. Evidencia: `nuevo-proyecto.ps1:109-120`. Grado: leído. Relación: DA-017, DA-030.
8. **Los PDP crecen sin techo.** §4 ocupa 391 líneas en fisica-espacial y 277 en black. Evidencia: wc -l. Grado: medido. Relación: DA-016, DA-035.

---

## 4. Lecciones, defectos, auditoría y lluvia

**Resumen.** Son cuatro lazos y comparten el disparador: **la acción manual del cierre**.

1. **Lecciones.** `aprender.py` valida al entrar, pero una lección llega a la sesión sólo si alguien escribe la viñeta en chequeo-de-trabajo.md.
2. **Defectos.** `defectos.py` frena el cierre falso, pero nadie lo dispara.
3. **Auditoría.** No hay hook Stop. Hay 21 informes y sólo 2 tienen ROJO.
4. **Lluvia de ideas.** Cuenta sesiones *auditadas*.

Nada frena la sesión en curso: el rigor está en la contabilidad.

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| aprender.py agregar | `perfil-global/herramientas/aprender.py:448` | manual | frena el registro mal formado (l.425-440, 473) | ~0 | no se encontró propio |
| lecciones.jsonl | `perfil-global/aprendizaje/lecciones.jsonl` | lo escribe aprender.py | no | 328 481 B; no se inyecta | n/a |
| aprender.py sin-triage | `aprender.py:554` | arranque (`chequeo-completo.ps1:56`) | informa | parte de los 109,7 s | probar-chequeo-lecciones |
| chequeo-de-trabajo.md | `perfil-global/chequeo-de-trabajo.md` | manual | no | 170 966 B | n/a |
| nucleo-chequeo.py | `perfil-global/herramientas/nucleo-chequeo.py:1-20` | install.ps1; 4 hooks SessionStart | informa | 28 214 B por sesión | --verificar |
| al-paso.py | `perfil-global/hooks/al-paso.py:1-40` | PreToolUse por herramienta | no (falla abierto) | ≤9 000 B por clave | no verificado |
| Listado de lecciones del proyecto | `.claude/hooks/cascada_puerta.py:799-813` | cascada.ps1 | informa (sólo títulos) | no medido | no |
| defectos.py | `perfil-global/herramientas/defectos.py:14-25,156-206` | manual | frena el cierre falso (l.172, 198) | verificar --correr es lento | autotest l.288; sabotaje l.374, l.352 |
| auditar-sesion.py | `auditar-sesion.py:310-375` | manual; sin hook Stop | informa (exit 1 sin consumidor) | un comando | --autotest (l.412), capa lenta :128 |
| .claude/auditorias/ | `.claude/auditorias/` | auditar --escribir | no | 21 archivos | n/a |
| lluvia-de-ideas.py aviso | `lluvia-de-ideas.py:93-108` | `cascada.ps1:371` | informa (return 0) | un print | --autotest / --sabotaje |

**Interfaces**
- Sesión → jsonl (`aprender.py:448-508`).
- jsonl → chequeo-de-trabajo.md: **el paso es humano y no tiene dueño** (`nucleo-chequeo.py:1-14`).
- md → núcleo → SessionStart.
- md → al-paso (`al-paso.py:126-129`).
- Caja negra + git → auditar (`cascada_puerta.py:696`; `auditar-sesion.py:318-320`).
- cascada.json `requisitos` → P7 (`:333-335`).
- auditorias → defectos validar (`defectos.py:127,182-198`).
- auditorias → lluvia (`lluvia-de-ideas.py:52-75`).
- jsonl → P10 (`auditar-sesion.py:278,362-368`).

**Mediciones**
- Nivel: 379 lecciones; **308 sin nivel (81 %)**, herramienta 37, regla 15, parche 11, flujo 8, **meta 0**.
- Triage: foldeada 188, propia 158, fuera 33, sin triage 0.
- Tamaños: chequeo 170 966 B, núcleo 28 214 B, jsonl 328 481 B.
- Informes con ROJO: 2 de 21.
- Líneas con P10 en ROJO o P7 en NO APLICA: 24.
- Hook Stop: no existe.

**Modos de falla**
- *No actúa.* Sin disparador, si la sesión corta por el límite no hay informe, y validar y lluvia quedan sin entrada. Leído.
- *No actúa.* Una lección no llega a ninguna sesión hasta que alguien escribe la viñeta (`nucleo-chequeo.py:1-14`). Leído.
- *Actúa mal.* Para P10, una falla es sólo una caída de la puerta o una excepción. Las 46 negadas de 2 115 o un ROJO de P7/P8 no cuentan (`auditar-sesion.py:364`). Leído.
- *Actúa mal.* P10 da VERDE con cualquier lección nueva, aunque no tenga que ver (`:367-368`). Leído.
- *Tarde.* La auditoría corre al final y no corrige nada en la sesión (`:28`). Leído.
- *Deja de actuar.* Si no se audita, el contador de lluvia se congela (`lluvia-de-ideas.py:52-75`). Leído.
- *No actúa.* Validar exige 3 auditorías manuales, y van **0 de 38 defectos validados** (`defectos.py:15-16,182-198`). Leído; la causa es hipótesis.

**Observaciones conceptuales**
1. **La auditoría manual es el cuello común de tres lazos** (validar, lluvia y P10), y no hay medidor de sesiones sin auditar. Evidencia: `defectos.py:127`; `lluvia-de-ideas.py:52`; no hay Stop. Grado: leído. Relación: extiende DA-026 y DA-019; nuevo como acoplamiento.
2. **jsonl → md es un paso humano.** El núcleo dice ser vista de una fuente que a su vez es una copia curada. Evidencia: `nucleo-chequeo.py:12-13`. Grado: leído. Relación: DA-017, DA-007.
3. **El 81 % sin nivel y 0 lecciones de nivel meta**: hoy no se puede medir a qué nivel aprende el método. Grado: medido. Relación: nueva; DA-011.
4. **Los frenos fuertes están en las herramientas de registro, no en la sesión.** Evidencia: `defectos.py:172,198` contra auditar sin consumidor. Grado: leído. Relación: DA-019.
5. **2 ROJO en 21 informes**: puede ser cumplimiento o ceguera, y no hay un segundo método que lo distinga. Grado: medido el conteo; la interpretación es hipótesis. Relación: DA-008, DA-023.
6. **P10 define «falla» por la infraestructura, no por el proceso.** Evidencia: `auditar-sesion.py:364`. Grado: leído. Relación: nueva, parecida a DA-028.
7. **Fuera del núcleo y de las 6 claves de al-paso, una lección llega sólo si se la busca.** Evidencia: `al-paso.py:11-17`. Grado: leído. Relación: DA-015.

---

## 5. Verificadores y saboteadores

**Resumen.** chequeo-completo tiene **13 medidores y 23 saboteadores** (el lector de inyección cuenta 12 medidores: van las dos cifras). Los medidores corren en el arranque; los saboteadores, a mano, y el arranque avisa si tienen más de 7 días. El sello de hoy: medidores verdes al 2026-10-12, saboteadores verdes al 2026-10-09 (medido).

Todo informa: nada bloquea un commit ni un push (DA-019). Sólo frenan los guardias: iso, fanout, heredoc y la puerta. guardia-iso **falla abierto sin PowerShell**. guardia-escapes **no existe**. Casi todos los medidores miden el objeto; la excepción es la puerta --verificar, que mide su registro.

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| chequeo-completo.ps1 | `chequeo-completo.ps1` (l.53-98, 100-129) | medidores en SessionStart; saboteadores manuales (aviso l.255-267) | informa | 7 s declarado contra 109,7 s medido; saboteadores 96 s declarado contra 310 + 378 s (A6) | **no tiene**; el filtro FAIL (l.150) no está probado |
| arranque-medicion.ps1 | `.claude/hooks/arranque-medicion.ps1` | SessionStart, 60 s (`settings.json:14-19`) | informa | ≤60 s | el corte por fecha no tiene saboteador |
| verificar-estructura.ps1 | raíz | arranque y manual | informa | capa rápida | probar-verificador (310 s) |
| verify-install.ps1 | `perfil-global/verify-install.ps1` | arranque | informa | capa rápida | indirecto (probar-guardia-fanout) |
| publicar-apuntes.ps1 | raíz | arranque (-Verificar); post-commit (archivo) | informa | bimodal 10/45 s | probar-publicacion |
| verificar-drive.ps1 | raíz | arranque | informa | ~5 s (`chequeo-completo.ps1:66`) | probar-verificar-drive |
| verificar-sincronia.ps1 | raíz | arranque | informa; ante la red falla abierto y lo declara (l.19-21) | un fetch por repo | probar-sincronia |
| cascada_puerta --verificar | `.claude/hooks/cascada_puerta.py` | arranque | informa | capa rápida | --autotest |
| Medidores de método | `perfil-global/herramientas/` | arranque | informa | medir-inyeccion ~3,5 s | sus probar-* respectivos |
| guardia-iso.ps1 | `.claude/hooks/guardia-iso.ps1` | PreToolUse, 15 s (`settings.json:57-62`) | frena; con JSON corrupto, cerrado (l.185) | un PowerShell por escritura | probar-hooks (378 s) |
| guardia-fanout.ps1 | `perfil-global/hooks/guardia-fanout.ps1` | PreToolUse Workflow/Agent/Task | frena (ask siempre, sin leer el prompt, l.28-36) | una tecla | probar-guardia-fanout (intermitente) |
| guardia-heredoc.ps1 | `~/.claude/hooks/guardia-heredoc.ps1` | PreToolUse Bash | frena (no leído en detalle) | un PowerShell por Bash | probar-guardia-heredoc |
| guardia-escapes.ps1 | **no existe** | nada | no actúa | 0 | probar-guardia-escapes declarado, fuera de la batería |
| ultimo-chequeo.json | `.claude/ultimo-chequeo.json` | lo escribe chequeo-completo | informa la antigüedad | despreciable | no tiene |

**Interfaces**
- arranque → chequeo (`arranque-medicion.ps1:55`).
- chequeo → scripts: **la única señal es el exit code** (`:141-153`).
- chequeo → sello (`:51,286`).
- settings → guardia-iso con `command -v powershell || exit 0` (`settings.json:61`).
- install.ps1 → `~/.claude/settings.json:217-268`.
- publicar y drive → Drive, con `--config` (`verificar-drive.ps1:65-69,143`).
- puerta --verificar → settings: **precondición** (`chequeo-completo.ps1:87-90`).

**Mediciones**
- Batería: 13 medidores y 23 saboteadores.
- Sello: medidores 2026-10-12, saboteadores 2026-10-09.
- guardia-escapes: sólo lo nombran HANDOFF, ESTADO y PDP de arquitectura-se.
- Timeouts: arranque 60, iso 15; fanout y heredoc no declaran.

**Modos de falla**
- *No actúa.* guardia-iso desaparece sin PowerShell, mientras la puerta falla cerrado sin Python (`settings.json:61` contra `:72`). Leído.
- *No actúa.* guardia-escapes está declarado «mitad puesta» y no existe (`arquitectura-se/ESTADO_ACTUAL.md:167`). Medido.
- *Tarde.* Entre corridas de saboteadores, un medidor puede quedar ciego 7 días o más (`chequeo-completo.ps1:255-267,317-322`). Leído.
- *Actúa mal.* Con trabajo concurrente, los saboteadores dan rojo falso (fanout, 27 y 28/09), y eso entrena a ignorar el rojo (`diagnostico-2026-09-28.md:119-126`). Declarado, probable.
- *Deja de actuar.* Un medidor lento sale «sin medir» en cada arranque y sigue figurando en la lista (`:57-60,41-46`). Leído.
- *Actúa mal.* El costo declarado diverge del medido: es un número escrito a mano (DA-012) (`:16-18`; diagnóstico :116-117). Medido por terceros.
- *No actúa.* Ningún rojo bloquea un commit (`:32`). Leído.

**Observaciones conceptuales**
1. **La política de falla ante la falta de intérprete no es uniforme**, y no hay regla de default por clase de freno. Evidencia: `settings.json:61` contra `:72`. Grado: leído. Relación: DA-022, DA-028.
2. **El inventario de saboteadores se escribe a mano**, mientras el de repos se descubre. Puede existir un probar-* fuera de la batería. Evidencia: `chequeo-completo.ps1:118,127`; `verificar-sincronia.ps1:59-61`. Grado: leído. Relación: nuevo; DA-017, DA-023.
3. **El orquestador no tiene saboteador** (por ejemplo, un medidor que sale 0 sin medir). Evidencia: `:131-158`. Grado: leído; el riesgo es hipótesis. Relación: nuevo; regla 3.
4. **fanout y heredoc no declaran timeout.** Evidencia: `~/.claude/settings.json:219-233`. Grado: leído. Relación: nuevo, menor.
5. **La puerta se verifica por su registro (precondición)**; que niegue de verdad lo prueba sólo la capa lenta. Evidencia: `:87-90,116`. Grado: leído. Relación: DA-011; regla 3.
6. **Hay piezas declaradas instaladas sin un cruce contra el disco.** Evidencia: `ESTADO_ACTUAL.md:167`. Grado: medido. Relación: DA-018, DA-037.

---

## 6. ESTADO, HANDOFF, bitácora y retomes

**Resumen.** Son 44 archivos de estado. BLACK siguió creciendo después de DA-016: el ESTADO pasó de 118 a 151,7 KB y el HANDOFF de 250 a 278,2 KB. La puerta lee una vista acotada: el ESTADO hasta el segundo `## ` con tope de 300 líneas, el HANDOFF con vista_h2 2 y tope de 80. Esa vista **depende de una convención de encabezados que nadie verifica**.

P8 mide commits y push, no el contenido. Los RETOME son 4 y no tienen verificador (DA-021). La puerta le negó a este lector un Bash de sólo lectura.

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| ESTADO_ACTUAL.md | `proyectos/*/*/` (22) + plantilla | puerta (PreToolUse); se escribe a mano | frena hasta leer la vista | 1,2 a 151,7 KB en disco; vista ≤300 líneas (`cascada.json:11`) | P8 (`auditar-sesion.py:513-519`) |
| HANDOFF.md | `{proy}/` o el primero de rglob (`cascada_puerta.py:125-130`) | puerta; a mano | frena | 0,4 a 278 KB; ≤80 líneas exigidas | P8; nada mide el contenido |
| HANDOFF raíz | `HANDOFF.md` | no se encontró qué lo exige | no | 13 KB | ninguno |
| RETOME*.md | black/sesiones (3), arquitectura-se (1) | manual | no | 5-9 KB | ninguno (DA-021) |
| Especificación del retome | `perfil-global/apertura-proyecto.md:73-96` | palabra: «chat nuevo» | no | dentro de apertura | ninguno |
| Regla 5 | `~/.claude/CLAUDE.md`; `apertura-proyecto.md:98` | manual | no | tokens de escritura | P8 |
| P8 | `auditar-sesion.py:244-275,347` | manual | informa | unos comandos git | autotest (:513-522) |
| vista_h2 | `cascada_puerta.py:154-179`; `cascada.json:11-12,187` | PreToolUse | frena | 300 / 80 líneas | no verificado |
| Exención de checkpoint | `cascada_puerta.py:556,1113` | PreToolUse | abre paso | 0 | caso CONTROL :1113 |
| Bitácora | `black/docs/03-bitacora.md` (572 KB, A2) | manual | no | fuera de la base | ninguno |

**Interfaces**
- cascada.json → puerta: el rango (`:11-12`).
- `handoff_de()` → disco: **el primer archivo alfabético, sin declarar** (`:125-130`).
- Sesión → ESTADO/HANDOFF: el dueño es el proyecto (declarado).
- ESTADO ↔ enrutador: la columna Estado está duplicada y nadie compara (DA-017).
- PDP §4 ↔ ESTADO: el mapa de fases está repartido (`black/ESTADO_ACTUAL.md:729`).
- git → P8 (`auditar-sesion.py:259-266`).
- «chat nuevo» → RETOME o el texto pegado (`apertura:73-96`).
- El estado de BLACK vive en N lugares (`diagnostico-2026-09-28.md:52-56`).

**Mediciones**
- Los más grandes: black HANDOFF 278 241 B, black ESTADO 151 723 B, fisica-espacial ESTADO 119 152 B y HANDOFF 86 820 B, telescopio HANDOFF 63 856 B, electronica-analogica ESTADO 56 391 B, arquitectura-se HANDOFF 50 647 B.
- Crecimiento de BLACK en 14 días: ESTADO +29 %, HANDOFF +11 %.
- Vista del ESTADO de black: líneas 1-39. El segundo `## ` está en la 40 y el mapa de fases en la 729.
- HANDOFF de black: el primer `## ` está en la línea 304, así que el tope corta en la 80.
- ESTADO con línea Fase/Estado: 6 de 22.
- RETOME: 4.

**Modos de falla**
- *Actúa mal.* El tope de 80 corta un bloque `>` de unas 300 líneas en un punto cualquiera (`black/sesiones/HANDOFF.md:7-12`; `cascada_puerta.py:159-178`). Leído y medido.
- *Actúa mal.* La vista del ESTADO de black (1-39) contradice al contrato, que dice «entero — es corto» sobre 151 KB. Medido.
- *No actúa.* No hay techo de tamaño. Medido.
- *Actúa mal.* P8 da VERDE con un retoque de una línea (`auditar-sesion.py:259-266`). Leído.
- *No actúa.* Nada verifica los RETOME (`apertura:77-96`). Leído; ya es DA-021.
- *Actúa mal.* handoff_de puede tomar el HANDOFF de una subcarpeta (`:126-129`). Hipótesis.

**Observaciones conceptuales**
1. **La vista depende de una convención de formato no declarada.** Evidencia: `cascada.json:4,11-12`; black HANDOFF. Grado: medido. Relación: nuevo; DA-016, DA-018.
2. **El HANDOFF de black dice «se sobreescribe, no es historial» y se apila.** Evidencia: `black/sesiones/HANDOFF.md:3-5` contra 278 KB. Grado: medido. Relación: concreta DA-016; nuevo como contradicción.
3. **Qué leer del ESTADO tiene dos dueños**: cascada.json (vista) y el contrato («entero»). Evidencia: `cascada.json:2`; black/CLAUDE.md. Grado: leído. Relación: DA-017.
4. **La fase no tiene dueño único** (PDP, ESTADO, enrutador, cuadro). Evidencia: 6 de 22. Grado: medido. Relación: DA-017, DA-033.
5. **El retome vive en dos formas**, el chat y el RETOME*.md, y choca con la regla 4. Evidencia: `apertura:77`. Grado: leído. Relación: amplía DA-021.
6. **El cierre de black tiene 5 pasos y el global 4**: la auditoría ve sólo la intersección. Evidencia: black/CLAUDE.md; `auditar-sesion.py:17`. Grado: leído. Relación: DA-011; nuevo.

---

## 7. Nube y paridad

**Resumen.** La paridad depende de un único settings.json trackeado y de una compuerta por capacidad (`command -v powershell`).

- **En la PC** corren el arranque, la medición, guardia-iso y la puerta.
- **En la nube** corren traer-perfil, la puerta y fase_activa; la puerta falla cerrado sin intérprete.

El libro llega por un acto manual (add_repo). La memoria llega **después** de que el harness ya la buscó. Las sincronizaciones son sólo PC→nube. **Nada mide la vuelta.** El exportador de metodo-agustin no existe.

| Componente | Ruta | Disparador | Frena/informa | Costo | Saboteador |
|---|---|---|---|---|---|
| settings.json trackeado | `.claude/settings.json` | eventos del harness | según el hook | 103 líneas; por tool, 2 Pre + 2 Post | probar-settings.py (16 casos) |
| Compuerta por capacidad | `settings.json:8,18,28,61` | cada evento | decide qué corre | despreciable | probar-settings casos 6 y 7 |
| traer-perfil.sh | `.claude/nube/traer-perfil.sh` | SessionStart sin PowerShell | no (exit 0) | 127 líneas; 60 s | --probar, 3 casos (`chequeo-completo.ps1:122`) |
| Puerta en la nube | `settings.json:72` | Pre / Post / UserPromptSubmit | frena; cerrado sin Python | 46 254 car. (t7:210) | autotest; probar-settings caso 6 |
| cascada.sh | `.claude/cascada.sh` | manual | habilita | chico | autotest, 3 casos (t7:194) |
| estado-nube.py | `.claude/nube/estado-nube.py:9-14` | arranque en la PC (`chequeo-completo.ps1:94`) | informa | 378 líneas | --probar (:126) |
| estado-nube --simular | `:16-19` | manual / capa lenta (:125) | no | no medido | --probar |
| --sincronizar-memoria | `:126-134` | manual | no | despreciable | sabotear_memoria (:188) |
| --traer | `:231` | manual | ROJO si no clona | un clone | no visto (hipótesis) |
| Espejo de memoria | `perfil-global/memoria` | lo escribe --sincronizar; lo lee `traer-perfil.sh:64-72` | no | ~47 .md | conteo (`:68`) |
| verificar-sincronia.ps1 | raíz | arranque en la PC (`chequeo-completo.ps1:71`) | informa | 173 líneas; 20 s por repo | probar-sincronia |
| install / verify-install | `perfil-global/` | install manual; verify en el arranque (:55) | no | 526 + 431 líneas | no leído |
| bootstrap + MAQUINA-NUEVA | raíz | manual, una vez | no | 244 + 181 líneas | ninguno (hipótesis) |
| Exportador de metodo-agustin | `metodo-agustin/ESTADO_ACTUAL.md:55` | **nada: no existe** | n/a | 0 | probar-exportador, tampoco existe |

**Interfaces**
- CLAUDE.md (regla 16) → nube (t7:176-180).
- settings → traer-perfil (`:28`; medido en la nube, t7:208).
- perfil-global → `~/.claude` de la nube (`traer-perfil.sh:40-57`).
- Memoria de la PC → espejo: **una sola dirección y con borrado** (`estado-nube.py:126-134`).
- Espejo → nube, después del arranque (`traer-perfil.sh:62-72,89`).
- MAPA.md §2 → lista de repos (`estado-nube.py:60-70`).
- cascada.json → limites (`:138-145`).
- Lecciones de la nube → GitHub: probable, nunca hecho (`traer-perfil.sh:91`; t7:246-249).
- origin → PC (`verificar-sincronia.ps1:59-80`).

**Mediciones**
- 2 060 líneas en el subsistema.
- 0 scripts de exportación.
- Un Bash de sólo lectura que nombraba metodo-agustin fue negado.

**Modos de falla**
- *Actúa mal.* La sincronización borra del espejo lo escrito en la nube y lo marca «sobran» (`estado-nube.py:121-122,129-131`). Leído; que haya pasado es hipótesis.
- *No actúa.* La memoria escrita en la nube muere con el contenedor. Leído.
- *Tarde.* La memoria llega después de que el harness la buscó (`traer-perfil.sh:89`). Leído.
- *Actúa mal.* Si falla el pull, instala el perfil viejo y da [OK] (`:35`). Leído.
- *No actúa.* traer-perfil sale 0: la compensa la puerta, indirectamente (`settings.json:28`; t7:234). Leído.
- *No actúa.* En la nube no corre ningún medidor (`settings.json:18`; `chequeo-completo.ps1:55,71,94`). Leído.
- *Actúa mal.* La copia de memoria se controla por cantidad, no por contenido (`traer-perfil.sh:67-68`). Leído.
- *Deja de actuar.* Los guardias no existen en la nube (t7:75-78; `settings.json:61`). Declarado.

**Observaciones conceptuales**
1. **La paridad es un flujo PC→nube**: la vuelta (memoria, lecciones, medidores) no tiene dueño ni medidor. Evidencia: `estado-nube.py:126-134`; t7:246-249. Grado: leído y declarado. Relación: DA-022, DA-017.
2. **El mismo bit (`command -v powershell`) decide dos cosas**: «estoy en la nube» y «puedo correr este freno». Evidencia: `settings.json:8,18,28,61`. Grado: leído; las consecuencias son hipótesis. Relación: nuevo; DA-022.
3. **En la nube el sistema frena sin medir**, el caso inverso de «mide y no frena». Evidencia: `settings.json:18`. Grado: leído. Relación: contrapunto de DA-019; DA-022.
4. **La regla 16 «falla cerrado» la sostiene otra pieza (la puerta).** Con una necesidad que no exige archivos del perfil, una sesión sin libro pasa. Evidencia: `settings.json:28`; t7:234. Grado: leído; el hueco es hipótesis. Relación: nuevo; DA-015, DA-026.
5. **R5 de T7 se cerró como «probable» sin uso.** Evidencia: `t7-paridad-nube.md:246-260`. Grado: declarado. Relación: DA-011, DA-037.
6. **MAQUINA-NUEVA dice que la memoria no viaja, y viaja.** Evidencia: `MAQUINA-NUEVA.md:111` contra `traer-perfil.sh:58-72`. Grado: leído. Relación: DA-017.
7. **La fase de metodo-agustin tiene criterio de salida sobre scripts inexistentes.** Evidencia: `metodo-agustin/ESTADO_ACTUAL.md:20-21,53-56`. Grado: medido. Relación: DA-029, DA-018.
8. **La puerta frena lecturas transversales que nombran un proyecto.** Evidencia: comando negado; t7:238. Grado: medido. Relación: ya conocido; costo transversal.

---

## 8. Transversal

### (a) N2 de interfaces entre subsistemas

En la tabla, fila → columna quiere decir «le entrega a». Siglas: INY = inyección; PUE = puerta; PDP = PDP y cuadro; LEC = lecciones y auditoría; VER = verificadores; EST = estado; NUB = nube.

| → | INY | PUE | PDP | LEC | VER | EST | NUB |
|---|---|---|---|---|---|---|---|
| **INY** | — | dos puertas en el mismo evento (settings :190 / :38) | apertura y recordatorio → cuadro | núcleo inyectado (de LEC) | arranque-medicion → chequeo-completo | — | — |
| **PUE** | — | — | exige nucleo-ise y la naturaleza; fase_activa | caja negra → auditar; listado de lecciones | --verificar como medidor | exige la vista de ESTADO/HANDOFF; exención de checkpoint | la misma puerta en la nube; cascada.sh |
| **PDP** | línea Fase → cuadro | `requisitos` (no lo escribe nuevo-proyecto) | — | — | medir-fase / medir-matriz | fase repartida PDP/ESTADO | — |
| **LEC** | chequeo-de-trabajo → núcleo / al-paso | P7 lee cascada.json | — | — | sin-triage en el arranque; autotest de auditar en la capa lenta | P8 mide los commits de ESTADO/HANDOFF | lecciones de la nube (probable, sin uso) |
| **VER** | medir-inyeccion mide los hooks | — | — | — | — | — | estado-nube y sincronía en el arranque de la PC |
| **EST** | — | ESTADO/HANDOFF exigidos | mapa de fases | — | — | — | RETOME por lugar (LOCAL/NUBE) |
| **NUB** | traer-perfil instala lo que INY emite | — | — | espejo de memoria | — | — | — |

### (b) Qué dispara a qué

Es un conteo de componentes según el disparador que anotó cada lector. Un componente con dos disparadores se cuenta en el principal, y algunos aparecen en más de un subsistema (al-paso, la puerta, fase_activa).

| Subsistema | Fase | Palabra | Archivo | Cadencia (arranque) | Evento del harness | Manual | Nada |
|---|---|---|---|---|---|---|---|
| Inyección | 0 | 1 (al-paso) | 0 | 1 | 11 | 0 | 0 |
| Puerta | 0 | 1 | 1 | 0 | 9 | 3 | 1 |
| PDP y cuadro | 0 | 0 | 0 | 2 | 6 | 5 | 0 |
| Lecciones | 0 | 1 (al-paso) | 0 | 1 | 1 | 7 | 1 |
| Verificadores | 0 | 0 | 1 (post-commit) | 7 | 5 | 0 | 2 |
| Estado | 0 | 1 («chat nuevo») | 0 | 0 | 4 | 4 | 1 |
| Nube | 0 | 0 | 0 | 2 | 4 | 6 | 2 |
| **Total** | **0** | **4** | **2** | **13** | **40** | **25** | **7** |

**Ningún componente se dispara por la fase (DA-033).** Lo «manual» es el segundo bloque en tamaño, y ahí está todo el lazo de aprendizaje: lecciones, defectos, auditoría y retome.

### (c) Costos sumables

Sólo se suman los valores que dieron los lectores.

- **Por sesión, fijo**: 92 333 B de fuente (núcleo 28 214, CLAUDE raíz 16 613, perfil 14 439, pilares 12 865, MEMORY 8 878, apertura 6 456, arranque.md 3 078, recordatorio 1 790).
  - Más nested: 0-32 997.
  - Más al-paso: 0-16 044.
  - Más el arranque: ≤40 s de pared (109,7 s en serie).
  - Más al-paso: ~17 s por sesión (declarado).
- **Por turno**: recordatorio de 1 790 B (línea de base 1 154-1 683), un proceso Python de la puerta y puerta-afuera.
- **Por herramienta**: al-paso ~200 ms; 2 procesos Pre y 2 Post en la PC; 3 intérpretes por evento fuera del árbol; un PowerShell por cada guardia que coincide.
- **Por entrada a un proyecto**:
  - Base: 25-35 K en arquitectura-se; más de 50 K en black.
  - Necesidades: 0 a ~50 K.
  - Conceptos: 25-100 K, y se vuelven a cobrar después de compactar.
  - Medido: 105 697 car. (hoy, metodo + lluvia + base); 448 352 (una sesión de BLACK); 46 254 (en la nube, t7:210).
  - Techo de los exigidos: 291 550 B.
- **Manual, por corrida**: saboteadores 310 + 378 s (dos de ellos, A6). La auditoría, un comando.

### (d) Comandos negados durante el mapeo

1. **Estado/handoff.** Un Bash con awk de sólo lectura (líneas y vista h2 de black, fisica-espacial, telescopio, arquitectura-se y electronica-analogica) fue negado por la puerta: tocaba electronica-analogica sin necesidad declarada. El lector siguió con Read y Grep.
2. **Nube.** `cd claude-acceso; wc -l .claude/nube/* ...; ls perfil-global/memoria; ls proyectos/ingenieria/metodo-agustin` fue negado: la puerta pidió declarar la necesidad para metodo-agustin.

Los demás lectores no tuvieron negados. Los dos casos son la misma clase: **una lectura transversal pagó el freno de un proyecto que no era el de la tarea.**
