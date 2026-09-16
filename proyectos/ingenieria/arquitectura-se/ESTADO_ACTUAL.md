# ESTADO ACTUAL — arquitectura-se

**Fase 0 CERRADA** el 2026-09-16. Abre la **fase 1**.

## Dónde está todo

| Qué | Dónde |
|---|---|
| Destilados del handbook (15 tramos, 819 KB) | `perfil-global/pilares/nasa-seh/` |
| Medidor de fidelidad de citas | `perfil-global/pilares/nasa-seh/verificar-citas.py` |
| Lector por página impresa (`PDF = libro + 10`) | `perfil-global/pilares/nasa-seh/pag.py` |
| Las 8 fuentes (PDF gitignoreados) + MD5 | `perfil-global/pilares/fuentes/INDICE.md` |
| El plan de fases y los criterios de salida | `PDP.md`, sección 4 |

## Medido, no supuesto

- Destilados: **15 de 17 tramos**. Faltan apéndices H-P (SEMP y planes) y R-T
  (ConOps, fase E). Los dos agentes murieron por límite de sesión, no por
  error. **La fase 1 los hace inline**, no reanudando el workflow.
- Citas textuales: **186/247 (75,3 %)**. Ese número mezcla fallos del medidor
  (un regex que levanta cualquier cosa entre comillas, incluidos comentarios
  en castellano) con fallos reales. Depurarlo es lo primero de la fase 1.
- Fuentes: 8 archivos, 2664 páginas, todos con MD5 verificado por `medir.py`.

## Lo que NO se hizo, y hay que saberlo

- No se tocó **ningún** archivo vivo de la arquitectura. `CLAUDE.md`,
  `cascada.ps1`, las naturalezas y las plantillas están intactos a propósito:
  la migración es la fase 6, después del diseño y del trade study.
- `perfil-global/engineering-orchestrator/referencias/ingenieria-de-sistemas.md`
  (267 líneas) sigue en pie y **se escribió sin abrir el libro**. No es fuente:
  hay que contrastarlo contra `pilares/nasa-seh/` y corregir lo que no
  coincida. Es tarea de la fase 5.

## Coste de la fase 0

2,07 M tokens de subagentes, 17 lectores, 6,6 minutos de reloj — y un límite
de 5 horas del plan entero. Compró lo que no se podía comprar de otra forma
(297 páginas no entran en una ventana), y **no se repite**: de la fase 1 en
adelante el trabajo es inline.
