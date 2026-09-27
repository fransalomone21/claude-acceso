# Mensaje de retome — BLACK, notebook (después de la bitácora (85))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (85) del 2026-09-27: COOP-B ABIERTA; B1 HECHA (dos vistas en el mismo cuadro, (84)); B2b HECHA como prototipo por PINE (el cuerpo de J2 es un ALIADO del nivel, el que eligió Fran: un soldado aliado copia la matriz de J2 y lo sigue) y B7 HECHA (J2 hace daño: su matriz de vista tenía el cabeceo al revés). Sin fuego amigo entre jugadores, por diseño del juego. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md): tiene que ser el cierre de la bitácora (85) o posterior. Si no está, pará.

1. Leé SOLO: el bloque «(85)» de sesiones/HANDOFF.md (es el primero), PDP.md §4 «Proyecto COOP — Fase B» (criterio, cómo se certifica y la tabla B1–B7) y, para B3, las líneas 1–256 de herramientas/jugador2.py (PROGRAMA, ENVOLTORIO_PROG, ATAR_PROG) y herramientas/pantalla_dividida.py. NO leas la bitácora salvo que algo no dé lo que dice acá. NO leas ESTADO_ACTUAL entero (la sección EL PROGRAMA alcanza si hace falta).

2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py (183 comprobaciones; manda el número que imprime).

3. Fase: COOP-B (diseño preliminar), ABIERTA. La cierran, las tres: (1) B1, B2, B3 y B7 retirados por efecto con control (B1 y B7 YA; B2 como prototipo por PINE); (2) IA, muerte de J2 y disparadores con su mecanismo leído (K4) y la política elegida; (3) docs/14-coop-diseno.md con cada dirección, gancho y rango de memoria, y `coop_diseno.py verificar` en 0 con su saboteador en rojo. Orden que queda: B3 (el mod sin PINE) -> B2b fino -> B4–B6 en frío -> docs/14 + coop_diseno.py.
   B3, qué hay que contestar primero: ¿J2 se construye en la carga desde un molde que un pnach pueda escribir AL ARRANCAR? Hoy `jugador2.py carga-poner` copia a J EN VIVO como molde (clon_jugador.poner) y pone molde+0x8A4 = 0x1C. Sonda barata: carga-poner con el molde en CERO salvo lo mínimo, y ver si J2 igual aparece (predicción escrita antes). Después, adentro de los stubs y todo como pnach (herramientas/pnach.py; place=1 continuo para el código en .bss): control2, `atar`, la vista de J2, la COPIA DEL TÍTERE (matriz J2+0x70..+0xAF -> aliado 1 = actores+0x90+1*0x3C0, cada cuadro) y EL CABECEO DE J2 (una sola matriz para la vista y el disparo: la vista de la pantalla dividida tiene que salir de la matriz +0xD0 de J2, o el cabeceo se niega al construirla; el eje vertical del mando 2 queda invertido respecto de J).
   B2b fino (diseño, no factibilidad): esconder los brazos de J2 en la vista de J y el títere en la de J2; que el títere camine cuando J2 camina; niveles SIN aliados (dar de alta un soldado con bando 0).

4. Opus, esfuerzo high, SIN subagentes ni fan-out: B3 es diseño de código MIPS y lectura del cargador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.

YA HECHO, NO REHACER:
- J2 construido por el juego en la carga (79), camina con el mando 2 con `atar` = FUN_0025C210(*(0x0040F4CC), J2) (82). SPAWN en caliente con un byte (83).
- B1 (84): la escena es FUN_001297E0(juego), llamada por los jal de 0x001056DC / 0x0010656C / 0x00106D8C (palabra original 0x0C04A5F8) ANTES del HUD. Cámara de escena = la 1 del gestor de render (R = *(0x0040F4C0) = 0x004BD180; R+0xD400; RwCamera en +0x58 = 0x01F265D0; sub-raster en RwCamera+0x60 = 0x01F26910: ancho +0xC, nOffsetX +0x1C). Vista = gestor de cámara (*(0x0040F4BC) = 0x0058E780) +0x700: +0x00 FOV 70, +0x10 cuaternión, +0x20 ojo. Re-sincronizar: FUN_001AE998(R,1) + FUN_001B0948(R+0xD400). Proporción: R+0xD400+0x70 = 1,333 y +0x74 = 1,778 (16:9); para mitades de 320, ×0,5.
- pantalla_dividida.py: poner (en pausa) / vista2 <s> --dejar --fuente mira|igual-J / ritmo <s> / cuat / apagar / quitar. Stub 0x0046FA00..0x0046FB14, datos 0x0046FC00..0x0046FC94 (+0x40 cuaternión J2, +0x50 ojo J2, +0x80 división on/off, +0x84 raster, +0x88 contador, +0x8C mitad, +0x90 entero).
- (85) Personaje: +0x328 = entrada de la tabla de tipos (actores+0x7A10+0x40*tipo), +0x3A4 = BANDO (0 jugadores/aliados, 1 enemigos), +0x2F8 vida. City Streets: aliados = actores 0 y 1 del pool (tipos 0x1E y 0x1D, Tom y Matt), bando 0, vida FLT_MAX; enemigos tipo 0x24, bando 1. J y J2 bando 0.
- (85) Títere: herramientas/titere.py <i> <s> <prefijo> [--control] [--giro=<grados>] [--sin-caminar] — copia la matriz de J2 al aliado i por PINE mientras J2 camina con el falso 2 (0x00472100 +0x8C = adelante). Confirmado: lo sigue 10 m a ≤ 0,21 m.
- (85) Disparo: el rayo del jugador = vtable +0xA4 (FUN_0013B4C0) con el acople 5 de su ranura (FUN_001A68B0(J+0x330,5)) y su matriz de vista +0xD0/+0xE0/+0xF0/+0x100; máscara (FUN_00159198) 0x57 si el tirador es jugador (+0xC4 = 2), 0x1F si no; el filtro FUN_0015ADA8 pide bit 4 para NPC y bit 8 para jugador -> entre jugadores no hay daño. La matriz de vista de J2 tiene el cabeceo AL REVÉS de su mira: herramientas/tirador.py J2 <blanco> <s> --pitch-invertido mata (con --titere=1 también).

