# Requisitos — fase 2: el pack nuevo y la tienda de mods

**Versión 0.3, 27 de noviembre de 2026** (0.1 del 24; la 0.2 suma L1-18 y L1-19 por el pedido de Fran del 25; la
0.3 suma la versión del mundo con Agus —N-09, L0-09 y L1-20— y acota L1-01, con el sí de Fran del 27).
Estado: **borrador**; entra en línea base con el sí de Fran (en la sesión del 2026-11-24 aprobó la forma: «sí, así,
quiero que sea sencillo y que esté probado»).

Escrito con los libros abiertos: `perfil-global/pilares/nucleo-ise.md` §4, el INCOSE GtWR, la cátedra de
IISE (M17 y M21) y NASA (`nasa-seh/requisitos.md` §4-14, App. C). Se mide con
`python perfil-global/pilares/incose-gtwr/verificar-requisito.py <enunciados> --idioma es`. El diseño que
los cumple: [`fase-2-tienda.md`](fase-2-tienda.md).

## 1. Glosario

| Término | Qué es |
|---|---|
| **sistema** | el server, la tienda, el pack y las instancias de Prism de cada máquina |
| **pack** | la lista única de mods publicada, con el archivo y el hash de cada uno |
| **tienda** | la página local donde Fran tilda mods y combinaciones y confirma |
| **selección** | el conjunto de mods que Fran confirma en la tienda |
| **combinación** | una selección armada de antemano, con nombre y descripción |
| **familia de contenido** | dimensiones, estructuras, animales, mecanismos, dungeons, minerales y jefes |
| **subfamilia** | un grupo de mods dentro de una familia de contenido (por ejemplo, en animales: bichos nuevos, los de siempre renovados, mascotas y monturas, conejos) |
| **lista de castigos** | los mods de temperatura y de sed (Tough As Nails, Cold Sweat, Thermoo y sus derivados) |
| **instancia** | la instalación de Minecraft con mods de una máquina, en Prism Launcher |
| **server de prueba** | un server efímero que arranca la selección antes de publicarla |
| **versión principal** | las selecciones de Minecraft 1.21.1 de la tienda (las de L0-06) |
| **versión del mundo con Agus** | las selecciones de Minecraft 1.21.4 de la tienda (las de L0-09) |

## 2. Necesidades de Fran

| ID | Expectativa |
|---|---|
| N-01 | Jugar Minecraft con mods con Kevin y los amigos, en casa y a distancia. |
| N-02 | Elegir los mods él mismo, tildando como en un carrito, sin pedirle a una sesión que arme la instancia. |
| N-03 | Mods con contenido al estilo de Minecraft: dimensiones, estructuras, animales, mecanismos, dungeons, minerales más fuertes y jefes, sin ser súper complejos. |
| N-04 | Nada de sistemas que castiguen el juego, como el frío y el calor. |
| N-05 | Varias combinaciones de mods, cada una con su descripción. |
| N-06 | La versión más nueva entre las que tienen más mods. |
| N-07 | Que sea sencillo y que esté probado. |
| N-08 | El server en la notebook, que tiene más memoria. |
| N-09 | Elegir también los mods del mundo 1.21.4 que Fran juega con Agus. |

## 3. Restricciones

| ID | Restricción | Quién la impone |
|---|---|---|
| R-01 | La cuenta offline de Prism la resuelve cada jugador. | Fran (regla 2 del contrato) |
| R-02 | La clave de RCON, la red de ZeroTier y sus miembros no entran al repo, que es público. | Fran (regla 1 del contrato) |
| R-03 | La notebook de Kevin no está a mano: su instalación se deja preparada. | Fran, 2026-11-24 |

## 4. Nivel 0

| ID | Padre | Requisito | Tipo | Verificación |
|---|---|---|---|---|
| L0-01 | N-01 | El sistema deberá permitir que Fran, Kevin y los amigos jueguen un mundo compartido con mods desde la casa y desde afuera. | funcional | demostración |
| L0-02 | N-02 | El sistema deberá armar la instancia de cada máquina a partir de la selección de Fran. | funcional | demostración |
| L0-03 | N-03 | El sistema deberá ofrecer mods de cada familia de contenido. | funcional | inspección |
| L0-04 | N-04 | El sistema deberá excluir de cada selección los mods de la lista de castigos. | funcional | ensayo |
| L0-05 | N-05 | El sistema deberá presentar combinaciones de mods con una descripción de cada combinación. | funcional | inspección |
| L0-06 | N-06 | El sistema deberá correr en la versión de Minecraft más nueva entre las versiones con mayor cantidad de mods publicados. | restricción | análisis |
| L0-07 | N-07 | El sistema deberá probar cada selección antes de entregarla a los jugadores. | funcional | ensayo |
| L0-08 | N-08 | El sistema deberá alojar el server en la máquina de la casa con más memoria. | restricción | inspección |
| L0-09 | N-09 | El sistema deberá ofrecer selecciones de mods para Minecraft 1.21.4. | funcional | demostración |

## 5. Nivel 1

