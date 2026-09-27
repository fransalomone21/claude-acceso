# Mensaje de retome — BLACK, notebook (después de la bitácora (87))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (87) del 2026-09-27: COOP-B ABIERTA; B1, B2b (prototipo por PINE) y B7 HECHAS; B3 HECHA Y AGUANTA CARGAS SEGUIDAS: coop_mod.py (202 palabras, SOLO CÓDIGO) = envoltorio del cargador (copia J -> J2) + stub por cuadro (control2 + enlazar + atar + correr a J2) + DESARME (0x0046DD00, gancho 0x00129E38: después de la baja del juego, FUN_0025C2C8 + FUN_0012A280 para J2). Tres cargas seguidas, J2 camina ~7,5 m en 2 s cada vez; sin la baja la 2.ª carga cae. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (87) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(87)» de sesiones/HANDOFF.md, la entrada (87) de docs/03-bitacora.md, y de herramientas/coop_mod.py el docstring y POR_CUADRO_MOD (ahí van el títere y la vista). Para el títere: herramientas/titere.py; para la vista: herramientas/pantalla_dividida.py (el stub 0x0046FA00 y sus DATOS 0x0046FC00). NO leas jugador2.py salvo que algo no cierre.

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido (lo que sigue es escribir MIPS en stubs, no leer desensamblado nuevo), python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183).

3. Fase: COOP-B, ABIERTA. La cierran las tres cosas de PDP.md §4. Lo que sigue, en orden:
   a) EL TÍTERE EN EL STUB: cada cuadro copiar la matriz de J2 (J2+0x70..+0xAF, 4 qwords con lq/sq) al aliado 1 = *(0x0040F514)+0x90+0x3C0, en su +0x70. Hoy lo hace titere.py por PINE. Prueba con control: J2 camina 7,5 m y el aliado lo sigue (≤ 0,3 m); sin el títere el aliado queda quieto. Cuidado: niveles sin aliado 1 (mirar su tipo en +0x328 antes de escribir).
   b) LA VISTA DE J2 EN EL STUB: pantalla_dividida.py calcula en Python el cuaternión (DATOS+0x40) desde el yaw de la mira de J2 (*(J2+0x32C)+8) y el ojo (DATOS+0x50 = J2+0x100). Pasarlo al stub (qmtc2/VU0 o tabla de seno); con control: misma vista que hoy por Python.
   c) EL CABECEO DE J2: su matriz +0xD0 tiene el cabeceo al revés de su mira (sin eso sus balas van por arriba: B7). Corregirlo en el stub; control con tirador.py J2 <blanco> (sin --pitch-invertido tiene que matar).
   d) Después: la pantalla dividida entera en el pnach (hoy pantalla_dividida.py poner por PINE), la recarga de J2, B2b fino, B4–B6 en frío, docs/14 + coop_diseno.py.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: es escribir MIPS con aritmética de VU0/FPU donde un error cuelga el emulador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, (c) algo necesita que yo esté frente a la máquina, o (d) el tope de 5 h del plan pasa el ~85 % (mirarlo con get_usage): ahí se cierra con checkpoint.

ESTADO DE LA MÁQUINA: PCSX2 cerrado. Lanzarlo con Start-Process "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','"C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"'. El bloque [COOP - jugador 2 (B3)] (202 palabras, con la baja) está INSTALADO en Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach y APAGADO en gamesettings (coop_mod.py activar / desactivar, con PCSX2 cerrado; el emulog dice «Enabled patch: COOP - jugador 2 (B3)»).

REPRODUCIR B3 (por PINE, sin el pnach): lanzar PCSX2 -> ~35 s -> pine.py cargarestado --slot 3 (desde herramientas/) -> 8 s -> depurador.py continuar -> 12 s -> selector_depuracion.py vivo -> coop_mod.py poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> coop_mod.py mirar 30 (moldes 1, fase 2, estado 3, atadas 1) -> coop_mod.py manos 2 --control / manos 2 (~7,5 m). Repetir desde pedir-frontend para la carga siguiente (desarmes sube de a 1). Las esperas NO van con Start-Sleep suelto (el harness lo bloquea): un script de Python en el scratchpad que corre la secuencia con time.sleep y subprocess (encoding utf-8).

YA HECHO, NO REHACER: todo lo de (85) y (86) (ver HANDOFF) y (87): el desarme del juego es FUN_00129DE8 estado 0x1D -> FUN_0012BFC8 (espejo de FUN_0012BE80); la causa del cuelgue era el controlador de colisión de J2 (aislado con la variante sólo-lista); el registro físico de FUN_0016E660 lo resetea entero FUN_0016DC80 (hipótesis, no hizo falta tocarlo).

7. Trampas medidas:
   - selector_depuracion.py pedir-frontend DESDE EL MENÚ DEL ARRANQUE hace saltar la CPU a datos: pedirlo siempre desde adentro de un nivel (slot 3).
   - El aviso «Failed to open patches.zip» y el cartel «FQC = 0 on VIF FIFO READ» son de la copia PCSX2-MCP (aserciones prendidas); el segundo sale DESPUÉS de un cuelgue, no es la causa.
   - coop_mod.py manos se niega si el mod todavía no preparó el control2.
   - Cuelgue: emulog en Documents\PCSX2\logs\emulog.txt; contar «TLB Miss» antes y después de cada corrida.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo).
   - pine.py cargarestado desde herramientas/ y SIN redirigir su salida a $null. Una sola conexión PINE por proceso.
   - Código nuevo en un stub: con el emulador EN PAUSA. Nada de heredocs: script al scratchpad y python <ruta>. Commits largos con git commit -F. Set-Content en PS 5.1 mete BOM. kb/subsistemas.json con herramientas/kb_formato.py.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, datos 0x0046D780..0x0046D7CC (ESPERA +0x7B8, MOLDES +0x7C0, ATADAS +0x7C4, DESARMES +0x7C8), stub por cuadro 0x0046D800..0x0046D910 (tope 0x0046D9F0), envoltorio 0x0046DA00..0x0046DB7C, armas de J2 0x0046DBC0..0x0046DBE0, desarme 0x0046DD00..0x0046DD90, pantalla dividida 0x0046FA00..0x0046FC94, falso 1 0x00472000, falso 2 0x00472100. Libre: 0x0046DE00..0x0046FA00.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
