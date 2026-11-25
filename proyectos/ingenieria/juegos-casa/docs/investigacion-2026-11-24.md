# Investigación del 2026-11-24 — jugar de a dos, emuladores, packs y Minecraft

Sesión de diseño (Opus, esfuerzo máximo para el plan; Fran baja a medio para ejecutar). Pedido de Fran:
Double Dragon II de Mega Drive con su primo Kevin, cada uno en su pantalla; una carpeta de juegos
clasificada en cada máquina; qué emuladores o paquetes dan muchos juegos de Sega, PS1 y PS2; otros
clásicos de Sega y «espacios» de originales, con mods e innovaciones; y el Minecraft nuevo (eso vive en
`minecraft-amigos`, ver `../../minecraft-amigos/docs/fase-2-tienda.md`).

Grados: **medido** (lo vi en la máquina o en la fuente primaria), **probable** (dos fuentes secundarias
coinciden), **hipótesis** (una sola fuente o deducción). Las fuentes, al final, con su número.

---

## 1. Las máquinas, medidas hoy (no leídas de un documento)

| | Notebook (MSI) | PC de casa (PCFRAN) |
|---|---|---|
| GPU | RTX 4060 Laptop | RTX 3090, monitor 2560x1440 a 143 Hz |
| RAM | 23,8 GB | 15,3 GB |
| Disco C: libre | **9 GB de 931** | **106 GB de 953** |
| Red | Wi-Fi + ZeroTier 10.147.20.2 | Ethernet 192.168.1.7 + ZeroTier 10.147.20.3 |
| Carpeta de juegos | `Escritorio\Juegos\` con 9 subcarpetas (BLACK, Emuladores, Juegos de a dos, …) | `Escritorio\Juegos\` y `Escritorio\Juegos de a dos\` sueltas |
| Emuladores | PCSX2 2.8.2, RPCS3 0.0.43 (en `C:\Games`) | PCSX2 2.8.2 y 2.6.3 (BLACK), RPCS3, BlueStacks |
| Sin instalar | RetroArch, Playnite, RetroBat, Moonlight, Apollo, Parsec | — (Parsec sí, según la memoria) |

**El factor limitante es el disco de la notebook** (medido). Todo lo pesado tiene que vivir en la PC.

La cuarentena de la notebook (31,3 GB) tiene, en «07 - No sé qué es», **seis ISOs de PS2** (listadas con
7-Zip, medido): God of War II NTSC (8,1 GB, en inglés) y PAL (3,9 GB, con castellano), GTA San Andreas
latino v1.3 (4,3 GB), Los Simpson Hit & Run latino v0.8 (2,0 GB), PES 6 (1,5 GB) y LEGO Batman PAL
(2,0 GB). Fran decidió (2026-11-24): a la PC, un solo GoW II (el PAL), verificar y recién ahí borrar en la
notebook. Además hay un `.pkg` de God of War: Ghost of Sparta (9,1 GB) que probablemente ya está
instalado en RPCS3 (hay acceso directo): **hipótesis**, se verifica antes de proponer borrarlo.

**La ROM de Double Dragon II ya está bajada** por Fran: `Descargas\Double Dragon II - The Revenge (Japan).zip`
(un `.md` de 1 MB adentro, medido).

## 2. Double Dragon II de Mega Drive

- Salió **sólo en Japón**, el 20/12/1991, por Palsoft; es un port del arcade de 1989 [1][2] (medido en
  dos fuentes).
- **Dos jugadores a la vez, cooperativo**, con el fuego amigo desactivable (el arcade no deja) y con
  bajones de velocidad que molestan a los dos [3] (probable: Co-Optimus y TheGamesDB coinciden en el modo).
- Cada uno en su pantalla: **RetroArch en red (netplay)** con el núcleo Genesis Plus GX, que está en la
  lista de núcleos con netplay [4][5]. Condiciones: el **mismo núcleo, la misma versión y la misma ROM** en
  las dos máquinas (el formato de los savestates de Genesis Plus GX depende de la plataforma: Windows con
  Windows anda) [5]; por la red de casa no hace falta abrir puertos (el 55435 es para internet) y el retardo
  de entrada se deja en 0-1 cuadros [5][6]. El anfitrión, en la máquina con cable (la PC) [6].
- Desde la casa de Kevin: por ZeroTier, como LAN. Kevin necesita RetroArch, el núcleo y **su** ROM.
- Alternativas legales que quedaron como plan B (Fran eligió la de Genesis):
  - **Double Dragon Trilogy** (Steam, DotEmu, arcade DD 1-3): USD 3,59 hoy, co-op y **Remote Play Together**
    (medido en la tienda, 2026-11-24) [7].
  - **Double Dragon Revive** (2025, Yuke's / Arc System Works): co-op local y en línea de 2, USD 33,98,
    63 % de reseñas positivas (medido en la tienda) [8].

## 3. Cada uno en su pantalla — la escalera (de lo mejor a lo último)

Regla de Fran (2026-11-20): uno por pantalla; si el juego es de pantalla dividida, buscar o hacer la versión
de una pantalla por jugador; si no se puede, el juego va a la PC. Lo que encontré, en orden de preferencia:

1. **Red propia del juego** (PC): Minecraft, Plutonium (CoD), los juegos con LAN u online.
2. **Emulador en red**: RetroArch netplay (rollback) para NES, SNES, Mega Drive, arcade (FBNeo) [4][5].
   PS1 por RetroArch: los documentos de Beetle PSX marcan netplay como **no soportado** [9]: hipótesis a
   medir con SwanStation. PCSX2 **no tiene netplay**, pero emula el adaptador de red (DEV9): los juegos de
   PS2 que traen modo LAN se juegan entre dos PCSX2 por la red; los foros dicen que anda y que es delicado
   (sockets o pcap según la máquina) [10] (hipótesis, por juego).
3. **Servidores revividos**, cada máquina con su emulador: **PS Rewired** (PS2, PSP y PS3: SOCOM 1-3,
   Killzone, Gran Turismo 4 online beta, Syphon Filter: The Omega Strain, Twisted Metal Head-On,
   Resistance, MotorStorm; tiene guía para PCSX2) [11][12] (medido en su página); **DCNet** de Flycast para
   Dreamcast, sin DreamPi, con unos 20-30 juegos (NFL/NBA 2K, Phantasy Star Online v1 y v2 que van por
   sus propios servidores, Quake III, StarLancer…) [13][14] (probable).
4. **Mods que le agregan red a un clásico de pantalla dividida**: **OnlineCTR** (Crash Team Racing de PS1
   por DuckStation, hasta 8 por internet, gratis, pide la copia NTSC-U) [15]; **Teamruns** de OpenGOAL
   (Jak and Daxter 1 como port nativo de PC, co-op local y en línea) [16]; Plutonium (CoD).
5. **Steam Remote Play Together**: para juegos de Steam con co-op local; **sólo el anfitrión tiene el
   juego** y el invitado entra con un link desde la app Steam Link, sin cuenta (un invitado así por
   sesión) [17] (probable).
6. **Streaming de la PC a la notebook** (Moonlight con Sunshine o Apollo, o Parsec): los dos ven lo mismo;
   sirve para que la notebook juegue lo pesado sin tenerlo instalado. Apollo crea una **pantalla virtual**
   con la resolución del cliente [18] (medido en su README).
7. **Experimental — la PC dibuja las dos vistas y manda una a la notebook**: Nucleus Co-op (ahora
   SplitScreen.Me, 800+ juegos de PC con «handler», casi todos con mandos XInput) abre una instancia por
   jugador [19]; con la pantalla virtual de Apollo, la instancia 2 iría a la notebook. Para emulados de
   pantalla dividida, recortar cada mitad con OBS a un proyector por pantalla [20]. **Nadie documenta la
   combinación completa** (búsqueda dio cero): es un spike con predicción escrita, no un plan.
8. Si nada de eso: en la PC, pantalla dividida, dos joysticks.

## 4. Emuladores, frontends y «packs»

- **Lo que se instala**: RetroArch (gratis, multiplataforma, netplay) con Genesis Plus GX (Mega Drive,
  Master System, Game Gear, Sega CD), PicoDrive (32X), FBNeo (arcade); DuckStation (PS1, la mejor calidad,
  y el que pide OnlineCTR); PCSX2 2.8.2 (ya está); Flycast (Dreamcast, con DCNet); Beetle Saturn por
  RetroArch (Saturn). Todos gratuitos.
- **Frontends** (la «vitrina» para cientos de juegos): Playnite (gratis, MIT, también ordena los juegos de
  PC), ES-DE (gratis, multiplataforma, colecciones propias), RetroBat (gratis, Windows, trae y configura
  los emuladores solo, con lista de netplay que chequea que los dos tengan la misma ROM por CRC), LaunchBox
  (la vista linda es paga) [21][22][23]. Las comparativas de 2026 son casi todas de un mismo sitio:
  probable, no medido.
- **«Packs» de juegos**: los conjuntos de ROMs e ISOs que circulan son de juegos comerciales: la sesión no
  los baja; Fran pone sus copias. Lo legal que había de Sega en PC se fue: **SEGA Mega Drive & Genesis
  Classics** y los Dreamcast Classics se retiraron de Steam el 6/12/2024 (quien los compró los conserva)
  [24][25] (medido en dos fuentes).
- **Innovaciones gratuitas y legales con espíritu Sega**: **Dr. Robotnik's Ring Racers** (kart de Sonic,
  pantalla dividida de 4 y en línea de 16, gratis y de código abierto) [26]; Sonic Robo Blast 2. De pago:
  Streets of Rage 4 (co-op en línea).

## 5. Clásicos de a dos para sembrar el catálogo (candidatos, a clasificar con evidencia)

- **Mega Drive** [27][28]: Streets of Rage 2 (y 1 y 3), Golden Axe, Gunstar Heroes, Contra: Hard Corps,
  TMNT: The Hyperstone Heist, Sonic 3 & Knuckles (co-op liviano), ToeJam & Earl (pantalla que se parte
  sola), Mega Bomberman, Snow Bros., NBA Jam, Herzog Zwei, World of Illusion (Mickey y Donald, co-op).
- **Dreamcast**: Phantasy Star Online (co-op en línea por DCNet), Power Stone 2, ChuChu Rocket!.
- **PS1**: Crash Team Racing (OnlineCTR), Crash Bash, Tekken 3, Metal Slug X, Gauntlet Legends.
- **PS2** (lo que ya hay más lo de la cuarentena): Battlefront II y su mod BF3 Legacy, LEGO Batman, GTA San
  Andreas (co-op en la misma pantalla), Los Simpson Hit & Run, PES 6, Syphon Filter: The Omega Strain
  (co-op en línea por PS Rewired), TimeSplitters, Marvel: Ultimate Alliance.

Cada uno entra al catálogo con su modo de juego verificado contra Co-Optimus o PCGamingWiki y con su
estado de prueba (probado / probable / sin probar). La lista de arriba **no** está verificada juego por juego.

## 6. La planilla de Retro Rusty y la captura (agregado el mismo día)

Fran mandó una planilla de Google («ahí tengo mis juegos») y una captura de un video de Retro Rusty. La
planilla, leída como CSV (medido): **«RetroRusty - Links and packs database»**, una base pública de
**packs de ROMs** por sistema con links a Gofile, 1Fichier, Mega, Internet Archive y torrents, con sus
contraseñas. No son archivos de Fran: son descargas de juegos comerciales de terceros, y la sesión no las
baja (R-01). Lo que sí sirve de la planilla:

- **Usa los nombres de carpeta de RetroBat y Batocera** (`megadrive`, `mastersystem`, `gamegear`, `psx`,
  `ps2`, `dreamcast`, `saturn`…), con arte incluido: lo que Fran ponga en esas carpetas aparece solo.
- **Los tamaños mandan**: Mega Drive 8,7 GB (1123 juegos), Master System 2,7 GB, Game Gear 2,8 GB entran
  en cualquier máquina; **PlayStation 595 GB (2217 juegos) y Dreamcast 328 GB no entran en ninguna** (la
  PC tiene 106 GB libres), y PS2 (717 juegos) tampoco. De lo grande se eligen juegos, no packs.

La captura es **RetroBat** (o su hermano Batocera) con un tema de cajas en carrusel: el frontend que le
gusta a Fran. Pidió además **Chase H.Q. II** (Mega Drive, Taito 1993, un jugador, carreras).

---

## Conclusión

La necesidad de Fran ya tiene casi todas sus piezas resueltas afuera, y la arquitectura sale de juntarlas,
no de inventarlas: RetroArch en red resuelve Double Dragon II y los clásicos 2D cada uno en su pantalla;
los servidores revividos (PS Rewired, DCNet) y los mods de red (OnlineCTR, Teamruns) resuelven varios de
PS1, PS2 y Dreamcast; Remote Play Together resuelve los de Steam con co-op local; y lo que queda de
pantalla dividida pura va a la PC, con un spike para mandar una vista a la notebook. El factor limitante no
es el software sino el disco de la notebook (9 GB): la biblioteca pesada vive en la PC y la notebook juega
lo liviano en local y lo pesado por streaming. No hay ningún pack legal de ROMs que bajar: Sega retiró los
suyos de Steam en 2024; las copias las pone Fran.

## Fuentes

1. Wikipedia, *Double Dragon II: The Revenge* — https://www.wikipedia.com/wiki/Double_Dragon_II
2. Sega Retro, *Double Dragon II: The Revenge* — https://segaretro.org/Double_Dragon_II:_The_Revenge
3. Co-Optimus, *Co-Op International: Double Dragon II Edition* — https://www.co-optimus.com/editorial/1123/co-op-international-double-dragon-ii-edition.html
4. RetroArch, netplay — https://www.retroarch.com/netplay.php
5. libretro docs, *Netplay FAQ* — https://docs.libretro.com/guides/netplay-faq/
6. Retro Handheld HQ, *RetroArch netplay guide* (marzo 2026) — https://retrohandheldhq.com/posts/retroarch-netplay-guide/
7. Steam, *Double Dragon Trilogy* — https://store.steampowered.com/app/314150/Double_Dragon_Trilogy/
8. Steam, *Double Dragon Revive* — https://store.steampowered.com/app/3012220/Double_Dragon_Revive/
9. libretro docs, *Beetle PSX HW* — https://docs.libretro.com/library/beetle_psx_hw/
10. Foro de PCSX2, *LAN play on Nightly builds* — https://forums.pcsx2.net/Thread-LAN-play-on-Nightly-builds
11. PS Rewired — https://psrewired.com/
12. PS Rewired, guía para PCSX2 — https://psrewired.com/guides/pcsx2
13. Flycast wiki, *DCNet* — https://github-wiki-see.page/m/TheArcadeStriker/flycast-wiki/wiki/DCNet
14. Flycast, versiones (2.6: Hundred Swords, PBA Bowling, StarLancer, The Next Tetris) — https://github.com/flyinghead/flycast/releases
15. CTR-ModSDK, *OnlineCTR* — https://github.qingwei-s.workers.dev/CTR-tools/CTR-ModSDK/wiki/OnlineCTR y Time Extension — https://www.timeextension.com/news/2024/06/crash-team-racing-has-been-rebuilt-by-fans-for-online-play
16. GamesRadar, Jak and Daxter con multijugador local y en línea (Teamruns) — https://gamesradar.com/games/platformer/after-23-long-years-jak-and-daxter-fans-do-what-sony-wont-and-port-the-classic-ps2-game-to-pc-now-with-local-and-online-multiplayer
17. PC Gamer, *Remote Play Together now works with people who don't have Steam* — https://pcgamer.com/steam-remote-play-together-now-works-with-people-who-dont-have-steam
18. Apollo (fork de Sunshine con pantalla virtual) — https://github.com/ClassicOldSong/Apollo
19. SplitScreen.Me (Nucleus Co-op), juegos soportados — https://www.splitscreen.me/docs/games
20. Foro de OBS, dos proyectores recortados de una misma captura — https://obsproject.com/forum/threads/view-preview-on-two-screens.126167/post-469887
21. Emulation General Wiki, comparación de frontends — https://emulation.gametechwiki.com/index.php/Comparison_of_Emulator_Frontends
22. RetroBat wiki, netplay — https://wiki.retrobat.org/advanced-features/netplay
23. Tech Insider, *LaunchBox vs Playnite vs ES-DE 2026* — https://tech-insider.org/launchbox-vs-playnite-vs-es-de-2026/
24. PC Gamer, Sega retira sus clásicos de Steam — https://pcgamer.com/games/sega-is-delisting-a-huge-number-of-its-greatest-classic-games-on-steam-probably-so-it-can-sell-you-a-new-collection
25. Siliconera, fecha del retiro (6/12/2024) — https://www.siliconera.com/sega-will-be-delisting-its-sega-classics-games/
26. Kart Krew, *Dr. Robotnik's Ring Racers* — https://www.kartkrew.org/news/2024-04-24_dr-robotniks-ring-racers-version-20.html
27. Infinity Retro, *Best Genesis multiplayer games* — https://infinityretro.com/best-genesis-multiplayer-games/
28. Co-Optimus, *SEGA Genesis Classics* (17 juegos con co-op de 2) — https://www.co-optimus.com/review/2118/page/1/sega-genesis-classics-co-op-review.html

**Búsquedas que dieron cero o fallaron, con su parámetro** (un negativo vale lo que su parámetro):
la wiki de emulación (gametechwiki) corta con Cloudflare desde el navegador del panel; «Apollo + Nucleus»
juntos: cero resultados (la combinación no está documentada, no prueba que no ande); «Battlefront II PS2
online revival»: no aparece en PS Rewired (hipótesis abierta: otro grupo).
