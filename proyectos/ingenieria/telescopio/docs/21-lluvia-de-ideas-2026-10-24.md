# Lluvia de ideas y revisión de concepto — 24 de octubre de 2026

**Por qué ahora:** `cascada.ps1` avisó el momento lluvia de ideas (12 sesiones auditadas, umbral 10; nunca se
había hecho) y la fase 0 está por cerrar con la revisión de concepto (MCR). Fran pidió, además: «asegurate de que
quede bien el concepto y de que no haya fallas conceptuales; pensá todos los *what if* de escenarios malos o
buenos, todos los emergentes, conocidos o no, deseados o no». En la lluvia **no se toca el producto**: se mide lo
barato, se escribe esto y se le llevan decisiones a Fran. Grado de cada cosa entre corchetes.

## 0. La meta y el estado medido contra ella

**La meta** (PDP §1): una foto propia y apilada de una nebulosa o una galaxia con el 200/1200, con el objeto
reconocible y las estrellas como puntos.

| Capacidad que la meta necesita (de la más básica a la más fina) | Estado | Grado |
|---|---|---|
| que la cámara llegue a foco en el telescopio | sin medir (P0, diez minutos de día) | `hipótesis` |
| que el cielo del patio deje sacar algo | sin medir (el spike de 10 s) | `hipótesis` (Bortle 7-8 por mapa) |
| que algo siga el cielo sin rotar el campo | arquitectura VNS elegida con pesos de Fran | trade cerrado |
| que lo que gira esté balanceado | centro de masa medido: 63,2 ± 0,5 cm | medido |
| que la plataforma no se vuelque ni se suelte | cálculo en el modelo, con toda la envolvente | `probable` |
| que siga con el error pedido | presupuesto por cálculo; la pista y el micropaso sin medir | `probable` / `hipótesis` |
| que se pueda llevar y armar solo, en otro lugar | decidido (Clio, centro del país); sin cuenta de volumen | `hipótesis` |
| la foto | nada | — |

**Venimos:** ≈ 15-20 % de la meta, contando las seis fases del PDP: la fase 0 a tres cosas de cerrar (foco,
inventario, el sí de Fran al concepto), y de la 1 a la 5 sin empezar.

## 1. ¿Están claros los conceptos? Las fallas que encontró esta revisión

La pregunta de marco (*¿qué tendría que ser verdad para que esto sea el problema equivocado?*) se hizo contra cada
decisión del concepto. Salieron **once** fallas, ninguna fatal; cuatro cambian una decisión.

