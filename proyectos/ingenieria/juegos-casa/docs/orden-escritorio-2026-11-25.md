# Orden del escritorio y de «Juegos de a dos» — 2026-11-25

## Lo medido antes de mover nada

- **Notebook**: el Escritorio ya tiene **una sola carpeta `Juegos`** (BLACK, Emuladores, Instaladores, Juegos de a
  dos, Juegos de emulador, Juegos de PC, Minecraft, Mods, Utilidades). Afuera no queda nada de juegos: el resto
  son las carpetas 00-04, `Herramientas`, `_PLANO`, proyectos sueltos y documentos del parcialito (no son de
  este proyecto: no se tocan). Lo dejó así el orden del 2026-11-12.
- **PC**: igual, una sola carpeta `Juegos` (BLACK, Juegos de a dos, Juegos de emulador, Juegos instalados y
  accesos sueltos). El spike decía «PC en `Escritorio\Juegos de a dos`»: estaba mal, viven en
  `Escritorio\Juegos\Juegos de a dos` (corregido en `spike-double-dragon.md`).
- **Qué nombra el repo** (Grep de `Desktop\Juegos`, `Escritorio\Juegos` y `Juegos de a dos` en todo
  `claude-acceso`): sólo las ISOs de BLACK en `Juegos\Juegos de emulador\PS2\BLACK\ISOs\` (`.claude/protegidos.json`,
  `black/kb/ubicaciones.json`, `black/kb/estructuras.json`). **No se mueven.** Los accesos de Double Dragon II y
  Chase H.Q. II no los nombra nada salvo el script que los genera.
- **Juegos de PC** de la note tiene juegos instalados adentro (Enter the Gungeon, Gang Beasts) con accesos que
  apuntan a esa ruta: renombrarla a «Juegos instalados» como en la PC rompe los accesos. **No se mueve**; lo
  ordena el índice (fase 1), que regenera las carpetas desde el catálogo.

## Lo que se movió (nada se borró)

`Juegos de a dos` pasó de accesos sueltos a **una subcarpeta por juego**, generada por
`scripts/instalar-retroarch.ps1` desde `scripts/juegos-de-a-dos.csv`. Los cuatro accesos sueltos viejos quedaban
duplicados y se mudaron a una carpeta de deshacer:

| Máquina | Origen | Destino |
|---|---|---|
| note | `Escritorio\Juegos\Juegos de a dos\Chase H.Q. II.lnk` | `C:\Games\_deshacer\accesos-sueltos-2026-11-25\` |
| note | `…\Double Dragon II - los dos en esta maquina.lnk` | ídem |
| note | `…\Double Dragon II - ser anfitrion.lnk` | ídem |
| note | `…\Double Dragon II - unirse a la PC.lnk` | ídem |
| PC | `Escritorio\Juegos\Juegos de a dos\Chase H.Q. II.lnk` | `C:\Games\_deshacer\accesos-sueltos-2026-11-25\` |
| PC | `…\Double Dragon II - los dos en esta maquina.lnk` | ídem |
| PC | `…\Double Dragon II - ser anfitrion.lnk` | ídem |
| PC | `…\Double Dragon II - unirse a la note.lnk` | ídem |

Lo nuevo: 18 subcarpetas (`Double Dragon II`, `Chase H.Q. II`, `Streets of Rage` 1-3, `Golden Axe` I-III,
`Double Dragon`, `Double Dragon 3`, `Battletoads and Double Dragon`, `TMNT The Hyperstone Heist`, `Gunstar
Heroes`, `Contra Hard Corps`, `ToeJam and Earl`, `Sonic 2`, `Sonic 3`, `Mega Bomberman`) con 52 accesos en cada
máquina. Los otros accesos de `Juegos de a dos` (Battlefront, CoD, LEGO, Sparking, BT4) siguen donde estaban.

## Deshacer

En cada máquina (en la PC, con `Fran` en vez de `frans`):

```powershell
$c = "C:\Users\frans\Desktop\Juegos\Juegos de a dos"
Get-ChildItem "C:\Games\_deshacer\accesos-sueltos-2026-11-25" -Filter *.lnk | Move-Item -Destination $c
Import-Csv "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\juegos-casa\scripts\juegos-de-a-dos.csv" | ForEach-Object { Remove-Item -LiteralPath (Join-Path $c $_.Nombre) -Recurse }
```

Las ROMs nuevas de `C:\Games\RetroArch\roms\megadrive\` (16 `.bin`) se sacan a mano si hiciera falta; la fuente
sigue entera en Descargas.

## El índice (2026-11-25, más tarde): lo que movió `indice.py generar`

El índice reemplazó a las carpetas de accesos sueltos. **Nada se borró**: cada acceso del índice viejo se movió
al almacén `C:\Games\_indice\accesos\` de su máquina, **con la misma ruta relativa al Escritorio** que tenía
(`Juegos\Juegos de a dos\Double Dragon II\...`), y el índice lo copia de ahí (L2-GEN-03). La planilla de cada
movimiento (origen, destino) está en `inventario/planilla-note-2026-11-25-1153.csv` (66 accesos) y
`inventario/planilla-pc-2026-11-25-1155.csv` (103), ignoradas por git porque llevan rutas. El almacén se llamaba
`lanzadores` en esas planillas y se renombró a `accesos` minutos después (el nombre chocaba con la puerta de
BLACK); las rutas de las planillas cambian sólo en esa palabra.

| Máquina | Qué se movió al almacén |
|---|---|
| note | `Juegos de a dos` entero, `Juegos de PC\Accesos`, `Minecraft` (4 accesos) |
| PC | los 23 accesos sueltos de `Juegos`, `Juegos de a dos` entero, `Sega - los dos en la PC` |
| PC | además, `Juegos\plutonium.exe` → `C:\Games\Plutonium\plutonium.exe` (MD5 igual antes y después) |

Lo que **no** se tocó: `BLACK`, `Emuladores`, `Utilidades`, `Mods`, `Instaladores`, `Juegos de PC` y `Juegos
instalados` (tienen juegos instalados adentro), `Juegos de emulador` (las ISOs de BLACK están protegidas), el LEEME.

**Deshacer el índice** (en cada máquina; en la PC con `Fran`):

```powershell
$e = "C:\Users\frans\Desktop"; $a = "C:\Games\_indice\accesos"
Get-ChildItem $a -Recurse -File | ForEach-Object { $d = Join-Path $e $_.FullName.Substring($a.Length + 1); New-Item -ItemType Directory -Force (Split-Path $d) | Out-Null; Move-Item -LiteralPath $_.FullName -Destination $d }
"Sega","PS2","PS3","Android","Clasificados","Minecraft" | ForEach-Object { $p = Join-Path "$e\Juegos" $_; if (Test-Path "$p\.indice-generado") { Remove-Item -LiteralPath $p -Recurse } }
Get-Content C:\Games\_indice\generado-raiz.txt | ForEach-Object { Remove-Item -LiteralPath (Join-Path "$e\Juegos" $_) }
```

(Desde la tarde del 2026-11-25 la forma es: juegos de PC sueltos —anotados en `generado-raiz.txt`—, carpetas
por consola, Minecraft y `Clasificados`; las cinco numeradas de la mañana se borraron solas al regenerar.)

(En la note, el `Minecraft` generado se borra antes de devolver el viejo.)
