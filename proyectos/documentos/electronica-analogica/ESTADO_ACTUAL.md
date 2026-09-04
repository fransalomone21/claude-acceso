# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-09-04
**Rama:** `main` — hay una sola rama; el proyecto es una carpeta, no una rama.
**Estado: APUNTE COMPLETO EN DOS PARTES.** 149 páginas, 15 módulos más anexos.

## Qué es esto

Apunte teórico-práctico completo de la materia, fuente única en **Typst**, listo para
compilar a PDF. Destinatario primario: el docente; en segundo lugar, los alumnos de
4.º año de la E.E.S.T. N.º 1 de Vicente López.

Tiene **dos partes**:

- **Parte I (módulos 1 a 6)** — el temario y los TP de la cátedra. Estudia *dispositivos*.
- **Parte II (módulos 7 a 14)** — fundamentos de análisis de circuitos, en el orden de la
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
| 10 | Capacitor, inductor y régimen transitorio (21 pág.): relaciones $v$–$i$ vistas como formas de onda, balance de energía, inductancia mutua y marcas de punto, tres instantes, tres datos, $R_"th"$ con fuente de prueba, entrada cero / estado cero, RLC serie y paralelo, las dos constantes, diseño inverso, componentes reales | 8 |
| 11 | Fasores, régimen permanente senoidal, potencia y resonancia | 3 |
| 12 | Respuesta en frecuencia, Bode, filtrado y señales poliarmónicas | 2 |
| 13 | Cuadripolos ($z$, $y$, $h$, $ABCD$) | 1 |
| 14 | **El amplificador operacional** (26 pág.): las dos reglas, el cortocircuito virtual y los tres casos donde no vale, nueve configuraciones deducidas con análisis nodal, el operacional real | 9 |
| 15 | **Simulación con SPICE** (8 pág.): netlist, los cuatro análisis, `PULSE` y `PWL`, condiciones iniciales, paso de integración, `.step`, `.meas`, los cinco controles, parásitos | 1 |
| — | Anexos: colores, E12/E24, formulario de las dos partes, **mapa de la guía asincrónica de TDC**, dos órdenes de lectura, símbolos, seguridad | — |

Todos los módulos llevan: teoría con deducción explícita, ecuaciones numeradas y
referenciadas, figuras vectoriales, cajas de definición / idea clave / cuidado /
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
trabaja en eficaz (multímetro en CA). ~~Hoy los módulos 11 y 12 están escritos en eficaz:
la conversión está pendiente.~~ **HECHO el 2026-08-25** — ver la sección siguiente.

## Fase 2 — Convenciones y fasor en pico (2026-08-25)

**Cerrada.** El apunte tiene ahora 103 páginas.

### El bloque de convenciones

`apunte/modulos/convenciones.typ`, incluido desde `apunte.typ` **antes** del divisor de
la Parte I. Seis apartados: (A) mayúsculas, minúsculas y barras, con la tabla de qué
significa cada forma de escribir una magnitud; (B) convención de signos pasiva; (C) nodo
de referencia; (D) sentido de las corrientes de malla y del recorrido; (E) el fasor en
valor de pico, con la tabla de equivalencia a eficaz; (F) números, unidades y ángulos.

Va como **sección de nivel 1 sin número**, con el ayudante `seccion(...)` nuevo de
`plantilla.typ`: un `heading` con `numbering: none` **no incrementa el contador**, así
que el bloque entra al frente sin correr la numeración de los trece módulos. La
contrapartida es que adentro no pueden ir headings de nivel 2 ni 3 —se numerarían
«0.1»—, y por eso los apartados son texto destacado (`apartado(...)`, local al archivo)
y no títulos. Hubo que tocar dos lugares más de `plantilla.typ`: el `show heading` de
nivel 1 (pedirle `counter(heading).display()` a un heading sin número devuelve el del
módulo anterior) y el encabezado de página.

### La conversión a valor de pico

- **Módulo 11**: convertido entero. La caja de definición del fasor declara el convenio
  y remite al bloque de convenciones. Las tres potencias llevan el factor $1/2$
  (`<ec-potencias>`), con la forma en eficaz publicada al lado. Máxima transferencia
  pasó a $V_(m,th)^2/(8 R_th) = V_(ef,th)^2/(4 R_th)$. Los tres ejercicios reconvertidos.
