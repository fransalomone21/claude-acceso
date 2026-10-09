# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-09 de madrugada (decimoséptima sesión, PC, abierta en `Desktop\claude-acceso`) ·
**Fase al cerrar:** 0 (Concebir, Pre-Fase A) — **abierta**, 2 de 4: arquitectura
cerrada (VNS) y **borrador de requisitos en verde** (`docs/10-requisitos.md`);
falta el CdM por dos métodos (≈ 63 cm, 58 a 69, **sin medir**), la prueba de
foco y el inventario sin `?`.

## Decimoséptima sesión (2026-10-08/09): revisión de punta a punta, la pista y los planos

**Fran** (sin medidas nuevas): «revisá el proyecto y el concepto y determiná
posibles inconvenientes en concepto, diseño, implementación y operación;
avanzá lo que puedas sin mis mediciones, refiná lo que sabés que sirve, mejorá
los dibujos y creá planos o layouts para cuando tengamos medidas».

**Hecho (todo commiteado y pusheado):**
- **`docs/16-revision-concepto-a-operacion.md`** = Doc «4 - Revisión: qué
  puede salir mal» (ID `1nlXkMXiffayMMLz8TbeIxN6xhdgzKxUkgcBWtgUigDE`, nuevo).
  Manda sobre `13` §3, §4 y §6. Lo central:
  - **La pista manda** (K1): 1 µm de canto ≈ 0,27″; tolerancias de micrones
    para 60 s; ≈ 70 % es bamboleo (ni tabla ni guiado). Salidas: fotos de 30 s,
    terminar cantos (fresado/rectificado) y rodillos de precisión. **Decide la
    muestra del canto** (paso 6c de `11`, nuevo).
  - **Método de trazado** (K2): el canto es la envolvente del rodillo (hoy el
    generador traza el punto de arriba: 1,2″); la chapa queda atada al
    diámetro del rodillo (±0,3 mm). **No se cambió `geometria-vns.js`**: el
    modelo sigue igual; la envolvente la calcula `contacto-vns.js`, y el DXF de
    la fase 3 tiene que salir de ahí.
  - Arista (D1), cuatro 608 afuera (D2), salto de rodillos (D3), tolerancias de
    armado (D4), homing y salida del fin de carrera (D5), pivote todo de acero
    (D6), docs atrasados corregidos (D7). Latitud: las patas (K3). T2 sabe
    dónde está la mesa (K5).
  - Operación: rocío, enfriamiento del espejo (choca con L1-17), foco con el
    frío (Bahtinov), colimación, óxido y polvo en la pista; la noche en orden.
  - §7: **candidatos a requisito** (no se editó `10`): canto, salto, homing,
    salida del fin de carrera, rocío, conservación del canto, patas si viaja,
    L1-17.
- **`docs/contacto-vns.js`** (función pura sobre `geometria-vns.js`; corre en
  node y en el navegador, `window.CONTACTO`) y **`probar-contacto.js`** (6
  controles y 4 sabotajes, verde). Newton sobre la pose de la mesa con pivote,
  dos contactos cilindro-prisma y la transmisión (V, F o eje ideal).
- **`docs/planos.html`** + **`planos.ps1`** → PDF «Planos de disposicion
  (preliminar).pdf» en el Drive (ID `1uJ853WGlh8TeLUAmO_HtWFC4L5afre8J`), 5
  hojas A3: planta 1:10, alzado 1:10, vista sur 1:5, chapa este 1:1, tolerancias
  y profundidades cada 10 mm. Arriba se cargan CdM, masa, rodillo, separación y
  base. Verlo: `preview_start telescopio-modelo` → `/planos.html`.
- **Dibujos**: `dibujos-mecanismos.js` **v5** (la chapa de los esquemas con su
  forma de verdad: sube de una punta a la otra; antes, un arco parejo);
  `?v=5` en `06-modelo-3d.html` y `dibujo-mecanismos.html`; PNG regenerados y
  Doc 3 subido con el mismo ID. **El artifact del modelo NO se republicó**
  (sigue con los esquemas v4); el modelo local da Sueltas 0 y Choques 0, sin
  errores de consola. Republicar con el próximo cambio del modelo (files con
  `dibujos-mecanismos.js` en `?v=5`).
- **Docs 1 v8 y 2 v6** con el mismo ID (2: paso 6c y la tabla FAB/CAL al día).
- **PDP**: riesgos **R12** (la pista), **R13** (el trazado), **R14** (la noche),
  **R15** (óxido y polvo); decisiones: planos de disposición sí (Fran) y
  canto-envolvente + rodillos de una pieza (técnica).
- **Lección** nueva (nivel herramienta): un presupuesto de error se arma
  recorriendo la cadena física, no listando los errores conocidos; línea
  propia en `chequeo-de-trabajo.md`, perfil reinstalado.
- **No hecho, a propósito:** las cuentas del telescopio (`probar-geometria`,
  `probar-transmisiones`, `probar-contacto`) **no corren en
  `chequeo-completo.ps1`**: engancharlas pide las lecturas del concepto
  «freno»; quedó como tarea aparte.

**Pendiente de Fran:** la foto de la tabla del vuelco; **la muestra del canto**
(6c); las medidas de la varilla; la palanca óptica; la prueba de foco; ¿60 o
30 s con la pista sobre la mesa?; ¿se paga la terminación de cantos y
rodillos?; ¿viaja en auto?; ¿cuánto armado?; ¿filtro de dos bandas?

## Decimosexta sesión (2026-10-08, noche): investigación, el micropaso y el v10.5

**Fran** (sin medidas nuevas): «investigá bien los diseños y arquitecturas y
avanzá el proyecto con soluciones inteligentes […] analizá en Villa Adelina
qué opciones hay en los alrededores, mecanismos, soluciones, dibujos, imágenes
y docs más útiles y visuales». Vía libre de tokens.

**Hecho (todo commiteado y pusheado):**
- **`docs/15-mecanismos-y-proveedores.md`** = Doc «3 - Mecanismos, proveedores
  y cielo» del Drive (ID `1xMPDUoihZAX2ZthJrEnyKVfAUAyWl-JattlAG8yAOV8`, nuevo,
  4 imágenes). Lo central:
  - **El error de micropaso** (±5 % de un paso entero, hoja de datos; el
    micropaso da resolución, no exactitud: Analog Devices). Con la F de una
    correa, ≈ 34″ por paso entero → borrón ≈ 3,4″ y redondez 0,66: **no pasa
    L2-PLT-02**. Pasan F2 (dos correas, 8,4″), V de paso 8 (10,5″), T2 con
    tornillo de bolas (5-7″) y C (cable de acero sobre el eje de 8, idea
    nueva, sin antecedentes en plataformas). `docs/13` §4 lo había dado por
    chico. Cuentas en **`docs/transmisiones.js`** (función pura;
    `probar-transmisiones.js` con 6 controles y sabotajes).
  - **El trade ya no empata**: con el orden de Fran, T2 le gana a F2 por
    15-21 % con ROC, suma de rangos y recíproco, y 10 % aunque F2 no patine
    (`docs/15` §2.3). Se elige en su nivel, con Fran.
  - **La palanca óptica**: espejito en el eje del motor + puntero láser +
    pared a 2 m; un paso entero = 126 mm en la pared, ±5 % = ±6 mm. Está como
    **paso 6b de `11`** (Doc 2 v5).
  - **El empujón**: un lastre no sirve (5,5 → 5,5); rodillos a 58 cm + base
    1,3 m ponen todo en verde.
  - **Proveedores** (directorios, sin llamar): quién corta 8 mm (Rapimetal,
    Martino; Prymax no), tornería con rectificadora (Acosta, Munro),
    rulemanes (Munro), hierros; el tornillo de bolas no aparece en el país.
  - **Cielo**: patio ≈ Bortle 7-8 (`hipótesis`); Punta Indio (150 km, Bortle
    3) a 0,8° de latitud, adentro de L1-09; filtro de dos bandas para la
    primera nebulosa desde el patio. **Cámara**: la APS-C en un portaocular de
    1,25" va a viñetear (`hipótesis`, se ve en P0).
- **Modelo v10.5** (artifact versión 10, mismo link, público, visto sin
  sesión): rodillos **58 cm**, base **1,3 m**, fines de carrera a **4,5 cm**
  (`KSW`), sección «Cuatro maneras de mover la mesa» (esquemas, estrella
  simulada con deslizadores de error y aire, tabla viva, palanca, empujón),
  **recorrido guiado** (7 paradas, botón «Recorrido»), **vista explotada**
  (deslizador; `sueltas()` y `choques()` la ponen en 0 mientras miden).
  Medido: Choques **ninguno** y Sueltas **ninguna** con F y V, 200 y 12";
  sabotajes motor 7/7 (F) y 4/4 (V), finales 6/6, choque 1, restaurado 0.
  Scripts nuevos: `transmisiones.js?v=3`, `dibujos-mecanismos.js?v=4`
  (`geometria-vns.js?v=10` no cambió). Republicar: `files` con los **tres**
  `.js` (rutas absolutas).
- **Dibujos**: `docs/dibujos-mecanismos.js` es la fuente única (la usan el
  modelo y `docs/dibujo-mecanismos.html`); PNG con
  `docs/dibujos-mecanismos.ps1` → `docs/img/mec-*.png`.
