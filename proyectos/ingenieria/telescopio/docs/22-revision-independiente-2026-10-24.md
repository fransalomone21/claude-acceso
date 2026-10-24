# Revisión independiente del concepto — 24 de octubre de 2026

**Qué es:** el punto 6 del criterio de salida de la fase 0 (`PDP.md` §4). La escribió una sesión que **no
escribió el concepto** (el *outsider* de NASA, SEH p. 68; la cátedra: validan quienes no lo escribieron). No se le
creyó a ningún número del repo hasta rehacerlo con una cuenta propia. **No se editó** `10-requisitos.md`, el modelo
3D ni los `.js` del diseño: acá se propone, y la sesión autora aplica.

**Cómo se reproduce:** `node docs/22-revision/revision.js` y `node docs/22-revision/revision2.js`. La física es
propia (vuelco con patas, empujón en la boca, par de desbalance, errores periódicos, actuador de declinación,
coma); de `geometria-vns.js` se toman **sólo posiciones** (patas, pivote, rodillos, centro de masa). Control
positivo: con las patas en cero, mi vuelco da lo mismo que `probar-requisitos.js` (20,4° en el peor caso), y mis
errores periódicos dan lo mismo que la función `tabla()` de `transmisiones.js` corrida a 30 s. Grado de cada cosa
entre corchetes; **severidad**: *concepto* (una decisión de arquitectura o de Fran descansa en una cuenta mala, o
lo construido no cumpliría), *diseño* (cambia un número o un detalle), *redacción*.

## 0. En criollo

La arquitectura (VNS espejada, tarjeta madre, trazador primero, 30 s con guiado previsto) **se sostiene**: no
apareció nada que la tire. Pero hay **seis hallazgos de concepto**, y los tres más graves son de la misma familia
que los once de `21`: una cuenta hecha para otro caso (60 s, el 608, la base sin patas, el empujón a 1,3 m) que
se arrastró a una decisión nueva sin rehacerla. El que más pesa: **con 30 s, ninguna transmisión candidata entra
en su presupuesto sin la corrección periódica (PEC)**; `14` §6b la dio por «recomendable» con una cuenta que ya
daba el presupuesto entero. Nada de esto pide cortar ni comprar distinto todavía: pide rehacer cuentas, corregir
tres verificadores ciegos y decidir dos cosas antes de cortar las chapas del trazador.

## 1. Los números que deciden, rehechos

