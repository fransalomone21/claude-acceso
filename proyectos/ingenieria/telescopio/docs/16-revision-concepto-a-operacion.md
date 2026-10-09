# Revisión de punta a punta: qué puede salir mal, del concepto a la noche de fotos

> **Corregido por `17-investigacion-pista.md` (2026-10-09), que manda donde se
> contradicen:** «70 % bamboleo» es 50/50 en potencia y el guiado en AR rescata
> parte a declinación austral; la causa del 1,2″ del trazado no es el radio (el
> número y la salida siguen); la métrica submuestrea las ondas cortas; «arista»
> no tiene umbral; el pivote va como bolilla templada en cono templado.

**Escrito el 2026-10-08 a la noche (decimoséptima sesión)**, a pedido de Fran,
sin medidas nuevas: «revisá el proyecto y el concepto y determiná posibles
inconvenientes en concepto, diseño, implementación y operación; avanzá lo que
puedas sin mis mediciones, refiná lo que sabés que sirve, mejorá los dibujos y
creá planos o layouts para cuando tengamos medidas». Es trabajo de **Pre-Fase
A**: poca profundidad y **horizonte completo**, hasta la operación
(`nucleo-ise.md` §2). Grado de cada número entre corchetes. **Manda sobre
`13-revision-externa.md` §3 (lo del radio del rodillo), §4 (el rodillo de
cuatro 608) y §6 (la aceptación del canto) donde se contradicen.**

Las cuentas nuevas están en **`contacto-vns.js`** (con sus controles y
sabotajes en `probar-contacto.js`, todo verde) y los planos en
**`planos.html`** (PDF con `planos.ps1`).

## 0. En criollo: lo que cambia

- **El cuello de botella se movió de la transmisión a la pista.** La pista es
  el canto de las chapas y los rodillos sobre los que rueda. Cada **micrón**
  (milésima de milímetro) de error en el canto mueve la estrella **≈ 0,27″**.
  Para que una foto de 60 s no se estire por la pista, el canto tiene que tener
  ondulaciones de **1 a 2 micrones** y los rodillos un salto de **2 micrones**
  [`probable`: cálculo]. Un corte láser solo, con su canto estriado, casi
  seguro no llega [`hipótesis`: no se midió ningún canto]. **Esto pesa más que
  el micropaso**, y además el guiado no lo arregla del todo (§2, K1).
- **Se arregla gratis: cómo se traza el canto.** El modelo traza el canto con
  el punto de arriba del rodillo; el correcto es la **envolvente** del rodillo.
  Cortado como está hoy, la estrella se corre **1,2″ por foto** en las puntas
  de la carrera. Trazado bien, cero. Y cada chapa queda atada al **diámetro de
  su rodillo** (±0,3 mm): el rodillo se elige antes de cortar (K2).
- **El rodillo de cuatro 608 se va**: las costuras entre rulemanes y sus
  diámetros distintos dan **2,4 a 4,2″ por foto**. Va un rodillo de una pieza (D2).
- **La chapa apoya en una arista, no en todo su espesor**: el rodillo se tuerce
  respecto del canto hasta 32′ en las puntas de la carrera. Se resuelve con un
  rodillo **basculante** o con rodaje y la rebaba del lado que no apoya (D1).
- **El armado tiene cuatro medidas finas**: el eje de cada rodillo a nivel y
  cada chapa a plomo (**±0,08°**), cada chapa en planta (±0,15°) y la altura del
  pivote (±0,8 mm). Lo demás es de herrería común (D4 y la hoja 5 de los planos).
- **La T2 suma otra razón**: no patina, así que el programa sabe siempre dónde
  está la mesa (tabla de corrección por posición, límites y rebobinado
  confiables). La F2 puede patinar cada vez que se apunta empujando el tubo (K5).
- **La noche tiene cuatro enemigos que no estaban escritos**: el **rocío** en
  el secundario, el espejo que **tarda en enfriarse**, el **foco** que se corre
  al bajar la temperatura, y el **óxido y el polvo** en la pista (§5).
- **Planos de disposición**: cinco hojas A3 que salen del modelo y se rehacen
  solas con el centro de masa medido (§6).
- **Es tuyo**, con esto sobre la mesa: ¿seguimos con 60 s, o 30 s? ¿Pagamos
  la terminación de los cantos en una tornería? (§8)

## 1. La pregunta de marco

