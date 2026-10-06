# Paso a paso — qué hacer y en qué orden

**Para Fran y Kevin.** Versión 1, 5 de octubre de 2026. La fuente vive en el
repo (`proyectos/ingenieria/telescopio/docs/11-paso-a-paso.md`); esta copia
está en la carpeta compartida del Drive.

> **Cómo se lee esto.** Este documento es **sólo pasos**: qué se hace, en qué
> orden, quién lo hace y cómo se sabe que salió bien. El **porqué** del diseño
> (qué es una plataforma VNS, por qué de hierro, por qué ese ancho de base) está
> en el otro documento: **«1 - El proyecto - concepto y diseno»**. Acá no se
> discute el diseño: se ejecuta. Si algo de acá no se entiende, la explicación
> está allá.

**El modelo 3D** (se mueve y se rehace solo si cambiás un número):
https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM

---

## Dónde estamos, en cinco líneas

- **Diseño elegido:** plataforma VNS (tres apoyos: un pivote y dos rodillos),
  de planchuela de hierro, con la base al piso en triángulo **ancho** (1,2 m).
- **Medido:** el conjunto pesa **40 kg** (por dos caminos que cierran) y su
  centro de masa está **a unos 63 cm** del piso del dobson, pero con una duda
  de ±5 cm (entre 58 y 69).
- **Lo único que falta para cerrar «medir»:** cerrar esa duda del centro de
  masa. De ese número depende la forma de las chapas de aluminio, que es lo
  único que no se arregla después.
- **Aparcado a pedido de Fran:** la cámara y el foco (ver el recuadro más
  abajo).
- **Hoy no se corta, no se suelda y no se compra nada grande.** Eso empieza
  recién cuando terminen los pasos 1 al 9.

## Las tres reglas del juego

1. **Medir antes de cortar.** La forma de las chapas depende del centro de
   masa. Cortar antes es pagar el aluminio dos veces.
2. **Un número sin su método es un cuento.** Cada medida se anota con *con qué*
   se midió (balanza tal, cinta, calibre) y de cuánto en cuánto lee.
3. **Un paso no está hecho porque «se hizo»: está hecho cuando pasó su
   prueba.** Cada paso trae su «cómo sabés que salió bien». Si no pasa, no se
   sigue: se busca el error.

---

# PARTE A — Lo que sigue ahora (se hace en este orden)

| # | Qué | Quién | Cuánto lleva | Hay que haber hecho antes |
|---|---|---|---|---|
| 1 | Anotar la balanza | Fran | 5 minutos | nada |
| 2 | Montura inclinada: masa y centro de masa | Fran y Kevin | una tarde | 1 |
| 3 | Todo junto, plano: el control | Fran y Kevin | una hora | 1 |
| 4 | Medidas chicas y pesar la planchuela | Fran | media hora | nada |
| 5 | El inventario que falta | Fran | media hora | nada |
| 6 | Rodillo de prueba | Kevin | una tarde | nada |
| 7 | El motor andando sobre la mesa de trabajo | Fran y Kevin | una tarde | comprar el motor y el driver |
| 8 | Cerrar el centro de masa y rehacer el modelo | la sesión | una vez | 2 y 3 |
| 9 | Revisarlo juntos y darle luz verde a la fase 1 | Fran y Kevin | una charla | 8 |

**Qué se puede hacer a la vez:** el 1, el 4, el 5, el 6 y el 7 no dependen de
nadie, arrancan todos juntos. El 2 y el 3 esperan al 1. El 8 espera al 2 y al
3. El 9 espera al 8.

## Paso 1 — Anotar la balanza

**Quién:** Fran. **Lleva:** 5 minutos.

Anotar **marca y modelo**, **hasta cuántos kilos pesa** y **de cuánto en cuánto
lee** (100 g, 50 g...). Sacarle una foto a la etiqueta.

