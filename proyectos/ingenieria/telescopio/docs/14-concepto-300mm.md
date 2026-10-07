# Estudio de concepto: una plataforma para el 200 y un dobson de 300 mm

**Escrito el 2026-10-07 (duodécima sesión)**, a pedido de Fran: «una
necesidad fundamental es que esta plataforma sirva para el 200 con su dobson,
que funcione bien, pero que además tenga la posibilidad de poner un dobson de
300 mm, cuya montura desconocemos». Es trabajo de **Pre-Fase A** (*Concept
Studies*): alternativas, factibilidad y las preguntas de necesidad. **No
elige todavía**: los pesos del trade study los pone Fran (§9), y los
requisitos se reforman con sus respuestas (§8). Grado de cada número entre
corchetes.

## 0. En criollo

- **Sí se puede, y con la misma plataforma.** Un dobson comercial de 300 mm
  pesa lo mismo que el 200 de Fran con su montura de pino (≈ 40-45 kg) y
  tiene el centro de masa **parecido o más bajo**. Las chapas, los rodillos,
  el motor y la base pueden ser los mismos [cálculo, con los datos del 12" en
  `hipótesis`].
- **La corredera de Kevin es la idea correcta, pero va en otro lugar.** En el
  pivote no ajusta el centro de masa: el eje lo fijan las chapas, y correr el
  pivote solo lo desalinea. Donde sirve es **debajo del dobson**: como el eje
  sube hacia el sur, correr el telescopio 10 cm hacia el sur sube 6,9 cm el
  punto del eje que le queda encima (§4).
- **Lo que cambia** es la mesa: más grande (la base de un 12" mide ≈ 63-66 cm)
  y con correderas de ≈ 30 cm de recorrido, con posiciones marcadas (la
  «chaveta» de Kevin) para que cambiar de telescopio no sea recalibrar.
- **La correa dentada pegada a la chapa** (Kevin) no saca el rebobinado y mete
  un error que se repite cada 37 s, justo dentro de cada foto (§6). Es una
  alternativa a puntuar, no un descarte.

## 1. Qué cambió en la necesidad

Hasta hoy el 12" era una **meta** (`10-requisitos.md`, M-03: «debería llevar
60 kg cambiando sólo las chapas y la mesa») y una decisión del PDP §6 (2026-10-07):
«un 12" futuro no se diseña hoy». Fran lo sube a **necesidad**, con dos
condiciones: el 200 **tiene que andar bien** (manda), y el 300 tiene que
**poder** ponerse, con una montura dobson que todavía no se conoce.

Eso reabre una decisión tomada con su fuente, y está bien que se reabra: la
anterior decía «sin modelo no hay requisito verificable». La salida no es
esperar el modelo, es **diseñar para la envolvente** de los dobson de 300 mm
que existen (§3), y escribirla como requisito con su rango.

## 2. Lo que dijo Kevin (WhatsApp, 2026-10-07, transcripción de 4 capturas)

> Transcripto a texto en la sesión que abrió las imágenes (regla del
> perfil). Las capturas quedaron fuera del repo. Lo de Kevin son audios
> transcriptos por WhatsApp: se corrige sólo lo evidente («tornife» →
> tornillo, «gorra dentada» → correa dentada, «blanchuela» → planchuela).

- **14:50, Kevin:** «Sí, yo pensaba lo mismo, que sea de acero.»
- **14:51, Fran:** «Eso no es problema igual.»
- **14:51, Kevin (audio, 0:35):** «Mirá, por ejemplo, si hacemos la guía esta
  regulable que yo te digo, de vos que querés que sea ultra precisa, bueno, se
  puede hacer. Agarrás y en la misma guía le hacés una muesca para que, en vez
  de que el tornillo sólo apriete y haga que no se mueva, el tornillo entre
  como si fuera en una chaveta, para que el tornillo quede inmóvil, y ahí la
  tuerca apriete para que no se salga nomás de lugar. Pero ahí la fuerza te la
  estaría llevando la planchuela. Y te ofrezco una solución.»
- **14:52, Fran:** «Claro, por eso te digo, tenemos que probar todo y cranear
  bien.»
- **14:53, Kevin (audio, 0:14):** «El nivel no me preocupa tanto porque le
  ponemos soportes abajo con tuercas regulables, que se pueda regular la
  altura, y ahí le damos el nivel. Así que eso para mí, pocos problemas.»
