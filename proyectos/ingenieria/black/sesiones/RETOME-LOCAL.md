# Mensaje de retome — BLACK, notebook (después de la bitácora (83))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (83) del 2026-09-27: `spawn` quedó en K5 (un byte en un spawner hace aparecer un enemigo en caliente, donde uno quiera) y con eso COOP-A CERRÓ. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md): tiene que ser el cierre de la bitácora (83) o posterior. Si no está, pará.

1. Leé SOLO: el bloque «(83)» de sesiones/HANDOFF.md (es el primero), ESTADO_ACTUAL.md (sección EL PROGRAMA) y PDP.md §4 («Proyecto COOP» y la tabla del plan de tecnología). NO leas la bitácora salvo que algo no dé lo que dice acá.

2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py (da 183 comprobaciones; el número que manda es el que imprime el script).

3. Fase: NINGUNA ABIERTA. COOP-A cerró el 2026-09-27 (83): entrada, camara, sesion, juego, codigo-nuevo, ragdoll y spawn en K5, render en K4 (su objetivo), prototipo por PINE de (82). LO PRIMERO DE ESTA SESIÓN: escribir en PDP.md §4 el criterio de salida de COOP-B (diseño preliminar), ANTES de empezarla, con su «cómo se certifica» y su plan de tecnología (sondas con K de hoy -> objetivo). Fran delegó pesos y decisiones («decide todo vos, primero el coop, después vamos viendo»): lo técnico se decide; si una elección cambia la META o lo que él va a ver jugando (p. ej. con qué cuerpo se ve J2), se le pregunta antes de rankear.

   Candidatos para COOP-B, sin priorizar:
   - El cuerpo de J2: desde J se ve como DOS BRAZOS de primera persona flotando (82). Necesita un modelo de personaje.
   - La pantalla dividida (M2): el motor ya dibuja por cuadro una segunda pasada de escena con viewport y framebuffer propios (160 x 112, en *(0x0040F4C0)+0xD170); proyección y viewport son parámetros de FUN_00269ea0(&0x0043F710, viewport, cámara). render K4.
   - `atar` permanente en el envoltorio de carga (hoy es un comando aparte: jugador2.py atar).
   - Los disparadores del nivel prueban SÓLO la posición del jugador 0 (juego+0x1C0), y 0x0040F530 recorre un array con cuenta compilada en 1.
   - La IA frente a J2 (sin medir; el enemigo de P17b quedó mirando hacia J2: hipótesis) y la reaparición de J2 si muere: ahora hay de dónde partir (el alta completa de un actor es FUN_00138C80, y la posición se elige).
   - HUD del jugador 2 (K2; no entraba en la A).

   YA HECHO, NO REHACER:
   - J2 construido por el juego durante la carga (79), camina con el mando 2 al atarle el controlador de colisión FUN_0025C210(*(0x0040F4CC), J2) (82); con la ranura COMPARTIDA alcanza.
   - SPAWN (83): por cuadro, FUN_00165F30(dt, *(0x0040F4F4)) recorre los spawners (listas 12/13 de `disparadores`: cuenta u16 en tabla+2i, array en tabla+0x48+4i; City Streets tiene 73) y FUN_00174578 es un temporizador: +0x28 activo, +0x2C restantes, +0x2A/+0x2B, +0x30 t, +0x24 actor actual. Con +0x28 = 1 aparece por FUN_001746E0 -> FUN_00178408 -> FUN_00178978/AE8 -> FUN_00178BC0 -> FUN_00138C80. La posición sale de *(desc+4)+0x10, leída AL APARECER. Herramienta: sondas_spawn.py (censo, foto, mirar, apuntar, punto-delante). 4 de 4, con negativo, y visto en pantalla.

   REPRODUCIR EL ESTADO: python herramientas/pine.py cargarestado --slot 13 -> depurador.py continuar si quedó en pausa -> esperar ~20 s. Slot 13 = J2 vivo, mando 2 y controlador. Slot 12 = sin controlador (jugador2.py atar). Control positivo antes de cada sonda: python herramientas/selector_depuracion.py vivo. Desde cero (slot 3): jugador2.py carga-poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> jugador2.py mirar 30 (fase 2) -> jugador2.py control2 -> jugador2.py estado 2 -> jugador2.py atar.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: es diseño de la fase (arquitectura) y, si hace falta, lectura de desensamblado del render. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.
7. Trampas medidas:
   - jugador2.py carga-poner MATÓ PCSX2 una vez de dos («[EE] Impossible block clearing failure» en Documents\PCSX2\logs\emulog.txt). Intermitente: se relanza con lanzadores\ABRIR-BLACK-ORIGINAL.bat, se recarga el slot y se REINTENTA.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo).
   - Toda dirección que sale de una cuenta se recalcula con la base VIVA (sistema de personajes = *(0x0040F50C) = 0x004ED380; juego = *(0x0040F4D0) = 0x005A8A80; cuerpos de personaje = *(0x0040F4CC) = 0x00585C00; actores = *(0x0040F514) = 0x0058FE00; disparadores = *(0x0040F4F4) = 0x005A8980; mundo físico = *(0x003C9ED4) = 0x0066E900).
   - El contador de apariciones *(0x0040F4D4)+0xFA4 SUBE SOLO (~1 cada 7-10 s, apariciones de fondo): el efecto de una aparición se lee en el propio spawner (+0x24) y en el actor.
   - Desde donde está J en el slot 13 NO hay línea de vista a los puntos de la planta de abajo (pared): para ver algo, sondas_spawn.py apuntar + punto-delante.
   - Para medir con el mando falso hay que SOSTENER el eje: adelante +0x8C, atrás +0x90, laterales +0x94/+0x98 del falso. No usar `empujar`.
   - Un «no cambia» medido con el objeto QUIETO no prueba que el código no corra (82).
   - Código nuevo en el stub por cuadro: con el emulador EN PAUSA (depurador.py pausar / continuar).
   - depurador.py --accion log NO cuenta; ritmo_vigilante.py usa break y --ra lee ra/a0/a1. El breakpoint de ejecución está bloqueado a propósito.
   - Nada de heredocs con comillas mezcladas: script al scratchpad con Write y después `python <ruta>`. Mensajes de commit largos: git commit -F <archivo>.
   - json.dump reformatea kb/subsistemas.json: usar herramientas/kb_formato.py (volcar). Después de subir una K: programa.py catalogo y verificar ANTES del commit.
   - Las capturas (capturar-pantalla.ps1) sacan LA PANTALLA; la herramienta trae PCSX2 al frente y verifica el foco. Desde (83) resuelve sola las rutas relativas (antes: «Error genérico en GDI+»).
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, contadores 0x0046D780..0x0046D7AC, stub por cuadro 0x0046D800 (estado 1 = ATAR), envoltorio 0x0046DA00..0x0046DB44, guarda 0x0046D7B0, dirección de la copia 0x0046D7B4, copia del sistema de personajes 0x0046DC00..0x0046F910 (sin usar), armas de J2 0x0046DBC0, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
