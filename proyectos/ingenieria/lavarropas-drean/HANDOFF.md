# Handoff — lavarropas-drean

**Escrito el:** 2026-09-21 · **Fase al cerrar:** 0 cerrada, 1 abierta

## Arrancá por acá

**Preguntarle a Fran los resultados de T1 a T7.** La fase 1 no la puede cerrar
ninguna sesión sola: la máquina está en su casa. Si todavía no los corrieron,
la respuesta correcta es decirlo, no suponerlos ni avanzar a la fase 2.

Los tests están en [`docs/guia-reparacion.md`](docs/guia-reparacion.md) §2.

## Lo que quedó a medias

Nada tocado a medias. El proyecto nació hoy: PDP, contrato, estado, guía y
bitácora quedaron completos y commiteados.

Lo que quedó **abierto a propósito**: los cinco renglones de hipótesis de
`ESTADO_ACTUAL.md`. Los cinco se resuelven con la máquina delante, ninguno
desde acá.

## Lo que NO hay que volver a intentar

- **Buscar en internet las medidas exactas de rodamiento del Next 6.06.** Se
  intentó: el kit específico existe pero su ficha no se pudo leer (dominio que
  no resuelve, yoreparo devuelve 403). Lo que sí se leyó es de la línea
  **Blue / Excellent 6.06** (6203 + 6204 + retén 25×47×8/11,5). Gastar otra
  sesión en confirmarlo por web es pagar por algo que el rulemán viejo contesta
  gratis y mejor.
- **Recomendar comprar el kit "por modelo" desde una publicación.** Es la
  falla del dominio y ya está escrita como regla 1 del contrato.

## Datos que no se pueden aproximar

- Modelo: **Drean Next 6.06 ECO**. 220 V – 50 Hz – **1700 W** – IPX4 –
  **600 rpm** – capacidad **6 kg**. Fabricado por Drean S.A., Av. Córdoba 325,
  Luque, Córdoba. Industria argentina.
- Etiqueta de eficiencia: IRAM 2141-3:2017 · clase **A+** · **0,42 kWh** ·
  **52 litros** · **180 min** por ciclo normal de algodón.
- Rodamientos candidatos (grado `probable`, línea Blue/Excellent 6.06):
  **6203-2RS** = 17 × 40 × 12 mm · **6204-2RS** = 20 × 47 × 14 mm ·
  **retén** = 25 × 47 × 8 / 11,5 mm (SAV 11140).
  Los Drean de **8 kg y más** llevan **6204 + 6205** — no es este caso.
- Precio de referencia del kit, septiembre 2026: **$18.000 – $21.000**.
- El tornillo central de la polea tiene **sellador verde** (trabaquímico):
  esperar que cueste, y no golpear la polea de plástico.

## Si hay que abrir un chat nuevo

```
Proyecto: lavarropas-drean (claude-acceso, proyectos/ingenieria/).
Leer en orden: ESTADO_ACTUAL.md entero, PDP.md seccion 4, y
docs/guia-reparacion.md seccion 2. No leer la bitacora salvo que haga falta
saber que ya se probo.

Fase 1 abierta (Diagnostico medido). La cierra: anotados T1 a T7 y al menos
una causa descartada por un test NEGATIVO.

Modelo: Sonnet si es solo cargar los resultados de los tests y decidir con la
tabla ya escrita. Opus si los resultados son contradictorios o aparece algo
que la tabla de causas no cubre. Esfuerzo medium, sin fan-out: es un solo
hilo y la superficie es chica.

Lo ya resuelto y que NO hay que rehacer: el modelo esta identificado, la guia
esta escrita y verificada, y las medidas candidatas de rodamiento estan
anotadas con su grado en HANDOFF.md. Buscar las medidas del Next 6.06 por web
ya fallo: se resuelven con el ruleman viejo en la mano.

Primer paso: preguntarle a Fran el resultado de T1 a T7. Si no los corrio,
decirlo y no avanzar a la fase 2.
```
