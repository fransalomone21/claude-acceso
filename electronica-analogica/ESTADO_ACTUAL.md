# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-08-23
**Rama:** `claude/manual-analogica-tr0mk6`
**Estado: APUNTE COMPLETO EN DOS PARTES.** 97 páginas, 13 módulos más anexos.

## Qué es esto

Apunte teórico-práctico completo de la materia, fuente única en **Typst**, listo para
compilar a PDF. Destinatario primario: el docente; en segundo lugar, los alumnos de
4.º año de la E.E.S.T. N.º 1 de Vicente López.

Tiene **dos partes**:

- **Parte I (módulos 1 a 6)** — el temario y los TP de la cátedra. Estudia *dispositivos*.
- **Parte II (módulos 7 a 13)** — fundamentos de análisis de circuitos, en el orden de la
  materia **Teoría de Circuitos** de la Ingeniería Electrónica de la UNSAM (Prof. Gabriel
  Sanca, director de la carrera). Estudia el *método*.

## Cómo se compila

```bash
cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf
```

Typst **0.15.1** instalado vía `winget install Typst.Typst`. No hace falta LaTeX ni
pandoc. Para trabajar con vista viva: `typst watch apunte.typ apunte.pdf`.

## Cómo se verifica

```bash
cd electronica-analogica/apunte && python verificar.py
```

Cinco chequeos, todos sobre efectos y **todos probados rompiéndolos a propósito**:
que el apunte compile, que la galería compile, que no quede **ningún** circuito en
ASCII (el chequeo 3 ya no tiene excepciones: la lista `ASCII_PENDIENTE` se borró al
llegar a cero el 2026-08-23, y se volvió a probar rompiéndolo después de reescribirlo),
que toda figura de la biblioteca esté en la galería (una figura que nadie mira se rompe
sin que se entere nadie), y que ningún rótulo de más de 18 caracteres haya quedado
adentro de un `plot.annotate`.

Para mirar las figuras sin compilar las 98 páginas:

```bash
typst watch biblioteca/galeria.typ biblioteca/galeria.pdf
```

## Las figuras (2026-08-21)

Documentación completa —herramientas, por qué esas, cómo agregar una, y las trampas
que ya costaron tiempo— en [`docs/figuras.md`](docs/figuras.md).

**Resumen:** los dibujos en ASCII se reemplazaron por figuras vectoriales hechas con
`zap` (símbolos de circuito según IEC/IEEE) y `cetz-plot` (curvas con ejes estilo
libro de texto), las dos sobre `cetz`. Todo corre adentro de Typst: se descartó
CircuiTikZ porque obligaba a instalar LaTeX y a mantener un segundo toolchain con un
paso de conversión por figura.

La biblioteca vive en `apunte/biblioteca/` con una función por figura (`fig-*` para
esquemas, `graf-*` para curvas). El módulo la llama por nombre y no sabe cómo está
dibujada.

**Seis gráficos nuevos**, que el apunte describía en palabras y no mostraba:

- `graf-respuesta-rc` — respuesta del pasa bajos, con $f_c$ y el punto de −3 dB (M2).
- `graf-media-onda` y `graf-onda-completa` — entrada contra salida rectificada (M4).
- `graf-rizado` — la salida con y sin capacitor, con la cota de ΔV_r (M5).
- `graf-curva-zener` — la característica del zener con vértice, I_Zmín e I_Zmáx (M5).
- `graf-recta-de-carga` — curvas de salida del BJT con la recta de carga, corte y
  saturación marcados (M6).

## Contenido por módulo

| Módulo | Tema | Ejercicios resueltos |
|---|---|---|
| 1 | Mediciones y expansión de rango | 5 |
| 2 | Señales periódicas e instrumental | 4 |
| 3 | Electromagnetismo y transformadores | 2 |
| 4 | Diodos y rectificación | 2 |
| 5 | Fuentes lineales (incluye zener) | 3 |
| 6 | BJT en conmutación y relés | 2 |
| 7 | Elementos, convenciones y leyes de Kirchhoff | 2 |
| 8 | Nodos, supernodos, mallas y supermallas | 6 |
| 9 | Teoremas de circuitos (superposición, Thévenin, Norton, máx. potencia) | 3 |
| 10 | Capacitor, inductor y régimen transitorio (1.º y 2.º orden) | 2 |
| 11 | Fasores, régimen permanente senoidal, potencia y resonancia | 3 |
| 12 | Respuesta en frecuencia, Bode, filtrado y señales poliarmónicas | 2 |
| 13 | Cuadripolos ($z$, $y$, $h$, $ABCD$) y amplificador operacional | 2 |
| — | Anexos: colores, E12/E24, formulario de las dos partes, dos órdenes de lectura, símbolos, seguridad | — |

