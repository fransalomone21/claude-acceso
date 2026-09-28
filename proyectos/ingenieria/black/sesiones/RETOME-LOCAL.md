# Mensaje de retome — BLACK, notebook (después de (93y)–(95), 2026-09-28)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de (93y)–(95) del 2026-09-28. Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA. Trabajo EN ESTE CHAT, sin tareas programadas y sin agentes. Opus, esfuerzo high, sin subagentes, nunca Fable.

0. git pull en claude-acceso (y en C:\Users\frans\black-datos si hace falta el decompilado). El último commit de proyectos/ingenieria/black tiene que ser el cierre de (95) o posterior; si no, pará.

0b. REGLA DE FRAN (memoria «Decime qué hago»): si Fran está frente al emulador, ANTES de analizar o sondear se le dice QUÉ HACER (botón, cuántos segundos, qué grabar) y se espera su aviso. Si no está, se trabaja solo con el fork.

0c. LO QUE VIO FRAN (al final, «LO QUE VI PROBANDO EL COOP») manda sobre el orden. Sus grabaciones: proyectos/ingenieria/black/volcados/video/<fecha-hora>/ — mirá PRIMERO hojas_mandos/hoja_NN.png (12 cuadros, 4 por segundo, la hora arriba y abajo «J1: ...» / «J2: ...» con lo que el JUEGO recibió de cada jugador), y eventos.txt (los cambios de botones con la hora). puertos.json dice qué puerto es J1 (el que apretó Start). Convertí cada cosa rara en una pregunta medible antes de tocar nada.

1. Leé SOLO: las entradas (93y), (93z), (94) y (95) de docs/03-bitacora.md (arriba de todo) y el bloque «(93y)–(95)» de sesiones/HANDOFF.md. Si hay entradas más nuevas, manda la bitácora.

2. Controles: python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN), python herramientas/parpadeo_escala.py --autotest (BIEN).

3. Predicción escrita ANTES de abrir el emulador; cada sonda con su control en la misma corrida. «Confirmado» = efecto visto en pantalla o RAM con control.

4. Fase: COOP-B, ABIERTA (criterio: PDP.md §4). En este orden:
   a) CAMBIO / LEVANTAR ARMA DE J2 CON LA RANURA 3 (el único camino de la ranura sin probar en vivo: el envoltorio 0x001ACA84 con a1 = J2). J y J2 arrancan el nivel con UNA sola arma (armas_j2.py), así que hace falta que J2 junte una. Con Fran: que J2 junte un arma del piso y la cambie 2 veces (grabando). Sin Fran: buscar cómo darle a J2 un arma (un enemigo muerto la suelta; o el llamado del juego que agrega un arma). Predicción: R3_DESVIOS (0x0046E0C0) y R3_REAPUNTES (0x0046E0BC) suben, J2+0x330 vuelve a 0x0046E100 al cuadro siguiente, el dueño de r0 (*(*(0x0040F50C)+0x470)) sigue siendo J, el emulador vivo. Riesgos (93s): los brazos de J durante el cambio de J2; si J2 levanta un arma de OTRO tipo en el índice que J tiene en la mano. Si cuelga: coop_mod.py instalar --sin-r3 y avisar a Fran.
   b) B5 SONDA 1 SIN ALIADO: b5_vigilar.py <s> --vida-J 40 --enemigo <i> en Wilderness, Steelworks o Gulag (sondas_spawn.py censo para elegir un CANDIDATO cercano). OJO: la vida se regenera ~30/s; si el enemigo tarda, bajarla de nuevo. Predicción (93u): J+0x5F0 sube a >= 1 antes de morir y *(0x0040F0E0)+0x21098 pasa a 1. Después, sonda 2 (J2 muere) y el envoltorio de FUN_0013ffa0 (0x0013FFA0): a0 = ctrl de J2 (0x0046D2E0) y a1 = 5 -> J2 reaparece junto a J con vida.
   c) «No Blur While Reload» (el acceso COOP lo prende desde (93y)): ver que J recargando ya no desenfoca la mitad de J2 (captura con J recargando por el mando falso de J, sondas_coop.py boton recargar, con y sin el parche).
   d) HUD de J2: hoy hay un solo HUD (el de J) partido en las dos mitades (vida a la izquierda, munición a la derecha). Punto de partida en frío: singleton 0x0040F518 (576 B, 71 funciones; perfil_singleton.py 0x0040F518), el método 0x001F2340 llama a 17 y toca 0x0040F4C4. Pregunta: ¿se dibuja una vez por cuadro fuera de las dos pasadas (como el tinte de (89))?
   e) El cuerpo en los 3 niveles sin aliado sólo si Fran dice que sí. NO tocar la sensibilidad de los mandos.

