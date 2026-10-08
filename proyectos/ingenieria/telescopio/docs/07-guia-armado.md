# El proyecto — qué es y por qué así

**Para Fran y Kevin.** Versión 7, 8 de octubre de 2026 (a la noche). Fuente
en el repo: `proyectos/ingenieria/telescopio/docs/07-guia-armado.md`.

> **Este documento es el concepto. Los pasos, en orden, están en «2 - Paso a
> paso».** Los mecanismos con sus dibujos, los talleres de la zona y el cielo
> están en **«3 - Mecanismos, proveedores y cielo»**. Los números finos están
> en la subcarpeta **Archivo**: no hace falta leerlos para avanzar.
>
> **Nuevo en la versión 7:** (1) el **error de micropaso** del motor, que
> faltaba en la cuenta: con **una** correa la F estira la estrella, y con tu
> orden de criterios **la transmisión ya no empata: va ganando T2**, la varilla
> de la foto con un tornillo de bolas (sección 3 de los conceptos); (2) los
> **rodillos pasan a 58 cm y la base a 1,3 m**: se cerró el único rojo; (3)
> **las chapas ya no dependen del vuelco**.

**Modelo 3D, versión 10.5: la plataforma «terminada», con el 200 o con un 12"
arriba, y con las dos transmisiones para elegir.** Nuevo: botón
**«Recorrido»** (la plataforma explicada en siete paradas), **vista
explotada** y la sección **«Cuatro maneras de mover la mesa»**, con la
estrella simulada según la transmisión:
https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd — se abre con el link,
sin cuenta (medido el 8/10).

## Qué vamos a hacer

El cielo gira. Con el telescopio quieto, una foto de 30 segundos sale con las
estrellas hechas rayitas. Vamos a construir una **plataforma ecuatorial**: una
mesa baja que va debajo del dobson entero y lo hace girar despacito, a la
velocidad del cielo, durante unos 90 minutos. Después se «rebobina» y se sigue.
El dobson se apunta a mano como siempre. Y desde el 7/10, **la misma
plataforma lleva también un dobson de 300 mm** que todavía no elegimos, GoTo
incluido.

Diseño elegido: **VNS**. Apoya en **tres puntos** (un pivote y dos rodillos),
así que no renguea en ningún piso.

## Cómo estamos trabajando: dibujar para decidir

Seguimos en la fase de **concepto** (NASA la llama *Pre-Phase A*). Para
definirlo usamos vueltas de **diseño preliminar**: cada versión del modelo 3D
muestra la plataforma como si estuviera terminada, con todo lo que sabemos, y
lo que no sabemos queda marcado. Es una forma ágil de trabajar: nos
convencemos mirando, y si algo no cierra se ve enseguida. Pero **el dibujo no
manda: manda la física** (la tabla «Lo que importa» del modelo), y **nada se
corta** hasta que el centro de masa esté medido y los requisitos cerrados.

Cada pieza lleva su grado:

- **confirmado**: medido, o decidido por Fran y cerrado por cálculo;
- **probable**: cuenta con datos reales, falta un segundo método;
- **en revisión**: concepto o propuesta abierta.

## El diseño en una tabla

