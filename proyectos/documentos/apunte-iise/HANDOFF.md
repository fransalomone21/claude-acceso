# HANDOFF — Apunte de IISE

## 2026-10-25 (noche) — fase 11 ABIERTA y a medias (Fran tuvo que apagar)

**Hecho:** las cuatro presentaciones (11 A 46, 11 B 36, 12 24, 13 43
láminas, ninguna oculta) exportadas y extraídas a `fuentes/clases/clase-11a.txt`,
`-11b`, `-12`, `-13` (`extraer-clases.py` aprendió las partes A/B: ids `11a`,
figuras `c11a-pNNN`, `--pagina 11a:8`; las clases 1-10 salieron idénticas).
Glosario de las unidades 11, 12 y 13 escrito (23 términos, al final de
`fuentes/glosario.md`). Figuras copiadas a `apunte/figuras/`: c11a-p008,
c11a-p030, c11b-p007, c12-p008, c12-p024, c13-p010, c13-p015, c13-p040.
Módulos **escritos y SIN compilar ni incluir**: `m40-vv-del-producto.typ`,
`m41-modelos-y-ensayos.typ`, `m42-ait-de-un-subsistema.typ` (11 A entera y
11 B 1-23).

**Falta, en orden:**
1. `m43` (11 B 24-36: requerimientos contra especificaciones, subsistemas,
   _drivers_, la batalla de los subsistemas, el dilema riesgo = f(costo,
   calendario, desempeño), fases ESA/NASA/DoD, presupuestos y Akin; las
   láminas 26-36 son imagen: mirarlas con una hoja de contacto).
2. `m44-fase-d-a-fondo` (clase 12; la clave `fase-d-a-fondo` ya la cita
   M40): Fase D, GPM y el radar de JAXA, el tanque demisable de Cobham («¿qué
   le falta a esta especificación?»), ORR, waivers (propulsores al 95 %),
   FRR, JWST (PER, PSR, _test as you fly_).
3. `m45-gestion-de-interfaces` (clase 13, 3-16: Ariane 501, los cuatro tipos
   canónicos del MIT 16.842, DSM) y `m46` (13, 17-43: el riesgo es la clase
   10 otra vez → remitir a M39 y agregar sólo riesgo ≠ problema, la tormenta
   del Opportunity, Virgin Galactic; la FRR con criterios de entrada y de
   éxito, Ingenuity, «A pensar», Fase E).
4. `#parte(11, …)`, `#parte(12, …)`, `#parte(13, …)` + los `#include` en
   `apunte.typ` (después de m39, antes del anexo); compilar; `verificar-lexico.py`
   (ojo: `#t[interfaz]` en M42 puede no tener alias en el glosario: si da
   rojo, cambiar por un término que exista o sacar la marca), `grep -n '#t\[[^]]*$'`,
   `verificar-cobertura.py`; **mirar cada página nueva**; commit (publica solo)
   y `publicar-apuntes.ps1 -Verificar`.

**Trampa pagada hoy:** la tabla de documentos de la 11 A (diap. 43) se
escribió primero desde el `.txt` y tenía dos filas mal (las cruces de las
fases no se leen en el texto extraído); la arregló mirar el PNG. Toda tabla
con cruces o columnas se lee de la lámina.

## 2026-10-19 — fase 10 cerrada (el cohete de M17), nada a medias

El ejemplo «el cohete de agua: necesidades, L0 y L1» de M17 quedó con la
forma corregida por Petrilli y tiene medidor:
`verificar-ejemplo-cohete.py` (y `--sabotaje`). Si se vuelve a tocar el
ejemplo, correrlo: un L0 con número o un padre que no existe da rojo. Trampa
pagada al mirar el render: en la prosa, los IDs largos (`REQ-L0-3`) se parten
en el guion al final de renglón; van en `#box[...]`, y «250~m» con espacio
duro. Lo que queda es del método, no del apunte: DA-068 está **arreglado**
(falta validarlo con 3 sesiones auditadas) y su clase —fecha de vigencia de
todo ejemplar inyectado— sigue en `perfil-global/arquitectura/ORDEN-DE-ATAQUE.md`.

## PENDIENTE (2026-10-19, SUMAMENTE IMPORTANTE) — cómo se escribe el alcance, con evidencia de la práctica

**Pedido de Fran:** registrar en el apunte, «con más evidencia que la de la
cátedra (de la práctica)», cómo se escriben la necesidad, las metas, los
objetivos y el resto del Ejercicio de Alcance. Lo va a hacer en otra sesión;
abrir la **fase 9** del PDP con su criterio escrito antes de tocar un módulo.

