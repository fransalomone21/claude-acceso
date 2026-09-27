# Mensaje de retome — BLACK, notebook (después de la bitácora (82))

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook), después de la bitácora (82) del 2026-09-27: J2 CAMINA con el mando 2 (le faltaba el controlador de colisión) y el prototipo del criterio de COOP-A está hecho. Proyecto: proyectos/ingenieria/black.

0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md): tiene que ser el cierre de la bitácora (82) o posterior. Si no está, pará.

1. Leé SOLO: el bloque «(82)» de sesiones/HANDOFF.md (es el primero) y ESTADO_ACTUAL.md (sección EL PROGRAMA). NO leas la bitácora ni los bloques (81)/(80): (82) corrigió lo que (81) decía del cuerpo físico y el HANDOFF ya trae la versión corregida. Si algo no da lo que dice acá, recién ahí la entrada (82) de docs/03-bitacora.md.

2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py (da 183 comprobaciones; el número que manda es el que imprime el script).

3. Fase: COOP-A. La cierra: cada habilitador crítico en K5 y un PROTOTIPO POR PINE donde el mando 2 MUEVE a un SEGUNDO jugador que está en el nivel. EL PROTOTIPO ESTÁ HECHO (82). Ya en K5: entrada, camara, sesion, arranque, codigo-nuevo, juego y ragdoll (= 0x0040F4CC, los cuerpos de personaje). `personajes` K4, `fisica` K4, render K4 (su objetivo en la tabla). LO ÚNICO QUE FALTA contra la tabla del PDP §4: `spawn` (fila 7, K3 -> K5).

   YA HECHO, NO REHACER:
   - J2 lo construye el juego durante la carga, con arma y cuerpo propios, a 60 Hz, sin congelar a J; el mando 2 le gira la mira (79).
   - J2 CAMINA (82): el mover FUN_00132D98 le entrega el desplazamiento al controlador de J+0xB4 (FUN_0025D840); a los `cuenta` = 1 jugadores se lo ata FUN_0012BE80 con FUN_0025C210(*(0x0040F4CC), actor); a J2 nadie. `jugador2.py atar` lo llama una vez -> J2 camina 8,14 m en 2 s a 4,5 m/s, en las 4 direcciones, choca con las paredes y EMPUJA a J. Pool de 20 controladores (mgr+0x2320, banderas +0x2960), no compilado para uno.
   - Con la ranura COMPARTIDA de (79) camina igual: la ranura propia de (81) y la copia de tres bloques de (80) NO hacen falta.
   - El cuerpo de J+0x34C es un SEGUIDOR (FUN_00170320 copia jugador -> cuerpo); el de J2 está en la lista del mundo 0x0066E900 y lo sigue. No hay nada que dar de alta ahí.
   - En pantalla, desde J, J2 se ve como DOS BRAZOS de primera persona flotando, sin cuerpo (4 capturas, con control). Es tema de la Fase B, no de ésta.

   LA PREGUNTA DE ESTA SESIÓN, Y ARRANCA EN FRÍO: ¿hay una aparición fuera de la carga que podamos disparar? (sonda P6 de `spawn`, fila 7).
   a. En frío (herramientas/leer_c.py y desensamblar.py): FUN_00138C80(mgr, spawner, datos) —el spawner de enemigos: saca un actor de las listas libres mgr+0x7990/+0x79A0 (FUN_00139980/FUN_00139838), lo resetea con FUN_001327F0 y le da cuerpo (FUN_0016E660), FUN_0013D048, FUN_001354E0, controlador (FUN_0025C210) y enlace (FUN_0012A158)— y su llamador FUN_00178BC0: quién lo dispara, con qué `datos` (puVar3[0xF], [0x12]...) y si se puede llamar desde el stub por cuadro.
   b. Escribí la PREDICCIÓN en la bitácora ANTES de tocar RAM. Efecto que subiría `spawn` a K5: un actor nuevo aparece en el nivel en caliente (su bloque pasa de libre a vivo, está en la lista del mundo y se ve), con control antes/después.
   c. Si la aparición necesita datos del stage que sólo existen en la carga, eso es resultado: se anota como límite y se decide con Fran si `spawn` es crítico para el prototipo o pasa a la Fase B.

   REPRODUCIR EL ESTADO EN UN COMANDO: python herramientas/pine.py cargarestado --slot 13 -> depurador.py continuar si quedó en pausa -> esperar ~20 s. Slot 13 = J2 vivo, con el mando 2 y CON controlador (y con la ranura 1 de (81), que no molesta). Slot 12 = lo mismo SIN controlador (ahí `jugador2.py atar` lo ata en un comando). Control positivo antes de cada sonda: python herramientas/selector_depuracion.py vivo.
   Desde cero (slot 3): jugador2.py carga-poner -> selector_depuracion.py pedir-frontend --bandera 0 --segundos 7 -> elegir 0 0 -> aceptar -> jugador2.py mirar 30 (fase 2) -> jugador2.py control2 -> jugador2.py estado 2 -> jugador2.py atar.