- **Módulo 12**: **no había nada que convertir**. Todo el módulo trabaja con cocientes
  —$H$, decibeles, $f_c$, BW, amplitudes relativas de los armónicos— y el $sqrt(2)$ se
  cancela arriba y abajo. Se le agregó un párrafo a la definición de función de
  transferencia que lo dice explícitamente, para que nadie vuelva a preguntárselo.
- **Anexo 14.2**: el formulario del Módulo 11 reescrito en pico, con la línea en eficaz
  al lado y la fórmula de máxima transferencia completa.

### Cómo se verificó cada ejercicio

Los cinco chequeos de `verificar.py` en verde, más render página por página de todo lo
tocado (5–8, 78–86, 101). Y la aritmética por **dos caminos independientes**, corrida en
Python:

| Ejercicio | Primer camino | Segundo camino |
|---|---|---|
| 11.1 | $P = ½ V_m I_m cos θ = 60$ W, $Q = 80$ VAr, $S = 100$ VA | $P_R = I_ef^2 R = 60$ W y $Q = I_ef^2 (X_L - X_C) = 80$ VAr; **y un tercero**, $V_ef I_ef cos θ = 60$ W |
| 11.2 | $C = Q_C/(ω V_ef^2) = 145$ µF | los datos son eficaces por ser de línea: se declaró explícito y la cuenta no cambia |
| 11.3 | $Q = ω_0 L/R = 2,5$, $V_L = 25$ V pico | $Q = 1/(2ζ)$ con el $ζ = 0,2$ del Módulo 10; y $V_L/V = 2,5$ da igual en pico que en eficaz |
| 12.2 | tabla de $|H|$ en 500/1500/2500/3500 Hz | recalculada con $1/sqrt(1+(f/f_c)^2)$: 0,954 / 0,728 / 0,537 / 0,414 |

El paso 7 del Ejercicio 11.1 se agregó justamente para eso: es el único lugar del apunte
donde el factor $1/2$ se usa y se comprueba en el mismo ejercicio.

### El puente de Graetz estaba mal dibujado

Lo encontró Fran mirando la figura, no ninguno de los cinco chequeos.

`fig-puente-graetz` tenía `diode("D2", ar, de)`: **ánodo en el vértice de salida y cátodo
en el borne derecho de la fuente**, o sea al revés. Con ese sentido, en el semiciclo
positivo D1 y D2 quedaban en serie y en directa de `iz` a `de`, cortocircuitando la
fuente por un camino de mucha menor resistencia que $R_L$. La figura compilaba, se veía
prolija, y el pie de figura y el texto del Módulo 4 —que dicen «conducen D1 y D4»— eran
**correctos**: sólo estaba mal el dibujo. Corregido a `diode("D2", de, ar)` y verificado
por render con zoom sobre los cuatro triángulos.

**La lección de proceso, y es la que importa**: las 45 figuras estaban «verificadas por
render», pero esa pasada preguntaba *¿se lee bien?* —rótulos cruzados, guías encima del
texto, curvas pisando etiquetas—. Nunca preguntó *¿el circuito es correcto?*. Son dos
verificaciones distintas y sólo se hizo una. Falta una pasada de **lectura eléctrica**
sobre las 45 figuras: seguir la corriente, chequear polaridades y sentidos de los
semiconductores. Entra como pendiente explícito en el `HANDOFF.md`.

De paso, en la misma figura: el rótulo `v_e` de la fuente estaba forzado con
`anchor: "east"` y le caía encima del círculo, comiéndose el subíndice. Se le sacó el
anclaje forzado.

### Tres trampas de Typst nuevas

1. **El ángulo negativo escrito como cadena.** `angle "−53,13" degree` mete un espacio
   detrás del símbolo de ángulo, y si el número **no** tiene coma decimal mete otro
   delante del grado: sale `2∠ −90 °`. Resuelto con el ayudante `ang(...)` de
   `plantilla.typ`, que reclasifica la cadena como `math.class("unary", ...)` y la deja
   igual que un ángulo positivo escrito con números sueltos: `2∠−53,13°`. Con
   `"normal"` alcanza sólo si el número tiene coma; con `"unary"` anda en los dos casos.
   Probado con render, no deducido.
2. **`mu "F"` mete el espacio en el medio** —`145μ F`—. Ya estaba en el HANDOFF; había un
   caso vivo en el Módulo 11. Va `"145 µF"` como cadena entera.