*¿Por qué?* Las pesadas de los 40 kg salieron con una balanza que no sabemos
cuánto marca de más o de menos. Con estos tres datos, cada pesada pasa de
«cuento» a «dato con su margen de error».

**Cómo sabés que salió bien:** los tres datos están anotados y se pueden
pegar en el chat.

## Paso 2 — La montura inclinada (el segundo método del centro de masa)

**Quién:** Fran y Kevin. **Lleva:** una tarde. **Es el paso más importante de
la lista.**

*Qué es esto, en criollo.* Hoy sabemos que el centro de masa de **todo** anda
por los 63 cm, pero esa cifra tiene una duda porque no sabemos dónde están los
2 a 5 kilos de herrajes de la montura (rulemanes, bulones, tacos, gomas). Si
están todos abajo, el centro de masa baja a 58 cm; si están todos arriba, sube
a 69. Esto lo resuelve: se pesa la montura apoyada en dos puntos, primero
plana y después con un lado levantado. Del cambio en lo que marca la balanza,
sale **a qué altura** está el centro de masa. (Es el método P3 del *Protocolo
de medición*.)

**Qué se pesa:** la **montura con la caja puesta y SIN el tubo** (los 19,7 kg
que ya pesaron). Con la caja puesta: así se pesó, y así evitamos pesarla sola.
Apretá los tornillos de la caja para que no se mueva nada al inclinar.

**Qué necesitás:**

- una **tabla rígida de unos 80 cm** (una de las que sobren, o un tirante);
- **dos caños redondos iguales** (PVC o de agua) para apoyar la tabla. Tienen
  que ser redondos: con apoyos planos el rozamiento mete un error que no se
  controla;
- la **balanza de baño** y un **bloque de la misma altura que la balanza**;
- un **bloque de 7 cm de alto** (ladrillos, tacos) para levantar un lado;
- cinta métrica; cinta de embalar o soga para **atar la montura a la tabla**.

**Cómo se hace:**

1. Poné la tabla sobre los dos caños, **separados 40 cm** entre sí. Un caño
   queda arriba de la balanza; el otro, sobre el bloque de igual altura, para
   que la tabla quede horizontal. Medí la separación exacta (**L**).
2. Apoyá la montura en el medio de la tabla y **atala** (que no se pueda
   deslizar ni volcar).
3. Leé la balanza (**R_A**) y después pasá la balanza al otro caño y leé de
   nuevo (**R_B**). La suma tiene que dar los ~19,7 kg: es la masa de la
   montura.
4. **Girá la montura 90° sobre la tabla** (este-oeste en lugar de norte-sur) y
   repetí las dos lecturas. Con eso tenemos dónde cae el centro de masa en
   planta.