Todos los módulos llevan: teoría con deducción explícita, ecuaciones numeradas y
referenciadas, circuitos en ASCII, cajas de definición / idea clave / cuidado /
laboratorio, y una caja final que ata el módulo con el TP correspondiente de la cátedra.

## Decisiones de contenido y por qué

**1. El apunte cubre la unión del temario pedido y de los TPs, que no coinciden.**
Los TPs suman regulador zener (TP 8), filtro pasa bajos RC (TP 5) y multímetro en
serie/paralelo (TP 2 y 3), que el temario no menciona. El temario suma transformadores y
BJT, que no tienen TP. Todo eso está.

**2. El apunte oficial de la cátedra (`AEA_Conceptos.pdf`, Prof. Esteban Lemos) está
incompleto.** Desarrolla mediciones, señales, osciloscopio y la introducción a fuentes
(hasta la página 39 de 42). Las secciones **7 (El diodo), 8 (El relé) y 9 (El transistor
bipolar)** son *títulos sin contenido*. Es decir: **todo el segundo cuatrimestre no tiene
material escrito.** Los módulos 4, 5 y 6 de este apunte llenan exactamente ese hueco.

**3. La Parte II no reordena la Parte I.** Los módulos 1 a 6 siguen el orden del temario
y de las guías de TP, y cada uno cierra con el práctico que le corresponde: alterar esa
secuencia rompería la correspondencia con el laboratorio. La Parte II está ordenada
íntegramente según Teoría de Circuitos, que es autónoma. Los cruces entre ambas se
resuelven por referencia y no por repetición, y el anexo 14.3 publica las dos secuencias
de lectura en una tabla.

**4. El programa de UNSAM se tomó de la ficha oficial de la carrera**, no de un programa
analítico: `unsam.edu.ar` está bloqueado por la política de red del entorno remoto y solo
se pudo leer a través del buscador. Los contenidos mínimos confirmados son: tipos y
caracterización de señales usuales; respuestas natural y forzada de circuitos simples;
fasores y régimen permanente en alterna senoidal; diagramas de Bode y señales
poliarmónicas; resolución sistemática de circuitos; teoría de los circuitos y de los
cuadripolos; introducción a los amplificadores operacionales y al filtrado. Carga:
8 h semanales teórico-prácticas, 128 h cuatrimestrales; 5.º cuatrimestre. **Sin verificar
contra el programa analítico de la cátedra**, que no fue accesible.

**5. Se adoptó la notación de la cátedra, no la propia.** En expansión de rango:
$R_m$ = resistencia interna del galvanómetro, $I_m$ = corriente de deflexión a plena
escala, $R_S$ = shunt, $R_M$ = multiplicadora. El Módulo 1 se reescribió para alinearse
con el apunte oficial: si no, el alumno estudia con dos idiomas distintos.

## Evidencia (qué está confirmado y cómo)

- **Compila** → `apunte.pdf`, 97 páginas. Confirmado por ejecución.
- **Se ve bien** → verificado por render a PNG y lectura visual, módulo por módulo, de
  toda la Parte II más la carátula, el índice, los divisores de parte y los anexos. Que
  compile no prueba que se vea bien.
- **Toda la aritmética de los ejercicios de la Parte II está verificada**: cada resultado
  se comprobó por un segundo camino (balance de potencias, el otro método de resolución,
  o sustitución en las ecuaciones originales). Un error del Ejercicio 7.1 —1,10 V donde
  correspondía 1,00 V— se encontró así.
