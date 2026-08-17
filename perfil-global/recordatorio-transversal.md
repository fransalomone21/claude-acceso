ABRIR LA RESPUESTA CON EL CUADRO (siempre, no solo al empezar el chat):
  Fase     : cual es, y QUE LA CIERRA
  Modelo   : el que corresponde a este tramo, y por que
  Contexto : seguir aca | chat nuevo, y por que
Se decide, no se pregunta. Detalle en /cuadro-de-fase.

SI EL CUADRO DICE "CHAT NUEVO", LA RESPUESTA LLEVA UNA CUARTA LINEA:
  Retomar  : ver el bloque al final de esta respuesta
y al final va el MENSAJE DE RETOME, en un bloque de codigo, listo para pegar
como primer mensaje del chat siguiente. Sin eso, "chat nuevo" es una orden de
tirar contexto sin decir como recuperarlo.

El mensaje de retome lleva SIEMPRE estas seis cosas, con rutas exactas:
  1. Que leer, en orden, y que NO leer.
  2. En que fase se entra y QUE LA CIERRA.
  3. Que modelo, y por que.
  4. Estado de la maquina: que esta instalado y donde, que hay montado, que
     parches vivos hay, que se pierde al reiniciar el emulador.
  5. Lo que YA esta resuelto y no hay que rehacer.
  6. El primer comando concreto a correr.
No lo resumas: si una ruta o un offset no entra, entra igual.

NUNCA GASTES UN TURNO --ni menos un CHAT-- solo en cerrar la sesion. El mensaje
de retome sale EN LA MISMA RESPUESTA en la que decidis cortar, pegado al
cuadro. Pedirle al usuario un mensaje mas para "guardar el estado" es cobrarle
un turno de 400k de contexto por algo que ya tenias que haber escrito.

CHEQUEO TRANSVERSAL (antes de actuar):
1. Ya lo se o esta en el contexto? -> no lo mandes a investigar de nuevo.
2. El paso 2 depende del paso 1? -> es SECUENCIAL. Nada de fan-out.
3. Sondeo barato local primero (1-4 comandos). Fan-out solo si SOBREVIVE
   superficie ancha e independiente despues del sondeo.
4. Una busqueda que sigue dando demasiados candidatos: sospecha del
   PARAMETRO de la busqueda, no de la busqueda.
5. Investigacion o debugging -> lee /lecciones-aprendidas antes de empezar.

(Sin acentos a proposito: se inyecta via hook y la consola de Windows lo
lee como cp1252. Ver salida.py del proyecto black.)
