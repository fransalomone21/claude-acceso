# Guía de armado — Plataforma ecuatorial del 200/1200

**Para Fran y Kevin.** Versión 1, 4 de octubre de 2026. La fuente vive en el
repo (`proyectos/ingenieria/telescopio/docs/07-guia-armado.md`); esta copia
está en la carpeta compartida del Drive.

> **Antes que nada: nada de esto se corta ni se compra todavía.** Todas las
> medidas salen de los números de agosto, que nunca se midieron con método.
> La guía sirve para entender qué vamos a hacer, presupuestar y repartirnos
> las tareas. Las medidas finales salen cuando pesemos el telescopio y
> encontremos su centro de masa. Cortar antes es comprar dos veces.

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
acompaña unos 90 minutos (45 a cada lado del centro). Después se "rebobina"
(vuelve al principio) y se sigue. Elegimos el diseño **VNS** (de Reiner Vogel):
apoya en tres puntos (un pivote y dos rodillos) y por eso no renguea en ningún
piso, que era el criterio número uno.

## 2. Lo de Saturno y la Barlow (Kevin)

Lo que viste con el adaptador impreso tiene explicación, y es buena noticia.

**En foco primario el telescopio es un teleobjetivo de 1200 mm.** La cámara
(sin su lente) se pone donde iría el ocular, y el espejo hace de lente. Con
la ZV-E10 cada píxel ve 0,67 segundos de arco. Saturno, con los anillos, mide
unos 45 segundos de arco de punta a punta: en la foto ocupa **unos 65 píxeles
de ancho, sobre una foto de 6000**. Es un puntito con anillos en el medio de
un cuadro enorme. Por eso parece "sin aumento": el aumento está, pero el
cuadro es gigante comparado con el planeta.

- **Para planetas** (Saturno, Júpiter, la Luna de cerca) hace falta una
  **lente Barlow** (×2 o ×3) entre el telescopio y la cámara: alarga la focal
  a 2400 o 3600 mm y el planeta sale 2 o 3 veces más grande. Y se filma un
  video en modo recorte, no una foto: se apilan los mejores cuadros
  ("lucky imaging"). Eso anda incluso sin plataforma, o con una que siga más o
  menos.
- **Para nebulosas y galaxias** (la meta del proyecto) se usa **sin Barlow**:
  esos objetos son grandes y oscuros, y lo que importa es juntar luz. El 200/1200
  es f/6; con una Barlow ×2 pasa a f/12 y necesita **cuatro veces** más
  tiempo de exposición para la misma foto. Ahí la Barlow juega en contra.
- **Bonus:** la Barlow también corre el punto de foco hacia afuera. Si algún
  día la cámara no llega a enfocar en foco primario (pasa en muchos
  newtonianos), la Barlow lo arregla.

**La pregunta que cierra todo:** cuando miraron Saturno, **¿se veían los
anillos, aunque fuera chiquitos?** Si sí, el telescopio llega a foco con la
cámara, y eso es la medición más importante que nos faltaba (si no llegara a
foco, la meta de la foto de una nebulosa se caía entera). Si se veía un
manchón redondo sin anillos, no estaba enfocado y hay que probar de día
apuntando a una antena lejana (más de 500 m), moviendo el enfoque de punta a
punta.

## 3. Las piezas, una por una

Los números son los del modelo 3D.

1. **Base al piso.** Un **triángulo de planchuela de hierro de 50 mm, de
   canto**, de pata a pata (idea de Kevin), con un travesaño bajo los
   rodillos y cartelas en las esquinas. No se mueve nunca. Mide unos
   **1,16 m de largo** con el pivote sobre un poste de 10 cm (sin poste,
   1,30). Todo el porqué, con números: `docs/09-estructura-hierro.md`.
2. **Tres patas regulables.** Un bulón M10 con tuerca en cada punta. Tres
   patas nunca renguean (el banquito de ordeñe); cuatro, siempre. Con las
   tuercas se nivela y se retoca la alineación, sin cortar nada.
