# Índice de temas del apunte — qué está y dónde

**Este archivo lo genera `indice-temas.py`. No se edita a mano:**
se deriva de `apunte/apunte.typ` y de los `.typ` de cada módulo, y se
regenera con `python indice-temas.py`. Si quedó viejo, `python
indice-temas.py --check` lo dice en rojo.

Para qué sirve: contestar **«¿el apunte ya cubre esto?»** sin abrir el
PDF de 163 páginas ni leer veinte módulos. Se busca acá el tema; si
está, la fila dice el módulo y la sección exacta que hay que tocar.
Si no está, hay que escribirlo — y el módulo donde entra también sale
de acá, por vecindad.

Las etiquetas `<...>` son los nombres de las ecuaciones numeradas: es
la forma más rápida de saber si una FÓRMULA ya está deducida en algún
lado. Se referencian en la prosa como `@etiqueta`.


## Parte 1 — Herramientas

### 1. Vectores y cinemática en coordenadas polares  ·  `vectores`

<small>`apunte/modulos/m01-vectores.typ`</small>

- **El vector, sus componentes y sus cosenos directores**
  - *(de donde sale)* Por qué los cosenos directores son las componentes del versor
- **El producto escalar: proyectar <vec-escalar>**
  - *(de donde sale)* La proyección de B sobre A
  - *(ejemplo)* Cosenos directores y proyección
- **El producto vectorial: construir una perpendicular**
  - *(de donde sale)* Por qué el módulo es el área
  - *(ejemplo)* Versor perpendicular a dos vectores dados
- **Los dobles productos, y la trampa <vec-dobles>**
- **La derivada de un vector: dos partes, no una <vec-derivada>**
  - *(de donde sale)* La derivada de un versor es perpendicular a él
  - *(de donde sale)* cuánto vale la derivada del versor radial
- **Velocidad y aceleración en coordenadas polares <vec-polares>**
  - *(de donde sale)* Velocidad y aceleración en polares, de punta a punta
  - *(ejemplo)* El cohete visto por el radar
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<vec-escalar>`, `<vec-dobles>`, `<vec-derivada>`, `<vec-polares>`

### 2. Marcos de referencia: cuándo vale F = m a, y qué pasa cuando no  ·  `marcos`

<small>`apunte/modulos/m02-marcos.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **Las tres leyes, y cuál de ellas no es una ley**
- **La transformación de Galileo**
  - *(de donde sale)* la transformación de Galileo, y por qué F = m a no se entera
- **Qué sobrevive a la transformación, y qué no**
- **Cuando el marco acelera en línea recta**
  - *(de donde sale)* de dónde sale la fuerza de inercia
- **Cuando el marco gira**
  - *(de donde sale)* las dos correcciones de un marco que gira, desde la aceleración en polares
- **Lo que se usa después**

  Ecuaciones: `<marcos-galileo>`, `<marcos-inercia>`, `<marcos-rotante>`, `<marcos-rotante-f>`

## Parte 2 — Los teoremas de conservación

### 3. Cantidad de movimiento, impulso y choques  ·  `cantidad-movimiento`

<small>`apunte/modulos/m03-cantidad-movimiento.typ`</small>

- **De $bold(F) = m bold(a)$ a $bold(F) = d bold(p) / d t$**
  - *(de donde sale)* por qué esta forma es más general que F = ma
- **El impulso: integrar la fuerza en el tiempo <cant-impulso>**
  - *(de donde sale)* el teorema del impulso, en dos renglones
- **Cuándo se conserva: fuerzas internas y externas**
  - *(de donde sale)* la conservación de P sale de la tercera ley
