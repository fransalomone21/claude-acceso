# Mensaje de retome — BLACK, notebook (después de la bitácora (81))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (81) del 2026-09-27: las dos sondas de la ranura de personaje REFUTADAS y la cadena del paso medida eslabón por eslabón. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md): tiene que ser de la bitácora (81) o posterior. Si no está, pará.

1. Leé SOLO: el bloque «(81)» de sesiones/HANDOFF.md (es el primero) y ESTADO_ACTUAL.md (sección EL PROGRAMA). NO leas la bitácora ni el bloque «(80, nube)»: (81) corrigió dos cosas de (80) y el HANDOFF ya trae la versión corregida. Si algo no da lo que dice acá, recién ahí la entrada (81) de docs/03-bitacora.md.

2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py (da 179 comprobaciones; el HANDOFF de (80) decía 180 y el número que manda es el que imprime el script).

3. Fase: COOP-A. La cierra: cada habilitador crítico en K5 y un PROTOTIPO POR PINE donde el mando 2 MUEVE a un SEGUNDO jugador que está en el nivel. Ya en K5: entrada, camara, sesion, arranque, codigo-nuevo y juego. `personajes` K4 y `fisica` K4.

   YA HECHO, NO REHACER:
   - J2 lo construye el juego durante la carga, con arma y cuerpo físico propios, corre a 60 Hz sin congelar a J, y el mando 2 le gira la mira (79).
   - La ranura de personaje NO era lo que faltaba (81): molde+0x2C3 = 1 no sobrevive a la construcción; y con J2+0x330 = ranura 1 y su dueño en J2, FUN_001334E0 corre para J2 y usa la ranura nueva, y J2 igual no camina.
   - No es una pared: los CUATRO empujes dan delta 0,000000 y rapidez 0,0000, con el yaw respondiendo en la misma pasada.
   - FUN_001A6BE0 propaga ACOPLES (matriz del dueño × matriz local de 7 sub-objetos), NO camina. La posición del jugador es +0xA0; +0x100 es el OJO (+0xA0 + 1,65 − 0,2).

   DÓNDE SE CORTA, MEDIDO: el pedido llega (J2+0x5C4 = 1,0), la rapidez pedida se calcula (+0x5D8 = 4,5, versor en +0x540/+0x548) y el CUERPO FÍSICO de J2 (0x00699200) tiene 0 campos que responden y 0 de ruido, contra 8 y 1 del de J (0x006B8180). El integrador es FUN_00170320 (PC 0x00170600), un callback virtual que invoca FUN_002EA898 (ra 0x002EA92C) del motor de física: el motor recorre SU lista y el cuerpo de J2 no está en ella.

   LA PREGUNTA DE ESTA SESIÓN, Y ARRANCA EN FRÍO: cómo se da de alta un cuerpo en el motor de física.
   a. En frío (decompilado local, herramientas/leer_c.py y desensamblar.py): FUN_0016E660 entera (es la que en (79) sacó el cuerpo del pool con J2+0xC4 = 1), FUN_002EA898 y sus dos llamadores (0x002E1118, 0x002E1208) para saber de qué lista sale cada cuerpo, y quién la escribe. Pista medida, sin confirmar: los dos cuerpos difieren en +0x14 (0x0066EBE4 en J, 0x0066EBBC en J2) y en +0x18 (0 en J, 0x00699680 en J2, puntero dentro del propio pool) — hipótesis: +0x18 es el enlace de la lista libre y el cuerpo se entregó sin darse de alta.
   b. Recién con eso, en vivo: dar de alta el cuerpo de J2 y medir si CAMINA (J2+0xA0 cambia y el de J no).
   c. Si el alta necesita el pool del tipo 2 (jugador, cuenta compilada en 1), ése es el cuarto o quinto lugar compilado para un solo jugador y entra al informe como límite.

   REPRODUCIR EL ESTADO EN UN COMANDO: python herramientas/pine.py cargarestado --slot 12 -> depurador.py continuar si quedó en pausa -> esperar ~20 s. El slot 12 tiene J2 vivo, corriendo, con el mando 2 y con la ranura 1 propia. Control positivo antes de cada sonda: python herramientas/selector_depuracion.py vivo.
   Si hace falta rehacerlo desde cero (slot 3): jugador2.py carga-poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> jugador2.py mirar 30 (fase 2) -> jugador2.py control2 -> jugador2.py estado 2.

4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.
7. Trampas medidas:
   - jugador2.py carga-poner MATÓ PCSX2 una vez de dos, con tormenta de «[EE] Impossible block clearing failure» en Documents\PCSX2\logs\emulog.txt. Es intermitente: si muere, se relanza con lanzadores\ABRIR-BLACK-ORIGINAL.bat, se recarga el slot y se REINTENTA; no se busca la causa en el comando.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo).
   - Toda dirección que sale de una cuenta se recalcula con la base VIVA (sistema de personajes = *(0x0040F50C) = 0x004ED380; juego = *(0x0040F4D0) = 0x005A8A80) antes de escribir encima.
   - Para medir con el mando falso hay que SOSTENER el eje (escribir el f32 y dejarlo), no usar `empujar`, que lo suelta al terminar.
   - depurador.py --accion log NO cuenta; ritmo_vigilante.py usa break y --ra lee ra/a0/a1. El breakpoint de ejecución está bloqueado a propósito. El vigilante write dispara aunque el valor no cambie.
   - Nada de heredocs con comillas mezcladas: el guardia los bloquea. Script al scratchpad con Write y después `python <ruta>`.
   - json.dump reformatea kb/subsistemas.json: usar herramientas/kb_formato.py. Después de subir una K: programa.py catalogo y verificar ANTES del commit.
   - Slot 3 = LEVEL_00 limpio; slot 11 = nivel 2; SLOT 12 = J2 vivo con la ranura propia (lo dejó (81)). El mundo corre a 60 Hz.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, contadores 0x0046D780..0x0046D7AC, stub por cuadro 0x0046D800, envoltorio 0x0046DA00..0x0046DB44, guarda del sistema 0x0046D7B0, dirección de la copia 0x0046D7B4, copia del sistema de personajes 0x0046DC00..0x0046F910 (sin usar todavía), armas de J2 0x0046DBC0, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
