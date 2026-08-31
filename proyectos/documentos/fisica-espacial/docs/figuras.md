# Las figuras — catálogo y reglas

Toda figura del apunte se **dibuja en el fuente**, con CeTZ. Nada de PNG
pegados: una imagen importada no se puede corregir, no se adapta al ancho de
la caja que la contiene, y cuando el rótulo queda mal hay que volver a la
herramienta con la que se hizo — que en seis meses ya no está instalada.

## Cómo se agrega una figura

1. Se escribe la función en `apunte/biblioteca/figuras.typ`, nombrada
   `fig-<tema>`, usando el vocabulario de `estilo.typ` (`flecha`, `angulo`,
   `masa`, `cuerpo-central`, `elipse-orbital`, `rotulo`…).
2. Se la agrega al `catalogo` del final del archivo.
3. Se compila **sólo la galería** y se la mira:

   ```
   compilar.bat galeria
   ```

4. Recién entonces se la llama desde el módulo con `#fig([epígrafe], fig-…)`.

El paso 3 no es opcional. Que compile no dice nada sobre si un rótulo cayó
encima de otro — y eso pasó en las cinco primeras figuras, todas a la vez.

## Las reglas, cada una pagada mirando un render

**1. El nombre de un vector corto va en la punta, no en el medio.** El 55% que
`flecha` usa por defecto sirve para un vector largo. En un versor de largo 1 el
nombre cae encima del vector vecino: en la primera galería, `r̂` y `θ̂` salieron
uno sobre el otro. Para versores va `pos: 100%` o, mejor, un `rotulo` suelto
corrido hacia afuera.

**2. Los ángulos se pasan como números, no como `angle`.** `angulo(centro, 25,
60)` y no `angulo(centro, 25deg, 60deg)`. La conversión a `deg` la hace el
helper, porque el mismo ángulo se usa además para calcular posiciones con
`calc.cos`, y mezclar las dos formas obliga a escribir el número dos veces de
dos maneras. CeTZ tira `cannot compare angle and integer` si se le pasa un
entero crudo a `arc` — ese error ya se pagó.

**3. Texto largo, fuera de los ejes.** Dentro de un `plot`, las anotaciones
están en coordenadas de datos —donde el mismo número mide distinto en cada
gráfico— y cetz-plot además recorta contra el área del gráfico, así que dos
rótulos largos en esquinas opuestas terminan encimados en el centro. Para eso
está `rotulo-marco`, que dibuja en coordenadas de lienzo. Adentro de los ejes,
sólo marcas cortas.

**4. Un color, un significado.** Los colores de las figuras están en
`paleta.typ` y son cinco: `c-dato` para el vector protagonista, `c-aux` para el
secundario, `c-trazo` para la construcción principal, `c-guia` para las líneas
auxiliares punteadas, `c-orbe` para el cuerpo central. Una figura que inventa un
color rompe la lectura de las otras.

**5. El lienzo se escala, el texto no.** `esquema` toma `escala:` (por defecto `1cm` por unidad). Una figura pensada en
un rango chico de coordenadas sale **diminuta** en la página aunque sus
proporciones sean correctas, porque el texto de los rótulos no se achica con
ella: queda un dibujo de 5 cm con letras de 8,5 pt encima. Se corrige subiendo
`escala` (el pozo gravitatorio va en `1,45cm` y el cañón en `1,35cm`), no
agrandando las coordenadas — que obligaría a recalcular todos los rótulos.

Y el corolario que se pagó en la misma galería: **un rótulo largo dentro del
lienzo estira el lienzo**, y como el lienzo se escala para entrar en el ancho
de la página, un párrafo al costado achica el dibujo entero. El texto que
explica la figura va en el **epígrafe**, no adentro.

**6. Un cartel de varios renglones va donde no hay ninguna curva, y ese lugar
se calcula.** En `fig-conicas` los cuatro rótulos —uno por cónica— se probaron
primero al lado de cada curva y se pisaron todos, porque las cuatro se cruzan
en los mismos dos puntos. El lugar bueno salió de una cuenta de treinta
segundos: el apogeo de la elipse, que es lo que más lejos llega hacia la
izquierda, cae en $x=-3{,}25$, así que para $x<-3{,}4$ el lienzo está vacío por
construcción. *Antes de mover un rótulo a ojo por tercera vez, conviene
calcular dónde no hay nada.*