3. **Las fórmulas largas del anexo se pisan con el número de ecuación.** Volvió a pasar
   al alargar la línea de potencias con el factor $1/2$. Se parte en dos ecuaciones. El
   anexo no tiene ninguna alarma que lo agarre: se ve por render o no se ve.



## Módulo 8 didáctico: las convenciones y el ejemplo antes de la regla (2026-08-28)

Pedido del alumno, textual: la parte de nodos cuesta, hace falta que estén bien
explicadas las convenciones de *cómo pensar las corrientes*, *cómo se escriben las
ecuaciones* y *cómo se cuentan las tensiones según el recorrido*; y que cada método
tenga un ejemplo sencillo pero no trivial, resuelto paso a paso, **antes** de pasar a la
definición general (antes de $G_(k j)$ y la matriz).

### El diagnóstico, que es lo que ordena el cambio

El módulo explicaba bien *qué* hace cada método y saltaba directo a la regla por
inspección. Lo que faltaba no era una explicación más: era el **orden**. La regla por
inspección es una compresión de algo que el alumno todavía no había visto descomprimido,
así que se leía como una receta arbitraria. Se invirtió el orden en los dos métodos:
convención explícita → un caso chico hecho a mano → recién ahí la generalización.

### Qué se agregó, por sección

- **8.1.2 — Las tres convenciones, antes de cualquier cuenta.** Definición con las tres
  decisiones arbitrarias del método nodal: (1) todas las corrientes se escriben
  *saliendo* del nodo; (2) la tensión de una rama es siempre "la mía menos la del otro",
  $v_k - v_j$, en ese orden; (3) de las dos sale $i_(k arrow.r j) = (v_k - v_j)\/R$.
- **La idea clave que faltaba: en nodal no se recorre nada.** Es la respuesta directa a
  "las tensiones según el recorrido". El recorrido desapareció porque las incógnitas
  pasaron a ser *potenciales* —un número pegado al nodo, no al camino—, que es
  exactamente lo que se compró al elegir la referencia: la LKT queda pagada por
  adelantado. Si estás recorriendo un lazo mientras hacés nodos, mezclaste los métodos.
- **Tabla 1** — traducción rama por rama: qué se escribe para cada cosa que cuelga del
  nodo $k$, y de qué lado de la igualdad va.
- **Caja de cuidado** con los tres errores de signo por frecuencia: dar vuelta la resta a
  mitad de la misma ecuación, pasar un resistor al lado derecho, y "arreglar" el dibujo
  cuando una corriente da negativa.
- **8.1.3 — Ejercicio 8.1, un nodo, tres ramas, una ecuación.** Figura nueva
  `fig-nodal-primero`. 12 V + $R_1 = 4 Omega$ / $R_2 = 2 Omega$ a masa / fuente de 3 A.
  Da $v_1 = 8$ V con números enteros, e $i_1 = -1$ A: el signo negativo aparece a
  propósito, para que la lectura del signo sea parte del ejercicio y no una advertencia
  abstracta. Cierra con LKC y con Tellegen (36 W entregados contra 36 W disipados).
- **8.3.2 — Las convenciones del método de mallas**, con el contraste explícito: acá *sí*
  hay recorrido, porque una corriente de malla está pegada a un lazo y no a un punto.
  Incluye de dónde sale el menos del término compartido (dos mallas horarias recorren la
  rama común en sentidos opuestos), que es lo único del método que conviene entender en
  vez de memorizar. Más la Tabla 2, análoga a la Tabla 1.
- **8.3.3 — Ejercicio 8.4, las dos ecuaciones paso a paso por el recorrido.** Mismo
  circuito del 7.2, recorrido tramo por tramo con viñetas, hasta que el patrón de la
  matriz (diagonal = perímetro, fuera de la diagonal = compartida con menos) **sale
  solo** del recorrido en vez de estar impuesto. El ejercicio siguiente lo rehace por
  inspección, y ahora esa regla se lee como un atajo de algo ya visto.
- **Supernodo y supermalla**: el paso 1 de los dos ejercicios pasó de dar la ecuación
  hecha a narrar de dónde sale cada término con la misma convención.

### Efectos colaterales, todos verificados en el render

- La figura de mallas se movió: antes venía después de la regla por inspección, ahora
  antes, junto al recorrido a mano.