5. **Inclinación (la parte que da la altura):** volvé a la posición del punto 3.
   Poné la balanza **arriba del bloque de 7 cm** (el otro caño queda en el piso:
   la tabla queda inclinada unos **10°**) y leé de nuevo (**R_A'**). Esa
   diferencia tiene que dar **entre 3 y 4 kg**. Si da menos de 1 kg, la balanza
   no alcanza a ver el cambio: subí el ángulo, **pero nunca más de 12°**.
6. Anotá todo: R_A, R_B (las dos direcciones), R_A', L, la altura del bloque.

**Seguridad:** uno sostiene la montura y el otro lee. Nada de inclinar con la
montura suelta. Las 80 cm de altura de la montura son un problema si se cae: si
no estás seguro de la atada, no inclines.

**Cómo sabés que salió bien:** (a) R_A + R_B da **19,7 ± 0,5 kg**; (b) leíste
cada valor **dos veces** y no difiere más que lo que lee la balanza; (c) el
cambio al inclinar da de 3 a 4 kg. Con eso, **la sesión calcula la altura** y el
rango de 58 a 69 cm se achica a menos de ±1 cm.

## Paso 3 — Todo junto, plano (el control)

**Quién:** Fran y Kevin. **Lleva:** una hora. **Después del paso 1.**

*Qué es esto, en criollo.* Es la prueba del nueve. El paso 2 nos da el centro
de masa **sumando partes**; este lo mide **todo junto**. Si los dos dan lo
mismo, el número vale. Si no, hay un error escondido en alguno de los dos y
**no se sigue diseñando hasta encontrarlo**: dos métodos que coinciden valen,
uno solo es una esperanza. (Es el método P4 del *Protocolo*.)

**Cómo se hace:** igual que el paso 2, pero con **toda la montura y el tubo
puestos**, el tubo horizontal y trabado, **sin cámara** y sin ocular. Pesada en
dos puntos, en las dos direcciones. **No se inclina**: 40 kg inclinados son
peligrosos para nada. Entre dos personas, siempre.

**Cómo sabés que salió bien:** la masa da **40 ± 0,5 kg**, y el centro de masa
en planta coincide con lo que dio el paso 2 más el tubo **dentro de 1 kg y
1 cm**. Si no coincide, hay un error: se frena y se busca.

## Paso 4 — Medidas chicas, y pesar la planchuela

**Quién:** Fran. **Lleva:** media hora. Se puede hacer cuando quieras.

Cuatro cosas que el diseño de la mesa necesita y que hoy salen de fotos o de
suposiciones:

| # | Qué | Cómo | Para qué |
|---|---|---|---|
| a | **El hueco entre la base fija y la móvil** (con los tacos de PVC y el vinilo puestos) | calibre o regla, en cada taco | el tornillo con el que se fija el dobson a la mesa tiene que entrar en ese hueco |
| b | **Del borde de la pared al centro del rulemán del eje de altura** | cinta | la altura del eje del tubo sobre el piso del dobson (hoy: estimada de una foto en 82,5 cm) |
| c | **El espesor de cada planchuela** (30, 40, 50 y 60 mm) | calibre. Si no hay calibre, anotá «sin calibre» y lo medimos con otra cosa | cuánto aguanta cada pieza, y cuánto pesa la mesa |
| d | **El peso de 1 metro de cada planchuela** (aunque sea con la balanza de cocina) y **cuántos metros** hay de cada una | balanza y cinta | la mesa entera pesa unos 8 kg *estimados*: así pasa a ser un número medido |

**Cómo sabés que salió bien:** los cuatro anotados, cada uno con su
instrumento.

## Paso 5 — El inventario que falta

**Quién:** Fran. **Lleva:** media hora.

Hay una lista de cosas que dijimos «tenemos» sin haberlas leído nunca.
Mirá cada una **de cerca, con luz, y sacale una foto donde se lea el texto**:

1. **Los rulemanes:** ¿cuántos hay y qué número tienen grabado? (debería decir
   `608ZZ`; el de skate mide 22 mm de diámetro exterior).
2. **El Arduino Nano:** ¿es original o clon? ¿el chip USB dice CH340 o FT232?
3. **La placa «HW-130»:** foto de los **dos lados** con el texto legible.
   Probablemente no sea un driver de motores sino una fuente de protoboard.
4. **La fuente de 12 V:** cuántos **amperes** dice la etiqueta.
5. **Tornillería:** ¿hay **tuercas mariposa M8** (cuántas)? ¿bulones M8 y de
   qué largo?
6. **Una escuadra grande y un nivel:** ¿hay?

**Cómo sabés que salió bien:** cada cosa tiene su foto con el texto legible o
la respuesta anotada. Una fila que dice «creo que...» no está hecha.

## Paso 6 — Rodillo de prueba

**Quién:** Kevin. **Lleva:** una tarde. No depende de nada.

*Qué es esto, en criollo.* El rodillo es la pieza que **empuja** la chapa de
aluminio. Es un cilindro de plástico con dos rulemanes adentro. Su diámetro
**no cambia con el centro de masa**, así que se puede probar ya. Lo que
queremos saber es si la impresora del amigo lo hace con la precisión que
necesita un encaje a presión.

**Qué hacer:** modelar e imprimir **un** rodillo: cilindro de **32 mm de
diámetro por 26 mm de ancho**, con un hueco pasante de 8 mm para el eje y, en
cada cara, un alojamiento para un rulemán 608ZZ (**22 mm de diámetro exterior
y 7 mm de profundidad**, más 0,1 o 0,2 mm de holgura de impresora). En PETG,
4 paredes, relleno de 50 % o más. Se prueba con **dos 608ZZ**.

**Cómo sabés que salió bien:** (a) los dos rulemanes **entran a presión con la
morsa** y no quedan flojos; (b) el rodillo gira libre sobre una varilla de 8 mm,
**sin juego y sin puntos duros**; (c) el diámetro exterior mide **32 ± 0,2 mm**
con calibre. Si no, se ajusta la holgura y se reimprime. Anotá el material y la
temperatura.

## Paso 7 — El motor andando sobre la mesa de trabajo

**Quién:** Fran y Kevin. **Lleva:** una tarde, **después de comprar**.

*Qué es esto, en criollo.* Antes de armar nada, probamos la parte eléctrica
afuera, en la mesa del taller. Si el motor no gira como tiene que girar, mejor
enterarse con un cable suelto que con una plataforma terminada.

**Qué comprar** (la plata es de Fran; el motivo está en el otro documento,
sección *Motor*):

- **un motor paso a paso NEMA 17 de ≈ 4 kg·cm** (1,7 A, 40 mm de largo, el
  tipo «17HS4401»): ≈ $25 mil;
- **un driver TMC2209** (silencioso, justo para movimientos lentos).

**Qué se usa de lo que ya hay:** el Arduino Nano, la fuente de 12 V (paso 5 dice
si alcanza) y el protoboard.

**Qué se hace:** armar el circuito mínimo (Nano → TMC2209 → motor) y correr un
programa que dé los pasos al ritmo del cielo. El ritmo es **muy lento**: con la
reducción 4:1 de la plataforma, el motor da **unos 0,46 pasos por segundo**
(7,3 micropasos por segundo). Es decir, un pasito cada dos segundos. Eso es lo
que se va a ver.

**Dos cuidados:** (1) **nunca conectes ni desconectes el motor con la fuente
prendida**: el driver se quema; (2) regulá la corriente del driver **debajo de
la del motor** (para un motor de 1,7 A, empezá en 1 A), y ponele un disipador.

**Cómo sabés que salió bien:** el motor gira **parejo y silencioso** durante
10 minutos seguidos, y el programa cuenta los pasos. A los 10 minutos el motor
dio **275 pasos enteros** (1,4 vueltas): contalo con una marca de fibrón en el
eje.

## Paso 8 — Cerrar el centro de masa y rehacer el modelo

**Quién:** la sesión. **Cuando:** pasos 2 y 3 aceptados.

Con los números de los dos pasos, la sesión (1) compone el centro de masa por
los dos caminos, (2) cambia la altura medida en el modelo 3D y recalcula la
altura del eje, (3) republica el modelo **en el mismo link** y (4) actualiza
los documentos del Drive. Fran y Kevin pegan en el chat las planillas o una foto
de lo anotado.

**Cómo sabés que salió bien:** los dos caminos coinciden dentro de ±1 cm, y el
modelo muestra los números nuevos.

## Paso 9 — Revisarlo juntos

**Quién:** Fran y Kevin. **Una charla, con el modelo abierto.**

Tres preguntas, con el modelo en la pantalla:

1. ¿El dobson **entra** sobre los dos largueros de la mesa?
2. ¿La base de **1,2 m de ancho** se puede **desarmar** y entra en el baúl?
   (se arma con un travesaño abulonado: sí, pero miralo).
3. ¿Hay algo en el modelo que no se parezca a lo que tienen en el patio?

Y una decisión que **sólo Fran puede tomar**, porque es de valor y no técnica:
**¿cuánto tiempo querés poder dejar abierto el obturador en cada foto?** (30
segundos, 1 minuto, 2 minutos). Cuanto más largo, más exacta tiene que ser la
plataforma. Esa respuesta arranca la fase 1.

**Cómo sabés que salió bien:** las tres respuestas están dichas y Fran eligió
el tiempo. Con eso **termina «medir y elegir»** y se abre la fase 1.

---

> ## Aparcado a pedido de Fran: la cámara y el foco
>
> Fran pidió el 5 de octubre dejar la cámara y el enfocador de lado y pensar
> la plataforma, la montura y el telescopio. Está hecho: ningún paso de arriba
> usa la cámara.
>
> **Lo que queda abierto, sin tocar:** la medición **P0**, «¿el telescopio
> llega a foco con la cámara?». Son 10 minutos de día, y es la única que, si
> sale mal, **tira abajo la meta de la foto** (una falla clásica de los
> newtonianos con enfocadores a rosca). Por eso queda como **compuerta**:
> **antes de comprar la chapa de aluminio (unos $66 mil) o de cortar nada,
> se cierra.** Mientras tanto, nada de arriba se pierde.
>
> **Cuando vuelva la cámara:** pesa unos 0,5 kg y, puesta en el portaocular,
> corre el centro de masa del tubo 1 o 2 cm hacia la boca; se corrige corriendo
> el tubo 1 o 2 cm hacia la cola en la caja. La pregunta pendiente para Kevin
> sigue siendo: *cuando miraron Saturno, ¿se veían los anillos?*

---

# PARTE B — Lo que viene después, fase por fase

Cada fase termina con un **resultado que se puede ver**, no con «trabajo
hecho».

| Fase | Qué se hace, en criollo | Quién | Termina cuando |
|---|---|---|---|
| **1 — Requisitos y presupuesto de error** | Con el tiempo de foto que elija Fran, se hace la cuenta de cuántos segundos de arco de error se pueden tolerar y de qué parte sale cada uno (el motor, los rodillos, la alineación, el viento) | la sesión; Fran decide el tiempo | la cuenta cierra y los requisitos pasan el verificador (`verificar-requisito.py`) |
| **2 — Reforma de la montura** | Se prepara el dobson para subir a la mesa: las ranuras de los largueros, la fijación (bujes, bulones, mariposas), y se rebalancea el tubo con lo que haya puesto | Fran y Kevin | el centro de masa, **medido de nuevo con el mismo método**, cae dentro de la tolerancia del eje |
| **3 — Diseño detallado** | Planos 1:1 de las chapas, lista de corte de planchuela, lista de compras con precios cotizados. **Acá se cierra P0.** Acá se decide si entra la pantalla con Bluetooth | la sesión; Kevin los archivos de impresión | plantillas 1:1 y lista de corte listas, y la lista de compras contrastada contra el inventario |
| **4 — Construir y calibrar** | La Parte C, de abajo | Fran y Kevin | la estrella sale redonda en 60 segundos y la mesa corre 60 minutos sin ayuda |
| **5 — La foto** | Una nebulosa | todos | la imagen existe |

---

# PARTE C — Fabricación y calibración (procedimiento formal)

> Esta parte cambia de tono a propósito. Lo de arriba se lee como una charla;
> esto se **ejecuta**, con el documento abierto al lado de la herramienta. Cada
> paso dice qué necesita, qué se hace y **cómo se sabe que salió bien**. Un paso
> no se da por terminado porque «se hizo», sino porque pasó su criterio de
> aceptación. Las tolerancias son provisorias: las definitivas salen de la
> fase 1. **Nada de esta parte se ejecuta antes de que termine la fase 3.**

## C.1 Fabricación

**FAB-0 — Medición del telescopio.**
*Requiere:* balanza anotada (paso 1), cinta, el *Protocolo de medición*.
*Procedimiento:* los pasos 2 y 3 de la Parte A. *Aceptación:* el centro de
masa medido por dos métodos independientes coincide dentro de **±1 cm**; cada
número lleva su instrumento.

**FAB-1 — Plantilla 1:1 de las chapas.**
*Requiere:* FAB-0 aceptado y el modelo recalculado. *Procedimiento:* imprimir la
plantilla a escala 100 % (sin «ajustar a la página»). *Aceptación:* la regla de
control impresa en la plantilla mide lo que dice, **±0,5 mm en 300 mm**. Si
no, se corrige la escala de la impresora y se reimprime.

**FAB-2 — Base, mesa y brazo de planchuela de hierro.**
*Requiere:* planchuelas de 30 a 60 mm, amoladora, soldadora, agujereadora,
escuadra grande, prensas, mesa de trabajo **plana**, antióxido y pintura.
*Procedimiento:* cortar según la lista de corte (fase 3). Presentar las piezas
con prensas **antes** de soldar y verificar escuadra. **Puntear** primero las
esquinas, soldar de a tramos cortos **alternando lados** (para que el calor no
combe la pieza) y dejar enfriar. Se **suelda** lo que no se desarma: el marco
de la mesa, el brazo en A, las cartelas, el triángulo de la base y el poste. Se
**abulona** (M8, con arandela y tuerca autofrenante) lo que se desarma o se
ajusta: el travesaño del sur de la base (para que entre en el baúl), los
soportes de los rodillos (con ranuras, para alinearlos) y todo lo de aluminio.
*Aceptación:* las **diagonales del marco de la mesa son iguales ±2 mm**; el
marco apoya **plano** sobre la mesa de trabajo (no se mece); la base, apoyada
en sus tres patas, no tiene ninguna esquina en el aire.

**FAB-3 — Patas y pivote.**
*Procedimiento:* soldar o roscar las tres tuercas de inserto, roscar los
bulones M10, atornillar la rótula del pivote al poste. *Aceptación:* sobre el
piso del patio la base **no se mueve al apretar cada esquina** (tres apoyos
firmes); el poste de 10 cm queda vertical (nivel).

**FAB-4 — Rodillos.**
*Requiere:* dos rodillos y cuatro soportes impresos, cuatro 608ZZ, bulones M8
(o la varilla de 8 mm de la impresora). *Procedimiento:* calzar los rulemanes a
presión (con prensa o morsa, nunca a martillazos directos). *Aceptación:* cada
rodillo gira libre a mano, sin juego axial perceptible ni puntos duros en una
vuelta completa.

**FAB-5 — Chapas de aluminio.**
*Requiere:* FAB-1 aceptado, chapa de 5 mm, caladora con hoja para metal,
aceite, lima. *Procedimiento:* pegar la plantilla, calar por afuera de la línea,
terminar con lima hasta la línea; redondear el canto de rodadura; pegar goma
en la cara interna de cada talón. *Aceptación:* el canto copia la plantilla
**±0,5 mm** en todo el largo (se controla apoyando otra vez la plantilla
impresa); el canto no tiene escalones que se sientan con la uña.

**FAB-6 — Montaje de las chapas en la mesa.**
*Procedimiento:* atornillar cada chapa con sus tacos, girada el ángulo que
indica el plano (unos 8°), con la plantilla de posición. *Aceptación:* con la
mesa apoyada sobre los rodillos y el pivote, sin telescopio, se empuja a mano
de punta a punta y **rueda sin saltos y frena contra los dos talones**.

**FAB-7 — Electrónica y finales de carrera.**
*Requiere:* Arduino Nano, TMC2209, NEMA 17, fuente 12 V, dos microswitches con
contacto **normalmente cerrado**, la leva M5. *Procedimiento:* cablear según el
esquema (sale con el diseño de detalle); montar los switches en su soporte, al
costado del rodillo este; atornillar la leva en el medio de la chapa.
*Aceptación:* con el motor andando, **cada switch apretado a mano lo detiene**,
y **un cable cortado también lo detiene** (por eso son normalmente cerrados:
si un cable se rompe, la mesa se frena y no sigue como si nada). Las dos
puntas, sin excepción.

**FAB-8 — Fijación del dobson a la mesa.**
*Requiere:* los dos largueros de la mesa con sus ranuras, cuatro bulones M8
de cabeza fresada, bujes (tramos de caño) para que el bulón no aplaste la
madera, arandelas anchas, cuatro tuercas mariposa M8. *Procedimiento:* el
dobson se apoya en los largueros, se corre sobre las ranuras hasta donde pida
la calibración (CAL-1), y se fija **con la cabeza del bulón al ras del pino y la
mariposa abajo**, así se aprieta con la mano, de noche, sin llave. *Aceptación:*
con la fijación apretada, un empujón fuerte con la mano no mueve el dobson
sobre los largueros; con la fijación suelta, se corre a mano sin forzar.

## C.2 Calibración

**CAL-1 — Balance sobre el eje.**
*Procedimiento:* con el telescopio arriba y el motor desacoplado (correa floja),
llevar la mesa a cinco posiciones (las dos puntas, el centro y los dos
intermedios) y soltarla. *Aceptación:* en las cinco **se queda quieta**. *Si no:*
si se va siempre para el mismo lado, el centro de masa está corrido: correr el
dobson en sus ranuras o sumar suplementos, y repetir.

**CAL-2 — Velocidad de seguimiento.**
*Procedimiento:* marcar la mesa y la base, correr el programa 10 minutos
medidos con cronómetro, medir el desplazamiento. *Aceptación:* el giro medido
difiere del del cielo (2,5° en 10 min) en **menos de 0,5 %**. *Si no:* se
ajusta la constante de pasos por grado del programa.

**CAL-3 — Las tres capas de límite.**
*Procedimiento:* (a) programa: correr hasta el final y ver que pare solo a los
±45 min; (b) switch: desactivar el límite del programa y ver que el switch
corte a los ±48 min; (c) talón: con el motor desacoplado, empujar a mano hasta
el tope. *Aceptación:* las tres frenan, cada una sin ayuda de la otra. **Una
capa que nunca se vio frenar no está probada.**

**CAL-4 — Alineación polar.**
*Procedimiento:* nivelar con las patas; apuntar una estrella cerca del
meridiano y otra cerca del horizonte este; mirar hacia dónde se escapan (método
de deriva) y corregir con las patas. Marcar las tres patas en el piso.
*Aceptación:* en 60 s de foco primario la estrella no se corre más de **3
píxeles** (unos 2″).

**CAL-5 — Prueba de deriva (el examen final).**
*Procedimiento:* fotos de 30 s, 60 s y 2 min de una misma estrella brillante,
con el seguimiento andando. *Aceptación provisoria:* estrellas **redondas** en
la de 60 s. La cifra definitiva sale de la fase 1. Recién ahí, la nebulosa.

---

## Palabras que van a aparecer

- **Centro de masa:** el punto de equilibrio del conjunto.
- **P3, P4:** los nombres de las pesadas en el *Protocolo de medición* (P3: la
  montura sola, inclinada; P4: todo junto, plano).
- **Eje polar:** la línea imaginaria alrededor de la que gira la mesa; apunta al
  polo sur celeste.
- **Micropaso:** el motor paso a paso divide cada paso en 16 para moverse
  suave.
- **Segundo de arco (″):** 1/3600 de grado. La Luna mide unos 1800″.
- **Deriva:** cuánto se escapa una estrella del lugar con el seguimiento
  andando. Es el examen final de la plataforma.
