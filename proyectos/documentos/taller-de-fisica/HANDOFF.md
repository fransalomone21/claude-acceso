# Handoff — Taller de Física

**Escrito el:** 2026-09-13 · **Fase al cerrar:** 0 (Estructura y fuentes)
CERRADA — 1 (Escribir) bloqueada a propósito, sin fecha.

## 2026-10-27 (tarde) — dos clases, diagrama y simulación

- `referencia.js` toma un 4.º argumento: `1`, `2` o `todo`. La clase que no
  va se arma sobre una presentación «nula» que no se escribe; `quien("…")`
  pone el orador al principio de las notas. Los tres archivos se suben con
  `rclone copyto` al mismo nombre.
- `simulacion/plantilla.html` es la fuente; `armar.py <salida>` mete las
  Figs. 2-6 y 2-10 en base64 (`compton.html`, ~900 KB). En la simulación la
  altura de los picos y la forma del continuo son ilustrativas (lo dice la
  página); la posición de los picos y λmin salen de las fórmulas.
- El diagrama: `typst compile --root . catedras/.../diagrama-compton.typ
  catedras/.../figuras/diagrama-compton.png --ppi 200` desde
  `proyectos/documentos`. No dice qué ánodo ni qué cristal usó Compton: los
  libros no lo dicen (la guía usa sal como ejemplo, aclarado).
- El Doc del orden se actualizó con `rclone copyto <html> … --drive-import-formats
  html --drive-export-formats html` al mismo nombre: mantuvo el id.

### Mensaje de retome (para después de la clase del 28/10)

```
Retomo el Taller de Física: la exposición de Compton y pares
(proyectos/documentos/taller-de-fisica; fuentes en el repo privado
catedras/taller-de-fisica/exposicion/).

0. En esta PC el perfil llega solo. En otra máquina o en la nube, primero
   bash .claude/nube/traer-perfil.sh en claude-acceso y leer lo que lista.
1. Primer comando: .\cascada.ps1 taller-de-fisica -Necesidad materia, y leer
   lo que pida la puerta (es largo: se lee igual). Después
   .\cascada.ps1 catedras -Necesidad materia. Para leer el Sears hace falta
   .\cascada.ps1 fisica-espacial -Excepcion "leer el Sears".
2. Fase: E2 (NASA Phase C, armar la presentación). La cierra: las dos
   clases dadas (28/10 y 4/11) con lo que corrija Aníbal en la primera
   aplicado en la segunda.
3. Modelo: Opus, esfuerzo medio, sin fan-out (contenido en un hilo).
4. Estado: todo en Drive, carpeta del grupo (id 1jQc0UDi6vIcGTI3L3qx5mJ0ar64RY0NG):
   guía (14i9eYDstJoCGb6ORCHbDW4o38mDlI9SM), power clase 1 y clase 2,
   referencia (1Xq0ttRXA8x1SS1TKnk73lD7ZK6GQy__C), compton.html, el diagrama
   y el Doc del orden. pptxgenjs vive en %TEMP%\pptxgen-ref (se reinstala
   con npm si falta) y apply_theme.js en %TEMP%\pv\scripts\.
5. Resuelto, no rehacer: guía v5.1 (43 págs.), diagrama nuevo, simulación,
   power partido en dos con quién habla, análisis de preguntas de Aníbal
   (guía §12.4), Doc del orden.
6. Lo primero: preguntarle a Fran qué corrigió o preguntó Aníbal el 28/10 y
   registrarlo en catedras/taller-de-fisica/REGISTRO.md como TAL-R8 (textual
   o «de memoria»), contrastar TAL-18 y TAL-19, y aplicarlo a la guía y al
   power de la clase 2. Después: repartir entre Fran y Agustín las
   diapositivas «a repartir» (resto de Compton y toda la clase 2) si lo piden.
7. Para verificar: render del power (soffice + pymupdf) mirado, validate.py
   en verde, y en Drive el mismo id y MD5 igual al local en cada archivo.
```

