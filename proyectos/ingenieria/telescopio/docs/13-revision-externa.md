# Revisión de afuera: ¿venimos bien?

**Escrito el 2026-10-07 (novena sesión)**, a pedido de Fran: «mirá el proyecto
como alguien de afuera, especialista, y asegurate de que venimos bien», más el
mecanismo pensado con lo rescatado (engranajes y correas de impresora y
casetera, rulemanes de roller, varillas de impresora) y la estructura con lo
que hay (tubo 20 × 20, planchuela, algún T, ángulos). Grado de cada cosa entre
corchetes. **Manda sobre `12-critica-y-medicion.md` donde se contradicen** (§3).

## 1. El veredicto, corto

- **La arquitectura está bien** y no se reabre: VNS espejado al sur, tres
  apoyos, eje en el centro de masa de todo lo que gira, tres capas de tope.
  Es lo que haría un especialista. [criterio, con las fuentes de `04`]
- **El proceso, no tanto.** Ocho sesiones de diseño, el material cambió tres
  veces (aluminio y PETG → planchuela → acero y tubo), y los tres datos que
  cierran la fase 0 siguen sin medir. El diseño cambia porque los datos
  llegan de a uno. Lo que destraba todo es **una tarde de mediciones**, no
  otra versión del modelo (§9).
- **Encontré tres errores**: dos de la sesión de la nube y uno del modelo v8.
  Ninguno toca la arquitectura; uno cambia una pieza del mecanismo (§3).
- **No hay planos de fabricación**, a propósito: la fase 0 no los produce
  (Fran: «planos sólo si hay partes aprobadas, si no, sigamos las fases»). Lo
  aprobado es la arquitectura. Las medidas no, porque salen del centro de masa.

## 2. ¿Es éste el problema correcto?

La meta es una foto de una nebulosa con el 200/1200 (PDP §1). Las otras
salidas: una montura ecuatorial comprada (una HEQ5 usada cuesta varias veces
la plataforma, y el tubo de 19 kg la lleva al límite); fotos cortísimas sin
seguimiento (a 1200 mm el cielo corre 15″ por segundo: no hay foto). Para un
dobson, la plataforma es la respuesta canónica, barata y reversible.
**Es el problema correcto.** [criterio]

Lo que sí estaba mal planteado es **«lo mejor hecha posible» sin un número**.
La precisión la fija el **tiempo de cada foto**, que todavía no se eligió
(pendiente desde el 5/10). A 0,67″ por píxel y aceptando ≈ 2″ de corrimiento
por foto (lo que ya borronea el aire de una noche común):

| Foto de | Error de velocidad que se tolera | Consecuencia |
|---|---|---|
| 30 s | ≈ 0,4 % | la variación propia del VNS (±0,5 %) **hay que corregirla en el programa**, con una tabla |
| 60 s | ≈ 0,2 % | además, el rodillo motriz y las poleas tienen que ser buenos (§4) |

[cálculo; el 2″ es un criterio a confirmar en la fase 1]. Sin ese número,
«mejor» no tiene contra qué medirse: es la **primera pregunta de la fase 1**.

## 3. Lo que estaba mal, y ya se corrigió

| # | Dónde | Qué decía | Qué es | Grado |
|---|---|---|---|---|
| E1 | `12` §2 y el panel del modelo | «la chapa se corre ±13,7 mm sobre el rodillo → rodillo de ≥ 40 mm» | el contacto camina **para un solo lado**: 0 en el centro de la carrera y hasta 12,6 mm en las dos puntas (7,6 mm dentro de los ±45 min). Centrado, alcanza un rodillo de **25 mm**; se usan 28-30 | `confirmado` por cálculo: `geometria-vns.js` ahora da el recorrido con signo, y `probar-geometria.js` tiene el control con sabotaje |
| E2 | `12` §6 | «en el vuelco se espera A ≈ B ≈ 34°» | con la montura a ≈ 44 cm (lo que sale de los 63 cm compuestos), **A ≈ 24°** sobre los cantos de 43 (W = 40) y ≈ 26° sobre los de 40; de 20 a 31° en todo el rango 58-69 | cálculo |
| E3 | modelo v8 | la polea de 80 iba en el bulón de un rodillo que gira **suelto** sobre sus rulemanes | así no transmite nada. El rodillo motriz va **fijo a un eje que gira** en dos rulemanes, y la polea en ese eje | criterio de diseño; corregido en v9 |
| E4 | `07`, `11` paso 6, el modelo | aluminio, rodillo impreso de PETG, «rodillos de acero sobre aluminio no» | contradecían a `12`. Alineados en esta sesión | — |

