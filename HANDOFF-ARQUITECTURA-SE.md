# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 1 de N. **2026-09-16.** Cortada al 97% del límite de 5 h.

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Agile. Fran: "mínima ambigüedad posible", y las
necesidades que generaron la arquitectura actual **siguen valiendo**.

## ESTADO
- Handbook leído: **14 de 17 tramos** → `perfil-global/pilares/nasa-seh/`
  (771 KB, anclas de página impresa, `PDF = libro + 10`). Commiteado y pusheado.
- Faltan 3 tramos (apéndices D-G, H-P, R-T). Son plantillas de documento;
  **ninguna decisión de arquitectura depende de ellos**.
- Citas medidas: **186/247 (75.3%)** con `pilares/nasa-seh/verificar-citas.py`.
- Fuentes bajadas y con MD5 en `pilares/fuentes/INDICE.md` + `medir.py`.

## EL HALLAZGO QUE MANDA LA REFORMA
Handbook **cap. 3.11, p. 34-42**: NASA tipifica proyectos **A-F** (tabla
3.11-1, p. 38) por 8 criterios, y después declara **producto por producto**
`Fully Compliant` / `Tailor` / `Not Applicable` (tabla 3.11-2, p. 39-40) en una
**Matriz de Cumplimiento** con justificación por línea, adjunta al SEMP.

Nuestras *naturalezas* (`ingenieria`/`documentos`/`seguimiento`) son una
tipificación de grano grueso **sin matriz y sin campo de justificación**: una
etiqueta, no un contrato. La reforma es convertirlas en matriz de cumplimiento.

El mecanismo correcto **ya está inventado en este repo**, dos veces:
`.claude/datos-permitidos.json` y `.claude/apuntes-publicos.json` son
deny-by-default con excepción declarada y motivo. Falta aplicárselo al método.

## NO REPETIR
- `engineering-orchestrator/referencias/ingenieria-de-sistemas.md` (267 líneas)
  se escribió **sin abrir el libro**. No tomarlo como fuente: contrastarlo
  contra `pilares/nasa-seh/` y corregir lo que no coincida.
- `curl` a `direct.mit.edu` y `incose.org` devuelve HTML de Cloudflare con
  nombre `.pdf` y **exit 0**. Verificar con `file`, no con el exit code.

## PRÓXIMO PASO CONCRETO
1. Leer `pilares/nasa-seh/tailoring.md`, `requisitos.md` y `glosario.md`
   (esos tres, no los 14).
2. Diseñar la **Matriz de Cumplimiento** del método: qué exige cada tipo de
   proyecto, qué exime y con qué justificación.
3. Recién después tocar `CLAUDE.md` y `cascada.ps1`.

## MODELO / ESFUERZO
Opus, esfuerzo high, **sin fan-out** — la reforma es un solo hilo de diseño y
el material ya está leído. El fan-out se gastó donde hacía falta (el libro no
entra en una ventana) y no se repite.

## COMPRAS PENDIENTES (Fran)
INCOSE GtWR v4 (US$ 25) · INCOSE SEH 5.ª ed. (~US$ 90) · Douglass, *Agile
Systems Engineering* (~US$ 55). Gratis: NPR 7123.1D (apéndices G y H).
