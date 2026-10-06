# El proyecto — concepto y diseño

**Para Fran y Kevin.** Versión 2, 5 de octubre de 2026. La fuente vive en el
repo (`proyectos/ingenieria/telescopio/docs/07-guia-armado.md`); esta copia
está en la carpeta compartida del Drive.

> **Cómo se lee esto.** Este documento es el **concepto**: qué estamos
> haciendo, cómo es cada pieza, por qué está decidido así y qué se compra. Es
> para entender y para consultar. **Los pasos a seguir, en orden, no están
> acá**: están en el otro documento, **«2 - Paso a paso - que hacer y en que
> orden»**. Si querés saber qué hacer mañana, andá a ese. Si querés saber
> *por qué*, quedate en este.

**El modelo 3D**, que se mueve, se gira y se rehace solo si cambiás un número:
https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM (Fran lo comparte desde el
botón Compartir de la página; si no te abre, pedíselo).

---

## 1. Qué vamos a hacer, en dos párrafos

El cielo gira: una vuelta cada 23 h 56 min alrededor de un eje que apunta al
polo sur celeste. Si sacás una foto de 30 segundos con el telescopio quieto,
las estrellas salen como rayitas. El dobson sabe moverse arriba-abajo e
izquierda-derecha, pero el cielo no gira así: gira inclinado. Motorizar los
dos ejes del dobson persigue al objeto pero **no** frena la rotación del campo
(la foto igual sale girada en los bordes).

La solución es una **plataforma ecuatorial**: una mesa baja que se pone debajo
del dobson entero y lo hace girar, despacito, alrededor de un eje paralelo al
de la Tierra. El dobson se apunta a mano como siempre, y la plataforma lo
acompaña unos 90 minutos (45 a cada lado del centro). Después se «rebobina»
(vuelve al principio) y se sigue. Elegimos el diseño **VNS** (de Reiner Vogel):
apoya en tres puntos (un pivote y dos rodillos) y por eso no renguea en ningún
piso, que era el criterio número uno.

## 2. El diseño de una mirada

| Decisión | Qué es | Por qué, en una línea |
|---|---|---|
| **Arquitectura VNS** | tres apoyos: un pivote y dos rodillos que ruedan sobre dos chapas de aluminio | más carga que el otro diseño (CS), apoyo real en tres puntos; elegido con los pesos de Fran |
| **Espejada para el sur** | el pivote va al **norte**, las chapas al **sur** | el eje polar sube hacia el sur; los planos de Vogel son del hemisferio norte |
| **De hierro, no de madera** | planchuelas de 30 a 60 mm, de canto | el brazo de madera se doblaba ≈ 8 mm; en hierro, ≈ 0,3 mm |
| **La mesa gira con el telescopio** | sus ≈ 8 kg entran en el centro de masa de lo que gira | el eje queda a **≈ 54 cm** sobre la mesa, no a 65; ignorarlo mete un torque que cambia de signo a mitad de carrera |
| **Poste del pivote de 10 cm** | un taco, no una columna | la base baja a 1,16 m (entra en un baúl) y la estabilidad casi no cambia |
| **Base al piso: triángulo ancho, 1,2 m** | tres patas, el travesaño del sur abulonado | ver sección 5 |
| **Soldar lo fijo, abulonar lo que se desarma** | marco y triángulo soldados; travesaño, soportes y chapas abulonados | ver sección 5 |
| **Pivote: rótula de amortiguador a gas** | bocha de 10 mm en un cono engrasado | cero juego; la de suspensión de auto no va (ver pieza 3) |
| **Motor: NEMA 17 de ≈ 4 kg·cm** | paso a paso, con reducción 4:1 | motores de continua descartados; ver sección 5 |
| **Límites de carrera en tres capas** | programa, fin de carrera y talón | que la chapa nunca se salga del rodillo |
| **El dobson se fija a la mesa con ranuras y mariposas** | idea de Kevin | corrige el centro de masa sin tocar madera |

