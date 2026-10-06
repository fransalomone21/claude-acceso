# El proyecto — qué es y por qué así

**Para Fran y Kevin.** Versión 3 (simplificada), 5 de octubre de 2026. Fuente
en el repo: `proyectos/ingenieria/telescopio/docs/07-guia-armado.md`.

> **Este documento es el concepto. Los pasos, en orden, están en «2 - Paso a
> paso».** Los números finos (cuentas de estabilidad, medidas, protocolo) están
> en la subcarpeta **Archivo**: no hace falta leerlos para avanzar.

**Modelo 3D** (se mueve y se rehace si cambiás un número):
https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM

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
| **Base al piso** | triángulo de planchuela de hierro de canto, **1,16 m de largo y 1,2 m de ancho**, tres patas regulables | tres patas nunca renguean; a 1,2 m de ancho aguanta lo mismo que una cuadrada enorme |
| **Mesa móvil** | marco de planchuela con dos largueros ranurados donde apoya el dobson, y un brazo en A hasta el pivote | el hierro no se dobla (la madera se doblaba 8 mm; el hierro, 0,3) |
| **Pivote** | rótula de amortiguador a gas (la del portón del baúl, no la de suspensión) sobre un poste de 10 cm | cero juego |
| **Dos chapas de aluminio** | de 5 mm, paradas, bajo la mesa; su borde es el camino por donde ruedan los rodillos | es lo único «difícil»: **su forma depende del centro de masa** |
| **Dos rodillos** | cilindros impresos de 32 mm con dos rulemanes 608ZZ cada uno | uno lo mueve el motor |
| **Motor** | NEMA 17 de unos **4 kg·cm** + driver TMC2209 + Arduino Nano, con correa 4:1 | tiene que ser paso a paso (los de casetera e impresora son de continua) |
| **Eje** | a unos **54 cm** sobre la mesa | la mesa gira con el telescopio, así que su peso entra en la cuenta |
| **Topes** | tres capas: programa (±45 min), fin de carrera (±48) y talón de la chapa (±51) | que la chapa nunca se salga del rodillo |

## Lo que dijo Kevin

| Kevin dijo | Qué se decidió |
|---|---|
| Base cuadrada y más grande | **Triángulo, pero de 1,2 m de ancho.** De costado el vuelco pasa de 17,8° a 25°. Una cuadrada no mejora el borde del sur, renguea con cuatro patas y gasta casi 1 m más de planchuela. Con 10 kg de lastre abajo queda todavía más firme |
| Fijar el dobson con bujes, tornillos y mariposas | **Sí.** Ranuras en los largueros + bulón M8 + buje + mariposa. Además sirven para centrar el centro de masa sin cortar madera |
| Topes para el motor | **Ya estaban** (las tres capas). Mejora para más adelante: que el fin de carrera corte el driver por cable, y que sean contactos normalmente cerrados |
| Pantalla con el tiempo y Bluetooth | **Se puede** (con un ESP32). Se decide más adelante, cuando la plataforma ya siga una estrella. De noche la pantalla tiene que ser roja o muy tenue |

## Soldar o abulonar

- **Soldar:** marco de la mesa, brazo, cartelas, el triángulo de la base y el poste.
- **Abulonar** (M8 con arandela y tuerca autofrenante): el travesaño del sur
  (así la base desarmada entra en el baúl), los soportes de los rodillos (con
  ranuras, para alinearlos), el aluminio y el dobson.
- La planchuela fina **se alabea con el calor**: punteá, soldá a tramos cortos
  alternando lados, y medí después (las diagonales de la mesa iguales ±2 mm).

## El motor

Tiene que vencer el rozamiento del pivote y el viento. Una ráfaga de 40 km/h
pide unos 0,6 kg·cm al motor (estimación mía). Con eso:

| Motor | Torque | Precio | Veredicto |
|---|---|---|---|
| 17HS2408S, 0,6 A (el que pasó Kevin) | 1,6 kg·cm | $18.200 | queda justo con viento: **no** |
| **Usongshine tipo 17HS4401** (Mercado Libre, FULL) | ≈ 4 kg·cm | **$24.640** | **este** (confirmá «17HS4401» en la ficha) |
| ACT Motor 17HS4417 (Marketplace) | ≈ 4 kg·cm | $22.000 | vale lo mismo, pero sin garantía |
| La Costa 3D 4,4 kg·cm | 4,4 kg·cm | $30.200 | el mismo, más caro |

## Qué se compra

Nada hasta que lo diga «2 - Paso a paso», salvo el motor y el driver.

| Qué | Precio |
|---|---|
| Motor NEMA 17 de ≈ 4 kg·cm + driver TMC2209 | ≈ $24.640 + a cotizar (**se pueden comprar ya**) |
| Chapa de aluminio 5 mm, 500 × 500 | $66.193 (**no comprar hasta cerrar la prueba de foco**) |
| Rulemanes 608ZZ, rótula de amortiguador, bulones, mariposas M8, correa GT2 y poleas, 2 microswitches | a cotizar |
| Planchuela de hierro, soldadora, Arduino Nano y fuente 12 V | ya hay |

Se imprime en 3D (Kevin, en PETG): rodillos, soportes y la caja de la electrónica.

## Lo que no se hace

- No se corta ni se suelda nada antes de medir el centro de masa.
- No se le saca madera a la montura: primero se mueve el tubo o el dobson.
- No se deja el telescopio andando solo hasta probar las tres capas de tope.
- Rodillos de acero sobre el aluminio, no.

## Aparcado: la cámara y el foco

A pedido de Fran quedan afuera por ahora. Una sola cosa queda pendiente y pesa:
**¿el telescopio llega a foco con la cámara?** Son 10 minutos de día y es lo
único que, si sale mal, tira la meta de la foto. Por eso **antes de comprar el
aluminio se cierra**. Pregunta para Kevin: cuando miraron Saturno, ¿se veían los
anillos, aunque fueran chiquitos?