*¿Qué tendría que ser verdad para que esto sea el problema equivocado?* Que el
seguimiento que pide la foto (≤ 1,5″ de la plataforma en 60 s a 0,67″ por
píxel) **no lo pueda dar ninguna transmisión** porque lo limita otra cosa. Eso
es justo lo que encontró esta revisión: la pista. Elegir entre F2 y T2 sigue
siendo necesario, pero ya no es la decisión que más pesa: pesa cuánto mide de
largo cada foto y cómo se termina el canto.

## 2. Concepto: ¿sirve para la foto?

**K1. La pista manda** [`probable`: cálculo; la calidad real del canto láser,
`hipótesis`]. Con la geometría v10.5 (rodillos a 58 cm, pivote a 1,02 m), un
error de altura en un punto de contacto gira la mesa sobre la línea que une el
pivote con el otro rodillo, a ≈ 0,56 m de palanca: **1 µm ≈ 0,27-0,37″**. Lo
que corre la estrella en una foto de 60 s, cada error solo, con las chapas bien
trazadas (`node docs/contacto-vns.js`, sección 3):

| Error | Tamaño | Corre en 60 s | Tolerancia para 0,2″ |
|---|---|---|---|
| ondulación del canto, onda de 50 mm | 0,010 mm | 1,63″ | **0,0012 mm** |
| ondulación del canto, onda de 5 mm | 0,002 mm | 1,38″ | **0,0003 mm** |
| escalón en el canto | 0,010 mm | 3,81″ | **0,0005 mm** |
| salto (excentricidad) de un rodillo | 0,010 mm | 1,22″ | **0,0016 mm** |

Un rulemán 608 común (clase P0) admite hasta 15 µm de salto: **1,8″**. Un canto
cortado a láser en 8 mm tiene estrías de decenas de micrones [`hipótesis`, a
medir]. Dos consecuencias:

1. **El guiado no lo cura entero.** De lo que corre la pista, ≈ 70 % es
   **bamboleo** del eje (sale perpendicular al eje polar) y ≈ 30 % es error de
   velocidad. La plataforma tiene un solo motor: un autoguiador o una tabla del
   programa corrigen la velocidad, **no el bamboleo**. Vale también para la meta
   de después (N-11, subs de 2 a 4 min guiados): la pista tiene que ser buena
   igual.
2. **La foto más corta lo divide.** Lo que corre adentro de una foto crece con
   su largo: con 30 s las tolerancias del canto se duplican; con 20 s, se
   triplican.

Salidas, de la más barata a la más cara: **(a)** fotos de 30 s (decisión de
Fran; el modo degradado N-08 ya pide que sirva con 10 s); **(b)** terminar el
canto después del láser: fresado CNC con pasada de acabado, o rectificado
(Tornería Acosta, Munro, anuncia rectificadora: `15` §5.2), y rodillos de
precisión; **(c)** las dos. **Lo que decide es medir un canto real** (§4, I2):
una muestra chica cortada a láser, medida con un comparador milesimal, y
`contacto-vns.js` dice cuánto corre la estrella con ESE canto.

**K2. El método de trazado** [`probable`: cálculo, con un control de una línea
que coincide a 7 µm]. `geometria-vns.js` traza el canto como el camino del
**punto de arriba** del rodillo. Un rodillo de radio r toca un canto inclinado
un poco al costado, y el canto correcto es la **envolvente** del cilindro. La
diferencia es casi constante (la mesa queda ≈ 0,57 mm más alta con un 608: lo
que `13` §3 llamó «0,4 mm, constante»), **pero no del todo**: cambia 0,1 mm a
lo largo de la carrera, y eso es bamboleo.

| Canto trazado… | Corre en 60 s, peor minuto |
|---|---|
| por el punto de arriba, rodillo Ø22 (608) | **1,22″** (minuto 45) |
| por el punto de arriba, rodillo Ø32 | **1,28″** |
| como envolvente del rodillo | **0,00″** |

Se arregla en el generador del DXF (fase 3), sin costo. Lo que cambia hoy: **la
chapa queda atada al diámetro de su rodillo** (tolerancia ±0,3 mm): el rodillo
se compra o se tornea **antes** de cortar las chapas. Es una interfaz nueva,
chapa ↔ rodillo, con dueño escrito: el plano de la chapa (hoja 4) dice para qué
rodillo es.

