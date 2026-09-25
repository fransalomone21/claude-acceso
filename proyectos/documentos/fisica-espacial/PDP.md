# PDP — Apunte general de Física Espacial

Plan de Desarrollo de Proyecto. Acá viven **el plan de fases, el criterio de
salida de cada una y las decisiones de contenido con su porqué**. Si el
`HANDOFF.md` y este archivo se contradicen, gana el PDP y el handoff se
corrige en el mismo turno.

---

## 1. Qué se produce

Un **apunte general** de la materia *Física Espacial* (UNSAM — Ingeniería en
Sistemas Espaciales, cátedra Feder–Valenti, ciclo 2026), en Typst, compilado a
un solo PDF.

No es un resumen de citas ni un formulario: es un texto que **explica**. La
regla de contenido que lo define, dicha por el destinatario:

> «Si estás explicando por qué con cierta $v$ tangencial un objeto orbita en
> una circunferencia sin caer, no me tires la fórmula en la cara: hacé la
> deducción de cómo llegar hasta ahí.»

Y su contrapeso, dicho en la misma frase:

> «No necesito demostraciones extensas de todo, ni pasos intermedios tontos.»

Traducido a criterio operativo: **se deduce lo que cambia el entendimiento y
se cita lo que sólo cambia el álgebra.** Toda fórmula que aparece por primera
vez llega desde algo anterior; ningún desarrollo se escribe línea por línea
cuando el paso es una cuenta mecánica.

## 2. Para quién es, y para quién no

**Es para Fran**, alumno de la materia, que cursa en paralelo Teoría de
Circuitos y ya tiene Análisis Matemático y Física I–III. Sabe derivar e
integrar, sabe qué es un producto vectorial, y **no** necesita que se le
explique qué es una derivada. Sí necesita:

- de dónde sale cada resultado, no sólo cuál es;
- la geometría y el álgebra vectorial del planteo, que es donde se pierde el
  tiempo en el parcial (qué versor, qué ángulo, respecto de qué punto);
- las trampas de notación entre los tres libros que la cátedra mezcla, que ya
  costaron confusión real (Beer llama $H$ al momento angular y $L$ a la
  cantidad de movimiento — exactamente al revés que la cátedra).

**No es** un libro de texto ni material de divulgación. No repite lo que ya
está bien en S&Z; lo usa y cita.

## 3. Decisiones de contenido, con su porqué

| Decisión | Por qué |
|---|---|
| **Cubre el plan de las 17 semanas completo**, cuerpo rígido incluido | el pedido fue «apunte general de la materia», y las semanas 10–14 (CR, precesión, peonza) son la mitad del segundo parcial. Cortar en la primera evaluación entregaría medio apunte |
| **Dos ejemplos por módulo: uno simple y uno complejo** | pedido explícito. El simple fija el mecanismo; el complejo es del nivel de la guía de la cátedra |
| Los ejemplos **se calcan de la guía de problemas**, no se inventan | la guía es el examen. Un ejemplo inventado enseña a resolver algo que no se va a tomar |
| **Cuadros de Cuidado geométricos y vectoriales** | pedido explícito, y coincide con dónde falla el planteo: respecto de qué punto se toma $L$, qué versor es radial, qué ángulo entra en el $sen$ |
| **Figuras dibujadas en CeTZ**, no importadas | mismo criterio que el apunte de Electrónica: la figura vive en el fuente, se regenera y se corrige. Un PNG pegado no se puede arreglar |
| **Estilo calcado del apunte de Electrónica Analógica** | pedido explícito. Se copia la arquitectura (`plantilla.typ` + `biblioteca/` + `modulos/`), no los archivos: los colores y las cajas cambian de semántica |
| **Se recicla el `resumen.typ` previo** (16 pág., verificado contra los libros con página) como *fuente*, no como base | ese documento es un mapa de citas de cátedra ya verificado — tirarlo sería tirar trabajo medido. Pero su forma es de resumen, no de apunte: el texto se reescribe |
| **El apunte no lleva demostración de la ecuación de Kepler en tiempo** (anomalía excéntrica) más allá del enunciado y su uso | no está en el plan de 17 semanas ni en la guía; entra como anexo si sobra |