4. Opus, esfuerzo high, SIN subagentes ni fan-out: es lectura de desensamblado y la primera hipótesis sobre el spawner, un solo hilo. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.
7. Trampas medidas:
   - jugador2.py carga-poner MATÓ PCSX2 una vez de dos, con tormenta de «[EE] Impossible block clearing failure» en Documents\PCSX2\logs\emulog.txt. Es intermitente: si muere, se relanza con lanzadores\ABRIR-BLACK-ORIGINAL.bat, se recarga el slot y se REINTENTA; no se busca la causa en el comando.
   - ANTES DE CADA SONDA, control positivo de «vivo» (selector_depuracion.py vivo).
   - Toda dirección que sale de una cuenta se recalcula con la base VIVA (sistema de personajes = *(0x0040F50C) = 0x004ED380; juego = *(0x0040F4D0) = 0x005A8A80; cuerpos de personaje = *(0x0040F4CC) = 0x00585C00; mundo físico = *(0x003C9ED4) = 0x0066E900) antes de escribir encima.
   - Para medir con el mando falso hay que SOSTENER el eje (escribir el f32 y dejarlo): adelante +0x8C, atrás +0x90, laterales +0x94/+0x98 del falso. No usar `empujar`, que lo suelta.
   - Un «no cambia» medido por diferencia de valores con el objeto QUIETO no prueba que el código no corra (82): se mide con vigilante de escritura o con el objeto en movimiento.
   - Código nuevo en el stub por cuadro: se escribe con el emulador EN PAUSA (depurador.py pausar / continuar), como hace `jugador2.py atar`.
   - depurador.py --accion log NO cuenta; ritmo_vigilante.py usa break y --ra lee ra/a0/a1. El breakpoint de ejecución está bloqueado a propósito. El vigilante write dispara aunque el valor no cambie.
   - Nada de heredocs con comillas mezcladas: el guardia los bloquea. Script al scratchpad con Write y después `python <ruta>`.
   - json.dump reformatea kb/subsistemas.json: usar herramientas/kb_formato.py (volcar). Después de subir una K: programa.py catalogo y verificar ANTES del commit.
   - Las capturas (herramientas/capturar-pantalla.ps1) sacan LA PANTALLA, no la ventana: si hay otra ventana adelante, sale esa.
   - Memoria usada: J2 0x0046CDF0..0x0046D6B0, contadores 0x0046D780..0x0046D7AC, stub por cuadro 0x0046D800 (su estado 1 es ahora ATAR), envoltorio 0x0046DA00..0x0046DB44, guarda del sistema 0x0046D7B0, dirección de la copia 0x0046D7B4, copia del sistema de personajes 0x0046DC00..0x0046F910 (sin usar), armas de J2 0x0046DBC0, falso 1 0x00472000, falso 2 0x00472100.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```
