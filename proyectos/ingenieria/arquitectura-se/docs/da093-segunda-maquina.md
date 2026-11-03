# La segunda máquina — DA-092 a DA-096 (2026-11-03)

Requisitos: N-13, L0-13 y la sección 16 de [`10-requisitos.md`](10-requisitos.md) (L1-31..34 y sus L2; 22
enunciados, 0 VIOLA del GtWR extrayéndolos). Los cinco defectos salieron de la notebook de Male el 2026-11-02 y de la
PC de Fran el 2026-11-03: la misma clase que DA-022 y DA-085 —otra máquina con otro estado— por cinco lados. Orden de
ataque: filas 49c a 49g de `perfil-global/arquitectura/ORDEN-DE-ATAQUE.md`.

**Pregunta de marco** (¿qué tendría que ser verdad para que esto sea el problema equivocado?): que la segunda máquina
fuera un caso único. No lo es: Fran trabaja en la notebook de Male cuando está con ella, y la nube es una tercera
máquina con la misma clase de problema (DA-022). Los cinco arreglos son de la clase, no del caso.

## 1. DA-093 — el AL DÍA no traía el remoto (L1-31, L2-CAS-10..12)

- **El defecto**: `cascada.ps1` medía «nada sin pushear» y nunca hacía `fetch`. En la notebook, malena estaba 7
  commits atrás, claude-acceso 34 y perfil-global 13, y la cascada decía AL DÍA en verde: la sesión leyó un contrato
  viejo y puso lo nuevo fuera de la regla 11. El arranque, que corre `verificar-sincronia.ps1`, no corre si la sesión
  abre en el Escritorio.
- **El arreglo**: el AL DÍA pasa a una función (`Al-Dia`, la usa también `-Repo`) que trae el remoto de **cada repo
  que la sesión lee** —el del proyecto, claude-acceso (enrutador, puerta, catálogo) y perfil-global (el libro)— con un
  plazo de 20 s por repo (`-PlazoRed`), y da **ROJO «ATRAS N commit(s)»** con el comando que los trae. Sin red, sin
  acceso o pasado el plazo: **SIN MEDIR**, amarillo, nunca al día. El fetch corre con `GIT_TERMINAL_PROMPT=0`: una
  credencial que pregunta no cuelga la entrada.
- **La V**: `probar-cascada.ps1` suma tres casos (clon atrasado → rojo con la cuenta; el control al día; remoto
  inalcanzable → SIN MEDIR) y los tres dan FALLA con la versión anterior (`git show HEAD:cascada.ps1`, el clon atrasado
  salía con código 0). **Efecto real** (`confirmado`): un clon de claude-acceso con `git reset --hard HEAD~1` y la
  cascada nueva corrida sobre él imprime `arquitectura-se ATRAS 1 commit(s) de origin/main` en rojo y sale 1; sobre el
  árbol real, los tres repos «al dia ... (recien traido)».

## 2. DA-092 — el índice de cátedras, a quien nombra una cátedra (L2-PTA-50/51)

- **El defecto**: la necesidad `materia` exigía `catedras/CLAUDE.md` a todo proyecto. malena declara `catedras: []`
  (sus criterios viven adentro, regla 1 de su contrato) y en la notebook ese repo privado no se clona: la puerta negaba
  después de leer todo lo demás, y la salida era `-Excepcion`.
- **El arreglo**: sale de la necesidad y entra a la rama de `documentos` con `"con_catedra": true`; `exigido()` lo
  exige sólo si la entrada del proyecto nombra al menos una cátedra. Una materia sin la clave `catedras` sigue negando
  (L2-VER-11).
- **La V**: caso 27 del autotest de la puerta (con cátedra y sin el índice → niega; con el índice → pasa; sin cátedras
  → pasa) y dos mutantes vistos (el índice a todos, como antes; el índice nunca).

## 3. DA-096 — la clase `-Repo` (L1-34, L2-PTA-52/53, L2-CAS-13)

- **El defecto**: un `git fetch` de sólo lectura sobre malena pagó ~40 K tokens del tronco: `-Excepcion` libera el
  proyecto y no el tronco, y `-Suelta` no despega la primera clasificación. Contra la ley del costo proporcional.
- **El arreglo**: `.\cascada.ps1 <proyecto> -Repo "motivo"` registra la Clase_Repo antes de que el comando corra
  (como las demás declaraciones) e imprime sólo el AL DÍA. La puerta, **por acción y por permiso**, deja pasar sin
  necesidad, tronco ni rama un Bash o PowerShell cuyo cada tramo es `git`, una mudanza (`Move-Item`, `mv`,
  `Rename-Item`) o una lectura pura, con tuberías sólo a filtros, sin redirección a archivo ni subexpresión, y que toca
  **sólo** proyectos con Clase_Repo. Un concepto que la operación dispare se exige igual. Editar o escribir en el
  proyecto sigue pidiendo la necesidad, y la negación lo dice. `cascada.sh` acepta `-Repo` en la nube.
