# T19 — el árbol de conocimiento: tronco fijo, ramas por proyecto

**2026-10-19.** Estado: **v2 aprobada por Fran; construidas las cinco piezas: A y B (§6), C (§7), E (§8) y D (§9)**;
falta la validación en sesiones reales de cada clase (P10), y que el lazo D junte sus primeras cinco muestras por clase.

## 0. De dónde sale

Fran, 2026-10-19 (memoria `arbol-de-conocimiento.md`): pagar contexto por el método es lógico, pero hay que
administrarlo. **El tronco va siempre**, en cualquier sesión: requisitos (cómo se escriben, qué va en cada nivel) y el
handbook. **Las ramas, según el proyecto y su complejidad**: el telescopio pide ciclo NASA completo; un TP de IISE pide
la teoría de los libros y **no** las lecciones de BLACK; lo sencillo no lleva un arsenal. **Ante la duda, que sobre.**
**Lo fundamental primero**, después los módulos.

No es una pieza nueva: es el diseño de **T19, «cascada proporcional»** (lluvia §6, fila 1c), cuyos requisitos ya
existen en [`10-requisitos.md`](10-requisitos.md): L0-06 (costo proporcional a la necesidad), L1-01 (arranque ≤ 90 000
caracteres), L1-07 (pregunta sin proyecto ≤ 30 000), L1-08 (la lectura escala con necesidad y naturaleza). Lo que Fran
agregó hoy es la forma: un tronco que nunca se recorta.

## 1. Lo que pesa hoy (medido el 2026-10-19)

Instrumentos: [`medir-costo.py --ultimas 3`](../medir-costo.py) (lo que llegó a las tres últimas sesiones) y
[`medir-arbol.py`](../medir-arbol.py) (lo que la puerta exige, por pieza; control: el libro da 17 601 y el documento de
requisitos 62 534, los mismos números que imprime la cascada y que midió DA-071).

**El arranque, en toda sesión** (con o sin proyecto): mediana **93 273** caracteres. **L1-01 pide ≤ 90 000: hoy
FALLA** (con T12 validada era 78 070). Desglose de la última sesión:

| Pieza | Caracteres | ¿Es tronco? |
|---|---|---|
| núcleo del chequeo (4 partes) | 26 719 | mezcla: lecciones generales y de proyectos |
| enrutador `CLAUDE.md` (claude-acceso) | 17 078 | no: el índice de proyectos, Drive, frenos |
| perfil `~/.claude/CLAUDE.md` | 14 159 | sí: las reglas |
| pilares (2 partes) | 12 731 | sí: el porqué de las reglas |
| índice de la memoria `MEMORY.md` | 10 779 | mezcla |
| apertura (el cuadro y el cierre) | 6 454 | sí |
| arranque de claude-acceso (autorizaciones y estado medido) | 4 728 | sí |

**El libro de bolsillo (`nucleo-ise.md`, 17 601) NO está en el arranque.** Llega sólo al entrar a un proyecto (es la
base de la puerta: `exigido()` lo agrega sólo con proyecto). `confirmado` leyendo el código y el desglose. Es decir:
**el tronco que Fran quiere en toda sesión es justamente lo único del tronco que no va siempre.**

**Al entrar a un proyecto** (lo que la puerta exige leer, una vez por sesión):

| Proyecto, necesidad, concepto | Total | Tronco (libro) | Del proyecto (naturaleza, contrato, estado, requisitos) | Ramas (necesidad + concepto) |
|---|---|---|---|---|
| arquitectura-se, metodo+diseno | 160 446 | 17 601 | 119 474 | 23 371 |
| telescopio, diseno, escribiendo requisitos y alcance | 241 647 | 17 601 | 80 746 | 143 300 |
| black, ingenieria-inversa, pcsx2 | 156 640 | 17 601 | 90 545 | 48 494 |
| TP de IISE, materia, escribiendo requisitos y alcance | 187 339 | 17 601 | 12 858 | 156 880 |
| física espacial, materia, typst | 126 766 | 17 601 | 43 304 | 65 861 |
| coaching, ninguna | 34 471 | 17 601 | 16 870 | 0 |

Los conceptos, solos: `requisitos` 96 001 (7 lecturas), `freno` 48 580, `alcance` 40 162, `pcsx2` 23 144, `typst`
20 390.

**El núcleo del chequeo** (en toda sesión): 193 viñetas, 25 193 caracteres. Por la lección que las originó
(`probable`: se atribuye por el renglón anclado o por la regla): **55 nacieron en BLACK**, 49 son generales, 32 no
tienen lección que las ancle, 19 de arquitectura-se, 14 de física espacial; el resto, de a 1 a 7 por proyecto. Que una
viñeta naciera en BLACK no la hace de BLACK («un cero acusa al parámetro» nació ahí y vale para todo); lo que sí es rama
sin discusión son las secciones enteras de un oficio (la GUI nativa, el emulador, el decompilador).

