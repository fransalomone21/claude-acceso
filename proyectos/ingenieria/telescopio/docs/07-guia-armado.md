# El proyecto — qué es y por qué así

**Para Fran y Kevin.** Versión 5, 7 de octubre de 2026. Fuente en el repo:
`proyectos/ingenieria/telescopio/docs/07-guia-armado.md`.

> **Este documento es el concepto. Los pasos, en orden, están en «2 - Paso a
> paso».** Los números finos (cuentas, medidas, protocolo) están en la
> subcarpeta **Archivo**: no hace falta leerlos para avanzar.

**Modelo 3D, versión 10: la plataforma «terminada», con el 200 o con un 12"
arriba** (se mueve y se rehace si cambiás un número; tildá «pintar por
certeza» para ver de qué estamos seguros):
https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd — se abre con el link,
sin cuenta (medido el 7/10).

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
| **Base al piso** | triángulo de **tubo 20 × 20**, ≈ 1,2 m de largo y 1,2 m de ancho, tres patas M10 regulables con su marca en el piso. El lado sur lleva los rodillos, la electrónica y la batería | probable |
| **Mesa universal** | marco de tubo 20 × 20 (travesaño sur, travesaño norte, **tres largueros**, brazo en A hasta el pivote) con **tres rieles** soldados arriba: ahí apoya el dobson y corren las mordazas. ≈ 87 cm de norte a sur, ≈ 11 kg con las chapas | en revisión |
| **Corredera** | el dobson se corre norte-sur sobre los rieles hasta **su muesca**: una por telescopio | en revisión |
| **Tres mordazas de borde** | toman la base del dobson del borde: **no se agujerea nada** | en revisión |
| **Pivote** | rótula de amortiguador a gas sobre un poste de 10 cm | probable |
| **Dos chapas** | **acero de 5/16"**, cortadas a **láser**, colgadas del travesaño sur. Las mismas para los dos telescopios. **Su forma depende del centro de masa** | en revisión |
| **Rodillo loco (este)** | cuatro rulemanes 608 de roller sobre una varilla de impresora | probable |
| **Transmisión (oeste)** | **F**: rodillo de acero torneado por fricción + correa GT2 4:1 + NEMA 17 de ≈ 4 kg·cm | en revisión |
| **Electrónica** | ESP32 + TMC2209 en una caja sobre la viga sur, botón de rebobinado, ficha ST-4 para el autoguiado de más adelante, batería | probable |
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
  correr las mordazas a sus muescas, apretar. Hoy el papel dice 15 minutos: lo
  confirma Fran.
- **El único rojo** de la cuenta: un 12" liviano con el centro de masa bajo
  aguanta 5,5 kg de empujón en la boca del tubo, contra los 6 del dobson solo.
  Se arregla separando los rodillos a 58 cm y abriendo la base a 1,3 m; se
  decide con el 12" que se compre.

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

## La transmisión: la propuesta y su respaldo

El canto de la chapa avanza **54 milésimas de milímetro por segundo**. Lo que
importa es el error que se repite **adentro de una foto**, porque ese no se
corrige y deja la estrella ovalada.

| | Qué es | Cada cuánto repite su error | Qué pasa |
|---|---|---|---|
| **F** (propuesta) | rodillo de acero torneado por fricción + correa GT2 4:1 | ≈ 8 min y ≈ 31 min | **más lento que la foto**: se ve como deriva suave y se calibra. Si algo se traba, patina antes de romper |
| B | correa dentada pegada al canto (Kevin) | 37 s | un diente por foto: 5 milésimas de ondulación ya se comen todo el margen |
| T | varilla roscada con brazo (Kevin) | 2-4 min | la varilla común tiene alabeo |
| **T2** (respaldo) | tornillo de bolas comprado, paso 5 u 8 mm | 2,3 a 3,7 min | parejo y sin juego; con paso 2 caería adentro de la foto |

**Propuesta: F, con T2 de respaldo** si el rodillo patina en el banco. Se
cierra cuando Fran (con Kevin) elija **30 o 60 segundos por foto**.

## Lo que dijo Kevin

| Kevin dijo | Qué se decidió |
|---|---|
| Base cuadrada y más grande | **Triángulo, pero de 1,2 m de ancho.** De costado aguanta lo mismo que al sur; una cuadrada renguea con cuatro patas |
| Fijar el dobson con bujes, tornillos y mariposas | **La idea de apretar a mano queda; los agujeros no** (7/10, Fran): tres mordazas de borde con mariposa |
| Corredera con mariposa en el pivote → plataforma universal | **La idea sí, el lugar no.** En el pivote desalinea el eje; donde ajusta el centro de masa es **debajo del dobson**. En el pivote queda como ajuste fino de armado (±1 cm) |
| La muesca tipo chaveta: que la fuerza la lleve la planchuela | **Sí**: son las muescas de la corredera, una por telescopio |
| Que sea de acero | **Sí**: chapas de acero dulce SAE 1010/1020 (el inoxidable no aguanta más y cuesta varias veces más; su ventaja es que no se oxida) |
| ¿Qué espesor corta el láser y cuánto sale? | **5/16"** lo corta cualquier láser de fibra; se cotiza con el DXF, que sale del centro de masa medido |
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