- **Docs del Drive**: 1 v7 (el trade nuevo), 2 v5 (6b, deberes al día), 3
  nuevo; 1 y 2 con el mismo ID.
- **Requisitos**: ningún enunciado cambia; rationale de L2-PLT-02 (micropaso),
  L1-13, L1-14, L2-PLT-05 y §9/§11 al día. VERDE.
- **PDP**: riesgo **R11** (micropaso) y dos decisiones técnicas (58 cm/1,3 m;
  la F de una correa sale).
- Cerrado el rojo del arranque «listo para la nube»: `clases-aed` (4) y
  `catedras` (1) tenían commits sin pushear; pusheados con excepción
  registrada en la puerta.

**OJO al commitear desde PowerShell:** un mensaje con comillas dobles adentro
se corta en `-m @'...'@` (PS 5.1 re-parsea el string al pasarlo a git). Usar
**`git commit -F <archivo>`** con el mensaje escrito con la herramienta Write.

**Pendiente de Fran:** la foto de la tabla del vuelco; las medidas de la
varilla de la foto; la palanca óptica (con Kevin); la prueba de foco;
¿viaja en auto?; ¿cuánto armado?; ¿filtro de dos bandas?

## Decimoquinta sesión, cierre (2026-10-08): la segunda transmisión (v10.4) y la V de NASA

**Fran** (con una foto de una plataforma con varilla roscada): «añadí al
artifact la versión con varilla roscada como en la foto, sólo eso, y esperá a
mis medidas». Y después: «dejalo obvio como una segunda opción de transmisión.
Una vez que terminemos el concepto, haremos el diseño con la lista de
requisitos de alto nivel y de ahí para abajo hasta definir el mejor mecanismo,
mejor performance en relación a simplicidad. Seguiremos el diagrama V de NASA
[…] y obvio que debemos tener los planes de verificación, de implementación y
todo. Mañana te paso las medidas y el CM».

**Hecho (artifact versión 9, `?v=10` sin cambio: `geometria-vns.js` no se tocó):**
- **Selector «Transmisión: dos opciones»** en el panel: **opción 1 · F**
  (rodillo motriz y correa, la de siempre) y **opción 2 · V** (la de la foto).
  Botón «Detalle: varilla (V)». La F queda idéntica.
- **La V:** perfil con varilla al **sur de la viga sur** (y = −44 cm, fuera
  del barrido de las chapas, que llegan a −35), sobre **dos planchuelas que
  cruzan la viga** con dos M6 en fila; motor (a ojo NEMA 23) + acople flexible
  + varilla + tuerca en un carro con rótula; **biela de 15 cm** con dos rótulas
  hasta un **brazo** que cuelga del travesaño sur de la mesa en x = 0 (entre
  las chapas) y pasa por **arriba** de los fines de carrera y de la varilla.
  Los dos rodillos quedan **locos** (608). Medidas a ojo en `VARI` (una sola
  constante en `06-modelo-3d.html`): paso 8 mm, biela 15 cm, motor 57 mm.
- **Lo que da (con medidas a ojo, `probable`):** carrera de la tuerca 339 mm
  tope a tope; luz al rulemán 16 mm; la velocidad de la varilla varía ±2,8 %
  (es un tangente: la corrige la tabla del programa, como la del VNS); 25
  vueltas por hora → **el error de la varilla se repite cada ≈ 2,4 min**, más
  lento que un sub de 60 s pero adentro de ~2,4 subs: entra en el PEC como el
  de la polea; 0,67″ por micropaso a 1/16.
- **Medido en el panel, con el 200 y con el 12":** Choques **ninguno** y
  Piezas sueltas **ninguna** con las dos opciones; `choques()` ahora pone el
  carro y la biela en cada paso de la carrera (`poseDrive`). Sabotajes: motor
  7/7 (F) y **4/4 (V)**, finales 6/6, choque 1, todos restaurado 0; **sabotaje
  propio de la V**: una caja fija en el camino del brazo da 1 choque
  (`motorBody<-printed2`) y restaura 0. La punta de la biela cae en la rótula
  del brazo con **0,00 mm** de error a −45, −20, 0, 20 y 45 min.
- **PDP §4: «Después de la fase 0: la V de NASA»** (SEH Fig. 2.1-1,
  `nasa-seh/fundamentos.md` §3): brazo que baja L0 → L1 → L2 → L3 → pieza;
  brazo que sube implementación → integración → verificación → validación; en
  cada nivel, **antes de bajar**, su plan de verificación y su plan de
  implementación; la transmisión (F o V) se elige **en su nivel** con un trade
  de pesos de Fran, nunca por el modelo 3D.
- Ojo: el PDP §8 (2026-10-07) había descartado «varilla roscada» porque «repite
  su error cada minuto». Con la cuenta de la V da cada ≈ 2,4 min (paso 8,
  biela en x = 0): **no está descartada**, pero ese argumento entra al trade.

- **Doc «1 - El proyecto» v6** (`docs/07-guia-armado.md`, mismo ID en el
  Drive `1wrzPpiz…`, releído desde el Drive): sección **«Los conceptos en
  competencia, con puntaje»** para discutir con Kevin — CS/VNS (2,7/4,5,
  decidido), U0-U3 (3,0 / **U1 4,0** / U2 3,6 / U3 afuera por el piso; el
  criterio «cambiar de telescopio» con peso 0 de Fran), transmisión con el
  piso de precisión (B y T afuera; la V de la foto es T2 si el tornillo es de
  bolas o trapezoidal bueno) y F 3,58 / T2 3,54 (empate: lo decide el banco),
  «el mejor postor hasta ahora» y cuatro preguntas para Kevin (facilidad de
  taller, torno a 0,02 mm, tipo de varilla de la foto, banco con chapa de
  prueba). Los puntajes de U0-U2 son **nuevos de esta sesión** (antes no
  había puntaje, sólo a favor/en contra en `docs/14` §5). También corregí en
  el doc dos datos viejos: la electrónica ya no va en la viga sur y el cambio
  de telescopio no tiene tope de 15 min.

**Pendiente de Fran (mañana):** las **medidas de la V** (largo y paso de la
varilla, motor, largo de la biela, alto del carro) y **la foto de la tabla del
vuelco** (el CdM). Siguen: ¿viaja en auto?; ¿cuánto armado?; prueba de foco.

## Decimocuarta sesión, cierre (2026-10-08): 60 s, el trade y nada choca (v10.3)

**Fran:** «vamos a por 60 segundos y mi ranking es precisión > que no patine >
facilidad > costo. wtf hiciste, se choca el segmento con medio mundo, ambos».

**Lo que pasó:** el v10.1 y el v10.2 movieron la electrónica, la batería y los
fines de carrera **sin medir el barrido** de las chapas, que recorren la viga
sur de punta a punta. «Piezas sueltas» no mira choques. Lección 357.

**Hecho (artifact versión 8):**
- **`choques()`** en el panel («Choques… toda la carrera, medido»): gira chapas
  y mesa de −51 a +51 min y prueba cada punto contra la caja de cada pieza fija
  **en su sistema**; excluye la pista (rodillos), la rótula y leva-palanca.
  Sabotaje `window.__vns.sabotearChoque()` (una caja donde estaba la batería):
  1 y restaura 0. **Dio 7 choques** (electrónica, batería y su cable, botón,
  leva contra el soporte de un switch, y los dos ángulos sur en el tope 49-51).
  Ojo: la primera versión del chequeo daba 0 porque un comentario `//` en el
  medio de la línea se comió el código; se sospechó del 0 antes de creerle.
- Electrónica y batería a los **tubos de costado** (30 cm de cada pata del sur,
  2 M6 en fila); mazo en la cara **norte** de la viga sur, ramales por la
  cartela. Fines de carrera a la altura **real** de la leva (`rotAbout` de la
  leva a los 48 min y su camino hasta el tope; el del este queda alto). Ángulos
  de los rodillos a ±32 mm (eran 24). `sabotear()` sube 10 mm (con 5 un bulón
  vecino «sostenía» el motor). Resultado: **choques ninguno, sueltas ninguna**,
  con el 200 y el 12"; motor 7/7, finales 6/6.
- **60 s** en los requisitos (L1-01, L1-27, L2-PLT-02, L2-PLT-03 0,1 %,
  L2-MON-01, L2-OPE-01 3,5′, L2-OPE-04 0,5 mm), §9 con PEC, el trade y la
  ubicación de la electrónica. VERDE.
- **Trade** (`docs/14` §6d): el orden de Fran pasado a pesos con ROC, suma de
  rangos y recíproco: **empata** (gana uno u otro por 1-3 %). Decide el banco:
  F no patina → **F + PEC**; patina → **T2 paso 8 + PEC**.

**Pendiente de Fran:** foto de la tabla del vuelco; ¿viaja en auto?; ¿cuánto
armado?; prueba de foco. **De la sesión:** el banco del rodillo (diseñarlo) y
ajustar CAL-2 y CAL-4 de `docs/11` a 60 s.

## Decimocuarta sesión, segunda parte: v10.2, los bulones

