# Mensaje de retome — BLACK, notebook (el video de Fran de las 14:58, después de (93y)–(95))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook). Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA. Trabajo EN ESTE CHAT, sin tareas programadas y sin agentes. Opus, esfuerzo high, sin subagentes, nunca Fable.

LA TAREA (pedido de Fran): jugué con J1 y J2 y grabé 60 s. Revisá TODO el video, cuadro por cuadro con la línea de tiempo de los botones que apreté, encontrá TODOS los errores que se ven y corregilos. Cada error: qué se ve, en qué segundo, qué botón y de qué jugador lo disparó, pregunta medible, hipótesis, sonda con control, arreglo, verificación.

0. git pull en claude-acceso. El último commit de proyectos/ingenieria/black tiene que ser 956dd9e («(95) B5 segundo intento…») o posterior; si no, pará.

0b. REGLA DE FRAN («Decime qué hago», en memoria): si Fran está frente al emulador, ANTES de sondear o analizar en vivo se le dice QUÉ HACER (botón, segundos, qué grabar) y se espera su aviso. Si no está, trabajás solo con el fork. Nada de abrir un emulador con el suyo abierto.

1. EL VIDEO: proyectos/ingenieria/black/volcados/video/20260928-145814/ (60 s, 240 cuadros, 1802 muestras de mandos, puertos.json: J1 = puerto 2).
   - Primero eventos.txt ENTERO (los cambios de botones de cada jugador con la hora; «J1»/«J2» ya son jugadores, no puertos) y armá la línea de tiempo: qué apretó cada uno y cuándo.
   - Después hojas_mandos/hoja_01..20.png EN ORDEN (12 cuadros de 3 s cada una, 4 por segundo, la hora arriba y abajo «J1: …» / «J2: …»). Mitad izquierda = J1, derecha = J2. HUD único de J1: vida arriba a la izquierda, munición arriba a la derecha.
   - Para mirar de cerca un momento: cuadros/c_NNN.png (c_001 = 0,00 s; 4 por segundo). Sincronía video/botones: hasta ~0,5 s; se ajusta con un evento visible (el contador de balas baja al disparar J1) y se re-anota con `python herramientas/registro_mandos.py anotar <dir> --desfase <s>`.
   - Anotá una tabla: segundo | jugador | botón | qué se ve | ¿esperado? | error. Nombres de botones: disparar 12, recargar 2, melee 3 (círculo), zoom 11, arma_a 6, arma_b 7, pausa 8; b1 sin nombre (¿cuadrado = agarrar?), b0/b10 sin nombre. Si un botón sin nombre hace algo visible, se le pone nombre (sondas_coop.BOTONES + mando_j2.NOMBRES) con evidencia.
   - Lo que ya sabemos que NO es error nuevo: HUD sólo de J1 (pendiente d), los carteles centrados sobre el corte.

2. Leé SOLO: las entradas (93y), (93z), (94), (95) de docs/03-bitacora.md y el bloque «(93y)–(95)» de sesiones/HANDOFF.md. Si hay entradas más nuevas, manda la bitácora.

3. Controles: python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN), python herramientas/parpadeo_escala.py --autotest (BIEN).

4. Fase COOP-B (criterio PDP.md §4). Método por error: predicción escrita ANTES de abrir el emulador; cada sonda con su control en la misma corrida; «confirmado» = efecto visto en pantalla o RAM con control. Checkpoint (bitácora + kb clasificado por tipo y área + commit + push) después de CADA error cerrado. Si en el video aparece alguno de estos, ya hay pista:
   - J2 junta/cambia de arma y algo se rompe → es el camino de la ranura 3 sin probar (envoltorio 0x001ACA84 con a1 = J2). Contadores: R3_DESVIOS 0x0046E0C0, R3_REAPUNTES 0x0046E0BC; J2+0x330 debe volver a 0x0046E100; dueño de r0 = *(*(0x0040F50C)+0x470) debe ser J. Control: coop_mod.py instalar --sin-r3.
   - Recarga o culatazo de J2 trabados → (93z) los arregló con la ranura 3; si vuelve, medir con prueba_acciones_j2.py r3|control.
   - Mitad de J2 comprimida → (94); ver que el emulog no liste «Widescreen 16:9».
   - Enemigos pegados al cuerpo de J2 o que mueren solos → la pregunta abierta de (95): el nacido ocupó 0x0058FE90, la dirección del títere; control `coop_mod.py poner --sin-titere`.
   - Muerte de un jugador → B5 (93u): FUN_0013ffa0(ctrl, 5), ctrl+0x100 = J+0x5F0, global *(0x0040F0E0)+0x21098.
   - Desenfoque de recarga en las dos mitades → debería estar apagado («No Blur While Reload» estaba prendido en su sesión, visto en el emulog).

