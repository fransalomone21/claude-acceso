# Mensaje de retome para una sesión LOCAL (notebook)

Copiar y pegar tal cual al abrir Claude Code en la notebook, en `claude-acceso`:

```
Retomo BLACK en LOCAL (notebook), después de los botones y la cámara desactivada (bitácora (77), 2026-09-27). Proyecto: proyectos/ingenieria/black.
0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md). Si no está, pará.
1. Leé SOLO: el bloque «2026-09-27, NOTEBOOK — BOTONES» de sesiones/HANDOFF.md, ESTADO_ACTUAL.md (sección EL PROGRAMA), PDP.md §4 «Proyecto COOP» y la entrada (77) de docs/03-bitacora.md.
2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py.
3. Fase: COOP-A. La cierra: cada habilitador crítico en K5 y un PROTOTIPO POR PINE donde el mando 2 mueve a un SEGUNDO jugador que está en el nivel. Ya en K5: entrada y camara. Ya hecho, no rehacer: botones del mando falso (sondas_coop.py boton: 12 dispara, 2 recarga, 6/7 arma, 8 pausa), matar sin manos (matar_sin_manos.py), y la cámara desactivada de 0x0040D9A3 confirmada (anim_muerte.py --forzar3). En orden:
   a. Si Fran ya contestó si la cámara de cine entra al mod, anotarlo en PDP §6 y seguir; si no, no bloquea.
   b. 5a por menús: vigilante de escritura en 0x004BC208 y recorrer los menús con el mando falso (índices de menú 2, 4, 5, 6, 7 con flanco; 8 abre la pausa). Predicción a la bitácora antes.
   c. PROTOTIPO: un segundo bloque de jugador de 0x8C0 fuera de jugadores[] (candidato: .bss en cero 0x0046CB6D..0x00477724, libre PROBABLE; ojo que el mando falso vive en 0x00472000), con sus tres copias de control (J+0x588, J+0x6D0, J+0x7C8) en 0x00585A0C y su propio objeto de mira (J+0x4F0). Primero en frío: qué más de la init FUN_0013ba40 y del update por cuadro hace falta para que un bloque se mueva.
   d. Niveles 96–99 desde el menú.
   Cada PREDICCIÓN va a la bitácora ANTES de correrla; cada resultado con su control.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía, o (c) algo necesita que yo esté frente a la máquina.
7. Trampas medidas: ANTES DE CADA SONDA un control positivo de «vivo» (un eje del falso mueve el yaw): el juego puede estar en el menú de pausa y todo da negativo. depurador.py --accion log NO cuenta (ritmo_vigilante.py o un vigilante break puesto en pausa); el breakpoint de ejecución está bloqueado a propósito. 0x0040D9A3 se lee una vez por cuadro (0x0011C948). Después de continuar desde un vigilante en la secuencia forzada, PINE no responde unos segundos: mirar con rafaga-capturas.ps1. Los mandos físicos DERIVAN (+27°/s de yaw). Slot 3 = LEVEL_00 (vida 990.590, enemigos disparando); slot 11 = nivel 2.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```

**Por qué este orden:** con los botones, el mando falso ya hace todo lo que
hacía falta para correr sondas sin Fran; 5a es la más barata de las que
quedaban y los menús leen el mismo control. El prototipo es el criterio de
salida de la Fase A.