**Pedido de Fran** (captura del fin de carrera del este): «propone estructura
que no deje eso volando, y si no hace falta planchuela ahí, dejá más clara la
estructura con detalle en los bulones para que me dé cuenta que no hace falta
la planchuela paralela». Era relevante: cada fin de carrera estaba en una
planchuela en voladizo de **6,7 y 12,6 cm** al norte de la viga con **un solo
bulón** (gira como bisagra), y los dos M8 de cada unidad de rodillo caían a
12 mm del eje del tubo de 20 mm: **afuera del tubo**.

**Hecho (artifact versión 7):**
- Fines de carrera al **lado sur** de la chapa, a 3,5 cm (`KSW`): como la
  chapa va girada, quedan a −3,3 y +2,6 cm del eje de la viga. Cada uno en un
  **pie de planchuela de 50 mm** que cruza la viga con **dos M6 en fila**. La
  leva (M5) sale hacia el sur. El contacto camina 0 a 13 mm hacia el **norte**:
  la chapa se aleja de los switches (2,3 cm de luz).
- **Todo lo que va sobre la viga** (rodillos en ranura, motor, electrónica,
  batería, fines de carrera): dos M6 en fila sobre el eje del tubo, en
  **tuerca remache** (abajo está la planchuela de canto: no hay pasante).
  Bulones dibujados con arandela y cabeza. Ala apoyada del ángulo sur de cada
  rodillo hacia adentro (su M8 lleva tuerca abajo, sobre aire).
- Cables en **un mazo** en la cara sur del tubo, con un ramal por cosa.
- Detector: **un cable o una correa no sostienen** (además de «lo fijo no se
  apoya en lo que gira»). `window.__vns.sabotear('motor')` 7 de 7 y
  `sabotear('finales')` 6 de 6, y «restaurado: 0», con el 200 y el 12".
- Vista nueva **«Detalle: viga y bulones»**; texto de la pieza 13 contesta lo
  de la planchuela paralela: no hace falta. Requisitos §9, dos filas
  (L2-PLT-07, L2-PLT-09, L2-PLT-02, L2-PLT-13). VERDE; 13 OK.

## Decimocuarta sesión (2026-10-07, PC): v10.1, L1-29 y 30 contra 60 s

**Pedido de Fran:** «no importa el tiempo de pasar de 200 a otro»; «decime en
criollo qué costo tenemos para 60 segundos y cuál para el de 30 y orientame
para hacer el trade off»; «soluciona el artifact para que sea más coherente la
estructura» (captura del detalle rodillo y motor); «dale color al 300 mm
propuesto teórico, por más que no exista».

**Hecho:**
- **Modelo v10.1** (artifact `Sn7F7NGPrNdsJnwwnXTZfd`, **versión 6**, público
  con el link; se leyó la versión viva entera antes: era el v10 del repo, sin
  cambios de nadie). El motor colgaba de una planchuela apoyada en el **canto**
  del ángulo norte, en el aire, y su cable cruzaba en diagonal. Ahora: la
  planchuela del rodillo motriz **sigue al oeste** (una pieza en L, cuatro M8 a
  la viga), polea de 80 **al sur** del ángulo sur, **escuadra NEMA 17** (ala
  vertical con 4 M3, ala apoyada con 2 M5 en ranura que tensan la correa),
  motor apoyado en el ala. Electrónica al lado del rodillo motriz (`MOT.xEste`)
  y batería al lado; cables acostados sobre la viga y las planchuelas, con un
  ramal por escuadra a cada fin de carrera. **12" teórico sólido**: tubo
  violeta, caja oscura, aros, celda, araña, portaocular de 2", buscador
  (materiales `doce`, `doceIn`, `doceCaja`, `doceMet`, grado «en revisión»).
  Vista «Detalle: rodillo y motor» desde el sudoeste. «Piezas sueltas» =
  ninguna con el 200 y con el 12"; `geometria-vns.js` sin cambios (`?v=10`).
- **Requisitos**: L1-29 sin tope de 15 min, **definido** (Fran); §9 con la
  escuadra del motor (L2-PLT-02, L2-PLT-10); §11.1 pregunta 4 contestada.
  VERDE. Antes se leyeron GtWR, m21, m17 y NASA (lo exige la puerta).
- **`docs/14` §6b**: qué cuesta 30 y qué 60 s (la cuenta δ·15″/s·t; tabla con
  alineación, velocidad media, PEC, piezas, plata, ganancia en la foto,
  riesgo). **§6c**: la guía del trade F/T2 (precisión como piso; cuatro
  criterios con puntajes de la sesión; la regla `w1 − 2·w2 + w4`; el banco
  primero).
- Memoria `telescopio-300mm-decision` con las dos respuestas.

**Descubierto:** el error de la polea de 20 **no es chico por ser lento**: lo
que entra en un sub es δ·15″/s·t sin importar el período. Con 0,02 mm de
descentrado da 1,4″ en 30 s: la PEC deja de ser opcional en cuanto se pide
precisión fina. Lo lento sólo la hace **corregible**. Corrige la frase «los dos
más lentos que una foto: se calibran» del modelo y de `docs/14` §6, que leída
sola sugería que no molestaban.

**El detector de piezas sueltas estaba ciego en el motor** (regla 3, sabotaje):
sin la escuadra, el motor seguía «apoyado» en la caja envolvente de la chapa,
que gira. Arreglado en el detector (no en el caso): el apoyo tiene dirección,
de lo fijo a lo que gira y nunca al revés. `window.__vns.sabotearMotor()` saca
escuadra, bulones, correa y cable y sube el motor 5 mm: da **7 de 7 sueltas**
con los dos telescopios, y «ninguna» al restaurar. Lección 355 (nivel
herramienta), sumada a `chequeo-de-trabajo.md`. Ojo con lo que el detector
**no** mide: que la carga baje por algo que la aguante (el v10 daba «ninguna»
con el motor colgado del canto de un ángulo); eso se mira en las vistas de
detalle.

**No se hizo:** el trade (faltan 30/60 y los 10 puntos de Fran).
**Pendiente de Fran:** 30 o 60 s y los 10 puntos (`docs/14` §6c); la foto de
la tabla del vuelco; ¿viaja en auto?; ¿cuánto armado?; prueba de foco.

## Decimotercera sesión (2026-10-07, PC): la plataforma «terminada» v10

**Pedido de Fran:** que lo charlado se vea como **diseño preliminar** en el
artifact («método agile: iteraciones de diseño preliminar para definir el
concepto; lo visual nos convence, lo que importa es la física»), **nada
flotando**, con lo confirmado, probable y en revisión; y los Docs al día.
Memoria nueva: `feedback_diseno-preliminar-iterado`.

**Hecho (commits `7a23959`, `35bd41f`, `157bf72`):**
- **Modelo v10** publicado (https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd,
  versión 3; mismo tamaño que el repo + 552 B; **público con el link**, lo dice
  el publish). Mesa universal (tres largueros + tres rieles arriba, ≈ 87 cm N-S,
  11 kg), corredera con muescas (`dNEquilibrio` en `geometria-vns.js`, forma
  cerrada; `tabN` y `railH` nuevos, sin ellos es el v9), selector 200 / 12"
  fantasma, tres mordazas, chapa 5/16", electrónica + batería + botón + ST-4,
  marcas del piso, fines de carrera con escuadra a la viga, bujes de altura
  que llegan a la pared. Salen los 4 bulones y el suplemento. Panel: «Piezas
  sueltas» medido (grafo de contacto en pose alineada; 0, y 22 con el buje del
  v9 saboteado), «pintar por certeza», tabla de vuelco/empujón/kg por rodillo
  telescopio por telescopio, sección «Lo que importa: la física». Debug:
  `window.__vns` en la consola.
- **v10 en números** (`node docs/escenarios-300.js`, sección v10): muesca del
  200 a 2,8 cm al N (H 63); 200 H 58 → 10,1 N, H 69 → 5,9 S; 12" de 0,5 a
  18,8 N. Vuelco ≥ 22,0° en todos con base 1,2 m. **Único rojo: 12" liviano
  (40 kg, CdM 52), empujón 5,5 kg** contra 6 (L1-13): rodillos a 58 cm (6,3) y
  base 1,3 m lo arreglan; se decide con el 12" que se compre.
- **El dibujo del CdM**: `docs/dibujo-cdm.html` (fuente única) →
  `docs/dibujos-cdm.ps1` saca el PDF «Medir el centro de masa» (3 páginas,
  mirado; en el Drive, ID `1kPx-OkcUkqWhbzXTBoetQbI1jF6vZJop`, y enviado a
  Fran) y las 4 imágenes de `docs/img/`. `md-a-gdoc.py` las incrusta en base64
  (un Doc las guarda: probado con un borrador; imagen faltante = ROJO).
- **Docs**: «1 - El proyecto» v5 (07: el 300, mordazas, F con respaldo T2,
  Kevin K1-K9, grados, «dibujar para decidir») y «2 - Paso a paso» v4 (11: los
  dibujos, cuarta pregunta) regenerados con los mismos IDs. Cuaderno del 4/10
  → `Archivo/VIEJO (4-10, reemplazado por 1 y 2) - Cuaderno del proyecto`
  (mismo ID). La carpeta queda: 1, 2, el PDF, Archivo, Fotos.
- **Requisitos 0.2 contra el v10**: columna 3D, §9, §10 y cinco rationales;
  ningún enunciado cambió. VERDE.
- Lecciones 353-354 (perfil-global `a03fd13`): el detector por cajas
  envolventes se mide en pose alineada (el sabotaje lo destapó); un link a un
  artifact privado en un Doc compartido es un link roto.

