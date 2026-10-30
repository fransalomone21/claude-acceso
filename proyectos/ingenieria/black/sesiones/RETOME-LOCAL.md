# Mensaje de retome — BLACK (después de (130): construir el banco coop con la regresión de R4)

Pegar tal cual como primer mensaje del chat siguiente, en la máquina con el emulador (PC o notebook).

```
Retomo BLACK (proyectos/ingenieria/black). Fase C. En (130) quedaron los requisitos del coop (docs/20-requisitos.md)
y el segundo momento lluvia de ideas (docs/21-lluvia-de-ideas-2026-10-30.md). Esta sesión hace el TRAMO 1 de una
forma nueva: construye el BANCO COOP (herramientas/banco_coop.py, requisitos L2-BAN-01..10) COMO TRAZADOR, y su
primera suite es la regresión de R4 en los 8 niveles.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 black -Necesidad ingenieria-inversa,diseno` y CON Read cada rango que imprima (incluye ahora
   docs/20-requisitos.md). Después docs/21 §4 (el diseño del banco) y, del código que se reusa:
   herramientas/campana_coop.py (lanzar, probar_nivel, matar_fork), herramientas/n27_banco.py (la pausa por el mando
   falso, la medición de R4), herramientas/coop_pausa.py (los testigos de R4), herramientas/sondas_coop.py (mando
   falso de J), herramientas/mando_j2.py (mando falso de J2), herramientas/pine.py (cargarestado/guardarestado).
   NO leer la bitácora vieja, docs/14 ni docs/16.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se hace:
   rediseñar sobre la marcha ni arreglar síntomas de a uno. La cierra (PDP §4): las cinco piezas con predicción,
   control y dos cargas; la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py verde.
   ESTE TRAMO cierra cuando: banco_coop.py corre la suite «regresion-r4» en segundo plano, imprime ≤ 40 líneas con un
   veredicto por escenario (verde / rojo / muerto / sin precondición / reventado), y su control sin R4 corre agrupado.
3. QUÉ HACER, en orden:
   (a) Predicción escrita ANTES en sesiones/PREDICCIONES-131.md (con R4: 8 de 8 verdes, contador de J2 vivo tras la
       pausa, testigos de R4 coherentes, ritmo ≥ 28 c/s en 5 niveles y ≥ 22 en Steelworks, Asylum, City Bridge;
       control sin R4: la caída de N27 sólo aparece con J2 en otra arma tras la pausa).
   (b) banco_coop.py, lo más delgado posible que atraviese todo: una sesión de emulador (campana_coop.lanzar una vez;
       relanzar sólo ante «muerto»); el guardián (contador de J2 + PC del EE cada 2 s → «muerto»); escenarios como
       diccionarios (foto o receta, pasos con los dos mandos falsos, observadores, oráculo); los cinco veredictos; el
       JSON completo a volcados/banco/<suite>-<fecha>.json; capturas sólo en rojo, con md5. Mide su precondición
       antes del efecto (L2-BAN-02). Saboteador en pruebas/: una caída provocada tiene que dar «muerto», una
       precondición rota «sin precondición», y un oráculo invertido «rojo».
   (c) La suite «regresion-r4»: por nivel, carga por el selector, pausa (Start = botón 8 del falso de J; en el menú
       confirma el botón 0) y vuelve, ritmo (contador de cuadros del juego contra el reloj), segunda carga. Con
       `coop_mod.py instalar --con-pausa`; el control, la misma suite sin --con-pausa, agrupado.
   (d) Lanzarla con run_in_background y esperar el aviso. Si 8/8: CON_PAUSA = True en coop_mod.py, sus filas de
       coop-plan-b a coop-rangos con el RANGO EXACTO, y en el MISMO turno los dos sabotajes de la regla 13 mudados.
       Si un nivel cae: frena, y R4 se rediseña en docs/16.
   (e) Cerrar los TBR de L1-02, L1-03 y L2-BAN-10 de docs/20 §9 con lo que midió la primera corrida.
4. MOTOR: Opus 5.5, esfuerzo alto, un solo hilo: el banco es la arquitectura de prueba del proyecto. Nunca Fable.
5. MÁQUINA (al cerrar (130), sin tocar desde (128)): fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD
   doble + sonido de J2; sub3, soporte2 y pausa propia apagados) en
   C:\Users\frans\Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach, 1116 de 1117 líneas `patch=1`; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork:
   C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; el PCSX2 de Fran tiene que
   estar CERRADO (comparte PINE y tarjeta). Primero `abrir-sesion.ps1 -Rapido`. Al terminar,
   `python herramientas/coop_mod.py instalar` (el default; si R4 pasó, el default nuevo). Prototipo de Burnout 3 con
   .map bajado (C:\Users\frans\herramientas\referencias-burnout\b3-jun8-2004\, sin extraer).
6. YA RESUELTO, no rehacer: (128) N27 es de la pausa; R4: ganchos 0x0020AEF4 y 0x0020AF84, montón 22 = entrada
   0x0040F40C (gestor 0x40F0F0), malloc FUN_0035E7D8 de 0x35FFF alineado a 0x800, datos 0x0046F1C0–0x0046F1D0,
   código 0x0046F200–0x0046F2E8. (130): requisitos escritos y declarados; el pnach del coop es patch=1.
7. TRAMPAS MEDIDAS: en el menú de pausa confirma el botón 0. J no junta armas: las precondiciones con armas distintas
   se arman por J2. Con el menú de pausa abierto el contador de J2 no sube aunque el EE corra (el guardián lo tiene
   que saber: en pausa mira el PC, no el contador). Escribir CÓDIGO por PINE sólo en pausa. `coop_mod.py instalar`
   sin cambios devuelve sólo {"cambio": false}. Un GPR del EE es de 128 bits: las ÚLTIMAS 8 cifras. Commit con `*`
   en el mensaje: `git commit -F <archivo>`. Scripts con Write, nunca por heredoc. `python pruebas/controles.py`
   antes de commitear. `git add` sólo de lo propio; `git pull --rebase` antes del push.
8. ABIERTO, no bloquea: docs/20 ya está ACORDADO por Fran (2026-10-30, PDP §6); falta su respuesta sobre cómo van a
   jugar (docs/21 §7, L1-24); el
   prototipo de BLACK del 16/08/2005 (enlace de Hidden Palace caído, archive.org cero: probar espejos); N25; H-acc.
9. MEDIR AL ENTRAR: la cascada de black imprime «lluvia de ideas: N de 10 sesiones auditadas desde la última
   (2026-10-30)». Si dice MOMENTO LLUVIA DE IDEAS, va antes que todo.
10. LO DE FRAN (tramo 2, cuando R4 esté prendida): jugar City Streets desde el menú con otra persona, grabando con
    lanzadores/grabar-gameplay.ps1 (Ctrl+Alt+G) y con v4_registro.py + guardado_auto.py corriendo.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa,diseno
```