- **Choques: qué se conserva y qué no**
  - *(de donde sale)* el choque elástico frontal y la velocidad relativa
  - *(ejemplo)* La astronauta y la herramienta
  - *(ejemplo)* Choque oblicuo de dos asteroides
  - *(ejemplo)* Separación de dos etapas en inercia
  - *(ejemplo)* El satélite que se suelta del transbordador, con la fuerza media
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<cant-segunda-ley>`, `<cant-impulso>`

### 4. Centro de masa y sistemas de partículas  ·  `centro-de-masa`

<small>`apunte/modulos/m04-centro-de-masa.typ`</small>

- **El centro de masa**
  - *(de donde sale)* por qué el CM está sobre la recta que une los dos cuerpos
- **El teorema del centro de masa**
  - *(de donde sale)* el CM se mueve como si toda la masa estuviera ahí
- **El sistema centro de masa <cm-sistema-cm>**
- **La energía cinética se parte en dos**
  - *(de donde sale)* el teorema de König
  - *(ejemplo)* El mismo lanzamiento, visto desde el centro de masa
  - *(ejemplo)* Los asteroides, ahora desde el centro de masa
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<cm-def>`, `<cm-p>`, `<cm-teorema>`, `<cm-sistema-cm>`

### 5. Propulsión: la ecuación del cohete  ·  `cohete`

<small>`apunte/modulos/m05-cohete.typ`</small>

- **Por qué acá no sirve $bold(F) = m bold(a)$**
- **La deducción del empuje**
  - *(de donde sale)* el empuje, desde la conservación de P
  - **Impulso específico**
- **Con gravedad: la ecuación de movimiento**
- **La ecuación de Tsiolkovsky**
  - *(de donde sale)* integrar la ecuación del cohete
- **Etapas**
  - *(ejemplo)* Aceleración al despegar y al apagarse
  - *(ejemplo)* Una etapa contra dos, con los mismos kilos
  - *(ejemplo)* El Saturno V y el transbordador: el empuje se reparte entre varios motores
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<coh-empuje>`, `<coh-movimiento>`, `<coh-vertical>`, `<coh-tsiolkovsky>`

### 6. Trabajo y energía  ·  `trabajo-energia`

<small>`apunte/modulos/m06-trabajo-energia.typ`</small>

- **El trabajo de una fuerza**
- **El teorema trabajo–energía**
  - *(de donde sale)* de la segunda ley al teorema, en tres renglones
- **Fuerzas conservativas y energía potencial**
  - *(de donde sale)* toda fuerza central que dependa sólo de r es conservativa
- **De la energía potencial a la fuerza, y los diagramas**
  - *(ejemplo)* De dónde sale la energía del calamar
  - *(ejemplo)* Leer un diagrama de energía de punta a punta
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<ener-trabajo>`, `<ener-teorema>`, `<ener-gradiente>`

## Parte 3 — Gravitación y mecánica orbital

### 7. Gravitación de Newton, peso y energía potencial  ·  `gravitacion`

<small>`apunte/modulos/m07-gravitacion.typ`</small>

- **La ley de Newton de la gravitación**
- **Peso, y cómo se pesa un planeta**
  - *(de donde sale)* por qué g no depende de la masa del cuerpo, y de paso cómo se pesa la Tierra
- **La energía potencial gravitatoria**
  - *(de donde sale)* la energía potencial gravitatoria, y por qué el cero va en el infinito
- **El pozo de potencial, y la velocidad de escape**
- **La órbita circular: por qué no cae**
  - *(de donde sale)* la velocidad de una órbita circular
  - *(ejemplo)* Estimar la masa del Sol
  - *(ejemplo)* Cuánto cuesta subir un satélite a la órbita geosíncrona
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<grav-newton>`, `<grav-newton-vec>`, `<grav-g>`, `<grav-vesc>`, `<grav-vcirc>`, `<grav-raiz2>`

### 8. Momento angular y fuerzas centrales  ·  `momento-angular`

<small>`apunte/modulos/m08-momento-angular.typ`</small>

- **Qué es el momento angular, y respecto de qué punto**
- **La ecuación de movimiento del momento angular**
  - *(de donde sale)* por qué el torque es la derivada del momento angular
- **Fuerza central: las dos consecuencias**
- **La segunda ley de Kepler es esto mismo**
  - *(de donde sale)* la ley de las áreas, desde la conservación del momento angular
  - *(ejemplo)* Dos demostraciones de una línea
  - *(ejemplo)* El satélite de la figura: h en los cuatro puntos
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<angm-def>`, `<angm-modulo>`, `<angm-tau>`, `<angm-conserva>`, `<angm-h>`, `<angm-areas>`

