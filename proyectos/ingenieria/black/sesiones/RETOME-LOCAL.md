# Mensaje de retome — BLACK, notebook (después de la bitácora (90))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (90) del 2026-09-28: COOP-B ABIERTA. FRAN YA JUGÓ EL COOP CON DOS MANDOS REALES en el PCSX2 2.8.0 (acceso «JUGAR BLACK COOP - dos mandos»): la pantalla se parte (confirmado en su pantalla, ~60 cuadros/s) y J2 CAMINA Y GIRA con el otro mando (confirmado por él, después del arreglo (90c)). La banda amarilla quedó arreglada en (90b). coop_mod.py = 434 palabras. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (90) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(90)» de sesiones/HANDOFF.md y la entrada (90) de docs/03-bitacora.md (con (90b), (90c) y (90d)). Si hace falta contexto del stub, el bloque «(89)». Del código, sólo lo que toque la tarea: herramientas/coop_mod.py (POR_CUADRO_MOD, TITERE_MOD) y herramientas/pantalla_dividida.py (FUENTE). NO leas jugador2.py.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183).

3. Fase: COOP-B, ABIERTA. La cierran las tres cosas de PDP.md §4 (riesgos altos retirados por efecto; riesgos medios IA/muerte/disparadores decididos con su mecanismo leído; docs/14-coop-diseno.md medido por coop_diseno.py verificar con su saboteador en rojo). Lo que sigue, en orden (lo reportó Fran jugando, bitácora (90d)):
   a) J2 NO DISPARA con el mando real (en (85) sí hizo daño con el botón del mando FALSO 2 por tirador.py). Descartado: J2+0x418 (J y J2 valen 0 con J en el puerto 2). Primer paso barato, por PINE con la partida abierta: con Fran apretando R1 en el mando de J2, ¿cambia el buffer del puerto (0x005856C0 puerto 1 / 0x005857B0 puerto 2, +0x8C.. ejes, botones antes) y el control 0x005858A0? Si el control ve el botón, lo que falta está entre el control y el arma de J2 (J2+0x2A0 = ARMAS2).
   b) EL CUERPO DEL ALIADO SE VE SUPERPUESTO EN LA CÁMARA DE J2 (el títere está parado donde está J2 y J2 lo ve desde adentro), y J2 ve el arma en primera persona de J (lo que parecía «J2 hace la animación de disparo»). Hace falta VISIBILIDAD POR PASADA: en la pasada 2 ocultar el aliado-títere y el arma de J; en la 1, el arma de J2. En frío primero: qué dibuja los brazos/arma de un jugador (vista-fp K2) y qué flag oculta un personaje.
   c) «La cámara de la pistola no funciona igual que en J1»: el arma de J2 en su vista no sigue la mirada como la de J1 (capturas de Fran). Probablemente misma raíz que b).
   d) Sensibilidad rara y un mando con palancas gastadas: el parche «Zona muerta del pad a cero» deja que la deriva de un stick gastado mueva la mira. Opción barata: zona muerta de PCSX2 por puerto para el mando gastado (preguntar a Fran cuál es).
   e) La recarga de J2, B4–B6 en frío, docs/14 + coop_diseno.py.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs con FPU, donde un error cuelga el emulador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo al cerrar una fase/tramo, si necesitás una decisión de valor mía, si algo necesita que yo esté frente a la máquina, o si el tope de 5 h del plan pasa el ~85 % (get_usage): ahí se cierra con checkpoint.

ESTADO DE LA MÁQUINA: los ISO están en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\ (fuente: kb/ubicaciones.json), con los accesos en PS2\BLACK\: «JUGAR BLACK» (apaga el bloque), «JUGAR BLACK COOP - teclado y mando» y «- dos mandos» (JUGAR-BLACK.ps1 -Coop teclado|2mandos: coop_mod.py instalar + activar y reparten los mandos en el ini). EL QUE APRIETA START EN LA PANTALLA DE TÍTULO ES J1; J2 toma el otro puerto. El 2.8.0 de Program Files TIENE PINE en 28011 (sirve para medir sobre la partida de Fran). Para sondas propias: fork MCP, Start-Process "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','"C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso"'. El pnach instalado puede estar en la versión de 430 palabras: el acceso COOP lo reinstala con 434 (el arreglo del puerto); para una sonda propia, correr coop_mod.py instalar con PCSX2 cerrado.

REPRODUCIR (por PINE, bloque apagado): lanzar el fork -> ~35 s -> pine.py cargarestado --slot 3 (desde herramientas/) -> 8 s -> depurador.py continuar -> 12 s -> selector_depuracion.py vivo -> coop_mod.py poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> coop_mod.py mirar 30 -> coop_mod.py manos 2. Con el bloque PRENDIDO: lo mismo sin «poner». Esperas en un script de Python del scratchpad (el de (90b) es el modelo), nunca Start-Sleep suelto.

YA HECHO, NO REHACER: (85)–(89); (90b) la banda amarilla era la llamada única al tinte (0x0046FAA4, ahora nop; sin tinte de daño con la pantalla partida); (90c) J2 toma el control del puerto que J no usa (0x005858A0 puerto 1 / 0x00585A0C puerto 2; el tercer control 0x00585B78 tiene fuente 0).

7. Trampas medidas:
   - El 2.8.0 con un juego corriendo: CloseMainWindow() abre «Confirmar apagado» y queda esperando; para cerrar uno de prueba, Stop-Process (no pisa el ini). NUNCA cerrar la partida de Fran sin avisar.
   - Los savestates tienen a J en el puerto 1: una prueba desde el slot 3 no ve nada que dependa de qué puerto apretó Start.
   - REESCRIBIR UN STUB EN CALIENTE con otra disposición puede volver a una instrucción corrida: pantalla -> pantalla_dividida.py quitar, esperar, poner en pausa; por cuadro -> FASE (0x0046D790) = 0, esperar, escribir en pausa, FASE = 2. Datos (punteros de J2) sí se pueden escribir en caliente.
   - UNA sola conexión PINE a la vez.
   - El banco de daño con tirador.py --acercar NO mide; aliados lejos y J como referencia positiva ANTES.
   - Mensajes de commit a archivo con [IO.File]::WriteAllText sin BOM (Out-File -Encoding utf8 mete BOM en el asunto) y sin «J:».
   - selector_depuracion.py pedir-frontend desde el menú del arranque hace saltar la CPU a datos: pedirlo desde adentro de un nivel (slot 3).
   - Código nuevo en un stub: con el emulador EN PAUSA. kb/subsistemas.json con herramientas/kb_formato.py.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, datos del mod 0x0046D780..0x0046D7D0, por cuadro 0x0046D800..0x0046D998 (tope 0x0046D9F0), envoltorio 0x0046DA00..0x0046DB7C, armas de J2 0x0046DBC0..0x0046DBE0, desarme 0x0046DD00..0x0046DD90, pantalla 0x0046F800..0x0046FAD4, filtro del tinte 0x0046FB00..0x0046FB20, DATOS de la pantalla 0x0046FC00..0x0046FC98, falso 1 0x00472000, falso 2 0x00472100. Libre: 0x0046DE00..0x0046F800 y 0x0046FB20..0x0046FC00.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