| # | Falla | Evidencia | Qué cambia | Grado |
|---|---|---|---|---|
| F1 | **El guiado en un solo eje no cura la mitad de la pista.** El 24/10 se escribió que con guiado en AR «la mecánica deja de pedir micrones». La pista mueve la estrella mitad en velocidad (AR) y mitad en bamboleo del eje (`17` §1, «50/50 en potencia»); el guiado en AR recupera la velocidad y la parte del bamboleo que cae en AR, que es ∝ \|sen δ\|. | Carina (δ −60°): queda ≈ 35 % del error de pista; NGC 253 (−25°): ≈ 65 %; **M42 (−5°): ≈ 70 %**, casi todo en declinación | La recomendación de los 30 s + guiado **sigue**, pero el guiado alivia la pista sólo en blancos australes. Para que deje de pedir micrones hace falta corregir también en declinación (palanca P3). Se corrige `20` §1 | `probable` (cálculo sobre el factor de `17`) |
| F2 | **El vuelco con la base inclinada no está cerrado.** Para el centro del país la base se inclina hasta 4°; inclinarla le saca margen al borde que baja. | `vuelco-inclinado.js` (sesión, sobre `geometria-vns.js` v10.6): el 200 medido da 23,7° al sur en 30,5° y 22,4° de costado en 38,5°; el 12" liviano (CdM 50) da 20,4° de costado en 38,5°; con la mesa en la punta de la carrera, 1 a 2° menos | Con el umbral de hoy (22°) el 200 queda justo y el 12" no cumple en 38,5°. Y **el 22° no tiene origen** (L1-14, TBR desde el v9) | `probable` (cálculo) |
| F3 | **El umbral de vuelco (22°) no sale de nada.** L1-13 se definió contra el dobson solo («no más fácil de volcar que el dobson en el piso»); L1-14 no. El dobson solo, con la base fija de 43 × 43 y el CdM a 63,2, vuelca a **18,8°**. | `atan(21,5 / 63,2)` | L1-14 pasa a 19°, con el mismo criterio que L1-13. Con eso el 200 cumple en todo el rango y el 12" liviano queda justo en 38,5° al final de la carrera (se cierra en la fase A: base de 1,35 m o el 12" sin viajar) | cálculo |
| F4 | **La foto tiene coma en las esquinas, siga como siga.** Un newtoniano f/6 sobre un sensor APS-C: la coma tangencial es 3h / (16 N² f) → 6″ a 7 mm del centro y 13″ en la esquina, contra 2-3″ del aire. | fórmula + foro (un 10" f/5,6 con APS-C: «se nota») | L0-02 (redondez 0,8 «sobre la imagen apilada») no se puede cumplir en todo el cuadro con ninguna plataforma. Se pide en el **campo central** (requisito nuevo, 7 mm) y el cuadro entero queda para un corrector de coma, que pide un portaocular de 2" | `probable` |
| F5 | **El portaocular de 1,25" helicoidal es el eslabón débil del tren de imagen**, más allá del foco: viñetea un sensor APS-C (28,4 mm de diagonal en un tubo de ≈ 28 mm), no admite corrector ni filtro de 2", y gira la cámara al enfocar. | fotos 59-63 (`hipótesis` que sea 1,25" helicoidal) | P0 tiene que medir también el portaocular (diámetro, recorrido). Un Crayford de 2" de perfil bajo resuelve foco, viñeteo, corrector y filtro de una vez (palanca P4) | `probable` |
| F6 | **El «60 s gana un 1 % en el patio» vale sólo sin filtro.** Con un filtro de dos bandas el fondo del cielo baja ≈ 10 veces y el sub óptimo del patio sube a 1-3 min (SharpCap: «el filtro baja el brillo del cielo y alarga el sub»; usuarios en Bortle 8 con dos bandas, 120 s). | foros de SharpCap y AstroBin | El guiado no es sólo para el cielo oscuro: con filtro también paga en el patio. Refuerza «guiado previsto desde el diseño»; no cambia el piso de 30 s sin guiar | `probable` |
| F7 | **El guiado en AR no corrige la deriva en declinación por la alineación polar.** Con 7′ de error el eje deriva 1,8″/min en declinación: en un sub de 4 min, 7″. | ε · ω sidéreo | Para los subs guiados de 2-4 min (N-11) la alineación tiene que ser ≤ 2′, o hay que corregir en declinación (P3). Para 30 s sin guiar, 7′ sigue alcanzando | cálculo |
| F8 | **Desarmar para el baúl choca con las tolerancias de armado.** El pivote en altura pide ±0,76 mm respecto de los rodillos, cada chapa en planta ±0,15° (`16` D4). Si cada viaje mueve eso, cada viaje es una calibración, y N-03 dice «sin renegar». | `contacto-vns.js` (tolerancias) | Las uniones que se desarman (los zócalos de la tarjeta madre) tienen que **repetir posición**: espigas o pasadores, no sólo bulones. Requisito nuevo | `probable` |
| F9 | **El canto viaja.** La pista es la superficie más fina del proyecto y en el baúl es la más expuesta: un golpe o un rayón es un escalón de decenas de micrones, para siempre. | `16` O5, R9, R15 | Las chapas se desmontan (ya son módulo abulonado) y viajan en una caja con protector de canto. Candidato a requisito | `probable` |
| F10 | **El 12" no entra en un Clio con la plataforma.** Un dobson de 12" tiene base de ≈ 65 cm y tubo de ≈ 1,6 m (`14` §3). | catálogo (`hipótesis`) | N-12 (el 300) y el Clio no se piden juntos: o el 300 se queda en el patio, o viaja en camioneta. Pregunta de valor (§7) | `probable` |
| F11 | **El alcance no tiene la forma de los ejemplares.** El documento de requisitos tiene **12 necesidades**; NASA y la cátedra piden **una**, y el resto son expectativas. Y tres L0 nombran la solución (L0-14 y L0-15 dicen «plataforma») o un parámetro de medición (L0-11 dice «10 s»), que en el tope no va (Leisner p. 10 y 18). | `alcance-como-se-escribe.md`; `nucleo-ise` §4 | v0.3: la necesidad única arriba, las N pasan a ser las expectativas de Fran (se conservan los ID), y los tres L0 se reescriben | lectura |

**Dos productos de la fase 0 que todavía no están:** el **ConOps** está escrito para el patio de octubre (Arduino,
marcas del piso, sin viaje, sin enfriar el espejo, sin guiado ni flats) y NASA lo pide al cerrar Pre-A; y la
**evidencia externa de cada KDR** (PDP §4 punto 5) está hecha sólo para L1-01. La de los otros tres va en §3.

## 2. ¿El reloj estaba puesto?

- **En el propio proyecto:** `16` §5 ya tenía rocío, enfriamiento del espejo, foco con el frío y óxido; `16` §7
  tenía los candidatos de homing y de la ondulación del canto; `17` §1 ya decía que el guiado en AR rescata
  bamboleo «para blancos australes», y eso es exactamente F1 dicho al revés. **La falla F1 estaba escrita y no se
  leyó al recomendar el 24/10.** Se corrige en `20`.
- **En la casa:** el cohete de agua usa el mismo ESP32 y la misma cadena de herramientas (la lista de compras ya lo
  aprovecha). Nada más se parece.
- **Afuera:** lo de §3.

## 3. Lo que otros ya resolvieron

| Quién | Qué resolvió | Cómo | Qué nos dice | Grado |
|---|---|---|---|---|
| TMS-Astro (vendida por Astroshop y Omegon) | plataforma ecuatorial **fotográfica** para dobson | además del motor de AR, **un motor de declinación** que maneja el autoguiador por ST-4; 70 kg; 60 min de carrera; **bandas de 5°** de latitud | (1) el que vende para foto guía en **dos ejes**: confirma F1; (2) 60 min de carrera es el estándar (evidencia de L1-02); (3) nuestra banda de ±4° (8°) es más ancha que la comercial: confirma F2 | `confirmado` que existe (ficha del vendedor); el mecanismo de su declinación no se publica |
| KStars/Ekos, NINA (TPPA), StellaVita, PAPS | alineación polar **sin ver el polo** | tres fotos resueltas por astrometría (*plate solving*) en tres posiciones del eje de AR (StellaVita: 0, 15 y 30°); el centro del círculo es el eje; anda en cualquier parte del cielo, mejor cerca del ecuador | la plataforma gira ±12,75° hasta los talones (25° en total): alcanza para el método con la cámara principal, en cualquier sitio y sin marcas. Reemplaza las marcas fuera del patio | `probable` (la plataforma da menos giro que una montura) |
| SharpCap (Glover) y usuarios en Bortle 8 | largo del sub en cielo contaminado | t ≈ 10 R² / L; con filtro el fondo baja y el sub sube | F6 | `probable` |
| Fabricantes de correctores de coma | el campo de un newtoniano f/3-f/6 en APS-C | corrector de 2" con 55-75 mm de foco trasero | F4 y F5: el corrector pide portaocular de 2" y recorrido | `probable` |
| Foros (Stargazers Lounge, IceInSpace) | la cámara que no llega a foco en un dobson | subir el primario ≈ 1 cm con los tornillos de colimación, portaocular de perfil bajo, o Barlow (lenta para cielo profundo) | P0 tiene tres salidas antes de rendirse; la Barlow es la peor para la meta | `probable` |
| Foros (AstroBin, StarTools) | el «ruido que camina» (*walking noise*) en el apilado | *dithering*: correr la imagen unos píxeles entre subs; con un solo eje, en AR | sin guiado, la deriva lenta y sin dither deja rayas en el apilado. La plataforma puede hacer el dither en AR si sabe cuándo termina cada sub | `probable` |
| OnStep / OnStepX | controlador abierto para monturas, ESP32, Wi-Fi, LX200, INDI, ST-4 | firmware de montura | es una montura, no una plataforma: la tabla de velocidad del VNS, el rebobinado y los topes serían desarrollo propio arriba de él (la trampa del *heritage*, SEH p. 68). Para un eje con tabla, el programa propio es más chico | `hipótesis` (no se leyó su código) |
| Matthews (2021), plataforma de «planar linkage», arXiv 2106.15694 | la velocidad no constante de una plataforma | tabla de la cinemática en el programa (Chebyshev → ticks del timer) | lo mismo que ya está en el diseño (L2-PLT-03): confirma el método. No publica error de seguimiento | `confirmado` (leído) |
| Osypowski, BAA, Vogel | CdM sobre el eje | el eje se pasa por el CdM para que el rodillo no patine | ninguno publica una tolerancia: el 1 cm de L1-15 se queda como cálculo de la sesión, con su sondeo (CAL-1) | `confirmado` que no hay dato |

**La evidencia externa de cada KDR** (PDP §4, punto 5; DA-081):

| KDR | Precedente | Límite del entorno | Queda |
|---|---|---|---|
| L1-01 (corrimiento en el sub) | ningún fabricante publica seguimiento sin guiar; los foros, 4-10 s con plataformas caseras; el comercial fotográfico guía en dos ejes | el cielo del patio (10-20 s sin filtro, `hipótesis`); la pista (sin medir) | `20` §1 + F1, F6. **30 s sin guiar sigue siendo el número con evidencia; 60 s no tiene** |
| L1-02 (60 min por carrera) | TMS-Astro: 60 min; el diseño da 90 | el largo de la chapa en el baúl | con precedente |
| L1-15 (CdM a ≤ 1 cm del eje) | BAA: el eje por el CdM para que no patine; nadie publica tolerancia | el motor y la fricción del rodillo | `hipótesis` de la sesión; lo cierra CAL-1 (la mesa quieta en cinco posiciones sin correa) |
| L1-22 (la Sony llega a foco) | la falla clásica, con tres arreglos conocidos (primario, perfil bajo, Barlow) | el portaocular que tenga | lo cierra P0 |

## 4. Los *what if* y las palancas

### 4a. Escenarios: lo malo y lo bueno, lo conocido y lo que puede aparecer

Cada uno con lo que lo detecta primero. Los de la pista, la noche y el micropaso ya estaban (`16`, `17`, R11-R15):
acá van los que no estaban, más los que cambian de peso con el viaje.

| Escenario | Clase | Qué pasa | Qué lo detecta primero | Qué se hace |
|---|---|---|---|---|
| La Sony no llega a foco | malo, conocido | sin foto en foco primario | P0 | subir el primario ≈ 1 cm (reversible), o portaocular de perfil bajo; Barlow último; celular afocal (L0-13) como plan B |
| El portaocular es 1,25" | malo, probable | viñeteo y sin corrector | P0, con calibre | P4 |
| Coma en las esquinas | malo, cierto | estrellas como cometas en el borde | la primera foto | redondez pedida en el campo central (L1-31); corrector después |
| La pista con canto láser no llega ni a 30 s | malo, conocido | estrellas que saltan en declinación | la muestra del canto (paso 6c) | terminación del canto; actuador de declinación (P3); blancos australes primero |
| El vuelco en el borde de la banda | malo, medido hoy | se vuelca más fácil que el dobson solo | la cuenta (hecha) | L1-14 a 19°; base de 1,35 m o el 12" sin viajar |
| Cada viaje es una calibración | malo, probable | no se cumple N-03 | el primer rearmado | uniones con espiga (L2-PLT-18) y la calibración guardada en el programa |
| Un golpe en el canto en el baúl | malo, probable | escalón permanente | la estrella salta siempre en la misma posición de la mesa | chapas desmontables en caja con protector |
| La batería de la cámara no aguanta la noche | malo, probable | se corta a la hora y media o dos | la primera noche larga | alimentar la cámara desde la batería de 12 V (L1-32); `hipótesis` que la ZV-E10 acepte USB-C mientras saca |
| El «star eater» de Sony en exposiciones largas | malo, `hipótesis` para la ZV-E10 | estrellas chicas borradas | el spike de 10 s, mirado al 100 % | quedarse en exposición temporizada (≤ 30 s, no BULB) |
| Rayas en el apilado (*walking noise*) | malo, probable sin dither | fondo con rayas diagonales | el primer apilado | dither en AR entre subs desde la plataforma (P8) |
| La deriva en declinación en subs guiados largos | malo, cierto | estrellas estiradas en declinación a los 2-4 min | la primera noche guiada | alineación ≤ 2′ con la cámara guía, o P3 |
| Un dedo entre la chapa y el rodillo | malo, cierto | atrapamiento con 20 kg encima | — (hay que prevenirlo) | guarda sobre cada contacto (candidato a requisito) |
| Brújula inútil para alinear | malo, cierto | el acero y la declinación magnética (≈ −8° a −10° en el centro del país, `hipótesis`) la corren | — | alineación por astrometría (§3) |
| El cielo del patio mejor de lo esperado | bueno, `hipótesis` | el sub óptimo sube | el spike de 10 s | se revisa el piso de 30 s hacia arriba |
| 30 s es el máximo de exposición temporizada de las Sony | bueno, probable | el modo intervalo de la cámara alcanza, sin intervalómetro ni BULB | el manual de la ZV-E10 | se usa; para más de 30 s hace falta disparador externo |
| Los mejores blancos australes están lejos del ecuador | bueno, cálculo | el guiado en AR rescata más bamboleo en Carina (−60°), ω Cen (−47°), Cen A (−43°) | — | la primera foto apunta a Carina o a ω Cen, no a M42 |
| La cámara principal alinea el polo | bueno, probable | se puede alinear sin cámara guía ni marcas | la primera prueba con una Pi | L2-OPE-05 sin fijar el método |
| La cámara guía también alinea | bueno, conocido (PHD2) | alineación de ≈ 1′ en cualquier sitio | — | la etapa del guiado la trae gratis |
| El ESP32 dispara la cámara | bueno, `hipótesis` (la ZV-E10 admite control remoto por cable o Bluetooth; el protocolo de Sony está documentado por terceros) | dither sincronizado, intervalómetro gratis, registro de cada sub | — | P8 |
| Primera luz en otoño de 2027 | emergente, de calendario | si la plataforma está en marzo-mayo: Carina, ω Cen, Cen A altos; M42 ya se pone temprano | el plan de la fase 4 | elegir el blanco por la fecha, no al revés |
| Fran se cansa o le falta tiempo | emergente, conocido | el proyecto se estira sin foto | meses sin un hito que se vea | el trazador (P1): una foto temprana |
| Lo que no sabemos que no sabemos | emergente, desconocido | — | **sólo un sistema real lo muestra** | spikes en el sistema real (P1, P2), no más diseño en el aire |

### 4b. Las palancas, de la más alta a la más baja

| # | Palanca | Escala | Mecanismo | Costo | ¿Se deshace? | Grado | Primer sondeo |
|---|---|---|---|---|---|---|---|
| P1 | **El trazador primero.** Una plataforma entera pero cruda —chapas láser sin terminar, rodillo torneado común, ESP32, el programa mínimo— andando en el patio con subs de 10-15 s, **antes** de cerrar el diseño de precisión; después se refina por módulos (terminación del canto, guiado, declinación) con lo que mida | meta y orden de las decisiones | lo que no se sabe se descubre en el sistema real (PDP: NASA con ágil); la tarjeta madre ya hace que cada mejora sea un módulo; la foto de 10-15 s **es** el modo degradado de L0-11 | el corte de las chapas se adelanta; si la muestra dice que hay que terminarlas, se terminan las mismas | sí: las chapas y el rodillo son módulos | `probable` | la muestra del canto y la palanca óptica, que ya están planeadas, son su primera mitad |
| P2 | **Medir antes de fijar números**: P0 con el portaocular, el spike de 10 s, la muestra del canto, la palanca | flujo de información | cada número que manda pasa de `hipótesis` a medido | tres tardes y una noche | — | — | ya planeado |
| P3 | **Un actuador de declinación en el pivote**: el zócalo del pivote de la tarjeta madre se hace para que, más adelante, el pivote pueda subir y bajar unos milímetros con un tornillo fino (1 mm de pivote ≈ 3,4′ de eje; un micropaso de un M6 ≈ 0,3 µm) | estructura | corrige la declinación: el bamboleo de la pista que el AR no ve (F1), la deriva por alineación (F7) y la alineación polar fina en altura desde el programa | hoy: dejar el lugar en el zócalo; después, un NEMA, un driver (ya está el de repuesto) y un tornillo | sí | `probable`: el comercial fotográfico lo hace (no publica cómo) | el diseño del zócalo en la fase B |
| P4 | **Portaocular de 2" de perfil bajo** en lugar del de 1,25" | estructura | más recorrido hacia adentro (R1), sin viñeteo, admite corrector de coma y filtro | un portaocular y agujeros nuevos en el **tubo** (no en la montura) | a medias: los agujeros quedan | `probable` | P0, con el portaocular medido |
| P5 | **Los requisitos con la forma correcta y los huecos tapados** (F2-F4, F8, F11; cámara alimentada; campo central; traslado) | reglas | el papel que define el proyecto deja de esconder fallas | esta sesión | sí | lectura | `verificar-requisitos.py` |
| P6 | **El ConOps de verdad**: la noche en el patio, la noche de viaje y la noche mala, con el orden de `16` O8, flats y darks, el dither, el armado del baúl | flujo de información | NASA: arquitectura, ConOps y requisitos tienen que cerrar entre sí; hoy el ConOps es de otra época | media sesión | sí | — | — |
| P7 | **Alinear el polo por astrometría** fuera del patio (cámara principal y plataforma girando ≈ 25°, o PHD2 con la cámara guía); las marcas quedan para el patio | estructura (de la operación) | saca la brújula y la deriva de media hora del camino | una Pi y software libre | sí | `probable` | la primera noche con la Pi |
| P8 | **El ESP32 como intervalómetro y dither**: dispara la cámara, espera el sub, corre la mesa unos segundos de arco al azar en AR, dispara de nuevo | estructura (de la electrónica) | mata el *walking noise* sin guiado y registra cada sub | programa; un cable o Bluetooth | sí | `hipótesis` (el control remoto de la ZV-E10) | leer el manual de la ZV-E10 |
| P9 | **Programa propio, no OnStep** para el eje de la plataforma | estructura (del programa) | un eje con tabla es chico; OnStep es una montura y adaptarlo es desarrollo | — | sí | `hipótesis` | si el programa propio pasa de ≈ 500 líneas, se mira OnStep de nuevo |
| P10 | **Base de 1,35 m** o el 12" sin viajar | parámetro | recupera el vuelco en 38,5° (F2) | 5 cm de tubo | sí | cálculo | la cuenta de la fase A con la mesa en la punta de la carrera |

**Lo considerado y descartado**, con su prueba:

- **Motorizar el dobson en alt-az y derrotar el campo en el programa** (como los telescopios «inteligentes»): con
  subs de 10-15 s funciona en el patio —la rotación de campo a 45° de altura corre la esquina del sensor ≈ 2″ en
  10 s—, pero no llega a los subs guiados de 2-4 min de N-11, y motorizar los ejes de madera es la reforma más
  invasiva de la montura (L0-05). La plataforma gana por N-11 y por el viaje, no por la física de los subs
  cortos. **El PDP §6 dice «el alt-az rota el campo: para exposición larga no sirve ni con los dos ejes
  perfectos»: es cierto para exposiciones largas, no para la meta del patio.** Se deja escrito para que nadie
  vuelva a pensarlo como imposible.
- **Comprar la plataforma comercial fotográfica:** cumple casi todo, pero N-04 pide construirla, la banda es de 5°
  y el 12" con GoTo la excede. Queda como precedente.
- **Pista mecanizada (electroerosión) para 60 s:** descartada el 24/10 (`20` §1); F6 no la revive (con filtro
  conviene guiar, no mecanizar).
- **Barlow para llegar a foco:** f/12 pide 4 veces la exposición y duplica el error en píxeles: es la última
  salida, no la primera.

### 4c. El balance (m24, NASA 6.8)

| Factor | Qué dice |
|---|---|
| requisitos y función | P1 y P5 son los que más acercan la foto con el menor diseño en el aire |
| forma y sencillez | P3 agrega un mecanismo; por eso hoy sólo se le deja el lugar (cuesta casi nada) y se decide con la pista medida |
| robustez | P7 y P8 sacan dos dependencias frágiles (la brújula y el disparador a mano) |
| costo | P4 es lo único que se compra antes de tiempo, y sólo si P0 lo pide |
| riesgo | P1 corre el riesgo de cortar chapas que después se terminan; la tarjeta madre lo acota (son módulo) |

## 5. Lo que se deja de hacer

- **Afinar la pista en el aire.** Los tres arreglos de `contacto-vns.js` (muestreo dentro de la foto) y buscar la
  causa del 1,2″ del trazado salen del camino: la envolvente ya es la salida, y la tolerancia de las ondas cortas
  la va a dar la muestra medida, no una cuenta mejor muestreada.
- **Las marcas del piso como solución general**: quedan sólo para el patio (L2-OPE-03 y 04).
- **El 22° de vuelco sin origen**: se reemplaza por el criterio del dobson solo.
- **L0-11 con «10 s» en el tope**: el número baja a L1-26, donde ya estaba.
- **Rehacer el modelo 3D por la latitud** antes de decidir la base (P10): se rehace una vez, con la decisión.

## 6. El orden propuesto, de lo fundamental a lo específico

1. **Fran, de día:** P0 (la Sony en el portaocular, ¿llega a foco?) **y el portaocular medido** (diámetro de la
   boca, cuánto entra y sale, si gira al enfocar). Diez minutos.
2. **Fran, una noche cualquiera:** el spike de 10 s (ISO 1600, cielo sin estrellas brillantes, el archivo crudo).
   Da el fondo del patio y, de paso, si la ZV-E10 se come estrellas chicas.
3. **Fran:** el inventario con calibre y las medidas del baúl del Clio (largo, ancho, alto de la boca y del piso).
4. **La sesión:** el ConOps de verdad (P6) y la MCR con Fran: el sí al concepto, el 30 s, el trazador.
5. **Fase A:** la muestra del canto y la palanca óptica (o el trazador entero, si Fran lo elige), el presupuesto
   de error con lo medido, la base contra el vuelco con la mesa en la punta, y la SRR.

Lo específico que va antes (el portaocular en el paso 1) va porque cambia el tren de imagen entero y se mide en el
mismo momento que P0.

## 7. Las decisiones de Fran

**Contestadas el mismo día:** la 1 («sí: 30 s sin guiar como piso, con el guiado previsto desde el diseño»,
aplicada en `10` v0.3 con L1-36) y la 2 («sí: primero la plataforma cruda andando en el patio con fotos de
10-15 s, y después se refina por módulos con lo que se mida», en el PDP §4 y §6). **Abierta:** la 3.

1. **¿Confirmás el piso de 30 s sin guiar, con el guiado previsto desde el diseño?** Con el ajuste de hoy: el
   guiado en AR alivia la pista en los blancos australes, y para que alivie en todos hace falta, más adelante, la
   declinación en el pivote (P3), que hoy cuesta sólo dejarle el lugar. *Recomendación: sí.*
2. **¿El trazador primero?** (a) Una plataforma cruda andando en el patio con fotos de 10-15 s en pocos meses, y
   después se refina por módulos con lo que se mida; o (b) el camino de hoy: requisitos en línea base, diseño de
   detalle y recién ahí construir. *Recomendación: (a)*; es lo que pide «viable, sin irnos al micrón».
3. **¿El 12" viaja?** (a) El 12" se queda en el patio y viaja sólo el 200 (la base sigue de 1,3 m), o (b) el 12"
   también viaja, en camioneta (base de ≈ 1,35 m y más peso en cada viaje).

Las respuestas van al PDP §6 y a la memoria; la 1 dispara el cambio de L1-01 y sus hijos en `10` (lista en §11.1).

## Fuentes

- TMS-Astro, plataformas EQ fotográficas: [Astroshop, 35-40°](https://www.astroshop.eu/equatorial-wedges/tms-astro-polar-wedge-eq-platform-photographed-35d-40d/p,86636), [Omegon, 35-40°](https://www.omegon.eu/polar-wedge/tms-astro-polar-wedge-eq-plattform-fotografisk-35d-40/p,86636).
- Alineación por astrometría: [SharpCap, Polar Alignment](https://docs.sharpcap.co.uk/4.1/9_PolarAlignment.htm), [StellaVita](https://www.touptekastro.com/blogs/tutorials/how-to-perform-polar-alignment-in-stellavita), [PAPS](https://www.astrophotography.app/usersguide/polar_align_via_ps___paps.htm), [AstroBin, TPPA](https://ssr.app.astrobin.com/forum/topic/42838/sky-watcher-az-gti/error-tryin-to-polar-lign).
- Largo del sub y filtros: [SharpCap foro](https://forums.sharpcap.co.uk/viewtopic.php?p=18796), [AstroBin, exposure time](https://app.astrobin.com/forum/topic/138538/exposure-time).
- Coma y correctores: [IceInSpace](https://www.iceinspace.com.au/forum/showthread.php?p=1381679), [Orion coma corrector](https://optcorp.com/products/orion-2-photo-visual-coma-corrector-for-newtonians).
- Foco en dobson: [Stargazers Lounge, 200P prime focus](https://stargazerslounge.com/topic/141497-prime-focus-skywatcher-200p-dob), [Stargazers Lounge, inward focus](https://stargazerslounge.com/topic/310065-inward-focus/).
- *Walking noise*: [StarTools](https://startools.org/forum/viewtopic.php?p=4227), [AstroBin](https://app.astrobin.com/forum/topic/179524/any-idea-whats-causing-this), [SGP, dither en un eje](https://forum.sequencegeneratorpro.com/t/direct-mount-guider-question/7017).
- Sony: [Lonely Speck, star eater](https://www.lonelyspeck.com/?p=87913), [Sony, intervalo en la ZV-E10M2](https://www.sony-asia.com/electronics/support/articles/00345860).
- OnStep: [OnStepX](https://github.com/hjd1964/OnStepX).
- Plataformas: [Matthews 2021, arXiv 2106.15694](https://arxiv.org/abs/2106.15694), [BAA, Equatorial Platforms 2](https://britastro.org/section_information_/equatorial-platforms-part-2), [Wikipedia](https://en.wikipedia.org/wiki/Equatorial_platform).
- Alt-az con subs cortos: [Sky at Night](https://skyatnightmagazine.com/astrophotography/astrophoto-tips/astrophotography-alt-az-mount), [SharpCap foro, derrotación](https://forums.sharpcap.co.uk/viewtopic.php?p=24480).
- Del proyecto: `docs/16`, `docs/17` §1, `docs/20` §1, `geometria-vns.js` v10.6; la cuenta del vuelco inclinado es
  un script de la sesión sobre `computeVNS` (se pasa al repo en la fase A, con su control).