### 9. El problema de dos cuerpos y la masa reducida  ·  `dos-cuerpos`

<small>`apunte/modulos/m09-dos-cuerpos.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **El planteo, sin suponer nada**
  - *(de donde sale)* la ecuación del movimiento relativo
- **El centro de masa, y las dos órbitas verdaderas**
  - *(de donde sale)* dónde está cada cuerpo, en función de la separación
- **La masa reducida y el problema equivalente**
  - *(de donde sale)* la masa reducida sale de sumar las dos energías cinéticas
- **Cuándo importa: un solo número**
  - *(ejemplo)* Qué masa se midió, en realidad, al estimar la del Sol
  - *(ejemplo)* El sistema Tierra–Luna: dónde está el centro y cuánto dura el mes
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<dosc-relativa>`, `<dosc-cm>`, `<dosc-posiciones>`, `<dosc-reducida>`

### 10. El potencial eficaz y la ecuación de la órbita  ·  `orbita-conicas`

<small>`apunte/modulos/m10-orbita-conicas.typ`</small>

- **El potencial eficaz: dos variables que se vuelven una**
  - *(de donde sale)* el potencial eficaz
- **Lo que el diagrama dice sin resolver nada**
  - *(guia de la catedra)* el Problema 1, otra vez
- **La ecuación de la órbita**
  - *(de donde sale)* por qué se cambia t por theta, y r por 1/r
- **Las cónicas, y el puente entre la energía y la forma**
  - *(de donde sale)* la relación entre la excentricidad y la energía
- **La elipse y sus seis números**
  - *(ejemplo)* El satélite del Ej. 4, ahora con la ecuación de la órbita
  - *(ejemplo)* Frenar en Júpiter: de la parábola a la elipse
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<orb-r0>`, `<orb-binet>`, `<orb-orbita>`, `<orb-visviva>`, `<orb-energia-especifica>`, `<orb-absides>`, `<orb-semiejes>`, `<orb-suma-inversos>`

### 11. Las leyes de Kepler  ·  `kepler`

<small>`apunte/modulos/m11-kepler.typ`</small>

- **Las tres leyes, ya deducidas**
- **La tercera ley: de dónde sale el período**
  - *(de donde sale)* el período, integrando el área
  - *(de donde sale)* el período, sólo en función del semieje mayor
- **Ejemplo: el satélite del módulo ‹orbita-conicas›, con período**
  - *(ejemplo)* El período del satélite, y la parte que faltaba del Problema 4
  - *(ejemplo)* La excentricidad de una órbita polar, a partir de su período
  - *(guia de la catedra)* qué ejercicios cubre este módulo
  - *(ejemplo)* El LEM del Apollo: subir a encontrarse, y bajar a estrellarse
  - *(de donde sale)* la nueva órbita, y por qué no vuelve a subir
- **Lo que se usa después**

  Ecuaciones: `<kep-tau-ab>`, `<kep-periodo>`

### 12. Maniobras: Hohmann y rendez-vous  ·  `maniobras`

<small>`apunte/modulos/m12-maniobras.typ`</small>

- **La transferencia de Hohmann**
  - *(de donde sale)* por qué la elipse tangente a las dos circulares es la más barata
  - *(ejemplo)* Hohmann a Marte: cuándo lanzar y cuánto tarda
- **Rendez-vous: encontrarse con algo en la misma órbita**
  - *(de donde sale)* cuánto tiene que durar la órbita de fasaje
  - *(ejemplo)* Encontrarse con un satélite un cuarto de vuelta adelante
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **El mapa completo**
- **Lo que se usa después**

  Ecuaciones: `<man-at>`, `<man-deltav>`, `<man-tv>`, `<man-fase>`, `<man-fasaje>`, `<man-fasaje-a>`

## Parte 4 — De la cónica al viaje real

### 13. La hipérbola: escapar, y llegar con velocidad de sobra  ·  `hiperbola`

<small>`apunte/modulos/m13-hiperbola.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **La parábola: el caso justo, y por qué no es una órbita**
- **La geometría de la hipérbola**
  - *(de donde sale)* el ángulo que se tuerce la velocidad al pasar