### Las fuentes, y cómo se citan

Los seis libros están en el disco (ver `fuentes/RUTAS.md`). Toda afirmación
lleva su origen entre paréntesis con **sección y página impresa**.

| Cita | Libro |
|---|---|
| S&Z | Young & Freedman, *Física universitaria* Vol. 1 y 2 (Pearson 2018) |
| Roederer | Roederer, *Mecánica elemental* (Eudeba 2008) |
| Beer | Beer & Johnston, *Mecánica vectorial para ingenieros: Dinámica* |
| Bate | Bate, Mueller & White, *Fundamentals of Astrodynamics* (Dover 1971) |
| Curtis | Curtis, *Orbital Mechanics for Engineering Students* (Elsevier 2020) |
| Clase | apuntes manuscritos de la cátedra (potencial eficaz, masa reducida) |

## 4. Las fases, y qué cierra cada una

El criterio de salida de una fase es un **resultado verificable**, nunca una
cantidad de trabajo hecho. Una fase no se abre con la anterior sin cerrar.

### Fase 0 — encuadre  ·  CERRADA (2026-08-30)

Cierra con: proyecto creado, fila en el enrutador, PDP escrito, inventario de
libros y de herramientas **medido** contra el disco.

### Fase 1 — andamiaje y módulo piloto

Cierra con: `apunte.pdf` compilando, con carátula, índice, plantilla,
biblioteca de figuras con al menos tres figuras propias, y el **Módulo 1
(Vectores y cinemática)** escrito entero — sus dos ejemplos incluidos — y
**mirado en el render**, no sólo compilado.

Por qué un piloto y no el esqueleto de los quince: el estilo se decide una
vez, y se decide sobre una página real. Escribir quince módulos con un estilo
que no se miró es quince módulos para corregir.

### Fase 2 — Parte II: los teoremas de conservación (M2–M5)

Cierra con: los cuatro módulos escritos, con sus ocho ejemplos, y el PDF
mirado página por página.

### Fase 3 — Parte III: gravitación y órbitas (M6–M11)  ·  CERRADA (2026-08-31)

Cierra con: los seis módulos escritos y mirados, incluido el diagrama de
flujo del Road Map (Curtis, ap. B) redibujado en CeTZ. *(Esta fila decía
«M6–M10, cinco módulos» hasta el 2026-08-31 — divergía de §5, que ya listaba
M11 «Maniobras» adentro de la Parte III. Ganó §5, que es donde vive la
estructura real de quince módulos; el número de acá se corrigió en el mismo
turno en que se detectó, por la regla 4 del enrutador.)*

### Fase 4 — Parte IV: cuerpo rígido (M12–M15)

Cierra con: los cuatro módulos escritos y mirados.

### Fase 5 — Parte V: de la cónica al viaje real (M16–M19)  ·  LOS CUATRO MÓDULOS ESCRITOS (2026-09-11); falta la sesión de cierre

**Por qué existe.** El 2026-09-07 Fran trajo la lista de temas de gravitación
actualizada (`Lista de temas Gravitación (2).pdf`, ver `fuentes/RUTAS.md`),
que agrega dos filas que la versión anterior no tenía: **«Todo — Curtis cap.
2»** y los **parámetros orbitales del Bate** (pág. 19–40 y 53–74). Y pidió,
además, órbitas parcheadas, esfera de influencia y su relación con Hohmann y
con la gravedad de la Tierra — que es el capítulo 8 de Curtis, no el 2.

