# Kit ADB para Samsung Galaxy — contrato de contexto

Kit de diagnóstico, limpieza y optimización para teléfonos **Samsung Galaxy**
vía ADB desde una PC. Sin root, sin apps de terceros en el teléfono, y todo
reversible.

**Estado: SUSPENDIDO** por decisión del usuario (2026-08-15). No se retoma sin
que él lo pida.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

## Qué leer

| Si la tarea es… | Leer |
|---|---|
| entender qué hace y cómo se usa | `README.md` (entero — está bien escrito) |
| ver o tocar un módulo | `modulos/<nombre>.sh` |
| saber qué es seguro sacar del teléfono | `datos/nivel1-seguro.txt`, `nivel2-opcional.txt`, `NO-TOCAR.txt` |

`informes/` **no se versiona**: lleva apps instaladas, serial y cuentas.

## La regla propia

**Todo lo que este kit hace tiene que ser reversible, y la reversión tiene que
estar probada**, no supuesta. `modulos/restaurar.sh` es parte del entregable,
no un extra.

## Nota de estructura (2026-08-27)

Este proyecto vivía en la **raíz** del repo: sus carpetas (`datos/`, `docs/`,
`lib/`, `modulos/`, `informes/`) estaban mezcladas con las de todos los demás.
Ahora está contenido acá. Si algo referencia rutas absolutas viejas, corregirlo
al encontrarlo.
