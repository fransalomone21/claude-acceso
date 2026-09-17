# ESTADO ACTUAL — arquitectura-se

**Fase 5 CERRADA** el 2026-09-17. Cerró por lo que la cerraba: **documento de
arquitectura + matriz de cumplimiento, con trade study explícito**. Los tres
artefactos están en `docs/`. **No se tocó ningún archivo vivo.** **Abre la
fase 6** (migrar).

**Es la primera fase de diseño del proyecto.** Las 0-4 fueron de lectura y
están cerradas; los cuatro libros están leídos y medidos.

## Dónde está todo

| Qué | Dónde |
|---|---|
| **El diseño: 10 piezas P1-P10 contra 14 defectos medidos** | `docs/arquitectura.md` |
| **Por qué esta arquitectura y no otra** | `docs/trade-study.md` |
| **El molde de matriz, el selector de rigor y la instancia llenada** | `docs/matriz-cumplimiento.md` |
| Los 10 requisitos A1-A10, como texto medible | `docs/requisitos.txt` |
| Destilados del handbook NASA (17 tramos) | `perfil-global/pilares/nasa-seh/` |
| Ficha del INCOSE GtWR (41 reglas) | `perfil-global/pilares/incose-gtwr/reglas.md` |
| Chequeo de requisitos | `perfil-global/pilares/incose-gtwr/verificar-requisito.py` |
| Ficha del INCOSE SEH 5.ª ed. — el mapeo | `perfil-global/pilares/incose-seh/mapeo-15288.md` |
| Ficha de Rechtin & Maier — las heurísticas con caso propio | `perfil-global/pilares/rechtin-maier/heuristicas.md` |
| Medidor de fidelidad de citas (sirve para los **cuatro** libros) | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| Las **10** fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## La arquitectura elegida, en una línea

**Catálogo de reglas derivado de sus archivos fuente + matriz de cumplimiento
por proyecto, con el rigor declarado por ASPECTO y no por proyecto.**

Las diez piezas: **P1** catálogo con el porqué de cada regla · **P2** la matriz
(tres estados, default silencio, la resta escrita al recortar) · **P3** el
selector de rigor de dos ejes (reversibilidad × incertidumbre), por aspecto ·
**P4** el molde de fase con *cómo se certifica* y con la salida *cancelar* ·
**P5** las heurísticas pegadas a los pasos en vez de inyectadas enteras ·
**P6** el criterio de **entrada** al registro de lecciones · **P7** la
separación System 2 / System 3 · **P8** la revisión independiente, declarada
sin respuesta · **P9** se elige el corte de NASA sobre el de INCOSE, con la
resta escrita · **P10** el medidor de validación, diseñado acá y construido en
la fase 7.

**Lo que NO cambia** —y esto es la mitad del diseño—: la cascada de seis
niveles, las tres naturalezas, las cuatro reglas de la estructura, las tres
capas de frenos, los cuatro saboteadores, los dos cuadros y el enrutado de
modelo y esfuerzo. Cada uno entra al catálogo con su impacto original escrito,
que era el criterio mandatorio M2.

## Medido, no supuesto

- **El trade study salió inconcluso en la primera pasada** —A 610 contra
  B 630, sobre un máximo de 900— y eso disparó la regla de Rechtin p. 402: se
  rehacen **los criterios**, no el estudio. El defecto estaba en la definición
  de C1, que medía *cuánto cambia* cada alternativa en vez de *cuánto cuesta
  operar la que resulte* — y cualquier criterio que premie la quietud le da el
  máximo al statu quo antes de mirar si el statu quo es caro. Con la definición
  corregida y **sin tocar un solo peso**: B 810, A 430, C 400.
- **El ranking es robusto**, probado contra la única incertidumbre grande (C1
  de B es predicción, no medición): aun en el peor caso posible B gana por 140
  puntos. Por lo tanto reducir esa incertidumbre ahora no es *net beneficial*
  (NASA p. 166); se difiere a la fase 7, que es la que la mide.
- **D14, descubierto midiendo, no leyendo.** `verificar-requisito.py` corrido
  sobre los 10 requisitos de la arquitectura dio **10 VIOLA y 3 REVISAR**, y
  los **13 son falsos positivos de idioma**: R1 exige el literal inglés `shall`
  y los diez dicen «debe». Control positivo: el mismo requisito traducido da
  **0 VIOLA**. Del otro lado, un enunciado deliberadamente malo da **2**
  violaciones en español y **6** en inglés. Su señal en español es nula en las
  dos direcciones.
- **La matriz de este proyecto: 38 filas, 28 cumple, 3 recortadas, 7 «no
  aplica — todavía».** Las tres recortadas no eran visibles antes de escribirla.
- `python perfil-global/pilares/fuentes/medir.py` → **10/10 OK**.

## Lo que la fase 5 encontró, y manda a la fase 6