**Lo que hay que agregar** (todo ya investigado y con fuente, ver abajo):

1. **La regla de forma (corregida el 2026-10-19):** la necesidad es una sola
   frase y nada más, sin justificación debajo; el contexto va antes, como
   antecedentes; metas y objetivos en una frase, con prosa sin rótulo si hace
   falta; el rationale, sólo en los requerimientos. Respaldo de la cátedra:
   Apollo (M17), CEV (M18) y Marte (M20), una línea por elemento. Respaldo de
   la práctica: NASA SEH rev. 2 (glosario y p. 49), JWST (Gardner et al.
   2006: el fondo científico va en su propia sección, antes de los
   objetivos), TESS. **Ojo:** una versión anterior de este pendiente decía
   «enunciado + justificación aparte»; estaba mal, ver
   `perfil-global/pilares/alcance-como-se-escribe.md`.
2. **Una sola necesidad**, sin nombrar la solución (SEH p. 49: dos necesidades
   obligan a un trade-off).
3. **Metas vs. objetivos:** metas con verbos de progreso; objetivos
   específicos, medibles, alcanzables y orientados al resultado, con verbos de
   completitud («determinar»); TBD permitido (SEH p. 49; Leisner); los tres
   tipos de objetivo (caracterización, prueba de hipótesis, analítico).
4. **Criterios de éxito:** misión completa (*baseline*) y mínima
   (*threshold*), como en los requerimientos de nivel 1 de TESS (2014).
5. **Hipótesis = supuesto** (ya está en M18; reforzarlo: catedras IIS-52).
6. **La autoridad en la práctica:** quién responde por la ciencia y quién
   tiene la autoridad técnica (TESS: el PI y Goddard).
7. **Un ejemplo completo nuevo**, si sirve: el alcance del TP final (CubeSat
   de radiación para la AMAS), que ya está escrito con este molde.
8. **El orden de la cadena:** la consigna del TP pone *hipótesis → misión* y
   el apunte (M18) *misión → hipótesis*; decir cuál y por qué.

**Cómo marcarlo:** lo de NASA va como evidencia de la práctica, separado de lo
que dijo la cátedra (memoria `feedback_apuntes-materia`: la mejora se marca
aparte). Dónde: probablemente una sección nueva al final de M18 o de M20;
decidirlo al abrir la fase.

**Fuentes, ya bajadas** en `C:\Users\frans\Desktop\01 - UNSAM\IISE\Trabajo Final\Fuentes\`:
`NASA - Systems Engineering Handbook rev 2 (2016).pdf`,
`NASA - TESS requerimientos de nivel 1 (2014).pdf`,
`NASA - Psyche requerimientos de nivel 1 (2020).pdf`,
`NASA - Writing Level 1 Requirements (Leisner).pdf`. Biblioteca pública:
<https://soma.larc.nasa.gov/stp/dynamic/programlibrary.html>. El destilado
ya hecho: `perfil-global/pilares/alcance-como-se-escribe.md` y
`perfil-global/pilares/nasa-seh/stakeholders.md` §3.11-3.13.

## Sesión 2026-10-14 — fase 8: resumen para el parcialito de hoy

**Hecho:** `resumenes/resumen-clases-8-9.typ` → PDF de 12 páginas, publicado
y verificado por MD5 en una carpeta nueva del Drive,
`Material de Estudio nuestro/Resumenes para parcialitos/Clases 8 y 9 (14-10)`.

**Cómo se hace el próximo resumen:** copiar la estructura de éste (cada tema:
definición con la palabra de la cátedra → idea → el ejemplo de la clase
contado de nuevo → trampa; al final «lo que puede caer» y siglas). El estilo
vive en `resumenes/estilo.typ` (importa la paleta del apunte). Se compila
**desde `apunte-iise`** con `typst compile --creation-timestamp=1767225600
--root . resumenes/<archivo>.typ resumenes/<archivo>.pdf` (sin `--root .` no
llega a la paleta; sin el timestamp el MD5 cambia en cada compilación). Se
declara en `.claude/apuntes-publicos.json` con su carpeta de clase.

**Trampa pagada:** los números de un ejemplo de la clase se sacan de la
**lámina**, no del texto extraído: en `clase-8.txt` las duraciones del té
salen en fila, sin decir a qué caja van, y la estructura de la red (qué rama
arranca dónde) sólo está en el PNG (`apunte/figuras/c08-p014.png`).

## Sesión 2026-10-13 — fase 7 cerrada: clases 8, 9 y 10 al apunte

**Hecho:** unidades 8, 9 y 10 (M28–M39), la sección de baselines en M15 y el
anexo A (el trabajo final, sección por sección). 191 páginas, publicado por
MD5. Ver `ESTADO_ACTUAL.md` arriba y `PDP.md` fase 7 (con los desvíos).

**Lo que la próxima sesión no tiene que rehacer:** extraer las clases 8, 9 y
10 (`fuentes/clases/clase-8.txt`, `-9`, `-10`, ya en el repo); el glosario de
esas unidades; los criterios del TP final (están en `catedras/iise/`, §E).

**Trampas nuevas, pagadas en esta sesión:**

- **Un `.pptx` con diapositivas ocultas exportado a PDF corre la numeración.**
  La clase 8 del 12/10 tiene la 39 y la 40 ocultas: «Guardar como PDF» dio 95
  páginas para 97 láminas. **Ahora se exporta con `exportar-pptx.ps1`** (en
  esta carpeta): copia, des-oculta todas las láminas, guarda el PDF e imprime
  cuántas había ocultas. Medido: con el script, 97 páginas para 97 láminas.
- **La cátedra re-sube los `.pptx` con cambios chicos** (la 44 de la clase 8
  apareció el 05/10 y desapareció el 12/10; en la 9, una lámina cambió de
  lugar). Antes de usar un número de diapositiva de un plan viejo, comparar
  las versiones lámina por lámina (texto + hash de imágenes).
- **`placement: auto` en las figuras grandes** evita las medias páginas en
  blanco, pero si dos figuras flotantes caen en la misma página que una caja
  partida, la caja queda con una tira vacía: esa figura va sin flotar.
- **Escala de riesgo:** la de NASA (diap. 68 de la clase 10) tiene el 1 como
  peor; la del ROV (diap. 49), el número alto como peor. M39 lo dice; no
  unificar sin avisar.

**Defecto viejo, anotado y sin tocar:** 5 tags `#t[]` partidos en M06, M08,
M09, M10 y M14 (ver `ESTADO_ACTUAL.md`, «Qué sigue»).

