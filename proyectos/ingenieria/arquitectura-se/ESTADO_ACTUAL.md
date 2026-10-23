# ESTADO ACTUAL — arquitectura-se

La fase en curso y qué la cierra: `PDP.md` §4 (dueño; la compuerta la inyecta al leer el proyecto). El orden de lo que
sigue: [`docs/lluvia-de-ideas-2026-10-12.md`](docs/lluvia-de-ideas-2026-10-12.md) §6 (dueño). Acá no se copian (T20).

**2026-10-23 (sesión lateral de correcciones técnicas, pedida por Fran desde la guía del parcial de TDC) — DA-079 Y
DA-080 ARREGLADOS (falta validarlos con 3 sesiones auditadas).** **DA-079**: `perfil-global/herramientas/lint-typst.py`
(T1-T4, sigue los `#import`/`#include`, exención por renglón escrita en el fuente) y el guardia
`perfil-global/hooks/guardia-typst.py`, que niega todo `typst compile|watch` en rojo; los compiladores envueltos
(física, electrónica, práctica, guía de TDC) lo corren antes. **Medido construyendo:** cuatro proyectos ya fijaban la
coma decimal en su plantilla (`show ","`), así que T1 se apaga por entrada donde eso está (por carpeta entera tapaba 8
comas reales: corregido con su caso). Barrido: 0 hallazgos en los apuntes; 8 en la guía del Lab 3 de TDC y 1 en la guía
del código del cohete (de esos proyectos, sin tocar). Efecto en vivo: un `typst compile` con `$0,5 V$` quedó negado en
la sesión y el mismo archivo arreglado compiló. **DA-080**: `PROBLEMAS.md` por proyecto (`plantillas/`,
`nuevo-proyecto.ps1`), `problemas.py aviso` en `cascada.ps1` y `cascada.sh`, `verificar` en la capa rápida. De paso,
en TDC: S6 (`resolver.py` rojo por número publicado sin control; 99 de 179 como deuda con tope) y la lección 147
subida a herramienta. Commits: perfil `69ef020`, `e01d766`; acá `b55938b`; TDC `3c9cb2f`.

