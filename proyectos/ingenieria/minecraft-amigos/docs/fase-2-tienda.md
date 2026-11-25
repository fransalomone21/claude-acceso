# Fase 2 — el pack nuevo y la tienda de mods (diseño del 2026-11-24)

Pedido de Fran (2026-11-24): la última versión jugable con más mods; mods «minecrafteros» que agreguen
dimensiones, estructuras, animales, mecanismos, dungeons, minerales más fuertes y jefes, sin ser súper
complejos y **sin el de frío y calor** (Tough As Nails, que estaba en el pack 1.21.4); varias
combinaciones con su descripción; todos los mods bajados y ordenados; una lista linda para tildar «como
quien agrega al carrito» que arme sola la instancia en las dos máquinas; el server en la notebook (más
RAM). Aprobó la forma: «sí, así, quiero que sea sencillo y que esté probado»; la notebook de Kevin no
está a mano: se deja preparada. Requisitos: [`10-requisitos.md`](10-requisitos.md).

## 1. La versión: 1.21.1 con NeoForge (medido)

Cantidad de mods publicados en Modrinth por versión (API `/v2/search`, facetas versión + tipo mod,
2026-11-24):

| Versión | Fecha | Mods (total) | De aventura | NeoForge | Fabric | Forge |
|---|---|---|---|---|---|---|
| 1.20.1 | 2023 | 35 652 | 9 791 | 5 278 | 18 263 | 26 001 |
| **1.21.1** | 2024-08 | **33 826** | **8 224** | **22 827** | 20 558 | 5 723 |
| 1.21.4 (la juntada) | 2024-12 | — | — | 9 764 | 14 135 | 4 537 |
| 1.21.11 | 2025-12 | 20 723 | 3 950 | 8 706 | 18 894 | 4 751 |
| 26.1.2 | 2026-04 | 16 514 | 3 482 | 9 042 | 14 322 | 3 711 |
| 26.3 (la última) | 2026-09 | 11 567 | 2 349 | — | — | — |

Cobertura de los candidatos de Fran (por versión y cargador, misma API): en **1.21.1 NeoForge** están
Aether, Deep Aether, Undergarden, Deeper and Darker, Eternal Starlight, Bumblezone, Ad Astra, Nullscape,
Incendium, todos los YUNG, When Dungeons Arise, Dungeons and Taverns, Towns and Towers, Explorify,
Structory, Lootr, L_Ender's Cataclysm, Mowzie's Mobs y Aquamirae. **Se pierden** los que quedaron en
1.20.1: Alex's Caves, Blue Skies (y Alex's Mobs). Twilight Forest no está en Modrinth: se busca en
CurseForge en la sesión de la tienda.

## 2. Lo que ya existía afuera (antes de diseñar)

- **Better MC 5 (NeoForge 1.21.1)**: un modpack «vanilla+» armado y probado por otros. Su índice (bajado
  de Modrinth, v31, 271 jars) trae Aether con Aether Villages, L_Ender's Cataclysm, Dragon Mounts
  Remastered, When Dungeons Arise, todos los YUNG, Moog's Voyager y Nether Structures, Repurposed
  Structures, Explorify, Oh The Biomes We've Gone, Friends & Foes, Farmer's Delight, Waystones, los mapas
  de Xaero, JEI, Jade, Sodium e Iris. **Sin temperatura ni sed**; trae **Serene Seasons** (estaciones que
  cambian los cultivos). La versión más nueva está en CurseForge (v51); Modrinth quedó en la v31.
  Licencia ARR: se usa en casa, no se republica.
- **packwiz**: la herramienta estándar para packs que se actualizan solos: el pack es una carpeta de
  texto (un archivo por mod, con URL y hash), se sirve por HTTP y cada instancia de Prism la sincroniza
  antes de arrancar con `packwiz-installer` como comando previo al lanzamiento; el server igual, con el
  lado `server`.
- **Prism Launcher** ya trae un buscador de mods con carrito, pero por instancia y por máquina: no
  sincroniza, no tiene combinaciones ni prueba de arranque.

## 3. La arquitectura

```
            [ la tienda ]  página local en la notebook (http://10.147.20.2:<puerto>)
                  | Fran tilda y confirma
                  v
     [ armar ]  packwiz agrega y saca mods  ->  bloquea la lista de castigos (L1-10)
                  |                          ->  server de prueba: arranca la selección (L1-05/06)
                  v                               (si no llega a "Done", no se publica)
     [ el pack publicado ]  carpeta packwiz servida por HTTP desde la notebook
          |                    |                         |                    |
   Prism notebook        Prism PC (LAN)        Prism de Kevin (ZeroTier)   server (lado server)
   se sincroniza al abrir el juego, comparando hash (L1-03)
```

