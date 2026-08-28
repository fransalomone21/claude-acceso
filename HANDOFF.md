# Handoff — la arquitectura del sistema de archivos

**Escrito el:** 2026-08-28 · **Fase:** estructura cerrada y **medible**.

Este handoff es del **trabajo de infraestructura**, no de un proyecto. El
estado permanente del sistema está en [`MAPA.md`](MAPA.md); esto es lo que
queda pendiente y lo que la próxima sesión necesita saber.

## Cuadro de fase para abrir el próximo chat

```
Fase     : Fundamentos CERRADOS el 2026-08-28, y los avisos residuales
           limpiados el mismo dia: verificar-estructura.ps1 pasa de 5 avisos
           a 1. El unico que queda es el .docx del Escritorio, bloqueado por
           un WINWORD abierto -- ver "Lo unico que quedo abierto".
           LA CIERRA (si se vuelve a tocar la estructura): las dos suites en
           verde -- .\probar-verificador.ps1 y .\perfil-global\verify-install.ps1
Modelo   : Sonnet 5 para contenido de proyecto sobre un plan ya decidido.
           Opus solo si hay que decidir enfoque o arquitectura de nuevo.
Esfuerzo : medio, sin fan-out. Un proyecto por chat.
Contexto : chat nuevo, y uno por proyecto.
```

## Arrancá por acá

```powershell
.\bootstrap.ps1
```

Hace las tres cosas y ninguna más: clona `perfil-global` si falta, lo instala
en `~/.claude` y lo verifica, y corre `verificar-estructura.ps1`. Tiene que dar
verde entero. Cada `[FAIL]` trae impreso su arreglo.

## Los tres verificadores, y qué mira cada uno

| Comando | Qué prueba | Probado rompiéndolo |
|---|---|---|
| `.\verificar-estructura.ps1` | las 4 reglas del `CLAUDE.md` contra el disco, en 6 bloques | sí — `probar-verificador.ps1`, **13 chequeos**: 11 sabotajes en rojo y 2 controles de silencio |
| `.\probar-verificador.ps1` | que el de arriba no esté ciego | es el saboteador |
| `.\perfil-global\verify-install.ps1` | que lo instalado **sea** lo del repo, y que los hooks emitan bajo bash | sí — 4 modos (2026-08-17) + contenido (2026-08-28) |

La regla que los ordena a los tres: **verificar es ver el efecto, nunca la
precondición**, y una alarma que nunca se puso en rojo está sin verificar.

## Lo que quedó hecho y verificado por efecto

| Qué | Cómo se verificó |
|---|---|
| Las 4 reglas de estructura, ejecutables | 11 sabotajes, cada uno rojo nombrando el objeto, 2 controles de silencio, y control positivo verde al restaurar |
| El verificador del perfil compara **contenido**, no presencia | se modificó la copia instalada de `chequeo-de-trabajo.md` → rojo; restaurada → verde |
| `install.ps1` y `verify-install.ps1` comparten **una** lista (`manifiesto.ps1`) | se le pidió al manifiesto un archivo que el copiador no copia → `install.ps1` rojo |
| Los respaldos dejaron de acumularse | 91 sueltos en la raíz de `~/.claude` → 0; `backups/` con los 10 últimos de `CLAUDE.md` y todos los de `settings.json` |
| Los dos repos **pusheados** | `main` de `claude-acceso` existe en `origin`; `perfil-global` al día |
| Registro de lecciones unificado | `aprender.py donde` desde otra carpeta, y commiteado |
| BLACK consolidado en `main`, 34 commits recuperados | `git rev-list` en las dos direcciones antes de mergear |

## Los 5 avisos residuales, y cómo se apagó cada uno (2026-08-28, tarde)

Ninguno se apagó aflojando el chequeo. Uno era **el chequeo el que estaba
mal**, y es el que más importaba: un aviso que miente entrena a ignorar los
otros cuatro.

| # | Aviso | Qué era | Cómo se cerró |
|---|---|---|---|
| 1 | `black : ACTIVO y sin HANDOFF.md` | **falso positivo** — el handoff de BLACK vive en `sesiones/HANDOFF.md` y la regla 4 miraba sólo la raíz | la regla 4 ahora acepta un HANDOFF fuera de la raíz **si el `CLAUDE.md` del proyecto lo nombra**. Aceptarlo por ruta a secas habría sido aflojar el chequeo: pasaría a medir «existe un archivo con ese nombre en alguna parte» —la precondición— en vez de «la próxima sesión lo encuentra», que es el efecto. Dos sabotajes nuevos y un control de silencio |
| 2 | `black : vivo y sin PDP.md` | real | `proyectos/ingenieria/black/PDP.md`. **No duplica** el mapa de fases de `ESTADO_ACTUAL.md`: guarda el problema, el alcance negativo, los riesgos, las decisiones y el criterio de salida de 7e |
| 3 | `electronica-analogica : sin PDP.md` | real | `PDP.md` con el plan de fases, que **estaba en el `HANDOFF.md` y ya había divergido** (seguía pidiendo 15 circuitos en ASCII borrados cinco días antes). El handoff ahora apunta al PDP |
| 4 | `caso-tio : sin CLAUDE.md` | real, y el arreglo iba en **su** repo | contrato escrito y commiteado allá (`ced28b3`), local y sin remoto. Este repo no lo trackea: `git ls-files` da 0 |
| 5 | `'Informe TC - Thevenin y Norton'` en el Escritorio | real | **NO se cerró.** Ver abajo |

## Lo único que quedó abierto

