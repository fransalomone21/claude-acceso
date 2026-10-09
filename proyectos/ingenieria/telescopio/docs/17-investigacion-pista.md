# Investigación de la pista: seis agentes, y lo que corrigen de `16`

**2026-10-09**, decimoséptima sesión, a pedido de Fran («metele con todo,
desplegá agentes»). Seis agentes en paralelo, 3,4 min. El resultado crudo, con
cada fuente, está en `17-investigacion-pista-agentes.json`. **Esto manda sobre
`16` donde se contradicen.** Grado entre corchetes.

## 1. Correcciones a `16` (revisión adversaria de `contacto-vns.js`)

- **La sensibilidad se sostiene** [`probable`]: 1 µm de canto ≈ **0,37″ en
  total** (0,27″ es sólo la parte de bamboleo). Las tolerancias de micrones
  siguen en pie.
- **El «70 % es bamboleo» está mal dicho** [`confirmado`]. El cociente 0,70 es
  de normas: en potencia es **50/50** entre velocidad y bamboleo. Y un guiado
  en AR **sí rescata parte del bamboleo** para blancos australes (factor
  −sen δ, con δ de −50 a −70°: Carina, Nubes). Sólo con δ = 0 es todo
  declinación. `16` K1 decía «el guiado no lo cura»: es demasiado fuerte.
- **La causa del 1,2″ del trazado no es el radio** [`probable`]. Con chapa casi
  sin espesor da 1,55″, y con rodillo de 16 mm da 1,60″ en vez de +45 %: el
  error casi no depende de r. Viene de la cinemática del mapeo del punto alto
  (`uTop`/`thDeU`), no de r(1/cos b − 1). **El número sigue (1,2″) y la salida
  también (trazar la envolvente); la explicación de `16` K2 está mal.** Falta
  identificar el término (prueba: rr → 0).
- **El 0″ de la envolvente es por construcción** [`confirmado`]: el mismo
  `techo()` arma el canto y lo mide. Prueba coherencia, no que una chapa real
  dé 0.
- **La métrica submuestrea las ondas cortas** [`probable`]: compara extremos de
  cada minuto. La onda de 5 mm queda en Nyquist. Hay que muestrear cada ≤ 5 s y
  tomar el máximo menos el mínimo dentro de la foto **antes de fijar la
  tolerancia de las ondas cortas**.
- **«Arista» no tiene umbral** [`probable`]: el código la marca con cualquier
  desalineo. Con micrones de luz, la deformación elástica la cubre. Hace falta
  un umbral de luz contra el aplastamiento antes de exigir el rodillo
  basculante por ese motivo.
- La norma |ω| es una cota superior: la parte a lo largo de la visual es
  rotación de campo [`probable`].

## 2. Lo que trajo la investigación

**Canto láser** [`probable`/`hipótesis`]: un canto láser de 8 mm queda uno o
dos órdenes por encima de 1-2 µm. Tiene Rz de unos 15-80 µm, perpendicularidad
de unos 0,07-0,23 mm y contorno de décimas. **El láser recorta la chapa; no
puede ser la pista.** El único proceso con números cerca es la
**electroerosión por hilo** con 3 o más pasadas: Ra 0,1-0,3 µm, contorno de
±2,5 a 10 µm, a USD 75-125 la hora en EE. UU. Fresado y rectificado de perfil
quedaron sin datos. La ISO 9013 no mide la ondulación a lo largo del contorno.

**Rodillos** [`confirmado`, tabla ISO 492 / JIS B 1514-1]: el salto del aro
exterior de un 608 es P0 15 µm, P6 9, P5 6, **P4 4**, P2 2,5. Comprar un P4 no
alcanza para 2 µm. Los rodillos de leva de catálogo (INA LR/KR/NATR) vienen
**abombados R500**, son angostos y no publican su clase: no van. **Sigue la
camisa cilíndrica de ≥ 20 mm sobre dos 608 de marca, rectificada montada**, y
se acepta midiendo con un comparador milesimal la camisa ya montada.

**Plataformas comerciales** [`confirmado` que no hay dato]: ningún fabricante
(Osypowski, BAA, Vogel) publica un seguimiento sin guiar en arcsec. Un vendedor
dice que para foto hay que calzarla. Un simulador de patente da unos 10″ por
actuador, y pocos arcsec calibrando. **Los 60 s sin guiar a 1200 mm con 1,5″
de plataforma no tienen respaldo externo.** El agente propone fotos cortas
(10-20 s) o prever guiado en AR desde el diseño.

**Pivote** [`probable`]: ni rótula de gas (el POM fluye) ni DIN 71802 (trae
juego sin publicar). Va una **bolilla de rodamiento templada de 1/2" a 5/8"
(G10-G25) en un asiento cónico templado** (≥ 58 HRC, o asentado con la misma
bolilla). En SAE 1010 blando se marca (1,8 GPa). Es rígida (~50 N/µm) y no tiene
juego, porque la carga es siempre de compresión.

**Noche en AMBA** [`probable`]:
- **Foco**: el tubo de acero corre el foco ≈ 12 µm/°C, ≈ 8 µm/°C netos con
  pyrex. Eso es ≈ 0,34″ de desenfoque por °C: hay que reenfocar cada 2-3 °C,
  o ese término entra al presupuesto.
- **Calefactores**: secundario 2-3 W y buscador 3 W, ≈ 2-4 Ah por noche a
  12 V.
- **Espejo**: ≈ 60-90 min sin ventilador y ≈ 30-45 min con ventilador
  (hipótesis). Ojo: el ventilador vibra sobre una mesa sensible al micrón.
- **Clima**: en invierno la humedad relativa media es de 78-79 % y la mínima
  queda sobre el punto de rocío. Hay ≈ 50 % del tiempo con menos de 60 % de
  cielo cubierto: unas 8-12 noches útiles por mes.

## 3. Lo que cambia para mañana (decisiones de Fran)

Con esto, **60 s sin guiar es el caso más difícil y nadie lo documenta**. Hay
tres caminos, del más barato al más caro:

- **(a)** Fotos de **20-30 s**. Es la salida barata; el modo degradado ya
  existe.
- **(b)** **Guiado en AR desde el diseño**. La entrada ST-4 ya está en el
  diseño y a δ austral rescata parte del bamboleo.
- **(c)** **Pista mecanizada**: canto por electroerosión de hilo y camisas
  rectificadas, cotizado en la zona.

La muestra del canto (paso 6c de `11`) sigue siendo la medición que decide.
Antes de usarla, `contacto-vns.js` necesita el muestreo dentro de la foto (§1).
