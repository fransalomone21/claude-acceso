// La decisión de los 60 s y la lista de electrónica, para Fran.
// Fuente única del PDF «Electronica y la decision de los 60 s» del Drive.
// Compilar: typst compile docs/20-decision-y-electronica.typ docs/20-decision-y-electronica.pdf

#let tinta = rgb("#15202c")
#let gris = rgb("#5a6878")
#let acento = rgb("#b8650a")
#let linea = rgb("#cfd7e1")
#let suave = rgb("#eef1f5")
#let calido = rgb("#fdf3e6")
#let verde = rgb("#2f7d4f")

#set document(title: "Electrónica y la decisión de los 60 s", author: "Fran")
#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1 / 1",
  footer: context [#set text(8pt, fill: gris); Telescopio 200/1200 y la facu · 24 de octubre de 2026 #h(1fr) #counter(page).display("1 / 1", both: true)])
#set text(font: ("Arial", "Liberation Sans"), size: 10.5pt, lang: "es", fill: tinta)
#set par(justify: true, leading: 0.62em)
#show math.equation: eq => { show ",": it => math.class("normal", it); eq }
#set heading(numbering: "1.1")
#show heading.where(level: 1): it => block(above: 1.4em, below: 0.8em)[#text(16pt, fill: acento, weight: "bold")[#it]]
#show heading.where(level: 2): it => block(above: 1.1em, below: 0.6em)[#text(12.5pt, weight: "bold")[#it]]
#set table(stroke: 0.4pt + linea, inset: 5pt)
#show table: set par(justify: false)
#show table: set text(hyphenate: false)
#show table.cell.where(y: 0): set text(weight: "bold", size: 9pt)

#let caja(titulo, cuerpo, fondo: calido, borde: acento) = block(width: 100%, fill: fondo, stroke: (left: 3pt + borde), inset: 9pt, radius: 2pt, breakable: false)[#if titulo != none [#text(weight: "bold")[#titulo] #linebreak()]#cuerpo]
#let costo(n) = text(fill: acento, weight: "bold")[#("$" * n)]
#let tenes = text(fill: verde, weight: "bold")[ya lo tenés]

#align(left)[
  #text(9pt, fill: acento, tracking: 1.5pt)[TELESCOPIO 200/1200 · TALLER · FACU]
  #v(2pt)
  #text(22pt, weight: "bold", hyphenate: false)[Electrónica, y la decisión de los 60 segundos]
  #v(2pt)
  #text(11pt, fill: gris)[Qué dice la evidencia de otros proyectos, qué conviene decidir, y la lista de todo lo que vas a necesitar (y disfrutar), por prioridad y con su porqué.]
]

#v(6pt)
#caja([En una línea])[
  *Fotos de 30 s como requisito, 15 a 30 s en el patio, y el guiado en un eje para cuando viajes a un cielo oscuro.* La pista mecanizada no: es pagar mucha plata para ganar un 1 % de señal en el patio. Y para comprar: lo de la prioridad 1 ya, que destraba el telescopio y el cohete a la vez.
]

#outline(title: [Qué hay adentro], depth: 1, indent: auto)

= La decisión de los 60 s

== Qué se está decidiendo

El 8 de octubre elegimos fotos (subs) de 60 s sin guiar. Ese número es el que manda la precisión de todo: la alineación polar, la velocidad del motor, y sobre todo la *pista* —el canto de las chapas y los rodillos—, que para 60 s pide errores de una o dos milésimas de milímetro. Las tres salidas que quedaron sobre la mesa: *(a)* bajar a 30 s, *(b)* sumar guiado en un eje, *(c)* mecanizar la pista para sostener los 60 s.

== Lo que dice la evidencia (y de dónde sale)

*Primero, lo que lograron otros con plataformas.* La búsqueda del 9 de octubre (seis agentes, en `docs/17`) no encontró un solo fabricante —ni Osypowski, ni las del club británico BAA, ni Reiner Vogel— que publique cuántos segundos de arco sigue una plataforma sin guiar. Lo que sí aparece en los foros es poco alentador: en IceInSpace, un dueño de una plataforma casera para un dobson de 10" contaba que lograba subs de 4 s y que su objetivo de 10 s nunca llegó; en Stargazers Lounge, a alguien que preguntaba por exposiciones de 5 minutos sobre plataforma le contestaron que eso cuesta hasta con una montura ecuatorial. Y el dato que más dice: las plataformas *comerciales para fotografía* (las TMS-Astro que venden Astroshop y Omegon) vienen con dos ejes y entrada ST-4 para autoguiado. El que vende para foto da por hecho que se guía. #text(fill: gris)[Grado: `probable`; son relatos de foro y fichas de vendedor, no mediciones.]

