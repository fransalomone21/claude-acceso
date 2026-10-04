# Estado actual — Automatización del telescopio 200/1200

**Última actualización:** 2026-10-04

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Concebir (Pre-Fase A, *Concept Studies*) | **en curso**, abierta el 2026-10-04 |
| 1 — Requisitos y presupuesto de error | sin empezar |
| 2 — Reforma de la montura | sin empezar |
| 3 — Diseño detallado de la plataforma | sin empezar |
| 4 — Construir, integrar y probar | sin empezar |
| 5 — Operar (la foto) | sin empezar |

**Qué cierra la fase en curso:** los tres números que mandan medidos (masa
total, centro de masa 3D, ¿llega a foco la cámara?), el inventario sin
ninguna fila en `?`, y **una** arquitectura de plataforma elegida en un trade
study con los pesos puestos por Fran y un ganador que no empata.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| El telescopio es un newtoniano de 200 mm de apertura y 1200 mm de focal (f/6), con buscador integrado al tubo | lo dice Fran, dueño del equipo | 2026-08 |
| La montura es una dobson de madera de diseño propio, con base fija, base móvil sobre tres tacos de PVC y disco de vinilo, cuatro paredes y caja sujetadora con tornillos de presión sobre retazos de goma | descripción de Fran, consistente entre dos sesiones | 2026-10-04 |
| Las paredes flexan: separación 37 cm abajo y 36 cm arriba | medido en 2026-08 | 2026-08 |
| **El CS (segmentos circulares) no admite apoyo real en tres puntos y es el de menor capacidad de carga de los diseños utilizables**; el VNS da tres puntos, transmisión de peso más directa y más carga — y hay un VNS construido que lleva **45 kg** | lectura de la referencia canónica (Reiner Vogel y BAA), ver `docs/04-conceptos.md` | 2026-10-04 |
| Un brazo tangencial **sin** corrección de tangente anda bien sólo 5 a 10 minutos | misma fuente | 2026-10-04 |
| En el hemisferio sur no hay estrella polar útil: σ Octantis es magnitud 5,4 y está a 1° 8' del polo | misma fuente | 2026-10-04 |
| Existe trabajo de CAD previo: 22 piezas SolidWorks, 2 DXF de plantilla y un macro VBA de 1571 líneas que genera la geometría CS y emite los DXF él mismo | los archivos están en `cad/`, contados | 2026-10-04 |

## Lo que es hipótesis

> Todo lo de abajo viene de la sesión de 2026-08, que trabajó **sin
> arquitectura ni mediciones**. No se tira: se marca. Un número heredado es
> una hipótesis aunque esté escrito con dos decimales.

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| masa total del conjunto ≈ 45 kg (en 2026-08) / ≈ 50 kg (estimación de Fran hoy) | P4.1 del protocolo de medición | nunca hubo balanza |
| centro de masa a 59 cm sobre el piso de la base móvil | P1+P2+P3 compuestos, verificados con P4 | ídem. **Y hay una inconsistencia a resolver:** el mismo documento de 2026-08 usa 59 cm sobre la base móvil y `H = 64 cm` sobre la tabla de la plataforma. Se reconcilian con los 5 cm del sándwich de bases, pero eso nunca se escribió y el macro VBA usa 64 |
| las medidas de geometría de 2026-08 (tubo 25 × 135,5 cm; base fija 40 × 43; base móvil 40,5 × 37,5; paredes 82 × 37,5 y 37,5 × 20; eje de altura a 78 cm; caja 40 × 31) | re-medición en P1-P3, con el método anotado | se declararon «medidas, no estimadas» pero **sin anotar con qué ni cómo**; una cita heredada sin método es una hipótesis |
| todos los parámetros de diseño de 2026-08 (radios 48,3 y 72,0 cm; recorridos ±6,3 y ±9,5 cm; tabla móvil 50 × 50; base fija 70 × 50; carrera ±7,52°) | recalcularlos con la masa y el CoM medidos, **y sólo si gana CS en el trade study** | se derivaron de `H = 64 cm`, que es una estimación |
| la placa **HW-130** es un driver de motores paso a paso | la foto de la serigrafía de los dos lados (P6, foto 7) | nunca se leyó la placa. `probable` que sea una **fuente para protoboard**, no un driver — en ese caso falta el driver y es una compra |
| los rulemanes son 608ZZ | medir el diámetro exterior: 22 mm → 608 | lo dijo Fran de memoria («creo que M8») |
| la cámara es una Sony ZV-E10 | confirmarlo con el cuerpo en la mano | lo anotó la sesión de 2026-08 y hoy Fran dijo «una cámara Sony» sin modelo |
| el 200/1200 **llega a foco** con una cámara en foco primario | P0 del protocolo, diez minutos de día | falla clásica de los newtonianos, y nunca se probó. **Es el riesgo más barato de cerrar y el más caro de ignorar** |
| las expectativas de resultado de 2026-08 (0,67 arcsec/píxel, subs de 20-30 s sin guiar, 2-4 min guiando) | el presupuesto de error de la fase 1, y después la medición de deriva de la fase 4 | se escribieron como predicción y conviene que no se citen como hecho |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| elegir la arquitectura CS por el argumento «es la única que deja poner el eje polar en el centro de masa» | el argumento es **falso como exclusividad**: el VNS cumple la misma condición | la decisión se reabre. La ventaja real de CS es sólo que el perfil se traza con un piolín, y eso se cae cuando ya hay un macro que emite el DXF |
| (según los comentarios del macro VBA) manipular sketches de SolidWorks por nombre con `SelectByID2`, y cerrar sketches 3D con `InsertSketch` | falló por idioma y por el toggle de `Insert3DSketch` | el macro ya tiene las seis correcciones escritas en su encabezado. Si se reusa, se reusan |

## Lo próximo

Fran mide, pesa y fotografía según `docs/02-protocolo-medicion.md`, arrancando
por **P0 (¿llega a foco?)**, que es go/no-go de diez minutos. En paralelo
llena `docs/03-inventario.md`. Con eso la sesión arma el modelo 3D y recién
después se corre el trade study CS vs VNS con los pesos de Fran.
