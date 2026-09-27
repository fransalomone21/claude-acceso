# Mensaje de retome — BLACK, notebook (después de la bitácora (86))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (86) del 2026-09-27: COOP-B ABIERTA; B1, B2b (prototipo por PINE) y B7 HECHAS; B3 HECHA EN LA PRIMERA CARGA: coop_mod.py mete el prototipo en los stubs como SOLO CÓDIGO (el envoltorio del cargador copia J -> J2 con lq/sq al terminar J; el stub por cuadro hace control2 + enlazar + atar + correr a J2), y entregado por el pnach J2 camina 7,5 m en 2 s con el mando 2. LA SEGUNDA CARGA CUELGA EL EMULADOR. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que el último commit que tocó proyectos/ingenieria/black/sesiones/HANDOFF.md sea el cierre de la (86) o posterior. Si no, pará.

1. Leé SOLO: el bloque «(86)» de sesiones/HANDOFF.md, la entrada (86) de docs/03-bitacora.md (es la primera; la necesitás entera: tiene la caída y la sonda H1/H2) y herramientas/coop_mod.py (ENVOLTORIO_MOD y POR_CUADRO_MOD). NO leas jugador2.py salvo que algo no cierre. Para B3.3: herramientas/censo_jugadores.py y su salida (los lazos sobre jugadores[] que obedecen a cuenta = 1).

2. Controles: .\proyectos\ingenieria\black\abrir-sesion.ps1 (SIN -Rapido: B3.3 es lectura de desensamblado, hace falta Ghidra: decompilar.py info), python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (183).

3. Fase: COOP-B, ABIERTA. La cierran las tres cosas de PDP.md §4. Lo que sigue, en orden:
   B3.3 — LA BAJA DE J2 AL SALIR DEL NIVEL. Hecho: la segunda carga cuelga en TLB Miss pc=0x33DDB0 addr=0x2000000 (FUN_0033DD98, un lqc2 de VU0, llamada por FUN_00336520, pila 0x01FFF000) al primer cuadro del nivel nuevo, con moldes = 2. H1 (correr a J2 durante el desarme) REFUTADA: con fase = 0 por PINE (0 cuadros de J2 en 1 s) cuelga igual. H2 probable: algo que se le da de alta a J2 sobrevive al nivel. Candidatos: el registro físico FUN_0016E660, el enlace FUN_0012A158, el controlador de colisión FUN_0025C210 (pool en 0x00585C00), lo que haga el constructor FUN_00139C68. A J lo da de baja el juego en algún lazo sobre jugadores[] que obedece a cuenta (sonda 5). En frío: encontrar ese desarme y qué llama por jugador; qué es FUN_00336520 y qué lista recorre. Después replicar la baja para J2 (en el envoltorio antes de copiar el molde, o donde el juego da de baja a J) y PROBAR CON DOS CARGAS SEGUIDAS, con control (lección nueva: una carga que anda no prueba el mod).
   Después: el títere (matriz J2+0x70..+0xAF -> aliado 1 = *(0x0040F514)+0x90+0x3C0, +0x70, cada cuadro), la vista de J2 (pantalla_dividida.py: DATOS+0x40 cuaternión y +0x50 ojo, hoy los escribe Python) y el cabeceo de J2 (su matriz +0xD0 tiene el cabeceo al revés de su mira) en los stubs; B2b fino; B4–B6 en frío; docs/14 + coop_diseno.py.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: B3.3 es leer el desarme en desensamblado. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.

ESTADO DE LA MÁQUINA: PCSX2 quedó COLGADO en la segunda carga: cerralo (Stop-Process -Name pcsx2-qt) y relanzá con Start-Process "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -ArgumentList '-fastboot','-batch','--','"C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"' (el .bat deja la consola colgada). El bloque [COOP - jugador 2 (B3)] está INSTALADO en Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach y APAGADO en gamesettings (coop_mod.py activar / desactivar; el emulog dice «Enabled patch: COOP - jugador 2 (B3)» cuando carga, y se lee al ARRANCAR el juego: activar con PCSX2 cerrado).

REPRODUCIR B3 (una carga): coop_mod.py activar -> lanzar PCSX2 -> esperar ~35 s -> pine.py cargarestado --slot 3 (desde herramientas/) -> 8 s -> depurador.py continuar -> 12 s -> selector_depuracion.py vivo -> pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> coop_mod.py mirar 40 (moldes 1, fase 2, estado 3, atadas 1) -> coop_mod.py manos 2 --control / manos 2 (~7,5 m). Sin el pnach: coop_mod.py poner desde el slot 3 hace lo mismo por PINE (en pausa).

YA HECHO, NO REHACER: todo lo de (85) (ver HANDOFF) y (86): el molde lo copia el envoltorio; CTRL2 = *(J+0x588) + 0x16C y CTRL2+0xC de fábrica es el mando 2 real (0x5857B0); el slot 3 tiene 0x0046CDF0..0x00472200 en cero; entregado por pnach anda en la primera carga.

7. Trampas medidas:
   - selector_depuracion.py pedir-frontend DESDE EL MENÚ DEL ARRANQUE hace saltar la CPU a datos (con y sin el mod, controlado): pedirlo siempre desde adentro de un nivel (slot 3).
   - El aviso «Failed to open patches.zip» es de la copia PCSX2-MCP (no trae resources\patches.zip): inocuo para los parches de usuario.
   - coop_mod.py manos se niega si el mod todavía no preparó el control2 (antes le robaba el mando a J).
   - Cuelgue del emulador: emulog en Documents\PCSX2\logs\emulog.txt; la primera línea anómala y la hora de la última conexión PINE lo ubican (así se separó el selector del mod).
   - Un cuelgue deja el PC en 0x8000018C (Trap en lazo) o fijo en la función que cayó; depurador.py pila / registros / hilos lo leen.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo; gira la vista de J).
   - pine.py cargarestado desde herramientas/ y SIN redirigir su salida a $null. Una sola conexión PINE por proceso.
   - Código nuevo en un stub: con el emulador EN PAUSA. Nada de heredocs: script al scratchpad y python <ruta>. Commits largos con git commit -F. Set-Content en PS 5.1 mete BOM. kb/subsistemas.json con herramientas/kb_formato.py.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, datos 0x0046D780..0x0046D7C8 (ESPERA +0x7B8, MOLDES +0x7C0, ATADAS +0x7C4), stub por cuadro 0x0046D800..0x0046D910, envoltorio 0x0046DA00..0x0046DB7C, armas de J2 0x0046DBC0, pantalla dividida 0x0046FA00..0x0046FC94, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
