# Mensaje de retome — BLACK, notebook (después de la bitácora (93q))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (93q) del 2026-09-28. Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA. Trabajo EN ESTE CHAT, sin tareas programadas y sin agentes (tampoco «remotos»: gastan el plan Pro, no los créditos de nube).

0. git pull en claude-acceso y en C:\Users\frans\black-datos. El último commit que tocó proyectos/ingenieria/black tiene que ser el cierre de (93q) o posterior; si no, pará.

1. Leé SOLO: docs/15-tercera-ranura.md (entero: es la fuente de la ranura 3), las entradas (93o), (93p) y (93q) de docs/03-bitacora.md, y herramientas/ranura3.py (FUENTE, armar()). NO leas jugador2.py entero. Si hay entradas más nuevas que (93p) en la bitácora, leelas: manda la bitácora.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN).

3. FRÍO ANTES QUE CALIENTE (pedido de Fran): no se abre el emulador sin saber en frío las estructuras que la sonda toca, y la predicción se escribe antes.

4. Fase: COOP-B, ABIERTA (criterio: PDP.md §4). Lo que sigue, en orden:
   a) HECHO (93q): la fuga está cerrada, medido en RAM con control (ranura3b.py): con la ranura 3 la pose de J no se mueve con J2 disparando (1 palabra contra 33), la cola de V no se mueve y el arma de J no pasa a 8. No rehacer.
   b) PRIMERO: llevar la ranura 3 al pnach: armar UNA vez por arranque (bandera persistente, NO en el pnach: armar dos veces se come otro bloque del pool), cargar en cada nivel con FUN_001a51c8(R3, J2, pers+0x398+i*0x6C), y los envoltorios de FUN_0013C868 (si dueño == J2 → +0x330 = R3 y reatar accesorios con R3+0x30..) y FUN_001a51c8 (si a1 == J2 y a0 es r0/r1 → a0 = R3). Filas nuevas en docs/14 (coop-rangos) y coop_diseno verificar en 0. Regresión: campana_coop.py 8 de 8.
   c) EL PARPADEO: con J2 disparando, su mitad alterna entre dos puntos de vista (video de Fran y capturas ranura3-control/prueba 0 contra 2). En frío: qué escribe la vista/cámara de J2 en el disparo (retroceso, cámara de la vista FP) dos veces por cuadro.
   d) B5 (qué pasa si J2 muere) en frío, y el cuerpo en los 3 niveles sin aliado sólo si Fran dice que sí.
   e) NO tocar la sensibilidad de los mandos.

5. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs, donde un error cuelga el emulador. Nunca Fable.
6. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
7. Autonomía: de tramo en tramo, hasta ~60 % de contexto o ~90 % del 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: ISO en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso (fuente: kb/ubicaciones.json). pnach instalado con 636 palabras y el bloque ACTIVO (los accesos COOP lo reinstalan con coop_mod.py instalar + activar; «JUGAR BLACK» lo apaga). La ranura 3 NO está en el pnach: sólo por PINE con ranura3.py (se pierde al cerrar el fork). El 2.8.0 de Fran: CERRADO; su partida está en el slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 con el 2.8.0: probar con el 2.8.0 cerrado; PINE 28011). Cerrar el fork con Stop-Process filtrando la ruta de Downloads\PCSX2-MCP.

YA HECHO, NO REHACER: (85)–(93m); (93n)/(93o) el frío de la ranura (docs/15); (93p) la ranura 3 por PINE se arma y carga sin colgar, J2 con brazos en cuadro; (93q) la fuga cerrada en RAM con control.

8. Trampas medidas:
   - EL PNACH ES patch=1: reescribe sus palabras EN CADA CUADRO. Un desvío por PINE sobre una palabra del mod (p. ej. el gancho 0x00129574) se pisa solo. Para código de una vez: 0x001295A8 (jal 0x1ab428, a0 = pers), fuera del pnach.
   - El guardia PreToolUse bloquea heredocs con comillas mezcladas o backslash y prosa en castellano en comandos: los textos y scripts van a archivo con la herramienta Write.
   - La tanda de control puede vaciarle TODA la munición a J2 y la prueba siguiente no recarga: ranura3.rellenar() antes de cada tanda.
   - Las capturas de la mitad de J incluyen al títere (el cuerpo de J2), que se mueve con J2: medir en la caja de los brazos (ranura3.mitades).
   - Dos cuerpos de colisión EXACTAMENTE en el mismo punto cuelgan el EE en FUN_0033DD98. Breakpoints de ejecución tiran el emulador (usar vigilante de lectura sobre una bandera). Un «cartel eterno» al cargar no es una espera: muestreá el PC. No apretes Start en pleno juego. Los savestates tienen a J en el puerto 1. UNA sola conexión PINE a la vez. Commits con mensaje en archivo, sin BOM y sin «J:».
   - Memoria usada (la tabla que manda es el bloque coop-rangos de docs/14): lo de (93m) sin cambios, más la ranura 3 (sólo PINE): datos 0x0046E0B0..0x0046E0C0, R3 0x0046E100..0x0046E340, código 0x0046E340..0x0046E468. Libre: 0x0046E468..0x0046F800.
9. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