**El hueco medido** (grep sobre los quince módulos, 2026-09-07): de Curtis
cap. 2, los apartados 2.2 a 2.7 están cubiertos por los módulos 6 a 10; lo
que **no estaba en ninguna parte del apunte** es 2.8–2.9 (parábola e
hipérbola más allá de una fila de tabla), 2.10 (marco perifocal), 2.11
(coeficientes de Lagrange) y 2.12 (tres cuerpos restringido y puntos de
Lagrange). Ni «perifocal», ni «Lagrange», ni «parcheada», ni «esfera de
influencia» aparecían una sola vez en los 5189 renglones de `modulos/`.

**Los cuatro módulos, en el orden en que se escriben:**

| Módulo | Qué | Fuente | Estado |
|---|---|---|---|
| M16 | La hipérbola: escapar y llegar con velocidad de sobra | Curtis §2.8–2.9 | **escrito y verificado** (2026-09-07) |
| M17 | Esfera de influencia y órbitas parcheadas | Curtis §8.4–8.6 | **escrito y verificado** (2026-09-07) |
| M18 | Marco perifocal, vector de estado y coeficientes de Lagrange | Curtis §2.10–2.11, Bate §2.2.4 a §2.5 (pág. 57–73) | **escrito y verificado** (2026-09-08) |
| M19 | El problema restringido de tres cuerpos y los puntos de Lagrange | Curtis §2.12 | **escrito y verificado** (2026-09-11) |

El orden no es el del libro: M17 va segundo, antes que los dos de
herramientas, porque es lo que Fran pidió explícitamente y porque M16 es su
única precondición.

**Va al final del apunte y no entre las Partes III y IV.** Insertarla en el
medio renumeraría los módulos 12 a 15 y rompería **51 referencias de texto
plano** («módulo 12», «módulo 14», …) repartidas en siete archivos y en 105
páginas ya verificadas — un refactor de riesgo silencioso, fuera del alcance
de «ampliá el apunte». La Parte V se lee inmediatamente después del módulo
11: no usa nada de cuerpo rígido, y la bajada de la parte lo dice.

Cierra con: los cuatro módulos escritos, con sus ejemplos, compilados y
**mirados en el render**; el enlace numérico Hohmann ↔ hipérbola de escape
cerrado de punta a punta (el $v_oo$ del módulo 16 usado como entrada del 17);
y `docs/figuras.md` al día.

### Fase 6 — cierre  ·  CERRADA (2026-09-13)

Cierra con: anexos (formulario, constantes, tabla de correspondencia con las
listas de temas de la cátedra), todas las referencias cruzadas validadas
contra el índice renderizado, y el PDF entregado.

**Se cerró con dos de los tres, y el tercero se movió.** Las referencias
cruzadas quedaron validadas (fase 5) y el PDF entregado; **los anexos no se
escribieron**. Eso no se declaró el día que se cerró la fase y se corrige acá:
los anexos pasan a ser la fase 7, opcional, definida abajo. Cerrar una fase
contra un criterio que no se cumplió, sin decirlo, es justo lo que el criterio
de salida existe para impedir.

### Fase 7 — que la guía se pueda resolver  ·  CERRADA (2026-09-13)

**La fase se abrió, cambió de alcance por evidencia y se cerró el mismo día.**
Se abrió para escribir tres anexos. Antes de escribirlos se hizo lo que no se
había hecho nunca: **cruzar la guía de la cátedra, problema por problema,
contra los 19 módulos** (`PROBLEMAS FÍSICA ESPACIAL (3).pdf`, 21 págs.). Ese
cruce mostró que los anexos resolvían un problema que el apunte no tenía.

**Lo que el cruce midió, y que nadie había medido antes:**

1. **El roadmap de Curtis está completo salvo un nodo** —las ecuaciones de
   Kepler que relacionan anomalía con tiempo— y el apunte ya lo declara, en
   `m11-maniobras.typ:264`, al lado de la figura del roadmap. Lo nuevo es que
   **ese nodo no lo pide ningún problema de la guía**, y ahora está
   verificado contra la guía en vez de asumido: el tiempo de la transferencia
   de Hohmann es medio período (Problema 5b) y el encuentro del Problema 10
   es una órbita de fasaje, que `m11:160` resuelve con $T'/T = 1 - Delta phi
   \/ 360°$.