**PROYECTO CERRADO.** Las **siete** fases del PDP están cerradas: el apunte
está escrito (7 unidades, 28 módulos, 71 términos, **126 páginas, 18
figuras**), mapeado contra los parcialitos (16 preguntas, ninguna huérfana, con
medidor y saboteador) y **publicado en el Drive de los compañeros**, verificado
por MD5.

**Última sesión: 2026-09-21 (fases 5 y 6).** La fase 6 sumó los parcialitos 4
y 5 —que este proyecto daba por perdidos— al banco: 28 preguntas mapeadas, un
hueco real de contenido cerrado (la sexta categoría de requerimientos) y dos
precisiones que salieron de las correcciones del profesor. Antes, en la misma
jornada:

**Fase 5, figuras didácticas.** Se agregaron 7
figuras de las presentaciones donde el texto describía un diagrama sin
mostrarlo, se descartaron 5 candidatas, y `extraer-clases.py` aprendió
`--pagina cN:pM` para pedir una diapositiva por número (el umbral automático
dejaba afuera las que tienen diagrama *y* rótulos). Detalle completo en
`PDP.md` §4, fase 5. **El destino de publicación cambió**: ahora es
`IISE/Material de Estudio nuestro/Apunte GENERAL`, la subcarpeta que armó
Fran.

**Sesión 2026-10-08 (mantenimiento, fuera de la fase 7):** M25 completado contra
la clase 7 (matriz de funciones por fase, interfaces internas/externas, 3
figuras) y el índice con una franja por unidad (`#parte()` emite un heading
`<unidad>` oculto en el cuerpo; el show-rule del índice lo dibuja). Detalle en
`ESTADO_ACTUAL.md`. **Para la sesión de la unidad 9:** la matriz de funciones
por fase YA está en M25 §«El mapa» (clase 7, diap. 4); las diap. 32 y 50 de la
clase 9 se citan ahí, no se repiten en M15 (`PLAN-CLASES-8-9.md` corregido).
Ojo al escribir unidades 8 y 9: cada `#parte(N, …)` sale sola en el índice,
no hay que tocar nada más.

**Sesión 2026-10-05: llegaron las clases 8 y 9 y se registró el plan** (nada
redactado). Siguiente paso: abrir [`PLAN-CLASES-8-9.md`](PLAN-CLASES-8-9.md) y
correr su §0 (exportar a PDF los `.pptx` nuevos de las clases 8 y 9, extraer)
antes de escribir la unidad 8. Ojo: el PDF de la clase 8 que hay en Descargas es
de una versión vieja (97 páginas; el `.pptx` nuevo tiene 98, con una imagen
agregada en la diapositiva 44), así que no sirve.

