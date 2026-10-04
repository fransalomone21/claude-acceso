# Handoff — Automatización del telescopio 200/1200

**Escrito el:** 2026-10-04 (segunda sesión del día) · **Fase al cerrar:** 0
(Concebir, Pre-Fase A) — **abierta**; de sus tres criterios de salida, la
arquitectura está cerrada (VNS) y faltan las mediciones y el inventario.

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

## Lo que quedó a medias

- **Preguntas abiertas a Fran:** (1) ¿midió algo? (P0 primero); (2) ¿la base
  de ≈ 1,41 m le sirve o va el pivote en poste (1,12 m con 20 cm)?; (3) el
  puesto 3 de los pesos (capacidad de carga), que no cambia el ganador.
- **El link al primo:** Fran dio un mail para mostrárselo. No se mandó nada:
  mandar es su decisión y el artifact se comparte desde su menú. El mail **no**
  va al repo (es público).
- **Precios a cotizar:** corte láser, rulemanes, rótula, TMC2209.
- **El modelo 3D de SolidWorks no se revisó pieza por pieza**; las medidas del
  modelo web son las del encabezado del macro (`cad/PlataformaEcuatorial.bas`,
  líneas 51-125), todas `hipótesis`.

## Mensaje de retome (chat nuevo)

Está completo en la respuesta de cierre del 2026-10-04 y es este, sin recortes:

```
Proyecto: telescopio (plataforma VNS del 200/1200), en claude-acceso.
Modelo: Opus, esfuerzo medium, SIN fan-out: es cargar medidas y reajustar un
modelo ya decidido; sube a high solo si una medida cambia la arquitectura.

0. Si ~/.claude/CLAUDE.md no empieza con "# Perfil global":
   bash .claude/nube/traer-perfil.sh  (desde claude-acceso) y leer lo que liste.
1. .\cascada.ps1 telescopio -Necesidad diseno  y leer TODO lo que exija la puerta.
2. Leer: ESTADO_ACTUAL.md entero, HANDOFF.md entero, docs/05-trade-study.md.
   NO leer el CAD ni el macro VBA. docs/06-modelo-3d.html y geometria-vns.js
   se leen SOLO si hay que cargar medidas o tocar el modelo.
3. Fase 0 (Concebir, Pre-Fase A). Arquitectura CERRADA: VNS. Falta para cerrar:
   masa total y centro de masa 3D medidos (dos métodos), P0 (¿llega a foco?),
   y docs/03-inventario.md sin ninguna fila en "?".
4. Estado de la máquina: nada montado ni corriendo. Modelo publicado en
   https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM (versión 2). Para verlo en
   local: preview_start "telescopio-modelo" (.claude/launch.json, puerto 8765).
   Controles de la geometría: node docs/probar-geometria.js (6 OK, 4 sabotajes rojos).
5. Ya resuelto, no se rehace: VNS y su trade study, diseño adaptable, el espejo
   para el sur (pivote al NORTE, segmentos al SUR), compras de zona norte.
6. PRIMER COMANDO: pedirle a Fran lo que traiga (medidas del portaocular y del
   buscador, imperfecciones de la base y la caja, fotos, peso) y las respuestas
   pendientes: (a) Kevin, adaptador impreso: ¿la cámara iba SIN lente? ¿qué
   miraban y a qué distancia? ¿se vio algo nítido moviendo todo el enfoque?
   (b) ¿base de 1,41 m o pivote en poste (1,12 m)? (c) ¿capacidad de carga 3.ª?
   Cada medida entra a los value= de los deslizadores de 06-modelo-3d.html y se
   republica al MISMO link (Artifact con file_path y files {geometria-vns.js}).
7. Si pide MEDIR la puerta: el efecto es que cascada.ps1 imprima el bloque
   "EXIGIDO POR LA PUERTA (T11) para telescopio" con sus rangos de líneas.
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
  segmento R ≈ 0,78 m, cuerda 298 mm, chapa 30-91 mm de alto, girada 8,1°;
  velocidad ±0,31 %; corrimiento ±8,7 mm; cargas 11,8 kg pivote / 19,1 kg
  cada rodillo.
- Aluminio 5 mm 500 × 500 Aluar 1050: **$66.193** (Alumina Argentina). Fenólico
  18 mm 1,22 × 2,44: **$50.121** (Easy). NEMA 17 7 kg·cm ≈ $49.900. Todo al
  2026-10-04.
