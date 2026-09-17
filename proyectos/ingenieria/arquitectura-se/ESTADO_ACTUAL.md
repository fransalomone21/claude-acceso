# ESTADO ACTUAL — arquitectura-se

**Fase 6 ABIERTA** el 2026-09-17 (migrar). **Es la primera fase que toca
archivos vivos**, así que el rigor es **pleno** (`docs/matriz-cumplimiento.md`
§4, aspecto `c`): backup y saboteador **antes** de cada pieza, no después.

**Las fases 0-5 están cerradas.** Los cuatro libros leídos y medidos; la
arquitectura elegida con trade study explícito; los tres documentos de diseño
en `docs/`.

## Lo que la fase 6 ya cerró — los TRES defectos vivos

| Defecto | Estado | Cómo se verificó |
|---|---|---|
| **D12** — el `186` contra el registro | **CERRADO** | El `INDICE.md` dice hoy **210**, y nadie lo escribió: sale de `len(utiles)`. `chequeo-de-trabajo.md` ya no lleva número |
| **D14** — el chequeo de requisitos era de idioma inglés | **CERRADO** | Las dos mitades de la aceptación, ahora control permanente del saboteador |
| **El medidor de desuso** (criterio C6) | **CERRADO** | `medir-matriz.py` + `probar-medidor-matriz.ps1`, 6 frenos que discriminan |

## Lo que se encontró midiendo, y no estaba en el plan

- **El freno de D12 existía, y su saboteador daba verde sobre el defecto
  vivo.** El patrón de `install.ps1` estaba anclado a la **primera línea**
  (`^CHEQUEO DE TRABAJO...`) y el saboteador rompía el archivo **ahí mismo**.
  El `186` real estaba en la línea 19. **Un saboteador escrito por el autor
  del freno hereda su punto ciego** — es la pieza P8 medida en carne propia, y
  el argumento más fuerte que tiene el proyecto para que P8 siga declarada
  como hueco sin respuesta.
- **Tres archivos vivos tenían un BACKSPACE (0x08) adentro**, uno de ellos
  `chequeo-de-trabajo.md`, que **se inyecta en cada sesión**. Los tres eran un
  `\b` escrito dentro de comillas de shell. En `verificar-requisito.py` además
  **apagaba en silencio una excepción de R16**. El chequeo de ASCII miraba
  `>127` y era **ciego a los controles `<32`**: media punta de un rango.
- **R24 marcaba VIOLA al determinante demostrativo** (`esa regla`), y el libro
  prohíbe la referencia colgante, no la palabra. Corregido **en los dos
  idiomas**: determinante → `REVISAR`, pronombre suelto → `VIOLA`.
- **El medidor de desuso daba verde sobre un archivo sin una sola fila.** Lo
  atrapó su propio saboteador. *Nada que medir* y *todo bien* no se pueden ver
  igual: es el único verde que **crece** a medida que la disciplina se
  abandona.

## Medido, no supuesto

- **D14, las dos mitades, y una tercera que se agregó:**
  **0 VIOLA** sobre `docs/requisitos.txt` · **6 VIOLA** sobre *"The method
  shall allow tailoring of any appropriate rule if necessary, etc."* · **5
  VIOLA** sobre ese mismo enunciado **traducido** — sin la tercera, el español
  podía ser la versión blanda de la regla.
- **27 reglas léxicas del GtWR se disparan en español**, y las 26 del inglés
  siguen disparándose: `rotos.txt` da 26 VIOLA y `sanos.txt` da 0, igual que
  antes.
- **Los cuatro requisitos que quedaron en VIOLA eran defectos reales**, no
  falsos positivos: A1 y A3 con el posesivo `su`, A6 y A9 con una negación.
  Reescritos. **No se aflojó ninguna regla para que pasaran.**
- **La matriz, medida:** 38 filas, 28 cumple, 7 no aplica, 3 recortado —
  **exactamente** lo que la sección 6 dice a mano. Control cruzado que no se
  buscaba.
- **210 lecciones, todas con triage** (eran 204; esta fase agregó 6).

## Lo que FALTA para cerrar la fase 6

El criterio de salida (`PDP.md` §4): `chequeo-completo.ps1` en verde, **todos**
los saboteadores corridos, y **un proyecto real migrado a la matriz**.

- **Las 5 piezas que quedan**, de las 7 filas `no aplica — todavía`:
  **P1** catálogo derivado · **P4** los dos campos del molde de fase (+ el
  campo de certificación en `plantillas/PDP.md`) · **P5** heurísticas pegadas
  a los pasos · **P6** criterio de entrada al registro · **P7** separación
  System 2 / System 3.
- **`ingenieria-de-sistemas.md`** con las 4 correcciones de `arquitectura.md`
  §8, y la pregunta abierta: reescrito contra las fichas, ¿sigue haciendo
  falta, o el catálogo P1 más las cuatro fichas ya lo reemplazan?
- **Un proyecto real migrado.** Es lo que de verdad cierra la fase.
- **P10 NO se construye acá**: es de la fase 7, a propósito.

## El único rojo abierto, y es correcto

`chequeo-completo.ps1 -SoloMedidores` da **1 rojo**: `restas de las matrices`.
Las 7 filas `no aplica — todavía` llevan `Fase 6` de justificación, que es un
puntero y no una resta. **El medidor está midiendo el avance de esta fase**, y
se pone en verde solo cuando las piezas estén puestas. Los otros 5 medidores,
en verde.

## Coste

- **Fases 0-5:** ver el historial de abajo. La 0 gastó 2,07 M tokens y un
  límite de 5 h en 6,6 minutos, y la matriz lo reclasificó de tailoring a
  **error**, con la resta escrita.
- **Fase 6, primer tramo:** inline, sin un solo subagente, **cero PDF
  extraídos**. Los tres defectos vivos, dos saboteadores nuevos, un medidor
  nuevo y seis lecciones, por **16 puntos** del límite de 5 h (39 % → 55 %) y
  **2** del semanal (82 % → 84 %), medidos al cerrar el tramo, no estimados.
  **Sexta fase seguida sin fan-out.**

## Historial de fases

- **Fase 0:** lectura con subagentes. 2,07 M tokens. Reclasificada como error.
- **Fases 1-4:** los cuatro libros, inline, por 7, 11 y 12 puntos del de 5 h.
- **Fase 5:** los tres documentos de diseño, por 10 puntos y 1 del semanal.