*Segundo, lo que da el cielo del patio.* Acá está la clave, y es física, no opinión. En un cielo con contaminación lumínica, pasado cierto tiempo de sub la foto ya no mejora: el ruido lo pone el brillo del cielo, no la cámara. El criterio que usa la comunidad (Robin Glover, el de SharpCap) dice que alcanza con un sub de

$ t_("sub") approx (10 dot R^2) / L $

donde $R$ es el ruido de lectura de la cámara (en electrones) y $L$ cuánta luz del cielo cae en cada píxel por segundo. Con la Sony a ISO alto ($R$ cerca de 2 electrones, `hipótesis` hasta medirlo) y un cielo de Villa Adelina, que es Bortle 7 a 8, $L$ fácilmente pasa de 3 electrones por segundo a f/6: el sub útil da del orden de *10 a 20 s*. Nuestra propia cuenta del 7 de octubre (`docs/14`, §6b) llegó a lo mismo por otro camino: en el patio, 60 s contra 30 s gana *un 1 % de señal sobre ruido*. En un cielo oscuro como Punta Indio sí gana, un 15 a 20 %.

*Tercero, lo que cuesta la pista.* Para 60 s, el canto tiene que ser parejo a una o dos milésimas. Un corte láser deja una rugosidad de 15 a 80 milésimas: no sirve como pista. Lo único con números cerca es la electroerosión por hilo con varias pasadas, a 75-125 dólares la hora en Estados Unidos, sin cotización acá.

== La decisión, y por qué

#caja([La mejor decisión: (a) ahora, (b) después, (c) nunca], fondo: suave, borde: verde)[
  - *El requisito pasa a 30 s* (L1-01 y sus hijos). En la práctica, en el patio se saca de *15 a 30 s*: más largo no suma nada y arriesga estrellas estiradas.
  - *El guiado en un eje (b) queda como la segunda etapa*, que ya estaba en el plan (subs de 2 a 4 min con autoguiado). Se activa cuando la plataforma viaje a un cielo oscuro, que es el único lugar donde los subs largos pagan. La entrada ST-4 ya está en el diseño, así que no hay que rehacer nada.
  - *La pista mecanizada (c) se descarta:* es lo más caro y en el patio compra un 1 %.
]

*Por qué es la mejor y no sólo la más barata.* Porque las tres líneas de evidencia apuntan al mismo lado: nadie demostró 60 s sin guiar con una plataforma a 1200 mm, el cielo del patio no deja aprovecharlos, y sostenerlos cuesta lo que más cuesta del proyecto. Además se puede deshacer: es cambiar un número en el papel, y la muestra del canto puede devolvernos a 60 s si el láser sale mejor de lo esperado. Las otras dos opciones cierran puertas o gastan plata antes de saber.

*Qué cambia con 30 s.* Vuelven los números de antes del 8/10: alineación polar de 7 minutos de arco en vez de 3,5, velocidad media con 0,2 % de error en vez de 0,1, y la corrección periódica del motor pasa de obligatoria a recomendable. Las ondas largas del canto pesan la mitad; las cortas siguen pidiendo micrones, y eso lo dice la muestra. *Lo que no cambia:* la transmisión de una sola correa sigue afuera, porque el error de cada paso del motor no depende de cuánto dure la foto (tiembla igual cada 2 s). Siguen en carrera la de dos correas y la de tornillo de bolas.

*Lo que hay que revisar en la etapa 2.* Guiar pide una camarita y algo que la maneje de noche (una Raspberry Pi con PHD2, por ejemplo), y hoy un requisito dice «sin computadora durante la noche» (L0-08). Una Pi chiquita pegada a la plataforma probablemente cumpla el espíritu (nada de notebook), pero se decide ahí, no ahora.

