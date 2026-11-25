# PDP — juegos-casa: la biblioteca de juegos de la casa

**El PDP se escribe antes de la primera línea de trabajo y se corrige cuando la realidad lo contradice.**
Waterfall en las puertas, ágil adentro: cada fase cierra con un resultado verificable; adentro se itera
con spikes cortos sobre el sistema real.

---

## 1. El problema

**Antecedentes.** En casa hay dos máquinas: la notebook MSI de Fran (RTX 4060, 24 GB de RAM, **9 GB
libres** de disco) y la PC (RTX 3090, 15 GB de RAM, monitor 1440p, 106 GB libres), en la misma red y en
ZeroTier. Juegan Fran, su primo Kevin (en casa y desde la suya, con su notebook), su hermano y a veces
Agustín. Los juegos están repartidos entre `C:\Games`, Descargas, la cuarentena y el Escritorio, con
carpetas a medio armar en cada máquina, y cada juntada arranca buscando, instalando y configurando. La
regla de Fran para jugar de a dos (2026-11-20): cada uno en su pantalla; si el juego es de pantalla
dividida, buscar o hacer la versión de una pantalla por jugador; si no se puede, el juego va a la PC. La
investigación de antecedentes está en `docs/investigacion-2026-11-24.md`.

- **Necesidad:** las juntadas de juego en casa se van en buscar, instalar y configurar, en vez de jugar.
- **Meta 1:** que cualquier juego de la casa se encuentre y se arranque desde un solo lugar en cada máquina.
- **Meta 2:** que de a dos cada jugador juegue en su propia pantalla siempre que el juego lo permita.
- **Meta 3:** que la biblioteca crezca con clásicos de Sega, PS1 y PS2, originales y con mods o
  innovaciones, sin que cada juego nuevo cueste una sesión.
- **Objetivo 1 (meta 1):** que cada juego instalado en cada máquina aparezca en su índice, clasificado
  por modo de juego y por tipo.
- **Objetivo 2 (meta 2):** que Double Dragon II de Mega Drive se juegue de a dos, cada uno en su pantalla,
  arrancado en menos de 3 minutos.
- **Objetivo 3 (meta 2):** que cada juego de a dos tenga escrita su mejor forma de jugarse y su estado de
  prueba.
- **Objetivo 4 (meta 3):** que sumar un juego al catálogo actualice el índice de las dos máquinas con un
  comando.
- **Criterios de éxito.** Misión mínima: el índice en las dos máquinas y Double Dragon II jugado por Fran
  y Kevin cada uno en su pantalla. Misión completa: además, los espacios de Sega, PS1 y PS2 armados y
  cinco juegos de a dos probados cada uno en su pantalla.
- **Misión:** una biblioteca de juegos igual en las dos máquinas, que dice de cada juego cómo se juega de
  a dos y lo arranca.
- **Hipótesis:** las dos máquinas se ven por la red de la casa con menos de 5 ms (a medir en el spike);
  Kevin, desde su casa, entra por ZeroTier; las ROMs e ISOs que se juegan son copias de Fran; los
  emuladores en red se mantienen sincronizados si corren el mismo núcleo con el mismo archivo.
- **Restricciones:** `docs/10-requisitos.md` §3 (R-01 a R-05, con quién las impone).
- **Autoridad y responsabilidad:** Fran decide qué se juega, qué se compra, qué se borra y los pesos de
  cualquier elección de valor; la sesión decide lo técnico, lo hace y lo verifica; Kevin y el hermano
  juegan y dicen si sirvió.
- **ConOps.** (1) Fran y Kevin abren `Escritorio\Juegos\De a dos - cada uno en su pantalla` en
  cualquiera de las dos máquinas. (2) Cada juego dice cómo se juega y si está probado. (3) Doble clic en
  «ser anfitrión» en una máquina y en «unirse» en la otra; juegan. (4) No nominal: si la red falla, la
  ficha del juego dice el plan B (la PC con dos joysticks); si el archivo del juego difiere entre las dos
  máquinas, el lanzador lo dice antes de conectar. (5) Juego nuevo: entra al catálogo y un comando
  regenera los dos índices.

