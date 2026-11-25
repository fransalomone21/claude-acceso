# Requisitos — borrador de la fase 0

**Versión 0.2, 25 de noviembre de 2026** (0.1 del 24: nivel 0 y 1; la 0.2 suma el eje tipo completo y el
nivel 2 del índice). Estado: **línea base** desde el 25 de noviembre de 2026: Fran la aceptó en la revisión de
concepto (MCR) de la fase 0 (`../PDP.md` §4; su frase, en `bitacora.md`). Un cambio desde acá sube la versión.

Escrito con los libros abiertos: `perfil-global/pilares/nucleo-ise.md` §4, el INCOSE GtWR
(`incose-gtwr/reglas.md`), la cátedra de IISE (M17 y M21) y NASA (`nasa-seh/requisitos.md` §4-14 y el
App. C del glosario). La redacción se mide con
`python perfil-global/pilares/incose-gtwr/verificar-requisito.py <enunciados> --idioma es`.

## 0. En criollo

Este es el papel que define el proyecto: lo que **Fran necesita** (N), lo que **no se discute** (R), lo
que **la biblioteca tiene que lograr** (L0, sin números) y **cuán bien** (L1, con números). Lo que se
instale, las carpetas y los scripts son *salidas*: se comparan contra esta lista, nunca al revés.

## 1. Glosario (R4, R36: un término, un significado)

