# Concepto de operación y requisitos

**Qué es esto.** El documento contra el cual se valida todo lo demás. El resto
del repo dice *cómo funciona BLACK*; esto dice *qué queremos que sea*, y por lo
tanto qué cuenta como éxito.

Sin esto, se puede verificar para siempre sin validar nunca: comprobar que cada
parche hace lo que dice y no saber jamás si el juego mejoró.

---

## La distinción que ordena todo

Tomada del NASA Systems Engineering Handbook, §2.4. Son dos preguntas
distintas y necesitan pruebas distintas:

| | pregunta | contra qué se prueba | ejemplo del 2026-08-17 |
|---|---|---|---|
| **Verificación** | ¿hace lo que dice la especificación? | el requisito escrito | `Power` quedó en `5.0` en `GLOBDATA.BIN`, el diff toca 17 rangos y ninguno la TOC, y en RAM se lee `5` |
| **Validación** | ¿sirve para lo que se quería, jugando? | este documento | con el jugador quieto bajo fuego: **24 impactos, los 24 de −5.0**, contra los 26.0 de antes |

La regla del proyecto —*"confirmado" es haber visto el efecto*— es la
validación. Sigue valiendo entera. Lo que agrega esta tabla es que **la
verificación también hay que escribirla**, porque es la que dice *por qué* el
efecto ocurrió y no fue una casualidad.

Y una consecuencia práctica que el handbook subraya: **validar temprano, con
productos parciales**, no al final. No hay que esperar a que el coop ande para
preguntar si el juego mejoró.

> **Adaptación explícita (el handbook lo pide, §3.11).** Esto es un proyecto de
> una persona, sin seguridad de vidas y sin presupuesto que rendir. Se toma de
> NASA la distinción V&V, la trazabilidad de requisitos y el registro de
> riesgos. **No** se toman las revisiones formales, las juntas de control de
> cambios ni la matriz de cumplimiento. Adoptar el aparato completo sería
> teatro de proceso y costaría más de lo que rinde.

---

## Lo que Fran quiere de BLACK (2026-08-17, dicho por él)

> "Mi gran objetivo con BLACK y todo esto es reinventarlo para hacerlo más
> desafiante e implementar cambios drásticos como coop y quién sabe algún nuevo
> nivel a largo plazo."

Un solo interesado, que además es el único usuario. Eso simplifica: no hay
requisitos en conflicto, y la validación es que él lo juegue y lo sienta.

## Requisitos

| id | requisito | verificación | validación | estado |
|---|---|---|---|---|
| **R1** | Un cambio al juego sobrevive a cerrar el emulador | el ISO parcheado difiere del original sólo en los bytes buscados | arrancar de cero y jugar con el cambio puesto | **CUMPLIDO** 2026-08-17 |
| **R2** | Se puede cambiar la dificultad por parámetros, sin rehacer contenido | leer y escribir los tunables identificados | jugar y que se sienta distinto | parcial: daño sí; percepción de la IA, no todavía |
| **R3** | La IA puede hacerse más aguda (ver antes, oír más, apuntar mejor) | escribir `VisualAcuteness` / `HearingAcuteness` / `MaxInaccuracy` y releer | los enemigos reaccionan antes y aciertan más | **abierto** — clases identificadas, valores no |
| **R4** | Se puede cambiar qué enemigos aparecen y cuántos | editar `STLEVEL.BIN` in-place y que el nivel cargue | el nivel se juega distinto | **abierto** |
| **R5** | Coop de dos jugadores | hay dos entidades jugador vivas y dos mandos leídos | dos personas juegan juntas | **abierto, largo plazo** |
| **R6** | Un nivel nuevo | el juego carga geometría que no venía en el ISO | se puede jugar de punta a punta | **abierto, muy largo plazo** |

## Restricciones

| id | restricción | por qué |
|---|---|---|
| **C1** | No editar el ISO original nunca | 3,9 GB por copia y es la única fuente limpia |
| **C2** | Todo lo que se afirme lleva evidencia | regla 1 del proyecto |
| **C3** | Las direcciones valen para NTSC-U / CRC `5C891FF1` | no portan a PAL |

---

## El riesgo técnico que hay que ver desde ahora

**El coop y cualquier nivel nuevo necesitan código nuevo. Código nuevo adentro
del ISO cambia el ELF, y cambiar el ELF cambia su CRC.** PCSX2 indexa por CRC
los savestates y los `.pnach`: al cambiarlo, **todos los savestates del
proyecto y todos los parches dejan de aplicar de golpe**, incluida la
infraestructura de investigación que costó cinco sesiones armar.

Anotarlo ahora, y no el día que pase, es exactamente para lo que sirve mirar el
riesgo temprano.

**Mitigación, y es barata:** el código nuevo se entrega por `.pnach`, que PCSX2
aplica en memoria al arrancar, **sin tocar el ELF del ISO**. Los datos —armas,
enemigos, colocación— se entregan in-place adentro del ISO, que ya está
probado. O sea:

```
datos   -> parche in-place en el ISO   (CRC intacto)
código  -> .pnach                       (CRC intacto)
```

Las dos vías conviven y ninguna invalida la otra. La única razón para
reconstruir el ISO sería **agregar o agrandar archivos** — un nivel nuevo,
R6 — y para ese día ya está verificado que se puede (tarea 6.1), con las tres
condiciones de `docs/05-iso.md`.

## Cómo se usa este documento

Antes de arrancar una tarea, preguntarse a qué requisito sirve. Si no sirve a
ninguno, o es un requisito que falta —y entonces se agrega acá— o es trabajo
que no hay que hacer.
