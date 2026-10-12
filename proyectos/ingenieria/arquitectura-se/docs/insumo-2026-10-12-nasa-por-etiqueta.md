# Insumo 2026-10-12 — NASA por etiqueta: las fases no exigen sus productos

> **De dónde sale.** Sesión de BLACK (129), el primer momento lluvia de ideas. Fran: «no puede ser que llevemos
> tantas sesiones usando NASA y que me digas ahora que no hay requerimientos definidos, ni que hayas hecho el
> ejercicio de alcance ni V&V»; «revisá bien la arquitectura y su implementación: no quisiera que no se ejecute una
> arquitectura de NASA por un bobo error de no leer un hook o de esperar la palabra mágica para que se active todo
> ese conocimiento». Y: «seguir el ciclo de vida NASA con ágil es seguirlo: de la ambigüedad y lo alto a lo bajo, con
> control de riesgo y el triángulo de hierro (desempeño, costo, plazo), hasta la fabricación; ágil en todo lo que es
> descubrimiento y prueba y error, para no hacer sesiones largas de diseño en el aire sin saber cómo es el sistema».
>
> Es un insumo de **validación** (fase 7, P10): una sesión real que mostró lo que la arquitectura no veía.

## 1. Lo medido (`medir-fases.py`, 2026-10-12)

`python proyectos/ingenieria/arquitectura-se/medir-fases.py`: la fase abierta de cada proyecto, tipada con las mismas
funciones que la compuerta (`.claude/hooks/fase_activa.py`), contra si declara requisitos en `.claude/cascada.json`.

| Hallazgo | Cuántos | Cuáles |
|---|---|---|
| **En fase NASA A–D sin requisitos declarados** | **6 de 22** | apunte-iise (B), **arquitectura-se (D)**, **black (C)**, cohete-de-agua (A), minecraft-amigos (D), software-de-vuelo (D) |
| Fase abierta sin tipo NASA | 8 | catedras, clase-asincronica-3, clases-aed, electronica-analogica, fisica-espacial, haberes-docentes, lavarropas-drean, metodo-agustin |
| Declara requisitos | 1 | telescopio (el control positivo: declara, existe, fase tipada) |

**Sobre el instrumento:** la primera versión dio «0 expuestos». Era falso: le pasaba una tupla a `tipo_de()`, cada
proyecto reventaba y el filtro contaba cero. Por eso ahora cuenta los reventados aparte, exige el control positivo y
sale con tres códigos (0 limpio, 1 expuestos, 2 instrumento roto).

## 2. Dónde la arquitectura depende de una palabra o de un campo opcional (la implementación, leída)

| # | Lugar | Qué hace hoy | Por qué falla abierto |
|---|---|---|---|
| 1 | `.claude/cascada.json` y `cascada_puerta.py` (`cli_exige`) | exige el documento de requisitos sólo si el proyecto lo declara (`"requisitos"`); el aviso «DISEÑO SIN REQUISITOS» sale sólo si la sesión declaró la **palabra** `diseno`, y es un aviso | opt-in: lo declara 1 proyecto de 22. BLACK declaraba `ingenieria-inversa` y nunca lo vio en rojo |
| 2 | `auditar-sesion.py`, P7 (≈ l. 333) | si el proyecto no declara requisitos, P7 = «NO APLICA» | falla abierto **por exclusión** (Saltzer): la ausencia del dato apaga el chequeo. Las auditorías de BLACK (128) y (129) dieron P7 NO APLICA con el proyecto en Fase C |
| 3 | `.claude/hooks/fase_activa.py` (`compuerta`) | imprime el tipo, PRODUCE, NO SE HACE y LA CIERRA | **informa, no verifica**: no mira si existen los productos de las fases anteriores; «sin tipo» sólo avisa (8 proyectos) |
| 4 | `plantillas/PDP.md` y los PDP | el criterio de salida lo escribe la propia sesión | ninguna fila exige los productos NASA de su fase. BLACK cerró la A con «habilitadores en K5» y la B con «PDR revisada», sin SRR ni línea base de requisitos |
| 5 | alcance y plan de V&V | no existen como artefacto declarado del método | nada los pide en ninguna capa |
| 6 | `.claude/arranque.md`, «EL DEFAULT ES EN FRÍO» | empuja a resolver en frío | sin el contrapeso ágil (spikes cortos para descubrir) produjo sesiones de diseño en el aire: la pieza 2 de BLACK, 13 sesiones |
| 7 | los conceptos de la puerta (`requisitos`, `typst`, `pcsx2`, `freno`) | se disparan por nombre de archivo o comando | está bien para lo que miran; **ninguno se dispara por la FASE** |

