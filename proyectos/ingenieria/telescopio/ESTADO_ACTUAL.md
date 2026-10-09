# Estado actual — Automatización del telescopio 200/1200

**Última actualización:** 2026-10-09 de madrugada (decimoséptima sesión: sin medidas nuevas; **revisión de punta a punta** —`docs/16`, Doc 4 del Drive—: **la pista** (canto y rodillos) pide micrones y pesa más que la transmisión; el canto se traza como envolvente del rodillo; fuera los cuatro 608; tolerancias de armado; **planos de disposición** en PDF A3)

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Concebir (Pre-Fase A, *Concept Studies*) | **en curso**, abierta el 2026-10-04 |
| 1 — Requisitos y presupuesto de error | sin empezar |
| 2 — Reforma de la montura | sin empezar |
| 3 — Diseño detallado de la plataforma | sin empezar |
| 4 — Construir, integrar y probar | sin empezar |
| 5 — Operar (la foto) | sin empezar |

**Qué cierra la fase en curso:** los tres números que mandan medidos (masa
total, centro de masa 3D, ¿llega a foco la cámara?), el inventario sin
ninguna fila en `?`, **una** arquitectura de plataforma elegida en un trade
study con los pesos puestos por Fran y un ganador que no empata, y **el
borrador de requisitos** (`docs/10-requisitos.md`, agregado el 2026-10-07: ver
`PDP.md` §4, punto 4).

**De las cuatro, van dos:** la arquitectura está elegida — **VNS**, por Fran y
por `docs/05-trade-study.md` (4,5 contra 2,7, sin empate en ningún orden) — y
**el borrador de requisitos existe y certifica**: `docs/10-requisitos.md`, 11
necesidades, 14 de misión, 26 de sistema y 27 de elementos, con
`python docs/verificar-requisitos.py` en verde (traza completa, GtWR 0 VIOLA).
Faltan las mediciones (el centro de masa por dos métodos y la prueba de foco)
y el inventario sin `?`.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| El telescopio es un newtoniano de 200 mm de apertura y 1200 mm de focal (f/6), con buscador integrado al tubo | lo dice Fran, dueño del equipo | 2026-08 |
| La montura es una dobson de madera de diseño propio, con base fija, base móvil sobre tres tacos de PVC y disco de vinilo, cuatro paredes y caja sujetadora con tornillos de presión sobre retazos de goma | descripción de Fran, consistente entre dos sesiones | 2026-10-04 |
| Las paredes flexan: separación 37 cm abajo y 36 cm arriba | medido en 2026-08 | 2026-08 |
| **El CS (segmentos circulares) no admite apoyo real en tres puntos y es el de menor capacidad de carga de los diseños utilizables**; el VNS da tres puntos, transmisión de peso más directa y más carga — y hay un VNS construido que lleva **45 kg** | lectura de la referencia canónica (Reiner Vogel y BAA), ver `docs/04-conceptos.md` | 2026-10-04 |
| Un brazo tangencial **sin** corrección de tangente anda bien sólo 5 a 10 minutos | misma fuente | 2026-10-04 |
| En el hemisferio sur no hay estrella polar útil: σ Octantis es magnitud 5,4 y está a 1° 8' del polo | misma fuente | 2026-10-04 |
| **La arquitectura es VNS**, con diseño adaptable (suplementos, ranuras, tres patas regulables) | decisión de Fran + trade study con sus pesos (`docs/05-trade-study.md`) | 2026-10-04 |
| En el hemisferio sur el VNS va **espejado**: pivote al **norte**, segmentos verticales al **sur** | geometría (el eje sube hacia el polo sur) + Wikipedia; `probar-geometria.js` lo controla con sabotaje | 2026-10-04 |
| A 34,5° el pivote queda a `H / tan φ` del centro de masa: con H = 64 cm, base de ≈ 1,41 m (1,12 m con 20 cm de poste). Velocidad no constante ±0,48 % y corrimiento en el rodillo ±13,7 mm sobre toda la chapa (hasta el talón; eran ±0,31 % y ±8,7 mm antes de los límites); cada chapa girada 7,9° | **por cálculo** (`docs/geometria-vns.js`, 6 controles en verde y 4 sabotajes en rojo). Los números dependen de H, que sigue siendo hipótesis | 2026-10-04 |
| **Límites de carrera en tres capas** (pedido de Fran): programa a ±45 min, fin de carrera (2 microswitches + una leva M5 en el medio de la chapa) a ±48 min, y **talón** en cada punta de la chapa que choca el rodillo a ±51 min. La chapa se estira un radio de rodillo más allá del talón: pasa de 298 a **378 mm de rodadura (394 con talones)** y de 91 a 106 mm de alto; sigue saliendo de una chapa de 500 × 500 | **por cálculo** (`docs/geometria-vns.js`; control nuevo «límites en orden», con sabotaje `stopMin: 2` en rojo). Modelo v3 publicado | 2026-10-04 |
| Carpeta de Drive compartida con Kevin como **editor**: `05 - PROYECTOS…/Telescopio 200-1200 - Fran y Kevin`, con el cuaderno, la guía de armado (`docs/07-guia-armado.md` → Doc con `docs/md-a-gdoc.py`) y el protocolo de medición | permiso leído del objeto (el cuaderno hereda `writer` de Kevin); declarado por hash en `.claude/estructura-drive.json` | 2026-10-04 |
| **Geometría del dobson medida**: base fija 43 × 40; base móvil 40 × 40; paredes grandes 40 × 79,6 (buscador) y 40 × 78,8; paredes chicas 20 × 40 (ocular) y 19,8 × 40 (cola); caja 40 × 31 (techo y piso) y 40 × 27 (costados); todo de 2 cm; tubo 25,3 cm de diámetro, aro 26,7; escalón pared-base móvil 1,7 → 1,3 cm | cinta, Fran, ±1 mm de lectura, una vez; registro en `docs/08-medidas.md`, 71 fotos en `fotos/2026-10-04/` (ignorada) y en el Drive | 2026-10-04 |
| Existe trabajo de CAD previo: 22 piezas SolidWorks, 2 DXF de plantilla y un macro VBA de 1571 líneas que genera la geometría CS y emite los DXF él mismo | los archivos están en `cad/`, contados | 2026-10-04 |

