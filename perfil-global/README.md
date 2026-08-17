# `perfil-global/` — el mapa

Cómo se trabaja, en cualquier proyecto. No es un proyecto: es el perfil que se
instala en la máquina y aplica a toda sesión de Claude Code.

Se edita **acá** (queda commiteado) y se instala en `~/.claude/`, que es una
copia. Editar `~/.claude/` a mano es escribir en algo que la próxima
instalación pisa.

```powershell
.\perfil-global\install.ps1        # instala o actualiza
.\perfil-global\verify-install.ps1 # verifica el EFECTO, no que los archivos existan
```

---

## Los cuatro niveles, y cuál dispara solo

Una regla que depende de que alguien la recuerde no es una regla: es una
intención (lección 11). Por eso cada cosa del perfil vive en el nivel más
confiable que su costo permite.

| Nivel | Mecanismo | Dispara | Qué vive acá |
|---|---|---|---|
| 4 | permiso denegado / validación | imposible saltearlo | (nada todavía) |
| 3 | **hook** `SessionStart` | una vez por sesión — puede ser largo | `pilares.md` (**Nivel 0**: los fundamentos destilados de los libros) · `apertura-proyecto.md` (el cuadro de fase) · `chequeo-de-trabajo.md` (las 32 lecciones comprimidas) |
| 3 | **hook** `UserPromptSubmit` | **en cada prompt** — tiene que ser corto | `recordatorio-transversal.md` (cuadro + chequeo de 5 puntos) |
| 2 | `CLAUDE.md` global | si se leyó el archivo (se carga solo) | las 7 reglas absolutas |
| 1 | skill de consulta | sólo si alguien la invoca | las 6 skills de abajo |

Los archivos que se inyectan van en **ASCII puro**: la consola de Windows los
lee como cp1252 y los acentos salen mojibake.

## Las skills

| Skill | Para qué | Cuándo |
|---|---|---|
| `/cuadro-de-fase` | las tres líneas que abren toda respuesta, y el mensaje de retome | si el cuadro se dejó de poner, o no se sabe qué escribir en una línea |
| `/enrutador-modelo` | qué corre en Opus, Sonnet y Haiku — y la autocalibración cuando el tramo no sale | al empezar un tramo nuevo, o ante la tentación de preguntar qué modelo usar |
| `/engineering-orchestrator` | la metodología completa: evidencia, contexto, subagents, handoff, costos, ingeniería de sistemas | al empezar una tarea de ingeniería nueva o ante una decisión de arquitectura |
| `/lecciones-aprendidas` | los 26 errores de proceso con su caso concreto | antes de investigar o debuggear |
| `/spec-interview` | sacar el spec antes de tocar código | antes de construir algo no trivial |
| `/verify-before-build` | chequeo de tres capas antes de la primera línea | después del spec, antes de construir |

## El aprendizaje: tres capas, un solo registro

Lo que ya costó tiempo **por cómo se trabajó** (no por lo que decía el código)
se registra una vez y se lee en tres formatos, según lo que haga falta:

| Capa | Archivo | Cuándo entra | Costo |
|---|---|---|---|
| Síntesis | `chequeo-de-trabajo.md` | **sola**, en cada sesión | ~70 líneas |
| Índice | `aprendizaje/lecciones.jsonl` → `aprender.py digesto` | cuando se busca una regla puntual | ~35 líneas |
| Historia | `lecciones-aprendidas/SKILL.md` | cuando la lección aplica y hace falta el caso | 800 líneas |

Registrar una lección nueva — desde **cualquier** carpeta de la máquina, no
sólo desde este repo:

```
python perfil-global\herramientas\aprender.py agregar ^
    --titulo "..." --costo "..." --sintoma "..." --regla "..." ^
    --grupo evidencia|busqueda|medicion|herramientas|proceso|entorno ^
    --proyecto black|perfil|general
```

El **síntoma se escribe como se veía antes de entenderlo**: es la única forma
de reconocerlo la próxima vez. La copia instalada en `~/.claude/herramientas/`
encuentra el repo por `~/.claude/aprendizaje/origen.txt`, que escribe
`install.ps1` — el registro se commitea siempre, nunca queda sólo en la
máquina.

`install.ps1` avisa si `chequeo-de-trabajo.md` quedó atrasado respecto del
registro: compara el número que el chequeo declara contra las entradas reales.
Sintetizar requiere criterio y se hace a mano; **detectar que hace falta
sintetizar, no**.

## Qué hay en cada carpeta

```
perfil-global/
  CLAUDE.md                    las 7 reglas -> se copia a ~/.claude/CLAUDE.md
  pilares.md                   NIVEL 0: los libros destilados. Hook SessionStart (ASCII)
  apertura-proyecto.md         inyectado por hook SessionStart (ASCII)
  chequeo-de-trabajo.md        inyectado por hook SessionStart (ASCII)
  recordatorio-transversal.md  inyectado por hook UserPromptSubmit (ASCII)
  install.ps1 / verify-install.ps1
  hooks/emitir-contexto.ps1    el lanzador unico de los cuatro hooks
  herramientas/aprender.py     registro de lecciones, global
  aprendizaje/
    lecciones.jsonl            la fuente de verdad (append-only)
    LECCIONES.md               generado; no editar a mano
  pilares/                     las fichas largas de cada libro + el protocolo
  referencias/                 material externo auditado, con su veredicto
  <skill>/SKILL.md             una carpeta por skill; install.ps1 las levanta solas
```

Una carpeta nueva con un `SKILL.md` adentro se instala sola: no hay que tocar
`install.ps1`.

## Las cinco cosas que hay que saber sin leer nada

1. **Confirmado = intervine y vi el efecto.** Todo lo demás es `hipotesis` o
   `probable`, y se anota como tal.
2. **El repo es la memoria** — pero el estado de la máquina se mide, no se lee.
3. **Cuadro de fase en toda respuesta**, y si dice "chat nuevo", el mensaje de
   retome sale en esa misma respuesta.
4. **Sondear es secuencial.** Fan-out sólo sobre superficie ancha e
   independiente, y nunca sobre lo que ya está en el contexto.
5. **El presupuesto del plan gana** sobre cualquier instrucción de
   exhaustividad, incluida `ultracode`.

## Pendiente conocido

`perfil-global/` vive en la rama de BLACK del repo `claude-acceso` por razones
históricas. Aplica a todo, así que su lugar natural es un repositorio propio.
Mientras se trabaje desde este repo no molesta: lo instalado en `~/.claude/`
funciona en cualquier carpeta de la máquina, y `origen.txt` hace que
`aprender.py` escriba siempre acá. Lo que se rompe el día que haya un repo de
verdad separado es **actualizar** el perfil desde allá.