**El patrón común:** el conocimiento NASA está en el repo y llega a la sesión (libro de bolsillo, fichas, cátedra),
pero lo que lo **pone en práctica** se activa por una palabra, un campo opcional o la lectura de un aviso. Lo que
falta es que la **fase** del PDP —que ya se lee sola en cada acción— sea el disparador, y que falle cerrado.

## 3. La corrección: T13, «la fase manda»

Requisitos (escritos para el método; se pasan por `verificar-requisito.py` en la sesión que los construya):

| ID | Requisito | Verificación |
|---|---|---|
| M-01 | Cuando el PDP de un proyecto declara una fase abierta de tipo NASA A, B, C o D, el verificador del catálogo deberá dar rojo si el proyecto no declara su documento de requisitos o si ese documento no existe. | ensayo: proyecto sintético en Fase C sin requisitos → rojo; con requisitos → verde; saboteador |
| M-02 | Cuando un proyecto en fase A–D no declara requisitos, la auditoría de la sesión deberá dar ROJO en P7. | ensayo: caso nuevo del autotest de `auditar-sesion.py` |
| M-03 | Cuando la sesión entra a un proyecto en fase B, C o D, la compuerta de fase deberá listar los productos de las fases anteriores (alcance, requisitos en línea base, plan de V&V, registro de riesgos) con su ruta y si existen. | demostración |
| M-04 | Cuando falta un producto de una fase anterior, la puerta deberá negar las ediciones de diseño y fabricación del proyecto, salvo escribir el producto que falta y el registro (ESTADO, HANDOFF, PDP). | ensayo, con su saboteador y el control positivo parecido al real |
| M-05 | Toda fase abierta de un PDP deberá declarar su tipo NASA o declararse fuera del ciclo de vida (proyectos de seguimiento). | inspección por el verificador |
| M-06 | El arranque deberá decir «leer en frío, descubrir con spikes» en lugar de «el default es en frío». | inspección — **hecho en (129)** |

**Tailoring:** en un proyecto de documentos, los requisitos pueden ser los contenidos mínimos y los criterios de la
cátedra (`carrera`, `catedras`); el catálogo los declara igual. **Despliegue:** seis proyectos quedan en rojo hasta
tener requisitos; propuesta: rojo de entrada para C y D (black, arquitectura-se, minecraft-amigos, software-de-vuelo)
y aviso con fecha para A y B (apunte-iise, cohete-de-agua). Es un freno nuevo: el despliegue lo aprueba Fran (regla 6).

## 4. Lo que quedó hecho en (129) y lo que no

- **Hecho:** el momento lluvia de ideas como necesidad con disparador **medido** (cadencia de sesiones, no palabra:
  `lluvia-de-ideas.py`, autotest y sabotaje); la sección «NASA con ágil» en el libro de bolsillo
  (`perfil-global/pilares/nucleo-ise.md` §2b); M-06 en el arranque; la regla 11 del perfil; las lecciones; este
  insumo y su medidor.
- **No hecho:** M-01 a M-05 (tocan la puerta, el verificador y la auditoría: freno vivo, con saboteadores). Es la
  sesión T13, la próxima del método. BLACK escribe sus requisitos en su propia sesión.

## 4 bis. Construido (2026-10-12, sesión de arquitectura `de44da9d`)

