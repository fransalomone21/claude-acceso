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

Uniones: soldadura, o bulones M8 con cartela. Todo con antióxido y pintura:
va a estar afuera, de noche, con rocío.

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

- El **espesor** de las planchuelas (se pesa la mesa terminada y se corrige
  `mTab` en el modelo: el eje se ajusta con suplementos).
- Soldadas o abulonadas: depende de qué herramienta tengan.
- El centro de masa del telescopio por un segundo método (P3/P4): sigue
  mandando sobre todo lo de arriba.
