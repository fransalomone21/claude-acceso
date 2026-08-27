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

## `perfil-global/` — MOVIDO a su propio repositorio (2026-08-17)

Era la metodología transversal (reglas, skills, hooks, lecciones aprendidas)
que aplica a **cualquier** proyecto, no sólo a BLACK, y vivía en esta rama por
razones históricas. Ahora vive en
**https://github.com/fransalomone21/perfil-global** (privado), clonado
localmente en `C:\Users\frans\Desktop\perfil-global\` — hermano de este repo,
no adentro. Instalar o actualizar en una máquina, desde ESE repo, no desde
acá:

```powershell
.\install.ps1
.\verify-install.ps1
```

La copia que sigue en esta rama es un **espejo temporal**, sin editar: se
borra en una sesión aparte una vez confirmado el uso real desde el repo
nuevo. Correr `install.ps1` desde acá pisaría `origen.txt` apuntando de
vuelta a `claude-acceso`. Detalle completo de la migración —cómo se conservó
la historia real de commits, cómo se probó por efecto— en
[`perfil-global/PENDIENTES.md`](perfil-global/PENDIENTES.md), sección 4.
