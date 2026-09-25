# Apunte de Física Espacial — contrato de contexto

Apunte general de la materia **Física Espacial** (UNSAM — Ingeniería en
Sistemas Espaciales, cátedra Feder–Valenti, 2026). Fuente única en **Typst**,
se compila a un solo PDF. Destinatario: **el alumno que cursa la materia**.

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md):
el render se mira y las fuentes se anotan donde se usan. Lo que en esa
naturaleza se advierte —que las referencias cruzadas de texto plano no las
valida el compilador— acá dejó de valer el 2026-09-13: las referencias a otro
módulo se escriben `#M("clave")` y una clave mala **rompe la compilación**
(regla propia 5).

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber qué módulos están cerrados | [`ESTADO_ACTUAL.md`](ESTADO_ACTUAL.md) (entero) |
| saber qué cierra la fase en curso, o por qué se decidió algo | [`PDP.md`](PDP.md) — sobre todo §3 y §4 |
| lo que quedó a medias y las trampas de Typst ya pagadas | [`HANDOFF.md`](HANDOFF.md) |
| verificar un dato contra la bibliografía | [`fuentes/RUTAS.md`](fuentes/RUTAS.md) — los seis libros, con ruta exacta |
| entender qué pide la cátedra en cada tema | [`fuentes/TEMARIO.md`](fuentes/TEMARIO.md) — las listas de temas y el plan de 17 semanas, transcriptos |
| **leer un enunciado de la guía, o verificar que un tema esté cubierto** | [`fuentes/GUIA-ENUNCIADOS.md`](fuentes/GUIA-ENUNCIADOS.md) — **la guía entera transcripta**. Los enunciados del PDF son imágenes: renderizarlas es la operación más cara del proyecto y ya está pagada. **Empezar siempre acá, no por el PDF.** |
| **saber si un tema YA está en el apunte, o dónde entraría uno nuevo** | [`docs/INDICE-TEMAS.md`](docs/INDICE-TEMAS.md) — **empezar acá antes de grepear o de abrir el PDF**. Es el mapa de los veinte módulos por título, subtítulo, ejemplo y etiqueta de ecuación. Lo **genera** `indice-temas.py`: no se edita a mano |
| tocar o agregar una figura | [`docs/figuras.md`](docs/figuras.md) |
| **reordenar módulos, o agregar uno** | reglas propias 5 y 6 acá abajo, y después `python verificar-apunte.py` |
| generar el PDF | `.\compilar.bat`. El flujo y el chequeo visual: `/pdf-con-codigo` |

## Las reglas propias

**1. Ninguna sección se da por cerrada sin haber mirado su página compilada.**
Que Typst compile no dice nada sobre si los rótulos se cruzan, si una figura
entró, o si una tabla se cortó.

**2. Se deduce lo que cambia el entendimiento; se cita lo que sólo cambia el
álgebra.** Es la regla de contenido que define este apunte y viene textual del
destinatario. Una fórmula que aparece de la nada incumple la primera mitad;
tres páginas de despeje incumplen la segunda.

**2 bis. Un cambio de variable independiente, o una derivada que se aplica más
de una vez, no es "sólo álgebra": es el paso que la regla 2 pide deducir.**
Decisión del 2026-09-21, a pedido explícito de Fran sobre el módulo 10: el
cambio $t arrow.r theta$ y $r arrow.r u=1\/r$ de la ecuación de la órbita
estaba citado ("Beer ecs. 12.35 y 12.36") pero no mostrado, y el lector no
podía reconstruir cómo $dot(r)$ se convierte en $-h thin d u\/d theta$. El
criterio: mostrar el operador que reemplaza a la derivada vieja, y aplicarlo
las veces que haga falta —no cada paso posible, los que muestran *el camino*—
hasta llegar al resultado que ya se cita. Ejemplo de referencia:
[`m10-orbita-conicas.typ`](apunte/modulos/m10-orbita-conicas.typ), la caja
"por qué se cambia t por theta, y r por 1/r" y, más abajo en el mismo módulo,
el paso $p arrow.r a$ de la ecuación vis-viva. **No se retrofittea** —mismo
criterio que `#posta` y `#repaso()` (reglas 3 y 7)—: se aplica de acá en
adelante, en todo cambio de variable o derivada repetida que aparezca en un
módulo nuevo o que se vuelva a tocar.

