# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20**. Cerró la fase 0.

## Lo que la próxima sesión NO tiene que rehacer

- **Bajar ni extraer el material.** Los 7 PDF vienen del Drive
  (`drive-apuntes:IISE/Clases CLASSROOM PDF`) y ya están extraídos. Si hacen
  falta de nuevo: `python extraer-clases.py --figuras`.
- **Medir las anclas de NotebookLM.** Ya está: 4 de 149 correctas. La
  conclusión está en la regla propia 2 del contrato y no se vuelve a discutir.
- **Decidir el léxico base.** `requerimiento` e `interesado`, medidos sobre las
  7 clases.

## Trampas ya pagadas

- **`rclone` NO se invoca crudo con `%APPDATA%`.** El config vive en
  `$env:USERPROFILE\.config\rclone\rclone.conf`; con la otra ruta responde
  `empty token found`, que se lee como token vencido y no lo es. Lo envuelve
  `publicar-apuntes.ps1`: leerlo antes de invocar rclone a mano.
- **Los `.txt` se escriben en UTF-8 y se leen así.** La consola de Windows es
  cp1252: imprimir el texto de las clases directo en la terminal muestra `?`
  donde hay acentos, y eso **no** significa que el PDF esté mal.
- **No escribir scripts con heredoc.** El guardia lo niega y tiene razón: se
  escriben con la herramienta Write y se corren con `python <ruta>`.

## Lo que quedó abierto

1. **La fase 1: el glosario controlado (M00).** Es lo primero, y ningún módulo
   se escribe antes. Salida: `fuentes/glosario.md` + `verificar-lexico.py` +
   su saboteador en rojo a propósito.
2. **Los parcialitos no llegaron.** La fase 3 (cobertura) está bloqueada hasta
   que estén. Si llegan después de empezar la fase 2, hay que reabrir módulos
   ya cerrados: por eso conviene que entren antes.
3. **La plantilla Typst no se copió todavía.** Sale de
   `proyectos/documentos/fisica-espacial/apunte/plantilla.typ` junto con la
   paleta y las cajas.
