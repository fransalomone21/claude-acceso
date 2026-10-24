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
| **Lo que ve Fran (y Kevin, y a quien se lo muestren): los DOS Docs del Drive** (Fran, 2026-10-18: «un documento central y uno en criollo de cómo venimos») | [`docs/18-guia-general.md`](docs/18-guia-general.md) = Doc «1 - El proyecto, todo en un lugar» (ID `1wrzPpizxcblHVY3Zd1vyjZxawaTfdZc2wzDKFsbEwTw`) y [`docs/19-como-venimos.md`](docs/19-como-venimos.md) = Doc «2 - Como venimos y como seguimos» (ID `1rpFTUuDcQvkzbma_9PBBHFBuVl9N3Tce_U9WsTQoUs0`). **Se actualizan cuando cambia el estado**: `python docs/md-a-gdoc.py <md> <html>` + `rclone copyto --config ~/.config/rclone/rclone.conf --drive-import-formats html --drive-export-formats html` con el **mismo nombre** del Doc (mismo ID: verificarlo con `rclone lsf --format pit`). Imágenes en `docs/img/`; las `modelo-*.png` salen del modelo 3D con `python docs/capturas-modelo.py docs/06-modelo-3d.html <carpeta>` (Playwright con el Chrome instalado). Todo lo demás del Drive va a una de dos subcarpetas (2026-10-24, pedido de Fran: «que no haya ruido, en subcarpetas por si Kevin los quiere ver»): **«Para profundizar (no hace falta para entender)»** (Docs 3 y 4, planos de disposición) e **«Historial (ya usado o reemplazado)»** (lo de medir, el cuaderno viejo, las fotos de la montura). **No se crean Docs nuevos arriba**; la lista de compras vive en el Doc 2 |
| **La pista investigada por seis agentes** (manda sobre `16`): el bamboleo, la causa del 1,2″, la métrica, canto por electroerosión, 608 P4, pivote templado | [`docs/17-investigacion-pista.md`](docs/17-investigacion-pista.md) |
| Saber en qué fase estamos y qué la cierra | `PDP.md` §4 |
| **Medir, pesar o fotografiar** el telescopio | [`docs/02-protocolo-medicion.md`](docs/02-protocolo-medicion.md) — qué, en qué orden, con qué tolerancia. **Los dibujos del vuelco y la altura del eje** (el centro de masa): [`docs/dibujo-cdm.html`](docs/dibujo-cdm.html), fuente única; `docs/dibujos-cdm.ps1` saca de ahí las imágenes de `docs/img/` (van al Doc «2 - Paso a paso») y el PDF «Medir el centro de masa» del Drive |
| **Elegir la arquitectura de la plataforma** (CS vs VNS), o entender la geometría | [`docs/04-conceptos.md`](docs/04-conceptos.md) — el catálogo, con fuentes |
| **Ver el conjunto en 3D**, mostrárselo a alguien, o probar qué cambia si cambia una medida | [`docs/06-modelo-3d.html`](docs/06-modelo-3d.html) (**v10.6**, 2026-10-24: el centro de masa medido, 63,2 cm, muesca del 200 a 2,5 cm; rodillos a 58 cm y base de 1,3 m, dos transmisiones —F y V—, recorrido guiado, vista explotada. **Hay DOS artifacts**: el que se actualiza desde la cuenta de esta PC es https://claude.ai/artifact/K4hfyQRik4xsJYYXv5sFeM (versión 9 del artifact = modelo 10.6, **público con el link** según la respuesta del publish; es el que linkea el Doc 1); https://claude.ai/artifact/Sn7F7NGPrNdsJnwwnXTZfd es de la otra cuenta, quedó en la 10.5 y desde acá sólo se lee (`list` lo marca «shared»). Antes de publicar, `Artifact list` dice cuál es «mine». **La fuente es el archivo del repo**). El panel mide «Piezas sueltas»: tiene que dar «ninguna»; se sabotea desde la consola con `window.__vns` (`window.__vns.sabotear('motor')` tiene que dar 7 de 7 sueltas, `sabotear('finales')` 6 de 6, y «restaurado: 0»). Y mide **«Choques»** de lo que gira contra lo fijo en toda la carrera: tiene que dar «ninguno»; su sabotaje es `window.__vns.sabotearChoque()` (1, y restaurado 0). **Toda pieza nueva cerca de las chapas se prueba con ese chequeo antes de publicar**. Los números salen de [`docs/geometria-vns.js`](docs/geometria-vns.js), única fuente; sus controles: `node docs/probar-geometria.js`. Verlo en local: `preview_start telescopio-modelo` |
| **La estructura en planchuela de hierro**, la altura del poste del pivote, o por qué la mesa entra en el centro de masa | [`docs/09-estructura-hierro.md`](docs/09-estructura-hierro.md). Si se cambia `geometria-vns.js`, subir el `?v=` del `<script>` en el modelo: si no, el navegador usa la copia vieja y la página se rompe |
| Por qué VNS y no CS, con los pesos de Fran | [`docs/05-trade-study.md`](docs/05-trade-study.md) |
| Saber qué piezas hay de verdad, o armar un BOM | [`docs/03-inventario.md`](docs/03-inventario.md) |
| **Qué se midió, con qué, y qué falta pesar**; la estimación de masa y centro de masa | [`docs/08-medidas.md`](docs/08-medidas.md) y `python docs/estimar-cdm.py`. Las fotos: `fotos/2026-10-04/` (ignorada, el repo es público) y el Drive |
| **Qué hacer ahora, en qué orden** (los pasos, quién, cómo se sabe que salió bien, y la fabricación y calibración formal FAB/CAL) | [`docs/11-paso-a-paso.md`](docs/11-paso-a-paso.md) — el detalle de cada paso; **ya no es un Doc del Drive** (desde el 2026-10-18 el Doc 2 sale de `19-como-venimos.md`) |
| **El concepto del proyecto**: qué es, las piezas, por qué cada decisión, los motores, la lista de materiales; lo que dijo Kevin | [`docs/07-guia-armado.md`](docs/07-guia-armado.md) — el detalle del concepto; **ya no es un Doc del Drive** (desde el 2026-10-18 el Doc 1 sale de `18-guia-general.md`). **Concepto y pasos están en documentos separados a pedido de Fran (2026-10-05): no se mezclan.** Cómo se pasan a Google Doc: `python docs/md-a-gdoc.py` + rclone (ver `HANDOFF.md`) |
| **Los requisitos** (necesidades → L0 → L1 → L2, con traza, verificación y estado): el papel que define el proyecto; se diseña contra esto | [`docs/10-requisitos.md`](docs/10-requisitos.md) — se certifica con `python docs/verificar-requisitos.py` (y `--autotest`) |
| **¿Qué requisitos se cumplen hoy?** (verificado / predicho / sin resultado, por nivel; la cascada lo imprime al entrar) | [`docs/matriz-verificacion.md`](docs/matriz-verificacion.md) — **generada, no se edita a mano**: `python matriz-verificacion.py escribir telescopio` desde la raíz, después de cambiar el modelo o un requisito (si no, `chequeo-completo` da rojo). La prueba es [`docs/probar-requisitos.js`](docs/probar-requisitos.js) (lee el diseño de `06-modelo-3d.html` y el criterio de cada enunciado; `--sabotaje`). Lo que mide Fran entra con `matriz-verificacion.py registrar telescopio <ID> pasa\|falla --evidencia "<foto o planilla>"`. Diseño: `arquitectura-se/docs/t16-estado-verificable.md` |
| **Mecanismos, proveedores y cielo**: el error de micropaso, las cuatro transmisiones (F, F2, V/T2, C) con su trade, la palanca óptica, el empujón, quién corta 8 mm y quién rectifica cerca de Villa Adelina, los cielos oscuros | [`docs/15-mecanismos-y-proveedores.md`](docs/15-mecanismos-y-proveedores.md) (2026-10-08) — Doc «3 - Mecanismos, proveedores y cielo» del Drive. Cuentas: `node docs/transmisiones.js` (controles: `node docs/probar-transmisiones.js`). Dibujos: `docs/dibujos-mecanismos.js` (fuente única, la usan el modelo y `dibujo-mecanismos.html`); PNG con `docs/dibujos-mecanismos.ps1`. Si cambia un `.js`, subir su `?v=` en las dos páginas |
| **¿Qué puede salir mal, del concepto a la noche?** La pista (canto y rodillos) a micrones, el método de trazado del canto (envolvente), la arista, los cuatro 608, las tolerancias de armado, homing, pivote, rocío, espejo, foco, óxido; candidatos a requisito | [`docs/16-revision-concepto-a-operacion.md`](docs/16-revision-concepto-a-operacion.md) (2026-10-08) — Doc «4 - Revisión: qué puede salir mal» del Drive. **Manda sobre `13` §3, §4 y §6** donde se contradicen. Cuentas: `node docs/contacto-vns.js` (controles con sabotaje: `node docs/probar-contacto.js`) |
| **Planos de disposición** (planta, alzado, vista sur, la chapa 1:1, tolerancias y profundidades del canto), para regenerar con las medidas | [`docs/planos.html`](docs/planos.html) — arriba se cargan el centro de masa, el rodillo, la separación y la base; carga `geometria-vns.js` y `contacto-vns.js` (si cambian, subir su `?v=`). PDF A3 para el Drive: `docs/planos.ps1`. **Preliminares: no son para cortar** (PDP §6) |
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