- **Las referencias a los TP se verificaron contra las guías**, no de memoria. Tres citas
  estaban mal en el primer borrador: el TP 4 es *Introducción al Análisis de Señales* y el
  TP 5 es *Manejo del Osciloscopio* — ninguno de los dos es un filtro RC, como se había
  supuesto. El Anexo 1 de la guía I (PT100) resultó ser un puente de Wheatstone y quedó
  citado en los módulos 8 y 9, donde encaja exactamente.
- **Dos defectos encontrados y corregidos por ese render**, no por leer el fuente:
  1. En Typst, una coma decimal seguida de `/` parte el número: `16,3/1000` se dibujaba
     como "16" seguido de la fracción 3/1000. Corregido con paréntesis en las seis
     expresiones afectadas.
  2. Typst trata la coma como separador y le agrega un espacio detrás: los decimales
     salían como "15, 6". Corregido globalmente en `plantilla.typ` con una regla
     `show` que reclasifica la coma como átomo normal.

- **Cinco defectos más, encontrados por render durante la Parte II** (ninguno impedía
  compilar):
  1. El encabezado mostraba el módulo *anterior* en la primera página de cada módulo:
     `.before(here())` no ve el título que arranca en esa misma página. Corregido
     filtrando por número de página.
  2. `mat(0,75, -0,25; ...)`: la coma decimal dentro de `mat()` es el separador de
     columnas y partía la matriz en cuatro. Corregido entrecomillando los decimales.
  3. El menos detrás de `angle` se componía como operador binario (`60 ∠ − 53,13°`).
     Corregido con el menos tipográfico dentro de una cadena.
  4. `v_square` dibujaba un cuadrado vacío en vez de un subíndice. Es `v_"cuad"`.
  5. Dos fórmulas del anexo se pisaban con el número de ecuación. Partidas en dos líneas.

- **El dibujo del amplificador operacional en ASCII se rehízo con las columnas contadas
  a mano.** El primer intento era ilegible: el triángulo no cerraba. El criterio que
  funciona es fijar la columna de la barra vertical y hacer que la diagonal avance de a
  una columna por fila.

### Evidencia de las figuras (al 2026-08-23)

- ~~**Las 30 figuras se ven bien** → confirmado por render a PNG de las 8 páginas de la
  galería, **completas y después del último retoque**.~~ **ESTO ERA FALSO.** La pasada
  del 2026-08-23 posterior a la Parte II encontró ocho defectos en la Parte I, listados
  más abajo. Se deja tachado y no borrado: la afirmación equivocada es el dato, porque
  es lo que hizo que la sesión siguiente no las mirara.
- **`graf-curva-diodo` está arreglada.** Los dos rótulos largos ya no cruzan el eje.
- **La causa era doble, y la segunda mitad no se sabía**: además de que las anotaciones
  van en coordenadas de datos, **cetz-plot recorta la anotación contra el área del
  gráfico** y empuja el texto hacia adentro tanto más cuanto más largo es. Por eso dos
  rótulos largos pedidos en esquinas opuestas terminaban encimados en el centro. Se
  comprobó por render con dos etiquetas de prueba de distinto largo en las mismas
  esquinas. La salida es `rotulo-marco`, que dibuja *fuera* del plot.
- **Cinco defectos más, encontrados en la pasada completa** y ninguno reportado antes:
  1. `graf-respuesta-rc` tenía un rótulo de 32 caracteres adentro de los ejes — la figura
     que la sesión anterior daba por bien resuelta. La encontró sola la alarma nueva.
  2. `graf-media-onda` y `graf-onda-completa`: "entrada" salía escrito *encima* del eje
     del tiempo, empujado por el mismo recorte.
  3. `fig-multiplicadora`: el rótulo `R_M` del resistor y el de la flecha `I_m` se
     dibujaban uno sobre el otro.
  4. `fig-rele-completo`: el `1N4007` quedaba pisado por el símbolo del diodo.
  5. `graf-rizado`: "sin capacitor" se montaba sobre la curva.
- **El verificador ahora corre cinco chequeos**, y el quinto se probó rompiéndolo:
  un rótulo de 27 caracteres adentro de un `plot.annotate` da rojo, y verde al
  restaurar. También se probó rompiendo el chequeo 3 con ASCII nuevo en un módulo de la
  Parte I.
