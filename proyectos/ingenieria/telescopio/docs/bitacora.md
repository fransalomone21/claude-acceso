# Bitácora — Automatización del telescopio 200/1200

Cómo se llegó a cada cosa, y qué se probó y falló. **No se lee al abrir**: se
lee cuando hace falta saber el porqué de algo.

---

## 2026-10-04 — El proyecto se reabre como proyecto de ingeniería

**Qué había.** Una carpeta `telescopio` en estado `dormido`, con un `CLAUDE.md`
que describía un diseño CS completo (radios, recorridos, transmisión) bajo el
título «Parámetros de diseño ya cerrados», 22 piezas de SolidWorks, dos DXF de
plantilla y un macro VBA de 1571 líneas. Sin PDP, sin `ESTADO_ACTUAL`, sin
`HANDOFF` — o sea, sin fase y sin criterio de salida.

**Qué se encontró al auditarlo.**

1. Los «parámetros cerrados» se derivaron de `H = 64 cm` (centro de masa sobre
   la tabla) y de una masa de 45 kg. **Las dos son estimaciones sin medición.**
   Todo lo que cuelga de ahí —los dos radios, los recorridos, el largo de los
   sectores, la tabla de 50 × 50— es predicción escrita como hecho, y el macro
   VBA la copió a sus constantes. Es exactamente el modo de falla de «una
   predicción escrita como un hecho contamina cada documento que la copia».
2. **Una inconsistencia que nadie reconcilió por escrito:** el mismo documento
   dice centro de masa a 59 cm sobre el piso de la base móvil y `H = 64 cm`
   sobre la tabla de la plataforma. Cierran con los 5 cm del sándwich de
   bases, pero eso estaba sobreentendido, y el macro usa 64.
3. Las medidas de geometría se declaraban «medidas, no estimadas», pero **sin
   decir con qué ni cómo**. Una cita heredada sin método es una hipótesis.

**El hallazgo que cambia una decisión.** La arquitectura CS se había elegido
con este argumento: *es la que permite poner el eje polar exactamente en el
centro de masa*. La referencia canónica de diseño de plataformas (Reiner
Vogel, y la BAA) dice otra cosa: la condición de tener el centro de masa sobre
el eje polar **la cumplen todos los diseños** —es la condición de diseño, no
una propiedad de CS— y el CS es justamente el que **no admite apoyo real en
tres puntos** y el de **menor capacidad de carga** de los utilizables. El VNS
(sectores norte verticales) da los tres puntos, transmite el peso más directo
al piso y tiene más carga: hay uno construido que lleva **45 kg**, con el
conjunto de Fran estimado en **50**.

La única ventaja real de CS es que el perfil se traza con un clavo y un
piolín. Y ese argumento se cae solo cuando ya existe un macro que emite el DXF
1:1: el perfil elíptico del VNS cuesta lo mismo que el circular si lo dibuja
una máquina.

**Qué se decidió.** La elección de arquitectura se reabre y pasa a trade study,
con los pesos de Fran, **después** de medir la masa. Los números de 2026-08
bajan a `hipótesis` y quedan escritos como tales. Nada se borró.

**Qué se construyó hoy.** `PDP.md` con seis fases y criterio de salida de la
fase en curso (mapeado a CDIO y a las fases NASA), `ESTADO_ACTUAL.md`,
`HANDOFF.md`, y cuatro documentos: el ConOps (`01`), el protocolo de medición
(`02`), el inventario por nombre (`03`) y el catálogo de conceptos con sus
fuentes (`04`). El enrutador de `claude-acceso` pasó la fila de `dormido` a
`ACTIVO`. Se agregó `~$*` al `.gitignore`: los archivos de bloqueo de
SolidWorks no son contenido, y había uno suelto sin trackear.

**Por qué el protocolo de medición mide el tubo y la montura por separado y no
el conjunto.** Porque el centro de masa del conjunto **es función del ángulo
de altura del tubo**: no hay un centro de masa, hay una curva. Midiendo el
tubo solo (masa + punto de equilibrio) y el resto de la montura solo, la curva
se calcula para cualquier ángulo y nunca hay que inclinar 50 kg. El conjunto
completo se pesa igual, pero como **control** de la composición: dos métodos
que coinciden valen, uno solo es una esperanza.

**El riesgo más barato del proyecto, y estaba sin disparar.** Nunca se probó
si el 200/1200 **llega a foco** con una cámara en foco primario. Es la falla
clásica de los newtonianos (el sensor queda más lejos del espejo de lo que el
focuser puede meterse) y si pasa, cae la rama entera de foco primario. Cuesta
diez minutos de día apuntando a una antena. Por eso es la medición **P0**, la
primera de todas, antes de cualquier peso.