**2026-10-19 (sesión lateral `1f168c8f`, noche) — DA-077 Y DA-078 ARREGLADOS (falta validarlos con 3 sesiones
auditadas).** L2 escrito antes ([`docs/10-requisitos.md`](docs/10-requisitos.md) §14-15: L2-PTA-46..49, L2-AUD-13; 0
VIOLA). **DA-077**: la puerta registra como leído lo que un Edit agrega al final del archivo con salto final (antes lo
buscaba sin el salto y pedía releer lo recién escrito); de paso, el salto final ya no cuenta una línea de más. Caso
10c3 del autotest con dos mutantes, y efecto real con un control que discrimina (el documento de requisitos leído con
rango exacto, dos renglones agregados al final, la edición siguiente pasó). **DA-078**: `exigido_de_sesion()` en la
puerta es la única regla de «lo exigido a esta sesión»; la usan `pre()` y la auditoría (P4, P13), y
[`probar-t19de.py`](probar-t19de.py) le da a la auditoría una puerta mutada que P4 y P13 tienen que ver (15 mutantes).
Autotests: puerta 212 BIEN, auditoría 59 BIEN. V: [`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md)
§8-9. Commits `09eda4d`, `aab7dd9`; perfil `61c7955`, `42ec9d2`. Falta: validar T19 en sesiones reales de cada clase.

**2026-10-19 (sesión `4a1da036`, noche) — T19, PIEZAS E Y D CONSTRUIDAS: las cinco piezas del árbol están.** L2
escrito antes ([`docs/10-requisitos.md`](docs/10-requisitos.md) §13: L1-30, L2-LDB-01..03, L2-AUD-04..12, L2-USO-01..07;
20 enunciados, 0 VIOLA). **E**: la quinta pregunta del libro de bolsillo (§7: ¿este procedimiento produce lo que la
necesidad pide?; mal planteado, se corrige y se avisa) y la P12 de la auditoría (`--procedimiento`, ROJO sin respuesta,
AMARILLO si un script que la caja negra vio correr 3 veces no está contrastado; umbral medido en 60 cajas negras).
**D**: el lazo de uso — al cerrar, la sesión dice qué lecturas exigidas usó (`--uso`, P13); la auditoría guarda una
muestra por clase en `.claude/auditorias/uso-lecturas.jsonl`; `uso-lecturas.py` propone a Fran lo que quedó sin uso en
5 sesiones de su clase (la cascada lo imprime al declarar) y registra su sí o su no con sus palabras. Probado: autotests
de la auditoría (59 casos) y de `uso-lecturas.py` (19), [`probar-t19de.py`](probar-t19de.py) con **14 mutantes vistos en
su caso**, la cascada de la PC y la de la nube por la frontera real, y la auditoría nueva sobre esta sesión. De paso: P4
daba AMARILLO falso con el tema declarado (arreglado) y dos defectos nuevos, **DA-077** (la puerta pide releer lo que la
sesión acaba de agregar al final de un archivo) y **DA-078** (la auditoría recalcula lo exigido por su cuenta). Diseño y
la V: [`docs/t19-arbol-de-conocimiento.md`](docs/t19-arbol-de-conocimiento.md) §8-9. Falta: validar en sesiones reales
de cada clase (P10) y que el lazo junte sus primeras cinco muestras por clase.

**2026-10-19 (sesión `125f02e6`, noche) — T19, PIEZA C CONSTRUIDA: la rama por naturaleza y el tema del pedido.**
L2 de C escrito antes ([`docs/10-requisitos.md`](docs/10-requisitos.md) §13: L2-PTA-40..45, L2-APR-12, L2-VER-08..12,
L2-CAS-08/09; 14 enunciados, 0 VIOLA). La sesión que declara un proyecto lee, antes de **cualquier** acción, lo que le
compete por su **naturaleza** y no por cómo se dijo el pedido: en una materia, `materia` + `publicar` (el Drive) +
`typst` + los criterios de su cátedra + sus lecciones; en ingeniería y seguimiento, sus lecciones (una ficha generada
por proyecto, `perfil-global/aprendizaje/fichas/proyectos/`). Un proyecto con **mapa de temas** (hoy arquitectura-se, 17
temas) niega hasta declarar el tema (`-Tema`) y exige su documento, no todos; BLACK y el telescopio sin mapa todavía
(`--verificar` los lista). Probado: autotest de la puerta BIEN (caso 26, 9 mutantes vistos), autotest de `aprender.py`
con su mutante, y el **efecto real** en esta sesión (TEMA SIN DECLARAR con el mapa → ficha de lecciones → pasa). De
paso: **DA-075 arreglado** (el recorte de lo pegado estaba ciego al cierre con atributos: 17 de 17 pedidos reales ahora
recortados), el tope de una lectura bajó a 50 000 (DA-071) y el partidor corta también por líneas; **DA-076** registrado
(el glosario del GtWR con acentos). Lo que pesa al entrar: [`docs/t19-arbol-de-conocimiento.md`](docs/t19-arbol-de-conocimiento.md)
§7. Falta: D (el lazo de uso), E (el procedimiento) y validar en sesiones reales de cada clase (P10).

**2026-10-19 (sesión `cfe21436`, tarde) — T19, PIEZAS A Y B CONSTRUIDAS: la sesión clasifica el pedido y sale con el
tronco.** Con el OK de Fran a la v2: requisitos N-11, N-12, L0-11, L0-12, L1-24..29 y el L2 de A y B
([`docs/10-requisitos.md`](docs/10-requisitos.md) §13, 23 enunciados, 0 VIOLA). **A**: hasta clasificar el pedido
(`cascada.ps1 -Suelta`, `-Ingenieria` o la necesidad de un proyecto) la puerta niega Bash, PowerShell, Write y Edit en
toda sesión, sin mirar ninguna palabra, y cada pedido sin clasificar trae la línea que lo dice. **B**: una sesión de
ingeniería (la clase Ingeniería, o un proyecto de `ingenieria` o `documentos`) lee el **tronco** —el libro de bolsillo y
las fuentes de requisitos y del alcance, 141 315 caracteres— antes de cualquier acción; la suelta y `seguimiento`, no.
Probado: autotest de la puerta BIEN con los casos 24 y 25 y **7 mutantes vistos**; efecto real por el lanzador, como lo
corre la app; `cascada.ps1` y `cascada.sh` con las dos clases, código 0. **De paso**: los mutantes del autotest corrían
desde una carpeta temporal sin la raíz, y el de DA-070 «se veía» porque la puerta no veía ningún proyecto (medido);
ahora corren con la raíz. Diseño y la V requisito por requisito: [`docs/t19-arbol-de-conocimiento.md`](docs/t19-arbol-de-conocimiento.md)
§6. Falta: C (la rama), D (el lazo de uso), E (el procedimiento) y validar en sesiones reales de cada clase (P10).

**2026-10-19 (sesión `cfe21436`, cuenta nueva de Fran) — T19 EN DISEÑO: el árbol de conocimiento, medido y con
propuesta.** Medido ([`docs/t19-arbol-de-conocimiento.md`](docs/t19-arbol-de-conocimiento.md) §1, instrumento
[`medir-arbol.py`](medir-arbol.py)): el arranque pesa **93 273** por sesión y **L1-01 (≤ 90 000) FALLA**, sin medidor que
lo diga; el **libro de bolsillo no está en el arranque** (llega sólo al entrar a un proyecto, por la puerta); al entrar
pesa más el propio proyecto que el método (arquitectura-se 119 K, BLACK 90 K); 55 de las 193 viñetas del núcleo nacieron
en BLACK. **Fran dio vuelta el planteo** (§3): desempeño y riesgo antes que costo; nada se activa por una palabra, la
sesión interpreta el pedido; tronco = libro + fuentes de requisitos completas en toda sesión con ingeniería de sistemas
(en la duda también); la rama, lo del pedido en alto nivel; lo que sobra sale con su sí; un procedimiento mal planteado
se corrige y se avisa (§4). La v1 (bajar el arranque a ~77 K) quedó descartada; la **v2** (§5: clasificación
obligatoria por interpretación, tronco, rama por naturaleza y tema, lazo de uso, revisión del procedimiento) espera su
OK final. L1-01 y L1-07 pasan a TBR. Rojos del arranque arreglados de paso: el mail
de prueba del autotest declarado, la memoria espejada, la pasada de T18 (10 retiradas). Nuevo **DA-074** (la lista de lo
que exige la puerta, cortada en la salida de la cascada) y evidencia nueva de **DA-071** (el tramo 1-329 todavía no
entra en una lectura).

**2026-10-19 (sesión lateral `94d0be8b`) — EL LIBRO CONTRA SUS FUENTES: DA-013, 065, 066, 067 y 070 ARREGLADOS** (falta
validarlos con 3 sesiones auditadas). Las 70 reglas de `nucleo-ise.md` y `alcance-como-se-escribe.md` graduadas contra
el PDF: **7 cambiaban el sentido** y se corrigieron (los niveles L0-L6, la excepción de la solución con su quién, los
números del tope según quién manda, IRD/ICD, el lazo de los procesos, el orden del alcance, la necesidad «sin
justificación»). Tabla y medición: [`docs/da013-libro-contra-fuente.md`](docs/da013-libro-contra-fuente.md);
requisitos L0-10, L1-20..23 y sus L2 en [`docs/10-requisitos.md`](docs/10-requisitos.md) §12 (0 VIOLA). Piezas:
`verificar-libro.py` (citas del libro en un destilado, cláusulas de escape sin quién; autotest 10), la ficha nueva
`pilares/nasa-level1/` (Leisner, TESS, Psyche, JWST, UNOOSA: 17/17), `mapa-lecturas.py` (5 huérfanas encontradas y
enganchadas; autotest 7) y la puerta: `requisitos` por título en cualquier documento, `alcance` por misión,
restricciones y autoridad, cada proyecto tocado exigido, el documento de requisitos largo exigido entero en secciones
(autotest 148 ok). **Efecto real** de DA-067 y DA-070 en la sesión. Commits: perfil `27b8964`, `2c11663`; acá
`4659a58` y el del checkpoint. Nuevos: **DA-071** (este documento de requisitos crece sin techo), **DA-072** (disparo
por palabra del concepto de PDF), **DA-073** (ConOps, trade, riesgos, V&V y la revisión sin concepto). Lección 346
repetida: exige nivel regla.

**2026-10-19 (sesión `8cb387c7`) — DA-064 ARREGLADO: el libro llega al momento de escribir un alcance.** Concepto
`alcance` de la puerta (`faff47a`): al escribir una sección de necesidad, metas u objetivos —en cualquier proyecto,
materia incluida— exige la ficha `alcance-como-se-escribe.md`, el SEH §3.11-3.13 y la cátedra (m18, m20), 18 711
caracteres una vez por sesión. Dispara por el **rol** del texto (el título de la sección que el Write o el Edit trae,
o que encierra lo editado; en un PDP, §1-2), no por la palabra: la prosa que nombra «la necesidad» no dispara. Medido:
37 títulos del repo caen en la definición, 25 son PDP §1-2 y 7 de los otros 12 son alcances (L0-09, L1-19,
L2-PTA-20..23, L2-VER-04, L2-CAS-03/04 en [`docs/10-requisitos.md`](docs/10-requisitos.md) §11, 0 VIOLA). Probado:
autotest de la puerta caso 20 (6 sabotajes, 6 controles, 5 mutantes vistos) y
[`probar-da064.py`](probar-da064.py) sobre el informe real del TP, el PDP y los requisitos. Diseño y por qué la puerta
y no la fase, el núcleo o un verificador: [`docs/da064-concepto-alcance.md`](docs/da064-concepto-alcance.md). **Lección
293 subida a herramienta** (`b22560e`): `.claude/hooks/medir-reescritura.py` mide contra HEAD, después de cada comando
de consola, los bytes cambiados fuera del cambio (mojibake, '?', BOM); efecto real visto en la sesión. **Quedan en rojo
las lecciones 70 y 230** (sin-triage): no entraron por plan (5 h al 71 % al empezarlas, compartida con la sesión del TP);
su diseño candidato está en el HANDOFF.

**2026-10-17 (sesión `ecd2332b`) — T18 CONSTRUIDO: el método también retira.** Fila 5 de la lluvia; decisión de Fran
por encuesta: **sensor de uso + núcleo**, aviso en el cuadro, un freno nunca sale solo (lluvia §7). El sensor son los
**transcripts** (lo que le llegó a cada sesión: Read, Grep, Bash y el hook al paso; leer el núcleo no cuenta), sin hook
nuevo. Una viñeta con 20 sesiones auditadas sin uso sale del núcleo, de a 10 por pasada, y vuelve sola si se usa o si su
lección se repite; la fuente nunca se toca (L1-17/18, L2-RET-01..11, L2-NUC-01..03 en
[`docs/10-requisitos.md`](docs/10-requisitos.md) §10, 0 VIOLA). Piezas: `perfil-global/herramientas/retiro.py`, el
generador del núcleo que omite lo retirado, el medidor en la capa rápida de `chequeo-completo` y
[`probar-t18.py`](probar-t18.py) (25 casos sanos, **12 mutantes vistos en su caso**). **Medido construyendo:** la app de
escritorio **borra el transcript de cada sesión eliminada** (153 `desktop-released`), así que 18 de 36 sesiones
auditadas ya no lo tienen; T18 conserva lo leído en un registro de usos (L2-RET-11) y el defecto general quedó como
**DA-063**. **Efecto real:** 1 236 usos medidos en 130 transcripts; el medidor da «18 sesiones medibles de 36 informes,
ventana 20: no se retira nada» (falla cerrado, como se diseñó): **retira desde la sesión auditada número 20, a dos de
ésta**. El «95 vencidas» del spike contaba informes y no sesiones medibles: recurrencia de la lección 193, arreglada a
nivel herramienta (el medidor imprime los dos denominadores). De paso: **DA-060** arreglado (`install.ps1` corre el
medidor único de lecciones; caso 3c del saboteador), **DA-062** (el núcleo que sólo crecía) arreglado; DA-041 sigue
abierto (memoria, hooks y medidores todavía sólo suman). `chequeo-completo`: 30 saboteadores OK; el único rojo era la
memoria nueva sin espejar (arreglado). Diseño en [`docs/t18-el-metodo-retira.md`](docs/t18-el-metodo-retira.md).

**2026-10-16 (sesión `fc3d285a`) — T15 CONSTRUIDO: el aprendizaje se cierra.** Cuatro defectos, cuatro piezas
(L1-13..16 y 22 L2 en [`docs/10-requisitos.md`](docs/10-requisitos.md) §9, 0 VIOLA): **(1)** una lección `propia` o
`foldeada` guarda su **renglón** (el comienzo de su viñeta) y `sin-triage` mide que la viñeta siga ahí; 236 heredadas
ancladas por 4-gramas como `inferido`, 125 quedan como deuda con tope que sólo baja (DA-044); **(2)** `aprender.py
repite N` cuenta la recurrencia y le sube el nivel exigido **sola**; el medidor da ROJO hasta `subir` con el arreglo, y
`agregar` lista las parecidas por tf-idf (los 4-gramas daban 0 en los pares conocidos) (DA-042); **(3)** el guardia de
fan-out muestra el costo estimado en % de la ventana de 5 h y sigue preguntando (DA-050); **(4)** la caja negra vive en
`~/.claude/caja-negra/`, con copia del legado de %TEMP% sin cortar la sesión viva (77 migradas) (DA-047). **Efecto real:**
la recurrencia de la #351 en esta misma sesión (3 ediciones en paralelo negadas por concepto freno) quedó contada,
exigió `regla` y dio ROJO; se arregló a nivel **flujo** (`c23b545`: al declarar `metodo` la cascada imprime el concepto
freno, que era DA-058) y volvió a verde. Probado: autotest de `aprender.py` (21 casos),
[`probar-t15.py`](probar-t15.py) (5 piezas, 11 mutantes vistos en su caso), autotests de la puerta, el lanzador y la
auditoría, `probar-chequeo-lecciones.ps1` (14). Diseño en [`docs/t15-el-aprendizaje-se-cierra.md`](docs/t15-el-aprendizaje-se-cierra.md).

**2026-10-16 (sesión `f475a5d5`) — T17 CONSTRUIDO: los conectores bajo la puerta.** La puerta decide cada llamada a
un conector de claude.ai por lista blanca (`.claude/conectores.json`): leer pasa; compartir pasa sólo con el par
objeto-destinatario declarado en `.claude/estructura-drive.json` (hash del mail, rol); crear, copiar o mudar a la
carpeta pública o a una carpeta sin declarar niega; un conector o una herramienta nuevos entran frenados hasta
clasificarlos (N-10, L0-08, L1-12, L2-PTA-07..17, L2-VER-03 en [`docs/10-requisitos.md`](docs/10-requisitos.md) §8, 0
VIOLA). Probado: autotest caso 19 (4 mutantes vistos), [`probar-t17.py`](probar-t17.py), `--verificar` rojo antes del
matcher y verde después, y el **efecto real** en esta sesión (dos negadas y dos que pasaron en la caja negra, sin mails
en claro). `chequeo-completo` en verde (el rojo de la nube era lo sin pushear). DA-046 arreglado sin validar; nuevo
**DA-059**: la terminal del app corre comandos sin pasar por ninguna puerta. Diseño en
[`docs/t17-conectores-bajo-la-puerta.md`](docs/t17-conectores-bajo-la-puerta.md).

**2026-10-16 (sesión de T16) — T16 CONSTRUIDO: el estado se prueba.** Los requisitos tienen ahora resultado, y la
cascada lo muestra al entrar: por nivel, cuántos están **verificados** (por su propio método), **predichos** (una cuenta
del diseño para un ensayo, que no lo verifica) y **sin resultado**, cada FALLA y lo que cambió contra la matriz escrita
(L1-11, L2-MVR-01..10, L2-CAS-01/02 en [`docs/10-requisitos.md`](docs/10-requisitos.md) §7; 0 VIOLA sobre los 48
enunciados). La columna pasa/falla vive en una vista generada (`matriz-verificacion.md`), nunca a mano (T20). Primer
cliente, el telescopio: su prueba lee el diseño del modelo y el criterio de cada enunciado; **L1-13, L1-14 y L1-30
verificados, L1-21 y L1-02 predichos, 71 sin resultado** (lo que falta medir es de Fran o de la fase B). Probado:
autotest (14 casos), [`probar-t16.py`](probar-t16.py) (3 mutantes vistos), el sabotaje del telescopio (L1-13 59,5 →
29,4 N; L1-14 22,33° → 16,49°), falla cerrado ante un modelo o un enunciado cambiados, y el **efecto real** (la cascada
del telescopio imprime la V por nivel; una matriz envejecida a mano da CAMBIO y rojo en `--verificar`, y verde al
regenerarla). `chequeo-completo`: 27 saboteadores OK y un solo rojo, lo sin pushear. Diseño en
[`docs/t16-estado-verificable.md`](docs/t16-estado-verificable.md). Encontrado al diseñar: el rationale de L1-21 del
telescopio dice 24,6 cm y el modelo v10.5 da 26,5 (`probable`; el requisito se cumple igual).

**2026-10-16 (sesión `4aab65ae`) — T14b CONSTRUIDO: mencionar no es pedir.** Medido antes: de 10 excepciones a la
puerta desde el 2026-10-12 20:00, 8 eran un proyecto nombrado sin pedirlo, y cada una pintaba P2 y P5 de AMARILLO. Ahora
`.\cascada.ps1 <p> -Mencion "motivo"` lo registra: libera lo que cae fuera de todo proyecto, nunca la carpeta del
mencionado, y la auditoría lo informa sin color (L2-PTA-05, L2-PTA-06, L2-AUD-02 en
[`docs/10-requisitos.md`](docs/10-requisitos.md) §6, 0 VIOLA). Probado: autotest de la puerta (caso 18, 2 mutantes),
de la auditoría y [`probar-t14b.py`](probar-t14b.py) (2 mutantes); **efecto real** en esta sesión (la mención en el
estado de la puerta; un Write en `telescopio/` negado igual, `confirmado`); `chequeo-completo` con 24 saboteadores OK
y un solo rojo, lo sin pushear. Diseño y medición en [`docs/t14b-mencionar-no-es-pedir.md`](docs/t14b-mencionar-no-es-pedir.md).
Falta el efecto en una sesión real donde Fran nombre otro proyecto de pasada.

**2026-10-12 noche (sesión `1622e692`) — T19a CONSTRUIDO: los apuntes ya no se frenan por la fase NASA.** Fran partió
la meta (N-09): rigor completo para los proyectos grandes, el método actual alcanza para los de materia. T13 se exige
ahora sólo a la naturaleza `ingenieria` (`exige_requisitos()` en la puerta, su verificador y la auditoría; L1-04
acotado, L2-VER-01/AUD-01/PTA-01 sobre Proyecto_Con_Ciclo_NASA, 0 VIOLA extrayendo los enunciados). **Efecto real:**
expuestos 5 → 2 (black, minecraft-amigos); apunte-iise, software-de-vuelo y cohete-de-agua dejaron de estar frenados.
Probado: autotests de la puerta y de la auditoría con control y mutante T19a, `probar-t13.py` (4 mutantes, mudados a
la línea nueva), `chequeo-completo` con 24 saboteadores OK y un solo rojo legítimo (lo sin commitear). Diseño en
[`docs/t19a-materia-sin-freno-nasa.md`](docs/t19a-materia-sin-freno-nasa.md). Plan al cerrar: 5 h al 78 %, semanal al
72 % con 3 días por delante. **Y DA-054 arreglado** (`3714573`, falta validar): arquitectura-se tiene señal fuerte en
la puerta (`arquitectura-se`, «retomo el método», «arquitectura del método», «defectos de arquitectura»; «el método»
suelto no, porque frenaría un apunte); efecto medido: el retome con «puntero» ya no frena por software-de-vuelo;
saboteador [`probar-da054.py`](probar-da054.py). Las decisiones de Fran por encuesta (telescopio primero, mencionar
no es pedir) están en la lluvia §7.

**2026-10-12 (sesión `26479d81`) — T20 CONSTRUIDO.** Los L2-DIV-01..05 viven en su dueño
([`docs/10-requisitos.md`](docs/10-requisitos.md) §5; 0 VIOLA extrayendo los enunciados) y t20 §5 los refiere: cerró
el ROJO P7 de la sesión anterior. Se sacaron copias: la fase del ESTADO (la cascada ahora la lee del PDP por
`fase_activa.py`, caso nuevo en `probar-cascada.ps1` visto en rojo con la versión vieja), la nota de reemplazo en el
diagnóstico §3 y el contrato, que mandaba el orden al diagnóstico viejo. El medidor: `divergencias.py` +
`.claude/datos.json` (fase, orden y conteo de defectos de este proyecto), falla cerrado, en la capa rápida de
`chequeo-completo`; su saboteador `probar-divergencias.py` da 14 casos y 5 mutantes vistos. **Efecto real:** su primera
corrida encontró dos copias vigentes viejas acá («Siguiente: T2», «Lo que FALTA»), hoy fechadas como historia; y una
copia sembrada a propósito dio ROJO en el tablero con el dato, el dueño y la copia, y verde al sacarla.
`chequeo-completo`: todo verde salvo «listo para la nube» antes del push (verde después). **No se cerró ningún DA**
(DA-017/012/036): el medidor cubre los datos registrados de este proyecto, no la clase; lo que falta (los otros
proyectos, las rutas locales, el prefijo de `arquitectura.md`) en [`docs/t20-cero-divergencias.md`](docs/t20-cero-divergencias.md)
§3. Nuevo: **DA-055** (el chequeo GtWR, corrido como lo documenta el libro, da 186 VIOLA sobre este documento).

**2026-10-12 (sesión `814911bc`) — T14 CONSTRUIDO; T20 DISEÑADO.** La puerta infiere el proyecto sólo de lo que tipea
Fran: saca los bloques pegados, las notificaciones y los recordatorios antes de buscar señales (`e6d58bb`, L2-PTA-04);
`fase_activa.py <ruta>` es lectura pura. Probado: autotest con el caso 17 (controles, sabotajes y 2 mutantes en su
caso), [`probar-t14.py`](probar-t14.py) (3 mutantes), `chequeo-completo` con un solo rojo legítimo (lo sin commitear),
y el **efecto real** en esta sesión: una notificación que nombraba al telescopio no lo dejó inferido. DA-045
**arreglado** (falta validar). Detalle y lo que T14 no cubre (arquitectura-se sin señal fuerte en el catálogo) en
[`docs/t14-lo-que-pide-fran.md`](docs/t14-lo-que-pide-fran.md) §5. **T20, cero divergencias**, diseñado en
[`docs/t20-cero-divergencias.md`](docs/t20-cero-divergencias.md): dato vigente / medición fechada / cita de un ID, qué
se saca primero, el medidor con su saboteador y L2-DIV-01..05 (0 VIOLA del GtWR). Siguiente: construir T20.

**2026-10-12 (sesión de arquitectura `de44da9d`) — T13 CONSTRUIDO, 15 defectos nuevos, el orden de lo que sigue.**
El método tiene **requisitos propios** ([`docs/10-requisitos.md`](docs/10-requisitos.md) v0.1: N-01..N-05, L0, L1 y
los L2 de T13 y T14; 0 VIOLA del GtWR) y **T13 «la fase manda» está construido** (`70871b2`): la puerta exige el
documento de requisitos por la FASE A–D del PDP y niega al entrar salvo escribirlo y el registro; la auditoría da
ROJO en P7; la compuerta lista los productos; el verificador lista 5 expuestos (apunte-iise, black, cohete-de-agua,
minecraft-amigos, software-de-vuelo) y 8 fases sin tipo. Probado: autotests de las tres piezas, `probar-t13.py` (4
mutantes), `chequeo-completo` con 23 saboteadores OK; DA-027/028/029/033 **arreglados** (falta validarlos). La
búsqueda de defectos (8 lentes, 3 escépticos por candidato) registró **DA-039 a DA-053**
([`docs/hallazgos-2026-10-12.md`](docs/hallazgos-2026-10-12.md)); no se agotó (el límite cortó dos rondas). **El orden,
con las decisiones de Fran**, vive en [`docs/lluvia-de-ideas-2026-10-12.md`](docs/lluvia-de-ideas-2026-10-12.md) §6
(dueño; acá decía una versión vieja que divergía, medido el 2026-10-12 por T20). Costo de la sesión: dos ventanas de 5 h y del 34 % al 63 % del
semanal, casi todo en dos fan-outs (la lección quedó, con su viñeta primera en «ANTES DE ABRIR FAN-OUT»).

**2026-10-12 — insumo de validación: NASA por etiqueta (T13, va PRIMERO).** En la sesión 129 de BLACK, Fran vio que
el coop había pasado por las fases A, B y C sin requisitos, alcance ni plan de V&V, y pidió revisar la arquitectura
«para que NASA no dependa de leer un hook o de una palabra mágica». **Medido** (`medir-fases.py`, control positivo con
el telescopio): **6 de 22 proyectos en fases A–D sin requisitos** (incluido éste). Causa leída en la implementación:
la exigencia es opt-in (`"requisitos"` en el catálogo, 1 de 22), el aviso sale sólo con la palabra `diseno`, la
auditoría da P7 «NO APLICA» por exclusión y la compuerta de fase informa sin verificar. Diseño de la corrección
(M-01 a M-06) en [`docs/insumo-2026-10-12-nasa-por-etiqueta.md`](docs/insumo-2026-10-12-nasa-por-etiqueta.md); M-06
(«leer en frío, descubrir con spikes») y «NASA con ágil» en el libro de bolsillo ya quedaron. También nació la
necesidad transversal **`lluvia-de-ideas`** (disparada por cadencia medida, `lluvia-de-ideas.py`) y el **registro de
defectos de arquitectura** (`perfil-global/DEFECTOS-ARQUITECTURA.md`, 38, cierre exigente). **Siguiente: la sesión de
arquitectura creativa en ultracode** ([`RETOME.md`](RETOME.md)); T13 es su primera implementación, antes que T2.

**2026-10-09 — la puerta ya no frena BLACK por «punteros».** Las señales del
catálogo se partieron en **fuertes** (nombran el proyecto) y **débiles**
(vocabulario: `punteros`, `programación`). La débil frena sola —el caso 331, el
ejercicio de C sin nombrar la materia, sigue cubierto— y cede, con un aviso de
una línea, si el pedido nombra otro proyecto con una fuerte o la sesión ya está
en otro. Aprobado por Fran (regla 6). Autotest de la puerta en verde con el
caso 15 y dos mutantes vistos en rojo; diseño en
[`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md) §4.6.