- **La energía: la velocidad que sobra, y $C_3$**
  - *(de donde sale)* la velocidad de sobra en el infinito
- **Las dos fórmulas que faltaban: $v_r$ y el ángulo $gamma$**
  - *(de donde sale)* la componente radial de la velocidad
  - *(de donde sale)* el ángulo de vuelo en función de la anomalía verdadera
  - *(guia de la catedra)* los ejercicios adicionales 1, 2, 4 y 5 de gravitación
  - *(ejemplo)* La órbita a partir de una sola medición de radar
  - *(ejemplo)* Una nave que se va: mostrar que es hipérbola y medirla entera
  - *(ejemplo)* El radio promedio del satélite de la guía, y el ángulo de vuelo ahí
- **Lo que esto ya permite: el enlace con Hohmann**
- **Lo que se usa después**

  Ecuaciones: `<hip-parabola>`, `<hip-vesc>`, `<hip-nuinf>`, `<hip-a>`, `<hip-rp>`, `<hip-delta>`, `<hip-energia>`, `<hip-vinf>`, `<hip-vr>`, `<hip-gamma>`

### 14. La esfera de influencia y las órbitas parcheadas  ·  `esfera-influencia`

<small>`apunte/modulos/m14-esfera-influencia.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **Por qué «quién tira más fuerte» es la pregunta equivocada**
- **La cuenta que sí sirve: quién perturba menos**
  - *(de donde sale)* la esfera de influencia, de comparar dos perturbaciones
- **Cuánto mide, y las dos comparaciones que hay que hacer**
- **El método de las cónicas parcheadas**
- **Cuánto cuesta la mentira**
- **El ejemplo completo: Tierra a Marte, con la licencia ya dada**
  - *(de donde sale)* la excentricidad y el encendido, a partir de la velocidad de sobra y del radio de estacionamiento
  - *(ejemplo)* Partida a Marte desde una órbita de estacionamiento de 300 km
- **Lo que se usa después**

  Ecuaciones: `<soi-ingenua>`, `<soi-suma>`, `<soi-vista1>`, `<soi-razon1>`, `<soi-vista2>`, `<soi-razon2>`, `<soi-soi>`, `<soi-soi-tierra>`, `<soi-pegado>`, `<soi-e>`, `<soi-vp>`, `<soi-dv>`

### 15. Marco perifocal, vector de estado y coeficientes de Lagrange  ·  `perifocal-lagrange`

<small>`apunte/modulos/m15-perifocal-lagrange.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **El marco perifocal**
  - *(de donde sale)* la velocidad en el marco perifocal
  - *(ejemplo)* del marco perifocal a los vectores, y de los vectores al marco
- **Los sistemas de referencia: respecto de qué se dan los seis números**
- **Los seis números de una órbita**
  - **Cómo se pasa del estado a los elementos**
- **Los coeficientes de Lagrange**
  - *(de donde sale)* los coeficientes de Lagrange
  - *(ejemplo)* propagar 120° de anomalía, y recién después preguntar en qué órbita estábamos
- **Lo que falta: el tiempo**
- **Lo que se usa después**

  Ecuaciones: `<perif-r>`, `<perif-r-orbita>`, `<perif-v>`, `<perif-tres>`, `<perif-elementos>`, `<perif-fg>`, `<perif-h-inicial>`, `<perif-coefs-xy>`, `<perif-wronskiano>`, `<perif-fg-dnu>`, `<perif-fgpunto-dnu>`, `<perif-r-dnu>`, `<perif-serie>`

### 16. El problema restringido de tres cuerpos y los puntos de Lagrange  ·  `tres-cuerpos`