- **Una sola fuente**: el pack publicado en la notebook. Nadie copia jars a mano (regla 3 del contrato;
  lección del proyecto).
- **El catálogo de la tienda** sale de Modrinth (nombre, imagen, cargador, versión, lado
  cliente/server, dependencias) más una descripción en criollo y la familia de contenido, escritas una
  vez por la sesión.
- **La biblioteca de mods bajados** (L1-11) vive en la PC, que tiene disco: una carpeta por familia.
- **Cada combinación** es una instancia de Prism y un mundo propios; el server corre una a la vez.

## 3b. Lo que cambió al construirla (2026-11-25)

- **Sin packwiz.** `packwiz-installer` sólo borra lo que él mismo instaló: un jar puesto a mano queda en la
  instancia y L1-03 («igual al pack, por SHA-1») no se cumple. En su lugar, `tienda/sincronizar.ps1`
  (PowerShell 5.1, está en toda máquina con Windows): lee `lista.json` de la tienda, baja lo que falta o
  cambió con su SHA-1, y aparta lo que sobra a `mods_fuera_de_pack` (no borra). Prism lo corre como comando
  previo de la instancia «Tienda 1.21.1». Se evita además compilar packwiz con Go.
- **NeoForge propio, 21.1.267.** El server de prueba frenó la primera combinación porque Lootr pedía
  NeoForge ≥ 21.1.195 y Better MC 5 trae 21.1.176. La tienda tiene su NeoForge en
  `C:\Users\frans\MinecraftServer\tienda\neoforge` (libraries) y la instancia lo usa; Better MC 5 y su server
  siguen intactos.
- **20 jars de Better MC 5 no están en Modrinth** (son de CurseForge): se sirven desde la notebook
  (`/pack/archivos/`), sólo en la combinación Better MC 5. Uso en casa, no se republican.
- **El server de la tienda** (puerto 25568) se pone igual a lo publicado al prenderlo
  (`iniciar-server-tienda.bat` → `armar.py --server`), un mundo por combinación (`mundo-<combo>`).
- Twilight Forest no está en Modrinth: queda afuera. Undergarden es `the-undergarden` y Deeper and Darker
  `deeperdarker`.
- Lo que la sesión construyó y probó está en `tienda/` (ver `tienda/LEEME.md`).

## 4. Las combinaciones (a validar en la sesión de la tienda)

| Combinación | Qué es | Peso |
|---|---|---|
| **Aventura minecraftera** (la recomendada) | dungeons y estructuras de YUNG, Dungeons Arise y Taverns, pueblos y torres, Explorify, Structory; bichos de Friends & Foes; dimensiones Aether, Deeper and Darker, Undergarden, Bumblezone; jefes de Cataclysm, Mowzie's Mobs y Aquamirae; Nether y End renovados; mapas, Waystones, JEI, Jade | medio (~6 GB) |
| **Better MC 5 sin castigos** | el pack de otros, entero, sin Serene Seasons | pesado (8 GB) |
| **Dimensiones y jefes** | la aventura + Twilight Forest y Eternal Starlight | medio-pesado |
| **Con mecanismos** | la aventura + Create y sus agregados, Supplementaries y Quark (más complejo: opcional) | pesado |
| **Liviana** | YUNG, Friends & Foes, Lootr y rendimiento, para máquinas flojas | liviano (~4 GB) |

Lista de castigos (L1-10): Tough As Nails, Cold Sweat, Thermoo y sus derivados (Frostiful, Scorchful),
y los de sed. Las estaciones (Serene Seasons) quedan como un mod más, avisado en su descripción.

## 5. Cómo se prueba (V&V)

- **Sabotajes que nacen con la tienda**: una selección con Tough As Nails tiene que quedar bloqueada; una
  con un mod de otro cargador tiene que hacer fallar el server de prueba y no publicarse; una instancia con
  un mod de más tiene que quedar igual al pack después de abrir el juego (hash).
- **Validación**: Fran arma un combo desde la tienda, sin pedirle nada a la sesión, y él y Kevin juegan en
  el server de la notebook.

## 6. Kevin

Su notebook no está (Fran, 2026-11-24). Queda preparado un paquete como el de los amigos
(`paquete/instalar-juntada.ps1`): Prism con la instancia apuntando al pack de la notebook y los pasos de
ZeroTier. La red de ZeroTier y su clave no entran al repo (R-02).
