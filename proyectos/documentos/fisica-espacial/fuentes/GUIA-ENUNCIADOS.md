# La guía de problemas, transcripta

*«GUIA DE PROBLEMAS — Física Espacial 2026», UNSAM, 18 páginas.* Ruta del PDF
en [`RUTAS.md`](RUTAS.md).

**Por qué existe este archivo.** Los enunciados de la guía son, en su mayoría,
**imágenes pegadas** dentro del PDF: `pdftotext` devuelve sólo los rótulos
«Ej. 5», «PROBLEMA 3» y nada más. Leerlos obliga a renderizar el PDF con
PyMuPDF y **mirar las páginas como imágenes**, que es la operación más cara de
todo el proyecto y se pagaba una vez por sesión. Acá quedan transcriptos: la
sesión que necesita un enunciado lo lee de este archivo, en texto, y sólo
vuelve al PDF si necesita **ver una figura**.

Transcripto el 2026-08-31 desde las páginas renderizadas. Los enunciados que
vienen de un libro llevan su número entre paréntesis, tal como la guía los
marca: S&Z (Young & Freedman) y Beer.

**Lo que este archivo no reemplaza.** Las figuras. Cuando un enunciado dice
«según la figura», acá va la *descripción de la figura con sus datos numéricos
leídos*, que es lo que hace falta para resolver; el dibujo sigue estando sólo
en el PDF, y se mira si hay que redibujarlo.

| Sección | Páginas del PDF |
|---|---|
| Vectores (Ej. 1–15) | 1–4 |
| Conservación de cantidad de movimiento (Ej. 1–9) | 4–6 |
| Conservación de impulso angular (Prob. 1–7) | 7–9 |
| Conservación de la energía – Gravitación (Prob. 0–10) | 10–14 |
| Cuerpo rígido (Prob. 1–9) | 15–18 |

---

## Vectores (pág. 1–4)

Los ejercicios **1 a 8** son imágenes y no se transcribieron: el módulo 1 ya
está escrito y cerrado, y no los necesita.

**Ej. 9 — Coordenadas curvilíneas.** Sea $R$ vector posición con módulo $R$ y
ángulo $\theta$ respecto al eje $X$ de un sistema de coordenadas de dos
dimensiones. Sean $\hat r$ y $\hat\theta$ dos versores en coordenadas polares.
Escriba la velocidad de un punto en coordenadas polares.

**Ej. 10.** Se lanza un cohete verticalmente desde una plataforma de
lanzamiento en $B$; su vuelo es seguido por un radar desde el punto $A$.
Determinar la velocidad del cohete en términos de $b$, $\theta$ y
$d\theta/dt$. *(Figura: el radar en $A$, la plataforma en $B$, la distancia
horizontal $b$ entre los dos, y $\theta$ el ángulo de elevación desde $A$.)*

**Ej. 11.** Hallar los cosenos directores del vector de componentes $(1,-1,3)$.

**Ej. 12.** Hallar los cosenos directores de los vectores paralelos al eje $Z$.

**Ej. 13.** Hallar las componentes del versor perpendicular a los vectores
$A=(0,1,5)$ y $B=(-3,0,2)$.

**Ej. 14.** Dados los vectores $A=(1,0,-3)$, $B=(2,5,-1)$, hallar la
proyección de $B$ sobre $A$.

**Ej. 15.** Dados $A=(2,0,-3)$, $B=(-1,5,2)$, $C=(0,-4,1)$, calcular:
i) $A\cdot(B\times C)$; ii) $A\times(B\times C)$; iii) $(A\times B)\times C$;
iv) $A\times(A\times B)$; v) $(A\cdot B)(A\times B)$;
vi) $(A\times B)\times(A\times C)$.

## Conservación de cantidad de movimiento (pág. 4–6)

Los nueve son imágenes. Los que el apunte ya usa quedaron resueltos y citados
en los módulos 2, 3 y 5:

- **Ej. 1** — la astronauta (módulo 2, ejemplo simple; también rehecho desde el
  CM en el módulo 3).
- **Ej. 2** — el choque oblicuo de asteroides (módulo 2, ejemplo a fondo; y en
  el sistema CM en el módulo 3).
- **Ej. 3** — el calamar (S&Z 8.19); la parte (b) es el ejemplo simple del
  módulo 5.

Los **4 a 9** no se transcribieron todavía: la Parte II está cerrada y ninguno
de los módulos que faltan los necesita. Si alguna vez hacen falta, están en las
páginas 5 y 6 del PDF.