**No se hizo:** el trade de la transmisión (espera 30/60 s y pesos de Fran).
**Pendiente de Fran:** medir con la hoja y mandar foto de la tabla; 30 o 60 s;
¿cuánto para pasar del 200 al 12"?; ¿viaja en auto?; ¿cuánto armado?; prueba
de foco.

## Duodécima sesión (2026-10-07, PC): el 300 mm, concepto y necesidades

**Pedido de Fran:** fase de concepto para que la plataforma sirva al 200 y a un
dobson de 300 mm de modelo desconocido, con los comentarios de Kevin (4
capturas de WhatsApp, transcriptas en `docs/14` §2; las imágenes no se
guardaron: estaban en Descargas).

**Hecho:**
- `docs/14-concepto-300mm.md`: los 12" del mercado (Flextube 300P SynScan 45
  kg, AD12/GSO 39 kg, XT12 38 kg, base 63-66 cm), la cinemática (la corredera
  va bajo el dobson, no en el pivote), alternativas U0-U3 y de transmisión
  F/B/T con números, material de las chapas (acero dulce vs inoxidable).
  Escenarios: `node docs/escenarios-300.js`.
- Respuestas de Fran: **U1** «correr y apretar»; **cualquiera, GoTo
  incluido**; «debe servir para ambos, aunque aumente la complejidad, no
  perdamos precisión» (memoria `telescopio-300mm-decision`).