- Renumeración: los ejercicios del módulo pasaron de 6 a 8. La referencia "Fue el
  Ejercicio 8.3" quedó apuntando a otro lado y se corrigió a 8.5.
- **Referencia que ya estaba mal antes de esta sesión**: el texto decía "en la sección
  8.6 el mismo circuito sale con una sola ecuación", y esa sección es la 8.7. Corregido.
  Es el caso exacto que avisa el contrato del proyecto: las referencias cruzadas de texto
  plano no las valida el compilador.
- El chequeo "toda figura de la biblioteca está en la galería" se probó **rompiéndolo**:
  se sacó `fig-nodal-primero` de `galeria.typ` y se lo vio en rojo nombrando la figura;
  después se restauró y volvió a verde.
- Las cinco páginas nuevas (52 a 59 del PDF) se miraron compiladas, no solo compiladas
  sin error.

## Módulo 14 — el amplificador operacional, con módulo propio (2026-08-30)

**Cerrada.** El apunte pasó de 107 a **123 páginas**. El operacional dejó de ser la
segunda mitad del Módulo 13 y tiene módulo propio, de 26 páginas.

### Por qué se movió en vez de ampliarse donde estaba

El Módulo 13 se llamaba «Cuadripolos y amplificador operacional» y le dedicaba al
operacional unas seis páginas: las dos reglas, inversor y no inversor con un párrafo cada
uno, y **una tabla de siete configuraciones "que hay que saber de memoria"**. Esa tabla
era el problema: pedía memorizar el resultado de una deducción que entra en tres
renglones, y que además es *la misma* deducción para las nueve.

Ampliarlo en su lugar habría dejado un módulo donde el cuadripolo —que es un tema
completo— quedaba de prólogo a otro cuatro veces más largo. Se movió entero, y el
Módulo 13 cierra ahora con una sección que explica *por qué* el operacional está aparte:
no se resuelve con el álgebra de cuadripolos sino con el análisis nodal del Módulo 8, así
que pertenece a otra familia de herramientas.

No quedó contenido duplicado: la sección vieja se borró del 13, no se copió.

### Lo que el módulo hace distinto

Sigue el patrón que se estrenó en el Módulo 8 el 2026-08-28 y que Fran confirmó que le
sirvió: **convenciones antes de cualquier cuenta → un caso mínimo hecho a mano → la regla
general → los casos que rompen el método.** Traducido al operacional:

1. *Relato antes que fórmula.* El operacional contado como una persona con dos
   termómetros y una perilla, y la pregunta que decide todo: ¿girar la perilla cambia lo
   que marcan los termómetros? Los tres casos posibles de esa pregunta **son** los tres
   circuitos del módulo: realimentación negativa, comparador y Schmitt.
2. *El cortocircuito virtual se deduce, no se declara.* Se parte de
   $v_d = v_o \/ A_"ol"$ —que es exacta y vale siempre— y se le pide al circuito una sola
   condición: que $v_o$ esté acotada. La conclusión que se busca es que el cortocircuito
   virtual **no es una propiedad del componente sino el punto de equilibrio del lazo**.
3. *El test de tres preguntas*, que es la parte operativa: ¿hay camino de la salida a una
   entrada? ¿a cuál pata llega? ¿el $v_o$ que dio la cuenta entra en la alimentación? Las
   tres se contestan mirando el dibujo, y la tercera es la que más se saltea.
4. *Las nueve configuraciones se deducen con el método de nodos del Módulo 8*, con un
   procedimiento de cinco pasos, en vez de listarse como fórmulas. La tabla de "las que
   faltan" quedó, pero explícitamente marcada como material de consulta.
5. *Una sección entera para los tres casos donde la Regla 1 es falsa*, que es lo que el
   apunte no tenía: sin realimentación (comparador), realimentación positiva (Schmitt) y
   realimentación negativa pero saturado. El tercero es el traicionero, porque las
   preguntas 1 y 2 dan bien.

### Las diez figuras nuevas

Recicladas de `teoria-circuitos/fuente/ao.typ` —los esquemáticos del Pre-Lab de
operacionales, ya depurados— y adaptadas a los helpers de este apunte. Cuatro venían de
ahí (seguidor, inversor, no inversor, sumador) y seis son nuevas: anatomía del símbolo,
lazo abierto, restador, integrador/derivador, comparador/Schmitt e instrumentación.

