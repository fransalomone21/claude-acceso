#import "../plantilla.typ": *

= Punteros

#objetivo[
  Entender qué es una dirección y qué guarda un puntero, leer y escribir a través
  de él, recorrer un vector con un puntero sin pasarte, usar `NULL` como «no hay»,
  leer cualquier declaración con `const` y `*`, mover un cursor desde una función
  con un puntero a puntero, y armar una tabla de despacho con punteros a función.
  Y, de paso, cerrar todo lo que los módulos anteriores dejaron como «receta».
]

== Una dirección y un puntero

La memoria es una fila enorme de bytes, cada uno con su número: su _dirección_.
Toda variable vive en alguna. `&modo` es «la dirección de `modo`». Un _puntero_ es
una variable que guarda una dirección, y se declara con un `*`: `char *p` es «un
puntero a `char`». Con el puntero en la mano, `*p` es la variable a la que apunta:
se puede leer y se puede escribir.

#codigo("m08-direccion", salida: true, titulo: "Cambiar el modo sin nombrarlo")

`*p = 'S'` cambió `modo` sin escribir `modo`. Eso es todo el truco, y es lo que
venía haciendo `limitar` en el módulo 6 y `scanf` en el 5: recibían una dirección y
escribían en la variable de otro. La receta «`*` en el parámetro, `&` en la
llamada» era exactamente esto.

El puntero ocupa 8 bytes en la PC, porque las direcciones de un procesador de 64
bits son de 64 bits. En la placa, un Cortex-M4 de 32 bits, ocupa 4. Y el tipo del
puntero importa: `char *` dice que lo apuntado se lee como un `char`. Si apuntás un
`uint16_t *` a un `uint32_t`, gcc avisa (_incompatible pointer type_), porque leer
dos bytes donde hay cuatro es leer la mitad de otra cosa.

#ojo[un puntero sin inicializar apunta a cualquier lado, y `*p = 3u` escribe en
cualquier lado. gcc lo ve en los casos simples: _'p' is used uninitialized_ (lo
prende `-Wall`, gcc 13.3, medido). En los casos no tan simples no lo ve. Todo
puntero nace apuntando a algo, o a `NULL`.]

== Puntero y vector: el nombre del vector es una dirección

El nombre de un vector, usado en una expresión, es la dirección de su primer
elemento: `trama` y `&trama[0]` son lo mismo. Y a un puntero se le puede sumar un
entero: `trama + 2` es la dirección del elemento 2, y `*(trama + 2)` es
`trama[2]`. Los corchetes, de hecho, son una forma abreviada de escribir eso.

#codigo("m08-recorrer", salida: true, titulo: "Verificar una trama recorriéndola con un puntero")

`p` arranca en el primer byte y avanza con `p++` hasta llegar a `fin`, que apunta
al byte de control. Cada vuelta hace un XOR, y el resultado tiene que coincidir con
el último byte: si un bit se dio vuelta en el viaje, no coincide y la trama se
descarta. Es el control más barato que existe, y no detecta todo (dos bits dados
vuelta en la misma posición se cancelan), pero algo es algo.

La última línea muestra la regla que hace funcionar `p++`: *sumarle 1 a un puntero
avanza un elemento, no un byte*. En un `uint8_t *` un elemento es un byte; en un
`uint32_t *`, cuatro. El compilador multiplica solo, según el tipo. Y ahora se
entiende el módulo 7: un vector que entra a una función llega como un puntero a
su primer elemento, y por eso `sizeof` daba 8.

#ojo[un puntero que se pasa del final del vector apunta a memoria ajena, igual que
un índice fuera de rango, y C no avisa. Se compara contra un `fin` calculado una
vez, como en el ejemplo. Apuntar *justo* uno después del último está permitido (es
lo que se usa para comparar), pero no leer ahí.]

#mejora("índices antes que aritmética")[
  MISRA-C:2012 aconseja (regla 18.4) recorrer con índices, `trama[i]`, antes que
  sumándole enteros a un puntero: el índice deja a la vista contra qué vector se
  está contando. Saber leer la aritmética de punteros es obligatorio, porque está
  en todo el código de la HAL; escribirla, cuanto menos, mejor.
]

== `NULL`: no apunta a nada

`NULL` (de `<stddef.h>`) es un puntero que, por convención, no apunta a nada. Se
usa para decir «no hay»: una función que busca algo y devuelve dónde está, devuelve
`NULL` si no lo encontró.

#codigo("m08-null", salida: true, titulo: "Buscar el umbral de un sensor por su id")

El que llama *tiene que* preguntar si es `NULL` antes de usar el puntero. Leer a
través de `NULL` no es un error que gcc vea: compila sin avisar, y en la PC el
programa muere con _Segmentation fault_ (medido). En la placa es peor otra vez: en
la F446RE, arrancando desde la flash, la dirección 0 es un espejo del principio de
la flash, así que leer `*NULL` *no falla*: devuelve el primer valor de la tabla de
vectores. El umbral de un sensor que no existe pasa a ser lo que haya escrito al
principio de la flash, un número que nadie va a sospechar, y nadie se entera.

