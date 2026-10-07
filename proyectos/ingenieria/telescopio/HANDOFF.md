# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-07 (undécima sesión, PC, abierta en `Desktop\claude-acceso`) ·
**Fase al cerrar:** 0 (Concebir, Pre-Fase A) — **abierta**, 2 de 4: arquitectura
cerrada (VNS) y **borrador de requisitos en verde** (`docs/10-requisitos.md`);
falta el CdM por dos métodos (≈ 63 cm, 58 a 69, **sin medir**), la prueba de
foco y el inventario sin `?`.

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