## Conservación de impulso angular (pág. 7–9)

### Problema 1 — (S&Z 10.1, «Sección 10.1 Torca»)

Calcule la torca (magnitud y dirección) alrededor del punto $O$ debida a la
fuerza $\vec F$ en cada una de las situaciones que se representan en la figura
E10.1. En todos los casos, la fuerza $\vec F$ y la varilla están en el plano de
la página, la varilla mide **4,00 m** de largo y la fuerza tiene magnitud
$F = 10{,}0$ N.

*Figura E10.1 — seis casos, con $O$ en un extremo de la varilla horizontal:*

| Caso | Dónde se aplica $F$ | Ángulo con la varilla |
|---|---|---|
| a) | extremo libre | $90{,}0°$ (hacia arriba) |
| b) | extremo libre | $120{,}0°$ |
| c) | extremo libre | $30{,}0°$ |
| d) | a **2,00 m** de $O$ | $60{,}0°$ (hacia arriba y a la izquierda) |
| e) | en $O$ mismo | $60{,}0°$ |
| f) | extremo libre | $180°$ — sobre la varilla, hacia $O$ |

### Problema 2

Demostrar que el impulso angular $\bm L = \bm r\times\bm p$ respecto de un
punto cualquiera de una sola partícula que se mueve con velocidad constante
permanece constante en todo el movimiento.

### Problema 3

Dos partículas cada una de masa $m$ y velocidad $\bm v$ avanzan en sentidos
opuestos siguiendo trayectorias paralelas separadas una distancia $d$.
Demostrar que el impulso angular $\bm L$ de ese sistema de partículas es el
mismo con respecto a un punto cualquiera que se tome como origen.

### Problema (sin número, entre el 3 y el 4) — (S&Z 10.51, «Giróscopos y precesión»)

El rotor (volante) de un giróscopo de juguete tiene una masa de **0,140 kg**.
Su momento de inercia alrededor de su eje es $1{,}20\times10^{-4}$ kg·m². La
masa del marco es de **0,0250 kg**. El giróscopo se apoya en un solo pivote
(figura E10.51) con su centro de masa a una distancia horizontal de **4,00 cm**
del pivote. El giróscopo hace un movimiento de precesión en un plano horizontal
a razón de una revolución cada **2,20 s**.
*a)* Calcule la fuerza hacia arriba ejercida por el pivote.
*b)* Calcule la rapidez angular en rev/min con que el rotor gira sobre su eje.
*c)* Copie el diagrama e indique con vectores el momento angular del rotor y la
torca que actúa sobre éste.

### Ejercicio 4 — el satélite de la figura

Según la figura de más abajo:
**A.** Calcule en las posiciones de Apogeo ($A$) y Perigeo ($P$) el impulso
angular específico (por unidad de masa de satélite) de un satélite con
trayectoria como la de la figura.
**B.** En base a lo calculado en el punto A, calcule las distancias al centro
terrestre en las otras dos posiciones marcadas con una flecha roja.

*Figura — los datos, leídos del dibujo:*

| Dato | Valor |
|---|---|
| Radio terrestre dibujado | **6378 km** |
| Altura del apogeo $A$ sobre la superficie | **4000 km** |
| Altura del perigeo $P$ sobre la superficie | **400 km** |
| Velocidad en $A$ | **5,509 km/s** (perpendicular al radio) |
| Velocidad en $P$ | **8,435 km/s** (perpendicular al radio) |
| Posición intermedia superior | **6,970 km/s**, a **12,05°** de la perpendicular al radio |
| Posición intermedia inferior | **6,817 km/s**, a **12,11°** de la perpendicular al radio |
| Ángulos de posición marcados | $96{,}09°$ (arriba) y $102{,}1°$ (abajo) |

En el dibujo, $C$ es el centro geométrico de la elipse y $F$ el foco ocupado
(centro de la Tierra); $A$ y $P$ están sobre la línea de ábsides, con $A$ a la
izquierda.

**Cuenta de control ya hecha:** $r_P = 6378+400 = 6778$ km y
$r_A = 6378+4000 = 10378$ km, así que
$h = r_P v_P = 6778\cdot 8{,}435 = 57{,}17\times10^3$ km²/s y
$r_A v_A = 10378\cdot 5{,}509 = 57{,}17\times10^3$ km²/s. **Coinciden**: los
números de la figura son consistentes, y ése es justamente el punto A del
ejercicio.

