# Handoff — Taller de Física

**Escrito el:** 2026-09-13 · **Fase al cerrar:** 0 (Estructura y fuentes),
casi cerrada — 1 (Escribir) bloqueada a propósito, sin fecha.

## Arrancá por acá

**No escribas ningún módulo todavía.** Fran fue explícito: "todo lo de
taller de física es para un plazo más largo, yo te voy a decir cuándo
empezarlo". Si esta sesión llegó acá sin que Fran haya dado esa señal en el
chat que la trajo, lo único que hay para hacer es lo que sigue: cerrar el
recorte de Pisacane. Nada de contenido.

**Cerrar la fase 0:** leer `../fisica-espacial/fuentes/TEMARIO.md` y cruzarlo
contra el recorte propuesto de Pisacane que está en `docs/bitacora.md` (caps.
3, 4, 6, 8, 9, 11 de 12). Confirmar con Fran si algún tema del temario de
Física Espacial pide complementar con un capítulo que hoy está afuera (el más
probable: el 7, ambiente neutro/atmósfera, por el arrastre en LEO), o si
alguno de los seis propuestos en realidad no correlaciona con nada confirmado
y sobra.

## Lo que quedó a medias

El recorte de Pisacane. Todo lo demás de la fase 0 está cerrado: Ferraro
(caps. 1-3, confirmado por Fran como bloque cerrado) y Young-Freedman
(referencia general, sin capítulos fijos, también confirmado).

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
- El recorte propuesto y no confirmado: capítulos **3, 4, 6, 8, 9, 11** de
  12. El detalle de por qué cada uno entró o quedó afuera está en
  `docs/bitacora.md`.

## Si hay que abrir un chat nuevo

```
Retomo el Taller de Física (proyectos/documentos/taller-de-fisica).

QUÉ LEER: CLAUDE.md, PDP.md completo (sobre todo §4 y §6), ESTADO_ACTUAL.md
y este HANDOFF.md. Si vas a cerrar el recorte de Pisacane, además
../fisica-espacial/fuentes/TEMARIO.md.

FASE: 0 (estructura y fuentes), casi cerrada. La cierra confirmar el recorte
de Pisacane contra el temario de Física Espacial (ver "Arrancá por acá" de
este HANDOFF).

NO ESCRIBAS NINGÚN MÓDULO DE CONTENIDO salvo que el mensaje que abrió esta
sesión diga explícitamente que Fran dio la señal de arrancar la fase 1 — lo
dijo así el 2026-09-13: "yo te voy a decir cuándo empezarlo".

MODELO Y ESFUERZO: Sonnet, esfuerzo low — es cerrar un cruce de dos listas de
temas ya escritas, no un diseño nuevo.

PRIMER COMANDO:
  cd C:\Users\frans\Desktop\claude-acceso ; .\cascada.ps1 taller-de-fisica
```