| Término | Qué es |
|---|---|
| **biblioteca** | el sistema de este proyecto: el índice, el entorno de juego y los lanzadores de las dos máquinas |
| **máquina** | la notebook MSI de Fran o la PC de casa (PCFRAN) |
| **índice** | el árbol de carpetas con accesos directos de una máquina (`Escritorio\Juegos\`) |
| **catálogo** | la lista única de juegos con su clasificación, de la que sale el índice de las dos máquinas |
| **inventario** | lo que un script mide en el disco de una máquina: qué juegos hay y dónde |
| **ejes de clasificación** | modo (un jugador, dos jugadores, cooperativo, pantalla dividida, cada uno en su pantalla) y tipo (acción, construcción, mundo libre, historia, deportes y carreras, estrategia y puzzle) |
| **modo dos jugadores** | dos personas en la misma máquina y la misma pantalla, en contra o juntas |
| **modo cooperativo** | dos personas del mismo lado contra el juego, en cualquier modo de pantalla |
| **lanzador** | el acceso directo que arranca un juego en una forma (solo, ser anfitrión, unirse, los dos en esta máquina) |
| **generador** | el script que arma el índice de una máquina desde el catálogo y el inventario |
| **carpeta de deshacer** | `C:\Games\_indice\accesos\` de cada máquina: los accesos del índice viejo, movidos sin borrar y con su ruta de origen; el generador los copia de ahí al índice |
| **versión** | original, con mods, o innovación (remake de fans, port nativo, pack de texturas) |
| **juego de red** | un juego de a dos que se juega con una máquina por jugador |
| **estado de prueba** | probado (se jugó de a dos y se vio), probable (fuentes coinciden), sin probar |
| **la red de la casa** | el router de casa; **ZeroTier** es la red virtual que ya usan las dos máquinas |

## 2. Necesidades de Fran (en su idioma; todavía no verificables)

La necesidad del proyecto es una sola y está en `../PDP.md` §1. Estas son las expectativas que salen de
ella, con su ID para trazar.

| ID | Expectativa |
|---|---|
| N-01 | Encontrar cada juego de cada máquina en una carpeta, clasificado por cómo se juega y por de qué se trata. |
| N-02 | Jugar de a dos con cada jugador en su propia pantalla cuando el juego lo permite, en casa y con Kevin desde la suya. |
| N-03 | Tener clásicos de Sega, de PlayStation y de PlayStation 2, originales y con mods o innovaciones. |
| N-04 | Que preparar un juego de a dos no se coma la juntada. |
| N-05 | Saber, de cada juego de a dos, cómo se juega y si ya se probó. |

## 3. Restricciones (las impone alguien de afuera; un trade no las cambia)

| ID | Restricción | Quién la impone |
|---|---|---|
| R-01 | La sesión no descarga ROMs ni ISOs de juegos comerciales: las copias las aporta Fran. | el derecho de autor y las reglas de la sesión |
| R-02 | Nada se borra sin el sí explícito de Fran; los juegos instalados y las fotos se quedan. | Fran (memoria `orden-pc-notebook-2026-11`) |
| R-03 | Las máquinas son las dos que hay; no se compra hardware. | Fran |
| R-04 | El PCSX2 2.6.3 de `C:\Program Files\PCSX2` de la PC queda intacto. | el proyecto BLACK |
| R-05 | Cada gasto en un juego lleva el sí de Fran, juego por juego. | Fran |

## 4. Nivel 0 — qué tiene que lograr la biblioteca (sin números)

| ID | Padre | Requisito | Tipo | Verificación |
|---|---|---|---|---|
| L0-01 | N-01 | La biblioteca deberá presentar en el índice de cada máquina cada juego instalado en la máquina, clasificado según los ejes de clasificación. | funcional | inspección |
| L0-02 | N-02 | La biblioteca deberá permitir que cada juego de red se juegue de a dos con un jugador en cada máquina. | funcional | demostración |
| L0-03 | N-03 | La biblioteca deberá incluir juegos de Sega, de PlayStation y de PlayStation 2 en cada versión del glosario. | funcional | inspección |
| L0-04 | N-04 | La biblioteca deberá dejar cada juego de a dos listo para arrancar en las dos máquinas. | funcional | demostración |
| L0-05 | N-05 | La biblioteca deberá informar la forma de juego de cada juego de a dos. | funcional | inspección |
| L0-06 | R-01 | La biblioteca deberá obtener cada ROM e ISO de una copia aportada por Fran. | restricción | inspección |
| L0-07 | N-05 | La biblioteca deberá informar el estado de prueba de cada juego de a dos. | funcional | inspección |

**Rationale del nivel 0.** L0-02 dice «juego de red» y no «todo juego de a dos»: la regla de Fran
(2026-11-20) acepta que un juego que sólo admite pantalla compartida vaya a la PC; ese caso es L1-13.
L0-06 baja la restricción R-01 al sistema, para que tenga método de verificación.

## 5. Nivel 1 — qué tiene que hacer y cuán bien (con números)

| ID | Padre | Requisito | Tipo | Verificación |
|---|---|---|---|---|
| L1-01 | L0-01 | El índice de cada máquina deberá listar cada juego que el inventario de esa máquina detecta, con 0 juegos detectados afuera del índice. | desempeño | inspección (script) |
| L1-02 | L0-01 | El índice deberá ubicar cada juego en al menos una carpeta de cada eje de clasificación. | funcional | inspección (script) |
| L1-03 | L0-04 | El índice deberá arrancar cada juego con un doble clic sobre el acceso directo del juego. | funcional | demostración |
| L1-04 | L0-02 | Cuando los dos jugadores arrancan un juego de red por la red de la casa, la biblioteca deberá conectar las dos máquinas dentro de los 180 s posteriores al primer doble clic. | desempeño | ensayo (cronómetro) |
| L1-05 | L0-02 | Durante una partida de red por la red de la casa, la biblioteca deberá mantener la demora de entrada entre 0 y 2 cuadros. | desempeño | ensayo (indicador del emulador) |
| L1-06 | L0-02 | La biblioteca deberá conectar por ZeroTier una máquina de la casa con la máquina de Kevin. | interfaz | demostración |
| L1-07 | L0-05 | El índice deberá mostrar para cada juego de a dos un paso a paso de arranque de entre 1 y 5 pasos. | funcional | inspección |
| L1-08 | L0-07 | El catálogo deberá registrar el estado de prueba de cada juego de a dos. | funcional | inspección (script) |
| L1-09 | L0-03 | La biblioteca deberá emular Mega Drive, Master System, Game Gear, Sega CD, Saturn, Dreamcast, PlayStation y PlayStation 2 en la PC. | funcional | demostración |
| L1-10 | L0-03 | La biblioteca deberá emular Mega Drive, Master System, Game Gear y PlayStation en la notebook. | funcional | demostración |
| L1-11 | L0-03 | El índice deberá ubicar cada juego en la carpeta de la versión del juego. | funcional | inspección (script) |
| L1-12 | L0-04 | Cuando cambia el catálogo, la biblioteca deberá regenerar el índice de las dos máquinas con un comando. | funcional | demostración |
| L1-13 | L0-04 | Cuando un juego de a dos admite sólo pantalla compartida, el índice deberá arrancarlo en la PC con dos joysticks. | funcional | demostración |
| L1-14 | L0-06 | El inventario deberá registrar la suma MD5 de cada ROM e ISO. | restricción | inspección |
| L1-15 | L0-02 | Antes de cada partida de red, la biblioteca deberá comparar la suma MD5 del archivo del juego entre las dos máquinas. | funcional | ensayo (sabotaje: una ROM distinta da rojo) |
| L1-16 | L0-06 | El inventario deberá registrar el origen de cada ROM e ISO declarado por Fran. | restricción | inspección |

**Rationale del nivel 1.**

- **L1-01 y L1-02** son el «se mide, no se lee»: un script compara el inventario del disco contra el
  índice; un juego que se instala a mano aparece como faltante en vez de perderse (lección 19).
- **L1-04, 180 s**: TBR. Es la mejor estimación de «no se come la juntada» (N-04) para el caso de
  Double Dragon II (dos dobles clics y la conexión de RetroArch); se resuelve midiéndolo en el spike de la
  fase 0. Dueño: la sesión del spike.
- **L1-05, 2 cuadros**: TBR. La guía de netplay de libretro deja el retardo en 0 por LAN y la de 2026 da
  0-1 cuadros para la misma ciudad (investigación §2); 2 deja margen al Wi-Fi de la notebook. Se resuelve
  en el spike.
- **L1-09 y L1-10** se parten por máquina porque el disco de la notebook (9 GB libres, medido) no banca
  PS2 ni Dreamcast; lo pesado se juega en la PC o por streaming desde la PC (concepto, `../PDP.md` §6).
- **L1-13** es la regla de Fran tal cual: si no se puede cada uno en su pantalla, el juego va a la PC.
- **L1-15** es derivado: RetroArch y PCSX2 desincronizan si las dos máquinas no tienen exactamente el
  mismo archivo (investigación §2); comprobarlo antes ahorra la partida rota.

## 5b. Nivel 2 — el índice (fase 1, 2026-11-25)

Los elementos del segmento índice: el **catálogo** (CAT, en el repo), el **inventario** (INV, uno por máquina),
el **generador** (GEN) y el **verificador** (VER). Escritos al abrir la fase 1, con el inventario de las dos
máquinas ya medido (`scripts/inventario.ps1`).

| ID | Padre | Requisito | Tipo | Verificación |
|---|---|---|---|---|
| L2-INV-01 | L1-01 | El inventario deberá detectar en cada máquina los juegos de Steam, de Epic Games, de las carpetas de juegos, de RetroArch, de PlayStation 2 y de RPCS3. | funcional | ensayo |
| L2-INV-02 | L1-14 | El inventario deberá registrar la suma MD5 de cada ROM y de cada ISO de más de 100 MB. | funcional | inspección |
| L2-CAT-01 | L1-02 | El catálogo deberá asignar a cada juego entre 1 y 3 valores de modo y entre 1 y 2 valores de tipo. | funcional | inspección (script) |
| L2-GEN-01 | L1-12 | El generador deberá construir el índice de una máquina a partir del catálogo y del inventario de esa máquina. | funcional | demostración |
| L2-GEN-02 | L1-02 | El generador deberá crear en el índice una carpeta por cada valor de cada eje de clasificación presente en la máquina. | funcional | inspección (script) |
| L2-GEN-03 | R-02 | Cuando el generador reemplaza un acceso directo del índice viejo, el generador deberá mover el acceso directo reemplazado a la carpeta de deshacer. | restricción | inspección |
| L2-GEN-04 | R-02 | Cuando el generador mueve un acceso directo a la carpeta de deshacer, el generador deberá anotar el origen y el destino del acceso directo en la planilla del movimiento. | restricción | inspección |
| L2-VER-01 | L1-01 | El verificador deberá nombrar cada juego que el inventario detecta y el índice de la máquina omite. | funcional | ensayo (sabotaje: un juego sacado del índice da rojo con su nombre) |

**Rationale del nivel 2.**

- **L2-GEN-01 fija la implementación** a propósito: es el resultado de la decisión del 2026-11-24 (`../PDP.md`
  §6, «carpetas de accesos generadas desde un catálogo único»), y un índice armado a mano es el que diverge
  entre las dos máquinas (SEH p. 60: el porqué de limitar la solución va en el rationale).
- **L2-CAT-01, 1 a 3 modos y 1 a 2 tipos**: un juego sin modo o sin tipo no aparece en su eje (L1-02); más de
  tres modos o dos tipos llena todas las carpetas con el mismo juego y la clasificación deja de separar.
- **El eje tipo creció de 4 a 6 valores** (2026-11-25): con los cuatro de Fran (acción, construcción, mundo
  libre, historia) PES 6 y Bloons TD no entraban en ninguna carpeta, y L1-02 no se podía cumplir. Se agregan
  «deportes y carreras» y «estrategia y puzzle»; los cuatro de Fran quedan como estaban.
- **L2-GEN-03 y L2-GEN-04** bajan R-02: el índice viejo son accesos que Fran usa; reemplazarlos sin dejar el
  original y su planilla es borrar.
- **L2-INV-02, 100 MB**: las ISO de PS2 pesan más de 1 GB; lo que queda por debajo en esas carpetas son
  archivos sueltos de un ISO extraído (medido en la PC: los datos de BLACK), no juegos.

## 6. Qué queda para después

El nivel 2 del entorno de emulación y de la red de a dos se escribe al abrir la fase 2, con lo que midió el
spike. Y los requisitos del Minecraft no van acá: viven en `minecraft-amigos/docs/10-requisitos.md`.