### Ej. 5 — la pregunta fina

Formule la segunda Ley de Kepler en términos de **velocidad areolar**.
Demuestre que la conservación de la velocidad areolar es equivalente a la
conservación de impulso angular.

*¿Qué condición es necesaria: que el potencial atractivo sea del tipo $1/r$ (la
fuerza del tipo $1/r^2$) y la fuerza sea central, o solamente que la fuerza sea
central?*

### Ej. 6

**Está en blanco en el PDF**: el rótulo «Ej 6» aparece en la página 9 y debajo
no hay ni texto ni imagen. No es un problema de renderizado — la página está
vacía. Si la cátedra lo completa, hay que volver a mirar esa página.

### Ej. 7 — (S&Z 10.53, «Estabilización del Telescopio Espacial Hubble»)

El Telescopio Espacial Hubble se estabiliza dentro de un ángulo de alrededor de
**2 millonésimas de grado** mediante una serie de giróscopos que giran a
**19 200 rpm**. Aunque la estructura de esos giróscopos es bastante compleja,
podemos modelar cada uno de ellos como un cilindro de pared delgada de
**2,0 kg** de masa y **5,0 cm** de diámetro, girando alrededor de su eje
central. ¿Qué magnitud de torca se necesita para hacer que esos giróscopos
realicen un movimiento de precesión a través de un ángulo de
$1{,}0\times10^{-6}$ grados durante una exposición de **5,0 horas** de una
galaxia?

## Conservación de la energía – Gravitación (pág. 10–14)

### Problema 0

Estime la masa del Sol.

### Problema 1 — (S&Z 7.76)

Una partícula se mueve a lo largo del eje $x$ y sobre ella actúa una sola
fuerza conservativa paralela al eje $x$. Tal fuerza corresponde a la función de
energía potencial graficada en la figura P7.76. La partícula se suelta del
reposo en el punto $A$.
*a)* ¿Qué dirección tiene la fuerza sobre la partícula en el punto $A$?
*b)* ¿Y en el punto $B$?
*c)* ¿En qué valor de $x$ es máxima la energía cinética de la partícula?
*d)* ¿Qué fuerza actúa sobre la partícula en $C$?
*e)* ¿Qué valor máximo de $x$ alcanza la partícula durante su movimiento?
*f)* ¿Qué valor o valores de $x$ corresponden a puntos de equilibrio estable?
*g)* ¿Y de equilibrio inestable?

*Figura P7.76 — la curva $U(x)$, con la escala del eje $y$ marcada en
$-2{,}0$, $0$, $2{,}0$, $4{,}0$ J y la del eje $x$ en $0{,}5$, $1{,}5$,
$2{,}0$, $2{,}5$ m.* Los valores medidos por píxeles y usados en el módulo 5
están en ese módulo.

**Ya resuelto entero en el módulo 5**, como ejemplo a fondo.

### Problema 2 — (Beer, sonda espacial)

Si se sabe que la velocidad de una sonda espacial experimental lanzada desde la
Tierra tiene una magnitud $v_A = 20{,}2\times10^3$ mi/h en el punto $A$,
determine la velocidad de la sonda cuando pase por el punto $B$.

*Figura:* $R = 3960$ mi (radio terrestre), $h_A = 2700$ mi, $h_B = 7900$ mi.
En $A$ la velocidad es **perpendicular al radio**; en $B$ se pide la velocidad
sobre la trayectoria.

### Problema 3 — (Beer 12.80)

Los satélites de comunicaciones se ubican en una órbita **geosincrónica**, es
decir, en una órbita circular tal que terminan una revolución completa
alrededor de la Tierra en un día sideral (**23,934 h**), y de esa manera
parecen estacionarios con respecto a la superficie terrestre. Determine
*a)* la altura de estos satélites sobre la superficie de la Tierra y
*b)* la velocidad con la cual describen su órbita.

### Problema 4 — (S&Z 13.67)