La geometría vive en ocho constantes (`ao-cx`, `ao-ym`, …) que **son las medidas del
símbolo `opamp` de zap**, no números elegidos a ojo. Eso se pagó en el render: con el
centro en 3,0 el rótulo del nodo virtual salía estrangulado contra el triángulo en *seis*
figuras a la vez, y se arregló cambiando una constante.

### Verificación

- Los cinco chequeos de `verificar.py`, en verde, con las 55 figuras en la galería.
- **Las diez figuras se miraron renderizadas a PNG, en cuatro rondas.** La primera tenía
  cuatro defectos que el compilador no ve: una masa dibujada hacia arriba que salía con
  el triángulo invertido, dos fuentes apiladas en la misma vertical que se leían como una
  rama en serie, dos rótulos `R_1` superpuestos, y el amplificador de instrumentación con
  cuatro resistores en diagonal y los rótulos encimados.
- Cuatro páginas del apunte compilado (98, 102, 110, 117) miradas en PNG. De ahí salieron
  tres correcciones tipográficas que caían en trampas ya documentadas en el `HANDOFF`:
  `mu "V"` con espacio, y rayas largas pegadas a matemática (`dif t$—` se lee `dt−`).
- `compilar.bat` probado **en los dos caminos**: sin `typst` en el PATH da el error
  explicando cómo instalarlo y sale con código 1; con `typst` regenera el PDF (timestamp
  y tamaño verificados) y lo abre.

## Módulos 10 y 15 — bobinas, capacitores, RL/RC/RLC y SPICE (2026-09-04)

**Cerrada.** El apunte pasó de 123 a **149 páginas**. Entra el material que pasó el
profesor de Teoría de Circuitos (UNSAM, Gabriel Sanca): la filmina *Bobinas, capacitores
y circuitos dinámicos* (52 diapositivas), la guía asincrónica con doce problemas de
Nilsson-Riedel capítulos 6, 7 y 8, y seis archivos de LTspice.

### Qué se agregó al Módulo 10 (de 8 a 21 páginas, de 2 a 8 ejercicios)

| Sección nueva | De dónde sale | Por qué entra |
|---|---|---|
| Las relaciones $v$–$i$, **vistas** | filminas 4–11, problemas 6.1 / 6.2 / 6.17 | La derivada y la integral se leían rápido en el papel y no se veían en una forma de onda |
| Energía: quién la guarda y quién la quema | filmina 32, problemas 7.4 / 7.8 / 7.21 / 7.25 | La energía decae como $e^{-2t/\tau}$ y el apunte no lo decía: es el error que la guía marca cuatro veces |
| Inductancia mutua y marcas de punto | filminas 14–15 | No estaba **en ningún lado** del apunte; el transformador del Módulo 3 se explicaba sólo por relación de vueltas |
| Cómo se saca $R_\text{th}$ sin equivocarse | filmina 30 | Faltaba el caso con fuentes dependientes (fuente de prueba) |
| Entrada cero y estado cero | filmina 31 | Es la partición que hace falta cuando la excitación no es constante |
| El RLC **paralelo** | filmina 39 | Estaba en un paréntesis. Y el sentido de $\alpha$ es **inverso** al del serie, que es donde se equivoca todo el mundo |
| Las dos constantes: de dónde salen | filmina 44, problema 8.38 | El apunte daba las tres formas y nunca decía cómo se determinan $A_1$, $A_2$ |
| Qué se mide en la pantalla | filmina 48 | $T_d$, sobrepico y decremento logarítmico: el camino inverso del cálculo |
| Diseño inverso: $R_\text{crít}$ | filmina 47 | Serie $2\sqrt{L/C}$, paralelo $\frac{1}{2}\sqrt{L/C}$ |
| Los componentes reales | segunda pasada de la guía | DCR, ESR, ESL, fuga, $R_\text{out}$, con qué arruina cada uno |
| Cinco errores de primer orden + laboratorio de $\tau$ | filminas 34–35 | |

### Módulo 15 — Simulación con SPICE (nuevo)

Va **al final de la Parte II** y no después del 10, a propósito: agregarlo en el medio
habría renumerado los módulos 11 a 14, y hay **21 referencias de texto plano** a esos
números que el compilador no valida. Al final no renumera nada, y además puede referirse
a todos los módulos anteriores, que es lo que hace: es el banco de pruebas de los catorce.