## 3. Las piezas, una por una

Los números son los del modelo 3D.

1. **Base al piso.** Un **triángulo de planchuela de hierro de 50 mm, de
   canto**, de pata a pata (idea de Kevin), con un travesaño bajo los rodillos
   y cartelas en las esquinas. No se mueve nunca. Mide unos **1,16 m de largo y
   1,2 m de ancho** en el sur, con el pivote sobre un poste de 10 cm. Todo el
   porqué, con números: sección 5 y `docs/09-estructura-hierro.md`.
2. **Tres patas regulables.** Un bulón M10 con tuerca en cada punta. Tres
   patas nunca renguean (el banquito de ordeñe); cuatro, siempre. Con las
   tuercas se nivela y se retoca la alineación, sin cortar nada.
3. **Pivote norte.** Una rótula de amortiguador a gas (bocha de 10 mm, rosca
   M8) atornillada arriba de un **poste de 10 cm** (caño 40 × 40 o
   planchuelas soldadas, con tres riendas), y arriba, en la punta del brazo
   de la mesa, un hueco cónico donde apoya. Es el único apoyo que no rueda:
   todo gira alrededor de él. **Ojo: la del amortiguador a gas (la del portón
   del baúl), no la de suspensión** (la de parrilla, con brida de tres
   agujeros y espárrago cónico). La de suspensión viene precargada contra una
   cazoleta de plástico para no tener juego en un auto de una tonelada: roza
   más, tiene el espárrago cónico (pide un agujero cónico a medida) y le sobra
   todo. Una bocha de 10 mm suelta en un cono engrasado roza ≈ 0,1 N·m con
   los ≈ 15 kg que carga el pivote; aun una de suspensión (≈ 1 a 3 N·m,
   `hipótesis`) le pediría al motor menos de 0,3 kg·cm: el rozamiento no es el
   problema. Lo que importa en el pivote es **cero juego y que gire parejo**.
   Alternativa si no aparece: un **terminal de rótula M8**.
4. **Mesa móvil.** Un marco de planchuela de 40 de canto con dos largueros
   (ranurados) donde apoya el dobson tal cual está, y el **brazo al pivote en
   A**: dos planchuelas de 50 de canto. **La mesa gira con el telescopio**:
   sus ≈ 8 kg (estimados; el paso 4 los mide) entran en el centro de masa de
   lo que gira.
5. **Las dos chapas de aluminio (los segmentos).** Las únicas piezas de
   aluminio: 5 mm de espesor, paradas, atornilladas al marco sur de la mesa.
   Su borde de abajo es un pedazo de elipse y cada una va girada unos 9°. Esa
   forma es lo único «difícil» del diseño, y se resuelve imprimiendo la
   **plantilla 1:1 en papel**, pegándola y calando alrededor. Miden unos
   **357 × 107 mm** cada una (las dos salen de una chapa de 500 × 500).
   **Su forma depende del centro de masa**: por eso no se corta nada antes de
   medirlo.
6. **Rodillos.** Un cilindro impreso de 32 mm de diámetro y 26 de ancho, con
   un rulemán 608ZZ (los de skate) a presión en cada cara, girando sobre un
   bulón M8. El canto de cada chapa apoya y rueda sobre uno. Cada rodillo
   carga unos 17 kg y el pivote unos 15 (40 kg de telescopio más 8 de mesa de
   hierro, poste de 10 cm).
7. **Motor.** Un paso a paso NEMA 17 con polea GT2 de 20 dientes y correa
   hasta una polea de 80 en el eje del rodillo oeste (reduce 4 a 1). El
   rodillo da unas dos vueltas por hora y cada micropaso mueve la mesa unos 2
   segundos de arco. Lo maneja un Arduino Nano con un driver TMC2209
   (silencioso y suave, justo para movimientos lentos). **Tiene que ser paso a
   paso:** los motores de casetera y de impresora que aparecieron son de
   continua, y un motor de continua sin encoder no sabe cuánto giró. El paso a
   paso cuenta pasos: gira exactamente lo que se le manda.