Considere una nave en órbita elíptica alrededor de la Tierra. En el punto bajo,
o **perigeo**, de su órbita, la nave está **400 km** arriba de la superficie de
la Tierra; en el punto alto, o **apogeo**, está a **4000 km** de la superficie
de la Tierra.
*a)* Calcule el periodo de la nave en esa órbita.
*b)* Usando la conservación del momento angular, calcule la razón entre la
rapidez de la nave en el perigeo y la rapidez de la nave en el apogeo.
*c)* Usando la conservación de la energía, determine la rapidez de la nave
tanto en el perigeo como en el apogeo.
*d)* Se desea que la nave escape totalmente de la Tierra. Si sus cohetes se
encienden en el perigeo, ¿cuánto tendrá que aumentarse la rapidez para
lograrlo? ¿Qué ocurre si los cohetes se disparan en el apogeo? ¿Qué punto de la
órbita se puede usar con mayor eficiencia?

> **Es la misma órbita del Ej. 4 de impulso angular** — 400 km y 4000 km de
> altura. Los dos ejercicios son el mismo satélite mirado con las dos leyes de
> conservación, y por eso conviene resolverlos con la misma notación.

### Problema 5 — (S&Z 13.79, «Navegación interplanetaria»)

La forma más eficiente de enviar una nave desde la Tierra a otro planeta es
usar una **órbita de transferencia de Hohmann** (figura P13.79). Si las órbitas
de los planetas de origen y destino son circulares, la órbita de transferencia
de Hohmann es una órbita elíptica, cuyo perihelio y afelio son tangentes a las
órbitas de los dos planetas. Los cohetes se encienden brevemente en el planeta
de origen para colocar la nave en la órbita de transferencia; a continuación,
la nave viaja sin motor hasta llegar al planeta de destino. En ese instante,
los cohetes se encienden otra vez para poner a la nave en la misma órbita
alrededor del Sol que el planeta de destino.
*a)* Para un vuelo de la Tierra a Marte, ¿en qué dirección se deben disparar
los cohetes en la Tierra y en Marte: en la dirección del movimiento o en la
dirección opuesta? ¿Y en un vuelo de Marte a la Tierra?
*b)* ¿Cuánto tarda un viaje de ida de la Tierra a Marte, entre los encendidos
de los cohetes?
*c)* Para llegar a Marte desde la Tierra, el instante del lanzamiento debe
calcularse de modo que Marte esté en el lugar correcto cuando la nave llegue a
la órbita de Marte alrededor del Sol. En el lanzamiento, ¿qué ángulo deben
formar las líneas Sol-Marte y Sol-Tierra? Use datos del apéndice F.

### Problema 6 — (Beer 13.85)

Mientras describe una órbita circular a **300 km** sobre la Tierra un vehículo
espacial lanza un satélite de comunicaciones de **3600 kg**. Determine
*a)* la energía adicional que se requiere para poner el satélite en una órbita
geosíncrona a una altura de **35 770 km** sobre la superficie terrestre, y
*b)* la energía requerida para poner el satélite en la misma órbita
lanzándolo desde la superficie de la Tierra, sin incluir la energía necesaria
para superar la resistencia del aire.

### Problema 7 — (Beer 13.100)

Se espera que una nave espacial, que viaja a lo largo de una trayectoria
**parabólica** hacia el planeta Júpiter, alcance el punto $A$ con una velocidad
$\bm v_A$ de **26,9 km/s** de magnitud. Sus motores se activarán entonces para
frenarla, colocándola en una órbita elíptica que la pondrá a
$100\times10^3$ km de Júpiter. Determine la reducción en la velocidad
$\Delta v$ en el punto $A$ que colocará a la nave espacial en la órbita
requerida. La masa de Júpiter es **319 veces** la masa de la Tierra.

*Figura P13.100:* $A$ está a $350\times10^3$ km de Júpiter y $B$ del otro lado,
a $100\times10^3$ km; $A$ y $B$ son los ábsides de la elipse pedida, y en $A$
la velocidad es perpendicular a la línea $AB$.

### Problema 8 — (Beer 13.101, el LEM del Apollo)

Después de completar su misión exploratoria a la Luna, los dos astronautas que
formaban la tripulación del módulo de excursión lunar (LEM) Apollo se
preparaban para reunirse con el módulo de mando que se encontraba orbitando la
Luna a una altura de **140 km**. La tripulación encendió el motor del LEM,
llevándolo a lo largo de una trayectoria curva hasta el punto $A$, **8 km**
sobre la superficie de la Luna, para después apagar el motor. Si se sabe que el
LEM se movía en ese momento en una dirección **paralela a la superficie** de la
Luna y que después se desplazó a lo largo de una trayectoria elíptica hacia un
punto de encuentro en $B$ con el módulo de mando, determine
*a)* la rapidez del LEM al apagar el motor, y
*b)* la velocidad relativa con la que el módulo de mando se aproximó al LEM en
$B$. *(El radio de la Luna es de 1740 km y su masa es 0,01230 veces la masa de
la Tierra.)*