- `docs/10-requisitos.md` **v0.2**: N-12, L0-15, L1-27 a L1-30, L2-PLT-05
  (rango de CdM 50-69), L2-PLT-14 a 16 (mesa 70 cm, posiciones marcadas ±2 mm,
  contacto ≤ 350 MPa → chapa 5/16"). VERDE. PDP §6: decisión nueva.
- Los Docs del Drive = repo (comparados palabra por palabra). El artifact
  `Sn7F7NGPrNdsJnwwnXTZfd` = repo (sha256 `7e0c9270…`). **Fran dice que lo hizo
  público: sin medir** (pedirle a Kevin que lo abra o una captura).
- Arreglos de método (regla 15): la cascada imprime lo que la puerta exige
  AL EDITAR los requisitos (lección 351: cinco Edit negados en paralelo); la
  puerta reconoce lo leído por contenido (la reinstalación corría las líneas,
  dos sesiones seguidas). Tercera reincidencia del `git checkout` que se lleva
  lo sin commitear (lección 352): chip de tarea para el guardia.

**Después, en la misma sesión:** Kevin mandó dos preguntas más (transcriptas
en `docs/14` §2): rodillo o canto de goma (no: K8) y una rosca hecha por un
tornero como la plataforma de una foto (no conviene: K9; si va tornillo,
uno de bolas comprado, T2). **Fran decidió: el dobson no se agujerea**, algo
adaptable → L2-PLT-17 y tres mordazas de borde (`docs/14` §5b). La sesión
propone **F** como transmisión (respaldo T2). Fran pidió seguir en una sesión
nueva con: el dibujo del CdM primero, el modelo con la propuesta y los Docs.
El rojo del arranque al reanudar era la memoria nueva sin espejo para la nube
(`estado-nube.py --sincronizar-memoria`): arreglado.

**No se hizo:** el dibujo del CdM, el modelo con la mesa universal y las 3
mordazas, los Docs con el 300. **Abierto para Fran y Kevin:** 30 o 60 s
(decide la transmisión); §11.1 de `10` (fijación del 300, tiempo de cambio,
auto, armado); el vuelco y la altura del eje.

## Undécima sesión (2026-10-07, PC): el borrador de requisitos

**Hecho, y certificado:** `docs/10-requisitos.md` v0.1 — 11 necesidades, 14 de
misión, 26 de sistema, 27 de elementos (PLT 13, MON 6, CAM 4, OPE 4), cada uno
con tipo, padre, método de verificación, estado y columna 3D; rationale por
ID; KDR L1-01, L1-02, L1-15, L1-22; metas «debería» de Kevin y del 12"; la
traza inversa del diseño v9 (§9). `python docs/verificar-requisitos.py`:
VERDE; `--autotest`: BIEN. Engancho los dos en `chequeo-completo.ps1`.

**Lo que destapó y se arregló más arriba (regla 15):**

- El chequeo del GtWR era **ciego a las tildes**: «deberá» daba R1 VIOLA y
  «rápido» pasaba sin marcar. Lo vio el borrador de tres líneas antes del
  documento. Arreglado en `verificar-requisito.py` con su prueba en rojo antes
  (perfil-global `63b324b`). R16 deja pasar la cota con número («no más de 50
  kg»), angosta.
- **Cuatro llamadas negadas por la puerta al abrir** (Fran las vio como
  «Fallido»): la puerta niega por el PEDIDO, no por la ruta. El aviso CASCADA
  ahora lo dice antes de actuar (claude-acceso `a85a14e`). Y tres de los siete
  «Fallido» eran rojos buscados: regla nueva, se imprime el código y la
  llamada cierra en 0. Lecciones 348-350, con sus líneas en el chequeo.
- El rojo del perfil en el arranque (`verify-install` exit 1) **no se
  reprodujo** en tres corridas: `hipótesis`, algo concurrente del arranque.
  Si vuelve, se mira la salida del arranque, no se re-corre a ciegas.

**Del modelo v9 (cálculo, `geometria-vns.js`):** mesa a 22,6 cm del piso,
inclinación 9,3° a los 45 min y 10,5° en el talón, vuelco 24,1° al sur y de
costado, empujón 6,9 kg. **El v9 incumple L2-PLT-12** (4 bulones del dobson).

**No se hizo** (queda para la próxima, en este orden): (a) el modelo sin piezas
volando y con 3 bulones (cita L2-PLT-12); (b) los dibujos del CdM en los Docs
y el Drive simplificado (cita L1-15).

**Pendiente de Fran:** el vuelco (hA, hB, A, B, W) y la altura del eje; la
prueba de foco; y §11.1 de los requisitos: 30 o 60 s, ¿viaja en auto?,
¿cuánto armado?

### El artifact y el pase de cuenta (medido el 2026-10-07, 12:00)

**La fuente es el repo** (`docs/06-modelo-3d.html` + `docs/geometria-vns.js`,
último cambio `406799d`). Las copias publicadas, por cuenta:

| Cuenta | Link | Versión | Medido |
|---|---|---|---|
| Agus y Fran (la de esta sesión) | https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd | **v9 = repo** | `geometria-vns.js` con el mismo sha256 (`7e0c9270…`); la página publicada contiene la del repo y suma 552 B del envoltorio de la publicación |
| Fran personal | https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM | **v8, atrasada** | desde esta cuenta no se puede publicar ahí |

**Medido por Fran el 2026-10-07 12:10 (captura): el link del Doc da «Página no
encontrada» desde su cuenta personal.** Un artifact es privado de la cuenta
que lo publica: el link de los Docs (que lee Kevin) no lo ve nadie más hasta
que el dueño lo comparta desde claude.ai (botón Compartir del artifact). Lección
a registrar en la próxima sesión: un link a un artifact privado en un Doc
compartido es un link roto para cada lector; se comparte ANTES de pegarlo, y
se prueba desde otra cuenta.

**Pase para cuando vuelvas a tu cuenta de Fran** (lo hace la sesión, no vos).
Antes de la tarea, en la sesión de la cuenta personal:

1. `Artifact read` de `https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM`
   (exigido antes de publicar encima).
2. Publicar con `url` = ese link, `file_path` = `docs/06-modelo-3d.html` y
   `files` = `{"geometria-vns.js": "docs/geometria-vns.js"}`.
3. Medir el efecto: `Artifact read` con `paths` `["geometria-vns.js"]` y
   comparar el sha256 contra el del repo. Iguales = sincronizado.
4. Desde ahí, **el link vigente es el de la cuenta en la que se trabaja**; el
   de la otra cuenta queda atrasado hasta el próximo pase. Actualizar la línea
   de `CLAUDE.md` del proyecto y el link de los Docs «1 - El proyecto» y «2 -
   Paso a paso» si cambia el link vigente.

Lo que **no** cambia con la cuenta: el repo, la memoria de la PC
(`~/.claude/projects/...`), el perfil y el Drive (rclone usa su propio token,
no el conector de claude.ai). Lo que **sí** cambia: los artifacts, los
conectores de claude.ai y el límite del plan.

### Mensaje de retome (chat nuevo)

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso, en la PC.
ABRIR LA SESION EN C:\Users\frans\Desktop\claude-acceso.
SI LA SESION ES DE LA CUENTA PERSONAL DE FRAN: primero el "pase de cuenta" de
HANDOFF.md (publicar el v9 en K4hfyQRik4xsJYYXv5sFeM y medir el sha256).
Modelo: Opus, esfuerzo medio, SIN fan-out: es diseno contra requisitos ya escritos
(un hilo); el esfuerzo alto era para escribirlos.

0. EL LIBRO: si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh y leer lo que liste.
1. PRIMERA LLAMADA, SOLA, SIN NADA EN PARALELO:
   .\cascada.ps1 telescopio -Necesidad diseno
   y leer con Read TODO lo que exija (incluye docs/10-requisitos.md entero, que ahora
   es base). Hasta declararla la puerta niega todo Bash/PowerShell/Write/Edit.
   Un verificador corrido ESPERANDO su rojo imprime el codigo y cierra en 0.
2. Leer: ESTADO_ACTUAL.md, el bloque "Undecima sesion" de HANDOFF.md. NO leer CAD,
   macro VBA ni fotos. 06-modelo-3d.html y geometria-vns.js solo al tocarlos (si
   cambia geometria-vns.js, subir el ?v= del <script>, hoy 9).
3. Fase 0 (Pre-Phase A). Van 2 de 4 (arquitectura VNS; borrador de requisitos en
   verde). La cierran: el CdM por 2 metodos, la prueba de foco y el inventario sin "?".
4. Estado: concepto v9. Masa ~40 kg, CdM ~63 cm (58-69) SIN medir. NO HAY PLANOS.
   Artifact v9: https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd -> pasar url,
   leerlo antes, publicar con files {"geometria-vns.js": docs/geometria-vns.js}.
   Local: preview_start "telescopio-modelo" (8765). Controles:
   node docs/probar-geometria.js ; python docs/verificar-requisitos.py (--autotest).
   Drive: "1 - El proyecto" (07, ID 1wrzPpizxcblHVY3Zd1vyjZxawaTfdZc2wzDKFsbEwTw),
   "2 - Paso a paso" (11, ID 1rpFTUuDcQvkzbma_9PBBHFBuVl9N3Tce_U9WsTQoUs0), Cuaderno viejo
   (ID 1Gqf00K3lqZJJkfu8lIKZxhDSEzKbtj2tO4Do6BFz-R4). python docs/md-a-gdoc.py <md> <html>
   + rclone copyto --config ~/.config/rclone/rclone.conf --drive-import-formats html
   --drive-export-formats html al mismo nombre; verificar el ID con rclone lsf --format pi.
5. Resuelto, no se rehace: VNS, espejo sur, limites 45/48/51, geometria del dobson,
   pesadas, docs/12 corregido por 13, el contacto camina para un lado, sin engranajes
   de casetera, el 12" no se disena, LOS REQUISITOS v0.1 (se editan, no se reescriben).
6. PRIMER PASO: (a) el modelo sin piezas volando (eje y barra del motor con soporte) y
   con 3 bulones con mariposa en el dobson -> commit citando L2-PLT-12 (y la columna 3D
   de 10-requisitos.md pasa a "si"). (b) dibujos del CdM en los Docs (probar antes con un
   borrador de tres lineas si un Doc acepta imagenes) y el Drive simplificado (el
   Cuaderno del 4/10 dice "CS o VNS abierta" y "50 kg") -> commit citando L1-15.
   Pendiente de Fran, URGENTE: vuelco (hA, hB, A, B, W), altura del eje, prueba de foco,
   y las 3 preguntas de 10-requisitos.md sec. 11.1. Si dice que lo hizo y la sesion no
   puede medir el efecto, pedirle captura.
7. Al cerrar: ESTADO + HANDOFF + commit + push, y despues
   python auditar-sesion.py --de-fran "que | evidencia" --escribir  (en claude-acceso).
   EFECTO a ver: P7 en VERDE para cada commit de diseno, ningun ROJO, y las llamadas
   negadas por la puerta en 0 (hoy fueron 7: 4 por actuar antes de declarar o de leer, y 3 por releer un rango que la reinstalacion del perfil corrio). El informe va en su commit.
```

## Décima sesión (2026-10-07, PC): la arquitectura del método, no el telescopio

Fran pidió dibujos del CdM en los Docs, ordenar el Drive y soportes y bulones en
el modelo. Al ir a mirar el modelo antes que el papel que define el proyecto,
cortó: **«te pasé libros de cómo escribir buenos requerimientos y no los usás:
es una falla arquitectónica»**. Nueve sesiones diseñaron sin requisitos. La
sesión se dedicó a arreglar eso en el método (regla 15) y **no tocó el diseño
del telescopio**. Lo que quedó, todo probado con sabotajes y controles:

- **El libro primero:** `perfil-global/pilares/nucleo-ise.md` (fases NASA,
  requisitos con cátedra + GtWR + NASA, arquitectura, V&V, índice del resto)
  encabeza la cascada de todo proyecto.
- **Sin requisitos no se diseña:** el telescopio declara `docs/10-requisitos.md`;
  mientras no exista, la puerta niega todo menos escribirlo y el registro
  (ESTADO, HANDOFF, PDP). Escribirlo exige el GtWR, la cátedra (m17, m21) y
  NASA. Formato de ID: `N-01`, `L0-01`, `L1-01`, `L2-PLT-01`.
- **La puerta corre desde cualquier carpeta** (`puerta-afuera.py`, del perfil)
  y **por su lanzador** (`.claude/hooks/puerta-lanzador.py`): si revienta,
  niega todo salvo repararla. Pasó de verdad: una edición a medias rompió la
  puerta y encerró a la sesión; Fran pegó el comando que la destrabó (captura:
  `quitadas 1 quedan 0`).
- **La auditoría de sesión** (lo que Fran pidió: preguntas con respuestas
  trazables «como un capacitor de la Voyager»): `python auditar-sesion.py`
  contesta P1-P11 desde la caja negra de la puerta, git, los requisitos y las
  lecciones. Se corre al cerrar, con `--escribir`.
- **PDP §4:** la fase 0 cierra también con el **borrador de requisitos**
  (NASA Pre-A: *draft system-level requirements*).
- **Regla nueva (Fran):** lo que Fran ejecuta se confirma con evidencia; si la
  sesión no puede medir el efecto, frena y le pide captura.

**Lo que Fran pidió y quedó para la próxima, en este orden** (cada commit de
diseño cita los IDs que cumple):

1. `docs/10-requisitos.md`: necesidades → L0 → L1 → L2 por elemento (PLT
   plataforma, MON montura, CAM tren de imagen, OPE operación), con tipo, padre,
   rationale, método de verificación, `TBD`/`TBR`, qué falta especificar y qué
   ya representa el modelo 3D (demostrativo para Fran).
2. Los dibujos del CdM en los Docs del Drive (probar antes si un Doc acepta
   imágenes con un borrador de tres líneas); leer el Drive entero y
   simplificarlo: el **Cuaderno** (ID `1Gqf00K3lqZJJkfu8lIKZxhDSEzKbtj2tO4Do6BFz-R4`)
   es del 4/10, no tiene fuente en el repo y está viejo («CS o VNS abierta»,
   «50 kg»); en *Archivo*, el Doc de la plataforma de hierro (`09`) quedó atrás
   del repo.
3. El modelo sin piezas volando (la captura de Fran: el eje y la barra del
   motor sin soporte), con sus soportes y los **3 bulones con mariposa** de
   Kevin (el modelo y los docs dicen 4).

**Pendiente de Fran, URGENTE:** el vuelco (hA, hB, A, B, W) y la altura del eje.
Al 7/10 no hay medidas nuevas.

### Mensaje de retome de la décima (YA EJECUTADO por la undécima: no usar)

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso, en la PC.
ABRIR LA SESION EN C:\Users\frans\Desktop\claude-acceso (si se abre en otra carpeta
corre la puerta, pero no el arranque).
Modelo: Opus, esfuerzo alto, SIN fan-out: escribir los requisitos es arquitectura y
decide todo lo que viene; un solo hilo, profundidad.

0. EL LIBRO: si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh y leer lo que liste. Despues: git fetch origin; si
   una rama claude/* tiene commits del telescopio fuera de main, traerla.
1. .\cascada.ps1 telescopio -Necesidad diseno  y leer TODO lo que exija, empezando por
   perfil-global/pilares/nucleo-ise.md. Va a decir "SIN REQUISITOS": es correcto.
2. Leer ENTERO: ESTADO_ACTUAL.md, el bloque "Decima sesion" de HANDOFF.md,
   docs/01-conops.md, docs/13-revision-externa.md, PDP.md secciones 1 a 4.
   Al crear docs/10-requisitos.md la puerta exige (concepto requisitos): GtWR reglas.md
   sec. 1-3, la catedra m21 entero y m17 (niveles), NASA requisitos.md sec. 5-14.
   NO leer CAD, macro VBA ni fotos. 06-modelo-3d.html y geometria-vns.js solo al
   tocarlos (si cambia geometria-vns.js, subir el ?v= del <script>, hoy 9).
3. Fase 0 (Pre-Phase A). La cierra (PDP sec. 4): CdM por 2 metodos, inventario sin "?",
   la arquitectura (ya: VNS) y el BORRADOR DE REQUISITOS docs/10-requisitos.md:
   N-xx -> L0 -> L1 -> L2 por elemento (PLT, MON, CAM, OPE); cada uno con tipo
   (funcional, desempeno, restriccion, interfaz, ambiental, otros), padre, rationale,
   metodo de verificacion (ensayo, analisis, inspeccion, demostracion), estado
   (TBD/TBR/definido) y si el modelo 3D lo representa. Se certifica con
   python perfil-global/pilares/incose-gtwr/verificar-requisito.py <archivo> --idioma es
   sin VIOLA (un requisito por linea: extraer la columna de enunciados a un .txt).
4. Estado: concepto v9 (docs/13). Masa ~40 kg, CdM ~63 cm (58-69) SIN medir. NO HAY PLANOS.
   Artifact v9 (cuenta de Agus y Fran): https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd
   -> pasar url, leerlo antes, publicar con files {"geometria-vns.js": docs/geometria-vns.js}.
   Local: preview_start "telescopio-modelo" (8765). Controles: node docs/probar-geometria.js.
   Drive: "1 - El proyecto" (07, ID 1wrzPpizxcblHVY3Zd1vyjZxawaTfdZc2wzDKFsbEwTw),
   "2 - Paso a paso" (11, ID 1rpFTUuDcQvkzbma_9PBBHFBuVl9N3Tce_U9WsTQoUs0), Cuaderno viejo
   (ID 1Gqf00K3lqZJJkfu8lIKZxhDSEzKbtj2tO4Do6BFz-R4). python docs/md-a-gdoc.py <md> <html>
   + rclone copyto --config ~/.config/rclone/rclone.conf --drive-import-formats html
   --drive-export-formats html al mismo nombre; verificar el ID con rclone lsf --format pi.
5. Resuelto, no se rehace: VNS, espejo sur, limites 45/48/51, geometria del dobson,
   pesadas, docs/12 corregido por 13, sin deslizamiento lateral, el contacto camina para
   un lado, sin engranajes de casetera, el 12" no se disena. Y el metodo (decima sesion):
   el libro primero, sin requisitos no se disena, la puerta corre afuera y por su
   lanzador, y la sesion se audita al cerrar.
6. PRIMER PASO: escribir docs/10-requisitos.md. Despues, cada commit citando los IDs que
   cumple: (a) dibujos del CdM en los Docs + leer y simplificar el Drive; (b) el modelo
   sin piezas volando, con soportes y los 3 bulones con mariposa de Kevin.
   Pendiente de Fran, URGENTE: vuelco (hA, hB, A, B, W) y altura del eje. Si dice que lo
   hizo y la sesion no puede medir el efecto, pedirle captura.
7. Al cerrar: ESTADO + HANDOFF + commit + push, y despues
   python auditar-sesion.py --de-fran "que | evidencia" --escribir  (en claude-acceso).
   EFECTO a ver: P7 en VERDE para cada commit de diseno y ningun ROJO; el informe va
   en su commit.
```

## Novena sesión (2026-10-07, PC): revisión de afuera y modelo v9

- **Nube traída**: la rama `claude/eloquent-meitner-7ubqo3` (sesión 8,
  `docs/12`) entró a `main` por fast-forward. Ninguna otra rama remota tiene
  commits del telescopio fuera de `main` (medido).
- **Revisión de afuera**: `docs/13-revision-externa.md`. Arquitectura bien;
  proceso flojo (8 sesiones de diseño, 0 mediciones del CdM). Corregidos: el
  rodillo de 40 (el contacto camina para UN lado: 0 a 12,6 mm), el ángulo de
  vuelco esperado (≈ 24°, no 34°) y la polea de v8 montada en un rodillo loco.
  Verificado que **no hay deslizamiento lateral** en el rodillo (la chapa avanza
  en la dirección en que gira) y que el radio del rodillo sólo corre la mesa
  0,4 mm constantes.
- **Mecanismo**: rodillo motriz de acero torneado fijo a un eje de 8 mm
  (varilla de impresora) en dos 608; rodillo loco de cuatro 608 de roller en
  varilla de impresora; GT2 20:80 comprada; engranajes y correas de casetera
  NO van en la transmisión. Dos piezas de precisión: el canto de las chapas
  (láser, sin lima) y el rodillo motriz (torno).
- **Estructura** con lo que hay (tubo 20 × 20): tubo solo donde la luz es
  corta; tubo + planchuela de canto en la viga sur de la base y en el brazo.
  Mesa en H + A. Rodillos a **50 cm** (la mesa aguanta 6,9 kg de empujón).
- **Fran (2026-10-07)**: «planos sólo si hay partes aprobadas; si no, sigamos
  las fases NASA» → **no se hicieron planos**. Un 12" «quizás algún día» → no
  se diseña; tres puertas abiertas (PDP §6).
- **Geometría**: `geometria-vns.js` devuelve el recorrido del contacto con
  signo (`latLo/latHi/latSwing/latCenter`), el ancho de rodillo que hace falta
  (`rollNeed`, `rollOK`) y el empujón que levanta la mesa (`empujeMesa`).
  Controles: 12 verdes, sabotajes en rojo. `?v=9`.
- **Modelo v9** publicado **desde esta cuenta**:
  https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd. El de la cuenta personal
  (`K4hfyQRik4xsJYYXv5sFeM`) quedó en v8: se actualiza sólo desde esa cuenta,
  con `url` y leyéndolo antes. Trae capas, bulones, unidades de rodillo y los
  dibujos del vuelco y de h_eje.
- **Docs**: `07` v4 y `11` v3 reescritos y subidos al Drive (mismos IDs,
  medidos). `03`, `09`, `12` y el contrato, alineados. PDP: R5 reescrito, R9 y
  R10 nuevos, tres decisiones nuevas.

## Arrancá por acá

1. `.\cascada.ps1 telescopio -Necesidad diseno` y leer lo que exija.
2. `ESTADO_ACTUAL.md` entero, `docs/13-revision-externa.md` entero y
   `docs/11-paso-a-paso.md` (v3).
3. **Preguntarle a Fran qué trajo de los pasos 1 a 6** (hA, hB, A, B, W,
   h_eje; el inventario; 30 o 60 s; si el amigo tiene torno). Con hA/hB/W/h_eje:
   `h_montura = W / (tan A + tan B)`, `A = asen(hA/W)`,
   `H = (19,2 h_eje + 19,7 h_montura) / 38,9`; si cae en 58-69, cierra el CdM
   por dos métodos. **No diseñar antes de eso.**

## Octava sesión (2026-10-07, nube): crítica de la arquitectura y método de vuelco

**Lo vigente está en `docs/12-critica-y-medicion.md`; leerlo ENTERO antes que
lo de abajo.** Cambia: chapas de **acero** de 6–8 mm y rodillos de **acero
torneado** (el PETG fluye a 42 MPa, el acero marca el aluminio); tracción por
**fricción**, no varilla (error periódico de ≈ 1 min, 40 veces peor);
**tubos** en lugar de planchuela de canto; ESP32 desde el arranque; rodillo
de ≥ 40 mm (`latMax` ±13,7, a confirmar). Medición: **vuelco sobre dos
cantos** + h_eje con cinta reemplazan la tabla y el «todo plano».
**Pendiente de Fran:** qué dobson futuro como máximo (fija H y la carga).
**Falta hacer (la sesión):** dibujos en perspectiva de la medición, modelo v9,
planos por capa y reescribir `11-paso-a-paso.md`. Ninguno se hizo: el plan de
Fran estaba agotado. (La novena sesión los hizo, salvo los planos: ver arriba.)

## Séptima sesión (2026-10-05, noche): observaciones de Kevin y documentos

- Fran: «las planchuelas se sueldan, o abulonan si vos lo recomendás»; **cámara
  y enfocador aparcados**; quiere los documentos del Drive con **concepto
  separado de pasos**, y los pasos claros, en orden y en criollo.
- Kevin (4 observaciones): base cuadrada más grande → **se evaluó con números**
  (`node docs/estabilidad-base.js`): queda el **triángulo, de 1,2 m de ancho**
  (costado 17,8° → 25,0°, sur 24,4°); fijación del dobson con bujes y mariposas
  → adoptada (ranuras en los largueros, FAB-8); topes del motor → ya estaban
  (tres capas), con la trampa hallada: capas 1 y 2 en el mismo Arduino
  (mejorar en fase 3 con switch NC en el EN del driver); pantalla + Bluetooth →
  fase 3 (ESP32).
- **Soldar** lo fijo, **abulonar** lo que se desarma/ajusta (`09`).
- **Motor** (pasó 4 publicaciones): se recomienda el de ≈ 4 kg·cm (Usongshine
  tipo 17HS4401, $24.640 ML FULL); el 17HS2408S de $18.200 (1,6 kg·cm) deja 2,6×
  de margen contra viento y se descartó (`09`, sección Motor). Precios y datos son los de
  las publicaciones: verificar al comprar.
- **Segundo método del CdM = P3 con la caja puesta** (da la altura, que es la
  duda); P4 plano queda de control; ya no se pesa la caja sola.
- **Modelo v8** (mismo link): slider «Ancho de la base» (default 120) y fila
  de vuelco; `?v=8`; controles: 9 verdes, 7 sabotajes en rojo.
- **Drive:** la guía vieja (ID `1wrzP…`) se **renombró** a «1 - El proyecto -
  concepto y diseno» (mismo ID, mismo link de Kevin) y se creó «2 - Paso a paso -
  que hacer y en que orden» (ID `1rpFTUuDcQvkzbma_9PBBHFBuVl9N3Tce_U9WsTQoUs0`).
  Regenerados: Medidas, Plataforma de hierro, Protocolo. Todos con los IDs de
  antes (medido). El permiso de Kevin se hereda de la carpeta.
- Inventario: M3, M6, M8, M9 pasan a `no aplica` (con su motivo); cámara y óptica
  marcadas como aparcadas, **no cerradas**.

- **Simplificado a pedido de Fran («son 6 docs, no dan ganas de leer»):** la
  carpeta del Drive queda con **2 Docs a la vista** («1 - El proyecto», ~2
  páginas; «2 - Paso a paso», ~3) y el Cuaderno; Medidas, Plataforma de hierro y
  Protocolo se mudaron (mismos IDs) a la subcarpeta «Archivo (referencia, no hace
  falta leer)». `07` y `11` se acortaron: las cuentas finas viven en `09`.
  Los .md del repo siguen completos; no se tocó nada más.

## Lo que se hizo y no se rehace

- **VNS elegido** (Fran) y trade study escrito: `docs/05-trade-study.md`.
- **Modelo 3D calculado**: `docs/06-modelo-3d.html`, publicado en
  https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM (privado: Fran lo comparte
  desde el menú Compartir). Explica cada pieza en criollo, trae la lista de
  compras con proveedores de zona norte y precios vistos el 2026-10-04.
- **La geometría es una sola fuente**: `docs/geometria-vns.js` (función pura
  `computeVNS`). La página la carga como archivo aparte. Controles:
  `node docs/probar-geometria.js` (6 verdes, 4 sabotajes que tienen que dar
  rojo). Verlo en local: `preview_start` con `telescopio-modelo`
  (`.claude/launch.json`, sirve `docs/` en el puerto 8765).
- **Corregido:** en el sur el VNS va espejado (pivote al norte, segmentos al
  sur). `04-conceptos.md` decía «sectores norte».

## Versión 2 del modelo (misma sesión, más tarde)

Colores por familia de pieza con leyenda; rodillo impreso con sus dos 608ZZ;
motor NEMA 17 con poleas GT2 20:80 y correa; tubo completo con araña,
primario, portaocular y buscador (estos dos, ubicados a ojo); sombras; vistas
de detalle; plano acotado de la chapa (las dos son espejo exacto, verificado);
botón «Valores de agosto» (los valores nunca se guardan: recargar los
restaura). Kevin (primo, dueño de la ZV-E10) imprimió un adaptador al
portaocular y dice que «se ve sin aumento»: ver la fila de foco en
`ESTADO_ACTUAL.md`. Inventario: B2, O2 y T3 actualizados.

## Versión 3 y la carpeta con Kevin (tercera sesión del día)

- **Límites de carrera en tres capas** en la geometría y el modelo (v3,
  mismo link): programa ±45, fin de carrera ±48, talón ±51 min. Control
  nuevo en `probar-geometria.js` (7 verdes, 5 sabotajes en rojo).
- **Saturno y la Barlow:** lo de Kevin era mirando Saturno; ahora es
  `probable` que sí llegue a foco. Falta su respuesta: ¿se veían los anillos?
- **Drive:** carpeta `05 - PROYECTOS - taller y astronomia/Telescopio
  200-1200 - Fran y Kevin`, Kevin **editor** (declarado por hash). Adentro:
  cuaderno (mudado ahí), «Guia de armado y lista de materiales» y «Protocolo
  de medicion», los dos generados con `docs/md-a-gdoc.py` desde el .md y
  subidos con rclone (`--drive-import-formats html --drive-export-formats
  html`; sin el segundo flag falla). **Ojo al regenerar:** rclone empareja por
  nombre; verificar que el ID del Doc sea el mismo (guía:
  `1wrzPpizxcblHVY3Zd1vyjZxawaTfdZc2wzDKFsbEwTw`).
- **Pedido de Fran para el PDF de la guía:** formato de apunte (Typst),
  criollo y didáctico, con la parte de fabricación y calibración en registro
  formal (FAB-n / CAL-n). La §5 de `07-guia-armado.md` ya está así.
- **El artifact NO se puede compartir desde la sesión**: lo comparte Fran
  desde el botón Compartir de la página.

## Versión 4: el dobson medido (cuarta sesión del día)

- Fran midió con cinta todas las tablas, la caja y el tubo, y mandó 71 fotos:
  registro en `docs/08-medidas.md`; fotos en `fotos/2026-10-04/` (ignorada)
  y en el Drive. Cargado en el modelo (v4, mismo link, que Fran ya compartió
  «cualquiera con el link»).
- **Masa estimada por volumen: 27 kg (22-32)**, no 45-50; centro de masa
  ≈ 60 cm sobre el piso del dobson (58-61), suponiendo el tubo balanceado.
  `python docs/estimar-cdm.py`. Valores por defecto del modelo: M 27,
  CdM 60, eje 62, suplemento 2 → base 1,39 m, chapa 371 (+16) × 106 mm.
- De las fotos (`hipótesis`): portaocular **helicoidal 1,25"** (poco
  recorrido: candidato a explicar un «no llega a foco»); motor de la
  impresora Mitsumi M28N-1, probablemente **de continua**, no sirve; su
  varilla guía de 8 mm sí sirve de eje de rodillo.
