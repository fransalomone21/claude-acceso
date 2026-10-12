# Retome — sesiones de arquitectura del método (creativas, en ultracode)

Pegar tal cual como primer mensaje del chat siguiente. Pedido de Fran (2026-10-12): «así podemos ver todos los errores
conceptuales y registrarlos; le dedicamos sesiones específicas sólo para eso, no mecánicas sino creativas; haremos lo
necesario para optimizar el desempeño al máximo: modificar, eliminar, agregar o evolucionar. Dedicaremos a
arquitectura en ultracode». T13 (insumo 2026-10-12, §5) queda como **la primera implementación** que salga de acá.

```
Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se) en una SESIÓN DE ARQUITECTURA, CREATIVA, EN ULTRACODE: encontrar,
registrar y arreglar los problemas CONCEPTUALES de la arquitectura del método —modificar, eliminar, agregar o evolucionar
lo que haga falta— para llevar su desempeño al máximo. No es una sesión mecánica: es descubrimiento y diseño. El registro
es perfil-global/DEFECTOS-ARQUITECTURA.md (al 2026-10-12: 38 defectos, 37 abiertos, DA-034 arreglado sin validar), que
sólo escribe perfil-global/herramientas/defectos.py y que no deja cerrar nada sin commit + prueba + saboteador + 3
sesiones auditadas después.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 arquitectura-se -Necesidad metodo,lluvia-de-ideas` y CON Read cada rango que imprima (la puerta;
   lluvia-de-ideas trae el método creativo: el m24 de la cátedra, NASA 4.4 y 6.8, INCOSE ágil y /lluvia-de-ideas).
   Después: `python perfil-global/herramientas/defectos.py listar` (la lista que NO se duplica),
   docs/insumo-2026-10-12-nasa-por-etiqueta.md (T13, ya diseñada), docs/diagnostico-2026-09-28.md §2 (el N² de
   interfaces) y §3 (el camino crítico), y docs/t12-simplificar.md (el costo medido y su instrumento).
2. FASE: 7 -- NASA Phase D, "System Assembly, Integration and Test, Launch" = armar lo diseñado, probar que anda y
   ponerlo en marcha. No se hace: rediseñar sobre la marcha (un cambio de diseño queda escrito como diseño T-n antes de
   tocar nada vivo). La cierra (PDP §4): una sesión real bajo la arquitectura nueva con su costo medido (P10). Estas
   sesiones son su insumo: cada defecto que se cierre tiene que bajar un costo o subir una efectividad, MEDIDO.
3. LA META Y SUS MEDIDAS, antes de buscar nada (el triángulo de hierro del método):
   - EFECTIVIDAD: ¿las sesiones de proyecto llegan a resultados? (retrabajo, sesiones por pieza, defectos por sesión,
     validaciones hechas; BLACK pieza 2 = 13 sesiones es un dato de base).
   - COSTO: caracteres inyectados por sesión y por turno, lectura que exige la puerta por entrada (BLACK con
     ingenieria-inversa ~57 K tokens), % del plan por sesión
     (`python proyectos/ingenieria/arquitectura-se/medir-costo.py --ultimas 3`, mcp__ccd_session_mgmt__get_usage).
   - PLAZO: segundos del arranque (hoy hay medidores cortados a los 40 s), frenos negados por sesión (auditorías, P6).
   Escribir esa LÍNEA DE BASE en el HANDOFF antes de proponer nada: sin ella no se puede decir que algo mejoró.