#caja([Un spike para confirmarlo, de 5 minutos])[
  Una noche cualquiera, la Sony en el portaocular (con lo que se use para la prueba de foco), ISO 1600, una foto de 10 s a un pedazo de cielo sin estrellas brillantes. Me pasás el archivo crudo y leo cuánto fondo junta: con eso $L$ deja de ser hipótesis y el sub óptimo del patio queda medido, no estimado.
]

#caja([Lo que corrige esto en el método], fondo: suave, borde: gris)[
  Tenés razón en lo que dijiste: esta evidencia tenía que estar al *abrir* el concepto, no al cerrarlo. Quedó registrado como defecto del método (DA-081) y como lección, y en el telescopio ya es condición para cerrar la primera etapa: cada número que manda lleva su precedente externo o queda marcado como hipótesis. El resto de los números que mandan (los 60 min de carrera, el centro de masa a 1 cm del eje, el foco) se completan así en la revisión del concepto.
]

= La lista de electrónica, por prioridad

Cómo leer las tablas: la *prioridad* dice cuándo conviene tenerlo; el *porqué* es el rationale, qué destraba y por qué ese modelo y no otro. El costo va en clases porque no está cotizado: #costo(1) es lo de un par de cafés, #costo(2) lo de una salida, #costo(3) una compra que se piensa. Lo que ya tenés está marcado. Todo lo de las prioridades 1 a 3 sirve *gane la transmisión que gane*.

== Prioridad 1 — ya: destraba el telescopio y el cohete