- **rclone `copyto` con el mismo nombre actualiza el Doc en el lugar** (ID de
  la guía igual antes y después, medido). Doc nuevo: «Medidas y lo que falta
  pesar» (`1qQ8hjG0Uh0pM2sKYlXE0ofKvwfIoPKN_eY18gjtar7A`).

## Pesadas por partes (quinta sesión, 2026-10-05)

- Tubo 19,2 kg (19,7 con cámara y soporte), montura 19,7: suman 38,9 contra
  40 del total con ocular → masa ≈ 40 kg, `probable` (`08-medidas.md` §3.2).
- Tubo **balanceado** en el eje de altura (Fran corrió el tubo en la caja).
- La caja quedó con la montura (no se pesó aparte); montura de **pino** →
  densidad aparente 620 (2-5 kg de herrajes), caja ≈ 4,6 kg estimada.
  **CdM ≈ 63 cm** (58-69) compuesto: `python docs/estimar-cdm.py`.
- **Modelo v6** (CdM 63, eje 65): base 1,43 m, chapas 398 × 106. Guía,
  medidas e inventario actualizados; Docs del Drive regenerados.
- **Motor de casetera** (Sankyo de cabrestante «− + H L» y SHU2L-00-2X24A):
  de continua, no sirven para seguir. El NEMA 17 se compra (inventario E4).
