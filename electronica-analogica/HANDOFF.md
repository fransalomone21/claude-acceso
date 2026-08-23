# Handoff — próxima sesión

## Cuadro de fase para abrir el próximo chat

```
Fase     : Fase 1 CERRADA en las dos partes (apunte completo, 97 pág., 13 módulos
           más anexos; compila y verificado por render página por página).
           Lo que sigue es Fase 2 — revisión pedagógica con el apunte usado en
           clase. La cierra: Fran dicta al menos un módulo de cada parte y marca
           qué falta o qué sobra.
Modelo   : Sonnet 5 para ajustes de redacción y agregados menores.
           Opus solo si hay que agregar deducciones nuevas.
Contexto : chat nuevo. El apunte está en el repo y se lee solo; arrastrar
           este contexto no aporta nada.
```

## Lo primero que hay que hacer

1. `cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf` — confirmar
   que sigue compilando antes de tocar nada.
2. Leer `ESTADO_ACTUAL.md`, en particular las cinco decisiones de contenido.

## Trampas de Typst ya pagadas — no volver a pisarlas

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
- **`v_square` no es un subíndice**: dibuja un cuadrado vacío. Usar `v_"cuad"`.
- **Etiquetas de ecuación repetidas**: Typst falla al compilar. `<ec-fc>` ya está tomada
  por el Módulo 2; la del Módulo 12 es `<ec-fc-rc>`.
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

## Pendientes de la sesión de figuras

- **PRIMERO: `graf-curva-diodo` está roto y publicado.** Ver ESTADO_ACTUAL.md. Y las
  figuras de las páginas 1 a 4 de la galería no se reverificaron después de los últimos
  retoques: el render que se miró es anterior a esos cambios.
- **El sistema de anotación de los gráficos hay que cambiarlo, no parchearlo.** Rótulo
  largo adentro de los ejes = bomba de tiempo. Regla nueva: adentro sólo marcas cortas
  (un número, una letra, "0,7 V"); el texto largo va contra el marco, en coordenadas de
  lienzo, con una línea guía al punto. Y `verificar.py` tiene que fallar si un `nota(` o
  `flecha-nota(` adentro de un `plot.annotate` lleva más de ~18 caracteres — ese chequeo
  habría agarrado exactamente los dos rótulos que se rompieron. Probarlo rompiéndolo.
- **Sin verificar contra el apunte interactivo** de Moodle, que sigue sin poder leerse.
- **Retoques finos de figura que quedaron aceptables pero no perfectos**: en
  `graf-respuesta-rc` la punta de flecha del eje x roza el rótulo `f/f_c`; en
  `graf-curva-zener` el rótulo `V_Z` queda muy cerca del eje. Ninguno molesta la lectura.
- **La galería no cubre el caso "figura en el contexto del texto"**: se mira aparte. Los
  problemas de salto de página o de ancho aparecen solo al compilar el apunte entero.

## Pendientes explícitos

- **Los circuitos son ASCII.** Se leen bien, pero si el apunte se va a imprimir y repartir
  conviene evaluar redibujarlos como vectores con CeTZ (paquete de Typst). Con 97 páginas
  y unas veinte figuras, ahora es más trabajo que antes, pero sigue sin bloquear nada.
- **El programa de UNSAM está tomado de la ficha oficial de la carrera, no del programa
  analítico de la cátedra.** `unsam.edu.ar` está bloqueado por la política de red del
  entorno remoto. Si Fran consigue el programa analítico de Teoría de Circuitos (o el
  campus de la materia), hay que contrastar el orden y el alcance de los módulos 7 a 13 —
  en particular cuánta transformada de Laplace entra, que acá no se tocó.
- **Sin verificar contra el apunte interactivo** de Moodle de la E.E.S.T., que sigue sin
  poder leerse.
- **Los anexos figuran como "Módulo 14"** porque usan el mismo `#modulo(...)` que el resto.
  Con seis módulos molestaba poco; con trece se nota más. Si se quiere sacarles el número,
  hay que agregarle un parámetro a `#modulo` en la plantilla.
