# Las fuentes del Taller de Física — con ruta exacta

Los PDFs no se commitean: pesan demasiado y no son nuestros. Esta tabla dice
dónde están en el disco. Todos viven en
`C:\Users\frans\Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\`
— la misma carpeta que usa `fuentes/RUTAS.md` de `fisica-espacial`.

**Ojo con el path largo de Pisacane: localizarlo con `glob`, nunca escribir
el nombre a mano.** Su ruta completa pasa los 260 caracteres que Windows
permite sin el prefijo `\\?\`; `os.path.exists()` y `pymupdf.open()` fallan
en silencio con "no such file" sobre un archivo que SÍ existe si no se usa
ese prefijo. Medido el 2026-09-13.

| Fuente | Archivo | Alcance confirmado |
|---|---|---|
| Ferraro, *El espacio-tiempo de Einstein* (2da ed.) | `El espacio-tiempo Ferraro 3 Cap (2).pdf` — 137 páginas, sólo capítulos 1-3 (el resto del libro no está en este PDF) | **Cerrado.** Cap. 1 "El espacio y el tiempo antes de Einstein" (incl. 1.3 Galileo y las leyes del movimiento), cap. 2 "En busca del éter" (Michelson-Morley y precursores), cap. 3 "Espacio y tiempo en Relatividad Especial" (postulados, transformaciones de Lorentz, dilatación/contracción, paradoja de los gemelos, Doppler). Offset: página impresa = página del PDF − 14 (medido: PDF pág. 130 = impresa 116, §3.16). |
| Pisacane, *The Space Environment and Its Effects on Space Systems* (AIAA, 2008) | `The Space Environment and Its Effects on Space Systems __ -- Pisacane, Vincent L_ -- ... -- An.pdf` — 441 páginas, 12 capítulos, con capa de texto (no hace falta rasterizar) | **Cerrado (2026-09-13). 7 capítulos: 3, 4, 5, 6, 8, 9, 11** de 12 — 3 (Sol), 4 (campos magnético/eléctrico), 5 (campo gravitatorio: WGS84, mareas, precesión por J2 — continúa el M6 de `fisica-espacial`, que sólo tiene Newton básico), 6 (magnetosfera y radiación), 8 (plasma y carga eléctrica), 9 (radiación sobre materiales), 11 (meteoroides y basura espacial). Fuera: 1, 2, 7, 10, 12 (ver `docs/bitacora.md` para el porqué de cada uno). Fran confirmó el criterio: "correlativo = continúa un tema ya confirmado", por eso el 5 entra. |
| Young, Freedman, Sears, Zemansky, Ford — *Física universitaria 2, con física moderna* (Pearson, 2018) | `Hugh D. Young_ Mark Waldo Zemansky_ Francis Weston Sears_ Roger A. Freedman_ Albert Lewis Ford - Física universitaria con física moderna 2-Pearson Educación (2018).pdf` — ya está citado en el apunte de `fisica-espacial` como "S&Z" | **Referencia general, sin capítulos fijos.** Fran: "tenelo de referencia para los temas que hay que desarrollar del taller de física" — se consulta según haga falta al escribir, no se le arma un recorte previo como a los otros dos. |