Cubre origen de SPICE (Berkeley 1973, Nagel bajo Pederson, sucesor de CANCER), netlist,
los cuatro análisis, `PULSE` y `PWL` parámetro por parámetro, `.ic` y `uic`, el paso de
integración, `.step`, `.meas`, los cinco controles, los parásitos y una tabla con los
seis archivos de la cátedra y qué hay que controlarle a cada uno.

### Un dato de la guía que no cierra, y está anotado en el apunte

En `05_RLC_serie.asc` la lista de `.step` incluye **632,46 Ω** como valor crítico. Con los
valores de ese mismo archivo —$L = 1$ mH, $C = 100$ nF— el crítico del RLC serie es
$2\sqrt{L/C} = 200\ \Omega$; **632,46 Ω es $2\sqrt{L/C}$ para $L = 10$ mH**, que es la
inductancia del archivo *paralelo*. Tal como está, ese caso sale sobreamortiguado con
$\zeta = 3{,}16$.

El circuito paralelo sí está bien: con $L = 10$ mH y $C = 100$ nF,
$\frac{1}{2}\sqrt{L/C} = 158{,}11\ \Omega$, que es el valor de su lista.

Está escrito en el apunte como caja de **cuidado** en la sección de `.step`, con la cuenta
hecha y la invitación a recalcularla, no como una corrección a la cátedra. Es el ejemplo
del propio criterio del módulo: a un valor de una lista ajena se le hacen las cuentas
antes de usarlo.

### Las 17 figuras nuevas (de 55 a 72)

Esquemas: `fig-rl-primer-orden`, `fig-tres-instantes`, `fig-req-prueba`,
`fig-no-idealidades`, `fig-induccion-mutua`, `fig-rlc-serie-conmutado`,
`fig-rlc-paralelo`, `fig-spice-rc`, `fig-spice-rlc`.

Gráficos: `graf-tau-exponencial`, `graf-pulso-en-bobina`, `graf-pulso-en-capacitor`,
`graf-tres-regimenes`, `graf-subamortiguado-detalle`, `graf-energia-descarga`,
`graf-respuesta-completa`, `graf-paso-de-simulacion`.

Ayudante nuevo en `estilo.typ`: **`paneles-columna`**, para las formas de onda que
comparten el eje de tiempo. Lado a lado se pierde justo lo que el gráfico tiene que
mostrar —que el quiebre de la corriente cae encima del escalón de la tensión—.

### Cómo se verificó

- `verificar.py` en verde: 72 figuras en la galería, ningún rótulo largo adentro de los
  ejes, apunte y galería compilan.
- **La alarma se probó rompiéndola**: sacada `graf-tres-regimenes` de la galería, el
  chequeo 4 se puso en rojo y la nombró. Restaurada, vuelve a verde.
- **Render mirado página por página** en las 21 del Módulo 10, las 8 del 15 y los anexos
  nuevos. De ahí salieron cinco rayas largas pegadas a fórmula que se leían como signo
  menos, un menos binario con hueco, una barra sin paréntesis que se leía
  $(20/3{,}5)\cdot 10^5$, y dos micro sin espacio. Ninguna se veía en el fuente.
- Los seis `.asc` de la cátedra recalculados uno por uno: $\tau$, $\omega_0$, $f_0$ y
  $R_\text{crít}$. Cinco coinciden con el archivo; el sexto es el de 632,46 Ω.

## Pasada de lectura eléctrica de las 72 figuras (2026-09-04)

**Cerrada. Las 72, una por una, contra la pregunta "¿el circuito está bien?" —no "¿se
lee bien?"—, que es la que la pasada de legibilidad del 2026-08-23 no hacía.** Fue así
como apareció el D2 invertido del puente de Graetz: compilaba perfecto, se veía prolijo,
y esta pasada es la que existe para agarrar ese tipo de error.

