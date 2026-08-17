APERTURA Y CIERRE DE SESION DE PROYECTO (obligatorio si la sesion toca un
proyecto). Esta capa es el PROTOCOLO: como se abre, como se corta y como se
cierra una sesion. Las reglas viven en CLAUDE.md y los fundamentos en
pilares.md; aca no se repiten.

ABRIR: leer el estado del proyecto y empezar la respuesta con estas tres
lineas. No al final, no si sobra lugar: primero.

  Fase     : en que fase esta, y QUE LA CIERRA (criterio de salida concreto)
  Modelo   : el que corresponde a este tramo, y por que
  Contexto : seguir en este chat | conviene uno nuevo, y por que

Como se completa cada linea:
- Fase: el criterio de salida es un RESULTADO verificable, no una cantidad de
  trabajo hecho. "Reescrito y con verify-install en verde", no "revisar los
  archivos". Si la fase anterior no quedo cerrada, decirlo ANTES de abrir otra.
- Modelo: se enruta por tipo de trabajo y se declara; no se pregunta. Se
  vuelve a declarar A MITAD de sesion cuando cambia el tipo de trabajo: leer
  desensamblado o decidir arquitectura -> Opus; ejecutar un runbook ya
  decidido -> Sonnet; mecanico (correr y reportar) -> Haiku.
- Contexto: chat nuevo cuando cambia la fase, cuando el contexto paso ~50%, o
  cuando lo que sigue no necesita nada de lo hablado. Un resumen degrada
  primero los datos que no se pueden aproximar: direcciones, offsets,
  versiones, valores de registros.

CORTAR: si el cuadro dice "chat nuevo", va una cuarta linea

  Retomar  : ver el bloque al final de esta respuesta

y al final de ESA MISMA respuesta, el MENSAJE DE RETOME, en un bloque de
codigo listo para pegar como primer mensaje del chat siguiente. Lleva SIEMPRE
estas seis cosas, con rutas exactas:

  1. Que leer, en orden, y que NO leer.
  2. En que fase se entra y QUE LA CIERRA.
  3. Que modelo, y por que.
  4. Estado de la maquina: que esta instalado y donde, que hay montado, que
     parches vivos hay, que se pierde al reiniciar el emulador.
  5. Lo que YA esta resuelto y no hay que rehacer.
  6. El primer comando concreto a correr.

No se resume: si una ruta o un offset no entra, entra igual. Y nunca se gasta
un turno --ni menos un chat-- solo en cerrar la sesion: el mensaje sale pegado
al cuadro, en el mismo turno en que se decide cortar.

CERRAR: el checkpoint de cuatro pasos es la regla 5 de CLAUDE.md, y el chequeo
de autoperfeccionamiento corre ANTES del commit, no despues.

Triangulo de hierro: costo, planning y performance por encima de velocidad de
respuesta. Estas tres lineas cuestan poco y evitan la sesion entera gastada en
la fase equivocada.

Casos borde del cuadro: /cuadro-de-fase.
