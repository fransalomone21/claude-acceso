# Estudio de conceptos — Pre-Fase A del programa BLACK

Abierto el **2026-09-26**. Es la fase que el proyecto se salteó: producir
*"a broad spectrum of ideas and alternatives"* (NASA p. 9) **antes** de elegir
en qué bajar al detalle. Cómo se trabaja: [`11-programa.md`](11-programa.md).
El catálogo completo, generado de `kb/`: [`12-catalogo.md`](12-catalogo.md).

**Qué cierra esta fase:** la MCR con sus criterios de éxito (`11-programa.md`
§6). **Cómo se certifica:** `programa.py verificar` en verde,
`pruebas/probar-programa.py` en rojo donde corresponde, tus respuestas
escritas abajo (§7), tus pesos en `kb/conceptos.json` con fuente y fecha, y
`programa.py trade` corrido. Hoy `trade` sale **2 (bloqueado)**: faltan tus
pesos, y así tiene que ser.

---

## 1. Qué querés (borrador — lo validás vos en la MCR)

Siete metas (NGOs), dos ya validadas por lo hecho y cinco sin validar. Cada una
tiene su medida de efectividad (MOE): cómo se ve, jugando, que se cumplió.
Están en `kb/conceptos.json` y al pie del catálogo. En corto:

| Meta | Cómo se sabría que se cumplió |
|---|---|
| **N1** jugar con otra persona | dos personas terminan una misión entera juntas, sin cuelgues, y quieren otra |
| **N2** más desafiante | reintentos por misión contra el original, y tu nota del 1 al 5 |
| **N3** reinventarlo, rejugarlo | volvés a un nivel ya terminado por gusto, y la partida es distinta |
| **N4** contenido nuevo | se juega de punta a punta algo que no existía |
| **N5** que se vea remaster | lado a lado aprobado por vos, con cuadros estables donde jugás |

## 2. Cómo se juega (ConOps en borrador)

Tres situaciones de uso, a confirmar con tus respuestas:

1. **Vos solo**, en la notebook o en la PC, teclado y mouse, una misión de 20 a
   40 minutos.
2. **Sillón:** vos y otra persona, una pantalla, dos mandos (los dos ya
   conectados y leídos por el juego, bitácora (61)).
3. **A distancia:** la otra persona en su casa, conectada a tu coop local por
   Parsec o Remote Play (concepto M6: cero reversing, si existe un coop local).

## 3. El juego como sistema: funciones y mapa de nivel 1

Diez funciones (F1 leer la entrada … F10 menús y flujo), cada una asignada a
subsistemas del mapa; `programa.py verificar` sale en rojo si una queda sin
dueño (NASA p. 64: traducir los requisitos a funciones y asignarlas a la
estructura del producto).

**El mapa, hoy** (`programa.py resumen`):

```
K0:  2  camara, tiempo
K1:  6  frontend-datos, s-0x0040F510, s-0x0040F4C0, sin-nombre, render, iso-globdata
K2: 13  ia, vista-fp, hud, comandos-ui, front-end, estadisticas, resultados, ...
K3:  6  fisica, recursos, flujo, valuedb, spawn, iso-video
K4:  4  juego, entrada, iso-niveles, iso-texturas
K5:  1  actores
K6:  3  armas, emu-imagen, pine
conceptos candidatos: 48; frenados por un habilitador en K0-K1: 14
```

Lo que dice ese mapa, y no se veía antes de hoy:

- **El coop, la pantalla dividida y el versus están frenados por lo mismo: la
  cámara, en K0.** Encontrarla (concepto P5) es el desarrollo de tecnología que
  más destraba, y también destraba el FOV (G3) y el modo foto (G7).
- **La segunda interfaz más grande del juego (`0x0040F510`, ≥219 funciones) no
  tiene nombre seguro.** Tampoco `0x0040F4C0` (≥117). Son candidatos a mover el
  catálogo entero, y cuestan una sonda cada uno.
- **El 99,3 % de `GLOBDATA.BIN` sigue sin nombre.**

## 4. Lo que el censo de hoy agregó al catálogo

Estructuras de nivel alto que aparecieron por mirar arriba, cada una con los
conceptos que abre:

| Hallazgo | Qué abre |
|---|---|
| El esquema de armas tiene bloques `PlayerParams` y **`AIParams`**, con **Max Spread Angle** y **Accuracy Fall Off** | **D2** puntería de la IA, en la misma tabla que ya se parchea; **J1** rebalanceo del jugador |
| Una **capa de comandos con nombre** hacia la interfaz (`SetupObjectives`, `HealthPacks`, `SetReticuleType`…) y la interfaz como **datos** en `/EXPORT/FRONTEND/` | **G6** HUD nuevo, **D7** hardcore, el HUD del jugador 2 |
| Un subsistema de **estadísticas y medallas** (muertes, tiros a la cabeza, «Black Kills») | **E1** estadísticas en vivo, **M7** puntaje por turnos |
| Un subsistema de **objetos recogibles** (64 instancias) | **D6** munición escasa, **J7** randomizer |
| Un subsistema de **guardado y perfil** | **J9** todo desbloqueado |
| Los dos mandos ya se leen; los jugadores son un array de largo 1 | **M1**, **M3**, **M6** |

## 5. Sin rankear todavía

No hay orden porque **no hay pesos tuyos**. Lo único que se puede decir sin
opinar es qué es barato y está maduro. Los conceptos de costo **S** con todos
sus habilitadores en K ≥ 3 son **once**, calculados de `kb/`, no elegidos: M6,
D2, D5, J1, J3, J4, L5, E2, E3, P3 y P4. M6 (coop a distancia) es barato pero
sólo sirve si antes existe un coop local. Otros nueve de costo S quedan afuera:
seis por un habilitador en K2 (A1, A2, E1, M7, D6, J9) y tres más abajo (G3,
G5, G8). Si
entran o no lo decidís vos en la MCR.

**Descartados, con el motivo escrito** (para no discutirlos de nuevo):
**X1** RTX Remix (engancha juegos DX8/DX9 de función fija; PCSX2 dibuja con
D3D11/12/Vulkan) y **X2** online nativo del emulador (PCSX2 2.8 no lo trae; M6
cubre la necesidad).

## 6. Preguntas para vos — antes de cualquier trade study

Contestá con el número y lo que quieras («1: coop; 2b, mi hermano; …»). Las
que no sepas, «no sé» es una respuesta útil. Las preguntas finas del coop
vienen con su análisis, después de esto.

**A. Para qué y para quién**
1. Si dentro de seis meses existiera **una sola** cosa terminada, ¿cuál sería?
   (coop / más difícil / remaster visual / contenido nuevo / otra)
2. ¿Para quién es? (a) vos solo; (b) vos y una persona fija, ¿quién?; (c) algo
   que algún día compartirías. La (c) cambia qué se puede distribuir: el ISO
   no; un pnach o un parche, sí.
3. ¿Qué de BLACK original **no** querés perder? (sonido, destrucción, ritmo,
   campaña lineal, estética…)
4. ¿Qué te molesta o te aburre hoy cuando lo jugás?

**B. Coop (sólo lo que decide la cartera)**
5. ¿Cómo lo imaginás? (a) misma pantalla, la cámara sigue a uno o encuadra a
   los dos; (b) pantalla dividida; (c) el segundo maneja a Tom o a Matt; (d) a
   distancia; (e) no sé todavía.
6. ¿Con quién jugarías, y con qué control cada uno? ¿Esa persona tiene PC
   propia?
7. ¿Campaña entera en coop, o alcanza con una o dos misiones, o una arena, para
   empezar?
8. ¿Aceptás resignar imagen o cuadros mientras se juega en coop (sin pack HD o
   sin DLSS), si hace falta?

**C. Desafío**
9. Ordená qué significa «más desafiante»: enemigos más letales · más enemigos
   · enemigos más inteligentes · menos recursos (munición, vida) · menos
   ayudas (HUD, auto-apuntado).
10. ¿Un modo aparte que se elige al arrancar, o reemplazar la dificultad del
    juego?

**D. Novedad y contenido**
11. ¿Te tira más la rejugabilidad (randomizer, horda, arenas) o la campaña
    curada a mano?
12. Armas: ¿más realistas, más arcade, o armas nuevas?
13. El nivel nuevo, ¿sigue en tu lista o pasa a «algún día»? (es el concepto
    más caro del catálogo)