8. **El eje polar.** No es una pieza: es la línea imaginaria alrededor de la
   que gira la mesa. Pasa por el pivote, sube hacia el sur a **34,5°** (la
   latitud de Villa Adelina) y apunta al polo sur celeste.
9. **Centro de masa.** El punto donde «se concentra» el peso. Tiene que caer
   **sobre** el eje: si queda corrido, el peso tironea para un lado y el motor
   pelea. Hoy: unos **63 cm** sobre el piso del dobson, con una duda de ±5 cm
   que cierra el paso 2.
10. **Polo sur celeste.** En el sur no hay estrella polar: la más cercana,
    σ Octantis, es apenas visible a ojo. Se alinea una vez con el método de
    deriva (mirando cómo se escapa una estrella) y se marcan las tres patas en
    el piso del patio.
11. **El dobson actual.** Se sube entero a la mesa.
12. **Suplementos.** Tablitas debajo del dobson para subir el centro de masa
    hasta el eje si sale más bajo de lo calculado. Se corrige apilando madera,
    no cortando aluminio.
13. **Finales de carrera.** Dos microswitches con palanca, uno por punta, en un
    soporte impreso al costado del rodillo este. Un tornillo M5 clavado en el
    medio de la chapa hace de leva: si la mesa se pasa 3 minutos del final, la
    leva aprieta la palanca y el Arduino corta el motor.
14. **Talones.** Cada chapa termina en un «diente» que cuelga 12 mm por debajo
    del borde, con goma pegada. Si falla todo lo demás, el talón choca contra
    el rodillo y la mesa se queda ahí, en vez de que la chapa se salga del
    rodillo y el telescopio se venga abajo.

### Los límites de carrera, en tres capas

Que la chapa se salga del rodillo es el peor accidente posible: unos 40 kg de
telescopio cayéndose de costado. Por eso no hay un límite, hay tres:

| Capa | Qué la frena | Dónde | Si falla… |
|---|---|---|---|
| 1. Programa | el Arduino cuenta pasos y para | a los ±45 min | …sigue la capa 2 |
| 2. Fin de carrera | la leva aprieta el switch y el Arduino corta el motor | a los ±48 min (unos 10 mm después) | …sigue la capa 3 |
| 3. Talón | el diente de la chapa choca el rodillo | a los ±51 min (otros 10 mm) | no falla: es aluminio |

**Una trampa que le encontramos al diseño (2026-10-05):** las capas 1 y 2 las
ejecuta **el mismo Arduino**. Si el programa se cuelga o se va de mambo, es
probable que se caigan las dos juntas, y sólo queda el talón. Mejora para la
fase 3: que el switch **corte la habilitación del driver por cable**, sin
pasar por el programa. Y los switches van **normalmente cerrados**: si se
corta un cable, la mesa se frena sola (el sistema se apaga ante la duda, no
sigue ante la duda).

## 4. Lo que dijo Kevin (2026-10-05), y qué se hizo con cada cosa

| # | Kevin dijo | Qué se hizo | Dónde está |
|---|---|---|---|
| 1 | Base triangular → cuadrada, mucho más grande, para más estabilidad | Se evaluó con números. **Se queda el triángulo, pero más ancho (1,2 m)**: gana la misma estabilidad que la cuadrada y no renguea | sección 5.1 |
| 2 | Fijar la montura dobson a la base con bujes, tornillos y mariposa | **Adoptada.** Va con las ranuras de los largueros, que además sirven para centrar el centro de masa | sección 5.3 y FAB-8 del Paso a paso |
| 3 | Sistemas de stop para el motor en las guías de aluminio | **Ya estaba**: son las tres capas de la sección 3. Se les agregó el cableado normalmente cerrado y la mejora por hardware | sección 3, límites de carrera |
| 4 | Un extra de goloso: una pantalla con el tiempo del recorrido y control por Bluetooth o app | **Anotado para la fase 3.** Se puede, con una placa ESP32. No toca el diseño mecánico | sección 5.5 |