Las decisiones de Fran (03:22) cambiaron el despliegue de §3: el freno actúa **al entrar** a cada proyecto expuesto
(no hay rojo de arranque por seis proyectos) y el verificador **lista**, no frena. Con eso, M-01 a M-05 se
reescribieron como requisitos del método (los del elemento VER, AUD, CMP y PTA en
[`10-requisitos.md`](10-requisitos.md) §4, 0 VIOLA del GtWR) y se construyeron así:

| Requisito | Dónde | Cómo se prueba |
|---|---|---|
| L2-PTA-01..03 (era M-04) | `cascada_puerta.py`: `fase_de()` tipa la fase con las funciones de la compuerta (una sola tabla); en `exigido()`, un proyecto sin documento declarado y en fase A–D recibe la nota `SIN REQUISITOS EN FASE`; `pre()` niega salvo escribir un `requisitos*.md` del proyecto o el registro; un PDP ilegible niega igual (`FASE ILEGIBLE`, falla cerrado) | autotest caso 16: 9 casos sobre un árbol sintético y 3 mutantes, cada uno visto en su caso |
| L2-VER-01/02 (eran M-01 y M-05) | `cascada_puerta.py --verificar`: líneas `EXPUESTOS` y `FASE SIN TIPO NASA`, sin `[FAIL]` | autotest caso 16 |
| L2-AUD-01 (era M-02) | `auditar-sesion.py`: `p7_de()` da ROJO en fase A–D sin documento | autotest: caso, mutante en proceso y control |
| L2-CMP-01..03 (era M-03) | `fase_activa.py`: `PRODUCTOS` con el documento de requisitos y las secciones 2, 5 y 7 del PDP (alcance, riesgos y plan de V&V **ya existían** en la plantilla: no hizo falta un artefacto nuevo, sólo mirar que no sean la plantilla) | autotest: 4 casos con mutante |
| todos | `probar-t13.py`: muta cada pieza en una copia y exige el rojo en SU caso | es el `--saboteador` de `defectos.py` |

Primer efecto, medido con el `--verificar` real: **5 expuestos** (apunte-iise B, black C, cohete-de-agua A,
minecraft-amigos D, software-de-vuelo D; arquitectura-se salió de la lista al escribir sus requisitos) y **8 fases sin
tipo**. Coincide con `medir-fases.py`, que mide lo mismo por otro camino.

## 5. El retome de T13 (pegar tal cual)