| # | Número o afirmación | Dónde | Mi cuenta | ¿Coincide? | Grado |
|---|---|---|---|---|---|
| 1 | L1-01: 2″ en 30 s, reparto 1,5 / 0,5 / 1 en cuadratura = 1,9″ | `10` §7 | √(1,5² + 0,5² + 1²) = 1,87″ | sí | confirmado (aritmética) |
| 2 | escala 0,67″/px (ZV-E10 a 1200 mm) | `10` L1-01 | 3,92 µm / 1200 mm = 0,674″/px | sí | confirmado |
| 3 | L2-OPE-01: 7′ → 0,9″ en 30 s | `10` §7 | 7′ × 15,04″/s × 30 s = 0,92″ | sí | confirmado |
| 4 | L1-26: 30′ → 1,3″ en 10 s | `10` §7 | 1,31″ | sí | confirmado |
| 5 | L2-OPE-04: 1 mm a 1,2 m → 3′ | `10` §7 | 2,9′ | sí | confirmado |
| 6 | L2-PLT-15: 2 mm de corredera → 1,1 mm fuera del eje | `10` §7 | 2 × sen 34,5° = 1,13 mm | sí | confirmado |
| 7 | la mesa se inclina 9,3° a 45 min y 10,5° en el talón | `10` L2-MON | 9,27° y 10,50° (cos α = s² + c² cos θ) | sí | confirmado |
| 8 | L2-MON-02/03: 12° con la base a 4° | `10` §7 | 11,46° compuesto (no pitagórico) | sí, entra | confirmado |
| 9 | L1-02: 60 min, el diseño da 90 | `10` §7 | ±45 min = 90; precedente TMS-Astro 60 min | sí | confirmado |
| 10 | L1-14 origen: el dobson solo vuelca a 18,8° | `21` F3 | atan(21,5 / 63,2) = 18,79° | sí (para el 200) | confirmado; ver **R-02** para el 12" |
| 11 | **L1-14: peor 20,4° en toda la banda** | `probar-requisitos.js` | **19,55° con las patas extendidas; 19,00° con el desnivel de L1-18** | **no** | confirmado (cálculo propio; la diferencia está explicada) → **R-02** |
| 12 | **L1-13: peor 59,5 N, cumple** | `probar-requisitos.js` | **37-41 N con el 12" liviano y 51-59 N con el 200, con la boca a su altura real** | **no** | probable (la altura de la boca del 12" es de catálogo) → **R-03** |
| 13 | **«con 30 s la PEC es recomendable»** (polea 1,4″ + rodillo 0,6″ «justo») | `14` §6b, `10` L1-01 y §9 | F2: 1,97″ en cuadratura; T2 (paso 5): 2,32″; contra 1,5″ de toda la plataforma | **no** | confirmado (dos cuentas que coinciden) → **R-01** |
| 14 | L2-PLT-16: 333 MPa con chapa de 5/16" «sobre los 608» | `10` §7 | 321 MPa en línea sobre un 608; ≈ 4900 MPa en arista | la cuenta sí, el supuesto no | confirmado → **R-04** |
| 15 | L1-15: 1 cm, «lo cierra CAL-1» | `10`, `21` §3 | CAL-1 (mesa quieta sin correa) detecta 0,28 mm, no 10 | **no** | probable → **R-08** |
| 16 | coma: 6″ a 7 mm, 13″ en la esquina | `21` F4 | 6,27″ y 12,6″ | sí | confirmado |
| 17 | L1-31: redondez 0,8 hasta 7 mm, «≈ 0,8 con 3″ de aire» | `10` §7 | 0,79 (aire 3″), 0,75 (2,5″), 0,71 (2″) **sin error de seguimiento**; con los 2″ de L1-01, 0,74 | **no** | probable (segundos momentos de la coma de tercer orden) → **R-07** |
| 18 | patas de 12 cm cubren ±4° | `10` L2-PLT-04 | 1,09 m × tan 4° = 7,6 cm + 3 cm de desnivel = 10,6 cm | sí, si en 34,5° las patas están recogidas | confirmado → **R-17** |
| 19 | P3: 1 mm de pivote ≈ 3,4′; un micropaso de M6 ≈ 0,3 µm | `21` P3 | 3,44′ y 0,31 µm | sí | confirmado |
| 20 | **P3 «corrige la declinación»** | `21` P3, `10` L1-36 | corrige Dec en proporción a cos H: 0,87 a 2 h, 0,5 a 4 h, 0 a 6 h | **no, a medias** | confirmado → **R-06** |
| 21 | F1: el guiado en AR rescata el bamboleo ∝ \|sen δ\| | `21` F1 | el bamboleo de dirección ψ mueve la estrella −w sen δ cos ψ en AR y −w sen ψ en Dec | sí | confirmado (derivación propia) |
| 22 | F7: con 7′ el eje deriva 1,8″/min en declinación | `21` F7 | 1,84″/min | sí | confirmado |
| 23 | «la mesa en la punta no mueve el CdM» | `10` L1-14 | cierto para lo que gira; con el 1 cm que admite L1-15, 2 mm de vaivén | sí | confirmado |
| 24 | el micropaso: T2 paso 5 mueve 6,57″ por paso entero | `15` §1 | 25 µm / 0,785 m/rad = 6,57″ | sí | confirmado |
| 25 | el motor: 4 kg·cm deja 6,5× contra la ráfaga de 40 km/h | `09` | con T2, ≈ 346 N·m en la mesa contra ≈ 13; con la F lo limita la **fricción**, no el motor | a medias | probable → **R-11** |
| 26 | la alineación por astrometría alcanza con 25° de giro | `21` §3 | error del eje ≈ 2″ / 0,44 rad ≈ 5-10″, mucho menos que 2′ | sí | probable |
| 27 | L1-21: la mesa a 26,5 cm, cumple | `probar-requisitos.js` | 26,5 en 34,5°; **31,7 en 38,5°** y hasta 34,7 con el desnivel | **no** en el borde de la banda | confirmado → **R-09** |

## 2. Los hallazgos

### Concepto

**R-01 — Con 30 s, ninguna transmisión candidata cumple L2-PLT-02 sin PEC; «PEC recomendable» es falso.**
- *Qué es.* `14` §6b escribió para 30 s: «polea 1,4″ + rodillo 0,6″ en cada sub: justo; la PEC es
  recomendable». Esos 2,0″ son **el presupuesto entero de L1-01** y superan los 1,5″ de toda la plataforma
  (L2-PLT-02), antes de sumar la velocidad (0,9″ con 0,2 %), el micropaso, la pista y la flexión. La cuenta era de
  la F de una correa (ya descartada por el micropaso) y la conclusión se arrastró a la v0.3 (L1-01, §9, §11.1 punto
  6) sin rehacerla para las que quedan.
- *Evidencia.* `revision.js` §E y, con la función del repo, `tabla(R, dxdth, {t: 30})`: **F2** periódicos
  1,26 + 1,41 + 0,56″ (cuadratura 1,97″, lineal 3,23″); **T2 paso 5** 2,32″; **T2 paso 4** 2,56″; **V8** 1,64″.
  Total con velocidad y micropaso: 2,3 a 2,8″ contra 1,5″. A 15 s (el trazador): F2 1,40″ (entra), T2 1,57″
  (justo). Los supuestos (0,02 mm de descentrado, 5 µm de alabeo del tornillo) son **optimistas**: una polea GT2
  común trae más, y un tornillo C7 no publica su error por vuelta. Orden de magnitud de afuera: las monturas
  comerciales tipo EQ6 traen errores periódicos de decenas de segundos de arco por vuelta del sinfín y se usan
  con PEC o guiado [`probable`, valor de foros no verificado en esta sesión].