#ojo[nunca se devuelve la dirección de una variable local. Al salir de la función,
la local deja de existir, y el puntero queda apuntando a un lugar que la próxima
llamada va a pisar. gcc avisa: _function returns address of local variable_
(medido). `buscar_umbral` devuelve la dirección de un elemento de un vector
`static`, que vive toda la ejecución: eso sí se puede.]

== `const` y punteros: dónde va cada uno

Con punteros hay *dos* cosas que pueden ser constantes: lo apuntado y el puntero
mismo. La regla para leerlo es de derecha a izquierda, desde el nombre:

#tabla(
  columns: (auto, 1fr),
  [*Declaración*], [*Se lee*],
  [`const uint8_t *p`], [`p` es un puntero a un `uint8_t` constante: por `p` no se escribe, pero `p` se puede mover],
  [`uint8_t *const p`], [`p` es un puntero constante: no se mueve, pero por él se escribe],
  [`const uint8_t *const p`], [ni se mueve ni se escribe],
  [`const char *const NOMBRE_MODO[3]`], [un vector de 3 punteros constantes a `char` constantes: la tabla del módulo 7],
)

`m08-recorrer` usa `const uint8_t *p`: `p` avanza por la trama, pero no puede
modificarla. Y si intentás apuntar un puntero sin `const` a un dato `const`, gcc
avisa (_discards 'const' qualifier_, medido): sería una puerta trasera para
escribir lo que se prometió no tocar.

=== El registro del módulo 3, leído entero

Ahora se puede leer la línea que el módulo 3 dejó para después:

```c
#define ADC1_SR   (*(const volatile uint32_t *)0x40012000u)
```

De adentro para afuera: `0x40012000u` es un número, la dirección donde el
fabricante puso el registro de estado del ADC1. `(const volatile uint32_t *)` lo
convierte en un puntero a un `uint32_t` que el programa no escribe y que cambia
solo. Y el `*` de afuera lo desreferencia: `ADC1_SR` *es* el registro, y se lee
como una variable más. Así está hecha toda la HAL de ST por dentro: estructuras
apuntadas a direcciones fijas (el módulo 10 lo mapea).

== Puntero a puntero: mover el cursor de otro

Una función que recibe `uint8_t *` puede cambiar el byte apuntado. ¿Y si tiene que
cambiar *el puntero* del que la llama, por ejemplo para avanzarlo? Por el módulo
6, recibe la dirección del puntero: un puntero a puntero, `**`.

#codigo("m08-cursor", salida: true, titulo: "Desarmar un telecomando con un cursor")

`cursor` apunta al próximo byte por leer. `leer_u8(&cursor)` recibe *dónde está el
cursor*: con `**cursor` lee el byte (dos saltos: al cursor, y de ahí al byte), y con
`(*cursor)++` avanza el cursor de `main`, no una copia. Cada lectura deja el
cursor listo para la siguiente, y quien desarma el telecomando no lleva la cuenta
de posiciones a mano. Al final, la resta `cursor - tc` dice cuántos bytes se
consumieron: restar dos punteros al mismo vector da la distancia en elementos.

Los paréntesis de `(*cursor)++` no son decorativos: `*cursor++` es `*(cursor++)`,
que avanza la copia local del puntero a puntero (que no apunta a ningún vector) y
deja el cursor de `main` donde estaba. Es la precedencia del módulo 4, otra vez.

== Punteros a función: la tabla de despacho

Una función también tiene dirección, y se puede guardar en un puntero. Con un
vector de punteros a función se arma una _tabla de despacho_: el código del
telecomando es el índice, y el elemento es la función que lo atiende. Es el
despachador del módulo 5, sin el `switch`:

#codigo("m08-despacho", salida: true, titulo: "El despachador de telecomandos, como tabla")

La declaración asusta, y se lee igual que las otras, desde el nombre: `MANEJADOR`
es un vector de `N_TC` elementos (`[N_TC]`) constantes (`const`), cada uno un
puntero (`*`) a una función que no recibe nada (`(void)`) y no devuelve nada
(`void`). `MANEJADOR[codigo]()` toma el elemento y lo llama.

Agregar un telecomando es agregar una función y una entrada en la tabla; el
despachador no se toca. Y el control `codigo < N_TC` no es opcional: un índice
fuera de la tabla no es un `default` que rechaza, es *saltar a una dirección
cualquiera* y ejecutar lo que haya ahí. Un byte corrupto en el enlace se convierte
en el OBC ejecutando basura. Es el `default` del módulo 5, con consecuencias más
graves si falta.

#idea[la tabla es `const`: va a la flash, y nadie la puede cambiar en vuelo. Si
estuviera en RAM, un bit dado vuelta por radiación en un puntero a función haría
que un ping ejecute cualquier cosa.]

#posta[
  `&x` es dónde está `x`; `*p` es lo que hay donde apunta `p`. Todo puntero nace
  apuntando a algo o a `NULL`, y antes de usarlo se pregunta si es `NULL`. Sumarle
  1 avanza un elemento, y nunca se pasa del `fin`. `const` a la izquierda del `*`
  protege el dato; a la derecha, el puntero. Para mover el puntero de otro, `**`.
  Y una tabla de punteros a función, `const` y con el índice controlado, reemplaza
  un `switch` largo.
]
