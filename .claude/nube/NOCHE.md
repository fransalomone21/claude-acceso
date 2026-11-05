# La noche del 2026-11-05: tres sesiones en la nube a la vez

Fran duerme. Corren tres sesiones sobre el mismo GitHub, cada una con lo suyo. Esto vale para las tres.

## Antes que nada, sin gastar: ¿esta sesión puede escribir?

```bash
git config --get remote.origin.url
git push --dry-run origin HEAD:refs/heads/claude/prueba-permisos
```

Después, `add_repo` de `fransalomone21/perfil-global` con push. **Si cualquiera de los dos falla, esta sesión no puede dejar
nada en GitHub y se cierra ya, con una sola línea que diga qué cuenta ve y qué falló:** seguir sólo gastaría créditos en
trabajo que se pierde. La primera vuelta, el 2026-11-05 a la 1:30, corrió con otra cuenta de GitHub y las tres se trabaron.

## La hora de cierre

Los créditos vencen a las **4:59 GMT-3**. Después, la sesión podría pasar a gastar el plan de Fran.

```bash
TZ=America/Argentina/Buenos_Aires date +%H:%M
```

Mirala al cerrar cada tema. **A las 4:30 no se abre nada nuevo; a las 4:40 todo tiene que estar commiteado, pusheado y con
su informe.** Si los créditos se acaban antes, lo que sobrevive es lo que ya esté en el remoto: por eso se pushea por tema.

## Quién toca qué

| Sesión | Es dueña de | Informe |
|---|---|---|
| `fisica` | `proyectos/documentos/fisica-espacial/` | `.claude/nube/regreso/2026-11-05-fisica.md` |
| `electronica` | `proyectos/documentos/electronica-analogica/`, `proyectos/documentos/teoria-circuitos/` | `.claude/nube/regreso/2026-11-05-electronica.md` |
| `metodo` | `perfil-global/herramientas/defectos.py`, `.claude/nube/estado-nube.py` y su simulacro | `.claude/nube/regreso/2026-11-05-metodo.md` |

Lo de otra sesión no se edita. Si hace falta, va al informe. `proyectos/documentos/catedras/` se toca sólo en
`<materia>/REGISTRO.md` y `CRITERIOS.md`, de la materia propia.

## Lo que comparten: en una sola tirada

`perfil-global` (lecciones, defectos, su vista, el orden de ataque) lo escriben las tres. Dos sesiones pueden sacar el mismo
número de defecto, así que cada registro va **completo y seguido**, sin nada en el medio:

```bash
cd /home/user/perfil-global
git pull --rebase -q
python3 herramientas/defectos.py agregar ... --urgencia alta --urgencia-por "..."
python3 herramientas/defectos.py vista
git add -A arquitectura DEFECTOS-ARQUITECTURA.md && git commit -qm "..." && git push -q
```

Si el push falla: `git reset --hard origin/main`, y otra vez desde el `pull`. **Nunca se resuelve a mano un conflicto en
`defectos.jsonl` ni en `lecciones.jsonl`**: se repite el comando, que le da número nuevo. `claude-acceso` igual: `git pull
--rebase` antes de cada push. Nunca `--force`.

`ORDEN-DE-ATAQUE.md`: una fila por defecto nuevo, en el mismo commit. Si choca, se conservan las filas de los dos lados.

## Lo que vale para las tres

- El cuadro en cada respuesta, aunque nadie lo lea esta noche: es lo que audita la mañana.
- Fran no contesta: lo técnico se decide, y lo que es de su gusto va a «decisiones para Fran» del informe, con la opción más
  conservadora aplicada mientras tanto.
- El informe se crea al arrancar con el renglón `estado: pendiente`, y se actualiza en cada tema.
- Nada de Drive, ni subagentes para contenido, ni Fable. Sin commitear `apunte.pdf` ni `apunte-tdc.pdf`.
- Lo que aprendas de Fran va a `perfil-global/memoria-nube/`, nunca a `memoria/`.
- Al cerrar: `python3 auditar-sesion.py ... --escribir`, commit y push. La PC lo levanta con `.claude/nube/regreso.py`.
