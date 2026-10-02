# Mensaje de retome — BLACK, notebook (después de (112): HUD de dos jugadores visto, PDR escrita para Fran)

Pegar tal cual como primer mensaje del chat siguiente. Es también la validación 4 de 5 de T11/T12 del método.

```
Retomo BLACK (proyectos/ingenieria/black). Validación 4 de 5 de T11 y T12.

1. LEER, en orden: primero `.\cascada.ps1 black -Necesidad ingenieria-inversa,diseno` y CON Read cada rango que imprima (la puerta no deja actuar sin eso); después la entrada (112) de docs/03-bitacora.md, sesiones/PREDICCIONES-112.md y docs/18-pdr-coop.md (la PDR). De arquitectura-se, sólo el rango que exija la puerta.
2. FASE: COOP-B -- NASA Phase B, "Preliminary Design and Technology Completion" = el diseño en grueso, con los riesgos grandes resueltos. No se hace: construir a prueba y error. La cierra la PDR: docs/18 revisado por Fran (sus seis respuestas) ANTES de fabricar. Si Fran ya contestó: anotar sus respuestas en docs/18 y docs/16, cerrar la B en PDP.md §4 y abrir la C con su criterio escrito antes. Si no contestó, lo que queda de la B, en vivo y con la pantalla LIBRE (las fotos necesitan el foco):
   V1 H4a: `python herramientas/hud_doble.py --pasos0` -> el HUD de la derecha pasa de 000 a los valores de J (predicción en PREDICCIONES-112). Si resumen.json dice FOTOS_INVALIDAS, no se concluye.
   V2 la escala del marco raíz del panel (*(panel+0x54)+8, hipótesis) para que el HUD no quede apretado.
   V3 la sonda de la fábrica de cuerpos (docs/16, «Cuerpos», (112)): FUN_00178408 llamada una vez con el descriptor de un spawner de Wilderness; el spawner queda igual.
   V4 (si hay tiempo) un cambio de unidad real con J2 lejos y «continuar misión» desde un punto de control.
3. MOTOR: Opus, esfuerzo high, sin fan-out (sondas con predicción sobre un diseño ya leído; un solo hilo). Nunca Fable.
4. MÁQUINA (al cerrar (112)): pnach con el bloque COOP + IA (938 palabras, sin cambios). Fork cerrado; PCSX2 de Fran cerrado. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; se lanza con campana_coop.lanzar() + probar_nivel(0) (City Streets). El emulador lo abre la sesión (autorización permanente): primero abrir-sesion.ps1. PCSX2.ini global con FrameRateNTSC 59.94 (verificarlo).
5. YA RESUELTO, no rehacer: (112) el HUD de dos jugadores existe (dos paneles al arrancar; la carga prende cuenta = jugadores en 0x00128F5C); prenderlo a mano da DOS HUD, uno por mitad (confirmado); el de la derecha lee jugadores[1] (ceros); diseño H1-H4 en docs/16 y 16 filas en coop-plan-b (verificadas, sabotaje en rojo). F11: el spawner se traba con un títere inmortal (+0x24); diseño por la fábrica sin spawner. (111): IA por defecto, B4, B5, S1, S4, F2, F3, F7, teletransporte, N4, campaña 8/8.
6. TRAMPAS MEDIDAS: con ventanas de Fran adelante, capturar-pantalla.ps1 no toma el foco y capturar-ventana.ps1 (PrintWindow) devuelve un cuadro VIEJO (md5 idénticos): hud_doble.py lo marca. Escribir CÓDIGO por PINE sólo en pausa. Usar `python pruebas/controles.py` antes de commitear (no `| tail`). Heredocs largos: escribir el script con Write.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa,diseno
Al cerrar: python perfil-global\herramientas\medir-cascada.py y python proyectos\ingenieria\arquitectura-se\medir-costo.py --ultimas 3, y anotar en arquitectura-se/HANDOFF.md como validación 4 de 5.
```