- **14:53, Fran:** «Lo del corte láser está bueno.»
- **14:54, Kevin:** «Ahora la pregunta: ¿de qué espesor es la planchuela de
  hierro o acero quirúrgico que podría cortar la máquina láser, y cuánto
  sale?»
- **15:22, Kevin (audio largo, transcripto):** «Eso se puede arreglar
  fácilmente. Se puede hacer una corredera en el pivote, que se ajuste con un
  tornillo, una mariposa también. Te lo explico: un tornillo, una planchuela
  abajo y una planchuela arriba; la planchuela de abajo con un agujerito y una
  corredera en la planchuela de arriba, y que se ajuste con una mariposa.
  ¿Para qué? Para mover la distancia, por ejemplo, del pivote, o el ancho
  también se podría, en caso de que necesitemos cambiar el centro de masa,
  hacerlo más grande o más chico. Tiene una corredera y se puede adaptar: o
  sea, sería una plataforma universal. Después, respecto a las tolerancias y a
  las necesidades que estabas hablando, yo pensaba que todo el peso lo va a
  soportar el rodillito de apoyo, donde va a estar apoyado contra el canto del
  aluminio, y eso tiene que tener también los buenos rulemanes, tiene que
  tener poca fricción. Por eso yo ya [pensaba] en una correa dentada, con unos
  dientitos, con la correa dentada apoyada sobre el canto de aluminio, para
  que sea preciso: o sea, vos vas a saber en qué diente está y en qué posición
  va a estar. O la otra que te había dicho era una varilla que cumple el
  recorrido del motor en cuarenta minutos, cuarenta y cinco. Lo único malo de
  la varilla es que al momento de llegar al final del recorrido vamos a tener
  que rebobinar el motor para que vuelva a iniciar. Y bueno, con la correa
  dentada creo que no tendríamos ese problema. Y también no tendría vibración:
  sería súper preciso.»

**Lo que se toma de Kevin, punto por punto:**

| # | Propuesta | Qué se hace con ella |
|---|---|---|
| K1 | corredera con mariposa en el pivote → plataforma universal | **la idea sí, el lugar no**: la corredera que ajusta el centro de masa va bajo el dobson (§4). En el pivote queda como ajuste fino de armado (±1 cm) |
| K2 | la muesca tipo chaveta: el tornillo no aprieta por rozamiento, la fuerza la lleva la planchuela | **sí**: posiciones marcadas en la corredera, una por telescopio. Hace repetible el cambio de telescopio (L1-15) |
| K3 | el rodillo carga todo el peso; buenos rulemanes, poca fricción | ya está: rodillo loco de cuatro 608 y motriz en dos 608 (`13` §4). El canto es de **acero**, no de aluminio (`13` §6) |
| K4 | correa dentada sobre el canto de la chapa | **alternativa de transmisión** a puntuar (§6) |
| K5 | varilla roscada que cubre el recorrido en 40-45 min | **alternativa de transmisión** a puntuar (§6) |
| K6 | patas con tuercas regulables para nivelar | ya está (L2-PLT-04) |
| K7 | ¿qué espesor corta el láser y cuánto sale? | §7: se cotiza con el DXF; espesor y material |

## 3. Los dobson de 300 mm que hay

Datos de las páginas de los vendedores [`probable`: catálogo, no medido acá].

| Modelo | Tubo | Base | Total | Base al piso | Otros |
|---|---|---|---|---|---|
| **Sky-Watcher Flextube 300P SynScan** (GoTo, tubo de varillas) | 21,0 kg | 24,0 kg | **45,0 kg** | 82,6 × 63,5 cm | ocular al cenit a 148,6 cm; tubo 91 cm cerrado, 140 abierto, Ø 36,2 cm; 1500 mm f/4,9 |
| **Apertura AD12** = GSO 12" Deluxe (tubo cerrado, 1520 mm f/5) | 21,7 kg | 17,4 kg | **39,1 kg** | — | tubo 145,4 cm; armado 161,9 cm de alto |
| **Orion SkyQuest XT12 Classic** (tubo cerrado, 1500 mm) | 22,7 kg | 15,0 kg | **37,7 kg** | 76 cm de alto, 66 cm de ancho | — |
| *El 200/1200 de Fran, para comparar* | 19,2 kg | 19,7 kg | **≈ 40 kg** | 43 × 40 cm | CdM ≈ 63 cm (58 a 69), sin medir |

Precios afuera [2026-10, de las mismas búsquedas]: Flextube 300P manual
≈ 1130-1300 €; GSO 300/1500 ≈ USD 1040-1080; Flextube 300P SynScan USD 2299.
En la Argentina no encontré publicaciones en esta búsqueda.

