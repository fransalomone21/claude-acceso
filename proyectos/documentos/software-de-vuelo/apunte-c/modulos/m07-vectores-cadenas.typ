#import "../plantilla.typ": *

= Vectores y cadenas

#objetivo[
  Guardar muchos datos del mismo tipo en un vector y recorrerlo sin pasarte del
  último, armar un buffer circular de tamaño fijo, usar una tabla de dos
  dimensiones, entender que una cadena es un vector de `char` que termina en `'\0'`,
  y pasarle un vector a una función sin perder su tamaño en el camino.
]

== Un vector: muchos del mismo tipo

Una variable guarda un dato. Un _vector_ (o _arreglo_, _array_) guarda varios del
mismo tipo, uno al lado del otro en la memoria, bajo un solo nombre. Se declara con
el tamaño entre corchetes, y a cada elemento se llega con su _índice_, que arranca
en *cero*: un vector de 8 va del `[0]` al `[7]`.

#codigo("m07-muestras", salida: true, titulo: "Ocho minutos de temperatura de la batería")

La lista entre llaves inicializa los elementos en orden. El vector es `const`
porque son mediciones que ya no se tocan (y, global, iría a la flash, como en el
módulo 3). El `for` lo recorre con `i < N_MUESTRAS`: `<`, no `<=`. Con `<=` se
lee un noveno elemento que no existe, que es el error más repetido de la historia
del C y tiene nombre propio: _off-by-one_, uno de más.

`sizeof` sobre un vector da el tamaño *total*: 8 elementos de 2 bytes, 16 bytes.
Dividido por el tamaño de uno, `sizeof(temp_dc[0])`, da la cantidad de elementos.
Ese truco anda acá; en un rato vas a ver dónde deja de andar.

#ojo[C no controla los índices. `temp_dc[8]` en un vector de 8 lee lo que haya en
la memoria a continuación, y `m[8] = 3u` *escribe* ahí, sobre otra variable que no
tiene nada que ver. gcc no avisó en ninguna de nuestras pruebas, ni con el índice
escrito como constante ni compilando con `-O2` (gcc 13.3, medido). En la PC, con
suerte, el programa muere; en la placa no hay sistema operativo que lo mate, y la
variable de al lado cambia de valor sin que nadie la haya tocado.]

#idea[si la lista de inicialización es más corta que el vector, lo que falta queda
en cero. Por eso `uint16_t historia[4] = { 0u };` es la forma corta de decir «todo
en cero».]

== Un buffer circular

Un caso que en vuelo aparece en todos lados: guardar *las últimas* N mediciones.
No se puede guardar todo (la memoria es fija y la cátedra no quiere `malloc`), así
que cuando el vector se llena, la medición nueva pisa la más vieja. Un índice
marca dónde va la próxima, y al llegar al final vuelve al principio:

#codigo("m07-circular", salida: true, titulo: "Las últimas cuatro tensiones del bus")

La vuelta al principio la hace la máscara del módulo 4: con una ventana de 4 (una
potencia de dos), `& 3u` es lo mismo que `% 4u`. Después de la cuarta medición,
`proxima` vuelve a 0, y la quinta pisa a la primera. El vector nunca crece, nunca
se pide memoria, y el peor caso se sabe antes de despegar: 4 lecturas de 2 bytes,
siempre.

#catedra("sin malloc")[
  Sin memoria dinámica: nada de `malloc`. Los buffers se declaran con tamaño fijo,
  de entrada.
]

== Dos dimensiones: una tabla

Un vector de vectores es una tabla: el primer índice elige la fila, el segundo la
columna. El LED de estado del OBC parpadea distinto según el modo, y cada modo es
una fila con los diez pasos de su patrón:

#codigo("m07-patrones", salida: true, titulo: "El patrón del LED de estado, por modo")

`PATRON_LED[modo][paso]` se lee «de la fila `modo`, la columna `paso`». En la
memoria la tabla está fila tras fila (primero los 10 pasos del modo 0, después los
del 1): 3 por 10, 30 bytes. Es `static const`: en la placa va a la flash y no gasta
RAM. Y el programa no tiene un solo `if` por modo: para agregar un modo nuevo se
agrega una fila, y el código que la recorre no se toca. Ésa es la gracia de una
tabla de patrones.

`NOMBRE_MODO` es un vector de cadenas, una por modo, para poder imprimirlas. El `*`
de su declaración es del módulo 8; las cadenas, de acá abajo.

