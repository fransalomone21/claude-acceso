# Mensaje de retome para una sesión LOCAL (notebook)

Copiar y pegar tal cual al abrir Claude Code en la notebook, en `claude-acceso`:

```
Retomo BLACK en LOCAL (notebook), después del lote de sondas del 2026-09-27 (bitácora (76)). Proyecto: proyectos/ingenieria/black.
0. git pull en claude-acceso y en C:\Users\frans\black-datos. Verificá que main tenga el último commit de BLACK que tocó sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md). Si no está, pará.
1. Leé SOLO: el bloque «2026-09-27, NOTEBOOK» de sesiones/HANDOFF.md, ESTADO_ACTUAL.md (sección EL PROGRAMA), PDP.md §4 «Proyecto COOP» y la entrada (76) de docs/03-bitacora.md.
2. Controles de apertura: .\proyectos\ingenieria\black\abrir-sesion.ps1 -Rapido, python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py. BLACK_DATOS ya no hace falta en la notebook: las herramientas de la nube resuelven black-datos por kb/ubicaciones.json (clave black_datos).
3. Fase: COOP-A. La cierra: cada habilitador crítico en K5 y un PROTOTIPO POR PINE donde el mando 2 mueve a un SEGUNDO jugador que está en el nivel. Ya en K5: entrada y camara. En orden:
   a. BOTONES del mando falso (sondas_coop.py ya mueve y hace mirar sin manos, pero no aprieta). En frío primero: FUN_00124708 (update del control virtual) y de dónde saca los bits (hipótesis: el búfer crudo del puerto que dice mando+0xEC, activo en bajo).
   b. PROTOTIPO: un segundo bloque de jugador de 0x8C0 fuera de jugadores[] (candidato de memoria: el tramo de .bss en cero 0x0046CB6D..0x00477724, libre PROBABLE), con sus tres copias de control (J+0x588, J+0x6D0, J+0x7C8) en 0x00585A0C y su propio objeto de mira. Primero en frío: qué más de la init FUN_0013ba40 y del update por cuadro hace falta para que un bloque se mueva.
   c. Con botones: 5a (vigilante en 0x004BC208 recorriendo los menús), 0x0040D9A3 = 1 + matar con el rifle a más de 6 m, y los niveles 96–99 desde el menú.
   Cada PREDICCIÓN va a la bitácora ANTES de correrla; cada resultado con su control.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo. «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo. Pará sólo si (a) el contexto llega al 50 %, (b) necesitás una decisión de valor mía (por ejemplo, si la cámara desactivada de 0x0040D9A3 funciona y hay que decidir si entra al mod), o (c) algo necesita que yo esté frente a la máquina.
7. Trampas medidas: depurador.py --accion log NO cuenta (usar herramientas/ritmo_vigilante.py, que pone el break EN PAUSA; ponerlo en caliente cerró PCSX2). Antes de medir, depurador.py estado: el emulador puede quedar pausado sin pedirlo. Los dos mandos físicos DERIVAN (+27°/s de yaw): para medir la vista, usar el mando falso quieto. Slot 3 = LEVEL_00 (vida 990.590, enemigos disparando); slot 11 = nivel 2.
8. Checkpoint después de CADA sonda: bitácora + kb/subsistemas.json + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + este mensaje.
```

**Por qué este orden:** los botones son lo único que falta para que el lote
entero corra sin Fran frente a la máquina, y el prototipo es el criterio de
salida de la Fase A. Lo demás (5a, la cámara desactivada, los niveles de
prueba) cuelga de los botones.