<small>`apunte/modulos/m16-tres-cuerpos.typ`</small>

- **La idea completa, antes de la primera ecuación**
- **El marco que gira con los dos cuerpos**
  - *(de donde sale)* las tres ecuaciones de movimiento
- **Los cinco puntos de Lagrange**
  - *(de donde sale)* los dos puntos triangulares
  - *(ejemplo)* los cinco puntos de Lagrange del sistema Tierra–Luna
- **Dos fronteras para lo mismo: Hill contra la esfera de influencia**
  - *(de donde sale)* el radio de Hill, o por qué L1 está donde está
- **Cuáles sirven para estacionar**
- **La constante de Jacobi: el diagrama de energía, otra vez**
  - *(de donde sale)* la constante de Jacobi
  - *(ejemplo)* cuánta velocidad separa quedarse en casa de escaparse del sistema
- **Lo que se usa después**

  Ecuaciones: `<tres-omega>`, `<tres-pi>`, `<tres-r12>`, `<tres-mov-x>`, `<tres-mov-y>`, `<tres-mov-z>`, `<tres-equilatero>`, `<tres-l45>`, `<tres-colineales>`, `<tres-hill>`, `<tres-razon>`, `<tres-estable>`, `<tres-routh>`, `<tres-jacobi>`, `<tres-potj>`, `<tres-prohibido>`

## Parte 5 — Cuerpo rígido

### 17. Rotación alrededor de un eje fijo: el Sears, capítulos 9 y 10  ·  `rotacion`

<small>`apunte/modulos/m17-rotacion.typ`</small>

- **La velocidad angular: un número y un vector**
- **La energía de rotación: de ahí sale el momento de inercia**
  - *(de donde sale)* por qué la energía cinética de rotación es un medio de I omega al cuadrado
- **Steiner: cambiar de eje sin volver a integrar**
  - *(de donde sale)* por qué el término cruzado se anula
- **El torque: lo que hace girar**
- **$tau = I alpha$: la segunda ley de Newton, versión rotación**
  - *(de donde sale)* de dónde sale que el torque sea I por alfa
- **El momento angular de un cuerpo que gira: $L = I omega$**
- **Conservación del impulso angular**
  - *(ejemplo)* Cualquiera puede bailar ballet (S&Z Ejemplo 10.10)
