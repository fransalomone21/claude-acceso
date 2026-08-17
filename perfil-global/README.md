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
| 3 | **hook** `SessionStart` | una vez por sesión — puede ser largo | `pilares.md` · `apertura-proyecto.md` · `chequeo-de-trabajo.md` |
| 3 | **hook** `UserPromptSubmit` | **en cada prompt** — tiene que ser corto | `recordatorio-transversal.md` |
| 2 | `CLAUDE.md` global | se carga solo, una vez por sesión | las 11 reglas absolutas |
| 1 | skill de consulta | sólo si alguien la invoca | las 6 skills de abajo |

Los archivos que se inyectan van en **ASCII puro**: la consola de Windows los
lee como cp1252 y los acentos salen mojibake. `CLAUDE.md` no pasa por hook, así
que ahí sí van acentos.

## El contrato de capas — qué lleva cada archivo, y qué no

Las cinco capas que se leen solas se solapaban: el cuadro de fase estaba
completo en tres archivos y el cierre de sesión en tres. Un dato que vive en
dos lados diverge, y encima se paga en cada sesión. El reparto es por **cuándo
hace falta la información**, no por tema:

| Archivo | Trabajo exclusivo | Nunca lleva |
|---|---|---|
| `pilares.md` | **por qué** — los fundamentos destilados de los libros (Nivel 0) | reglas operativas, pendientes, estado de proyecto |
| `CLAUDE.md` | **qué** — las reglas normativas, la tabla de memorias, el índice de skills | el desarrollo operativo de una regla |
| `chequeo-de-trabajo.md` | **cómo falla** — errores ya cometidos, agrupados por la situación que los dispara | reglas de sesión, protocolo de cierre |
| `apertura-proyecto.md` | **el protocolo de sesión** — cuadro de fase, mensaje de retome, cuándo cortar | fundamentos, lecciones |
| `recordatorio-transversal.md` | **el disparador** — lo mínimo para no olvidarlo en el instante de actuar | cualquier spec: apunta al de arriba, no lo copia |

La regla que ordena el reparto: **el que dispara más seguido lleva menos**. Un
char en `recordatorio-transversal.md` cuesta N veces lo que el mismo char en un
`SessionStart`, porque se re-inyecta en cada turno. Por eso es el archivo más
chico y el único que tiene prohibido explicar algo.

Cuando una regla necesita su fundamento, `CLAUDE.md` **apunta** al pilar en vez
de repetirlo (`*(Pilar: la regla del saboteador.)*`). Si una regla y su pilar
se contradicen, gana el pilar y la regla se reescribe en el mismo turno.

## Las skills

| Skill | Para qué | Cuándo |
|---|---|---|
| `/cuadro-de-fase` | los casos borde de las tres líneas y del mensaje de retome | si el cuadro se dejó de poner, o no se sabe qué escribir en una línea |
| `/enrutador-modelo` | qué corre en Opus, Sonnet y Haiku — y la autocalibración cuando el tramo no sale | al empezar un tramo nuevo, o ante la tentación de preguntar qué modelo usar |
| `/engineering-orchestrator` | la metodología completa: evidencia, contexto, subagents, handoff, costos, ingeniería de sistemas | al empezar una tarea de ingeniería nueva o ante una decisión de arquitectura |
| `/lecciones-aprendidas` | los 34 errores de proceso con su caso concreto | antes de investigar o debuggear |
| `/spec-interview` | sacar el spec antes de tocar código | antes de construir algo no trivial |
| `/verify-before-build` | chequeo de tres capas antes de la primera línea | después del spec, antes de construir |

## El aprendizaje: tres capas, un solo registro

Lo que ya costó tiempo **por cómo se trabajó** (no por lo que decía el código)
se registra una vez y se lee en tres formatos, según lo que haga falta:

| Capa | Archivo | Cuándo entra | Costo |
|---|---|---|---|
| Síntesis | `chequeo-de-trabajo.md` | **sola**, en cada sesión | ~65 líneas |
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
  CLAUDE.md                    las 11 reglas -> se copia a ~/.claude/CLAUDE.md
  pilares.md                   NIVEL 0: los libros destilados. Hook SessionStart (ASCII)
  apertura-proyecto.md         protocolo de sesion. Hook SessionStart (ASCII)
  chequeo-de-trabajo.md        las lecciones foldeadas. Hook SessionStart (ASCII)
  recordatorio-transversal.md  el disparador. Hook UserPromptSubmit (ASCII)
  PENDIENTES.md                lo que le falta al perfil mismo. NO se inyecta
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

## Pendientes

En [`PENDIENTES.md`](PENDIENTES.md) — incluido el de sacar `perfil-global/` a
su propio repositorio. No se inyecta por hook: es estado de este proyecto, y
una sesión de otro proyecto no gana nada leyéndolo.