**K3. La latitud no toca la cinemática, toca las patas** [cálculo]. Inclinar
la plataforma entera no cambia cómo gira: por eso sirve en Punta Indio. Pero la
pata norte tiene que subir o bajar **≈ 15 mm** para esos 0,8°, y eso se suma a
los 3 cm de desnivel del piso de L1-18: **≈ 4,5 cm** contra los ≥ 3 cm que pide
L2-PLT-04. Si la plataforma viaja, las patas necesitan ≥ 5 cm de recorrido (o
una cuña). Depende de la pregunta abierta «¿viaja?».

**K4. El 60 s y el 1,5″ ya están en el límite de lo que se ve** [cálculo].
L0-02 pide redondez 0,8. Con 2,5″ de aire, eso deja **≈ 1,9″** de estiramiento
para todo (plataforma, montura, alineación): es exactamente el presupuesto de
L1-01. No hay margen escondido: cada 0,5″ que se va de la pista se nota.

**K5. La T2 gana una razón más: sabe dónde está la mesa** [`probable`: cálculo
de orden]. Con la F2, el rodillo agarra con ≈ 24 N (μ 0,15, 16 kg en el
rodillo): ≈ 18 N·m sobre el eje. Apuntar empujando el tubo con 1,5-2 kg a un
metro ya es eso: **el rodillo patina** y el programa pierde la posición de la
mesa (los minutos de la carrera se cuentan por pasos). Con la T2 el tornillo
no patina ni se deja empujar (haría falta ≈ 400 N·m): la cuenta de pasos **es**
la posición de la mesa, y eso habilita la **tabla de corrección por posición**
(saca el ≈ 30 % de la pista que es velocidad), el tope de 45 min por programa y
el rebobinado al punto justo.

## 3. Diseño

**D1. La chapa apoya en una arista** [cálculo]. El eje del rodillo es
horizontal y fijo; la chapa gira con la mesa sobre un eje inclinado. Vistos
desde la chapa, el rodillo se va torciendo:

| Minuto de la carrera | 5 | 15 | 30 | 45 | 51 (talón) |
|---|---|---|---|---|---|
| Rodillo torcido respecto del canto | 0,4′ | 3,5′ | 14′ | **32′** | 41′ |
| Luz a lo ancho de la chapa (7,94 mm) | 1 µm | 8 µm | 33 µm | **74 µm** | 95 µm |

Desde el minuto 10 la chapa apoya en **una arista** (siempre la misma: el giro
tiene el mismo signo a los dos lados). Con 25 kg, en línea (todo el espesor)
son 321 MPa; en una arista viva, ≈ 4900 MPa: la arista se aplasta unos pocos
micrones en las primeras noches hasta hacerse un asiento [cálculo de orden].
Consecuencias y salidas:

- **Rodaje**: veinte carreras con carga antes de calibrar la tabla (CAL nuevo).
- **La rebaba del láser no puede estar en la arista que apoya**: se corta con
  el lado de entrada del láser hacia ese lado, y se le saca la rebaba.
- **Rodillo basculante** (la salida de fondo): la unidad del rodillo bascula
  sobre un perno a lo largo de la pista, debajo del rodillo, y el rodillo se
  acuesta solo sobre el canto. Apoya en todo el espesor, y las dos tolerancias
  más finas del armado (rodillo a nivel y chapa a plomo, D4) dejan de
  importar. Lo que cuesta: un perno y dos bujes por unidad. Con el perno 15 mm
  debajo del contacto, bascular sube el contacto < 1 µm en toda la carrera
  [cálculo]. **Se decide en la fase B**, con la transmisión.

**D2. El rodillo de cuatro 608 no sirve** [cálculo, `contacto-vns.js` §4]. El
contacto camina **8,2 mm** a lo largo del rodillo en ±45 min; los 608 miden 7 mm
de ancho, tienen chaflán en los bordes y su diámetro exterior varía hasta 9 µm
entre uno y otro (tolerancia P0). Con diferencias de 0 / −4,5 / +3 / −2 µm:
**2,4″** con un aro centrado en el camino y **4,2″** con una costura en el
medio. Va un **rodillo de una pieza**: una camisa de acero torneada (y
rectificada) sobre dos 608, de ≥ 20 mm de ancho (igual que el motriz de la F).
Con la T2 los dos rodillos son locos: **dos camisas iguales**.

**D3. El salto de los rodillos** [cálculo]: ≤ 2 µm para 0,2″. Un 608 P0 admite
15 µm; un P4/ABEC-7, 3-4 µm. La camisa se rectifica **montada en sus propios
rulemanes** (así su salto incluye el de ellos). El reloj comparador de 0,01 mm
de FAB-4 no ve 2 µm: hace falta uno milesimal (0,001 mm).

