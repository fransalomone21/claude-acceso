# Mensaje de retome — BLACK, notebook (después de la bitácora (84))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (84) del 2026-09-27: COOP-B quedó ABIERTA con su criterio en el PDP y B1 HECHA: el juego dibuja dos vistas en el mismo cuadro (J a la izquierda, J2 a la derecha, con control), `render` K5. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md): tiene que ser el cierre de la bitácora (84) o posterior. Si no está, pará.

1. Leé SOLO: el bloque «(84)» de sesiones/HANDOFF.md (es el primero), PDP.md §4 «Proyecto COOP — Fase B» (criterio, cómo se certifica y la tabla B1–B6) y, si vas a B3, las líneas 1–256 de herramientas/jugador2.py (PROGRAMA, ENVOLTORIO_PROG, ATAR_PROG) y herramientas/pantalla_dividida.py. NO leas la bitácora salvo que algo no dé lo que dice acá. NO leas ESTADO_ACTUAL entero (la sección EL PROGRAMA alcanza si hace falta).

2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py (183 comprobaciones; manda el número que imprime).

3. Fase: COOP-B (diseño preliminar), ABIERTA. La cierran, las tres: (1) B1, B2 y B3 retirados por efecto con control (B1 YA); (2) IA, muerte de J2 y disparadores con su mecanismo leído (K4) y la política elegida; (3) docs/14-coop-diseno.md con cada dirección, gancho y rango de memoria, y `coop_diseno.py verificar` en 0 con su saboteador en rojo. Orden que queda: B3 (el mod sin PINE) -> B2b (si Fran ya eligió el cuerpo) -> B4–B6 en frío -> docs/14 + coop_diseno.py.
   B3, qué hay que contestar primero: ¿J2 se construye en la carga desde un molde que un pnach pueda escribir AL ARRANCAR? Hoy `jugador2.py carga-poner` copia a J EN VIVO como molde (clon_jugador.poner) y pone molde+0x8A4 = 0x1C. Sonda barata: carga-poner con el molde en CERO salvo lo mínimo, y ver si J2 igual aparece (predicción escrita antes). Después: control2, `atar` y la vista de J2 (cuaternión = yaw de su mira *(J2+0x32C)+8, ojo J2+0x100: q = (0, sin(y/2), 0, cos(y/2)), y en grados) dentro de los stubs, y todo como pnach (herramientas/pnach.py; place=1 continuo para el código en .bss).
   B2: DECISIÓN DE FRAN pendiente (qué soldado es el cuerpo de J2). Si no contestó, no se rankea: se hace B3.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: B3 es diseño de código MIPS y lectura del cargador. Nunca Fable.
5. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.

YA HECHO, NO REHACER:
- J2 construido por el juego en la carga (79), camina con el mando 2 con `atar` = FUN_0025C210(*(0x0040F4CC), J2) (82); ranura COMPARTIDA alcanza. SPAWN en caliente con un byte (83).
- B1 (84): la escena es FUN_001297E0(juego), llamada por los jal de 0x001056DC / 0x0010656C / 0x00106D8C (palabra original 0x0C04A5F8) ANTES del HUD. Cámara de escena = la 1 del gestor de render (R = *(0x0040F4C0) = 0x004BD180; R+0xD400; RwCamera en +0x58 = 0x01F265D0; sub-raster en RwCamera+0x60 = 0x01F26910: ancho +0xC, nOffsetX +0x1C). Vista = gestor de cámara (*(0x0040F4BC) = 0x0058E780) +0x700: +0x00 FOV 70, +0x10 cuaternión, +0x20 ojo. Re-sincronizar: FUN_001AE998(R,1) + FUN_001B0948(R+0xD400). Proporción: R+0xD400+0x70 = 1,333 y +0x74 = 1,778 (16:9); para mitades de 320, ×0,5. La pasada 160×112 es de SOMBRAS (FUN_001C9110).
- pantalla_dividida.py: poner (en pausa) / vista2 <s> --dejar --fuente mira|igual-J / ritmo <s> / cuat / apagar / quitar. Stub 0x0046FA00..0x0046FB14, datos 0x0046FC00..0x0046FC94 (+0x40 cuaternión J2, +0x50 ojo J2, +0x80 división on/off, +0x84 raster, +0x88 contador, +0x8C mitad, +0x90 entero).
- B2 en frío: tabla de tipos de personaje en actores+0x7A10 (0x40 B; FUN_00138C40). City Streets: tipo 0 = jugador (brazos), soldados 0x1D, 0x1E, 0x24, 0x25, 0x27. Diseño barato: títere (un actor de esos tipos, sin cerebro, que copia posición y yaw de J2).