**La memoria** (índice, en toda sesión): 61 memorias, 10 984 caracteres; a ojo (`hipótesis`, clasificado por palabra),
~55 % es cómo se trabaja y el resto materias, BLACK, la máquina, el telescopio y personas.

## 2. Lo que eso dice

1. **El tronco está al revés.** Lo que va siempre es lo que más pesa y menos tronco es (el enrutador, viñetas de oficios
   puntuales, memorias de proyectos); el libro, que es el tronco, va sólo si hay proyecto.
2. **Dos pedidos de Fran chocan y hay que elegir**: L1-07 (una pregunta sin proyecto, en un párrafo, ≤ 30 000) y «el
   tronco en cualquier sesión». Hoy una pregunta suelta paga 93 K; el libro solo ya es 17,6 K.
3. **Al entrar, lo más pesado es el propio proyecto**, no el método: arquitectura-se 119 K (su estado y sus requisitos),
   BLACK 90 K. Son estados y documentos que crecen sin techo (DA-016, DA-071): la rama «proyecto» también se dosifica,
   con vistas cortas.
4. **El concepto `requisitos` (96 K) es la rama más cara**, y es la que Fran pide que sobre en un TP. El libro de bolsillo
   ya trae su resumen (§4): con el tronco siempre presente, la rama puede bajar por nivel (lo que se escribe: L0, L1 o
   L2) sin perder lo fundamental.

## 3. El giro de Fran (2026-10-19, después de la v1)

La v1 de la propuesta (bajar el arranque de 93 K a ~77 K moviendo ramas) **quedó descartada el mismo día**: optimizaba
el costo, y Fran puso el costo al final. Sus palabras, resumidas sin cambiarles el sentido:

- **Que la arquitectura ande bien; el costo es lo que se deja holgado** y se optimiza con el uso, no de entrada («ya nos
  pasó múltiples veces» que un diseño no anduvo de una). Se sacrifica costo a cambio de mejor planificación, desempeño y
  menos riesgo.
- **Nada se activa por nombrar una palabra.** «Si yo no le digo la palabra publicar, no sepas nada sobre lo que tengo en
  el Drive»: así quedan huecos cada vez que Fran dice algo de una forma que no está registrada. **La sesión interpreta el
  pedido** y lo clasifica (proyecto, materia, necesidad); y siempre sale con el tronco.
- **El tronco aparece donde hay ingeniería de sistemas**; una pregunta suelta y específica que no la necesita va sin él.
- **La rama es lo que compete al pedido, en alto nivel**: en un módulo de BLACK no se lee todo BLACK, pero sí todas sus
  lecciones y lo que toque el tema; en la punta de Física Espacial, el Drive (seguramente haya que actualizarlo), los
  criterios de la materia y las lecciones de cómo armar el PDF. **Leer de más** hasta que el uso diga qué sobra, y que
  la sesión se lo diga a Fran.
- **No pasar por arriba de un procedimiento sin preguntarse si está bien planteado.** Casos: el L0 del TP de IISE (error
  conceptual que «no puede pasar nunca más») y el ensayo del coop de BLACK repetido cientos de veces moviendo al jugador
  1 y recién después al 2, cuando hacía falta probar a los dos. Así se generó la arquitectura con errores: diseñando lo
  específico mientras lo importante quedaba sin reconocer.

## 4. Las decisiones de Fran

| Fecha | Pregunta | Respuesta |
|---|---|---|
| 2026-10-19 | ¿Una pregunta suelta, sin proyecto, lleva el tronco? | «Preguntámelo por cada sesión que no sea de proyecto o materia» — **reemplazada** por el giro (§3) y la fila de abajo |
| 2026-10-19 | ¿Cómo se le hace lugar al tronco en el arranque? | «Haceme la propuesta y, después de mi comentario, lo decidimos» → v1, descartada por el giro |
| 2026-10-19 | En la duda sobre si el pedido lleva ingeniería de sistemas | **Se carga el tronco** (que sobre) |
| 2026-10-19 | Qué es el tronco en una sesión con ingeniería de sistemas | **El libro de bolsillo más las fuentes de requisitos completas** (GtWR, NASA apéndice C, cátedra), aunque esa sesión no escriba requisitos |
| 2026-10-19 | Quién saca una lectura que el uso muestra que no sirvió | **Fran, con la propuesta de la sesión** (qué no se usó y por qué conviene sacarlo o activarlo distinto) |
| 2026-10-19 | Un procedimiento heredado mal planteado para la necesidad | **La sesión lo corrige y avisa**; pregunta sólo si cambia lo que Fran ejecuta o lo que se busca |

## 5. La propuesta v2 (para el OK final de Fran; nada construido)

Cinco piezas, en el orden en que dependen (lo fundamental primero). Ninguna optimiza costo: el costo lo va a ir
proponiendo el lazo de la pieza D.

