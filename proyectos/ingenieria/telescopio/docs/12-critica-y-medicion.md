# Crítica de la arquitectura preliminar y un método de medición más fácil

> **Corregido el 2026-10-07 por `13-revision-externa.md`, que manda.** Dos
> errores: el «±13,7 mm» de §2 es un recorrido **para un solo lado** (0 a 12,6
> mm; centrado alcanza un rodillo de 25 mm, no hace falta uno de 40), y el
> ángulo esperado de §6 es **≈ 24°**, no 34°. Y §4 recomendaba tubo de 40 × 20
> o 30 × 30: lo que hay es 20 × 20, y se resuelve con tubo + planchuela de canto
> donde hay luz larga.

**Escrito el 2026-10-07**, a pedido de Fran: «evaluá el diseño como un
espectador que sabe mucho de ingeniería y va a criticarlo», más las
propuestas de Kevin (rodillo de poliuretano, varilla roscada con tuerca).
Grado de cada cosa entre corchetes. Las cuentas se hicieron con Hertz de
contacto lineal y error periódico por excentricidad; las entradas que son
estimación propia están marcadas `hipótesis`.

## 1. Lo primero que diría un revisor: el pedido cambió de tamaño

Fran (2026-10-06): *«que esta plataforma sea definitiva para este y futuros
telescopios dobson»*. Eso es un **requisito nuevo**, no un detalle:

- La forma de las chapas depende de la **altura del eje** (H). Un dobson con
  el centro de masa más bajo se sube con suplementos; uno con el centro de
  masa **más alto no entra**. Una plataforma «para varios» se diseña con el
  eje a la altura del **más alto** de la familia, y los demás se suplementan.
- Más H es base más larga (L ≈ H / tan 34,5° ≈ 1,46 H) y suplementos altos
  para el 200/1200 (un suplemento de 15 cm ya es una torre que flexa).
- Y la capacidad de carga (hoy 40 kg) también se fija por el más pesado.