| Parte | Cómo es | Grado |
|---|---|---|
| **Base al piso** | triángulo de **tubo 20 × 20**, ≈ 1,2 m de largo y **1,3 m de ancho** (era 1,2), tres patas M10 regulables con su marca en el piso. El lado sur lleva los rodillos (a **58 cm** uno del otro; eran 50) y el motor; la electrónica y la batería van en los lados | probable |
| **Mesa universal** | marco de tubo 20 × 20 (travesaño sur, travesaño norte, **tres largueros**, brazo en A hasta el pivote) con **tres rieles** soldados arriba: ahí apoya el dobson y corren las mordazas. ≈ 87 cm de norte a sur, ≈ 11 kg con las chapas | en revisión |
| **Corredera** | el dobson se corre norte-sur sobre los rieles hasta **su muesca**: una por telescopio | en revisión |
| **Tres mordazas de borde** | toman la base del dobson del borde: **no se agujerea nada** | en revisión |
| **Pivote** | rótula de amortiguador a gas sobre un poste de 10 cm | probable |
| **Dos chapas** | **acero de 5/16"**, cortadas a **láser**, colgadas del travesaño sur. Las mismas para los dos telescopios. Su forma sale de la altura del eje, la latitud y los rodillos; **no del centro de masa**: la corredera absorbe cualquier 200 entre 55 y 69 cm | en revisión |
| **Rodillo loco (este)** | cuatro rulemanes 608 de roller sobre una varilla de impresora | probable |
| **Transmisión** | **dos opciones, sin elegir**: **F** (rodillo de acero torneado por fricción + correa GT2 4:1 + NEMA 17 de ≈ 4 kg·cm, en el rodillo oeste) o **V** (varilla y tuerca al sur de la viga, con una biela que empuja un brazo de la mesa, como la foto de Fran). **Va ganando la V con tornillo de bolas (T2)**: la F con una correa no pasa la precisión por el error de micropaso, y con dos correas pierde por facilidad y porque puede patinar (ver el puntaje abajo) | en revisión |
| **Electrónica** | ESP32 + TMC2209 en una caja sobre el tubo de costado del oeste (fuera del barrido de las chapas), botón de rebobinado, ficha ST-4 para el autoguiado de más adelante; la batería en el tubo del este | probable |
| **Topes** | tres capas: programa (±45 min), fin de carrera (±48) y talón de la chapa (±51) | confirmado |
| **Eje** | a 54 cm sobre la mesa, inclinado 34,5° hacia el sur | confirmado |

## Dos telescopios, una plataforma

Fran: «debe servir para ambos, aunque aumente la complejidad, no perdamos
precisión». Cómo se logra sin cortar otras chapas:

- **El eje sube hacia el sur** con la latitud: correr el dobson **10 cm al
  sur** equivale a subir el eje **6,9 cm**. Un telescopio con el centro de
  masa bajo va más al norte; uno alto, más al sur. **Las chapas no cambian.**
- Cada telescopio tiene su **muesca** en los rieles (la «chaveta» de Kevin):
  el 200 va **2,8 cm al norte** del centro; un 12" va entre **0,5 y 18,8 cm al
  norte** según el modelo. Una muesca mal puesta 2 mm corre el centro de masa
  1 mm del eje: nada.
- Para diseñar sin saber qué 12" viene, se usa la **envolvente** de los que
  hay: hasta **50 kg** con GoTo, centro de masa entre **50 y 62 cm**, base de
  hasta **70 cm**. Con 25 kg por rodillo, la chapa de 1/4" se marcaría: por eso
  pasa a **5/16"**.
- **Cambiar de telescopio**: aflojar tres mariposas, bajar uno, subir el otro,
  correr las mordazas a sus muescas, apretar. El tiempo no importa (Fran,
  7/10): importa que se haga con herramientas de mano y que la muesca repita.
- **El que era el único rojo, cerrado (versión 7):** un 12" liviano con el
  centro de masa bajo aguantaba 5,5 kg de empujón en la boca del tubo, contra
  los 6 del dobson solo. Con los rodillos a **58 cm** y la base a **1,3 m**
  aguanta 6,1 a 6,3, y ningún telescopio de la envolvente vuelca antes de
  22°. Un lastre no lo arreglaba (corre la muesca al norte y el margen se
  achica igual). El dibujo está en el Doc 3.
- **Las chapas ya no esperan al vuelco:** la corredera pone sobre el eje
  cualquier 200 con el centro de masa entre 55 y 69 cm, así que el vuelco
  confirma las chapas, no las cambia. Igual no se cortan antes de la prueba de
  foco.

## El dobson no se agujerea: tres mordazas de borde

Fran: «el dobson no se agujerea de ser posible; quizás sea mejor algo
adaptable». Cada mordaza es un carro que corre por su riel y se traba en la
muesca con un bulón y una mariposa. Lleva una **pestaña** que pisa el borde de
la base (no se puede levantar) y un **tornillo de mano con almohadilla de
goma** que aprieta de costado. Acá la goma sí va: no está en la transmisión.

Son **tres**, como las patas: no renguean. En el 200, una al medio del lado
norte y dos en las esquinas del sur. En un 12" redondo, la del norte y dos que
lo toman a los costados del sur. Falta probar con la mesa inclinada a mano
(10,5°, el final de la carrera) que aguantan.

## Los conceptos en competencia, con puntaje

