# Inventario — qué hay, en qué estado, y el modelo exacto

**Una enumeración no es un inventario.** Que el diseño dependa de si existe
una pieza y la pieza esté nombrada de memoria («una placa que creo que es un
driver») es el error más caro de esta etapa: se diseña sobre algo que no está
y se descubre cuando ya se cortó la madera.

Por eso esta tabla pregunta **por nombre**. La fase 0 cierra cuando no queda
ninguna fila en `?`.

Estado: `tengo` / `tengo pero no sé el modelo` / `no tengo` / `?` (sin revisar).

---

## Lo que bloquea una medición (estas tres primero)

| # | Pieza, por nombre | Por qué bloquea | Estado | Modelo / dato |
|---|---|---|---|---|
| B1 | **balanza**, con su rango y su resolución | sin saber hasta cuánto pesa y de cuánto en cuánto, P1 a P4 del protocolo no se pueden planificar | `?` | |
| B2 | **adaptador de la Sony al focuser**: anillo T2 de montura E + adaptador T2 a 1,25" o 2" | sin esto la medición P0 (¿llega a foco?) no se puede hacer | `tengo pero no sé el modelo` | **impreso en 3D** por Kevin; entra en el portaocular y queda fijo (Fran, 2026-10-04). Falta: ¿qué diámetro (1,25" o 2")? ¿la cámara va sin su lente? |
| B3 | **cinta métrica y calibre** | las tolerancias de ±1 mm los piden | `?` | |

## Mecánica

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| M1 | **rulemanes**: cuántos y qué número grabado (¿`608ZZ`? exterior 22 mm) | `?` | |
| M2 | **varilla roscada M8** y su largo útil; tuercas M8 | `?` | hay una **varilla guía lisa de ≈ 8 mm** en la impresora desarmada (fotos 45, 54): sirve de eje de rodillo |
| M3 | **resorte** de precarga, cualquiera que estire | `no aplica` | el VNS apoya por gravedad: no lleva precarga (diseño de 2026-10-04, `05-trade-study.md`) |
| M4 | **multilaminado**: espesores que hay y medida de los retazos | `no aplica` como estructura (la mesa y la base son de hierro, `09-estructura-hierro.md`); sirve de **suplemento** bajo el dobson | los retazos que haya alcanzan |
| M5 | **correa GT2** y poleas (para 4:1 hacen falta dos, tipo 20 y 80 dientes) | `?` | |
| M6 | **engranajes** recuperados de las videograbadoras: cuántos, de qué paso | `no aplica` | la reducción es una correa GT2 20:80, no engranajes |
| M7 | **tornillería**: bulones largos, arandelas, tuercas mariposa | `?` | hacen falta 4 **mariposas M8** y 4 bulones M8 fresados para fijar el dobson (paso 5 del Paso a paso) |
| M8 | **caño** del que salieron los tacos de PVC: ¿sobra? diámetro | `no aplica` | los bujes de la fijación del dobson salen de cualquier tramo de caño |
| M9 | **teflón o PTFE** en plancha, o el disco de vinilo de repuesto | `no aplica` | el pivote es una rótula en un cono engrasado, sin teflón |

