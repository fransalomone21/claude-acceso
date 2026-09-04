# Handoff — próxima sesión

## Cuadro de fase para abrir el próximo chat

```
Fase     : FASE 3, tema 7 (simulación) CERRADO el 2026-09-04, junto con una
           ampliación grande del Módulo 10. El apunte pasó de 123 a 149
           páginas y de 14 a 15 módulos. Entró el material del profesor de
           Teoría de Circuitos: filminas de bobinas y capacitores (52
           diapositivas), guía asincrónica con doce problemas de
           Nilsson-Riedel caps. 6, 7 y 8, y seis archivos de LTspice.
           Módulo 10: de 8 a 21 páginas, de 2 a 8 ejercicios. Secciones
           nuevas: relaciones v-i vistas como formas de onda, balance de
           energía, inductancia mutua y marcas de punto (no estaba en NINGUNA
           parte del apunte), R_th con fuente de prueba, entrada cero /
           estado cero, RLC paralelo con su alfa inverso, las dos constantes,
           diseño inverso, componentes reales.
           Módulo 15 nuevo (SPICE), al FINAL de la Parte II a propósito:
           meterlo en el medio habría renumerado 11 a 14 y hay 21
           referencias de texto plano a esos números que nadie valida.
           17 figuras nuevas (55 -> 72). Ayudante nuevo: `paneles-columna`.
           verificar.py en verde y PROBADO ROMPIÉNDOLO. Render mirado página
           por página en el 10, el 15 y los anexos nuevos.
           Detalle: ESTADO_ACTUAL.md, sección "Módulos 10 y 15".

           **PASADA DE LECTURA ELÉCTRICA de las 72 figuras: CERRADA el
           2026-09-04.** Las 72, una por una, contra "¿el circuito está
           bien?" (no "¿se lee bien?", que es otro chequeo y ya estaba
           hecho). Recorte de pixel sobre todo diodo/zener/LED/BJT/entrada
           de operacional, y recálculo de los siete gráficos de transitorios
           y del diagrama fasorial contra sus propios números. Resultado:
           **0 corregidas** — confirma el Graetz de agosto y revierte un
           falso positivo propio sobre `fig-proteccion-polaridad` (a primera
           vista el diodo de protección parecía al revés; el recorte mostró
           que está bien). Detalle figura por figura: ESTADO_ACTUAL.md,
           sección "Pasada de lectura eléctrica de las 72 figuras".

           Lo que sigue, en orden de valor:
           (b) los seis temas que quedan de la Fase 3 (ver PDP);
           (c) mirar en render las páginas del Módulo 14 que NO se miraron
               —se vieron cuatro de veintiséis: 98, 102, 110 y 117—.
Modelo   : Opus para (b), que es escribir teoría nueva y decidir cómo se
           deduce. Sonnet 5 para (c), que es mirar imágenes contra un
           criterio ya escrito.
Esfuerzo : medio, sin fan-out. Un archivo por vez, secuencial: el fan-out no
           compra nada acá y el presupuesto del plan sí lo paga.
Contexto : chat nuevo — esta sesión gastó su contexto en recortes de pixel
           uno por uno; (b) es escribir teoría nueva y arranca mejor fresca.
Retomar  : ver el bloque al final de esta respuesta.
Rama     : main — una sola rama, el proyecto es una carpeta.
```

## Lo que quedó abierto, y no se puede perder

- **Los seis `.asc` de la cátedra no se corrieron**: se leyeron como texto y se
  recalcularon a mano. No hay LTspice instalado en esta máquina, y el apunte no lo
  necesita para ser correcto —pero si alguna vez se corren, el control está escrito
  en la tabla «Los seis circuitos de la guía» del Módulo 15.
- **El valor de 632,46 Ω** de `05_RLC_serie.asc` no cierra con los valores de ese
  archivo (ver ESTADO_ACTUAL). Está anotado en el apunte como caja de cuidado, con la
  cuenta hecha. Si Fran lo consulta con el profesor y hay una explicación, hay que
  volver a esa caja.
- **La figura de cuatro paneles del pulso en la bobina** no entra al pie de una página
  y deja un tercio en blanco en la página anterior. Se probó achicarla a 0,98 de alto
  por panel y **sigue sin entrar** (mide 11,9 cm y el hueco es de 8,4): achicarla más
  sólo empeora la legibilidad sin arreglar nada. Se dejó en 1,25, que es el tamaño
  legible. No volver a intentarlo sin medir primero.