Para discutir entre Fran y Kevin. Hay **tres decisiones** con alternativas
reales: cómo se apoya la plataforma, cómo lleva dos telescopios y cómo se
mueve. En cada una van las alternativas, lo que juega a favor y en contra, el
puntaje y **quién va ganando hasta ahora**.

**Cómo se puntúa** (es el método de NASA para un *trade study*, y se puede
discutir punto por punto):

- **Los criterios se escriben antes de puntuar**, y **los pesos los pone
  Fran**, con su frase como fuente. La sesión no elige qué importa más.
- **Los puntajes van de 1 (malo) a 5 (muy bueno)** y los pone la sesión, cada
  uno con su porqué. **Es lo que más se presta a discutir:** si Kevin ve un 3
  donde va un 5, se cambia y se recalcula.
- **Lo que es requisito no se pesa: es un piso.** Una alternativa que no llega
  a la precisión pedida queda afuera antes de puntuar, aunque sea barata.
- **Si dos alternativas empatan, el problema está en los criterios**, no en
  las alternativas: hay que buscar el dato que las separa.

### 1. Cómo se apoya la plataforma: CS o VNS — decidido: VNS

**Pesos de Fran (4/10):** que ande en cualquier piso sin renegar con
calibraciones **0,4**; que no sea extremadamente complejo de construir
**0,3**; que aguante el peso **0,2** (deducido del orden: Fran no lo nombró);
costo **0,1** («si puedo gastar más plata en algo, no importa»).

| | CS (segmentos circulares, el diseño de agosto) | **VNS** (pivote al norte y dos rodillos) |
|---|---|---|
| **A favor** | el perfil se traza con un piolín; base corta (≈ 0,7 m) | apoya en **tres puntos**: no renguea en ningún piso; rodillos **horizontales** y motor simple; Vogel lleva 45 kg medidos en una |
| **En contra** | apoya en **cuatro** (renguea); los rodillos van inclinados a la latitud y esa inclinación hay que clavarla; es la que menos peso aguanta | la chapa necesita plantilla impresa; base larga (1,17 m con el poste); la velocidad varía ±0,5 % y la corrige el programa |
| Que ande sin renegar (0,4) | 2 | 5 |
| Facilidad (0,3) | 3 | 4 |
| Peso (0,2) | 3 | 5 |
| Costo (0,1) | 4 | 3 |
| **Total** | **2,7** | **4,5** |

**Gana VNS por 1,8.** No depende del orden de los criterios: aun poniendo el
costo en segundo lugar, VNS saca 4,2 contra 2,9. Fran lo eligió directamente
el 4/10, antes de la cuenta, y la cuenta coincide.

### 2. Cómo lleva el 200 y un 12": cuatro maneras — va ganando: la mesa universal (U1)

Los mismos pesos de Fran. Hay un quinto criterio, **cuánto cuesta cambiar de
telescopio**, y Fran le puso **peso cero**: «no importa el tiempo de pasar del
200 al otro» (7/10). Lo que sí importa es que se haga con herramientas de mano
y **sin perder precisión**, y eso es un piso.

| | U0: otra plataforma para el 12" | **U1: mesa universal con corredera** | U2: una placa por telescopio | U3: corredera en el pivote (idea de Kevin) |
|---|---|---|---|---|
| **Qué es** | para el 12" se cortan otras chapas y otra mesa | chapas, rodillos y motor únicos; el dobson se corre norte-sur sobre rieles hasta **su muesca** y lo toman tres mordazas | U1 pero cada telescopio trae su placa, que se abulona en un lugar fijo | el ajuste se hace corriendo el pivote |
| **A favor** | el 200 queda óptimo; cada una aguanta justo lo suyo | **un solo juego de chapas**; la muesca repite la posición (2 mm de error = 1 mm del eje); no se agujerea nada | la posición queda fija «de fábrica» | se ajusta en un solo lugar |
| **En contra** | **dos cortes láser** de la pieza cara; cambiar es desarmar y volver a alinear | mesa más grande (≈ 87 cm, ≈ 11 kg); para que el 12" liviano no levante la mesa, rodillos a 58 cm y base de 1,3 m (versión 7) | para no agujerear el dobson la placa necesita sus propias mordazas (es U1 con una pieza más); la del 12" se hace cuando exista | **no cumple:** correr el pivote desalinea el eje polar. Queda sólo como ajuste fino de armado (±1 cm) |
| Que ande sin renegar (0,4) | 3 | 4 | 4 | — |
| Facilidad (0,3) | 2 | 4 | 3 | — |
| Peso (0,2) | 5 | 4 | 4 | — |
| Costo (0,1) | 2 | 4 | 3 | — |
| **Total** | **3,0** | **4,0** | **3,6** | **afuera por el piso** |
| Cambiar de telescopio (peso 0) | 1 | 4 | 4 | — |