- *Clase.* La de los 60 s y la del micropaso: un número fijado sin la cuenta en el caso nuevo; y un verificador
  que no lo vio (`probar-transmisiones.js` sólo controla a 60 s).
- *Grado.* confirmado (cálculo, dos implementaciones). *Severidad:* **concepto** (cambia el programa, la
  calibración y la compuerta de los 30 s).
- *Qué lo cierra.* (1) La PEC pasa a **obligatoria** para los 30 s (requisito L2 nuevo, con un índice de fase:
  la PEC de la F2 va atada al eje del motor y del rodillo; la de la T2, al ángulo del tornillo), o se pide el
  error periódico de cada pieza por número (L3) y se rehace el presupuesto; (2) `probar-transmisiones.js` con un
  control a 30 s y a 15 s, con su sabotaje; (3) corregir `14` §6b, `10` L1-01, §9 y §11.1. **Quién:** la sesión
  autora; Fran, sólo si el cierre cambia los 30 s.

**R-02 — L1-14 (vuelco) no tiene margen: la prueba ignora que las patas levantan el conjunto, y su origen no
cubre al 12".**
- *Qué es.* `vuelcoInclinado()` de `probar-requisitos.js` inclina la gravedad pero deja las tres patas en el
  plano de la base: no extiende ninguna. Para inclinar 4° hay que alargar 7,6 cm las patas del sur (o la del
  norte), y eso sube el centro de masa sobre el borde que baja. Y L1-18 pide andar con 3 cm de desnivel, que
  también los toma una pata.
- *Evidencia.* `revision2.js`: el 12" liviano (40 kg, CdM 50) en 38,5° da **20,4° en el modelo del repo, 19,55°
  con las patas y 19,00° con el desnivel**, contra 19°: margen cero. El 200 medido baja de 22,4° a 21,0°. Con
  eso, la decisión de Fran «el 12" también viaja» (§11.1 pregunta 7) se cerró sobre un número que no tenía en
  cuenta las patas («la base de 1,3 m alcanza»). Además, **el origen de 19° es el 200 solo**: un 12" solo, con
  base de ≈ 65 cm y CdM de 50-62 cm, vuelca a ≈ 28°. Con el 12" arriba, la plataforma es bastante más fácil de
  volcar que el 12" solo, y el rationale de L1-14 dice que eso no puede pasar.
- *Clase.* Detector ciego (como las cajas envolventes): el chequeo da PASA porque no puede ver la variable
  que lo rompe. Y umbral con origen prestado del caso equivocado.
- *Grado.* confirmado (el control positivo reproduce el 20,4° del repo con las patas en cero; la diferencia es
  sólo la extensión). La masa de la base, que la prueba no suma, baja el CdM y ayuda [no medida]. *Severidad:*
  **concepto** (una decisión de Fran descansa en esa cuenta).
- *Qué lo cierra.* (1) `probar-requisitos.js` con las patas extendidas y el desnivel de L1-18, y un sabotaje
  «pata larga» que tiene que bajar el valor; (2) decidir el criterio para el 12" (pregunta 1 de §6); (3) según la
  respuesta: base de 1,35-1,40 m, patas que se abren, o un umbral aceptado por escrito. **Quién:** la sesión
  autora (1, 3); Fran (2).

**R-03 — L1-13 (empujón) se verifica a 1,3 m, no en la boca del tubo; con la boca real no cumple, sobre todo con
el 12".**
- *Qué es.* L1-13 pide 59 N «en la boca del tubo»; `geometria-vns.js` lo calcula con el empujón a 1,3 m del piso
  («la convención de `estabilidad-base.js`»). Sobre la plataforma el dobson sube 26,5 cm y la boca queda a 1,5-1,9
  m con el 200 y a 1,8-2,2 m con un 12". El enunciado y la prueba miden cosas distintas.
- *Evidencia.* `revision.js` §C y la cuenta del 12": el 200 levanta la mesa con **6,0 kg a 45° de altura y 5,2
  kg a 90°** (59 N son 6,0 kg); el 12" liviano con **3,7-4,2 kg**; la prueba dice 6,1 kg y PASA. Comparado con lo
  que pide el rationale («no más fácil que el dobson solo», con la boca a su altura de verdad): el 200 queda un 3 %
  peor que solo, que es casi el criterio; el 12" queda mucho peor que el 12" solo. Cuando la mesa se levanta de un
  rodillo, vuelve a caer sobre el canto, que es la superficie de micrones.
- *Clase.* Umbral (convención) sin origen, y detector ciego: el 1,3 m no cambia con el tubo.
- *Grado.* confirmado para el 200; probable para el 12" (altura del eje y largo del tubo de catálogo).
  *Severidad:* **concepto**: «rodillos a 58 cm, toda la envolvente cumple» (§9) descansa en esa cuenta, y la
  salida puede ser de arquitectura (una retención que no deje levantar la mesa).
