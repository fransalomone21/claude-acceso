# HANDOFF — Software de Vuelo

## 2026-09-29 (01:20) — guía de IDEs publicada; el TP Cohete salió de lo público

**Hecho:** guía de IDEs v0.3 publicada y verificada por MD5; el hook
`post-commit` la republica sola en cada commit que toque su PDF. El informe del
TP Cohete salió de la carpeta pública `TDC` a una carpeta de GRUPOS privada
(detalle en `ESTADO_ACTUAL.md`).

**Lo que sigue, en orden:**
1. **Compartir la carpeta del TP Cohete con los autores**, cuando Fran diga
   quiénes son (el .docx no tiene mails: medido). Al compartir, declararla en
   `.claude/estructura-drive.json` → `compartido-con-nombre`, **por hash del
   mail** (nunca el mail: el repo es público), y renombrar la carpeta con los
   apellidos, como la de Teoría de Circuitos.
2. Con lo que Fran cuente del TP2, corregir y subir a v0.4 las dos versiones.
   Commitear el PDF público alcanza: el hook lo sube.
3. La guía de C, cuando Fran la pida (la dejó para después el 29/09).

## 2026-09-29 (madrugada) — la guía de IDEs v0.3, adelantada para el TP2

**Hecho:** guía pública (`guia-ides/`, 6 pág., sin publicar) y guía personal
(`catedras/software-de-vuelo/personal/`, PDF en la carpeta local de la
materia). Detalle en `ESTADO_ACTUAL.md`.

**Lo que sigue, en orden:**
1. **Preguntarle a Fran si se publica la pública** en el Drive de apuntes. Si
   dice que sí: declararla en `.claude/apuntes-publicos.json` (materia
   «Software de Vuelo», `local` = `proyectos/documentos/software-de-vuelo/guia-ides/guia-ides.pdf`)
   y `.\publicar-apuntes.ps1`. **Ojo:** el detector de «sin declarar» busca
   sólo archivos llamados `apunte.pdf`, así que esta guía **no aparece** en
   rojo si nadie la declara — no esperar que el arranque lo recuerde.
2. Con lo que Fran cuente del TP2 (si el script, el simulador o IntelliSense
   fallaron), corregir y subir a v0.4. Es la validación real de la guía.
3. La fase 0 sigue igual: criterios de Leandro en `catedras`, y
   `docs/ALCANCE.md`.

**Trampas de esta sesión:** en PowerShell, `"...$placa: ..."` no compila (la
variable seguida de `:` es un calificador; va `${placa}`). En Typst, un bloque
de código en medio de una lista numerada la corta y reinicia la numeración: se
indenta dentro del ítem. Y un `raw` largo sin espacios (una ruta de WSL) se
sale de la celda de una tabla.

## 2026-09-29 — primera sesión

**Lo que sigue:** la fase 0 de este proyecto espera a la fase 0 de
`catedras` (los criterios de Leandro). Orden:

1. En `catedras`: leer la presentación del 18/08 y los prácticos 1 a 3 y
   registrar `LEA-R1` a `LEA-R4` con sus criterios (ver su `HANDOFF.md`).
2. Acá: `docs/ALCANCE.md`, cada tema de las dos guías con la clase o el
   práctico que lo pide.

**No hacer:** abrir el TP Cohete acá (regla 2), ni publicar nada que no sea
una de las dos guías.