3. **Pivote norte.** Una rótula de amortiguador a gas (bocha de 10 mm, rosca
   M8) atornillada arriba de un **poste de 10 cm** (caño 40 × 40 o
   planchuelas soldadas, con tres riendas), y arriba, en la punta del brazo
   de la mesa, un hueco cónico donde apoya. Es el único apoyo que no rueda: todo gira alrededor de él.
   **Ojo: la del amortiguador a gas (la del portón del baúl), no la de
   suspensión** (la de parrilla, con brida de tres agujeros y espárrago
   cónico). La de suspensión viene precargada contra una cazoleta de
   plástico para no tener juego en un auto de una tonelada: roza más, tiene
   el espárrago cónico (pide un agujero cónico a medida) y le sobra todo. Una
   bocha de 10 mm suelta en un cono engrasado roza ≈ 0,1 N·m con los ≈ 15 kg
   que carga el pivote; aun una de suspensión (≈ 1 a 3 N·m, `hipótesis`) le
   pediría al motor menos de 0,3 kg·cm de 7, así que el rozamiento no es el
   problema: lo que importa en el pivote es **cero juego y que gire parejo**
   (sin enganches a velocidad lenta). Alternativa si no aparece: un
   **terminal de rótula M8** (cabeza de rótula, la de los cilindros
   neumáticos), que se atornilla derecho y no tiene juego.
4. **Mesa móvil.** Un marco de planchuela de 40 de canto con dos largueros
   (ranurados) donde apoya el dobson tal cual está, y el **brazo al pivote
   en A**: dos planchuelas de 50 de canto. En madera ese brazo se doblaba
   ≈ 8 mm; en hierro, ≈ 0,3. **La mesa gira con el telescopio**: sus ≈ 8 kg
   entran en el centro de masa de lo que gira, y por eso el eje va a
   **≈ 54 cm** sobre la mesa, no a 65.
5. **Las dos chapas de aluminio (los segmentos).** Las únicas piezas de
   aluminio: 5 mm de espesor, paradas, atornilladas al marco sur de la mesa.
   Su borde de abajo es un pedazo de elipse y cada una va girada unos 9°.
   Esa forma es lo único "difícil" del diseño, y se resuelve imprimiendo la
   **plantilla 1:1 en papel**, pegándola y calando alrededor. Miden unos
   **357 × 107 mm** cada una (las dos salen de una chapa de 500 × 500).
6. **Rodillos.** Un cilindro impreso de 32 mm de diámetro y 26 de ancho, con
   un rulemán 608ZZ (los de skate) a presión en cada cara, girando sobre un
   bulón M8. El canto de cada chapa apoya y rueda sobre uno. Cada rodillo
   carga unos 17 kg y el pivote unos 15 (40 kg de telescopio más 8 de
   mesa de hierro, poste de 10 cm).
7. **Motor.** Un paso a paso NEMA 17 con polea GT2 de 20 dientes y correa
   hasta una polea de 80 en el eje del rodillo oeste (reduce 4 a 1). El
   rodillo da unas dos vueltas por hora y cada micropaso mueve la mesa unos
   2 segundos de arco. Lo maneja un Arduino Nano con un driver TMC2209
   (silencioso y suave, justo para movimientos lentos). **Tiene que ser
   paso a paso:** los motores de casetera y de impresora que aparecieron son
   de continua, y un motor de continua sin encoder no sabe cuánto giró —
   anda «más o menos a tantas vueltas», y para las estrellas «más o menos»
   son estrellas con cola. El paso a paso cuenta pasos: gira exactamente lo
   que se le manda.
8. **El eje polar.** No es una pieza: es la línea imaginaria alrededor de la
   que gira la mesa. Pasa por el pivote, sube hacia el sur a **34,5°** (la
   latitud de Villa Adelina) y apunta al polo sur celeste.
9. **Centro de masa.** El punto donde "se concentra" el peso del telescopio.
   Tiene que caer **sobre** el eje: si queda corrido, el peso tironea para un
   lado y el motor pelea. Por eso hay que medirlo antes de cortar.
10. **Polo sur celeste.** En el sur no hay estrella polar: la más cercana,
    σ Octantis, es apenas visible a ojo. Se alinea una vez con el método de
    deriva (mirando cómo se escapa una estrella) y se marcan las tres patas
    en el piso del patio.
11. **El dobson actual.** Se sube entero a la mesa.
12. **Suplementos.** Tablitas debajo del dobson para subir el centro de masa
    hasta el eje si sale más bajo de lo calculado. Se corrige apilando
    madera, no cortando aluminio.
13. **Finales de carrera** (nuevo). Dos microswitches con palanca, uno por
    punta, en un soporte impreso al costado del rodillo este. Un tornillo M5
    clavado en el medio de la chapa hace de leva: si la mesa se pasa 3
    minutos del final, la leva aprieta la palanca y el Arduino corta el
    motor. Uno por punta, así el programa sabe de qué lado se pasó.