**Método:** `typst compile biblioteca/galeria.typ "OUT/g-{p}.png" --ppi 110` (19
páginas), cada página mirada con el render completo y además con **recortes ampliados
por pixel** (Python + PIL, 3×–10×) sobre todo componente con polaridad: diodo, zener,
LED, BJT, entrada de operacional. En un diodo o zener eso significa identificar ánodo y
cátodo por la forma (triángulo ancho = ánodo, barra = cátodo) y trazar la corriente
convencional contra la polaridad de la fuente; en un BJT, contra qué terminal es C y
cuál E; en un operacional, a qué entrada vuelve la realimentación. En los ocho gráficos
de transitorios y fasores (Módulos 10 a 12) se rehicieron las cuentas con los valores
que el propio gráfico anota (constantes de tiempo, energías, el triángulo 60-80-100 del
diagrama fasorial) para confirmar que la curva dibujada es la que esas cuentas dan.

**Resultado: 0 corregidas.** Las 72 están bien. Ninguna requirió cambio. El detalle,
módulo por módulo (nombre → veredicto; sólo se explica el razonamiento donde no es
trivial):

| Módulo | Figuras (72) | Veredicto |
|---|---|---|
| 1 — Mediciones | `fig-conexion-instrumentos`, `fig-shunt`, `fig-multiplicadora`, `fig-multirrango` | bien — sin semiconductores, topología de shunt/multiplicador correcta |
| 2 — Señales | `fig-filtro-rc`, `graf-formas-de-onda`, `fig-bloques-osciloscopio`, `graf-respuesta-rc` | bien |
| 3 — Transformadores | `fig-transformador`, `fig-transformador-punto-medio` | bien — relación de espiras consistente con 220→12 V |
| 4 — Diodos | `graf-curva-diodo`, `fig-polarizacion-diodo`, `fig-led-limitadora`, `fig-proteccion-polaridad`, `fig-rectificador-media-onda`, `graf-media-onda`, `fig-rectificador-punto-medio`, `graf-onda-completa`, **`fig-puente-graetz`** | bien — ver detalle abajo |
| 5 — Fuentes | `fig-bloques-fuente`, `fig-filtro-capacitivo`, `graf-rizado`, `fig-regulador-zener`, `graf-curva-zener` | bien — ver detalle abajo (zener) |
| 6 — Transistores | `fig-simbolos-bjt`, `fig-conmutacion-npn`, `fig-rele-completo`, `graf-recta-de-carga` | bien — ver detalle abajo |
| 7 — Kirchhoff | `fig-nodos-y-mallas`, `fig-delta-estrella` | bien — sin semiconductores |
| 8 — Nodal y mallas | `fig-nodal-primero`, `fig-nodal-basico`, `fig-supernodo`, `fig-mallas-basico`, `fig-supermalla`, `fig-nodal-controlada` | bien — sin semiconductores, fuentes y CCCS consistentes |
| 9 — Teoremas | `fig-fuentes-reales` | bien |
| 10 — Transitorios | `fig-rc-primer-orden`, `fig-rl-primer-orden`, `fig-tres-instantes`, `fig-req-prueba`, `fig-no-idealidades`, `fig-induccion-mutua`, `fig-rlc-serie-conmutado`, `fig-rlc-paralelo`, `graf-tau-exponencial`, `graf-pulso-en-bobina`, `graf-pulso-en-capacitor`, `graf-tres-regimenes`, `graf-subamortiguado-detalle`, `graf-energia-descarga`, `graf-respuesta-completa` | bien — ver detalle abajo (los siete gráficos, recalculados) |
| 11 — Fasores | `fig-rlc-serie`, `graf-diagrama-fasorial` | bien — $V_R=60$, $V_L+V_C=80$, $\|V\|=100\angle 53{,}13°$ cierra exacto (triángulo 3-4-5 ×20) |
| 12 — Frecuencia | `fig-pasabajos-pasaaltos`, `graf-bode-amplificador` | bien |
| 13 — Cuadripolos | `fig-cuadripolo` | bien |
| 14 — Operacional | `fig-ao-terminales`, `fig-ao-lazo-abierto`, `fig-ao-seguidor`, `fig-ao-inversor`, `fig-ao-no-inversor`, `fig-ao-sumador`, `fig-ao-restador`, `fig-ao-integrador-derivador`, `fig-ao-comparador-schmitt`, `fig-ao-instrumentacion` | bien — ver detalle abajo |
| 15 — Simulación | `fig-spice-rc`, `fig-spice-rlc`, `graf-paso-de-simulacion` | bien |
| Anexos | `fig-codigo-colores`, `fig-tabla-simbolos` | bien |

**Lo que se verificó con recorte de pixel, y qué se encontró:**

