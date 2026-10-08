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
| 0 | Concebir | Pre-Fase A, *Concept Studies* | los tres números que mandan medidos, el inventario real con modelos, **una** arquitectura elegida con trade study pesado por Fran, y el **borrador de requisitos** (necesidades → L0 → L1 → L2, trazados, con TBD/TBR declarados) | ver abajo | **abierta** |
| 1 | Requisitos y presupuesto de error | Fase A, *Concept & Technology Development* | el presupuesto de error cierra numéricamente para el tiempo de sub pedido, y los requisitos quedan en **línea base** (sin TBD, validados con Fran: SRR) | `verificar-requisito.py docs/10-requisitos.md --idioma es` sin VIOLA + la cuenta de arcsec cierra + SRR con fecha | sin empezar |
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
4. **El borrador de requisitos** en `docs/10-requisitos.md` (agregado el
   2026-10-07: NASA pone en Pre-Fase A el *draft system-level requirements*,
   las necesidades, metas y objetivos, y las medidas de efectividad, y este
   PDP lo había dejado para la fase 1 — nueve sesiones diseñaron sin él).
   Con los criterios de la cátedra (IISE m17, m21), el GtWR y NASA:
   necesidades (`N-xx`) → `L0` misión → `L1` sistema → `L2` elementos
   (plataforma, montura, tren de imagen, operación), cada uno con tipo,
   padre, rationale, método de verificación y estado (`TBD`/`TBR`/definido);
   lo que falta definir, marcado; lo que el modelo 3D ya representa, marcado.
   Se certifica con `verificar-requisito.py --idioma es` sin VIOLA y con cada
   hijo trazado a un padre que existe.

**Cómo se certifica:** `ESTADO_ACTUAL.md` § *Lo confirmado* tiene las tres
mediciones con su método y su fecha, `docs/03-inventario.md` no tiene ninguna
fila en `?`, `docs/05-trade-study.md` tiene la columna de pesos con fuente
«Fran» y una diferencia distinta de cero entre el primero y el segundo, y
`docs/10-requisitos.md` existe, pasa el verificador sin VIOLA y
`auditar-sesion.py` no encuentra un commit de diseño que no trace a uno de sus
IDs.

**En rojo se ve así:** una fila del inventario que diga «una placa que creo que
es un driver», o un trade study cuyos pesos los puso la sesión. Las dos cosas
ya pasaron en este proyecto.

**Si esta fase se cancela:** si la medición 0 dice que el tubo **no** llega a
foco con la cámara y tampoco con el celular, la meta de cielo profundo cae y
el proyecto se reescribe entero. Eso es información valiosa, no un fracaso, y
cuesta diez minutos averiguarlo — por eso la medición 0 va primera.

**Después de la fase 0: la V de NASA** (Fran, 2026-10-08: «una vez que
terminemos el concepto, haremos el diseño con la lista de requisitos de alto
nivel y de ahí para abajo hasta definir el mejor mecanismo, mejor performance
en relación a simplicidad»). Es el motor de NASA (SEH Fig. 2.1-1,
`perfil-global/pilares/nasa-seh/fundamentos.md` §3; también en los apuntes de
IISE del Drive): **el brazo que baja** — requisitos de alto nivel (L0, L1) →
L2 por elemento → L3 por subsistema (transmisión, rodillos, estructura,
electrónica, programa) → cada pieza hasta que se puede comprar, fabricar o
reusar —, y **el brazo que sube** — implementación → integración →
verificación contra cada nivel de requisitos → validación contra el ConOps (la
foto). Cada nivel del brazo que baja deja escrito, **antes** de bajar al
siguiente, su **plan de verificación** (con qué ensayo, análisis, inspección o
demostración se va a comprobar cada «deberá» al subir) y su **plan de
implementación** (cómo se fabrica, compra o integra). Los mecanismos en
competencia (la transmisión: opción 1 F, rodillo y correa; opción 2 V, varilla
roscada y biela, la de la foto del 2026-10-08) se eligen **en su nivel**, con
un trade study de pesos puestos por Fran, nunca antes por el modelo 3D: el
modelo muestra opciones, no decide.

## 5. Riesgos

| # | Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|---|
| R1 | el tubo no llega a foco con la cámara en foco primario (falla clásica de newtonianos: el recorrido hacia adentro se agota) | media | **alta** | mitigar: plan B afocal con el celular y el ocular de 10/25 mm | la medición 0 de la fase 0 |
| R2 | 50 kg sobre madera: flexión y *creep* de la tabla durante una hora de exposición, deriva que ningún motor corrige | media | alta | vigilar; pesa en el trade study como capacidad de carga | en la fase 4, deriva con forma de rampa que no cambia al cambiar la velocidad del motor |
| R3 | alineación polar en el hemisferio sur: no hay estrella polar brillante (σ Octantis, mag 5,4, a 1° 8' del polo) | **alta** | media | mitigar: método de deriva documentado + marcas fijas en el piso del patio para no realinear cada noche | la prueba de deriva no baja de la deriva pedida |
| R4 | las paredes de la montura flexan (medido: 37 cm abajo, 36 cm arriba) y apretar el eje de altura las cierra | **confirmado, ya pasa** | media | casquillos rígidos en los ejes de altura | ya disparó |
| R5 | error periódico de la transmisión. Era la varilla roscada (se sacó el 2026-10-07: repetía su error cada ≈ 1 min); ahora son la polea de 20 (≈ 3,6″ cada 8 min), el rodillo motriz (≈ 2,9″ cada 31 min con 0,01 mm) y los micropasos (≈ ±1″ cada 10 s), todo por cálculo en `docs/13-revision-externa.md` §4 | media | media | presupuesto de error en la fase 1; rodillo torneado y polea medida; si no alcanza, 16:80 o autoguiado | estrellas con un guión periódico en los subs largos |
| R9 | **el canto de las chapas con escalones** (corte a plasma, caladora o lima a mano): un escalón de 0,01 mm en pocos milímetros mueve la estrella ≈ 5″ | media | alta | láser + aceptación FAB-1 por escalones, no por contorno | saltos en la deriva que se repiten en la misma posición de la mesa |
| R10 | la mesa apoya y no está atada: un empujón de costado en la boca del tubo la levanta de un rodillo | baja | alta | rodillos a 50 cm (6,9 kg, más que el dobson solo en el piso); no apoyarse en el tubo | la mesa golpea al apuntar |
| R6 | **la arquitectura CS elegida en 2026-08 no admite apoyo en tres puntos y tiene menos capacidad de carga que la alternativa VNS** | **confirmado por lectura, 2026-10-04** | alta | la decisión se reabre en el trade study de la fase 0 | ya disparó: ver `docs/04-conceptos.md` |
| R8 | **a 34,5° el VNS sale largo**: el pivote queda a `H / tan φ` del centro de masa (0,96 m con H = 64 cm) y la base mide ≈ 1,40 m; incómodo de guardar y llevar | **confirmado por cálculo** (H aún hipótesis) | media | mitigar: pivote sobre un poste (cada 10 cm de poste, ≈ 14,5 cm menos); Fran decide si el largo le sirve | ya disparó: `docs/geometria-vns.js` |
| R7 | el peso de la cámara y el soporte en la boca del tubo corre el centro de masa después de medirlo | alta | media | mitigar: el CoM se mide **sin** cámara como línea base, y se re-mide cuando el soporte exista (fase 2) | el soporte sale de la impresora |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-10-04 | **plataforma ecuatorial**, no motorizar los dos ejes en alt-az | alt-az de doble eje motorizado; apilado de subs cortos sin seguimiento | el alt-az rota el campo: para exposición larga no sirve ni con los dos ejes perfectos. Es la razón física por la que la plataforma existe |
| 2026-10-04 | **no GoTo** | GoTo con catálogo | lo pidió Fran, y multiplica la electrónica y el firmware sin acercar la meta (la foto) |
| 2026-10-04 | la arquitectura CS decidida en 2026-08 **se reabre** y vuelve a competir | mantenerla por costo hundido | se eligió sin trade study y con la masa sin medir; y la fuente canónica dice que CS no da apoyo en tres puntos (R6) |
| 2026-10-04 | los números de diseño de 2026-08 (radios, H, recorridos, el macro VBA) bajan a **`hipótesis`** | dejarlos como «parámetros cerrados» | se calcularon con H = 64 cm y 45 kg, y las dos cosas son estimaciones sin medición. Una predicción escrita como un hecho contamina cada documento que la copia |
| 2026-10-04 | **la meta se parte en dos, en este orden:** primero la foto con subs de 20-30 s sin guiar (ésa es la fase 5 de este proyecto); el autoguiado para subs de 2-4 min es un **proyecto nuevo** después | una sola meta de 2-4 min desde el arranque; quedarse sólo en 20-30 s | **fuente: Fran, 2026-10-04.** Hace que la primera foto llegue antes. El riesgo asumido y escrito: que el diseño no escale al segundo objetivo — se mitiga dejando el gancho de autoguiado en el firmware desde el día uno, que es gratis |
| 2026-10-04 | **arquitectura VNS** (pivote al norte + dos segmentos verticales de aluminio al sur, en tres puntos) | CS de segmentos circulares (la de 2026-08) | **fuente: Fran, 2026-10-04**: *«sí, vamos con el VNS»*. Pesos y puntajes en `docs/05-trade-study.md`: VNS 4,5 contra CS 2,7, y gana en cualquier orden de los puestos 2-4. Precio aceptado y escrito antes: base de ≈ 1,40 m por la latitud baja (o un poste en el pivote) |
| 2026-10-04 | **la plataforma se diseña adaptable**: eje un poco arriba del centro de masa esperado + suplementos bajo el dobson + ranuras para correrlo + tres patas regulables | cortar los segmentos al número exacto y que el telescopio se adapte | **fuente: Fran, 2026-10-04** (*«no estar renegando con calibraciones»*). Lo único que queda fijo al cortar es la forma de los segmentos, y por eso se corta después de medir |
| 2026-10-07 | **concepto de materiales y mecanismo (técnico, de la sesión)**: chapas de acero 1/4" a láser; rodillo motriz de acero torneado fijo a un eje que gira; rodillo loco de cuatro 608 rescatados en varilla de impresora; fricción + GT2 20:80; ESP32; estructura de tubo 20 × 20 con vigas compuestas (tubo + planchuela de canto) en la viga sur y el brazo; mesa en H + A; rodillos a 50 cm | aluminio 5 mm con rodillo PETG; varilla roscada; rodillo de poliuretano; engranajes y correas de casetera; marco de planchuela de canto | el PETG fluye y el acero marca el aluminio; la varilla repite su error cada minuto; la goma se estira; los engranajes rescatados tienen juego y paso desconocido. Grado `probable` (cálculo): `docs/12` y `docs/13`. **No son planos**: ningún número es para cortar hasta medir el centro de masa |
| 2026-10-07 | **no hay planos de fabricación en la fase 0** | planos por capa «no para cortar» | **fuente: Fran, 2026-10-07**: «planos sólo si hay partes del diseño aprobadas; si no, sigamos las fases NASA». Lo aprobado es la arquitectura, no las medidas |
| 2026-10-07 | ~~**un 12" futuro no se diseña hoy**~~ — **reemplazada** por la de abajo, el mismo día | dimensionar todo para un 12" | **fuente: Fran, 2026-10-07**: «quizás algún 300 mm, no sé cuál ni qué modelo» |
| 2026-10-07 | **la misma plataforma lleva el 200 y un dobson de 300 mm** (cualquiera de la envolvente, GoTo incluido): **mesa universal** con corredera norte-sur y posiciones marcadas; chapas, rodillos, motor y base únicos; chapa de **5/16"** | U0 (otras chapas y otra mesa para el 300), U2 (una placa por telescopio), U3 (corredera en el pivote: no cumple la cinemática) | **fuente: Fran, 2026-10-07** (duodécima sesión): «necesidad fundamental»; «correr y apretar»; «debe servir para ambos, aunque aumente la complejidad, no perdamos precisión». El estudio: `docs/14-concepto-300mm.md`; los requisitos: `10` v0.2 (N-12, L0-15, L1-27 a L1-30, L2-PLT-14 a 16). **Abierto:** la transmisión (fricción, correa dentada de Kevin o varilla) espera el 30/60 s |
| 2026-10-07 | **el dobson se toma del borde, sin agujerear**: tres mordazas con pisador sobre los rieles de la corredera, una posición marcada por telescopio | 4 bulones con buje y mariposa fresados en la base (v9); agujerear el 300 | **fuente: Fran, 2026-10-07**: «el dobson no se agujerea de ser posible; quizás sea mejor algo adaptable». Requisito L2-PLT-17; concepto en `docs/14` §5b. **Transmisión propuesta por la sesión: F** (rodillo torneado por fricción), respaldo T2 (tornillo de bolas comprado); la rosca torneada que preguntó Kevin no conviene (`docs/14` K9). Se cierra con el 30/60 s y los pesos de Fran |
| 2026-10-04 | **soporte de cámara intercambiable**: la Sony en foco primario y el celular afocal, con dos adaptadores sobre la misma base | elegir una sola cámara ahora | **fuente: Fran, 2026-10-04.** No se cierra ninguna puerta antes de medir si el tubo llega a foco (R1). Precio aceptado: dos configuraciones de centro de masa que balancear, y más diseño 3D |

## 7. Verificación

**Cómo se verifica cada entregable:**

| Entregable | Se verifica contra | Con qué |
|---|---|---|
| masa y centro de masa | **dos métodos independientes** que tienen que coincidir dentro de la tolerancia | pesada en dos puntos, y composición de las masas de las piezas |
| requisitos (borrador en la fase 0, línea base en la 1) | INCOSE GtWR + la traza (cada hijo con un padre del nivel de arriba, cada necesidad baja) + los atributos de NASA | `python docs/verificar-requisitos.py`, que llama a `verificar-requisito.py --idioma es`; corre en `chequeo-completo.ps1` |
| geometría de los sectores | las fórmulas paramétricas, recalculadas con los números medidos | chequeo que compara el DXF emitido contra la fórmula |
| la plataforma armada | el requisito de deriva | foto de una estrella en un sub del largo pedido: redonda o rayada |
| la montura reformada | el CoM pedido | se re-mide, no se supone |

**Qué se registra de cada verificación:** qué se midió, con qué instrumento,
la tolerancia del instrumento, en qué difiere de la condición real (de día vs
de noche, con cámara vs sin cámara), y **la lista de lo que quedó fuera de
tolerancia** — esa última parte es la que siempre se omite.

**El verificador, ¿alguna vez falló?** Sí, a propósito: `probar-geometria.js`
tiene sus sabotajes, y `verificar-requisitos.py --autotest` rompe nueve
veces el documento (padre inexistente, nivel salteado, huérfano, método,
estado, tipo, necesidad que no baja, ID repetido, enunciado inverificable) y
exige ver cada rojo **por su motivo** (2026-10-07). Escribirlo destapó además
que el chequeo del GtWR era ciego a las tildes del español: se arregló en la
herramienta, con su prueba en rojo antes.

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
