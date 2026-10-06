# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-05 (séptima sesión) · **Fase al cerrar:** 0 (Concebir,
Pre-Fase A) — **abierta**; arquitectura cerrada (VNS), masa ≈ 40 kg por dos
caminos, CdM ≈ 63 cm (58 a 69, falta el segundo método), plataforma de hierro
con base triangular ancha de 1,2 m (modelo v8); **P0 aparcada** (compuerta
antes de comprar el aluminio) e inventario con filas en `?`.

## Arrancá por acá

1. `.\cascada.ps1 telescopio -Necesidad diseno,publicar` y leer lo que exija.
2. `ESTADO_ACTUAL.md` entero y `docs/11-paso-a-paso.md` (el orden vigente).
3. **Preguntarle a Fran qué hizo de los nueve pasos** (balanza, P3, P4, medidas
   chicas, inventario, rodillo de Kevin, motor en banco). Lo que traiga del P3
   y el P4 entra al modelo (`Hreal`, `Hdis = Hbal` en `docs/06-modelo-3d.html`)
   y se republica al mismo link (mismo `file_path` + `files` con
   `geometria-vns.js`; si el live difiere de lo local, leerlo primero con
   `read` y `path`).

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

## Mensaje de retome (chat nuevo)

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
