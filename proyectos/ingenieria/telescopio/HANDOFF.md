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
