# T19a — los proyectos de materia no se frenan por la fase NASA

Primera rebanada de T19 («cascada proporcional», lluvia §6 fila 1c), construida el 2026-10-12 a la noche porque
bloqueaba el estudio de Fran. Requisitos: N-09 (nueva), L0-03 y L1-04 acotados, L2-VER-01, L2-AUD-01 y L2-PTA-01
reescritos sobre el término Proyecto_Con_Ciclo_NASA ([`10-requisitos.md`](10-requisitos.md)).

## 1. El problema, medido

Fran (2026-10-12, noche): la arquitectura completa es para los proyectos grandes (BLACK, el telescopio), donde su
falta afecta la necesidad; los apuntes, actividades y parcialitos siguen con el método que ya tienen: «no me interesa
si el apunte de física no está bien hecho con la arquitectura, porque es funcional y alcanza».

Medido con `cascada_puerta.exigido()` sobre el árbol real, necesidad `materia`, antes del cambio:

| Proyecto | Naturaleza | Fase del PDP | La puerta |
|---|---|---|---|
| apunte-iise | documentos | 7, Fase B | **FRENADO**: niega todo menos escribir requisitos |
| software-de-vuelo | documentos | 2, Fase D | **FRENADO** |
| cohete-de-agua | documentos | Fase A | **FRENADO** |
| fisica-espacial, clase-asincronica-3, electronica-analogica, taller-de-fisica | documentos | sin tipo NASA | pasa |

T13 («la fase manda») frenaba por el **tipo** de la fase sin mirar la naturaleza del proyecto: tres de los cinco
expuestos eran de materia, y uno era IISE, el apunte que Fran tiene que ampliar para los parcialitos. En un proyecto de
materia el papel que manda es el criterio de la cátedra (`catedras/<materia>/CRITERIOS.md`), que la necesidad `materia`
ya exige leer.

## 2. Qué se cambia

Una sola condición, en un solo lugar: `exige_requisitos(proy, fase)` en `.claude/hooks/cascada_puerta.py` = fase A-D
**y** la carpeta de naturaleza del proyecto en `NATURALEZAS_NASA` (hoy `("ingenieria",)`). La usan las tres piezas que
frenan o dan rojo: la puerta (`exigido`), su verificador (`--verificar`) y la auditoría (`auditar-sesion.py`, P7).
La compuerta de fase (`fase_activa.py`) sigue listando los productos NASA en todos los proyectos: informa, no frena.

**No se saca:** el libro de bolsillo (`nucleo-ise.md`) sigue en la base de todos los proyectos (11 115 caracteres por
entrada). Sacarlo de los de materia toca la regla 16, el enrutador y la auditoría (P3): es del resto de T19, no de lo
urgente.

## 3. Cómo se verifica

- Autotest de la puerta: caso «T19a CONTROL» (apunte en Fase C sin requisitos → pasa), el `--verificar` no lo lista, y
  el mutante «documentos con ciclo NASA» lo vuelve a frenar (visto en su caso).
- Autotest de la auditoría: el mismo control (P7 NO APLICA) y su mutante (vuelve el ROJO).
- `probar-t13.py`: sus mutantes se mudaron a la línea nueva (`exige_requisitos`) en el mismo turno; los 4 vistos.
- **Efecto real:** `--verificar` pasó de 5 expuestos a 2 (black, minecraft-amigos), y la medición de §1 ya no frena
  a ningún proyecto de materia.

## 4. Riesgo

Un proyecto de materia que de verdad diseña algo técnico (un TP con hardware, el cohete de agua) ya no recibe el
freno de requisitos. Se acepta por N-09: lo que manda ahí es la cátedra, y el TP del cohete ya tiene sus requisitos
dentro del informe. Si un proyecto de materia se vuelve grande, se muda a `proyectos/ingenieria/` y vuelve a tener
el ciclo NASA entero: el criterio es la carpeta, no una lista de nombres.
