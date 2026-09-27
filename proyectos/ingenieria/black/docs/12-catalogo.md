<!-- GENERADO por herramientas/programa.py catalogo desde kb/conceptos.json y kb/subsistemas.json. NO SE EDITA A MANO: programa.py verificar lo compara. -->

# Catalogo de conceptos — Pre-Fase A del programa BLACK

La columna **K min** es la madurez del habilitador MAS FLOJO (escala en `kb/subsistemas.json`): es el riesgo tecnico del concepto, calculado, no opinado.

Costo: **S** 1-2 sesiones, **M** 3-6, **L** 7-15, **XL** mas de 15.


## multijugador

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| M1 | Coop local, pantalla compartida | segundo jugador en el mismo nivel y la misma pantalla | N1 | XL | pnach-codigo | K2 (hud) | camara sin ubicar; el array de jugadores no tiene lugar (bitacora 61) | candidato |
| M2 | Coop con pantalla dividida | cada jugador con su vista | N1 | XL | pnach-codigo | K4 (personajes) | dos vistas cuestan el doble de GS/EE; render K1 | candidato |
| M3 | El segundo mando maneja a un companero de escuadra | el jugador 2 toma a Tom o a Matt, que ya existen como actores | N1 | L | pnach-codigo | K3 (ia) | los companeros no estan en todos los niveles; hay que desenchufar su IA (8a) | candidato |
| M4 | Coop asimetrico: el segundo como apoyo | marca objetivos, pide municion o controla una vista de apoyo | N1, N3 | L | pnach-codigo | K2 (comandos-ui) | diseno de juego nuevo, no solo tecnica | candidato |
| M5 | Versus 1 contra 1 | dos jugadores enfrentados en un nivel o arena | N1, N4 | XL | pnach-codigo | K4 (personajes) | necesita M1 o M2 mas dano entre jugadores y reaparicion | candidato |
| M6 | Coop a distancia con Parsec o Remote Play | un amigo se conecta al coop local desde su casa | N1 | S | externo | K5 (entrada) | latencia; depende de que exista M1, M2 o M3 | candidato |
| M7 | Puntaje por turnos | dos jugadores se turnan la misma mision y compiten por puntos | N1, N3 | S | pine | K2 (estadisticas) | poco: no toca el juego | candidato |
| X2 | Online nativo del emulador | descartado | N1 | XL | emulador | — | PCSX2 2.8 no trae netplay; M6 cubre la necesidad sin tocar nada | descartado |

## desafio

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| D1 | Perfil 'Black Ops+' | dano de la IA, vida, regeneracion y botiquines ajustados como un preset | N2 | M | datos-iso | K2 (pickups) | vida maxima y regeneracion son hipotesis (K2) | candidato |
| D2 | Punteria de la IA | Max Spread Angle y Accuracy Fall Off del bloque AIParams de cada arma | N2 | S | datos-iso | K6 (armas) | el offset de esos campos se deriva del esquema; falta el efecto | candidato |
| D3 | Percepcion de la IA | ver antes y oir mas | N2 | L | datos-iso | K3 (ia) | depende de 8a: no se sabe que codigo piensa por el enemigo | candidato |
| D4 | Mas enemigos, y otros tipos, por nivel | editar las unidades de StLevel | N2, N3 | M | datos-iso | K4 (iso-niveles) | el pool tiene 32 lugares; E5 sin probar por efecto | candidato |
| D5 | Enemigos mas duros | multiplicadores de dano por zona de impacto | N2 | S | pnach-datos | K6 (armas) | bajo: zona*100 confirmado (4b) | candidato |
| D6 | Municion escasa | cargadores (Num Bullets In Clip) y cuanto dan los pickups | N2 | S | datos-iso | K2 (pickups) | los pickups estan en K2 | candidato |
| D7 | Modo hardcore | sin HUD ni reticula, sin auto-apuntado, sin regeneracion | N2, N3 | M | pnach-codigo | K2 (comandos-ui) | HUD en K2 | candidato |
| D8 | Sin checkpoints | morir reinicia la mision | N2 | M | pnach-codigo | K2 (guardado) | checkpoints sin ubicar | candidato |
| D9 | Director de dificultad | el juego ajusta la presion segun como te va (prototipo desde afuera por PINE) | N2, N3 | L | pine | K2 (estadisticas) | latencia de PINE; necesita poder hacer aparecer enemigos | candidato |