#table(
  columns: (2.2fr, 0.8fr, 3.5fr, 0.6fr),
  table.header([Qué], [Cuántos], [Por qué (rationale)], [Costo]),
  [*NEMA 17* 1,8°, 40 a 48 N·cm, 1,5 a 2 A, cuerpo de 40-48 mm, eje de 5 mm], [1-2], [El motor de la plataforma y el del banco de la palanca óptica, que es la medición que elige la transmisión. 4 kg·cm deja 6,5 veces de margen contra una ráfaga de 40 km/h. A tu amigo: que la etiqueta diga 17HS4401, 17HS4401S, 17HS8401 o parecido. Los chatos de 20-23 mm (1,6 kg·cm) no.], [#costo(2)],
  [*Driver TMC2209* v1.2 o v1.3], [2], [Mueve el motor en silencio y con micropasos suaves, que es justo lo que pide seguir el cielo lento y parejo. El A4988 hace ruido y pierde micropasos. Uno de repuesto: se queman.], [#costo(1)],
  [*ESP32 DevKit* (WROOM-32)], [2], [El cerebro de la plataforma: botón de rebobinar, entrada de guiado, la tabla que corrige la velocidad, y el Bluetooth y la pantalla que quería Kevin. El segundo, para la facu.], [#costo(1)],
  [*ESP32-C3 SuperMini*], [2], [La placa del cohete de agua. Chiquita, barata y con Wi-Fi: la que más vas a usar en la facu.], [#costo(1)],
  [*BMP280* (GY-BMP280, I2C)], [2], [El sensor de presión del cohete: de ahí sale la altura y el apogeo. Dos, porque uno siempre termina soldado a algo.], [#costo(1)],
  [*OLED 0,96"* 128×64 I2C SSD1306], [2], [La pantalla del cohete y la de la plataforma (cuánto le queda a la carrera). La de 1,3" usa otro chip (SH1106): si comprás esa, el código cambia una línea.], [#costo(1)],
  [Capacitor electrolítico *100 µF 35 V*], [4], [Uno pegado a cada TMC2209. Sin él, el pico al enchufar el motor puede quemar el driver: es el seguro más barato de la lista.], [#costo(1)],
  [*Microswitch con palanca de rodillo* (KW12)], [3], [Los dos fines de carrera de la plataforma, la segunda capa de seguridad, y uno de repuesto.], [#costo(1)],
  [Puntero láser chico y un espejito], [1], [La palanca óptica: un paso del motor mueve el punto 126 mm en una pared a 2 m, y el error de cada paso se ve con una regla.], [#costo(1)],
)

== Prioridad 2 — el banco de trabajo: multiplica todo lo demás

#table(
  columns: (2.2fr, 0.8fr, 3.5fr, 0.6fr),
  table.header([Qué], [Cuántos], [Por qué (rationale)], [Costo]),
  [Fuente de PC (ATX)], [—], [#tenes. Da 12, 5 y 3,3 V con amperes de sobra: es una muy buena fuente de banco.], [—],
  [*Adaptador ATX a bornes* (breakout de 24 pines, con llave)], [1], [Saca las tres tensiones a bornes y la prende con una llave, sin puentear el cable verde con un clip.], [#costo(1)],
  [*Portafusibles y fusibles* de 2 y 5 A], [2 y 10], [La fuente entrega 15 a 40 A en los 12 V: un corto derrite un cable antes de que ella se dé cuenta. Un fusible entre la fuente y cada cosa que pruebes.], [#costo(1)],
  [*Step-down regulable* LM2596 (3 A) y MP1584 (mini)], [3 y 3], [Bajan los 12 V a lo que pida cada placa. El LM2596 para cosas con consumo; el MP1584 para meter adentro de un proyecto.], [#costo(1)],
  [*Soldador regulable* de 60 W, estaño de 0,8 mm con flux, malla desoldadora], [1], [Si no tenés uno con temperatura, es la mejor compra de la lista: con uno malo las placas chinas se levantan y se pierde la tarde.], [#costo(2)],
  [*Analizador lógico* 8 canales, 24 MHz], [1], [Te deja ver qué pasa en el I2C o el UART cuando un sensor «no anda». Con PulseView gratis. Para Software de Vuelo es oro.], [#costo(1)],
  [Multímetro], [—], [#tenes (UT89X).], [—],
  [Protoboard y cables], [—], [#tenes. Sumá otra de 830 y cables dupont macho-macho, macho-hembra y hembra-hembra, 40 de cada.], [#costo(1)],
  [Calibre digital], [1], [Si no tenés: lo pide el inventario del telescopio (paredes de tubo, varillas de 8,00 mm).], [#costo(1)],
  [Pelacables, alicate de corte, termocontraíble surtido, crimpeadora dupont/JST], [1 c/u], [Las conexiones que se sueltan son la mitad de las fallas de un proyecto.], [#costo(2)],
)

== Prioridad 3 — la facu de este año y la que viene

#table(
  columns: (2.2fr, 0.8fr, 3.5fr, 0.6fr),
  table.header([Qué], [Cuántos], [Por qué (rationale)], [Costo]),
  [NUCLEO-F446RE], [—], [#tenes. Trae el ST-Link adentro: no hace falta comprar un programador aparte.], [—],
  [*MPU6050* (GY-521)], [1], [Aceleración y giro: actitud de un cohete o de un satélite de juguete. Si después querés lo bueno, un BNO085 ya da la orientación calculada.], [#costo(1)],
  [*BME280*], [1], [Como el BMP280 más humedad. En el telescopio avisa cuándo viene el rocío. Ojo: muchos «BME280» baratos son BMP280; se ve leyendo el número de chip.], [#costo(1)],
  [Módulo *microSD*], [1], [Guardar un vuelo entero para analizarlo después.], [#costo(1)],
  [*Servo MG90S* (engranajes de metal)], [2], [Los paracaídas del cohete; los de plástico (SG90) pelan los dientes.], [#costo(1)],
  [*RTC DS3231*], [1], [Un reloj que no se atrasa: registros con la hora real.], [#costo(1)],
  [*INA219*], [1], [Mide corriente y tensión: cuánto consume el motor en el banco, que es lo que define la batería de la plataforma.], [#costo(1)],
  [*GPS* u-blox NEO-M8N], [1], [Posición y hora exacta; también para alinear la plataforma por latitud.], [#costo(2)],
  [*LoRa* SX1276 (915 MHz) x2], [2], [Telemetría a kilómetros con muy poco consumo. En Argentina la banda libre es 915-928 MHz (`hipótesis`, verificarlo antes de transmitir).], [#costo(2)],
  [*HX711 y celda de carga* de 5-10 kg], [1], [Ensayo estático: medir el empuje de un cohete o el par del motor de la plataforma.], [#costo(1)],
  [Conversor de niveles 3,3/5 V (BSS138)], [2], [Para no freír una placa de 3,3 V con un módulo de 5 V.], [#costo(1)],
  [MOSFET *IRLZ44N*, diodos 1N5819, relé de 5 V], [5, 10, 2], [Prender cosas de 12 V desde la placa: los calefactores contra el rocío, un ventilador, una bomba.], [#costo(1)],
  [Kits: resistencias, capacitores, LEDs, pulsadores; placa perforada 5×7 y 7×9, tiras de pines, borneras], [1 c/u], [El «tengo uno en el cajón» que salva un domingo.], [#costo(2)],
  [*Power bank USB-C PD y gatillo PD a 12 V* (ZY12PDN)], [1], [Posible batería del telescopio en el patio: una power bank grande entrega 12 V con el gatillo. Se confirma con el consumo medido (INA219).], [#costo(2)],
)

== Prioridad 4 — para disfrutar, explorar y la etapa 2 del telescopio

#table(
  columns: (2.2fr, 0.8fr, 3.5fr, 0.6fr),
  table.header([Qué], [Cuántos], [Por qué (rationale)], [Costo]),
  [*Osciloscopio* de 2 canales, 50-100 MHz (tipo Rigol DS1054Z o Hantek DSO2D10)], [1], [Ver la señal es entender la electrónica: Teoría de Circuitos y Analógica dejan de ser cuentas. El Hantek trae generador de funciones adentro.], [#costo(3)],
  [*Raspberry Pi 4 o 5*], [1], [Para la etapa 2: maneja la cámara guía con PHD2 y la plataforma por ST-4. Y para jugar: servidor, cámara, robot.], [#costo(3)],
  [*Cámara guía* (SVBONY SV305 o ZWO ASI120MM Mini) y buscador guía de 30-50 mm], [1], [La etapa 2 del telescopio: los subs largos en cielo oscuro. No antes de tener la plataforma andando.], [#costo(3)],
  [Fuente de laboratorio regulable 30 V 5 A], [1], [Con límite de corriente: probás algo nuevo sin miedo a quemarlo. La ATX no limita.], [#costo(2)],
  [*DRV8833* o L298N], [1], [Para los motores de continua de la casetera: no sirven para el telescopio, pero sí para un autito o un robot.], [#costo(1)],
  [28BYJ-48 con ULN2003], [2], [Paso a paso de juguete: aprender micropasos sin arriesgar el NEMA.], [#costo(1)],
  [Raspberry Pi Pico (RP2040) y ESP32-S3 con cámara], [1 c/u], [Otra familia para aprender (el Pico tiene E/S programables), y visión con el S3.], [#costo(1)],
  [Tira de LEDs WS2812, pantalla TFT 2,4" ILI9341, encoder rotativo, buzzer, joystick], [1 c/u], [Interfaces lindas: un menú en la plataforma, un tablero, un regalo.], [#costo(1)],
  [Celdas 18650, cargador TP4056 con protección, BMS], [2-4], [Proyectos a batería de verdad. Con cuidado: una 18650 en corto es un fuego chico.], [#costo(2)],
)

== Lo que todavía NO se compra, y por qué

#table(
  columns: (2.3fr, 4.7fr),
  table.header([Qué], [Por qué esperar]),
  [La chapa de 5/16" y su corte], [Después de la prueba de foco (si la cámara no llega, cambia el plan) y de la muestra del canto.],
  [Correas, poleas GT2, tornillo de bolas], [Dependen de la transmisión, que la elige la palanca óptica.],
  [Rulemanes 608], [Tenés los del roller; se cuentan en el inventario.],
  [La batería de campo], [Sale del consumo medido en el banco (con el INA219).],
  [Cámara guía], [Etapa 2: primero la plataforma siguiendo sola.],
)

#v(4pt)
#text(9pt, fill: gris)[Fuente de este documento: `proyectos/ingenieria/telescopio/docs/20-decision-y-electronica.typ` en el repositorio. La evidencia de plataformas viene de la búsqueda del 9/10 (`docs/17`) y de foros (IceInSpace, Stargazers Lounge) y fichas de vendedores (Astroshop, Omegon); el criterio del sub viene del foro de SharpCap; la cuenta del cielo del patio, de `docs/14`. Precios: sin cotizar.]