| ID | Padre | Requisito | Tipo | Verificación |
|---|---|---|---|---|
| L1-01 | L0-06 | En la versión principal, el sistema deberá usar Minecraft 1.21.1 con el cargador NeoForge. | restricción | inspección |
| L1-20 | L0-09 | En la versión del mundo con Agus, el sistema deberá usar Minecraft 1.21.4 con el cargador Fabric. | restricción | inspección |
| L1-02 | L0-02 | Cuando Fran confirma una selección en la tienda, el sistema deberá publicar el pack dentro de los 300 s posteriores a la confirmación. | desempeño | ensayo (cronómetro) |
| L1-03 | L0-02 | Al abrir el juego, la instancia de cada máquina deberá igualar la lista de mods del pack, comparada por hash SHA-1. | funcional | ensayo |
| L1-04 | L0-02 | El sistema deberá sincronizar la instancia de la notebook de Fran, la instancia de la PC y la instancia de Kevin con el pack. | interfaz | demostración |
| L1-05 | L0-07 | Antes de publicar una selección, el sistema deberá arrancar el server de prueba con la selección. | funcional | ensayo |
| L1-06 | L0-07 | El sistema deberá publicar una selección únicamente después de que el server de prueba complete el arranque. | funcional | ensayo (sabotaje: una selección rota no se publica) |
| L1-07 | L0-03 | La tienda deberá mostrar para cada mod el nombre, una imagen, una descripción en castellano, la familia de contenido y el peso en memoria. | funcional | inspección |
| L1-18 | L0-03 | La tienda deberá ubicar cada mod en una subfamilia de su familia de contenido. | funcional | inspección (script) |
| L1-19 | L0-03 | La tienda deberá ofrecer para cada mod un desplegable con entre 2 y 3 fotos del mod. | funcional | inspección (script) |
| L1-08 | L0-05 | La tienda deberá ofrecer entre 4 y 8 combinaciones de mods. | funcional | inspección |
| L1-09 | L0-05 | La tienda deberá mostrar para cada combinación una descripción, la cantidad de mods y la memoria recomendada. | funcional | inspección |
| L1-10 | L0-04 | El sistema deberá bloquear la publicación de una selección que contenga un mod de la lista de castigos. | funcional | ensayo (sabotaje: Tough As Nails) |
| L1-11 | L0-03 | El sistema deberá guardar en la PC una copia de cada archivo de mod del catálogo, ordenada por familia de contenido. | funcional | inspección |
| L1-12 | L0-01 | El server deberá aceptar conexiones desde la red de la casa. | interfaz | demostración |
| L1-13 | L0-01 | El server deberá aceptar conexiones desde ZeroTier. | interfaz | demostración |
| L1-14 | L0-01 | Con dos jugadores conectados, el server deberá sostener entre 18 y 20 ticks por segundo medidos con spark. | desempeño | ensayo |
| L1-15 | L0-01 | El cliente de la combinación más pesada deberá llegar al menú principal con 8 GB de memoria asignada. | desempeño | ensayo |
| L1-16 | L0-08 | El sistema deberá alojar el server en la notebook de Fran. | restricción | inspección |
| L1-17 | L0-02 | El sistema deberá dejar listo un paquete de instalación para la notebook de Kevin. | funcional | inspección |

## 6. Rationale

- **L1-01 (1.21.1 con NeoForge).** Medido en la API de Modrinth el 2026-11-24 (`fase-2-tienda.md` §1):
  1.20.1 tiene 35 652 mods, 1.21.1 33 826, 1.21.11 20 723, 26.1.2 16 514, 26.2 15 469 y 26.3 (la última,
  2026-09-15) 11 567. **1.21.1 es la más nueva con menos de 6 % de diferencia contra el máximo**, y un año
  más nueva que 1.20.1. NeoForge porque en 1.21.1 tiene más mods que Fabric (22 827 contra 20 558) y lleva
  los de contenido grande (Aether, Cataclysm, Mowzie's Mobs, Undergarden, Bumblezone, Dungeons Arise).
  Lo que se pierde: los que quedaron en 1.20.1 (Alex's Mobs, Alex's Caves, Blue Skies). Es el resultado
  de un trade cerrado: por eso el L1 fija la implementación (SEH p. 60).
- **N-09, L0-09 y L1-20 (la versión del mundo con Agus).** Pedido de Fran del 2026-11-27, textual: «Prepara la
  tienda para ambas versiones y todo», sobre «nuestro server nuevo 1.21.4». El mundo con Agus ya existe en Fabric
  1.21.4 (100 mods, `pack/manifiesto.json`): la versión y el cargador los impone ese mundo, no un trade, y por eso
  L1-20 los fija (SEH p. 60; GtWR R31, restricción del interesado). Lo que se pierde, medido en Modrinth el mismo
  día: en Fabric 1.21.4 no hay mods de naves ni de planetas; esos siguen en la versión principal. El resto de los
  L1 (prueba antes de publicar, castigos, cartas, combinaciones) rige igual para las dos versiones.
- **L1-02, 300 s.** TBR: incluye el arranque del server de prueba (el de 1.21.4 tardó 10,9 s con 62 mods;
  con 270 mods se estima un orden más). Se mide en la sesión de la tienda.
- **L1-06 y L1-10** son lo «probado» de N-07: la tienda no puede publicar lo que no arranca ni lo que trae
  un castigo. Cada uno nace con su sabotaje.
- **L1-14, 18 a 20 TPS.** 20 es el máximo del juego; 18 deja el margen que spark muestra sin que se note.
- **L1-15, 8 GB.** La recomendación del pack más pesado (Better MC 5); la PC tiene 15 GB y la notebook
  24 GB con el server adentro.
- **L1-16** baja L0-08 con el dato medido: notebook 23,8 GB, PC 15,3 GB.
- **L1-18 y L1-19** son el pedido de Fran del 2026-11-25, textual: «quiero que agregues muchos mods mas, y los
  organices con desplegables en cada uno con 2 o 3 imagenes iconicas del mismo. Me gusto como sectorizaste, pero al
  agregar mas debes sub sectorizar inteligente, y simplemente. Agrega mods de conejos tmb.» Las fotos salen de la
  galería que el autor eligió en Modrinth; si tiene menos de 2, de las imágenes de la página del mod. Un mod sin
  imágenes publicadas incumple L1-19: `tienda/verificar_cartas.py` lo nombra, y se resuelve con otra fuente o
  sacando la carta, nunca con una foto inventada.