```
Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se): T13, «la fase manda». En la sesión 129 de BLACK Fran vio
que el coop cruzó las fases NASA A, B y C sin requisitos, alcance ni V&V, y pidió que NASA no dependa de leer un hook
ni de una palabra mágica. Medido con medir-fases.py: 6 de 22 proyectos en fases A–D sin requisitos. Esta sesión
construye M-01 a M-05 de docs/insumo-2026-10-12-nasa-por-etiqueta.md, fallando cerrado, con saboteadores.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER: `.\cascada.ps1 arquitectura-se -Necesidad metodo` y CON Read cada rango; después el insumo entero, el §4 de
   docs/t11-cascada-obligatoria.md (cómo frena la puerta y su autotest) y el código que se toca:
   .claude/hooks/cascada_puerta.py (cli_exige y cli_verificar), auditar-sesion.py (P7 y su autotest) y
   .claude/hooks/fase_activa.py (fase_abierta, tipo_de, compuerta). Al editar un archivo de hooks la puerta exige el
   concepto «freno» (chequeo «CUANDO PONES UN FRENO», saltzer-schroeder.md, mutation-testing.md): leerlo antes, y
   esa primera edición SOLA.
2. FASE: 7 -- NASA Phase D, "System Assembly, Integration and Test, Launch" = armar lo diseñado, probar que anda y
   ponerlo en marcha. No se hace: rediseñar sobre la marcha (un cambio de diseño vuelve al insumo). La cierra (PDP
   §4): una sesión real bajo la arquitectura nueva con su costo medido (P10); T13 es un insumo de esa validación.
3. QUÉ HACER, en orden:
   (a) M-01 a M-05 pasados por `verificar-requisito.py --idioma es` (quedan en el insumo).
   (b) M-01: `cascada_puerta.py --verificar` en rojo si un proyecto en fase A–D no declara requisitos o no existen;
       la lógica de medir-fases.py pasa a ser la del verificador y medir-fases.py su prueba.
   (c) M-02: auditar-sesion.py, P7 = ROJO (no NO APLICA) para un proyecto en fase A–D sin requisitos; caso nuevo en
       su autotest, visto en ROJO con la versión vieja.
   (d) M-03: la compuerta de fase lista los productos de las fases anteriores (alcance, requisitos, plan de V&V,
       riesgos) con su ruta y si existen. Decidir dónde se declaran (¿en la entrada del catálogo o en el PDP?) con
       el criterio de un dueño por dato (T2).
   (e) M-04: la puerta niega editar diseño o fabricación del proyecto si falta un producto anterior, salvo escribirlo
       y el registro (ESTADO, HANDOFF, PDP), igual que ya hace con los requisitos declarados y ausentes.
   (f) M-05: fase abierta sin tipo NASA -> rojo del verificador (o «fuera del ciclo» declarado).
   (g) Saboteadores: cada M en rojo con un mutante que ciega SU chequeo (llegó / cambió / salió), y el control
       positivo parecido al real (el telescopio, en verde).
   (h) DESPLIEGUE, pregunta de valor para Fran ANTES de prender: seis proyectos quedan en rojo (apunte-iise B,
       arquitectura-se D, black C, cohete-de-agua A, minecraft-amigos D, software-de-vuelo D). Propuesta: rojo de
       entrada para C y D, aviso con fecha para A y B; arquitectura-se declara su docs/requisitos.txt si pasa GtWR.
   (i) chequeo-completo.ps1 en verde, salvo los rojos del despliegue, declarados.
   (j) EL REGISTRO DE DEFECTOS (perfil-global/DEFECTOS-ARQUITECTURA.md, 37 defectos, nacido en (129)): enganchar
       `defectos.py resumen` al arranque (una línea, el medidor a la vista) y `defectos.py verificar`, `vista --check`,
       `--autotest` y `--sabotaje` a chequeo-completo. Los defectos que esta sesión cierra (DA-027 a DA-033, las
       grietas de este insumo) pasan por `defectos.py arreglar` con el commit, la prueba y el saboteador de cada M;
       validarlos exige 3 sesiones auditadas después: no se validan acá.
4. MOTOR: Opus 5.5, esfuerzo alto, un solo hilo: es un freno vivo, y un error lo deja abierto o encierra.
5. MÁQUINA: claude-acceso y perfil-global al día en origin. Respaldo: .claude\desinstalar-hooks.ps1.
6. YA RESUELTO: el diagnóstico y la medición (insumo §1-2); M-06 en .claude/arranque.md; «NASA con ágil» en
   nucleo-ise §2b; la regla 11 del perfil; la necesidad lluvia-de-ideas con su disparador medido; el registro de
   defectos de arquitectura (perfil-global/herramientas/defectos.py: autotest con 12 casos y sabotaje del
   verificador en rojo; DA-034, la revisión de rumbo, ya «arreglado» con el commit 4b50858).
7. TRAMPAS: un freno VIVO se edita en un orden que nunca lo deja roto (la puerta corre por puerta-lanzador.py y, si
   revienta, niega todo salvo repararla); la primera acción sobre un archivo con freno va sola; un sabotaje que da
   rojo por el motivo equivocado se ve igual que uno que anda.
8. ABIERTO: cómo se materializan «alcance» y «plan de V&V» (¿secciones del PDP o archivos?): se decide en (d).
9. MEDIR AL ENTRAR: `python proyectos/ingenieria/arquitectura-se/medir-fases.py` sale 1 con 6 expuestos; al cerrar
   T13, `cascada_puerta.py --verificar` da esos mismos en rojo (o los que Fran decida en (h)).

PRIMER COMANDO: .\cascada.ps1 arquitectura-se -Necesidad metodo
```
