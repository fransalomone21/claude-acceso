# Mensaje de retome — BLACK, notebook (después de la nube: bitácoras (93s)–(93v))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la tanda en frío de la NUBE: bitácoras (93s), (93t), (93u) y (93v) del 2026-09-28. Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA. Trabajo EN ESTE CHAT, sin tareas programadas y sin agentes (tampoco «remotos»: gastan el plan Pro). Lo que sigue es LO CALIENTE: el frío ya está hecho.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. El último commit que tocó proyectos/ingenieria/black tiene que ser el cierre de la nube (93v) o posterior; si no, pará.

1. Leé SOLO: las entradas (93s), (93t), (93u) y (93v) de docs/03-bitacora.md (arriba de todo), docs/15-tercera-ranura.md (la sección «Para el pnach — lo que quedó en el código (93s)») y, de herramientas/coop_mod.py, el bloque de la ranura 3 (R3_POR_CUADRO_MOD, R3_ENVOLTORIO_MOD, R3_BAJA_MOD, ranura3()). Si hay entradas más nuevas en la bitácora, leelas: manda la bitácora.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (184), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN), python herramientas/parpadeo_escala.py --autotest (BIEN).

3. La predicción se escribe ANTES de abrir el emulador, y cada sonda lleva su control en la misma corrida.

4. Fase: COOP-B, ABIERTA (criterio: PDP.md §4). En este orden:
   a) LA RANURA 3 POR EL PNACH (93s). El código ya está: coop_mod.py; desde (93v) va APAGADA por defecto (el acceso de jugar instala sin ella) y se prende con --con-r3 (787 palabras; sin ella, 638).
      - Instalar CON la ranura (python herramientas/coop_mod.py instalar --con-r3) y correr la regresión: python herramientas/campana_coop.py -> predicción: 8 de 8 como en (93e)/(93m), el emulador vivo, y en RAM R3_ARMADA (0x0046E0B4) = 1 una sola vez por arranque, R3_CARGAS (0x0046E0B8) = una por nivel cargado, R3_BAJAS (0x0046E0C4) = una por nivel dejado, J2+0x330 = 0x0046E100 y *(0x0046E100) = J2 en cada nivel, y el dueño de r0 (*(pers+0x470)) = J.
      - La fuga, sobre el pnach: la MEDICIÓN de ranura3b.py (pose de J = compañero de r0, la cola de V, el arma de J, los contadores del filtro), con el bloque instalado con --con-r3 contra el bloque instalado sin ella como control. Predicción: con la ranura, 1 palabra (ruido) contra ~33, el arma de J nunca en 8. OJO: la parte de ranura3.py/ranura3b.py que ARMA por PINE escribe en 0x0046E340.., que ahora es el código del pnach: con la ranura instalada NO se arma por PINE, sólo se mide.
      - El cambio de arma de J2 (el mando 2 cambia de arma, 2 veces): predicción: R3_DESVIOS (0x0046E0C0) sube una vez por cambio, R3_REAPUNTES (0x0046E0BC) también, J2+0x330 vuelve a R3 al cuadro siguiente y el dueño de r0 y r1 sigue siendo J. Riesgos a mirar (93s): los brazos de J durante el cambio de J2.
      - Si todo da: SIN_R3 = False por defecto en coop_mod.py (así el acceso de jugar la instala) y se actualiza el número de palabras en ESTADO_ACTUAL.
   b) EL PARPADEO (93t) Y SU ARREGLO (93v, opción 2 aprobada por Fran): el coop trae su pantalla ancha, el stub es el dueño de R+0xD470/74 y el lanzador -Coop APAGA el «Widescreen 16:9» comunitario.
      - Primero mirá que el lanzador hizo lo suyo: en el emulog, con el acceso COOP, «Enabled patch: COOP - jugador 2 (B3)» y NO «Widescreen 16:9»; con JUGAR BLACK (solo), al revés. En RAM, R+0xD470/74 (0x004CA5F0/F4) = 4/3 y 16/9 fuera de las pasadas.
      - Medición con control, J2 quieto disparando, 16 capturas (como parpadeo_volcados.py), medidas con python herramientas/parpadeo_escala.py REF.png cap*.png (REF = captura con J2 quieto): (1) como lo deja el acceso COOP: predicción 0 de 16 en B y la imagen en 16:9 sin estirar; (2) control, la misma corrida con «Enable = Widescreen 16:9» agregado a mano en los ajustes del juego: predicción >= 1 de 16 en B (vuelve la carrera). Si (2) da 0, el control no mide: más capturas o J2 con más carga.
   c) B5 (93u). Sonda 1: vigilar J+0x5F0 (= ctrl+0x100 de J) mientras J recibe daño hasta morir; predicción: sube a >= 1 antes de morir y *(0x0040F0E0)+0x21098 pasa a 1. Sonda 2: J2 muere por un código de una vez que llama FUN_0013c3e8 sobre J2 con daño >= su vida (control: daño menor). Predicción según la 1. Con eso, el envoltorio de FUN_0013ffa0 (0x0013FFA0): si a0 = 0x0046D2E0 y a1 = 5 -> J2 reaparece junto a J con vida, sin terminar la partida.
   d) El cuerpo en los 3 niveles sin aliado sólo si Fran dice que sí. NO tocar la sensibilidad de los mandos.

5. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs, donde un error cuelga el emulador. Nunca Fable.
6. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
7. Autonomía: de tramo en tramo, hasta ~60 % de contexto o ~90 % del 5 h (get_usage); antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA: ISO en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso (fuente: kb/ubicaciones.json). pnach instalado con 636 palabras y el bloque ACTIVO hasta el próximo doble clic en un acceso COOP, que reinstala con coop_mod.py instalar: desde (93v) eso son 638 palabras + la pantalla ancha propia, SIN la ranura 3 (con --con-r3, 787). El acceso COOP apaga el «Widescreen 16:9» comunitario y «JUGAR BLACK» (solo) lo vuelve a prender. «JUGAR BLACK» lo apaga. El 2.8.0 de Fran: CERRADO; su partida está en el slot 14 (no la pises). Fork de pruebas: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 con el 2.8.0: probar con el 2.8.0 cerrado; PINE 28011). Cerrar el fork con Stop-Process filtrando la ruta de Downloads\PCSX2-MCP.

YA HECHO, NO REHACER: (85)–(93r); (93s) el código de la ranura 3 (en frío: el reatar de accesorios está REFUTADO, J2+0x25C.. son los objetos de J); (93t) el parpadeo en frío (la vista B es la mitad con la proporción entera; clasificador parpadeo_escala.py); (93u) la cadena de muerte en frío; (93v) el arreglo del parpadeo (pantalla ancha propia del coop, 4 palabras del stub) y la ranura 3 apagada por defecto.

8. Trampas medidas:
   - EL PNACH ES patch=1: reescribe sus palabras EN CADA CUADRO, y PCSX2 lo hace desde el emulador: un vigilante de escritura del EE NO lo ve (eso escondió el parpadeo en (93k)). Vale para los parches comunitarios también.
   - Con la ranura 3 instalada, 0x001295A8 y 0x001ACA84 son ganchos del pnach: el código de una vez por PINE necesita otro sitio.
   - El guardia PreToolUse bloquea heredocs con comillas mezcladas o backslash y prosa en castellano en comandos: los textos y scripts van a archivo con la herramienta Write.
   - La tanda de control puede vaciarle TODA la munición a J2 y la prueba siguiente no recarga: ranura3.rellenar() antes de cada tanda.
   - Las capturas de la mitad de J incluyen al títere (el cuerpo de J2), que se mueve con J2: medir en la caja de los brazos (ranura3.mitades).
   - Dos cuerpos de colisión EXACTAMENTE en el mismo punto cuelgan el EE en FUN_0033DD98. Breakpoints de ejecución tiran el emulador (usar vigilante de lectura sobre una bandera). Un «cartel eterno» al cargar no es una espera: muestreá el PC. No apretes Start en pleno juego. Los savestates tienen a J en el puerto 1. UNA sola conexión PINE a la vez. Commits con mensaje en archivo, sin BOM y sin «J:».
   - Un volcado «en pausa» puede caer A MITAD de la escena (el de (93r) fuego-1 cayó dentro de la pasada 1: DATOS+0x3C = 1). Antes de comparar volcados, mirá DATOS+0x3C.
   - Memoria (la tabla que manda es el bloque coop-rangos de docs/14): ranura 3 datos 0x0046E0B0..0x0046E0CC (fuera del pnach), R3 0x0046E100..0x0046E340, por cuadro 0x0046E340..0x0046E484, envoltorio 0x0046E4A0..0x0046E578, desarme hasta 0x0046DDC0. Libre: 0x0046E580..0x0046F800.
9. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
