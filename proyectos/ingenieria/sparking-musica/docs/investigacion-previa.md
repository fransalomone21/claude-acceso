# Investigación previa (afuera primero, DA-145): música del Sparking ZERO

Hecha el 2026-11-21 con el navegador, leyendo las páginas enteras (GameBanana por su API pública, Nexus por
texto). Todo es **lo que dicen los autores**; nada se probó en la PC todavía (`hipotesis` hasta probar).

## 1. Lo que ya existe

| Mod | Qué hace | Qué requiere | Fuente |
|---|---|---|---|
| **Kuro's Music Manager 1.3.3** (KurohaSaenoki) | Panel en el juego (**Shift+M**). Slots nuevos para música propia (sin reemplazar), loops, música aunque la ventana pierda foco, BGM de modo Sparking, **aleatorio de pelea (solo canciones propias)**, **BGM Swapper: "escuchar cualquier canción que ya esté en el juego"**, muestra la **clave** de cada canción, **botón "Save Updater"** (cambiar el orden o forzar el desbloqueo de las canciones modeladas), "Reload Music Mod JSONs" (nombres y volumen sin reiniciar), volumen general. Funciona en batalla personalizada. Limitaciones que declara: la vista previa de canciones propias en el menú **no suena** (en la pelea sí); pausar no corta la música propia | Carpeta `SparkingZERO\Mods` (o Unverum). **El idioma de texto del juego tiene que ser el mismo que el de Steam, o el juego se cierra al instalar música** | [GameBanana 595406](https://gamebanana.com/mods/595406) (26 MB). **La página de Nexus (mods/929) figura "Removed by staff"** |
| Packs "BGMMod…" (≈10 en GameBanana/Nexus) | Música nueva como slots. Se instalan en `Mods` junto al Manager. Cada carpeta lleva `MusicManagerConfig.json` (nombre, volumen 0-4, `allowRandomization`) | el Manager | p. ej. [Anime BGM from the JP Games](https://www.nexusmods.com/dragonballsparkingzero/mods/949) (68 temas), [Unrestricted BGM](https://www.nexusmods.com/dragonballsparkingzero/mods/1417) (duplica pistas del juego que no se podían elegir), [Rock BGM](https://gamebanana.com/mods/700812) y [alternative rock](https://gamebanana.com/mods/698037) (dicen traer **algo de Linkin Park**; sin lista de temas: no confirmado cuáles) |
| `ReOrderBGM.json` (en la carpeta del Manager) | Ordena y **oculta ("Locked")** pistas de los BGMMod; se aplica con "Update BGM Order" | el Manager | [Nexus 949](https://www.nexusmods.com/dragonballsparkingzero/mods/949) |
| Becks7 "Extra BGM Slots" | El antecesor del Manager: slots extra, **RePág/AvPág cambia de tema en plena pelea**, Inicio/Fin volumen | MusicManager viejo, no usar Unverum | [GameBanana 589244](https://gamebanana.com/mods/589244) |
| Sparking Zero Audio Importer / Ryo Framework | Reemplazo por .hca/acb en tiempo de ejecución (Reloaded-II); una carpeta con varios = aleatorio | Reloaded-II | [Nexus 493](https://www.nexusmods.com/dragonballsparkingzero/mods/493) |

**No existe un pack de Linkin Park de Hybrid Theory / Meteora** hecho: la búsqueda solo devolvió un pack de AMV con
"Numb" y los de rock de arriba. Habría que armarlo.

## 2. Cómo se arma música propia (para el Manager)

Unreal Engine 5 (la versión custom de la guía de modding) + Alpakit: crear un mod que empiece con `BGMMod`,
arrastrar .wav/.ogg (se vuelven SoundWave solos), tildar *Looping*, empaquetar. Es lo pesado: hace falta el
motor, no hay herramienta liviana en lo que encontré.

## 3. Lo que esto cambia para nuestro caso (cruzado con `menu-musica.md`)

- Los **famosos de la v4 (M1000–M1044) ya están en el juego**. El **BGM Swapper** y el **Save Updater** del Manager
  son justo lo que "escucha cualquier canción que ya esté en el juego" y "fuerza el desbloqueo": con eso se
  llegarían a elegir, **sin rehacer audio** (`hipotesis`: falta probar que alcanza a los M1000+ y que no pisa el DLC).
- El aleatorio del Manager es **solo de canciones propias**: para que los famosos "predominen" solos hace falta
  que sean BGMMod propios (UE5) o cambiar el audio de las 22 filas visibles (vía A de `menu-musica.md`).
- Esconder las filas de tele (DLC) con "Locked": el Nexus 949 dice que sirve para pistas de los BGMMod; **de las del
  DLC no dice nada** (`hipotesis`).
- Riesgos medidos en las fuentes: idioma del juego distinto del de Steam cierra el juego; la versión
  ElAmigos con `steam_emu.ini` puede no tener "idioma de Steam" (sin medir); el loader de la PC
  (`dsound.dll` + UTocBypass + ZeroSpark/SZModLib) no se probó con el Manager.

## 4. Vía elegida

**Paso 1 (barato y reversible): instalar Kuro's Music Manager 1.3.3 en la PC y probar el BGM Swapper en una
pelea**, con respaldo previo del guardado (`respaldo-save-1724`) y de `Mods`, sin tocar el DLC. Se declara con la
puerta (`-Sistema sparking-zero -Investigacion docs/investigacion-previa.md`). Lo prueba Fran con el oído: ¿se
puede elegir Numb / In the End de M1000+ en la pelea?
**Paso 2, según el resultado:** si el Swapper llega a los famosos pero no alcanza (no predominan, no son
elegibles en el menú), armar un BGMMod propio con Meteora y Hybrid Theory (UE5) o la vía A.
**Por qué esta y no otra:** es lo que la comunidad usa, no cambia audio, se desinstala borrando una carpeta, y
contesta con una prueba de 10 minutos si hace falta construir algo.

Pendiente de Fran para el paso 1: nada todavía; la sesión instala y le pide una cosa concreta (escuchar una
pelea). Descarga: 26 MB de GameBanana (a pedir permiso antes de bajarlo).