## 5. Las decisiones, con sus números

### 5.1 La base al piso: ¿triangular o cuadrada más grande?

Lo que importa de una base es **cuánto hay que inclinar el conjunto para que
se caiga** (el «vuelco»). Con la mesa en el medio de la carrera, el telescopio
y la mesa pesando 48 kg y el centro de masa de todo a **74 cm** del piso:

| Base | Vuelco de costado | Vuelco hacia el sur | Patas |
|---|---|---|---|
| Triángulo de 0,80 m de ancho (el de antes) | 17,8° | 24,4° | 3 |
| Triángulo de 1,00 m | 21,6° | 24,4° | 3 |
| **Triángulo de 1,20 m (elegido)** | **25,0°** | 24,4° | 3 |
| Triángulo de 1,40 m | 27,8° | 24,4° | 3 |
| Cuadrada, del tamaño que sea | de sobra | 24,4° | 4 |

*Cómo se lee:* con el triángulo de antes, un empujón de costado de unos
**9 kg a la altura del ocular** (1,3 m) ya vuelca el conjunto. Con 1,2 m de
ancho hace falta casi **un 40 % más** (unos **12 kg**). Más ancho que 1,2 m **no sirve de nada**: el
que manda pasa a ser el vuelco hacia el sur (24,4°), que no depende del ancho.

*Por qué la cuadrada no mejora lo que el triángulo ancho ya logra:*

1. **El que manda es el sur.** El borde del sur está fijo (lo ponen los
   rodillos): una base cuadrada, aunque sea gigante, vuelca hacia el sur a los
   mismos 24,4°. Para ganar ahí habría que alargarla hacia el sur, y entonces
   ya no entra en el baúl.
2. **Cuatro patas renguean.** Un piso de patio nunca es perfectamente plano;
   con cuatro patas siempre hay una en el aire. Con tres, nunca.
3. **Más hierro.** Una cuadrada de 1,2 × 1,2 pide casi un metro más de
   planchuela de canto que el triángulo y más peso.

**Si una ráfaga o un empujón te preocupa:** 10 kg de lastre bajo (una bolsa de
arena o ladrillos sobre el travesaño) llevan el vuelco al sur de 24,4° a 28,3°.
Es reversible y no cuesta nada.

*Cuenta reproducible:* `node docs/estabilidad-base.js`. Es una versión
simplificada (no suma la inclinación de la mesa); sirve para comparar bases.

### 5.2 ¿Soldar o abulonar?

**Recomendación: las dos, cada una donde corresponde.**

| Pieza | Cómo | Por qué |
|---|---|---|
| Marco de la mesa, brazo en A, cartelas, poste | **soldado** | no se desarman nunca y son las uniones que sufren el torque |
| Triángulo de la base (los tres lados) | **soldado** | un triángulo soldado no se deforma |
| Travesaño del sur (el que lleva el ancho a 1,2 m) | **abulonado** (M8, arandela y tuerca autofrenante) | así se saca y la base queda de 0,8 m: entra en el baúl |
| Soportes de los rodillos | **abulonados, con ranuras** | un rodillo mal alineado hace que la mesa corra torcida; con ranuras se alinea en el patio |
| Chapas de aluminio, motor, switches | **abulonados** | el aluminio no se suelda en el taller |
| Dobson a la mesa | **mariposas** | se saca sin herramientas |

