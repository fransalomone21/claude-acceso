# Mensaje de retome — BLACK, notebook (después de la bitácora (93e))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (93)–(93e) del 2026-09-28 (tarea programada, madrugada). COOP-B ABIERTA. Hecho esa noche: la RECARGA de J2 arreglada en el stub (confirmado en RAM con control); VISIBILIDAD POR PASADA (filtro en el callback de dibujo: pasada 1 sin J2, pasada 2 sin el títere; los brazos+arma de cada mitad son el dibujo del propio personaje, confirmado con control); TODA LA CAMPAÑA por el pnach solo (8 de 8 niveles: J2 se arma, llega al juego, camina, pantalla partida, 7 cargas seguidas; antes 7 de 8 colgaban porque J2 nacía encima de J, arreglado con control); el PLANO docs/14-coop-diseno.md con coop_diseno.py verificar = 0 y su saboteador 6 de 6 en rojo; B4 (IA) en frío. Bloque: 514 palabras, instalado y ACTIVO. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (93e) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(93)» de sesiones/HANDOFF.md, las entradas (93)–(93e) de docs/03-bitacora.md y docs/14-coop-diseno.md §2 (política de riesgos). Del código, sólo lo que toque la tarea: herramientas/coop_mod.py (ENVOLTORIO_MOD, POR_CUADRO_MOD, TITERE_MOD), herramientas/ocultar_pasada.py, herramientas/campana_coop.py. NO leas jugador2.py entero.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN).

3. Fase: COOP-B, ABIERTA. La cierran las tres cosas de PDP.md §4. Estado: riesgos altos B1, B3, B7 hechos; B2 (cuerpo) con el títere en 4 de 8 niveles; punto 2 (riesgos medios): B4 leída en frío con política (aceptar), B6 política (J abre el camino), B5 SIN MEDIR; punto 3 (el plano) HECHO. Lo que sigue, en orden:
   a) B5 · MUERTE DE J2: (93f) midió que la vida en 0 escrita a mano NO hace nada (se regenera tras ~3,5 s). En frío ya se leyó (93f): el piso de muerte de 0x00134654 es la rama de los agentes; a un jugador (controlador +0x32C con +0x80 = 2) el daño le llega por FUN_001411A0 -> FUN_001412C0 -> método +0x28 de otro objeto. FUN_001412C0 = el estado en curso de la máquina de estados del controlador (mira+0x490[mira+0x4B4]). Sigue: en vivo, los estados de J2+0x4F0 (+0x490.., índice +0x4B4) y cuál maneja el daño; después una granada junto a J2 (¿fin de misión para cualquier jugador?). Después, en vivo, una granada junto a J2. Y la política v1 del plano (reaparece junto a J): qué hay que llamar.
   b) EL TÍTERE POR NIVEL: el aliado 1 del pool sirve en City Streets, Asylum, Docks y City Bridge; en Town y Steelworks es enemigo (la guarda no lo toca) y en Wilderness y Gulag no sigue a J2 aunque el stub copie la matriz. En frío/en vivo: buscar en el stub el primer actor del pool con bando 0 y vivo (qué campo dice «dado de alta»), o dar de alta uno (FUN_00138C80, spawn (83)).
   c) Los brazos de J2 animados igual que los de J (93b): qué de J2 apunta a lo de J (candidatos: +0x270/+0x274/+0x278, tres bloques con dueño J copiados del molde).
   d) J visto desde J2: brazos flotantes (un segundo títere, con el mismo filtro: pasada 2 sin J si hay títere de J).
   e) El parpadeo de la mitad de J2 (Fran: «se angosta y se reacomoda»): quién escribe R+0xD470/+0xD474 en el mismo cuadro (ritmo_vigilante.py).
   f) NO tocar la sensibilidad de los mandos (decisión de Fran).
   g) B4 en vivo si sobra: un enemigo más cerca de J2 que de J (sondas_spawn.py) — ¿le dispara?

4. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs con FPU, donde un error cuelga el emulador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. Autonomía: trabajá solo, de tramo en tramo, hasta ~60 % de contexto o ~95 % del tope de 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: ISO en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso (fuente: kb/ubicaciones.json). pnach instalado con 514 palabras y el bloque ACTIVO en los ajustes del juego (los accesos COOP lo reinstalan con coop_mod.py instalar + activar; «JUGAR BLACK» lo apaga). El 2.8.0 de Fran: CERRADO; su partida está en el slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 con el 2.8.0: probar con el 2.8.0 cerrado; PINE 28011). Cerrar el fork con Stop-Process filtrando la ruta de Downloads\PCSX2-MCP.

REPRODUCIR: `python herramientas/campana_coop.py 0` (lanza el fork con el bloque del pnach, slot 3, carga City Streets con el selector, mide y cierra). Para una sonda propia por PINE con el bloque apagado: coop_mod.py desactivar → lanzar el fork → ~35 s → pine.py cargarestado --slot 3 → 8 s → depurador.py continuar → 12 s → selector_depuracion.py vivo → coop_mod.py poner → selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 → elegir 0 0 → aceptar → coop_mod.py mirar 30 → ... → coop_mod.py activar al final. Esperas en scripts de Python, nunca Start-Sleep suelto.

YA HECHO, NO REHACER: (85)–(91); (93) recarga; (93b) filtro por pasada; (93c) apartar a J2 1 m; (93d) el plano y su verificador; (93e) la tabla de la campaña (volcados/campana/campana.json).

7. Trampas medidas:
   - EL GUARDIA PreToolUse BLOQUEA COMANDOS DE POWERSHELL CON PROSA EN CASTELLANO ADENTRO («Remove-Item on system path '*' is blocked», falso positivo): textos de bitácora, kb y mensajes de commit van a archivo con la herramienta Write; el shell sólo corre Python/git con rutas.
   - Un «cartel eterno» al cargar un nivel NO es una espera: muestreá el PC (depurador.py pausar/registros); en (93c) era el EE caído en FUN_0033DD98. No apretes Start para «saltar»: en pleno juego abre la pausa y frena el por cuadro.
   - El 2.8.0 con un juego corriendo: CloseMainWindow() abre «Confirmar apagado»; para cerrar uno de prueba, Stop-Process. NUNCA cerrar la partida de Fran sin avisar.
   - Los savestates tienen a J en el puerto 1.
   - REESCRIBIR UN STUB EN CALIENTE: pantalla -> quitar, esperar, poner en pausa; por cuadro -> FASE (0x0046D790) = 0, esperar, escribir en pausa, FASE = 2. El lui/addiu del callback (0x001298F8/0x00129900) SIEMPRE juntos y en pausa. Datos se pueden escribir en caliente.
   - UNA sola conexión PINE a la vez. Mensajes de commit a archivo sin BOM y sin «J:».
   - selector_depuracion.py pedir-frontend desde el menú del arranque hace saltar la CPU a datos: pedirlo desde adentro de un nivel (slot 3).
   - Escribir la mira de J (0x005A8FA0) por PINE NO gira su cámara.
   - kb/subsistemas.json con herramientas/kb_formato.py (volcar).
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, datos del mod 0x0046D780..0x0046D7D4, por cuadro 0x0046D800..0x0046D9DC (tope 0x0046D9F0: quedan 5 palabras), envoltorio 0x0046DA00..0x0046DBB4 (tope 0x0046DBC0: quedan 3), armas de J2 0x0046DBC0..0x0046DBE0, desarme 0x0046DD00..0x0046DD90, pantalla 0x0046F800..0x0046FAD4, filtro del tinte 0x0046FB00..0x0046FB20, ocultar 0x0046FB20..0x0046FBD4, datos de ocultar 0x0046FBF0..0x0046FC00, DATOS de la pantalla 0x0046FC00..0x0046FC98, falso 1 0x00472000, falso 2 0x00472100. Libre: 0x0046DE00..0x0046F800. La tabla que manda es el bloque coop-rangos de docs/14 (coop_diseno.py la mide).
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
