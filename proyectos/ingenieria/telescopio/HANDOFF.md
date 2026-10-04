# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-04 · **Fase al cerrar:** 0 (Concebir, Pre-Fase A) —
**abierta**, recién arrancada.

## Arrancá por acá

1. `.\cascada.ps1 telescopio -Necesidad diseno` y leer lo que imprima.
2. `ESTADO_ACTUAL.md` entero.
3. **Preguntarle a Fran si ya midió.** La fase 0 no avanza sin
   `docs/02-protocolo-medicion.md` ejecutado: todo lo demás depende de la masa
   y del centro de masa. Si no midió, no hay nada que diseñar — lo que hay que
   hacer es ayudarlo a medir, no adelantar geometría.

## Lo que quedó a medias

- **Las tres preguntas de valor** que se le hicieron el 2026-10-04 (qué cuenta
  como ganar, los pesos del trade study, Sony o celular). Si contestó, van a
  `PDP.md` §6 y al trade study, y **con fuente «Fran»**.
- **El trade study CS vs VNS no está escrito.** El catálogo de conceptos sí
  (`docs/04-conceptos.md`). Falta `docs/05-trade-study.md`, y no se puede
  escribir sin la masa medida ni sin los pesos de Fran.
- **El modelo 3D no se revisó pieza por pieza** contra las medidas. Se contó
  qué hay en `cad/` y se leyó el encabezado del macro VBA; las 22 piezas no se
  abrieron.
- **El Google Doc** quedó creado con el índice y el contenido de hoy. Cuando
  entren las mediciones, se actualiza ahí también.

## Lo que NO hay que volver a intentar

- **No volver a elegir CS por el argumento de 2026-08.** Decía que era la
  única arquitectura que deja poner el eje polar en el centro de masa, y es
  falso: el VNS cumple lo mismo, con apoyo real en tres puntos y más carga.
  Está medido por lectura en `docs/04-conceptos.md`.
- **No usar los DXF de `cad/DXF/` para cortar nada.** Salen de `H = 64 cm`,
  que es una estimación, y de una arquitectura que todavía compite.
- **No manipular sketches de SolidWorks por nombre con `SelectByID2`** ni
  cerrar un sketch 3D con `InsertSketch`: las seis trampas ya están escritas
  en el encabezado de `cad/PlataformaEcuatorial.bas`. Leerlo antes de tocar el
  macro ahorra la sesión entera.
- **No calcular geometría de la plataforma antes de la medición.** Ya se hizo
  una vez y hay que rehacerlo.

## Datos que no se pueden aproximar

- Latitud de diseño: **34,5° S** (Don Torcuato, Buenos Aires).
- Telescopio: newtoniano **200 mm de apertura, 1200 mm de focal**, f/6.
- Fórmulas paramétricas del CS, tal como quedaron en 2026-08:
  `R = (H − z_r)·cos(phi) + y_r·sin(phi)` y
  `t = y_r·cos(phi) + (z_r − H)·sin(phi)`, con `t` negativo hacia el norte.
- Corrección de tangente: `x(t) = L·tan(ω·t)` con **ω = 7,2921e−5 rad/s**.
- Geometría del VNS: el sector elíptico es un sector circular **comprimido por
  `cos α`**; después se parte en dos, cada uno girado `β = 90° − α` alrededor
  de un eje vertical y **estirado por `1/cos β`**. La velocidad deja de ser
  constante pero la desviación es **menor que ±1 %**.
- VNS construido y medido por Reiner Vogel: **45 kg** de telescopio, base de
  12 mm, mesa de 18 mm con vigas de 20 mm, sectores de aluminio AlMgSi0.5 de
  5 mm.
- σ Octantis: **magnitud 5,4**, a **1° 8'** del polo sur celeste.
- Rulemanes `608ZZ`: 8 mm de agujero, **22 mm de exterior**, 7 de ancho.
- Macro VBA: `cad/PlataformaEcuatorial.bas`, **1571 líneas**.
- Fuentes de la investigación: `docs/04-conceptos.md` §0 (los cuatro links).

## Si hay que abrir un chat nuevo

```
Proyecto: telescopio (automatización del 200/1200), en claude-acceso.

0. Si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh   (desde claude-acceso) y leer lo que liste.
1. .\cascada.ps1 telescopio -Necesidad diseno   y leer todo lo que exija la puerta.
2. Leer proyectos/ingenieria/telescopio/ESTADO_ACTUAL.md entero, y
   docs/02-protocolo-medicion.md.
   NO leer el CAD ni el macro VBA salvo que la tarea sea CAD.
3. Fase 0 (Concebir, Pre-Fase A). La cierran TRES cosas: los tres números
   medidos (masa, centro de masa 3D, ¿llega a foco?), el inventario sin
   ninguna fila en "?", y UNA arquitectura elegida en trade study con pesos
   de Fran y sin empate.
4. Modelo: Opus, esfuerzo high, sin fan-out. Es diseño y decisión, un solo hilo.
5. Estado de la máquina: nada montado, nada corriendo, ningún parche vivo.
   SolidWorks instalado (versión sin confirmar). El macro VBA no se ejecutó
   nunca en esta máquina.
6. Primer comando: preguntarle a Fran si ya ejecutó el protocolo de medición.
   Si no, la tarea es ayudarlo a medir, no diseñar.
7. Lo que ya está resuelto y no se rehace: el PDP con sus 6 fases, el ConOps,
   el catálogo de conceptos con sus fuentes, el protocolo de medición y el
   inventario (la plantilla, no los datos).
```
