# Predicciones de la tanda (114), escritas ANTES de medir

## V4 — cambio de unidad real con J2 lejos, y «continuar misión» desde un punto de control (2026-10-02, fork, City Streets, Fran juega a J)

Banco: el fork con el bloque COOP + IA del pnach (938 palabras), City Streets por el selector
(`campana_coop.lanzar()` + `probar_nivel(0)`). **Nadie toca el mando 2**: J2 queda donde nace. Fran juega a J
hacia adelante hasta un punto de control. Registro continuo, sólo lectura: `herramientas/v4_registro.py`
(`--autotest` verde y en rojo al sabotear `eventos`), salida en `volcados/v4/<fecha-hora>/`.

**V4a — J2 lejos cuando el nivel cambia de unidad.** Mecanismo leído (bitácora (111), T3): la descarga
(`FUN_0012DD78`, módulo `0x1D`) llama a `FUN_0016E3C0` (la IA olvida la unidad) y después saca objetos y colisión
(`FUN_0025C180` sobre `0x0040F4CC`, los cuerpos de personaje, (82)). El arreglo diseñado («traer a J2» en
`0x0012DDCC`) **no está instalado**: esto mide el síntoma sin arreglo, que nunca se vio.
**Predicción (`hipótesis`):** cuando se descarga la unidad donde quedó J2, J2 pierde el piso y cae (altura bajando
sin parar, evento «J2 baja») hasta morir → «MISSION FAILED» (pierden los dos, (110)); alternativa con el mismo
peso: la descarga le saca el controlador (`J2+0xB4` cambia o queda en 0) y J2 queda congelado en el aire.
**Refuta las dos:** J2 sigue parado (altura constante, vida igual, `+0xB4` igual) 2 min después de la descarga
y camina con `coop_mod.py manos 2`. **Inválida:** no hubo cambio de unidad mientras J2 estaba a más de 50 m (no se
sabe cuándo pasa uno: se infiere por Fran — pantalla de carga o «stream» — y por el registro).
Límite del instrumento: «baja» mira el eje 1 de `+0xA0` como altura (`hipótesis`); el CSV guarda los tres.

**V4b — «continuar misión».** (110): reiniciar misión desarma y rearma a J2 en 2,3 s. (111): CONTINUE MISSION no se
elige sin punto de control.
**Predicción (`probable` por (110)):** después del punto de control, la muerte → «MISSION FAILED» → CONTINUE MISSION
recarga por el mismo camino de carga: FASE 2 → 0 → 2 y ESTADO 3 de nuevo en < 10 s, J salta al punto de control,
el contador del mod sube (el mundo corre) y J2 camina (`coop_mod.py manos 2`). Dónde aparece J2 (en el arranque del
nivel o junto a J) **no se predice**: se mide.
**Refuta:** el mundo frenado > 30 s con el EE vivo, o J2 no se rearma (FASE ≠ 2), o J2 no camina.
**Control:** la carga del nivel por el selector en la misma corrida (FASE 2 / ESTADO 3, J2 camina).

## Lo que pasó en la primera corrida (`volcados/v4/20261002-110959/`)

- **J1 no se movía con nada:** `lanzar()` + `probar_nivel()` dejan el control 1 de J en el mando FALSO
  (`ctrl1+0xC` = `0x00472000`, lo usa el selector). Arreglo en la herramienta: `campana_coop.entregar_a_fran()`
  lo devuelve al real y lo mide (probado en rojo con `falso_quitar` anulado y en verde).