| # | Pieza | Qué hace | Qué error evita |
|---|---|---|---|
| A | **La clasificación, obligatoria y por interpretación** | Al empezar, toda sesión que vaya a actuar declara qué es el pedido: `suelta`, o trabajo con ingeniería de sistemas, con proyecto o materia, naturaleza, tema y necesidad. La puerta niega actuar hasta que esté declarada, **en toda sesión**, no sólo cuando una palabra infiere un proyecto. Las señales por palabra pasan a ser un **control cruzado**: si la sesión dijo `suelta` y el pedido nombra un proyecto, o la acción toca su carpeta, o se escribe un requisito, la puerta pide reclasificar. En la duda, la clase más pesada | los huecos por cómo se dijo algo; el disparo por palabra (DA-056, DA-072) |
| B | **El tronco, en toda sesión con ingeniería de sistemas** | El libro de bolsillo **más** las fuentes de requisitos y del alcance completas (las reglas del GtWR, el apéndice C de NASA, los ejemplares de NASA Level 1, la cátedra M17-M21, la ficha del alcance), exigidas al declarar la clase, antes de la primera acción. Los disparos por título de sección de hoy quedan como red de abajo para la sesión que se clasificó `suelta` y termina escribiendo un requisito | el L0 del TP (un error conceptual con los libros en el repo) |
| C | **La rama: la naturaleza y el tema del pedido, en alto nivel** | Cada naturaleza trae lo que le compete siempre, sin palabra: una **materia**, sus criterios de cátedra, el estado de su Drive (lo publicado y lo que falta subir), sus contenidos mínimos y las lecciones de PDF y Typst; un **proyecto de ingeniería**, todas sus lecciones, su programa o PDP y el documento del **tema** que se toca (no todos). Cada proyecto grande tiene un mapa de temas con sus lecturas, que arma la sesión desde sus documentos y se muestra a Fran | «no sabías lo del Drive porque no dije publicar»; leer todo BLACK para un módulo |
| D | **El lazo de uso** | Al cerrar, la sesión dice qué lecturas usó para decidir y cuáles no; una herramienta lo acumula por clase de sesión. Lo que no se usó en varias sesiones de la misma clase le llega a Fran como propuesta (sacarlo o activarlo distinto); sale sólo con su sí. Límite declarado: es lo que la sesión dice de sí misma, el sensor más débil (DA-043); se mejora con el uso | leer de más para siempre, sin que nadie lo revise |
| E | **El procedimiento se revisa antes de correrlo** | Quinta pregunta del libro (§7), en el tronco: «¿este procedimiento produce lo que la necesidad pide?» (el ensayo del coop prueba a los dos jugadores a la vez, no a uno y después al otro). Mal planteado: se corrige y se avisa; se pregunta sólo si cambia lo que Fran ejecuta o lo que se busca. Y la auditoría lo pregunta al cerrar | los ensayos repetidos sobre un planteo equivocado |

**Lo que cambia en los requisitos:** una necesidad nueva de Fran (interpretar el pedido y llegar con el conocimiento de
su naturaleza, sin depender de una palabra; el tronco siempre que haya ingeniería de sistemas); L1-01 y L1-07 dejan de
ser techos y pasan a TBR, como metas que el lazo D va a ir fijando; L1-08 se reescribe (la lectura sale de la
clasificación de la sesión, no de la palabra).

**Lo que queda igual:** la puerta como freno (falla cerrado), la Mención, el retiro del núcleo por uso (T18) y lo que ya
llega al paso (`al-paso.py`).

**Costo, dicho una vez:** una sesión de ingeniería va a leer bastante más que hoy (el tronco con sus fuentes es varias
veces el libro solo). Es lo que Fran eligió: que sobre, y que el uso diga qué se saca.

**OK de Fran a la v2, el 2026-10-19**: «escribí los requisitos del árbol y arrancá por las piezas A y B». Requisitos:
[`10-requisitos.md`](10-requisitos.md) §13 (N-11, N-12, L0-11, L0-12, L1-24..29; L2 de A y B), 23 enunciados, 0 VIOLA
del GtWR.

**Orden y estimación** (`hipótesis`, por lo que costaron T15-T18): A y B, 1-2 sesiones; E, en la misma (es una regla
del libro y una pregunta de la auditoría); C, 1-2 sesiones, más el mapa de temas de cada proyecto grande la primera
vez que se entra; D, 1 sesión. Validación (P10): una sesión real de cada clase (una materia, un módulo de BLACK, el
telescopio, una suelta) con la auditoría diciendo si la clasificación, el tronco y la rama fueron los correctos.

## 6. Construidas: las piezas A y B (2026-10-19, sesión `cfe21436`)