## jugabilidad

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| J1 | Rebalanceo de armas del jugador | PlayerParams: cadencia, rafaga, dispersion, cargador, rebote, alcance | N3 | S | datos-iso | K6 (armas) | el dano de salida no usa Power (4b): hay que medir que campos gobiernan al jugador | candidato |
| J2 | Armas nuevas por combinacion | clonar registros y cambiar proyectil, impacto y modelo | N3, N4 | M | datos-iso | K2 (iso-globdata) | el directorio tiene 17 entradas fijas | candidato |
| J3 | Arsenal distinto por nivel | habilitar armas que el nivel trae y no usa (en LEVEL_00 sobran 9) | N3 | S | datos-iso | K4 (iso-niveles) | bajo: L1 editable en frio; falta el efecto | candidato |
| J4 | Fisica y destruccion exageradas | impulsos de Collision.cfg en la ValueDB | N3 | S | pnach-datos | K3 (valuedb) | RESUELTO en frio 2026-09-27 (bitacora (73)): el valor sale de Data/Andy.aku (herramientas/valuedb_aku.py). Medido: Collision Heavy/Medium/Light Object Max Weight = 6000/200/1, Max Impulse = 100/5/1. OJO: esos son los del .cfg de SONIDO de colision; los impulsos de la fisica pueden ser otra tabla. Falta el efecto (notebook) | candidato |
| J5 | Camara lenta | escala de tiempo global, por ejemplo al matar | N3 | M | pnach-codigo | K2 (tiempo) | el reloj no esta ubicado (K0) | candidato |
| J6 | Movimiento | velocidad, carrera, salto | N3 | M | pnach-datos | K5 (juego) | campos del jugador sin nombre para esto | candidato |
| J7 | Randomizer | enemigos, armas y pickups distintos cada partida | N3 | L | datos-iso | K2 (pickups) | depende de que D4 ande por efecto | candidato |
| J8 | Horda o supervivencia | oleadas en una zona de un nivel existente | N3, N4 | XL | pnach-codigo | K3 (flujo) | aparicion en runtime sin ubicar | candidato |
| J9 | Todo desbloqueado y nueva partida+ | armas plateadas, municion infinita, todos los niveles | N3 | S | pnach-datos | K2 (guardado) | banderas de desbloqueo sin ubicar | candidato |
| J10 | Companeros distintos | mortales, o mas utiles en combate | N2, N3 | M | pnach-datos | K3 (ia) | hoy tienen vida FLT_MAX; su IA en K2 | candidato |

## niveles

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| L1 | Remezcla de niveles | mover apariciones, pickups y objetivos dentro de niveles existentes | N3, N4 | L | datos-iso | K2 (pickups) | colocacion y objetivos sin mapear | candidato |
| L2 | Noche, niebla o clima | otra atmosfera sobre el mismo nivel | N3, N5 | L | datos-iso | K4 (iso-niveles) | luces y niebla sin ubicar (LevelDat es candidato) | candidato |
| L3 | Nivel nuevo | geometria propia jugable de punta a punta | N4 | XL | datos-iso | K4 (fisica) | colocacion de submallas, colision y reconstruir el ISO | candidato |
| L4 | Arenas recortadas | una zona chica de un nivel existente para horda o versus | N4 | L | datos-iso | K3 (flujo) | limites y puntos de aparicion | candidato |
| L5 | Selector de mision y checkpoint | entrar directo a cualquier tramo: para jugar y para probar mods | N3, N7 | S | pnach-datos | K3 (flujo) | nivel y stage son dos bytes de una global (bitacora 30) | candidato |

## graficos

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| G1 | Resolucion interna y pack HD | hecho: renderer, escala y pack del ~93 % | N5 | S | emulador | K6 (emu-imagen) | T4 (costo en FPS) abierta | hecho |
| G2 | Pipeline DLSS5/ReShade | R2 abierta: instalado y corriendo | N5 | M | emulador | K6 (emu-imagen) | techo de la notebook (1080p) | candidato |
| G3 | Pantalla ancha y FOV | parche 16:9 de la comunidad ya en el menu; FOV propio | N5, N6 | S | pnach-datos | K5 (camara) | FOV propio depende de la camara (K0) | candidato |
| G4 | 60 FPS | parche de la comunidad ya en el menu (pide EE al 180 %) | N5, N6 | S | pnach-datos | K6 (emu-imagen) | falta medirlo jugando (J1) | hecho |
| G5 | Mas distancia de detalle | subir las distancias de LOD 30/60/100 del header de cada modelo | N5 | S | datos-iso | K4 (iso-niveles) | costo en GS; falta el efecto | candidato |
| G6 | HUD moderno o minimalista | rediseno de la interfaz, que es DATOS en /EXPORT/FRONTEND | N5, N3 | L | datos-iso | K1 (frontend-datos) | formato de la UI sin leer (K1) | candidato |
| G7 | Modo foto o camara libre | pausar y mover la camara | N5 | M | pine | K2 (tiempo) | camara K0; sirve de paso a M1 y M2 | candidato |
| G8 | Filtro de color del juego | los parametros de tinte que dejan ver 'Tint channel' y 'Percentage Black Mode' | N5 | S | pnach-datos | K2 (estadisticas) | hipotesis por cadenas: puede ser debug | candidato |
| X1 | Trazado de rayos con RTX Remix | descartado | N5 | XL | emulador | — | RTX Remix engancha juegos DX8/DX9 de funcion fija; PCSX2 dibuja con D3D11/12/Vulkan | descartado |

