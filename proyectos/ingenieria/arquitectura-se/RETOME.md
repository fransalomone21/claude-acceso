# Retome — sesiones de arquitectura del método

Pegar tal cual como primer mensaje del chat siguiente. Escrito al cerrar la sesión `de44da9d` (2026-10-12), que
construyó T13, registró DA-039..DA-053 y dejó el orden de lo que sigue (`docs/lluvia-de-ideas-2026-10-12.md` §6).
**No nombra otros proyectos a propósito:** la puerta todavía infiere proyectos del texto pegado (es justo T14), y un
nombre acá frenaría la sesión por un proyecto que no se toca.

```
Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se): T14, «la puerta infiere el proyecto sólo de lo que escribe
Fran». Es el primero del orden de docs/lluvia-de-ideas-2026-10-12.md §6 (T14 -> T20 -> T19 -> T17 -> T15 -> T16 ->
T18, uno por sesión). Criterio de Fran para estas sesiones: desempeño > costo > plazo (tardar más está bien, gastar
de más no); sin fan-out salvo diseño escrito y costo estimado por ronda. Y dos LEYES transversales (Fran, 2026-10-12,
N-06 y N-07 de docs/10-requisitos.md): CERO DIVERGENCIAS (cada dato con un archivo dueño; «lo más cuidado») y COSTO
PROPORCIONAL (una pregunta suelta no carga la cascada; todo escala con proyecto, necesidad y naturaleza).

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 arquitectura-se -Necesidad metodo` y CON Read cada rango que imprima (incluye
   docs/10-requisitos.md, los requisitos del método, que ahora son base). Después: docs/t14-lo-que-pide-fran.md (el
   diseño, entero) y el §6 de docs/lluvia-de-ideas-2026-10-12.md. El código: .claude/hooks/cascada_puerta.py,
   prompt() (busca «def prompt») e inferidos_de() (busca «def inferidos_de»), y los casos 14 y 15 de su autotest
   (busca «# 14.» y «# 15.»). Al editar un archivo de hooks la puerta exige el concepto «freno» (la sección CUANDO
   PONES UN FRENO de chequeo-de-trabajo.md, saltzer-schroeder.md, mutation-testing.md): leerlo antes, y esa primera
   edición SOLA.
2. FASE: 7 -- NASA Phase D, "System Assembly, Integration and Test, Launch" = armar lo diseñado, probar que anda y
   ponerlo en marcha. No se hace: rediseñar sobre la marcha (un cambio de diseño vuelve al documento T-n antes de
   tocar nada vivo). La cierra (PDP §4): una sesión real bajo la arquitectura nueva con su costo medido (P10).
