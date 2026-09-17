# Máquina nueva — poner la PC a trabajar con la misma arquitectura

Este archivo es el runbook de **replicar el sistema**, no de replicar el
trabajo. Lo que se copia es la arquitectura, los flujos, las skills, los
pilares, las lecciones y los frenos. Qué proyecto se toca en cada máquina es
una decisión de cada día, no de la instalación.

---

## La decisión de fondo: una memoria, dos máquinas

**Un solo repo, una sola rama `main`, en las dos máquinas.** No se parte el
sistema en dos.

Lo tentador es lo contrario: "la PC no necesita los proyectos de la notebook,
hagamos un repo del sistema y otro de los proyectos". Eso **duplica la
memoria**, y un dato que vive en dos lados diverge — es la falla que ya costó
23 lecciones perdidas entre dos repos (2026-08-27) y la que el `CLAUDE.md`
entero existe para no repetir. El costo de traer todos los proyectos es de
**229 MB de `.git`** y 413 archivos de texto: nada. El costo de dividir la
memoria no se mide en MB.

Así que las dos máquinas tienen **todo** en el disco, y trabajan en lo que
corresponda. Un proyecto no es de una máquina: es una carpeta.

Lo que sí es de una máquina son los **archivos pesados y los datos locales**
—el ISO de BLACK, los volcados, `rclone.conf`— y eso ya está resuelto por el
`.gitignore` y por las tres capas de frenos.

---

## Paso 0 — habilitar scripts (una vez por máquina, y no lo puede medir `bootstrap.ps1`)

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

Windows viene con la ejecución de scripts **deshabilitada** en una instalación
limpia. Sin esto, `.\bootstrap.ps1` muere con `UnauthorizedAccess` antes de
correr su primera línea — y **por eso este chequeo no puede vivir adentro del
script**: un verificador no puede medir la precondición que le impide
arrancar. Tiene que estar en la capa que se lee, no en la que se corre.

No alcanza con un `-ExecutionPolicy Bypass` en el comando de bootstrap: cada
sesión de Claude Code en esa máquina corre `.ps1` de este repo —
`cascada.ps1`, `verificar-estructura.ps1`, `chequeo-completo.ps1`— y todos
chocarían contra lo mismo.

`RemoteSigned` con scope `CurrentUser` es el mínimo que alcanza: permite los
scripts locales, exige firma sólo para los descargados, y no pide admin. Los
archivos que llegan por `git clone` no llevan marca de descarga, así que
pasan. Es lo que tiene la notebook — **medido**, no supuesto — y es lo que
hacía que todo esto anduviera ahí sin que nadie se enterara de que existía.

Se deshace con `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Undefined`.

---

## Los dos comandos

En la PC, con Claude Code ya instalado y con sesión iniciada:

```powershell
git clone -b main https://github.com/fransalomone21/claude-acceso.git "$env:USERPROFILE\Desktop\claude-acceso"
```

```powershell
cd "$env:USERPROFILE\Desktop\claude-acceso"; .\bootstrap.ps1
```

El `-b main` no es decorativo. **Medido el 2026-09-13, en la PC**: el clone
salió bien, la carpeta existía, el `cd` entraba — y adentro no había
`bootstrap.ps1`. La rama por defecto del remote seguía apuntando a una rama
vieja de la época en que cada proyecto era una rama, y eso es lo que `git
clone` checkoutea. El síntoma se leía como «falta un archivo»; la causa era
«estás en otro árbol».

El default del remote ya se corrigió a `main`, así que el `-b` hoy es
redundante — se deja igual, porque un comando que no depende de una
configuración remota es un comando que no se puede romper desde afuera. Y
`verificar-sincronia.ps1` ahora **mide** que la rama por defecto del remote
sea la que se trabaja: si alguien la vuelve a mover, sale en rojo en el
arranque en vez de descubrirse en la próxima máquina.

`bootstrap.ps1` es idempotente y hace, en orden:

| paso | qué |
|---|---|
| 0 | mide las dependencias de la máquina (`git`, `python`, `rclone`, `typst`) y corta si falta una crítica |
| 1 | clona `perfil-global` (repo aparte, **privado**) |
| 2 | lo instala en `~/.claude` y verifica **por hash**, no por "no dio error" |
| 3 | corre `verificar-estructura.ps1`: las siete reglas contra el disco |
| 4 | instala los frenos con la ruta **medida** de esta máquina, y los **sabotea** para verlos en rojo |