## Electrónica

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| E1 | **Arduino Nano**: ¿original o clon? ¿chip USB CH340 o FT232? | `?` | |
| E2 | **la placa HW-130**: hay que leer la serigrafía de los dos lados. `probable` que **no** sea un driver de motores sino una **fuente para protoboard** (5 V / 3,3 V) de la familia MB-102 / HW-131. Si es eso, **falta el driver** y es una compra | `?` | |
| E3 | **driver de stepper** de verdad: ¿A4988? ¿DRV8825? ¿TMC2208 / TMC2209? | `?` | |
| E4 | **motores paso a paso**: cuántos, y la etiqueta de cada uno. Los de impresora suelen ser NEMA 17; los de videograbadora son chicos y casi seguro **no alcanzan** | `no tengo` — se compra un NEMA 17 de **≈ 4 kg·cm** (1,7 A, 40 mm; recomendado: Usongshine tipo 17HS4401, $24.640 en Mercado Libre FULL, 2026-10-05). El de 1,6 kg·cm (17HS2408S, $18.200) deja 2,6× de margen contra una ráfaga de 40 km/h y se descartó; ver `07-guia-armado.md` §5.4. Antes se había anotado ≈ $49.900 por uno de 7 kg·cm: sobraba | en la impresora: **Mitsumi M28N-1** (P/N C6409-60004, HP), `probable` de continua con encoder (fotos 48, 51). En la **casetera** (2026-10-05, 3 fotos de Fran): un **Sankyo** de cabrestante, chato, con cuatro terminales marcados **− + H L**, y un **SHU2L-00-2X24A** (el de las bobinas o del mecanismo). Los dos son **de continua** (`probable`: el «H L» es la selección de velocidad normal / doble del regulador interno, que es lo típico de los motores de cabrestante). **No sirven para seguir:** giran a miles de rpm con un regulador de ±1 % que deriva con la temperatura, y el seguimiento pide ≈ 0,1 rpm en el motor y mucho mejor que 1 % (1 % de error son ≈ 5″ en 30 s de exposición, siete píxeles de la Sony). De la casetera sí se pueden rescatar las **correas de goma** y los **resortes** (M3) |
| E5 | **fuente 12 V**: cuántos amper | `?` | |
| E6 | **tester UT89X** | `tengo` | UT89X |
| E7 | **protoboard y cables** | `tengo` | |
| E8 | **finales de carrera**: hacen falta **2** microswitches con palanca de rodillo (tipo KW12), uno por punta (diseño del 2026-10-04: segunda capa de límite, ver guía §3) | `?` | ¿hay de alguna impresora vieja? |

## Óptica y cámara

> **Aparcado a pedido de Fran (2026-10-05):** nada de esta sección se
> completa por ahora. **No cuenta como cerrado:** la fila B2 y P0 siguen
> abiertas en el PDP, y P0 es **compuerta antes de comprar la chapa de
> aluminio** (`11-paso-a-paso.md`).

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| O1 | oculares 5 / 10 / 25 mm: marca y si son de 1,25" o 2" | `?` | |
| O2 | la **cámara Sony**: modelo exacto (en 2026-08 se anotó ZV-E10, confirmar) | `tengo` (es de Kevin) | **ZV-E10 con el 16-50**, `probable`: foto de catálogo que mandó Kevin el 27/4 diciendo «esta compré». Se confirma con el cuerpo en la mano |
| O3 | el **celular**: S21 o S24 Ultra, el que se vaya a usar | `?` | |
| O4 | **buscador** integrado al tubo: aumento y si sale | `tengo pero no sé el modelo` | chico y recto, tubo de ≈ 2,5 cm, pie pegado con masilla al tubo (fotos 28, 32, 64): no sale sin romper. Falta: aumento |
| O6 | **portaocular** | `tengo pero no sé el modelo` | **helicoidal (a rosca), 1,25"**, ≈ 4,5 cm de alto (fotos 59-63, 69-70). Falta: cuántos mm sube de punta a punta |
| O5 | cable de disparo o app para la Sony (el obturador se dispara por el Multi/Micro USB) | `?` | |

## Herramientas y taller

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| T1 | amoladora, caladora, agujereadora, atornilladora | `tengo` (lo dijo Fran) | |
| T5 | **soldadora** (tipo: electrodo o MIG) | `tengo` (Fran, 2026-10-05: «las planchuelas se sueldan») | falta el tipo; la receta de `09-estructura-hierro.md` vale para las dos |
| T2 | **escuadra** grande y **nivel** | `?` | |
| T3 | **impresora 3D**: ¿propia, prestada o tercerizada? material | `tengo` (prestada) | un amigo de Kevin, con varias impresoras, algunas de calidad mejor que las comunes (Fran, 2026-10-04). Falta: material (PLA/PETG) y volumen de impresión |
| T4 | **SolidWorks**: versión instalada, y si corre macros VBA | `?` | |

---

## Lo que ya se sabe que hay que comprar (salvo que el inventario diga otra cosa)

| Qué | Por qué | Cuándo se decide |
|---|---|---|
| driver de stepper decente (TMC2208/2209) | el A4988 hace ruido y pierde micropasos; el seguimiento es un movimiento lento y continuo, que es justo donde el TMC gana | fase 3, con el BOM |
| multilaminado de 18 mm para la mesa y 12 mm para la base | si no hay retazos del tamaño | fase 3 |
| rulemanes 608ZZ si faltan | son baratos y son el estándar del armado | fase 3 |

Nada de esto se compra antes de la fase 3: el BOM sale **después** de elegir
la arquitectura, no antes.