*Figura:* $A$ y $B$ son diametralmente opuestos; $A$ es el perilunio de la
elipse (8 km de altura) y $B$ el apolunio (140 km de altura, sobre la órbita
circular del módulo de mando).

### Problema 9 — (Beer, continuación del 13.101)

Cuando el LEM regresó al módulo de mando, la nave espacial Apollo del problema
anterior se giró de modo que el LEM viera la parte trasera de la nave. Después
el LEM se impulsó con una velocidad de **200 m/s** con respecto al módulo de
mando. Determine la magnitud y la dirección (ángulo $\phi$ formado con la
vertical $OC$) de la velocidad $\bm v_C$ del LEM justo antes de estrellarse en
$C$ sobre la superficie de la Luna.

*Figura:* la órbita circular del módulo de mando a 140 km; $B$ es el punto del
impulso y $C$ el impacto sobre la superficie, con $\phi$ medido desde $OC$.

### Problema 10 — rendez-vous

Se tiene un *spacecraft* en órbita alrededor de la Tierra que se debe encontrar
con otro que está **un cuarto de órbita adelantado**.
**A.** Investigue el tema.
**B.** Formule alguna solución.
**C.** Encuentre una solución exacta para un caso determinado.

## Cuerpo rígido (pág. 15–18)

### Problema 1 — el satélite cúbico

Se tiene un satélite cúbico de **2 metros de lado** y **120 kg** de masa. En un
vértice hay un impulsor del tipo *thruster* de gas frío ($F_E = 4$ N,
$I_{sp} = 50$ s) alineado con una de las aristas.
- Calcular el vector velocidad angular del satélite luego de producirse un
  encendido del impulsor de **4 segundos**.
- Calcular el caudal másico propio del *thruster*.
- ¿Cuánto tiempo girará el satélite luego de finalizado el encendido del
  impulsor?

*Dato:* el momento de inercia de un cubo es $\tfrac16 m d^2$, con $m$ la masa y
$d$ la arista.

### Problema 2 — el disco en la horquilla

Un disco delgado, homogéneo, de masa $m$ y radio $r$ gira a velocidad constante
$\omega_1$ alrededor de un eje vertical sostenido por una horquilla que a su
vez rota con velocidad angular $\omega_2$.
1. Determine el impulso angular $\bm L_G$ del disco respecto a su centro de
   masa $G$.
2. Calcule $d\bm L_G/dt$.

### Problema 3 — el volante en el *gimbal*

El volante de la figura gira a velocidad angular constante
$\omega_s = 100$ rad/s en la dirección $z$; sus momentos de inercia son
$I_x = I_y = 5$ kg·m², $I_z = 10$ kg·m². Está soportado por un *gimbal* sin
peso montado en una plataforma como se muestra en la figura. El *gimbal* está
inicialmente quieto respecto a la plataforma, que gira con velocidad angular
constante $\omega_p = 0{,}5$ rad/s en la dirección $y$. ¿Cuál será la
aceleración angular del *gimbal* cuando se aplica al volante un torque de
**600 N·m** en la dirección $x$?

*(Las unidades de inercia están escritas «Kg/m2» en la guía; es una errata
evidente — el momento de inercia va en kg·m².)*

### Problema 4 — el *spacecraft* que precesa

El *spacecraft* de la figura es simétrico alrededor del eje $z$ con un **radio
de giro de 720 mm**. Los radios de giro respecto a los otros ejes son iguales,
de **540 mm**. Al moverse en el espacio, el eje $z$ describe un cono de
**2 grados** al precesar respecto al impulso angular ($\bm H_G$). Si la
velocidad angular de *spin* es de **1,5 rad/s**, calcule el período de cada
giro de precesión. El vector velocidad angular de *spin*, ¿apunta en el sentido
positivo o negativo del eje $z$?

### Problema 5 — (M 7.99) la estación orbital, precesión estable

La estructura primaria de una estación orbital consiste en **cinco esferas
huecas** conectadas por tubos. El momento de inercia de la estructura respecto
al eje $A$-$A$ es el doble del momento de inercia de cada esfera respecto al
eje $A$-$A$ respecto a $O$. La estación fue diseñada para rotar alrededor de su
eje geométrico a una velocidad de **3 rev/min**. Si el eje $A$-$A$ precesa
respecto al eje $Z$ de orientación fija con un ángulo pequeño, calcule la
velocidad angular de precesión $\dot\chi$. El centro de masa no está acelerado.