Si el paso 1 pide credenciales: `perfil-global` es privado. Hace falta que la
PC tenga acceso a GitHub (`gh auth login`, o Git Credential Manager).

---

## Qué viaja y qué no

| cosa | ¿viaja? | por qué |
|---|---|---|
| reglas, pilares, skills, hooks, lecciones | **sí**, por `perfil-global` | es el sistema |
| enrutador, plantillas, verificadores, saboteadores | **sí**, por `claude-acceso` | es la estructura |
| todos los proyectos | **sí** | texto; y partirlos partiría la memoria |
| `.claude/settings.json` | **no**, se genera | lleva la ruta absoluta de los hooks de *esta* máquina |
| `rclone.conf` | **no** | es un token OAuth de Google. Se rehace con `rclone config` |
| `Black.iso`, volcados, `construido/` | **no** | 3,9 GB, ignorados a propósito |
| auto-memoria de la sesión | **no** | vive en `~/.claude/projects/<ruta>/memory/`, por máquina y por ruta |
| `caso-tio/`, `teoria-circuitos/` | **no** | repos propios **sin remote**: existen sólo donde se crearon |
| `coaching/` | **sí**, aparte | repo propio con remote privado: se clona a mano dentro de `proyectos/seguimiento/` |

Las dos últimas filas son la **regla 2** en acción: la sensibilidad decide el
repo dueño, y eso es independiente de la naturaleza del proyecto.

---

## Lo que hay que hacer a mano en la PC, y por qué no se automatiza

1. **Instalar Claude Code e iniciar sesión.** Nada del sistema existe antes de
   eso.
2. **`rclone config reconnect drive-apuntes:`** — es un consentimiento OAuth
   de Google en el navegador. Hasta que se haga, el medidor de Drive abre cada
   sesión en amarillo (`PENDIENTE`), que es lo correcto: no miente en verde.
   El archivo va a `%USERPROFILE%\.config\rclone\rclone.conf` (nunca bajo
   `%APPDATA%`: la app empaquetada lo redirige y quedan dos archivos
   distintos creyéndose el mismo).
3. **Declarar el Escritorio de la PC.** La regla 6 censa toda carpeta del
   Escritorio que parezca proyecto. Lo que legítimamente no lo sea va a
   `.claude/fuera-del-sistema.txt`.
4. **Copiar `caso-tio/` a mano** si hace falta en la PC: no tiene remote y no
   se puede clonar de ningún lado.

---

## La regla nueva que aparece recién con dos máquinas

Con una sola máquina, «el repo es la memoria» se cumplía solo: no había otra
copia que pudiera estar más adelante. Con dos, aparece una falla que antes no
existía y que **no duele el mismo día**: abrir una sesión sobre un árbol
atrasado. No da error — la sesión trabaja bien, sobre una base vieja, y el
precio se paga al pushear, o no se paga nunca porque la versión buena queda
tapada.

Escribir «acordate de pullear» habría sido subirle el volumen a una regla.
Lo que se agregó es el flujo de información que faltaba:

```powershell
.\verificar-sincronia.ps1      # mide atraso contra origin, en cada arranque
.\probar-sincronia.ps1         # lo rompe y exige verlo en rojo
```

Es uno de los medidores de `chequeo-completo.ps1`, así que **cada sesión abre
diciendo si este árbol quedó atrasado**. Rojo sólo para *atrasado*: tener
commits sin pushear es el estado normal de una sesión a mitad de camino, y
poner eso en rojo entrenaría a ignorar el aviso.

En la práctica, con dos máquinas la **regla 5 del perfil** (checkpoint antes
de parar: `ESTADO_ACTUAL` + `HANDOFF` + commit + push) deja de ser higiene y
pasa a ser la condición para que la otra máquina pueda seguir.

---

## Cuando algo quede en rojo en la PC

Antes de tocar nada, correr el chequeo entero y leer **qué** se puso en rojo:

```powershell
.\chequeo-completo.ps1
```

Dos rojos son esperables en una PC recién instalada y no son fallas del
sistema:

- **Drive en amarillo** hasta hacer el `rclone config reconnect`.
- **Capas 1 y 3 de los frenos en `[SKIP]`** — el archivo que protegen
  (`Black.iso`) es de un proyecto que no está en esa máquina. `probar-hooks.ps1`
  lo nombra y no lo cuenta como verde: dice qué quedó sin verificar y dónde sí
  se puede verificar.
