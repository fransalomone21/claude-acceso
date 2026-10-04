# PDP — Automatización del telescopio 200/1200

**Proyecto:** plataforma ecuatorial motorizada + reforma de la montura dobson +
soporte de cámara, para astrofotografía de larga exposición.
**Naturaleza:** `ingenieria`. **Abierto el:** 2026-10-04.
**Antecedente:** hubo trabajo previo (2026-08) hecho sin arquitectura. No se
tira: entra como **un concepto candidato** y sus números bajan a `hipótesis`.
Ver §6 y `docs/04-conceptos.md`.

## 1. El problema

Hoy el telescopio no puede sacar una foto de larga exposición: la montura es
alt-azimutal y manual. Dos cosas lo impiden, y son distintas: el objeto **se
va del campo** (no hay seguimiento) y el campo **rota** (toda montura alt-az
rota el campo, así que ni motorizando los dos ejes se puede exponer largo).

**Para quién es:** para Fran, solo. No es un producto; nadie más lo va a usar
ni a mantener. Eso baja el rigor de documentación de uso y lo sube en
reversibilidad: no hay repuesto de la montura.

**Cómo sabremos que sirvió (validación — la meta):** existe **una foto propia,
apilada, de una nebulosa o una galaxia**, tomada con el 200/1200 sobre la
plataforma, donde el objeto se reconozca y las estrellas sean puntos y no
rayas. Esa foto es el criterio. Un diseño perfecto sin la foto falla la
validación.

## 2. Qué NO es

- **No es un GoTo.** No hay catálogo, ni apuntado automático, ni búsqueda. El
  telescopio se sigue apuntando a mano; la plataforma sólo lo mantiene quieto.
- **No es una montura nueva.** La dobson existente se reforma, no se reemplaza.
- **No es planetaria.** Para planetas no hace falta plataforma (video corto y
  apilado funcionan en alt-az). Si la foto de un planeta sale de paso, bien,
  pero no manda ninguna decisión de diseño.
- **No es autoguiado en la fase 1.** Se deja la entrada prevista en el
  firmware, pero el objetivo se cumple sin guiar.
- **No se compra lo que se puede reciclar**, salvo donde el reciclado ponga en
  riesgo la meta (y eso se escribe, no se supone).

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `a` elegir la arquitectura de la plataforma | un solo tiro: se construye una | requisitos desconocidos hasta medir masa y CoM | **pleno** | es la decisión de la que cuelga todo lo demás, y ya se tomó una vez sin trade study |
| `b` reformar la montura dobson actual | **un solo tiro**: no hay otra montura, la madera cortada no vuelve | conocidos una vez medido el CoM | **pleno, y prototipo antes** | la compensación se prueba **moviendo** el tubo antes de cortar nada |
| `c` cortar y armar la plataforma nueva | se rehace: madera y tiempo, no el proyecto | conocidos (geometría cerrada por fórmula) | **plantilla 1:1 obligatoria** antes del primer corte | un sector mal cortado no se endereza |
| `d` electrónica y firmware | se rehace barato, todo es software y cables | desconocidos: no se sabe qué motores hay | iterar corto y medir el efecto | nada acá puede arruinar la montura |
| `e` soporte de cámara impreso en 3D | se rehace barato, se reimprime | desconocidos: la cámara no está elegida | iterar corto | el costo de una iteración es un rollo de filamento |

El default es el rigor más bajo que los dos ejes permitan. Acá los dos ejes
de `b` son los peores del proyecto y por eso es el único aspecto con prototipo
obligatorio.

## 4. Las fases

Mapeo a CDIO: **Concebir** = fases 0 y 1. **Diseñar** = 2 y 3.
**Implementar** = 4. **Operar** = 5.