2. **Los 16 problemas de gravitación (0 a 10 más los 5 adicionales) son
   resolubles con lo que ya está escrito.** Dos de ellos, además, ya están
   resueltos adentro del apunte: el adicional 5 en `m16:354` y el Problema 9
   (el LEM) como ejemplo trabajado de `m10`.
3. **Los dos únicos huecos eran de vocabulario, no de física.** La guía pide
   «la energía específica de la órbita» y habla de «órbita geosincrónica»;
   el apunte tenía las dos cosas deducidas —la vis-viva y el día sideral con
   la altura geosincrónica calculada— y no las llamaba por su nombre.

**Lo que se hizo, y por qué así y no como anexo.** Los dos términos se
escribieron **donde ya vive el concepto**: $epsilon = E\/m = -mu\/(2a)$ en el
módulo 9, junto a la vis-viva, y la geosincrónica/geoestacionaria en el
módulo 6, junto a la cuenta que ya sacaba los 35 780 km. Un anexo habría
puesto el nombre lejos de su deducción, que es exactamente lo que este apunte
existe para no hacer.

**Cerró con:** los dos términos adentro, el apunte compilado (149 páginas, no
cambió el total) y las tres páginas afectadas —46, 68 y 69— **miradas en el
render**, que es la regla propia del proyecto.

*(La fase 8 —«fundamentos primero», el orden que ahora se mide— está
registrada en `ESTADO_ACTUAL.md` y no llegó a escribirse acá. Se deja
constancia en vez de reconstruirla de memoria.)*

### Fase 9 — Impulso angular: rotación alrededor de un eje fijo  ·  CERRADA (2026-09-25)

La abrió la *Lista de temas Impulso angular (1)*, toda del Sears caps. 9–10.
El cruce mostró que el escalón entero faltaba: el apunte iba del momento
angular de partícula (Beer cap. 12) al cuerpo rígido en 3D (Beer cap. 18) sin
pasar nunca por $K = \frac12 I\omega^2$, $\tau = I\alpha$, $L = I\omega$ ni la
precesión elemental. Entró el módulo `rotacion` al principio de la parte de
cuerpo rígido (los cuatro de CR se renumeraron 18–21).

**Cerró con:** las 17 filas de la lista con sección (tabla en `TEMARIO.md`),
el Ejemplo 10.13 del Sears y el Problema S&Z 10.51 de la guía resueltos y
recalculados por separado —coinciden con el libro y con el Anexo A—, el
apunte compilado (187 páginas), las diez páginas del módulo miradas en el
render, y `verificar-apunte.py`, `indice-temas.py` y el saboteador en verde.

### Fase 10 — el tono: el piloto aprobado por Fran

El módulo `rotacion` se escribe con la voz nueva (regla propia 8) para que
sirva de piloto. **El tono es una decisión de gusto del destinatario, no de
la sesión**, y pasarlo a 20 módulos antes de que lo lea es el error caro.

**Llevó tres vueltas el mismo día**, y cada una corrigió algo que la anterior
había hecho mal: (1) humor amable en diez cajas `#aparte` por módulo; (2)
Fran pidió más sarcasmo y crudeza, que Aníbal sea «hinchapelotas» y se le
reconozca cuando acierta, que Fran también sea blanco, y el humor *integrado*
en la prosa y en la explicación formal, no en cajas; (3) Fran señaló que un
chiste anunciado pierde la gracia, y que tantos tipos de caja distintos
podían ser excesivos. Resultado: `#aparte` borrado, el humor sin carteles,
y **218 de las 407 cajas del apunte pasaron a ser marcas de color en el
texto** («Ojo:», «La idea:»…), cambio de plantilla que ya vale para los 21
módulos.