**El centro de masa de un 12" entero** [`hipótesis`, cuenta propia]: el tubo
balancea en el eje de altura, a ≈ 70-80 cm del piso de la base; la base pesa
15-24 kg con su centro a ≈ 25-35 cm. Juntos: (22 × 75 + 16 × 30) / 38 ≈ 57 cm,
con un rango de **≈ 50 a 62 cm**. El GoTo, con la base más pesada, cae abajo
del rango. **Es igual o más bajo que el 200 de Fran**, que tiene la montura
alta (paredes de 79,6 cm).

**La envolvente que sale de ahí**, para diseñar sin saber el modelo:
masa **≤ 50 kg**, centro de masa **50 a 69 cm** sobre el piso del dobson
(el 200 incluido), base **≤ 70 cm** de diámetro, tubo **≤ 160 cm**.

## 4. La cinemática de «universal»: dónde va la corredera

Las dos chapas giran alrededor del eje polar; su canto es una curva **atada
a ese eje**. El eje lo fijan las chapas, no el pivote: el pivote tiene que
caer sobre el eje que ellas definen. Por eso:

- **Correr el pivote solo** (la corredera de Kevin en el pivote) mueve un
  apoyo fuera del eje de las chapas: la mesa se tuerce y el seguimiento sale
  mal. Sirve para el ajuste fino de armado (que el pivote caiga justo en el
  eje), no para cambiar de telescopio.
- **Lo que tiene que cumplirse es que el centro de masa caiga sobre el eje.**
  El eje sube hacia el sur con la pendiente de la latitud: tan 34,5° = 0,687.
  Correr el dobson **10 cm al sur** lo pone debajo de un punto del eje
  **6,9 cm más alto**. Un telescopio con el centro de masa más bajo va más al
  norte; uno más alto, más al sur. **Las chapas no cambian.**
- **Un Poncet** (plano inclinado en vez de chapas) aceptaría cualquier altura
  de centro de masa, pero a 34,5° el plano queda a 55° del piso: la mesa
  carga de costado. Queda afuera, como ya había quedado en `04` por carga.

