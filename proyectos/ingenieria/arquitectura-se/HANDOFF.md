# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 4 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la tercera fase seguida así. Cerrada con presupuesto de sobra:
5 h al ~11 %, semanal al 78 % (entró al 78 %: **la fase entera costó 0 puntos
del semanal**).

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Agile. Fran: "mínima ambigüedad posible", y las
necesidades que generaron la arquitectura actual **siguen valiendo**.

## ESTADO — fase 3 CERRADA, abre la fase 4

La fase 3 cerraba por dos cosas y cerró por las dos, las dos en
**`perfil-global/pilares/incose-seh/mapeo-15288.md`**:

1. **El mapeo** de los 17 procesos de NASA contra los 30 del ISO/IEC/IEEE
   15288 (2023), proceso por proceso, anclado a página impresa, con las **10
   filas que no son 1:1** explicadas en las dos direcciones.
2. **La lista de qué tiene INCOSE que NASA no**, con el ciclo iterativo/ágil
   desarrollado en **cuatro capas separadas**, porque el libro las separa a
   propósito y mezclarlas sería inventar.

**Citas 73/73 (100 %)**, medidas y saboteadas.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. El ancla se midió por DOS caminos, no por uno, y costó casi lo mismo.**
`impresa = PDF − 25`, confirmado por 321 de 370 encabezados **y** por 41 de 41
entradas del índice cruzadas contra el cuerpo. Un camino solo es una
suposición con un número al lado. Cuatro libros, cuatro offsets: NASA `+10`,
GtWR `−1`, Douglass no constante, SEH `+25`.

**2. La trampa de partición de palabras de este libro es la tercera variante
distinta en tres libros, y hubo que resolverla midiendo.** El de NASA parte
**sin** guion (`opera\ntions`), el GtWR **no parte**, y el SEH parte **con**
guion (`configura-\ntions`). Medidos 982 cortes. Unir todos rompe
`decision-\nmaking`; no unir ninguno deja `configura- tions` en cada cita. Se
decide **por palabra** contra el vocabulario del propio libro: 909 re-unidas,
74 dejadas, y el residuo se imprime con `-v` en vez de esconderse.

**3. Un rojo del medidor fue una cita VERDADERA del libro equivocado.**
*crosscutting tools for carrying out the processes* es de NASA p. 5 y estaba
en un archivo que se mide contra el `.txt` del SEH. No se "arregló" la cita:
se estableció la regla —**en la carpeta de un pilar, entre comillas va sólo
ese libro**— y las citas de los otros se referencian por su ficha. La
alternativa era un medidor por pilar, que es la copia que diverge.

**4. Un fallo del cruce índice↔cuerpo era del script del cruce, no del ancla.**
Daba 39/41 y los dos "fallos" eran páginas de apertura de capítulo cuyo texto
estaba ahí, en mayúsculas. La causa: el regex que partía páginas usaba un
lookahead de tres saltos de línea y se comía 13 páginas enteras — 357 de 370
capturadas. Partiendo por el marcador, como hace `pag.py`, dio **41/41**.
*Antes de dudar del dato, dudar del medidor.*

## HALLAZGOS QUE CAMBIAN UNA DECISIÓN (entradas a la fase 5)

1. **El SEH no menciona el NPR 7123.1 ni una vez.** El mapeo es **construido**,
   no citado, y la ficha lo dice en su sección 0. Cada fila lleva su grado de
   evidencia: `textual`, `probable` o `no 1:1`.
2. **El corte NASA 3/4 (lógico/físico) contra INCOSE T4/T5
   (arquitectura/diseño) no se puede cumplir a la vez sin duplicar
   artefactos.** La matriz de la fase 5 **elige uno y lo declara**.
3. **Verificación y validación aplican a ARTEFACTOS** (p. 138, 146): un
   requisito se verifica y se valida, una arquitectura también. En NASA eso
   está implícito en los reviews; acá es proceso, con lista de acciones por
   tipo de artefacto (p. 141-142 y 149-150).
4. **Una fase puede cerrar cancelando la siguiente** (p. 223): "the outcome of
   stage activity may simply be valuable learned knowledge that aborts the need
   for producing artifacts of use in other stages". El molde de fase actual no
   tiene esa salida.
5. **`perfil-global` es un System 3** —"the process improvement system that
   learns, configures, and matures System-2"— y el repo es el System 2
   (p. 223). Hoy viven mezclados en la misma cascada.
6. **El repo es una VSE perfil `Entry`** (ISO/IEC/IEEE 29110, p. 219): menos de
   6 personas. El tailoring no arranca de 30 procesos: arranca de un perfil.
7. **El eje `certain/uncertain × static/dynamic` (Fig. 4.3, p. 222) es el
   selector de naturaleza que falta.** Las naturalezas actuales clasifican por
   dominio; esto clasifica por incertidumbre, que es lo que decide el rigor. Y
   la Tabla 2.2 (p. 34) da el corte más barato: **¿se conocen los requisitos al
   empezar?** Si no: evolutivo.
8. **Las cuatro métricas de agilidad (p. 165-166) —timely, affordable,
   predictable, comprehensive— son medibles y nadie las mide.** Candidatas
   directas al medidor que le falta a la fase 7.
9. **La Matriz de Cumplimiento sigue con TRES fuentes, no cuatro.** El SEH
   **no** la agrega. Aporta el proceso de tailoring con IPO y las **cinco
   trampas** (p. 218), de las cuales cuatro describen errores ya cometidos acá.
10. **Los 10 temas de desafío del Lean SE (p. 226)**: el tema 4 —"Processes
    that are locally optimized and not integrated for the entire enterprise"—
    es el hallazgo C6-vs-C12 de la fase 2 dicho por otro libro.

## LO QUE SE TOCÓ FUERA DEL PROYECTO, Y POR QUÉ NO ROMPE LA REGLA 4

Nada vivo de la arquitectura. Sólo `perfil-global/pilares/incose-seh/`, que es
material de lectura nuevo. **No se tocó `verificar-citas.py`**: la fase 2 ya le
había puesto `--dir` y sirvió tal cual para el tercer libro.

## LO SIGUIENTE — fase 4: Rechtin & Maier

La cierra (PDP §4): ficha con las heurísticas de arquitectura que aplican a un
sistema de trabajo de una persona, **cada una con un caso propio ya vivido**.

Fuente en `perfil-global/pilares/fuentes/` (ver `INDICE.md`). **El ancla de
página hay que medirla otra vez** — van cuatro libros y cuatro offsets — y por
los dos caminos, que cuesta lo mismo.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
python perfil-global\pilares\fuentes\medir.py      # 10/10 OK
```

y después, sobre el PDF de Rechtin & Maier, el patrón ya probado tres veces:
medir `page_count` y caracteres **antes** de decidir cómo leer, extraer con la
tabla `TRAD`, **medir si el libro parte palabras y cómo** (las tres variantes
ya vistas: sin guion, con guion, no parte), y medir el offset por encabezados
**y** por índice.