## 2026-10-27 — guía v5 y power v5

- Lo que corrija Aníbal en la 1.ª clase (28/10) entra a `catedras` como
  TAL-R8 y se contrasta con TAL-18 y TAL-19; después, la guía y el power.
- Figuras nuevas del Pisacane: `recortar-figuras.py` las saca por la caja de
  la imagen incrustada (`get_image_rects`), del recorte de la bibliografía.
- El power se genera con `NODE_PATH=%TEMP%\pptxgen-ref\node_modules` y el
  `apply_theme.js` de `%TEMP%\pv\scripts\`; render con el `soffice.exe` de
  LibreOffice. Quedan cuatro títulos largos en dos renglones, pegados a la
  raya: si molestan, se acortan.
- Las notas «Base, por si preguntan» citan el anexo por letra: ahora hay
  A.7 (escala log), A.8 (glosario) y A.9 (símbolos).
- El Sears se leyó con `-Excepcion` de `fisica-espacial` (la ruta lo nombra).

## 2026-10-26 (noche, después) — bases en las notas

- Las líneas «Base, por si preguntan» de `referencia.js` citan secciones del
  Anexo A por letra (A.1 a A.6): si el anexo se reordena, se corrigen a mano
  (son texto plano, el compilador no las ve).

## 2026-10-26 (noche) — guía v4, el Anexo A

- El anexo cambia el rótulo del título con el estado `rotulo` («PARTE» →
  «ANEXO») y la numeración a `"A.1"` con el contador en cero. Su ejemplo va
  con `caja(...)` a mano: `ejemplo()` numeraría «1.1».
- Las notas son `#repaso(destino: <anx-...>)` de la plantilla de
  `fisica-espacial`; las etiquetas: `anx-foton`, `anx-ev`, `anx-hc`,
  `anx-relatividad`, `anx-interferencia`, `anx-magnetico`.
- Las páginas se midieron con el texto volcado de los PDF (Eisberg y Sears
  vol. 2); el Sears vive en `01 - UNSAM\Fisica Espacial\Libros de Fisica\`, y
  la puerta pide declarar `fisica-espacial` (se usó `-Excepcion`) porque la
  ruta lo nombra.

## 2026-10-26 — el PowerPoint de referencia

- Fuente: `catedras/taller-de-fisica/exposicion/referencia.js` (privado, al
  lado de `esqueleto.js`). Se genera igual que el esqueleto: pptxgenjs 3.12.0
  en una carpeta temporal con `NODE_PATH`, y el `apply_theme.js` del skill
  copiado en `%TEMP%\pv\scripts\`. El `validate.py` del skill pide
  `defusedxml`: correrlo con `py -3.13`, no con `python`.
- **Trampa pagada:** un objeto de opciones compartido entre layouts
  (`defineSlideMaster`) sale bien en el primero y roto en los siguientes,
  porque pptxgenjs lo muta al usarlo: los títulos salieron chicos en la
  esquina. Por eso en `referencia.js` son funciones (`tituloContenido()`).
- El render: `soffice.py` del skill no anda en Windows (pide `AF_UNIX`); se
  llama a `C:\Program Files\LibreOffice\program\soffice.exe` directo y se
  renderiza el PDF con pymupdf (no hay `pdftoppm`).
- Si se regenera, sube a Drive con `rclone copy` al **mismo nombre** y se
  verifica que el id siga siendo `1Xq0ttRXA8x1SS1TKnk73lD7ZK6GQy__C` y el
  MD5 igual al local.

## 2026-10-25 (tarde) — guía v3 y el Doc del orden

- El Doc del grupo se creó con `rclone copy <html> --drive-import-formats html
  --drive-export-formats html` (sin el segundo flag, rclone se niega). Si hay
  que cambiarlo, se edita en Docs: un HTML nuevo crearía otro archivo al lado.
- `#power[...]` en la guía es la marca «En el PowerPoint:»; la tabla de
  diapositivas está en `<diapos>`.
