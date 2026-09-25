# Estado actual — Apunte de Física Espacial

## Fase 10: la voz, en su tercera vuelta, y menos cajas en todo el apunte — 2026-09-25 (segunda parte)

Fran leyó el piloto y lo corrigió dos veces el mismo día:

1. **Más sarcasmo y más crudo**: Aníbal puede ser «el hinchapelotas de la
   cátedra», y cuando acierta se le reconoce con el mismo sarcasmo; Fran
   también es blanco, sin pudor, como coautor. Y el humor **integrado** en
   la prosa y en la explicación formal, «como lo haría un buen y completo
   profesor», no en una caja por cada pedido.
2. **El chiste no se anuncia**: «pierde la gracia si te anunciás». Y quizás
   hay demasiados tipos de caja: considerar pasar cosas al texto, con color.

**Lo que se hizo:**

- **`m17-rotacion.typ` reescrito entero** con esa voz: de diez `#aparte` a
  ninguno; el tono vive en la prosa y adentro de las deducciones y los
  avisos. Los chistes sobre Fran salen de cosas que Fran dijo o escribió de
  verdad (el giróscopo que «está levitando», la $tau$ que parece un seis en
  sus apuntes de clase). Marca `// voz: 2026-09-25` en la línea 2.
- **`#aparte` borrado** de la plantilla y de la leyenda: una caja de humor
  es un chiste anunciado.
- **Trade-off de cajas, aplicado a los 21 módulos de una vez** desde
  `plantilla.typ`: había ~407 cajas en 187 páginas. Quedan en cuadro las
  que se buscan o se saltean (ejemplo 46, deducción 61, definición 22, guía
  18, lectura 21, posta 20). **Pasaron al texto** —entrada en el color de su
  caja, sin recuadro, vía `#marca`— idea clave (109, «La idea:»), cuidado
  (53, «Ojo:»), geometría (33) y notación (23): 218 cajas. El apunte bajó de
  **187 a 180 páginas**. Tres referencias en prosa a «el cuadro rojo» (m09,
  m13, m15) corregidas; leyenda de la carátula reescrita.
- **Regla propia 8 reescrita** con las tres correcciones; `medir-estilo.py`
  mide ahora la marca `// voz:` en vez de contar `#aparte` (sigue
  PENDIENTE: 58).

**Verificado:** compila sin errores (180 páginas); miradas la carátula, las
págs. 141–150 del módulo 17 y una página con marcas del módulo 8;
`verificar-apunte.py`, `indice-temas.py` y el saboteador en verde.

**Publicado al Drive por decisión de Fran**, que calibró el tono al decidir:
Aníbal lo trata de «falluto y tramposo» y Fran a él también, así que la
cargada es mutua; «hinchapelotas» sí, pero sin que suene a ataque. Las dos
apariciones se suavizaron antes de subir (la de la `#lectura` ahora trae su
contrapartida: «él diría que nosotros somos unos fallutos»), y la regla 8
quedó con esa calibración.

## Fase 9 cerrada: el módulo `rotacion` (Sears caps. 9–10), y el tono nuevo en piloto — 2026-09-25

Fran trajo la *Lista de temas Impulso angular (1)* y pidió tres cosas: que
todo esté explicado y diga de dónde sale («esto es del Sears que tanto le
gusta a Aníbal»), un tono humorístico casual en todo el apunte, y resolver el
ejercicio del giróscopo apoyado en un poste.

**Lo que midió el cruce:** el apunte no tenía el escalón del Sears. Iba del
momento angular de partícula (módulo 8, Beer) al cuerpo rígido en 3D (Beer
cap. 18) sin $K = \frac12 I\omega^2$, $\tau = I\alpha$, $L = I\omega$ ni la
precesión elemental — `grep` de cada una contra los 20 módulos: cero.

**Lo que se hizo:**

- **Módulo nuevo `m17-rotacion.typ`** (clave `rotacion`), primero de la parte
  de cuerpo rígido; los cuatro de CR pasaron a ser 18–21 (`git mv`, y el
  sabotaje 1 de `probar-verificar-apunte.py` actualizado a los nombres
  nuevos). Nueve secciones, una por fila de la lista, con la sección y la
  página impresa del Sears en cada una (offset medido: pág. impresa = pág.
  del PDF − 27). Abre por el **experimento** —la rueda que no cae— y no por
  la teoría, que es como pide la cátedra.
- **El ejercicio del giróscopo es el Problema S&Z 10.51 de la guía** (rotor
  0,140 kg, marco 0,0250 kg, 4,00 cm, una vuelta cada 2,20 s): resuelto a
  fondo, $n = 1{,}62$ N y $\omega = 189$ rad/s $= 1{,}80\times10^3$ rpm.
  Además el Ejemplo 10.13 del libro ($\omega = 277$ rad/s, horaria) y el
  10.10 (el profesor con mancuernas, $2{,}5$ vueltas/s). Los tres,
  recalculados a mano y coincidentes con el libro y con el Anexo A.
- **Figura nueva `fig-giroscopo-pivote`** (de costado y desde arriba),
  redibujada de S&Z Figs. 10.34–10.35 y mirada en la galería y en el PDF.
- **`#aparte[...]`**, función nueva en `plantilla.typ` y en la leyenda de la
  carátula: el humor va ahí, nunca suelto ni adentro de una caja. Regla
  propia 8 en `CLAUDE.md`. El módulo 17 lleva 10, y es **el piloto**: el
  resto del apunte no se toca hasta que Fran apruebe el tono (fase 10).
- **Anexo A:** las fichas de S&Z 10.1, 10.51 y 10.53 apuntan ahora al módulo
  `rotacion`, y dejaron de ser «cuenta propia» (quedan 13).
- **`medir-estilo.py`**, el tablero de la fase 11: secciones sin libro,
  módulos sin `#posta` y sin `#aparte`. Hoy da **PENDIENTE: 58**.
- **PDP §4:** fases 9 (cerrada), 10, 11 y 12 escritas con su criterio de
  salida.

**Verificado:** `typst compile` sin errores (**187 páginas**, antes 176); las
diez páginas del módulo (141–150 impresas) miradas en el render —se
encontraron y arreglaron tres defectos: un `;` que Typst se comía después de
una nota al pie, la tabla de analogías partida entre dos páginas y un título
de caja con «TAU = I ALPHA»—; `verificar-apunte.py` en verde con el módulo
nuevo usando sólo los módulos 1, 4 y 8; `indice-temas.py` regenerado;
`probar-verificar-apunte.py` con los cuatro sabotajes en rojo.

**Sí se publicó al Drive, y no era la intención.** La sesión había decidido
retenerlo hasta que Fran aprobara el tono —la carpeta es pública por link y
los apartes hablan del profesor—, no corrió el publicador, y el commit
`1ca33a4` lo subió igual: el hook `post-commit` publica cualquier commit que
incluya `apunte/apunte.pdf`, y la sesión no lo había mirado. La versión
pública del 2026-09-25 **es el piloto**. Lección registrada (grupo proceso) y
línea nueva en `chequeo-de-trabajo.md`. Para retener versiones de acá en
adelante: se commitean los `.typ` y el PDF queda fuera del commit.

## Pasos intermedios en la ecuación de la órbita (módulo 10) — 2026-09-21

Fran pidió desarrollar con más pasos intermedios las ecuaciones de §10.3 "La
ecuación de la órbita", y dejó el criterio para lo que sigue: donde aparezca
otro cambio de variable o una derivada aplicada más de una vez, mostrar los
pasos *importantes* del camino matemático — no todos.

**Qué se agregó, en `m10-orbita-conicas.typ`:**

- **La caja "por qué se cambia t por theta, y r por 1/r".** Antes citaba el
  resultado de Beer (ecs. 12.35 y 12.36) sin mostrar cómo se llega. Ahora
  desarrolla el operador $d\/d t = dot(theta) thin d\/d theta = h thin u^2
  thin d\/d theta$, lo aplica una vez para $dot(r) = -h thin d u\/d theta$ y
  una segunda vez para $dot.double(r) = -h^2 u^2 thin d^2u\/d theta^2$, arma
  el término que faltaba ($r dot(theta)^2 = h^2 u^3$) y factoriza hasta la
  ecuación de Binet. Verificado a mano contra Beer: los tres resultados
  intermedios coinciden con los que el apunte ya citaba.
- **El paso $p arrow.r a$ de la ecuación vis-viva.** Estaba como "la ec.
  (e2E) se despeja en..." sin mostrar la sustitución; ahora muestra
  $e^2-1=-p\/a$ y la cancelación del $p$. La otra mitad de esa misma
  ecuación (de $E=-mu m\/(2a)$ a $v^2$) se dejó como estaba, marcada "sin
  ningún paso intermedio" — es una cuenta de un renglón, no un cambio de
  variable, y ya lo decía el propio apunte.

**Se agregó una regla propia (2 bis) en `CLAUDE.md`** para que este criterio
no dependa de que alguien se acuerde: un cambio de variable independiente o
una derivada repetida no es "sólo álgebra" a los efectos de la regla 2,
aunque cada paso individual sí lo sea. **No se retrofitteó** a otras
secciones del apunte con el mismo patrón —geometría de la elipse, suma de
inversos de los ábsides— que se revisaron y se dejaron así a propósito:
son sustituciones de un renglón, no una cadena de cambios de variable.

**Verificado:** `typst compile` sin errores (176 páginas, sin cambio),
páginas 75, 76 y 78 miradas renderizadas a 150 dpi — las ecuaciones nuevas
entran sin cortarse ni desbordar la caja. `verificar-apunte.py` y `python
indice-temas.py` en verde, sin diferencia en `docs/INDICE-TEMAS.md` (no se
tocó ninguna etiqueta).

## `#repaso()` en los módulos 8 y 17 — corrección de un dato propio — 2026-09-20 (segunda parte)