| **Base al piso: triángulo de 1,2 m de ancho** (no cuadrada): vuelco de costado 17,8° → 25,0°, al sur 24,4° (manda el sur desde 1,2 m); una cuadrada tiene el mismo borde sur, cuatro patas que renguean y ≈ 1 m más de planchuela. **Soldar** marco, brazo, cartelas, triángulo y poste; **abulonar** travesaño del sur (baúl), soportes de rodillos (ranurados), aluminio y dobson (mariposas) | pregunta de Kevin + decisión de Fran («se sueldan, o abulonan si vos lo recomendás»), `node docs/estabilidad-base.js`, control con sabotaje en `probar-geometria.js` (9 verdes, 7 rojos), modelo v8 | 2026-10-05 |
| **Motor: NEMA 17 de ≈ 4 kg·cm** (el de 1,6 kg·cm deja 2,6× contra una ráfaga de 40 km/h, el de 4 deja 6,5×) | cálculo (`09-estructura-hierro.md` (sección Motor)); las cifras de viento y rozamiento son estimaciones propias | 2026-10-05 |
| **Documentos separados por pedido de Fran:** `07-guia-armado.md` = el concepto del proyecto; `11-paso-a-paso.md` = los pasos en orden, en criollo, con la parte formal FAB/CAL al final. Mismos nombres en el Drive («1 - El proyecto…», «2 - Paso a paso…») | Fran, 2026-10-05; IDs del Drive verificados | 2026-10-05 |
| **El contacto camina por el rodillo para UN solo lado**: 0 en el centro de la carrera, 12,6 mm en las puntas (7,6 dentro de ±45 min); es geometría, no deslizamiento. Centrado, alcanza un rodillo de 25 mm. El «±13,7 → rodillo de 40» de la nube estaba mal leído | `geometria-vns.js` (recorrido con signo) + control en `probar-geometria.js`, con sabotaje en rojo (12 verdes) | 2026-10-07 |
| **Revisión de afuera** (`docs/13-revision-externa.md`): la arquitectura está bien; tres errores corregidos (rodillo de 40, ángulo de vuelco 34° → 24°, polea en un rodillo loco en v8); mecanismo con lo rescatado; estructura de tubo 20 × 20 con vigas compuestas; rodillos a 50 cm (la mesa aguanta 6,9 kg de empujón, más que el dobson solo); sin planos en fase 0 (Fran) | cálculo, `probable`; controles nuevos en `probar-geometria.js` | 2026-10-07 |
| **Modelo v9** publicado desde la cuenta de Agus y Fran: https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd (el link viejo de la cuenta personal quedó en v8). Docs «1 - El proyecto» y «2 - Paso a paso» regenerados, mismos IDs | publicado; IDs medidos con `rclone lsf` | 2026-10-07 |
| **Borrador de requisitos** `docs/10-requisitos.md` v0.1: N → L0 → L1 → L2 (PLT, MON, CAM, OPE), cada uno con tipo, padre, método de verificación, estado y si lo muestra el modelo; rationale por ID; KDR L1-01, L1-02, L1-15, L1-22; trazabilidad inversa del diseño v9. **El v9 incumple L2-PLT-12** (4 bulones del dobson, el requisito pide 3). Del modelo: mesa a 22,6 cm del piso, inclinación de 10,5° en el talón, vuelco 24,1°, empujón 6,9 kg | `python docs/verificar-requisitos.py` VERDE (autotest: 9 sabotajes con su motivo + 2 del GtWR); en `chequeo-completo.ps1`. **No está en línea base**: falta Fran (SRR, fase 1) y 3 preguntas suyas (§11.1) | 2026-10-07 |
| **El dobson de 300 mm es necesidad** (N-12): la misma plataforma lleva el 200 y cualquier 12" comercial, GoTo incluido (≤ 50 kg), por **mesa universal**: corredera norte-sur con posiciones marcadas; chapas, rodillos, motor y base únicos; chapa de 5/16". La corredera va **bajo el dobson**, no en el pivote: el eje sube 6,9 cm cada 10 cm al sur. Requisitos **v0.2** (L0-15, L1-27 a L1-30, L2-PLT-05, L2-PLT-14 a 16). El v9 no lo muestra todavía | Fran: «correr y apretar», «cualquiera, GoTo incluido», «debe servir para ambos, aunque aumente la complejidad, no perdamos precisión»; cálculo `node docs/escenarios-300.js` (los datos del 12" son de catálogo, `hipótesis`); `verificar-requisitos.py` VERDE; `docs/14-concepto-300mm.md` | 2026-10-07 |
| Los Docs «1 - El proyecto» y «2 - Paso a paso» del Drive **coinciden palabra por palabra con el repo** (salvo el encabezado y la numeración de listas): nadie los editó a mano | export txt + comparación por palabras | 2026-10-07 |
| **Modelo v10: la plataforma «terminada»** (diseño preliminar, pedido de Fran: «nada flotando», con grados confirmado/probable/en revisión). Mesa universal: marco con tres largueros y **tres rieles** arriba, corredera con una muesca por telescopio (`dNEquilibrio`, forma cerrada), selector 200 / 12" fantasma, **tres mordazas de borde** (salen los 4 bulones y el suplemento), chapa 5/16", electrónica con botón y ST-4, batería, marcas del piso. Muescas: 200 a 2,8 cm al norte; 12" de 0,5 a 18,8. Vuelco ≥ 22° con todos; **único rojo: el 12" liviano, empujón 5,5 kg** (rodillos a 58 cm y base 1,3 m lo arreglan) | `probar-geometria.js` (13 OK, control nuevo de la corredera con sabotaje en rojo); «Piezas sueltas» medido en el panel: 0, y 22 con el buje del v9 saboteado; publicado, mismo tamaño que el repo + 552 B | 2026-10-07 |
| **El artifact es público con el link**: lo dice la respuesta de la herramienta al publicar («shared as Anyone with the link»). Cierra el «Fran dice que es público: sin medir» | respuesta del publish, 2026-10-07 | 2026-10-07 |
| **El dibujo para medir el centro de masa existe**: `docs/dibujo-cdm.html` (fuente única) → PDF «Medir el centro de masa» (3 páginas, mirado) en el Drive y enviado a Fran, y 4 imágenes adentro del Doc «2 - Paso a paso». Docs «1 - El proyecto» v5 (el 300, mordazas, transmisión F con respaldo T2, Kevin K1-K9) y «2» v4 regenerados con los mismos IDs; el Cuaderno del 4/10 al Archivo como VIEJO | IDs con `rclone lsf`; el Doc 2 bajado tiene las 4 imágenes; un Doc acepta imágenes: probado antes con un borrador | 2026-10-07 |
| **Modelo v10.1** publicado (versión 6 del artifact, público con el link): el motor va en una **escuadra NEMA 17 sobre la misma planchuela del rodillo motriz** (una pieza en L, cuatro M8 a la viga; correa del lado sur); en el v10 colgaba de una planchuela apoyada en el canto del ángulo. Cables acostados sobre la viga; electrónica al lado del rodillo motriz. **El 12" teórico, sólido y en color** (pedido de Fran) | «Piezas sueltas» = ninguna con el 200 y con el 12"; consola sin errores; vistas miradas; publicado = repo | 2026-10-07 |
| **Modelo v10.3** (versión 8): **nada choca** — el panel gira chapas y mesa de tope a tope y prueba cada punto contra cada pieza fija («Choques»). El v10.1-10.2 tenía la electrónica, la batería y un fin de carrera adentro del barrido de las chapas, y los ángulos de los rodillos rozados en el tope: electrónica y batería a los tubos de costado, cada fin de carrera a la altura real de la leva, ángulos a ±32 mm. **60 s** (Fran): requisitos actualizados; trade F/T2 empatado, lo decide el banco | `choques()` = ninguno con el 200 y el 12"; `sabotearChoque()` lo ve (1) y restaura 0; `sabotear('motor')` 7/7, `('finales')` 6/6; requisitos VERDE; 13 OK | 2026-10-08 |
| **Modelo v10.2** (versión 7): fines de carrera del lado sur de la chapa, cada uno en un pie que cruza la viga con **dos M6 en fila** (antes: voladizo de 6,7 y 12,6 cm con un bulón); todo lo de la viga sur con dos M6 en fila sobre el eje del tubo en tuerca remache (los M8 de los rodillos caían afuera del tubo); cables en un mazo por la cara del tubo. **No hace falta una planchuela paralela** | «Piezas sueltas» = ninguna con los dos telescopios; `sabotear('motor')` 7 de 7 y `sabotear('finales')` 6 de 6, restaurado 0 | 2026-10-07 |
| **El tiempo de cambiar de telescopio no importa** (Fran): L1-29 sin tope, definido; requisitos VERDE | `verificar-requisitos.py` VERDE (12 N, 15 L0, 30 L1, 31 L2) | 2026-10-07 |
| **30 contra 60 s, en números** (`docs/14` §6b): un error de velocidad δ corre la estrella δ·15″/s·t en un sub de t s, así que 60 s parte a la mitad todo el presupuesto (alineación 7′ → 3,8′, velocidad media 0,2 → 0,1 %, la PEC pasa de recomendable a obligatoria); plata casi igual; en el patio gana ≈ 1 % de señal/ruido, en cielo oscuro ≈ 15-20 %. **Guía del trade** (§6c): la precisión es piso, no peso (quedan F y T2); F gana si precisión + costo > 2 × «no patina»; el banco del rodillo mueve la decisión más que los pesos | cálculo; el descentrado de 0,02 mm, el cielo del patio y el ruido de lectura son `hipótesis` | 2026-10-07 |
| **El error de micropaso cuenta, y saca a la F de una correa** (`probable`): un paso a paso cae en cada paso entero con hasta ±5 % de error (hoja de datos) y el micropaso no lo achica (Analog Devices). Con la F de una correa 20:80 cada paso entero mueve ≈ 34″ el cielo: borrón ≈ 3,4″ y redondez 0,66 en cada foto (L2-PLT-02 y L0-02 no cumplen). Pasan F2 (dos correas, 8,4″), la V de paso 8 (10,5″), T2 con tornillo de bolas (5-7″) y el cable (C, 9″); las monturas EQ6/HEQ5-R dan 9-14″. Con el orden de Fran el trade **ya no empata: T2 gana** a F2 por 15-21 % con los tres métodos (10 % aunque F2 no patine). `docs/13` §4 lo había dado en ±1″ «que se confunde con el aire» | `node docs/transmisiones.js` + `probar-transmisiones.js` (6 controles, 6 sabotajes en rojo); la estrella simulada sobre píxeles da 0,66 contra 0,65 de la fórmula; fuentes en `docs/15` §9. Lo confirma la **palanca óptica** (paso 6b de `11`) | 2026-10-08 |
| **Rodillos a 58 cm y base de 1,3 m (modelo v10.5): todo verde.** Vuelco ≥ 22,3° y empujón ≥ 6,1 kg con los siete casos de la envolvente (el 12" liviano daba 5,5 con 50 cm). Un lastre de 5 kg no servía (5,5 → 5,5). Los fines de carrera pasan a 4,5 cm de la chapa (la punta del travesaño barría 6 mm de un soporte) | `geometria-vns.js` (cálculo); en el panel, con F y V, 200 y 12": «Choques: ninguno», «Piezas sueltas: ninguna»; sabotajes motor 7/7 (F) y 4/4 (V), finales 6/6, choque 1, restaurado 0; con la vista explotada, choques y sueltas siguen en 0; publicado (versión 10 del artifact, público con el link, visto sin sesión) | 2026-10-08 |
| **Las chapas ya no dependen del vuelco**: los rieles toman al 200 con el centro de masa entre 55 y 69 cm (con 70 las mordazas se salen 1 cm) y a toda la envolvente del 300 (el peor, 40 kg y 50 cm, pide 21,7 cm al norte y entra). El vuelco sigue cerrando la fase 0, pero confirma las chapas en vez de definirlas | chequeo «Las tres mordazas caen sobre los rieles» del modelo, barrido a mano con el deslizador (55, 63, 69, 70, 71, 72) | 2026-10-08 |
| **Proveedores de la zona** (directorios, sin llamar: `hipótesis`): láser que dice cortar 8 mm (Rapimetal hasta 9, Martino hasta 1/2"); Prymax (Garín) llega a 4,7: no; tornería con rectificadora en Munro (Acosta); rulemanes en Munro (Av. Mitre 2996) con rodamientos lineales; tornillo de bolas SFU1605/1204 no aparece en el país (USD 12-35 afuera) | `docs/15` §5 | 2026-10-08 |
| **Docs del Drive**: «1 - El proyecto» v7 y «2 - Paso a paso» v5 regenerados con el **mismo ID**; **«3 - Mecanismos, proveedores y cielo»** nuevo (`1xMPDUoihZAX2ZthJrEnyKVfAUAyWl-JattlAG8yAOV8`), con 4 imágenes y 11 tablas | `rclone lsf --format pit` antes y después; el Doc 3 exportado de vuelta trae las 4 imágenes | 2026-10-08 |
| **La pista manda** (`probable`): 1 µm de error en el canto mueve la estrella ≈ 0,27″; para ≤ 0,2″ por error en 60 s: ondulación del canto ≤ 1-2 µm (ondas de 5-50 mm), escalón ≤ 0,5 µm, salto de cada rodillo ≤ 2 µm. ≈ 70 % es bamboleo del eje, que ni la tabla del programa ni el guiado corrigen. Un canto láser crudo y un 608 común (15 µm) no llegan (`hipótesis` hasta medir una muestra: paso 6c de `11`) | `node docs/contacto-vns.js` + `probar-contacto.js` (6 controles —dos de ellos cuentas de una línea independientes— y 4 sabotajes, verde); `docs/16` §2 | 2026-10-08 |
| **El canto se traza como envolvente del rodillo**: el método de hoy (el punto de arriba) deja 1,2″ por foto en las puntas (con Ø32, 1,28″); la envolvente, 0. La chapa queda atada al diámetro del rodillo (±0,3 mm): se elige antes de cortar. `13` §3 lo había dado por «0,4 mm, constante»: es 0,57 mm y varía 0,1 mm | ídem; C1 (subida en el centro contra r(1/cos b − 1): 0,567 contra 0,574 mm) | 2026-10-08 |
| **Cuatro 608 lado a lado no sirven**: el contacto camina 8,2 mm a lo largo del rodillo y cruza costuras: 2,4-4,2″. Va un rodillo de una pieza (camisa rectificada sobre dos 608) | ídem, `contacto-vns.js` §4 | 2026-10-08 |
| **La chapa apoya en una arista** desde el minuto ≈ 10: el rodillo se tuerce hasta 32′ a ±45 min (74 µm de luz en los 7,94 mm). Salidas: rodaje y rebaba del otro lado, o rodillo basculante (fase B) | ídem, §1 | 2026-10-08 |
| **Tolerancias de armado** (cada una sola, 0,2″ por foto, V/T2): rodillo a nivel y chapa a plomo ±0,078°, chapa en planta ±0,15°, rodillo en planta ±0,24°, pivote en altura ±0,76 mm, chapa en altura ±0,41 mm, rodillo E-O ±1 mm, en altura ±1,4, N-S ±3, pivote N-S libre | `tolerancias()` de `contacto-vns.js`, la misma tabla en node y en el navegador (hoja 5) | 2026-10-08 |
| **Planos de disposición** (preliminares, NO para fabricar, Fran 2026-10-08): `docs/planos.html` → PDF A3 de 5 hojas (planta, alzado, vista sur, chapa 1:1, tolerancias y profundidades) en el Drive; se rehacen con el centro de masa medido | PDF de 5 páginas de 420 × 297 mm, la hoja 5 calculada (no «calculando»); ID `1uJ853WGlh8TeLUAmO_HtWFC4L5afre8J` con `rclone lsf` | 2026-10-08 |
| **Docs del Drive**: 1 v8, 2 v6 (paso 6c, tabla FAB/CAL al día: 5/16", rodillos de una pieza, mordazas, 0,1 %, 1,5 px, rodaje) y 3 (los esquemas con la chapa de verdad) con el **mismo ID**; **«4 - Revisión: qué puede salir mal»** nuevo (`1nlXkMXiffayMMLz8TbeIxN6xhdgzKxUkgcBWtgUigDE`) | `rclone lsf --format pit` antes y después | 2026-10-08 |
| **La cámara y el foco se aparcan** (Fran, 2026-10-05). P0 sigue abierta en el PDP y es **compuerta antes de comprar la chapa de aluminio** | decisión de Fran; la compuerta es mía | 2026-10-05 |

## Lo que es hipótesis

> Todo lo de abajo viene de la sesión de 2026-08, que trabajó **sin
> arquitectura ni mediciones**. No se tira: se marca. Un número heredado es
> una hipótesis aunque esté escrito con dos decimales.

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| masa total **≈ 40 kg, `probable`**: por partes 19,2 (tubo) + 19,7 (montura) = 38,9 sin ocular, contra 40 con ocular pesado entero; cierran a 1,1 kg (`docs/08-medidas.md` §3.2). La estimación por volumen (27) estaba mal | anotar la balanza (rango y resolución) | dos caminos con la misma balanza sin calibrar |
| centro de masa **≈ 63 cm** (58 a 69) sobre el piso del dobson, `probable`: compuesto con las pesadas (tubo sin caja 19,7 con cámara; montura de pino con la caja 19,7) y la geometría; el tubo está **balanceado sin la cámara** | P3 o P4 como segundo método, y pesar la caja sola | el rango sale de no saber dónde están los ≈ 2-5 kg de herrajes de la montura (`08-medidas.md` §3.2) |
| largo del tubo (135,5 cm, de 2026-08), hueco de los tacos (≈ 1,5 cm, foto) y eje de altura ≈ 2,6 cm debajo del borde de la pared (fotos) → a ≈ 82,5 cm del piso del dobson | cinta | lo demás de la geometría ya está medido (ver *Lo confirmado*); estas tres salen de fotos o de agosto |
| el portaocular es **helicoidal 1,25"** con ≈ 1 cm de recorrido | mirarlo y medir cuánto sube la rosca | fotos 59-63; si es así, explica de sobra un «no llega a foco» con la cámara, y la Barlow lo arregla |
| el motor de la impresora (Mitsumi M28N-1, repuesto HP C6409-60004) es **de continua con encoder**, no paso a paso | contar sus cables (2 = continua) | fotos 46-53 |
| todos los parámetros de diseño de 2026-08 (radios 48,3 y 72,0 cm; recorridos ±6,3 y ±9,5 cm; tabla móvil 50 × 50; base fija 70 × 50; carrera ±7,52°) | recalcularlos con la masa y el CoM medidos, **y sólo si gana CS en el trade study** | se derivaron de `H = 64 cm`, que es una estimación |
| la placa **HW-130** es un driver de motores paso a paso | la foto de la serigrafía de los dos lados (P6, foto 7) | nunca se leyó la placa. `probable` que sea una **fuente para protoboard**, no un driver — en ese caso falta el driver y es una compra |
| los rulemanes son 608ZZ | medir el diámetro exterior: 22 mm → 608 | lo dijo Fran de memoria («creo que M8») |
| la cámara es una Sony ZV-E10 | confirmarlo con el cuerpo en la mano | lo anotó la sesión de 2026-08 y hoy Fran dijo «una cámara Sony» sin modelo |
| el 200/1200 **llega a foco** con una cámara en foco primario | P0 del protocolo, diez minutos de día; **o** que Kevin confirme que en Saturno se veían los anillos | falla clásica de los newtonianos. **Dato 1, 2026-10-04 (Kevin, vía Fran):** con un adaptador impreso, «se ve como sin aumento». **Dato 2, mismo día:** lo decía **mirando Saturno**, «poco aumento porque no sirve para Saturno, necesitaríamos Barlow». Eso cambia el orden: a 0,67″/píxel (ZV-E10 a 1200 mm) Saturno con anillos mide ≈ 45″ ≈ 65 píxeles de 6000 — un puntito, que es lo **esperado** en foco primario. `probable` ahora: (d) **sí llegó a foco** y la imagen es chica, que es correcto; (a) no llega a foco, baja. Lo separa una pregunta: ¿se veían los anillos? La Barlow es para planetas; para nebulosas (la meta) va sin Barlow (f/12 pide 4× la exposición). Explicado en `docs/07-guia-armado.md` §2 |
| las expectativas de resultado de 2026-08 (0,67 arcsec/píxel, subs de 20-30 s sin guiar, 2-4 min guiando) | el presupuesto de error de la fase 1, y después la medición de deriva de la fase 4 | se escribieron como predicción y conviene que no se citen como hecho |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| elegir la arquitectura CS por el argumento «es la única que deja poner el eje polar en el centro de masa» | el argumento es **falso como exclusividad**: el VNS cumple la misma condición | la decisión se reabre. La ventaja real de CS es sólo que el perfil se traza con un piolín, y eso se cae cuando ya hay un macro que emite el DXF |
| (según los comentarios del macro VBA) manipular sketches de SolidWorks por nombre con `SelectByID2`, y cerrar sketches 3D con `InsertSketch` | falló por idioma y por el toggle de `Insert3DSketch` | el macro ya tiene las seis correcciones escritas en su encabezado. Si se reusa, se reusan |

## Lo próximo

> **2026-10-09 de madrugada (decimoséptima sesión) — manda sobre todo lo de abajo.**
> Sin medidas nuevas. Hecho: la revisión de punta a punta (`docs/16`, Doc 4),
> la cuenta del contacto y las tolerancias (`contacto-vns.js`), los planos de
> disposición (PDF A3 en el Drive) y los Docs 1, 2 y 3 al día. **Lo que cambió
> el orden: la pista pesa más que la transmisión.** Sigue: **(1)** la foto de
> la tabla del vuelco (L1-15); **(2)** la **muestra del canto** (paso 6c de
> `11`): una tira de láser medida con comparador milesimal, que decide si la
> foto puede ser de 60 s y si hay que terminar los cantos; **(3)** las medidas
> de la varilla; **(4)** la palanca óptica; **(5)** la prueba de foco.
> **Fran:** ¿60 s o 30 s, con la pista sobre la mesa? (se recomienda decidirlo
> con la muestra); ¿se paga la terminación de cantos y rodillos?; ¿viaja en
> auto (fija el recorrido de las patas)?; ¿cuánto armado (choca con el
> enfriamiento del espejo)? **El modelo publicado (artifact) quedó con los
> esquemas viejos de la chapa**: se republica con el próximo cambio del modelo.
>
> **2026-10-08 a la noche (decimosexta sesión).**
> Sin medidas nuevas. Hecho: `docs/15` y el Doc 3 (mecanismos, proveedores,
> cielo), el modelo **v10.5** y los Docs 1 (v7) y 2 (v5). Sigue, en este
> orden: **(1)** la foto de la tabla del vuelco (L1-15: ahora confirma las
> chapas, no las define); **(2)** las medidas de la varilla de la foto (si es
> de bolas o trapezoidal, es T2); **(3)** la **palanca óptica** con el motor
> del banco (paso 6b de `11`): da el error real del micropaso; **(4)** la
> prueba de foco. **Fran:** ¿viaja en auto (Punta Indio entra en la
> tolerancia de latitud)?, ¿cuánto armado?, ¿un filtro de dos bandas para la
> primera foto en el patio? La transmisión se elige en su nivel (la V de
> NASA): con su orden, va ganando T2.
>
> **2026-10-08 (decimocuarta sesión, cierre).**
> Fran eligió **60 s** y el orden **precisión > no patina > facilidad > costo**:
> el trade F/T2 **empata** con cualquier método de pesos; lo decide **el banco
> del rodillo** (si F no patina, F + PEC; si patina, T2 + PEC). Requisitos con
> 60 s (VERDE). Modelo **v10.3** (artifact versión 8): **nada choca** en toda la
> carrera, medido en el panel. Sigue: **(1)** la foto de la tabla del vuelco
> (L1-15); **(2)** el banco del rodillo, que decide la transmisión; **(3)** la
> prueba de foco. **Fran:** ¿viaja en auto?, ¿cuánto armado?
>
> **2026-10-07 (decimocuarta sesión).** Hechos
> el v10.1 (motor apoyado, 12" en color), L1-29 sin tope y la cuenta de 30/60 s
> con la guía del trade (`docs/14` §6b-6c). Sigue: **(1) Fran elige 30 o 60 s**
> (la sesión recomienda 30 si la plataforma no viaja a un cielo oscuro) y
> **reparte 10 puntos** entre margen de precisión, que no patine, facilidad y
> costo; con eso la sesión cierra el trade F/T2. **(2)** La foto de la tabla
> del vuelco (cierra L1-15). **(3)** La prueba de foco. **Fran:** ¿viaja en auto?,
> ¿cuánto armado?
>
> **2026-10-07 (decimotercera sesión).** Hechos
> el dibujo del CdM, el modelo v10 y los Docs. Sigue: **(1) Fran y Kevin
> miden** con la hoja «Medir el centro de masa» (vuelco hA, A, hB, B, W y la
> altura del eje) y mandan **foto de la tabla**; con eso la sesión cierra el
> CdM por dos métodos, fija la muesca del 200 y el eje (L1-15, L2-PLT-05).
> **(2)** El trade de la transmisión (F, B, T, T2) cuando elijan **30 o 60 s**,
> con pesos de Fran. **(3)** La prueba de foco. **Fran:** además, ¿cuánto para
> pasar del 200 al 12"?, ¿viaja en auto?, ¿cuánto armado?
>
> **2026-10-07 (duodécima sesión).** El 300 mm
> subió a necesidad y los requisitos van por la **v0.2** (con L2-PLT-17: **el
> dobson no se agujerea**, tres mordazas de borde). Sigue, en este orden, pedido
> por Fran para una sesión nueva: **(1) el dibujo de cómo medir el centro de
> masa** (el vuelco, paso 1 de `11`, y la altura del eje, paso 2), que pidió
> hace rato y no estaba; **(2)** el modelo 3D con la propuesta de la sesión:
> mesa universal (corredera, ~70 cm, selector 200 / 12" de la envolvente),
> **tres mordazas de borde**, transmisión F, sin piezas volando (L1-28,
> L2-PLT-05, L2-PLT-12, L2-PLT-14, L2-PLT-15, L2-PLT-17), publicado en el
> artifact; **(3)** los Docs del Drive con el 300 y el dibujo (L1-15); **(4)**
> el trade de la transmisión cuando Fran y Kevin elijan 30 o 60 s (propuesta:
> F, respaldo T2; `docs/14` §6). **Fran:** el vuelco y la altura del eje (siguen
> mandando: además definen si el 200 en el borde alto vuelca, 18,4°), la prueba
> de foco, y §11.1 de `10`: ¿agujerear la base del 300 o tomarla con topes?,
> ¿cuánto para cambiar de telescopio?, ¿viaja en auto?, ¿cuánto armado?
>
> **2026-10-07 (undécima sesión).** Los
> requisitos están escritos. Sigue, cada commit citando los IDs que cumple:
> **(a)** el modelo sin piezas volando, con soportes y los **3 bulones** del
> dobson (**L2-PLT-12**, hoy incumplido); **(b)** los dibujos del centro de masa
> en los Docs del Drive y el Drive simplificado (**L1-15**). **Fran:** el vuelco
> y la altura del eje (cierran L1-15), la prueba de foco (L1-22), y tres
> preguntas: 30 o 60 s por foto, ¿viaja en auto?, ¿cuánto armado? (§11.1).
>
> **2026-10-07 (décima sesión).** El orden:
> **1) escribir `docs/10-requisitos.md`** con los criterios de la cátedra (IISE
> m17, m21), el GtWR y NASA — necesidades `N-xx` → `L0` → `L1` → `L2` con
> trazabilidad, tipo, rationale, método de verificación, `TBD`/`TBR`, qué falta
> definir y qué ya representa el modelo 3D; la puerta no deja diseñar antes.
> **2) Los pedidos de Fran de esta sesión, trazados a esos requisitos:** los
> dibujos para medir el centro de masa en los Docs del Drive (si el formato Doc
> no aguanta imágenes, otro, pero en el Drive), leer el Drive entero y
> simplificarlo (el Cuaderno del 4/10 quedó viejo: dice "CS o VNS abierta" y
> "50 kg"), y el modelo sin piezas volando, con sus soportes y los **3 bulones
> con mariposa** de Kevin (hoy son 4 en el modelo). **3) Pendiente de Fran,
> URGENTE:** el vuelco (hA, hB, A, B, W) y la altura del eje — sin medidas
> nuevas al 7/10; con eso se cierra el CdM por dos métodos.
>
> **2026-10-07 (novena sesión).** El
> orden vigente es `docs/11-paso-a-paso.md` **versión 3** (siete pasos): 1) el
> vuelco de la montura sin tubo; 2) la altura del eje con cinta; 3) inventario
> de hierros y rescatados con calibre (pared de los tubos, ¿varillas de 8,00?,
> cuántos 608, la balanza); 4) **Fran elige 30 s o 60 s por foto**; 5) ¿el amigo
> metalúrgico tiene torno?; 6) motor en el banco; 7) la sesión cierra el CdM y
> la revisión de fase. **La sesión no diseña más hasta tener el 1 y el 2.** El
> porqué de todo: `docs/13-revision-externa.md`. Un 12" futuro: no se diseña,
> tres puertas abiertas (PDP §6).

Masa ≈ 40 kg por dos caminos, CdM ≈ 63 cm compuesto (58 a 69), plataforma de
planchuela de hierro, poste de 10 cm, base triangular **ancha (1,2 m)**,
modelo v8. **El orden vigente de lo que sigue, con quién y cómo se sabe que
salió bien, está en `docs/11-paso-a-paso.md`** (nueve pasos): 1) anotar la
balanza; 2) P3, la montura con caja inclinada, que da la **altura** del CdM (es
el segundo método; P4 plano no la da); 3) P4 como control; 4) medidas chicas y
pesar 1 m de cada planchuela; 5) inventario; 6) rodillo de prueba (Kevin);
7) motor y TMC2209 andando en el banco; 8) la sesión cierra el CdM y rehace el
modelo; 9) revisión juntos y luz verde a la fase 1 (Fran elige el tiempo de
exposición). **Cámara y foco aparcados**; P0 es compuerta antes de comprar el
aluminio. Ya no hace falta pesar la caja sola. Pendiente de Fran: el
puesto 3 de los pesos. Pivote: rótula de amortiguador a gas en un cono.
Extra de Kevin (pantalla y Bluetooth con ESP32): fase 3.
