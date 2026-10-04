# Catálogo de conceptos de plataforma ecuatorial

Investigación del 2026-10-04. **Esto es el insumo del trade study, no la
elección.** La elección se hace con los pesos de Fran y la masa medida.

Fuentes, y por qué estas: la referencia canónica de diseño de plataformas
caseras es el sitio de **Reiner Vogel**, que publica el método geométrico
completo y dos plataformas construidas y medidas; la historia y la comparación
de familias está en la **British Astronomical Association**. Las dos coinciden
en lo que importa acá.

- [Reiner Vogel — Designing an Equatorial Platform](http://www.reinervogel.net/Plattform/Planung_e.html)
- [Reiner Vogel — VNS platform](http://www.reinervogel.net/Plattform/plattform_VNS_e.html)
- [BAA — Equatorial Platforms Part One](https://britastro.org/section_information_/equipment-and-techniques-section-overview/telescope-making/equatorial-platforms-pt-1)
- [Wikipedia — Equatorial platform](https://en.wikipedia.org/wiki/Equatorial_platform)

---

## 1. Lo que todas tienen en común

Una plataforma ecuatorial es una mesa que gira alrededor de un eje inclinado
al ángulo de la latitud, apuntando al polo sur celeste. El dobson se apoya
arriba y se sigue apuntando a mano; la mesa compensa la rotación de la Tierra.
Resuelve las dos cosas de un saque: el objeto no se va **y el campo no rota**.

**La condición que no se negocia, y es la misma en todos los diseños:** el
centro de masa del conjunto tiene que estar **sobre el eje polar**. Vogel lo
dice en una línea: *"be on the polar axis"*. Si no lo está, la gravedad hace
un momento sobre el eje que cambia de signo a lo largo de la carrera, y el
motor pelea contra algo que no es fricción. Eso es exactamente lo que Fran
intuyó y por eso la reforma de la montura va antes de la plataforma.

**Carrera típica:** una hora a cada lado del meridiano. La superficie de
seguimiento necesaria para 1,5 h sale de `(1,5 h / 24 h) · 2 π c`, con `c` el
radio del sector.

---

## 2. Las familias

| Concepto | Qué es | A favor | En contra |
|---|---|---|---|
| **Poncet** (1977) | pivote real en el vértice del cono al sur, y al norte un disco plano perpendicular al eje polar que desliza o rueda | el más simple de todos; el disco norte no necesita ni ser circular | capacidad de carga baja, y la altura que agrega sube el ocular |
| **Gee** | variante de Poncet con disco circular y rodillos en el canto, alineados **paralelos** al eje polar | mejor rodadura que el deslizamiento | el canto del disco toma toda la carga |
| **CS — segmentos circulares** | dos sectores circulares **inclinados**, cortados en planos perpendiculares al eje polar | **el más fácil de entender y de cortar**: el perfil es un arco de círculo, se marca con un clavo y un piolín | **no admite apoyo real en tres puntos**, y es el de **menor capacidad de carga** de los que sirven. Vogel: *"has several disadvantages"*; sirve para telescopios **medianos** |
| **VNS — sectores norte verticales** | los sectores al norte van **verticales**, no inclinados; el perfil deja de ser un arco de círculo y pasa a ser **elíptico** | **el mecánicamente más fuerte.** Apoyo real en tres puntos, transmisión del peso más directa al piso, rodamientos y motor más simples, **más capacidad de carga**. La plataforma VNS de Vogel lleva **45 kg** medidos | el perfil no se traza con piolín: hay que generarlo (comprimir un círculo por `cos α` y estirar por `1/cos β`). Necesita plantilla 1:1 — que es justo lo que un macro de CAD hace gratis |

Los dos últimos son los candidatos reales. Poncet y Gee quedan afuera por
carga.

> **En el hemisferio sur todo va espejado (corregido el 2026-10-04).** El
> nombre dice «sectores *norte*» porque Vogel construye en Alemania, donde el
> eje polar sube hacia el norte. Acá sube hacia el **sur**: el pivote va al
> **norte** (el extremo bajo del eje) y los segmentos verticales al **sur**
> (el extremo alto). Wikipedia lo dice para el Poncet: en el sur la superficie
> mira al sur y el rodillo motriz gira al revés. Las coordenadas del macro de
> 2026-08 ya usaban `+y` al sur; este catálogo lo tenía mal en las palabras.
>
> **El precio de la latitud baja:** el pivote queda a `H / tan φ` del centro
> de masa. A 34,5° y con H = 64 cm son **0,96 m**, y la base mide ≈ 1,40 m
> (a 50° de Vogel serían 0,54 m). Se acorta con un pivote sobre un poste.
> Calculado en `geometria-vns.js`; se ve en `06-modelo-3d.html`.
>
> **Otra referencia construida:** AstralFields (Stargazers Lounge, 2024) hizo
> VNS para 8", 10" y 12" con segmentos **de madera** y una rótula de
> amortiguador a gas como pivote, por 90-120 USD. Sus plantillas son para
> 49-53° N y no sirven acá; la idea del pivote sí.

### La geometría del VNS, para que no suene a magia

El sector elíptico sale de un sector circular **comprimido por `cos α`**, con
`α` la latitud. Después se parte en dos sectores y cada uno se **gira un
ángulo `β = 90° − α` alrededor de un eje vertical** y se **estira por
`1/cos β`**, para que los rodillos no se corran de costado. El precio: la
velocidad de seguimiento deja de ser constante, pero **la desviación es menor
que ±1 %** respecto de la velocidad media — del mismo orden que el error de
tangente que el brazo ya obliga a corregir, y se corrige en el mismo firmware.

**Lo que esto cambia acá:** el argumento de 2026-08 para elegir CS era "es la
que permite poner el eje polar exactamente en el centro de masa". Eso **no es
exclusivo de CS**: el VNS cumple la misma condición, y encima da el apoyo en
tres puntos y la carga. La única ventaja real de CS es que el perfil se traza
con un piolín — y ese argumento se cae solo cuando ya hay un macro de CAD que
emite el DXF 1:1.

### Detalles constructivos del VNS de 45 kg (Vogel), medidos, no supuestos

- Base al piso: **12 mm de multilaminado** con los costados reforzados.
- Mesa móvil: **18 mm de multilaminado**, reforzada con vigas de 20 mm en los
  dos ejes.
- Sectores norte: **aluminio AlMgSi0.5 de 5 mm**, cortado de un plano a escala.
- Apoyo en tres puntos: al norte, un rodillo con rulemanes a la izquierda y la
  **unidad motriz** a la derecha; al sur, **un bulón redondeado girando en un
  hueco cónico**.
- Transmisión: motor con reductora + tornillo sin fin 1:20 y un eje de acero
  que empuja **por fricción**. El eje de 5 mm **se gastó**: recomienda más
  grueso. (Acá el plan era brazo tangencial con varilla M8, que es otro camino
  y no tiene ese desgaste.)

Rulemanes: `608ZZ` (8 mm de agujero, 22 de exterior) es el estándar de estos
armados — los de skate. Coincide con lo que Fran cree tener; se confirma
midiendo el diámetro exterior (P6, foto 7).

---

## 3. Transmisión: las dos opciones

| | Brazo tangencial (varilla roscada) | Rodillo por fricción |
|---|---|---|
| Precisión | alta, pero con **error de tangente** que crece hacia los extremos | sin error de tangente |
| Corrección | **obligatoria** en el firmware: `x(t) = L · tan(ω t)` | no hace falta |
| Carrera | limitada por el largo de la varilla; hay que rebobinar | continua |
| Desgaste | la tuerca y el juego; se compensa con resorte de precarga | el eje se gasta (caso medido de Vogel) |
| Error periódico | sí, el de la varilla reciclada (riesgo R5) | no |
| Lo que dice la práctica | un brazo tangencial simple anda bien **5 a 10 minutos** antes de que el error de tangente se note. Con la corrección aplicada, se llega a la hora | — |

El dato de los 5-10 minutos es la razón por la que la corrección de tangente
es un requisito y no una mejora: sin ella, el objetivo de subs largos no se
alcanza aunque el resto esté perfecto.

---

## 4. El problema del hemisferio sur, que nadie del hemisferio norte tiene

No hay estrella polar útil: **σ Octantis es magnitud 5,4 y está a 1° 8' del
polo**. Las plataformas del norte se alinean apuntando a Polaris y listo; acá
no.

- Con **método de deriva** se llega a una alineación buena, y la práctica dice
  que 10 a 15 minutos sin deriva detectable en declinación alcanza para la
  mayoría de los usos; 30 a 60 minutos de prueba si se quiere lo mejor.
- Un buscador polar da del orden de **3 arcmin**, pero del sur hay que saber
  usar el patrón de Octans.
- **La mitigación que importa acá y es gratis:** marcas fijas en el piso del
  patio. Se alinea bien **una vez**, se marca dónde van las tres patas, y
  todas las noches siguientes se arranca de ahí. Convierte un procedimiento de
  media hora en uno de dos minutos.

Esto es riesgo **R3** del PDP y es el de probabilidad más alta del proyecto.
No lo arregla ningún diseño mecánico: lo arregla el procedimiento.

---

## 5. Qué entra al trade study

Candidatos: **CS** y **VNS**, cada uno con las dos transmisiones (brazo
tangencial / rodillo). Eso da cuatro, pero la transmisión es una decisión
separable y se decide después: primero la arquitectura del apoyo.

Criterios propuestos — **los pesos los pone Fran, no la sesión**:

| Criterio | Qué mide, en criollo |
|---|---|
| capacidad de carga | ¿se banca los ~50 kg sin flexar durante una hora? |
| facilidad de construcción con sus herramientas | amoladora, caladora, agujereadora, atornilladora. Nada de torno ni CNC |
| **changüí** (calibrable y reversible) | si sale torcido, ¿se arregla con suplementos y tornillos, o hay que cortar de nuevo? |
| costo en material a comprar | contra lo que ya tiene en el inventario |
| altura que agrega | cuánto sube el ocular, y cuánto empeora la estabilidad |
| precisión de seguimiento alcanzable | el techo de la arquitectura, no el del motor |

**Pesos declarados por Fran (2026-10-04, fuente «Fran»):** el **changüí** —que
se pueda calibrar y que no dependa de un piso perfecto— es el criterio número
uno. Y dejó escrito el criterio de desempate: *«si es un poco de complejidad
extra a beneficio de mejor performance, vamos a la más compleja»*. Falta
cerrar si capacidad de carga, facilidad de construcción o costo queda segundo.

> **Lo que eso ya decide, y conviene verlo antes de medir:** el apoyo en tres
> puntos **es** el changüí. Tres puntos es la única cantidad de apoyos que
> apoya plano sobre cualquier piso sin hamacarse; con cuatro, uno queda en el
> aire y la plataforma oscila. El CS no admite tres puntos reales. O sea que
> el criterio que Fran puso primero apunta al VNS **por una razón distinta**
> de la capacidad de carga, y las dos razones empujan para el mismo lado.
> Esto es `probable`, no `confirmado`: lo confirma el trade study escrito con
> la masa medida.

**Falta un dato duro para rankear capacidad de carga: la masa real.** Por eso
el trade study va **después** de las mediciones, no antes. Ranquear ahora
sería elegir con el mismo nivel de información con el que se eligió en agosto.
