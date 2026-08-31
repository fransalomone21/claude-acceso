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

## Lo que `estilo.typ` todavía no tiene

Se agrega cuando el módulo que lo necesite lo pida, no antes:

- **cono de precesión** (módulos 14 y 15) — dos conos tangentes, espacial y
  corporal. Es la figura más difícil del apunte y probablemente necesite
  proyección 3-D de CeTZ, no el plano.
- **transferencia de Hohmann** (módulo 11) — dos círculos y la elipse tangente
  a los dos. `elipse-orbital` ya sirve; falta el arco de transferencia parcial.
~~- **choque en el sistema centro de masa** (módulo 3)~~ — hecho en la fase 2
  (`fig-choque-cm`), sin helper nuevo: alcanzó con `flecha` y `paneles`.
