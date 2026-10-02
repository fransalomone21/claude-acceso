# Mensaje de retome — BLACK, notebook (después de (110): la IA ve a J2, la muerte de J2 ya termina la misión)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook). Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA (Fase B, diseño preliminar; la cierra la PDR: el diseño escrito, verificado contra el ELF y revisado por Fran). DECISIONES DE FRAN (106): el juego como con uno pero con dos (IA a los dos, recogibles al primero, HUD separado con vida/munición/punto de mira propios, disparadores de J1, si muere uno pierden los dos, cuerpos de aliado para los dos). Opus, esfuerzo high, sin subagentes, nunca Fable. Castellano rioplatense. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase en cada respuesta. Grado de evidencia en todo; «confirmado» = efecto visto en pantalla o RAM, con control. Fran pide (2026-10-01): fotos y audio ingeniosos para encontrar problemas MACRO de J2 y bajar de ahí; eficiencia de contexto (cortar al ~50 %).

0. git pull en claude-acceso; el último commit de proyectos/ingenieria/black tiene que ser el de (110) o posterior. Desde la raíz: .\chequeo-completo.ps1 -SoloMedidores y .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido (los dos, SIEMPRE: en (110) se olvidaron al abrir).
0b. REGLA DE FRAN («Decime qué hago»): si Fran está frente al emulador, primero se le dice QUÉ HACER y se espera. Si no, el fork solo. Nunca el fork con el 2.8.0 de Fran abierto.

1. LEÉ SOLO: la entrada (110) de docs/03-bitacora.md y sesiones/PREDICCIONES-110.md. Nada más salvo que una tarea lo pida.

2. CONTROLES: python herramientas/programa.py verificar (0), python pruebas/prueba_herramientas.py (184), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN), python herramientas/coop_ia.py verificar (0; 139 palabras en dos programas).

3. LO QUE YA ESTÁ (no rehacer):
 - La IA ve a J2: PERC2 (coop_ia.py programa 2 en 0x0046F000; sitios 0x00184DB8 jal PERC2 y 0x00185184 slti 5; J2 en la 5.a ranura del escuadrón *(0x0040F4D4)+0x22874). Confirmado: enemigos en combate anotan a J2 (id 1).
 - La muerte de J2 ya termina la misión (FUN_0013FFA0(J2+0x4F0,5) → MISSION FAILED con J vivo). NO construir nada para «pierden los dos».
 - Reiniciar misión con el coop anda (desarme + rearmado en 2,3 s + camina).
 - Agachado independiente en RAM (F6 no se reproduce). Botones de menú con el mando falso: ✕ = 2, abajo = 5, arriba = 4 con pulsación de 0,45 s, pausa = 8.

4. LO QUE SIGUE, en orden (cada uno: predicción escrita ANTES en sesiones/PREDICCIONES-111.md, control, bitácora, commit):
 T1 — que un enemigo ELIJA a J2 y le dispare (cierra B4 en vivo). Banco: City Streets, J2 a la vista de los enemigos que pelean con Tom (están en ~(-77,-3.6,33)); s0_ia.py --ir J2 se traba en la primera ventana: probar rutas o mover a J lejos y dejar a J2 cerca con un disparo suyo (puerta del daño). Medir: +0x270 del enemigo apuntando a la ranura con id 1 y la vida de J2 bajando sin que J2 dispare. De paso J2 muriendo por daño real → MISSION FAILED.
 T2 — el audio en una escena CALLADA: inspeccion_coop.py fuego-J2 fuego-J recién cargado el nivel (antes del tiroteo de Tom) o en otro nivel; ¿suena el disparo de J2? (F4). Si no suena, S4 de docs/16 (--sin-aislar).
 T3 — el cambio de UNIDAD con J2 lejos (riesgo macro sin medir: la unidad vieja se descarga y J2 queda sin piso o colgado). Primero en frío: FUN_00172FE0 / FUN_00173028 y los disparadores que cambian de unidad; después en vivo con seguir_carga.py.
 T4 — en frío, el diseño del HUD por jugador (B9) y el indicador de daño de J que se dibuja en la mitad de J2 (nuevo en (110)).
 T5 — «continuar misión» (punto de control) con el coop, con seguir_carga.py: el reinicio anda; el punto de control no se probó.

5. DECISIÓN PENDIENTE DE FRAN: el acceso «JUGAR BLACK COOP» (lanzadores/JUGAR-BLACK.ps1, línea ~69) instala el bloque SIN la IA; con su ok, CON_IA = True por defecto en coop_mod.py (y la fila «IA» de coop-plan-b pasa a coop-rangos).

ESTADO DE LA MÁQUINA (al cerrar (110)): pnach con el bloque COOP + IA (938 palabras, ranura 3 prendida), los PCSX2 cerrados. PCSX2.ini global: FrameRateNTSC vuelto a 59.94 (estaba en 146.16; respaldo .bak-...-fps146). Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; campana_coop.lanzar() + probar_nivel(0) (City Streets, J2 queda en la ventana a ~10 m de J). Una sola conexión PINE a la vez (el depurador 21512 es aparte).

TRAMPAS MEDIDAS: escribir CÓDIGO por PINE con el EE corriendo tiró el fork («Impossible block clearing failure»): en pausa (llamar_una_vez.EnPausa). Los enemigos de spawner apuntan y casi nunca disparan; un spawner con el punto en el aire nace y muere de la caída. --help en un script propio sin argparse lo CORRE. El pnach es patch=1: reescribe sus palabras cada cuadro (una prueba por PINE sobre un sitio del pnach no dura). kb/*.json: editar con reemplazo exacto, sin json.dump. Commits con mensaje en archivo.

PRIMER COMANDO: git log --oneline -3 -- proyectos/ingenieria/black
```