**Pregunta para Fran, de valor (no técnica):** ¿qué dobson futuro, como
máximo? (8", 10", 12"; con su peso aproximado). Sin eso, «universal» no se
puede verificar. Si la respuesta es «no sé», se diseña para el 200/1200 con
el changüí de ±5 cm que ya tiene, y se dice así.

## 2. El contacto rodillo–chapa es el punto débil [cálculo, `probable`]

Carga por rodillo ≈ 19 kg (190 N), sobre el canto de la chapa.

| Combinación | Presión de contacto | Contra qué | Veredicto |
|---|---|---|---|
| rodillo PETG 32 mm sobre aluminio 5 mm (el diseño de hoy) | **42 MPa** | fluencia del PETG ≈ 50 MPa | al límite: con carga sostenida **fluye (creep)** y aplana el rodillo |
| rulemán de acero 22 mm sobre aluminio 1050 de 5 mm | **254 MPa** | el aluminio 1050 empieza a marcarse ≈ 175 MPa | **marca el canto** (el modelo ya lo advertía) |
| rodillo de acero torneado 25 mm sobre **chapa de acero 6–8 mm** | **264–305 MPa** | acero SAE 1010/1020: empieza a marcarse ≈ 390 MPa | **anda**, y con margen |
| rodillo de poliuretano 75–85A (Kevin) | baja, porque se deforma mucho | — | soporta, pero **se aplasta bajo carga** (cambia el radio efectivo) y deja «panza» si queda cargado guardado; **no sirve como rodillo motriz** |

**Recomendación:** chapas de **acero de 6–8 mm** (las corta el metalúrgico
desde la plantilla, con plasma o láser, o se calan) y rodillos de **acero
torneado** con dos 608ZZ adentro. Sale **más barato** que el aluminio
($66 mil la chapa de 500 × 500) y más duro. Cada chapa pesa ≈ 1,5–2 kg: entra
en `mTab` (gira con el telescopio).

**Hallazgo de paso [`probable`]:** la chapa se corre de costado sobre el
rodillo **±13,7 mm** a lo largo de la carrera (`latMax` en `geometria-vns.js`).
Un rodillo de 26 mm con una chapa de 5 mm sólo cubre ±10,5 mm: en las puntas
de la carrera el canto **se sale del rodillo**. El rodillo tiene que tener
**≥ 40 mm** de ancho. Falta confirmar cómo está referenciado `latMax` (centro
del rodillo o borde de la chapa) antes de fijar la medida.

## 3. La transmisión: la varilla roscada es MENOS precisa, no más [cálculo, `probable`]

Lo que arruina una foto de 60 s no es la velocidad media (eso se calibra en
el programa) sino el **error periódico**: un vaivén que se repite cada vuelta
de la pieza que gira.

| Transmisión | Período del vaivén | Amplitud | Lo que mueve la estrella (pico) |
|---|---|---|---|
| rodillo PETG impreso, 0,05 mm de excentricidad | 24 min | 10,7″ | 2,8″ por minuto |
| **rodillo de acero torneado, 0,01 mm** | 19 min | 2,1″ | **0,7″ por minuto** |
| varilla TR8 × 2 con 0,01 mm de cabeceo por vuelta, brazo de 40 cm | **1,2 min** | 5,2″ | **28″ por minuto** |

Las tolerancias de la columna 1 son `hipótesis` (valores típicos, no
medidos). El orden de magnitud manda: con varilla, el vaivén tiene el
**mismo período que la foto** y cada sub sale con un guión; con el rodillo
de acero el vaivén es tan lento que en 60 s no se ve. Una varilla roscada M8
común es peor que la TR8 (riesgo R5 del PDP).

**Recomendación:** **tracción por fricción con rodillo de acero torneado**
sobre la chapa de acero, motor NEMA 17 con correa GT2 20:80 (como hoy). La
idea de pegar una correa dentada al canto (la captura que mandó Kevin)
resuelve un patinamiento que con acero sobre acero y 19 kg encima no aparece:
fricción disponible ≈ 28 N (μ ≈ 0,15) contra ≈ 9 N que pide un centro de
masa corrido 1 cm. **Margen ≈ 3×** [cálculo, `probable`].

**Minimizar el esfuerzo del motor** no pasa por un motor más grande: pasa por
**poner el centro de masa sobre el eje** (suplementos + ranuras). Con eso la
cupla es casi cero y el motor sólo vence rozamiento y viento.

## 4. La estructura: planchuela de canto es la sección equivocada [criterio de ingeniería]

Una planchuela de canto es rígida para arriba y **floja a la torsión y de
costado** (sección abierta y fina). Un marco de planchuelas tuerce cuando el
centro de masa no está centrado, y vibra cuando sopla viento o se toca el
tubo. El **tubo rectangular o cuadrado** (sección cerrada) tiene, para el
mismo peso, una rigidez a torsión **decenas de veces mayor**. El perfil T
queda en el medio (también abierto).

| Pieza | Hoy | Recomendado | Por qué |
|---|---|---|---|
| mesa (marco y largueros) | planchuela 40 de canto | **tubo 40 × 20 o 30 × 30** | torsión y vibración |
| brazo al pivote | dos planchuelas 50 en A | **tubo**, en A | lleva ≈ 15 kg en voladizo |
| base al piso | triángulo de planchuela 50 | tubo o ángulo | el triángulo ya da la rigidez en su plano |
| soportes de rodillos | impresos | **ángulo de hierro con agujeros chinos** | el plástico fluye con 19 kg encima, igual que el rodillo |
| cartelas | planchuela 60 | sin cambio | trabajan en su plano |

**Hierros oxidados de la terraza:** sirven si la pérdida de pared es chica.
Se cepillan, se mide la pared con calibre en tres puntos, y se descarta el
que perdió más del 20 % o tiene picaduras pasantes. Antióxido antes de armar.

**Bulones (lo que no se suelda):** M8 clase 8.8 con arandela ancha y tuerca
autofrenante en mesa, soportes y chapas (tres bulones por chapa, no dos);
M10 en las patas; mariposas M8 para el dobson (FAB-8). Sobre tubo, con buje o
tuerca remachable, para no aplastar la pared al apretar.

## 5. Decisiones que Kevin pidió cerrar

| Decisión | Valor | Grado |
|---|---|---|
| **Carrera** | **±45 min (90 min por recarga)**. Alcanza para una sesión de un objeto con subs de 30–60 s; más largo agranda las chapas y la variación de velocidad | recomendado; Fran confirma |
| **Altura del poste** | **10 cm** como valor de trabajo. **No puede ser definitivo** hasta tener H medido y la respuesta de la §1: el poste y las chapas salen de la misma cuenta | `hipótesis` hasta el paso 2 nuevo |
| Rodillo de poliuretano | **no** como motriz; no hace falta como soporte si las chapas son de acero | `probable` |
| Varilla roscada | **no** como transmisión (§3) | `probable` |
| **Placa** | **ESP32 desde el arranque**, no Nano: cuesta lo mismo y es lo que va a pedir la pantalla y el Bluetooth de la fase 3; evita rehacer el programa | recomendado |

## 6. Medir el centro de masa: un método más fácil y más preciso

**Lo que se aprovecha:** el tubo **ya está balanceado** en su eje de altura.
Eso quiere decir que su centro de masa está **sobre el eje de altura**, y la
altura del eje se mide con cinta en un minuto. Entonces el centro de masa de
todo es:

    H = (19,2 × h_eje + 19,7 × h_montura) / 38,9

y lo único difícil de medir es **h_montura**: la montura con la caja, sin el
tubo.

### Método A — el vuelco (reemplaza a la tabla con los caños)

1. Trabar la caja en su posición de observar (cinta o una cuña): si no, gira
   sobre el eje de altura al inclinar. Trabar también la base giratoria.
2. Clavar o apoyar un listón en el piso como **tope**, para que el canto de la
   base fija no resbale.
3. Inclinar la montura despacio sobre ese canto hasta el **punto de
   equilibrio**: ni vuelve ni se cae. Uno la sostiene con una soga floja del
   otro lado; el otro lee.
4. Leer el ángulo con el **celular** (app de nivel o inclinómetro) apoyado en
   la cara de abajo de la base fija. Tres veces.
5. Repetir sobre el **canto opuesto**.

Con W la distancia entre los dos cantos (43 o 40 cm, según el lado):

    h_montura = W / (tan A + tan B)

Con los dos cantos se cancela si el centro de masa no está justo en el medio,
y además se obtiene ese corrimiento. Se espera **A ≈ B ≈ 34°**. Cada medio
grado de error mueve h_montura ≈ **0,6 cm**.

**Control positivo del celular, antes:** sobre el piso da lo mismo que
girado 180°, y contra el marco de una puerta da 90°. Si no, no se le cree.

### Método B — el control

- **h_eje**: cinta del piso del dobson al centro del rulemán del eje de
  altura. Reemplaza al «todo junto plano» de 40 kg: el mismo dato, sin
  levantar 40 kg.
- **El segundo método** (regla 2 del contrato) para h_montura es la tabla
  con los caños del paso 2 viejo (`11-paso-a-paso.md`). **Sólo hace falta** si
  A y la composición por partes (63 cm, de 58 a 69) **no coinciden**.

**Ahorra:** una tarde, la tabla de 80 cm, los caños, los bloques y levantar
40 kg. **Precisión:** ±0,6 cm en h_montura y ±0,1 cm en h_eje, lo que da
**≈ ±0,4 cm en H**, mejor que lo que pide la chapa (1 cm).

**Riesgo:** en el punto de equilibrio la montura es inestable por
definición. Se hace con soga, con un almohadón del lado de la caída, y
nunca con el tubo puesto.

## 7. Lo que queda para la próxima sesión

- Los **dibujos en perspectiva** del método A y B, para Fran y Kevin.
- El **modelo v9**: chapas y rodillos de acero, tubos, soportes de ángulo,
  bulones, rodillo de ≥ 40 mm.
- Los **planos por capa**: base, mesa, brazo y pivote, chapas (plantilla
  1:1) y rodillos y soportes. **Ninguno es para cortar** hasta tener H medido.
- Confirmar la referencia de `latMax` (§2).
- Reescribir `11-paso-a-paso.md` con el método A y B.
