# Diagnóstico MSI Sword 15 — contrato de contexto

Diagnóstico de **batería, Secure Boot y arranque** de la notebook MSI Sword 15
del usuario. Medido en vivo el 2026-08-21, no reconstruido de memoria.

**Estado: CERRADO con informe.** No hay trabajo abierto. Si vuelve a aparecer
un síntoma, se reabre midiendo de nuevo — **no** leyendo el informe viejo: el
informe describe la máquina de agosto de 2026.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).

## Qué leer

| Si la tarea es… | Leer |
|---|---|
| entender qué se encontró | `INFORME.md` — separa a propósito lo **medido** de lo **inferido** |
| rehacer la captura | `recolectar.ps1` |
| analizar Secure Boot o firmas PE | `analizar-secureboot.ps1`, `firmas-pe.ps1` |

`datos-crudos/` **no se versiona**: lleva serial de BIOS, variables UEFI y
600 KB de eventos del sistema. Está en la máquina, y en `.gitignore`.
`informe-previo-gpt-2026.txt` es material de terceros, sin auditar.

## La regla propia

**Cada afirmación del informe lleva su grado** (medido / inferido) y el dato
crudo que la respalda. Si se agrega algo, se agrega con grado o no se agrega.