== Las cadenas: un vector de `char` con un cero al final

C no tiene un tipo «texto». Una cadena es un vector de `char` que termina en un
byte que vale cero, el `'\0'`: así sabe `printf` con `%s` dónde termina. Cuando se
escribe `"OBC-1"` entre comillas dobles, C agrega el `'\0'` solo:

#codigo("m07-cadenas", salida: true, titulo: "El nombre de la misión y el de cada foto")

`"OBC-1"` tiene cinco letras y ocupa *seis* bytes. `strlen` (de `<string.h>`)
cuenta las letras hasta el `'\0'`; `sizeof` mide el vector entero, con el `'\0'`
incluido. Con `char mision[]`, sin número, el tamaño lo calcula C a partir de la
cadena, y no se equivoca.

#ojo[`char nombre[5] = "ORBIT";` compila sin un solo warning (gcc 13.3, medido): en
C es legal, y el `'\0'` simplemente no entra. Después, un `printf("%s", nombre)`
sigue leyendo memoria hasta encontrar un cero por casualidad, e imprime «ORBIT»
seguido de lo que haya al lado. Sin el número entre corchetes, el problema no
existe.]

Para *armar* una cadena, como el nombre de un archivo, está `snprintf`: es un
`printf` que escribe en un vector en vez de en la pantalla. Recibe el tamaño del
vector y nunca escribe más que eso: si no entra, recorta y siempre deja el `'\0'`.
Y devuelve cuántos caracteres *habría* necesitado, así que comparando se sabe si
recortó. La foto 42 entra justa en los 13 bytes; la 10042 tiene cinco cifras, no
entra, y el programa se entera. Un nombre recortado que nadie revisa es una foto
que pisa a otra en la memoria de la cámara.

#ojo[cuando todos los datos son constantes, gcc hace la cuenta antes de compilar y
avisa: un `snprintf` de `"IMG_%04u.RAW"` con el 42 escrito a mano en un vector de 8
da _directive output truncated_ (lo prende `-Wall`; medido en gcc 13.3). Con el
número en una variable, como en el ejemplo, ya no puede saberlo: por eso se mira lo
que devuelve.]

#mejora("las cadenas, con tamaño")[
  `strcpy`, `strcat` y `sprintf` escriben sin mirar cuánto lugar hay: con un dato
  más largo de lo previsto, pisan lo que sigue. Se usan las versiones con tamaño
  (`snprintf`) y se mira lo que devuelven. Y una nota para más adelante: MISRA-C
  prohíbe directamente `<stdio.h>` en el código de producción (regla 21.6), así que
  en el software de vuelo real ni `printf` hay. En el apunte se usa para ver qué
  pasa; en la placa, la telemetría se arma byte por byte.
]

== Un vector como parámetro

Cuando se pasa un vector a una función no se copia entero (sería carísimo): se
pasa *dónde empieza*. Adentro de la función, el parámetro ya no es el vector sino
un puntero a su primer elemento, aunque lo hayas declarado con corchetes. Y ahí el
truco del `sizeof` se rompe:

#codigo("m07-parametro", salida: true, titulo: "Las seis celdas del pack de baterías")
#aviso("m07-parametro")

En `main`, `sizeof` da 12: seis celdas de 2 bytes. En `mal`, da 8, el tamaño de un
puntero en la PC (en la placa daría 4). El `[N_CELDAS]` de la declaración es
decorativo: el compilador lo ignora, y gcc avisa que lo está ignorando. La forma
correcta es la de `total_mv`: el vector y, aparte, cuántos elementos tiene.

El `const` del parámetro es una promesa: `total_mv` no va a modificar las celdas.
Si lo intentara, no compilaría. Como el vector no se copia, ese `const` es la única
garantía que tiene el que llama de que su dato vuelve intacto.

#posta[
  Los índices van de `0` a `N - 1`, el bucle es con `<`, y C no te avisa si te
  pasás. Lo que tiene que guardar «las últimas N» es un buffer circular de tamaño
  fijo. Una tabla de patrones cambia `if` por filas, y si es `const`, vive en la
  flash. Una cadena ocupa una letra más que su largo, por el `'\0'`: dejá que C
  cuente. Para armar cadenas, `snprintf`, mirando lo que devuelve. Y un vector que
  entra a una función llega como puntero: el tamaño se pasa aparte.
]