3. QUÉ HACER, en orden:
   (a) T14 según su diseño: prompt() saca del texto los bloques entre las etiquetas pasted_content,
       task-notification y system-reminder ANTES de inferir; nada más cambia.
   (b) Autotest de la puerta, caso 17: señal FUERTE adentro de <pasted_content> + Write fuera de todo proyecto ->
       pasa; adentro de <task-notification> -> pasa; TIPEADA fuera -> deny (el caso 331 sigue frenando); afuera Y
       adentro -> deny. Un mutante sin el recorte tiene que verse en SU caso. Catálogo sintético, como los casos 14 y
       15 (no depende de las señales reales).
   (c) Saboteador para defectos.py: `probar-t14.py` al lado de probar-t13.py (mismo molde: copia mutada al lado del
       original, exige el MAL en su caso, borra la copia).
   (d) chequeo-completo.ps1 en verde (el rojo «listo para la nube» mientras haya algo sin commitear es legítimo).
       Commit citando L2-PTA-04 (padre L1-03) y push.
   (e) `python perfil-global/herramientas/defectos.py arreglar DA-045 --nivel herramienta --repo claude-acceso
       --commit <hash> --prueba "python .claude/hooks/cascada_puerta.py --autotest" --saboteador "python
       proyectos/ingenieria/arquitectura-se/probar-t14.py"`, después `defectos.py vista` y commit de perfil-global.
   (f) EFECTO REAL (no la precondición): lanzar en segundo plano un comando trivial cuya DESCRIPCIÓN nombre un
       proyecto (la notificación de fin la trae); cuando llegue, `python .claude/hooks/cascada_puerta.py --estado
       <session_id>` no tiene que mostrar ese proyecto en «inferidos». Antes de T14 lo mostraba (medido 3 veces el
       2026-10-12).
   (g) Si queda ventana y contexto (<50 %): el DISEÑO de T20, la ley de cero divergencias (L0-05, L1-06): inventario
       de los datos con más de un lugar (empezar por los que ya se midieron: fase, estado, conteos, rutas locales;
       DA-012, DA-017, DA-036 y el T2 del diagnóstico del 2026-09-28 §3), cuál es el dueño de cada uno, qué copias se
       vuelven vista generada o puntero, y el medidor que da ROJO ante una copia que difiere, con su saboteador. Como
       docs/t20-*.md con sus requisitos L2 (verificar-requisito.py --idioma es). Primero qué se SACA. Se construye en la
       sesión siguiente; después T19 (cascada proporcional) y T17 (conectores).
   (h) Cierre: ESTADO, HANDOFF, lluvia §6 al día; auditar-sesion.py --de-fran "ninguno" --escribir; retome del
       siguiente.
4. MOTOR: Opus 5.5, esfuerzo alto, un solo hilo: es un freno vivo. Sin fan-out.
5. MÁQUINA: claude-acceso y perfil-global al día en origin (main). origin/HEAD local apunta a main (corregido el
   2026-10-12; la rama vieja de la nube se borró de GitHub con el sí de Fran). Respaldo de los frenos:
   .claude\desinstalar-hooks.ps1.
6. YA RESUELTO, no rehacer: requisitos del método v0.1 (docs/10-requisitos.md); T13 construido y probado (70871b2,
   probar-t13.py, DA-027/028/029/033 arreglados); el mapa (docs/mapa-metodo-2026-10-12.md); la búsqueda y su
   registro (docs/hallazgos-2026-10-12.md, DA-039..DA-053); T14 diseñado; el orden con las cuatro decisiones de
   Fran (lluvia §6-§7: pasa/falla al escribir requisitos; retirar solo con aviso lo que no se disparó en 20
   sesiones; frenar compartir/publicar por conectores; rama vieja borrada); las dos leyes como requisitos
   (N-06, N-07, L0-05, L0-06, L1-06 a L1-08; 0 VIOLA) y en memoria (feedback_leyes-divergencia-y-proporcion).
7. TRAMPAS: la puerta todavía infiere proyectos de texto pegado y de notificaciones (hasta T14: -Excepcion con
   motivo, una vez, sola). Un proyecto en fase A–D sin requisitos queda frenado al entrar: es T13 andando. La
   auditoría mide lo leído contra la versión de HOY (DA-038): editar el libro o el chequeo en la sesión da un rojo
   falso que se dice. encontrar-defectos.js ya no cuenta un agente fallado como ronda seca; la búsqueda NO se agotó
   (rondas 2 y 3 cortadas). Un freno vivo se edita en un orden que nunca lo deja roto.
8. MEDIR AL ENTRAR: `python perfil-global/herramientas/defectos.py resumen` (al cerrar de44da9d: 48 abiertos, 5
   arreglados sin validar, 0 validados, de 53); `python proyectos/ingenieria/arquitectura-se/medir-fases.py` (sale 1,
   5 expuestos); `python .claude/hooks/cascada_puerta.py --verificar` (EXPUESTOS 5, FASE SIN TIPO 8, OK).

PRIMER COMANDO: .\cascada.ps1 arquitectura-se -Necesidad metodo
```
