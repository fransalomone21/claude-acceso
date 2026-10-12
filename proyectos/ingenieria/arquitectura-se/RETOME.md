# Retome — sesiones de arquitectura del método

Pegar tal cual como primer mensaje del chat siguiente. Escrito al cerrar la sesión `26479d81` (2026-10-12), que
construyó T20. **No nombra otros proyectos ni el vocabulario de la materia de C, a propósito:** arquitectura-se no tiene
señal fuerte en el catálogo (DA-054) y una débil de otro proyecto frena.

```
Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se): DISEÑAR lo próximo de docs/lluvia-de-ideas-2026-10-12.md §6
(dueño del orden; al cerrar 26479d81 era la fila 1c, T19 «cascada proporcional»: L0-06, L0-07, L1-07 a L1-10). Criterio
de Fran: desempeño > costo > plazo; sin fan-out salvo diseño escrito y costo estimado por ronda. LEYES (N-06, N-07):
cero divergencias y costo proporcional.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 arquitectura-se -Necesidad metodo` y CON Read cada rango que imprima. Después la fila de la
   lluvia §6 que toque y su §7 (las decisiones de Fran), docs/t12-simplificar.md (el costo medido y el instrumento
   medir-costo.py) y docs/t20-cero-divergencias.md como MOLDE de un diseño T-n (problema medido, qué se saca, medidor,
   L2, riesgo). Para escribir los L2 en docs/10-requisitos.md la puerta exige el concepto «requisitos»: leerlo antes, y
   esa primera edición SOLA. NO leer el resto de docs/ por las dudas.
2. FASE: 7 -- NASA Phase D, "System Assembly, Integration and Test, Launch" = armar lo diseñado, probar que anda y
   ponerlo en marcha. No se hace: rediseñar sobre la marcha; por eso el diseño T-n se escribe ANTES de tocar nada vivo.
   La cierra (PDP §4): una sesión real bajo la arquitectura nueva con su costo medido (P10). ESTA sesión cierra cuando:
   el diseño docs/t19-*.md existe con su problema MEDIDO (medir-costo.py sobre una sesión sin proyecto y una de
   proyecto: hoy unos 88 000 caracteres fijos), sus L2 en docs/10-requisitos.md con 0 VIOLA (extrayendo los
   enunciados: DA-055), y Fran contestó lo que sea suyo (L1-10: la complejidad se estima preguntándole).
3. MOTOR: Opus 5.5, esfuerzo alto, un solo hilo: diseño de arquitectura con medición; sin fan-out.
4. MÁQUINA: claude-acceso (2d0d296 y el cierre de 26479d81) y perfil-global (f07cf05) al día en origin/main. Vivo y
   nuevo: divergencias.py + .claude/datos.json en la capa rápida de chequeo-completo (un dato vigente nuevo se
   REGISTRA ahí, no se copia). Respaldo de los frenos: .claude\desinstalar-hooks.ps1.
5. YA RESUELTO, no rehacer: T14 y T20 construidos y probados (probar-t14.py; probar-divergencias.py 14 casos y 5
   mutantes; efecto real de T20 medido con una copia sembrada); DA-055 registrado; la lección del mutante «visto» sobre
   un caso que ya fallaba (foldeada).
6. TRAMPAS: un ROJO de «cero divergencias» se arregla en la copia (puntero o fecha), nunca en el medidor. La auditoría
   mide lo leído contra la versión de HOY (DA-038). DA-054: si la puerta frena por vocabulario de otro proyecto,
   -Excepcion con motivo, una vez, sola. Un freno vivo se edita en un orden que nunca lo deja roto; la primera
   edición sobre un archivo con freno va SOLA.
7. MEDIR AL ENTRAR: `python perfil-global/herramientas/defectos.py resumen` (al cerrar 26479d81: 49 abiertos, 6
   arreglados sin validar, 0 validados, de 55); `python divergencias.py` (verde, 3 datos);
   `python .claude/hooks/cascada_puerta.py --verificar` (al cerrar 26479d81: EXPUESTOS 5, FASE SIN TIPO 8).

PRIMER COMANDO: .\cascada.ps1 arquitectura-se -Necesidad metodo
```