- Lo que viene (E2, armar la presentación) arranca de esa tabla y del
  esqueleto de Slides, que ya puede tener ediciones de Fran o Agustín: se
  edita en Slides, no se regenera.

## 2026-10-25 — guía versión 2

- Las cuentas nuevas (Bragg en NaCl, la energía del haz de 0,71 Å, lo que se
  lleva el electrón a 90°) están en `validar.py`. Las figuras nuevas del Sears
  (36.22 y 44.1) las recorta `recortar-figuras.py`, que ahora abre también el
  Sears con el prefijo `\\?\` y mide sus coordenadas con `get_text("blocks")`.
- La guía tiene `#show figure.where(kind: table): set block(breakable: true)`:
  las tablas largas se parten en vez de saltar enteras.
- En esta máquina `python` es el 3.11 y **no tiene pymupdf**: los scripts de la
  exposición se corren con `py -3.13`.
- Los recortes nuevos de bibliografía los armó un script de la sesión; están
  en `01 - UNSAM\Taller de Fisica\Exposicion Compton y Pares\1 - Bibliografia\`
  (5 a 8) y en Drive. La guía se sube con `rclone copyto` al MISMO nombre, y
  se verifica que el ID no cambie (`14i9eYDstJoCGb6ORCHbDW4o38mDlI9SM`).
- **Abierto**: qué es la «L» de «P y L» (preguntarle a Aníbal) y la fecha de
  las notas de TAL-R6. Si Aníbal comenta algo más, entra como TAL-R7.

## 2026-10-20 — la exposición, tramo E1

**Qué hay:** la carpeta del grupo en Drive (ver `ESTADO_ACTUAL.md`) con la
bibliografía recortada, la guía y el esqueleto en Google Slides, compartida
con Agustín. Las **fuentes** viven en el repo privado
`catedras/taller-de-fisica/exposicion/`:

- `guia.typ` — se compila desde `proyectos/documentos`:
  `typst compile --root . --creation-timestamp=1767225600 catedras/taller-de-fisica/exposicion/guia.typ "<salida>.pdf"`.
  Importa cajas y paleta de `fisica-espacial/apunte/plantilla.typ` (no usa
  `apunte()`, que tiene la carátula de Física Espacial adentro).
- `recortar-figuras.py` — el Eisberg es un **escaneo**: las figuras se recortan
  por coordenadas. **Las coordenadas se miden con el OCR** (`get_text("blocks")`
  da la caja de cada rótulo), no mirando un render: el primer intento, a ojo
  sobre una imagen achicada por el visor, salió corrido.
- `validar.py` — todas las cuentas de la guía contra el libro; sale en 1 si
  una no coincide (probado rompiendo el borde Compton).
- `esqueleto.js` — el PowerPoint con pptxgenjs (no está instalado global:
  `npm install pptxgenjs@3.12.0` en una carpeta temporal y `NODE_PATH`). Se
  sube a Drive con `rclone copy ... --drive-import-formats pptx`, que lo
  convierte a Google Slides. **Si se regenera, se sube como archivo nuevo** y
  pisa lo que Fran y Agustín hayan editado: una vez que lo tocan, el
  esqueleto ya no se regenera, se edita en Slides.
- El validador del skill de pptx no corre desde su carpeta (pasa los 260
  caracteres): se copia con el prefijo `\\?\` a `%TEMP%\pv` y se corre ahí.

**Lo que pidió Fran sobre la guía (2026-10-20):** que diga de dónde salió cada
cosa **en el texto, como comentario**, y por qué de ese libro y no de otro; nada
de ids ni cuadros de fuente. Y sobre conectar con los temas de antes y de
después: era una sugerencia, y la guía la discute (parte 1).

**Lo que sigue:** que Fran y Agustín elijan orden, alcance y ejercicios
(cierra E1); después E2, armar la presentación. Aníbal espera ver avances.

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
