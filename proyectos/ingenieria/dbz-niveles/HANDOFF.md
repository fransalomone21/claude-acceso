# Handoff — dbz-niveles

**Escrito el:** 2026-11-20 · **Fase al cerrar:** 0, Pre-Fase A, abierta

## Arrancá por acá

```
.\cascada.ps1 dbz-niveles -Necesidad ingenieria-inversa,investigar
```

y leer lo que pida (la puerta exige ~34 K tokens: es una vez por sesión, y por
eso esta parte se pasó a un chat nuevo). Después, el alcance (PDP §1-2) con el
concepto `alcance` de la puerta abierto.

## Lo que quedó a medias

- El proyecto se creó el 2026-11-20 y sólo tiene el plan de fases, los riesgos
  y el inventario medido (`ESTADO_ACTUAL.md`). §1-2 del PDP (alcance) vacías a
  propósito.
- El `PROBLEMAS.md` es la plantilla.

## Lo que NO hay que volver a intentar

- Buscar los juegos otra vez: el inventario está en `ESTADO_ACTUAL.md` y las
  rutas de PS2 en `../ps2-casa/RUTAS.md`.
- Correr `DEJAR-TODO-LISTO.ps1` tal cual: sus rutas apuntan a
  `C:\Users\frans\Desktop\DBZ-mods`, que se mudó a
  `C:\Users\frans\Desktop\Juegos\Mods\Dragon Ball\DBZ-mods`, y además pisa el
  save. Corregir las rutas antes, o probar con `bisectar-mods.ps1`.

## Datos que no se pueden aproximar

- ISOs (notebook): `C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\DBZ Niveles de Poder (Beta 8.1)\ISO niveles de poder BETA 8.1.ISO` (4 451 MB, ELF SLUS_219.99); `...\DBZ Budokai Tenkaichi 4 (Beta 14)\SLUS_219.78.DBZBT4B14.iso` (5 096 MB); `...\DBZ Budokai Tenkaichi 4 (Beta 14 REV2)\SLUS_219.78.DBZBT4B14REV2.iso` (5 147 MB); referencia BT3: `C:\Games\PS2-ISOs\` (ver RUTAS de ps2-casa).
- Sparking ZERO (notebook): `C:\Games\Dragon Ball Sparking ZERO`; mods en `SparkingZERO\Content\Paks\~mods` y `SparkingZERO\Mods`; escala de poder en `SparkingZERO\Mods\Extension_Dynamic_DP\Config\DP_values.json` (claves "0".."15": `lifePointScale`, `damageScale`, `changeCharacterCooldown`).
- Scripts locales: `C:\Users\frans\Desktop\Juegos\Mods\Dragon Ball\DBZ-mods\scripts\` (`mods-sparking.ps1 estado|on|off <grupo>`, `bisectar-mods.ps1`).
- PC de casa: SSH `Fran@10.147.20.3` con `~\.ssh\pc-cable`; el comando va con `powershell -NoProfile -EncodedCommand`.

## Si hay que abrir un chat nuevo

```
Seguimos con dbz-niveles (claude-acceso). 0) En la notebook el libro llega solo; en otro lado, bash .claude/nube/traer-perfil.sh primero.
1) .\cascada.ps1 dbz-niveles -Necesidad ingenieria-inversa,investigar y leé lo que pida. Leé también proyectos/ingenieria/ps2-casa/RUTAS.md. NO vuelvas a buscar los juegos: el inventario está en ESTADO_ACTUAL.md.
2) Fase 0, Pre-Fase A. La cierra: en PDP §6 el camino elegido por Fran con fecha, sobre la tabla «personaje -> nivel (fuente) -> parámetro» de 3 personajes (Goku base, Goku SSJ Blue, Goku Ultra Instinto).
3) Opus, esfuerzo alto, sin fan-out y sin subagentes (Fran no los quiere).
4) Primero el alcance (PDP §1-2, con el concepto alcance abierto). Después dos spikes, con predicción escrita antes: (a) 7z l de los ISOs Niveles 8.1, BT4 B14 REV2 y el BT3 de referencia, y diff de qué archivos cambian; (b) el Sparking ZERO de la notebook: arreglar las rutas de DEJAR-TODO-LISTO.ps1 o usar bisectar-mods.ps1, y medir qué grupos de mods arrancan (respaldar el save antes). Abrir el juego le tapa la pantalla a Fran: avisarle antes.
5) Efecto a ver: el diff en un archivo del proyecto, y la lista de grupos que arrancan.
```