- El tubo se balanceó **sin** la cámara: rebalancear con ella (1-2 cm).
- Pivote: Fran propuso una rótula de suspensión de auto y le preocupa el
  rozamiento. La guía ya pedía la de **amortiguador a gas** en un cono;
  quedó escrito por qué la de suspensión no va y que el rozamiento no es el
  problema (`07-guia-armado.md` §3, ítem 3). Alternativa: terminal de
  rótula M8.

## Plataforma de hierro (sexta sesión, 2026-10-05)

- Fran: la plataforma de **planchuela de hierro** (tienen de 30, 40, 50 y
  60 mm, menos de 1 cm de espesor), no de madera. Kevin: base **triangular**
  con refuerzos. Escrito en `docs/09-estructura-hierro.md`.
- **Hallazgo:** la mesa de hierro (≈ 8 kg, estimado) gira con el telescopio:
  el eje va al CdM de TODO lo que gira → **≈ 54 cm** sobre la mesa (no 65).
  Ignorarlo deja 9 cm fuera del eje y ≈ 7 N·m que cambian de signo en el
  medio de la carrera. `geometria-vns.js` tiene ahora `mTab`, `zTab` y
  devuelve `Cg`, `Mtot`, `Hbal`; control nuevo con sabotaje (8 OK). La base
  y la mesa ahora tienen el canto de la planchuela (BASE 50, TAB 40 mm).
- **Poste del pivote: 10 cm** (barrido 0-30 en la doc 09): base 1,16 m,
  vuelco 17,8°, ≈ 15 kg en el pivote.
- **Modelo v7** publicado (mismo link): triángulo, cartelas, poste con
  riendas, mesa en marco, brazo en A, slider de masa de mesa.
- **Trampa pagada:** el navegador usaba la copia vieja de `geometria-vns.js`
  y la página se rompía. El `<script>` lleva `?v=7`: subirlo cada vez que
  cambia la geometría (está en el contrato).

## Lo que quedó a medias

- **Pendiente de Fran:** los pasos 1 a 7 de `11-paso-a-paso.md`; el puesto 3 de
  los pesos; y, **sólo cuando él quiera**, la cámara (P0, que es compuerta antes
  de comprar el aluminio).
- **El primo:** editor de la carpeta de Drive. El artifact lo comparte Fran desde
  su menú; la sesión no puede. El mail **no** va al repo (público): sólo su hash.
  Kevin: ¿se veían los anillos de Saturno? (P0, aparcada) y el rodillo de prueba.
- **PDF de la guía** en formato apunte (Typst): cuando haya medidas cerradas.
- **Precios a cotizar:** corte láser, rulemanes, rótula, TMC2209, ESP32.
- **Mejora de la fase 3:** el switch de fin de carrera por hardware (NC en el
  habilitar del driver) y cómo se sale del tope.
- **El modelo SolidWorks no se revisó pieza por pieza.**

## Mensaje de retome de la novena sesión (SUPERADO por el de la décima, arriba)

Escrito el 2026-10-07 (novena sesión), sin recortes:

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso, en la PC.
Modelo: Opus, esfuerzo medium, SIN fan-out: cerrar el CdM con datos y la revision
de fase; sube a high solo si una medicion cambia la arquitectura.