**Lo que parecía un problema y no lo es** [cálculo]: que el contacto camine
por el rodillo **no es que patine**. La chapa va girada respecto del rodillo y
el punto de apoyo se corre como el cruce de las hojas de una tijera, pero el
acero de la chapa avanza justo en la dirección en que gira el rodillo: no hay
roce de costado ni pérdida de tracción. Y el radio del rodillo no deforma la
pista: corre la mesa ≈ 0,4 mm, constante, que lo absorbe la alineación polar.

## 4. El mecanismo, con lo que hay

**El principio:** hay **dos piezas de precisión** y nada más. Todo lo demás es
herrería común.

1. **El canto de las chapas** (la pista). Un escalón de 0,01 mm en unos
   milímetros mueve la estrella ≈ 5″ [cálculo]: se cortan a **láser** y el
   canto se lija con un taco largo, **nunca con lima a mano**.
2. **El rodillo motriz.** Su redondez es el error que se repite cada media
   hora.

| Pieza | Qué es | De dónde | Por qué así |
|---|---|---|---|
| Rodillo motriz (oeste) | acero torneado Ø32 × 30, fijo con prisionero a un eje de 8 mm | torno (el amigo, o una tornería) | con 0,01 mm de excentricidad mueve la estrella 2,9″ en media hora: 0,6″ por minuto [cálculo] |
| Eje motriz | varilla lisa de **8 mm de impresora**, en dos **608 de roller** puestos en dos ángulos | **rescatado** | medir con calibre que sea 8,00: el 608 tiene agujero de 8 |
| Rodillo loco (este) | **cuatro 608 de roller** uno al lado del otro (28 mm) sobre otra varilla de impresora | **rescatado** | el aro de afuera de un rulemán es más redondo que cualquier cosa torneada en casa; presión de contacto ≈ 324 MPa sobre la chapa, debajo de los ≈ 390 en que el acero dulce empieza a marcarse [cálculo, Hertz] |
| Reducción | correa **GT2** cerrada de 6 mm, poleas de 20 y 80 (4:1) | **se compra** (barato) | paso conocido, sin juego. La excentricidad de la polea de 20 es el término más grande: ≈ 3,6″ cada 8 min (2,8″ por minuto) [cálculo]; si la fase 1 pide más, se pasa a 16:80 |
| Engranajes de impresora y casetera, correas de goma | — | **no van en la transmisión** | módulo y paso desconocidos, plástico con juego, y la goma se estira: todo eso cae justo donde se mide la estrella. Regla del PDP §2: se recicla salvo donde ponga en riesgo la meta, y esto es donde |
| Motor | NEMA 17 de ≈ 4 kg·cm + TMC2209 + **ESP32** | se compra | cada micropaso (1/16) corre la mesa ≈ 2″; el error de los micropasos (≈ ±1″ cada 10 s) se confunde con el aire |
| Finales de carrera | microswitches con palanca | **rescatados** de impresora, si hay | — |

**Tracción por fricción, confirmada** [cálculo, `probable`]: acero sobre
acero con ≈ 17 kg encima da ≈ 25 N de agarre, y con el centro de masa bien
puesto el rodillo empuja 2 a 4 N. Y tiene una virtud: si la mesa se traba o
llega al talón, **el rodillo patina antes de que se rompa algo**.

## 5. La estructura con lo que hay

**La regla:** tubo 20 × 20 donde la carga es corta; donde hay una luz larga o
un voladizo, **tubo arriba y planchuela de canto soldada abajo** (la planchuela
da altura, el tubo da rigidez a la torsión y una cara para abulonar). Un T de
50 sirve igual, si hay.

| Pieza | Sección | Por qué [cálculo, con pared de 1,6 mm a confirmar] |
|---|---|---|
| Lados de la base | tubo 20 × 20 | casi no cargan: los rodillos van sobre el lado sur |
| **Viga sur de la base** (lleva los dos rodillos) | tubo 20 × 20 + planchuela 30 de canto abajo (50 mm de alto) | sola, un 20 × 20 de 1,1 m se hunde ≈ 5 mm y vibra a ≈ 7 Hz; así ≈ 0,6 mm |
| Mesa: travesaño sur, largueros, travesaño norte | tubo 20 × 20 | luces de ≈ 55 cm: ≈ 0,5 mm bajo el dobson |
| **Brazo en A** (≈ 15 kg en voladizo) | tubo 20 × 20 + planchuela 40 de canto abajo | solo se dobla ≈ 1,6 mm; así ≈ 0,1 mm |
| Soportes de rodillos y motor | ángulo, sobre una planchuela de base por unidad | se abulonan a la viga sur en ranura: se corren para cambiar la separación |
| Poste del pivote | tubo corto, tapa de planchuela abulonada, tres riendas de ángulo | la tapa abulonada deja cambiar el poste |