## Lo primero que hay que hacer

1. `cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf` — confirmar
   que sigue compilando antes de tocar nada.
2. Leer `ESTADO_ACTUAL.md`, en particular las cinco decisiones de contenido y la
   sección de los ocho defectos ya corregidos (para no reabrirla).

## Trampas de Typst ya pagadas — no volver a pisarlas

- **Raya larga pegada a una fórmula**: `—$v arrow.l.r i$` compone la raya a la altura
  del eje matemático y con el largo de un menos, y se lee `−v ↔ i`. Es el mismo caso
  que el de `$+$—` de más abajo, pero con una variable cualquiera y no sólo con un
  signo. Salida: paréntesis, o comas. Se ve en el render, nunca en el fuente; volvió
  a pasar el 2026-09-04 en cinco lugares del Módulo 10.
- **Coma decimal antes de `/`**: `16,3/1000` se dibuja como "16" más la fracción 3/1000.
  Escribir siempre `(16,3)/(1000)` con paréntesis.
- **Coma decimal dentro de una función**: `sqrt(1000^2 + 99,5^2)` es un error de sintaxis
  (la coma separa argumentos). Usar `"99,5"` entre comillas. Vale igual para `mat()`,
  donde además la coma es el separador de *columnas*: `mat("0,75", -"0,25"; ...)`.
- **Espacio detrás de la coma**: ya está resuelto globalmente en `plantilla.typ` con una
  regla `show ","` que la reclasifica como átomo normal. No borrar esa regla.
- **Signo menos detrás de `angle`**: se compone como operador binario y queda
  `60 ∠ − 53,13°`. Meter el número en una cadena con el menos tipográfico:
  `angle "−53,13" degree`.
