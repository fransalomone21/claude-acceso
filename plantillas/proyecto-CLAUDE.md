# Proyecto <NOMBRE> — contrato de contexto

> Plantilla. Copiar a `proyectos/<naturaleza>/<proyecto>/CLAUDE.md`.
> Este archivo es el **nivel 4** de la cascada: se lee entero al entrar al
> proyecto, y de ahí se salta a lo que la tarea pida. Es el índice, no el
> manual. Si crece más de una pantalla y media, algo que debería estar en
> `docs/` se metió acá.

<!-- Una o dos frases: que es el proyecto y para que. -->

**Naturaleza:** `ingenieria` / `documentos` / `seguimiento` — ver
[`plantillas/naturalezas/<nat>.md`](../../../plantillas/naturalezas/) para lo
que se lee siempre en esta clase de proyecto.

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| entender cómo se llegó a algo, o qué no funcionó | `docs/bitacora.md` |
| | |

**No leas todo "por las dudas".** Cada documento cuesta contexto, y el
contexto es lo que después falta para pensar el problema difícil.

## Las reglas propias de este proyecto

> Sólo las que **no** están ya en el perfil global. Repetir una regla global
> acá la hace divergir de su original. Si no hay ninguna propia, borrar esta
> sección — es una respuesta válida.

1.

## Dónde está cada cosa

```
PDP.md            el plan: fases, criterios de salida, riesgos, decisiones
CLAUDE.md         este archivo: el indice, se carga solo al abrir aca
ESTADO_ACTUAL.md  donde estamos hoy. Se actualiza cuando cambia algo real
HANDOFF.md        el mensaje para la proxima sesion
docs/             el detalle
```

## Dónde corre esto

<!-- Si el trabajo necesita algo que solo existe en esta maquina (un emulador,
     un dispositivo conectado, un archivo pesado que no esta en el repo),
     decirlo aca. Una sesion que no tiene eso al alcance debe DECIRLO en vez
     de simular resultados. Si no aplica, borrar la seccion. -->

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.

Sin esos pasos, la próxima sesión arranca de cero.