0. EL LIBRO: si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh (desde claude-acceso) y leer lo que liste.
   Despues: git fetch origin; si alguna rama claude/* tiene commits del telescopio
   fuera de main (git log main..<rama> -- proyectos/ingenieria/telescopio), traerla.
1. .\cascada.ps1 telescopio -Necesidad diseno  y leer TODO lo que exija.
2. Leer ENTERO: ESTADO_ACTUAL.md, docs/13-revision-externa.md (manda sobre 12),
   el bloque "Novena sesion" de HANDOFF.md, docs/11-paso-a-paso.md (v3).
   NO leer CAD, macro VBA ni fotos. 06-modelo-3d.html y geometria-vns.js solo al
   tocarlos (si cambia geometria-vns.js, subir el ?v= del <script>, hoy 9).
3. Fase 0 (Pre-Fase A). La cierra: CdM por 2 metodos que coinciden (vuelco + h_eje
   contra la composicion de pesadas 58-69; la tabla de canos solo de desempate),
   P0 foco (aparcada; compuerta antes de mandar a cortar las chapas), inventario
   sin "?", y la revision de cierre con Fran y Kevin.
4. Estado: concepto v9 (docs/13): chapas acero 1/4" laser, rodillo motriz torneado
   fijo a eje de 8 mm en dos 608, rodillo loco 4x608 en varilla de impresora,
   GT2 20:80, ESP32, tubo 20x20 con vigas compuestas (viga sur y brazo), mesa H+A,
   rodillos a 50 cm, poste 10 cm. Masa ~40 kg, CdM ~63 cm (58-69). NO HAY PLANOS
   (Fran: solo con partes aprobadas). Artifact v9 en la cuenta de Agus y Fran:
   https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd -> desde otra conversacion
   pasar url, leerlo antes, publicar con files {"geometria-vns.js": docs/geometria-vns.js}.
   El de la cuenta personal (K4hfyQRik4xsJYYXv5sFeM) quedo en v8.
   Local: preview_start "telescopio-modelo" (8765).
   Controles: node docs/probar-geometria.js (12 OK, sabotajes en rojo).
   Drive: "1 - El proyecto" (07, ID 1wrzPpizxcblHVY3Zd1vyjZxawaTfdZc2wzDKFsbEwTw) y
   "2 - Paso a paso" (11, ID 1rpFTUuDcQvkzbma_9PBBHFBuVl9N3Tce_U9WsTQoUs0):
   python docs/md-a-gdoc.py <md> <html> + rclone copyto --config ~/.config/rclone/rclone.conf
   --drive-import-formats html --drive-export-formats html al mismo nombre;
   verificar el ID con rclone lsf --format pi.
5. Resuelto, no se rehace: VNS, espejo sur, limites 45/48/51, geometria del dobson,
   pesadas, docs/12 corregido por 13, no hay deslizamiento lateral, el contacto
   camina para un lado (rodillo de 28-30 centrado alcanza), sin engranajes ni
   correas de casetera en la transmision, el 12" no se disena (3 puertas abiertas).
6. PRIMER PASO: preguntarle a Fran que trajo: hA, hB, A, B, W, h_eje; inventario
   (pared de los tubos, varillas de 8,00?, cuantos 608, balanza); 30 o 60 s por
   foto; si el amigo tiene torno. Con eso: h_montura = W/(tan A + tan B),
   A = asen(hA/W), H = (19,2 h_eje + 19,7 h_montura)/38,9. Si cae en 58-69: CdM
   cerrado por dos metodos; Hreal al modelo, Hdis = Hbal, republicar, regenerar Docs.
7. Si pide MEDIR la puerta: el efecto es que cascada.ps1 imprima "EXIGIDO POR LA
   PUERTA (T11) para telescopio" con sus rangos.
```

### El de la séptima sesión (superado, queda de historia)

Escrito el 2026-10-05, sin recortes:

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso.
Modelo: Opus, esfuerzo medium, SIN fan-out: cargar medidas en un diseno ya
elegido; sube a high solo si una medicion cambia la arquitectura.

0. Si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh  (desde claude-acceso) y leer lo que liste.
1. .\cascada.ps1 telescopio -Necesidad diseno,publicar  y leer TODO lo que
   exija la puerta.
2. Leer: ESTADO_ACTUAL.md entero, HANDOFF.md entero, docs/11-paso-a-paso.md
   entero (el orden vigente), docs/08-medidas.md entero. NO leer el CAD, el
   macro VBA ni las fotos. 07-guia-armado.md (concepto), 09-estructura-hierro.md,
   06-modelo-3d.html y geometria-vns.js: solo si hay que tocarlos; si se toca
   geometria-vns.js, subir el ?v= del <script> (hoy 8).
3. Fase 0 (Concebir, Pre-Fase A). Arquitectura CERRADA: VNS. Falta para cerrar:
   el CdM por dos metodos que coincidan (P3 con la caja puesta + P4 de
   control), P0 (llega a foco? APARCADA por Fran; es compuerta antes de comprar
   la chapa de aluminio) e inventario sin filas en "?".
4. Estado de la maquina y del mundo:
   - Masa ~40 kg por dos caminos; CdM ~63 cm (58-69). Tubo balanceado SIN
     camara (camara aparcada).
   - Plataforma de planchuela de hierro, base TRIANGULAR de 1,2 m de ancho
     (travesano del sur abulonado), poste 10 cm, mesa ~8 kg que gira -> eje a
     ~54 cm. Soldar lo fijo, abulonar lo que se desarma.
   - Modelo publicado v8: https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM
     (con link). Se publica con files {"geometria-vns.js": docs/geometria-vns.js};
     la herramienta pide leer antes lo publicado (action read, y con path para
     el .js). Local: preview_start "telescopio-modelo" (8765). Controles:
     node docs/probar-geometria.js (9 OK, 7 sabotajes en rojo);
     node docs/estabilidad-base.js (la comparacion de bases).
   - Drive: "drive-personal:05 - PROYECTOS - taller y astronomia/Telescopio
     200-1200 - Fran y Kevin/<Nombre>.html", Kevin editor. Docs: "1 - El proyecto
     - concepto y diseno" (07), "2 - Paso a paso - que hacer y en que orden" (11),
     "Medidas y lo que falta pesar" (08), "Plataforma de hierro y altura del
     pivote" (09), "Protocolo de medicion" (02). Se generan con docs/md-a-gdoc.py
     y rclone copyto --drive-import-formats html --drive-export-formats html
     --config ~/.config/rclone/rclone.conf (mismo nombre = actualiza en el lugar;
     verificar el ID con lsf --format pi).
5. Ya resuelto, no se rehace: VNS y trade study; espejo sur (pivote al NORTE);
   limites 45/48/51 min; geometria del dobson; pesadas por partes; pivote =
   rotula de amortiguador a gas; motores de casetera/impresora descartados, NEMA
   17 de ~4 kg.cm se compra (Usongshine 17HS4401, 09, sección Motor); hierro y poste de
   10 cm; base triangular ancha (no cuadrada); soldar/abulonar; fijacion del
   dobson con ranuras, bujes y mariposas; concepto y pasos en documentos
   separados.
6. PRIMER COMANDO: preguntarle a Fran cuales de los 9 pasos de 11-paso-a-paso.md
   hizo y que midio (balanza; P3 y P4 con sus lecturas; espesores y peso de 1 m
   de planchuela; fotos del inventario; si compro el motor). Con P3 y P4: cerrar
   el CdM (estimar-cdm.py), cambiar Hreal y poner Hdis = Hbal en
   06-modelo-3d.html, republicar al MISMO link y regenerar los Docs.
7. Si pide MEDIR la puerta: el efecto es que cascada.ps1 imprima el bloque
   "EXIGIDO POR LA PUERTA (T11) para telescopio" con sus rangos de lineas.
```

## Lo que NO hay que volver a intentar

- No elegir CS por el argumento de agosto (falso como exclusividad).
- No usar los DXF de `cad/DXF/` para cortar.
- No cortar los segmentos antes de medir el centro de masa: su forma es lo
  único del diseño que no se ajusta después.
- No copiar orientaciones («norte», «sur») de una fuente del hemisferio norte
  sin espejarlas.
- No buscar con Google desde el navegador del panel: da captcha. DuckDuckGo
  html (`html.duckduckgo.com/html/?q=...`) anda; Mercado Libre pide login.

## Datos que no se pueden aproximar

- Latitud de diseño **34,5° S**. Newtoniano **200/1200**, f/6.
- Pivote al norte a `H / tan φ` del centro de masa; ω = 7,2921e−5 rad/s.
- Resultados con H = 64 cm, ±45 min, rodillos a ±19 cm (todo hipótesis):
  base 1,41 × 0,76 m (1,12 m con 20 cm de poste); mesa a 14,9 cm del piso;
  segmento R ≈ 0,79 m, rodadura 378 mm (394 con talones de 8 × 12 mm),
  chapa 30-106 mm de alto, girada 7,9°; velocidad ±0,48 %; corrimiento
  ±13,7 mm; cargas 12,0 kg pivote / 19,0 kg cada rodillo (v3, con límites).
- Aluminio 5 mm 500 × 500 Aluar 1050: **$66.193** (Alumina Argentina). Fenólico
  18 mm 1,22 × 2,44: **$50.121** (Easy). NEMA 17 7 kg·cm ≈ $49.900. Todo al
  2026-10-04.
