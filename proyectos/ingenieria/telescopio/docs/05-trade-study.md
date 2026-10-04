# Trade study — arquitectura de la plataforma (CS vs VNS)

**Fecha:** 2026-10-04. **Decide:** el apoyo de la plataforma. La transmisión
(rodillo motriz o brazo tangencial) es separable y se decide en la fase 3.
**Insumo:** `docs/04-conceptos.md` (familias y fuentes) y
`docs/geometria-vns.js` (la geometría calculada, con sus controles en
`docs/probar-geometria.js`).

## 1. Los pesos, con su fuente

| # | Criterio | Peso | Fuente |
|---|---|---|---|
| 1 | **changüí**: apoyar en cualquier piso, calibrar sin cortar | 0,4 | **Fran, 2026-10-04**: *«que yo pueda poner la plataforma en donde quiera y hacerla andar, y no estar renegando con calibraciones ni nada, lo menos posible»* |
| 2 | **facilidad de construcción** con sus herramientas | 0,3 | **Fran, 2026-10-04**: *«me interesa que sea no extremadamente complejo»* — y aclaró que calar alrededor de una plantilla impresa o sumar software **no** le parece complejo |
| 3 | capacidad de carga (~50 kg sin flexar) | 0,2 | `inferido` del orden: Fran no lo nombró. **A confirmar** |
| 4 | costo del material a comprar | 0,1 | **Fran, 2026-10-04**: *«si puedo gastar más plata en algo, no importa»* |

Pesos por suma de rangos (4-3-2-1 sobre 10). Desempate escrito por Fran antes
de rankear: *«si es un poco de complejidad extra a beneficio de mejor
performance, vamos a la más compleja»*.

## 2. Los puntajes (1 a 5, los pone la sesión con su razón)

| Criterio | CS | VNS | Por qué |
|---|---|---|---|
| changüí | 2 | 5 | VNS apoya en **tres puntos** (pivote + dos rodillos): no renguea en ningún piso. CS apoya en cuatro (dos rodillos por sector). En VNS, además, el centro de masa se ajusta con suplementos y ranuras sin tocar el aluminio |
| facilidad | 3 | 4 | CS: el perfil se traza con piolín, pero los rodillos van con el eje **inclinado** a la latitud, y esa inclinación hay que clavarla. VNS: el perfil necesita plantilla impresa (el cálculo ya existe), y los rodillos van **horizontales** (Vogel: *rodamientos y motor más simples*) |
| capacidad | 3 | 5 | Vogel: CS sirve para telescopios medianos; su VNS lleva 45 kg medidos |
| costo | 4 | 3 | VNS: 0,25 m² de aluminio 5 mm (≈ $66.000, 2026-10-04) y una base más larga (1,4 m contra 0,7 m) |

## 3. Resultado

| | CS | VNS |
|---|---|---|
| total ponderado | 0,8 + 0,9 + 0,6 + 0,4 = **2,7** | 2,0 + 1,2 + 1,0 + 0,3 = **4,5** |

**Gana VNS por 1,8 puntos.** No empata, y **no depende del orden que falta
confirmar**: VNS es igual o mejor que CS en todo menos el costo, y el costo es
el peso más chico en cualquier permutación de los puestos 2 a 4 (la peor para
VNS, costo segundo con 0,3, da VNS 4,2 contra CS 2,9).

**Coincide con la decisión directa de Fran** del 2026-10-04 (*«sí, vamos con
el VNS»*), que se tomó después de leer la comparación de `04-conceptos.md`.

## 4. Lo que el VNS cuesta y se aceptó, escrito antes de construir

1. **El largo.** A 34,5° el eje polar va muy acostado y el pivote queda lejos:
   con el centro de masa a 64 cm sobre la mesa, el pivote está **0,96 m** al
   norte del centro y la base mide **≈ 1,41 m**. Es geometría
   (`y_pivote = H / tan φ`), confirmado por cálculo con H todavía `hipótesis`.
   Se acorta levantando el pivote en un poste: cada 10 cm de poste, ≈ 14,5 cm
   menos de base (con 20 cm de poste: 1,12 m). **Pendiente de Fran:** si el
   largo le sirve para guardarla y llevarla.
2. **La velocidad no es constante.** Varía **±0,31 %** a lo largo de ±45 min
   (calculado; Vogel da < ±1 %). Se corrige en el firmware, en el mismo lugar
   que la corrección de tangente si gana el brazo tangencial.
3. **Corrimiento lateral sobre el rodillo:** ±8,7 mm (±45 min). El rodillo
   tiene que tener ≥ 25 mm de ancho y el canto de la chapa redondeado.
4. **El aluminio blando.** La chapa suelta que se consigue es Aluar 1050:
   rodillo de plástico duro, no de acero. 6061 o 5052 si aparecen.

## 5. Qué falta para que esta elección cierre la fase 0

- la masa y el centro de masa **medidos** (P1-P4 del protocolo): mueven el
  largo y la forma de los segmentos, no la elección;
- el puesto 3 (capacidad de carga) confirmado por Fran — no cambia el ganador.