| # | Fase | NASA | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|---|
| 0 | Concebir | Pre-Fase A, *Concept Studies* | los tres números que mandan medidos, el inventario real con modelos, y **una** arquitectura elegida con trade study pesado por Fran | ver abajo | **abierta** |
| 1 | Requisitos y presupuesto de error | Fase A, *Concept & Technology Development* | el presupuesto de error cierra numéricamente para el tiempo de sub pedido, y los requisitos pasan el verificador GtWR | `verificar-requisito.py docs/10-requisitos.md` en verde + la cuenta de arcsec cierra | sin empezar |
| 2 | Reforma de la montura | Fase B | el CoM medido cae dentro de la tolerancia pedida respecto del eje, **con la montura ya reformada** | se re-mide el CoM con el mismo método de la fase 0 y se compara | sin empezar |
| 3 | Diseño detallado de la plataforma | Fase C, CDR | plantillas 1:1 en DXF + lista de corte + BOM contrastado contra el inventario | el CAD se regenera desde los números medidos; un chequeo compara el DXF contra las fórmulas | sin empezar |
| 4 | Construir, integrar y probar | Fase D | deriva medida en una estrella ≤ requisito, durante el tiempo de sub pedido, y 60 min de carrera sin intervenir | prueba de deriva fotografiada | sin empezar |
| 5 | Operar | Fase E | **la foto** | la imagen existe | sin empezar |

**Fase en curso:** 0 — Concebir (Pre-Fase A, *Concept Studies*).

**Qué la cierra, exactamente** — las tres cosas, y ninguna es "trabajo hecho":

1. **Los tres números que mandan**, medidos y con su método escrito:
   masa total del conjunto, posición 3D del centro de masa, y la respuesta
   sí/no a *¿llega a foco la cámara en foco primario?*
2. **El inventario real**, pieza por pieza con su modelo leído de la etiqueta
   (no enumerado de memoria), en `docs/03-inventario.md`.
3. **Una arquitectura elegida** en `docs/05-trade-study.md`, con los pesos
   puestos por Fran y declarados con fuente, y un ganador que **no empata**.

**Cómo se certifica:** `ESTADO_ACTUAL.md` § *Lo confirmado* tiene las tres
mediciones con su método y su fecha, `docs/03-inventario.md` no tiene ninguna
fila en `?`, y `docs/05-trade-study.md` tiene la columna de pesos con fuente
«Fran» y una diferencia distinta de cero entre el primero y el segundo.

**En rojo se ve así:** una fila del inventario que diga «una placa que creo que
es un driver», o un trade study cuyos pesos los puso la sesión. Las dos cosas
ya pasaron en este proyecto.

**Si esta fase se cancela:** si la medición 0 dice que el tubo **no** llega a
foco con la cámara y tampoco con el celular, la meta de cielo profundo cae y
el proyecto se reescribe entero. Eso es información valiosa, no un fracaso, y
cuesta diez minutos averiguarlo — por eso la medición 0 va primera.

## 5. Riesgos

| # | Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|---|
| R1 | el tubo no llega a foco con la cámara en foco primario (falla clásica de newtonianos: el recorrido hacia adentro se agota) | media | **alta** | mitigar: plan B afocal con el celular y el ocular de 10/25 mm | la medición 0 de la fase 0 |
| R2 | 50 kg sobre madera: flexión y *creep* de la tabla durante una hora de exposición, deriva que ningún motor corrige | media | alta | vigilar; pesa en el trade study como capacidad de carga | en la fase 4, deriva con forma de rampa que no cambia al cambiar la velocidad del motor |
| R3 | alineación polar en el hemisferio sur: no hay estrella polar brillante (σ Octantis, mag 5,4, a 1° 8' del polo) | **alta** | media | mitigar: método de deriva documentado + marcas fijas en el piso del patio para no realinear cada noche | la prueba de deriva no baja de la deriva pedida |
| R4 | las paredes de la montura flexan (medido: 37 cm abajo, 36 cm arriba) y apretar el eje de altura las cierra | **confirmado, ya pasa** | media | casquillos rígidos en los ejes de altura | ya disparó |
| R5 | error periódico de la varilla roscada M8 reciclada en el brazo tangencial | media | media | aceptar en la fase 4, medir; si no alcanza, el plan es autoguiado | estrellas con un guión periódico en los subs largos |
| R6 | **la arquitectura CS elegida en 2026-08 no admite apoyo en tres puntos y tiene menos capacidad de carga que la alternativa VNS** | **confirmado por lectura, 2026-10-04** | alta | la decisión se reabre en el trade study de la fase 0 | ya disparó: ver `docs/04-conceptos.md` |
| R7 | el peso de la cámara y el soporte en la boca del tubo corre el centro de masa después de medirlo | alta | media | mitigar: el CoM se mide **sin** cámara como línea base, y se re-mide cuando el soporte exista (fase 2) | el soporte sale de la impresora |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-04 | **plataforma ecuatorial**, no motorizar los dos ejes en alt-az | alt-az de doble eje motorizado; apilado de subs cortos sin seguimiento | el alt-az rota el campo: para exposición larga no sirve ni con los dos ejes perfectos. Es la razón física por la que la plataforma existe |
| 2026-10-04 | **no GoTo** | GoTo con catálogo | lo pidió Fran, y multiplica la electrónica y el firmware sin acercar la meta (la foto) |
| 2026-10-04 | la arquitectura CS decidida en 2026-08 **se reabre** y vuelve a competir | mantenerla por costo hundido | se eligió sin trade study y con la masa sin medir; y la fuente canónica dice que CS no da apoyo en tres puntos (R6) |
| 2026-10-04 | los números de diseño de 2026-08 (radios, H, recorridos, el macro VBA) bajan a **`hipótesis`** | dejarlos como «parámetros cerrados» | se calcularon con H = 64 cm y 45 kg, y las dos cosas son estimaciones sin medición. Una predicción escrita como un hecho contamina cada documento que la copia |

## 7. Verificación

**Cómo se verifica cada entregable:**

| Entregable | Se verifica contra | Con qué |
|---|---|---|
| masa y centro de masa | **dos métodos independientes** que tienen que coincidir dentro de la tolerancia | pesada en dos puntos, y composición de las masas de las piezas |
| requisitos (fase 1) | INCOSE GtWR | `python perfil-global/pilares/incose-gtwr/verificar-requisito.py` |
| geometría de los sectores | las fórmulas paramétricas, recalculadas con los números medidos | chequeo que compara el DXF emitido contra la fórmula |
| la plataforma armada | el requisito de deriva | foto de una estrella en un sub del largo pedido: redonda o rayada |
| la montura reformada | el CoM pedido | se re-mide, no se supone |

**Qué se registra de cada verificación:** qué se midió, con qué instrumento,
la tolerancia del instrumento, en qué difiere de la condición real (de día vs
de noche, con cámara vs sin cámara), y **la lista de lo que quedó fuera de
tolerancia** — esa última parte es la que siempre se omite.

**El verificador, ¿alguna vez falló?** Todavía no existe ninguno propio de
este proyecto. El primero que se escriba se rompe a propósito antes de
creerle.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `CLAUDE.md` #1 evidencia con grado | todos | `cumple` | |
| `CLAUDE.md` #3 toda alarma se prueba rompiéndola | `c`, `d` | `cumple` | |
| `CLAUDE.md` #6 cambios mínimos | `b` | `cumple` | |
| `ingenieria.md` §nivel 1 primero | todos | `cumple` | el nivel 1 es el modelo 3D del conjunto, y va antes del detalle de la plataforma |
| `ingenieria.md` §pesos del trade study los pone el interesado | `a` | `cumple` | se le preguntan antes de rankear |
| `nasa-seh` revisión formal con interesado al cerrar fase | todas | `recortado` | **la resta:** el interesado y el ingeniero son la misma persona en dos roles. Una revisión formal con uno mismo no agrega información; lo que sí agrega es el criterio de salida escrito **antes**, que queda. Riesgo que compra la regla completa: que una fase cierre en falso — ya cubierto por el campo «cómo se certifica». Riesgo que crea: una sesión entera de ceremonia por fase, sobre un proyecto de 6 fases |
| `nasa-seh` SEMP stand-alone | todos | `no aplica` | no hay equipo ni contrato; el PDP cumple ese rol (NPR no exige documentos stand-alone) |
| `nasa-seh` TRL por nodo | `d` | `recortado` | **la resta:** el TRL discrimina entre tecnologías que podrían no existir. Acá todo es tecnología madura (madera, rulemanes, steppers). Lo que sí falta es saber **qué** se tiene: eso lo cubre el inventario, que es más barato y más informativo |