14. **Talones** (nuevo). Cada chapa termina en un "diente" que cuelga 12 mm
    por debajo del borde, con goma pegada. Si falla todo lo demás, el talón
    choca contra el rodillo y la mesa se queda ahí, en vez de que la chapa
    se salga del rodillo y el telescopio se venga abajo. No cuesta nada:
    sale de la misma plantilla.

### Los límites de carrera, en tres capas

Que la chapa se salga del rodillo es el peor accidente posible: unos 40 kg de
telescopio cayéndose de costado. Por eso no hay un límite, hay tres, cada uno
independiente del anterior:

| Capa | Qué la frena | Dónde | Si falla… |
|---|---|---|---|
| 1. Programa | el Arduino cuenta pasos y para | a los ±45 min | …sigue la capa 2 |
| 2. Fin de carrera | la leva aprieta el switch y el Arduino corta el motor | a los ±48 min (unos 10 mm después) | …sigue la capa 3 |
| 3. Talón | el diente de la chapa choca el rodillo | a los ±51 min (otros 10 mm) | no falla: es aluminio |

**Cada capa se prueba rompiéndola**, no confiando: se hace andar el motor
con el programa "olvidado" de parar y se mira que el switch lo corte; se
desconecta el switch y se empuja la mesa a mano hasta el talón. Una alarma
que nunca sonó está sin probar.

## 4. Lista de materiales

Precios vistos el 4/10/2026 en zona norte. "Quién" es una propuesta.

| Qué | Cuánto | Dónde | Precio | Quién |
|---|---|---|---|---|
| Chapa de aluminio 5 mm (Aluar 1050, blanda: el rodillo tiene que ser de plástico) | 500 × 500 mm, alcanza para las dos | Alumina Argentina (online); MECENALUM (cortes, Mercado Libre); J. L. Metales (Av. Mitre 3380, Caseros) | $66.193 | compra |
| Corte de los segmentos | 2 piezas | en casa con caladora y hoja de metal, o láser desde el DXF: Iruña Metalúrgica (Munro), Lasertec | a cotizar | Fran |
| Planchuela de hierro de 30 a 60 mm, menos de 1 cm de espesor | ≈ 6 m en total | ya la tienen | — | hay |
| Rulemanes 608ZZ | 4 + 1 de repuesto | casas de rulemanes, insumos de impresión 3D | a cotizar | compra |
| Rótula de amortiguador a gas, bocha 10 mm, rosca M8 | 1 | repuestos de auto, ferretería industrial | a cotizar | compra |
| Bulones M10 + tuercas de inserto (patas); ejes de los rodillos: **la varilla guía de 8 mm de la impresora sirve** (es más derecha que un bulón) | 3 patas, 2 ejes | ferretería | a cotizar | compra |
| Motor NEMA 17 (unos 4 kg·cm alcanzan). El de la impresora que hay (Mitsumi M28N-1) parece ser de continua con encoder, no paso a paso: no sirve tal cual | 1 | Todomicro, Mercado Libre | ≈ $49.900 el de 7 kg·cm | ver si hay |
| Driver TMC2209 | 1 | TP3D, 3DInsumos, 3D Casa Bureu | a cotizar | compra |
| Correa GT2 6 mm + polea de 20 y de 80 dientes | 1 juego | insumos de impresión 3D (la de 80 se puede imprimir) | a cotizar | compra / Kevin |
| Microswitch con palanca de rodillo (tipo KW12, los de las impresoras) | 2 + 1 de repuesto | Todomicro, casas de electrónica | a cotizar | compra |
| Tornillo M5 × 80 con dos tuercas (la leva) y goma de cámara de bici (talones) | 1 | ferretería, bicicletería | casi nada | compra |
| Arduino Nano + fuente 12 V | 1 | **ya hay** (ver inventario) | — | Fran |

**Lo que se imprime en 3D (Kevin):** los dos rodillos (con hueco a medida
para los 608), los cuatro soportes de rodillo, el soporte del motor, la polea
de 80 si no se compra, los dos soportes de los finales de carrera, la caja
de la electrónica, el adaptador de la cámara y el soporte de cámara
intercambiable. Propuesta de material: **PETG** para rodillos y soportes
(aguanta mejor el sol y la carga que el PLA), con 4 paredes y 50 % de
relleno o más. Los archivos salen en el diseño de detalle, con las medidas
reales.