- **`fig-puente-graetz`.** Es la que ya se había corregido el 2026-08-25 (D2 invertido).
  Se retrazó nodo por nodo: Izquierda/Derecha = terminales de CA (opuestos en el
  rombo), Arriba/Abajo = salida CC. Las cuatro condiciones que tiene que cumplir un
  puente ($D_1$: ánodo-Izq/cátodo-Arriba, $D_2$: ánodo-Der/cátodo-Arriba, $D_3$:
  ánodo-Abajo/cátodo-Izq, $D_4$: ánodo-Abajo/cátodo-Der) se comprobaron una por una con
  recortes a 10× — las cuatro cierran. La corrección de agosto sigue en pie.
- **`fig-proteccion-polaridad`, panel "en paralelo con fusible"** (candidata de riesgo
  por la lista del handoff anterior). A primera vista el diodo parecía con el ánodo
  arriba (hacia +12 V), que habría fundido el fusible en polaridad NORMAL. El recorte a
  8× mostró lo contrario: la barra (cátodo) está arriba, el triángulo (ánodo) abajo — en
  reversa queda polarizado inverso (no hace nada) y sólo conduce, fundiendo el fusible,
  si la fuente se conecta al revés. Es el comportamiento correcto de un diodo de
  protección tipo *crowbar*. El primer vistazo se equivocaba; el recorte lo corrigió.
- **`fig-regulador-zener`.** $D_Z$ con cátodo hacia el riel de $V_\text{in}$ y ánodo
  hacia el retorno: en reversa, que es el régimen en que un zener regula. $I_Z$ e $I_L$
  bajan en el sentido correcto de la corriente convencional. Bien.
- **`fig-conmutacion-npn` y `fig-rele-completo`** (las otras dos candidatas de riesgo).
  El NPN tiene C arriba (a la carga/$V_{cc}$) y E abajo (a masa) en las dos, con la
  flecha del emisor saliendo — configuración de llave de bajo lado, correcta. El diodo
  volante 1N4007 de `fig-rele-completo` tiene el cátodo hacia $+12\,\text{V}$ y el ánodo
  hacia el colector: en operación normal el colector está bajo (transistor saturado) y
  el diodo queda en reversa (no hace nada); cuando el transistor abre, la bobina invierte
  su polaridad y el diodo conduce, absorbiendo el pico inductivo. Es la disposición
  correcta de un diodo de *flyback*.
- **`fig-ao-instrumentacion`** (la figura más compleja del apunte). Las dos entradas
  ($v_1$, $v_2$) van al "+" de cada operacional de la primera etapa, y la realimentación
  de cada salida vuelve a su propio "−" — ninguna cruzada. El puente $R_3$–$R_G$–$R_3$
  conecta los dos "−". La tercera etapa reproduce exactamente la topología ya verificada
  de `fig-ao-restador` ($R_4$/$R_5$ en vez de $R_1$/$R_2$). Las cuatro configuraciones de
  operacional del Módulo 14 (seguidor, inversor, no inversor, sumador, restador,
  integrador/derivador, comparador/Schmitt) tienen la realimentación donde tiene que
  estar: negativa al "−" en las primeras siete, positiva al "+" sólo en el Schmitt
  (`fig-ao-comparador-schmitt`, panel derecho) y ausente en el comparador simple (panel
  izquierdo), que es exactamente lo que cada nombre promete.
- **Los siete gráficos de transitorios** (`graf-pulso-en-bobina`, `graf-pulso-en-capacitor`,
  `graf-tau-exponencial`, `graf-energia-descarga`, `graf-respuesta-completa`) se
  recalcularon con los números que el propio gráfico anota: en el pulso de bobina,
  $v_L=20\,\text{V}$ en la subida y $-10\,\text{V}$ en la bajada implican $L=20\,\text{mH}$
  en las dos rampas, y $E_L=\tfrac12 L i^2$ da 40 mJ en $t=2\,\text{ms}$, que es lo que el
  panel de energía muestra; en el pulso de capacitor, $C = 0{,}25$ µF cierra la
  subida a 4 V y la energía a 2 µJ por los dos caminos. En `graf-respuesta-completa`,
  entrada-cero ($8e^{-t/\tau}$) más estado-cero ($2(1-e^{-t/\tau})$) suman exactamente la
  completa ($2+6e^{-t/\tau}$) en los tres puntos que el gráfico marca.

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
