# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 7 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la sexta fase seguida así. **Cero PDF extraídos.**

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 6 CERRADA, abre la fase 7

La fase 6 cerraba por tres cosas y cerró por las tres, medidas:

```
Chequeo OK. Ningun rojo.     7 medidores + 10 saboteadores + 7 de limpieza
38 filas: 33 cumple, 2 no aplica, 3 recortado   (todas con su resta)
8 PDP: 1 en verde, 0 en rojo, 7 sin migrar
```

**Es la primera fase que tocó archivos vivos**, y el rigor pleno se respetó:
saboteador corrido **antes** de dar por puesta cada pieza, repo commiteado y
pusheado entre piezas.

**Instalado:** P2 (matriz), P3 (rigor por aspecto), P4 (molde de fase), P6
(criterio de entrada) y P7 (System 2/3) en `cumple`; P5 **recortado con la
mitad puesta**; P1 diferido con su resta; P10 es de la fase 7.

**Los tres defectos vivos, cerrados:** D12, D14 y el medidor de desuso.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. Un saboteador escrito por el autor del freno hereda su punto ciego, y
esta vez se midió.** El freno de D12 **ya existía** en `install.ps1`, con su
caso de sabotaje, en verde desde el 2026-08-28. El patrón miraba la **primera
línea**; el saboteador rompía el archivo **en la primera línea**; el `186` real
vivía en la **línea 19**. El test probaba que el patrón matchea su propio
ejemplo. **Es el argumento más fuerte para que P8 siga declarada como hueco sin
respuesta** en vez de darse por cubierta con los saboteadores.

**2. La inyección dejó de ser entrega, y hay número.** La lección de los
escapes de C estaba escrita desde el 13/09, con triage `propia`, e **inyectada
en `chequeo-de-trabajo.md` línea 553**. Estuvo en el contexto desde el arranque
y el mismo error corrompió **cinco archivos vivos** en esta sesión —uno de
ellos el .md que se inyecta en cada sesión, y dos datos técnicos de BLACK
medidos contra el ELF—. A **95 KB, 1347 líneas, 154 viñetas**, es exactamente
lo que Rechtin p. 35 llama hojear una ferretería. Eso decidió qué mitad de P5
construir: el guardia que entrega **en el paso**, no la partición del archivo.

**3. Un chequeo que valida un rango tiene que validar las dos puntas.** El de
ASCII miraba `>127` y era ciego a los controles `<32`. La pregunta correcta no
es *qué valores malos conozco* sino *cuál es el conjunto de los legítimos*.

**4. "Nada que medir" y "todo bien" son opuestos, y el segundo crece solo.**
Apareció **dos veces**: en `medir-matriz.py` y en `medir-fase.py`, la segunda
ya con la lección escrita. Verde por vacío es el único verde que **aumenta** a
medida que la disciplina se abandona, porque abandonarla borra justo lo que el
medidor buscaba.

**5. Se reescribieron los requisitos, no el chequeo.** Los 4 VIOLA que
quedaron en español eran defectos reales (`su`, una negación), los mismos que
el chequeo marca en inglés sobre `its` y `not`. Ablandar las listas para que
pasaran habría sido calibrar el medidor contra el resultado buscado.

**6. Un saboteador sin `exit 0` hereda el código del comando que TENÍA que
fallar.** Dos saboteadores sanos reportados en rojo por el orquestador, en
0,9 s — y el tiempo corto hizo pensar que morían al arrancar.

## ENTRADAS A LA FASE 7, YA ESCRITAS

1. **P10, el medidor de validación** — *timely / affordable / predictable /
   comprehensive* (SEH p. 165-166). **Tiene con qué medirse**: el costo por
   fase está registrado fase por fase en `ESTADO_ACTUAL.md`, desde los 2,07 M
   tokens de la fase 0 hasta los ~31 puntos de la 6.
2. **La otra mitad de P5**: partir `chequeo-de-trabajo.md`, que sigue pesando
   95 KB. Criterio ya escrito: lo que se inyecta pesa menos, **y** la lección
   del paso en curso está adentro.
3. **P1, el catálogo derivado**, con su resta ya escrita en la matriz.
4. **Migrar los otros 7 PDP.** `medir-fase.py` cuenta 1 en verde y 7 sin
   migrar; ese número tiene que bajar, y el medidor lo muestra solo.
5. **`ingenieria-de-sistemas.md`** con las 4 correcciones de
   `docs/arquitectura.md` §8, y la pregunta abierta sobre si sigue haciendo
   falta.

## LO QUE SE TOCÓ

Archivos vivos, **todos con su saboteador corrido**: `install.ps1`,
`chequeo-de-trabajo.md`, `herramientas/aprender.py`, `verify-install.ps1`,
`manifiesto.ps1`, `CLAUDE.md` del perfil, `README.md` del perfil,
`verificar-requisito.py` y sus casos, `verificar-estructura.ps1`,
`probar-verificador.ps1`, `probar-chequeo-lecciones.ps1`,
`chequeo-completo.ps1`, `plantillas/PDP.md`, `MAQUINA-NUEVA.md`, el `CLAUDE.md`
de la raíz, y el `PDP.md` y `docs/` de este proyecto. Más BLACK:
`ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md`, por los caracteres de control.

**Nuevos:** `herramientas/medir-matriz.py`, `herramientas/medir-fase.py`,
`hooks/guardia-escapes.ps1`, `probar-medidor-matriz.ps1`,
`probar-medidor-fase.ps1`, `probar-chequeo-ascii.ps1`,
`probar-guardia-escapes.ps1`, `casos/sanos-es.txt`, `casos/rotos-es.txt`,
`.claude/controles-permitidos.json`.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
.\chequeo-completo.ps1 -SoloMedidores
```

Tiene que dar **7 verdes y ningún rojo**. Si da otra cosa, eso es lo primero
que se mira: la fase 6 cerró con todo en verde, así que un rojo ahí es algo
que pasó **después**.