**Va ganando U1 por 0,4 sobre U2.** Fran la eligió el 7/10 («correr y
apretar») y la cuenta coincide. La diferencia con U2 sale de no agujerear: con
esa condición, la placa de U2 no ahorra nada y suma una pieza por telescopio.
**Para discutir con Kevin:** si en el taller los rieles con muesca le parecen
más difíciles que lo que puse (4), U1 y U2 se acercan.

### 3. Cómo se mueve la mesa: la transmisión — va ganando T2 (versión 7)

> **Lo que cambió el 8/10 a la noche.** Faltaba un error en la cuenta: el
> **micropaso**. Un motor paso a paso cae en cada paso entero con hasta ±5 %
> de error (hoja de datos), y el micropaso no lo arregla. Ese error se repite
> cada pocos segundos: adentro de una foto **estira la estrella**. Con la F de
> una correa, cada paso entero mueve ≈ 34″ el cielo y la estrella sale con
> redondez 0,66 (la foto pide 0,8): **la F de una correa no pasa el piso**.
> Pasan la F con **dos** correas (F2: 8,4″ por paso) y la V con tornillo de
> bolas (T2: 5 a 7″, como una montura comercial). Puntuando F2 contra T2 con
> los mismos criterios y tu orden, **gana T2 por 15 a 21 % con los tres
> métodos**, y sigue ganando aunque el banco diga que el rodillo no patina.
> Las cuentas, los dibujos y cómo medir el error del motor en una tarde con un
> puntero láser están en el **Doc 3**. Lo de abajo es la cuenta de la versión
> 6, que queda para ver de dónde venía.

El canto de la chapa avanza **54 milésimas de milímetro por segundo**. Lo que
cuenta es el error que se repite **adentro de una foto de 60 s** (Fran,
8/10): si dura menos que la foto, la estrella sale ovalada y no hay programa
que lo arregle. Si tarda más, el programa lo corrige con una tabla medida una
noche con la cámara (la corrección periódica, PEC).

**Primer filtro, el piso de precisión** (≤ 1,5″ por foto para la
plataforma, requisito L2-PLT-02):

| | Qué es | Cada cuánto repite su error | ¿Pasa el piso? |
|---|---|---|---|
| **B** | correa dentada pegada al canto (Kevin) | cada diente, **37 s**: adentro de cada foto | **no**: 5 milésimas de ondulación son 1,4″, todo el margen, y no se corrigen |
| **T** | varilla roscada común con brazo (Kevin) | cada vuelta, 2 a 4 min | **no**: la varilla de ferretería tiene el paso desparejo y alabeada, y eso no se repite igual: no se corrige |
| **T2** | tornillo de bolas comprado (paso 8 mm) con guía lineal y biela | cada vuelta, ≈ 2,4 a 3,7 min | **sí, con PEC** |
| **F** | rodillo de acero torneado por fricción + correa GT2 4:1 | polea de 20 cada ≈ 8 min; rodillo cada ≈ 31 min | **sí, con PEC** |

**La opción 2 del modelo (V, la de la foto de Fran) es la familia T:** con
varilla común es T y no pasa; con tornillo de bolas o un tornillo trapezoidal
bueno es T2 y pasa. Cuál es la de la foto se sabe con las medidas (el paso y
la tuerca). En la geometría del modelo el brazo empuja a 77 cm del eje: cada
error de la varilla pesa un tercio menos que a 50 cm, pero se repite más
seguido (cada ≈ 2,4 min con paso 8), siempre más lento que una foto.

**Segundo paso, entre las que pasan. Pesos de Fran** (8/10: «precisión > que
no patine > facilidad > costo»; el orden se pasa a pesos con el método ROC):

