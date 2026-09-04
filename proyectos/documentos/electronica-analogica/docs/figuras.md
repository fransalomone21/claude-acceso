# Las figuras del apunte: con qué están hechas y cómo se tocan

Hasta 2026-08-21 los circuitos del apunte eran dibujos en ASCII adentro de un
bloque de código. Ahora son **vectoriales**: se dibujan con el mismo compilador
que arma el PDF, escalan sin pixelarse y se editan como código.

La referencia de estilo que se buscó igualar está en
[`referencia/curva-zener-referencia.png`](referencia/curva-zener-referencia.png):
esquemas con símbolos normalizados y curvas con ejes cruzándose en el origen,
punta de flecha y anotaciones.

---

## 1. Qué herramienta, y por qué esa

| Para qué | Paquete | Versión |
|---|---|---|
| Motor de dibujo vectorial | [`cetz`](https://typst.app/universe/package/cetz) | 0.5.2 |
| Símbolos de circuito (IEC/IEEE) | [`zap`](https://typst.app/universe/package/zap) | 0.6.0 |
| Ejes y curvas | [`cetz-plot`](https://typst.app/universe/package/cetz-plot) | 0.1.4 |

Los tres son paquetes de Typst y corren adentro del compilador que ya usaba el
apunte. **No hace falta instalar nada**: la primera vez que se compila, Typst
los baja solo desde `packages.typst.org` y los deja cacheados en
`%LOCALAPPDATA%\typst\packages\preview\`. De ahí en adelante compila sin red.

`zap` y `cetz-plot` usan **la misma versión de `cetz` (0.5.2)**, así que
conviven sin conflicto en un mismo documento.

### Por qué no LaTeX / CircuiTikZ

CircuiTikZ es el estándar histórico, y era la opción obvia. Se descartó por tres
razones concretas, no por gusto:

1. **Costo de instalación.** No hay LaTeX en esta máquina. MiKTeX son cientos de
   MB más los paquetes que se bajan solos, y hay que mantenerlo actualizado.
   `zap` son 20 KB que Typst baja en un segundo.
2. **Dos toolchains y un paso de conversión.** CircuiTikZ obliga a compilar cada
   figura aparte a PDF/SVG y después incrustarla. Cada figura pasa a ser un
   archivo binario más en el repo, y un cambio de estilo global obliga a
   regenerar todos.
3. **Reversible.** Todo lo que se agregó vive adentro del repo o del caché de
   Typst; se desinstala borrando una carpeta. Un LaTeX instalado a nivel sistema
   no.

Lo que se pierde: CircuiTikZ tiene más símbolos y más años de pulido. Para lo
que necesita el apunte —resistor, capacitor, diodo, zener, LED, transformador,
BJT, relé, instrumentos, fuentes— `zap` alcanza y sobra. El relé no existe como
símbolo y está compuesto a mano (bobina + contactos + acople punteado).

---

## 2. Dónde está cada cosa

```
apunte/
├── apunte.typ            documento principal
├── plantilla.typ         estilo del documento; importa y reexporta la biblioteca
├── verificar.py          los cinco chequeos (ver sección 5)
├── modulos/*.typ         el texto; llama a las figuras por nombre
└── biblioteca/
    ├── paleta.typ        los colores, en un solo lugar
    ├── estilo.typ        grosores, tamaños, envoltorios y ayudas de anotación
    ├── circuitos.typ     una función `fig-<tema>()` por esquema
    ├── graficos.typ      una función `graf-<tema>()` por curva
    ├── galeria.typ       banco de pruebas: renderiza TODAS las figuras juntas
    └── figuras/          la única figura que NO se dibuja adentro de Typst
        ├── generar-bode.py         el script que la genera
        └── bode-amplificador.svg   el resultado, commiteado
```

**Por qué `figuras/` cuelga de `biblioteca/` y no del apunte.** Cuando se compila
*sólo* la galería, el root del sandbox de Typst es `biblioteca/`, y un `../` desde
ahí da `path would escape the project root`. Con el SVG adentro, la misma ruta
relativa funciona compilando la galería y compilando el apunte.

El contrato es el **nombre**: el módulo escribe `#fig-shunt()` y no sabe ni le
importa cómo está dibujado. Cambiar un dibujo no toca el texto.

Los módulos siguen haciendo un solo `#import "../plantilla.typ": *`, porque
`plantilla.typ` reexporta la biblioteca. No hay ciclo de imports gracias a que
la paleta vive en su propio archivo: `plantilla → circuitos → estilo → paleta`.

---

## 3. Compilar y mirar

```bash
cd electronica-analogica/apunte

# el apunte entero
typst compile apunte.typ apunte.pdf

# vista viva mientras se edita
typst watch apunte.typ apunte.pdf

# SOLO las figuras: compila en segundos, no en decenas
typst compile biblioteca/galeria.typ biblioteca/galeria.pdf
typst watch   biblioteca/galeria.typ biblioteca/galeria.pdf

# a PNG, para mirarla sin visor de PDF
typst compile biblioteca/galeria.typ "biblioteca/_g{0p}.png" --ppi 120
```

Los `.png` están en `.gitignore`: son artefactos de trabajo, no fuente.

En una sesión en la nube, donde no hay binario `typst` y el registro de
paquetes está bloqueado, lo mismo se hace desde Python pasándole el caché:

```python
import typst
typst.compile("biblioteca/galeria.typ", output="_g{0p}.png",
              format="png", ppi=105, package_cache_path=CACHE)
```

**Que compile no prueba que se vea bien.** Casi todos los defectos que aparecieron
—rótulos encimados, textos que se salían de las cajas, flechas que apuntaban al
lado equivocado— compilaban perfecto. Hay que *mirar* el render.

---

## 4. Agregar una figura

1. Copiar en `circuitos.typ` (o `graficos.typ`) la función más parecida y
   cambiarle el nombre. El prefijo importa: `fig-` para esquemas, `graf-` para
   curvas.
2. Agregarla a `galeria.typ` con `#muestra("nombre()", nombre())`.
3. Compilar la galería y mirarla.
4. Llamarla desde el módulo, adentro de `#circuito([epígrafe])[ ... ]`.
5. Correr `python verificar.py`.

### Escribir un esquema

Adentro de `esquema({ ... })` valen los símbolos de `zap` —`resistor`,
`capacitor`, `diode`, `zener`, `led`, `inductor`, `npn`, `pnp`, `transformer`,
`voltmeter`, `ammeter`, `round-meter`, `cell`, `acvsource`, `fuse`, `lamp`,
`switch`, `ground`, `vcc`, `wire`, `node`— y las primitivas de CeTZ
(`cetz.draw.line`, `.content`, `.circle`, `.rect`, `.arc`).

```typst
#let fig-ejemplo() = esquema({
  import zap: *
  cell("V", (0, 0), (0, 2), label: $V$)     // fuente vertical
  wire((0, 2), (0.5, 2))
  resistor("R", (0.5, 2), (2.5, 2), label: $R$)
  wire((2.5, 2), (2.5, 0))
  wire((2.5, 0), (0, 0))
})
```

Las coordenadas son `(x, y)` en unidades del lienzo; `escala:` fija cuánto mide
una unidad (0,95 cm por defecto). Para agrandar una figura entera se sube
`escala`, no se tocan las coordenadas.

### Escribir un gráfico

```typst
#let graf-ejemplo() = grafico({
  ejes-libro(
    tam: (7, 4), x-label: $v$, y-label: $i$,
    x-min: -1, x-max: 1, y-min: 0, y-max: 10,
    {
      plot.add(domain: (0, 1), samples: 150,
               style: (stroke: trazo-curva + c-dato), v => v * v * 10)
      plot.annotate(resize: false, {
        guia((0, 5), (0.7, 5))
        nota((0.75, 5), [la mitad], ancla: "west")
      })
    },
  )
})
```

`ejes-libro` es el estilo `school-book` de cetz-plot: los ejes se cruzan en el
origen y terminan en punta de flecha. Los ticks vienen apagados a propósito —en
una curva cualitativa una escala numérica miente más de lo que informa—; se
prenden pasando `x-tick-step` / `y-tick-step`.

---

## 5. Verificar

```bash
python verificar.py
```

Cinco chequeos, todos sobre **efectos**:

1. `apunte.typ` compila de verdad.
2. `galeria.typ` compila de verdad.
3. No quedó ningún circuito en ASCII adentro de un `#circuito(...)`.
4. Toda figura definida en la biblioteca aparece en `galeria.typ`. Una figura
   que no está en la galería no se mira nunca, y una figura que nadie mira se
   rompe sin que se entere nadie.
5. Ningún `nota(` ni `flecha-nota(` adentro de un `plot.annotate` lleva más de
   18 caracteres. Ese es el límite entre "marca corta" y "rótulo", y es la
   alarma que habría agarrado sola los dos rótulos rotos de `graf-curva-diodo`.

El chequeo 3 **ya no tiene excepciones**. Mientras la Parte II conservó sus
circuitos en ASCII, llevó una lista `ASCII_PENDIENTE` con la cuenta exacta por
módulo —para que la alarma siguiera sirviendo con la deuda abierta—. La deuda se
saldó el 2026-08-23 y la lista se borró junto con la rama que la toleraba: hoy
cualquier `#circuito(...)` que arranque con un bloque de código es rojo. Un rojo
permanente no lo mira nadie; una deuda sin enumerar tampoco se paga; y una
excepción que sobrevive a lo que la justificaba es peor que las dos cosas.

En una sesión en la nube no hay binario `typst` en el PATH y `packages.typst.org`
está bloqueado por el proxy de egreso. `verificar.py` cae al módulo de Python y
usa el caché de paquetes cuya ruta se le pasa en `TYPST_PACKAGE_CACHE`. En la
máquina de escritorio no hace falta nada de esto.

El chequeo 3 se reescribió al borrar la lista, así que se volvió a probar
rompiéndolo: un bloque ASCII devuelto a `m9-teoremas.typ` da rojo con código de
salida 1 y nombra el archivo y la cuenta; al restaurarlo, verde con código 0. Un
verificador reescrito es un verificador sin verificar, aunque el anterior
estuviera probado.

Los cinco se probaron **rompiéndolos a propósito** (error de sintaxis en un
módulo, error de sintaxis en la galería, un bloque ASCII devuelto a su lugar,
una figura definida sin agregar a la galería, y un rótulo de 27 caracteres
metido adentro de un `plot.annotate`): los cinco dieron rojo, y verde de nuevo
al restaurar. Una alarma que nunca sonó está sin verificar.

---

## 6. Trampas que ya costaron tiempo

Esto es lo que no está en la documentación de los paquetes y se aprendió a los
golpes. Leerlo antes de pelearse con algo.

- **Un `wire` corto rompe CeTZ, no sólo uno de longitud cero.** El error es el
  mismo que ya estaba documentado para el largo cero —`inequality assertion
  failed: value none was equal to none`, en `anchor.typ:186`— y no dice nada del
  wire. **Medido el 2026-09-04**: 0,35 unidades rompe, 0,5 anda. Apareció al
  despegar una llave del conductor de arriba en `fig-tres-instantes`. Si el error
  aparece después de tocar una figura, el primer sospechoso es el `wire` más corto
  que se haya agregado.

- **`wire(..., i: ...)` explota.** El decorado de corriente de `zap` 0.6.0
  funciona sobre un símbolo de dos nodos, pero sobre un `wire` tira
  `panic: Element 'symbol' does not have a border for anchor '0deg'`. Para
  marcar corriente sobre un cable está el ayudante `corriente(desde, hasta,
  etiqueta)` de `estilo.typ`, que además deja elegir dónde cae la flecha.

- **Los nombres de elemento no pueden tener punto.** CeTZ usa el punto para
  separar elemento y ancla, así que `node("t1.5", ...)` —generado con
  `str(1.5)` adentro de un `for`— aborta la compilación. Numerar con el índice
  del `enumerate`, nunca con el valor.

- **Las patas del transistor no están alineadas con su punto de inserción.**
  `npn("Q", (2, 1))` deja los bornes en `Q.b`, `Q.c` y `Q.e`, desplazados
  respecto de `(2, 1)`. Si se cablea a coordenadas absolutas, los conductores
  salen en diagonal. Todo lo que cuelga de un transistor va con coordenadas
  relativas: `(rel: (0, 1.2), to: "Q.c")`.

- **En el PNP, el colector va para abajo.** `npn` y `pnp` intercambian `c` y
  `e`: en el NPN el colector queda arriba y el emisor abajo, en el PNP al revés.
  Un `wire("Q.c", (rel: (0, 0.7), to: "Q.c"))` que anda en el NPN dibuja la pata
  hacia *adentro* del símbolo en el PNP.

- **Las anotaciones de un gráfico van en coordenadas del gráfico.** Un
  `largo: 0.3` en un eje que va de 0 a 20 mA es invisible; el mismo 0,3 en un
  eje que va de 0 a 1 V tapa media figura. Cada gráfico lleva sus propios
  valores, y conviene calcular cuántas unidades de dato entran en un centímetro
  antes de acomodar rótulos. Y siempre `plot.annotate(..., resize: false)`, para
  que la anotación no estire los ejes.

- **Un rótulo largo adentro de `plot.annotate` no se queda donde uno lo pone.**
  Ésta es la que costó la figura publicada rota, y tiene dos capas. La primera:
  las anotaciones van en coordenadas de DATOS, y el texto no sabe cuánto mide,
  así que un rótulo anclado al borde izquierdo cruza el eje vertical sin avisar.
  La segunda, que es peor porque es invisible en el fuente: **cetz-plot recorta
  la anotación contra el área del gráfico**, y cuanto más largo es el texto más
  lo empuja hacia adentro. Dos rótulos largos pedidos en esquinas opuestas
  terminan encimados en el centro. Comprobado por render con dos etiquetas
  IZQUIERDA/DERECHA: la de dos letras quedó casi en su lugar y la de nueve se
  corrió media figura.

  La salida es `rotulo-marco(...)` de `estilo.typ`, que dibuja **fuera** del
  plot —como hermano de `ejes-libro` adentro del mismo `grafico({ ... })`—,
  donde las coordenadas son las del lienzo y no las toca nadie. Se le pasa el
  `marco(...)` de la figura, una de las ocho posiciones del borde, y opcionalmente
  un punto de dato al que tirar una guía. Adentro de los ejes quedan sólo las
  marcas cortas: un número, una letra, "0,7 V". El chequeo 5 de `verificar.py`
  hace cumplir el límite.

- **El rótulo automático de un símbolo de zap cae arriba, justo donde va la
  flecha de corriente.** En `fig-multiplicadora`, el `label: $R_M$` del resistor
  y el rótulo de la flecha `corriente(...)` se dibujaban uno encima del otro y
  el resultado era ilegible. Subir la flecha no alcanza: lo que funciona es
  apagar el rótulo con `label: none` y poner el texto a mano por debajo con
  `cetz.draw.content`.

- **Un borde punteado que pasa por el medio de un `−` lo convierte en `+`.**
  En `fig-supermalla`, el recuadro de la supermalla cortaba justo el signo menos
  de la fuente de 20 V, y la figura mostraba dos bornes positivos. Compilaba
  perfecto y en el fuente no se ve. Regla: un `recuadro-super` se lleva adentro
  los rótulos de lo que encierra, o los deja bien afuera; nunca por el medio.

- **Los símbolos de zap en la variante IEC no dicen lo que hace falta.** La
  variante por defecto es `iec`, y ahí `isource` es un círculo con una raya
  *perpendicular* a la corriente: **no muestra hacia dónde va**, que es
  exactamente el dato con el que se plantea la ecuación de nodos. Y `opamp` es
  un rectángulo con los signos adentro, no el triángulo que el alumno ve en
  todos lados. Las dos se arreglan pasando `variant: "ieee"` al símbolo. `vsource`
  y `dvsource` en IEC tampoco traen polaridad: el `+` y el `−` van a mano.

- **El valor de un componente no entra al lado de un símbolo vertical.** Un
  `label: $R_2 = 4 Omega$` sobre un resistor rotado mide más de una unidad de
  lienzo y se lleva por delante al vecino —además de caer sobre una punta, por
  la trampa del `anchor` de más abajo—. La salida es `valor(pos, $R_2$, $4 Omega$)`
  de `estilo.typ`, que lo apila en dos renglones y ocupa menos de la mitad.

- **La galería tiene que aplicar las mismas reglas tipográficas que el apunte.**
  `galeria.typ` no importa `plantilla.typ`, así que le faltaba la regla
  `show ","` que le saca el espacio a la coma decimal: componía `53, 13` donde el
  apunte compone `53,13`. Eso convierte al banco de pruebas en un proxy infiel —
  se mira la galería, se aprueba, y en el apunte se ve distinto. La regla está
  duplicada a propósito en `galeria.typ`, con un comentario que lo dice: si
  cambia en `plantilla.typ`, cambia ahí.

- **El puente de Graetz no se puede dibujar sin un cruce.** Con la fuente de un
  lado y la carga del otro, dos conductores tienen que cruzarse sí o sí. Está
  resuelto con un salto (`_salto`), que es la convención inequívoca.

- **Etiqueta de símbolo: `anchor` elige el LUGAR, no el lado.** En
  `label: (content: $R$, anchor: "east")`, `"east"` es el punto del símbolo
  donde se ancla el rótulo; en un símbolo rotado 90° eso cae en una punta y el
  texto se monta sobre el dibujo. Para casi todo, el rótulo por defecto
  (`label: $R$`) cae bien. Cuando no, es más barato apagarlo con `label: none` y
  poner el texto a mano con `cetz.draw.content`.

---

## 7. Qué figuras hay

**Cuántas hay no se escribe acá**: el número vivía en esta línea, decía 45 cuando ya
eran 55, y volvió a quedar viejo al llegar a 72. Lo mide `verificar.py`, que las
cuenta contra la galería y lo imprime en cada corrida:

```
  ok  las N figuras están en la galería
```

Ya no queda ningún circuito en ASCII en todo el apunte.

| Módulo | Figuras |
|---|---|
| 1 — Mediciones | `fig-conexion-instrumentos`, `fig-shunt`, `fig-multiplicadora`, `fig-multirrango` |
| 2 — Señales | `graf-formas-de-onda`, `fig-bloques-osciloscopio`, `fig-filtro-rc`, **`graf-respuesta-rc`** |
| 3 — Transformadores | `fig-transformador`, `fig-transformador-punto-medio` |
| 4 — Diodos | `fig-polarizacion-diodo`, `graf-curva-diodo`, `fig-led-limitadora`, `fig-proteccion-polaridad`, `fig-rectificador-media-onda`, **`graf-media-onda`**, `fig-rectificador-punto-medio`, **`graf-onda-completa`**, `fig-puente-graetz` |
| 5 — Fuentes | `fig-bloques-fuente`, `fig-filtro-capacitivo`, **`graf-rizado`**, `fig-regulador-zener`, **`graf-curva-zener`** |
| 6 — Transistores | `fig-simbolos-bjt`, `fig-conmutacion-npn`, `fig-rele-completo`, **`graf-recta-de-carga`** |
| 7 — Kirchhoff | `fig-nodos-y-mallas`, `fig-delta-estrella` |
| 8 — Nodal y mallas | `fig-nodal-primero`, `fig-nodal-basico`, `fig-supernodo`, `fig-mallas-basico`, `fig-supermalla`, `fig-nodal-controlada` |
| 9 — Teoremas | `fig-fuentes-reales` |
| 10 — Transitorios | `fig-rc-primer-orden`, `fig-rl-primer-orden`, `fig-tres-instantes`, `fig-req-prueba`, `fig-no-idealidades`, `fig-induccion-mutua`, `fig-rlc-serie-conmutado`, `fig-rlc-paralelo`, **`graf-tau-exponencial`**, **`graf-pulso-en-bobina`**, **`graf-pulso-en-capacitor`**, **`graf-tres-regimenes`**, **`graf-subamortiguado-detalle`**, **`graf-energia-descarga`**, **`graf-respuesta-completa`** |
| 11 — Fasores | `fig-rlc-serie`, `graf-diagrama-fasorial` |
| 12 — Frecuencia | `fig-pasabajos-pasaaltos`, **`graf-bode-amplificador`** |
| 13 — Cuadripolos | `fig-cuadripolo` |
| 14 — Operacional | `fig-ao-terminales`, `fig-ao-lazo-abierto`, `fig-ao-seguidor`, `fig-ao-inversor`, `fig-ao-no-inversor`, `fig-ao-sumador`, `fig-ao-restador`, `fig-ao-integrador-derivador`, `fig-ao-comparador-schmitt`, `fig-ao-instrumentacion` |
| 15 — Simulación | `fig-spice-rc`, `fig-spice-rlc`, **`graf-paso-de-simulacion`** |
| Anexos | `fig-codigo-colores`, `fig-tabla-simbolos` |

En **negrita**, las que no salen de un dibujo en ASCII previo (los 6 gráficos de
la Parte I y el Bode).

### La notación de los métodos de análisis

Las figuras de los módulos 7 y 8 no son sólo circuitos: llevan encima la notación
del método. Está resuelta **una vez** en `estilo.typ` y no figura por figura,
porque cinco figuras que inventan cada una su forma de marcar un nodo son cinco
notaciones distintas para la misma cosa:

| Ayudante | Qué dibuja |
|---|---|
| `marca-nodo(pos, etiqueta, hacia:)` | el punto de unión más su número adentro de un círculo, en una de ocho direcciones |
| `nodo-referencia(pos, etiqueta:)` | lo mismo más el símbolo de tierra colgando; sale en diagonal por defecto porque en un nodo de referencia hay un cable horizontal y otro vertical |
| `giro-malla(centro, etiqueta)` | la flecha circular de la corriente de malla, horaria por defecto |
| `recuadro-super(a, b, etiqueta)` | el recuadro punteado del supernodo y de la supermalla: la misma marca para los dos, porque las dos dicen "esto de acá adentro se trata como una sola ecuación" |
| `rotulo(pos, cuerpo)` / `valor(pos, nombre, val)` | texto puesto a mano, y nombre-más-valor en dos renglones |

### La excepción: el Bode va en matplotlib

`graf-bode-amplificador` es la única figura que **no** se dibuja adentro de Typst.
cetz-plot no hace bien los ejes logarítmicos, y un Bode sin décadas parejas no es
un Bode. Se genera con matplotlib y se incrusta el SVG:

```bash
cd electronica-analogica/apunte
python biblioteca/figuras/generar-bode.py
```

El SVG **se commitea**: el apunte tiene que compilar en una máquina sin Python.
El script está para regenerarlo, no para correr en cada compilación.

Dos detalles que hacen que la figura no se note como un cuerpo extraño, y que
están explicados en el encabezado del script:

- `svg.fonttype = "none"` deja el texto como texto y con el *nombre* de la familia
  adentro del SVG. Typst la resuelve con su propio catálogo al compilar, así que la
  figura queda escrita en la misma tipografía que el cuerpo del apunte.
- Libertinus Serif la trae Typst adentro y no es una fuente del sistema, así que
  matplotlib no la ve. Maqueta con Times New Roman —métricas parecidas— y después
  el script reescribe la familia en el SVG. **Si no reescribe ninguna, aborta**:
  la primera versión no reescribió nada porque matplotlib pone los nombres entre
  comillas simples, y sin esa alarma la figura se habría publicado con otra letra.

Las curvas cualitativas siguen en cetz-plot, que es donde funciona.
