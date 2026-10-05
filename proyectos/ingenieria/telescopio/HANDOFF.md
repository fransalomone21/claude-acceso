# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-05 · **Fase al cerrar:** 0 (Concebir, Pre-Fase A) —
**abierta**; arquitectura cerrada (VNS), geometría del dobson medida, masa
≈ 40 kg cerrada por dos caminos y tubo balanceado; CdM ≈ 63 cm compuesto
(falta el segundo método); plataforma de planchuela de hierro con poste de
10 cm (modelo v7); faltan P0 y el inventario.

## Arrancá por acá

1. `.\cascada.ps1 telescopio -Necesidad diseno` y leer lo que imprima.
2. `ESTADO_ACTUAL.md` entero.
3. **Preguntarle a Fran qué midió.** Lo que traiga entra a los valores por
   defecto de `docs/06-modelo-3d.html` (los `value=` de los deslizadores) y se
   republica al mismo link con la herramienta Artifact (mismo `file_path`, o
   `url` desde otro chat).

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

- **Preguntas abiertas a Fran:** (1) espesor de las planchuelas, y si se
  sueldan o se abulonan; (2) el segundo método del CdM; (3) el puesto 3 de
  los pesos (capacidad de carga), que no cambia el ganador.
- **El primo:** ya es editor de la carpeta de Drive (a pedido de Fran). El
  artifact lo comparte Fran desde el menú Compartir de la página; la sesión
  no puede. El mail **no** va al repo (es público): sólo su hash.
- **Pendiente de Kevin:** ¿se veían los anillos de Saturno? (cierra P0).
- **PDF de la guía** en formato apunte: cuando haya medidas (antes no vale la
  pena maquetar números de agosto).
- **Precios a cotizar:** corte láser, rulemanes, rótula, TMC2209.
- **El modelo 3D de SolidWorks no se revisó pieza por pieza**; las medidas del
  modelo web son las del encabezado del macro (`cad/PlataformaEcuatorial.bas`,
  líneas 51-125), todas `hipótesis`.

## Mensaje de retome (chat nuevo)

Escrito el 2026-10-05, sin recortes:

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso.
Modelo: Opus, esfuerzo medium, SIN fan-out: es cargar pesadas y reajustar un
modelo ya decidido; sube a high solo si una pesada cambia la arquitectura.

0. Si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh  (desde claude-acceso) y leer lo que liste.
1. .\cascada.ps1 telescopio -Necesidad diseno,publicar  y leer TODO lo que
   exija la puerta.
2. Leer: ESTADO_ACTUAL.md entero, HANDOFF.md entero, docs/08-medidas.md entero.
   NO leer el CAD, el macro VBA ni las 71 fotos (ya estan transcriptas en
   08-medidas.md; si hace falta una, fotos/2026-10-04/indice.txt da el numero).
   docs/09-estructura-hierro.md entero (la plataforma de hierro, el poste).
   06-modelo-3d.html y geometria-vns.js: solo si hay que tocar el modelo;
   si se toca geometria-vns.js, subir el ?v= del <script> del modelo.
3. Fase 0 (Concebir, Pre-Fase A). Arquitectura CERRADA: VNS. Falta para cerrar:
   masa y centro de masa por DOS metodos que coincidan, P0 (llega a foco?), y
   docs/03-inventario.md sin filas en "?".
4. Estado de la maquina y del mundo:
   - Dobson rearmado, tubo balanceado en el eje de altura (2026-10-05).
   - Masa ~40 kg por dos caminos; CdM ~63 cm compuesto (58-69).
   - Plataforma de PLANCHUELA DE HIERRO (30-60 mm, <1 cm), base triangular,
     poste de 10 cm, mesa de ~8 kg que gira -> eje a ~54 cm sobre la mesa.
   - Modelo publicado v7 (M 40, CdM 63, mesa 8 kg, eje 54, suplemento 2,
     poste 10): https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM (con link).
     Se publica con files {"geometria-vns.js": docs/geometria-vns.js}.
     Local: preview_start "telescopio-modelo" (puerto 8765).
     Controles: node docs/probar-geometria.js (8 OK, 6 sabotajes en rojo).
   - Drive: "05 - PROYECTOS - taller y astronomia/Telescopio 200-1200 - Fran y
     Kevin", Kevin editor. Docs generados del repo con docs/md-a-gdoc.py y
     rclone copyto --drive-import-formats html --drive-export-formats html
     (mismo nombre = actualiza en el lugar, ID verificado). Remote:
     "drive-personal:05 - PROYECTOS - taller y astronomia/Telescopio
     200-1200 - Fran y Kevin/<Nombre del Doc>.html". Config de rclone:
     ~/.config/rclone/rclone.conf, pasarlo con --config.
5. Ya resuelto, no se rehace: VNS y su trade study; espejo para el sur
   (pivote al NORTE); limites en tres capas (programa 45, switch 48, talon 51
   min); geometria del dobson medida con cinta (08-medidas.md 1); guia de
   armado en criollo con parte formal FAB/CAL (docs/07-guia-armado.md);
   pesadas por partes (08-medidas.md 3.2); plataforma de hierro y poste de
   10 cm (09); pivote = rotula de amortiguador a gas, no de suspension;
   motores de casetera descartados (de continua), NEMA 17 a comprar.
6. PRIMER COMANDO: preguntarle a Fran (a) el espesor de las planchuelas y si
   sueldan o abulonan; (b) el SEGUNDO METODO del CdM (P3 montura inclinada o
   P4 todo junto plano) y la caja pesada sola; (c) Kevin y los anillos de
   Saturno (P0). Con (b): si el CdM difiere de 63, cambiar Hreal y recalcular
   Hdis = Hbal en 06-modelo-3d.html, y republicar al MISMO link.
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