| | **F** (rodillo y correa) | **T2 / V con tornillo bueno** (varilla y biela) |
|---|---|---|
| **A favor** | ningún diente; su error es lento y atado a la posición del motor, así que la PEC lo saca casi entero; si algo se traba, **patina antes de romper**; piezas baratas | empuja con rosca: **no patina**, la posición se sabe siempre; se compra hecho (tornillo, guía, soportes) |
| **En contra** | **puede patinar** si el centro de masa queda mal (agarra ≈ 25 N y hace falta empujar 2 a 4 N); pide un rodillo torneado de ≤ 0,02 mm de descentrado y alinearlo con el canto | la biela con dos rótulas mete juego que hay que precargar con un resorte; el brazo va en arco y la tuerca derecho (±2,8 % de velocidad, que corrige el programa); más piezas que alinear; ocupa 34 cm al sur de la viga |
| Precisión (0,52) | 4 | 3 |
| Que no patine (0,27) | 3 | 5 |
| Facilidad (0,15) | 3 | 3 |
| Costo (0,06) | 4 | 3 |
| **Total** | **3,58** | **3,54** |

**Empatan:** F gana por 1 % con este método, y con otros dos métodos
estándar gana una o la otra por 1 a 3 %. Como dice el método, el empate no se
discute: **se mide**. Lo único que separa a las dos es si F patina, y eso lo
contesta el **banco del rodillo**:

- si F **no patina** con el doble del empuje del peor caso, su «no patina»
  sube a 4 y **gana F** con cualquier método (por 0,2 a 0,36);
- si **patina**, baja a 2 y **gana T2**: la varilla de la foto, con tornillo
  de bolas de paso 8.

Con 60 s por foto, la corrección periódica va en cualquiera de las dos.

### El mejor postor hasta ahora

| Decisión | Va ganando | Puntaje | Qué falta para cerrarla |
|---|---|---|---|
| Cómo se apoya | **VNS** | 4,5 contra 2,7 | nada: decidida |
| Cómo lleva dos telescopios | **U1, mesa universal** con corredera, muescas y tres mordazas | 4,0 contra 3,6 | que Kevin revise la facilidad de los rieles; probar que las mordazas aguantan la mesa inclinada 10,5° |
| Cómo se mueve | **T2**: la V de la foto con tornillo de bolas (SFU1605 o SFU1204), carro, biela y PEC | ≈ 4,0 contra ≈ 3,4 de la F con dos correas (la de una correa no pasa el piso) | decidirlo en su nivel (la V de NASA), con Fran; medir el error del motor con la palanca óptica (Doc 3) |

**Para charlar con Kevin:**

1. ¿Algún puntaje le parece mal? Sobre todo los de **facilidad**, que son de
   taller: rieles con muesca (U1), rodillo torneado y alineado (F), guía
   lineal y biela (T2).
2. ¿Su torno da un rodillo de 32 mm con **≤ 0,02 mm** de descentrado? Si no
   da, F pierde un punto de precisión y gana T2.
3. ¿La varilla de la foto es de **bolas**, **trapezoidal** o **común**? Con
   bolas o trapezoidal buena es T2; común no pasa el piso.
4. Para el **banco del rodillo**: ¿se puede armar con la chapa de prueba y el
   motor, antes de cortar las chapas definitivas? (Versión 7: con T2 al frente
   pierde peso; el que suma es el **banco de la palanca óptica**: el motor, un
   espejito y un puntero láser contra una pared a 2 m. Está en el Doc 3.)
5. (Versión 7) ¿Conocés algún láser que corte **acero de 8 mm**? No todos:
   en la zona hay que llegan a 4,7. La lista está en el Doc 3.

Esto es el **concepto**. Cuando se cierre (el centro de masa medido y la
prueba de foco), la elección final de la transmisión se hace en el **diseño**,
bajando desde los requisitos como pide la V de NASA, con su plan de
verificación (cómo se prueba cada cosa) y su plan de implementación (cómo se
construye).

## Lo que dijo Kevin