- *Qué lo cierra.* (1) La prueba con la boca a su altura (eje de altura + brazo del tubo, por telescopio, en 45° y
  90°); (2) elegir: rodillos más separados, una **retención anti-levante** bajo el canto (una garra o un
  contra-rodillo, que además protege la pista en el traslado), o reescribir L1-13 relativo al dobson solo de cada
  telescopio; (3) para el 12", la pregunta 1 de §6. **Quién:** la sesión autora; Fran el criterio.

**R-04 — El contacto chapa-rodillo: con rodillo cilíndrico la chapa apoya en una arista, y el «rodaje» deforma
la pista; L2-PLT-16 está calculado para otro rodillo y otro contacto.**
- *Qué es.* `16` D1: desde el minuto 10 la chapa apoya en una arista (74 µm de luz a 45 min en 7,94 mm). La luz
  es ≈ 70 veces la aproximación elástica de un contacto en línea con esa carga (≈ 1 µm), así que el apoyo **es**
  en la arista: ≈ 4900 MPa. La salida elegida para hoy (rodaje: «la arista se aplasta unos micrones hasta hacerse
  un asiento») es deformar plásticamente la superficie que tiene que tener micrones, con un resultado que
  depende de la carga: el 12" carga ≈ 20 kg por rodillo y el 200 ≈ 16 (`revision2.js`), así que al cambiar de
  telescopio la arista se vuelve a aplastar distinto (N-12: «no perdamos precisión»; L1-33: sin recalibrar).
  Y L2-PLT-16 (350 MPa) se justifica con «la chapa de 5/16" sobre los 608 da 333», en línea: ni es el rodillo
  elegido (camisa de una pieza) ni el contacto real.
- *Clase.* Un supuesto que el mismo proyecto ya había desmentido (D1, D2) y que siguió en el rationale; y «un
  término descartado de palabra» («la arista se aplasta unos pocos micrones»).
- *Grado.* confirmado que el apoyo es en arista y que el rationale de L2-PLT-16 no aplica; probable que el rodaje
  deje una pista que depende de la carga. *Severidad:* **concepto**: decide el tipo de rodillo y la forma del
  canto, que entran en el trazador.
- *Qué lo cierra.* Decidir el contacto **antes de cortar las chapas del trazador**, no en la fase B: rodillo
  basculante (`16` D1) o camisa abombada con radio controlado; rehacer L2-PLT-16 con ese contacto (y el material
  de la chapa, que fija la fluencia); la prueba de rodadura de `16` I3 con las dos cargas. **Quién:** la sesión
  autora.

**R-05 — El trazador: su criterio de salida no tiene la cuenta de la pista a 10-15 s, la muestra del canto dejó
de ser compuerta, y la transmisión no es un módulo.**
- *Qué es.* El PDP pone el trazador (chapas láser sin terminar, rodillo torneado común) como lo que cierra la
  fase 1, con «estrellas puntuales con subs de 10-15 s». `17` §2 dice que un canto láser queda «uno o dos órdenes
  por encima de 1-2 µm». En 10-15 s el rodillo recorre **0,53-0,79 mm** de canto (`revision.js` §F) y, con 0,37″/µm,
  1″ de pista por foto son 2,7 µm de cambio de altura en ese tramo. Un rodillo de r = 16 mm puentea ondas de 10 µm
  más cortas que 2,5 mm, así que lo que importa es la envolvente de las crestas del canto en menos de 1 mm: nadie
  la calculó ni la midió. Si no da, el trazador no cierra la fase 1 sin la terminación del canto. Además:
  (a) las compuertas del trazador son P0 y los frenos de la montura; **la muestra del canto ya no está** (`16` I4
  la ponía antes de cortar); (b) «se terminan las mismas» chapas sólo si el corte láser deja **sobremedida** para
  la terminación, y no está pedido; (c) la tarjeta madre no declara la **transmisión** como módulo con interfaz
  fija, pero el trade F2/T2 se hace después: si el trazador sale con F2 y gana T2 (34 cm al sur de la viga, un
  brazo en la mesa), puede que haya que rehacer lo que el trazador iba a conservar; (d) sin sensor de origen
  (`16` D5), el tope por programa no es una capa de verdad y L1-04 queda con dos; (e) el «programa mínimo» tiene
  que llevar la tabla del VNS: sin ella, ±0,48 % son 1,1″ en 15 s.
- *Clase.* KDR o criterio fijado sin precedente ni cuenta en el caso nuevo (como los 60 s); un trazador que no
  cumple la condición de trazador (que se conserve) si sus módulos no tienen interfaz.
- *Grado.* hipótesis que el canto crudo alcance o no a 10-15 s (no hay dato); confirmado que falta la cuenta y
  que la transmisión no está en la lista de la tarjeta madre. *Severidad:* **concepto** (el plan de la fase
  siguiente).
