NIVEL 0 - FUNDAMENTOS. Se lee antes que el resto, porque decide que clase de
intervencion vale la pena antes de elegir como ejecutarla.

Destilado de los libros que sostienen el metodo. La ficha larga de cada uno
esta en perfil-global/pilares/<libro>.md; ahi esta de donde sale cada linea.

PENSAR EN SISTEMAS ANTES DE INTERVENIR  (Meadows, Leverage Points, 1999)

  - Ubica la intervencion en la escala ANTES de evaluarla. De menor a mayor
    apalancamiento: parametros (que modelo, que effort, cuantos tokens,
    cuantos agentes) < buffers < estructura < retardos < lazos negativos <
    lazos positivos < FLUJOS DE INFORMACION < REGLAS < AUTO-ORGANIZACION <
    METAS < PARADIGMA.
    El 99% de la atencion se va a los parametros, que son el escalon mas bajo
    que existe. Si una propuesta cae ahi, su techo ya esta puesto por bien
    argumentada que este.

  - Una regla que se incumple no se escribe mas fuerte: se le agrega el flujo
    de informacion que falta. Casas identicas, precio identico: las que tenian
    el medidor electrico a la vista en la entrada, en vez de en el sotano,
    gastaron 30% menos. Subir el volumen de una regla es un parametro
    disfrazado de solucion.

  - Un freno que nunca salta no es inutil: es un lazo de emergencia. Antes de
    sacar un aviso, un test lento o una validacion molesta, pregunta contra
    QUE IMPACTO fue disenado, no cuantas veces salto. Sacarlos no se nota en
    el corto plazo y angosta el rango de condiciones que el sistema sobrevive.

  - Los leverage points son contraintuitivos: la gente los encuentra por
    instinto y empuja para el lado equivocado. Cuando identifiques uno,
    pregunta explicitamente en que direccion hay que empujar.

LA ESTRUCTURA PRODUCE LA CONDUCTA  (Meadows, Thinking in Systems, 2008)

  - Antes de arreglar un fallo, mira CUANTAS VECES PASO. Evento ->
    comportamiento -> estructura. Un fallo aislado se arregla; uno con
    historia se redisena, y desde adentro del turno se ven identicos. El
    evento gatillo siempre esta disponible y siempre convence: si analizas a
    nivel de evento, le vas a echar la culpa a la primavera calurosa.

  - Cambiar el ACTOR no cambia nada si la informacion que recibe es la misma.
    Subir el modelo, meter un subagente mejor o mas effort es poner otro actor
    en la misma posicion de racionalidad acotada. Si Claude abre la sesion sin
    saber que se decidio ayer, un Claude mejor abre la sesion sin saber que se
    decidio ayer.

  - En un sistema con RETARDO, reaccionar mas rapido y mas fuerte AMPLIFICA la
    oscilacion. La concesionaria que acorta su tiempo de reaccion empeora el
    problema; lo arregla alargandolo. Ante un fallo, aplica una fraccion de la
    correccion, no la correccion entera: lo aprendido hoy recien actua manana.

  - La meta REAL se deduce del comportamiento, no de lo declarado. Se mide
    donde se fue el esfuerzo, no se lee que dice el documento. Y un sistema
    medido por esfuerzo produce esfuerzo: el criterio de salida de una fase
    tiene que ser un RESULTADO verificable, no una cantidad de trabajo hecho.

  - Solo importa el FACTOR LIMITANTE, y se mueve cada vez que mejoras algo.
    Echar mas fosforo no sirve si lo que falta es potasio. La respuesta a
    "cual es el cuello de botella" VENCE: hay que volver a preguntarla despues
    de cada mejora. Y un stock sube tapando la fuga, no solo abriendo la
    canilla: pregunta siempre las dos.

  - Las trampas conocidas tienen salida conocida. Catalogo de las ocho en
    perfil-global/pilares/thinking-in-systems.md, cap. 5. Las que mas nos
    pegan: TRASLADAR LA CARGA AL INTERVENTOR (el sintoma no es que la
    respuesta sea mala, es que haga falta mas intervencion para el mismo
    resultado) y ELUSION DE LA REGLA (cumplimiento aparente: eso no es
    indisciplina, es retroalimentacion sobre una regla impracticable, y
    endurecerla es el camino mas adentro de la trampa).

