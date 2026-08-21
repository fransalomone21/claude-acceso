# claude-acceso

Repositorio con varios proyectos de Fran, separados por rama. **Los proyectos
no se mezclan**: cada uno vive en su rama y ahí se queda.

| Rama | Proyecto | Dónde | Estado |
|---|---|---|---|
| `claude/black-game-reverse-engineering-ricv3t` | Ingeniería reversa de **BLACK** (PS2) sobre PCSX2 | `black/` | **ACTIVO** |
| `claude/manual-analogica-tr0mk6` | Apunte de **Aplicaciones de Electrónica Analógica** (4.º año) en Typst — Parte I (materia y TPs) + Parte II (fundamentos de análisis de circuitos, orden de Teoría de Circuitos UNSAM) | `electronica-analogica/` | **ACTIVO** |
| `claude/apunte-electronica-analogica` | Idem, versión anterior de 43 páginas (solo Parte I) | `electronica-analogica/` | superada por la de arriba |
| `claude/phone-optimization-cleanup-vfdbb9` | Kit de diagnóstico y optimización Samsung vía ADB | raíz | suspendido (2026-08-15) |

La de teléfono está suspendida por decisión del usuario; no se mergea ni se
sincroniza con nada. El PR #1 queda abierto sin mergear a propósito —
mergearlo mezclaría los dos proyectos.

**Si estás en la rama del apunte, leé `electronica-analogica/ESTADO_ACTUAL.md`
y `HANDOFF.md`**: ahí están las decisiones de contenido y las trampas de Typst
ya pagadas.

**Si estás en la rama de BLACK, leé `black/CLAUDE.md`**: ahí está el contrato de
contexto del proyecto, las reglas y el índice de qué leer según la tarea.

---

## `perfil-global/` — el perfil de Claude, no un proyecto

Es la metodología transversal (skills, hook, lecciones aprendidas) que aplica
a **cualquier** proyecto, no sólo a BLACK. Vive en esta rama por razones
históricas: se creó acá.

Instalar o actualizar en una máquina:

```powershell
.\perfil-global\install.ps1
```

Copia el `CLAUDE.md` global, todas las skills (carpeta entera, incluidas sus
`referencias/`), el `recordatorio-transversal.md`, y configura el hook
`UserPromptSubmit` en `~/.claude/settings.json` — con respaldo previo y de
forma idempotente.

> **Pendiente conocido:** si algún día se reactiva otro proyecto en otra rama,
> `perfil-global/` no va a estar ahí. La solución no es mergear ramas (los
> proyectos no se mezclan) sino sacarlo a su propio repositorio. Mientras haya
> un solo proyecto activo, no hace falta.