**Dónde.** La puerta (`.claude/hooks/cascada_puerta.py`), el catálogo (`.claude/cascada.json`: claves `clasificacion` y
`tronco`, cada una con su `_porqué`), `cascada.ps1` y `.claude/cascada.sh` (las dos clases nuevas, con la misma sintaxis
en la PC y en la nube). La puerta se editó en una copia y se instaló de una vez, con su autotest en verde antes del
cambio: nunca quedó rota (lección 346).

**Decisiones técnicas, y por qué.**

- **Qué clasifica**: `-Suelta "qué es"`, `-Ingenieria "qué es"` o la necesidad declarada de un proyecto (L2-PTA-33).
  La Mención y la Excepción no clasifican: dicen de qué *no* es la sesión. Si la acción toca un proyecto todavía sin
  declarar, manda el freno de siempre (pide su necesidad, que también clasifica): así el mensaje es el más útil.
- **Se registra en PreToolUse** (L2-PTA-32): un comando que sale con error no dispara el registro de después.
- **La invocación de la cascada siempre pasa** (L2-PTA-34): es la única salida, y tiene que quedar abierta.
- **El freno se apaga sólo a la vista** (L2-PTA-35, L2-VER-05): sin la clave, se exige; `"exigida": false` lo apaga
  (lo que se instala solo se desinstala solo) y el arranque lo muestra en rojo.
- **El tronco = la base que no depende del proyecto (el libro) + los conceptos `requisitos` y `alcance`**, exigido
  antes de **cualquier** acción de una sesión de ingeniería, toque o no el proyecto (L2-PTA-37/38). Hoy pesa 141 315
  caracteres (~40 K tokens) por sesión: es lo que Fran eligió («que sobre»).
- **Qué naturalezas llevan tronco**: `ingenieria` y `documentos` (las materias son de la carrera de ingeniería en
  sistemas espaciales: en la duda, se carga); `seguimiento` no. Es dato del catálogo, no código: el lazo D lo ajusta.
- **El aviso antes del freno** (L2-PTA-36): mientras la sesión no clasificó, cada pedido de Fran trae una línea con los
  tres comandos, sin mirar ninguna palabra.

**La V: cada requisito contra su resultado.**

| Requisito | Resultado | Evidencia |
|---|---|---|
| L2-PTA-30, 31 | verificado | autotest caso 24 (deny con las tres clases y la ruta absoluta), mutante «sin el freno» visto |
| L2-PTA-32 | verificado | caso 24 (`-Suelta` en PreToolUse y después Edit pasa), mutante «la clase no se registra» visto |
| L2-PTA-33 | verificado | caso 24 (declarar `coaching` clasifica), mutante «declarar no clasifica» visto |
| L2-PTA-34 | verificado | caso 24 (invocar la cascada sin clasificar pasa) |
| L2-PTA-35 | verificado | caso 24 (catálogo sin la clave: niega), mutante «la clave ausente apaga» visto |
| L2-PTA-36 | verificado | caso 24 (el pedido sin clasificar lo dice; clasificado, calla) |
| L2-VER-05 | verificado | caso 24 (`--verificar` en rojo con `"exigida": false`) |
| L2-CAS-06 | demostrado | `cascada.ps1` y `cascada.sh` con `-Suelta` y `-Ingenieria`: código 0 en los dos |
| L2-PTA-37 | verificado | caso 25 (telescopio declarado, acción fuera: niega por el libro), mutante «el tronco sólo al tocar el proyecto» visto |
| L2-PTA-38 | verificado | caso 25 (`-Ingenieria` sin el tronco: niega por el GtWR; leído, pasa), mutante «Ingeniería sin tronco» visto |
| L2-PTA-39 | verificado | caso 25 (`-Suelta` pasa sin tronco; `coaching`, de seguimiento, también), mutante «tronco para toda naturaleza» visto |
| L2-VER-06, 07 | verificado | caso 25 (concepto inexistente y tronco vacío: `--verificar` en rojo) |
| L2-CAS-07 | verificado y demostrado | caso 25 (`--tronco` y `--exige telescopio` imprimen el tronco con rangos); `cascada.ps1 -Ingenieria` lo imprime |

**Efecto real**, por el lanzador (como lo corre la app), con el catálogo real y sesiones nuevas
(`scratchpad/demo_t19.py` de la sesión): el pedido sin clasificar lo dice; un comando sin clasificar se niega;
`-Ingenieria` pasa; el comando sin el tronco se niega con 14 lecturas pendientes; leído, pasa; otra sesión con
`-Suelta` pasa sin tronco; clasificada, el pedido calla. **Falta**: la validación en sesiones reales de cada clase (P10).

