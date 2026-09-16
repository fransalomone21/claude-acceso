# ESTADO ACTUAL — arquitectura-se

**Fase 2 CERRADA** el 2026-09-16. Cerró por las **dos** cosas que la cerraban:
la **ficha del GtWR** con las 41 reglas ancladas, y el **chequeo mecánico** que
lee un requisito y dice qué regla viola, con su saboteador en verde.
**Abre la fase 3** (INCOSE SEH 5.ª ed.: marco e híbrido).

## Dónde está todo

| Qué | Dónde |
|---|---|
| Destilados del handbook NASA (17 tramos) | `perfil-global/pilares/nasa-seh/` |
| **Ficha del INCOSE GtWR** | `perfil-global/pilares/incose-gtwr/reglas.md` |
| **Chequeo de requisitos** | `perfil-global/pilares/incose-gtwr/verificar-requisito.py` |
| **Saboteador del chequeo** | `perfil-global/pilares/incose-gtwr/probar-verificar-requisito.ps1` |
| Medidor de fidelidad de citas (sirve para los dos libros) | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| Saboteador del medidor | `perfil-global/pilares/nasa-seh/probar-verificar-citas.ps1` |
| Las **10** fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## Medido, no supuesto

- **GtWR: citas 74/74 (100 %).** Mismo medidor de la fase 1, que ahora acepta
  `--dir`. Saboteado sobre la ficha nueva: los tres sabotajes en rojo y limpio
  al final.
- **Ancla del GtWR: `impresa = PDF − 1`**, medida sobre **101 de 108 páginas**
  y cruzada contra el índice en 41 de 41 reglas. **No se heredó el `+10` del
  handbook**: es de ese libro.
- **El chequeo cubre 32 de las 41 reglas** — 19 enteras, 13 parciales. Las 9
  que no cubre están declaradas con el motivo en `--cobertura`.
- **Control positivo: 0 VIOLA sobre 17 ejemplos que el propio GtWR marca como
  aceptables.** Sin esa mitad, un chequeo que siempre dice que no se ve igual
  de "verificado" que uno que funciona.
- **NASA: 1424/1437 (99,1 %) sin cambios**, re-medido después de tocar
  `verificar-citas.py`, y su saboteador corrido otra vez en verde.

## Lo que el saboteador encontró en esta fase

- **R16 (`/NonAmbiguity/AvoidNot`) estaba declarada en la matriz de cobertura y
  no tenía código detrás.** La agarró el control de coherencia: toda regla que
  la matriz declara mirar tiene que dispararse en algún caso. Una matriz que
  miente, miente en verde.
- **El sabotaje al propio chequeo falló en su primera versión, con razón:** R7
  tiene dos mecanismos (la lista de términos vagos y la heurística de los
  adverbios en `-ly`), y vaciar uno no apaga al otro. El control estaba mal
  escrito, no la herramienta. Ahora además exige que el mecanismo que **no**
  sabotea siga vivo.

## Lo que NO se hizo, y hay que saberlo

- No se tocó **ningún** archivo vivo de la arquitectura. `CLAUDE.md` de la
  raíz, `cascada.ps1`, las naturalezas y las plantillas siguen intactos: la
  migración es la fase 6, después del diseño y del trade study. Lo único que se
  tocó afuera del proyecto es `pilares/` —que es material de lectura— y
  `verificar-citas.py`, con su saboteador corrido después.
- `perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
  sigue en pie y **se escribió sin abrir el libro**. Contrastarlo es la fase 5.
- El ancla de **Douglass no es constante** (+9, +8, +7). Reinertsen sí:
  `PDF = impresa + 14`.
- Los apéndices N y P **no están** en el Rev2 del handbook: ese material va
  anclado a la *Expanded Guidance*.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  Compró lo que no se podía comprar de otra forma y **no se repite**.
- **Fase 1:** inline, sin fan-out, un solo hilo en Opus.
- **Fase 2:** inline, sin fan-out. **108 páginas leídas, la ficha escrita, la
  herramienta construida y los dos saboteadores corridos costaron 7 puntos del
  límite de 5 h y 0 del semanal** (74 % antes, 74 % después). El fan-out de la
  fase 0 no compró velocidad: compró superficie que acá no hacía falta.