HACER ES UN OFICIO, Y TIENE REGLAS  (Hunt & Thomas, Pragmatic Programmer, 1999)

  - El exito que no sabes explicar es una coincidencia que todavia no se
    descubrio. Fred escribio codigo, lo probo, "andaba"; semanas despues dejo
    de andar y estuvo horas sin entender por que -- porque nunca supo por que
    andaba. Cuando algo empieza a funcionar despues de tocar varias cosas,
    sacar las que no entendes es MAS barato ahora que despues: la que quedo
    puede no estar haciendo nada, puede apoyarse en un borde accidental que
    cambia en la proxima version, y suma riesgo propio. Todas las reglas de
    evidencia que ya tenemos miran el fracaso. Esta mira el EXITO, que es el
    caso que no duele y por eso nunca se revisa.

  - Un verificador que nunca fallo esta sin verificar. Un test es una alarma, y
    a una alarma se la prueba tratando de burlarla: provoca el fallo A
    PROPOSITO y mira que se ponga en rojo. Si nunca lo hiciste, no sabes si
    verifica o si siempre dice que si. Vale para los tests, para los hooks y
    para todo script que diga "OK".

  - La sorpresa mide la confianza, y ahi esta la suposicion equivocada. El
    tamano del susto es proporcional a la fe que le tenias al codigo que
    corrio; por eso el lugar que te sorprendio es exactamente el que no
    miraste. No lo saltees porque "ese anda": probalo EN ESE contexto, con
    ESOS datos, en ESE borde. Y antes de culpar al sistema, al emulador o a la
    biblioteca: "select no esta roto" -- huellas de cascos son caballos, no
    cebras. Un ingeniero perdio SEMANAS construyendo workarounds para un bug
    que no existia. Que los workarounds no funcionen es la senal de que el
    modelo esta mal, no de que falta otro workaround.

  - Trazador o prototipo: decidilo ANTES, no despues. Prototipo = explora UN
    aspecto, puede ignorar precision, completitud y robustez, y SE TIRA.
    Trazador = atraviesa el sistema entero con lo mas delgado posible, con
    todo el chequeo de errores puesto, y SE CONSERVA. El test que los separa:
    si no podes ignorar los detalles, no es un prototipo. Codigo exploratorio
    que se queda sin la estructura del trazador es el peor de los dos mundos.
    Y si algo se reporta "95% listo" semana tras semana, es que nunca hubo un
    camino de punta a punta.

  - "Esto cuesta mucho mas de lo que deberia" es un disparador, no una queja.
    Cuando aparezca, para y corre la lista: hay un camino mas facil? estoy
    resolviendo el problema o un asunto tecnico periferico? POR QUE esto es un
    problema? que lo hace dificil? tiene que hacerse ASI? tiene que hacerse?
    No se trata de pensar fuera de la caja sino de ENCONTRAR la caja: enumera
    todas las salidas, incluidas las que parecen estupidas, y para cada una
    pedi la prueba de por que esta descartada. Casi siempre, reinterpretar el
    requisito hace desaparecer un grupo entero de problemas.

  - El costo de deshacer es un eje aparte del apalancamiento y del retardo.
    Alto apalancamiento e irreversible es otro riesgo que alto apalancamiento
    y reversible, y hoy los evaluamos igual. Cada decision critica angosta el
    blanco; con muchas tomadas, cualquier viento te hace errar. Escribilas en
    la arena, no en piedra, y lo que se instala solo tiene que desinstalarse
    solo. Corolario sobre el retardo: un metodo nuevo EMPEORA las cosas antes
    de mejorarlas, asi que evaluarlo durante su propia caida de adopcion mata
    justo lo que iba a andar.

  - Lo generado se juzga por DONDE queda, no por si lo entendes todo. Nadie
    entiende el compilador que usa, y esta bien: eso vive detras de una
    interfaz definida y estable. Lo generado que queda INTERCALADO linea a
    linea con lo tuyo dejo de ser del generador y paso a ser tuyo, y eso hay
    que entenderlo entero -- porque el dia que cambie el contexto vas a estar
    solo con eso. Mismo criterio para una biblioteca, para un asistente y para
    el codigo que escribe un modelo.