### Problema 6 — la relación $\ell/r$

El cilindro de paredes delgadas rota en el espacio respecto a su eje de
simetría. Si el eje precesa con un ángulo pequeño, ¿para qué radios de
$\ell/r$ será una precesión **retrógrada** y para cuáles **directa**?

### Problema 7 — la cápsula espacial

La cápsula espacial de la figura no cuenta con velocidad angular cuando se
activa el cohete $A$ durante **un segundo** con un empuje de **50 N** en
dirección paralela al eje $x$. Su masa es de **1000 kg** y sus radios de giro
son $k_x = k_y = 1$ m y $k_z = 1{,}25$ m. Determine el eje de precesión y las
velocidades de *spin* y de precesión al finalizar el impulso dado.

### Problema 8 — (Beer 18.126)

Repita el problema 7 pero con velocidad angular
$\bm\omega = 0{,}02\ \mathrm{rad/s}\ \hat\jmath + 0{,}10\ \mathrm{rad/s}\ \hat k$
y el cohete que se enciende el mismo tiempo y con el mismo empuje es $B$.

### Problema 9 — el satélite octogonal

Un satélite de **2500 kg** y **2,4 m** de alto tiene forma octogonal como
indica la figura. Cada lado mide **1,2 m**, y se encuentra libre de torques
externos. Los momentos de inercia son $I_y = 2400$ kg·m²,
$I_x = I_z = 2000$ kg·m². Los *thrusters* $A$, $B$, $C$ y $D$ pueden expeler
combustible en la dirección $y$ positiva con un empuje $J$ de **20 N**. El
satélite gira con velocidad angular $\omega_0$ alrededor del eje $y$. Mantiene
una dirección fija al espacio cuando se activan $A$ y $B$ durante $T =$ **dos
segundos**. Los *thrusters* $A$ y $B$ están ubicados en
$\bm R_A = (x_A, y_A, z_A)$ y $\bm R_B = (x_B, y_B, z_B)$.

1. Diga qué tipo de precesión tendría este cuerpo si se lo perturba
   adecuadamente.
2. Escriba el impulso angular del satélite luego del disparo de ambos
   *thrusters* en función de los parámetros mencionados.
3. Escriba la velocidad angular en el mismo caso del punto 2 en función de los
   parámetros mencionados.
4. Escriba una expresión que permita calcular el ángulo entre el impulso
   angular y el eje de simetría del cuerpo.
5. Escriba una expresión que permita calcular el ángulo entre la velocidad
   angular y el eje de simetría del cuerpo.
6. Dibuje el impulso angular, la velocidad angular total, la velocidad angular
   de espín y la velocidad angular de precesión en un mismo sistema de ejes
   coordenados apropiados (aproximadamente).
7. Describa en palabras el movimiento del satélite visto desde un sistema
   inercial (fijo al espacio).
8. Calcule explícitamente todo lo pedido en los puntos 2 a 5.

---

## Lo que se ve mirando la guía entera de una vez

Tres cosas que no se notan leyendo un ejercicio por sesión, y que deciden qué
ejemplo va en qué módulo:

1. **La sección de gravitación es casi toda Beer y S&Z cap. 13**, y sus diez
   problemas cubren, en orden, exactamente lo que el apunte planea para los
   módulos 6 a 11: potencial y energía (1, 2, 6), órbita circular y período
   (3), la elipse con sus dos ábsides (4, 7, 8), Hohmann (5) y *rendez-vous*
   (10). **No hay que inventar ningún ejemplo en la Parte III.**

2. **El Ej. 4 de impulso angular y el Problema 4 de energía son el mismo
   satélite** (400 km de perigeo, 4000 km de apogeo). Conviene resolverlos con
   la misma notación y que el segundo se apoye explícitamente en el primero:
   es la mejor demostración de que las dos conservaciones son independientes y
   se usan juntas.

3. **La sección de cuerpo rígido tiene los enunciados en texto, no en imagen**
   — al revés que las otras dos. Lo que está en imagen ahí son las **figuras**,
   que en varios problemas (2, 3, 4, 7, 9) hacen falta para saber la geometría.
   Esas sí hay que mirarlas cuando se escriban los módulos 12 a 15.
