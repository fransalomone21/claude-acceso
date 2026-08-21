# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-08-21
**Rama:** `claude/apunte-electronica-analogica`
**Estado: APUNTE COMPLETO, CON FIGURAS VECTORIALES.** 44 páginas, los 6 módulos
redactados más anexos, y las 24 figuras que antes eran dibujos en ASCII ahora
dibujadas como vectores, más 6 gráficos nuevos.

## Qué es esto

Apunte teórico-práctico completo de la materia, fuente única en **Typst**, listo para
compilar a PDF. Destinatario: alumnos de 4.º año de la E.E.S.T. N.º 1 de Vicente López.

## Cómo se compila

```bash
cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf
```

Typst **0.15.1** instalado vía `winget install Typst.Typst`. No hace falta LaTeX ni
pandoc. Para trabajar con vista viva: `typst watch apunte.typ apunte.pdf`.

Los tres paquetes de dibujo (`cetz` 0.5.2, `zap` 0.6.0, `cetz-plot` 0.1.4) los baja
Typst solo la primera vez y quedan cacheados en
`%LOCALAPPDATA%\typst\packages\preview\`. **No hay nada que instalar a mano.**

## Cómo se verifica

```bash
cd electronica-analogica/apunte && python verificar.py
```

Cuatro chequeos, todos sobre efectos y **todos probados rompiéndolos a propósito**:
que el apunte compile, que la galería compile, que no haya quedado ningún circuito en
ASCII, y que toda figura de la biblioteca esté en la galería (una figura que nadie
mira se rompe sin que se entere nadie).

Para mirar las figuras sin compilar las 44 páginas:

```bash
typst watch biblioteca/galeria.typ biblioteca/galeria.pdf
```

## Contenido por módulo

| Módulo | Tema | Ejercicios resueltos | Figuras |
|---|---|---|---|
| 1 | Mediciones y expansión de rango | 5 | 4 |
| 2 | Señales periódicas e instrumental | 4 | 4 |
| 3 | Electromagnetismo y transformadores | 2 | 2 |
| 4 | Diodos y rectificación | 2 | 9 |
| 5 | Fuentes lineales (incluye zener) | 3 | 5 |
| 6 | BJT en conmutación y relés | 2 | 4 |
| — | Anexos: código de colores, series E12/E24, formulario, símbolos, seguridad | — | 2 |

Todos los módulos llevan: teoría con deducción explícita, ecuaciones numeradas y
referenciadas, **figuras vectoriales**, cajas de definición / idea clave / cuidado /
laboratorio, y una caja final que ata el módulo con el TP correspondiente.

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

**3. Se adoptó la notación de la cátedra, no la propia.** En expansión de rango:
$R_m$ = resistencia interna del galvanómetro, $I_m$ = corriente de deflexión a plena
escala, $R_S$ = shunt, $R_M$ = multiplicadora. El Módulo 1 se reescribió para alinearse
con el apunte oficial: si no, el alumno estudia con dos idiomas distintos.

## Evidencia (qué está confirmado y cómo)

- **Compila** → `apunte.pdf`, 44 páginas. Confirmado por ejecución.
- **26 de las 30 figuras se ven bien** → confirmado por render a PNG y lectura visual.
- **`graf-curva-diodo` está MAL y se publicó igual** (2026-08-21). Los dos rótulos largos
  —"tensión de ruptura" y "corriente de fuga"— están anclados a la izquierda del marco
  pero el texto corre hacia la derecha y cruza el eje vertical, encima de las marcas de
  10 y 20 mA; las dos líneas guía atraviesan el gráfico y se confunden con la curva.
- **Las figuras de las páginas 1 a 4 de la galería quedaron SIN reverificar** después de
  las dos últimas rondas de retoques. El render que se miró es anterior a esos cambios.
  Concretamente: todo el Módulo 1, `fig-filtro-rc`, `graf-formas-de-onda`,
  `graf-curva-diodo`, los dos transformadores, las seis de diodos y las dos de
  rectificación. Hay que mirarlas de nuevo antes de darlas por buenas.
- **Causa de los dos puntos anteriores, y lo que hay que cambiar**: los rótulos se ubican
  en coordenadas de DATOS, donde un mismo número significa distinto en cada gráfico (en
  la curva del diodo, 1 mA vertical son 3,5 pt y 0,1 V horizontal son 3 mm), y el texto
  no sabe cuánto mide, así que cruza el eje sin avisar. El arreglo no es correr rótulos a
  mano otra vez: es que adentro de los ejes solo entren marcas cortas y que el texto
  largo se ubique contra el marco del gráfico, en coordenadas de lienzo.
- **El verificador funciona** → confirmado rompiéndolo cuatro veces a propósito (error de
  sintaxis en un módulo, error de sintaxis en la galería, un bloque ASCII devuelto a su
  lugar, una figura definida sin agregar a la galería). Las cuatro dieron rojo, y verde
  de nuevo al restaurar.
- **Dos defectos de tipografía encontrados por render en la sesión anterior**, ya
  corregidos y con la regla puesta en `plantilla.typ` (coma decimal antes de `/`, y
  espacio detrás de la coma).

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
