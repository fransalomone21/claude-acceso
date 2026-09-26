# Proyecto metodo-agustin — contrato de contexto

Pasar el método de trabajo de Fran —pilares, reglas, skills, hooks, frenos,
lecciones, cascada— a la notebook de Agustín, **sin** los proyectos de Fran y
sin nada personal, como un núcleo que se **genera** desde el repo de Fran y
viaja por GitHub.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md)
para lo que se lee siempre en esta clase de proyecto.

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| qué va al núcleo y qué no | `PDP.md`, secciones 2 y 6 |
| entender cómo se llegó a algo, o qué no funcionó | `docs/bitacora.md` |

**No leas todo "por las dudas".** Cada documento cuesta contexto, y el
contexto es lo que después falta para pensar el problema difícil.

## Las reglas propias de este proyecto

1. **El `install.ps1` del export no se corre nunca en esta máquina.** No tiene
   parámetro de destino: escribe en `%USERPROFILE%\.claude` y pisaría el
   perfil instalado de Fran. El export se verifica como carpeta; la
   instalación se verifica en la notebook de Agustín.
2. **Nada sale del disco de Fran sin pasar el verificador del export en
   verde.** El filtro de personales es la única parte irreversible del
   proyecto (PDP §3, aspecto `b`).
3. **El nombre "Fran" se reemplaza sólo en los archivos operativos.** En las
   lecciones y los pilares es la historia del caso (PDP §6).

## Dónde está cada cosa

```
PDP.md            el plan: fases, criterios de salida, riesgos, decisiones
CLAUDE.md         este archivo: el indice, se carga solo al abrir aca
ESTADO_ACTUAL.md  donde estamos hoy. Se actualiza cuando cambia algo real
HANDOFF.md        el mensaje para la proxima sesion
docs/             el detalle (bitacora)
```

## Dónde corre esto

Las fases 0 y 1 corren acá, en la notebook de Fran: el exportador lee los dos
repos de Fran y escribe en una carpeta de scratch. Las fases 3 y 4 corren
**sólo en la notebook de Agustín**: una sesión en esta máquina no las puede
certificar, y si lo intenta tiene que decirlo en vez de simular el resultado.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.

Sin esos pasos, la próxima sesión arranca de cero.
