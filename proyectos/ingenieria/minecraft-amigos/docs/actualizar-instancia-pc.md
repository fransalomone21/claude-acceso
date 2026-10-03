# Actualizar la instancia "Nuevo 1.21.4" de la PC (donde juega Agus)

Para el Claude de la PC de Fran. Objetivo: que la instancia de Prism
**Nuevo 1.21.4** quede con los mismos mods que la de la notebook, para jugar
juntos. Es mecánico: Sonnet o Haiku, esfuerzo bajo, sin fan-out.

## 0. El libro primero
Si `~/.claude/CLAUDE.md` no empieza con «# Perfil global»:
`bash .claude/nube/traer-perfil.sh` en `claude-acceso`, y leer lo que lista.

## 1. Traer el repo
```powershell
cd $env:USERPROFILE\Desktop\claude-acceso ; git pull
.\cascada.ps1 minecraft-amigos -Necesidad ninguna   # y leer lo que pida
```

## 2. Cerrar Prism y respaldar los mundos
```powershell
Get-Process prismlauncher -EA SilentlyContinue | Stop-Process -Force
$i = "$env:APPDATA\PrismLauncher\instances\Nuevo 1.21.4"
Compress-Archive "$i\.minecraft\saves" "$env:USERPROFILE\Desktop\Nuevo-saves-backup.zip" -Force
```
Si la instancia en esa PC tiene otro nombre, buscarla en
`%APPDATA%\PrismLauncher\instances` (la que tenga Fabric 1.21.4 y los mods de
`pack/manifiesto-nuevo.json`) y usar esa ruta.

## 3. Sumar los mods (descarga de Modrinth, verifica sha1, trae dependencias)
```powershell
python proyectos\ingenieria\minecraft-amigos\herramientas\armar_pack.py --origen $i --destino $i --mc 1.21.4 --agregar proyectos\ingenieria\minecraft-amigos\pack\agregar.txt --manifiesto $env:TEMP\manifiesto-pc.json
```
Tiene que terminar con `[ok] ... sin version 1.21.4: ninguno`.

## 4. Verificar por efecto: mismos jars que la notebook
```powershell
$ref = (Get-Content proyectos\ingenieria\minecraft-amigos\pack\manifiesto-nuevo.json -Raw | ConvertFrom-Json).mods.archivo
$pc  = (Get-ChildItem "$i\.minecraft\mods" -Filter *.jar).Name
Compare-Object $ref $pc
```
**Sin salida = idénticos.** Si aparece algo:
- `=>` (sobra en la PC): un mod que la notebook no tiene → moverlo fuera de `mods`.
- `<=` (falta en la PC): bajar ese archivo exacto desde Modrinth (el slug está en
  el manifiesto) o copiarlo de la notebook. Una versión distinta de un mod entre
  host y cliente puede no dejar entrar al server.

## 5. Probar
Abrir Prism → Nuevo 1.21.4 → Launch. Si el mundo es el de Fran por LAN o por
su server, entrar ahí; el juego tiene que cargar sin pantalla de mods faltantes.

## Avisos
- No se toca `accounts.json`.
- Las estructuras nuevas (YUNG, Nullscape, Incendium) aparecen sólo en chunks
  **sin explorar**; lo ya generado del mundo viejo queda igual.