**El `.docx` del Escritorio no se pudo mover: lo tiene abierto un WINWORD
(PID 8376, desde las 03:18 del 2026-08-28).** El archivo es

```
C:\Users\frans\Desktop\Informe TC - Thevenin y Norton\
  Informe 1 - Equivalentes de Thevenin y Norton - Favazza, Salomone, Diaz Segui.docx
```

y va a `proyectos\documentos\teoria-circuitos\` — que es su repo, propio y sin
remote a propósito (la carátula lleva mails de compañeros). **No** se agrega a
`.claude\fuera-del-sistema.txt`: sí es un proyecto, y el censo tiene razón.

No se mató el proceso: puede tener cambios sin guardar, y eso lo decide Fran.
Con Word cerrado, es un comando:

```powershell
Move-Item -LiteralPath "C:\Users\frans\Desktop\Informe TC - Thevenin y Norton\Informe 1 - Equivalentes de Thevenin y Norton - Favazza, Salomone, Diaz Segui.docx" -Destination "C:\Users\frans\Desktop\claude-acceso\proyectos\documentos\teoria-circuitos\"
Remove-Item -LiteralPath "C:\Users\frans\Desktop\Informe TC - Thevenin y Norton"
```

y después commitear en **ese** repo (local, sin push). El WARN se apaga solo.

## Lo que NO se hizo, a propósito

- **El proyecto de coaching no se arrancó.** Decisión explícita: dos proyectos
  en un chat es mala práctica. La entrevista ya está en su `PDP.md`.
- **Los dos PDP nuevos no inventaron fases.** Están reconstruidos contra el
  `ESTADO_ACTUAL.md` y el `HANDOFF.md` de cada proyecto, y lo dicen en la
  primera línea. Lo que no se sabe quedó escrito `PENDIENTE` —la validación de
  los dos, y la probabilidad del riesgo de adopción del apunte— en vez de
  rellenado.

## Lo que NO hay que volver a intentar

- **Mergear `origin/claude/infraestructura-global-fase-2-45vjd9`.** Es del
  2026-08-14 y revertiría BLACK trece días. Su único aporte real (el encoding
  de `preparar_entorno.ps1`) ya está en `main`.
- **Sabotear el invariante con `git add -f` sobre un repo ya anidado.** No
  rompe nada: git ignora esos archivos y el índice queda vacío, así que la
  alarma da verde porque el escenario está sano. El caso roto sólo se produce
  en el orden real: primero tracked, después clonado adentro.
- **Restaurar archivos de texto reescribiéndolos con `Set-Content`** después de
  un sabotaje. Normaliza los fines de línea y deja el repo con 135 líneas
  cambiadas que no cambió nadie. Se restauran con `git checkout`, y por eso
  `probar-verificador.ps1` lo hace así.

## Datos que no se pueden aproximar

- `claude-acceso` es **PÚBLICO** (`api.github.com` → 200 sin autenticar).
  `perfil-global` es privado (404). De ahí sale toda la política de qué se
  ignora.
- **Cuáles son los repos anidados no se anota acá**: lo mide
  `verificar-estructura.ps1`. Al 2026-08-28 son tres, y esa lista ya estuvo
  desactualizada una vez en dos documentos a la vez.
- El registro del perfil vive en
  `C:\Users\frans\Desktop\claude-acceso\perfil-global\aprendizaje\lecciones.jsonl`,
  y `~/.claude/aprendizaje/origen.txt` apunta a
  `C:\Users\frans\Desktop\claude-acceso`.
- Respaldo previo a la reconciliación, por si algo falta: la rama
  `rescate/disco-20260827` del repo `perfil-global`.
- **`main` de `claude-acceso` todavía no es la rama por defecto en GitHub.**
  Eso se cambia a mano en Settings → Branches del repo; no hay `gh` en esta
  máquina.

## Pendientes, en orden de costo si no se hacen

1. **Poner `main` como rama por defecto en GitHub**, y recién después decidir
   qué se hace con las seis ramas `claude/*` del remoto
   ([`archivo/RAMAS.md`](archivo/RAMAS.md) dice qué quedó en cada una).
2. **Crear el repo privado del coaching en GitHub** y agregarlo como remote.
   Sin eso no se puede consultar desde el teléfono, que era el requisito.
3. **Mover el `.docx` del Escritorio** cuando Word esté cerrado — el único
   aviso que queda encendido. Los dos comandos están arriba.
4. **Auditar la rama `rescate/disco-20260827`** (~115 renglones propios) y
   recién entonces borrarla.
5. **Carpeta vacía `.claude/worktrees/goofy-chaum-61dbef/`.** El worktree se
   quitó de git y no queda metadata, pero Windows no dejó borrar el directorio
   porque la sesión lo tenía tomado. Se borra a mano cuando no haya una sesión
   abierta.

## Si hay que abrir un chat nuevo

**Para arrancar el coaching** (que es lo que sigue), el mensaje de retome:

> Arrancamos el proyecto de coaching. Está en
> `claude-acceso/proyectos/seguimiento/coaching/`. Leé su `CLAUDE.md` y su
> `PDP.md` enteros — la entrevista ya está hecha, no me la vuelvas a preguntar.
> Naturaleza `seguimiento`: leé también
> `plantillas/naturalezas/seguimiento.md`. Ojo: esa carpeta es un **repo
> aparte** y todavía no tiene remote, así que el checkpoint es commit local
> hasta que se cree. Empezamos por la Fase 0 (línea base): definir el formato
> de registro que cueste menos de un minuto por sesión, y el plan de 4 días.
> Modelo: Opus para diseñar el protocolo y las fases; Sonnet de ahí en
> adelante.