- **J2 murió de un golpe, sin moverse, a los 392 s:** vida 750 → 0 entre dos muestras (< 0,5 s), estado 0 → 2,
  altura igual (−0,34 → −0,37), controlador igual; J a 11,3 m con 750 intacto. Fran vio **una explosión** afuera
  de la ventana junto a la que estaba J2 (foto de Fran: el fogonazo en la mitad de J2), sin enemigos con granadas
  a la vista. «MISSION FAILED» con CONTINUE MISSION apagado (sin punto de control todavía).
  **No fue el teclado sobre J2:** la configuración global (`Documents\PCSX2\inis\PCSX2.ini`) tiene teclado y mouse
  sólo en el puerto 1; el puerto 2 es sólo el mando SDL-1.
  **`hipótesis`:** un auto explotó (¿un tiro de J?) y la explosión mata a J2 de un golpe a una distancia en la que J
  no recibe nada: J2 no tendría la reducción de daño de explosión del jugador (o la recibe como un actor
  cualquiera). Sin reproducir. Es un riesgo nuevo para la C (N nuevo en `docs/17`).
  **Causa, por Fran (conoce el nivel):** al salir de la primera habitación y bajar la escalera, el guion hace
  explotar bombas puestas **detrás** del jugador, como efecto de cine; están donde J ya no está y J2 se había
  quedado ahí. Ningún auto ni explosivo explota sin un tiro de J. → **Riesgo nuevo de la clase B (lo que el mundo
  le pregunta a «el jugador»): los eventos de guion se ubican contra el recorrido de J, y J2 rezagado puede quedar
  adentro.** Sigue siendo `probable` (relato de Fran + muerte de un golpe medida); el arreglo natural es el mismo
  «traer a J2 junto a J» de N4, disparado también por estos eventos, o J2 invulnerable a lo del guion.
- **RESTART MISSION con el coop, de nuevo bien (control de V4b):** a los 630 s FASE 2 → 0, controlador de J2 → 0
  (el desarme), y a los 637–639 s FASE 2, ESTADO 3, J y J2 de vuelta en el arranque, controlador re-atado
  (`0x005880B0`), el mundo corre.
- **Segunda pasada, J2 quieto en el arranque:** J se alejó a 89 m (entró al museo) y J2 sigue vivo, a la misma
  altura (−0,3) y con el mismo controlador: **hasta los 1140 s no se cayó nada** (V4a todavía sin refutar ni
  confirmar: no se sabe si la unidad de J2 ya se descargó).
- **Fran, jugando:** (a) la mira con el mouse no detecta movimientos lentos y constantes (hay que moverlo mucho):
  es la zona muerta del propio juego ya medida (chequeo: «la causa era una zona muerta de 0.1 del propio juego»);
  el fork no trae el parche que la saca en su PCSX2 (`hipótesis`, ver `docs/10-jugar.md`). (b) **el fuego, el humo
  y las nubes se mueven al mover la mira**: partículas orientadas a la cámara de UN jugador y dibujadas en las dos
  mitades (`hipótesis`, observación nueva para `docs/17`, clase C).
- **El RPG del museo, roto con el coop (Fran, foto `C:\Users\frans\.claude\uploads\...\b24beeed-image.jpg`):** el
  cohete va ~3 veces más lento, la estela sale al costado del cohete y **desaparece unos metros antes de llegar a J**
  (nunca le pega). `hipótesis`: una sola causa — el proyectil avanza menos por cuadro con el coop (¿se integra con
  el dt de un cuadro que ahora dura el doble, o una pasada sí y otra no?) y su vida útil, fija en tiempo, se acaba
  antes del blanco; la estela corrida sería el mismo efecto que «el humo se mueve con la mira» (partículas puestas
  con la cámara de un jugador). **Sin control todavía:** hay que ver la misma escena sin el bloque COOP. Nodo
  `proyectiles` (K2). Para `docs/17`.
- **Para morir y llegar a CONTINUE MISSION** (el RPG no pega): la vida de J se sostiene en 5 por PINE
  (`J+0x2F8`, escritura de dato, no de código) hasta que J muere; el resto lo hace un enemigo.
- **Resultado V4b: SIN MEDIR.** J murió a los 1343 s (en el museo, frente al del RPG, después de la puerta
  derribada; J a 92 m de J2). MISSION FAILED muestra CONTINUE MISSION pero **no se puede elegir** (foto de Fran,
  `1bedf67a-image.jpg`): igual que en (111), no hay punto de control registrado. Dos explicaciones, sin
  discriminar: (a) el original no tiene punto de control antes de ese tramo; (b) con el coop (o cargado por el
  selector de depuración) el punto de control no se guarda (los disparadores miran sólo a J, así que (b) es
  menos probable). **Control que lo decide:** la misma partida con el bloque COOP apagado.
