# Medidas del telescopio — registro

Cada número lleva **con qué se midió** y su grado. Lo que sale de una foto es
una estimación, aunque tenga una escuadra al lado.

Fotos: 71, del 2026-10-04, en `fotos/2026-10-04/` (carpeta **ignorada**: muestran
la terraza y la casa; el repo es público) y en el Drive compartido, carpeta
`Fotos 2026-10-04`. Los números «foto NN» siguen `fotos/2026-10-04/indice.txt`.

## 1. Medidas de Fran, con cinta (2026-10-04)

Método: cinta métrica y escuadra; resolución de lectura ±1 mm, sin
repetición. Todas las tablas tienen **2 cm** de espesor.

| Pieza | Medida | Nota |
|---|---|---|
| Base fija | 43 × 40 cm | |
| Base móvil | 40 × 40 cm | |
| Pared chica 1 (lado del **ocular**) | 20 × 40 cm | une las paredes grandes |
| Pared chica 2 (lado de la **cola**) | 19,8 × 40 cm | |
| Pared grande 1 (lado del **buscador**) | 40 × 79,6 cm (alto) | su canto no coincide con el borde de la base móvil: escalón de **1,7 cm** en la punta del ocular a **1,3 cm** en la cola (no es paralelo) |
| Pared grande 2 (enfrentada) | 40 × 78,8 cm (alto) | 8 mm más baja que la 1 |
| Caja: techo y piso | 40 × 31 cm | |
| Caja: costado del ocular y del buscador | 40 × 27 cm | |
| Tubo, diámetro exterior | 25,3 cm | |
| Aro de aluminio del tubo | 26,7 cm | |
| Eje de los rodillos de la impresora | entre 0,5 y 1 cm, «creo que 0,8» | foto 54 con escuadra: **≈ 8 mm**, `probable` |

## 2. Lo que sale de las fotos — `hipótesis` hasta medirlo

| Qué | Estimación | Foto | Para qué importa |
|---|---|---|---|
| Hueco entre base fija y móvil (tacos de PVC + vinilo) | ≈ 1,5 cm | 19 | altura de todo lo de arriba |
| **Eje de altura** | un rulemán en un vaso, con bulón y tuerca M8, **≈ 2,6 cm debajo del borde** de la pared; el CD de la caja centrado en él | 35, 36 | la altura del eje sobre el piso del dobson: **≈ 82,5 cm** |
| **Portaocular** | **helicoidal (a rosca), 1,25"**: boca interior ≈ 3,2 cm, ≈ 4,5 cm de alto sobre el tubo | 59-63, 69, 70 | **P0**: un helicoidal tiene muy poco recorrido (≈ 1 cm). Si la cámara no llega a foco, es por esto, y la Barlow lo arregla |
| Buscador | chico, recto, tubo de ≈ 2,5 cm, pie pegado con masilla | 28, 32, 64 | masa chica; no cambia el centro de masa |
| Celda del primario | fundición de aluminio con una corona de agujeros; aro de ≈ 6 cm de ancho | 13, 14, 56 | es lo más pesado del tubo: corre su centro de masa hacia la cola |
| Araña | cuatro patas de fleje, porta-secundario con tres tornillos de colimación | 65-68 | — |
| Caja sujetadora | tornillos de presión en el techo (≈ 9) y en el piso, sobre gomas | 2, 17, 18, 55, 58 | el tubo se puede correr dentro de la caja: es la perilla del balance |
| Motor de la impresora | **Mitsumi M28N-1**, P/N C6409-60004 (repuesto HP) | 48, 51 | `probable` **motor de continua con encoder, no paso a paso**: al lado hay una tira y una rueda de encoder (46, 52, 53). Para la plataforma no sirve tal cual |
| Eje guía de la impresora | varilla de acero cromada, ≈ 8 mm | 45, 54 | **sí sirve** como eje de los rodillos (reemplaza el bulón M8, y es más derecho) |

## 3. Masa y centro de masa — estimados por volumen

