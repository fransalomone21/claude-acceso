# Estado actual — Clase Asincrónica 3 (Teoría de Circuitos, UNSAM)

**Última actualización:** 2026-09-04

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Reconocimiento (enunciados + entorno) | cerrada 2026-09-04 |
| 1 — Construcción de las simulaciones | **cerrada 2026-09-04** |
| 2 — Segunda pasada y redacción | **en curso** |

**Qué cierra la fase en curso:** que estén escritas las respuestas a **dos** de
las cinco preguntas de "Para pensar" (la guía pide dos), y que la carpeta de
entrega esté armada con los `.asc`, sus `.log` y las capturas de las gráficas
que pide el punto 3 del entregable mínimo.

## Qué hay hecho

**Los diecisiete archivos de LTspice**, en `ltspice/`:

- **12 problemas** de la guía: 6.1, 6.2, 6.17, 6.25 · 7.1, 7.4, 7.8, 7.21,
  7.23, 7.25 · 8.1, 8.38.
- **2 hojas de `.op`** (7.1b y 7.8b) que resuelven los estados previos sin
  simular tiempo. No las pide el enunciado; existen para mostrar cuál es la
  herramienta correcta para una pregunta de régimen permanente.
- **3 hojas de segunda pasada** (X1 RL, X2 RC, X3 RLC) con no idealidades y
  valores supuestos declarados, con las cuatro preguntas de la guía contestadas
  adentro de cada archivo.

Cada uno trae, escrito en la hoja como comentarios de LTspice: enunciado,
armado del circuito con el porqué de cada decisión, cada directiva explicada
línea por línea, los cuatro análisis de SPICE, cómo se lee `.tran` / `.ic` /
`.meas`, la receta de la gráfica paso a paso, y el bloque `CONTROL` con los
números calculados **antes** de simular.

El índice, la tabla de calculado-contra-medido y las trampas de LTspice están
en [`ltspice/LEEME.md`](ltspice/LEEME.md).

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| Los 17 circuitos corren sin error ni aviso inesperado | 17 `.log` de LTspice 26.0.1, batch; el único aviso es `Node vc is floating` en el 6.17, que es el circuito del enunciado y está documentado | 2026-09-04 |
| Los 97 controles cierran contra el cálculo a mano dentro del 2 % | `python verificar.py` → `[OK] 97 controles` | 2026-09-04 |
| El verificador **discrimina** | `python probar-verificador.py` → los 5 sabotajes en rojo, control positivo en verde, disco limpio al final | 2026-09-04 |
| `Ceq(a-b) = 6 µF` del problema 6.25 | reducción a mano en 6 pasos **y** medición con `.ac` a 1 kHz: `|Iin| = 37,6991 mA` → 6,0000 µF, idéntica al capacitor equivalente (error 1,8·10⁻¹⁴ %) | 2026-09-04 |
| El estado previo del 7.1 y del 7.8 | `.op` en `P7-01b` y `P7-08b`: V(A)=30 V, I(R2)=15 mA, I(R3)=5 mA; V(n1)=300 V, I(L1)=10 A | 2026-09-04 |
| Una respuesta RLC **sobreamortiguada sí puede cruzar el cero** una vez | tres `t_cruce1` medidos (4,62 / 5,00 / 5,36 ms) y la deducción analítica que los explica | 2026-09-04 |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| `Rser=0` en las bobinas, para apagar el miliohm que LTspice pone solo | `over-defined circuit matrix` en el 6.2 y en el 7.8 — justo los dos donde el default importaba | El cero exacto no sirve: una bobina ideal en paralelo con una fuente de tensión o con otra bobina ideal deja el sistema sin solución única. Va un valor chico **declarado**: `Rser=1u` |
| Diferencia finita `(i(2µs)−i(0))/2µs` para el `di/dt` del 8.38 | −30 A/s en vez de −50 A/s (40 % de error) | El `.ic` de una bobina tiene ~0,1 % de tolerancia, y ese error es del mismo tamaño que el cambio real de corriente en 2 µs. Se usa `DERIV`, en un instante distinto de cero |
| Generar archivos `.plt` con la configuración de paneles | descartado antes de escribirlo | El formato no está documentado y un `.plt` mal armado abre un panel vacío sin decir por qué. No hay forma de verificarlo sin abrir la GUI, así que sería una alarma que nunca salta. La receta va escrita en la hoja |
| Leer los `.raw` binarios del `.op` para verificarlos | los valores salían basura (`nan`, `6e+283`) | LTspice mezcla `double` y `float` en el binario. Se corre con `-ascii` y se leen como texto |

## Lo próximo

Las dos preguntas de "Para pensar" y el armado de la carpeta de entrega. Detalle
en `PDP.md` §4.
