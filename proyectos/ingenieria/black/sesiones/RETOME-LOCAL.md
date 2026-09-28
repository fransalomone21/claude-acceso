# Mensaje de retome — BLACK, notebook (después de la bitácora (93m))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (93f)–(93m) del 2026-09-28 (tarea programada, mañana). COOP-B ABIERTA. Hecho: B5 medido hasta donde se puede sin combate (la vida de J2 en 0 se regenera; un enemigo de spawner no le dispara a nadie); el TÍTERE POR NIVEL (el stub elige el primer aliado vivo: 5 de 8 niveles; Wilderness, Steelworks y Gulag no tienen aliado); un prototipo de CUERPO SIN ALIADO por PINE (soldado de spawner con bando 0 y grupo de colisión 4, confirmado con control; no llevado al stub: gasta un spawner del guion, lo decide Fran); y LA CAUSA DE LA POSE COMPARTIDA: la ranura J+0x330 (compartida con J2) es el modelo en primera persona del arma en la mano, con su animación, y los eventos de J2 salen a nombre de J. Bloque: 636 palabras, instalado y ACTIVO; campaña 8 de 8. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (93m) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(93f)–(93m)» de sesiones/HANDOFF.md y las entradas (93h), (93i), (93l), (93m) de docs/03-bitacora.md. Del código, sólo lo que toque la tarea: herramientas/coop_mod.py (TITERE_MOD, ELEGIR_MOD, aislar()), herramientas/ranura93.py, herramientas/ranuras_cmp93.py. NO leas jugador2.py entero.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN).

3. Fase: COOP-B, ABIERTA (criterio: PDP.md §4). Lo que sigue, en orden:
   a) LA TERCERA RANURA para J2 (lo que más se ve: arregla a la vez los brazos de J2 con la pose de J y la recarga de J2 en la mitad de J). Ranuras: pers = *(0x0040F50C); r0 = pers+0x470 (FP_P_S_01, la de J), r1 = pers+0x6B0 (FP_S_G_S_001, la otra arma de J); 0x240 B cada una, con un compañero de 0x9D0 B en el montón (80) y el modelo. En frío: quién arma las ranuras al cargar el nivel (el constructor/inicializador de pers+0x470) y si se puede llamar para una tercera en memoria libre (0x0046E0B0..0x0046F800 = 0x1750 B libres; no entra 0x240+0x9D0+modelo: buscar dónde alojar). Prototipo por PINE antes de tocar el stub. Con la ranura propia, el filtro de eventos ya instalado (0x0046E070) hace el resto.
   b) EL CUERPO EN LOS 3 NIVELES SIN ALIADO: sólo si Fran dice que sí (riesgo: un spawner del guion). Receta medida: spawner → punto en J2 → activar → con alta, +0x3A4 = 0 y *(*(B4+0x34)+0x18) = 4; ELEGIR lo toma solo.
   c) EL PARPADEO: el ancho de la vista está descartado (93k); preguntar a Fran en qué momento lo ve; candidato, el sub-raster *(R+0xD458)+0x60.
   d) B5 con un combate real del guion (un disparador que despierte enemigos): ¿qué pasa si J2 muere?
   e) NO tocar la sensibilidad de los mandos (decisión de Fran).

4. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs con FPU, donde un error cuelga el emulador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. Autonomía: trabajá solo, de tramo en tramo, hasta ~60 % de contexto o ~95 % del tope de 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: ISO en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso (fuente: kb/ubicaciones.json). pnach instalado con 636 palabras y el bloque ACTIVO en los ajustes del juego (los accesos COOP lo reinstalan con coop_mod.py instalar + activar; «JUGAR BLACK» lo apaga; `instalar --sin-aislar` es el control del aislamiento). El 2.8.0 de Fran: CERRADO; su partida está en el slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 con el 2.8.0: probar con el 2.8.0 cerrado; PINE 28011). Cerrar el fork con Stop-Process filtrando la ruta de Downloads\PCSX2-MCP.

REPRODUCIR: `python herramientas/campana_coop.py` (los 8 niveles seguidos, ~6 min). Una sonda propia: copiar el arranque de herramientas/ranura93.py (lanzar → selector 0 0 → esperar CONTADOR → manos 0.5 → ...). El mando falso 2 de J2: botón = byte +0x2A+i en 1, +0x0E+i en 0 Y el float +0x4C+4i en 1.0 (sin el float no dispara).

YA HECHO, NO REHACER: (85)–(93e); (93f)–(93g) B5 hasta donde se puede; (93h) ELEGIR; (93i) receta del cuerpo sin aliado; (93j) el objeto de la vista (0x1C50 B, armado una vez); (93k) el ancho de la vista no es el parpadeo; (93l)/(93m) aislamiento + filtro de eventos + la causa (la ranura).

7. Trampas medidas:
   - EL GUARDIA PreToolUse BLOQUEA COMANDOS CON PROSA EN CASTELLANO O HEREDOCS CON COMILLAS/BACKSLASH: los textos van a archivo con la herramienta Write; el shell sólo corre Python/git con rutas.
   - Dos cuerpos de colisión EXACTAMENTE en el mismo punto cuelgan el EE en FUN_0033DD98 (93c, 93i): nunca copiar una posición exacta sobre otro cuerpo con controlador.
   - Breakpoints de ejecución tiran el emulador. Para saber quién llama a una función: un envoltorio que lee una bandera + vigilante de LECTURA sobre la bandera con ritmo_vigilante --ra (93l).
   - Un «cartel eterno» al cargar NO es una espera: muestreá el PC. No apretes Start en pleno juego (abre la pausa).
   - Los savestates tienen a J en el puerto 1. UNA sola conexión PINE a la vez. Mensajes de commit a archivo sin BOM y sin «J:».
   - selector_depuracion.py pedir-frontend desde el menú del arranque hace saltar la CPU a datos: pedirlo desde adentro de un nivel (slot 3).
   - Memoria usada (la tabla que manda es el bloque coop-rangos de docs/14; coop_diseno.py la mide): J2 0x0046CDF0..0x0046D6B0, datos del mod 0x0046D780..0x0046D7D4, por cuadro 0x0046D800..0x0046D9E0 (tope 0x0046D9F0: quedan 4 palabras), envoltorio 0x0046DA00..0x0046DBB4, armas de J2 0x0046DBC0..0x0046DBE0, desarme 0x0046DD00..0x0046DD90, ELEGIR 0x0046DE00..0x0046DE64, TITERE_ACT 0x0046DEF0, bandera de aislar 0x0046DEF4, aislar 0x0046DF00..0x0046E02C, contadores 0x0046E040..0x0046E070, filtro de eventos 0x0046E070..0x0046E0B0, pantalla 0x0046F800..0x0046FAD4, filtro del tinte 0x0046FB00..0x0046FB20, ocultar 0x0046FB20..0x0046FBB8, datos de ocultar 0x0046FBF0..0x0046FC00, datos de la pantalla 0x0046FC00..0x0046FC98, falso 1 0x00472000, falso 2 0x00472100. Libre: 0x0046E0B0..0x0046F800.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
