# Automatización del telescopio 200/1200 — contrato de contexto

**Índice de qué leer según la tarea.** No explica cómo se trabaja (eso es el
perfil global, que se carga solo) ni dónde estamos (eso es `ESTADO_ACTUAL.md`).

**Naturaleza:** `ingenieria` —
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).
**Fase:** la dice `PDP.md` §4. **Estado:** `ESTADO_ACTUAL.md`.

> **Nota de estructura (2026-10-04):** el proyecto se reabrió como proyecto de
> ingeniería con PDP, fases y criterios de salida. Lo de 2026-08 (medidas,
> parámetros de diseño, CAD, macro VBA) **no se borró**: bajó a `hipótesis` y
> entró como un concepto candidato. Lo que se borró es la pretensión de que
> estuviera cerrado. La carpeta sigue llamándose `telescopio` porque el
> enrutador y el catálogo de la cascada la nombran así.

## Qué leer, según la tarea

| Si la tarea es… | Leer |
|---|---|
| **Cualquier cosa** | `ESTADO_ACTUAL.md` entero, primero |
| Saber en qué fase estamos y qué la cierra | `PDP.md` §4 |
| **Medir, pesar o fotografiar** el telescopio | [`docs/02-protocolo-medicion.md`](docs/02-protocolo-medicion.md) — qué, en qué orden, con qué tolerancia. **Los dibujos del vuelco y la altura del eje** (el centro de masa): [`docs/dibujo-cdm.html`](docs/dibujo-cdm.html), fuente única; `docs/dibujos-cdm.ps1` saca de ahí las imágenes de `docs/img/` (van al Doc «2 - Paso a paso») y el PDF «Medir el centro de masa» del Drive |
| **Elegir la arquitectura de la plataforma** (CS vs VNS), o entender la geometría | [`docs/04-conceptos.md`](docs/04-conceptos.md) — el catálogo, con fuentes |
| **Ver el conjunto en 3D**, mostrárselo a alguien, o probar qué cambia si cambia una medida | [`docs/06-modelo-3d.html`](docs/06-modelo-3d.html) (publicado **v10.2** desde la cuenta de Agus y Fran, **público con el link** según la herramienta de publicación: https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd; el de la cuenta personal de Fran, https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM, quedó en v8 y sólo se actualiza desde esa cuenta. **La fuente es el archivo del repo**). El panel mide «Piezas sueltas»: tiene que dar «ninguna»; se sabotea desde la consola con `window.__vns` (`window.__vns.sabotear('motor')` tiene que dar 7 de 7 sueltas, `sabotear('finales')` 6 de 6, y «restaurado: 0»). Los números salen de [`docs/geometria-vns.js`](docs/geometria-vns.js), única fuente; sus controles: `node docs/probar-geometria.js`. Verlo en local: `preview_start telescopio-modelo` |
| **La estructura en planchuela de hierro**, la altura del poste del pivote, o por qué la mesa entra en el centro de masa | [`docs/09-estructura-hierro.md`](docs/09-estructura-hierro.md). Si se cambia `geometria-vns.js`, subir el `?v=` del `<script>` en el modelo: si no, el navegador usa la copia vieja y la página se rompe |
| Por qué VNS y no CS, con los pesos de Fran | [`docs/05-trade-study.md`](docs/05-trade-study.md) |
| Saber qué piezas hay de verdad, o armar un BOM | [`docs/03-inventario.md`](docs/03-inventario.md) |
| **Qué se midió, con qué, y qué falta pesar**; la estimación de masa y centro de masa | [`docs/08-medidas.md`](docs/08-medidas.md) y `python docs/estimar-cdm.py`. Las fotos: `fotos/2026-10-04/` (ignorada, el repo es público) y el Drive |
| **Qué hacer ahora, en qué orden** (los pasos, quién, cómo se sabe que salió bien, y la fabricación y calibración formal FAB/CAL) | [`docs/11-paso-a-paso.md`](docs/11-paso-a-paso.md) — Doc «2 - Paso a paso» del Drive |
| **El concepto del proyecto**: qué es, las piezas, por qué cada decisión, los motores, la lista de materiales; lo que dijo Kevin | [`docs/07-guia-armado.md`](docs/07-guia-armado.md) — Doc «1 - El proyecto» del Drive. **Concepto y pasos están en documentos separados a pedido de Fran (2026-10-05): no se mezclan.** Cómo se pasan a Google Doc: `python docs/md-a-gdoc.py` + rclone (ver `HANDOFF.md`) |
| **Los requisitos** (necesidades → L0 → L1 → L2, con traza, verificación y estado): el papel que define el proyecto; se diseña contra esto | [`docs/10-requisitos.md`](docs/10-requisitos.md) — se certifica con `python docs/verificar-requisitos.py` (y `--autotest`) |
| **El 300 mm**: que la misma plataforma lleve el 200 y un dobson comercial de 300; lo que dijo Kevin (corredera, chaveta, correa dentada, varilla), los 12" del mercado, dónde va la corredera y las alternativas | [`docs/14-concepto-300mm.md`](docs/14-concepto-300mm.md) (2026-10-07) y `node docs/escenarios-300.js` |
| **¿Venimos bien?** La revisión de afuera: veredicto, errores corregidos, el mecanismo con lo rescatado, la estructura con tubo 20 × 20, bulones, chapas, un 12" futuro, la crítica al proceso | [`docs/13-revision-externa.md`](docs/13-revision-externa.md) (2026-10-07) — **manda sobre `12` donde se contradicen** |
| **La crítica de la arquitectura** (materiales de chapa y rodillo, transmisión, tubos vs planchuela, bulones) y **el método de vuelco** para el CdM | [`docs/12-critica-y-medicion.md`](docs/12-critica-y-medicion.md) (2026-10-07, nube; corregido por `13`) |
| ¿Qué base al piso aguanta más? | `node docs/estabilidad-base.js` (cuenta reproducible; el modelo trae el slider y el vuelco) |
| Entender **cómo se usa** y qué requisitos salen de ahí | [`docs/01-conops.md`](docs/01-conops.md) |
| Riesgos, rigor por aspecto, decisiones tomadas | `PDP.md` §3, §5, §6 |
| El CAD previo y qué hacer con él | `cad/` + la tabla de abajo |
| Cómo se llegó a algo, o qué ya se probó y falló | `docs/bitacora.md` — **no** se lee al abrir |

