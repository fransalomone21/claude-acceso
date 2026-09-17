# ESTADO ACTUAL — arquitectura-se

**Fase 3 CERRADA** el 2026-09-17. Cerró por las **dos** cosas que la cerraban:
el **mapeo** de los 17 procesos de NASA contra los 30 del ISO/IEC/IEEE 15288
(2023), proceso por proceso y anclado a página impresa, y la **lista de lo que
tiene INCOSE y NASA no**, con el ciclo iterativo/ágil desarrollado.
**Abre la fase 4** (Rechtin & Maier: heurísticas de arquitectura).

## Dónde está todo

| Qué | Dónde |
|---|---|
| Destilados del handbook NASA (17 tramos) | `perfil-global/pilares/nasa-seh/` |
| Ficha del INCOSE GtWR (41 reglas) | `perfil-global/pilares/incose-gtwr/reglas.md` |
| Chequeo de requisitos | `perfil-global/pilares/incose-gtwr/verificar-requisito.py` |
| **Ficha del INCOSE SEH 5.ª ed. — el mapeo** | `perfil-global/pilares/incose-seh/mapeo-15288.md` |
| **Cómo se lee ese libro, y sus dos trampas** | `perfil-global/pilares/incose-seh/README.md` |
| Medidor de fidelidad de citas (sirve para los **tres** libros) | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| Saboteador del medidor | `perfil-global/pilares/nasa-seh/probar-verificar-citas.ps1` |
| Las **10** fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## Medido, no supuesto

- **SEH: citas 73/73 (100 %).** Mismo medidor de las fases 1 y 2, con `--dir`.
  Saboteado sobre la ficha nueva: los tres sabotajes en rojo, el control
  positivo del filtro de encabezados en verde, y limpio al final.
- **Ancla del SEH: `impresa = PDF − 25`, medida por DOS caminos
  independientes.** 321 de 370 encabezados, y **41 de 41** entradas del índice
  cruzadas contra el cuerpo. Van cuatro libros y cuatro offsets distintos: el
  ancla se mide por libro y no se hereda nunca.
- **Tamaño medido ANTES de decidir cómo leer:** 370 páginas, 1,2 M de
  caracteres. Se leyeron **~112 páginas**, las que el mapeo necesitaba; lo que
  no se leyó está declarado en la sección 8 de la ficha.
- **Control positivo de la extracción antes de creerle:** `15288` da 126 hits,
  `technical process` 40, `agile` 71.
- **El SEH parte palabras al final de renglón y deja el guion.** 982 cortes
  medidos. `extraer.py` decide por palabra contra el vocabulario del propio
  libro: 909 re-unidas, 74 dejadas, el residuo listado con `-v`.

## Lo que el mapeo encontró, y manda a la fase 5

- **El SEH 5.ª ed. no menciona el NPR 7123.1 ni una vez** (`grep 7123` = 0). El
  mapeo es **construido**, no citado: las columnas son verbatim de cada libro,
  las filas las armó esta lectura, y cada una lleva su grado
  (`textual` / `probable` / `no 1:1`).
- **10 filas no son 1:1**, en las dos direcciones. Del lado de INCOSE:
  Business or Mission Analysis, System Analysis, Quality Assurance, y
  **Operation, Maintenance y Disposal**, que en NASA no son procesos. Del lado
  de NASA: **Requirements Management, Interface Management y Logical
  Decomposition**, que en el 15288 no existen como proceso.
- **El corte NASA 3/4 contra INCOSE T4/T5 es el desacople más grande.** NASA
  corta entre lógico y físico; INCOSE entre arquitectura y diseño. No se puede
  cumplir con los dos cortes sin duplicar artefactos: la matriz de la fase 5
  tiene que **elegir uno y declararlo**.
- **Verificación y validación aplican a ARTEFACTOS, no a productos** (p. 138 y
  146). Un requisito se verifica y se valida; una arquitectura también.
- **El orden 8↔9 está invertido** respecto de NASA: el 15288 pone Transition
  antes de Validation, porque la validación definitiva se hace en el entorno
  operativo real.
- **Una fase puede cerrar cancelando la siguiente** (p. 223). El molde de fase
  actual del PDP no tiene esa salida.
- **`perfil-global` es un "System 3"** en el modelo de tres sistemas anidados
  (p. 223) y hasta hoy no tenía nombre para serlo.
- **El repo es una VSE perfil `Entry`** (ISO/IEC/IEEE 29110, p. 219): menos de
  6 personas, perfil ya definido en una norma.
- **La Matriz de Cumplimiento NO sale de este libro.** Sigue con tres fuentes
  (NASA 3.11, SEMP §9.0, GtWR R39). El SEH aporta el **proceso** de tailoring
  con IPO y las **cinco trampas** (p. 218), de las cuales cuatro describen
  errores ya cometidos en el repo.

## Lo que NO se hizo, y hay que saberlo

- No se tocó **ningún** archivo vivo de la arquitectura. `CLAUDE.md` de la
  raíz, `cascada.ps1`, las naturalezas y las plantillas siguen intactos: la
  migración es la fase 6, después del diseño y del trade study. Lo único que
  se tocó afuera del proyecto es `pilares/`, que es material de lectura.
- **No se abrió la 4.ª ed. del SEH** (2015). Está en `fuentes/` por si el
  mapeo la pedía; no la pidió.
- `perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
  sigue en pie y **se escribió sin abrir el libro**. Contrastarlo es la fase 5.
- El ancla de **Douglass no es constante** (+9, +8, +7). Reinertsen sí:
  `PDF = impresa + 14`.
- Los apéndices N y P **no están** en el Rev2 del handbook de NASA: ese
  material va anclado a la *Expanded Guidance*.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  Compró lo que no se podía comprar de otra forma y **no se repite**.
- **Fase 1:** inline, sin fan-out, un solo hilo en Opus.
- **Fase 2:** inline, sin fan-out. 108 páginas, la ficha, la herramienta y dos
  saboteadores por **7 puntos** del límite de 5 h y **0** del semanal.
- **Fase 3:** inline, sin fan-out. **~112 páginas de un libro de 370, la ficha,
  el extractor con des-partición medida, el ancla por dos caminos y el
  saboteador, por 11 puntos del límite de 5 h y 1 del semanal** (78 % antes,
  79 % después). Tres fases seguidas sin un solo subagente.