**E. Imagen y experiencia**
14. Remaster: ¿qué pesa más: nitidez, cuadros, atmósfera (luz, niebla) o un
    HUD moderno? ¿Jugás en la notebook o en la PC?
15. Estadísticas en vivo, logros, cronómetro: ¿te suman o te sacan de la
    inmersión?

**F. Restricciones y forma de trabajar**
16. ¿Cuántas sesiones por semana para BLACK, sabiendo que el tope del plan se
    comparte con Agustín?
17. ¿Cuánto podés jugar pruebas por semana? ¿Y el jugador 2?
18. Riesgo: ¿está bien que un mod en prueba cuelgue el emulador (hay
    savestates), o preferís que todo pase antes por un prototipo desde afuera
    (PINE)?
19. Revisiones: una MCR para toda la cartera y después una por fase de cada
    proyecto, ¿o preferís menos revisiones y más autonomía en lo técnico?
20. Preguntas: ¿en bloque como éste, o de a tres o cuatro con opciones para
    tocar?

**G. Los pesos del trade study**
21. Repartí **100 puntos** entre: C1 valor para vos · C2 costo · C3 riesgo
    técnico · C4 tiempo hasta la primera partida · C5 que habilite otros
    conceptos · C6 que se apague sin romper nada.
22. Para C1, ordená las metas: N1 coop · N2 desafío · N3 novedad · N4
    contenido · N5 remaster.

## 7. Tus respuestas

### 2026-09-27 — respuestas de Fran a las 22 preguntas (textuales, sesión en la nube)

Copiadas tal cual las escribió, sin corregir. En la sesión, las preguntas 1 y 22
se le presentaron con estas opciones, y a ellas remite «en ese orden»:
**1** (a) coop · (b) más difícil · (c) remaster visual · (d) contenido nuevo ·
(e) otra; **22** N1 coop · N2 desafío · N3 novedad y ganas de volver a jugarlo ·
N4 contenido nuevo · N5 remaster · N6 cómodo en PC · N7 cada mod sobrevive al
reinicio, se prende y apaga, y no rompe a los demás.

> 1) en ese orden quiero 2- es para mi y para jugar con quien quiera 3- quiero que se agreguen cosas, y se mejoren las que ya estan, sin cambair lo que esta bien. 4- que me resulta facil aun en dificil y quiero jugarlo con alguien o nuevas sorpresas ya que me lo pase varias veces 5- me gustaria que sea pantalla dividida o cada uno en una computadora seria mejor, quiero la que sea viable, que permita jugar de a dos. 6- tengo la notebook y PC de r7 5700g y 3090, con quien sea jugare, amigos o familia. 7- campania entera y despues vamos viendo en el futuro 8- si acepto, perder lo menor posible pero perder lo necesario. 9-  todas esas caracteristicas o cambios me gustan y las considero como aumento de dificultad 10-  un modo que se elige antes de entrar al nivel 11- ambas me gustan 12- todas me gustan 13- algun dia, no lo veo viable por ahora 14- del remaster me gustaria luz y niebla y nitidez el resto tambien 15- quiero que sea inmersivo, bien realista. 16- eso lo voy manejando yo cuando quiero retomar o no 17-  cuando le dedico tiempo, hacemos pruebas obvio conmigo con ambos controles o pcs. 18- no hay problema con cuelgues en el emu o savestates. 19- cuando sea necesario mas al principio de conceptos y alto nivel 20- en bloque asi esta bien, me hace contestar todo de una y no darte informacion a cuotas haciendo que avances sin saber todas mis necesidades. Hacer preguntas luego antes de implementar nuevas cosas que no vienen de los requerimientos, asi no perdemos trazabilidad.  21 me interesa basicamente avanzar ocasionalmente y que hags caso a la intensidad, o costos que maneje en el momento y tokens que disponga. 22- en ese orden que me pusiste

**Abierto después de leerlas** (lo pregunta la sesión, no se decide sola):

- La **1** pone remaster (c) antes que contenido (d); la **22** pone N4
  contenido antes que N5 remaster. Falta saber cuál manda.
- La **21** no reparte los 100 puntos: dice que el costo lo maneja Fran en el
  momento. Sin un reparto, `trade` sigue bloqueado, y se le proponen
  opciones.