Fran pidió aplicar `#repaso()` también en los módulos 8, 12 y 17, siguiendo
la lista que esta misma sesión había escrito más abajo ("se vuelve a usar en
los módulos 8, 12 y 17, según el grafo de `verificar-apunte.py`"). Antes de
tocar código se verificó esa lista contra el texto real, porque el grafo del
verificador no dice lo que esa nota afirmaba:

- **Módulo 8, confirmado.** Línea "Descomponiendo $v$ en polares —como en el
  módulo 1—", sección 8.3. No es la aceleración: es la *velocidad* en
  polares ($v_theta = r dot(theta)$), pero es el mismo patrón (resultado del
  módulo #M("vectores") citado sin rederivar). `#repaso()` puesto ahí,
  destino `<vec-polares>`, texto sobre la velocidad. Página 55.
- **Módulo 17, confirmado.** Línea "La aceleración en polares del módulo 1
  es la ec. (19)", sección 17.6 — el caso más directo de los tres: re-deriva
  la aceleración por otro camino (marco rotante) y la compara término a
  término con la del módulo 1. `#repaso()` puesto con el mismo texto que en
  el módulo 10. Página 147.
- **Módulo 12: NO tiene ningún uso de la aceleración (ni de la velocidad) en
  polares.** `grep` de "polares", "vectores" y de los términos
  $dot.double(r)$, $dot(theta)$ contra `m12-maniobras.typ` no da una sola
  coincidencia. **La lista de la sesión anterior estaba mal**: leyó la
  columna "anticipa (adelante)" de la fila 1 del grafo de
  `verificar-apunte.py` (`[8, 10, 12, 17, 18]`) como "estos módulos reusan
  el resultado", y esa columna dice otra cosa — son los `#M(...)` que el
  PROPIO módulo 1 escribe mirando hacia adelante en su cierre ("de acá salen
  las fórmulas de los módulos 8 al 12", "reaparece en el módulo 17"), no una
  medición de qué módulo cita a cuál. Quedó como hipótesis sin marcar y no
  se verificó contra el archivo antes de escribirla — no se retrofittea:
  no hay ecuación ahí para colgarle un repaso.

**Verificado:** `typst compile` sin errores (176 páginas, sin cambio),
páginas 55 y 147 miradas renderizadas a 150 dpi, `verificar-apunte.py` y
`indice-temas.py --check` en verde — y el filtro de `destino:` agregado en
la sesión anterior sigue funcionando: ninguna de las dos etiquetas cruzadas
nuevas ensucia `docs/INDICE-TEMAS.md`.

## `#repaso()` — repaso clicable junto a una ecuación reutilizada — 2026-09-20

**Cerrado, con un caso de uso.** Fran leyó el módulo 10 (pág. 75/176, la
caja "De dónde sale — por qué se cambia t por theta, y r por 1/r") y no
reconoció de dónde salían las dos ecuaciones de movimiento en polares: son
la aceleración en polares del módulo #M("vectores") (sección 1.6),
reutilizada sin repuntero seis módulos después. Pidió que el apunte tenga
"la posibilidad de clickar en las ecuaciones" para un repaso breve, siempre
que aparezcan ecuaciones así.

**Qué se agregó:** `#repaso(cuerpo, destino: none)` en `plantilla.typ` — una
nota al pie de Typst (`footnote`), pegada a la palabra que dispara la duda.
El repaso breve aparece al pie de la MISMA página (no hace falta saltar a
ningún lado), en azul, y si `destino` apunta a una etiqueta de otro módulo,
suma un link clicable a la deducción completa. Aplicado como caso de
referencia en
[`m10-orbita-conicas.typ`](apunte/modulos/m10-orbita-conicas.typ), con
`destino: <vec-polares>`. Detalle y motivo completos: regla propia 7 de
`CLAUDE.md`.

**No se retrofitteó a los demás módulos** —mismo criterio que `#posta`
(regla propia 3)—: se usa de acá en adelante, en todo módulo nuevo o que se
retoque por otro motivo. Retrofittear los veinte de una sola vez no lo pidió
Fran y no es necesario para que la próxima confusión de este tipo ya tenga
la herramienta lista.

**Verificado:** `typst compile` sin errores (176 páginas, igual que antes —
la etiqueta cruzada no rompió la compilación), página 75 mirada renderizada
a 150 dpi (regla propia 1: el número "1" de nota al pie aparece pegado a
"polares", y el pie de página trae el repaso y el link en azul, legibles).
`verificar-apunte.py` y `python indice-temas.py --check` en verde.

**Se encontró y arregló un bug real en `indice-temas.py` al agregar el
primer caso de uso** (no antes, porque nunca había un `link()` cruzando de
un módulo a otro): `ecuaciones()` leía cualquier `<etiqueta>` del archivo
fuente sin distinguir definición de referencia, así que `destino:
<vec-polares>` en el módulo 10 hacía aparecer esa etiqueta como si el módulo
10 la hubiera definido. Se filtra ahora el patrón `destino: <etiqueta>`
antes de buscar. Probado viendo el diff de `docs/INDICE-TEMAS.md`: con el
bug, `<vec-polares>` aparecía en la lista de "usa después" del módulo 10;
arreglado, desaparece de ahí y sigue apareciendo, correcto, en la del
módulo 1.

## Caja `#lectura` puesta en los 14 módulos que faltaban — 2026-09-17 (tercera parte)

**Cerrado.** `grep -L "#lectura" apunte/modulos/*.typ` no da salida: los veinte
módulos tienen la caja. Faltaban m01-08, m14, m16-20 (m09-13 y m15 ya la
tenían de sesiones anteriores).

**El mapeo de fuente por módulo se verificó contra el TOC real de cada libro**
(Roederer, Young & Freedman Vol. 1, Beer Dinámica, Curtis), no de memoria:

- m01-08 (vectores hasta momento angular): Roederer cap. 3-4, S&Z Vol. 1
  caps. 1, 6-8 y 13, y Beer cap. 11-12 y 14 (coordenadas polares y sistemas
  variables de partículas). Varios módulos ya citaban esas fuentes inline
  (m04, m06, m07, m08) y eso confirmó el mapeo antes de escribir la caja.
- **m14 y m16 NO son Roederer/S&Z/Beer, aunque el mensaje de retome de esta
  sesión decía que sí.** La esfera de influencia y las cónicas parcheadas
  (m14) y el problema restringido de tres cuerpos (m16) son astrodinámica,
  y sólo Curtis los cubre (cap. 8 y cap. 2 respectivamente) — confirmado
  contra el TOC real de Curtis, que trae «Circular restricted three-body
  problem» como sección final del capítulo 2. El retome quedó desactualizado
  en ese punto y la caja se escribió contra lo que el libro realmente tiene,
  no contra el mensaje.
- m17-20 (cuerpo rígido): Roederer cap. 5 (que tiene una sección llamada
  literalmente «Giróscopo y trompo») y Beer cap. 15 y 18, más el Apéndice B
  para momentos de inercia (m18).

**Verificado:** `typst compile` sin errores (175 páginas, antes 173),
`indice-temas.py` y `verificar-apunte.py` en verde, y
`probar-verificar-apunte.py` confirma que los cuatro chequeos se ponen en
rojo cuando corresponde. **No se hizo el chequeo visual página por página**
(regla propia 1) por decisión explícita de Fran al cierre de la sesión —
dado que los verificadores automáticos y el saboteador ya daban verde y el
tiempo apremiaba. Queda como probable, no confirmado, hasta que alguien mire
las páginas nuevas.

## La lista de temas de Gravitación `(3)` cruzada entera, y el hueco que salió — 2026-09-17

Fran trajo la versión `(3)` de *Lista de temas Gravitación* y pidió lo único
que una lista de temas sirve para pedir: **que esté todo**. Se cruzaron las
**23 filas** contra los veinte módulos, usando `docs/INDICE-TEMAS.md` —que
existe justo para eso— y verificando contra los libros las filas que daban
dudas.

**La `(3)` es superconjunto de la `(2)` por dos filas**, y las dos ya estaban
en el apunte: «Esfera de influencia — Curtis 8.4» y «Patched orbits —
Curtis 8.5», que hasta ahora eran un pedido del destinatario y no de la
cátedra. Las cubre el módulo 14 entero. O sea que lo que la lista nueva
*agrega* no costó nada.

**Salió un solo hueco, y no era de la parte nueva: era de la `(2)`.** La fila
«Parámetros orbitales — Bate pág. 19 a 40 y pág. 53 a 74» pide, en su segundo
tramo, el §2.2 del Bate: **los sistemas de coordenadas**. El apunte tenía
*uno* de los cuatro —el perifocal, §2.2.4— y le faltaban los otros tres. Y no
era un descuido silencioso: el propio `TEMARIO.md` lo tenía anotado como
«pendiente» desde el 2026-09-07, con un número de módulo que además ya había
quedado viejo.

Lo que se midió antes de escribir, contra el PDF del Bate y no de memoria:
las págs. 53 a 73 son §2.2 (sistemas de coordenadas), §2.3 (elementos
orbitales), §2.4 (estado → elementos) y §2.5 (elementos → estado en
perifocal). Los tres últimos ya estaban en el módulo 15. El §2.6 —las
matrices de rotación perifocal → IJK— **empieza en la pág. 74, que la lista
excluye**, así que la deuda que el módulo 15 ya declaraba en «Lo que se usa
después» sigue siendo legítima y no hay que saldarla.

**Lo que entró:** la §15.3 nueva del módulo 15, *Los sistemas de referencia:
respecto de qué se dan los seis números*, puesta **antes** de «Los seis
números de una órbita» y no después, porque es la regla 4 del contrato: la
inclinación es «el ángulo respecto de $hat(k)$» y el nodo se mide «desde
$hat(i)$», y hasta acá el módulo usaba esos dos versores sin haberlos
definido nunca. Lleva:

- las cuatro decisiones que definen cualquier sistema (origen, plano
  fundamental, dirección principal, sentido del $Z$), del Bate §2.2;
- las tres definiciones que faltaban: **heliocéntrico-eclíptico**,
  **geocéntrico-ecuatorial (IJK)** y **ascensión recta–declinación**, con qué
  instrumento entrega cada una;
- el `#cuidado` que es la razón de ser de la sección: **el IJK está centrado
  en la Tierra pero no pegado a la Tierra** — si girara no sería inercial y
  la @dosc-relativa no valdría en él. Es un error que no deja rastro
  algebraico;
- la **precesión de los equinoccios** y por qué existe la época J2000;
- el topocéntrico-horizonte nombrado y explícitamente fuera de lo pedido.

Y de paso, porque el módulo se tocaba, la caja **`#lectura` del módulo 15**
(regla 4 bis): quedan catorce módulos sin ella, no quince.

El apunte pasó de **170 a 173 páginas**. `verificar-apunte.py` en verde,
`indice-temas.py` regenerado, y `probar-verificar-apunte.py` corrido para que
ese verde valga algo.


## El material de la clase del 11/11 (Bate cap. 1) incorporado, y el índice de temas — 2026-09-17

Fran trajo cuatro PDFs de la cátedra: la Fig. 2.12 de Curtis suelta («Ángulo
de vuelo»), el manuscrito de la clase sobre el capítulo 1 de Bate (parámetros
orbitales, geometría de las cónicas, Hohmann, hipérbola), un «camino EO» que
es el flujo para resolver un problema de órbitas, y un escaneo con los
adicionales 1 a 3 y el Ej. 4 resueltos a mano.

**Lo primero que se midió fue cuánto de eso faltaba, y faltaba poco:** los
cuatro adicionales ya estaban en el Anexo A, y $epsilon$ en función de $h$ y
$e$, el ángulo de giro $delta$, $v_oo$, $C_3$ y $tan gamma = v_r\/v_perp$ ya
estaban deducidos. Lo que **no** estaba, y entró:

1. **La forma cerrada del ángulo de vuelo**, $tan gamma = e sin nu \/ (1 + e
   cos nu)$ (Curtis ec. 2.52, §2.4), en el módulo 13 con su deducción: el
   factor $mu\/h$ se cancela, y eso dice que $gamma$ no depende del tamaño de
   la órbita ni del cuerpo central, sólo de la forma y de dónde se está.
2. **La figura del horizonte local** (`fig-angulo-vuelo`), redibujada de
   Curtis Fig. 2.12, pág. 73. Es la que faltaba para que «perpendicular al
   radio, no tangente a la órbita» se vea en vez de leerse.
3. **El radio promedio**, que estaba calculado y sin nombre. El ejemplo del
   módulo 10 ya sacaba $8387$ km y $102,1°$ de la figura de la guía; ahora
   dice que $8387$ es $overline(r) = sqrt(r_p r_a) = b$ —la distancia media al
   foco **no** es $a$— y que $102,1°$ es donde $cos nu = -e$.
4. **Y el cierre que eso permitió, que es el que más vale:** el módulo 8 había
   leído $gamma = 12,05°$ **de la figura de la guía, con una regla**, para
   poder proyectar $h = r v cos gamma$. El ejemplo nuevo del módulo 13 lo
   *deduce* de dos alturas. Un dato medido del dibujo pasó a ser una
   consecuencia.
5. **El camino del parcial** (módulo 10, caja rosa): la cadena
   $e arrow.r h arrow.r v_p,v_a arrow.r a arrow.r T arrow.r epsilon$, que es
   el «camino EO» de Fran, con la aclaración de que sólo los dos primeros
   escalones importan y de que la cadena se puede entrar por el medio.
6. **La notación de Bate**: $p$ como *semilatus rectum* y la constante
   vectorial $bold(B)$ con $e = B\/mu$, que aparece en §1.5 y no vuelve a
   aparecer nunca — saberlo antes de abrir el libro ahorra una lectura.

**Lo segundo que pidió Fran, y es una regla nueva del proyecto (4 bis):
nombrar al autor y el capítulo, no sólo la página.** Entró la caja `#lectura`
—«Dónde leerlo»— con autor, capítulo, sección y una línea de *para qué sirve
cada uno de los dos libros*, y está puesta en los módulos 9 a 13. Faltan los
otros quince, y se ven con `grep -L "#lectura" apunte/modulos/*.typ`. Las
figuras recicladas de un libro dicen su fuente en el epígrafe.

**Lo tercero: `docs/INDICE-TEMAS.md`, generado por `indice-temas.py`.** Es el
mapa de los veinte módulos por título, subtítulo, ejemplo, deducción y
etiqueta de ecuación, y existe para que la pregunta «¿esto ya está?» cueste
una lectura barata en vez de 163 páginas o veinte greps a ciegas — que fue
exactamente lo que costó el arranque de esta sesión. **No se edita a mano** y
tiene su propia alarma: `indice-temas.py --check` se pone en rojo si alguien
tocó un módulo y no regeneró. La alarma se probó rompiéndola, y está adentro
de `probar-verificar-apunte.py` como cuarto sabotaje (los ocho controles en
verde).

El apunte pasó de **163 a 170 páginas**.

## La glosa de variables, extendida al resto del apunte — 2026-09-14, sin abrir fase nueva

Fran pidió extender a los otros 17 módulos + Anexo A el estándar de la
entrada anterior (nombrar siempre qué es cada variable de cada ecuación en
un ejercicio resuelto). **Primer intento: fan-out con 3 subagentes en
paralelo, uno por grupo de módulos — Fran rechazó los 3 y contestó "andá
sin agentes".** El resto se hizo inline, módulo por módulo, secuencial.
Quedó una memoria de sesión sobre esto (`feedback_sin-agentes-para-contenido`,
en la auto-memoria, no acá).

**Resultado, y es la parte que vale la pena recordar:** de 17 módulos
revisados (m01, m03, m06 a m20; m02 no tiene ejercicios), **la mayoría ya
cumplía el estándar sin tocar nada** — desde el segundo ejemplo de
`dos-cuerpos` en adelante (m09 en adelante: m10, m12, m13, m14, m15, m16,
m17, m18, m19, m20), cero ediciones. Sólo hicieron falta cambios en:

- **m01** (vectores): 1 — nombrar $r$ (distancia radar-cohete) e $y$
  (altura) en el ejemplo del radar.
- **m03** (cantidad de movimiento): 3 — $v_h$ en el ejemplo de la
  astronauta (el mismo que en m04 ya se había arreglado, acá en su versión
  original); $K_1$/$K_2$ como energía antes/después en los asteroides;
  $v_0$ en la separación de etapas.
- **m08** (momento angular): 1 — aclarar que las cuatro rapideces del
  ejemplo del satélite se leen de la figura, no de ningún cálculo previo.
- **m11** (Kepler): 1 — $R_T$ explícito en vez de un `6378` suelto.

**Anexo A (49 fichas) — 7 arreglos, elegidos por valor, no exhaustivos.**
El formato de ficha es deliberadamente corto (enunciado + "resuelve:" +
respuesta, nunca el desarrollo) y la mayoría ya estaba bien; se tocaron
sólo las que tenían una ambigüedad real, no una completitud cosmética:

- Ej. 9 (vectores): `R` en el enunciado vs. `r` en la resolución — mismo
  símbolo, unificado a `r` (la convención del resto del apunte).
- Ej. 1 y Adicional 3 de cantidad de movimiento: mismas dos glosas que en
  los módulos ($v_h$; $g$ vs. $g_0$).
- El giroscopio de juguete (A.3): $M_"total"$ no decía que era
  rotor+marco sumados.
- **Los dos casos de más peso: Problema 2 y Ejercicio adicional 2 de
  A.4, donde la ficha usaba $r_p$/$r_A$/$r_B$ sin decir que el dato del
  enunciado era *altura*, no radio** — exactamente la trampa que el
  `#cuidado` del módulo `gravitacion` marca como el error que más cambia
  un resultado, y acá estaba sin red en una ficha pensada para alguien
  que no leyó ese módulo. Corregido mostrando `r = R_T + altura`
  explícito en las dos.
- Problema 10 de A.4: "un cuarto de vuelta adelantado" nunca se traducía
  a $Delta phi = 90°$ antes de usarse en la fórmula.

**Verificado:** `python verificar-apunte.py` en verde. Recompilado
completo — **168 páginas, sin cambio** (a diferencia de la tanda anterior,
esta ronda no empujó paginación). Diez páginas de muestra, cubriendo las
cinco archivos tocados (m01, m03 ×2, m08, m11, y cinco fichas de Anexo A),
miradas en render a 150 dpi: sin huérfanos, sin superposición.

## Revisión de propuestas externas y mejoras a los módulos 4/5/9 — 2026-09-14, sin abrir fase nueva

Fran trajo 4 propuestas de mejora que Gemini generó revisando el PDF del
apunte (caja de erratas de Roederer, tabla de choque de notación de $mu$,
derivación de la pérdida por gravedad, diagrama vectorial de König). Se
verificó cada una contra el `.typ` real, no contra el resumen de Gemini:
**3 de las 4 ya estaban implementadas**, casi palabra por palabra — el
revisor externo no tenía el contrato del proyecto ni su taxonomía de cajas
(`#cuidado` = rojo, `#notacion` = teal) y no las reconoció. Detalle de la
verificación de las 4 en el chat de esa sesión, no acá — es historia, no
estado. La lección de proceso (verificar propuestas externas contra la
fuente, no contra el PDF) quedó en la auto-memoria de la sesión, no acá.

**Lo único con mérito real: un diagrama vectorial nuevo para el teorema de
König**, que faltaba. Agregado:

- `apunte/biblioteca/figuras.typ`: `fig-konig-descomposicion`, en el
  espacio de *velocidades* (no de posiciones — rótulo explícito "$v = 0$"
  en el origen, para no repetir la confusión posición/velocidad que ya
  pasó una vez con el "centro fijo" del módulo #dos-cuerpos: regla propia 4
  del `CLAUDE.md` de este proyecto). Muestra
  $bold(v)_i = bold(v)_"cm" + bold(v)_i^*$ como suma de vectores: un tramo
  $bold(v)_"cm"$ compartido por las dos partículas, y el tramo final
  $bold(v)_i^*$ —exactamente opuesto entre las dos—, medido desde la punta
  del tramo compartido.
- `apunte/modulos/m04-centro-de-masa.typ`: la figura entra justo después de
  la ec. $bold(v)^* = bold(v) - bold(v)_"cm"$ y antes de la caja que
  interpreta $bold(P)^* = bold(0)$ — antes de que el teorema de König la
  use, no después (regla propia 4 otra vez).
- `docs/figuras.md` y el `catalogo` de `galeria.typ`: actualizados.
- **El primer intento de las etiquetas $v_2$ y $v_2^*$ salió superpuesto**
  —se vio recién en el render de la galería a 400 dpi, no en el compile,
  que da verde igual—: corregido moviendo `pos` de cada `flecha()` para que
  las dos no caigan en la misma zona del lienzo.

**Además, a pedido explícito de Fran: las explicaciones de los ejercicios
de los módulos 4, 5 y 9 —los que esta revisión tocó— se expandieron para
nombrar SIEMPRE qué es cada variable de cada ecuación**, no darla por
sabida del enunciado o de la teoría de arriba. Siete ejemplos tocados: los
2 de `centro-de-masa` (la astronauta —quedó autocontenido, ya no depende de
que el lector haya leído antes el módulo #cantidad-movimiento— y los
asteroides), los 3 de `cohete` (glosa de $mu$, $abs(v_r)$, $g$ y $g_0$
—esta última aclarando que $g_0$ *no* es la $g$ de la parte anterior del
mismo ejemplo, una distinción real que el enunciado no marca solo—), y 1 de
los 2 de `dos-cuerpos` (glosa de $v$ y $r$ en $mu = v^2 r$; el otro ejemplo
del módulo ya estaba autocontenido y no se tocó).

**Alcance elegido, todavía sin confirmar con Fran: sólo estos 3 módulos**,
no los otros 17 + Anexo A. Pesó que el pedido decía «un poco más» y que la
sesión venía de revisar específicamente estos tres — una relectura del
apunte entero para aplicar el mismo estándar es un trabajo de otro orden
(~60-100 ejemplos más para recompilar y verificar). Si Fran confirma que lo
quiere en todo el apunte, es la próxima tarea — no asumida acá.

**Verificado:** `python verificar-apunte.py` en verde (orden, claves,
grafo). Apunte recompilado completo — **168 páginas** (subió de 163; es
reflow de las 7 ediciones empujando el resto del documento, no contenido
nuevo de ese tamaño). Las páginas impresas 24-27, 31-32, 34 y 63 —las que
tocaron estos cambios— miradas en render a 150-400 dpi: sin huérfanos, sin
superposición, sin desborde.

## Anexo A agregado el 2026-09-14 — guía de ejercicios, sin abrir fase nueva

Dos pedidos de Fran, resueltos en la misma sesión y sin tocar ningún módulo
(por eso no abre fase): **(1)** una estructura reusable para agregar
apéndices o secciones a un apunte Typst sin reorganizar nada existente, y
**(2)** usarla para volcar los 40 enunciados de `fuentes/GUIA-ENUNCIADOS.md`
en un anexo de práctica — qué conceptos/ecuaciones/teoremas aplicar, y *sólo
la respuesta final*, nunca la resolución desarrollada (eso ya lo hacen los
`#ejemplo` de cada módulo).

**Hecho, compilado y verificado en render** (páginas del anexo miradas una
por una, cero huérfanos de caja, `verificar-apunte.py` en verde). El apunte
pasó de **151 a 161 páginas impresas**, con una Parte 6 nueva ("Anexos") y
el **Anexo A** adentro: 49 fichas en cinco grupos —Vectores (7), Cantidad de
movimiento (9 + 3 adicionales), Impulso angular (7), Gravitación (11 + 5
adicionales), Cuerpo rígido (9)—.

**Mecanismo, en `apunte/plantilla.typ`:** un `state("rotulo-especial", ...)`
que cada tipo de sección sin numerar pisa antes de su heading (así
"SECCIÓN PRELIMINAR" y "ANEXO A" conviven sin una rama nueva por tipo en el
show-rule); `#anexo(letra, titulo, resumen)`, que abre una sección como
`#modulo()` pero **no** emite la metadata que `M()` busca —un anexo no es un
módulo, no entra en el grafo de `verificar-apunte.py` ni debe entrar—; y
`#disparador(numero, enunciado, resuelve:, respuesta)`, la ficha de
práctica, en violeta porque ese color ya significaba "vínculo con la guía de
problemas" — no hizo falta un color nuevo. El patrón completo, generalizado
para cualquier apunte de este flujo (no sólo éste), quedó documentado en
`/pdf-con-codigo` (sección "Modularizar un documento largo").

**42 de las 49 fichas tienen respuesta numérica** (las demás son
demostraciones o valen "ver el módulo X"). De esas 42: **~24 citan una
respuesta ya verificada adentro del apunte** (grado *confirmado* — tiene su
desarrollo completo, mirado en render); **~18 se calcularon de cero para
esta ficha** con las herramientas del módulo citado, marcadas
*"(cuenta propia de este anexo)"* en el propio PDF — grado *probable*, no
tuvieron la segunda mirada que sí tuvo el resto del apunte. El Problema 9
de cuerpo rígido suma un caso aparte: sus puntos 1 a 7 quedaron resueltos en
forma *simbólica* (es lo que el enunciado pide para esos puntos) y sólo el
punto 8 —la versión numérica— sigue abierto, por la razón que sigue.

**Actualizado el mismo día, más tarde: las cuatro se retomaron renderizando
`PROBLEMAS FÍSICA ESPACIAL (2).pdf` (la guía se corrió 2-3 páginas respecto
de la numeración vieja por los bloques "ADICIONALES" insertados — cuerpo
rígido quedó en pág. 17-21, no 15-18). Tres quedaron resueltas y una a
medias:**

- **Problema 5** (cinco esferas): resuelto sin ambigüedad. La frase rara del
  enunciado ("el doble") no hacía falta leerla dos veces — el teorema de
  ejes perpendiculares más la simetría $>=3$ de las esferas alrededor de
  $A$-$A$ (visible en la figura) da $I_"transversal" = I_(A"-"A)\/2$ solo,
  sin necesitar masas ni posiciones. $dot(chi) = 6$ rev/min, directa.
- **Problemas 7 y 8** (cápsula, tronco de cono): resueltos con la geometría
  leída de la figura — $A$ en el radio de la base $(2 m)$, $B$ en el radio
  angosto de arriba $(1,25 m)$, cada uno a la altura correspondiente del
  centro de masa. La coordenada $x$ de cada cohete no hace falta: la fuerza
  es paralela a $x$ y el producto vectorial no la usa. Precesión a $1,13$ y
  $1,45$ rpm respectivamente.
- **Problema 9** (satélite octogonal): los puntos 1 a 7 quedaron resueltos
  —incluidos simbólicamente en función de $x_A,z_A,x_B,z_B$, que es
  exactamente lo que el enunciado pide—, usando el mismo truco que 7 y 8
  (la fuerza es paralela al eje de simetría $y$, así que tampoco hace falta
  esa coordenada de los thrusters). **El punto 8 (los números) queda
  abierto**: la figura no alcanza para decidir con certeza qué vértice del
  octógono mira hacia $+x$, y de esa orientación dependen $x_A,z_A,x_B,z_B$.
  Con esa orientación confirmada —mirando el PDF a mayor resolución que la
  que tiene esta guía escaneada, o preguntándole a la cátedra— la cuenta es
  mecánica, la misma de los Problemas 7/8.

**Las respuestas de 5, 7 y 8, y las de 1-7 del 9, están marcadas en el
propio Anexo A como "cuenta propia de este anexo"**: no tuvieron la
segunda mirada (auditoría independiente) que sí tuvo el resto del apunte,
más allá de los controles de consistencia hechos al resolverlas (para el
Problema 5, el período dio un número redondo, $10,0$ s; para 7 y 8, el
salto $bold(H)=Delta bold(H)$ cuando $bold(omega)_0=bold(0)$ se verificó
explícitamente).

**Actualizado el mismo día, más tarde — pasada de calidad a las 49
fichas, a pedido de Fran.** Dos cosas, sobre el mismo archivo:

1. Fran pidió que cada ficha alcance para alguien que baja el apunte
   *sin haber leído los módulos* — hasta acá, varios "Se resuelve con"
   eran una cita desnuda tipo "(8)", que sólo sirve si ya se sabe qué hay
   en el módulo 8. Se reescribieron los treinta y pico que estaban así,
   con el principio y la ecuación en palabras (p. ej. "el torque respecto
   del centro de fuerza es nulo, así que $L$ se conserva para cualquier
   fuerza central" en vez de sólo el número de módulo).
2. Fran pidió, aparte, que **ningún inciso quedara sin respuesta**. La
   auditoría encontró ocho fichas que dejaban uno o más incisos afuera
   —el Problema 1 de gravitación (7 incisos, sólo decía "ver el módulo"),
   el 3 (faltaba la velocidad), el 4 (faltaban razón y rapideces), el 5
   (faltaba el sentido de encendido), los Problemas 8 y 9 del LEM
   (faltaban rapidez, velocidad relativa y la magnitud de $v_C$), el
   Ej. 3 de cantidad de movimiento (el calamar) y el Ej. 9 (la altura) — y
   se completaron todas, la mayoría citando un número que YA estaba
   calculado adentro de algún módulo (`grep` de `#ejemplo` en
   `m06-trabajo-energia.typ`, `m11-kepler.typ`, `m18-inercia.typ`,
   `m19-euler-giroscopo.typ` lo encontró) y dos con cuenta nueva de este
   anexo (la altura del Ej. 9, integrando $V(t)$; la velocidad
   geosíncrona del Problema 3).

162 páginas impresas ahora (era 161). Recompilado, cero huérfanos,
`verificar-apunte.py` en verde.

**Actualizado el mismo día, una vez más — resultados intermedios en las
fichas complejas, a pedido de Fran (saltea Vectores, que ya estaba bien).**
Doce fichas de las más largas (multi-paso) ganaron un valor intermedio
explícito antes de la respuesta final, para que alguien pueda ubicar en
qué paso se desvió si el número final no le cierra — el ejemplo que dio
Fran fue $v_"esc"$ en el Problema 4 de gravitación. Las doce: Cantidad de
movimiento Ej. 7-8 y Adicional 3; Impulso angular (sin número) y Ej. 7; y
en Gravitación, Problemas 4, 6, 7, 8-9 (el LEM, la que más ganó: radios,
semieje, $h$ y las dos velocidades de cada tramo) y los Ejercicios
adicionales 1, 2 y 4. 163 páginas impresas. Recompilado, cero huérfanos,
`verificar-apunte.py` en verde, Drive verificado por MD5 después de
pushear.

**Descubierto de paso, y no corregido — no era parte del pedido:** las
descripciones en prosa de "Lo que hay escrito en la Parte III/IV/V" (más
abajo, en este mismo archivo) usan números de módulo **desactualizados en
uno** desde que la fase 8 insertó `m02-marcos.typ`: dicen "Módulo 6 —
Gravitación" donde el archivo real es `m07-gravitacion.typ` (módulo 7), y
así con el resto de Parte III en adelante. Es la misma clase de problema que
la regla 5 del `CLAUDE.md` del proyecto ya resolvió *adentro* del apunte con
`#M("clave")` — pero `ESTADO_ACTUAL.md` y `HANDOFF.md` son prosa de Markdown
sin ese mecanismo, y nada los revalida cuando el apunte se reordena. No
afecta el PDF (los `#M()` del `.typ` están bien, medido por
`verificar-apunte.py`); si una sesión futura necesita citar "el módulo N" de
esta prosa histórica, conviene sumarle 1 a partir de la Parte III, o mejor,
buscar por **clave** (`gravitacion`, `momento-angular`, …) en vez de por
número.

---

## FASE 8 — CERRADA el 2026-09-13: fundamentos primero, y el orden ahora se mide

**Fase: ninguna — el apunte está CERRADO.** **20 módulos, 151 páginas
impresas**, compiladas y verificadas en render. No hay fase abierta.

Fran pidió dos cosas: que estuvieran los fundamentos —nombró la transformación
de Galileo— y que el apunte fuera en orden de bases hacia complejidad. Las dos
se midieron antes de tocar nada, y la medición contradijo al `HANDOFF`.

**Lo que la medición encontró, y es lo que cambia una decisión:**

- **La transformación de Galileo NO estaba deducida.** La fase 6 la había dado
  por cubierta con dos `grep`: uno era una línea suelta en el centro de masa
  («a cada velocidad se le resta $v_cm$», sin deducción ni figura) y el otro
  era Galileo el de los cuerpos que caen, en gravitación — otro hecho, otro
  Galileo. **Tampoco estaban** las tres leyes de Newton escritas en ninguna
  parte, ni la definición de *marco inercial*, que cinco módulos usaban como
  si estuviera dada.
- **El orden tenía una sola dependencia al revés, y era la que impedía
  arreglarlo:** el problema de tres cuerpos (Parte V) necesitaba la fórmula del
  marco rotante, que vivía en cuerpo rígido. Por eso la Parte V estaba al final
  «por una razón puramente práctica», según lo declaraba el propio
  `apunte.typ`.

**Lo que se hizo, y en este orden:**

1. **Módulo nuevo — «Marcos de referencia: cuándo vale F = m a, y qué pasa
   cuando no»**, que es el módulo 2, en la Parte I. Las tres leyes; la
   definición de marco inercial; la transformación de Galileo deducida con
   figura propia (`fig-galileo`) y la invariancia de $F = m a$; qué cambia y
   qué no al cambiar de marco (`p`, `K` y `W` cambian — S&Z vol. 1 pág. 179);
   la fuerza de inercia de un marco que acelera; y **las dos correcciones de un
   marco que gira con $Omega$ constante, deducidas desde la aceleración en
   polares del módulo 1** — sin herramientas nuevas. Fuentes medidas, no
   citadas de memoria: Roederer cap. 3 págs. 100-102 (ec. 3.23) y Beer §15.11
   ec. 15.35 págs. 977-978.
2. **Orden nuevo**: Parte I *Herramientas* (vectores, marcos) · II
   *Conservación* · III *Gravitación y mecánica orbital* · **IV *De la cónica
   al viaje real*** (era la V) · **V *Cuerpo rígido*** (era la IV). El viaje
   interplanetario quedó pegado a la mecánica orbital de la que sale, y el
   cuerpo rígido —que casi no usa nada anterior— quedó último.
3. **La dependencia al revés desapareció**: tres cuerpos ahora usa la
   `@marcos-rotante` del módulo 2, y cuerpo rígido generaliza ese mismo
   resultado en vez de fundarlo. Medido: en el grafo de los 20 módulos, la
   columna «usa» va **siempre hacia atrás**.

**El cambio de fondo, que es el que va a sobrevivir a esta sesión:** el número
de un módulo ya no se escribe a mano. Había **355 números en la prosa** que
ningún compilador podía ver; ahora se escribe `#M("clave")` y el número sale
del orden de los `#include` de `apunte.typ`. La conversión se verificó de la
única manera que prueba algo: **el texto renderizado quedó idéntico carácter
por carácter a las 149 páginas de antes** — cero líneas de diferencia. Recién
con eso hecho se reordenó, y reordenar costó mover cuatro `#include`.

Lo mide `verificar-apunte.py` (nombres de archivo vs. orden, claves
declaradas, grafo de referencias) y lo prueba en rojo
`probar-verificar-apunte.py`, con control positivo antes y después.

---

## El apunte estaba cerrado desde antes — 2026-09-13, y la guía se puede resolver con él

**Se cerró dos veces el mismo día, y la segunda es la que vale.** La primera
vez se cerró sin anexos por criterio. Después Fran pidió verificar que el
roadmap estuviera completo y que la guía de gravitación fuera resoluble — y
esa verificación, que nunca se había hecho, abrió y cerró la fase 7.

**Lo que la verificación midió** (detalle completo en `PDP.md` §4, fase 7):

- **El roadmap de Curtis está completo salvo un nodo**, la ecuación de Kepler
  tiempo-anomalía, que el propio apunte declara en `m11:264`. Lo nuevo:
  **ningún problema de la guía lo necesita**, y ahora eso está verificado
  contra la guía, no asumido.
- **Los 16 problemas de gravitación son resolubles** con lo escrito. Dos ya
  están resueltos adentro del apunte (`m16:354` y el ejemplo de `m10`).
- **Los dos únicos huecos eran de vocabulario**, y se taparon: la *energía
  específica* $epsilon$ en el módulo 9 (pág. 68-69) y la órbita
  *geosincrónica / geoestacionaria* en el módulo 6 (pág. 46), cada término
  junto a la deducción que ya existía.

**Deuda que sobrevive, declarada y no tapada:** la ecuación de Kepler
tiempo-anomalía (citada en 17.6, 18.5 y 19.7) y, por ella, los 3,2 días de la
travesía de la esfera de influencia que `m18` cita sin deducir.

**Lo que NO se verificó, y es lo primero de una próxima sesión:** las otras
cuatro secciones de la guía —vectores, cantidad de movimiento, impulso
angular y cuerpo rígido—. Sus problemas son en su mayoría imágenes y no se
auditaron: Fran pidió gravitación.

**Los tres anexos** (formulario, constantes, correspondencia con la cátedra)
siguen sin escribirse. Ya no bloquean nada — siguen siendo útiles para
estudiar, no para resolver. El alcance está escrito en `PDP.md`.
**Desde esta sesión el PDF se publica en Drive** para los compañeros, junto
con el de Electrónica Analógica. El mecanismo está en la raíz del repo
(`publicar-apuntes.ps1`); qué se publica y qué no, en
`.claude/apuntes-publicos.json`.

**FASE 5 — CERRADA el 2026-09-13.** Los cuatro módulos de la Parte V (M16–M19,
escritos el 2026-09-11) más el cierre de fase: las referencias cruzadas de
texto plano validadas para los **19** módulos (no sólo la Parte V — el detalle
de qué estaba mal y se corrigió está en `HANDOFF.md`, sección «Fase 5 —
CERRADA») y el blanco al pie de la pág. 30 impresa, revisado y declarado
aceptable.

**FASE 6 — CERRADA el 2026-09-13, sin tocar el apunte.** Los tres pedidos que
Fran hizo al cerrar la fase 5 se resolvieron apenas agregó el roadmap y los
tres libros del Taller: (1) el roadmap (Apéndice B de Curtis) no reveló
huecos — lo que dibuja ya está deducido en los módulos 6-10, salvo la
ecuación de Kepler tiempo-anomalía, que ya es deuda declarada; (2) Galileo ya
está deducido dos veces (M3, M6); (3) los temas del Taller de Física se
mudaron a un proyecto propio, [`taller-de-fisica/`](../taller-de-fisica/CLAUDE.md)
— es materia aparte y no le correspondía a este apunte. El detalle está en
`HANDOFF.md`, sección «Fase 6 — CERRADA».

**FASE 5 — contexto original.** Es la fase que la cátedra abrió sin querer: la
lista de temas de gravitación actualizada (`Lista de temas Gravitación (2).pdf`)
agrega «Todo — Curtis cap. 2» y los parámetros orbitales del Bate, y Fran
pidió además órbitas parcheadas, esfera de influencia y su relación con
Hohmann y con la gravedad de la Tierra. El plan de los cuatro módulos, con el
hueco medido contra los quince ya escritos, está en `PDP.md` §4 (fase 5).

| Módulo de la Parte V | Estado |
|---|---|
| **M16 — La hipérbola: escapar, y llegar con velocidad de sobra** | **escrito y verificado en render** (2026-09-07) |
| **M17 — La esfera de influencia y las órbitas parcheadas** | **escrito y verificado en render** (2026-09-07, sesión 2) |
| **M18 — Marco perifocal, vector de estado y coeficientes de Lagrange** | **escrito y verificado en render** (2026-09-08, sesión 3) |
| **M19 — Tres cuerpos restringido y puntos de Lagrange** | **escrito y verificado en render** (2026-09-11, sesión 4) |

**Lo que falta para cerrar la fase 5 es la sesión de cierre**, no un módulo:
las referencias cruzadas de la Parte V validadas contra el índice renderizado.
`docs/figuras.md` ya quedó al día en esta sesión.

**El apunte pasó de 106 a 149 páginas** y de 28 a 37 figuras. La Parte V
arranca en la página 107 y el M19 ocupa las páginas 133 a 145 (impresas).
`apunte.typ` ya no tiene ningún `#include` comentado salvo el de los anexos,
que es de la fase 6.

**Lo que el M16 cerró, además de su propio tema.** Las dos fórmulas que
faltaban para despejar $v_r$ y el ángulo de trayectoria de vuelo $gamma$
—$v_perp = h/r$, $v_r = (mu/h) e sin nu$, $tan gamma = v_r/v_perp$— entraron
en la sección 16.5. Con eso quedan resolubles los **ejercicios adicionales 1,
2, 4 y 5 de gravitación**, que hasta el 2026-09-07 figuraban en
`GUIA-ENUNCIADOS.md` como «el apunte no tiene esa fórmula despejada». El 5
está resuelto adentro del módulo como ejemplo simple ($e = 0,215$,
$nu = 63,8°$); el 1, el 2 y el 4 quedan como práctica, ahora sí con la
herramienta a mano.

**Y el enlace que Fran pidió está hecho, con números.** La sección 16.6
retoma el ejemplo de Marte del módulo 11 y muestra qué le faltaba: los
$2,94$ km/s que aquella cuenta llamaba $Delta v_1$ **no son** lo que el motor
tiene que dar, son $v_oo$ — la velocidad de sobra medida desde el Sol. Lo que
el motor da, desde una órbita de estacionamiento de 300 km, son $3,59$ km/s,
y la diferencia no es lineal porque las velocidades se suman en cuadrado. La
*licencia* para pegar los dos problemas (por qué se puede) **la dio el módulo
17 el mismo día, en la sesión 2**.

**Lo que el M17 cerró (2026-09-07, sesión 2).** La promesa del M16 está
cumplida y con auditoría: la esfera de influencia sale de comparar
perturbaciones —no fuerzas—, y el módulo muestra primero que el criterio
ingenuo («quién tira más fuerte») deja a la Luna afuera de la Tierra, que es
el absurdo que obliga a cambiar de pregunta. El ejemplo de Marte quedó cerrado
de punta a punta con dos números que el M16 no tenía: **$\beta = 29,2°$**, que
dice *dónde* se enciende, y **$\Delta m/m = 0,705$** con la ecuación del cohete
del módulo 4. Y hay una sección entera —la 17.6— dedicada a *medir el error
del método*: en la frontera la nave va a $3,086$ km/s y no a los $2,943$ que
el parcheo supone (4,9% de más), pero la dirección se acierta con $1,5°$. El
error es asimétrico, y eso es lo que decide que las misiones corrijan a mitad
de camino en vez de rediseñar.

**Lo que el M18 cerró (2026-09-08, sesión 3).** Las dos filas nuevas que la
cátedra agregó a la lista de gravitación —«todo Curtis cap. 2» y los
parámetros orbitales del Bate— quedan cubiertas: el marco perifocal
(Curtis §2.10 y Bate §2.2.4), los **seis elementos orbitales clásicos** con su
receta de obtención desde el vector de estado (Bate §2.3 y §2.4) y los
**coeficientes de Lagrange** (Curtis §2.11). Dos figuras nuevas.

Tres cosas que el módulo aporta y que no estaban en el plan:

- La deducción de los coeficientes de Lagrange se apoya en **un solo hecho
  geométrico**, dicho antes de cualquier cuenta: $bold(r)_0$ y $bold(v)_0$ son
  una base del plano de la órbita, porque si fueran paralelos $bold(h)$ sería
  cero. Con eso, que existan $f$ y $g$ deja de ser un resultado y pasa a ser
  obvio; la cuenta sólo dice cuánto valen.
- La identidad $f dot(g) - dot(f) g = 1$ se presenta como lo que es: **la
  conservación del momento angular**, o sea la segunda ley de Kepler escrita
  como un determinante igual a uno. Y sirve de control aritmético gratis, que
  el ejemplo a fondo usa.
- **Una tercera errata de Curtis**, confirmada por el resultado impreso del
  propio libro: el ejemplo 2.13 imprime $r_0 = 10 thin 861$ km donde va
  $10 thin 681$ (con $10 thin 861$ no sale el $h = 75 thin 366$ que el libro
  publica dos renglones más abajo, y el resto del ejemplo usa $10 thin 681$).
  Queda anotada en el apunte, en un `#cuidado` al lado del ejemplo.

**Lo que el M19 cerró (2026-09-11, sesión 4).** Cubre Curtis §2.12 entero —el
marco co-rotante, las tres ecuaciones de movimiento, los cinco puntos de
Lagrange, la estabilidad y la constante de Jacobi— y con eso la fila «todo
Curtis cap. 2» de la lista de la cátedra queda completa. Tres figuras nuevas.

Cuatro cosas que el módulo aporta y que no estaban en el plan:

- **La comparación Hill contra esfera de influencia, con su propia deducción**
  (sección 19.4). El radio de Hill se deduce desarrollando a primer orden la
  condición de equilibrio de $L_1$ —tres renglones— y da
  $r_"Hill" = r_12 (m_2\/3m_1)^(1\/3)$, que para la Luna vale $61 thin 524$ km
  contra los $58 thin 019$ medidos: 6% de más, que es el precio del primer
  orden. Y la razón entre las dos fronteras sale con **exponente $-1\/15$**,
  tan chico que las dos coinciden en casi todo el sistema solar — salvo
  donde importa: **$L_1$ y $L_2$ del par Sol–Tierra están AFUERA de la esfera
  de influencia de la Tierra** (1,5 millones de km contra 925.000), así que
  el SOHO y el James Webb viven en lugares que el método del M17 considera
  territorio del Sol. Esto es propio del apunte: Curtis no compara las dos.
- **El «potencial de Jacobi»**, nombre de este apunte (Curtis no lo bautiza),
  que deja la constante de Jacobi con la forma $C = K + U_J$ — el $E = K + U$
  del módulo 5 palabra por palabra. Con eso la figura del perfil se lee como
  un diagrama de energía y no hace falta el gráfico 2-D de curvas de
  velocidad cero de Curtis.
- **Por qué $L_4$ y $L_5$ salen exactos y los tres colineales no**: con
  $y != 0$ hay dos ecuaciones y son *lineales* en $1\/r_1^3$ y $1\/r_2^3$;
  sobre el eje queda una sola condición y es una quíntica. La deducción de
  los puntos triangulares no usa ninguna aproximación y no depende de las
  masas.
- **Una cuarta errata de Curtis**, en el ejemplo 2.17 y confirmada por el
  propio libro: imprime $x_1 = -pi_1 r_12 = -0,9878 dot 384 thin 400 =
  -4670,6$ km, donde el símbolo y el factor son de $pi_1$ y el resultado es
  de $pi_2$ ($0,9878 dot 384 thin 400 = 379 thin 700$). Lo correcto es
  $x_1 = -pi_2 r_12$, que es lo que dice su propia ec. (2.177a). En el mismo
  ejemplo hay otra transposición: $5,947 times 10^24$ donde va
  $5,974 times 10^24$.

**Todos los números del M19 están recalculados desde cero**, no copiados: las
tres raíces de la quíntica por bisección propia, las cuatro constantes de
Jacobi y las seis velocidades de apagado. Las cuatro constantes coinciden con
las que Curtis imprime en su figura 2.37 hasta la última cifra que el libro
muestra, lo cual es la verificación cruzada del cálculo entero.

**El Bate SÍ está en el disco**, contra lo que el HANDOFF de la sesión 2
suponía: `Roger R. Bate, Donald D. Mueller, Jerry E. White - Fundamentals of
astrodynamics-Dover Publications (1971).pdf`, en la misma carpeta que el
Curtis. Offset medido: **página impresa = página del PDF − 15**.

**Lo que el M18 NO hizo, a propósito.** No desarrolla la ecuación de Kepler
—no es su tema y da para un módulo entero—, así que **los 3,2 días de la
sección 17.6 siguen citados y no deducidos**. El M18 lo dice explícitamente en
su sección 18.5, de modo que la deuda queda declarada adentro del apunte y no
sólo acá.

**Fase 3 (Parte III: gravitación y órbitas) — CERRADA el 2026-08-31.**

**Fase 4 (Parte IV: cuerpo rígido, M12–M15) — CERRADA el 2026-08-31.** Los
quince módulos del apunte estaban escritos, compilados y verificados en el
render.

**2026-09-07 — tres ejercicios nuevos incorporados, sin abrir fase nueva.**
Fran trajo una versión ampliada de la guía de la cátedra (ver
`fuentes/RUTAS.md` y la nota al principio de `fuentes/GUIA-ENUNCIADOS.md`),
con dos bloques de «adicionales» que el original no tenía. Se incorporaron
tres —el resto queda anotado como práctica sin resolver, siguiendo la misma
decisión de curación que ya regía para los Problemas 5, 7, 8 y 9 de cuerpo
rígido (ver el `#guia` del módulo 15: no se agrega un ejercicio que no
enseña una técnica nueva, se anota para práctica):

- **Módulo 2** — Adicional 1 (separación de dos etapas de un cohete, el
  mismo mecanismo del Ej. 1 con las dos masas en movimiento) y Adicional 2
  (satélite expulsado del transbordador), que es el primer ejemplo del
  módulo que usa numéricamente $F_"prom" = Delta p \/ Delta t$ y no sólo la
  define.
- **Módulo 4** — Adicional 3: el mismo empuje y la misma definición de
  $I_"sp"$ aplicados a un cohete con varios motores encendidos a la vez (el
  transbordador, con sus dos SRB y sus tres SSME), que es el caso real de
  cualquier lanzador con etapas de refuerzo.
- **Módulo 10** — el Ejercicio adicional 3 de gravitación (excentricidad de
  una órbita polar a partir de su período): la tercera ley despejada al
  revés, sin momento angular ni energía.

Los otros siete adicionales no se tocaron entonces. *Actualizado el mismo
día, más tarde:* los ejercicios 1, 2, 4 y 5 de gravitación pedían anomalía
verdadera o ángulo de trayectoria de vuelo como *dato de salida*, y el apunte
no tenía esa fórmula despejada. **El módulo 16 la agregó** (sección 16.5), y el
**5 quedó resuelto ahí como ejemplo simple**; el 1, el 2 y el 4 siguen anotados en
`GUIA-ENUNCIADOS.md` como práctica, ahora con la herramienta a mano.

**Mismo día — nueva caja de estilo, `#posta`.** A pedido de Fran, el módulo 8
sumó dos cuadros técnicos (por qué funciona el problema equivalente, qué es
el "centro fijo") y, sobre eso, se creó una **tercera regla propia del
apunte** (ver `CLAUDE.md`): todo tema nuevo lleva, además de las cajas
técnicas, un cuadro rosa `#posta` con la misma idea en criollo. La función
vive en `plantilla.typ`, el color en `paleta.typ`, y la leyenda de la
carátula ya lo explica. **No se retrofitteó a los 15 módulos existentes** —
se aplica de acá en adelante.

**Mismo día — reordenado el módulo 8: el modelo se explica antes de la
figura, no después.** Fran reportó no entender "respecto de qué" estaba el
punto fijo del problema equivalente: la figura que lo mostraba aparecía
*antes* de que ninguna caja lo explicara. Se agregó una sección nueva al
principio del módulo, «8.1 La idea completa, antes de la primera ecuación»,
que cuenta el plan en criollo y en tres pasos y recién ahí muestra la
figura —movida desde su posición vieja, más abajo—; las cajas técnicas que
ya explicaban el punto fijo quedaron donde estaban, ahora como
profundización de algo ya presentado, no como primera exposición. Quedó
registrado como **cuarta regla propia** en `CLAUDE.md`: todo modelo o
entidad nueva se explica en palabras antes de la primera ecuación o figura
que lo use, con el `m8-nodos-mallas.typ` de Electrónica Analógica como
referencia de cómo se hace bien. Compilado y verificado en el render: cero
huérfanos de caja, **106 páginas**.

| Qué | Estado |
|---|---|
| `apunte/apunte.pdf` | **126 páginas**, compila sin errores, cero huérfanos de caja |
| Plantilla, carátula, índice, encabezados | listos, no se tocan |
| Biblioteca de figuras (CeTZ) | **32 figuras**, todas miradas en la galería |
| Módulos 1 a 5 — Partes I y II | escritos y verificados (fases 1 y 2) |
| **Módulo 6 — Gravitación, peso y energía potencial** | **escrito y verificado en render** |
| **Módulo 7 — Momento angular y fuerzas centrales** | **escrito y verificado en render** |
| **Módulo 8 — Dos cuerpos y masa reducida** | **escrito y verificado en render** |
| **Módulo 9 — Potencial eficaz y ecuación de la órbita** | **escrito y verificado en render** |
| **Módulo 10 — Las leyes de Kepler** | **escrito y verificado en render** |
| **Módulo 11 — Maniobras: Hohmann y rendez-vous** | **escrito y verificado en render** |
| **Módulo 12 — Cinemática del cuerpo rígido y sistemas rotantes** | **escrito y verificado en render** |
| **Módulo 13 — Momento de inercia y ejes principales** | **escrito y verificado en render** |
| **Módulo 14 — Ecuaciones de Euler y el giróscopo** | **escrito y verificado en render** |
| **Módulo 15 — Peonza simétrica, precesión directa y retrógrada** | **escrito y verificado en render** |
| **Módulo 16 — La hipérbola: escapar y llegar con velocidad de sobra** | **escrito y verificado en render** |
| **Módulo 17 — La esfera de influencia y las órbitas parcheadas** | **escrito y verificado en render** |
| **Módulo 18 — Marco perifocal, vector de estado y coeficientes de Lagrange** | **escrito y verificado en render** |
| **Módulo 19 — Tres cuerpos restringido y puntos de Lagrange** | **escrito y verificado en render** |
| Anexos | no empezados |

## Lo que hay escrito en la Parte III

**Módulo 6 — Gravitación de Newton, peso y energía potencial** (9 pág.). La ley
de Newton con su signo y su versor; el teorema de la cáscara (citado, no
deducido); $mu = G M$ y por qué tiene letra propia; peso y $g$, con la cuenta
de Cavendish; **la deducción de $U = -mu m \/ r$ que el módulo 5 había dejado
prometida**, con el cero en el infinito explicado como la elección que hace que
el signo de $E$ signifique algo; el pozo de potencial y la tabla que clasifica
la órbita por el signo de $E$; velocidad de escape; y la órbita circular con
$v_"circ"$, $T$, $E = -mu m \/ 2r$ y $v_"esc" = sqrt(2) v_"circ"$. Ejemplos: el
Problema 0 (estimar la masa del Sol, $1,99 times 10^30$ kg) y el Problema 6 de
Beer (subir a la geosíncrona: $90,6$ y $208,3$ GJ), que adentro resuelve de
paso el Problema 3.

**Módulo 7 — Momento angular y fuerzas centrales** (7 pág.). $bold(L) = bold(r)
times m bold(v)$ como brazo de palanca, con el cuadro de por qué hay que
declarar siempre el punto; la tabla de traducción de notación Beer ↔ cátedra;
$sum bold(tau) = d bold(L)\/d t$; fuerza central y sus dos consecuencias —el
movimiento es plano y $r^2 dot(theta)$ es constante—; $h = r v cos gamma$ y por
qué en los ábsides se reduce a $h = r v$; y la segunda ley de Kepler deducida
de la conservación. Contesta la pregunta fina del Ej. 5 con la tabla de las
tres condiciones. Ejemplos: los Problemas 2 y 3 (las dos demostraciones) y el
Ejercicio 4 (el satélite de la figura).

**Módulo 8 — El problema de dos cuerpos y la masa reducida** (6 pág.). Saca la
suposición de que el cuerpo central está fijo; deduce
$bold(accent(r, dot.double)) = -mu bold(r)\/r^3$ con $mu = G(m_1+m_2)$ —y con
eso salva toda la Parte III sin rehacer nada—; las dos elipses semejantes
alrededor del CM; la masa reducida y el problema equivalente; y la tabla de
cuándo importa, con $q = m_2\/m_1$. Ejemplos: el Problema 0 rehecho (lo que se
midió fue $M_"Sol" + M_T$) y el sistema Tierra–Luna construido sobre los datos
del Problema 8 (CM a 4671 km, adentro de la Tierra; el mes da 27,28 días contra
27,45 si se ignora la Luna).

**Módulo 9 — El potencial eficaz y la ecuación de la órbita** (10 pág.). Es el
módulo central de la parte y hace las dos mitades. La cualitativa: sustituir
$dot(theta) = h\/r^2$ adentro de la energía cinética deja
$E = 1/2 m dot(r)^2 + U_"ef" (r)$, un problema de *una* variable al que se le
aplica tal cual el diagrama del módulo 5 — con la barrera centrífuga (por qué
la Luna no se cae), el fondo del pozo en $r_0 = h^2\/mu$ (que reproduce el
$E = -mu m\/2r$ del módulo 6 como *mínimo de una función*) y la clasificación
en cuatro casos por el signo de $E$. La cuantitativa: el cambio de variable
$t arrow.r theta$, $u = 1\/r$, la ecuación de Binet, y su solución
$r = p\/(1 + e cos nu)$; después el puente $e = sqrt(1 + 2 E h^2\/(mu^2 m))$,
que ata las dos mitades, y de ahí $E = -mu m\/(2a)$ y la **vis-viva**. Cierra
con los seis números de la elipse. Ejemplos: el satélite del Ej. 4 rehecho
desde la ecuación de la órbita —$h = 57 thin 172$ km²/s sale ahora de las dos
alturas solas, sin usar ninguna velocidad del dibujo— y el Problema 7 (Beer
13.100, frenar en Júpiter: $Delta v = 14,2$ km/s, y la cuenta de por qué
capturar solo cuesta $0,9$).

**Tres figuras nuevas**, las tres miradas en la galería antes de usarse:
`fig-potencial-eficaz` (la figura 4.1 de la cátedra, redibujada),
`fig-conicas` (las cuatro con el mismo $p$) y `fig-elipse-geometria`.

**Módulo 10 — Las leyes de Kepler** (6 pág.). Muestra que las tres leyes de
Kepler no son un agregado: la primera es la ecuación de la órbita del módulo 9
evaluada en $0<e<1$; la segunda es la conservación del momento angular del
módulo 7; y la tercera —lo único nuevo— sale de integrar la
velocidad areolar sobre el área de la elipse, $tau = 2 pi a b \/ h$ (Beer
ec. 12.45), y de reemplazar $b$ y $h$ hasta quedar en $tau = 2 pi a^(3\/2) \/
sqrt(mu)$: la misma fórmula del módulo 6 con $a$ en el lugar de $r$. El cuadro
rojo central: por qué la ley *exacta* no dice que $T^2\/a^3$ sea igual para
todos los planetas —$mu$ depende de las dos masas, módulo 8—. Ejemplos: el
Problema 4 (S&Z 13.67, el satélite del módulo 9: período $tau = 7907$ s y la
comparación de escape, $Delta v_p = 2,41$ contra $Delta v_a = 3,26$ km/s) y los
Problemas 8 y 9 juntos (el LEM del Apollo: sube por una transferencia tipo
Hohmann hasta encontrarse con el módulo de mando a $30$ m/s de relativa, y
después baja y se estrella a $79,2°$ de la vertical).

**Módulo 11 — Maniobras: Hohmann y rendez-vous** (7 pág.). Cierra la Parte
III. Deduce la transferencia de Hohmann —por qué la elipse tangente a las dos
circulares es la más barata, con la vis-viva del módulo 9 en cada ábside— y el
tiempo de vuelo como medio período de la elipse de transferencia (módulo 10
partido a la mitad); y el rendez-vous por *órbita de fasaje*, con la relación
$T' \/ T =
1 - Delta phi \/ 360°$ que reduce el problema del reencuentro a un cambio de
tamaño de órbita. Ejemplos: el Problema 5 (Hohmann a Marte: $258,8$ días de
viaje y $44,4°$ de ángulo de fase en el lanzamiento) y el Problema 10 —abierto
en la guía— resuelto con el método general más un caso numérico concreto
(rendez-vous geosíncrono a un cuarto de vuelta, $Delta v = 698$ m/s en una
sola vuelta de fasaje). Cierra con el Road Map de Curtis (ap. B) redibujado en
CeTZ: los once resultados de la Parte III, de las leyes de Newton hasta las
ecuaciones de Kepler, en un solo diagrama de flujo.

**Cuatro figuras nuevas**, las cuatro miradas en la galería antes de usarse:
`fig-hohmann`, `fig-rendezvous-phasing` y `fig-roadmap-curtis` (módulo 11), más
la reutilización de `fig-elipse-geometria` y `fig-satelite-guia` por
referencia en los ejemplos del módulo 10.

## Lo que hay escrito en la Parte IV

**Módulo 12 — Cinemática del cuerpo rígido y sistemas rotantes** (7 pág.).
Abre la parte y es la herramienta de la que dependen los otros tres módulos.
El teorema de Euler —todo movimiento con un punto fijo es una rotación
alrededor de un eje— con su demostración sobre la esfera; el eje instantáneo,
$bold(v) = bold(omega) times bold(r)$ y la aceleración con sus dos términos,
más la advertencia de que $bold(alpha)$ *no* va sobre el eje instantáneo
(cosa que en movimiento plano nunca pasa); la demostración de que las
velocidades angulares se suman como vectores aunque las rotaciones finitas
no; el cono espacial y el cono corporal; **la derivada de un vector en un
sistema que rota** —el resultado central, y el que en el módulo 14 produce
las ecuaciones de Euler—, con la observación de que los versores polares del
módulo 1 son ese mismo teorema en su caso más chico; la distinción entre la
velocidad angular del *sistema* y la del *cuerpo*, que es donde se pierde el
planteo; el movimiento general de dos puntos cualesquiera; y Coriolis en tres
dimensiones, con la comprobación de que la aceleración en polares del módulo
1 es exactamente esa fórmula término por término. Ejemplos: las mitades
cinemáticas de los Problemas 2 (el disco en la horquilla:
$bold(alpha) = omega_1 omega_2 hat(i)$ con las dos rapideces constantes) y 3
(el volante en el gimbal: $bold(alpha) = 50 hat(i)$ rad/s², que es el efecto
giroscópico visible antes de escribir una sola ecuación de la dinámica).

**Tres figuras nuevas**, las tres miradas en la galería antes de usarse:
`fig-vector-rotante` (los dos casos de la derivada en un sistema rotante),
`fig-suma-omegas` (el Problema 2, con el eje instantáneo) y `fig-conos` (el
cono espacial y el corporal). La última estaba anotada en `docs/figuras.md`
como «la figura más difícil del apunte, probablemente necesite proyección 3-D
de CeTZ»: **no la necesitó**. Salió con la sección axial más un helper nuevo
de `estilo.typ`, `circulo-escorzo`, que proyecta un círculo del espacio como
la elipse que se ve de costado. Los módulos 14 y 15 la reusan cambiándole los
dos semiángulos.

**Módulo 13 — Momento de inercia y ejes principales** (5 pág.). Extiende
$H_G = I omega$ del plano al espacio: la deducción por integrales de
$bold(H)_G = integral bold(r) times (bold(omega) times bold(r)) dm$, con la
identidad BAC-CAB, hasta llegar a los momentos y productos de inercia (ecs.
18.4 a 18.7); el tensor de inercia como matriz simétrica de $3 times 3$ (ec.
18.8) y la existencia de ejes principales donde diagonaliza (ec. 18.9,
citada del Beer, no deducida —la demostración vive en el volumen de Estática
que no está disponible); el cuadro central de por qué $bold(H)_G$ y
$bold(omega)$ no son paralelos salvo sobre un eje principal (ec. 18.10);
$bold(H)_O = bold(macron(r)) times m bold(macron(v)) + bold(H)_G$ (ec.
18.11); y la energía cinética deducida por triple producto escalar hasta
$T = 1/2 bold(omega) dot bold(H)_G$ (ecs. 18.16, 18.17, 18.20). Ejemplos: el
Problema 1 (el satélite cúbico: tensor isótropo, $bold(omega) = 0,2 hat(j) -
0,2 hat(k)$ rad/s tras el encendido, y por qué sigue girando para siempre) y
el Problema 2 punto 1 (el disco de la horquilla: $bold(H)_G$ no paralelo a
$bold(omega)$, demostrado en números con $I_z = 2 I_x$).

**Sin figuras nuevas.** Reusa `fig-suma-omegas` del módulo 12 —los mismos
ejes de la horquilla sirven para calcular $bold(H)_G$ que para calcular
$bold(omega)$—, con un nuevo epígrafe.

**Módulo 14 — Ecuaciones de Euler y el giróscopo** (4 pág.). Aplica la
@m12-derivada a $bold(H)_G$ y llega a la relación general $dot(bold(H))_G =
(dot(bold(H))_G)_(O x y z) + bold(Omega) times bold(H)_G$ (ecs. 18.22/18.23,
y su versión con punto fijo, ecs. 18.27/18.28); de ahí salen las ecuaciones
de Euler clásicas ($bold(Omega) = bold(omega)$, ec. 18.25) y, por el camino
que los dos ejemplos usan de verdad, el caso $bold(Omega) != bold(omega)$
—ejes que acompañan la simetría del cuerpo sin girar con su espín, la
recomendación que el módulo 12 ya había dejado picando—. Cierra con los
ángulos de Euler (φ precesión, θ nutación, ψ giro, §18.9) y la derivación de
la cupla que sostiene una precesión estable (ecs. 18.40–18.44), con el caso
particular $theta=90degree$ (ec. 18.45). Ejemplos: el Problema 2 punto 2 (la
cupla del disco, $dot(bold(H))_G = 1/2 m r^2 omega_1 omega_2 hat(i)$, la
misma dirección que el $bold(alpha)$ del módulo 12) y el Problema 3 completo
(el volante en el gimbal: $600$ N·m de torque dan sólo $20$ rad/s² de
aceleración del gimbal, porque $500$ N·m se gastan en sostener la dirección
de $bold(H)_O$). Sin figuras nuevas.

**Módulo 15 — Peonza simétrica, precesión directa y retrógrada** (4 pág.),
cierra la Parte IV. El caso sin cuplas: $sum bold(M)_G = 0 arrow.r
bold(H)_G$ constante, de donde $dot(phi) = H\/I$ (la precesión no depende de
$theta$); $tan gamma = (I\/I') tan theta$ (ec. 18.49, con la aclaración de
que el $gamma,theta$ de esta fórmula puntual no son el $theta$ de nutación
del módulo 14); y el criterio de signo $dot(psi)\/dot(phi) = ((I'-I)\/I')
cos theta$ que separa precesión directa ($I' > I$, achatado) de retrógrada
($I' < I$, alargado) —**corregido contra una nota de planificación previa
que tenía el criterio invertido**; verificado con dos formas independientes
(las ecuaciones de Euler sin cupla, y el ejemplo de la Tierra/bamboleo de
Chandler, que es achatada y de precesión directa—dato astronómico conocido).
Ejemplos: el Problema 4 (el satélite achatado, $I'\/I=16\/9$, período de
precesión $1,832$ s) y el Problema 6 (el cilindro de paredes delgadas, umbral
$ell\/r = sqrt(6)$ entre directa y retrógrada, con el caso límite isótropo
que recuerda al cubo del módulo 13). Reusa `fig-conos` del módulo 12 con un
nuevo epígrafe, apoyada en su tangencia externa para ilustrar el caso
directo. Cierra con un párrafo de síntesis de toda la Parte IV.

## Lo que hay escrito en la Parte V

**Módulo 16 — La hipérbola: escapar, y llegar con velocidad de sobra**
(11 pág., 107–117). Cierra la clasificación de cónicas que el módulo 9 dejó
en una fila de tabla. Seis secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con la receta en tres pasos («necesitás que llegue al infinito → necesitás
   que además le sobre velocidad → de las dos sale todo») y un `#posta`.
2. *La parábola* — $e = 1$, $E = 0$, $v = v_\text{esc}$, y el `#cuidado` de por
   qué no tiene semieje y por qué ninguna trayectoria real es una parábola.
3. *La geometría* — $\nu_\infty = \arccos(-1/e)$, $\beta$, la deducción del
   ángulo de giro $\delta = 2\arcsin(1/e)$, $a = (h^2/\mu)/(e^2-1)$,
   $r_p = a(e-1)$, y el radio de puntería $\Delta = b = a\sqrt{e^2-1}$.
   Figura nueva: `fig-hiperbola-geometria`.
4. *La energía* — $E = +\mu m/(2a)$ deducida de la @m9-e-E del módulo 9;
   $v_\infty = \sqrt{\mu/a}$; $v^2 = v_\text{esc}^2 + v_\infty^2$; $C_3$.
   Figura nueva: `fig-hiperbola-energia`. Cuadro `#notacion` sobre la
   convención $a < 0$, que es la de todo el software de astrodinámica.
5. *$v_r$ y el ángulo $\gamma$* — la caja de herramientas de Curtis (pág. 99)
   y el truco de cálculo (armar $e\sin\nu$ y $e\cos\nu$, elevar al cuadrado y
   sumar). Cierra los ejercicios adicionales 1, 2, 4 y 5 de gravitación.
6. *El enlace con Hohmann* — el ejemplo de Marte del módulo 11 rehecho: los
   $2,94$ km/s eran $v_\infty$, no el $\Delta v$ del motor; el encendido real
   desde 300 km de altura vale $3,59$ km/s.

Ejemplos: el **simple** es el ejercicio adicional 5 de la guía ($e = 0,215$,
$\nu = 63,8°$) y el **a fondo** es el ejemplo 2.10 de Curtis (pág. 100), que
mide una hipérbola entera —$h$, $e$, $\nu$, $r_p$, $a$, $C_3$, $\delta$,
$\Delta$— a partir de $r$, $v$ y $\gamma$. Los dos usan exactamente el mismo
planteo de cinco ecuaciones, uno con $e < 1$ y el otro con $e > 1$: es la
razón por la que están apareados.

**Módulo 17 — La esfera de influencia y las órbitas parcheadas** (9 pág.,
118–126). Es el núcleo de lo que Fran pidió: la *licencia* que el M16 prometió
y no dio. Ocho secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («hay que decidir de quién es la nave en cada
   tramo → el criterio obvio es el equivocado → con la frontera dibujada son
   tres problemas de dos cuerpos») y un `#posta`.
2. *Por qué «quién tira más fuerte» es la pregunta equivocada* — la frontera
   ingenua da 259.000 km, **adentro** de la órbita de la Luna. El
   `#cuidado` explica por qué la cuenta no está mal hecha sino que mide lo que
   no importa, y el `#posta` del ascensor lo dice en criollo.
3. *La cuenta que sí sirve* — la `#deduccion` central: los dos puntos de vista,
   $P_p/A_s = (m_p/m_s)(R/r)^2$ y $p_s/a_p = (m_s/m_p)(r/R)^3$, y de igualarlos
   $r_"SOI" = R (m_p/m_s)^{2/5}$. El `#clave` que sigue explica **por qué los
   exponentes son 2 y 3** (el término solar es una *diferencia*, o sea marea) y
   por qué el 5 es literalmente $2+3$ — con eso la fórmula no se memoriza.
4. *Cuánto mide, y las dos comparaciones* — figura nueva
   `fig-esfera-influencia` (a escala real las dos veces) y tabla de siete
   cuerpos, calculada con la fórmula y coincidente con la tabla A.2 de Curtis.
5. *El método de las cónicas parcheadas* — `#definicion`, figura nueva
   `fig-conicas-parcheadas`, el `#clave` del pegado de velocidades relativas, y
   el `#cuidado` de por qué **no sirve para la Luna** (17% contra 0,6%).
6. *Cuánto cuesta la mentira* — la auditoría, hecha con las herramientas del
   M16: en la frontera la nave va a $3,086$ km/s y no a $2,943$ (**4,9% de
   error en el módulo**) pero la dirección se acierta con $1,5°$ de error. El
   error no es simétrico, y eso decide cómo se corrige.
7. *El ejemplo completo* — el ejemplo 8.4 de Curtis: $e = 1,145$,
   $Delta v = 3,590$ km/s (el mismo del M16, ahora justificado), y las dos
   cosas nuevas: $beta = 29,2°$ —**dónde** se enciende— y $Delta m/m = 0,705$
   con la ecuación del cohete del módulo 4.
8. *Lo que se usa después* — incluye el círculo de perigeos posibles de radio
   $r_p sin beta = 3260$ km, que es de dónde salen las ventanas diarias.

**Módulo 18 — Marco perifocal, vector de estado y coeficientes de Lagrange**
(10 pág., 123–132). Es el módulo de *herramientas* de la Parte V: no agrega
física nueva, agrega la forma en que la física que ya está se escribe para una
computadora. Seis secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («elegir bien los ejes → contar los números →
   propagar sin resolver nada») y un `#posta` de tres ideas, la última de las
   cuales organiza el módulo entero: una órbita *son seis números*.
2. *El marco perifocal* — `#definicion` de $hat(p) hat(q) hat(w)$, figura nueva
   `fig-perifocal`, la posición leída sin deducir y la `#deduccion` de
   $bold(v) = (mu\/h)[-sin nu hat(p) + (e + cos nu) hat(q)]$, con el `#clave`
   de que sus componentes **no dependen de $r$**. Un `#notacion` por el choque
   Curtis ($theta$, $hat(p) hat(q) hat(w)$) contra Bate ($nu$, $P Q W$).
3. *Los seis números de una órbita* — `#definicion` de vector de estado, los
   seis elementos clásicos del Bate, y el `#clave` que los separa: **cinco son
   constantes y sólo el sexto corre**. Después la receta de los tres vectores
   $bold(h)$, $bold(n)$, $bold(e)$ y los seis cosenos, con dos `#cuidado`: el
   de la resolución de cuadrante y el de las **órbitas degeneradas** (circular
   y ecuatorial), que cierra con «una singularidad de las coordenadas no es una
   singularidad de la física».
4. *Los coeficientes de Lagrange* — el argumento de la base en un renglón,
   figura nueva `fig-lagrange-base`, la `#deduccion` completa, el `#clave` del
   determinante igual a uno, las cuatro fórmulas en función de $Delta nu$ y la
   receta en cinco pasos (algoritmo 2.3 de Curtis).
5. *Lo que falta: el tiempo* — la ecuación de Kepler nombrada y **no**
   desarrollada, la serie de $f$ y $g$ en $Delta t$, y el `#cuidado` del radio
   de convergencia (1700 s, un quinto del período del ejemplo de Curtis).
6. *Lo que se usa después.*

Ejemplos: el **simple** son los ejemplos 2.11 y 2.12 de Curtis apareados a
propósito —la misma órbita en las dos direcciones, y el segundo termina en una
hipérbola que los datos no dejaban ver—; el **a fondo** son los ejemplos 2.13
y 2.14, una propagación entera de $120°$ que corre sin saber en qué cónica
está, con el control $f dot(g) - dot(f) g = 1$ hecho a mitad de camino.

**Módulo 19 — El problema restringido de tres cuerpos y los puntos de
Lagrange** (13 pág., 133–145). Cierra la Parte V y el apunte. Siete secciones:

1. *La idea completa, antes de la primera ecuación* — la regla 4 del contrato,
   con el plan en tres pasos («aceptar que no hay solución cerrada → cambiar
   de marco → preguntar dónde se puede estar quieto y a dónde no se puede
   llegar») y un `#posta` de tres ideas.
2. *El marco que gira con los dos cuerpos* — `#definicion` de las tres
   restricciones del nombre, figura nueva `fig-tres-cuerpos-marco`, las
   fracciones de masa $pi_1$ y $pi_2$ con un `#notacion` por el choque con el
   número $pi$ y con el $mu = G M$ del apunte, y la `#deduccion` de las tres
   ecuaciones de movimiento a partir de la fórmula de cinco términos del
   módulo 12. El `#clave` que sigue dice *por qué* no se resuelven: no
   linealidad más el acoplamiento de Coriolis.
3. *Los cinco puntos de Lagrange* — $z = 0$ en un renglón; la `#deduccion` de
   los dos triangulares (el sistema lineal en $1\/r_1^3$ y $1\/r_2^3$, sin
   ninguna aproximación); el `#clave` de por qué los tres colineales son una
   quíntica y no se despejan nunca; `#definicion` del método de bisección;
   figura nueva `fig-lagrange-puntos` (dos paneles) y el ejemplo simple con
   los cinco puntos del par Tierra–Luna.
4. *Dos fronteras para lo mismo: Hill contra la esfera de influencia* — la
   sección propia del apunte, con la `#deduccion` del radio de Hill, la tabla
   comparativa de las dos fronteras para la Luna y para la Tierra, el
   `#clave` del exponente $-1\/15$ y el `#cuidado` de que no hay que elegir
   una sino saber cuál contesta qué.
5. *Cuáles sirven para estacionar* — estabilidad, el criterio de Routh
   despejado ($k >= 24,96$, o $pi_2 <= 0,0385$), el `#cuidado` de que el Sol
   desestabiliza $L_4$ y $L_5$ del par Tierra–Luna, y un `#posta` sobre por
   qué las misiones reales están en los puntos *inestables*.
6. *La constante de Jacobi* — la `#deduccion` completa, el `#clave` de que
   Coriolis no aparece **porque no trabaja**, el potencial de Jacobi, figura
   nueva `fig-jacobi-perfil`, el `#clave` de las cuatro puertas en orden y el
   `#cuidado` doble (C no es la energía; permitido no es alcanzable).
7. *Lo que se usa después*, que cierra la Parte V entera.

Ejemplos: el **simple** es el 2.16 de Curtis (los cinco puntos del par
Tierra–Luna) y el **a fondo** es el 2.17 —las seis velocidades de apagado—,
cuyo resultado es el que justifica el módulo entero: **22 m/s separan «no
llego a la Luna» de «me escapo del sistema»**, sobre una velocidad de apagado
de casi 11 km/s.

## Lo verificado contra las fuentes en esta fase

| Afirmación | Fuente, medida |
|---|---|
| Ley de Newton, $G$ | S&Z §13.1, ec. 13.1, pág. 399 |
| Peso, $g = G m_T \/ R_T^2$, peso a altura $r$ | S&Z ecs. 13.3, 13.4 y 13.5, pág. 403 |
| Teorema de la cáscara | S&Z §13.6, pág. 413–415 (citado) |
| $W_"grav"$, $F_r$, $U = -G m_T m \/ r$ | S&Z ecs. 13.6 a 13.9, pág. 405 |
| Velocidad de escape | S&Z ejemplo 13.5, pág. 406 |
| $v_"circ"$, $T$, $E = -mu m \/ 2r$, $v_"esc" = sqrt(2) v_"circ"$ | S&Z ecs. 13.10 a 13.13, pág. 407–409 |
| Velocidad areolar y 2.ª de Kepler | S&Z ecs. 13.14 a 13.16, pág. 410–411 |
| $bold(H)_O = bold(r) times m bold(v)$, $H_O = r m v sin phi$ | Beer §12.7, ecs. 12.12 y 12.13, pág. 721–722 |
| $H_O = m r^2 dot(theta)$, $sum bold(M)_O = dot(bold(H))_O$ | Beer ecs. 12.17 a 12.19, pág. 723 |
| Fuerza central, $bold(H)_O$ constante, movimiento plano | Beer §12.9, ecs. 12.23 y 12.24, pág. 724 |
| $r m v sin phi$ constante, $r^2 dot(theta) = h$, velocidad areolar | Beer ecs. 12.25 a 12.27, pág. 725 |
| Movimiento relativo, masa reducida, problema equivalente | apunte de clase 23/9 (escaneo manuscrito), pág. 1 y 2 |
| **Dos erratas de signo en el apunte de clase 23/9** | pág. 1, **confirmadas** ampliando el escaneo |
| Ecuaciones de movimiento en polares con fuerza central | Beer ecs. 12.31 y 12.32, pág. 736 |
| Cambio de variable $u = 1\/r$ y ecuación de Binet | Beer ecs. 12.35 a 12.37, pág. 736 |
| $u'' + u = mu\/h^2$, y su solución cónica | Beer ecs. 12.38 y 12.39, pág. 737 |
| Excentricidad y forma $r = p\/(1 + e cos nu)$ | Beer ecs. 12.40 y 12.39', pág. 737 |
| Clasificación por $e$ (hipérbola, parábola, elipse) | Beer §12.12, pág. 738 |
| $a = (r_p + r_a)\/2$, $b = sqrt(r_p r_a)$ | Beer ecs. 12.46 y 12.47, pág. 740 |
| $1\/r_p + 1\/r_a = 2 mu\/h^2$ | Beer, problema 12.102, citada en pág. 744 |
| Potencial eficaz, y su gráfico con los cuatro niveles | apunte de clase, `potencial eficaz.pdf` y `_2.pdf` |
| **Errata de signo delante de $U(r)$** | pág. 3 del escaneo del 23/9, **confirmada** a 300 dpi |
| **Errata $alpha = G M$ donde va $G M m$** | hoja `potencial eficaz.pdf`, **confirmada** |
| Los 40 enunciados de la guía | transcriptos en `fuentes/GUIA-ENUNCIADOS.md` |
| $tau = 2 pi a b \/ h$ (tercera ley de Kepler) | Beer ec. 12.45, pág. 739 |
| $a = (r_p+r_a)\/2$, $b = sqrt(r_p r_a)$, reusadas con período | Beer ecs. 12.46 y 12.47, pág. 740 (ya citadas en el módulo 9) |
| $mu_L = 0,01230 mu_T$ (masa de la Luna, Problema 8) | dato de la guía, coherente con el módulo 8 |
| El satélite del Problema 4 es el mismo del Ej. 4 (módulos 7 y 9) | verificado por los tres caminos (h, ecuación de la órbita, vis-viva) dando el mismo número |
| Ecuaciones de movimiento en polares, $u=1\/r$, Binet — reusadas para la transferencia de Hohmann | Beer ecs. 12.31 a 12.39, pág. 736–737 (ya citadas en el módulo 9) |
| El Road Map, fig. B.1 de Curtis, apéndice B | escaneo en `Downloads\Road Map.pdf`, renderizado a 250–400 dpi y leído entero, con la anotación manuscrita $mu=G(m_1+m_2)$ |
| Datos orbitales de Marte (apéndice F): $r=2,279 times 10^8$ km, $tau=686,98$ días | S&Z apéndice F |
| **Fase 4 — todo lo de abajo se leyó en el Beer en esta sesión** | offset medido: pág. impresa = pág. del PDF + 575 |
| Teorema de Euler; eje instantáneo; $bold(v)$ y $bold(a)$ de un punto | Beer §15.12, ecs. 15.37 a 15.39, pág. 988–989 |
| Cono espacial y cono corporal | Beer §15.12, fig. 15.33, pág. 989 |
| Las velocidades angulares se suman como vectores | Beer ec. 15.40, pág. 990–991 |
| Derivada de un vector en un sistema rotante | Beer §15.10, ec. 15.31, pág. 975–976 |
| Movimiento general de dos puntos del cuerpo | Beer ecs. 15.43 y 15.44, pág. 991 |
| Coriolis en tres dimensiones, y cuándo se anula | Beer ecs. 15.45 y 15.47, pág. 1002–1003 |
| Sistema de referencia en movimiento general | Beer ecs. 15.52 y 15.54, pág. 1004 |
| El sistema puede girar *menos* que el cuerpo ($bold(Omega) != bold(omega)$) | Beer §18.5, pág. 1170 |
| Mapa completo del capítulo 18 (ecuación a ecuación, con página impresa) | escrito en `HANDOFF.md`; leído por capa de texto |
| Las figuras en imagen de los Problemas 2, 3, 4, 7 y 9 de la guía | renderizadas de las pág. 15–18 del PDF de la guía, y miradas |
| **El enunciado del Problema 2 contradice a su figura** | el enunciado dice «eje vertical» y la figura muestra el eje del disco horizontal; se tomó la figura |
| $mu_"Sol" = 1,327 times 10^11$ km³/s² | S&Z apéndice F |
| **Fase 5 — lo de abajo se leyó en el Curtis en esta sesión** | offset medido: pág. impresa = pág. del PDF − 8 |
| Índice completo del Curtis (378 entradas), para ubicar qué cubre el cap. 2 y dónde vive lo parcheado | leído del *outline* del PDF, no de la imagen del índice |
| Parábola: $r$, $v = \sqrt{2\mu/r}$, trayectoria de escape | Curtis §2.8, ecs. 2.89 a 2.91, pág. 90 |
| Hipérbola: $\nu_\infty$, $\beta$, $\delta$, $a$, $r_p$, $r_a$, $b$, $\Delta$ | Curtis §2.9, ecs. 2.96 a 2.107, pág. 93–96 |
| Energía hiperbólica: $\varepsilon = +\mu/2a$, $v_\infty$, $v^2 = v_\text{esc}^2 + v_\infty^2$, $C_3$ | Curtis §2.9, ecs. 2.110 a 2.115, pág. 97–98 |
| La convención $a < 0$ y la vis-viva única para las tres cónicas | Curtis §2.9, pág. 99 (el comentario que sigue a la caja de herramientas) |
| Caja de herramientas: $h$, $r$, $v_r$, $\tan\gamma$, y las de cada cónica | Curtis, pág. 99 |
| Ejemplo 2.10 rehecho número por número (los ocho apartados) | Curtis, pág. 100–101; coinciden todos dentro del redondeo |
| El enlace Hohmann ↔ hipérbola de escape ($v_\infty = 2,94$ km/s, $\Delta v = 3,59$ km/s desde 300 km) | calculado en esta sesión con los datos del apéndice F que el módulo 11 ya usaba |
| **Fase 5, sesión 2 — lo de abajo es del capítulo 8 de Curtis**, mismo offset (impresa = PDF − 8) | leído por capa de texto |
| Esfera de influencia: los dos puntos de vista, las dos razones de perturbación y $r_\text{SOI} = R(m_p/m_s)^{2/5}$ | Curtis §8.4, ecs. 8.18 a 8.34, pág. 390–394 |
| Radio de la esfera terrestre, 925.000 km = 145 $R_T$ | Curtis, ejemplo 8.3, pág. 394 |
| Método de las cónicas parcheadas, y por qué no sirve para la Luna | Curtis §8.5, pág. 394–395 |
| Partida planetaria: $e = 1 + r_p v_\infty^2/\mu$, $h$, $v_p$, $\Delta v$, $\beta$, el círculo de perigeos $r_p\sin\beta$ | Curtis §8.6, ecs. 8.35 a 8.43, pág. 395–397 |
| Ejemplo 8.4 rehecho entero ($v_\infty=2,943$; $\Delta v=3,590$; $\beta=29,2°$; $\Delta m/m=0,705$) | Curtis, pág. 399–401 |
| **Errata en Curtis, ejemplo 8.4(b)**: el denominador dice 368.600 donde va $\mu_T=398.600$ | el resultado impreso, 29,16°, sale con 398.600; con 368.600 daría otro número |
| **Errata en Curtis, ejemplo 8.3**: la fracción dice $1,989\times10^{24}$ donde va $10^{30}$ | el resultado impreso, 925.000 km, sale con $10^{30}$ |
| La tabla de siete esferas de influencia (Mercurio a Saturno, más la Luna) | **calculada en esta sesión** con la fórmula y los $\mu$ del apéndice F; los siete valores coinciden con la tabla A.2 de Curtis |
| El error del parcheo: $v=3,086$ km/s y $
u=149,3°$ en la frontera | **calculado en esta sesión** con la vis-viva y la ecuación de la órbita del apunte |
| El tiempo adentro de la esfera, 3,2 días de 259 | **calculado en esta sesión** con la ecuación de Kepler hiperbólica (que el apunte NO desarrolla: el número se cita, no se deduce) |
| **Fase 5, sesión 4 — lo de abajo es Curtis §2.12**, mismo offset (impresa = PDF − 8); la sección arranca en la pág. impresa 116 (PDF 124) | leído por capa de texto, y las páginas del ejemplo 2.17 miradas a 300 dpi |
| Marco co-rotante, $\Omega=\sqrt{\mu/r_{12}^3}$, $\pi_1$, $\pi_2$, y las tres ecuaciones de movimiento | Curtis §2.12, ecs. 2.173 a 2.192, pág. 116–120 |
| $z=0$ para los cinco puntos; $r_1=r_2=r_{12}$ para los triangulares; la quíntica $f(\pi_2,\xi)=0$ de los colineales | Curtis §2.12.1, ecs. 2.193 a 2.204, pág. 120–121 |
| Método de bisección (algoritmo 2.4) | Curtis, pág. 122–123 |
| Estabilidad: colineales inestables; $L_4$, $L_5$ estables si $m_1/m_2+m_2/m_1\ge 25$ | Curtis, pág. 126, citando a Battin (1987) |
| Constante de Jacobi y curvas de velocidad cero | Curtis §2.12.2, ecs. 2.207 a 2.216, pág. 126–128 |
| $\xi_1=0{,}83692$, $\xi_2=1{,}15568$, $\xi_3=-1{,}00506$ | **recalculadas en esta sesión** por bisección propia; coinciden con las del ejemplo 2.16 |
| $C_1=-1{,}6735$, $C_2=-1{,}6650$, $C_3=-1{,}5810$, $C_{4,5}=-1{,}5683$ | **recalculadas en esta sesión**; coinciden con las cuatro que Curtis imprime en su fig. 2.37 |
| Las seis velocidades de apagado del ejemplo 2.17 (10,8455 a 10,8676 km/s) | **recalculadas en esta sesión**; difieren de las impresas en menos de 0,3 m/s (redondeo de $\pi_2$) |
| $r_\text{Hill}=r_{12}(m_2/3m_1)^{1/3}$, y la razón $r_\text{Hill}/r_\text{SOI}=0{,}693\,(m_2/m_1)^{-1/15}$ | **deducidas y calculadas en esta sesión**; Curtis no las trae. Verificadas contra las raíces exactas: Hill queda entre $L_1$ y $L_2$ en los dos sistemas |
| $L_1$ y $L_2$ del par Sol–Tierra a 1.491.577 y 1.501.558 km de la Tierra | **calculados en esta sesión** con la misma quíntica; coherentes con el «about 1.5 million km» de Curtis, pág. 126 |
| **Cuarta errata de Curtis, ejemplo 2.17**: $x_1=-\pi_1 r_{12}=-0{,}9878\cdot384.400=-4670{,}6$ km | **confirmada mirando la página a 300 dpi**: el producto impreso da 379.700; lo correcto es $-\pi_2 r_{12}$, que es lo que dice su propia ec. (2.177a) |
| **Quinta errata, mismo ejemplo**: $m_1=5{,}947\times10^{24}$ donde va $5{,}974\times10^{24}$ | la división que el propio libro imprime dos símbolos después da 0,9878, que sale con 5,974 |

## Lo que NO está verificado todavía

Nada de los módulos 1 a 12 quedó sin fuente. Para los módulos 13 a 15 el
material está **leído y mapeado** —la tabla del capítulo 18 está en el
`HANDOFF.md`, con página impresa por ecuación— pero todavía no está escrito.

Dos cosas quedan medidas a medias y hay que cerrarlas cuando el módulo las
use, no antes:

- **Las coordenadas exactas de los cohetes A y B del Problema 7** (la cápsula
  espacial). La figura da el tronco de cono con sus tres medidas, pero las
  posiciones de A y B hay que volver a medirlas sobre la imagen: de ellas
  depende el brazo de palanca y con él todo el resultado.
- **Los ejes principales de inercia no están deducidos en el libro que hay.**
  El temario manda «Beer vol. 1, §§9.16 y 9.17», que es la *Estática*, y el
  PDF disponible es sólo la *Dinámica*. El §18.2 (pág. 1153) afirma que
  siempre existen pero no lo demuestra. Para el módulo 13 alcanza, porque la
  guía da todos los datos por radios de giro.

## Lo que sigue

**La fase 5 está abierta y el orden de las sesiones está decidido.** Una
sesión por módulo, con checkpoint al cerrar cada una — la misma decisión
operativa de la fase 4, y por la misma razón: un módulo entra en una sesión,
cuatro no.

| Sesión | Módulo | Qué cierra la sesión |
|---|---|---|
| 1 · **hecha** (2026-09-07) | M16 — la hipérbola | escrito, compilado y mirado; el enlace numérico con Hohmann adentro |
| 2 · **hecha** (2026-09-07) | M17 — esfera de influencia y órbitas parcheadas | la deducción de $R_\text{SOI} = r\,(m/M)^{2/5}$, el método de las cónicas parcheadas, la partida planetaria completa (Curtis §8.4–8.6), y el ejemplo Tierra→Marte de punta a punta usando el $v_\infty$ del módulo 16 |
| 3 · **hecha** (2026-09-08) | M18 — marco perifocal y coeficientes de Lagrange | $\hat p$, $\hat q$, $\hat w$; el vector de estado y los seis elementos; $f$ y $g$ (Curtis §2.10–2.11) y los parámetros orbitales del Bate (pág. 53–74) |
| 4 · **hecha** (2026-09-11) | M19 — tres cuerpos restringido y puntos de Lagrange | los cinco puntos, la constante de Jacobi (Curtis §2.12), y la comparación medida entre la esfera de Hill y la esfera de influencia del M17 |
| 5 · **hecha** (2026-09-13) | cierre de fase | referencias cruzadas de los 19 módulos validadas (7 filas corregidas contra la tabla vieja, que estaba incompleta); blanco de la pág. 30 revisado y declarado aceptable |
| 6 · **hecha** (2026-09-13) | fase 6 (roadmap, fundamentos, Taller) | los tres pedidos de Fran cerrados sin tocar el apunte: roadmap sin huecos nuevos, Galileo ya deducido, Taller de Física mudado a `taller-de-fisica/` |

**Por qué el M17 va segundo y no cuarto.** Es lo que Fran pidió
explícitamente, y su única precondición es el M16, que ya está. Los dos
módulos de herramientas (M18 y M19) no le hacen falta para nada.

**Lo que queda pendiente para este apunte, si alguna vez se retoma.** Sólo
la decisión de si lleva anexos (fase 7, nunca definida). Las referencias
cruzadas se cerraron en la sesión 5, y los tres pedidos de la fase 6
(roadmap, fundamentos, Taller) se cerraron en la sesión 6 sin generar deuda:
el roadmap y Galileo ya estaban cubiertos, y el Taller de Física vive ahora
en su propio proyecto. Detalle en `HANDOFF.md`, sección «Fase 6 — CERRADA».

**Checkpoint por módulo, no por fase.** `ESTADO_ACTUAL` + `HANDOFF` + commit
+ push al cerrar *cada* módulo.