REPRODUCIR EL ESTADO: python herramientas/pine.py cargarestado --slot 13 -> depurador.py continuar -> esperar ~20 s -> selector_depuracion.py vivo. Slot 13 = J2 vivo, mando 2 (falso 2) y controlador, J2 en la ranura 1 (dueño J2). Desde cero (slot 3): jugador2.py carga-poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> jugador2.py mirar 30 (fase 2) -> jugador2.py control2 -> jugador2.py estado 2 -> jugador2.py atar. Pantalla dividida encima: depurador.py pausar -> pantalla_dividida.py poner -> depurador.py continuar -> pantalla_dividida.py vista2 5 --dejar (y para verla sin deformar: R+0xD400+0x70/+0x74 = 0,6667 / 0,8889). Un enemigo de prueba en la sala: vida FLT_MAX a J y J2 (+0x2F8 = 0x7F7FFFFF), mover el punto del spawner L12[17] al medio J–J2 y sondas_spawn.py mirar 17 3 (nace 0x00592B90); ESPERAR ≥ 12 s antes de dispararle.

7. Trampas medidas:
   - jugador2.py carga-poner MATÓ PCSX2 una vez de dos («[EE] Impossible block clearing failure» en Documents\PCSX2\logs\emulog.txt): se relanza con lanzadores\ABRIR-BLACK-ORIGINAL.bat, se recarga el slot y se REINTENTA.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo; ojo: gira la vista de J — puede dejarlo mirando una pared).
   - (85) El enemigo recién nacido por spawner NO recibe daño los primeros segundos: esperar ≥ 12 s. Un enemigo nacido cerca MATA a J en segundos («Mission failed»; reponer la vida después no lo revive): J con vida FLT_MAX en esas pruebas.
   - (85) pine.py cargarestado desde la carpeta equivocada no carga nada: correr desde herramientas/ y NO redirigir su salida a $null.
   - (85) Dos conexiones PINE a la vez se cortan por tiempo: una sola conexión por proceso, todo intercalado en el mismo lazo.
   - (85) A J2 el botón recargar del falso 2 no le recarga (ni con reserva J2+0x280 = 30); escribir el cargador a mano (sub+0x18) no probó ser seguro: J2 tiene 15 balas nativas por carga del slot 13.
   - Toda dirección que sale de una cuenta se recalcula con la base VIVA (personajes = *(0x0040F50C); juego = *(0x0040F4D0) = 0x005A8A80; cuerpos = *(0x0040F4CC) = 0x00585C00; actores = *(0x0040F514) = 0x0058FE00; disparadores = *(0x0040F4F4); render = *(0x0040F4C0); cámara = *(0x0040F4BC)).
   - Capturas: capturar-pantalla.ps1 ya es DPI-aware (1920x1080). Si una captura sale 1536x864, está RECORTADA.
   - La ventana de vista de la RwCamera (+0x68) se recalcula cada cuadro: lo que manda es R+0xD400+0x70/+0x74.
   - En la pasada 2 se cambia el CONTENIDO de gestor+0x710/+0x720, no el puntero de la cámara.
   - Código nuevo en un stub: con el emulador EN PAUSA (depurador.py pausar / continuar).
   - depurador.py --accion log NO cuenta; ritmo_vigilante.py usa break. El breakpoint de ejecución está bloqueado a propósito.
   - Nada de heredocs (se cuelgan esperando stdin): script al scratchpad con Write y después `python <ruta>`. Mensajes de commit largos: git commit -F <archivo>.
   - Set-Content -Encoding utf8 en PowerShell 5.1 mete BOM: escribir con [IO.File]::WriteAllText y UTF8Encoding($false), y respetar CRLF.
   - json.dump reformatea kb/subsistemas.json: usar herramientas/kb_formato.py (volcar). Después de subir una K: programa.py catalogo y verificar ANTES del commit.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, contadores 0x0046D780..0x0046D7AC, stub por cuadro 0x0046D800, envoltorio 0x0046DA00..0x0046DB44, armas de J2 0x0046DBC0, copia de personajes 0x0046DC00..0x0046F910 (sin usar), pantalla dividida 0x0046FA00..0x0046FC94, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