**7. Los rótulos de una figura densa se reparten por mitades, no uno por uno.**
`fig-elipse-geometria` tiene seis magnitudes sobre el mismo eje y en el primer
intento salieron encimadas de a tres. La regla que la ordenó no fue mover
rótulos: fue partir el dibujo en dos: **arriba de la línea de ábsides, lo que
se mide desde el foco** ($p$, $r$, $\nu$); **abajo, lo que se mide desde el
centro** ($a$, $b$) más las dos distancias de ábside. Y cada cota de abajo
lleva sus dos líneas de referencia verticales: sin ellas, el extremo que cae
sobre el perigeo queda *fuera* de la elipse —el perigeo está sobre la curva
sólo en $y=0$— y se lee como una marca suelta.

## Catálogo

| Figura | Módulo | Qué muestra |
|---|---|---|
| `fig-proyeccion` | 1 | la sombra de $B$ sobre $A$ — por qué el escalar proyecta |
| `fig-producto-vectorial` | 1 | el paralelogramo cuya área es $\|A \times B\|$, y el resultado saliendo de la hoja |
| `fig-versores-polares` | 1 | $\hat r$ y $\hat\theta$ en un punto de una trayectoria cualquiera |
| `fig-derivada-versor` | 1 | el triangulito de $\Delta\hat r$: de dónde sale $\dot{\hat r} = \dot\theta\,\hat\theta$ |
| `fig-cohete-radar` | 1 | el Ej. 10 de la guía: el cohete visto desde el radar |
| `fig-impulso-area` | 2 | el impulso como area bajo F(t), y el rectangulo de F_med |
| `fig-choque-oblicuo` | 2 | el Ej. 2 de la guia: el choque, y el triangulo de impulsos que lo resuelve |
| `fig-cm-dos-cuerpos` | 3 | el CM sobre la recta que une los cuerpos, con d1/d2 |
| `fig-choque-cm` | 3 | el mismo choque en el laboratorio y en el sistema centro de masa |
| `fig-cohete-elemento` | 4 | el intervalo del cohete: antes y despues, con v_r |
| `fig-etapas` | 4 | una etapa contra dos, con los mismos kilos |
| `fig-trabajo-central` | 5 | por que una fuerza central es conservativa: solo dr trabaja |
| `fig-diagrama-energia` | 5 | como se lee un diagrama de energia: E, K, retornos, equilibrios |
| `fig-canon-newton` | 6 | el canon de Newton: la misma caida con distinta v horizontal |
| `fig-pozo-gravitatorio` | 6 | U = -mu m / r con tres E: el signo de E decide si el cuerpo vuelve |
| `fig-momento-angular` | 7 | el brazo de palanca: mismo v, dos origenes, dos L distintos |
| `fig-velocidad-areolar` | 7 | la 2.a de Kepler: dos sectores de igual area, uno flaco y uno ancho |
| `fig-satelite-guia` | 7 | el Ej. 4 de la guia: la orbita con A, P y las dos posiciones con gamma |
| `fig-dos-cuerpos` | 8 | las dos elipses semejantes en torno al CM, y el problema equivalente |
| `fig-potencial-eficaz` | 9 | las dos ramas, el pozo, y los cuatro niveles de E leídos como cuatro cónicas |
| `fig-conicas` | 9 | las cuatro cónicas con el mismo p y el mismo foco: sólo cambia e |
| `fig-elipse-geometria` | 9 | la elipse y sus seis números: a, b, c = ae, p, r_p, r_a, más r y ν |
| `fig-hohmann` | 11 | la transferencia Tierra–Marte: la media elipse, los dos Δv y el ángulo de fase en el lanzamiento |
| `fig-rendezvous-phasing` | 11 | el rendez-vous del Problema 10: la órbita de fasaje que cierra un cuarto de vuelta en una revolución |
| `fig-roadmap-curtis` | 11 | el mapa de Curtis (apéndice B) redibujado: los once resultados de la Parte III y de dónde sale cada uno |

## Lo que `estilo.typ` todavía no tiene

Se agrega cuando el módulo que lo necesite lo pida, no antes:

- **cono de precesión** (módulos 14 y 15) — dos conos tangentes, espacial y
  corporal. Es la figura más difícil del apunte y probablemente necesite
  proyección 3-D de CeTZ, no el plano.
~~- **transferencia de Hohmann** (módulo 11) — falta el arco parcial~~ — el
  helper existe desde el módulo 6: **`arco-conica`**, que dibuja un tramo de
  cualquier cónica desde `(p, e)`. Hace tres cosas que `elipse-orbital` no
  puede: trayectorias abiertas (`e >= 1`, donde no hay `a` positivo), arcos
  parciales —la transferencia de Hohmann es media elipse— y curvas recortadas
  contra la superficie del cuerpo central, con `r-min`.
~~- **choque en el sistema centro de masa** (módulo 3)~~ — hecho en la fase 2
  (`fig-choque-cm`), sin helper nuevo: alcanzó con `flecha` y `paneles`.