- *Qué lo cierra.* Antes de cortar las chapas del trazador: la muestra del canto medida y pasada por
  `contacto-vns.js` muestreado cada ≤ 5 s a 10-15 s; el contacto de R-04 decidido; sobremedida pedida en el corte;
  la transmisión elegida **o** su interfaz escrita como módulo de la tarjeta madre (L2-PLT-19 la nombra); el
  sensor de origen en el trazador; la tabla del VNS en el programa mínimo. **Quién:** la sesión autora; Fran,
  si cambia el orden de la fase 1.

**R-06 — El actuador de declinación en el pivote (P3) corrige la declinación en proporción a cos H, no siempre.**
- *Qué es.* Subir el pivote gira todo alrededor de un eje este-oeste. Eso mueve la estrella en declinación por
  cos H (H, el ángulo horario del blanco) y la cruza a AR por sen H. `21` P3 y el rationale de L1-36 lo presentan
  como la corrección de la declinación sin esa salvedad.
- *Evidencia.* `revision.js` §G: componente en Dec por unidad de giro 1,00 a 0 h, 0,87 a 2 h, **0,50 a 4 h, 0 a
  6 h** (δ = −60°); con δ = −5°, 0,71 a 3 h y 0,26 a 5 h. Y mover el pivote milímetros (para corregir 7′ de
  alineación hacen falta ≈ 2 mm) se sale de la tolerancia de altura del pivote de `16` D4 (±0,76 mm), que existe
  porque las chapas están trazadas para un eje: guiando, el guiador lo absorbe; sin guiar, no.
- *Clase.* La de F1, exacta: «un remedio que corrige un eje anunciado como si corrigiera todo el error».
- *Grado.* confirmado (geometría). *Severidad:* **concepto** (es el camino de N-11 sin rehacer la plataforma).
- *Qué lo cierra.* Escribir la cobertura en `21` P3 y en el rationale de L1-36: con P3, subs guiados de 4 min
  sólo con el blanco a ≤ 3-4 h del meridiano; fuera de eso, la alineación de ≤ 2′ y una pista que no bambolee.
  Fran acepta la limitación o se piensa un eje de declinación de verdad. **Quién:** la sesión autora; Fran acepta.

### Diseño

**R-07 — La redondez del campo central no cierra con su propio presupuesto.** L1-31 pide 0,8 hasta 7 mm; la coma
de tercer orden de un f/6 (segundos momentos: σx² = 0,5 C², σy² = C²/6, con C = coma tangencial / 3) da, sin
ningún error de seguimiento, 0,79 con 3″ de aire, 0,75 con 2,5″ y 0,71 con 2″; con los 2″ de corrimiento que admite
L1-01, 0,74. A 5 mm, 0,82 sin seguimiento y 0,76 con. El presupuesto de la redondez tiene tres términos (coma,
aire, seguimiento) y se escribió con dos. *Clase:* presupuesto armado por lista. [probable] *Lo cierra:* el radio del
campo central a ≈ 4 mm (TBR hasta la primera foto) o la redondez repartida entre los tres; la sesión autora.

**R-08 — L1-15 (1 cm) no tiene origen, CAL-1 no lo verifica y el par cambia de signo en el medio.** Con la mesa en
dos rodillos locos, el rozamiento que tiene que vencer el desbalance es ≈ 0,14 N·m: CAL-1 («la mesa quieta en cinco
posiciones sin correa») detecta 0,28 mm fuera del eje, 35 veces más fino que lo pedido, y un diseño que cumple L1-15
no pasaría nunca su verificación. Y cualquier error en el plano del meridiano (la altura del CdM, la corredera) da un
par proporcional a sen θ: 0 en el centro de la carrera y de signo contrario a cada lado (±0,66 N·m con 1 cm);
`09` ya lo decía («el juego se cruza justo ahí»). Sólo un corrimiento este-oeste da par de un signo (−2 N·m con 5 mm).
*Clase:* umbral sin origen y verificación que mide otra cosa. [probable] *Lo cierra:* L1-15 reescrito como lo que
importa (par de un solo signo en toda la carrera, o precarga de la transmisión que lo cubra, con su número) y CAL-1
acorde; la sesión autora.

**R-09 — L1-21 (30 cm) no se cumple en el borde de la banda.** Con las patas del sur 7,6 cm afuera (38,5°), los
rieles quedan a 31,7 cm en el centro de la mesa, hasta 34,7 con el desnivel. `probar-requisitos.js` lo mide sólo en
34,5°. *Clase:* detector ciego (la banda). [confirmado] *Lo cierra:* medirlo en la banda y subir el número (es una
estimación de la sesión, TBR) o pedir que se cargue en 34,5°; la sesión autora.

**R-10 — La base de 1,3 m contra el baúl del Clio.** La viga sur lleva las patas a ±61 cm: mide ≈ 1,3 m. Un Clio IV
tiene 300 l de baúl y ≈ 1 m entre pasaruedas [`hipótesis`, sin medir], y el tubo va en el asiento de atrás (asiento
arriba). L1-14 pide la base de 1,3 m y L1-35 el Clio: hay que mostrar que entran juntos (C11, consistencia). *Lo
cierra:* la medida del baúl (ya pedida a Fran) y, si no entra, brazos de las patas desmontables (no tocan la pista:
no necesitan espiga fina); la sesión autora.