- **Unidades con micro**: `6667 mu "F"` sale con espacio feo. Escribir `"6667 µF"`.
- **Raya larga pegada a un `$+$` o un `$-$`**: `por el borne $+$—, total` se compone
  como `+—` y se lee como un `±` o como un menos suelto. Pasó en el Ejercicio 8.1 y se
  vio en el render, no en el fuente. Salida: nombrar el borne en palabras ("por el borne
  positivo") o separar la raya con otra puntuación. Vale igual para las rayas alrededor
  de números: "la diagonal —6 y 10—" se lee "−6 y 10−"; poner paréntesis.
- **`v_square` no es un subíndice**: dibuja un cuadrado vacío. Usar `v_"cuad"`.
- **Etiquetas de ecuación repetidas**: Typst falla al compilar. `<ec-fc>` ya está tomada
  por el Módulo 2; la del Módulo 12 es `<ec-fc-rc>`.
- **Ángulo negativo escrito como cadena**: `angle "−53,13" degree` mete un espacio detrás
  del símbolo de ángulo, y si el número *no* tiene coma decimal mete otro delante del
  grado (`2∠ −90 °`). Va con el ayudante `ang(...)` de `plantilla.typ`:
  `$60 angle ang("−53,13°") thin "V"$`. Usa `math.class("unary", ...)`, que es la única
  clase que anda con coma y sin coma.
- **Referencias `@ec-...` entre módulos distintos**: no sirven. El contador de ecuaciones
  se reinicia en cada `#modulo(...)`, así que "Ecuación 4" desde otro módulo no lleva a
  ningún lado. Se cita por nombre de módulo o de sección.
- **Fórmulas largas en el anexo**: se pisan con el número de ecuación, y ninguna alarma lo
  agarra. Se parten en dos ecuaciones. Volvió a pasar el 2026-08-25.
- **Sección de nivel 1 sin número**: `heading(level: 1, numbering: none)` **no incrementa**
  el contador, que es justo lo que hace falta para meter las convenciones al frente sin
  correr los módulos. Pero adentro no van headings de nivel 2 ni 3 (saldrían "0.1"), y
  hay que ramificar tanto el `show heading.where(level: 1)` como el encabezado de página:
  pedirle `counter(heading).display()` a un heading sin número devuelve el del módulo
  anterior. Ya está hecho: el ayudante es `seccion(...)`.
- **Encabezado de página**: no usar `.before(here())` para saber en qué módulo se está —
  no ve el título que arranca en esa misma página y el encabezado sale con el módulo
  anterior. La plantilla filtra por número de página; está resuelto, no revertirlo.
- **No hay poppler en la máquina**: la herramienta Read no abre PDFs. Para leer uno,
  extraer texto con `pypdf` — ver `fuentes/_extraer.py`.
- **Verificar por render, no por compilación.** `typst compile apunte.typ "chk-{p}.png"
  --ppi 100 --pages N` y mirar la imagen. Los siete defectos que se encontraron habrían
  pasado desapercibidos mirando solo el fuente, y el PDF compilaba igual en todos los
  casos.

### De las figuras

Las seis trampas de `zap`/CeTZ están en [`docs/figuras.md`](docs/figuras.md), sección 6,
con el síntoma exacto de cada una. Las dos que más cuestan:

- `wire(..., i: ...)` aborta la compilación en zap 0.6.0. Usar el ayudante `corriente()`.
- Las patas del transistor no están alineadas con su punto de inserción: todo lo que
  cuelga de un BJT va con coordenadas relativas a `"Q.c"` / `"Q.b"` / `"Q.e"`.

Una más, pagada el 2026-09-04: un `wire` de **menos de 0,5 unidades** rompe CeTZ con
el mismo error del `wire` de longitud cero. Medido: 0,35 rompe, 0,5 anda. Está en
`docs/figuras.md`, sección 6, arriba de todo.

Cuatro más, pagadas el 2026-08-30 con las figuras del Módulo 14:

- **Un `wire` de longitud cero rompe CeTZ** con un error que no dice nada del wire:
  `inequality assertion failed: value none was equal to none`, en `anchor.typ:186`. Pasó
  al escribir `wire((6.5, y), (7.4 - 0.9, y))`, donde la aritmética daba justo 6,5. Si
  aparece ese mensaje, buscar dos coordenadas que den lo mismo, no un anchor mal escrito.
- **El largo mínimo de un resistor es 1,7**: su cuerpo mide 1,41 unidades y es fijo. Un
  tramo más corto no lo comprime, lo hace desbordar sus terminales.
- **Una fuente pegada a un resistor se superponen**: el círculo tiene radio 0,4 y el
  cuerpo del resistor empieza a 0,15 de su terminal. Va medio punto de cable en el medio.
- **`ground(..., angle: 180deg)` sale con el triángulo invertido** y se lee como otro
  símbolo. Las masas van siempre hacia abajo, aunque el nodo esté arriba del dibujo.

### De método

- **Verificar por render, no por compilación.** Todos los defectos de figura que
  aparecieron compilaban perfecto. Mirar el PNG:
  `typst compile biblioteca/galeria.typ "biblioteca/_g{0p}.png" --ppi 120`.
- **Nada de `str.replace('', ...)` para editar un archivo.** Un slice mal acotado
  (`s[s.index(a):s.index(b)]` con `b` antes que `a`) devuelve cadena vacía, y
  `replace("")` inserta el texto entre *cada* carácter del archivo. Pasó una vez y hubo
  que reescribir `graficos.typ` entero. Si se edita con script: verificar que el trozo
  buscado exista y sea único, y afirmarlo con `assert` antes de reemplazar.

## Cómo se agrega o edita contenido

Un archivo por módulo en `apunte/modulos/`. `m1-mediciones.typ` es el modelo canónico de
la Parte I y `m8-nodos-mallas.typ` el de la Parte II: apertura con `#modulo(...)`, teoría
con deducción explícita, ecuaciones etiquetadas `<ec-...>` y referenciadas con `@ec-...`,
cajas `#definicion` / `#clave` / `#atencion` / `#laboratorio`, ejercicios con `#ejercicio`,
circuitos con `#circuito(...)` en ASCII, y cierre con `#tp(...)`. La numeración de
ejercicios, ecuaciones y figuras se reinicia sola en cada `#modulo(...)`: no agregar
contadores a mano. Los divisores de parte se ponen desde `apunte.typ` con `#parte(n, ...)`.

**Circuitos en ASCII**: se dibujan contando columnas, no a ojo. Para el triángulo del
amplificador operacional, el criterio que funciona es fijar la columna de la barra
vertical y hacer que la diagonal avance exactamente una columna por fila.

## Decisiones ya tomadas — no reabrir

- **El apunte NO resuelve los TPs.** Confirmado por Fran el 2026-08-16: las
  resoluciones las hace él. El apunte aporta el *sustento teórico* y ejercicios
  *análogos* con los mismos números, como modelo de resolución. No agregar soluciones
  de los prácticos.
- **El destinatario primario es el docente**, y en segundo lugar los alumnos. De ahí el
  peso puesto en las deducciones completas (de dónde sale cada fórmula) por encima de la
  ejercitación.
- **La Parte I no se reordena.** Sigue el temario y las guías de TP, y cada módulo cierra
  con su práctico. La Parte II va en el orden de Teoría de Circuitos. Las dos secuencias
  están publicadas en el anexo 14.3.
- **Las citas a los TP se verifican contra las guías, nunca de memoria.** El listado real
  es: TP 0 Mediciones · TP 1 Errores · TP 2 Multímetro serie · TP 3 Multímetro paralelo ·
  TP 4 Análisis de señales · TP 5 Osciloscopio · TP 6 Polarización del diodo ·
  TP 7 Fuentes de alimentación · TP 8 Fuente con regulador zener · Anexo 1 PT100 en
  puente. **No hay ningún TP de filtro RC**, contra lo que decía este handoff antes.
- **La fila del proyecto ya está en la tabla del `CLAUDE.md` raíz.**

## Pendientes explícitos

- ~~**La conversión de fasores a valor de pico** en los módulos 11 y 12.~~ **HECHA el
  2026-08-25.** Ver `ESTADO_ACTUAL.md`, sección "Fase 2".
- ~~**PASADA DE LECTURA ELÉCTRICA de las figuras.**~~ **HECHA el 2026-09-04, las 72.**
  El 2026-08-25 apareció que `fig-puente-graetz` tenía el D2 al revés: en el semiciclo
  positivo D1 y D2 quedaban en serie y en directa, cortocircuitando la fuente por un
  camino de menor resistencia que la carga. Esa vez lo encontró Fran mirando, no ningún
  chequeo, porque las figuras estaban verificadas de LEGIBILIDAD —¿se lee bien?— y nunca
  de corrección eléctrica —¿el circuito es correcto?—. La pasada de las 72 (recorte de
  pixel sobre cada semiconductor y entrada de operacional) confirma esa corrección y no
  encontró ninguna nueva. Detalle: `ESTADO_ACTUAL.md`, sección "Pasada de lectura
  eléctrica de las 72 figuras".
- ~~**15 circuitos en ASCII** en los módulos 7 a 13, enumerados en `ASCII_PENDIENTE`.~~
  **HECHO el 2026-08-23.** Las 15 están dibujadas, `ASCII_PENDIENTE` se borró y el
  chequeo 3 volvió a ser un rojo simple. En su lugar quedó pendiente otra cosa: los
  **ocho defectos de la Parte I** que encontró la pasada completa (ver
  `ESTADO_ACTUAL.md`).
- **Los temas del programa que faltan** — la lista completa está en `ESTADO_ACTUAL.md`,
  sección "El programa real de Teoría de Circuitos".
- **Nadie leyó el Nilsson-Riedel todavía.** Fran lo tiene en Descargas; ninguna sesión
  en la nube puede abrirlo, porque corre en un contenedor y no ve su disco. La
  convención de pico se adoptó porque es la de los cuatro libros de la cátedra, pero
  **conviene que Fran lo confirme** mirando cómo define la transformada fasorial y si
  la potencia media aparece como ½·Vm·Im·cosθ o como Vef·Ief·cosθ.
- **Los circuitos son vectores pero los gráficos cuantitativos todavía no existen.**
  Bode con décadas reales, plantillas de filtro y mapas de polos y ceros van en
  matplotlib, y todavía no hay ninguno.
- **Sin verificar contra el apunte interactivo** de Moodle de la E.E.S.T., que sigue sin
  poder leerse, ni contra el campus de Teoría de Circuitos.
- **Los anexos figuran como "Módulo 14"** porque usan el mismo `#modulo(...)` que el
  resto. Con seis módulos molestaba poco; con trece se nota. Si se le quiere sacar el
  número, hay que agregarle un parámetro a `#modulo` en la plantilla.

## Entorno: compilar en una sesión en la nube

`packages.typst.org` está **bloqueado** por el proxy de egreso, así que Typst no puede
bajar `cetz`, `zap` ni `cetz-plot` y **no compila nada**. Tampoco hay binario `typst`
en el PATH.

Se resuelve armando un caché de paquetes a mano, una vez por sesión:

```bash
pip install typst pypdf
git clone --filter=blob:none --sparse --depth 1 https://github.com/typst/packages tp
cd tp && git sparse-checkout set \
  packages/preview/cetz/0.5.2 packages/preview/zap/0.6.0 \
  packages/preview/cetz-plot/0.1.4 packages/preview/oxifmt/1.0.0
# y copiar cada packages/preview/<n>/<v> a  <CACHE>/preview/<n>/<v>
```

`raw.githubusercontent.com` y `github.com` por clone **sí** son alcanzables; la API y
`codeload` no. `oxifmt` es dependencia transitiva de cetz y hay que bajarla también.

Después, todo va con `package_cache_path`:

```python
typst.compile("apunte.typ", output="apunte.pdf", package_cache_path=CACHE)
```

`verificar.py` ya lo contempla: si no encuentra el binario cae al módulo de Python y
lee la ruta de `TYPST_PACKAGE_CACHE`. En la máquina de escritorio no hace falta nada
de esto y todo sigue funcionando como antes.

---

## Plan de fases

**Vive en [`PDP.md`](PDP.md), no acá.** Estaba escrito en este archivo y
divergió: seguía pidiendo los 15 circuitos en ASCII de la Parte II que se
habían eliminado el 2026-08-23. Un dato que vive en dos lados diverge, y el
criterio de salida de la fase en curso es justamente lo que el PDP existe para
guardar.

Hoy: **Fase 3 — Los temas que faltan del programa**, en curso. Los siete temas,
que la cierra exactamente y el pendiente de la lectura eléctrica de las 46
figuras: PDP, sección 4.

## Lo que NO hay que rehacer

- **Las 15 figuras de la Parte II** (módulos 7 a 13) están dibujadas y verificadas por
  render el 2026-08-23, en una pasada completa posterior al último retoque.
- **Los ayudantes de notación de `estilo.typ`** —`marca-nodo`, `nodo-referencia`,
  `giro-malla`, `recuadro-super`, `rotulo`, `valor`— ya están y se usan en cinco
  figuras. No inventar una notación nueva por figura.
- **El Bode en matplotlib** ya está resuelto, con la tipografía del apunte y con la
  alarma que aborta si la reescritura de fuente falla. No volver a intentarlo en
  cetz-plot.
- **Las 45 figuras están verificadas por render, pasada completa de las 12 páginas
  de la galería, posterior al último retoque (2026-08-23).** Incluye los ocho
  defectos de la Parte I (`graf-curva-diodo`, `graf-curva-zener`, `graf-media-onda`,
  `graf-onda-completa`, `graf-respuesta-rc`, `graf-rizado`, `fig-bloques-osciloscopio`,
  `fig-led-limitadora`, `graf-recta-de-carga`), ya corregidos — no reabrirlos sin
  render nuevo que muestre un defecto concreto.
- El sistema de anotación ya está rediseñado: `rotulo-marco` dibuja fuera del plot.
  No volver a acomodar rótulos a mano en coordenadas de datos. Y si un `rotulo-marco`
  lleva `hacia` (guía): la guía cruza el rótulo cuando su pendiente es más chica que
  el cociente alto/ancho de la caja de texto. Antes de agregar una guía a un rótulo
  ancho, preguntar si el punto ya está marcado por otro medio adentro del plot — si sí,
  no hace falta.
- Typst contra LaTeX: decidido y documentado en `docs/figuras.md`. No reabrir.
- El merge de las dos ramas ya está hecho. Es un solo documento y una sola biblioteca.
- **El convenio de fasor en valor de pico y su tabla de equivalencia a eficaz** están
  escritos y verificados. No reabrir la discusión pico/eficaz: la decisión es de Fran y
  la ejecución está hecha. Lo único que sigue abierto es que Fran confirme contra el
  Nilsson-Riedel de sus Descargas (ver "Pendientes explícitos").
- **La aritmética de los ejercicios 11.1, 11.2, 11.3 y 12.2** está comprobada por dos
  caminos independientes y corrida en Python el 2026-08-25. No rehacerla sin un motivo
  concreto.