## 5. Fabricación y calibración — el procedimiento

> Esta parte cambia de tono a propósito. Lo de arriba se lee como una charla;
> esto se **ejecuta**, con la guía abierta al lado de la herramienta. Cada
> paso dice qué necesita, qué se hace y **cómo se sabe que salió bien**. Un
> paso no se da por terminado porque "se hizo", sino porque pasó su
> criterio de aceptación. Las tolerancias son provisorias: las definitivas
> salen del presupuesto de error (fase 1 del proyecto).

### 5.1 Fabricación

**FAB-0 — Medición del telescopio.**
*Requiere:* balanza, cinta métrica, el "Protocolo de medición" de esta
carpeta. *Procedimiento:* el del protocolo, en su orden (P0 foco, después
masa y centro de masa). *Aceptación:* el centro de masa medido por dos
métodos independientes coincide dentro de **±1 cm**; cada número queda
anotado con con qué se midió.

**FAB-1 — Plantilla 1:1 de los segmentos.**
*Requiere:* FAB-0 aceptado; el modelo recalculado con esas medidas.
*Procedimiento:* imprimir la plantilla a escala 100 % (sin "ajustar a la
página"). *Aceptación:* la regla de control impresa en la plantilla mide lo
que dice, **±0,5 mm en 300 mm**. Si no, se corrige la escala de la
impresora y se reimprime.

**FAB-2 — Base, mesa y brazo de planchuela de hierro.**
*Requiere:* planchuelas de 30 a 60 mm (ya las tienen), amoladora, agujereadora
o soldadora, escuadra, antióxido.
*Procedimiento:* cortar según la lista de corte (fase 3); armar el triángulo
de la base y el marco de la mesa **sobre una superficie plana**, presentar
con prensas antes de soldar o abulonar; cartelas en las esquinas; antióxido y
pintura. *Aceptación:* diagonales del marco de la mesa iguales **±2 mm**
(escuadra), y la base apoyada en sus tres patas sin ninguna esquina en el
aire. Detalle: `docs/09-estructura-hierro.md`.

**FAB-3 — Patas y pivote.**
*Procedimiento:* insertar las tres tuercas de inserto, roscar los bulones
M10, atornillar la rótula del pivote. *Aceptación:* sobre el piso del
patio, la base no se mueve al apretar cada esquina (tres apoyos firmes).

**FAB-4 — Rodillos.**
*Requiere:* dos rodillos y cuatro soportes impresos, cuatro 608ZZ, bulones
M8. *Procedimiento:* calzar los rulemanes a presión (con prensa o morsa,
nunca a martillazos directos), montar sobre el bulón entre soportes.
*Aceptación:* cada rodillo gira libre a mano, sin juego axial perceptible ni
puntos duros en una vuelta completa.

**FAB-5 — Segmentos de aluminio.**
*Requiere:* FAB-1 aceptado, chapa de 5 mm, caladora con hoja para metal,
aceite, lima. *Procedimiento:* pegar la plantilla, calar por afuera de la
línea, terminar con lima hasta la línea; redondear el canto de rodadura;
pegar goma en la cara interna de cada talón. *Aceptación:* el canto
copia la plantilla **±0,5 mm** en todo el largo (se controla apoyando la
plantilla impresa de nuevo); el canto no tiene escalones que se sientan con
la uña.

**FAB-6 — Montaje de los segmentos en la mesa.**
*Procedimiento:* atornillar cada chapa con sus tacos, girada el ángulo que
indica el plano (unos 8°), usando la plantilla de posición. *Aceptación:*
apoyada la mesa sobre los rodillos y el pivote, sin telescopio, se empuja a
mano de punta a punta y **rueda sin saltos y frena contra los dos talones**.

**FAB-7 — Electrónica y finales de carrera.**
*Requiere:* Arduino Nano, TMC2209, NEMA 17, fuente 12 V, dos microswitches,
la leva M5. *Procedimiento:* cablear según el esquema (se entrega con el
diseño de detalle); montar los switches en su soporte, al costado del
rodillo este; atornillar la leva en el medio de la chapa. *Aceptación:* con
el motor andando, **cada switch apretado a mano lo detiene**, y el
programa informa de qué punta fue. Las dos puntas, sin excepción.

### 5.2 Calibración

**CAL-1 — Balance sobre el eje.**
*Procedimiento:* con el telescopio arriba y el motor desacoplado (correa
floja), llevar la mesa a cinco posiciones (las dos puntas, el centro y los
dos intermedios) y soltarla. *Aceptación:* en las cinco **se queda quieta**.
*Si no:* si se va siempre para el mismo lado, el centro de masa está
corrido: correr el dobson en sus ranuras o sumar suplementos, y repetir.

**CAL-2 — Velocidad de seguimiento.**
*Procedimiento:* marcar la mesa y la base, correr el programa 10 minutos
medidos con cronómetro, y medir el desplazamiento. *Aceptación:* el giro
medido difiere del del cielo (2,5° en 10 min) en **menos de 0,5 %**. *Si
no:* se ajusta la constante de pasos por grado del programa.

**CAL-3 — Las tres capas de límite.**
*Procedimiento:* (a) programa: correr hasta el final y ver que pare solo a
los ±45 min; (b) switch: desactivar el límite del programa y ver que el
switch corte a los ±48 min; (c) talón: con el motor desacoplado, empujar a
mano hasta el tope. *Aceptación:* las tres frenan, cada una sin ayuda de la
otra. **Una capa que nunca se vio frenar no está probada.**

**CAL-4 — Alineación polar.**
*Procedimiento:* nivelar con las patas; apuntar una estrella cerca del
meridiano y otra cerca del horizonte este; mirar hacia dónde se escapan
(método de deriva) y corregir con las patas. Marcar las tres patas en el
piso. *Aceptación:* en 60 s de foco primario la estrella no se corre más de
**3 píxeles** (unos 2″). El mismo píxel sería lindo, pero no es de este
mundo.

**CAL-5 — Prueba de deriva (el examen final).**
*Procedimiento:* fotos de 30 s, 60 s y 2 min de una misma estrella brillante,
con el seguimiento andando. *Aceptación provisoria:* estrellas **redondas**
en la de 60 s. La cifra definitiva sale de la fase 1. Recién ahí, la
nebulosa.

## 6. Lo que no se hace

- **No se corta nada antes de medir.** La forma de las chapas depende del
  centro de masa y es lo único que no se ajusta después.
- **No se le saca madera a la montura** para equilibrar: no hay otra. Primero
  se corre el tubo en la caja o se agregan suplementos.
- **No se deja el telescopio sobre la plataforma con el motor andando y sin
  nadie**, hasta que las tres capas de límite estén probadas.
- **Nada de rodillos de acero** sobre el aluminio blando: marcan el canto.

## 7. Lo que falta saber (y quién)

| Qué | Para qué | Quién |
|---|---|---|
| ¿Se veían los anillos de Saturno? | saber si llega a foco | Kevin |
| ¿El tubo se queda quieto donde lo soltás (20°, 45°, 80°)? | saber si está balanceado: si no, el centro de masa se mueve | Fran |
| Pesar la caja sola, y el segundo método del centro de masa: montura inclinada (P3) o todo junto plano (P4) | cierra el centro de masa (hoy 63 cm compuesto, entre 58 y 69) | Fran y Kevin |
| Rebalancear el tubo **con la cámara puesta** (correrlo ≈ 1 a 2 cm hacia la cola) | que el centro de masa no cambie al subir o bajar el tubo | Fran |
| Centro de masa, por dos métodos | la forma de las chapas | Fran y Kevin |
| Medidas del portaocular y del buscador | el modelo y el soporte de cámara | Fran |
| Espesor de las planchuelas, y si se sueldan o se abulonan (base 1,16 m con poste de 10 cm: ya decidido) | dónde se va a usar | Fran |
| Material y volumen de impresión de la impresora del amigo | qué piezas salen enteras | Kevin |
| Etiquetas del motor y de la placa HW-130 que hay | si hay que comprar driver y motor | Fran |

## 8. Palabras que van a aparecer

- **Foco primario:** la cámara sin lente, donde iría el ocular. El telescopio
  es la lente.
- **Barlow:** lente que alarga la focal (×2, ×3). Para planetas.
- **f/6:** focal dividida apertura (1200 / 200). Cuanto más chico, más
  luminoso.
- **Segundo de arco (″):** 1/3600 de grado. La Luna mide unos 1800″.
- **Deriva:** cuánto se escapa una estrella del lugar con el seguimiento
  andando. Es el examen final de la plataforma.
- **Centro de masa:** el punto de equilibrio del conjunto.
- **Micropaso:** el motor paso a paso divide cada paso en 16 para moverse
  suave.