**R-11 — L2-PLT-10 para la familia F lo limita la fricción, no el motor.** Con 16-20 kg por rodillo y μ ≈ 0,15-0,2,
el rodillo motriz agarra ≈ 25-40 N; la ráfaga de 40 km/h sobre el tubo pide ≈ 16 N en el canto: 1,5-2,5 veces,
no las 6,5 del motor. La T2 no tiene ese límite. [probable] *Lo cierra:* entra al trade F2/T2 como dato; la sesión
autora.

**R-12 — Las tolerancias de armado son de 60 s y del 608.** `16` D4 (y de ahí L2-PLT-18: 0,4 mm, y L1-33) sale de
`contacto-vns.js` con r = 11 mm, la foto de 60 s y el muestreo por minuto; hoy el rodillo es una camisa y la foto de
30 s (o 10-15 s en el trazador). Probablemente se aflojan, pero no se sabe. [confirmado que están desactualizadas]
*Lo cierra:* recalcular con el rodillo y la foto de hoy (ya pedido en `17` §1); la sesión autora.

**R-13 — Faltan requisitos que el propio proyecto ya encontró.** (a) el **sensor de origen** y la salida del fin de
carrera (`16` D5: «requisito nuevo»); (b) la **guarda contra el atrapamiento** de un dedo entre chapa y rodillo
(`21` §4a), que es la sexta categoría, la que se olvida: L0-09 cuida al telescopio, nadie a la persona; (c) el
**rocío** (calefactores) y su energía dentro de L1-06; L1-11 se verifica «por inspección», que no ve el rocío;
(d) el **lugar para la declinación** en el zócalo del pivote (P3) no tiene requisito hijo de L1-36; (e) el
**dither** contra el *walking noise* (`21` P8) no traza a nada. [confirmado: búsqueda en `10`] *Lo cierra:* la
sesión autora, en `10`.

**R-14 — Las interfaces sin dueño o sin requisito** (detalle en §4): la transmisión con la mesa y la viga (R-05),
la plataforma con la cámara (disparo y dither), el pivote con el actuador de declinación.

### Redacción

**R-15 — §9 de `10` y otros documentos contradicen decisiones posteriores.** La fila «rótula de amortiguador en el
pivote, cero juego» contra `16` D6, `17` y `20` (bolilla templada en asiento cónico); «rodillo loco de cuatro 608»
contra `16` D2; «ESP32 en caja sobre la viga sur» y «batería en la viga sur» contra la fila del v10.3 (tubos de
costado); el rationale de L2-PLT-16 con los 608 (R-04); el ConOps con el Arduino y «la plataforma se inclina hasta
~7,5°» (son 12°: punto 7 del PDP, ya pendiente). *Lo cierra:* la sesión autora.

**R-16 — `14` §6b dice «no importa si el error es lento o rápido: lo que entra en la foto crece lineal con el
tiempo».** Vale para un error de velocidad; no para uno periódico más rápido que la foto (el micropaso, que no
crece con t) ni para uno más lento (crece como sen). Es parte de por qué R-01 no se vio. *Lo cierra:* la sesión
autora, junto con R-01.

**R-17 — «12 cm cubren ±4°» es cierto sólo con las patas recogidas en 34,5°.** Pedido: 7,6 + 3 = 10,6 cm de una
pata. Si se arma con las patas por la mitad, cubren ±2,7°. Va al rationale de L2-PLT-04 y al ConOps.

## 3. La misma clase, buscada en todo el resto

| Clase que ya se cometió | Otra instancia encontrada | Hallazgo |
|---|---|---|
| KDR fijado sin precedente (los 60 s) | «PEC recomendable» para 30 s; el criterio del trazador a 10-15 s sin la cuenta de la pista | R-01, R-05 |
| Un remedio que corrige un eje anunciado como si corrigiera todo (guiado en AR) | el actuador del pivote corrige Dec ∝ cos H | R-06 |
| Un umbral sin origen (el vuelco de 22°) | L1-15 (1 cm); el 1,3 m del empujón; el 19° aplicado al 12" | R-08, R-03, R-02 |
| Una estimación que nadie midió («1-2° en la punta») | la extensión de las patas «no cambia nada» (nadie la sumó); la arista «se aplasta unos micrones» | R-02, R-04 |
| Un cociente mal dicho («70 % bamboleo») | «polea 1,4 + rodillo 0,6: justo» (es el 133 % del presupuesto de la plataforma) | R-01 |
| Un ± leído como simétrico (el rodillo de 40) | «±4° con 12 cm»: es asimétrico, una pata por lado | R-17 |
| Un término descartado de palabra (el micropaso) | la fricción en L2-PLT-10; el rodaje de la arista | R-11, R-04 |
| Un método de trazado equivocado (el canto por el punto alto) | ninguna instancia nueva: la envolvente es correcta y `17` ya dijo que su 0″ es por construcción | — |
| Un detector ciego (las cajas envolventes) | `probar-requisitos.js` en L1-13, L1-14 y L1-21; `probar-transmisiones.js` sólo a 60 s; CAL-1 | R-02, R-03, R-09, R-01, R-08 |