- **La V**: caso 28 del autotest (6 casos sobre black real: el fetch con `-Repo`, el caso exacto —una sesión ya
  clasificada Ingeniería con el tronco sin leer—, un Edit, un git encadenado con un borrado, el fetch sin `-Repo`, una
  redirección) y tres mutantes vistos. **Efecto real por la frontera** (el lanzador, el catálogo real, una sesión nueva
  sin nada leído, `confirmado`): después de `malena -Necesidad metodo,materia`, el `git fetch` sobre malena **niega
  pidiendo el tronco** sin `-Repo` y **pasa** con `-Repo`; con la puerta anterior niega en los dos casos. En esta
  sesión, `cascada.ps1 malena -Repo` y el fetch pasaron (no discrimina: esta sesión ya tenía el tronco leído).
- **Límite declarado**: un comando git que **nombra** otro proyecto en un argumento de texto (un mensaje de commit)
  sigue disparando a ese proyecto (DA-083, vivido en esta misma sesión: el mensaje que citaba la ruta del índice de
  cátedras). Se rodea con el mensaje en un archivo.

## 4. DA-095 — el espejo de fuentes (L1-33, L2-FUE-01..05)

- **El defecto**: las fuentes de Química (20 PDF de teoría, los parciales 2022-2026) vivían en Descargas y Escritorio
  de la notebook; `MATERIAL.md` lo decía en prosa. Desde la PC el apunte compilaba y el módulo siguiente no se podía
  escribir.
- **El arreglo**: `fuentes.py` en la raíz. Cada proyecto declara en **su** raíz (`fuentes.json`, en el repo privado:
  nombra carpetas de terceros) el espejo de cada materia en Drive y los orígenes. La Copia_Local vive en
  `~/fuentes-espejo/<proyecto>/<materia>/`, fuera de todo repo (los PDF de cátedra no van a git) y fuera del árbol (la
  puerta no la ve como el proyecto). `subir` copia los orígenes que existan en esa máquina y sube lo que falta o
  difiere; `traer` baja; `aviso` —lo corre la cascada al entrar— dice por materia «N de M en esta máquina» comparando
  por **MD5**, «ESPEJO VACÍO» si no hay nada (incluida la carpeta que todavía no existe: rclone sale 3) y «SIN MEDIR»
  si el espejo no responde en 30 s. malena declara Química en `04 - TERCEROS/<su carpeta>/Quimica Inorganica/Fuentes/`
  (adentro de la carpeta compartida con ella: son sus propias fuentes; `estructura-drive.json` lo dice).
- **La V**: `fuentes.py --autotest` (8 casos sobre un espejo local sintético: rclone acepta rutas locales) y
  `--sabotaje` (4 mutantes, cada uno visto en su caso: comparar sólo nombres, el espejo vacío en verde, sin red como al
  día, subir sin orígenes); en la capa de saboteadores de `chequeo-completo`. **Efecto real**: `fuentes.py aviso malena`
  contra el Drive de verdad da «ESPEJO ESTÁ VACÍO»; se llena con un `subir` en la notebook de Male (lo de Fran).

## 5. DA-094 — lo validado que no sale de la máquina (L1-32, L2-SGU-01/02, L2-PER-01/02)

- **El defecto**: el checkpoint (regla 5) y el retome (regla 12) suponen que la sesión llega a cerrar. En la notebook
  se cortó: lo validado y el retome quedaron en ese chat.
- **El arreglo, en dos niveles**: **regla** (perfil `52e0827`): cada sí de Fran a un paso es un commit y un push en ese
  turno, y el retome se escribe al HANDOFF en el mismo turno. **Flujo**: `.claude/hooks/sin-guardar.py`, un hook
  `Stop` que al terminar cada turno le muestra **a Fran** (systemMessage, no el contexto de la sesión: DA-043) cuántos
  archivos sin commitear y commits sin pushear tienen los proyectos que la sesión declaró; un aviso cada 30 min a lo
  sumo; lo sucio de otra sesión fuera de esos proyectos no cuenta (DA-088); una falla sale 0 y calla.
- **La V**: `sin-guardar.py --autotest` (7 casos) y `--sabotaje` (4 mutantes vistos); corrido a mano sobre esta sesión
  real calla, con razón: lo de sus proyectos ya estaba pusheado.
- **Sin instalar**: corre solo en cada turno, así que entra a `.claude/settings.json` con el sí de Fran (regla 6). Hasta
  entonces DA-094 queda **abierto** con la regla hecha.
- **Límite declarado**: no mide los archivos del método en la raíz (cascada.ps1, la puerta): son de sesiones de
  arquitectura y viven en claude-acceso junto a lo sucio de otras sesiones.