**2026-10-06 — T7 bis: la nube, medida por proyecto.** `.claude/nube/estado-nube.py`
(arranque: repos subidos y memoria espejada; `--simular`: la puerta contra un
clon armado desde GitHub, para los 22 proyectos × las 8 necesidades). Nació con
cinco rojos, el peor la memoria de la PC fuera de todo repo (la nube no podía
entrar a ningún trabajo de materia). Espejo en `perfil-global/memoria`.
Detalle en `HANDOFF.md`.

**2026-10-02 — T7 CERRADA (paridad nube/local).** Medida en la nube real (las
cinco en verde) y, al traerla a la PC, el barrido de su último hallazgo destapó
la clase entera: en la nube la puerta salteaba **en silencio** las skills y todo
`perfil-global/` (vive al lado del árbol y `traer-perfil.sh` no copiaba las
skills). Ahora la puerta **niega** ante un exigido inexistente, encuentra
`perfil-global` en los dos lados y `traer-perfil.sh` instala y mide las skills;
cada arreglo visto en rojo con la versión vieja. De paso: `cascada.ps1` sin
`-Necesidad` reventaba, y `ninguna` decía «sin declarar» (los dos arreglados). El
retome ahora no recorta lo que exige la puerta y encarga medir **efectos**, no
comandos (lecciones 328-329). R4-R7 resueltos por flujo, reubicados en T5 o
declarados ([`docs/t7-paridad-nube.md`](docs/t7-paridad-nube.md) §4 quinquies,
«Cierre»). Lo que sigue abajo es cómo se llegó.