5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo.
6. Autonomía: de error en error hasta ~50 % de contexto o ~90 % del 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: el PCSX2 2.8.0 de Fran quedó ABIERTO A PROPÓSITO, en pleno juego (15:01, 60 fps), para que lo uses en vivo por PINE (28011) ANTES de cerrarlo: su captura muestra a J1 agachado con un arma larga (SPAS/escopeta; HUD 005, 0/024), a J2 con un arma larga igual en su propia pose, y en la mitad de J2 UN OBJETO OSCURO FLOTANDO sobre la pared de ladrillos (¿brazos/arma suelta? — es el primer candidato a error para mirar). Con él abierto: NO lanzar el fork. Si hace falta cerrarlo, preguntale a Fran. Su sesión cargó: COOP - jugador 2 (B3), No Blur While Reload, 60 FPS, Video Mode, Auto-apuntado apagado, Saltear videos con Start, y NO el Widescreen 16:9 (emulog). pnach: bloque COOP con la ranura 3 (787 palabras, por defecto; --sin-r3 = 638). ISO: C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso. Su partida: slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 y PINE 28011 con el 2.8.0: NUNCA los dos abiertos; campana_coop.py ya se niega). En el fork: campana_coop.lanzar() y después campana_coop.probar_nivel(i) (0 City Streets … 7 Gulag); en el slot 3 J2 no existe hasta cargar un nivel. Cerrar el fork con Stop-Process filtrando Downloads\PCSX2-MCP.

YA HECHO, NO REHACER: (85)–(93w); (93y) grabar 60 s con los botones por jugador, Widescreen comunitario apagado de verdad; (93z) ranura 3 por el pnach: campaña 8 de 8, recarga y culatazo de J2 arreglados con control, prendida por defecto, personajes K5; (94) parpadeo arreglado con control (0/16 contra 2/16); (95) la vida del jugador se regenera ~30/s; los enemigos nacidos por spawn mueren sin pegar (2 de 2).

HERRAMIENTAS: registro_mandos.py (grabar/anotar/probar), mando_j2.py (mando falso de J2: poner / boton <nombre> <s> / estado / quitar), prueba_acciones_j2.py r3|control, armas_j2.py [--lanzar], parpadeo_control.py coop|control, b5_vigilar.py (--vida-J v --mantener --enemigo i), sondas_coop.py (mando falso de J), sondas_spawn.py, campana_coop.py, coop_mod.py (instalar [--sin-r3], poner [--sin-titere …], manos).

PRIMER COMANDO: type proyectos\ingenieria\black\volcados\video\20260928-145814\eventos.txt

7. Trampas medidas:
   - `--help` en un script propio sin argparse lo CORRE (grep argparse antes).
   - UNA sola conexión PINE a la vez, también entre dos scripts tuyos: lo que pase mientras se vigila va en el mismo proceso.
   - EL PNACH ES patch=1: reescribe sus palabras en cada cuadro (un vigilante del EE no lo ve). Con la ranura 3, 0x001295A8 y 0x001ACA84 son ganchos del pnach: el código de una vez por PINE necesita otro sitio.
   - El guardia PreToolUse bloquea heredocs con backslash o largos: scripts y textos a archivo con Write. kb/*.json: agregar entradas pegándolas antes del cierre (json.dump del archivo entero lo reformatea).
   - Memoria: manda el bloque coop-rangos de docs/14. FALSO2 (mando falso de J2) = 0x00472100.
   - Dos cuerpos de colisión en el mismo punto cuelgan el EE. Breakpoints de ejecución tiran el emulador. No apretes Start en pleno juego. Commits con mensaje en archivo, sin BOM.

LO QUE VI PROBANDO EL COOP (lo escribe Fran; si está vacío, arrancá igual por el video):
- Qué hice en el video (con qué jugador, en qué segundo):
- Errores que noté:
```
