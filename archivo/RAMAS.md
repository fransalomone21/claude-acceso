# Las ramas viejas — qué quedó en cada una

Antes del 2026-08-27 los proyectos se separaban **por rama**. Ahora se separan
por carpeta y hay una sola rama viva: `main`.

**Ninguna rama se borró.** Están en el repo y en `origin`, y se pueden mirar
cuando haga falta. Esta tabla existe para no tener que mirarlas.

| Rama | Qué tenía | Qué se hizo |
|---|---|---|
| `claude/black-game-reverse-engineering-ricv3t` | BLACK hasta la fase 7e — **34 commits que main no tenía** | **mergeada a main**. Es el BLACK bueno |
| `claude/manual-analogica-tr0mk6` | el apunte de Electrónica Analógica, 103 pág. | era la base de `main` |
| `claude/apunte-electronica-analogica` | el apunte en su versión de 43 pág. | 0 commits únicos: superada |
| `claude/phone-optimization-cleanup-vfdbb9` | el kit ADB, en la **raíz** del repo | 0 commits únicos. El kit está en `proyectos/ingenieria/telefono-samsung/` |
| `claude/friendly-diffie-9bdcee` | idem anterior | 0 commits únicos |
| `claude/goofy-chaum-61dbef` | idem anterior | 0 commits únicos |
| `origin/claude/exam-key-terms-k2fxpz` | repaso oral de IISE: guion + audios. **Rama huérfana**, sin ancestro común | traída a `proyectos/documentos/repaso-iise/` con `git read-tree --prefix` |
| `origin/claude/infraestructura-global-fase-2-45vjd9` | 3 commits del **2026-08-14** sobre `preparar_entorno.ps1` y el estado de BLACK | **no se mergeó**: main ya tiene el arreglo de encoding y el archivo más completo (17908 vs 17464 bytes). Mergearla habría revertido BLACK trece días |

## Por qué esto no vuelve a pasar

El problema no era tener ramas: era usarlas para separar proyectos. Una rama
esconde el estado del proyecto detrás de un `git checkout`, y un
`ESTADO_ACTUAL.md` que no se puede ver desde donde estás parado **miente por
omisión** — declaraba la fase 5 cuando el proyecto iba por la 7e.

Las ramas siguen siendo útiles para lo que sí son: trabajo en curso que
todavía no se integra, y experimentos que pueden salir mal. Cuando el trabajo
cierra, se mergea a `main`.

## En el repo del perfil

| Rama | Qué tenía | Estado |
|---|---|---|
| `rescate/disco-20260827` | el estado del disco antes de reconciliar las dos historias del perfil | **no borrar todavía**: tiene ~115 renglones propios sin auditar uno por uno |