**Los cuidados de soldar:** la planchuela de menos de 1 cm **se alabea con el
calor**. Se suelda sobre una superficie plana, con prensas, **punteando primero
y soldando a tramos cortos alternando lados**. Después se mide: el marco de la
mesa tiene que quedar plano y con las diagonales iguales **±2 mm**. Si queda
alabeado, la mesa se mece y las chapas quedan torcidas, y eso ningún ajuste
posterior lo compensa. Todo con antióxido y pintura (va afuera, de noche, con
rocío).

### 5.3 La fijación del dobson (idea de Kevin)

El dobson (su base fija, de 43 × 40 y 2 cm de pino) apoya en los dos largueros
de la mesa. Los largueros llevan **ranuras de 9 mm** en el sentido
norte-sur, y la fijación es:

- **bulón M8 de cabeza fresada**, con la cabeza al ras de la madera (entre la
  base fija y la móvil hay apenas unos 1,5 cm de hueco, el paso 4 lo mide);
- un **buje** (un tramo de caño) en el agujero del pino, para que el bulón no
  aplaste la madera;
- una **arandela ancha** abajo y una **tuerca mariposa M8** que se aprieta con
  la mano, de noche, sin llave.

Las ranuras tienen un segundo trabajo: el dobson se **corre** sobre ellas para
llevar el centro de masa justo sobre el eje (calibración CAL-1), sin cortar
madera. Eso es lo que decía la regla del proyecto: primero se mueve, después
(quizás) se corta.

### 5.4 El motor: ¿cuál comprar?

**Lo que el motor tiene que vencer** (todo estimado, `hipótesis` hasta
medirlo):

- el rozamiento del pivote: de 0,1 a 3 N·m en el eje;
- el viento: una ráfaga de 40 km/h sobre el tubo empuja con unos 25 N, que es
  **≈ 12 N·m** alrededor del eje;
- los rodillos y la correa: poca cosa.

El torque que eso pide al motor es `T_eje × 0,016 m (radio del rodillo) ÷ 0,79 m
(distancia del rodillo al eje) ÷ 4 (reducción)`: **0,16 kg·cm** para el
rozamiento y **0,62 kg·cm** para la ráfaga de 40 km/h.

| Motor (publicación del 5/10/2026) | Torque | Precio | Margen contra la ráfaga | Veredicto |
|---|---|---|---|---|
| **17HS2408S, 0,6 A** (ELabshop en Mercado Libre, el que pasó Kevin) | 1,6 kg·cm | $18.200 | 2,6 veces | alcanza para el rozamiento pero **queda justo con viento**. Descartado |
| **Usongshine, tipo 17HS4401, 1,7 A** (Ingeniería Gabriel Gómez, Mercado Libre, FULL, llega gratis mañana) | ≈ 4 kg·cm | $24.640 | 6,5 veces | **recomendado**: la etiqueta de la foto lee «17HS4401»; confirmarlo en la ficha antes de pagar |
| **ACT Motor 17HS4417P1-X16, 1,7 A** (Facebook Marketplace; Fran ya mandó mensaje) | ≈ 4 kg·cm (`probable`) | $22.000 | 6,5 veces | vale lo mismo; ahorra ≈ $2.600 pero **sin garantía**: sólo si lo ven en mano y la etiqueta coincide |
| **La Costa 3D, 4,4 kg·cm, 40 mm** (Mercado Libre) | 4,4 kg·cm | $30.200 y $32.950 | 7 veces | el mismo motor, $5.500 más caro |

**Por qué el de 4 kg·cm y no el de 1,6:** $6.400 más compran un margen de 6,5
veces en vez de 2,6. Una plataforma que se traba a mitad de una foto de 30
minutos pierde la foto; y el motor es la parte más barata de todo. Con el
TMC2209 se puede bajar la corriente para que el motor de 1,7 A ande tranquilo.

*Los datos de cada publicación son los que dice el vendedor: se verifican al
comprar.*

### 5.5 El extra: pantalla con el tiempo y control por Bluetooth

