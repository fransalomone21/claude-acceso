# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 3 de N. **2026-09-16.** Opus, esfuerzo alto, **inline, sin un solo
subagente**. Cerrada con presupuesto de sobra: 5 h al ~31 %, semanal al 74 %
(entró al 74 %: **la fase entera costó 0 puntos del semanal**).

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Agile. Fran: "mínima ambigüedad posible", y las
necesidades que generaron la arquitectura actual **siguen valiendo**.

## ESTADO — fase 2 CERRADA, abre la fase 3

La fase 2 cerraba por dos cosas y cerró por las dos:

1. **`perfil-global/pilares/incose-gtwr/reglas.md`** — las 41 reglas y las 14
   características, numeradas y ancladas a página impresa, con definiciones
   textuales. **Citas 74/74 (100 %)**, medidas y saboteadas.
2. **`perfil-global/pilares/incose-gtwr/verificar-requisito.py`** — lee un
   requisito y dice qué regla viola. **32 de las 41 reglas**, las otras 9
   declaradas con motivo. Saboteador en verde.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. El ancla de página se mide sobre el libro que se está leyendo, y salió
distinta de la del handbook: `impresa = PDF − 1`.** No se midió en tres puntos
sino en **101**: el número impreso vive en el encabezado de cada página del
cuerpo, así que medirlas todas costó lo mismo que medir tres. Cruzada además
contra el índice en 41 de 41 reglas. Las 7 páginas sin número son tapa y
frente.

**2. El extractor a secas inventa citas, y no por partir palabras.** La trampa
del handbook (`opera\ntions`) **no aplica** al GtWR: se buscó y de 3.500
renglones hay un solo falso positivo. La que sí aplica es otra:
`NFKD + encode('ascii','ignore')` **borra comillas tipográficas y apóstrofos**
— `don't` sale `dont` y las listas de términos vagos pierden todas las
comillas. `extraer.py` traduce antes de tirar.

**3. La única cita que falló era figura interleaveada, y no se reparó: se
recortó.** La definición de *entity* cruza el salto de página y el extractor le
mete los rótulos de la Figura 2 en el medio. Citarla entera hubiera dado un
texto que el libro no tiene seguido. Es la misma clase de defecto que dejó 13
fallos en NASA.

**4. El GtWR casi nunca prohíbe una palabra: prohíbe un USO.** R5 prohíbe `a`
salvo en `an accuracy of`; R16 prohíbe `not` salvo el `NOT` lógico; R21
prohíbe corchetes salvo los de R15; R10 prohíbe `be able to` salvo en
necesidades. **Por eso el chequeo tiene dos severidades y no una**: una lista
negra plana convierte ejemplos que el libro acepta en rojos, y un chequeo que
se equivoca sobre su propia fuente se apaga.

**5. Y el libro choca consigo mismo en cinco lugares, cuatro de ellos
declarados.** El que **no** declara es `R24` vs `R32`: R24 lista `each` entre
los pronombres indefinidos a evitar y R32 **exige** `each`. Gana R32 — el libro
lo usa así en todos sus ejemplos aceptables. La tabla completa está en
`reglas.md`, sección 5.

## LO QUE ENCONTRARON LOS SABOTEADORES (y por eso existen)

- **R16 estaba en la matriz de cobertura y no tenía una sola línea de código.**
  La matriz se escribió primero y el código después. Lo agarró el control de
  coherencia — *toda regla declarada tiene que dispararse en algún caso* — que
  es el control que hace que la matriz no pueda mentir en verde.
- **El sabotaje al chequeo mismo falló en su primera versión, con razón.** R7
  tiene dos mecanismos independientes y vaciar uno no apaga al otro. El control
  estaba mal escrito. Ahora exige las dos cosas: que el mecanismo saboteado se
  apague **y que el otro siga vivo**.

## HALLAZGOS QUE CAMBIAN UNA DECISIÓN

1. **R39 (`/UniformLanguage/StyleGuide`, p. 84) dice que la organización elige
   qué reglas usa y lo escribe.** El GtWR **no pide cumplir las 41.** Es
   *tailoring* con matriz de cumplimiento, con otro nombre — el mismo hallazgo
   del handbook cap. 3.11 y del SEMP §9.0, ahora desde el segundo libro.
2. **C6 vs C12 (p. 37 y 47): cada pieza factible y el conjunto no.** Es el
   diagnóstico del método actual —cada freno es barato por separado— y hoy no
   lo mide ningún verificador del repo.
3. **La nota del principio de la sección 4 (p. 51) desactiva parte de las
   reglas para las NECESIDADES.** Sin eso, cualquier set de necesidades sale
   rojo entero.
4. **C7 (verificable) y R34 (medible) aplican directo al criterio de salida de
   una fase**: «la fase cierra con X medido» pasa; «revisar los archivos» no.

## LO QUE SE TOCÓ FUERA DEL PROYECTO, Y POR QUÉ NO ROMPE LA REGLA 4

Nada vivo de la arquitectura. `pilares/` es material de lectura. Lo único
ejecutable que cambió es `verificar-citas.py`, que ahora acepta `--dir` —
alternativa: una **copia** del medidor en la carpeta nueva, y la copia que
diverge es siempre la que nadie está mirando. Se re-midió NASA después del
cambio (**1424/1437 igual**) y se corrió su saboteador otra vez, en verde.
`probar-verificar-citas.ps1` ganó `-Dir` y `-Blanco`, con el default intacto.

## LO SIGUIENTE — fase 3: INCOSE SEH 5.ª ed.

La cierra (PDP §4): ficha con el **mapeo 17 procesos NASA ↔ procesos ISO
15288**, y la lista explícita de qué tiene INCOSE que NASA no — sobre todo el
ciclo iterativo/agile.

Fuente: `perfil-global/pilares/fuentes/incose-seh-5ed-2023.pdf` (y está también
la 4.ª ed., 2015, para contrastar ediciones si hace falta). **El ancla de
página hay que medirla otra vez**: ya van tres libros y tres offsets distintos.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

El `.txt` de cada libro vive en el scratchpad y **no sobrevive**. El del GtWR
se regenera con `pilares/incose-gtwr/extraer.py`. Para el SEH 5.ª:

```
python -c "import pymupdf,unicodedata;d=pymupdf.open(r'C:\Users\frans\Desktop\claude-acceso\perfil-global\pilares\fuentes\incose-seh-5ed-2023.pdf');print(d.page_count)"
```

y después el mismo patrón de `extraer.py`, **con la tabla de traducción de
comillas** — sin ella las citas salen sin apóstrofos y el medidor las da por
falsas (o peor: quedan reparadas a mano, que es inventarlas).

**Control positivo antes de creerle a la extracción:** `grep -c "shall"` tiene
que dar decenas de hits, y el offset PDF↔impresa se mide sobre **todas** las
páginas que tengan número en el encabezado, no sobre tres.
