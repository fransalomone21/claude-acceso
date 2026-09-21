# HANDOFF — Apunte de IISE

Última sesión: **2026-09-20 (cierre de la fase 3)**. Mapeó las 16 preguntas de
los parcialitos 1-3 contra los módulos escritos, **encontró el mapeo anterior
mal en 9 de las 16**, lo corrigió con anclas `MNN §sección` y lo dejó medido
por `verificar-cobertura.py` + `probar-verificar-cobertura.py`. **No se escribió
contenido nuevo: no hizo falta, ninguna pregunta quedó huérfana.** La fase 3
quedó cerrada en `PDP.md`; **la única fase abierta es la 4 (publicación), y es
decisión de Fran**.

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
- **Discutir los parcialitos 4 a 7.** No van a llegar (decisión de Fran,
  2026-09-20); el apunte no se escribe en función de ellos.

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

1. **Fase 4** (publicación al Drive), y es **decisión de Fran, no automática**:
   declarar el PDF en `.claude/apuntes-publicos.json`, subirlo a la carpeta
   `IISE` con `publicar-apuntes.ps1`, y dejar `-Verificar` en verde.
2. **Nada de contenido queda pendiente.** El apunte de IISE, como cuerpo de
   texto, está terminado: 28 módulos, 71 términos, 115 páginas.
3. **Si aparecieran los parcialitos 4 a 7** —no se espera que aparezcan—: se
   agregan sus filas a `fuentes/parcialitos.md`, se actualiza el conteo
   declarado y se vuelve a correr `verificar-cobertura.py`, que se pone en
   rojo solo si alguna queda huérfana o mal anclada.