| Kevin dijo | Qué se decidió |
|---|---|
| Base cuadrada y más grande | **Triángulo, pero ancho: 1,3 m** desde la versión 7 (era 1,2). De costado aguanta lo mismo que al sur; una cuadrada renguea con cuatro patas |
| Fijar el dobson con bujes, tornillos y mariposas | **La idea de apretar a mano queda; los agujeros no** (7/10, Fran): tres mordazas de borde con mariposa |
| Corredera con mariposa en el pivote → plataforma universal | **La idea sí, el lugar no.** En el pivote desalinea el eje; donde ajusta el centro de masa es **debajo del dobson**. En el pivote queda como ajuste fino de armado (±1 cm) |
| La muesca tipo chaveta: que la fuerza la lleve la planchuela | **Sí**: son las muescas de la corredera, una por telescopio |
| Que sea de acero | **Sí**: chapas de acero dulce SAE 1010/1020 (el inoxidable no aguanta más y cuesta varias veces más; su ventaja es que no se oxida) |
| ¿Qué espesor corta el láser y cuánto sale? | **5/16" (8 mm), y no lo corta cualquiera** (versión 7): en la zona hay talleres que dicen 9 mm o 1/2" y otros que llegan a 4,7. Lista y qué preguntar en el Doc 3. Se cotiza con el DXF de la fase 3 |
| Topes para el motor | **Ya estaban** (las tres capas) |
| Patas con tuercas para nivelar | **Ya estaban** |
| Pantalla con el tiempo y Bluetooth | **Se puede** con el ESP32. Se decide cuando la plataforma siga una estrella |
| Correa dentada sobre el canto | **Alternativa B**, puntuada arriba: repite cada 37 s, adentro de la foto |
| Varilla roscada que cubre el recorrido | **Alternativa T.** El rebobinado no la separa de nadie: todas rebobinan al final de los 90 min |
| Rodillo de goma, o el canto forrado con goma | **No** (Fran: «la elasticidad nos caga»). Aun dura, con 20 kg se aplasta y queda una panza: error de velocidad. Resbalar no es el problema: acero sobre acero agarra 6 veces lo que hace falta |
| Que un tornero haga la rosca, como la plataforma de la foto | **No conviene la rosca torneada**: copia el error del tornillo del torno y no le gana a un tornillo de bolas comprado (T2). Donde el tornero sí da precisión es en el **rodillo de la F** |

## Soldar o abulonar

- **Soldar:** el marco de la mesa, los rieles sobre los largueros, el brazo,
  los lados de la base, las cartelas, el poste y las orejas.
- **Abulonar** (M8 clase 8.8, arandela ancha y tuerca autofrenante): la viga
  sur de la base (así entra en el baúl), las unidades de rodillo (en ranura),
  las chapas (agujero ovalado para emparejar las alturas) y las mordazas (con
  mariposa).
- El tubo de pared fina **se alabea y se perfora con el calor**: punteá, soldá
  a tramos cortos alternando lados, y medí después (las diagonales de la mesa
  iguales ±2 mm).

## Qué se compra

Nada hasta que lo diga «2 - Paso a paso», salvo lo del banco.

| Qué | Precio |
|---|---|
| Motor NEMA 17 de ≈ 4 kg·cm (Usongshine 17HS4401) + driver TMC2209 + ESP32 | ≈ $24.640 el motor + a cotizar (**se pueden comprar ya**: sirven para el banco) |
| Poleas GT2 de 20 y 80 + correa cerrada | a cotizar |
| Corte láser de las dos chapas de acero de 5/16" | a cotizar con el DXF (**no antes de medir el centro de masa y la prueba de foco**) |
| Rodillo motriz torneado | el amigo, o una tornería |
| Rótula de amortiguador, bulones M8 y M10, mariposas, almohadillas de goma para las mordazas | ferretería, a cotizar |
| Caja estanca, botón, ficha ST-4 (RJ12), batería | casas de electrónica; la batería, después del banco |
| Tubo 20 × 20, planchuela, ángulo, rulemanes de roller, varillas de impresora, soldadora, fuente 12 V | **ya hay** |

## Lo que no se hace

- No se corta ni se suelda nada antes de medir el centro de masa.
- No se agujerea ningún dobson, ni el 200 ni el 12".
- No se le saca madera a la montura: primero se mueve el tubo o el dobson.
- No se deja el telescopio andando solo hasta probar las tres capas de tope.
- No va plástico donde hay peso: ni rodillos ni soportes impresos.

## Aparcado: la cámara y el foco

A pedido de Fran quedan afuera por ahora. Una sola cosa queda pendiente y pesa:
**¿el telescopio llega a foco con la cámara?** Son 10 minutos de día y es lo
único que, si sale mal, tira la meta de la foto. Por eso **antes de mandar a
cortar las chapas se cierra**.