`python docs/estimar-cdm.py` (pino 450-550 kg/m³, tubo completo 8-14 kg,
tubo **supuesto balanceado** sobre el eje de altura):

| | Estimado | Lo que se decía antes |
|---|---|---|
| Masa total | **27 kg** (rango 22 a 32) | 45 kg (2026-08) / 50 kg (Fran, a ojo) |
| Centro de masa sobre el piso del dobson | **60 cm** (rango 58 a 61) | 64 cm |
| Eje de altura sobre el piso del dobson | 82,5 cm | 78 cm |

**Lo que cambia:** la masa sale **la mitad** de lo que se creía. La geometría
de la plataforma depende del centro de masa, no de la masa, así que el diseño
no cambia; pero baja la carga sobre cada rodillo (de 19 a ≈ 10 kg) y el
torque que necesita el motor. El centro de masa es robusto: aunque el tubo
pese el doble de lo supuesto, se mueve 2 cm.

**Lo que no se sabe y manda:** si el tubo está **balanceado** sobre el eje de
altura. Si no lo está, el centro de masa total se corre hacia donde cuelga y
además **cambia con la altura a la que apunta el tubo**. Eso lo dice la
pesada, no las fotos.

### 3.1 Primera pesada (2026-10-05): **40 kg** — y contradice la estimación

Fran: «telescopio + montura dobson más lente en el ocular y todo, 40 kg».
Método: balanza (cuál y cómo, sin anotar todavía). Grado: `medido`, una vez.

**Cae afuera del rango estimado (22 a 32 kg).** Hay dos hipótesis y valen lo
mismo: la estimación está mal (la madera es más densa que pino de 500, o el
tubo pesa bastante más de 14 kg) o la pesada está mal (balanza, método). Lo
separa la pesada por partes, que Fran está haciendo:

| Si el exceso está en… | Montura / tubo | Centro de masa del total |
|---|---|---|
| la madera (≈ 750 kg/m³) | ≈ 24 / 16 kg | ≈ **60 cm** (no cambia) |
| el tubo (≈ 24 kg) | ≈ 16 / 24 kg | ≈ **67 cm** (sube 7 cm) |

Por eso la pesada separada importa: la masa sola no mueve la geometría, pero
**dónde está** la masa sí. Hasta saberlo, el modelo usa 40 kg y 60 cm.

**Balance del tubo (Fran, 2026-10-05):** al volver a montarlo, lo va a correr
dentro de la caja para que su centro de masa quede en el eje de altura. La
referencia exacta es el **centro del CD / rulemán** (el eje), no el centro
del cajón: se marca en el tubo el punto donde se balancea sobre el caño y se
lo deja alineado con el eje. Es la regla 4 del proyecto (correr el tubo antes
que cortar madera).

### 3.2 Pesadas por partes (2026-10-05)

Fran, misma balanza (modelo, rango y resolución **sin anotar todavía**):

| Qué | kg |
|---|---|
| Tubo **sin la caja**, con el buscador, sin ocular ni Barlow | **19,2** |
| El mismo, con la cámara y su soporte montados | **19,7** (cámara + soporte ≈ 0,5) |
| Montura sola («la base»), **con la caja** (la caja no se pesó aparte) | **19,7** |

**La masa cierra por dos caminos:** partes 19,2 + 19,7 = **38,9 kg** sin
ocular, contra **40 kg** del total con ocular (§3.1). Diferencia 1,1 kg
(3 %): el ocular y la resolución de la balanza. Grado: `probable` (dos
caminos, una sola balanza sin calibrar). **Masa de diseño: 40 kg.**

**Balance (Fran):** el tubo se corrió en la caja hasta que «no se mueve en
altura al ponerlo a distintos ángulos». El paso 1 de §4 está hecho: el CdM
del tubo está sobre el eje de altura, **dentro de lo que deja ver el
rozamiento** del eje (un desbalance chico lo frena el rozamiento y no se
ve). Se balanceó **sin la cámara**: con ella (≈ 0,5 kg en el portaocular)
el CdM del tubo se corre ≈ 1 a 2 cm hacia la boca, y se corrige corriendo el
tubo lo mismo hacia la cola. Fran lo va a refinar.