**3. Todo tema no trivial lleva, además de las cajas técnicas, un cuadro
`#posta` en la voz de Fran.** Decisión del 2026-09-07, a pedido explícito del
destinatario. Es la misma idea de las cajas azules/ámbar/etc., dicha en
criollo y sin vueltas — qué ganás, a qué te ahorrás pensar, por qué el truco
funciona —, y **no reemplaza ninguna caja técnica ni se permite perder rigor**:
si el cuadro rosa dice algo que ninguna otra caja del tema ya dedujo, está mal
puesto. Ejemplo de referencia, el primero que se escribió:
[`m09-dos-cuerpos.typ`](apunte/modulos/m09-dos-cuerpos.typ), la caja `#posta`
sobre el problema equivalente. La función vive en `plantilla.typ`
(`#let posta(cuerpo) = ...`, color `c-rosa` en `paleta.typ`) y ya está en la
leyenda de la carátula. **No se retrofitteó automáticamente a los 15 módulos
ya escritos** —eso es una pasada aparte, deliberadamente no hecha todavía por
el costo que tiene tocar 105 páginas ya cerradas—: se aplica a partir de acá
en todo módulo nuevo o que se vuelva a tocar por otro motivo.

**4. Todo modelo, método o entidad nueva se introduce en palabras —qué es,
respecto de qué está, qué pasa con las masas/vectores que ya se conocían—
ANTES de la primera ecuación o figura que lo use, nunca al revés.** Decisión
del 2026-09-07: en el módulo 8, el "centro fijo" del problema equivalente
apareció primero en una figura y recién se explicó varios párrafos después,
y esa fue exactamente la confusión que reportó el destinatario ("no entiendo
respecto de qué está ese punto"). El arreglo no es una caja más al final: es
mover la explicación —en criollo, con el plan en 2-3 pasos— **antes** de la
figura y de las primeras ecuaciones del tema. La referencia de cómo se hace
bien, señalada por el destinatario, es el apunte de Electrónica Analógica:
`m8-nodos-mallas.typ`, la sección que abre con «la idea de este módulo es
una sola: cambiar las incógnitas» y el `#clave` de dos ramas que sigue,
**antes** de tocar un circuito. El ejemplo propio, sección "La idea completa,
antes de la primera ecuación" de
[`m09-dos-cuerpos.typ`](apunte/modulos/m09-dos-cuerpos.typ). Vale para todo
módulo nuevo, y es motivo válido para reabrir uno viejo si alguien reporta
la misma confusión.

**4 bis. La fuente se nombra donde se usa, y además se dice qué capítulo
leer.** Son dos cosas distintas y hasta el 2026-09-17 el apunte sólo hacía la
primera. Citar «Beer ec. 12.46, pág. 740» al lado de una fórmula sirve para
*verificar* esa fórmula; no contesta la pregunta que la cátedra hace en el
oral, que es *de qué capítulo de qué autor salió este tema*. Por eso:

- todo módulo lleva **una** caja `#lectura` —«Dónde leerlo»— con autor,
  capítulo y sección, y una línea sobre *cuál de los dos libros conviene abrir
  para qué*. Una por módulo, breve: no es una bibliografía, es un puntero;
- toda figura **reciclada o redibujada de un libro** dice de dónde sale en su
  propio epígrafe («Redibujada de Curtis, Fig. 2.12, pág. 73»), no en el
  cuerpo del texto ni sólo en `docs/figuras.md`.

Vale para todo módulo nuevo o que se vuelva a tocar. Al 2026-09-17 tienen
`#lectura` los módulos 9, 10, 11, 12 y 13; los otros quince están pendientes,
y eso **se ve**: `grep -L "#lectura" apunte/modulos/*.typ`.

**5. El número de un módulo NO se escribe a mano. Nunca.** En la prosa va
`#M("clave")` —por ejemplo `módulo #M("gravitacion")`— y el número sale del
orden de los `#include` de `apunte.typ`, que es el único lugar donde ese orden
vive. Una clave que no existe **no compila**: `M()` hace `panic`, no imprime un
signo de pregunta. Probado en las dos direcciones el 2026-09-13 (clave buena →
número correcto; clave inventada → error de compilación).

Esto salió de una necesidad concreta: hasta ese día había **355 números de
módulo escritos a mano** en los diecinueve módulos, y reordenar el apunte
significaba reescribirlos todos sin que ningún compilador pudiera avisar si
quedaba uno mal. La conversión se hizo de una vez y se verificó de la única
manera que prueba algo: **el texto renderizado quedó idéntico, carácter por
carácter, a las 149 páginas de antes**. Lo mismo vale para los archivos
(`mNN-clave.typ`, renumerados al reordenar), para las etiquetas internas
(`<grav-vesc>`, con prefijo de clave y no de número) y para el catálogo de
figuras, que lista claves.

**6. El orden del apunte es «fundamentos primero», y eso es verificable.**
Ningún módulo puede *usar* uno posterior. El grafo se mide así, y tiene que dar
la columna «usa» siempre con números menores:

```
python -c "import io,re; ap=io.open('apunte/apunte.typ',encoding='utf-8').read(); orden=re.findall(r'#include \"modulos/(m\d+-[a-z-]+)\.typ\"',ap); [print(i, re.search(r'clave: \"([a-z-]+)\"', io.open('apunte/modulos/%s.typ'%f,encoding='utf-8').read()).group(1)) for i,f in enumerate(orden,1)]"
```

Anticipar un módulo posterior («esto se va a usar en…») sí está permitido y es
deseable; *depender* de él no. El 2026-09-13 había exactamente una dependencia
al revés —el problema de tres cuerpos necesitaba la cinemática del cuerpo
rígido— y por eso se movió la fórmula del marco rotante con $Omega$ constante
al módulo de fundamentos, donde se deduce con lo que ya da el de vectores.

**7. Una ecuación que reutiliza un resultado de otro módulo sin rederivarlo
lleva `#repaso(destino: <etiqueta>)` pegado a la palabra o el símbolo que
dispara la duda.** Es la regla propia 2 vista desde el lector: «se cita lo
que sólo cambia el álgebra» deja al que no reconoce el resultado sin más
opción que salir a buscar el módulo de memoria — lo que reportó Fran leyendo
el módulo 10 (2026-09-20), sobre la aceleración en polares del módulo
#M("vectores") reutilizada seis módulos después sin ningún puntero.
`#repaso()` (en `plantilla.typ`) es una nota al pie: el repaso breve aparece
al pie de la misma página —no hace falta saltar a ningún lado para leerlo— y,
si el resultado tiene una deducción completa en otro módulo, un link que
salta ahí. Primer caso de uso, de referencia:
[`m10-orbita-conicas.typ`](apunte/modulos/m10-orbita-conicas.typ), sobre las
ecuaciones de movimiento en polares (Beer ecs. 12.31-12.32).

**No se retrofitteó a los usos ya existentes** —mismo criterio que la regla
propia 3 con `#posta`—: se aplica de acá en adelante, en todo módulo nuevo o
que se vuelva a tocar por otro motivo.

`destino` es una etiqueta, no un módulo ni un número de página, por el mismo
motivo que `#M()` usa claves (regla propia 5): sigue apuntando bien si el
apunte se reordena. Y `indice-temas.py` sabe filtrarla —`ecuaciones()` saca
el patrón `destino: <etiqueta>` antes de listar qué define cada módulo—
porque sin ese filtro cada `#repaso()` hacía aparecer la etiqueta ajena como
si el módulo que la usa la hubiera definido él. Se encontró y se arregló al
agregar el primer caso de uso: probado viendo `<vec-polares>` desaparecer de
la lista de "usa después" del módulo 10 y seguir en la del módulo 1.

**8. La voz del apunte: un buen profesor, completo, sarcástico y en criollo —
integrado en la redacción, no encerrado en cajas.** Decisión del 2026-09-25,
en dos pasos, a pedido de Fran. El primer piloto puso el humor en una caja
propia (`#aparte`), diez por módulo, con tono amable; Fran lo corrigió así:
*«me gusta que haya cuadros, pero no que por cada cosa que te pido hagas uno;
estos aspectos deben estar integrados humana y didácticamente a lo largo del
apunte, en toda la redacción; la explicación formal también tiene que tener
toque de criollo y humor, como lo haría un buen y completo profesor»*. Y el
tono, *«más sarcástico y un poco más crudo»*. Las reglas que salen de ahí:

- **El humor y el criollo viven en la prosa**, incluida la de las cajas
  técnicas —una `#deduccion` puede decir «el cuerpo no se puede hacer girar
  a sí mismo tirándose de los pelos»— y en los títulos de sección si viene
  al caso. **Nunca dentro de una ecuación ni rompiendo un paso de una
  cuenta**: el chiste va antes o después del renglón matemático, no en el
  medio.
- **El chiste no se anuncia.** Tercera corrección de Fran, el mismo día:
  *«un humano no dice "he aquí mi acotación humorística" antes de decir algo
  gracioso; pierde la gracia si te anunciás»*. Por eso **no hay caja de
  humor** (`#aparte` existió unas horas y se borró de la plantilla), ni
  fórmulas repetidas del tipo «hay que reconocérselo», «resumen honesto»,
  «dicho sea con humor». Si el chiste necesita un cartel, no era un chiste.
- **No se crea una caja nueva por cada pedido, y hay menos cajas que antes.**
  Trade-off decidido el 2026-09-25 contra la medición: había ~407 cajas en
  187 páginas. **Quedan en cuadro** las que se *buscan* o se *saltean*:
  `#ejemplo`, `#deduccion`, `#definicion`, `#guia`, `#lectura` y `#posta`
  (el lugar de la idea en criollo separada, regla 3). **Pasaron al texto,
  con la entrada en el color de su caja** y sin recuadro, los avisos cortos:
  `#clave` («La idea:», azul), `#cuidado` («Ojo:», rojo), `#geometria` («Ojo
  con la geometría:», ámbar) y `#notacion` («Ojo con la notación:», teal).
  Son 218 de las 407; el cambio está en `plantilla.typ` (`#marca`) y vale
  para los 21 módulos de una vez. Consecuencia para el que escribe: el
  cuerpo de esas cuatro **no arranca repitiendo su entrada** («Ojo: *Ojo
  con…*»), y en la prosa no se habla de «el cuadro rojo».
- **Sarcástico y crudo, sin pudor, y con los dos lados — pero sin atacar.**
  Calibrado por Fran al decidir publicarlo: *«Aníbal me trata de falluto y
  tramposo, y yo a él también; si decís hinchapelotas, que no suene tan
  ofensivo: la idea no es atacarlo, pero ser sincero a la vez»*. La cargada
  es mutua y con cariño —si se le dice hinchapelotas, en la misma frase él
  nos devuelve «fallutos»—, y la palabra fuerte va poco. Aníbal puede ser
  el que manda a leer, sube cuatrocientos
  PDFs y fotos de manuscritos torcidos al Classroom, odia las «verdades
  reveladas», corta una exposición con «no, no, no: esto se hace así», hace
  dar la clase a los alumnos. **Y cuando la cátedra acierta —un buen
  ejemplo, una advertencia que resulta cierta, una lista con páginas— se le
  reconoce, con el mismo sarcasmo** («punto para Aníbal», «duele escribirlo,
  pero tenía razón»).
- **Fran también es blanco, sin pudor**: es coautor del apunte («Fran,
  coautor de este apunte, lo describió como un giróscopo que *está
  levitando*»). Mejor si el chiste sale de algo que Fran dijo o escribió de
  verdad —sus apuntes de clase, sus preguntas— que de algo inventado.
- **Lo que no cambia:** el humor nunca reemplaza física ni la aproxima de
  más, y **nunca le atribuye a nadie algo que no dijo o hizo**: se exagera
  la situación, no se inventan hechos. El sarcasmo va contra lo que la
  cátedra *hace*, no contra la persona.
- **Se ancla en la fuente cuando se puede**: el mejor chiste es el que de
  paso dice de dónde sale algo («el famoso Sears que tanto le gusta a
  Aníbal»), y cumple la regla 4 bis.

**Ojo con el Drive:** el PDF se publica en una carpeta pública por link que
ven los compañeros. Qué tan crudo es aceptable ahí lo decidió Fran, que pidió
este tono sabiéndolo; no es una decisión de la sesión.

Referencia, el módulo escrito así de punta a punta:
[`m17-rotacion.typ`](apunte/modulos/m17-rotacion.typ) — todo el tono está en
la prosa y adentro de las cajas técnicas, sin ningún cartel que lo anuncie.

## Dónde está cada cosa

```
apunte/
  apunte.typ          el documento: llama a los modulos en orden
  plantilla.typ       estilo, cajas, caratula, indice
  biblioteca/
    paleta.typ        los colores, en un solo lugar
    estilo.typ        helpers de CeTZ compartidos por las figuras
    figuras.typ       las figuras del apunte, una funcion por figura
    galeria.typ       compila SOLO las figuras (segundos, no minutos)
  modulos/            m01-*.typ … m21-*.typ, uno por modulo, numerados
                      SEGUN EL ORDEN de apunte.typ (lo mide verificar-apunte.py)
docs/                 figuras.md        el catalogo de figuras
                      INDICE-TEMAS.md   que temas cubre el apunte y donde
                                        -- GENERADO por indice-temas.py
fuentes/
  RUTAS.md            donde esta cada libro en el disco
  TEMARIO.md          las listas de temas y el plan de 17 semanas
  GUIA-ENUNCIADOS.md  la guia de problemas entera, transcripta a texto
                      -- la bibliografia en si no se copia aca
PDP.md · ESTADO_ACTUAL.md · HANDOFF.md
```

Los PDFs de los libros **no se commitean**: pesan cientos de MB y no son
nuestros. `fuentes/RUTAS.md` guarda dónde están en el disco.

## Antes de renderizar una página de un PDF de la cátedra

**Mirá primero si ya está transcripta en `fuentes/`.** Los enunciados de la
guía son imágenes pegadas: `pdftotext` devuelve sólo «Ej. 5», «PROBLEMA 3», y
leerlos de verdad obliga a rasterizar y mirar. Ese costo se paga **una vez** y
ya se pagó — está en `fuentes/GUIA-ENUNCIADOS.md`, con las figuras descriptas
en palabras. Volver al PDF sólo si hace falta **ver** una figura.

Medido el 2026-09-13: una sesión cruzó la guía de gravitación contra los 19
módulos renderizando cinco páginas del PDF, sin saber que el archivo existía —
porque esta tabla no lo listaba. La transcripción estaba hecha desde el
2026-08-31. Un archivo que el contrato no nombra es un archivo que la próxima
sesión no encuentra, por más que esté commiteado.

## Al cerrar cualquier sesión

0. `python verificar-apunte.py` — el orden, los nombres de archivo y las
   claves tienen que decir lo mismo. Y **`python indice-temas.py`**, que
   regenera `docs/INDICE-TEMAS.md`: si se tocó un módulo y no se regenera, el
   índice miente en silencio, que es la única forma en que un índice falla.
   Para probar que ninguno de los dos chequeos está ciego:
   `python probar-verificar-apunte.py`, que rompe los cuatro a propósito
   —incluido dejar el índice viejo— y exige verlos en rojo.
1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