**De paso, en el autotest de la puerta.** El ayudante que corre el hook ahora le pasa `CASCADA_RAIZ`: los mutantes
viven en una carpeta temporal, y sin ella su raíz salía de esa carpeta. Medido: la puerta vieja copiada a una carpeta
temporal **no ve ningún proyecto** y deja pasar el comando de DA-070 que con la raíz niega, así que el mutante de ese
caso «se veía» por esa razón y no por la suya. Con la raíz, los dos mutantes de DA-070 se siguen viendo, ahora por su
mecanismo. Tres casos viejos se adaptaron porque el tronco cambió su premisa (el rango leído a medias no puede estar
contenido en otro; el disparo del concepto `requisitos` se mide con ingeniería sin tronco; el segundo proyecto de DA-070
lee el tronco antes, para que lo único pendiente sea su base). Los casos anteriores a T19 clasifican su sesión como
`suelta`, como lo haría una sesión real.

## 7. Construida: la pieza C, la rama (2026-10-19, sesión `125f02e6`)

Requisitos: L1-26 y su L2 (L2-PTA-40..45, L2-APR-12, L2-VER-08..12, L2-CAS-08/09) en
[`10-requisitos.md`](10-requisitos.md) §13, 14 enunciados, 0 VIOLA del GtWR (con el glosario sin acentos: DA-076).

**Lo que había y por qué no alcanzaba.** La puerta ya sumaba, a la necesidad declarada, las necesidades «por defecto»
de cada proyecto: `fisica-espacial` y `software-de-vuelo` traían `publicar`; `apunte-iise` y el TP de IISE, no. Lo que le
compete a un proyecto dependía de cómo estaba escrita su fila, no de qué clase de proyecto es; las lecciones llegaban
como doce títulos y un comando; los criterios de cátedra, como una línea del contrato («primero CRITERIOS.md») que había
que acordarse de seguir; y en un proyecto grande se leía el estado entero y ningún documento del tema.

**Dónde.** El catálogo (`.claude/cascada.json`: `ramas`, `catedras` en cada proyecto de `documentos`, `temas` en
arquitectura-se, cada uno con su `_porqué`), la puerta (`exigido()` arma la rama; `pre()` la exige; `--verificar`,
`--exige`), `perfil-global/herramientas/aprender.py` (la ficha de cada proyecto) y `cascada.ps1` / `.claude/cascada.sh`
(`-Tema`). La puerta se editó en una copia al lado, con su autotest en verde, y se instaló moviendo la copia (lección 346).

**Decisiones técnicas, y por qué.**

- **La rama sale de la NATURALEZA**, no de la necesidad ni de una palabra: `documentos` = las necesidades `materia` y
  `publicar`, el concepto `typst`, las lecciones del proyecto y los criterios de cada cátedra que el proyecto declara;
  `ingenieria` y `seguimiento` = las lecciones del proyecto. Es dato del catálogo, no código: el lazo D lo ajusta.
- **Se exige antes de cualquier acción** de la sesión que declaró el proyecto, como el tronco (L2-PTA-40): el Drive se
  toca desde la raíz, fuera de la carpeta del proyecto. La Excepción y la Mención no la cargan (dicen que la sesión no es
  de ese proyecto).
- **Las lecciones del proyecto son una vista generada**: `aprender.py` escribe `perfil-global/aprendizaje/fichas/
  proyectos/<proyecto>.md` para cada proyecto del catálogo cada vez que escribe las fichas de grupo (L2-APR-12), una
  lección por título `##`. Un proyecto sin lecciones tiene la suya, que lo dice: la ficha ausente sólo puede ser el
  generador roto, y la puerta niega.
- **La cátedra se declara siempre** en los proyectos de `documentos` (`[]` si ninguna): la puerta niega sin la clave, y
  `--verificar` da rojo (L2-VER-11). Hoy: iise (apunte-iise, repaso-iise, trabajo-final-iise), fisica-espacial,
  software-de-vuelo (también cohete-de-agua, que es de Petrilli), taller-de-fisica (más los generales de Aníbal, en
  fisica-espacial).
- **El tema**: `-Tema <t>[,<t>]` en la misma línea de la cascada; se registra en PreToolUse y la última declaración
  reemplaza a la anterior (así se corrige un tema mal escrito). Sin tema válido la puerta niega mostrando el mapa
  (L2-PTA-43/44); `todos` exige cada documento del mapa. El primer mapa es el de arquitectura-se, armado desde el índice de
  su contrato: 17 temas (t1, t7, t11-t20, libro, defectos, orden, diseño, validación). **BLACK y el telescopio todavía no
  tienen mapa**: `--verificar` los lista (L2-VER-12); lo arma la sesión que entre a cada uno, desde sus documentos, y se
  le muestra a Fran.
- **Lo largo se parte**: una lectura de la rama sin rango se exige entera y partida en lecturas que entran. Dos cosas
  medidas al construir: `DEFECTOS-ARQUITECTURA.md` tiene una sección de 62 K que no se parte por títulos (ahora el
  partidor corta también por líneas), y el tope de 60 000 caracteres ya estaba medido por encima de lo que entrega el Read
  (DA-071: 56 702 dieron 25 949 tokens): bajó a 50 000. Efecto: el documento de requisitos ahora se exige en dos rangos
  que entran de a uno (1-249 y 250-444).

