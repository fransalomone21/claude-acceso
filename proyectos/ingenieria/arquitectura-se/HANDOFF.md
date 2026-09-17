# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

Sesión 6 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la quinta fase seguida así. **Cero PDF extraídos**: la fase 5 era
de diseño y sus entradas eran las cuatro fichas ya escritas.

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 5 CERRADA, abre la fase 6

La fase 5 cerraba por **documento de arquitectura + matriz de cumplimiento, con
trade study explícito**, y cerró por los tres, en `docs/`:

1. **`docs/arquitectura.md`** — 10 piezas (P1-P10) contra **14** defectos
   medidos. Cada pieza lleva su página de fuente, qué defecto cierra y **cómo
   se sabrá que está puesta**. Incluye el contraste de
   `ingenieria-de-sistemas.md` contra los libros y la medición que descubrió
   D14.
2. **`docs/trade-study.md`** — informe de análisis de decisión con las siete
   partes que pide NASA p. 164-165. Criterios **mandatorios separados de los
   ponderados** y escritos antes de puntuar.
3. **`docs/matriz-cumplimiento.md`** — el molde, el selector de rigor de dos
   ejes, y la **instancia llenada de este proyecto**: 38 filas, 3 recortadas
   con su resta escrita.

**Ningún archivo vivo tocado.**

## LA ARQUITECTURA ELEGIDA

**Catálogo de reglas derivado de sus fuentes + matriz de cumplimiento por
proyecto, con el rigor declarado por ASPECTO y no por proyecto.**

Ganó 810 sobre 900 contra dos alternativas: *evolución in situ* (430) y
*re-arquitectura por los 17 procesos* (400).

**Lo que NO cambia** es la mitad del diseño: la cascada de seis niveles, las
tres naturalezas, las cuatro reglas de estructura, las tres capas de frenos,
los cuatro saboteadores, los dos cuadros y el enrutado de modelo y esfuerzo.
Las naturalezas se quedan **con un trabajo más chico**: dicen qué se lee, y
dejan de decidir el rigor (eso pasa a P3).

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. Un trade study que empata está diciendo que los criterios están mal, y lo
que se rehace son las DEFINICIONES, no los pesos.** Primera pasada: A 610,
B 630 sobre 900 — 3,3 % de diferencia con cuatro de seis puntajes estimados a
ojo. Eso es un empate. El defecto estaba en C1: se puntuó *cuánto cambia* cada
alternativa en vez de *cuánto cuesta operar la que resulte*, y **cualquier
criterio que premie la quietud le da el máximo al statu quo antes de mirar si
el statu quo es caro**. Corregida la definición y sin tocar un peso: B 810,
A 430. Fuentes: Rechtin p. 402 y NASA p. 169-170, que es explícito en que se
revisan "not only the weights, but the basic definitions of what is being
measured".

**2. D14: el medidor de requisitos del repo es de idioma inglés.** Corrido
sobre los 10 requisitos de la arquitectura: **10 VIOLA, 3 REVISAR, y los 13
son falsos positivos de idioma**. R1 busca el literal `shall` y los diez dicen
«debe»; R5 marca la preposición española *a*; R6 y R33 toman el año 2026 por
una cantidad sin unidad. **Control positivo:** el mismo requisito traducido da
0 VIOLA. **Del otro lado:** un enunciado deliberadamente malo da 2 violaciones
en español y **6** en inglés. Señal nula en las dos direcciones: falso rojo
constante (100 % de los enunciados) y falsos verdes en las cuatro reglas
léxicas que más rinden. Su propia cabecera nombra el modo de falla: *"un
chequeo que grita donde no corresponde se apaga"*.

**3. Es la tercera vez que el mismo defecto aparece, y las tres se encontró
auditando lo que el medidor NO mira.** Fase 1: un regex de comillas miraba el
27 % del corpus. Fase 4: el denominador descartaba 19 spans. Fase 5: el idioma.
Ninguna de las tres se encontró leyendo la salida del medidor.

**4. Escribir la justificación de un recorte obliga a decidir si fue tailoring
o fue un error, y a veces la respuesta incomoda.** El gasto de la fase 0
(2,07 M tokens, un límite de 5 h en 6,6 minutos) estaba anotado en el `PDP.md`
§5 como riesgo "ya pasó" — sin resta. Escrita la resta: compró la lectura de un
libro que no entraba en una ventana, y las fases 1-4 se hicieron inline sin
perder nada. **La resta sale negativa: fue un error, no un tailoring.** La
columna de justificación es lo que fuerza esa distinción; sin ella el hecho
queda registrado y sin clasificar.

**5. Los requisitos se midieron DESPUÉS de elegir la arquitectura, y ahí
apareció D14.** No cambió la elección — pero medirlos antes habría costado lo
mismo y el defecto se habría sabido antes de escribir la sección.

## ENTRADAS A LA FASE 6, YA ESCRITAS

1. **Las 7 piezas con estado `no aplica — todavía`** en
   `docs/matriz-cumplimiento.md` §5 son el plan de la fase 6: P1, P4, P5, P6,
   P7, P10 y el campo de certificación del molde de fase.
2. **D12 (el `186` contra `204`)**: se **deriva** del registro, no se
   actualiza. `perfil-global/chequeo-de-trabajo.md:19` y
   `perfil-global/herramientas/aprender.py:243`.
3. **D14**: agregarle a `verificar-requisito.py` las listas del GtWR en
   español, con la misma estructura de dos severidades y su saboteador.
   **Condición de aceptación ya escrita**: 0 VIOLA sobre `docs/requisitos.txt`
   **y** 6 VIOLA sobre *"The method shall allow tailoring of any appropriate
   rule if necessary, etc."*. Sin la segunda mitad, el arreglo puede ser apagar
   R1 y nadie lo notaría.
4. **El medidor de desuso**: filas `recortado` con la justificación vacía =
   rojo. Es lo que hace cobrable el criterio C6 del trade study.
5. **`ingenieria-de-sistemas.md`** entra con las cuatro correcciones de
   `docs/arquitectura.md` §8 y con la pregunta abierta: reescrito contra las
   fichas, ¿sigue haciendo falta, o el catálogo P1 más las cuatro fichas ya lo
   reemplazan?
6. **El criterio de salida de la fase 6 ya está escrito** en el `PDP.md` §4:
   `chequeo-completo.ps1` en verde, los cuatro saboteadores corridos, y **un
   proyecto real ya migrado** a la matriz.

## LO QUE SE TOCÓ, Y POR QUÉ NO ROMPE LA REGLA 4

**Nada vivo.** Sólo `docs/` de este proyecto, que es nuevo. Lo que se actualizó
afuera son las filas de estado, en el mismo turno y por las reglas 4 y 7: la
fila del enrutador, las filas del contrato del proyecto y la fila 5 del
`PDP.md`.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
python perfil-global\pilares\fuentes\medir.py      # 10/10 OK
```

Y después, **leer `docs/arquitectura.md` §3 entero** antes de tocar nada: es la
lista de qué se instala y en qué orden. La fase 6 **sí** toca archivos vivos,
así que el rigor de esa fase es **pleno** (`docs/matriz-cumplimiento.md` §4,
aspecto `c`): backup y saboteador antes de cada pieza, no después.
