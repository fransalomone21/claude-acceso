# Handoff — Taller de Física

**Escrito el:** 2026-09-13 · **Fase al cerrar:** 0 (Estructura y fuentes)
CERRADA — 1 (Escribir) bloqueada a propósito, sin fecha.

## 2026-09-29 — lo nuevo va ARRIBA de lo de abajo

**Si Fran pide algo de la exposición** (Compton y creación de pares /
Bremsstrahlung, semanas 12 y 13; define los subtemas el miércoles 30/09):

1. Leer **primero** `../catedras/taller-de-fisica/CRITERIOS.md` y los
   generales de Aníbal (`../catedras/fisica-espacial/CRITERIOS.md` §A). Ahí
   está también **dónde está el tema en los tres libros de la cátedra**,
   medido: Sears-Zemansky vol. 2 cap. 38, Pisacane cap. 9. El material sale
   de esos libros (TAL-05, ANI-14).
2. **Dónde se produce:** si el PowerPoint lleva los nombres de los
   integrantes en la carátula, **no** va en este repo, que es público (regla
   2 de la estructura): se abre una carpeta privada al empezar, igual que
   `teoria-circuitos`. Si no los lleva, puede ir acá, en una carpeta
   `exposicion/` fuera de las fases del apunte.
3. La fase 1 (el apunte de la materia) **sigue bloqueada**: la exposición no
   la abre. Fran pidió «luego» que el apunte condense las clases de todos los
   grupos; se redefine cuando diga «arrancamos».

El cronograma está en `C:\Users\frans\Desktop\01 - UNSAM\Taller de Fisica\`.

## Arrancá por acá (lo del 2026-09-13)

**No escribas ningún módulo todavía**, aunque la fase 0 esté cerrada y el
recorte confirmado. Fran fue explícito: "todo lo de taller de física es
para un plazo más largo, yo te voy a decir cuándo empezarlo". Si esta sesión
llegó acá sin que el mensaje que la abrió diga explícitamente que Fran dio
esa señal, no hay nada para hacer en este proyecto todavía — no es un
"mientras tanto, adelantá algo": es una espera real.

**La fase 0 cerró el 2026-09-13.** Fran confirmó el recorte de Pisacane en
el chat: "correlativo = continúa un tema ya confirmado, sumá el 5" → 7
capítulos, **3, 4, 5, 6, 8, 9, 11** de 12. El detalle de por qué cada uno
entró o quedó afuera está en `docs/bitacora.md`.

## Lo que quedó a medias

Nada de la fase 0 — cerró completa. Lo que sigue abierto es la fase 1
entera (escribir), bloqueada a propósito hasta que Fran avise.

## Lo que NO hay que volver a intentar

- **No abrir el PDF de Pisacane con la ruta normal.** Su path completo tiene
  292 caracteres y Windows corta en 260: `os.path.exists()` y
  `pymupdf.open()` fallan con "no such file" sobre un archivo que existe.
  Hace falta el prefijo `\\?\` delante del path absoluto. Localizarlo con
  `os.listdir()` + `os.path.join()`, nunca tipeando el nombre a mano (tiene
  guiones dobles, dos espacios y un DOI adentro).
- **No usar el tool `Read` del harness sobre el PDF de Ferraro** para ver
  páginas — es un escaneo sin capa de texto (`get_text()` devuelve vacío) y
  el tool de lectura de PDF necesita `pdftoppm`, que no está instalado en
  esta máquina. Rasterizar con `pymupdf` (`get_pixmap(dpi=130).save(...)`) y
  mirar el PNG con el tool de lectura de imágenes. Pisacane sí tiene capa de
  texto: ahí alcanza con `get_text()`, más barato que rasterizar.

## Datos que no se pueden aproximar

- Las tres fuentes viven en
  `C:\Users\frans\Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\`
  — detalle completo en `fuentes/RUTAS.md`.
- Ferraro: 137 páginas en el PDF, offset página impresa = PDF − 14 (medido
  con la pág. 130 del PDF = impresa 116, §3.16, ec. 3.57c).
- Pisacane: 441 páginas, 12 capítulos. El prefacio (PDF pág. 14-16) trae la
  tabla del propio autor con el programa de 37 clases y qué secciones omitir
  por capítulo — es el punto de partida si hace falta afinar el recorte más.
- El recorte de Pisacane está CERRADO: capítulos **3, 4, 5, 6, 8, 9, 11** de
  12. El detalle de por qué cada uno entró o quedó afuera está en
  `docs/bitacora.md`.

## Si hay que abrir un chat nuevo

```
Retomo el Taller de Física (proyectos/documentos/taller-de-fisica).

QUÉ LEER: CLAUDE.md, ESTADO_ACTUAL.md y este HANDOFF.md. PDP.md y
docs/bitacora.md sólo si hace falta el detalle de por qué se eligió cada
capítulo de Pisacane.

FASE: 0 (estructura y fuentes) CERRADA. Las tres fuentes están confirmadas:
Ferraro caps. 1-3, Pisacane caps. 3,4,5,6,8,9,11, Young-Freedman como
referencia general.

NO ESCRIBAS NINGÚN MÓDULO DE CONTENIDO salvo que el mensaje que abrió esta
sesión diga explícitamente que Fran dio la señal de arrancar la fase 1 — lo
dijo así el 2026-09-13: "yo te voy a decir cuándo empezarlo". Si no hay esa
señal, no hay nada para hacer en este proyecto todavía.

MODELO Y ESFUERZO, cuando arranque la fase 1: Opus para la primera pasada de
cada módulo nuevo (territorio no escrito todavía), esfuerzo medium — no es
un runbook como el cierre de fisica-espacial, es contenido nuevo con
deducciones propias.

PRIMER COMANDO:
  cd C:\Users\frans\Desktop\claude-acceso ; .\cascada.ps1 taller-de-fisica
```