## 4. Interfaces (N²)

Fila = quién entrega; columna = quién recibe. Cada celda: el requisito que la gobierna y el dueño. ✗ = sin requisito.

| | Plataforma (PLT) | Montura (MON) | Tren de imagen (CAM) | Operación (OPE) | Afuera |
|---|---|---|---|---|---|
| **PLT** | — | apoyo y fijación: L2-PLT-12, 14, 17; CdM: L1-15, L2-PLT-05 (PLT) | disparo y dither: **✗** (R-13 e) | origen y rebobinado: L1-03; **origen ✗** (R-13 a) | piso: L2-PLT-04, L1-18; auto: L2-PLT-13, L1-35, L1-37, L2-PLT-20; batería: L1-06; guiador: L2-PLT-11; **declinación en el pivote ✗** (R-13 d) |
| **MON** | carga y CdM: L2-PLT-05; frenos con la mesa inclinada: L2-MON-02/03 (MON) | — | portaocular: L2-CAM-01 (CAM) | apuntado: L1-08 | — |
| **CAM** | — | peso en el portaocular: L2-CAM-03, L2-MON-06 | — | sin tocar: L2-CAM-04 | energía: L1-32 |
| **OPE** | alineación: L2-OPE-01 a 05 | trabar ejes (ConOps) | foco (ConOps; frío y reenfoque de `17` §2 sin requisito) | — | sitio sin marcas: L2-OPE-05 |
| **Afuera** | viento: L1-12, L2-PLT-10; temperatura y humedad: L1-10, L1-11 (**rocío ✗**, R-13 c); persona: **atrapamiento ✗** (R-13 b) | — | cielo del patio (spike de 10 s, sin requisito: es dato) | — | — |

Además, dentro de PLT: **transmisión ↔ mesa y viga** sin interfaz declarada en la tarjeta madre (R-05 c).

## 5. *What if* que le faltan a `21` §4a (sobre todo, del trazador)

| Escenario | Qué pasa | Qué lo detecta primero | Qué se hace |
|---|---|---|---|
| El canto láser crudo no da ni 10 s | el trazador no cierra la fase 1 | la muestra del canto, si vuelve a ser compuerta | R-05: medirla antes de cortar; sobremedida para terminar |
| La arista se aplasta distinto con el 12" | el 200 pierde la tabla después de usar el 12" | la deriva medida con cada telescopio | R-04: contacto decidido antes de cortar |
| Gana T2 después de construir el trazador con F2 | hay que rehacer la mesa o la viga | el trade de la fase B | R-05: interfaz de transmisión en la tarjeta madre |
| Alguien empuja el ocular del 12" al enfocar | la mesa se levanta y cae sobre el canto | un salto fijo de la estrella en esa posición | R-03: retención anti-levante |
| Armado en el campo con las patas por la mitad | no llega a 38,5° | la deriva de la primera noche | R-17: patas recogidas en 34,5° |
| El trazador sin sensor de origen | el tope por programa no sabe dónde está; quedan dos capas | el primer arranque con la mesa en una punta | R-05, R-13 a |
| El programa mínimo sin la tabla del VNS | 1,1″ de corrimiento en 15 s | la primera foto | R-05: la tabla va en el mínimo |
| La PEC pierde la fase al desarmar (la F2 patina) | la corrección queda corrida | la deriva periódica después del viaje | R-01: índice de fase por pieza |
| Viento con el 12" en el borde de la banda | menos margen de vuelco que el 12" solo | — | R-02 |
| Pinchar un dedo al rebobinar | lesión; 20 kg sobre el contacto | — | R-13 b |

## 6. Los verificadores: ¿miden la condición real?

| Herramienta | Da | Sabotaje que hice | ¿Lo ve? |
|---|---|---|---|
| `probar-requisitos.js`, L1-14 | PASA 20,38° | extender las patas 7,6 cm (lo que pide la banda) y 3 cm de desnivel | **no**: no tiene una variable para la pata; mi cuenta baja a 19,00° (R-02) |
| `probar-requisitos.js`, L1-13 | PASA 59,5 N | subir la boca a la altura real (1,5-2,2 m) | **no**: el 1,3 m está fijo (R-03) |
| `probar-requisitos.js`, L1-21 | PASA 26,5 cm | evaluar en 38,5° | **no**: sólo mide 34,5° (R-09) |
| `probar-transmisiones.js` | 3 OK | correr la cuenta a 30 s | **no**: sus controles son de 60 s; a 30 s su propia función da lo que dice R-01 |
| `contacto-vns.js` / `probar-contacto.js` | verde | rodillo de hoy y foto de 30 s | **no**: r = 11 mm, foto de 60 s, muestreo por minuto (ya dicho en `17` §1; R-12) |
| CAL-1 (procedimiento) | — | un CdM a 5 mm del eje, que cumple L1-15 | **lo rechaza**: mide 0,28 mm, no 10 (R-08) |
| `verificar-requisitos.py` | VERDE | un requisito físicamente imposible y bien escrito (L1-31) | **no, y es correcto**: mide la forma (GtWR) y la traza, no la física; por eso existe esta revisión |
| `matriz-verificacion.md` | L1-14 «verificado por análisis» | — | hereda el ciego de `probar-requisitos.js`: L1-14 pasaría a «falla» o «predicho» con R-02 |

