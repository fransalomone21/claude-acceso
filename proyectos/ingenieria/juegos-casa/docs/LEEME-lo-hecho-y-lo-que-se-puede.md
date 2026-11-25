# Lo que ya anda y lo que se puede sumar (24 y 25 de noviembre de 2026)

Fran: esto es el resumen de lo que quedó andando en la note y en la PC, y de lo que encontramos afuera que se
puede sumar, cada cosa con lo que hace falta para tenerla. Lo técnico fino vive en el repo
(`proyectos/ingenieria/juegos-casa/`); acá va lo que cambia para vos.

## Lo que ya anda

### Clásicos de Sega de a dos, cada uno en su pantalla

- **Double Dragon II** en red entre la note y la PC: la PC se engancha a la note en unos 40 segundos, por
  ZeroTier, así que anda igual en casa que con Kevin desde la suya. Es la prueba que abrió todo.
- **16 clásicos más**, sacados del pack de Sega que bajaste, con la misma ROM exacta en las dos máquinas
  (comprobado archivo por archivo, que si no el juego en red se desincroniza):
  Streets of Rage 1, 2 y 3 · Golden Axe I, II y III · Double Dragon y Double Dragon 3 · Battletoads and
  Double Dragon · Tortugas Ninja: The Hyperstone Heist · Gunstar Heroes · Contra: Hard Corps · ToeJam & Earl ·
  Sonic 2 y Sonic 3 (el segundo jugador es Tails) · Mega Bomberman.
- **Chase H.Q. II** (de uno solo, de autos), como pediste.
- **Dónde están**: `Escritorio\Juegos\Juegos de a dos\`, una carpeta por juego, igual en las dos máquinas.
  Adentro de cada una hay tres accesos:
  1. **ser anfitrión** → el que arranca primero (normalmente la note);
  2. **unirse a la PC / unirse a la note** → el otro, después de que el anfitrión ya está adentro;
  3. **los dos en esta máquina** → dos joysticks en la misma pantalla.
- **Si se traba el menú**: Start + Select abre el menú de RetroArch; de ahí se sale o se reinicia.

### Juegos de PS2 y de PS3 en la PC

- En `C:\Games\PS2-ISOs\` de la PC: God of War II, GTA San Andreas en latino, Los Simpson Hit & Run en
  latino, PES 6 y LEGO Batman (comprobados byte por byte después de copiarlos).
- **God of War: Ghost of Sparta** (PS3) está en `C:\Games\PS3-ISOs\` de la PC, con su licencia al lado.

### La note respira

- Pasó de **9 GB libres a 121 GB**: se vació la cuarentena, se borraron los comprimidos duplicados (cada ISO
  comprobado antes) y lo intermedio del Sparking, todo con tu sí.
- El Escritorio de la note ya tenía una sola carpeta `Juegos`, igual que la PC; ahora `Juegos de a dos`
  está ordenada por juego. Lo que se movió y cómo deshacerlo:
  `proyectos/ingenieria/juegos-casa/docs/orden-escritorio-2026-11-25.md`.

### Minecraft

- **La juntada sin Tough As Nails**: se sacó el mod del frío y el calor que no te gustó (y el que lo
  necesitaba), del server y de las instancias de las dos máquinas. El mundo sigue igual.
- **Better MC 5** (1.21.1) instalado en la note y en la PC, igual en las dos, con su server propio en la note
  (**puerto 25567**; la juntada vieja sigue en el suyo).
- **La tienda de mods**: la está armando otra sesión («mc-tienda»): vos elegís mods en una página y las
  instancias de las dos máquinas quedan iguales solas.

## Lo que se puede sumar (y qué hace falta para cada cosa)

| Qué | Qué hace | Qué hace falta |
|---|---|---|
| **RetroBat con tema de cajas** | la vitrina con las cajitas en carrusel, como en la captura que mandaste; trae los emuladores y se fija sola que los dos tengan la misma ROM antes de jugar en red | una sesión para instalarlo en las dos (es gratis); que vos elijas el tema entre 2 o 3 que te muestro; el pack de Sega entero entra (pesa menos de 1 GB) |
| **PS Rewired** | revive el online de juegos de PS2 y PS3 (SOCOM, Killzone, Syphon Filter: The Omega Strain en co-op) en el emulador | una cuenta gratis en su página (la hacés vos) y las ISOs de esos juegos (las ponés vos) |
| **DCNet** | revive el online de Dreamcast desde el emulador Flycast, sin hardware raro (Phantasy Star Online, Quake III) | instalar Flycast (gratis), las imágenes de los juegos (vos) |
| **OnlineCTR** | Crash Team Racing de PS1 en red, hasta 8, cada uno en su pantalla | instalar DuckStation y el mod (gratis); la copia **NTSC-U** del juego (vos) |
| **Teamruns** | Jak and Daxter como juego nativo de PC, co-op en la misma o en red | los archivos de tu copia de PS2 de Jak 1 (vos) y una sesión para instalar OpenGOAL |
| **Remote Play Together** | juegos de Steam con co-op local jugados de a dos por internet: **sólo el que hostea tiene el juego** | Steam en la PC con el juego; el otro entra con un link (Steam Link, sin cuenta) |
| **Streaming PC → note** (Apollo + Moonlight) | la note juega lo pesado de la PC sin tenerlo instalado, a la resolución de la note | una sesión para instalar los dos (gratis) y una partida para medir la demora |
| **Dr. Robotnik's Ring Racers** | un kart de Sonic hecho por fans, gratis y legal: pantalla dividida de 4 y en red de 16 | bajarlo (gratis, de su página oficial); lo instala la sesión |

**Lo que todavía es prueba, no promesa**: que la PC dibuje un juego de pantalla dividida y mande una mitad a
la note (Nucleus Co-op + Apollo). Nadie documentó la combinación entera; es el spike de la fase 3.

## Lo que pide tu mano

- **Jugar y decir si van**: cada juego nuevo se prueba en caliente cuando termine la partida de hoy (abrir,
  captura y cerrar, en las dos máquinas).
- **Las ROMs e ISOs las ponés vos**: la sesión instala y ordena, pero no baja juegos.
- **El sí al concepto** de la biblioteca y a sus requisitos, que es lo que cierra la fase 0.