**Lo que pesa** (lo que la puerta exige al entrar, una vez por sesión, medido con `--exige` el 2026-10-19): telescopio
253 K caracteres, BLACK 372 K (su ficha de lecciones son 94 K), apunte-iise 259 K, TP de IISE 242 K, fisica-espacial
284 K, arquitectura-se con un tema 355 K, coaching 45 K. Es lo que Fran eligió (que sobre); el lazo D dirá qué no se usó.

**La V: cada requisito contra su resultado** (autotest de la puerta, caso 26, sobre un árbol sintético sin base ni
tronco, para que lo único exigido sea la rama; 9 mutantes vistos).

| Requisito | Resultado | Evidencia |
|---|---|---|
| L2-PTA-40 | verificado | caso 26: materia declarada, acción fuera, sin la rama → niega; leída → pasa; mutante «la rama sólo al tocar el proyecto» visto; la Excepción no la carga |
| L2-PTA-41 | verificado | caso 26: sin leer las lecciones → niega; la ficha ausente → niega (falla cerrado); mutantes «sin las lecturas propias» y «falla abierto ante un archivo que falta» vistos |
| L2-PTA-42 | verificado | caso 26: sin los criterios de la cátedra → niega; sin la clave `catedras` → niega; mutante «sin la clave pasa» visto |
| L2-PTA-43 | verificado | caso 26: sin tema → niega con el mapa; mutante «no pide el tema» visto |
| L2-PTA-44 | verificado | caso 26: tema fuera del mapa → niega; corregido declarando de nuevo → pasa; mutante «el tema que no está vale» visto |
| L2-PTA-45 | verificado | caso 26: t1 sin su documento → niega; t1 leído → pasa sin t2; `todos` exige los dos; mutantes «el tema no exige su documento» y «el tema no se registra» vistos |
| L2-APR-12 | verificado | autotest de `aprender.py`: la ficha de cada proyecto del catálogo, una lección por `##`, la del proyecto vacío y la sobrante borrada; sin catálogo no toca nada; mutante «generador apagado» visto |
| L2-VER-08..11 | verificado | caso 26: cada uno en rojo con su marca; el catálogo sano sin ninguna; mutante «una naturaleza sin rama pasa» visto en la puerta |
| L2-VER-12 | verificado | caso 26: un proyecto grande sin mapa se lista; el arranque real lista black y telescopio |
| L2-CAS-08, 09 | verificado y demostrado | caso 26 (`--exige` imprime el mapa, el tema y la rama); `cascada.ps1 arquitectura-se -Necesidad metodo,diseno -Tema t19` en esta sesión |

**Efecto real**, en esta misma sesión, con la puerta instalada: arquitectura-se estaba declarado sin tema y la primera
edición se negó con «TEMA SIN DECLARAR» y el mapa; declarado `-Tema t19`, la puerta pidió la ficha de lecciones del
proyecto (la del tema ya estaba leída); leída, la edición pasó.

**De paso: DA-075 arreglado** (el recorte de lo pegado, T14, estaba ciego: la app cierra el bloque con atributos y la
puerta infería proyectos del retome pegado; así frenó esta sesión por «BLACK»). El patrón acepta el cierre con
atributos, el fixture lo arma como la app, un mutante con el cierre viejo se ve, y un caso nuevo prueba el recorte
contra los pedidos pegados REALES de los transcripts de la máquina: 17 de 17 recortados, y con el patrón viejo 17
ciegos (sin transcripts, sale SALTEADO, nunca verde).

**Límites declarados.** (1) La ficha de lecciones trae las reglas y no los renglones del núcleo, pero una regla que
copie el comienzo de una viñeta contaría como uso de la viñeta para T18; a medir en la primera pasada de retiro con la
rama activa. (2) En la nube el repo privado de cátedras no está: la puerta niega en las materias hasta traerlo
(`estado-nube.py --traer catedras`), como cualquier exigido ausente. (3) El tema lo elige la sesión: uno equivocado lee
el documento equivocado, y nada lo ve todavía; el lazo D (las lecturas sin uso por clase de sesión) es el primer sensor.

## 8. Construida: la pieza E, el procedimiento (2026-10-19, sesión `4a1da036`)

Requisitos: L1-30 (nuevo: la mitad «antes de correr» de L1-29) y su L2 y el de L1-29 (L2-LDB-01..03, L2-AUD-04..08) en
[`10-requisitos.md`](10-requisitos.md) §13; 0 VIOLA del GtWR (el mismo chequeo dio 4 antes de pasar «ninguno» y «el no»
a términos definidos).

