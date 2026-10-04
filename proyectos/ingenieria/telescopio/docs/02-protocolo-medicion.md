# Protocolo de medición — fase 0

Lo que hay que medir, en este orden, con qué precisión y por qué. **Cada
número de acá manda sobre una decisión de diseño; los que no mandan nada no
están.**

Regla de oro: **se mide una vez y se anota con el método al lado.** Un número
sin método es una hipótesis con cara de dato.

---

## Configuración de referencia — se fija antes de medir nada

Todas las mediciones del conjunto se hacen con:

- **el tubo horizontal** (paralelo al piso) y **trabado** en la caja
  sujetadora, apretado como se aprieta para observar;
- **sin cámara ni soporte** (esos se suman después, por cálculo);
- el ocular **sacado** (se pesa aparte);
- la misma configuración de los tacos de PVC y el disco de vinilo.

> **Por qué el tubo horizontal y no en cualquier ángulo.** El centro de masa
> del conjunto **se mueve cuando el tubo gira en altura**. No hay un CoM, hay
> una curva de CoM en función del ángulo. Por eso no alcanza medir el conjunto
> armado: se mide el **tubo solo** y el **resto de la montura solo**, y con
> esos dos la curva se calcula para cualquier ángulo. Eso decide después a qué
> altura se balancea la plataforma, que es una decisión de la fase 1.

---

## P0 — ¿Llega a foco? (go/no-go, diez minutos, de día)

**Es lo primero porque si sale mal, cambia el proyecto entero** (riesgo R1 del
PDP). Falla clásica de los newtonianos: el sensor de la cámara queda más lejos
del espejo de lo que el focuser puede meterse, y no enfoca nunca.

1. De día, apuntar a algo lejos: una antena, un árbol a más de 300 m.
2. Poner la cámara en el focuser **sin ocular** (foco primario), con el
   adaptador que haya. **Si no hay adaptador T2/1,25", decilo: es un bloqueo,
   no una medición.**
3. Meter el focuser **todo hacia adentro** y enfocar sacándolo de a poco.

**Anotar las cuatro cosas:**

| # | Qué | Para qué |
|---|---|---|
| P0.1 | ¿enfoca? sí / no | decide foco primario vs afocal con celular |
| P0.2 | si enfoca: cuántos mm de recorrido **sobran hacia adentro** | margen; si es ~0 no hay lugar para un corrector ni un filtro |
| P0.3 | si enfoca: cuántos mm **sobran hacia afuera** | margen térmico |
| P0.4 | si **no** enfoca: cuántos mm faltaban (a ojo, cuánto más habría que meter) | decide si se arregla con un focuser bajo o no se arregla |

**Repetir con el celular en modo afocal** (celular apoyado contra el ocular de
25 mm, a pulso, nada más): ¿se ve la imagen nítida en la pantalla? Eso es el
plan B y hay que saber si existe.

> Dato de referencia: las cámaras **mirrorless** (la Sony) llegan a foco en
> newtonianos donde una DSLR no, porque no tienen la caja del espejo. Si no
> enfoca ni la mirrorless, el plan es afocal.

---

## P1 — El tubo solo

Sacar el tubo de la caja sujetadora.

| # | Qué | Cómo | Tolerancia |
|---|---|---|---|
| P1.1 | masa del tubo solo | balanza, con el tubo apoyado entero sobre ella | ±0,2 kg |
| P1.2 | **punto de equilibrio** sobre su eje | apoyar el tubo cruzado sobre un caño redondo y correrlo hasta que se queda quieto; medir desde el **extremo del espejo primario** hasta el caño | ±3 mm |
| P1.3 | largo total y diámetro exterior | cinta / calibre | ±2 mm |
| P1.4 | distancia del extremo del primario al **eje del focuser** | cinta | ±2 mm |
| P1.5 | distancia del extremo del primario al **buscador** y masa del buscador si sale | cinta / balanza | ±5 mm |
| P1.6 | **diámetro del eje menor del secundario** | mirando por el focuser sin ocular, con una regla apoyada | ±2 mm |

P1.6 decide si el APS-C de la Sony viñetea en las esquinas. Si da 50 mm, el
campo plenamente iluminado es chico y eso va al presupuesto de error.

---

## P2 — La caja sujetadora sola

| # | Qué | Tolerancia |
|---|---|---|
| P2.1 | masa de la caja completa, con sus tornillos y las gomas | ±0,2 kg |
| P2.2 | ancho, alto y profundidad interiores y exteriores | ±1 mm |
| P2.3 | posición de los dos agujeros del eje de altura: altura desde el canto inferior y distancia a cada cara | ±1 mm |
| P2.4 | **coaxialidad** de los dos agujeros: pasar una varilla recta y medir cuánto se desvía en el otro lado | ±1 mm |
| P2.5 | la asimetría de 1,8 cm que está anotada de antes: ¿sigue siendo 1,8? medir qué cosa es exactamente | ±1 mm |

---

## P3 — El resto de la montura (bases + cuatro paredes, armado, sin tubo ni caja)

Acá entra la **pesada en dos puntos**, que da masa y centro de masa de una vez.

**Montaje:** dos caños redondos del mismo diámetro como apoyos, separados una
distancia **L** conocida, uno de ellos **arriba de la balanza** sobre un
bloque de la misma altura que la balanza (así queda horizontal). Los caños
redondos importan: con apoyos planos la fricción mete un error que no se
controla.