- **D14 es nuevo y toca una herramienta viva.** El arreglo **no** es traducir
  los requisitos —eso reintroduce D12— sino agregarle al chequeo las listas del
  GtWR en español, con la misma estructura de dos severidades. **Condición de
  aceptación ya escrita**: 0 VIOLA sobre A1-A10 **y** 6 VIOLA sobre el
  enunciado malo. Sin la segunda mitad, el arreglo puede ser apagar R1.
- **La resta del gasto de la fase 0 sale negativa.** Escribirla como fila de
  matriz obligó a decidir algo que el `PDP.md` §5 dejaba en "ya pasó": 2,07 M
  tokens y un límite de 5 h en 6,6 minutos **no fueron tailoring, fueron un
  error**. La diferencia entre las dos cosas es lo que la columna de
  justificación obliga a contestar.
- **`ingenieria-de-sistemas.md` contrastado contra los libros** (era parte de
  esta fase). Cinco cosas bien, **cuatro mal**: atribuye el tailoring a NPR
  7150.2 (clases A-F **de software**) cuando está en el cap. 3.11 (tipos A-F
  **de proyecto**); **omite la Compliance Matrix entera**, que resultó ser el
  hallazgo que manda la reforma; omite la distinción *tailor/customize*; y
  gradúa el rigor por proyecto cuando el handbook lo gradúa por aspecto — de
  ahí salió D5. Y tres referencias (*Power of Ten*, NPR 7150.2, SWE-030) quedan
  **no medidas**: ninguna de esas fuentes está entre las 10.
- **El medidor de desuso que la fase 6 tiene que escribir**: filas `recortado`
  con la justificación vacía = rojo. Es lo que hace cobrable el criterio C6.

## Lo que NO se hizo, y hay que saberlo

- **Ningún archivo vivo tocado.** `CLAUDE.md` de la raíz, `cascada.ps1`, las
  naturalezas y las plantillas siguen intactos. Lo único que se actualizó
  afuera de `docs/` son las filas de estado (reglas 4 y 7): el enrutador, el
  contrato del proyecto y la fila 5 del `PDP.md`.
- **DEFECTO VIVO, TODAVÍA NO ARREGLADO (D12).**
  `perfil-global/chequeo-de-trabajo.md` línea 19 y
  `perfil-global/herramientas/aprender.py` línea 243 dicen **186**; el registro
  tiene **204** al cerrar esta sesión (eran 201 al abrirla; esta fase agregó 3). El arreglo correcto es **derivarlo**, no
  actualizarlo. Fase 6.
- **La revisión independiente sigue sin respuesta.** Este trade study lo
  escribió el autor de la alternativa ganadora, y eso está declarado en su §9.
- No se leyó la Parte II de Rechtin, ni la 4.ª ed. del SEH, ni Douglass,
  Reinertsen o Leveson.
- **P10 (el medidor de validación) está diseñado y no construido**, a
  propósito: construirlo ahora sería medir una arquitectura que todavía no se
  usó.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  **La matriz lo reclasificó de tailoring a error**, con la resta escrita. No
  se repite.
- **Fase 1:** inline, sin fan-out, un solo hilo en Opus.
- **Fase 2:** inline. 108 páginas, la ficha, la herramienta y dos saboteadores
  por **7 puntos** del límite de 5 h y **0** del semanal.
- **Fase 3:** inline. ~112 páginas de un libro de 370, la ficha, el extractor y
  el ancla por dos caminos, por **11 puntos** y **1** del semanal.
- **Fase 4:** inline. ~40 páginas de un libro de 468, la ficha con 99 citas, el
  ancla por dos caminos, el saboteo y una mejora al medidor de citas, por
  **12 puntos** y **1** del semanal.
- **Fase 5:** inline, sin fan-out, **cero PDF extraídos**. Los tres documentos
  de diseño, los 10 requisitos, la medición que descubrió D14 y las tres
  lecciones registradas, por **10 puntos** del límite de 5 h (27 % → 37 %) y
  **1** del semanal (81 % → 82 %), medidos al cerrar, no estimados.
  **Es la fase más barata desde la 2, y la primera que no leyó un libro.**
  **Cinco fases seguidas sin un solo subagente.**

## Un freno saltó, y era real

Al instalar el perfil con las tres lecciones nuevas, `verify-install.ps1` salió
en **rojo**: `chequeo-de-trabajo.md` tenía tres bytes >127 (los acentos de
«español», «año» y «correlo»). Ese archivo es ASCII a propósito —se inyecta por
hook y la consola de Windows lo lee como cp1252— y el error era mío, de esta
sesión. **El freno hizo exactamente lo que tenía que hacer**: atrapó un defecto
que habría llegado como mojibake a todas las sesiones siguientes, y que ningún
otro chequeo miraba. Corregido y re-medido: los cinco medidores en verde.
