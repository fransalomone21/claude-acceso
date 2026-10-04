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
| **Medir, pesar o fotografiar** el telescopio | [`docs/02-protocolo-medicion.md`](docs/02-protocolo-medicion.md) — qué, en qué orden, con qué tolerancia |
| **Elegir la arquitectura de la plataforma** (CS vs VNS), o entender la geometría | [`docs/04-conceptos.md`](docs/04-conceptos.md) — el catálogo, con fuentes |
| Saber qué piezas hay de verdad, o armar un BOM | [`docs/03-inventario.md`](docs/03-inventario.md) |
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