5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo.
6. Autonomía: de tramo en tramo hasta ~50 % de contexto o ~90 % del 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: los dos PCSX2 cerrados. ISO: C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso. pnach con 787 palabras (ranura 3 PRENDIDA por defecto desde (93z); --sin-r3 = 638, el control), bloque COOP activo. Los accesos COOP (dos mandos / teclado y mando) reinstalan con coop_mod.py instalar (787), apagan el «Widescreen 16:9» comunitario TAMBIÉN por juego (EnableWideScreenPatches = false en [EmuCore] de gamesettings\SLUS-21376_5C891FF1.ini) y prenden «No Blur While Reload»; «JUGAR BLACK» (solo) deshace las dos cosas. Accesos de grabar: «BLACK - Grabar 60 s» (espera 5 s, graba 60, con botones). El 2.8.0 de Fran: su partida en el slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 y PINE 28011 con el 2.8.0: NUNCA los dos abiertos; campana_coop.py ya se niega). Cerrar el fork con Stop-Process filtrando Downloads\PCSX2-MCP.

YA HECHO, NO REHACER: (85)–(93w); (93y) grabar con botones por jugador y el «Widescreen 16:9» apagado de verdad; (93z) ranura 3 por el pnach: campaña 8 de 8, recarga y culatazo de J2 arreglados CON CONTROL, prendida por defecto, personajes K5; (94) parpadeo arreglado CON CONTROL (0/16 contra 2/16); (95) la vida del jugador se regenera y el aliado mata a los enemigos que se hacen nacer cerca.

HERRAMIENTAS NUEVAS: registro_mandos.py (grabar/anotar/probar), mando_j2.py (poner/boton <nombre> <s>/estado/quitar; nombres: disparar 12, recargar 2, melee 3, zoom 11, arma_a 6, arma_b 7), prueba_acciones_j2.py r3|control, armas_j2.py [--lanzar], parpadeo_control.py coop|control, b5_vigilar.py. Para cargar un nivel en el fork: campana_coop.lanzar() y después campana_coop.probar_nivel(i) (en el slot 3 J2 NO existe hasta cargar un nivel).

7. Trampas medidas:
   - `--help` en un script propio sin argparse lo CORRE (así se abrió un segundo emulador sobre el de Fran). Mirá argparse antes.
   - UNA sola conexión PINE a la vez, también entre dos scripts tuyos: lo que tenga que pasar mientras se vigila va en el mismo proceso.
   - EL PNACH ES patch=1: reescribe sus palabras en cada cuadro desde el emulador (un vigilante del EE no lo ve). Con la ranura 3, 0x001295A8 y 0x001ACA84 son ganchos del pnach: el código de una vez por PINE necesita otro sitio.
   - El guardia PreToolUse bloquea heredocs con backslash o largos: scripts y textos a archivo con Write. Para agregar a kb/*.json sin reformatear: el patrón de pegar antes del cierre (no json.dump del archivo entero: reformatea 80 líneas).
   - Memoria: la tabla que manda es el bloque coop-rangos de docs/14. FALSO2 del mando falso de J2 = 0x00472100 (clon_jugador).
   - Dos cuerpos de colisión en el mismo punto cuelgan el EE. Breakpoints de ejecución tiran el emulador. No apretes Start en pleno juego. Commits con mensaje en archivo, sin BOM.

LO QUE VI PROBANDO EL COOP (lo escribe Fran; si está vacío, preguntale antes de empezar):
- Acceso que usé (dos mandos / teclado y mando):
- ¿J2 recarga y el culatazo termina? (debería, desde (93z)):
- ¿J2 juntó un arma y la cambió? ¿se colgó algo?:
- ¿La mitad de J2 se comprime cuando dispara? (no debería, desde (94)):
- ¿La recarga de J1 desenfoca la mitad de J2? (no debería):
- Nivel(es) y qué pasó al cargar o cambiar de nivel:
- Cosas raras (qué, en qué nivel, en qué momento):
- Grabaciones (carpeta de volcados\video\ y en qué segundo mirar):
```
