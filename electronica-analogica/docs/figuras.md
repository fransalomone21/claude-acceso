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
├── verificar.py          los cuatro chequeos (ver sección 5)
├── modulos/*.typ         el texto; llama a las figuras por nombre
└── biblioteca/
    ├── paleta.typ        los colores, en un solo lugar
    ├── estilo.typ        grosores, tamaños, envoltorios y ayudas de anotación
    ├── circuitos.typ     una función `fig-<tema>()` por esquema
    ├── graficos.typ      una función `graf-<tema>()` por curva
    └── galeria.typ       banco de pruebas: renderiza TODAS las figuras juntas
```

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

Cuatro chequeos, todos sobre **efectos**:

1. `apunte.typ` compila de verdad.
2. `galeria.typ` compila de verdad.
3. No quedó ningún circuito en ASCII adentro de un `#circuito(...)`.
4. Toda figura definida en la biblioteca aparece en `galeria.typ`. Una figura
   que no está en la galería no se mira nunca, y una figura que nadie mira se
   rompe sin que se entere nadie.

Los cuatro se probaron **rompiéndolos a propósito** (error de sintaxis en un
módulo, error de sintaxis en la galería, un bloque ASCII devuelto a su lugar, y
una figura definida sin agregar a la galería): los cuatro dieron rojo, y verde
de nuevo al restaurar. Una alarma que nunca sonó está sin verificar.

---

## 6. Trampas que ya costaron tiempo

Esto es lo que no está en la documentación de los paquetes y se aprendió a los
golpes. Leerlo antes de pelearse con algo.

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

30 en total. Las 24 que reemplazan a los dibujos en ASCII, más 6 gráficos que el
apunte no tenía y que estaban descritos solo en palabras.

| Módulo | Figuras |
|---|---|
| 1 — Mediciones | `fig-conexion-instrumentos`, `fig-shunt`, `fig-multiplicadora`, `fig-multirrango` |
| 2 — Señales | `graf-formas-de-onda`, `fig-bloques-osciloscopio`, `fig-filtro-rc`, **`graf-respuesta-rc`** |
| 3 — Transformadores | `fig-transformador`, `fig-transformador-punto-medio` |
| 4 — Diodos | `fig-polarizacion-diodo`, `graf-curva-diodo`, `fig-led-limitadora`, `fig-proteccion-polaridad`, `fig-rectificador-media-onda`, **`graf-media-onda`**, `fig-rectificador-punto-medio`, **`graf-onda-completa`**, `fig-puente-graetz` |
| 5 — Fuentes | `fig-bloques-fuente`, `fig-filtro-capacitivo`, **`graf-rizado`**, `fig-regulador-zener`, **`graf-curva-zener`** |
| 6 — Transistores | `fig-simbolos-bjt`, `fig-conmutacion-npn`, `fig-rele-completo`, **`graf-recta-de-carga`** |
| Anexos | `fig-codigo-colores`, `fig-tabla-simbolos` |

En **negrita**, las nuevas.