**Para quién es:** Fran, Kevin, el hermano; la sesión es quien lo mantiene.

**Cómo sabremos que sirvió (validación):** una juntada en la que Fran y Kevin eligen un juego de a dos y
están jugando, cada uno en su pantalla, antes de terminar un mate; y que en la siguiente nadie pregunte
«¿dónde estaba tal juego?».

## 2. Qué NO es

- **No baja ROMs ni ISOs de juegos comerciales** (R-01). Los emuladores sí: son gratuitos y oficiales.
- **No compra hardware** (R-03) ni juegos sin el sí de Fran (R-05).
- **No es Minecraft**: el pack nuevo, la tienda de mods y el server viven en `minecraft-amigos`.
- **No son las PS2 reales**: OPL y la red de las consolas viven en `ps2-casa`; los mods de Dragon Ball en
  `dbz-niveles`; la música del Sparking en `sparking-musica`; cómo se maneja la PC desde la notebook, en
  `pc-casa-control`; BLACK en `black`. Este proyecto los **enlaza** desde el índice, no los reescribe.
- **No toca el PCSX2 2.6.3** de la PC (R-04).
- **No es un servidor público**: la red de la casa y ZeroTier.

## 3. Naturaleza, y el rigor POR ASPECTO

| Campo | Valor |
|---|---|
| Naturaleza | `ingenieria` |

| Aspecto | Reversibilidad | Incertidumbre | Rigor | Por qué |
|---|---|---|---|---|
| `indice` (carpetas y accesos) | se rehace barato | requisitos conocidos | mínimo: directo | se regenera desde el catálogo |
| `emulacion` (emuladores y su configuración) | se rehace barato | desconocida (la red de a dos) | iterar corto y medir | cada emulador se prueba con un juego antes de sumar otro |
| `guardados` (partidas de la familia) | un solo tiro | conocidos | pleno: respaldo con MD5 antes de tocar | una partida pisada no vuelve (regla 2 de `pc-casa-control`) |
| `disco` (mover o borrar juegos) | un solo tiro | conocidos | pleno: copia verificada antes de borrar, y el sí de Fran | lo borrado no vuelve (R-02) |

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Cómo se certifica | Estado |
|---|---|---|---|---|
| 0 | Concepto — **Pre-Fase A** (estudio de conceptos), con el spike de Double Dragon II | (a) Fran acepta el concepto y los requisitos L0-L1 en la revisión de concepto (MCR); (b) Double Dragon II se jugó de a dos, cada uno en su pantalla, con L1-04, L1-05 y L1-15 medidos | (a) su sí, textual, en `docs/bitacora.md`; (b) el log de RetroArch de las dos máquinas (conexión, cuadros de demora) y el MD5 comparado, en `docs/spike-double-dragon.md` | abierta: **(a) cumplida** el 2026-11-25 (el sí de Fran, en `docs/bitacora.md`; requisitos v0.2 en línea base); falta (b), la demora de Double Dragon II en red |
| 1 | El índice — **Fase C/D** (armar y probar) | el índice de las dos máquinas sale del catálogo y `indice.py verificar` da 0 juegos detectados afuera del índice en cada una | `indice.py verificar` corrido por la sesión en cada máquina, y el mismo verificador en rojo con un juego sacado a propósito | **cerrada** el 2026-11-25: criterio cumplido a la mañana (note 45 juegos, PC 54; verde, y rojo con el sabotaje en las dos) y el sí de Fran en la MCR de la 0 a la tarde |
| 2 | Los espacios retro — **Fase C/D** | Sega, PS1 y PS2 en la PC; Mega Drive, Master System, Game Gear y PS1 en la notebook; 5 juegos de a dos con estado «probado» | catálogo + una prueba de red por juego | — |
| 3 | Pantalla dividida a dos pantallas — **spike** | un juego de pantalla dividida jugado con cada vista en su pantalla, o la fase cancelada con la medición que lo descarta | captura de las dos pantallas | — |

