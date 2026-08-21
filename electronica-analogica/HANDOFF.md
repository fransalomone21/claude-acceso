# Handoff — próxima sesión

## Cuadro de fase para abrir el próximo chat

```
Fase     : Fase 1 CERRADA (apunte completo, 44 pág.) y Fase 1b CERRADA
           (figuras vectoriales, 30 en total, verificador en verde y
           probado rompiéndolo). Lo que sigue es Fase 2 — revisión
           pedagógica con el apunte usado en clase. La cierra: Fran dicta
           al menos un módulo y marca qué falta o qué sobra.
Modelo   : Sonnet 5 para ajustes de redacción, retoques de figuras y
           agregados menores. Opus solo si hay que agregar deducciones
           nuevas o diseñar una figura desde cero.
Esfuerzo : medio, sin fan-out. El trabajo que queda es de una sola
           cabeza sobre un documento que ya existe; la amplitud no compra
           nada acá.
Contexto : chat nuevo. El apunte y su documentación están en el repo y se
           leen solos; arrastrar contexto no aporta.
```

## Lo primero que hay que hacer

```bash
cd electronica-analogica/apunte && python verificar.py
```

Tiene que dar "Todo en verde". Si da rojo, arreglar eso antes de tocar nada más.
Después leer `ESTADO_ACTUAL.md` (las tres decisiones de contenido) y, si se van a
tocar figuras, `docs/figuras.md` entero.

## Trampas ya pagadas — no volver a pisarlas

### De Typst / tipografía

- **Coma decimal antes de `/`**: `16,3/1000` se dibuja como "16" más la fracción 3/1000.
  Escribir siempre `(16,3)/(1000)` con paréntesis.
- **Coma decimal dentro de una función**: `sqrt(1000^2 + 99,5^2)` es un error de sintaxis
  (la coma separa argumentos). Usar `"99,5"` entre comillas.
- **Espacio detrás de la coma**: ya está resuelto globalmente en `plantilla.typ` con una
  regla `show ","` que la reclasifica como átomo normal. No borrar esa regla.
- **Unidades con micro**: `6667 mu "F"` sale con espacio feo. Escribir `"6667 µF"`.
- **No hay poppler en la máquina**: la herramienta Read no abre PDFs. Para leer uno,
  extraer texto con `pypdf` (ya instalado) — ver `fuentes/_extraer.py`.

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

Un archivo por módulo en `apunte/modulos/`. `m1-mediciones.typ` es el modelo canónico:
apertura con `#modulo(...)`, teoría con deducción explícita, ecuaciones etiquetadas
`<ec-...>` y referenciadas con `@ec-...`, cajas `#definicion` / `#clave` / `#atencion` /
`#laboratorio`, ejercicios con `#ejercicio`, figuras con
`#circuito([epígrafe])[#fig-loquesea()]`, y cierre con `#tp(...)`. La numeración de
ejercicios, ecuaciones y figuras se reinicia sola en cada `#modulo(...)`: no agregar
contadores a mano.

Para agregar una figura nueva, el procedimiento de cinco pasos está en `docs/figuras.md`,
sección 4. Lo importante: **agregarla también a `galeria.typ`**, o el verificador da rojo.

## Decisiones ya tomadas — no reabrir

- **El apunte NO resuelve los TPs.** Confirmado por Fran el 2026-08-16: las
  resoluciones las hace él. El apunte aporta el *sustento teórico* y ejercicios
  *análogos* con los mismos números, como modelo de resolución. No agregar soluciones
  de los prácticos.
- **El destinatario primario es el docente**, y en segundo lugar los alumnos. De ahí el
  peso puesto en las deducciones completas (de dónde sale cada fórmula) por encima de la
  ejercitación.
- **Las figuras se dibujan con Typst, no con LaTeX.** El razonamiento completo está en
  `docs/figuras.md`, sección 1. No reabrirlo salvo que aparezca un símbolo que `zap` no
  tenga y que no se pueda componer a mano.
- **La fila del proyecto ya está en la tabla del `CLAUDE.md` raíz.**

## Pendientes explícitos

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