**Cierra con:** Fran leyó el módulo 17 en su tercera versión y dijo «así» o
qué cambiar, y el cambio está aplicado. **CERRADA el 2026-09-25: Fran dijo
«así».**

**La intención era no subir el piloto al Drive de los compañeros hasta que
cierre**, y no se cumplió: el hook `post-commit` lo publicó con el commit
`1ca33a4` (ver `HANDOFF.md`). La decisión de dejarlo o volver a la versión
anterior es de Fran. Para los commits de la fase 11, mientras el tono no esté
aprobado, el PDF queda fuera del commit.

### Fase 11 — la pasada por los 20 módulos restantes y el Anexo A  ·  CERRADA (2026-09-25)

Lo que Fran pidió el 2026-09-25 para *todo* el apunte, en una sola lectura
por módulo —porque las tres cosas se hacen mirando lo mismo, y leer cada
módulo tres veces triplica el costo—:

1. **la voz** aprobada en la fase 10, integrada en la prosa y en las cajas
   técnicas (regla propia 8), y la marca `// voz: <fecha>` al principio del
   módulo cuando está hecho;
2. **de dónde sale cada tema**: toda sección nombra el libro y el capítulo
   («esto es del Curtis, cap. 3»), no sólo el módulo en su `#lectura`;
3. **`#posta`** en los módulos que no tienen ninguno (13 de 21), que es la
   deuda de la regla propia 3 que se había dejado para «cuando se toque el
   módulo por otro motivo» — y éste es el motivo.

De paso se cumple la regla 1 en páginas que nunca se miraron (las `#lectura`
del 2026-09-17 quedaron sin chequeo visual).

**Se mide con `python medir-estilo.py`**, que el 2026-09-25 da **PENDIENTE:
58** (25 secciones sin libro, 13 módulos sin posta, 20 sin la voz nueva).
**Las cajas ya no son parte de la pasada**: el trade-off de cuáles quedan
se aplicó de una vez en la plantilla. Lo que sí queda por módulo es revisar
que ningún «Ojo:» arranque repitiendo su propia entrada.

**Tandas de una sesión cada una**, porque cinco módulos entran en una sesión
y veinte no: (a) 1–5, (b) 6–10, (c) 11–16, (d) 18–21 y el Anexo A.
Checkpoint y commit por tanda.

**Cierra con:** `medir-estilo.py` en PENDIENTE: 0, las páginas tocadas
miradas en el render, los verificadores en verde y el PDF publicado al Drive
con `publicar-apuntes.ps1` (MD5 al día).

### Fase 12 — la deuda de exactitud que ya estaba anotada

No es de estilo: son resultados que el apunte da y que nadie verificó dos
veces, o datos que faltan medir. **Si hay un parcial de cuerpo rígido cerca,
esta fase va antes que la 11**, porque un chiste de menos no desaprueba a
nadie y una respuesta mal en el Anexo A sí.

- **Ya pagado en la fase 11 (2026-09-25):** directa y retrógrada estaban
  invertidas en m20, m21 y cuatro fichas del Anexo (P4, P5, P6, P9);
  corregido contra el Beer pág. 1191. Es la prueba de que esta fase no es
  decorativa: la respuesta mal estaba en el PDF publicado.
- **13 fichas del Anexo A marcadas «cuenta propia»**, sin segunda mirada
  (`grep -c "cuenta propia" apunte/anexos/a1-guia-ejercicios.typ`). Eran 15:
  el 2026-09-25 se recalcularon por separado el Problema 1 (torques), el
  S&Z 10.51 y el Hubble, y coincidieron.
- **Problema 9 de CR, el satélite octogonal**: la orientación del octógono
  no está confirmada, y de ella dependen las coordenadas de los dos cohetes.
- **Problema 7 de CR, la cápsula**: las posiciones de los cohetes A y B hay
  que volver a medirlas sobre la figura.