**Se puede, y no toca nada de la mecánica.** Es una caja con una pantalla y
tres botones que muestre **qué está haciendo** (siguiendo, parado, rebobinando)
y **cuántos minutos le quedan a la carrera**, y que se maneje desde el celular.

**Cómo se haría (propuesta):**

- una placa **ESP32** en lugar del Arduino Nano (trae Bluetooth y WiFi, y maneja
  el TMC2209 igual que el Nano);
- una pantalla chica (OLED o LCD de 16 × 2);
- tres botones (seguir / parar / rebobinar), para cuando el celular no esté a
  mano;
- desde el celular: lo más fácil es que la placa **sirva una página web** (se
  abre desde el navegador, sin instalar nada); la alternativa es una app
  genérica de Bluetooth.

**Un cuidado que no es técnico:** de noche una pantalla blanca **arruina la
visión nocturna** y se cuela en la foto. Tiene que ser **roja o muy atenuada**,
con apagado automático.

**Cuándo:** se decide en la fase 3 y se prueba en la 4, **después** de que la
plataforma siga bien una estrella (CAL-5). Antes, el programa mínimo con el Nano
alcanza. La meta del proyecto es la foto: esto es el postre.

## 6. Lista de materiales

Precios vistos el 4 y el 5 de octubre de 2026 en zona norte y en línea. «Quién»
es una propuesta. **Nada de esta lista se compra antes de que lo indique el
Paso a paso**, salvo lo marcado.

| Qué | Cuánto | Dónde | Precio | Quién |
|---|---|---|---|---|
| Chapa de aluminio 5 mm (Aluar 1050, blanda: el rodillo tiene que ser de plástico) | 500 × 500 mm, alcanza para las dos | Alumina Argentina (online); MECENALUM (cortes, Mercado Libre); J. L. Metales (Av. Mitre 3380, Caseros) | $66.193 | compra, **después de cerrar P0** |
| Corte de las chapas | 2 piezas | en casa con caladora y hoja de metal, o láser desde el DXF: Iruña Metalúrgica (Munro), Lasertec | a cotizar | Fran |
| Planchuela de hierro de 30 a 60 mm, menos de 1 cm de espesor | ≈ 6 m en total | ya la tienen | — | hay |
| Electrodos (o alambre, si es MIG), antióxido y pintura | para ≈ 6 m de planchuela | ferretería, pinturería | a cotizar | compra |
| Rulemanes 608ZZ | 4 + 1 de repuesto (+2 para el rodillo de prueba) | casas de rulemanes, insumos de impresión 3D | a cotizar | compra |
| Rótula de amortiguador a gas, bocha 10 mm, rosca M8 | 1 | repuestos de auto, ferretería industrial | a cotizar | compra |
| Bulones M10 + tuercas de inserto (patas); ejes de los rodillos: **la varilla guía de 8 mm de la impresora sirve** | 3 patas, 2 ejes | ferretería | a cotizar | compra |
| Bulones M8 de cabeza fresada, tuercas mariposa M8, arandelas anchas, un tramo de caño para los bujes | 4 juegos (fijación del dobson) | ferretería | a cotizar | compra |
| **Motor NEMA 17 de ≈ 4 kg·cm** | 1 | ver sección 5.4 | ≈ $24.640 | **se puede comprar ya** (para el paso 7) |
| **Driver TMC2209** | 1 | TP3D, 3DInsumos, 3D Casa Bureu | a cotizar | **se puede comprar ya** (para el paso 7) |
| Correa GT2 6 mm + polea de 20 y de 80 dientes | 1 juego | insumos de impresión 3D (la de 80 se puede imprimir) | a cotizar | compra / Kevin |
| Microswitch con palanca de rodillo (tipo KW12, los de las impresoras), normalmente cerrados | 2 + 1 de repuesto | Todomicro, casas de electrónica | a cotizar | compra |
| Tornillo M5 × 80 con dos tuercas (la leva) y goma de cámara de bici (talones) | 1 | ferretería, bicicletería | casi nada | compra |
| Arduino Nano + fuente 12 V | 1 | **ya hay** (el paso 5 mira si alcanza) | — | Fran |
| *(extra)* ESP32 y pantalla | 1 | a cotizar | a cotizar | **no comprar hasta la fase 3** |
| *(opcional)* lastre: arena o ladrillos | 10 kg | ferretería, corralón | casi nada | Fran |