**La cuenta** (`geometria-vns.js` sin cambios, la plataforma v9 tal cual;
`node docs/escenarios-300.js`) [cálculo; los datos del 12" son `hipótesis`]:

| Telescopio | Masa | CdM | Corrido | Vuelco | Empujón | Apoyos piv / E / O |
|---|---|---|---|---|---|---|
| 200 (v9) | 40 kg | 63 cm | 0 | 24,1° | 6,9 kg | 14,7 / 16,6 / 16,6 kg |
| 200, rango bajo | 40 | 58 | 7,5 cm al norte | 23,4° | 6,3 | 17,7 / 15,2 / 15,2 |
| 200, rango alto | 40 | 69 | 8,5 cm al sur | **18,4°** | 7,6 | 11,4 / 18,3 / 18,3 |
| 12" liviano, CdM bajo | 40 | 52 | 19 cm al norte | 22,3° | **5,3** | 22,2 / 12,9 / 12,9 |
| 12" GoTo, CdM bajo | 50 | 52 | 16 cm al norte | 22,5° | 6,7 | 25,7 / 16,2 / 16,2 |
| 12" GoTo, CdM alto | 50 | 62 | 1,5 cm al norte | 23,9° | 8,2 | 18,5 / 19,7 / 19,7 |

Lo que dice la tabla:

1. **La corredera necesita ≈ 28 cm** de recorrido (de 8,5 al sur a 19 al
   norte) para cubrir la envolvente entera con las chapas de hoy. Con el
   suplemento (L2-PLT-05) se acorta.
2. **Los rodillos y la chapa no se enteran**: la carga máxima por rodillo es
   19,7 kg, menos que los 25 kg con que se dimensionó la chapa de 1/4"
   (`13` §7). El pivote sube a 25,7 kg.
3. **Lo que se pone en rojo no es el 12"**: es el 200 en el borde alto de su
   rango (vuelco 18,4°, contra los 22° de L1-14), y el 12" liviano en el
   empujón (5,3 kg contra 6 del dobson solo, L1-13). Los dos dependen del
   centro de masa del 200, que **sigue sin medir**: el vuelco del paso 1 de
   `11` destraba también esto.
4. **La mesa crece**: hoy mide 54 × 60 cm; una base de 12" pide ≈ 70 cm de
   ancho, y la corredera suma largo.

## 5. Las alternativas de arquitectura

| | Concepto | A favor | En contra |
|---|---|---|---|
| **U0** | plataforma dedicada: para el 12" se cortan **otras chapas y otra mesa** (lo que hoy dice M-03) | el 200 queda óptimo; nada nuevo que diseñar hoy | cambiar de telescopio es desarmar; dos juegos de chapas (dos cortes láser) |
| **U1** | **mesa universal**: chapas, rodillos, motor y base únicos; el dobson va sobre correderas norte-sur con posiciones marcadas (K1 + K2 reubicados), y suplemento para el ajuste fino | un solo juego de chapas; cambiar de telescopio es correr y apretar mariposas; la cuenta da (§4) | mesa más grande y pesada (≈ +3-4 kg); el vuelco del 200 en el borde alto pide base más ancha o medir antes |
| **U2** | U1 con **adaptadores por telescopio**: una placa propia de cada dobson que se abulona en la mesa en su posición | el cambio es abulonar una placa; la posición queda fija de fábrica | una placa por telescopio; para un 12" que todavía no existe, la placa se hace cuando exista |
| **U3** | corredera en el **pivote** (K1 textual) | — | no cumple la cinemática (§4): **descartada como ajuste de telescopio**; queda como ajuste de armado |

**Criterios escritos antes de puntuar** (los de `05`, más uno nuevo):

1. changüí: ponerla y que ande, sin recalibrar (peso de Fran 2026-10-04: 0,4);
2. facilidad de construcción (0,3);
3. capacidad de carga — ahora con un dueño: el 12" (0,2, **a confirmar**);
4. costo (0,1);
5. **nuevo: cambiar de telescopio** (cuánto cuesta pasar del 200 al 300 y
   volver). **Sin peso: lo pone Fran.**

## 6. Las alternativas de transmisión

Velocidad del canto a 74,5 cm del eje (el v9): **54 µm/s, 19,6 cm por hora**
[cálculo].

| | Concepto | A favor | En contra |
|---|---|---|---|
| **F** | rodillo motriz de acero por **fricción** sobre el canto + GT2 20:80 (lo de `13`) | sin dientes: el error más rápido es la polea de 20 (≈ 8 min) y el rodillo da una vuelta cada ≈ 31 min, los dos lentos y calibrables; si se traba, **patina antes de romper** | puede patinar si el centro de masa queda mal (agarre ≈ 25 N contra 2-4 N de empuje, `13` §4) |
| **B** | **correa dentada pegada al canto** y un piñón (Kevin) | no patina: se sabe en qué diente está | un diente de 2 mm pasa **cada 37 s**: su ondulación cae **dentro** de cada foto, y 5 µm de ondulación son 1,4″ en el cielo, todo el presupuesto de la plataforma (1,5″, L2-PLT-02) [`hipótesis` sobre los 5 µm]. Piñón directo: 3,5″ por micropaso, así que **igual necesita reducción**. La correa pegada sobre un canto elíptico cambia el radio de paso a lo largo de la carrera (se corrige con la tabla, como la F) |
| **T** | **varilla roscada** con brazo tangente (Kevin) | empuje positivo, piezas comunes | error de tangente (5-10 min sin corregir; se corrige en el programa); la varilla roscada común tiene alabeo, que se repite cada vuelta (≈ 2-4 min con una varilla de paso 8) |

**El rebobinado no separa a ninguna**: la plataforma tiene una carrera de
90 min y **cualquier** transmisión rebobina al final (L1-03). Con un paso a
paso, rebobinar 9 cm de varilla de paso 1,25 son 72 vueltas: ≈ 15 s a
300 rpm. Lo que dijo Kevin de la correa («no tendríamos ese problema») no se
sostiene; lo que sí es cierto es que la B **no patina**.

**Criterios para la transmisión** (sin pesos: los pone Fran): precisión en la
foto (error dentro de un sub), que no patine ni pierda la posición, facilidad
de construcción, costo.

## 7. Las chapas: material, espesor y quién las corta (la pregunta de Kevin)

- **Material.** Acero **SAE 1010/1020** (`13` §6). El inoxidable
  («quirúrgico», 304/316) **no aguanta más presión de contacto** que el acero
  dulce —su fluencia recocido es parecida— y cuesta varias veces más. Lo que
  sí tiene es que **no se oxida**, y un punto de óxido en el canto es un
  escalón que se ve en la foto (con rocío, L1-11). Es una elección real:
  **acero dulce con el canto protegido** (aceite o cera, guardado adentro) o
  **inoxidable**. La decide el costo cotizado, no hoy.
- **Espesor.** Con chapas compartidas (U1) la carga máxima por rodillo es
  19,7 kg (§4): la de **1/4" (6,35 mm)** alcanza. Si se quiere margen para un
  12" con accesorios, **5/16" (7,94 mm)** [cálculo de `13` §7]. Los dos son
  espesores que corta cualquier láser de fibra de taller [`hipótesis`:
  cotizar].
- **Precio.** **TBR**: se cotiza con el DXF de las dos chapas (≈ 0,1-0,2 m²,
  ≈ 2,5 m de corte) en dos talleres. Sin DXF no hay cotización seria, y el DXF
  sale del centro de masa medido.

## 8. Qué cambia en los requisitos (propuesta; se aplica con las respuestas de §9)

| ID | Hoy | Propuesta |
|---|---|---|
| **N-12** (nueva) | — | Fran necesita poner en la misma plataforma, más adelante, un dobson comercial de 300 mm cuyo modelo todavía no eligió. |
| L0-05 | usar la montura dobson existente | se mantiene para el 200; se agrega un L0 hermano para el 300 (la montura comercial, sin modificarla) |
| L1-07 | el tubo en la montura existente | se agrega: la plataforma recibe un dobson de la envolvente de §3 |
| L1-15 | CdM a ≤ 1 cm del eje | igual, **para cada telescopio** de la envolvente |
| L1-16 | piezas ≤ 20 kg | se revisa: la base de un 12" GoTo pesa 24 kg sola (no es pieza de la plataforma, pero se sube a la mesa) |
| L2-PLT-05 | ajuste de ≥ 12 cm de altura sin cortar | ajuste de **50 a 69 cm** de centro de masa sin cortar (≈ 28 cm de corredera, o corredera más suplemento) |
| L2-PLT-12 | 3 puntos, ajuste a mano | igual, con **posiciones marcadas** (K2) para cada telescopio |
| **L2-PLT-14** (nueva) | — | la mesa recibe una base de hasta 70 cm de diámetro |
| **L2-PLT-15** (nueva, según §9) | — | pasar del 200 al 300 en no más de N min sin cortar ni soldar |
| M-03 | meta: 60 kg cambiando chapas y mesa | sube a requisito (L1) con la envolvente de §3: 50 kg de telescopio + mesa |
| L1-01 | 2″ en 30 s | **a revisar**: a 1500 mm un píxel es 0,54″ en vez de 0,67″; el criterio en el cielo es el mismo, pero en píxeles el 300 muestra 25 % más el mismo error |

## 9. Lo que sólo Fran puede decidir

1. **¿Cuánto se puede tocar para pasar del 200 al 300?** (fija U0 / U1 / U2).
2. **¿Qué 300?** ¿Puede ser un GoTo (≈ 45-50 kg) o sólo manual (≈ 38-40 kg)?
   (fija la carga y el espesor de las chapas).
3. **¿Qué pesa más si chocan:** el 200 perfecto, o la plataforma universal?
   (los pesos del trade study).
4. **La transmisión:** ¿qué importa más, que no se escape nunca de la posición
   (B, T) o que la foto salga más limpia (F)?
5. Las tres de antes que siguen abiertas (`10` §11.1): 30 o 60 s por foto,
   ¿viaja en auto?, ¿cuánto armado?

## 10. Lo que no se decide hoy

- **El modelo de 12"**: no hace falta; se diseña para la envolvente.
- **Planos**: no, fase 0.
- **El ancho de la base al piso** para el 200 en el borde alto: sale del
  vuelco medido.
- Fuentes de §3: [Agena, Flextube 300Pi](https://agenaastro.com/sky-watcher-12-flextube-synscan-300pi-goto-collapsible-dobsonian-telescope-s11825.html),
  [B&H, Flextube 300P SynScan](https://www.bhphotovideo.com/c/product/1141691-REG/sky_watcher_s11820_12_goto_collapsible_dobsonian.html/specs),
  [Astromart, Apertura AD12](https://astromart.com/reviews/telescopes/newts/show/apertura-ad12-great-things-come-in-large-packages),
  [Astromart, Orion XT12](https://www.astromart.com/reviews/telescopes/newts/show/orion-skyquest-xt12-intelliscope),
  [telescopes-et-accessoires, precios](https://www.telescopes-et-accessoires.fr/telescopes-dobson/8704-telescope-dobson-sky-watcher-300-3664055000506.html).