**Fuera de eso no hay trabajo pendiente.** Lo que sigue abajo es referencia para
el día que haya que TOCAR algo: cómo se escribe un módulo y las trampas ya pagadas.

Última sesión: **2026-09-20 (fases 3 y 4)**. Mapeó las 16 preguntas de los
parcialitos 1-3 contra los módulos escritos, **encontró el mapeo anterior mal
en 9 de las 16**, lo corrigió con anclas `MNN §sección` y lo dejó medido por
`verificar-cobertura.py` + `probar-verificar-cobertura.py`. **No se escribió
contenido nuevo: no hizo falta, ninguna pregunta quedó huérfana.** Después, a
pedido de Fran, declaró el apunte en `.claude/apuntes-publicos.json` y lo
publicó en el Drive.

## La sesión anterior (redacción)

Escribió la unidad 7 (M24–M27), la última que faltaba: cómo se crea una arquitectura (síntesis/descubrimiento, 4 métodos,
factores de balance, arquitectura vs. diseño), Fase A a fondo (ConOps del
Mars 2020, herencia del Curiosity, un IRD real del GLAST), las revisiones
SRR y MDR una al lado de la otra, y el diagrama N² aplicado a interfaces con
el TDRS y una matriz real de 17 disciplinas. **Con esto, la fase 2 (redacción)
cerró: las 7 unidades están escritas.** La sesión abrió la fase 3 (cobertura
contra los parcialitos) en `PDP.md`, pero no hizo el trabajo de esa fase
todavía.

## Lo que la próxima sesión NO tiene que rehacer

- **Bajar ni extraer el material, ni escribir ningún módulo nuevo.** Las 7
  unidades (M00–M27) están escritas, compilando, con `verificar-lexico.py`
  en verde. **No hay unidad 8**: el apunte cubre las 7 clases completas.
- **El glosario.** 71 términos, las 7 unidades cubiertas.
- **Montar infraestructura Typst, ni el verificador de léxico.** Los dos
  están hechos y verdes desde la fase 0/1.
- **Volver a mapear los parcialitos 1 a 5.** Están mapeados y medidos: 28
  preguntas, 62 anclas, `verificar-cobertura.py` en verde. Los de las clases 7
  en adelante pueden aparecer o no — el 2026-09-21 aparecieron dos que este
  mismo archivo daba por imposibles, así que no se afirma nada al respecto.

## La fase 3, cerrada — qué quedó y por qué así

**Las 16 preguntas mapeadas, ninguna huérfana, ningún hueco de contenido.** El
mapeo vive en la columna «Dónde se responde» de `fuentes/parcialitos.md`, y
cada ancla es `MNN §título exacto de la sección`.

**El mapeo que ya estaba escrito ahí estaba mal en 9 de las 16.** Se había
hecho el mismo día, desde los parcialitos y sin abrir un módulo: CDIO y
triángulo de hierro cruzados entre M01 y M02, ambigüedad y entregables
cruzados entre M08 y M09, pensamiento holístico mandando a M04 cuando se
define en M06, y la tabla N² aplicada apuntando a M26 — la numeración anterior
a que la unidad 6 creciera a cinco módulos.

**Y por eso hay un script, en contra de lo que decía este mismo HANDOFF**
(«las 16 preguntas son estáticas, no hace falta»). Eran estáticas las
preguntas; lo que se mueve son los **módulos**, y ya se movieron una vez en
silencio. `verificar-cobertura.py` mide cuatro cosas —pregunta huérfana,
módulo inexistente, sección inexistente, y el conteo declarado contra el
contado— y `probar-verificar-cobertura.py` las pone en rojo a propósito, más
el control positivo.

Lo que el medidor **no** puede medir, y está escrito en su docstring: que la
sección realmente conteste la pregunta. Eso se lee. El script atrapa el ancla
rota, el módulo cruzado y la numeración corrida.

## Cómo se escribe un módulo (referencia, ya no hace falta escribir ninguno)

1. Leer **sólo** `fuentes/clases/clase-N.txt` (regla propia 6).
2. Escribir `apunte/modulos/mNN-clave.typ` y agregar su `#include` a
   `apunte/apunte.typ`, debajo de su `#parte(...)`.
3. Agregar al `fuentes/glosario.md` los términos nuevos de esa unidad,
   **antes** de marcarlos con `#t[]` en el módulo.