**Lo que se imprime en 3D (Kevin):** los dos rodillos (con hueco a medida para
los 608), los cuatro soportes de rodillo, el soporte del motor, la polea de 80
si no se compra, los dos soportes de los finales de carrera, la caja de la
electrónica. Propuesta de material: **PETG** para rodillos y soportes (aguanta
mejor el sol y la carga que el PLA), con 4 paredes y 50 % de relleno o más. Los
archivos salen en el diseño de detalle, con las medidas reales (el rodillo de
prueba es el paso 6).

## 7. Lo que no se hace

- **No se corta ni se suelda nada antes de medir.** La forma de las chapas
  depende del centro de masa y es lo único que no se ajusta después.
- **No se le saca madera a la montura** para equilibrar: no hay otra. Primero
  se corre el tubo en la caja, o el dobson sobre las ranuras, o se agregan
  suplementos.
- **No se deja el telescopio sobre la plataforma con el motor andando y sin
  nadie**, hasta que las tres capas de límite estén probadas.
- **Nada de rodillos de acero** sobre el aluminio blando: marcan el canto.
- **No se compra la chapa de aluminio** hasta que P0 (¿llega a foco?) esté
  cerrada.

## 8. Aparcado: la cámara y el foco

A pedido de Fran (5 de octubre) la cámara y el enfocador quedan afuera de lo que
se está diseñando. Queda anotado para cuando vuelvan:

- **En foco primario el telescopio es un teleobjetivo de 1200 mm.** La cámara
  (sin su lente) se pone donde iría el ocular y el espejo hace de lente. Con la
  ZV-E10 cada píxel ve 0,67 segundos de arco. Saturno, con los anillos, mide
  unos 45 segundos de arco: en la foto ocupa **unos 65 píxeles de 6000**. Es un
  puntito con anillos en medio de un cuadro enorme: por eso se ve «sin aumento».
- **Para planetas** hace falta una **lente Barlow** (×2 o ×3) y filmar video
  para apilar los mejores cuadros. **Para nebulosas y galaxias** (la meta) se
  usa **sin Barlow**: con una ×2 el telescopio pasa de f/6 a f/12 y necesita
  cuatro veces más exposición.
- **P0, la pregunta que queda abierta:** ¿el telescopio llega a foco con la
  cámara? La pregunta para Kevin: cuando miraron Saturno, **¿se veían los
  anillos, aunque fuera chiquitos?** Si sí, llega a foco. Si fue un manchón sin
  anillos, hay que probar de día apuntando a una antena a más de 500 m. El
  portaocular es a rosca (helicoidal, 1,25") y tiene poco recorrido: es el
  sospechoso si no llega. Detalle en el *Protocolo de medición*, P0.

## 9. Palabras que van a aparecer

- **Foco primario:** la cámara sin lente, donde iría el ocular. El telescopio
  es la lente.
- **Barlow:** lente que alarga la focal (×2, ×3). Para planetas.
- **f/6:** focal dividida apertura (1200 / 200). Cuanto más chico, más
  luminoso.
- **Segundo de arco (″):** 1/3600 de grado. La Luna mide unos 1800″.
- **Deriva:** cuánto se escapa una estrella del lugar con el seguimiento
  andando. Es el examen final de la plataforma.
- **Centro de masa:** el punto de equilibrio del conjunto.
- **Vuelco:** cuántos grados hay que inclinar el conjunto para que se caiga.
- **Micropaso:** el motor paso a paso divide cada paso en 16 para moverse
  suave.
