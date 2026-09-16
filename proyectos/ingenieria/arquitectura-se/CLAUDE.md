# `arquitectura-se` — reformar el método con ingeniería de sistemas

Contrato de contexto. **Índice de qué leer según la tarea**, no explicación de
cómo se trabaja (eso es el perfil global, que se carga solo).

## Qué es este proyecto

Rehacer la arquitectura de trabajo —cascada, PDP, naturalezas, cuadro de fase,
frenos— contrastándola contra el cuerpo formal de ingeniería de sistemas:
NASA SP-2016-6105 Rev2, INCOSE SEH 5.ª ed., INCOSE GtWR, Rechtin & Maier.

**Las necesidades que generaron la arquitectura actual siguen vigentes y no se
negocian.** Cada freno que hoy existe entra a la arquitectura nueva con su
impacto original escrito, o no sale.

## Qué leer, según la tarea

| Si la tarea es… | Leer |
|---|---|
| **Cualquier cosa** | `ESTADO_ACTUAL.md` entero, primero |
| Saber en qué fase estamos y qué la cierra | `PDP.md` § 4 |
| Diseñar la matriz de cumplimiento | `perfil-global/pilares/nasa-seh/tailoring.md` |
| Escribir o auditar requisitos | `.../nasa-seh/requisitos.md` + `.../glosario.md` (apéndice C) |
| Definir verificación o validación | `.../nasa-seh/verificacion.md`, `.../validacion.md` |
| Puertas, revisiones y criterios de salida | `.../nasa-seh/ciclo-vida.md` |
| Trade study antes de una decisión | `.../nasa-seh/datos-decision.md` (cap. 6.8) |
| Riesgo con disparador observable | `.../nasa-seh/riesgo-config.md` |
| Interfaces entre piezas del método | `.../nasa-seh/req-interfaz.md` |
| Una definición exacta | `.../nasa-seh/glosario.md` |
| Buscar una página del handbook | `python perfil-global/pilares/nasa-seh/pag.py <desde> <hasta>` |

Ninguno se lee "por las dudas": son 819 KB. Se abre el que la tarea pide.

## Reglas propias de este proyecto

1. **Nada se cita sin ancla de página.** El ancla es la página **impresa** del
   libro (`PDF = libro + 10`), que es la que se puede chequear después.
2. **El medidor de citas corre antes de cerrar cualquier fase de lectura.**
   Un destilado infiel se ve idéntico a uno fiel; la única diferencia medible
   son las citas textuales.
3. **Inline, sin fan-out.** La fase 0 gastó 2,07 M tokens y un límite de 5 h
   en 6,6 minutos. Compró lo que no se podía comprar de otro modo (297
   páginas no entran en una ventana) y no se repite.
4. **Nada vivo se toca antes de la fase 6.** El diseño y el trade study van
   primero; migrar sin diseño es la falla que este proyecto existe para no
   cometer.