4. `typst compile apunte.typ apunte.pdf`, `python verificar-lexico.py`, y
   `grep -rn '#t\[[^\]]*$' apunte/modulos/*.typ` (ningún tag partido en el
   salto de línea — ver la trampa de abajo).
5. **Mirar las páginas compiladas.** Renderizarlas con
   `typst compile apunte.typ "$TEMP/iise-{p}.png" --ppi 110` y abrirlas con
   el tool de lectura de imágenes.

## Trampas ya pagadas (para cuando haga falta tocar un módulo de nuevo)

- **Un tag `#t[término]` partido en dos líneas del código fuente NO lo ve
  `verificar-lexico.py`** (el checker itera línea por línea). Typst compila
  igual —el content-block de un macro sí puede partirse—, así que el
  defecto es invisible en ambos sentidos. Pasó tres veces en la unidad 6 y
  una vez más en la unidad 7 (M25) antes de agregar
  `grep -n "#t\[[^\]]*$"` como parte del paso 4. Ya está en
  `perfil-global/chequeo-de-trabajo.md` como lección de proceso.
- **No re-`#definicion()`ar un término ya definido en otra unidad**, ni
  siquiera para decir "ya está definido" — imprime una segunda caja
  "DEFINICIÓN" con el mismo título, que no rompe el verificador (sólo mira
  `### ` en el glosario) pero confunde sobre dónde vive la definición real.
  Pasó en la unidad 6 (M21, dos veces) y otra vez en la unidad 7 (M24, con
  "arquitectura de sistema"). Para referenciar: `#clave[]`, `#deduccion[]`
  o prosa con `#t[término]` — nunca `#definicion()` de nuevo.
- **Una cita heredada de una sesión anterior también puede estar mal — y
  una unidad posterior puede tener la evidencia para corregirla.** Pasó
  entre la unidad 5 y la 6 (el corte de fases Formulación/Aprobación/
  Implementación). La regla propia 2 y la regla del repo (un dato vive en
  un solo lado) valen para las unidades ya cerradas también.
- **Cuando la cátedra usa dos siglas para la misma cosa sin avisar**
  (SDR/MDR en la unidad 7), no se elige una y se descarta la otra en
  silencio: se documenta la inconsistencia con `#cuidado`, tanto en el
  módulo como en el glosario. Es la misma lógica que "una excepción se
  declara, no se calla" del léxico.
- **Elegir la foto o el diagrama real por sobre el render genérico**,
  cuando hay las dos disponibles para la misma diapositiva o tema.
- **Una plantilla copiada trae el CONTENIDO del proyecto viejo**, no sólo
  el estilo, y compila igual de verde.
- **Tabla Typst: nunca `auto` si una columna tiene texto largo** — van
  fracciones explícitas, y aun así un encabezado largo en columna angosta
  se puede partir feo: se ve sólo mirando la página renderizada.
- **Una palabra con guión propio puede partirse mal al justificar** — usar
  el término ya establecido sin guión, si existe uno.
- **Una caja `#deduccion(titulo)` ya antepone "De dónde sale — " al
  título; `#ejemplo(titulo, cuerpo, nivel: "a-fondo")` lleva el argumento
  nombrado ANTES del bloque de contenido**, no después.
- **Un `#image()` con ruta fuera de la carpeta de `apunte.typ` no
  compila** (`would escape the project root`) — copiar el PNG a
  `apunte/figuras/` (carpeta plana, SÍ se commitea) y referenciarlo con
  `../figuras/archivo.png`.
- **No escribir scripts con heredoc.** Usar Write y correr con
  `python <ruta>`.
- **Los `.txt` se escriben en UTF-8 y se leen así.** La consola de Windows
  es cp1252: los `?` en pantalla no significan que el PDF esté mal.

## Lo que quedó abierto

**Nada.** El proyecto está cerrado: contenido, cobertura y publicación.

Si alguna vez hay que tocarlo, el circuito completo es: tocar el módulo,
recompilar, `verificar-lexico.py`, `verificar-cobertura.py`, mirar las páginas
que cambiaron, y `publicar-apuntes.ps1` — el medidor de cada arranque avisa si
el Drive quedó atrasado respecto del PDF local.

Y si aparece otro parcialito: se guarda el PDF en `fuentes/pdf/parcialitos/`
(ignorado por git: lleva nombre propio), se agregan sus filas a
`fuentes/parcialitos.md` con ancla `MNN §sección exacta` —leyendo el título del
`.typ`, no de memoria—, se actualiza el conteo declarado y se corre
`verificar-cobertura.py`. Es lo que se hizo el 2026-09-21 con el 4 y el 5, y
tomó una sesión corta.