**2026-10-02 — T7 (paridad nube/local), R3 y punto 3 construidos.** En Windows
los hooks corren por Git Bash y `$CLAUDE_PROJECT_DIR` se expande (**confirmado**
en la sesión viva); `.claude/settings.json` va **trackeado** con esa variable y
llega a cualquier clon; en la nube calla lo que no tiene con qué correr y
`traer-perfil.sh` se corre solo. `nuevo-proyecto.ps1` registra el proyecto en el
catálogo de la puerta. **Y el punto 4:** `.claude/cascada.sh` declara donde no
hay PowerShell, la puerta corre **sin gate** (en la nube frena y deja declarar;
sin intérprete falla cerrado) y el autotest de `fase_activa` dejó de esperar una
fase escrita a mano y entró a `chequeo-completo` (que dio entero en verde). **Medido
en la nube real el mismo día: las cinco en verde, R2 cerrado** (el libro llega,
la puerta frena y `cascada.sh` la destraba, `fase_activa` habla;
[`docs/t7-paridad-nube.md`](docs/t7-paridad-nube.md) §4 quinquies).

**2026-10-02 — T12 CONSTRUIDA: el método pesa menos, medido**
([`docs/t12-simplificar.md`](docs/t12-simplificar.md); instrumento
[`medir-costo.py`](medir-costo.py), que lee el transcript o corre los hooks
instalados). Por sesión **131 889 → 77 685** caracteres (−41 %), por turno
**5 541 → 1 792** (−68 %), por entrada a un proyecto de método **137 884 →
50 000** (−64 %). Cinco podas, cada una con su saboteador después: el
catálogo de la puerta, el enrutador a vista corta (55 K → 12 K; la historia a
`MAPA.md` §7), el cuadro (uno solo, con la fase por su **nombre NASA** y su
criollo, a pedido de Fran), las reglas 10-12 sin historia y la fuente del
perfil renombrada (`CLAUDE-global.md`) para que no se cargue dos veces.
`chequeo-completo` entero en verde. **De T11b entró lo barato y con freno**:
`--nivel` de la regla 15 en `aprender.py` y el respaldo obligatorio por
necesidad en la puerta; y quedó **medido** que más de la mitad de las acciones
caen fuera de las carpetas de proyecto (casi todas, trabajo de método). Falta
**validar en 5 sesiones** (con T11): **hechas las 5 el 2026-10-02**, anotadas en `HANDOFF.md`: las entradas a
proyecto cumplieron 5 de 5 (base: 1 de 113) y ses.met se sostiene en ~78 K (antes 131 889). Fran tiene que apagar los
plugins de SEO y Adobe de su cuenta (~29 K por sesión).

