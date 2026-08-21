# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-08-21
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
