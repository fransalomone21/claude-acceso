# ESTADO ACTUAL — arquitectura-se

**Fase 1 EN CURSO** desde el 2026-09-16. La cierran **dos** cosas, no una:
17/17 tramos destilados, y el medidor de citas depurado con el número
re-medido y publicado. **La mitad del medidor está cerrada.**

## Dónde está todo

| Qué | Dónde |
|---|---|
| Destilados del handbook | `perfil-global/pilares/nasa-seh/` |
| Medidor de fidelidad de citas | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| **Saboteador del medidor** | `perfil-global/pilares/nasa-seh/probar-verificar-citas.ps1` |
| Lector por página impresa (`PDF = libro + 10`) | `perfil-global/pilares/nasa-seh/pag.py` |
| Las **10** fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## Medido, no supuesto

- **Citas textuales: 1325/1338 (99,0%)**, medido el 2026-09-16 con el medidor
  ya depurado y ya saboteado. El desglose de los 13 fallos que quedan, y de
  los 8 defectos reales que se corrigieron, está en
  `perfil-global/pilares/nasa-seh/README.md`.
- **Ese número no se compara con el 186/247 (75,3%) anterior.** El medidor
  viejo apareaba mal las comillas y, al desfasarse, se comía el resto de cada
  línea: llegaba a mirar 282 citas de las 1338 que hay. No medía peor — medía
  otra cosa, sobre una muestra que él mismo elegía mal.
- **Los 13 fallos que sobreviven son todos del extractor del PDF**, no de los
  destilados: tablas intercaladas a mitad de oración, bloques desordenados y
  texto de figura corrompido letra por letra. Auditados a mano, uno por uno.
- Destilados: **15 de 17 tramos**. Faltan apéndices H-P (SEMP y planes,
  p. 216-243) y R-T (ConOps, fase E, p. 244-259). **Van inline**, no
  reanudando el workflow de la fase 0.
- Fuentes: **10 archivos**, todos con MD5 verificado por `medir.py`. Douglass
  y Reinertsen entraron el 2026-09-16.

## Lo que NO se hizo, y hay que saberlo

- No se tocó **ningún** archivo vivo de la arquitectura. `CLAUDE.md`,
  `cascada.ps1`, las naturalezas y las plantillas están intactos a propósito:
  la migración es la fase 6, después del diseño y del trade study.
- `perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
  (267 líneas) sigue en pie y **se escribió sin abrir el libro**. No es fuente:
  hay que contrastarlo contra `pilares/nasa-seh/` y corregir lo que no
  coincida. Es tarea de la fase 5.
- El ancla de página de **Douglass no es constante** (+9, +8, +7 medidos en
  p. 72, 193 y 294). Cuando llegue su fase, la página impresa se lee de la
  página; calcularla con offset fijo produce anclas inventadas. Reinertsen sí
  es constante: PDF = impresa + 14.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes, 17 lectores, 6,6 minutos de reloj —
  y un límite de 5 horas del plan entero. Compró lo que no se podía comprar de
  otra forma (297 páginas no entran en una ventana), y **no se repite**.
- **Fase 1:** inline, sin fan-out, un solo hilo en Opus.