| # | Qué se lee | Fórmula |
|---|---|---|
| P3.1 | `R_A` con la balanza bajo el apoyo A | — |
| P3.2 | `R_B` con la balanza bajo el apoyo B | masa total `W = R_A + R_B` |
| P3.3 | distancia del CoM al apoyo A | `d_A = R_B · L / W` |

Hacer P3.1-P3.3 **en dos direcciones perpendiculares** (norte-sur y
este-oeste de la base) → el CoM en el plano de la base.

**La altura del CoM, por inclinación:** levantar el apoyo A un `Δ` medido
(bloque de altura conocida), con el otro apoyo quieto, y leer otra vez la
balanza bajo A → `R_A'`.

    z = L · (R_A − R_A') / (W · tan θ)     con   θ = asin(Δ / L)

con `z` la altura del CoM sobre el plano de los apoyos. Con L ≈ 40 cm y
θ ≈ 10°, la diferencia `R_A − R_A'` da del orden de **7 kg** sobre esta pieza:
se lee de sobra con una balanza de baño.

> **Trabar todo antes de inclinar** y no pasar de 10-12°. Y acordate de que
> acá el tubo **no** está: por eso es seguro inclinarlo.

| # | Qué | Tolerancia |
|---|---|---|
| P3.4 | masa `W` del conjunto sin tubo ni caja | ±0,5 kg |
| P3.5 | CoM en el plano de la base, dos coordenadas | ±5 mm |
| P3.6 | altura `z` del CoM | ±5 mm |
| P3.7 | espesor real de cada tabla (fija, móvil, pared grande, pared chica) | ±0,5 mm |
| P3.8 | altura del eje de altura sobre la cara superior de la base móvil | ±2 mm |
| P3.9 | separación entre paredes, abajo y arriba (está anotado 37 / 36) | ±1 mm |
| P3.10 | diámetro, altura y posición de los tres tacos de PVC, y el radio en el que están | ±1 mm |

---

## P4 — El conjunto completo (verificación independiente)

Armado, tubo horizontal y trabado, configuración de referencia.

| # | Qué | Tolerancia |
|---|---|---|
| P4.1 | masa total por pesada en dos puntos | ±0,5 kg |
| P4.2 | CoM en el plano de la base, dos direcciones | ±5 mm |

**Esto es el control, no un dato más:** P4 tiene que coincidir con lo que sale
de componer P1 + P2 + P3. Si no coincide dentro de 1 kg y 10 mm, hay un error
en alguna de las dos y **no se sigue diseñando hasta encontrarlo**. Dos
métodos que coinciden valen; uno solo es una esperanza.

**No inclinar el conjunto completo.** La altura del CoM sale de la
composición, y 50 kg inclinados son peligrosos para nada.

---

## P5 — Masas sueltas, para el cálculo

| # | Qué | Tolerancia |
|---|---|---|
| P5.1 | cada ocular (5, 10, 25 mm) | ±10 g |
| P5.2 | la cámara Sony con su adaptador | ±10 g |
| P5.3 | el celular (S21 / S24 Ultra, el que vaya) | ±10 g |
| P5.4 | el buscador si sale del tubo | ±20 g |

---

## P6 — Las fotos

No "fotos del telescopio": **estas fotos**, y con una cinta métrica o una
regla en el cuadro, apoyada sobre la pieza, en todas.

1. El conjunto completo: **de frente, de costado y de atrás**, con la cinta
   vertical apoyada al lado.
2. La base de abajo: el sándwich de las dos tablas, los **tres tacos de PVC**,
   el **disco de vinilo** y el niple del centro. Una foto desde abajo si se
   puede dar vuelta.
3. La caja sujetadora: los dos lados, los tornillos de presión, los
   **retazos de goma** y el **DVD separador**.
4. El eje de altura, de cerca: tornillo, tuerca, el agujero y cómo apoya.
5. El focuser con y sin ocular, y el buscador.
6. **Por el focuser sin ocular**, apuntando a un fondo claro: se ve el
   secundario y se puede medir su eje menor.
7. Electrónica, con el texto **legible**: la placa **HW-130 por los dos
   lados**, el Arduino Nano, cada motor con su etiqueta, los rulemanes con el
   número grabado (debería decir `608ZZ` o parecido) y los engranajes con una
   regla al lado.

La foto 7 es la que más vale: decide el BOM. Sin ella el inventario queda en
`?` y la fase 0 no cierra.

---

## Qué hace la sesión con esto

| Entra | Sale |
|---|---|
| P0 | la rama de óptica: foco primario o afocal, y qué soporte 3D hay que diseñar |
| P1 + P2 + P3 | la **curva de CoM en función del ángulo de altura**, que es el insumo de la geometría de la plataforma |
| P4 | el control de las dos anteriores |
| P3.4 + P1.1 + P2.1 | la masa total, que decide **CS o VNS** en el trade study (capacidad de carga) |
| P5 | cuánto corre el CoM al colgar la cámara (riesgo R7) |
| P6 | el modelo 3D y el inventario |

**Lo que NO hace falta medir todavía**, y no se mide: nada de la plataforma
nueva (no existe), nada de los engranajes de las videograbadoras (eso es fase
3), y la precisión mejor que las tolerancias de arriba. Perseguir el décimo de
milímetro en el CoM es tiempo tirado: la fórmula del radio del sector es
lineal en la altura del CoM, y la plataforma se calza con suplementos.