## audio-experiencia

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| A1 | Sordera y latido | Tinnitus, LowHealth, HeartbeatThreshold y Full Muff de la ValueDB DSP | N3 | S | pnach-datos | K3 (audio) | RESUELTO en frio 2026-09-27 (bitacora (73)): el valor sale de Data/Andy.aku, la ValueDB compilada (herramientas/valuedb_aku.py la lee y la nombra). Medido: Tinnitus/Trigger Threshold = 10, Low Health/HeartbeatThreshold = 0.4, Full Muff = 0.1. Falta el efecto de cambiarlo (notebook) y elegir vehiculo: parchear ANDY.AKU en el ISO o escribir la copia en RAM | candidato |
| A2 | Mezcla | duck de explosiones, balas que pasan (BaseMix) | N3 | S | pnach-datos | K3 (audio) | idem A1: BaseMix.cfg esta en ANDY.AKU (medido: BulletBy Ducker Dist = 1, Outer Dist = 5, Stereo Spread = 0.4) | candidato |
| E1 | Estadisticas en vivo | ventana aparte con muertes, precision y tiempo, leidas por PINE | N3, N1 | S | pine | K2 (estadisticas) | no toca el juego | candidato |
| E2 | RetroAchievements | logros de la comunidad si BLACK tiene set | N3 | S | emulador | — | puede no existir set; exige cuenta (la crea Fran) | candidato |
| E3 | Cronometro de speedrun | tiempos por tramo leidos por PINE | N3 | S | pine | K3 (flujo) | bajo | candidato |

## plataforma

| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |
|---|---|---|---|---|---|---|---|---|
| P1 | Mapa de nivel 1 a la vista | los 37 subsistemas con su K, impresos al abrir sesion | N7 | S | externo | — | ninguno | hecho |
| P2 | Inyector de codigo | code cave y gancho: donde vive el MIPS nuevo y como se llama | N1, N3, N7 | M | pnach-codigo | K5 (codigo-nuevo) | memoria libre estable sin probar | candidato |
| P3 | Arnes de prototipos por PINE | probar una mecanica desde Python antes de escribirla en MIPS | N7 | S | pine | K6 (pine) | latencia: sirve para prototipo, no para el producto | candidato |
| P4 | Registro de interfaces entre mods | que direcciones escribe cada mod; avisa si dos se pisan | N7 | S | externo | — | ninguno | candidato |
| P5 | Encontrar la camara | llevar la camara de K0 a K4 | N1, N5 | M | externo | K5 (camara) | puede estar repartida entre vista-fp y render | candidato |
| P6 | Aparicion en runtime | hacer aparecer un personaje fuera de la carga del stage | N1, N2, N3 | L | pnach-codigo | K5 (codigo-nuevo) | puede no existir como funcion aislada | candidato |
| P7 | Leer la UI como datos | el formato de /EXPORT/FRONTEND y la capa de comandos | N1, N5 | M | externo | K1 (frontend-datos) | formato propio de Criterion | candidato |

## NGOs (borrador hasta la MCR)

- **N1** jugar BLACK con otra persona — Fran 2026-09-26: 'me encantaria que haya dos jugadores'; conops R5 — *validada*
- **N2** que sea mas desafiante — Fran 2026-08-17; conops R2, R3 — *validada*
- **N3** reinventarlo con cambios drasticos: novedad y ganas de volver a jugarlo — Fran 2026-08-17: 'reinventarlo' — *validada*
- **N4** contenido nuevo: algun nivel o modo que no existia — Fran 2026-08-17; conops R6 — *validada*
- **N5** que se vea como un remaster — conops R7; interes en la PC a 2K — *validada*
- **N6** que se juegue comodo en PC — J1, cerrada 2026-09-05 — *validada*
- **N7** que cada cambio sobreviva al reinicio, se prenda y apague, y no rompa a los demas — conops R1; menu 'BLACK - Parches' — *validada*