**Cierra con:** las tres cosas resueltas o declaradas irresolubles con el
motivo (por ejemplo, «la figura escaneada no alcanza; preguntar a la
cátedra»), y `grep -c "cuenta propia"` en 0.

### Lo que queda fuera de fase, a propósito

- **Los tres anexos** (formulario, constantes, correspondencia) — abajo.
- **El estándar de ejemplos «un poco más» desarrollados** se aplicó a 3
  módulos y nunca se confirmó si Fran lo quiere en los 21. Se pregunta
  cuando se cierre la fase 10, que es cuando Fran va a estar leyendo.
- **La demostración de que los ejes principales existen**: el Beer que la
  tiene es el de *Estática*, que no está en el disco.
- **El Ej. 6 de impulso angular** está en blanco en el PDF de la cátedra.

### Los tres anexos — SIGUEN SIN ESCRIBIRSE, y ya no bloquean nada

Formulario, constantes y tabla de correspondencia con la cátedra. Eran el
alcance original de la fase 7 y siguen siendo **útiles para estudiar**, pero
el cruce contra la guía mostró que **no hacen falta para resolverla**: eso era
lo que no se sabía y es lo que cambia la decisión. Si alguna vez se escriben,
el `#include` de `modulos/anexos.typ` sigue comentado en
`apunte/apunte.typ:134`, y el alcance de cada uno está descrito abajo.

**Cerrarían con:** los tres escritos, el apunte compilado y las páginas nuevas
miradas en el render. Es una sesión propia: el formulario obliga a recorrer
las 7.795 líneas de los 19 módulos, y hacerlo a medias produce un artefacto de
consulta incompleto, que se usa sin desconfiar — peor que no tenerlo.
## 5. La estructura del apunte

```
Parte I   — Herramientas
  M1  Vectores, coordenadas polares y curvilíneas
Parte II  — Los teoremas de conservación
  M2  Cantidad de movimiento, impulso y choques
  M3  Centro de masa y sistemas de partículas
  M4  Propulsión: la ecuación del cohete
  M5  Trabajo y energía
Parte III — Gravitación y mecánica orbital
  M6  Gravitación de Newton, peso y energía potencial
  M7  Momento angular y fuerzas centrales
  M8  El problema de dos cuerpos y la masa reducida
  M9  La ecuación de la órbita, las cónicas y el potencial eficaz
  M10 Leyes de Kepler y parámetros orbitales
  M11 Maniobras: Hohmann, phasing y rendez-vous
Parte IV  — Cuerpo rígido
  M12 Cinemática del cuerpo rígido y sistemas rotantes
  M13 Momento de inercia y ejes principales
  M14 Ecuaciones de Euler y el giróscopo
  M15 Peonza simétrica, precesión directa y retrógrada
Parte V   — De la cónica al viaje real
  M16 La hipérbola: escapar, y llegar con velocidad de sobra
  M17 Esfera de influencia y órbitas parcheadas
  M18 Marco perifocal, vector de estado y coeficientes de Lagrange
  M19 El problema restringido de tres cuerpos y los puntos de Lagrange
Anexos    — formulario · constantes · correspondencia con la cátedra
```

Diecinueve módulos. Eran quince hasta el 2026-09-07: la Parte V nació de las
dos filas nuevas de la lista de temas de gravitación (ver la fase 5). El de
Electrónica tiene catorce y 123 páginas; éste tiene **149 con los diecinueve
módulos adentro** (2026-09-11), sin los anexos.

## 6. Cómo se verifica

- **Verificación:** compila, y cada página se **mira** (regla propia del
  proyecto, ver `CLAUDE.md`). Que Typst compile no dice nada sobre si una
  figura entró o si una tabla se cortó.
- **Validación:** el destinatario lee un módulo entero y puede resolver el
  ejercicio de la guía correspondiente sin abrir el libro.
