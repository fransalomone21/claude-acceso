# La carpeta Juegos: cómo está ordenada y qué hay (25 de noviembre de 2026)

Fran: esto es lo que ves en `Escritorio\Juegos`, igual en la note y en la PC. Lo técnico vive en el repo
(`proyectos/ingenieria/juegos-casa/`); acá va lo que cambia para vos.

## Cómo está ordenada

| Dónde | Qué hay |
|---|---|
| **sueltos en Juegos** | los juegos de PC, uno por acceso, con el ícono del juego (Hades, The Last of Us, Sparking ZERO, Gang Beasts…) |
| **Sega** | los clásicos de Mega Drive, con su carátula. Cada uno abre «los dos en esta máquina»; las formas en red (ser anfitrión / unirse) están en «Jugar en red (cada uno en su pantalla)» |
| **PS2** · **PS3** · **Android** | los juegos de cada consola, con su carátula (PS2) o el ícono del juego (PS3). Android sólo en la PC |
| **Minecraft** | Jugar (Prism Launcher), la Tienda de mods, **Servidores** (el de la tienda, la juntada, Better MC 5, el 1.21.4 de la PC), Otros launchers, la Biblioteca de mods (PC) y «Como jugar.txt» |
| **Clasificados** | la clasificación de anoche, toda junta: De a dos (con el «Como jugar de a dos.txt» de cada juego), Por modo, Por tipo y Por versión |
| BLACK, Emuladores, Utilidades, Mods, Juegos de PC / Juegos instalados, Juegos de emulador | quedaron como estaban: adentro hay juegos instalados o cosas de otros proyectos, y moverlas las rompe |

**Todo esto se arma solo desde la lista de juegos del repo**: si un juego nuevo se instala, la próxima vez que
se arma aparece; si algo se borra de estas carpetas, se vuelve a poner. Lo de adentro no se toca a mano.
En la note las carpetas ya están en íconos grandes; en la PC, si se ven chiquitos: Ver > Íconos grandes.

Los accesos viejos (los sueltos de Juegos, «Juegos de a dos», «Sega - los dos en la PC», «Juegos de PC\Accesos»
y el Minecraft viejo) no se borraron: están en `C:\Games\_indice\accesos\` de cada máquina, con la misma ruta
que tenían, y de ahí los copia el índice.

**Hoy:** la note tiene 45 juegos y la PC 54, con 39 carátulas e íconos de juego. Lo que está en un disco USB (Battlefront II original, tres BT3)
aparece con «(disco USB)» en el nombre: hay que enchufarlo antes.

## De a dos

- **Los clásicos de Sega** (Double Dragon II y 16 más: Streets of Rage 1-3, Golden Axe I-III, Double Dragon 1 y
  3, Battletoads, Tortugas Ninja, Gunstar Heroes, Contra Hard Corps, ToeJam & Earl, Sonic 2 y 3, Mega
  Bomberman): **lo recomendado es los dos en la PC con dos joysticks** («los dos en esta maquina»). En red
  («ser anfitrion» en una, «unirse a ...» en la otra) anda, pero anoche se ralentizó y se desincronizó; desde
  hoy RetroArch juega en red con 2 cuadros de margen y chequea cada medio segundo que las dos vayan iguales,
  que es el arreglo para eso. Falta probarlo jugando.
- **CoD World at War**: pantalla dividida en una compu (la receta entera está en la carpeta PS3 y en «Clasificados\De a dos»).
- **Minecraft**: abajo.
- Cada juego de a dos dice en su txt si está **probado**, **probable** o **sin probar**.

## Minecraft

1. En la **note**: «Server de la tienda». Prende el server **y** el pack (las dos cosas, de una).
2. En cada máquina: **Prism Launcher** > instancia **«Tienda 1.21.1»** > Jugar. Se pone igual al pack sola y
   entra directo al server.
3. Para cambiar los mods: **«Tienda de mods»** en la note, elegís y confirmás; la próxima vez que abran el
   juego, las dos máquinas se actualizan solas. Hoy está publicada **Aventura minecraftera** (106 mods).
4. **Kevin** desde su casa: el paquete de Kevin (`C:\Users\frans\MinecraftServer\tienda\paquete-kevin.zip`),
   una sola vez.
- Probado hoy: el server acepta a la PC por ZeroTier y por la red de casa; todos los jars del catálogo (297)
  están también guardados en la PC en `C:\Games\Minecraft-mods`, ordenados por familia.
- **Lo tuyo**: en Prism de cada máquina, la cuenta sin conexión (Cuentas > Agregar sin conexión): en la PC,
  **Kheven**; en la note, la tuya (hoy la note no tiene ninguna, y sin cuenta Prism no abre el juego).

## Lo que se puede sumar (y qué hace falta)

| Qué | Qué hace | Qué hace falta |
|---|---|---|
| **RetroBat con tema de cajas** | la vitrina con las cajitas, como en la captura que mandaste | una sesión; que elijas el tema entre 2 o 3 que te muestro |
| **PS Rewired** | revive el online de juegos de PS2 y PS3 en el emulador | una cuenta gratis (la hacés vos) y las ISOs (vos) |
| **DCNet** | el online de Dreamcast desde el emulador Flycast | instalar Flycast (gratis) y las imágenes (vos) |
| **OnlineCTR** | Crash Team Racing de PS1 en red, cada uno en su pantalla | DuckStation y el mod (gratis); la copia NTSC-U (vos) |
| **Remote Play Together** | juegos de Steam de a dos por internet: sólo el que hostea tiene el juego | Steam en la PC con el juego |
| **Streaming PC → note** (Apollo + Moonlight) | la note juega lo pesado de la PC sin tenerlo instalado | una sesión y una partida para medir la demora |

**Lo que todavía es prueba, no promesa**: que la PC dibuje un juego de pantalla dividida y mande una mitad a
la note. Es el spike de la fase 3.

## Lo que pide tu mano

- **Las cuentas sin conexión de Prism** (arriba): sin eso Minecraft no abre en la note.
- **Jugar y decir si van**: los Sega en red con el arreglo nuevo, y Minecraft con Kevin en el server de la tienda.
- **Mirar la carpeta y decir si te gusta así**: se cambia en un rato y se rearma solo.
- **El sí al concepto** de la biblioteca y a sus requisitos, que es lo que cierra la fase 0.