## 7. Lo que revisé sin encontrar nada

Cada uno con su cuenta propia en §1 o en los scripts:

- la geometría VNS espejada para el sur (pivote al norte, eje que sube al sur: `d = (0, −cos φ, sen φ)`);
- la inclinación de la mesa (9,27° y 10,50°) y los frenos con la base a 4° (11,46° contra 12°);
- el reparto de L1-01 (1,87″), la escala de la cámara (0,674″/px), L2-OPE-01, L1-26, L2-OPE-04, L2-PLT-15;
- L1-02 (90 min contra 60, con precedente);
- la cinemática de la banda: inclinar toda la base no cambia la cinemática del VNS (cuerpo rígido);
- el recorrido de las patas (10,6 cm contra 12, con la salvedad de R-17);
- «la mesa en la punta no mueve el CdM» (cierto);
- la coma (6,27″ y 12,6″) y su consecuencia: el cuadro entero pide corrector (F4/F5 de `21`);
- F1 y F7 de `21` (derivación propia del bamboleo en AR y Dec);
- los números de P3 (3,44′ por mm, 0,31 µm por micropaso);
- el micropaso por concepto (T2 6,57″, F2 8,4″ por paso entero);
- las tres capas de tope en orden (45, 48, 51 min) y el fin de carrera normalmente cerrado;
- el par del NEMA 17 con la T2 (≈ 346 N·m en la mesa contra ≈ 13 de la ráfaga);
- la alineación por astrometría con 25° de giro (≈ 5-10″, mucho menos que 2′);
- la máxima exposición temporizada de las Sony (30 s) y que más allá hace falta disparador externo;
- el Hertz de línea sobre un 608 (321 MPa): la cuenta está bien, el supuesto no (R-04);
- la trazabilidad y la forma de los requisitos (`verificar-requisitos.py` VERDE: 13 N, 16 L0, 37 L1, 35 L2).

**Hallazgos de concepto abiertos: 6** — R-01 (PEC a 30 s), R-02 (vuelco con patas y el 12"), R-03 (empujón en la
boca), R-04 (contacto en arista y rodaje), R-05 (criterio y compuertas del trazador), R-06 (P3 ∝ cos H). Diseño: 8
(R-07 a R-14). Redacción: 3 (R-15 a R-17). La fase 0 no cierra hasta que cada uno de concepto quede **corregido con
su prueba** o **aceptado por Fran por escrito** (PDP §4, punto 6).

## 8. Preguntas para Fran (de valor, no técnicas)

1. **Con el 12" arriba, ¿cuánto más fácil de volcar (o de levantar con un empujón) puede ser la plataforma que el
   12" solo en el piso?** Hoy el criterio sale del 200 (19°); el 12" solo aguanta ≈ 28°. Si la respuesta es «igual
   que el 12" solo», la base o la retención cambian (R-02, R-03).
2. **¿Aceptás que los subs guiados de 4 min (la segunda meta) valgan sólo con el blanco a menos de 3-4 h del
   meridiano?** Es lo que da el actuador del pivote; para todo el cielo hace falta un eje de declinación de verdad
   (R-06).

## Fuentes

- Del proyecto: `10` v0.3, `14` §6b, `15` §1-2, `16` D1-D6 e I1-I4, `17` §1-2, `21`, `09`, `13` §8, `01`,
  `PDP.md` §4 y §6; `geometria-vns.js`, `contacto-vns.js`, `transmisiones.js`, `probar-requisitos.js`.
- Baúl del Clio IV (300 l): [vehiclesizes](https://www.vehiclesizes.com/cars/renault/clio/clio-iv-phase-ii-2016-hatchback/rear-view),
  [angurten.de](https://www.angurten.de/is/abmessungen/1375-Clio+IV). El ancho entre pasaruedas no se encontró: `hipótesis`.
- Redondez y excentricidad (no hay un umbral publicado; e = 0,5 equivale a 0,87 de cociente):
  [Astro Pixel Processor](https://www.astropixelprocessor.com/community/main-forum/what-is-fwhm-shape/),
  [AstroBin](https://app.astrobin.com/forum/topic/157348/fwhm-vs-eccentricity-how-to-filter-the-good-frame-in-subframe-selector-in-pi),
  [photutils](https://photutils.readthedocs.io/en/latest/api/photutils.detection.DAOStarFinder.html).
- Error periódico de las monturas comerciales: orden de magnitud de foros, sin fuente leída en esta sesión
  (`probable`); no se usa para ningún número de R-01, que sale de la cuenta.
