# El proyecto — qué es y por qué así

**Para Fran y Kevin.** Versión 4, 7 de octubre de 2026. Fuente en el repo:
`proyectos/ingenieria/telescopio/docs/07-guia-armado.md`.

> **Este documento es el concepto. Los pasos, en orden, están en «2 - Paso a
> paso».** Los números finos (cuentas, medidas, protocolo) están en la
> subcarpeta **Archivo**: no hace falta leerlos para avanzar.

**Modelo 3D, versión 9** (se mueve y se rehace si cambiás un número; trae los
dibujos de cómo medir el centro de masa):
https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd
(el link viejo, `K4hfyQRik4xsJYYXv5sFeM`, quedó en la versión 8).

## Qué vamos a hacer

El cielo gira. Con el telescopio quieto, una foto de 30 segundos sale con las
estrellas hechas rayitas. Vamos a construir una **plataforma ecuatorial**: una
mesa baja que va debajo del dobson entero y lo hace girar despacito, a la
velocidad del cielo, durante unos 90 minutos. Después se «rebobina» y se sigue.
El dobson se apunta a mano como siempre.

Diseño elegido: **VNS**. Apoya en **tres puntos** (un pivote y dos rodillos),
así que no renguea en ningún piso.

## El diseño en una tabla

| Parte | Cómo es | Por qué |
|---|---|---|
| **Base al piso** | triángulo de **tubo 20 × 20**, ≈ 1,2 m de largo y 1,2 m de ancho, tres patas M10 regulables. El lado sur lleva los rodillos: tubo + planchuela de 30 de canto abajo | tres patas nunca renguean; la viga de los rodillos es la única que trabaja de verdad |
| **Mesa móvil** | **tubo 20 × 20 en H** (travesaño sur, dos largueros ranurados, travesaño norte) + **brazo en A** hasta el pivote, con planchuela de 40 de canto abajo | menos piezas que el marco con lados, y el brazo en voladizo no se dobla (0,1 mm) |
| **Pivote** | rótula de amortiguador a gas (la del portón del baúl) sobre un poste corto con la tapa abulonada | cero juego |
| **Dos chapas** | **acero de 1/4"**, cortadas a **láser**, colgadas del travesaño sur con tres M8 cada una | su canto es la pista por donde ruedan los rodillos: **su forma depende del centro de masa** |
| **Rodillo loco (este)** | **cuatro rulemanes 608 de roller** sobre una **varilla de impresora** | rescatado, y más redondo que cualquier cosa torneada en casa |
| **Rodillo motriz (oeste)** | **acero torneado** 32 × 30, fijo a un eje de 8 mm que gira en dos 608 | es la otra pieza de precisión: su redondez es el error que se repite |
| **Motor** | NEMA 17 de ≈ 4 kg·cm + driver TMC2209 + **ESP32**, correa GT2 4:1 | tiene que ser paso a paso; el ESP32 es lo que va a pedir la pantalla y el Bluetooth |
| **Eje** | a unos **54 cm** sobre la mesa | la mesa gira con el telescopio, así que su peso entra en la cuenta |
| **Topes** | tres capas: programa (±45 min), fin de carrera (±48) y talón de la chapa (±51) | que la chapa nunca se salga del rodillo |

## Dos piezas de precisión, y el resto herrería

Todo es hierro común, salvo **dos piezas**: el **canto de las chapas** (se
cortan a láser y se lijan con un taco largo, nunca con lima a mano) y el
**rodillo motriz** (torno). Ahí va la plata y el cuidado. Lo rescatado entra
donde no suma error: rulemanes, varillas, microswitches, la fuente.
**Engranajes y correas de goma de las caseteras no van en la transmisión**:
suman juego y estiramiento justo donde se mide la estrella.

## Lo que dijo Kevin

| Kevin dijo | Qué se decidió |
|---|---|
| Base cuadrada y más grande | **Triángulo, pero de 1,2 m de ancho.** De costado aguanta lo mismo que al sur; una cuadrada no mejora el sur y renguea con cuatro patas |
| Fijar el dobson con bujes, tornillos y mariposas | **Sí.** Ranuras en los largueros + bulón M8 + buje + mariposa |
| Topes para el motor | **Ya estaban** (las tres capas). Mejora para más adelante: que el fin de carrera corte el driver por cable |
| Pantalla con el tiempo y Bluetooth | **Se puede** con el ESP32, que ya entra desde el arranque. Se decide cuando la plataforma siga una estrella |
| Rodillo de poliuretano, varilla roscada con tuerca | **No.** El poliuretano se aplasta con el peso; la varilla repite su error cada minuto, que es lo que dura una foto |

## Soldar o abulonar

- **Soldar:** la H de la mesa y el brazo, los lados de la base, las cartelas,
  el poste y las orejas donde van los bulones.
- **Abulonar** (M8 clase 8.8, arandela ancha y tuerca autofrenante): la viga
  sur de la base (así entra en el baúl), las unidades de rodillo (en ranura,
  para alinearlas y correrlas), las chapas (agujero ovalado para emparejar las
  alturas) y el dobson.
- El tubo de pared fina **se alabea y se perfora con el calor**: punteá, soldá
  a tramos cortos alternando lados, y medí después (las diagonales de la mesa
  iguales ±2 mm).

## Un 12" el día de mañana

No se diseña hoy para un telescopio que no existe. Pero quedan tres puertas
abiertas que no cuestan nada: los rodillos se corren sobre la viga, el poste
se cambia, y el núcleo aguanta 60 kg. Para otro telescopio se rehacen **las
dos chapas y la mesa**; base, rodillos, motor y electrónica se reusan.

## Qué se compra

Nada hasta que lo diga «2 - Paso a paso», salvo lo del banco.

| Qué | Precio |
|---|---|
| Motor NEMA 17 de ≈ 4 kg·cm (Usongshine 17HS4401) + driver TMC2209 + ESP32 | ≈ $24.640 el motor + a cotizar (**se pueden comprar ya**: sirven para el banco) |
| Poleas GT2 de 20 y 80 + correa cerrada | a cotizar |
| Corte láser de las dos chapas de acero de 1/4" | a cotizar con el DXF (**no antes de medir el centro de masa y la prueba de foco**) |
| Rodillo motriz torneado | el amigo, o una tornería |
| Rótula de amortiguador, bulones M8 y M10, mariposas | ferretería, a cotizar |
| Tubo 20 × 20, planchuela, ángulo, rulemanes de roller, varillas de impresora, soldadora, fuente 12 V | **ya hay** |

## Lo que no se hace

- No se corta ni se suelda nada antes de medir el centro de masa.
- No se le saca madera a la montura: primero se mueve el tubo o el dobson.
- No se deja el telescopio andando solo hasta probar las tres capas de tope.
- No va plástico donde hay peso: ni rodillos ni soportes impresos.

## Aparcado: la cámara y el foco

A pedido de Fran quedan afuera por ahora. Una sola cosa queda pendiente y pesa:
**¿el telescopio llega a foco con la cámara?** Son 10 minutos de día y es lo
único que, si sale mal, tira la meta de la foto. Por eso **antes de mandar a
cortar las chapas se cierra**.
