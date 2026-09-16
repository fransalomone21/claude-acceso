# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 2 de N. **2026-09-16.** Opus, esfuerzo alto, **inline, sin un solo
subagente**. Cerrada con presupuesto de sobra: 5 h al ~20%, semanal al 73%.

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Agile. Fran: "mínima ambigüedad posible", y las
necesidades que generaron la arquitectura actual **siguen valiendo**.

## ESTADO — fase 1 CERRADA, abre la fase 2

La fase 1 cerraba por dos cosas y cerró por las dos:

1. **17/17 tramos del handbook destilados.** El libro está leído entero. Los
   dos últimos se hicieron inline en esta sesión: `planes.md` (ap. H-P,
   p. 214-243) y `conops-fase-e.md` (ap. R-T, p. 244-259).
2. **`verificar-citas.py` depurado, saboteado y re-medido: 1424/1437 (99,1%).**

## LO QUE SE APRENDIÓ MIDIENDO, Y CAMBIA CÓMO SE TRABAJA

**El medidor viejo no medía peor: medía otra cosa.** Daba 186/247 (75,3%) y su
peor defecto no se veía en la lista de fallos — apareaba mal las comillas y, al
desfasarse, **se comía el resto de cada línea**. Miraba 282 citas de las 1437
que hay: el 27% del corpus, elegido mal por él mismo.

Se auditaron **77 fallos a mano, uno por uno, contra el libro**. Cinco defectos
del medidor, todos documentados arriba de `verificar-citas.py` con el caso
concreto que los delató; y **8 defectos reales de fidelidad**, corregidos.

**Los 8 reales son casi todos la misma falla**, y por eso entró como regla 5
del contrato: *lo que el destilado agrega o saca va AFUERA de las comillas*.
Adentro va lo que dice el libro, aunque esté mal escrito (con el `[sic]`
afuera).

**Los 13 fallos que quedan son todos del extractor del PDF**, no de los
destilados, y están clasificados en `../../../perfil-global/pilares/nasa-seh/README.md`:
tablas intercaladas a mitad de oración, bloques desordenados, texto de figura
corrompido letra por letra.

**Y NO se tolera el hueco para llegar a 100%.** Se probó y se descartó a
propósito: una celda de tabla intercalada mide 14 caracteres y una cláusula que
el destilado se comió también — el medidor no puede distinguirlas, y la segunda
es justo lo que existe para ver. 99,1% con 13 explicados vale más que 100% con
un medidor sin filo.

## HALLAZGOS QUE CAMBIAN UNA DECISIÓN

1. **Los apéndices N (peer reviews) y P (checklist de SOW) NO ESTÁN en el
   Rev2.** Imprimen "This appendix has been removed" y remiten a la *Expanded
   Guidance*; O y Q dicen "Reserved". Ese material está en
   `perfil-global/pilares/fuentes/nasa-sp-2016-6105-SUPPL-expanded-guidance.pdf`,
   y cualquier ancla sobre esos temas va contra **ese** PDF.
2. **El corte de H-P estaba mal anotado**: arranca en la p. 214, no en la 216.
3. **El ancla de página de Douglass NO es constante** (+9, +8, +7 en p. 72, 193
   y 294). Cuando llegue su fase, la página impresa se lee de la página.
   Reinertsen sí: PDF = impresa + 14.
4. **Las 10 fuentes están.** Douglass y Reinertsen entraron esta sesión desde
   Descargas, con MD5 y páginas en `pilares/fuentes/INDICE.md`.

## EL HALLAZGO QUE MANDA LA REFORMA — sin cambios

Handbook **cap. 3.11, p. 34-42**: NASA tipifica proyectos **A-F** (tabla
3.11-1, p. 38) y después declara **producto por producto** `Fully Compliant` /
`Tailor` / `Not Applicable` (tabla 3.11-2, p. 39-40) en una **Matriz de
Cumplimiento** con justificación por línea, adjunta al SEMP.

**Y ahora hay una segunda fuente para lo mismo, más operativa:** el SEMP §9.0
(p. 232) dice `compliant / partially compliant / noncompliant`, que el que
cumple indique **con qué** y que el que no cumple escriba **por qué**. Las dos
mitades son la forma exacta de `.claude/datos-permitidos.json` y
`.claude/apuntes-publicos.json`: deny-by-default con excepción declarada.

## LO SIGUIENTE — fase 2: INCOSE GtWR

La cierra (PDP §4): ficha con las reglas numeradas y ancladas, **más un chequeo
mecánico** que lea un requisito escrito y diga qué regla viola. Sin la
herramienta, la fase no cierra.

Fuente: `perfil-global/pilares/fuentes/incose-gtwr-v3-2019.pdf`, 108 páginas,
MD5 en el `INDICE.md`. **El ancla de página hay que medirla**: la del handbook
(`+10`) es de ese libro y no vale para este.

## LO QUE NO SE TOCA
Ningún archivo vivo de la arquitectura. `CLAUDE.md` de la raíz, `cascada.ps1`,
las naturalezas y las plantillas siguen intactos: la migración es la fase 6,
después del diseño y del trade study.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

El texto ASCII del handbook vive en el scratchpad de la sesión y **no
sobrevive**. Para el GtWR hace falta el suyo:

```
python -c "import pymupdf,unicodedata;d=pymupdf.open(r'C:\Users\frans\Desktop\claude-acceso\perfil-global\pilares\fuentes\incose-gtwr-v3-2019.pdf');open('gtwr.txt','w',encoding='ascii').write(''.join('\n\n===== PAGINA %d =====\n'%i+unicodedata.normalize('NFKD',p.get_text()).encode('ascii','ignore').decode() for i,p in enumerate(d,1)))"
```

**Control positivo antes de creerle:** `grep -c "shall"` tiene que dar decenas
de hits, y el offset PDF↔impresa se mide en **3 puntos distintos** antes de
usarlo — Douglass ya demostró que puede no ser constante.
