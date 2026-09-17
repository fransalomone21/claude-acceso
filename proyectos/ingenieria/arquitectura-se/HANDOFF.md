# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 7 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la sexta fase seguida así. **Cero PDF extraídos.**

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 6 ABIERTA, primer tramo cerrado

La fase 6 **toca archivos vivos**, así que su rigor es **pleno**: backup y
saboteador **antes** de cada pieza. Se respetó: los dos repos quedaron limpios
y pusheados después de cada pieza, y cada freno nuevo tiene su saboteador
corrido y en rojo antes de darlo por puesto.

**Cerrados los TRES defectos vivos que la fase 5 dejó:**

1. **D12** — el `186` contra el registro. Se **derivó**, no se actualizó:
   `aprender.py` saca el conteo de `len(utiles)` y `chequeo-de-trabajo.md` ya
   no lleva número. Verificado en vivo: al agregar las 6 lecciones de esta
   sesión, el `INDICE.md` pasó a decir **210** sin que nadie lo tocara.
2. **D14** — el chequeo de requisitos era de idioma inglés. Tiene las listas
   del GtWR en español, con la **misma severidad**, y su saboteador.
3. **El medidor de desuso** — `medir-matriz.py` + `probar-medidor-matriz.ps1`.
   El criterio C6 del trade study dejó de ser una intención.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. El saboteador escrito por el autor del freno hereda su punto ciego, y
esta vez se midió.** El freno de D12 **ya existía** en `install.ps1`, con su
caso de sabotaje, en verde desde el 2026-08-28. El patrón estaba anclado a la
**primera línea** del archivo; el saboteador rompía el archivo **en la primera
línea**; y el `186` real vivía en la **línea 19**. El test probaba que el
patrón matchea su propio ejemplo, nada más. **Es el argumento más fuerte que
tiene el proyecto para que P8 (revisión independiente) siga declarada como
hueco sin respuesta en vez de darse por cubierta con los saboteadores.**

**2. Un chequeo que valida un rango tiene que validar las dos puntas.** El
verificador de ASCII buscaba bytes `>127` (mojibake) y era ciego a los de
control `<32`. Por esa punta entraron **tres BACKSPACE a archivos vivos**, uno
a `chequeo-de-trabajo.md`, que se inyecta en **cada sesión**, y dos a
`verificar-requisito.py`, donde además **apagaban en silencio una excepción de
R16**. Los tres eran el mismo error: un `\b` escrito dentro de comillas dobles
de shell, que el shell interpreta antes de que el archivo lo reciba. La
pregunta correcta no es *qué valores malos conozco* sino *cuál es el conjunto
de los legítimos*.

**3. La condición de aceptación de dos mitades funcionó exactamente como la
fase 5 predijo, y hacía falta una tercera.** Sin la mitad 2 (*6 VIOLA sobre el
enunciado malo en inglés*), el arreglo de D14 podía haber sido apagar R1 y
nadie se enteraba. Trabajando apareció la tercera: *el mismo enunciado
traducido tiene que dar VIOLA comparable*. Sin ella, el español podía quedar
como **la versión blanda** de la regla — que es la otra forma de apagarla, y
la que no se ve.

**4. Se reescribieron los requisitos, no el chequeo.** Los 4 VIOLA que
quedaron en español eran defectos **reales** (`su` en A1 y A3, una negación en
A6 y A9): los mismos que el chequeo marca en inglés sobre `its` y `not`.
Ablandar las listas para que pasaran habría sido calibrar el medidor contra el
resultado buscado. La contraposición de A6 va al atributo A1 (Rationale), que
es lo que el libro pide en la p. 64.

**5. Verde por vacío.** El medidor de desuso daba **verde** sobre un archivo
sin una sola fila. *Nada que medir* y *todo bien* son opuestos, y es el único
verde que **crece** a medida que la disciplina se abandona, porque abandonar
la práctica borra justo lo que el medidor buscaba. Lo atrapó su propio
saboteador, en el control que más fácil se escribe al revés.

## ENTRADAS AL TRAMO QUE SIGUE, YA ESCRITAS

1. **Las 5 piezas que faltan** de las 7 filas `no aplica — todavía` de
   `docs/matriz-cumplimiento.md` §5: **P1** (catálogo derivado), **P4** (los
   dos campos del molde de fase + el campo de certificación en
   `plantillas/PDP.md`), **P5** (heurísticas pegadas a los pasos), **P6**
   (criterio de entrada, los 5 de Rechtin p. 33-34), **P7** (System 2 /
   System 3).
2. **`ingenieria-de-sistemas.md`** (`perfil-global/engineering-orchestrator/
   referencias/`) entra con las 4 correcciones de `docs/arquitectura.md` §8, y
   con la pregunta abierta: reescrito contra las fichas, ¿sigue haciendo
   falta, o el catálogo P1 más las cuatro fichas ya lo reemplazan?
3. **Un proyecto real migrado a la matriz.** Es lo que **de verdad** cierra la
   fase; instalar las piezas no alcanza.
4. **P10 NO se construye**: es de la fase 7, a propósito. Construirlo ahora
   sería medir una arquitectura que todavía no se usó.
5. **El PDP dice "los cuatro saboteadores" y ya son ocho.** Ese número se
   corrige cuando la fase cierre: es un dato de hace tres fases.

## EL ÚNICO ROJO ABIERTO, Y ES CORRECTO

`chequeo-completo.ps1 -SoloMedidores` → **1 rojo**: `restas de las matrices`.
Las 7 filas `no aplica — todavía` llevan `Fase 6` de justificación, que es un
puntero y no una resta. El medidor está midiendo el avance de la fase, que es
lo que tiene que hacer. Los otros 5 medidores, en verde.

## LO QUE SE TOCÓ, Y SIGUE CUMPLIENDO LA REGLA 4

Archivos vivos tocados, **todos con su saboteador corrido**:
`perfil-global/install.ps1`, `chequeo-de-trabajo.md`, `herramientas/aprender.py`,
`verify-install.ps1`, `pilares/incose-gtwr/verificar-requisito.py` y sus casos,
`chequeo-completo.ps1`, `MAQUINA-NUEVA.md`, y `docs/requisitos.txt`.
Nuevos: `herramientas/medir-matriz.py`, `probar-medidor-matriz.ps1`,
`probar-chequeo-ascii.ps1`, `casos/sanos-es.txt`, `casos/rotos-es.txt`.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
.\chequeo-completo.ps1 -SoloMedidores
```

Tiene que dar **5 verdes y 1 rojo** (`restas de las matrices`). Si da otra
cosa, eso es lo primero que se mira. Y después, `docs/arquitectura.md` §3, las
piezas P1, P4, P5, P6 y P7 — cada una trae su cita, su página y su *cómo se
sabrá que está puesta*.