**2026-10-02 — T11 CONSTRUIDA: la cascada dejó de ser un consejo.** Medido
antes: de 113 entradas sesión × proyecto desde el 1/9, **1** leyó ESTADO +
HANDOFF + PDP + contrato antes de su primera acción, y BLACK corrió su
apertura 7 de 28 veces. Ahora `.claude/hooks/cascada_puerta.py` **no deja
actuar** sobre un proyecto hasta que la sesión declara la necesidad
(`.\cascada.ps1 <p> -Necesidad …`) y **lee con Read** lo que el catálogo
`.claude/cascada.json` exige para esa necesidad y para el concepto que la
resuelve (typst, freno, pcsx2). Diseño, medición y validación en
[`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md).
Autotest **22/22** (con un mutante que ciega la función que decide); el
medidor del catálogo en la capa rápida dio rojo con la puerta sin registrar y
verde instalada. **Primera sesión real (ésta): la puerta frenó el primer Edit
sobre el proyecto; se declaró `metodo,diseno`, se leyeron los 16 rangos (~37 K
tokens) y el Edit pasó.** En el camino encontró dos defectos que el autotest
no podía ver (no cruzaba la frontera real): un `cascada.ps1` que sale con
código 1 no dispara el hook de *después* (la declaración se perdía) y el
parser de `-Necesidad` se cortaba ante una redirección. Arreglados, con caso.
Falta validar en **5** sesiones reales (`medir-cascada.py`; Fran pidió «más
de 3»); la primera es la que retoma BLACK. Después de la primera versión Fran
agregó: necesidades abiertas (clase `nueva` → requisitos), herramientas y
respaldo por clase, y la regla 15 (error evitable → causa raíz más arriba).

**T1 CERRADA el 2026-09-29: los seis pasos.** Construidos el 28/09 los pasos
1 (medidor), 2 (arranque partido), 3 (pilares en dos hooks), 4 (núcleo de
chequeo en cuatro) y 5 (hook al paso); **el 6 validó en 3 sesiones reales
limpias**, contadas desde los saboteadores del 28/09 21:42:33, como fijó la
corrección de las 23:35: `53e404af` (la que corrió los saboteadores),
`e5fa731f` (la del Escritorio) y `b3a19cc1` (ésta). `medir-inyeccion.py --solo
despues` sobre esa ventana: **3 sesiones, 0 cortados y 0 cancelados**;
`disparos.log` **sin una línea ERROR**; `al-paso` disparó en uso real en dos
de ellas (`rclone` 23:31; la del Escritorio, 00:12). Desde la instalación del
paso 5 (21:17) son **cuatro** arranques bajo la misma configuración de hooks,
los cuatro limpios.

**Cómo se contó, porque el medidor tal cual daba 2.** El «desde» se había
movido a **23:44:41**. Esa escritura de `~/.claude/settings.json` la hizo **la
app**, no una sesión: coincide al segundo con el primer mensaje de la sesión
del Escritorio, que todavía no había corrido ninguna herramienta; ningún
archivo de hooks cambió después de 21:43, y `verify-install` da el registro
igual al manifiesto (`probable`). Se midió la ventana desde 21:42 con una
copia de `settings.json` fechada a esa hora (`--settings`), sin tocar la real.
**Deuda del medidor, para P10:** anclar en el mtime confunde «archivo tocado»
con «configuración cambiada» — ya pasó con los saboteadores y ahora con la
app (lección 298, `fuera`; `perfil-global/PENDIENTES.md` §11).

**Siguiente, al 2026-09-29 (reemplazado: el orden vigente es la lluvia §6, y T2 es T20): T2, «un dueño por dato»** (camino crítico T1 → T2 → T3 → T4 →
T7 → T9, `docs/diagnostico-2026-09-28.md` §3). Alcance, con el insumo del
29/09 (`docs/insumo-2026-09-29-cambio-externo.md`):
- **entra**: las **rutas locales escritas a mano** (insumo 4) — un dato con N
  copias y ningún dueño, que es exactamente lo que T2 ataca: una fuente por
  dato, el resto puntero, y un medidor que la ejecute; y
  **`fuera-del-sistema.txt`** (insumo 3) como dato con dueño que tiene que
  poder encoger (aviso de entrada muerta, como ya hace
  `datos-permitidos.json`).
- **no entra, va a P10 como dato de validación**: el censo que sólo mira el
  Escritorio (insumo 1) y el contenedor declarado que oculta a sus hijos
  (insumo 2). Son alcance del verificador («un verificador sólo ve donde
  vive»), no dueño de un dato.

**De paso (29/09): `install.ps1` corrompía `settings.json`.** Lo leía con
`Get-Content` sin `-Encoding`; la app lo deja sin BOM, PS 5.1 lo tomaba como
cp1252 y el `Out-File` lo reescribía con una capa de mojibake: la raya de
`autoMode` tenía una desde la instalación de las 20:50 del 28/09 (medido en
los respaldos: limpia a las 19:59). Arreglados los seis lectores
(`install.ps1`, `verify-install.ps1`, `probar-guardia-fanout.ps1`,
`arreglar-permisos.ps1`), probado en réplica (viejo: 1 capa; nuevo: limpio) y
reparadas las 9 rayas con `autoMode` idéntico al respaldo limpio. Y
**PENDIENTES §10 cerrado**: las líneas de las lecciones 295 y 296 están en
`chequeo-de-trabajo.md` (el núcleo pasó a 201 reglas), `install.ps1` corrido y
`verify-install` en verde.

**Fase 6 CERRADA** el 2026-09-17. Cerró por lo que la cerraba (`PDP.md` §4):
**`chequeo-completo.ps1` en verde, todos los saboteadores corridos, y un
proyecto real migrado a la matriz.** Los tres, medidos:

```
Chequeo OK. Ningun rojo.      7 medidores + 10 saboteadores + 7 de limpieza
```

**Fue la primera fase que tocó archivos vivos**, con rigor **pleno**
(`docs/matriz-cumplimiento.md` §4, aspecto `c`): saboteador antes de dar por
puesta cada pieza, no después. **Abre la fase 7** (validar ≠ verificar).

## Lo que quedó instalado

| Pieza | Estado | Lo que la hace cobrable |
|---|---|---|
| **P2** matriz por proyecto | **cumple** | `medir-matriz.py` + `probar-medidor-matriz.ps1` (6 casos) |
| **P3** rigor por aspecto | **cumple** | `plantillas/PDP.md` §3, y la instancia en el PDP de este proyecto |
| **P4** molde de fase | **cumple** | `medir-fase.py` + `probar-medidor-fase.ps1` (6 casos) |
| **P5** heurísticas al paso | **recortado**, mitad puesta | `hooks/guardia-escapes.ps1` + `probar-guardia-escapes.ps1` (10 casos) |
| **P6** criterio de entrada | **cumple** | `aprender.py --opuesto` + 3 casos en `probar-chequeo-lecciones.ps1` |
| **P7** System 2 / System 3 | **cumple** | `perfil-global/README.md`, sin reescribir la cascada |
| **P1** catálogo derivado | **no aplica — todavía** | difiere, con la resta escrita |
| **P10** medidor de validación | **fase 7** | a propósito |

**Los tres defectos vivos, cerrados:** D12 (el conteo se **deriva**: el
`INDICE.md` pasó solo de 186 a 212), D14 (el chequeo de requisitos dejó de ser
de idioma inglés) y el medidor de desuso (C6 dejó de ser una intención).

**El proyecto migrado es este mismo:** su `PDP.md` lleva el rigor por aspecto
(§3 bis), la columna *Cómo se certifica* con la salida `cancelar` (§4) y la
matriz de cumplimiento (§8). **38 filas, 33 cumple, 2 no aplica, 3 recortado**,
todas las recortadas con su resta escrita.

## Lo que se encontró midiendo, y no estaba en el plan

- **El freno de D12 existía, y su saboteador daba verde sobre el defecto
  vivo.** El patrón de `install.ps1` estaba anclado a la **primera línea** y el
  saboteador rompía el archivo **ahí mismo**; el `186` real vivía en la línea
  19. **Un saboteador escrito por el autor del freno hereda su punto ciego.**
  Es el argumento más fuerte que tiene el proyecto para que **P8 siga declarada
  como hueco sin respuesta** en vez de darse por cubierta con los saboteadores.
- **Cinco archivos vivos tenían un carácter de control adentro**, invisible en
  cualquier editor: `chequeo-de-trabajo.md` (que **se inyecta en cada
  sesión**), `MAQUINA-NUEVA.md`, `verificar-requisito.py` —donde **apagaba en
  silencio una excepción de R16**— y **dos datos técnicos de BLACK medidos
  contra el ELF y contra la máquina**. Los cinco eran un escape de C en un
  string no-raw. Ahora lo mide la **regla 8** de `verificar-estructura.ps1`
  sobre los 288 archivos que el repo trackea.
- **La lección de ese error ya estaba escrita, con triage `propia`, e
  inyectada en `chequeo-de-trabajo.md` línea 553.** Estuvo en el contexto todo
  el tiempo y el error se cometió **cinco veces igual**. A 95 KB, 1347 líneas y
  154 viñetas, **la inyección dejó de ser entrega** — que es, palabra por
  palabra, lo que Rechtin p. 35 describe como hojear una ferretería. Es P5
  medido en carne propia, y es lo que decidió construir su guardia.
- **Dos saboteadores sanos reportados en rojo** por no cerrar con `exit 0`:
  heredaban el código del último comando nativo, que en un saboteador es por
  construcción uno que **tiene** que fallar.

## 2026-09-26 — D15 y P11: el ciclo de vida que la reforma no trajo

Medido en BLACK, no en este proyecto: la reforma tomó de NASA el tailoring, la
matriz y V&V, pero **no el ciclo de vida de arriba hacia abajo** (Pre-Fase A,
refinamiento sucesivo, programa/proyecto, madurez). BLACK hizo 61 entradas de
detalle y leyó último el arranque que construye sus 37 subsistemas. **P11**
quedó diseñada en `docs/arquitectura.md` §3, con piloto en BLACK y una sección
nueva en `plantillas/naturalezas/ingenieria.md`. El medidor genérico se
difiere hasta que un segundo proyecto la use. **No cambia el criterio de
salida de la fase 7** (P10): son la misma preocupación —construir la cosa
correcta— de los dos lados. P11 elige antes de construir; P10 mide después si
sirvió.

## 2026-09-28 — el diagnóstico medido del método entero

Pedido de Fran desde una sesión de BLACK (109): los problemas de arquitectura
de todo el sistema, medidos, para dedicarles sesiones de reforma.
**[`docs/diagnostico-2026-09-28.md`](docs/diagnostico-2026-09-28.md)**: A1–A11,
el N² de las interfaces (la columna *Sesión* —el único consumidor— tiene una
entrada verificada y cinco rotas) y el camino crítico T1 → T2 → T3 → T4 → T7 →
T9 (~9-16 sesiones, `hipótesis`). **A1 cambia la prioridad de P5:** la
inyección no es que pese mucho, es que **no llega** — el harness muestra 2 KB
de los 129 KB de `chequeo-de-trabajo.md` y de los 12,6 KB de `pilares.md`.
De paso: la cascada mide ahora si todo está **al día** por git
(`probar-cascada.ps1`), y la fila 6 del PDP quedó marcada CERRADA. Al cerrar,
A11 (sesiones paralelas) se vio en vivo: dos sesiones en el mismo árbol a la
vez, y el rojo de una era trabajo en curso de la otra.

## 2026-09-28 (noche) — T1 diseñada: el umbral medido y el arranque que se pierde

**[`docs/t1-presupuesto-inyeccion.md`](docs/t1-presupuesto-inyeccion.md)**, en
frío, sin tocar nada vivo. **El umbral es 10 000 caracteres por hook**
(`confirmado` por dos caminos: la constante en el binario de Claude Code
2.1.284 y un censo de 1 235 salidas de hooks sin una excepción); es por hook,
así que partir sirve. `chequeo-de-trabajo.md` llega cortado desde el **22/08**.
**Y el arranque del repo se pierde entero en 13 de las últimas 30 sesiones**:
tarda 58 s contra 60 de timeout (su comentario dice 7 s) y el texto fijo muere
con la medición. `verify-install` decía `[OK] emite 134667 chars`: medía el
efecto sin umbral. **Elegida la D**: núcleo generado de `chequeo` en dos hooks
(las 198 reglas de cabecera, 17,5 K), el detalle **al paso** sólo para los
momentos que discriminan (la sonda sobre 165 sesiones mostró que «creerle» y
«negativo» disparan en el 93–98 % y en la 4.ª llamada: van al núcleo),
`pilares` en dos hooks, el arranque partido con fecha límite interna, y el
medidor `medir-inyeccion.py` con su saboteador **primero**. Al arrancar: de
160 K emitidos y 16 K recibidos a ~45 K emitidos y recibidos. De paso, la línea
`Fase en curso` del PDP seguía en «6 — Migrar» (el hook la lee a ella, no a la
fila): corregida a 7, tipo D, **y medido el efecto** sobre lo que el hook
inyecta.

## 2026-09-28 (noche, 2.ª) — T1 pasos 1 y 2 construidos

- **El medidor** `perfil-global/herramientas/medir-inyeccion.py`, en los
  medidores de `chequeo-completo.ps1`: nació **en rojo sobre el estado de
  hoy**, como pedía el §7 — `pilares` 12 863 y `chequeo` 133 973 (antes) y
  los tres cortes/cancelaciones de las sesiones posteriores al último cambio
  de settings (después); **amarillo** en la apertura (9 592, margen 408). Su
  saboteador `perfil-global/probar-medir-inyeccion.ps1`, **10 de 10** (siete
  del §6 + 10 000 exactos, cortes anteriores al cambio y 5 000 limpio), y
  **saboteado él mismo**: sin umbral y sin leer `hook_cancelled`, da CIEGO.
  `verify-install` dejó de imprimir el número: mide que el hook anda; el
  tamaño tiene un solo medidor.
- **El arranque partido:** `arranque-proyecto.ps1` = sólo el texto (0,5 s,
  timeout 15); `arranque-medicion.ps1` = la capa rápida **en paralelo** con
  `-FechaLimite 40` (nuevo en `chequeo-completo.ps1`): entrega lo que terminó
  y nombra lo que no («SIN MEDIR»), matcher `startup|resume|clear` (no corre
  en compact). Medido: **41 s de pared** contra 56 s en serie. `probar-hooks`
  51 OK, con un caso nuevo (fecha límite 2 s → termina y nombra), roto a
  propósito sin fecha límite: da rojo.
- **Corrige a S3:** `publicar-apuntes -Verificar` es **bimodal corriendo
  solo** (10–11 s o 45–46 s, 5 corridas): la lentitud no era por correr junto
  al otro de Drive. En el arranque su modo lento sale «SIN MEDIR».

## 2026-09-28 (noche, 4.ª) — T1 paso 5: el hook al paso

- **Paso 0, validado:** la primera sesión con pilares y núcleo partidos dio
  `medir-inyeccion --solo despues` = **0 cortados y 0 cancelados** (1 sesión
  posterior al cambio de settings).
- **`perfil-global/hooks/al-paso.py`** (PreToolUse, registrado por
  `install.ps1` desde `Get-Guardias` con `Interprete`/`Decide`/`Timeout`
  nuevos; desinstalable sacando su entrada de `settings.json`): clasifica cada
  llamada por herramienta y entrada, e inyecta las viñetas **enteras** de la
  clave **una vez por sesión** (estado por `session_id` en
  `hooks/al-paso-estado/`, poda a 3 días). **Seis claves** que discriminan
  según S2: `freno`, `fanout`, `gui`, `rclone`, `typst`, `pcsx2`. Emite
  8 441 / 3 799 / 1 532 / 5 242 / 7 029 / 7 350 (tope 9 000 de **stdout**,
  con los escapes del JSON). Queda **fuera** ghidra y gh: la sonda no midió
  si discriminan.
- **`freno` no entra entero:** son 31 viñetas (~18 K) y salen 16; el pie del
  extracto dice cuántas faltan y dónde leerlas. Es el orden de la fuente, no
  un ranking; si pesa, el arreglo es entregar el resto en la segunda llamada de
  la clave (cambio de diseño: vuelve al doc).
- **Falla abierto a propósito** (no decide, inyecta): cualquier error termina en
  silencio y queda en `disparos.log`. Su primera versión falló abierto en las
  seis claves por un BOM (PowerShell 5.1 lo antepone al pipe) y **sólo el log
  lo delató**: por eso el saboteador exige el *texto* y no `exit 0`.
- **`probar-al-paso.ps1`, 20 de 20**, en `chequeo-completo`: efecto por clave,
  la viñeta entera llega, una vez por sesión (y sus dos controles), no dispara
  en Read / `ls` / `.md`, fuente ausente, stdin roto, **tres mutaciones del
  hook** (sin tope, sin marcar, todo es clave) que ponen en rojo su caso, y el
  medidor (control verde, clave > 10 000, fuente vacía).
- **`medir-inyeccion`** corre ahora una entrada sintética por clave (la declara
  el hook con `--muestras`) y da FAIL si una clave pasa 10 000 o no emite.
  `verify-install` comprueba registro y efecto (`additionalContext` ante un
  Write a `hooks/`, silencio ante Read).
- **Confirmado en sesión real** (no sólo en frío): el `settings.json` se
  recargó en caliente y el primer `rclone` de la sesión trajo las 7 viñetas
  como `PreToolUse:Bash hook additional context`; el segundo, nada.

## Lo que FALTABA al 2026-09-28, para la fase 7 (historia: lo que sigue hoy es la lluvia §6)

- **T1, validar (paso 6)** según `docs/t1-presupuesto-inyeccion.md` §7:
  **pasos 1 a 5 hechos** (pilares 7 940 + 4 791; núcleo 6 831 / 3 732 / 7 790
  / 7 764; hook al paso en 6 claves). Falta 0 cortados y 0 cancelados en 3–5
  sesiones reales, que la mitad «después» del medidor cuenta sola; como
  instalar el paso 5 movió `settings.json`, la cuenta arranca de nuevo en la
  próxima sesión. Riesgo nuevo: un momento de `chequeo-de-trabajo.md` que
  pase ~8 900 de cabeceras no entra en ningún hook (el corte es por momento);
  lo atrapa el medidor.
- Después, el resto del camino crítico del diagnóstico (T2 → T3 → T4 → T7 →
  T9).

- **P10, el medidor de validación** — *timely / affordable / predictable /
  comprehensive* (SEH p. 165-166), contra el costo por fase ya registrado acá
  abajo. Es lo que cierra la fase 7.
- **P1, el catálogo derivado**, diferido con su resta escrita en la matriz.
- **La mitad de P5 que falta:** partir `chequeo-de-trabajo.md` — la primera
  condición ya está (se inyecta el núcleo, 26 K en vez de 134 K, y llega
  entero); la segunda, **la lección del paso en curso adentro**, es el hook al
  paso (T1 paso 5).
- **`ingenieria-de-sistemas.md`** con las 4 correcciones de `arquitectura.md`
  §8, y la pregunta abierta: ¿sigue haciendo falta, o el catálogo P1 más las
  cuatro fichas ya lo reemplazan?
- **Migrar los otros 7 PDP.** `medir-fase.py` los cuenta: hoy **1 en verde, 7
  sin migrar**, y ese número tiene que bajar.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  **La matriz lo reclasificó de tailoring a error**, con la resta escrita.
- **Fases 1-5:** inline, entre 7 y 12 puntos del límite de 5 h cada una.
- **Fase 6:** inline, sin un solo subagente, **cero PDF extraídos**. Los tres
  defectos vivos, cinco piezas instaladas, **cinco saboteadores nuevos**, dos
  medidores nuevos, una regla de estructura nueva, un guardia nuevo y ocho
  lecciones, por **~31 puntos** del límite de 5 h (dos ventanas: 39→55 % y
  9→17 %+) y **4** del semanal (82 % → 86 %), medidos al cerrar.
  **Sexta fase seguida sin fan-out.**
