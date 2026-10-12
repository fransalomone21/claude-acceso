# Retome — sesiones de arquitectura del método

Pegar tal cual como primer mensaje del chat siguiente. Escrito al cerrar la sesión `814911bc` (2026-10-12), que
construyó T14 y diseñó T20. **No nombra otros proyectos ni el vocabulario de la materia de C, a propósito:** un retome
mandado como mensaje (no como bloque pegado) se lee como tipeado, y una señal débil frena porque arquitectura-se no
tiene señal fuerte en el catálogo (DA-054).

```
Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se): CONSTRUIR T20, la ley de cero divergencias (L0-05, L1-06):
cada dato con un archivo dueño; toda copia es vista generada o una referencia al dueño; un medidor que da ROJO si una
copia difiere. El orden de lo que sigue lo tiene docs/lluvia-de-ideas-2026-10-12.md §6 (dueño; no se copia). Criterio
de Fran: desempeño > costo > plazo; sin fan-out salvo diseño escrito y costo estimado por ronda. LEYES (N-06, N-07):
cero divergencias y costo proporcional.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 arquitectura-se -Necesidad metodo` y CON Read cada rango que imprima. Después
   docs/t20-cero-divergencias.md ENTERO (el diseño: §2 la distinción vigente / fechada / cita de ID; §3 qué se SACA;
   §4 el medidor; §5 los L2-DIV propuestos). Para pasar los L2-DIV a docs/10-requisitos.md la puerta exige el concepto
   «requisitos» (GtWR, cátedra m17/m21, NASA requisitos): leerlo antes, y esa primera edición SOLA. Para el medidor y
   su saboteador, el concepto «freno» (CUANDO PONES UN FRENO de chequeo-de-trabajo.md, saltzer-schroeder.md,
   mutation-testing.md). Molde del saboteador: probar-t14.py.
2. FASE: 7 -- NASA Phase D, "System Assembly, Integration and Test, Launch" = armar lo diseñado, probar que anda y
   ponerlo en marcha. No se hace: rediseñar sobre la marcha (un cambio vuelve a docs/t20 antes de tocar nada vivo).
   La cierra (PDP §4): una sesión real bajo la arquitectura nueva con su costo medido (P10).
3. QUÉ HACER, en orden:
   (a) L2-DIV-01..05 a docs/10-requisitos.md (sección nueva, elemento DIV); en docs/t20 §5 queda la referencia.
   (b) Lo que se SACA (t20 §3): la fase de la primera línea del ESTADO, el orden copiado en ESTADO/HANDOFF/RETOME, la
       nota de reemplazo en el camino crítico del diagnóstico §3 (T2 es T20), medir-fase.py importando los tipos de
       fase_activa.py. Las rutas locales: inventario primero (TBR del diseño).
   (c) El medidor (t20 §4) con su registro de datos, fallando cerrado; saboteador con los casos (a)-(e) de t20 §4,
       cada mutante visto en SU caso, cada script en su propia sesión (lección 382). A la capa rápida de
       chequeo-completo.
   (d) chequeo-completo en verde (el rojo «listo para la nube» con algo sin commitear es legítimo). Commit citando
       L2-DIV-xx (padre L1-06) y push.
   (e) defectos.py arreglar DA-017, DA-012 y DA-036 (los que el medidor cubra de verdad; el resto se dice), vista,
       commit de perfil-global.
   (f) EFECTO REAL: una copia divergente sembrada a propósito en un archivo de este proyecto da ROJO en chequeo-completo
       con el dato, el dueño y la copia; se borra y vuelve a verde.
   (g) Cierre: ESTADO, HANDOFF, lluvia §6 al día; auditar-sesion.py --de-fran "<lo de Fran o ninguno>" --escribir;
       retome del siguiente (T19, según la lluvia §6).
4. MOTOR: Opus 5.5, esfuerzo alto, un solo hilo: es un freno nuevo y un medidor. Sin fan-out.
5. MÁQUINA: claude-acceso (e6d58bb y el cierre de 814911bc) y perfil-global (4090cc3) al día en origin/main. T14 vive
   en .claude/hooks/cascada_puerta.py (AJENO, sin_ajeno, prompt). Respaldo de los frenos: .claude\desinstalar-hooks.ps1.
6. YA RESUELTO, no rehacer: T14 construido y probado (autotest caso 17, probar-t14.py, efecto real medido; DA-045
   arreglado sin validar); T20 diseñado (0 VIOLA del GtWR en sus L2); DA-054 registrado (proyecto sin señal fuerte);
   lección 382 (mutante en la sesión del caso real).
7. TRAMPAS: un proyecto en fase A–D sin requisitos queda frenado al entrar (es T13 andando). La auditoría mide lo
   leído contra la versión de HOY (DA-038): editar el libro o el chequeo en la sesión da un rojo falso que se dice.
   DA-054: si la puerta frena por vocabulario de otro proyecto, -Excepcion con motivo, una vez, sola; darle a
   arquitectura-se una señal fuerte lo decide Fran. Un freno vivo se edita en un orden que nunca lo deja roto.
8. MEDIR AL ENTRAR: `python perfil-global/herramientas/defectos.py resumen` (al cerrar 814911bc: 48 abiertos, 6
   arreglados sin validar, 0 validados, de 54); `python .claude/hooks/cascada_puerta.py --verificar` (EXPUESTOS 5,
   FASE SIN TIPO 8).

PRIMER COMANDO: .\cascada.ps1 arquitectura-se -Necesidad metodo
```
