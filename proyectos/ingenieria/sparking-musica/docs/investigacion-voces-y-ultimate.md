# Investigación: voces en inglés y la música que se corta en el ataque final (2026-11-21, noche)

Pedido de Fran (2026-11-21 ~20:00): «soluciona las voces en inglés que quedaron en algunos personajes como Whis y
Vegeta Ultra Ego, además de cuando tiro el ataque final de Vegeta se va la música de fondo; revisá que no pase en
otros personajes ni ataques». Afuera primero (DA-145), y lo medido en la PC en frío (sin tocar el juego).

## 1. Lo que dice afuera

| Fuente | Qué dice | Qué cambia para nosotros |
|---|---|---|
| [Gladius Theme Music Packs, ANTIBigBoss (Nexus 488)](https://www.nexusmods.com/dragonballsparkingzero/mods/488), leída entera con el navegador | El juego tiene **dos juegos de pistas**: las de fondo y las **«Sparking themes»** (Impartial Justice, Dreadful Villain, Morally Gray, Divine Judgement, Ultimate Survivor, Absolute Domination, Swirling Chaos, Ultra Instinct, *Let's Rock!*), que suenan al entrar en **modo Sparking**. «Due to how the game handles overlapping tracks, these files don't always loop perfectly»; recomienda no instalar el pack Sparking o el mod *Remove Music of Sparking Mode* | el ataque final se tira **en modo Sparking**: ahí el juego cambia de pista. Es el sospechoso número uno |
| Búsqueda general ([Nexus 1023](https://www.nexusmods.com/dragonballsparkingzero/mods/1023), [139](https://www.nexusmods.com/dragonballsparkingzero/mods/139), [190](https://www.nexusmods.com/dragonballsparkingzero/mods/190?tab=docs), [929](https://www.nexusmods.com/dragonballsparkingzero/mods/929)), resumen del buscador, sin abrir cada página (Nexus niega la lectura automática) | un pack de BGM anotó en su registro que «ciertas pistas paran y no vuelven a arrancar»; el Music Manager declara «Sparking Mode BGM Support» y opción para **desactivar la música Sparking**; otro mod deja elegir la música Sparking **por personaje** en el menú de personalización | el cambio de pista en Sparking es un punto conocido donde la música se corta con mods de audio |
| Búsqueda «Remove Music of Sparking Mode» (comentarios de [Nexus 436](https://www.nexusmods.com/dragonballsparkingzero/mods/436?tab=posts), [Nexus 113](https://nexusmods.com/dragonballsparkingzero/mods/113), docs de [Nexus 493](https://nexusmods.com/dragonballsparkingzero/mods/493?tab=docs)), resumen del buscador | la música Sparking **se elige por personaje** en el menú de Personalización («Sparking! BGM»), y **la primera opción de esa lista la silencia**; la comunidad usa un mod que **elimina la música Sparking** (citado como mods/112, sin abrir) para que la de pelea siga sin cortarse; otro (LeonEF) la deja sonar sin interrupción | el corte puede ser simplemente que Vegeta (o el Ultra Ego agregado) tiene elegida la primera opción, o una pista Sparking que quedó muda |
| [Tiendas del Anime Music Pack](https://store.playstation.com/en-us/product/UP0700-PPSA15211_00-DBSZ0BGMANIME001) | el pack «permite cambiar la música de pelea **y la del modo Sparking**» por los temas del anime | las filas de tele (Ryo) también son elegibles como música Sparking |
| Búsqueda de doblaje latino ([Nexus 1295](https://www.nexusmods.com/dragonballsparkingzero/mods/1295), [1416](https://www.nexusmods.com/dragonballsparkingzero/mods/1416); [Vandal](https://vandal.elespanol.com/noticia/1350775029/sera-posible-jugar-con-voces-en-espanol-a-dragon-ball-sparking-zero-gracias-a-estos-trabajados-mods-de-doblaje/)) | los mods latinos son **por personaje**, de autores distintos; no hay un paquete único que cubra todo | cada mod elige qué idioma pisa: hay que medir cuál |
| Búsqueda «Vegeta Ultra Ego» | Ultra Ego **no está en el juego base**: es un personaje agregado por mod (el de la PC está en `Mods\VegetaUltraEgo`) | su voz es la del banco que reusa, no una propia |

## 2. Lo medido en la PC (solo lectura, 2026-11-21 20:06)

- **Voces:** de los índices de los 137 paquetes de `~mods` (copiados a la notebook) salen **136 bancos de voz pisados**
  por mods latinos: **88 pisan las dos voces (japonesa e inglesa)**, **48 pisan SOLO la japonesa** y **0** solo la
  inglesa. Entre los 48: Whis (`BTLCV_0790_00`), la familia de Vegeta Super (`0020_60/61/63`, `0022_62`, mod
  `VegetaSuper`), las cinco Gogetas, los tres Gotenks, Krillin, Yamcha, Trunks niño, Kefla, Androide 18, Ginyu,
  Recoome, Guldo, Zamasu, Kid Buu, Mecha Freezer, Gohan definitivo y todo lo de `DBSZLT` (Goku, Vegeta, Gohan, Cell…
  bases). Tabla completa: [`voces-cobertura.txt`](voces-cobertura.txt) (205 bancos del juego: 88 latinos en los dos idiomas, 48 solo en japonés, 69 sin mod).
- El mod `VegetaUltraEgo` no trae `CharacterSound` ni banco de voz propio (su índice no los nombra): reusa la voz de
  otro Vegeta (probable: la familia Super, que tiene latino solo en japonés).
- **Música:** en la tabla de fábrica de `bgm_main`, cada pista de pelea `M_1000…M_1044` tiene su gemela
  `M_10xx_SPK` (modo Sparking) **sobre la misma onda**; las filas del menú que cambió la v5 (`M_0102…M_0122`) **no
  tienen gemela `_SPK`**. Las del DLC (tele) sí: `M_20xx_SPK`, que Ryo pisa.

## Conclusion

- **Voces (probable, falta oírlo):** el juego está con **voces en inglés**; los 48 bancos que los mods latinos pisan
  solo en japonés suenan en inglés. El arreglo de menor costo es **cambiar el idioma de voces del juego a japonés**
  (Opciones → Sonido): los 136 quedan en latino, y los personajes sin ningún mod pasan de inglés a japonés. El
  arreglo completo, sin depender del menú, es un paquete propio que copie cada banco `_JP` latino como `_US`
  (mismo largo de nombre; la misma técnica del plan `af-voces-plan.md`), que pide `retoc` (descarga, con el sí de
  Fran).
- **Las categorías de música del juego** (de `fichas-bgm.txt`, los datos del juego leídos por la sesión anterior):
  `BattleBGM` (pelea), `SparkingBGM` (45: los temas Sparking `M_0200…M_0209` —que la v1–v4 pasó a LP— y las gemelas
  `M_10xx_SPK`), `DramaticBattleBGM` (`M_1100` y las 23 del DLC `M_2000…M_2022`, las de tele que pisa Ryo),
  `JingleBGM` (`M_0029…M_0034`, protegidas) y `StoryBGM`.
- **Música en el ataque final (hipótesis, a medir):** el corte coincide con la entrada/salida del modo Sparking.
  Candidatas: (a) la fila elegida es de la v5 (`M_01xx`) y no tiene gemela `_SPK`; (b) el tema Sparking propio del
  personaje (el de Vegeta es *Let's Rock!*) o el del personaje agregado apunta a una pista que no existe; (c) el
  cambio de pista de Ryo; (d) **la más barata de descartar**: el personaje tiene elegida como música Sparking la
  primera opción de la lista (silencio). Se distingue **oyendo**: la misma pelea con una fila de pelea `M_10xx` o de tele, y con la
  música Sparking desactivada en las opciones. La sesión todavía no puede oír la PC: armar la grabación de lo que
  sale por los parlantes (loopback) es lo primero de la próxima tanda, con el juego cerrado.
