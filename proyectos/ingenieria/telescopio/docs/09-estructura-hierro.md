# La plataforma en planchuela de hierro (2026-10-05)

Pedido de Fran: la plataforma de **hierro**, no de madera, para que no haya
puntos débiles al torque (el brazo de la mesa al pivote). Kevin propuso la
base **triangular** o con ángulos de refuerzo. El material es el que hay:
**planchuelas largas de 30, 40, 50 y 60 mm de ancho, de menos de 1 cm de
espesor** (el espesor exacto falta: los números de abajo usan 3,2 mm, el peor
caso). Grado de todo esto: concepto (fase 0). Las medidas para cortar salen en
la fase 3, después del centro de masa por dos métodos.

## Qué va de qué

| Pieza | Planchuela | Cómo | Por qué así |
|---|---|---|---|
| Base | **50, de canto** | triángulo de pata a pata (dos al sur, una al norte bajo el pivote) | el peso baja derecho a las patas y un triángulo no se deforma (Kevin). De canto, porque acostada una planchuela se dobla como una regla |
| Travesaño bajo los rodillos | 50, de canto | une los dos lados del triángulo | ahí apoyan los soportes de los rodillos |
| Cartelas | recortes de 60 | triángulos de ≈ 16 cm en las tres esquinas | rigidez en las uniones, que es donde un marco cede |
| Poste del pivote | caño 40 × 40 o planchuelas soldadas en cajón | **10 cm**, con tres riendas de 30 | ver abajo |
| Mesa | 40, de canto | marco + dos largueros donde apoya el dobson, con ranuras | los largueros reemplazan la tabla; el dobson se corre sobre las ranuras para centrar el CdM |
| Brazo al pivote | **50, de canto** | dos planchuelas en A desde las esquinas norte de la mesa hasta la cazoleta | era el punto débil |
| Separadores de las chapas de aluminio | recortes de 30 | atornillados al marco sur de la mesa | |

Uniones: **decidido el 2026-10-05** (Fran: «se sueldan, o abulonan si vos lo
recomendás»). Se **suelda** lo que no se desarma: marco de la mesa, brazo en A,
cartelas, triángulo de la base, poste. Se **abulona** (M8, arandela, tuerca
autofrenante) lo que se desarma o se ajusta: el travesaño del sur de la base
(para que entre en el baúl), los soportes de los rodillos (con ranuras, para
alinear en el patio) y todo lo de aluminio. La planchuela de menos de 1 cm se
alabea con el calor: punteo, prensas, tramos cortos alternando lados, y se
mide después (diagonales de la mesa iguales ±2 mm). Todo con antióxido y
pintura: va a estar afuera, de noche, con rocío.

## Decisiones del 2026-10-05 (observaciones de Kevin)

**Base: triángulo ancho de 1,2 m, no cuadrada.** `node docs/estabilidad-base.js`
(40 kg + mesa de 8 kg, CdM de todo a 74 cm del piso, mesa en el medio de la
carrera): triángulo de 0,80 m → vuelco 17,8° de costado y 24,4° al sur; de
1,00 m → 21,6° / 24,4°; **de 1,20 m → 25,0° / 24,4°**; de 1,40 m → 27,8° / 24,4°.
Pasado 1,2 m manda el sur, que no depende del ancho; una cuadrada tiene el
mismo borde sur (24,4°), cuatro patas que renguean y casi 1 m más de
planchuela. Empujón de costado que vuelca a 1,3 m de altura: ≈ 9 kg con 0,80 m
contra ≈ 12 kg con 1,20 m. Lastre de 10 kg bajo: el vuelco al sur sube de 24,4° a
28,3°. El modelo (v8) trae el slider «Ancho de la base» y el vuelco en el
panel, con control y sabotaje en `probar-geometria.js` (9 verdes, 7 sabotajes en
rojo). Grado: `probable` (cálculo; no suma la inclinación de la mesa, que da
1-2° menos).

**Fijación del dobson (Kevin):** ranuras N-S de ≈ 9 mm en los dos largueros,
cuatro bulones M8 de cabeza fresada al ras del pino (el hueco entre bases es de
≈ 1,5 cm, estimado de foto), buje de caño en el agujero, arandela ancha y
mariposa abajo. Las ranuras sirven también para centrar el CdM sin cortar madera.

**Topes del motor (Kevin):** ya estaban, son las tres capas de la guía (programa
±45, fin de carrera ±48, talón ±51 min). Hallazgo propio: las capas 1 y 2 corren
en el **mismo Arduino**: causa común. Fase 3: switch **normalmente cerrado** en
serie con la habilitación del driver (corta por hardware, y un cable roto
también corta). Falta decidir cómo se sale del tope (reversa con el switch
puenteado por software, o botón).