## El CAD de 2026-08 — qué es cada cosa y qué vale hoy

| Archivo | Qué es | Vale hoy |
|---|---|---|
| `cad/PlataformaEcuatorial.bas` (1571 líneas) | macro VBA que genera la geometría **CS** paramétrica en SolidWorks y escribe los dos DXF de plantilla 1:1 como texto plano, sin depender de la exportación de SolidWorks | **la mecánica sí, los números no.** Las seis correcciones de robustez de su encabezado son conocimiento pagado y se reusan. Las constantes salen de `H = 64 cm`, que es una estimación |
| `cad/PlataformaEcuatorial.swp` | el mismo macro, empaquetado | ídem |
| `cad/DXF/SectorPlantillaNorte.dxf`, `...Sur.dxf` | plantillas 1:1 de los sectores CS | **no se usan para cortar.** Salen de los números sin medir, y sólo sirven si CS gana el trade study |
| `cad/piezas/*.sldprt` (22 piezas) y `ConjuntoTelescopio.sldasm` | el telescopio, la montura y la plataforma CS modelados | el **nivel 1** del sistema. Se revisa contra las medidas nuevas pieza por pieza; lo que no coincida se corrige, no se descarta |

## Reglas propias de este proyecto

1. **Un número sin su método es una hipótesis.** Toda medida que entre al repo
   lleva con qué se midió y con qué tolerancia. Las de 2026-08 no lo tienen y
   por eso están en la tabla de hipótesis del `ESTADO_ACTUAL`, no en la de
   confirmados — aunque digan «medidas, no estimadas».
2. **La masa y el centro de masa se verifican por dos métodos**, y tienen que
   coincidir. Uno solo es una esperanza. Está en `PDP.md` §7.
3. **Nada se corta antes de la plantilla 1:1.** Vale para la plataforma nueva
   y, con más razón, para la montura existente: **no hay otra montura.**
4. **La reforma de la montura se prueba moviendo antes de cortar.** La
   compensación del centro de masa se consigue corriendo el tubo en la caja;
   sacar madera es el último recurso y es irreversible.
5. **Los pesos de cualquier trade study los pone Fran**, y se declaran con su
   fuente. La sesión decide cómo se ejecuta; qué importa más, no.
6. **La meta es la foto, no la plataforma.** Antes de cada decisión grande:
   ¿esto acerca la foto de una nebulosa, o es ingeniería linda? Lo segundo se
   anota y se deja para después.