**Dónde.** La quinta pregunta del libro de bolsillo (`perfil-global/pilares/nucleo-ise.md` §7) con su fila de grado
`casa` en [`da013-libro-contra-fuente.md`](da013-libro-contra-fuente.md); la auditoría (`auditar-sesion.py`: P12 y la
opción `--procedimiento`); el cierre del protocolo (`perfil-global/apertura-proyecto.md`) y el enrutador (`CLAUDE.md`),
que ahora muestran las dos opciones nuevas.

**Decisiones técnicas, y por qué.**

- **La pregunta va en el libro, no en un hook nuevo**: el libro es tronco y llega entero a toda sesión de ingeniería
  antes de su primera acción (L1-25). Al cerrar, la auditoría la pregunta.
- **P12 sin respuesta es ROJO** (P9 es AMARILLO): es el único sensor de N-12, y un amarillo no exige. Contestarla cuesta
  una opción: `--procedimiento "qué | qué tiene que producir | produce"`, o `ninguno`.
- **Los tres resultados son la decisión de Fran** (§4): `produce`; `corregido: qué` (se corrigió y se avisó);
  `preguntado: qué` (la corrección cambiaba lo que Fran ejecuta o lo que se busca).
- **El control cruzado** (como las señales de la pieza A): la auditoría lista lo que la caja negra vio correr 3 veces o
  más y da AMARILLO si no figura en lo declarado. Cuenta el script **invocado** al principio de un tramo del comando
  (no el que nombra un `echo` o un mensaje de commit), con su subcomando, y sólo lo que la puerta dejó pasar. Lista y no
  frena: la repetición incluye registros (`aprender.py agregar`), y un ROJO tendría falsos positivos.
- **El umbral se midió antes de fijarlo** (spike sobre las 95 cajas negras de la máquina, 60 con scripts): con la clave
  «script» sola, 46 sesiones tenían algo repetido 3 veces o más (mediana 2 por sesión); con «script + subcomando» por
  tramo, 32 (mediana 1). TBR 3.

**La V: cada requisito contra su resultado** (autotest de `auditar-sesion.py` y [`probar-t19de.py`](../probar-t19de.py),
14 mutantes vistos en su caso, cada uno con su caso sano en verde en la misma corrida).

| Requisito | Resultado | Evidencia |
|---|---|---|
| L2-LDB-01..03 | inspeccionado | §7, quinta pregunta; `verificar-libro.py`: LIBRO OK (18/18 citas en cursiva con destilado, ninguna cláusula de escape) |
| L2-AUD-04, 08 | verificado | autotest «E: sin declaración de contraste»: ROJO con la forma de `--procedimiento`; mutante «sin declaración pasa» visto |
| L2-AUD-05 | verificado | autotest: sin resultado, y con un resultado que no es de Fran («ok»), ROJO; mutante «cualquier resultado vale» visto |
| L2-AUD-06 | verificado | autotest: el repetido sin contraste da AMARILLO con «x3»; el `echo` que nombra un script y lo negado no cuentan; mutantes «umbral inalcanzable» y «lo negado cuenta» vistos |
| L2-AUD-07 | verificado | autotest: VERDE con el repetido declarado, y con `ninguno` sin repetidos |

**Efecto real**, con la auditoría nueva sobre esta misma sesión (sin escribir): P12 dio ROJO por la forma y listó lo
que de verdad repetí (`medir_proc.py x3`, el autotest de la copia de la auditoría `x3`); P4 pasó a VERDE con el tema
declarado.

**De paso, dos defectos encontrados y arreglados antes de instalar.** (1) **P4 daba AMARILLO falso** «TEMA SIN DECLARAR»
a la sesión que sí lo había declarado: la auditoría calculaba lo exigido sin los temas (pieza C cambió la puerta y no la
auditoría; medido en la auditoría de `125f02e6`); caso y mutante nuevos. (2) El control positivo encontró que un script
invocado por una ruta **con espacios entre comillas** («01 - UNSAM») no se contaba: el patrón se arregló antes de que el
caso pasara.

## 9. Construida: la pieza D, el lazo de uso (2026-10-19, sesión `4a1da036`)

Requisitos: L2-AUD-09..12 y L2-USO-01..07 en [`10-requisitos.md`](10-requisitos.md) §13; 0 VIOLA.

**Dónde.** La auditoría (P13, `--uso`, y la muestra en `.claude/auditorias/uso-lecturas.jsonl`), la herramienta nueva
`uso-lecturas.py` (raíz: `proponer`, `decidir`, `verificar`, `--autotest`), la cascada (`cascada.ps1` y
`.claude/cascada.sh`, al declarar un proyecto o `-Ingenieria`) y `chequeo-completo` (el medidor en la capa rápida, el
saboteador en la lenta).

**Cómo anda el lazo.**

1. Al cerrar, la sesión dice qué lecturas exigidas usó y para qué decisión: `--uso "nucleo-ise.md, reglas.md | escribir
   el L2 de E"` (una opción por decisión), o `--uso ninguna`.