- **V4a, lo que sí quedó:** J2 rezagado en el arranque mientras J recorrió ~90 m y entró al museo: **vivo, misma
  altura, mismo controlador, 700 s**. No se cayó nada; si la unidad del arranque se descargó en ese recorrido, J2
  la sobrevivió (no se sabe si se descargó: el registro no mira la descarga).
- **Dos más de Fran, en la corrida con coop:** (a) al disparar el AK aparece un **bloque de basura gráfica arriba a
  la izquierda** (~190 × 150 px de 1920, sobre el borde del HUD de J; foto en el chat); (b) **una vez J siguió
  disparando solo**, sin que Fran apretara. Las dos `hipótesis`, sin control: (a) un destino de dibujo del coop
  (la pasada 2 o la lista 2D) que pisa una zona sin limpiar; (b) un botón que quedó apretado (el clic del mouse
  perdido al cambiar de ventana, o el mando falso: J1 estuvo en el falso hasta el `entregar_a_fran`).
- **El mouse:** los tres parches de mira (`Mira lineal`, `Mira sensible`, `Zona muerta del pad a cero`) estaban
  APAGADOS en `gamesettings\SLUS-21376_5C891FF1.ini`: los saca `JUGAR-BLACK.ps1 -Coop 2mandos` (la última vez que
  Fran jugó) y el lanzador del fork no los repone. Prendidos a mano para el control (respaldo `.bak-` con fecha).
  La causa de fondo es la misma de `entregar_a_fran`: el fork se arma para las sondas, no para que Fran juegue.
- **Control sin coop (V4b y el RPG):** `coop_mod.py desactivar`, el fork relanzado, City Streets por el selector
  (`probar_sin_mod(0)`, 35 s), J1 devuelto al mando real. Savestates cada 90 s en los slots 5–7
  (`herramientas/guardado_auto.py`, registro en `volcados/guardados.txt`).
- **Control sin coop, resultado del RPG:** **sin el coop el cohete también va lento** (Fran). El RPG lento NO es
  del coop: queda `hipótesis` entre el parche «60 FPS» (prendido en las dos corridas), el emulador o el juego así.
  Sale del riesgo del coop; va a `docs/10-jugar.md` como cosa a mirar del juego.
- **Sin coop Fran llegó a un punto de control** (después del del RPG, con un RPG propio). Savestate slot 8
  (post-checkpoint, sin coop, J en (−88,6; −3,7; 15,0)). En la corrida con coop J murió ANTES de ese punto: por
  eso CONTINUE estaba apagado — la explicación (a) gana, (b) queda sin probar.
- **V4b rediseñada (escrita antes):** desde el slot 8, (1) control: J muere sin coop → CONTINUE se puede elegir y el
  juego sigue; (2) `coop_mod.py poner` en pausa (el bloque COOP escrito en vivo), J muere → CONTINUE.
  **Predicción:** la recarga del punto de control pasa por el cargador con el gancho del coop → FASE 2 / ESTADO 3
  en < 15 s, pantalla partida, J2 aparece junto a J (el punto de aparición del punto de control) y camina
  (`coop_mod.py manos 2`). **Refuta:** cuelga, o FASE ≠ 2, o J2 no camina.
- **Corrección:** el control «sin coop CONTINUE anda» **no se midió** (lo di por hecho por una foto de Fran jugando,
  sin que dijera que había continuado). Con el coop puesto (`poner`) y J muerto ahí, CONTINUE apagado otra vez.
  Lectura de Fran: el aviso de objetivo cumplido no es un punto de control. Se carga el slot 8 (sin coop; FASE 0
  medido), Fran avanza hasta el final del nivel y ahí se repite: primero el control sin coop, después con coop.
- **El arma de J en las dos mitades al juntar** (foto de Fran: las dos mitades con el rifle) = F7, ya conocido
  (pieza 2 de la C).