REPRODUCIR EL ESTADO: python herramientas/pine.py cargarestado --slot 13 -> depurador.py continuar -> esperar ~20 s -> selector_depuracion.py vivo. Slot 13 = J2 vivo, mando 2 y controlador. Slot 12 = sin controlador. Desde cero (slot 3): jugador2.py carga-poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> jugador2.py mirar 30 (fase 2) -> jugador2.py control2 -> jugador2.py estado 2 -> jugador2.py atar. Pantalla dividida encima: depurador.py pausar -> pantalla_dividida.py poner -> depurador.py continuar -> pantalla_dividida.py vista2 5 --dejar (y para verla sin deformar: R+0xD400+0x70/+0x74 = 0,6667 / 0,8889).

7. Trampas medidas:
   - jugador2.py carga-poner MATÓ PCSX2 una vez de dos («[EE] Impossible block clearing failure» en Documents\PCSX2\logs\emulog.txt): se relanza con lanzadores\ABRIR-BLACK-ORIGINAL.bat, se recarga el slot y se REINTENTA.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo; ojo: gira la vista de J).
   - Toda dirección que sale de una cuenta se recalcula con la base VIVA (personajes = *(0x0040F50C); juego = *(0x0040F4D0) = 0x005A8A80; cuerpos = *(0x0040F4CC) = 0x00585C00; actores = *(0x0040F514) = 0x0058FE00; disparadores = *(0x0040F4F4); render = *(0x0040F4C0); cámara = *(0x0040F4BC)).
   - Capturas: capturar-pantalla.ps1 ya es DPI-aware (1920x1080). Si una captura sale 1536x864, está RECORTADA (escalado de Windows) y no es el juego.
   - La ventana de vista de la RwCamera (+0x68) se recalcula cada cuadro: lo que manda es R+0xD400+0x70/+0x74.
   - En la pasada 2 se cambia el CONTENIDO de gestor+0x710/+0x720, no el puntero de la cámara: la pasada de sombras lo repone a mitad del cuadro.
   - El contador de apariciones *(0x0040F4D4)+0xFA4 SUBE SOLO: el efecto de una aparición se lee en el spawner (+0x24).
   - Código nuevo en un stub: con el emulador EN PAUSA (depurador.py pausar / continuar).
   - depurador.py --accion log NO cuenta; ritmo_vigilante.py usa break. El breakpoint de ejecución está bloqueado a propósito.
   - Nada de heredocs con comillas mezcladas: script al scratchpad con Write y después `python <ruta>`. Mensajes de commit largos: git commit -F <archivo>.
   - Set-Content -Encoding utf8 en PowerShell 5.1 mete BOM: escribir con [IO.File]::WriteAllText y UTF8Encoding($false), y respetar CRLF.
   - json.dump reformatea kb/subsistemas.json: usar herramientas/kb_formato.py (volcar). Después de subir una K: programa.py catalogo y verificar ANTES del commit.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, contadores 0x0046D780..0x0046D7AC, stub por cuadro 0x0046D800, envoltorio 0x0046DA00..0x0046DB44, armas de J2 0x0046DBC0, copia de personajes 0x0046DC00..0x0046F910 (sin usar), pantalla dividida 0x0046FA00..0x0046FC94, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
