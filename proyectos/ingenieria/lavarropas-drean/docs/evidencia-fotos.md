# Evidencia — qué muestran las fotos del 2026-09-21

Las fotos no están en el repo (pesan y no aportan nada que esta descripción no
diga). Lo que sigue es **lo que se ve**, separado de **lo que se infiere**.

## Foto 1 y 2 — etiqueta de identificación

**Se ve:** `DREAN` / `NEXT 6.06 ECO`, sellos IRAM y Seguridad Eléctrica
(República Argentina). En la segunda, el pliegue lateral: `220V – 50Hz –
1700W – IPX4` / `600rpm – Capacidad: 6kg` / `Fabricado por DREAN S.A. /
Av. Córdoba 325 – X5967AHA / Luque – Córdoba` / `INDUSTRIA ARGENTINA`.
También hay un código de barras con número de serie, **que no se transcribe**:
este repo es público.

**Se infiere:** carga frontal de gama media, **600 rpm es un centrifugado
bajo**. Eso importa: a menos revoluciones, los rulemanes sufren menos por
velocidad, así que un rulemán comido acá apunta más a **agua** (retén) que a
fatiga por uso.

## Foto 6 — etiqueta de eficiencia energética

**Se ve:** IRAM 2141-3:2017 · clase **A+** · consumo **0,42 kWh** · **52
litros** · **600 rpm** · **180 min** · capacidad 6,0 kg. Nivel de ruido:
**sin declarar** (`--`).

**Se infiere:** nada sobre la falla. Sirve para confirmar el modelo y para
saber que 180 min es la duración normal del ciclo largo — útil si más adelante
alguien sospecha que "tarda mucho".

## Foto 3 — vista trasera, tapa sacada

**Se ve:** el bidón (tambor exterior) de plástico beige. Abajo a la derecha, el
**motor** con su bobinado de cobre a la vista y el eje saliendo; alrededor, los
brazos del soporte. En la panza del bidón, una placa metálica con tres
terminales y un conector: es la **resistencia calefactora** con su sensor.
Mazo de cables rojos y blancos (motor), verde-amarillo (tierra) y una ficha
blanca multipín. A la derecha se ve un **amortiguador** con la punta amarilla.
Pelusa y telaraña acumuladas.

**Se infiere:** la máquina ya está abierta y **la correa no está puesta**. Eso
habilita los tests T1–T4 sin trabajo previo. También: hay 220 V y una
resistencia de ~1500 W expuestos — desenchufado, siempre.

## Foto 4 y 5 — la polea del tambor

**Se ve:** polea grande **de plástico**, con radios en dos coronas. En el cubo
central, el aro metálico del rodamiento y el **tornillo allen central con
sellador verde**. Alrededor del cubo hay **óxido marrón**, y sobre las aspas
hay **manchas de óxido tiradas hacia afuera**, en patrón radial. En el borde
inferior de la foto 5 se ve el motor, el mismo de la foto 3.

**Se infiere — y esta es la pista principal:** ese óxido no se genera en la
cara exterior de una polea de plástico. Es agua oxidada que salió del
rodamiento por el retén vencido, y que el centrifugado tiró hacia afuera. Es la
firma clásica de **retén perdido → rulemán mojado → rulemán oxidado**.

**Grado: `probable`.** Falta ver el retén y el eje detrás de la polea, y falta
el tacto de T1/T2/T3. Confirmado sería haberlo girado y sentido.

## Lo que las fotos NO muestran, y hace falta

1. El **perímetro del bidón**: ¿corona de tornillos/grampas, o junta lisa
   soldada? Decide si se abre o se compra completo.
2. El **eje y el retén** con la polea afuera: ¿el eje está liso o picado?
3. El **número grabado** en el aro de cada rulemán.
4. Los **amortiguadores** de cerca: si están húmedos de aceite, están
   terminados.