### Las 15 figuras de la Parte II (2026-08-23, sesión siguiente)

**La deuda quedó saldada: no hay un solo circuito en ASCII en todo el apunte.** Son 45
figuras. Las 15 nuevas se verificaron por render en una pasada **completa** de las 12
páginas de la galería, posterior al último retoque, y están limpias.

- **La notación de los métodos se resolvió una vez, en `estilo.typ`** —`marca-nodo`,
  `nodo-referencia`, `giro-malla`, `recuadro-super`, más `rotulo` y `valor`— y recién
  después se dibujaron las cinco figuras que la usan. Dibujarlas una por una habría
  dado cinco notaciones distintas para la misma cosa.
- **Cuatro trampas nuevas, todas encontradas por render y ninguna visible en el
  fuente.** Están en `docs/figuras.md`, sección 6. La peor: el borde punteado del
  recuadro de la supermalla pasaba por el medio del signo `−` de la fuente y lo
  convertía en `+`; la figura mostraba dos bornes positivos y compilaba perfecto.
- **La galería no aplicaba la regla de la coma decimal** de `plantilla.typ`: componía
  `53, 13` donde el apunte compone `53,13`. Era un banco de pruebas *infiel* —se
  miraba la galería, se aprobaba, y en el apunte se veía distinto—. Se le duplicó la
  regla, con el comentario que lo explica.
- **El Bode va en matplotlib**, como estaba decidido, y es la única figura que no se
  dibuja adentro de Typst. Sale con la MISMA tipografía que el cuerpo del apunte:
  `svg.fonttype = "none"` más una reescritura de la familia en el SVG. El script
  aborta si no reescribe ninguna, y esa alarma saltó de verdad en el primer intento
  —matplotlib pone los nombres entre comillas simples— así que la figura no se
  publicó con otra letra.

### Los ocho defectos de la PARTE I — corregidos (2026-08-23)

Aparecieron en la pasada completa del 2026-08-23 posterior a la Parte II. **Eran
previos a esa sesión**: se comprobaron abriendo el `apunte.pdf` publicado, donde se
veían idénticos, así que no los causó ningún cambio nuevo. La afirmación de más
arriba —"las 30 figuras se ven bien, confirmado por render"— **no se sostenía**, y
`graf-curva-diodo` se había dado por buena estando rota dos veces antes de ésta.

El defecto dominante era uno solo y se repetía: **la línea de guía de un rótulo le
pasaba por encima al propio rótulo**, o la curva le pasaba por encima al rótulo que
la nombra. Los nueve casos (ocho filas, dos figuras comparten la última):

| Figura | Qué se veía | Cómo se arregló |
|---|---|---|
| `graf-curva-diodo` | la curva cruzaba "polarización directa"; "corriente de fuga $I_R$ (escala exagerada)" cruzaba el eje vertical y chocaba con el `0` y con "0,7 V" | "directa" partido en dos renglones y corrido con `dx`, lejos de donde la rama exponencial sube pegada al borde; "corriente de fuga" a dos renglones, sin guía (la guía viajaba tan inclinada como ancho el rótulo, y lo atravesaba entero) |
| `graf-curva-zener` | la curva cruzaba "región de polarización directa" | mismo tratamiento: tres renglones cortos a 7pt, corridos con `dx`, lejos de la rama directa |
| `graf-media-onda` y `graf-onda-completa` | la línea de guía atravesaba "entrada" | se sacó la guía: el rótulo queda pegado a la curva de todos modos |
| `graf-respuesta-rc` | la línea de guía atravesaba "frecuencia de corte:" | se sacó la guía: el punto ya está marcado adentro del plot con las líneas punteadas y el tick de $f_c$ |
| `graf-rizado` | "sin capacitor" quedaba montado sobre la curva punteada y sobre el eje de tiempo | se bajó el `y-min` del marco de −0,22 a −0,5: el margen que quedaba debajo del eje era de dos milésimas de unidad |
| `fig-bloques-osciloscopio` | la flecha atravesaba "barrido horizontal" | rótulo movido a la derecha del tramo vertical, en vez de centrado sobre el hueco entre las dos patas |
| `fig-led-limitadora` | el rótulo `V_F` caía sobre el símbolo del LED | más separación horizontal del símbolo (de 2,5 a 2,15) |
| `graf-recta-de-carga` | la guía atravesaba "corte", que además quedaba sobre el eje | rótulo movido al lado derecho de $V_"cc"$, que estaba vacío, en vez de al izquierdo (pegado al eje y al tick) |