**D4. Las tolerancias del armado** (hoja 5 de los planos; cada una sola, deja
0,2″ por foto; «con tabla» = con la T2 y la tabla por posición):

| Medida | Tolerancia | Con tabla | Cómo se cumple |
|---|---|---|---|
| eje del rodillo a nivel | **±0,078°** (0,09 mm entre sus ángulos) | ±0,11° | calce en un ángulo; nivel de mecánico — o basculante |
| chapa a plomo | **±0,078°** (≈ 0,2 mm en su alto) | ±0,11° | calce en las orejas — o basculante |
| chapa en planta | **±0,15°** (≈ 1 mm en su largo) | ±0,21° | plantilla al soldar las orejas |
| eje del rodillo en planta | ±0,24° | ±0,34° | ranura + escuadra a la chapa |
| altura del pivote | ±0,76 mm | ±1,1 mm | calces bajo la tapa del poste |
| altura de una chapa | ±0,41 mm | ±0,59 mm | ovalado + tornillo de empuje |
| rodillo este-oeste (separación) | ±1,0 mm | ±1,4 mm | ranura en la viga |
| altura de un rodillo | ±1,4 mm | ±2,0 mm | calce |
| rodillo norte-sur | ±3,0 mm | ±4,2 mm | ranura |
| diámetro del rodillo contra el de diseño | ±0,32 mm | ±0,44 mm | se elige antes de cortar |
| pivote norte-sur | libre (±24 mm) | | |

Lo fino no sale de soldar: sale de **ajustar** después, con calces y ranuras
puestos a propósito, y de **medir** con un nivel de mecánico (0,02-0,05 mm/m).
El nivel del celular (±0,1-0,2°) sirve para el vuelco del centro de masa, no
para esto.

**D5. Saber dónde está la mesa al prender** [criterio]. El tope por programa
(45 min) y el rebobinado (L1-03) necesitan una referencia; el fin de carrera
corta el motor «con independencia del programa» (L2-PLT-07), así que tocarlo
deja la mesa trabada hasta que alguien la saque. Hace falta: (1) un **sensor de
origen** aparte (un tercer microswitch o un sensor magnético a ±46 min) o el
mismo switch con dos contactos, y (2) una **salida explícita** del fin de
carrera (un botón que habilita moverse sólo hacia adentro). Es requisito
nuevo (§7).

**D6. El pivote** [`hipótesis`]. Muchas rótulas de amortiguador a gas tienen
la cazoleta de **plástico** (POM): bajo 18-26 kg se hunde y fluye (y eso es
bamboleo). Tiene que ser **toda de acero** (tipo DIN 71802 de acero) o una
bolilla de acero en el cono, y su altura con calces (±0,8 mm, D4).

**D7. Documentos atrasados** [inspección]: `11-paso-a-paso.md` decía chapa de
1/4" (es 5/16"), rodillo loco de cuatro 608, bulón fresado con buje y mariposa
(son mordazas de borde), CAL-2 0,2 % (es 0,1 %, L2-PLT-03) y CAL-4 «3 píxeles
en 60 s» (L2-OPE-01 da ≈ 1,3). **Corregido hoy** (versión 6). `07` decía el
rodillo de cuatro 608: corregido (versión 8). `13` y `14` quedan como estudios
de su fecha; este documento manda donde se contradicen.

**D8. Lo que el modelo 3D no ve** [inspección]: «Piezas sueltas» y «Choques»
miden que nada flote ni choque, no la precisión. `contacto-vns.js` es esa capa
nueva, y sus controles están en `probar-contacto.js` (seis controles y cuatro
sabotajes, verde; dos de los controles son cuentas de una línea independientes
del cálculo largo).

## 4. Implementación: fabricar, integrar, probar

**I1. «Corta 8 mm» no es «deja una pista»** [`hipótesis`]. Al pedir el corte
(`15` §5.1) hay que preguntar también: rugosidad y ondulación del canto,
conicidad (el láser deja el canto apenas en bisel), de qué lado queda la
rebaba, y si pueden cortar **una muestra** de 100 mm del mismo material.

