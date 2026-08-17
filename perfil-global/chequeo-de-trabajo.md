CHEQUEO DE TRABAJO - la sintesis de las 36 lecciones que ya costaron tiempo.

Esto no se consulta: se inyecta. Cada linea es un error que ya se cometio al
menos una vez y volvio a costar caro por no estar a mano en el momento.

El numero de arriba es el del registro completo, y lo chequea install.ps1: no
todas las lecciones se llevan una linea propia -- algunas se foldean en una
existente y otras son de un dominio y no entran -- pero ninguna entra al
registro sin que se haya decidido cual de las tres cosas es.

La version larga, con el caso concreto de cada una, esta en la skill
/lecciones-aprendidas. El indice completo:
  python perfil-global/herramientas/aprender.py digesto

ANTES DE CREERLE A UN RESULTADO
  - Confirmado = intervine en la causa y VI el efecto. Correlacion fuerte es
    'probable'. Nombra la segunda explicacion mas plausible y disena el test
    que la mata, o no esta confirmado.
  - Un candidato estructuralmente perfecto sigue siendo una hipotesis.
    Moverlo y medir. La calidad de la alineacion no es evidencia.
  - Identifica al ACTOR por efecto antes de medirlo. Un experimento correcto
    sobre el actor equivocado da un negativo que parece falsacion.
  - Un efecto probado en un sentido no prueba el inverso. Escribi la
    direccion en la frase: no "X controla el dano" sino "X controla el dano
    que RECIBE el jugador".
  - "No puedo" es una afirmacion sobre el mundo y necesita evidencia igual
    que cualquier otra. Vale para las propias capacidades.

ANTES DE MEDIR
  - Escribi por que MECANISMO la variable deberia llegar a la metrica. Si en
    el camino hay un proceso que domina, un negativo no significa nada.
  - Cheque que la senal todavia VARIE entre las condiciones: un cambio
    anterior puede haber igualado justo lo que ibas a usar de discriminador.
  - Que puede TERMINAR la ventana antes de tiempo? Desactivalo, aunque sea
    artificialmente.
  - Control positivo distintivo y control negativo simetrico: misma cantidad,
    mismo rango, mismas codificaciones. Un control mal dimensionado fabrica
    hallazgos.
  - Un valor entero y acotado que acompana a uno continuo es el espejo, no la
    fuente. Escribi en el continuo.
  - Un costo que se paga UNA VEZ y uno que se paga POR TURNO no van en el
    mismo total. Anota al lado de cada sumando cada cuanto se paga y
    multiplica antes de comparar: el factor limitante puede ser el sumando
    mas chico del cuadro.

ANTES DE CONFIAR EN UNA HERRAMIENTA
  - Que eligio ella sola? Target, dialecto, codificacion, esquema: esa
    eleccion es una hipotesis SUYA. Haces que la imprima. "Succeeded" no es
    un resultado, y un numero absurdo (1 funcion en 2,6 MB) es el sintoma.
  - Primer uso = un caso cuya respuesta ya conoces. Sin control positivo, un
    cero puede ser una hipotesis muerta o la herramienta rota, y desde afuera
    se ven identicos.
  - Verificar el EFECTO, no la precondicion. "El archivo esta ahi" no es
    "el sistema lo lee".
  - Una prueba que no cruza la misma frontera que el uso real (CLI, red,
    archivo, proceso) prueba la logica, no la herramienta.
  - Un comando adentro de un archivo de configuracion lo corre el shell del
    OTRO programa: nada de $VAR, %VAR%, comillas anidadas. Y nunca silencies
    errores ahi.
  - El tool Bash de esta sesion es Git Bash (POSIX sh), no PowerShell: envolver
    'powershell -Command "...$env:VAR..."' ahi hace que el shell POSIX expanda
    el $ ANTES de que PowerShell vea el string. Sintaxis de PowerShell ($env:,
    variables, comillas anidadas) va por el tool de PowerShell dedicado.
  - El cwd de una herramienta de shell sobrevive entre llamadas aunque el
    resto del estado no. "No such file or directory" sobre algo que existe =
    te movieron el piso, no el archivo. Y su stdout tiene tope: contenido que
    vas a leer vos se escribe a archivo y se abre con la herramienta de leer,
    no se transporta por el shell.
  - La herramienta de leer tiene SU PROPIO tope, y no se estima por
    caracteres/4. Medi la razon real chars/token en el primer tramo chico y
    dimensiona el resto con esa. Texto cortado en lineas cuesta casi el doble
    por caracter que la prosa corrida: reflowealo ANTES de medir.

AL LEER UN NEGATIVO
  - Un negativo prueba dos cosas a la vez: que no esta, o que lo buscaste
    mal. Con que parametro lo busque, y que asume ese parametro?
  - Si la busqueda depende de bytes que cambian entre representaciones
    (punteros, offsets, padding, endianness), busca por lo INVARIANTE.
  - Un cero que refuta la premisa es el mejor resultado posible: preguntate
    que premisa acaba de caerse, no "no encontre".
  - Antes de un trabajo de inferencia largo: la respuesta no estara ya
    escrita en el artefacto? Simbolos, debug info, RTTI, cadenas, .rodata.

AL LEER EL ESTADO DE LA MAQUINA
  - El estado del entorno se MIDE, no se lee. Un documento no se entera de
    que aparecio una carpeta nueva. Ojo con la categoria "bajado pero sin
    incorporar". Si un documento dice que algo falta, verificalo antes de
    repetirlo.
  - Un archivo que un hook inyecta se lee UNA vez, al abrir la sesion.
    Editarlo a mitad de sesion no tiene efecto en esa sesion: hay que correr
    install.ps1 y abrir una sesion nueva para verlo.

(El cierre de sesion --checkpoint, commit, y el registro de una leccion nueva
con aprender.py-- es la regla 5 y el autoperfeccionamiento de CLAUDE.md. No se
repite aca: un dato que vive en dos lados diverge.)
