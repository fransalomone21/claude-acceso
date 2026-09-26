# Estado actual — metodo-agustin

**Última actualización:** 2026-09-26

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Diseño y PDP | cerrada |
| 1 — Exportador y verificador de privacidad | **en curso** |
| 2 — Publicación | pendiente |
| 3 — Instalación en su notebook | pendiente |
| 4 — Primera actualización | pendiente |

**Qué cierra la fase en curso:** el export generado en una carpeta de scratch
pasa el verificador en verde, y `probar-exportador.ps1` lo pone en rojo cinco
de cinco (ruta `frans`, mail, DNI, lección `fuera`, "Fran" en un archivo
operativo) y vuelve al verde al sacar la siembra.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| La notebook de Agustín tiene Windows | Lo dijo Fran | 2026-09-26 |
| Sólo ida: las lecciones de Agustín no vuelven | Decisión de Fran | 2026-09-26 |
| "Fran" aparece 103 veces en `perfil-global` | `grep -rIoi "\bfran\b"` sobre `.md`, `.ps1`, `.py` | 2026-09-26 |
| Rutas `frans` / `fransalomone` fijas en 7 archivos de `perfil-global` | `grep -rIl` | 2026-09-26 |
| 248 lecciones: 126 `propia`, 104 `foldeada`, 18 `fuera` | conteo sobre `lecciones.jsonl` | 2026-09-26 |
| `install.ps1` escribe siempre en `%USERPROFILE%\.claude`: no tiene parámetro de destino | su bloque `param()` sólo tiene `RepoRoot` | 2026-09-26 |
| `bootstrap.ps1` clona `fransalomone21/perfil-global` (línea 102) | `grep` | 2026-09-26 |
| `chequeo-completo.ps1` corre dos medidores y un saboteador de Drive (líneas 51, 57 y 84) | `grep` | 2026-09-26 |
| Los libros de los pilares no están en git | `perfil-global/.git` pesa 8,4 MB, y lo trackeado más grande pesa 212 KB | 2026-09-26 |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| El cuerpo de las lecciones casi no tiene datos personales (la regex encontró 1 "DNI" y 0 mails) | la lectura humana de las 13 lecciones de `seguimiento/` | la regex no ve pesos, nombres propios ni números de trámite |
| Agustín tiene cuenta de GitHub | que Fran pase el usuario | no se preguntó con éxito todavía |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|

## Lo próximo

Escribir `exportar-nucleo.ps1` y `probar-exportador.ps1` (fase 1). Antes de la
fase 2 hace falta el usuario de GitHub de Agustín.