- **El giróscopo que no se cae**
  - *(de donde sale)* la velocidad de precesión
  - *(ejemplo)* El giróscopo del Sears: cuánto gira la rueda (S&Z Ejemplo 10.13)
  - *(ejemplo)* El giróscopo de juguete de la guía (S&Z 10.51)
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<rot-omega>`, `<rot-v>`, `<rot-energia>`, `<rot-steiner>`, `<rot-torque>`, `<rot-tau-ialfa>`, `<rot-traslacion>`, `<rot-l-iw>`, `<rot-tau-dl>`, `<rot-conserva>`, `<fig-giroscopo>`, `<rot-precesion>`

### 18. Cinemática del cuerpo rígido y sistemas rotantes  ·  `cinematica-cr`

<small>`apunte/modulos/m18-cinematica-cr.typ`</small>

- **Con un punto fijo, todo movimiento es una rotación**
  - *(de donde sale)* por qué siempre hay un eje, aunque el cuerpo se mueva de cualquier manera
- **Las velocidades angulares se suman; las rotaciones finitas, no**
  - *(de donde sale)* por qué las velocidades angulares son vectores de verdad
  - *(ejemplo)* El disco en la horquilla: velocidad y aceleración angulares
- **El eje instantáneo se mueve: cono espacial y cono corporal**
- **La derivada de un vector visto desde un sistema que rota**
  - *(de donde sale)* cómo se relacionan las dos derivadas
  - *(ejemplo)* El volante en el gimbal: por qué hace falta una cupla
- **Dos puntos cualesquiera: el movimiento general**
- **Una partícula vista desde un sistema que rota: Coriolis en tres dimensiones**
  - *(guia de la catedra)* qué ejercicios cubre este módulo
- **Lo que se usa después**

  Ecuaciones: `<cin-v>`, `<cin-a>`, `<cin-suma>`, `<cin-derivada>`, `<cin-vgen>`, `<cin-agen>`, `<cin-coriolis-v>`, `<cin-coriolis-a>`

### 19. Momento de inercia y ejes principales  ·  `inercia`

<small>`apunte/modulos/m19-inercia.typ`</small>

- **$bold(H)_G$ por integrales: momentos y productos de inercia**
  - *(de donde sale)* de dónde salen los seis números que hacen falta
- **El tensor de inercia**
- **Por qué $bold(H)_G$ y $bold(omega)$ casi nunca son paralelos**
- **De $G$ a un punto cualquiera: $bold(H)_O$**
- **Energía cinética**
  - *(de donde sale)* por qué la energía cinética de rotación es media vez omega por H_G
  - *(guia de la catedra)* qué ejercicios cubre este módulo
  - *(ejemplo)* El satélite cúbico: velocidad angular tras un encendido
  - *(ejemplo)* El disco en la horquilla: el momento angular que no acompaña a omega
- **Lo que se usa después**

  Ecuaciones: `<iner-hg-integral>`, `<iner-tensor>`, `<iner-diagonal>`, `<iner-ho>`, `<iner-energia>`

### 20. Ecuaciones de Euler y el giróscopo  ·  `euler-giroscopo`

<small>`apunte/modulos/m20-euler-giroscopo.typ`</small>

- **La derivada de $bold(H)_G$: la @cin-derivada, por fin en uso**
  - *(de donde sale)* de dónde sale la relación general entre cupla y H
- **Las ecuaciones de Euler ($bold(Omega) = bold(omega)$, ejes clavados al cuerpo)**
  - *(guia de la catedra)* qué ejercicios cubre este módulo
  - *(ejemplo)* El disco en la horquilla: la cupla que sostiene el movimiento
  - *(ejemplo)* El volante en el gimbal: por qué 600 N·m dan sólo 20 rad/s²
- **Los ángulos de Euler: cómo describir la orientación de un giróscopo**
- **Precesión estable: el caso que sí se resuelve a mano**
  - *(de donde sale)* de dónde sale la cupla que sostiene una precesión constante
- **Lo que se usa después**

  Ecuaciones: `<euler-derivada-h>`, `<euler-euler-clasicas>`, `<euler-precesion-estable>`, `<euler-precesion-90>`

### 21. Peonza simétrica, precesión directa y retrógrada  ·  `peonza`

<small>`apunte/modulos/m21-peonza.typ`</small>

- **Un cuerpo simétrico sin cuplas: $bold(H)_G$ queda fijo**
  - *(de donde sale)* de dónde sale que la precesión es automática
- **El ángulo del eje instantáneo: $tan gamma = (I/I') tan theta$**
- **Precesión directa y precesión retrógrada**
  - *(de donde sale)* de dónde sale el criterio del signo
  - *(guia de la catedra)* qué ejercicios cubre este módulo
  - *(ejemplo)* El satélite achatado: el período de una precesión que nadie sostiene
  - *(ejemplo)* El cilindro de paredes delgadas: el umbral entre directa y retrógrada
- **Cierre de la Parte IV**

  Ecuaciones: `<peon-precesion-libre>`, `<peon-tan-gamma>`, `<fig-conos-directa>`

## Anexo A — la guía de la cátedra, ficha por ficha

- **A.1 — Vectores (Ej. 9 a 15)**
- **A.2 — Conservación de cantidad de movimiento (Ej. 1 a 9, más tres adicionales)**
- **A.3 — Conservación de impulso angular (Problemas 1 a 7)**
- **A.4 — Conservación de la energía y gravitación (Problemas 0 a 10, más cinco adicionales)**
- **A.5 — Cuerpo rígido (Problemas 1 a 9)**

Los enunciados completos están transcriptos en
`fuentes/GUIA-ENUNCIADOS.md`; las fichas del anexo son
enunciado + «resuelve:» + respuesta, sin desarrollo.
