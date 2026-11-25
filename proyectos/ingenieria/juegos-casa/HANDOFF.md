# Handoff — juegos-casa

**Escrito el:** 2026-11-25 (mediodía) · **Fase al cerrar:** 0 (Concepto) abierta por el sí de Fran; la 1 (el
índice) con su criterio cumplido, se cierra junto con la MCR de la 0.

## Lo último (2026-11-25 al mediodía, sesión «ordená la carpeta de juegos»)

- **Hecho y medido**: el índice en las dos máquinas (`scripts/catalogo.json` + `scripts/indice.py`): note 45
  juegos, PC 54, `verificar` en verde y `sabotaje` en rojo por el motivo correcto en las dos. Los accesos viejos
  están en `C:\Games\_indice\accesos\` (planillas en `inventario/`, deshacer en `docs/orden-escritorio-2026-11-25.md`).
  Requisitos v0.2 (eje tipo de 6 valores, L2 del índice; GtWR 0 VIOLA). LEEME nuevo en las dos (MD5).
  RetroArch con la config de red nueva en las dos. Los 18 de Mega Drive arrancan en la note (capturas).
- **Falta, en orden**: (1) el sí de Fran al concepto y a los requisitos (MCR: cierra la 0 y la 1); (2) la prueba
  en caliente en la PC cuando nadie la use: `scripts/caliente-sega.ps1` como tarea interactiva de una vez
  (como `ra-teclas.ps1`), y mirar la hoja de capturas; (3) jugar DD II en red con el arreglo y medir la demora
  (L1-05); (4) sesión 6 del plan (RetroBat, mostrarle 2-3 temas a Fran).
- **Para sumar un juego**: agregarlo a `scripts/catalogo.json` (cómo se detecta, modo, tipo, versión, y si es de
  a dos, su forma y pasos) y `python scripts/indice.py generar --maquina ambas`. Un juego instalado que no está
  en el catálogo hace dar rojo al `verificar` («sin catalogar»): así no se pierde ninguno.
- **Comandos de RetroArch** (ahora los accesos van al almacén, no al Escritorio): note `-Nick Fran -Otra
  10.147.20.3 -NombreOtra "la PC" -Carpeta "C:\Games\_indice\accesos\Juegos\Juegos de a dos"`; PC `-Nick Kheven
  -Otra 10.147.20.2 -NombreOtra "la note" -Carpeta` igual; después `indice.py generar`.

## La sesión de los clásicos (2026-11-25 a la madrugada)

- **Hecho**: 16 clásicos de a dos de Mega Drive en las dos máquinas (MD5 igual, 18/18), accesos por juego
  en `Escritorio\Juegos\Juegos de a dos` de las dos (script generalizado + `scripts/juegos-de-a-dos.csv`),
  LEEME para Fran (`docs/LEEME-lo-hecho-y-lo-que-se-puede.md` y `Escritorio\Juegos\LEEME.txt` de las dos),
  planilla del orden (`docs/orden-escritorio-2026-11-25.md`).
- **Después (misma noche)**: el Double Dragon II en red se ralentizaba y desincronizaba; Fran eligió jugar los
  Sega de a dos **en la PC, pantalla compartida** (`Escritorio\Juegos\Sega - los dos en la PC`, 18 accesos). El
  arreglo de red (2 cuadros de demora, chequeo cada 30) está en `instalar-retroarch.ps1` sin aplicar: «para otro
  momento». `scripts/ra-teclas.ps1` + `ra-paso.ps1` manejan RetroArch de la PC con captura (tarea `juegos-paso`).
  La tienda de Minecraft se terminó acá (ver `minecraft-amigos/ESTADO_ACTUAL.md`). A las ~03:50 la PC dejó de
  contestar SSH (ping sí): no se pudo apagarla como pidió Fran ni copiar la biblioteca de mods.
- **Falta, en orden**: (1) con Fran avisando que terminaron de jugar: prueba en caliente con captura de cada
  juego nuevo (`scripts/abrir-y-capturar.ps1`; en la PC, tarea interactiva de una vez, el script ya está en
  `C:\Games\_scripts\`) y de Minecraft entrando a la juntada y a Better MC 5 (cuentas sin conexión: las pone
  Fran); (2) volver a correr `instalar-retroarch.ps1` con RetroArch cerrado en las dos, para que escriba
  `retroarch.cfg` (con RetroArch abierto lo saltea a propósito).
- (Los comandos de esa sesión apuntaban `-Carpeta` al Escritorio: desde el índice, van al almacén; ver arriba.)

## Arrancá por acá

1. Medir el disco de la notebook antes de creerle a este archivo (al escribirlo: 9 GB libres).
2. Declarar el sistema ajeno antes del primer cambio (DA-145):
   `.\cascada.ps1 -Sistema juegos-pc -Investigacion proyectos/ingenieria/juegos-casa/docs/investigacion-2026-11-24.md -Prediccion "<lo que va a pasar>" -Respaldo "<ruta de la copia | no-cambia: motivo>"`
3. Seguir el plan por sesiones de abajo, en orden.

## El plan por sesiones (Fran: «separá en sesiones y gestioná el uso»)

Cada sesión de ejecución: **Sonnet, esfuerzo medio, sin agentes** (Fran: nada de delegar), un solo
hilo, y cierra con commit, push y auditoría. Si la ventana de 5 h pasa del 80 %, se corta con retome. La
de diseño (2026-11-24, Opus, esfuerzo máximo) usó alrededor de un cuarto de una ventana de 5 h.

| # | Sesión | Qué deja hecho | Lo de Fran |
|---|---|---|---|
| 2 | **La notebook liviana y Double Dragon II** | las 6 ISOs de PS2 en la PC (God of War II sólo el PAL), MD5 verificado, borradas de la notebook (Fran ya dijo sí); RetroBat en las dos máquinas con un tema de cajas (mostrarle 2 o 3 antes de fijar); Double Dragon II en red con la predicción escrita antes y lo medido después (`docs/spike-double-dragon.md`); accesos «ser anfitrión» y «unirse» | jugar con Kevin y decir si va |
| 3 | **El índice** | requisitos L2 del índice; catálogo único; inventario por máquina; generador de las carpetas y su verificador con sabotaje; las carpetas viejas se migran con planilla y deshacer, sin borrar | mirar la primera página del índice y decir si le gusta |
| 4 | **Minecraft: la tienda de mods** (en `minecraft-amigos`) | ver `minecraft-amigos/HANDOFF.md` | — |
| 5 | **Minecraft: server en la notebook y las instancias** (en `minecraft-amigos`) | ídem, con el paquete de Kevin preparado | entrar al server con Kevin |
| 6 | **Los espacios retro** | Sega (Master System, Game Gear, Sega CD, 32X, Saturn, Dreamcast con DCNet), PS1 (DuckStation, OnlineCTR), PS2 en RetroBat; 5 juegos de a dos probados cada uno en su pantalla | poner sus ROMs e ISOs en las carpetas que deja la sesión |
| 7 | **Lo pesado en la notebook por streaming** | Apollo en la PC y Moonlight en la notebook; Remote Play Together probado con un juego de Steam | jugar una partida para medir |
| 8 | **El método: investigar antes** (en `arquitectura-se`, Opus, esfuerzo alto) | DA-081 (el barrido de antecedentes como producto exigido al abrir un concepto) y DA-147/155 (la ficha de lecciones de un proyecto nuevo) | aceptar el cambio |
| 9 | **Pantalla dividida a dos pantallas** (spike, fase 3) | un juego de pantalla dividida con cada vista en su pantalla, o la medición que lo descarta | jugar la prueba |

## Lo que quedó a medias

- **Fase 0 (a)**: el concepto y los requisitos L0-L1 están escritos (`PDP.md`, `docs/10-requisitos.md`,
  0 VIOLA del GtWR, 29 REVISAR de aviso); falta el sí de Fran en la revisión de concepto.
- **Pedidos de Fran que esperan su sesión**: Chase H.Q. II (Mega Drive) en la biblioteca; otros clásicos
  de Sega; espacios de originales, con mods e innovaciones.
- La planilla de Retro Rusty que mandó Fran son links de descarga de packs de ROMs: no se bajan (R-01).

## Lo que NO hay que volver a intentar

- Leer `emulation.gametechwiki.com` desde el navegador del panel: Cloudflare lo bloquea.
- Medir la cobertura de mods de Modrinth bajando la lista entera de versiones de cada mod: se trabó; se
  consulta filtrado por versión y loader (`?loaders=[..]&game_versions=[..]`).

## Datos que no se pueden aproximar

- ROM: `C:\Users\frans\Downloads\Double Dragon II - The Revenge (Japan).zip` (adentro
  `Double Dragon II - The Revenge (Japan).md`, 1 MB).
- ISOs de PS2 en la cuarentena de la notebook:
  `Escritorio\_CUARENTENA - candidatos a borrar\07 - No se que es\` → `Z-dcdcJ8892l.rar` (God of War II
  NTSC, 6,05 GB, **no va**), y en `_Sin clasificar (con contrasena)\`: `P-S9t8lXi3gE.rar` (God of War II
  PAL, 2,87 GB), `U-rZqDyxjmcP.7z` (GTA SA latino v1.3, 2,36 GB), `8-lebuuOtfgO.7z` (Simpsons Hit & Run
  latino v0.8, 0,66 GB), `B-ivSvV2UUrj.rar` (PES 6, 1,26 GB), `Y-VbdE7ZzlaD.rar` (LEGO Batman PAL,
  1,19 GB). La contraseña la tiene Fran (no se escribe en el repo).
- PC: SSH `ssh -i ~\.ssh\pc-cable Fran@10.147.20.3`; Ethernet 192.168.1.7. Notebook: ZeroTier 10.147.20.2.
- PCSX2 de BLACK: `C:\Program Files\PCSX2` (2.6.3) en la PC, intocable.

## Si hay que abrir un chat nuevo

```
Proyecto juegos-casa (claude-acceso), fase 0 (Concepto, Pre-Fase A), sesión 2 del plan:
«La notebook liviana y Double Dragon II». Sonnet, esfuerzo medio, sin agentes.
1. .\cascada.ps1 juegos-casa -Necesidad ingenieria-inversa  y leer lo que pida.
2. Leer enteros: proyectos/ingenieria/juegos-casa/ESTADO_ACTUAL.md y HANDOFF.md;
   PDP.md §4 y §6; docs/investigacion-2026-11-24.md §1-§3 y §6.
3. Declarar el sistema: .\cascada.ps1 -Sistema juegos-pc -Investigacion
   proyectos/ingenieria/juegos-casa/docs/investigacion-2026-11-24.md -Prediccion "..." -Respaldo "..."
4. En orden: (a) las 6 ISOs de PS2 de la cuarentena a la PC, con MD5, sin el God of War II NTSC,
   y recién verificadas, borrarlas de la notebook (Fran ya dijo sí); (b) RetroBat en las dos
   máquinas, mostrarle a Fran 2-3 temas de cajas antes de fijar; (c) Double Dragon II en red
   entre las dos: predicción escrita en docs/spike-double-dragon.md ANTES de jugar.
Lo que cierra la sesión: Fran y Kevin juegan Double Dragon II cada uno en su pantalla, con la
conexión, la demora en cuadros y el MD5 de la ROM igual en las dos máquinas, medidos.
```