**I2. El banco del canto (prueba nueva, barata, decisiva)**. La muestra de
láser, apoyada en un mármol de tornería, con un 608 en un brazo que rueda por
el canto y un **comparador milesimal** encima: la altura cada 1 mm a lo largo
de 100 mm. Con esa tira de números, `contacto-vns.js` (escenario `defecto`)
dice cuánto corre la estrella. Es para la pista lo que la palanca óptica es para
el motor: convierte una hipótesis en una medida antes de gastar en chapas,
tornillo o rectificado. La puede hacer la tornería que mida (Acosta, Munro).

**I3. La prueba de rodadura**: un tramo de 100 mm de chapa terminada sobre la
camisa del rodillo elegida, con 25 kg encima y el comparador en la chapa,
rodándola despacio. Mide junto lo que importa (canto, salto, arista) y es la
aceptación de FAB-1 y FAB-4 antes de cortar las dos chapas enteras.

**I4. El orden**: palanca óptica (motor) → banco del canto (pista) → prueba de
foco (P0) → elegir transmisión y rodillo → cortar. Ninguna de las primeras
tres necesita el centro de masa.

**I5. Ajuste, no soldadura, para lo fino**: los calces bajo cada unidad de
rodillo, las ranuras, el tornillo de empuje de las chapas y los calces del
pivote van en el diseño de la fase 3 (D4).

**I6. El rodaje antes de calibrar**: veinte carreras con el dobson arriba
antes de grabar la tabla de corrección (D1). Y la tabla se graba con la
cámara, una noche, como la PEC.

## 5. Operación: la noche de fotos

**O1. Rocío** [`probable`: clima de Buenos Aires]. El secundario, el buscador
y el sensor se empañan en 30-60 min muchas noches. Salidas: una **visera** en
la boca del tubo (cartón o goma eva, gratis) y **resistencias calefactoras** de
12 V en el secundario y el buscador (5-10 W). Cambia la batería: con calefactor,
L1-06 (4 h) pide 2 a 4 veces más energía que con el motor solo.

**O2. El espejo tiene que enfriarse** [`probable`]. Un espejo de 200 mm tarda
30-60 min en acercarse a la temperatura del aire; mientras tanto, la imagen
hierve (2-3″ de más, que es todo el presupuesto). L1-17 pide el primer sub a
20 min de salir: **choca**. Salida de operación, sin hardware: **el tubo sale
primero** y la plataforma se arma mientras se enfría (o un ventilador de PC en
la celda del primario).

**O3. El foco se corre con el frío** [cálculo]. El tubo de 1,2 m se acorta
≈ 14 µm por grado; la profundidad de foco a f/6 es ≈ ±24 µm. Con 2-3° de baja
por noche, **reenfocar cada 30-60 min**, entre subs, con una **máscara de
Bahtinov** (se imprime o se corta en cartón).

**O4. Colimación**: el tubo viaja y se apoya cada noche; dos minutos con un
colimador láser o un Cheshire antes de empezar.

**O5. Óxido y polvo en la pista** [`probable`]. Un granito de tierra en el
canto es un escalón de decenas de micrones (decenas de segundos de arco), y el
acero 1010 se oxida en una noche húmeda: picaduras de micrones. Salidas:
**limpiar canto y rodillos antes de cada noche**, un fieltro con aceite
delante de cada rodillo (como en las guías de las máquinas), las chapas
aceitadas o pavonadas y **la plataforma guardada adentro**.

**O6. Apuntar sin empujar la mesa**: empujar el tubo cerca de la boca hace
palanca sobre la mesa (que apoya, no está atada: R10, y con la F2 hace patinar
el rodillo, K5). Apuntar empujando cerca del eje de altura.

**O7. El cambio de cámara a ocular** (ConOps paso 6) mueve el balance del tubo
en altura; la muesca del dobson no cambia. Ya está en L1-24 y R7.

**O8. La noche nueva en orden** (lo que cambia del ConOps): sacar el tubo
primero → plataforma a sus marcas, limpiar la pista → dobson a su muesca,
mordazas → colimar → rebobinar → apuntar → visera y calefactor → foco con
Bahtinov → exponer; reenfocar cada hora.

## 6. Los planos de disposición

`docs/planos.html` dibuja **cinco hojas A3** desde `geometria-vns.js` y
`contacto-vns.js` (las mismas fuentes que el modelo 3D v10.5), con rótulo y la
marca **PRELIMINAR · NO PARA FABRICAR**:

1. **Planta** (1:10): base, patas, pivote, mesa, rieles, chapas, rodillos, el
   200 en su muesca y la base de un 12"; la tabla de muescas.