**Pantalla con el tiempo y Bluetooth (Kevin, «extra de goloso»):** fase 3 la
decide, fase 4 la prueba, después de CAL-5. ESP32 en lugar del Nano, pantalla
roja o atenuada (la luz blanca arruina la visión nocturna), página web servida
por la placa. No toca la mecánica.

**Motor** (sección Motor): NEMA 17 de ≈ 4 kg·cm. Cuenta: `T_eje × 0,016 m
(radio del rodillo) ÷ 0,79 m (rodillo al eje) ÷ 4 (reducción)`. Pide 0,16 kg·cm por el
rozamiento del pivote (3 N·m, peor caso) y
0,62 kg·cm por una ráfaga de 40 km/h (≈ 25 N sobre el tubo ≈ 12 N·m en el eje; estimado).
Opciones vistas el 5/10: ELabshop 17HS2408S 1,6 kg·cm $18.200 (descartado);
Usongshine tipo 17HS4401 ≈ 4 kg·cm $24.640 ML FULL (**elegido**; confirmar el
modelo en la ficha); ACT Motor 17HS4417P1 ≈ 4 kg·cm $22.000 Marketplace (sin
garantía); La Costa 3D 4,4 kg·cm $30.200. El de
1,6 kg·cm (17HS2408S, $18.200) deja 2,6× de margen; el de ≈ 4 kg·cm (Usongshine
tipo 17HS4401, $24.640) deja 6,5×. Detalle y opciones: `09-estructura-hierro.md` (sección Motor).

## El brazo, en números

Carga en el pivote ≈ 14,5 kg; brazo de ≈ 41 cm → ≈ 60 N·m en la raíz.

| | Flecha en la punta | Tensión |
|---|---|---|
| Lengua de fenólico 18 × 120 mm (lo de antes) | **≈ 8 mm** | — |
| Dos planchuelas de 50 × 3,2 de canto | **≈ 0,3 mm** | ≈ 22 MPa (el hierro aguanta ≈ 250) |

Con más espesor, mejor todavía. El brazo deja de ser un problema.

## La mesa gira con el telescopio: el eje baja 11 cm

Una mesa de hierro pesa ≈ 8 kg (estimado: ≈ 6 m de planchuela de 40-50 ×
4,8 mm, más las chapas de aluminio), y **gira junto con el telescopio**. El
eje tiene que pasar por el centro de masa de **todo lo que gira**, no sólo del
dobson. Con 40 kg de telescopio a 65 cm sobre la mesa y 8 kg de mesa a −2 cm,
ese centro queda a **≈ 54 cm** sobre la mesa.

Si se ignora: el centro de masa queda 9 cm fuera del eje, el motor carga
≈ 7 N·m de más, y ese torque **cambia de signo en el medio de la carrera**
— el juego de la correa y los engranajes se cruza justo ahí, y en la foto se
ve como un salto. Calculado en `docs/geometria-vns.js` (`mTab`, `Hbal`), con
control y sabotaje en `probar-geometria.js`.

Lo bueno: el eje más bajo **acorta la base** (de 1,43 a 1,30 m sin poste).

## La altura del pivote

Barrido con la mesa de hierro (eje a 54 cm, 48 kg girando):

| Poste | Base | Vuelco de costado | Vuelco al sur | Momento en el brazo | Carga en el pivote |
|---|---|---|---|---|---|
| 0 | 1,30 m | 18,8° | 24,4° | 72 N·m | 12,6 kg |
| 5 cm | 1,23 m | 18,3° | 24,4° | 67 N·m | 13,5 kg |
| **10 cm** | **1,16 m** | **17,8°** | 24,4° | 62 N·m | 14,5 kg |
| 15 cm | 1,09 m | 17,1° | 24,4° | 55 N·m | 15,6 kg |
| 20 cm | 1,01 m | 16,3° | 24,4° | 48 N·m | 16,9 kg |
| 30 cm | 0,87 m | 14,4° | 24,4° | 29 N·m | 20,3 kg |

«Vuelco» es cuánto hay que inclinar el conjunto para que se caiga: 17,8° es
un empujón de costado de ≈ 15 kg a la altura del ocular. **Elegido: 10 cm.**
Es un taco, no una columna: no necesita más que tres riendas cortas, la base
baja a 1,16 m (entra en el baúl de un auto) y la estabilidad
casi no cambia. Arriba de 15 cm el poste empieza a ser una columna que se
dobla, la carga del pivote crece y lo que se gana en largo es poco.

## Lo que queda abierto

- El **espesor** de las planchuelas (paso 4 del paso a paso: calibre, y pesar 1 m
  de cada ancho; se corrige `mTab` en el modelo y el eje se ajusta con
  suplementos).
- Soldadas o abulonadas: **resuelto** (arriba).
- El centro de masa del telescopio por un segundo método (P3/P4): sigue
  mandando sobre todo lo de arriba.