**La montura es de pino** (Fran). Su madera, con la caja, son **31,8 litros**
(§1): a 450-550 kg/m³ dan **14,3 a 17,5 kg**, y la pesada dio 19,7. La
densidad aparente es **620 kg/m³**: lo que sobra (**2,2 a 5,4 kg**) son
herrajes — rulemanes y bulones del eje, tacos, vinilo, gomas, tornillos —, o
pino más pesado que el de tabla (húmedo o con nudos). **La caja sola** (9,3
litros) sale **≈ 4,6 kg** de pino de 500 (4,2 a 5,1), ≈ 5,8 kg con la
densidad aparente. Pesarla sola la próxima vez cierra este número.

El tubo, en cambio, pesa **19,2 kg sin caja**: casi el doble de un 200/1200
comercial de chapa (≈ 10-11 kg). Es medido, así que manda; el exceso es
`hipótesis` (tubo de chapa gruesa, celda de fundición pesada).

**Centro de masa compuesto** (`python docs/estimar-cdm.py`): tubo con cámara
19,7 kg balanceado en el eje (82,5 cm) + montura 19,7 kg repartida según su
geometría → **63 cm** sobre el piso del dobson. Lo que no se sabe es dónde
están los herrajes: todos abajo lo bajan a **58**, todos a la altura del eje
lo suben a **69**. El rango real es más angosto (están repartidos), pero el
número exacto lo da el **segundo método**: P3 (montura inclinada) o P4 (todo
junto, plano). Grado: `probable`. **Valores de diseño: 40 kg, CdM 63 cm,
eje a 65 sobre la mesa con 2 cm de suplemento.**

## 4. Lo que falta, en orden

> **Vigente desde 2026-10-05:** el orden con quién, cuándo y cómo se sabe que
> salió bien está en `docs/11-paso-a-paso.md` (Doc «2 - Paso a paso»). Esta
> lista queda como historia del protocolo. Cambios: el **segundo método** es
> P3 (montura **con la caja puesta**, inclinada), porque es el único que da la
> **altura** del CdM, que es la duda de 58 a 69 cm (P4, plano, sólo da la
> planta); P4 queda como **control**. Ya **no hace falta pesar la caja sola**.
> La cámara y el rebalanceo con ella quedan **aparcados** a pedido de Fran.

0. **Hechos (2026-10-05, §3.2):** el balance (sin cámara) y las pesadas
   del tubo y de la montura. Quedan los pasos 3 a 5 (P3 y P4), ~~pesar la caja
   sola~~ y ~~rebalancear con la cámara puesta~~ (aparcado).
1. **Hecho, sin cámara.** ¿El tubo se queda donde lo dejás? Apuntado a 20°, a 45° y a 80°, soltado:
   ¿se queda quieto o se va solo hacia la cola o hacia la boca? (30 segundos,
   sin herramientas). Si se queda en las tres, está balanceado.
2. **Pesar el tubo con su caja** con la balanza de baño: subirse con el tubo
   en brazos, restar el peso propio. Y **dónde se balancea**: apoyarlo cruzado
   sobre un caño de PVC en el piso y correrlo hasta que quede quieto; medir del
   caño al centro del CD (el eje de altura). Es el P1 del protocolo, con la
   caja puesta (no hace falta sacarla).
3. **La montura sin el tubo** (bases + paredes), pesada en dos puntos y con
   inclinación: es el P3 del protocolo, con una tabla rígida de unos 80 cm,
   dos caños iguales como apoyos, la balanza de baño y ladrillos para
   levantar un lado unos 12-14 cm. Da masa y centro de masa en 3D de una.
4. **Todo junto, plano** (P4, sin inclinar): masa total y centro de masa en
   planta. Es el control: tiene que coincidir con 2 + 3.
5. Medir de verdad el hueco de los tacos y la distancia del borde de la pared
   al centro del rulemán del eje de altura (las dos estimadas de fotos).