**La mesa se simplificó**: de marco con lados a **H + A** (seis tubos). Las
chapas cuelgan del travesaño sur justo donde llegan los largueros, y los lados
del marco no llevaban nada. Pesa ≈ 8 kg con las chapas [estimación].

**Bulones** (lo que no se suelda): chapas a la mesa, 3 × M8 × 25 clase 8.8 por
chapa en orejas soldadas, con agujero **ovalado** vertical (±3 mm: se emparejan
las alturas de las dos); viga sur a los lados de la base, 2 × M8 por punta
(desarmada entra en el baúl); unidades de rodillo a la viga, 2 × M8 en ranura;
patas, M10 × 60 en tuerca soldada con contratuerca; dobson, 4 × M8 fresados con
buje y mariposa. Todo con arandela ancha y tuerca autofrenante; sobre tubo, con
oreja o buje para no aplastar la pared.

## 6. Las chapas (los segmentos)

- Acero SAE 1010 de **1/4" (6,35 mm)**, a **láser** desde el DXF. Ni plasma
  (deja el canto biselado y con rebaba) ni caladora.
- **La aceptación cambia**: no es «el canto copia la plantilla ±0,5 mm» (FAB-5
  viejo) sino **que no tenga escalones**: no se siente nada con la uña, y la
  plantilla calza ±0,3 mm. Un error de forma suave y largo se calibra; un
  escalón corto no.
- Tres M8 por chapa en agujero ovalado; los talones salen del mismo corte.
- Son, con la mesa, lo único atado al centro de masa de **este** telescopio.

## 7. Un 12" el día de mañana

[`hipótesis`: un dobson de 12" de tubo cerrado pesa 40-50 kg, con el centro
de masa parecido o más bajo que el del 200/1200.] **No se diseña hoy para un
telescopio que no existe** (regla 6 del contrato: la meta es la foto). Se dejan
**tres puertas abiertas que no cuestan nada**:

1. Las **unidades de rodillo** se abulonan en ranura a lo largo de la viga sur:
   la separación se cambia sin soldar.
2. El **poste** tiene la tapa abulonada: se cambia por uno más alto o más bajo.
3. El **núcleo aguanta 60 kg** girando: con 25 kg por rodillo la chapa de 1/4"
   llega a ≈ 309 MPa con el torneado y ≈ 372 con los 608; para un 12" se
   pasaría a chapa de 5/16" [cálculo].

Lo que se rehace para otro telescopio: **las dos chapas y la mesa** (≈ 6 m de
tubo y dos cortes láser). Base, rodillos, motor y electrónica se reusan.

## 8. La mesa apoya, no está atada

Un empujón de costado en la boca del tubo levanta la mesa de un rodillo. Con
los rodillos a 38 cm alcanzaban **5,3 kg**; el dobson solo, en el piso, aguanta
≈ 6. **La plataforma no tiene que ser más fácil de volcar que el dobson
solo**: los rodillos pasan a **50 cm** → **6,9 kg** [cálculo; control con
sabotaje en `probar-geometria.js`]. El precio: chapas de 350 mm en vez de 341 y
la mesa 3 cm más alta.

## 9. Cómo venimos trabajando (la crítica al proceso)

| Qué pasó | Por qué es un problema | Qué cambia |
|---|---|---|
| Diseño antes que datos: 8 sesiones, 0 mediciones del centro de masa | cada versión del modelo se apoya en un 63 cm que puede ser 58 o 69 | **la próxima sesión no diseña**: arranca con lo que traigan del vuelco |
| El inventario llegó por enumeración: «tengo tubo 20 × 20, T y ángulo» apareció hoy, después de diseñar con planchuela | «una enumeración no es un inventario» (lección del perfil) | paso nuevo: inventario de hierros con calibre y foto (sección, **pared**, largo) |
| Documentos que se contradecían (`07`, `11`, `12`, modelo) | Kevin lee el Doc y arma otra cosa | las decisiones viven en el PDP §6; `07`, `11` y el modelo se alinearon hoy |
| El modelo publicado vive en otra cuenta | desde esta cuenta no se puede actualizar | la fuente es `06-modelo-3d.html` del repo; el link es una copia |
| Bulones y detalles en fase 0 | es diseño de detalle (fase C) | se aceptan como **concepto visual**; ningún número del modelo es para cortar |

## 10. Preguntas para Fran (de valor, no técnicas)

1. **¿Cuánto tiempo querés por foto: 30 s o 60 s?** Fija toda la precisión (§2).
2. **¿El amigo metalúrgico tiene torno, o suelda y corta?** Decide de dónde
   sale el rodillo motriz, que es una de las dos piezas de precisión.