**Fase en curso:** 0 — Concepto (Pre-Fase A).

**Qué la cierra, exactamente:** las dos mitades: (a) el sí de Fran al concepto (§6) y a
`docs/10-requisitos.md` v0.1 o la versión que salga de sus cambios; (b) una partida de Double Dragon II
entre la notebook y la PC, con la conexión hecha, la demora en cuadros leída del indicador de RetroArch y
el MD5 de la ROM igual en las dos.

**Cómo se certifica:** (a) la frase de Fran copiada en la bitácora con la fecha; (b)
`docs/spike-double-dragon.md` con la predicción escrita **antes** de jugar y lo medido después. En rojo
se ve así: sin conexión, o con el MD5 distinto (el lanzador frena), o con la demora arriba de 2 cuadros.

**La fase también puede CANCELARSE:** si el spike muestra que la red de a dos no anda en la red de la
casa (por ejemplo, el Wi-Fi de la notebook), lo aprendido cambia el concepto: el juego de a dos pasa a
cable o a la PC con dos joysticks, y la fase 2 se reescribe.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| El disco de la notebook no alcanza (9 GB) | alta | alta | mitigar: lo pesado en la PC; liberar con las ISOs de PS2 que Fran aprobó pasar a la PC | menos de 15 GB libres en la notebook |
| La red de a dos se desincroniza | media | media | mitigar: mismo núcleo y misma ROM con MD5 comparado (L1-15) | «desync» en el log o los jugadores ven cosas distintas |
| El Wi-Fi de la notebook mete demora | media | media | mitigar: anfitrión en la PC (cable), retardo de 0-2 cuadros | indicador de RetroArch arriba de 2 cuadros |
| Kevin desde su casa no tiene su copia del juego | media | baja | aceptar: el paquete de Kevin lleva emulador y configuración, no ROMs | Kevin no puede abrir el juego |
| Se pisa un guardado de la familia | baja | alta | evitar: respaldo con MD5 antes de cambiar algo de un juego en uso; nada mientras juegan | MD5 del guardado distinto después del cambio |
| El repo público muestra de dónde salió cada juego | media | media | evitar: el catálogo del repo no lleva rutas ni sitios; las rutas por máquina van a un archivo ignorado | `git grep` de nombres de sitios en el catálogo |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-11-24 | La carpeta suelta `juegos-casa` (la del BlueStacks) se adopta como este proyecto | un proyecto nuevo con otro nombre | dos casas para lo mismo divergen; el BlueStacks es parte de la biblioteca |
| 2026-11-24 | **El índice son carpetas de accesos directos generadas desde un catálogo único**, igual en las dos máquinas | un frontend como único índice (Playnite, RetroBat, ES-DE, LaunchBox) | Fran pidió carpetas; un frontend por máquina tiene su base de datos propia y diverge |
| 2026-11-24 | **La vitrina del retro es RetroBat**, con un tema de cajas como el del video de Retro Rusty que mandó Fran; su RetroArch es el único de cada máquina y lo usan también los accesos del índice | ES-DE, Playnite, LaunchBox | es el frontend de la captura que eligió Fran (gusto: se le muestra primero); usa los nombres de carpeta de sistema (`megadrive`, `psx`, `ps2`) de los packs que él maneja; trae netplay con control de que los dos tengan la misma ROM por CRC; es gratis. Playnite queda como opción para los juegos de PC si las carpetas no alcanzan |
| 2026-11-24 | **Lo pesado vive en la PC; la notebook juega lo liviano en local y lo pesado por streaming** | duplicar la biblioteca en las dos máquinas | la notebook tiene 9 GB libres (medido); duplicar es imposible hoy y diverge mañana |
| 2026-11-24 | **La escalera de «cada uno en su pantalla»** (investigación §3) decide la forma de cada juego, de arriba hacia abajo | decidir juego por juego sin orden | sin orden se elige lo primero que anda, y la regla de Fran pide lo mejor que anda |
| 2026-11-24 | Double Dragon II: el de Mega Drive con la ROM de Fran, por RetroArch en red (Fran) | Double Dragon Trilogy de Steam (USD 3,59, Remote Play Together) | Fran eligió el de Genesis; la Trilogy queda de plan B |
| 2026-11-24 | Las seis ISOs de PS2 de la cuarentena de la notebook van a la PC; del God of War II queda el PAL en castellano; se borran de la notebook después de verificar la copia (Fran) | dejarlas en la notebook; guardar los dos God of War II | la notebook no tiene lugar; el NTSC es en inglés y pesa el doble |
| 2026-11-25 | **El índice abre antes de cerrar la fase 0**: Fran pidió «ordená bien todo en la carpeta de juegos» (y lo había pedido el 24); el criterio de la fase 1 se cumplió y se cierra con la MCR | esperar el sí al concepto para armarlo | el índice se regenera barato (rigor mínimo, §3): si el concepto cambia, se rearma en minutos |
| 2026-11-25 | **La forma del índice**: cinco carpetas numeradas (todos, de a dos, por modo, por tipo, por versión) más Minecraft destacado; un juego con varias formas de arrancar es una carpeta; los accesos viejos van al almacén `C:\Games\_indice\accesos\` y el índice los copia de ahí; no se tocan las carpetas con juegos instalados ni las de otros proyectos | un frontend; reescribir las carpetas viejas en el lugar; mover los juegos instalados a `C:\Games` | Fran pidió carpetas; mover un juego instalado rompe sus accesos y a veces sus partidas; el almacén deja deshacer con un comando |
| 2026-11-25 (tarde) | **La forma del índice cambia a pedido de Fran**: los juegos de PC sueltos en `Juegos\`, una carpeta por consola (Sega, PS2, PS3, Android), Minecraft con todo ordenado (servidores, tienda, otros launchers) y la clasificación entera en `Clasificados\`; cada juego con su carátula o el ícono del juego (`scripts/iconos.py`) | las cinco carpetas numeradas de la mañana | Fran: «otra manera quiero que estén todos los juegos sueltos los de PC, y que agrupes en carpetas Sega, PS2…» |
| 2026-11-25 (tarde) | **Las carpetas del índice abren solas en íconos grandes**: el generador escribe en cada una un `desktop.ini` con la plantilla Imágenes y la deja de solo lectura (medido en la note: sin él, Detalles; con él, íconos grandes, aun en una carpeta ya abierta) | que Fran ponga Ver > Íconos grandes en cada carpeta de cada máquina; fijar la vista con Shell.Application | a mano es carpeta por carpeta (más de 60) y se pierde al regenerar; Shell.Application pide la sesión interactiva y abre ventanas |
| 2026-11-25 | **El eje tipo pasa de 4 a 6 valores** (deportes y carreras, estrategia y puzzle) | meter PES 6 y Bloons en «acción» | con los cuatro de Fran L1-02 no se podía cumplir (`docs/10-requisitos.md` v0.2) |

## 7. Verificación

Cada requisito tiene su método en `docs/10-requisitos.md`. De cada verificación se registra qué versión
de qué se verificó (emulador, núcleo, ROM con MD5), en qué difiere de la juntada real y qué limita el
resultado. **El verificador del índice (`indice.py verificar`) nace con su sabotaje**: se saca un juego
del índice a propósito y tiene que dar rojo nombrándolo.

## 8. Matriz de cumplimiento

| Regla | Aspecto | Estado | Justificación |
|---|---|---|---|
| `plantillas/naturalezas/ingenieria.md` §Riesgo (respaldo antes de intervenir) | `guardados` | `cumple` | |
| `plantillas/naturalezas/ingenieria.md` §Riesgo (respaldo antes de intervenir) | `disco` | `cumple` | |
| `nucleo-ise.md` §4 (requisitos con libros abiertos) | todos | `cumple` | |