2. La auditoría calcula las lecturas exigidas de la sesión por clase (`proyecto:<naturaleza>` o `ingenieria`) con la
   misma `exigido()` de la puerta, marca las usadas y, con `--escribir`, guarda una muestra por clase al lado del
   informe. Auditar dos veces la misma sesión reemplaza su muestra.
3. `uso-lecturas.py` acumula: una lectura exigida y sin uso en **5 muestras** seguidas de su clase —contadas desde su
   último uso y desde la última decisión de Fran sobre ella— es una **propuesta**. La cascada la imprime al declarar esa
   clase, y la sesión la lleva al cuadro (Lo tuyo).
4. Fran decide y la sesión lo registra con sus palabras: `python uso-lecturas.py decidir --clase <c> --ruta <r> --si|--no
   --fran "<lo que dijo>"`. Un sí se aplica en `.claude/cascada.json` (sacarla o activarla distinto); si una muestra
   posterior la sigue exigiendo, el medidor da ROJO. Un no reinicia la ventana.

**Decisiones técnicas, y por qué.**

- **La unidad es el archivo por clase**: los rangos de un archivo son una lectura, y si el catálogo cambia el rango la
  cuenta sigue. La clase es la naturaleza porque la rama y el tronco se deciden por naturaleza (pieza C): ahí se ajustan.
- **Los conceptos que dispara una acción** (freno, typst) no entran: ya se activan por el rol de la acción.
- **Sin declaración no hay muestra**, y P13 da ROJO: un sensor ciego vería todo sin uso (como T18, L2-RET-06).
- **Un nombre que no coincide** con ninguna exigida da AMARILLO (mal escrito, o señal de que falta en la rama); uno
  ambiguo («readme.md») marca todos los que coinciden: la dirección segura es de más usado, nunca de más propuesto.
- **La propuesta no es un rojo del arranque**: depende de Fran, y un rojo que la sesión no puede arreglar frena todo lo
  demás. Sí son rojo el registro roto y el sí sin aplicar.
- **Las rutas se guardan igual en la PC y en la nube**: perfil-global anclado por su nombre (vive adentro del árbol en
  la PC y al lado en la nube), lo de la carpeta del usuario con `~/`.

**La V: cada requisito contra su resultado.**

| Requisito | Resultado | Evidencia |
|---|---|---|
| L2-AUD-09 | verificado | autotest «D: sin declaración de uso»: ROJO con la forma de `--uso`, sin muestra; mutante «sin declaración pasa» visto |
| L2-AUD-10 | verificado | autotest: archivo sin la decisión, ROJO y sin muestra; mutante «nada es incompleto» visto |
| L2-AUD-11 | verificado | autotest: un archivo que no es exigido da AMARILLO y no marca nada; un nombre ambiguo marca los dos README; mutante visto |
| L2-AUD-12 | verificado | autotest: la muestra se escribe una vez aunque se audite dos veces, y lo ajeno y lo ilegible quedan; sin declaración no hay muestra; sobre el catálogo real, la clase del proyecto trae el libro y el documento del tema y la de ingeniería el tronco; mutante «se duplica» visto |
| L2-USO-01 | verificado | autotest de `uso-lecturas.py`: 5 sin uso proponen, 4 no, un uso en el medio reinicia; mutante visto |
| L2-USO-02 | demostrado | `cascada.ps1` y `cascada.sh`, por la frontera real, contra una raíz sembrada: imprimen la propuesta al declarar arquitectura-se y `-Ingenieria`, código 0; sin muestras, una línea con la cuenta |
| L2-USO-03 | verificado | autotest: la decisión queda con fecha, clase, lectura, veredicto y las palabras de Fran |
| L2-USO-04 | verificado | autotest: sin palabras, y con una lectura que ninguna muestra exigió, se rechaza sin escribir; mutante visto |
| L2-USO-05 | verificado | autotest: un «no» calla la propuesta, y vuelve con otras 5 sin uso; mutante visto |
| L2-USO-06 | verificado | autotest: el sí con una muestra posterior que la exige da ROJO; aplicado, verde; mutante visto |
| L2-USO-07 | verificado | autotest: el renglón ilegible da ROJO con archivo y renglón, y bloquea `decidir`; la decisión sin palabras escrita a mano, también; mutante visto |

**Límites declarados.** (1) El sensor es lo que la sesión dice de sí misma (DA-043): una sesión que declara haber usado
todo calla el lazo; pedir la decisión por cada uso lo hace más caro de falsear, no imposible. (2) El ROJO de un sí sin
aplicar compara por clase: si Fran decide «activarla distinto» dentro de la misma clase (p. ej. sólo al declarar
`diseno`), daría un rojo falso; se resuelve cuando pase, con el alcance escrito en la decisión. (3) La primera propuesta
llega después de cinco sesiones auditadas de una clase con `--uso`: esta sesión es la primera muestra. (4) La muestra va
en el commit del informe de la auditoría (`.claude/auditorias/`).
