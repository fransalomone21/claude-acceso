# claude-acceso

Repositorio con varios proyectos de Fran, separados por rama. **Los proyectos
no se mezclan**: cada uno vive en su rama y ahí se queda.

| Rama | Proyecto | Dónde | Estado |
|---|---|---|---|
| `claude/black-game-reverse-engineering-ricv3t` | Ingeniería reversa de **BLACK** (PS2) sobre PCSX2 | `black/` | **ACTIVO** |
| `claude/phone-optimization-cleanup-vfdbb9` | Kit de diagnóstico y optimización Samsung vía ADB | raíz | suspendido (2026-08-15) |

**La rama de trabajo es la de BLACK.** La de teléfono está suspendida por
decisión del usuario; no se mergea ni se sincroniza con nada. El PR #1 queda
abierto sin mergear a propósito — mergearlo mezclaría los dos proyectos.

**Si estás en la rama de BLACK, leé `black/CLAUDE.md`**: ahí está el contrato de
contexto del proyecto, las reglas y el índice de qué leer según la tarea.

---

## `perfil-global/` — el perfil de Claude, no un proyecto

Es la metodología transversal (reglas, skills, hooks, lecciones aprendidas)
que aplica a **cualquier** proyecto, no sólo a BLACK. Vive en esta rama por
razones históricas: se creó acá.

**El mapa está en [`perfil-global/README.md`](perfil-global/README.md)**: qué
hay, en qué nivel de mecanismo vive cada regla, y las cinco cosas que hay que
saber sin leer nada.

Instalar o actualizar en una máquina:

```powershell
.\perfil-global\install.ps1
.\perfil-global\verify-install.ps1
```

Copia el `CLAUDE.md` global, todas las skills (carpeta entera, incluidas sus
`referencias/`), los cuatro archivos que inyectan los hooks, `herramientas/` y
el puntero `origen.txt` que las hace escribir de vuelta en este repo — con
respaldo previo y de forma idempotente. `verify-install.ps1` comprueba el
**efecto** de los hooks corriéndolos por Git Bash, no que los archivos estén.

Sus pendientes —incluido el de sacarlo a su propio repositorio, cuya condición
ya se dio con la aparición de `electronica-analogica/`— están en
[`perfil-global/PENDIENTES.md`](perfil-global/PENDIENTES.md).