2. **Alzado lateral** (1:10): el eje polar por el pivote y el centro de masa,
   la mesa, la chapa, el dobson con el tubo a 45°.
3. **Vista desde el sur** (1:5): las dos chapas de frente, con la forma real
   del canto (sube de una punta a la otra: no es un arco parejo, como lo
   dibujaban los esquemas del Doc 3), los rodillos en su unidad.
4. **La chapa este en su plano, 1:1 en A3**: el canto como envolvente del
   rodillo elegido, talones, los tres ovalados, dónde toca el rodillo a cada
   minuto (centro, 15, 30, y las tres capas de tope) y una barra de control de
   100 mm.
5. **Tolerancias y profundidades**: la tabla de D4 calculada en vivo, y la
   profundidad del canto cada 10 mm (la plantilla en números).

Arriba de la página se cargan **el centro de masa medido, la masa, el
rodillo (Ø22 o Ø32), la separación y la base**, y las cinco hojas se rehacen.
Con el vuelco medido, se pone el número y sale la muesca del 200 con todo lo
demás. El PDF (`planos.ps1`) va al Drive. **No son planos de fabricación**
(PDP §6, Fran 2026-10-07): esos son de la fase 3, con el rodillo, la
transmisión y el centro de masa cerrados.

## 7. Candidatos a requisito (para la versión 0.3, en la fase A)

No se editó `10-requisitos.md` hoy: estos van a la revisión de requisitos,
con sus padres:

| Candidato | Padre | Tipo | Estado |
|---|---|---|---|
| El canto de cada chapa deberá tener una ondulación de no más de 0,002 mm en largos de onda entre 5 y 50 mm. | L2-PLT-02 | desempeño | TBR (depende del 60/30 s y de la medición I2) |
| Cada rodillo deberá girar con un salto radial de no más de 0,002 mm. | L2-PLT-02 | desempeño | TBR |
| Al encenderse, la plataforma deberá establecer la posición de la mesa antes de seguir el cielo. | L1-04 | funcional | definido |
| La plataforma deberá mover la mesa fuera de un fin de carrera sólo con una orden del operador. | L1-04 | otros: seguridad | definido |
| El sistema deberá mantener el espejo secundario sin rocío con una humedad relativa de hasta 95 %. | L1-11 | ambiental | TBR |
| El canto de cada chapa deberá conservar su ondulación después de 50 noches de uso. | L2-PLT-02 | ambiental | TBR |
| (cambio) L2-PLT-04: recorrido de las patas de no menos de 5 cm si la plataforma viaja. | L1-18, L1-09 | restricción | TBD (¿viaja?) |
| (cambio) L1-17: 20 min hasta el primer sub, con el tubo afuera desde antes. | L0-10 | factor humano | TBR |

## 8. Lo que es de Fran (de valor, no técnico)

1. **¿60 s o 30 s por foto, ahora que se sabe lo de la pista?** Con 30 s las
   tolerancias del canto y de los rodillos se duplican y casi todo lo de este
   documento pasa de «rectificado» a «buen fresado». Con 60 s hace falta
   terminar el canto y rodillos de precisión. La sesión recomienda **decidirlo
   con la medición del canto** (I2), no antes.
2. **¿Se paga la terminación de los cantos y los rodillos en una tornería?**
   (fresado CNC o rectificado, y dos camisas rectificadas). Es la plata que
   compra los 60 s.
3. Siguen abiertas: ¿viaja en auto? (fija las patas, K3), ¿cuánto armado?
   (L1-17, que ahora choca con el enfriamiento del espejo, O2), ¿filtro de dos
   bandas?

## 9. Cómo se reproduce

```bash
node docs/contacto-vns.js          # desalineo, método de trazado, tolerancias, cuatro 608
node docs/probar-contacto.js       # controles y sabotajes (sale 1 si algo falla)
```

Supuestos de la cuenta: rodillos y chapas rígidos (sin la deformación de
Hertz, que es de pocos micrones y casi constante), contacto de un cilindro con
un prisma de 7,94 mm, transmisión V/T2 con la punta del brazo en (0, −0,44,
0,135) m (a ojo de la foto, `VARI` del modelo), carrera de ±45 min, geometría
v10.5 con el 200 a 63 cm. La porción de 0,2″ por error es una propuesta de la
sesión (0,5″ de los 1,5″ de L2-PLT-02 para la geometría, repartidos en
cuadratura): la fija el presupuesto de error de la fase 1.
