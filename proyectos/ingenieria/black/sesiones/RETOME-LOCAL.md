# Mensaje de retome — BLACK, notebook (después de (111): IA a los dos por defecto, sondas del concepto confirmadas)

Pegar tal cual como primer mensaje del chat siguiente. Es también la validación 3 de 5 de T11/T12 del método.

```
Retomo BLACK (proyectos/ingenieria/black). Validación 3 de 5 de T11 y T12.

1. LEER, en orden: primero `.\cascada.ps1 black -Necesidad ingenieria-inversa,diseno` y CON Read cada rango que imprima (la puerta no deja actuar sin eso); después la entrada (111) de docs/03-bitacora.md y sesiones/PREDICCIONES-111.md. NO leer nada de arquitectura-se.
2. FASE: COOP-B -- NASA Phase B, "Preliminary Design and Technology Completion" = el diseño en grueso, con los riesgos grandes resueltos. No se hace: construir a prueba y error. La cierra la PDR: el diseño escrito, verificado contra el ELF y revisado por Fran ANTES de fabricar. Lo que queda para la PDR, en orden:
   P1 (frío) HUD: quién arma la lista 2D que reproduce FUN_00278EA0(panel+0x40) (el panel es de 0x0040F518) y si el 2D acepta un corrimiento global (FUN_00266088 / FUN_002662A8). Sonda del concepto en vivo después: reproducir la lista corrida a la mitad derecha.
   P2 (frío) F11: la receta del cuerpo en los niveles sin aliados (Wilderness, Steelworks, Gulag): soldado de spawner con bando 0 (93i).
   P3 (escritorio) el DOCUMENTO DE LA PDR para Fran: un resumen de docs/14 + docs/16 + docs/17 en criollo (qué hace el mod, qué falta construir en la C, qué quedó medido y qué no), para que lo revise. Sin su ok no se fabrica.
   P4 (vivo, si hay tiempo) un cambio de unidad real con J2 lejos (pide jugar o llegar con teletransporte al borde de una unidad) y «continuar misión» desde un punto de control.
3. MOTOR: Opus, esfuerzo high, sin fan-out (desensamblado y diseño; un solo hilo). Nunca Fable.
4. MÁQUINA (al cerrar (111)): pnach con el bloque COOP + IA (938 palabras: la IA ya es el default de coop_mod.py; --sin-ia es el control). Fork cerrado; PCSX2 de Fran cerrado. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; se lanza con campana_coop.lanzar() + probar_nivel(0) (City Streets). El emulador lo abre la sesión (autorización permanente): primero abrir-sesion.ps1. PCSX2.ini global con FrameRateNTSC 59.94 (verificarlo: ya volvió a 146 dos veces).
5. YA RESUELTO, no rehacer: CON_IA por defecto; B4 (un enemigo elige a J2 y lo mata; control 3/3); B5 por daño real; sondas del concepto S1 (juntar), S4 (sonido), F2, F3 (cuerpo de J), F7; el teletransporte (herramientas/teletransporte.py: TRES lugares de la posición); el diseño de N4 (traer a J2 en 0x0012DDCC, coop-plan-b); campaña 8/8 con la IA. El HUD NO son las páginas 1/2/6 (medido).
6. TRAMPAS MEDIDAS: escribir CÓDIGO por PINE sólo en pausa (depurador.py pausar/continuar). Encadenar un control con `| tail && git commit` tapa el rojo: usar `python pruebas/controles.py` (sale 1 si algo falla). El teletransporte de una sola escritura se pisa en City Streets. En City Streets el aliado 0 es el títere de J2 (usar el 1). girar_hacia puede dejar mal el encuadre: el yaw de la mira es atan2(dx, dz) en grados. Heredocs largos: los frena el hook; escribir el script con Write.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa,diseno
Al cerrar: python perfil-global\herramientas\medir-cascada.py y python proyectos\ingenieria\arquitectura-se\medir-costo.py --ultimas 3, y anotar en arquitectura-se/HANDOFF.md como validación 3 de 5.
```
