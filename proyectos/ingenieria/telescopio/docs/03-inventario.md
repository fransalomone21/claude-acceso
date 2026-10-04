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
| M2 | **varilla roscada M8** y su largo útil; tuercas M8 | `?` | |
| M3 | **resorte** de precarga, cualquiera que estire | `?` | |
| M4 | **multilaminado**: espesores que hay y medida de los retazos | `?` | |
| M5 | **correa GT2** y poleas (para 4:1 hacen falta dos, tipo 20 y 80 dientes) | `?` | |
| M6 | **engranajes** recuperados de las videograbadoras: cuántos, de qué paso | `?` | |
| M7 | **tornillería**: bulones largos, arandelas, tuercas mariposa | `?` | |
| M8 | **caño** del que salieron los tacos de PVC: ¿sobra? diámetro | `?` | |
| M9 | **teflón o PTFE** en plancha, o el disco de vinilo de repuesto | `?` | |

## Electrónica

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| E1 | **Arduino Nano**: ¿original o clon? ¿chip USB CH340 o FT232? | `?` | |
| E2 | **la placa HW-130**: hay que leer la serigrafía de los dos lados. `probable` que **no** sea un driver de motores sino una **fuente para protoboard** (5 V / 3,3 V) de la familia MB-102 / HW-131. Si es eso, **falta el driver** y es una compra | `?` | |
| E3 | **driver de stepper** de verdad: ¿A4988? ¿DRV8825? ¿TMC2208 / TMC2209? | `?` | |
| E4 | **motores paso a paso**: cuántos, y la etiqueta de cada uno. Los de impresora suelen ser NEMA 17; los de videograbadora son chicos y casi seguro **no alcanzan** | `?` | |
| E5 | **fuente 12 V**: cuántos amper | `?` | |
| E6 | **tester UT89X** | `tengo` | UT89X |
| E7 | **protoboard y cables** | `tengo` | |
| E8 | **finales de carrera**: hacen falta **2** microswitches con palanca de rodillo (tipo KW12), uno por punta (diseño del 2026-10-04: segunda capa de límite, ver guía §3) | `?` | ¿hay de alguna impresora vieja? |

## Óptica y cámara

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| O1 | oculares 5 / 10 / 25 mm: marca y si son de 1,25" o 2" | `?` | |
| O2 | la **cámara Sony**: modelo exacto (en 2026-08 se anotó ZV-E10, confirmar) | `tengo` (es de Kevin) | **ZV-E10 con el 16-50**, `probable`: foto de catálogo que mandó Kevin el 27/4 diciendo «esta compré». Se confirma con el cuerpo en la mano |
| O3 | el **celular**: S21 o S24 Ultra, el que se vaya a usar | `?` | |
| O4 | **buscador** integrado al tubo: aumento y si sale | `?` | |
| O5 | cable de disparo o app para la Sony (el obturador se dispara por el Multi/Micro USB) | `?` | |

## Herramientas y taller

| # | Pieza, por nombre | Estado | Modelo / dato |
|---|---|---|---|
| T1 | amoladora, caladora, agujereadora, atornilladora | `tengo` (lo dijo Fran) | |
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
