# Handoff — reestructuración del sistema de archivos

**Escrito el:** 2026-08-27 · **Fase:** A-D cerradas, E preparada sin arrancar.

Este handoff es del **trabajo de infraestructura**, no de un proyecto. El
estado permanente del sistema está en [`MAPA.md`](MAPA.md); esto es lo que
queda pendiente y lo que la próxima sesión necesita saber.

## Arrancá por acá

```powershell
.\bootstrap.ps1
```

Tiene que dar verde en los tres bloques. Si algún `[FAIL]` aparece en el
invariante, el arreglo está impreso en la propia salida.

## Lo que quedó hecho y verificado por efecto

| Qué | Cómo se verificó |
|---|---|
| Registro de lecciones unificado, **67** | `aprender.py donde` desde otra carpeta, y commiteado |
| Perfil bueno instalado (11 reglas, línea Esfuerzo de vuelta) | `verify-install.ps1` verde + la skill `cuadro-de-fase` recargada declara 4 líneas |
| BLACK consolidado en `main`, 34 commits recuperados | `git rev-list` en las dos direcciones antes de mergear |
| Una sola copia del perfil en el disco | `find -name perfil-global` devuelve una sola ruta |
| El chequeo del invariante **discrimina** | sabotaje en repo de prueba: rojo ante el caso roto, verde ante el sano |

## Lo que NO se hizo, a propósito

- **Nada se pusheó.** Hay **38 commits locales** en `main` de `claude-acceso`,
  y `main` es una rama nueva que no existe en `origin`. Pushear es decisión del
  usuario y hay que decirle que crea `main` como rama por defecto en GitHub.
- **El proyecto de coaching no se arrancó.** Decisión explícita del usuario:
  dos proyectos en un chat es mala práctica. La entrevista ya está hecha y
  volcada en `proyectos/seguimiento/coaching/PDP.md`.

## Lo que NO hay que volver a intentar

- **Mergear `origin/claude/infraestructura-global-fase-2-45vjd9`.** Es del
  2026-08-14 y revertiría BLACK trece días. Ya se comprobó que su único aporte
  real (el encoding de `preparar_entorno.ps1`) ya está en `main`.
- **Sabotear el invariante con `git add -f` sobre un repo ya anidado.** No
  rompe nada: git ignora esos archivos y el índice queda vacío, así que la
  alarma da verde porque el escenario está sano. El caso roto sólo se produce
  en el orden real: primero tracked, después clonado adentro.

## Datos que no se pueden aproximar

- `claude-acceso` es **PÚBLICO** (`api.github.com` → 200 sin autenticar).
  `perfil-global` es privado (404). De ahí sale toda la política de qué se
  ignora.
- Repos anidados con dueño propio: `perfil-global/`,
  `proyectos/seguimiento/caso-tio/`, `proyectos/seguimiento/coaching/`.
  Los tres tienen que dar **0** en `git ls-files <ruta>`.
- El registro del perfil vive en
  `C:\Users\frans\Desktop\claude-acceso\perfil-global\aprendizaje\lecciones.jsonl`,
  y `~/.claude/aprendizaje/origen.txt` apunta a
  `C:\Users\frans\Desktop\claude-acceso`.
- Respaldo previo a la reconciliación, por si algo falta:
  la rama `rescate/disco-20260827` del repo `perfil-global`.

## Pendientes, en orden de costo si no se hacen

1. **Crear el repo privado del coaching en GitHub** y agregarlo como remote.
   Sin eso no se puede consultar desde el teléfono, que era el requisito.
2. **Pushear `claude-acceso`** (38 commits) y `perfil-global` (2 commits).
3. **19 lecciones sin foldear** en `chequeo-de-trabajo.md`: el contador dice 45
   y el registro tiene 67. El aviso de `install.ps1` **se deja encendido** —
   subir el número sin auditarlas apaga la única señal que hay sobre ellas.
4. **`verify-install.ps1` no compara contenido contra el repo.** Dio verde
   mientras la máquina corría el perfil viejo. Es la lección del 2026-08-27 que
   todavía no tiene arreglo en el código.
5. **Auditar la rama `rescate/disco-20260827`** (~115 renglones propios) y
   recién entonces borrarla.
6. **BLACK y el apunte no tienen `PDP.md`.** Sus fases viven repartidas. Se
   arman al abrir la próxima fase de cada uno, no antes.

## Si hay que abrir un chat nuevo

**Para arrancar el coaching** (que es lo que sigue), el mensaje de retome:

> Arrancamos el proyecto de coaching. Está en
> `claude-acceso/proyectos/seguimiento/coaching/`. Leé su `CLAUDE.md` y su
> `PDP.md` enteros — la entrevista ya está hecha, no me la vuelvas a preguntar.
> Naturaleza `seguimiento`: leé también
> `plantillas/naturalezas/seguimiento.md`. Empezamos por la Fase 0 (línea
> base): definir el formato de registro que cueste menos de un minuto por
> sesión, y el plan de 4 días. Modelo: Opus para diseñar el protocolo y las
> fases; Sonnet de ahí en adelante.