4. QUÉ HACER — workflows de ultracode, uno por fase, leyendo cada resultado antes del siguiente:
   GUARDA DE PRESUPUESTO antes de CADA workflow (regla 9): mcp__ccd_session_mgmt__get_usage; si la ventana de 5 h pasa
   el 80 % o la semanal el 85 %, nada de fan-out: se sigue inline y se asegura el repo. Respetar el tamaño de workflow
   configurado (hoy «small», menos de 5 agentes por workflow: se encadenan varios chicos en vez de uno grande).
   (a) MAPA: un agente por subsistema del método —inyección y arranque; la puerta, la cascada y la fase; PDP,
       plantillas, naturalezas y cuadro; lecciones, chequeo, defectos y auditoría; verificadores y saboteadores;
       estado, HANDOFF, bitácora y retomes; nube y paridad—: componentes, interfaces, QUÉ LO DISPARA (fase, palabra,
       archivo, cadencia, nada), costo medido (bytes, segundos) y modos de falla.
   (b) ENCONTRAR, multi-lente y con verificación adversarial: un buscador por lente —NASA SEH (productos por fase,
       revisiones), INCOSE (ágil, System 1/2/3, 15288), Meadows (flujos de información, lazos, retardos, metas),
       Saltzer y Schroeder (fail-safe, economía de mecanismo, mediación completa), Leveson (no actuar, actuar mal,
       tarde, dejar de actuar), Rechtin y Maier (simplificar), costo y desempeño— sobre el mapa; dedup contra
       `defectos.py listar`; cada candidato pasa por 3 escépticos que intentan refutarlo (ante la duda, refutado); los
       que sobreviven se registran con `defectos.py agregar` (grado según la verificación; evidencia con archivo:línea
       o una medición). Repetir hasta dos rondas seguidas sin nada nuevo.
   (c) PRIORIZAR: los abiertos por palanca (Meadows), costo de esperar y riesgo. QUÉ PESA MÁS —costo, efectividad o
       plazo— es pregunta de valor para Fran, antes de rankear.
   (d) DISEÑAR, creativo: para los primeros, un panel de alternativas por defecto —modificar, ELIMINAR (primero qué se
       saca), agregar, evolucionar—, juzgadas con el triángulo y los factores de balance del m24; la ganadora queda como
       diseño T-n con requisitos (verificar-requisito.py --idioma es), su prueba y su saboteador planeados, igual que T13.
   (e) AL CERRAR: el registro con lo nuevo (`defectos.py vista`, `verificar`, `vista --check`), los diseños T-n, la
       línea de base del punto 3 en el HANDOFF, y el retome de la sesión siguiente (implementar el primero de la lista;
       si no cambió el orden, T13 con su retome del insumo §5).
5. MOTOR: Opus 5.5 en el hilo principal, esfuerzo alto. Los agentes heredan el modelo; esfuerzo bajo para el mapa,
   alto para refutar y para juzgar. Nunca Fable.
6. MÁQUINA: claude-acceso y perfil-global al día en origin al cerrar (129); nada vivo a medio tocar. Respaldo de los
   frenos: .claude\desinstalar-hooks.ps1.
7. YA RESUELTO, no rehacer: el registro de defectos (38) y su herramienta (autotest de 12 casos, sabotaje del
   verificador en rojo); la necesidad lluvia-de-ideas con su disparador medido (lluvia-de-ideas.py); T13 diseñada
   (M-01 a M-06; M-06 hecho en .claude/arranque.md); «NASA con ágil» en perfil-global/pilares/nucleo-ise.md §2b;
   medir-fases.py (6 de 22 proyectos en fases A–D sin requisitos).
8. TRAMPAS: la auditoría mide lo leído contra la versión de HOY (DA-038): editar el libro o el chequeo en la sesión da
   un rojo falso que se dice, no se maquilla. Lo que trae un agente es una hipótesis hasta que sobrevive a los
   escépticos. Un defecto se registra con la herramienta, nunca a mano, y no se valida en la sesión que lo arregla. Un
   freno vivo se edita en un orden que nunca lo deja roto.
9. MEDIR AL ENTRAR: `python perfil-global/herramientas/defectos.py resumen` (hoy «37 abiertos, 1 arreglados sin
   validar, 0 validados (de 38)»); `python proyectos/ingenieria/arquitectura-se/medir-fases.py` (sale 1, 6 expuestos);
   la cascada de arquitectura-se imprime «lluvia de ideas: N de 10».

PRIMER COMANDO: .\cascada.ps1 arquitectura-se -Necesidad metodo,lluvia-de-ideas
```
