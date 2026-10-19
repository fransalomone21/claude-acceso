# T19 — el árbol de conocimiento: tronco fijo, ramas por proyecto

**2026-10-19, sesión de diseño (abierta).** Estado: **medido y con propuesta (§6); falta el comentario final de Fran**
para decidir. Nada construido.

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

## 3. Lo que decide Fran (valor, no técnica)

- **¿Una pregunta suelta, sin proyecto, lleva el tronco?** Si sí, L1-07 se reescribe (el techo sube a lo que pese el
  tronco); si no, el tronco va desde que hay trabajo de proyecto.
- **¿Cómo se le hace lugar al tronco?** Sacar del arranque lo que es de un proyecto (y que vuelva al entrar), subir el
  techo de L1-01, o las dos.

Respuestas: §5, cuando lleguen.

## 4. Cómo sigue

1. Con las respuestas, los requisitos de T19 (L1 y L2 del árbol), con el concepto `requisitos` leído. Dónde: el
   documento del método ya no entra en una lectura (DA-071); el árbol se aplica a sí mismo y es candidato a partirse
   por T-n.
2. El trade de qué sale del arranque, con los pesos de Fran (efectividad > costo > plazo, lluvia §7).
3. Construir de a una pieza, cada una con su saboteador: el libro al arranque; el núcleo partido por oficio (lo de un
   oficio llega al entrar o al paso, como ya hace `al-paso.py`); el índice de la memoria partido igual.
4. Validar con `medir-costo.py` antes y después (L1-01, L1-07) y en una sesión real de cada clase (P10).

## 5. Las decisiones de Fran

Preguntadas el 2026-10-19 (AskUserQuestion), con la medición de §1 a la vista:

| Pregunta | Respuesta de Fran |
|---|---|
| ¿Una pregunta suelta, sin proyecto, lleva el tronco? | «Preguntámelo por cada sesión que no sea de proyecto o materia. Así vamos aprendiendo a gestionarlo y quizás automatizar la dosis de conocimientos necesaria.» |
| ¿Cómo se le hace lugar al tronco en el arranque? | «Dedicale pensamiento a cómo gestionar esto, haceme la propuesta que se te ocurra, y después de eso y mi comentario final lo decidimos.» → §6 |

## 6. La propuesta (para el comentario de Fran; nada construido)

**Lo que cambia el planteo.** Con la respuesta 1, el tronco **no necesita lugar en el arranque**: a toda sesión de
proyecto o de materia ya le llega primero, por la puerta, antes de la primera acción (§1); a las demás se le pregunta a
Fran. Lo que sí está mal es el arranque mismo: **93 K contra un techo de 90 K, sin nadie que lo mida**, y cargado de ramas
que paga toda sesión. La propuesta mueve cada rama al momento en que se usa, sin sacar nada del tronco y sin reglas nuevas
(cada movimiento aplica una que ya existe).

| # | Qué | Cómo | Ahorro por sesión | Regla que ya lo pedía |
|---|---|---|---|---|
| 1 | **La sesión suelta pregunta el tronco** | El recordatorio de la puerta, cuando el pedido no infiere proyecto, le dice a la sesión que le pregunte a Fran si carga el libro. Se anota la **clase** de pregunta (nunca el texto: el repo es público), si se cargó y, al cerrar, si hizo falta. Con ~10 sesiones hay datos para automatizar la dosis por clase | 0 (agrega una pregunta) | la respuesta 1; Meadows: la regla sale del dato medido |
| 2 | **El enrutador se queda con lo que enruta** | Drive, los frenos, las cuatro reglas de la estructura y «dónde está el resto» (~6,5 K) pasan a un archivo que la cascada exige al declarar `publicar` o `metodo`; quedan la cascada, las tablas de proyectos y el aviso de repo público | ~6 K | T12 (el enrutador como vista corta), que creció de 12 K a 17 K |
| 3 | **El índice de la memoria pasa a vista generada** | Cada memoria declara su proyecto en el encabezado; el índice se genera: las generales enteras, las de un proyecto (BLACK, telescopio, la MSI, Male, juegos: ~17 de 61) en una línea por proyecto, y la cascada las exige al entrar a ese proyecto | ~4 K | la tabla de memorias del perfil (los hechos de un proyecto van a su proyecto) y T20 (una copia es vista generada) |
| 4 | **El núcleo no se toca a mano** | T18 ya lo poda solo por uso real: quedan 50 viñetas vencidas, de a 10 por sesión auditada. Las secciones de un oficio (freno, fan-out, GUI) ya llegan al paso con el caso entero (`al-paso.py`) | ~6 K en ~5 sesiones | T18 (L1-17) |
| 5 | **El techo, a la vista** | El total del arranque contra L1-01 en el tablero de cada arranque, con su saboteador: si pasa de 90 K, rojo, y se decide qué rama se mueve. Hoy nadie lo mide: por eso pasó de 78 K a 93 K sin aviso | 0 (es el lazo que faltaba) | regla 3 y la viñeta «un medidor que informa el valor sin el umbral da OK sobre el defecto»; DA-041 |

**Resultado esperado** (`hipótesis`, por suma de lo medido): el arranque de **93 K a ~77 K**, con el tronco entero en
toda sesión de proyecto o materia y preguntado en las demás.

**Lo que no propongo, y por qué:**
- **Subir el techo de L1-01**: no hace falta, porque el tronco no ocupa el arranque.
- **Sacar a mano las 55 viñetas nacidas en BLACK**: la mayoría son reglas generales de medición nacidas ahí;
  clasificarlas a ojo es inventar el criterio. T18 las saca por uso medido.
- **Poner el libro en el arranque de toda sesión**: duplicaría lo que la puerta ya exige al entrar (17,6 K dos veces) y
  contradice la respuesta 1.

**Un requisito que hay que reescribir:** L1-07 (pregunta sin proyecto ≤ 30 000) es inalcanzable hoy: lo que el harness
carga solo (perfil, enrutador, índice de la memoria) ya son ~42 K, ~32 K después de 2 y 3. Pasa a TBR con el valor que
salga del registro de la pieza 1.

**Costo estimado:** requisitos de T19 y diseño fino, 1 sesión; construcción (2, 3, 5 y 1), 1-2 sesiones; validar con
`medir-costo.py` antes y después y una sesión real de cada clase. **Total: 2-3 sesiones** (`hipótesis`, por lo que
costaron T15-T18).