**Patrón que se repitió en la corrección misma, y vale para la próxima vez que se
toque un rótulo con guía**: la guía cruza el rótulo cuando su pendiente es más chica
que el cociente alto/ancho de la caja de texto (la guía viaja "a lo largo" del
rótulo en vez de salir por un borde corto). Se resuelve sacando la guía cuando el
punto ya está marcado por otro medio adentro del plot, o partiendo el texto en más
renglones angostos para que la caja sea más alta que ancha.

Verificado por render, pasada completa de las 12 páginas de la galería posterior al
último retoque — no sólo las cinco páginas donde estaban los ocho defectos.

## El programa real de Teoría de Circuitos (2026-08-23)

Hasta ahora el contenido de la Parte II se había derivado de la ficha web de la carrera.
Fran aportó los documentos de la cátedra, y **la ficha estaba equivocada en lo básico**:

- La materia es de **Ingeniería en Sistemas Espaciales**, **1.º cuatrimestre**, no de
  Electrónica en el 5.º. Cursada 2C 2026, modalidad bimodal, Campus Miguelete.
  Profesor: Gabriel Sanca.
- Bibliografía obligatoria: **Nilsson-Riedel** (primero), Alexander-Sadiku, Hayt-Kemmerly
  y Dorf-Svoboda.
- El marco didáctico pide **tres perspectivas por concepto**: análisis teórico,
  simulación computacional y validación experimental. Uno de los cinco resultados de
  aprendizaje es *comunicar mediante informes técnicos*.

**Lo que el apunte ya cubre**: leyes básicas, Ohm, Kirchhoff, nodos y mallas,
superposición, Thévenin/Norton, máxima transferencia, fuentes ideales y reales, C y L,
RC/RL/RLC, respuesta natural y forzada, valores medio y eficaz, fasores, impedancia y
admitancia, potencias, factor de potencia, resonancia, Q, Bode, frecuencias de corte,
ancho de banda, decibel, cuadripolos, AO ideal y sus limitaciones y las seis
configuraciones básicas.

**Lo que falta, y está pendiente**: sistemas trifásicos (estrella y triángulo, tensiones
de fase y línea, potencias); filtros activos con Butterworth de orden N, Sallen-Key,
ganancia unitaria y diseño por plantillas; la forma zpk y los polos y ceros en el plano
complejo, con la relación unívoca entre la posición de los polos, ζ y Q; la respuesta en
frecuencia del RLC serie según de dónde se tome la salida; el amplificador diferencial y
el de instrumentación; la impedancia reflejada del transformador y los equivalentes serie
y paralelo; y la simulación como tercera pata.

**Decisión de convención, tomada por Fran el 2026-08-23**: el apunte adopta el **fasor en
valor de pico** como convención por defecto —que es la de los cuatro libros de la
cátedra— y publica además la conversión explícita a valor eficaz, porque la Parte I
trabaja en eficaz (multímetro en CA). Hoy los módulos 11 y 12 están escritos en eficaz:
**la conversión está pendiente**.

## Fuentes

En `fuentes/`, con su texto ya extraído a `.txt` (la herramienta Read no abre PDFs en
esta máquina: no hay poppler).

- `AEA_Conceptos.pdf` — apunte oficial de la cátedra, 42 pág., Prof. Esteban Lemos, 2015.
  **Incompleto** a partir de la sección 7.
- `TP_I_cuatrimestre.pdf` / `TPX.pdf` — guía de TPs 0 a 5 + Anexo 1. Son el mismo
  documento (difieren en ~90 caracteres de encabezado).
- `TP_II_cuatrimestre.pdf` / `TP_II_completo.pdf` — guía de TPs 6 a 8. Ídem.
- Autor de las guías: Prof. Guillermo Ruisi.
- **No accesible:** el aula virtual de Moodle pide login.
