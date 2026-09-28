# Mensaje de retome — BLACK, notebook (después de la bitácora (88))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (88) del 2026-09-27: COOP-B ABIERTA; B1, B2b (en el stub) y B3 HECHAS. EL COOP EN PANTALLA DIVIDIDA SALE DEL PNACH SOLO: coop_mod.py = 375 palabras (envoltorio del cargador, stub por cuadro con títere y cabeceo, desarme, pantalla dividida en 0x0046F800 con la vista de J2 calculada con sinf/cosf del ELF, 4 constantes y 6 ganchos). Con PCSX2 reiniciado y el bloque prendido, sin Python del mod: J2 se arma, camina con el mando 2, el aliado 1 le hace de cuerpo y la pantalla se divide sola. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (88) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(88)» de sesiones/HANDOFF.md y la entrada (88) de docs/03-bitacora.md (con (88b)–(88e)). Del código, sólo lo que toque la tarea: herramientas/coop_mod.py (programas(), POR_CUADRO_MOD, CABECEO_MOD, TITERE_MOD) y herramientas/pantalla_dividida.py (FUENTE, VISTA_J2). NO leas jugador2.py.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183).

3. Fase: COOP-B, ABIERTA. La cierran las tres cosas de PDP.md §4 (riesgos altos retirados por efecto; riesgos medios IA/muerte/disparadores decididos con su mecanismo leído; docs/14-coop-diseno.md medido por coop_diseno.py verificar con su saboteador en rojo). Lo que sigue, en orden:
   a) SI FRAN YA PROBÓ EL MANDO 2 REAL: registrar lo que vio (es la prueba de punta a punta de B3 y del cabeceo). Si no, sigue igual con lo demás.
   b) LA PROPORCIÓN DE LAS MITADES: hoy cada mitad muestra el FOV entero aplastado a 320 px. La proporción la ponen R+0xD400+0x70 (1,333) y +0x74 (1,778), R = *(0x0040F4C0): ×0,5 durante las dos pasadas y restaurar (bitácora (84)). Control: captura con y sin, un objeto redondo/cuadrado.
   c) EL HUD POR MITAD: el «fantasma» amarillo espejado en la mitad 2 es un efecto de pantalla completa (84). En frío primero: qué lo dibuja.
   d) Esconder los brazos de J2 en la vista de J (B2b fino), la recarga de J2, B4–B6 en frío, docs/14 + coop_diseno.py.
   e) La prueba de daño de punta a punta con el cabeceo nuevo: con un enemigo que llegue SOLO a la línea de tiro (sin --acercar) y con J como referencia positiva sobre el mismo blanco ANTES de leer el par.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: MIPS en stubs con FPU, donde un error cuelga el emulador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, (c) algo necesita que yo esté frente a la máquina, o (d) el tope de 5 h del plan pasa el ~85 % (get_usage): ahí se cierra con checkpoint.

ESTADO DE LA MÁQUINA: PCSX2 cerrado. Lanzarlo con Start-Process "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','"C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"'. El bloque [COOP - jugador 2 (B3)] (375 palabras) está INSTALADO en Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach y APAGADO (coop_mod.py activar / desactivar, con PCSX2 cerrado; el emulog dice «Enabled patch: COOP - jugador 2 (B3)»).

REPRODUCIR (por PINE, bloque apagado): lanzar PCSX2 -> ~35 s -> pine.py cargarestado --slot 3 (desde herramientas/) -> 8 s -> depurador.py continuar -> 12 s -> selector_depuracion.py vivo -> coop_mod.py poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> coop_mod.py mirar 30 (fase 2, estado 3, titeres subiendo) -> coop_mod.py manos 2 (~8 m, el aliado lo sigue a ≤ 0,3 m; la pantalla ya está dividida). Con el bloque PRENDIDO: lo mismo sin «poner». Las esperas van en un script de Python del scratchpad (time.sleep + subprocess, encoding utf-8), nunca Start-Sleep suelto.

YA HECHO, NO REHACER: todo lo de (85)–(87) y (88): el títere en el stub; sinf/cosf del ELF; la convención del cuaternión (q_yaw·q_cabeceo, medida sobre J); +0xD0 tiene la MISMA convención en J y J2; negar el cabeceo alrededor del update del stub NO llega a la matriz (refutado); el raster en vivo y la guarda FASE/ESTADO.

7. Trampas medidas:
   - REESCRIBIR UN STUB EN CALIENTE con otra disposición puede volver a una instrucción corrida: pantalla -> pantalla_dividida.py quitar, esperar, poner en pausa; por cuadro -> FASE (0x0046D790) = 0, esperar, escribir en pausa, FASE = 2.
   - UNA sola conexión PINE a la vez: no abrir `with Pine()` mientras corre otra herramienta PINE.
   - El banco de daño con tirador.py --acercar NO mide (al blanco movido no le pega ni J); un aliado con IA cerca del tirador mata por su cuenta: aliados lejos y J como referencia positiva ANTES.
   - El guardia de PowerShell lee «J:» dentro de un mensaje de commit como unidad de disco: mensajes a archivo (git commit -F) y sin «J:».
   - selector_depuracion.py pedir-frontend DESDE EL MENÚ DEL ARRANQUE hace saltar la CPU a datos: pedirlo desde adentro de un nivel (slot 3).
   - «Failed to open patches.zip» y «FQC = 0 on VIF FIFO READ» son de la copia PCSX2-MCP.
   - Código nuevo en un stub: con el emulador EN PAUSA. Nada de heredocs: script al scratchpad. Set-Content en PS 5.1 mete BOM. kb/subsistemas.json con herramientas/kb_formato.py.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, datos del mod 0x0046D780..0x0046D7D0 (TITERES +0x7CC), por cuadro 0x0046D800..0x0046D988 (tope 0x0046D9F0), envoltorio 0x0046DA00..0x0046DB7C, armas de J2 0x0046DBC0..0x0046DBE0, desarme 0x0046DD00..0x0046DD90, pantalla 0x0046F800..0x0046FA20, DATOS de la pantalla 0x0046FC00..0x0046FC98 (+0x20..+0x2C senos, +0x60..+0x7F vista calculada), falso 1 0x00472000, falso 2 0x00472100. Libre: 0x0046DE00..0x0046F800 y 0x0046FA20..0x0046FC00.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
