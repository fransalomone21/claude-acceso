# HANDOFF — Apunte de Física Espacial

Lo que quedó a medias y las trampas ya pagadas. **El plan de fases y el
criterio de salida no están acá: están en `PDP.md` §4.** Este archivo no los
repite, porque un dato que vive en dos lados diverge.

---

## Fase 8 — CERRADA (sesión 8, 2026-09-13): fundamentos y orden

### Lo que hay que saber antes de tocar un módulo

**El número de un módulo no se escribe nunca a mano.** Va `#M("clave")` y sale
del orden de los `#include` de `apunte.typ`. La clave es el sufijo del nombre
del archivo (`m07-gravitacion.typ` → `"gravitacion"`), y se declara en el
propio `#modulo(..., clave: "...")`. Una clave inventada **rompe la
compilación** — `M()` hace `panic`, a propósito: un `??` impreso en rojo es un
aviso que se aprende a saltear.

**Las etiquetas internas también dejaron el número.** `<m12-coriolis-a>` es
ahora `<cin-coriolis-a>`: prefijo de clave abreviada, no de número. El mapa
completo es `vec cant cm coh ener grav angm dosc orb kep man cin iner euler
peon hip soi perif tres marcos`.

**Y hay una trampa nueva, pagada acá — la 10.**

### 10. Un `;` pegado a una llamada `#funcion()` desaparece del render

`#M("kepler");` imprime el número y **se come el punto y coma**: en markup, el
`;` cierra el modo código y no se escribe. Compila sin decir nada, y la frase
sale con dos cláusulas pegadas. `#[#M("x")];` tiene el mismo problema. Lo que
sí funciona: **`#M("x")#";"`**, o el escape `\u{3b}`.

Se detectó porque la conversión de las 355 referencias se verificó exigiendo
que el texto renderizado quedara **idéntico**, y aparecieron 17 líneas de
diferencia: los 10 `;` comidos. Sin esa exigencia la conversión habría pasado
por buena — y ése es el punto: *el chequeo que sirve para una transformación
que no debe cambiar nada es comparar el resultado contra el de antes*, no
mirar si compila.

```bash
# la receta, por si hay que repetirla
python -c "import pymupdf; d=pymupdf.open('apunte/apunte.pdf'); open('antes.txt','w',encoding='utf-8').writelines(p.get_text() for p in d)"
# ... el cambio ...
diff antes.txt despues.txt    # tiene que dar 0 lineas
```

### Qué se movió, y qué NO se tocó

- **Módulo nuevo**: `m02-marcos.typ`, Parte I. Es el primer módulo escrito
  desde el principio con las reglas 3 y 4 del contrato (cuadro `#posta` y «la
  idea completa antes de la primera ecuación»).
- **Las partes IV y V se dieron vuelta**: «De la cónica al viaje real» quedó
  4.ª y «Cuerpo rígido» 5.ª. Los archivos se renumeraron (`m13-hiperbola.typ`
  … `m20-peonza.typ`), así que **un módulo que se busque por número viejo no
  está donde dice el HANDOFF de antes de esta fase**.
- **Tres cuerpos dejó de depender de cuerpo rígido.** Las tres referencias de
  `m16-tres-cuerpos.typ` a la cinemática apuntan ahora a `#M("marcos")`, y la
  fórmula que usa es la `@marcos-rotante`, deducida para Omega constante.
  Cuerpo rígido la generaliza; no la funda.
- **NO se retrofittearon los cuadros `#posta` a los módulos viejos.** Sigue
  siendo deuda declarada, igual que antes.
- **NO se tocó el contenido de ningún módulo salvo cinco párrafos**: los tres
  de tres cuerpos, el del centro de masa (que ahora cita la `@marcos-galileo`
  en vez de enunciarla al pasar), el de dos cuerpos y dos de cinemática del
  cuerpo rígido.

### Lo que la fase 6 había dado por cubierto y no lo estaba

El `HANDOFF` de la fase 6 decía que Galileo estaba «deducido dos veces, no
menciones de pasada», y lo probaba con un `grep -in galileo`. Medido de nuevo:
uno de los dos hits era una línea suelta sin deducción, y el otro era Galileo
el de la caída de los cuerpos — otro hecho. *Un `grep` por el nombre propio
mide si la palabra está, no si el contenido está*, y para un fundamento esa
diferencia es la que importa. El chequeo que sí distingue es preguntar dónde
está la caja `#deduccion` correspondiente, no dónde está la palabra.

---

## Sesión 7 (segunda parte) — FASE 7 ABIERTA Y CERRADA EL MISMO DÍA

Fran pidió verificar que el roadmap estuviera completo y que la guía de
gravitación fuera resoluble con el apunte. **Esa verificación nunca se había
hecho**: la fase 6 había mirado el roadmap contra los módulos, pero nadie
había abierto la guía de la cátedra y cruzado problema por problema.

**El cruce cambió el alcance de la fase 7.** Se iba a abrir para escribir tres
anexos; resultó que los anexos resolvían un problema que el apunte no tenía, y
que lo que faltaba eran **dos palabras**. Están escritas y la fase cerró. El
detalle está en `PDP.md` §4, fase 7. Lo que hay que saber acá:

- La *energía específica* $epsilon$ quedó en el módulo 9, junto a la vis-viva
  (págs. 68-69 del PDF). La *geosincrónica / geoestacionaria*, en el módulo 6,
  junto a la cuenta que ya sacaba los 35 780 km (pág. 46). Las tres páginas se
  miraron en el render.
- El apunte siguió en **149 páginas**: los dos agregados entraron sin correr
  nada.

### La trampa de esta sesión, y cuesta media hora si se vuelve a caer

**`grep` de una frase de dos palabras sobre fuente Typst da falsos negativos.**
El fuente está envuelto a ancho fijo, la frase se parte entre dos líneas, y
grep trabaja por línea. Medido: `grep -ril "anomalía verdadera"` devolvió
**NADA** sobre un apunte que la usa en **seis** módulos, y estuvo a punto de
reportarse como hueco de contenido. Para frases hay que usar modo multilínea
con `\s+` entre palabras. La señal de alarma es el resultado mismo: un cero
sobre un concepto que el documento obviamente trata no es un hueco, es una
búsqueda mal parametrizada.

### Lo que queda para la próxima sesión, en orden

1. **Las otras cuatro secciones de la guía no se auditaron** —vectores,
   cantidad de movimiento, impulso angular, cuerpo rígido—. Fran pidió
   gravitación y eso se hizo. El método ya está probado y es barato: extraer
   el texto con PyMuPDF, renderizar como imagen sólo las páginas cuyos
   problemas son figuras, y cruzar con `grep` multilínea contra los módulos.
   La guía está en `Downloads\PROBLEMAS FÍSICA ESPACIAL (3).pdf` — **conviene
   copiarla a `fuentes/` en esa sesión**, porque Downloads no es parte del
   proyecto y el archivo puede desaparecer.
2. **Los tres anexos**, si Fran los quiere para estudiar. Ya no bloquean nada.
   Alcance y criterio de salida escritos en `PDP.md`.
3. **La ecuación de Kepler tiempo-anomalía** sigue siendo la única deuda de
   contenido, y arrastra los 3,2 días de la travesía de la esfera de
   influencia que `m18` cita sin deducir. No la pide la guía ni el plan de las
   17 semanas.

---

## Sesión 7 — EL APUNTE QUEDÓ CERRADO (2026-09-13)

No hay nada a medias. **El proyecto no tiene fase abierta y no se abre
ninguna.** Si una sesión futura lo retoma, que lea primero el encabezado de
`ESTADO_ACTUAL.md`: dice CERRADO y dice por qué.

**La trampa que esta sesión pagó, y que no hay que volver a pagar:** el
criterio de salida escrito de la fase 6 en `PDP.md` nombraba los anexos, y la
fase se había cerrado el mismo 2026-09-13 sin escribirlos, sin declararlo. No
fue mala fe: la sesión 6 cerró los tres pedidos que Fran hizo *de viva voz* y
nadie volvió a mirar el criterio escrito. **Cerrar contra lo que se pidió en
el chat en vez de contra lo que dice el PDP es la forma silenciosa de que un
criterio de salida deje de servir.** Quedó corregido en `PDP.md` §4.

**Los anexos son ahora la fase 7, opcional y con alcance definido** —
formulario, constantes y correspondencia con la cátedra, con su criterio de
salida escrito. Antes estaban «mencionados», que obligaba a inventarles el
alcance a cada sesión que los encontraba. El `#include` donde engancharían
sigue comentado en `apunte/apunte.typ:134`.

**Deuda de contenido que sobrevive al cierre, y es la única:** la ecuación de
Kepler tiempo-anomalía, ya declarada como tal en 17.6, 18.5 y 19.7. El apunte
la nombra y dice que no la deduce; eso es honesto y no es un hueco tapado.

**El PDF se publica solo en el Drive de los compañeros** desde esta sesión:
`publicar-apuntes.ps1` en la raíz del repo, con `apunte.pdf` declarado en
`.claude/apuntes-publicos.json`. Si alguna vez se abre la fase 7 y el apunte
cambia, el medidor del arranque avisa que Drive quedó atrasado — no hace
falta acordarse de subirlo.

---

## Cómo se compila y cómo se mira

```powershell
.\compilar.bat            # el apunte entero
.\compilar.bat galeria    # solo las figuras (segundos)
```

Y para mirar el render sin abrir el visor —que es lo que hace la sesión—:

```bash
python -c "import pymupdf; d=pymupdf.open('apunte/apunte.pdf'); [p.get_pixmap(dpi=108).save(f'p{i+1:02d}.png') for i,p in enumerate(d)]"
```

`pdftoppm` **no está instalado**, así que el lector de PDF de la sesión no
puede rasterizar solo: hay que pasar por PyMuPDF. Vale también para leer los
escaneos de la cátedra y **los enunciados de la guía, que son imágenes**.

### Un chequeo que no cuesta mirar 35 páginas

El huérfano de caja se detecta sin ojos: se busca si la última línea de una
página es un título de cuadro.

```bash
python -c "
import pymupdf,re
d=pymupdf.open('apunte/apunte.pdf')
pat=re.compile(r'^(DE D.NDE SALE|CUIDADO|IDEA CLAVE|OJO CON|DEFINICI.N|EJEMPLO|DE LA GU.A|QU. VAS)')
for i,p in enumerate(d):
    ls=[l.strip() for l in p.get_text().split('\n') if l.strip()]
    if ls and any(pat.match(l) for l in ls[-2:]): print('pag', i+1, ls[-2:])
"
```

## Fase 6 — CERRADA para este apunte (sesión 6, 2026-09-13)

Los tres pedidos que Fran hizo al cerrar la fase 5 se resolvieron en la misma
sesión, apenas Fran agregó el roadmap y los tres libros a
`Desktop\Mis Documentos\SistemasEspaciales\Libros de Fisica\`:

1. **El roadmap en PDF** (`Road Map.pdf`) resultó ser el Apéndice B de
   Curtis, *Orbital mechanics for engineering students* — un diagrama de
   flujo (Fig. B.1) de sus capítulos 1-3: leyes de Newton → ecuación de dos
   cuerpos → energía mecánica → fórmula de la órbita (1ª ley de Kepler) →
   $v_\perp$, $v_r$ → 2ª y 3ª ley de Kepler → ecuaciones de Kepler
   (anomalía verdadera vs. tiempo). **Los cinco primeros bloques ya están
   deducidos en los módulos 6-10** (no citados: deducidos, que es lo que
   Fran pidió como estándar — "que no tenga que ir a internet"). El único
   nodo sin cubrir es el último, la ecuación de Kepler tiempo-anomalía, que
   **ya está declarada como deuda conocida** en 17.6, 18.5 y 19.7. El
   roadmap no reveló ningún hueco nuevo: confirma que el apunte ya sigue esa
   misma cadena lógica.
2. **La auditoría de fundamentos** (ejemplo dado: Galileo) — `grep -in
   galileo apunte/modulos/*.typ` da dos hits: la transformación de Galileo
   en `m3-centro-de-masa.typ:93` y la independencia peso/masa en
   `m6-gravitacion.typ:89` ("eso ya se sabía desde Galileo"). Las dos son
   deducciones propias, no menciones de pasada. Cerrado con lo que ya
   había — no hizo falta escribir nada nuevo.
3. **Los temas del Taller de Física** se mudaron a un proyecto propio:
   [`../taller-de-fisica/`](../taller-de-fisica/CLAUDE.md). El Taller es
   materia aparte (palabras de Fran) y mezclarlo acá rompía el título de
   este apunte, ya cerrado en 149 páginas verificadas. Las tres fuentes
   (Ferraro, Pisacane, Young-Freedman) están localizadas y el recorte de
   contenido decidido en ese proyecto — **fase de escritura bloqueada a
   propósito**, Fran dijo que la va a arrancar en otro momento. Nada de eso
   toca este apunte.

Con los tres pedidos resueltos, la fase 6 de `fisica-espacial` queda cerrada
sin haber tocado un solo módulo — el hallazgo fue que no hacía falta.

---

## Fase 5 — CERRADA (sesión 5, 2026-09-13)

**Las dos tareas del cierre están hechas.**

1. **Referencias cruzadas de texto plano — validadas para los 19 módulos**, no
   sólo la Parte V. La tabla que estaba en «Lo que sigue abierto, a
   propósito» (módulos 1 a 11) se armó **a mano** en su momento y quedó
   **incompleta**: un `grep -oP '[Mm]ódulo \K\d+'` por módulo, leyendo cada
   coincidencia en contexto para descartar falsos positivos (`módulo` como
   *magnitud de un vector* — sólo uno real, "vector de módulo 1" en
   `m1-vectores.typ:31`) y sumando las referencias elípticas que el patrón
   simple no agarra (`"en los módulos 6 y 7"`, `"y en el 10"`, `"módulos 7 al
   11"`), encontró **7 filas con números faltantes**:

   | Módulo | Tabla vieja | Faltaba | Confirmado en contexto |
   |---|---|---|---|
   | 2 | 4, 5, 7, 14 | **3** | línea 381: "el módulo 3 permite decir que el CM..." |
   | 3 | 4, 8, 13 | **2** | 6 menciones (choques, rapideces, dos números) |
   | 5 | 6, 7, 9, 10 | **1, 2, 3, 4** | producto escalar (1), P=0 (2), CM (3), cohete (4) |
   | 6 | 5, 8, 9, 10, 11 | **4, 7** | combustible del cohete (4), dirección de v en B (7) |
   | 7 | 1, 2, 3, 5, 9, 10, 11, 14 | **6** | "el módulo 6 dio la rapidez por energía" |
   | 16 | 6, 9, 11 | **7, 17** | $h=rv$ del módulo 7; todo M17 anticipado 6 veces |
   | 17 | 4, 8, 11, 16, 19 | **6, 9** | velocidad de escape (6), ecuación de la órbita (9) |

   Los módulos 1, 4, 8, 9, 10, 11, 18, 19 ya estaban completos. **Ninguna
   referencia, vieja o nueva, apunta a un módulo inexistente.** La tabla de
   abajo («Lo que sigue abierto, a propósito») ya quedó reescrita con las 19
   filas (1 a 19) y esto es lo que cierra la fase.

   **Los módulos 12 a 15 (Parte IV) nunca habían entrado a esta tabla** — el
   plan de la fase 5 sólo hablaba de 1-11 y 16-19. Se agregaron igual porque
   el pedido de esta sesión era «TODOS los módulos» y el mismo grep ya los
   tenía medidos: M12 → 1, 3, 7, 13, 14, 15; M13 → 7, 8, 12, 14, 15; M14 →
   12, 13, 15; M15 → 7, 12, 13, 14. Los cuatro, limpios.

2. **El blanco al pie de la pág. 30 impresa (PDF pág. 34): mirado y declarado
   aceptable, no se toca.** Es un salto de página normal, no un huérfano: el
   §5.3 termina con la ec. (9) y la `Figura 1` (con su caption) no entraba
   completa en lo que quedaba de página, así que Typst la enteró en la pág.
   31. No hay caja cortada ni título de cuadro huérfano — eso ya lo cubre el
   chequeo de huérfanos, que sigue en cero. Reordenar 149 páginas ya
   verificadas para ahorrar un salto de página estético no vale el riesgo
   (regla 6, cambios mínimos) y no hay otro problema real que resolver.

`docs/figuras.md` ya quedó al día en la sesión 4, con las tres figuras del
M19 en el catálogo y dos reglas nuevas (la 11 y la 12).

**Lo que el M19 dejó hecho y NO hay que rehacer:**

- Curtis §2.12 entero: marco co-rotante, las tres ecuaciones de movimiento,
  los cinco puntos (los dos triangulares deducidos exactos, los tres
  colineales por bisección), estabilidad, y la constante de Jacobi con sus
  curvas de velocidad cero.
- **Los números, todos recalculados desde cero** y coincidentes con los del
  libro: $\xi_1 = 0{,}83692$, $\xi_2 = 1{,}15568$, $\xi_3 = -1{,}00506$;
  $C_1 = -1{,}6735$, $C_2 = -1{,}6650$, $C_3 = -1{,}5810$,
  $C_{4,5} = -1{,}5683$; las seis velocidades de apagado del ejemplo 2.17
  (10,8455 a 10,8676 km/s).
- **La comparación Hill contra esfera de influencia**, que es propia del
  apunte y no está en Curtis: $r_\text{Hill} = r_{12}(m_2/3m_1)^{1/3}$
  deducida a primer orden, la razón con exponente $-1/15$, y el hecho medido
  de que $L_1$ y $L_2$ del par Sol–Tierra caen **afuera** de la esfera de
  influencia de la Tierra.
- **Dos erratas más de Curtis** (van cinco), las dos en el ejemplo 2.17 y las
  dos confirmadas contra el propio libro: $x_1 = -\pi_1 r_{12}$ donde va
  $-\pi_2 r_{12}$ (el producto impreso no da el resultado impreso), y
  $m_1 = 5{,}947 \times 10^{24}$ donde va $5{,}974 \times 10^{24}$.
- **La deuda de la ecuación de Kepler queda como estaba**, y ya está declarada
  adentro del apunte en tres lugares (17.6, 18.5 y 19.7). No hay que tocar
  nada de eso: es tema del capítulo 3 de Curtis y de una fase futura, si
  alguna vez se decide.

---

## Lo que la sesión del M19 necesitaba (histórico, ya consumido)

**Las dos fuentes, con los offsets MEDIDOS.** Localizar los PDFs con
`glob.glob` sobre `Desktop\Mis Documentos\SistemasEspaciales\Libros de
Fisica\`, **nunca escribiendo la ruta a mano**: tiene acentos y el heredoc se
los come.

| Libro | Offset | Estado |
|---|---|---|
| Curtis, *Orbital mechanics for engineering students* (2020) | impresa = PDF − 8 | medido, usado cuatro veces |
| Bate–Mueller–White, *Fundamentals of astrodynamics* (1971) | impresa = PDF − 15 | **medido el 2026-09-08** |

**El Bate SÍ está en el disco** — la sesión 2 anotó que no, y era falso. Está
en la misma carpeta que el Curtis, como `Roger  R. Bate, Donald D. Mueller,
Jerry E. White - Fundamentals of astrodynamics-Dover Publications (1971).pdf`
(ojo: **dos espacios** entre «Roger» y «R.», por eso conviene el glob). Es un
escaneo con OCR flojo: las fórmulas salen rotas al extraer texto, pero la
prosa se lee bien y las secciones se ubican con regex sobre `2\.\d`.

Secciones ya localizadas y leídas (números de PDF, confirmados abriéndolas):

| Fuente | Qué | PDF | Impresa |
|---|---|---|---|
| Curtis §2.10 | marco perifocal | 110 | 102 |
| Curtis §2.11 | coeficientes de Lagrange | 113 | 105 |
| **Curtis §2.12** | **tres cuerpos restringido — es el M19** | **124** | **116** |
| Bate §2.2.4 | sistema perifocal | 72 | 57 |
| Bate §2.3 | los seis elementos orbitales clásicos | 73 | 58 |
| Bate §2.4 | los elementos a partir de $r$ y $v$ | 76 | 61 |
| Bate §2.5.1 | $r$ y $v$ en el sistema perifocal | 87 | 72 |

La fila de §2.12 **corrige** la que dejó la sesión 2, que decía «~45»: eso era
un error de tipeo del índice y habría mandado a la sesión del M19 a leer el
capítulo 1.

**Lo que el M18 ya dejó hecho y NO hay que rehacer:**

- El marco perifocal entero, con las dos fórmulas ($bold(r)$ y $bold(v)$) y su
  deducción, más la figura `fig-perifocal`.
- Los seis elementos orbitales del Bate, con la receta de los tres vectores
  ($bold(h)$, $bold(n)$, $bold(e)$), los seis cosenos, los tres chequeos de
  cuadrante y los dos casos degenerados. Con eso, la fila «parámetros
  orbitales del Bate» de la lista de la cátedra queda cubierta.
- Los coeficientes de Lagrange en las dos versiones (exacta en $Delta nu$ y
  serie en $Delta t$), la identidad $f dot(g) - dot(f) g = 1$ y la figura
  `fig-lagrange-base`.
- Una tercera errata de Curtis: **ejemplo 2.13, $r_0 = 10 thin 861$ km donde
  va $10 thin 681$** (confirmada porque con $10 thin 861$ no sale el
  $h = 75 thin 366$ que el propio libro imprime).

**Lo que el M19 hereda como deuda declarada.** Los $3,2$ días adentro de la
esfera de influencia (sección 17.6) **siguen citados y no deducidos**: hace
falta la ecuación de Kepler hiperbólica, que el M18 nombró y no desarrolló
(sección 18.5). Si el M19 tampoco la desarrolla —y no debería, no es su tema—,
la deuda queda como está y ya está dicha adentro del apunte, así que **no hay
que volver a la 17.6 a tocar nada**.

**Lo que el M17 ya dejó hecho y NO hay que rehacer:**

- La esfera de influencia entera: los dos puntos de vista, las dos razones de
  perturbación, el exponente 2/5 con su explicación (el término solar es una
  *diferencia*, o sea marea, y de ahí el 3 contra el 2), la tabla de siete
  cuerpos calculada, y el método de las cónicas parcheadas con sus dos
  figuras nuevas.
- El ejemplo Tierra→Marte queda **cerrado de punta a punta**: $v_\infty =
  2,943$ km/s, $e = 1,145$, $v_p = 11,32$ km/s, $\Delta v = 3,590$ km/s,
  $\beta = 29,2°$, $\Delta m/m = 0,705$. No hace falta volver a tocarlo.
- La auditoría del método (sección 17.6): en la frontera $v = 3,086$ km/s
  (4,9% de error) y $\nu = 149,3°$ contra $\nu_\infty = 150,8°$ (1,5°). Los
  **3,2 días adentro de la esfera están citados, no deducidos**: necesitan la
  ecuación de Kepler hiperbólica, que el apunte no desarrolla. Si el M18 o el
  M19 llegan a desarrollarla, ese número pasa a ser deducible y conviene
  volver a la 17.6 a decirlo.
- **Dos erratas de Curtis**, confirmadas cada una por el resultado impreso del
  propio libro: el ejemplo 8.4(b) escribe 368.600 en el denominador donde va
  $\mu_T$ = 398.600 (con 368.600 no sale el 29,16° que el libro imprime), y el
  ejemplo 8.3 escribe $1,989 \times 10^{24}$ donde va $10^{30}$ (con $10^{24}$
  no salen los 925.000 km que imprime).

**Las dos reglas propias que aplican a todo módulo de la Parte V** (reglas 3 y
4 del `CLAUDE.md`): sección «la idea completa, antes de la primera ecuación» al
principio, y al menos un `#posta` por tema no trivial. M16 y M17 son los dos
ejemplos de referencia. El M17 agrega un patrón que conviene repetir donde
haya una aproximación: **una sección entera que mide el error del propio
método** antes de darlo por bueno (la 17.6, «Cuánto cuesta la mentira»).

**Figuras.** Las seis de la Parte V ya están: `fig-hiperbola-geometria`,
`fig-hiperbola-energia`, `fig-esfera-influencia`, `fig-conicas-parcheadas`,
`fig-perifocal` y `fig-lagrange-base`. Ninguna necesitó helper nuevo:
`flecha`, `angulo`, `elipse-orbital`, `rotulo` y `masa` alcanzaron para las
seis, y `estilo.typ` no se tocó desde el M12.

`docs/figuras.md` va por la **regla 10**. Las tres últimas son de la Parte V y
las tres son de colocación, no de dibujo: la 8 (mostrar que algo es un punto
sin agrandarlo), la 9 (dos vectores colineales no se dibujan como dos flechas
— la larga tapa a la corta) y la 10 (dónde va el punto móvil lo deciden sus
proyecciones, no la estética).

## Las trampas de Typst ya pagadas

**1. Una fracción se come sólo el átomo siguiente.** `X / |bold(A)|` sale como
$X$ sobre la barra vertical; `b / cos theta` sale como $b/\cos$ multiplicado por
$\theta$. Las dos compilan perfecto y salen mal impresas.

- Para módulos: usar **`abs(...)`**, nunca `|...|` dentro de una fracción.
- Para funciones trigonométricas: **paréntesis explícitos**, `b / (cos theta)`.

**2. El título de una caja pasa por `upper()`.** Un título escrito como fórmula
sale «D R̂ / DT» y no se lee. *Los títulos de las cajas van en palabras.*
**Vale para las seis cajas, no sólo para `#definicion`:** en el módulo 13
la trampa volvió a pagarse en un título de `#deduccion` (`"por qué la
energía cinética de rotación es $1/2 bold(omega) dot bold(H)_G$"`) y uno de
`#ejemplo`, los dos con una fórmula metida en el string que después pasa
entero por `upper()` y sale como código fuente en mayúsculas. El chequeo es
mirar el render de cada caja nueva, no sólo las `#definicion`.

**3. CeTZ quiere `angle` en `arc`, y el resto de la figura quiere números.**
Resuelto dentro del helper `angulo`. Si aparece `cannot compare angle and
integer`, es un `arc` llamado a mano sin `* 1deg`.

**4. El rótulo de un vector corto, en la punta.** Ver `docs/figuras.md`, regla 1.

**5. La coma decimal adentro de una función matemática parte los argumentos.**
`sqrt(5,36^2 + 14,64^2)` no es una raíz de una suma: Typst lo lee como `sqrt`
con *dos* argumentos y tira `error: unexpected argument`, señalando una línea
que a la vista está perfecta. Vale para `sqrt`, `abs`, `frac`, `root`, `vec`,
`binom` y cualquier otra que reciba argumentos.
*Regla: ninguna coma decimal adentro de un paréntesis de función.* Se
reescribe: `abs(v)^2 = 5,36^2 + 14,64^2 = 243,1 ==> abs(v) = 15,59`.

**6. `{,}` no hace falta y encima se ve.** La plantilla ya trae un
`show ","` que le saca el espacio a la coma decimal, así que `$29,3$` sale
bien. Escribir `$29{,}3$` imprime las llaves. En las **figuras** —que la
galería compila *sin* la plantilla— los números con coma van como contenido de
texto plano, `[29,3]`, no como fórmula.

**6b. La trampa 6 tiene una mitad que no estaba escrita: el rótulo que MEZCLA
símbolo y número.** La regla decía «en las figuras los números con coma van
como texto plano, `[29,3]`». Lo que no decía es qué hacer cuando el rótulo es
`$C_3 = -1,581$` — donde el símbolo y el signo menos *sí* quieren modo
matemático. Escrito entero como fórmula, en la galería sale «−1, 581» con un
espacio; escrito entero como texto, el subíndice sale como `C_3` literal.

*La salida es partirlo*: `[$C_3$ = $-$1,581]`. Cada pedazo en el modo que le
corresponde, y el número —lo único que la coma toca— en texto plano. Pagada
el 2026-09-11 en `fig-jacobi-perfil`, con tres rótulos a la vez.

**7. Un `#v(-3pt)` después de un `block` no es lo mismo que después de texto
suelto.** Entre bloques, un `v()` explícito *reemplaza* el espaciado
automático en vez de sumarse: la caja quedó con el título encimado sobre la
primera línea. Si el título va en su propio `block`, el espacio se pone con
`below:` y se saca el `v()`.

**8. `**negrita**` no existe en Typst: la negrita es `*así*`.** Con dos
asteriscos el compilador avisa «no text within stars» —es sólo un *warning*, no
un error— y el documento sale **sin la negrita**, que es peor que fallar. Y
ojo con anidarlos: un `*énfasis*` adentro de otro `*énfasis*` corta el de
afuera en el lugar equivocado.

**8b. La fracción de la trampa 1, en dos formas nuevas que ya se pagaron.** La
regla es la misma —`/` se come sólo el átomo siguiente— pero las dos formas en
que aparece con *números* no se ven venir:

- **La coma decimal parte el denominador.** `8200/0,9777` se imprime como
  `8200/0` seguido de `,9777`. Compila sin decir nada.
- **Un `thin` parte el denominador.** `3600/17 thin 156` sale como `3600/17`
  seguido de `156`, que es justo el separador de miles que se estaba tratando
  de escribir.

*Regla: todo denominador con más de un carácter va entre paréntesis* —
`8200/(0,9777)`, `3600/(17 thin 156)`— aunque «se vea» como un número solo.

**Y del lado del numerador pasa exactamente lo mismo, pagado en el módulo 4
de esta sesión.** `198 thin 000 / (6 + 9,81)` no salió mal por el
denominador —ya estaba entre paréntesis— sino porque `/` sólo agarra el
átomo *inmediatamente anterior*, que es `000`, no `198 thin 000`: salió
«$198\frac{000}{6+9{,}81}$», con el 198 flotando afuera de la fracción. La
regla de arriba es de los dos lados: *todo numerador con más de un carácter
también va entre paréntesis*, `(198 thin 000) / (6 + 9,81)`.

**8c. La trampa 5 es más chica de lo que decía, y saberlo ahorra paréntesis.**
La coma decimal rompe una función sólo si queda en el **nivel superior** de sus
argumentos: `sqrt(3,269 times 10^9)` falla, pero
`sqrt((3,986 times 10^5)(8200))` compila perfecto, porque ahí la coma está
adentro de un paréntesis anidado. Cuando el paréntesis no se puede poner sin
que se imprima, la salida es reescribir la ecuación despejando el cuadrado:
`h^2 = ... = 3,269 times 10^9 ==> h = ...` en vez de `h = sqrt(3,269 ...)`.

**10. En modo matemático, un identificador de más de una letra se resuelve
contra el ámbito de Typst.** Una figura con `let nu = 125` adentro hizo que
`$nu$` imprimiera **125** en vez de la letra griega: Typst busca `nu` primero
como variable y sólo si no existe usa el símbolo. Compila sin warning y sale
mal. Las de una sola letra (`a`, `b`, `r`, `p`, `e`) no tienen el problema:
esas siempre son letras.
*Regla: en el código de una figura, ninguna variable se llama como una letra
griega ni como una función matemática* (`nu`, `mu`, `pi`, `alpha`, `min`,
`max`, `sqrt`). En `fig-elipse-geometria` la anomalía verdadera se llama
`anom`.

**12. Un símbolo suelto como `°` también parte una fracción — mismo mecanismo
que la trampa 1/8b, disfraz nuevo.** `360°/x` no es «360 grados sobre x»: el
`/` sólo agarra el átomo *inmediatamente* anterior, que acá es `°` solo, no
`360°`. Compila sin avisar y el número que sale es el mismo por casualidad
(°=1 en el cálculo), pero el renglón se ve mal —el grado queda flotando
arriba de la barra de fracción, separado del 360— y con otro símbolo al lado
(una coma, un `thin`) el número sí sale mal. Vale para los dos lados de la
fracción: `Delta phi/360°` y `360°/T` fallan igual.
*Regla: todo numerador o denominador de más de un token —número más símbolo,
número más `thin`, número más coma— va entre paréntesis*, `(Delta phi)/(360°)`.
Pagada tres veces en el módulo 11 (Hohmann y la órbita de fasaje).

**11. Los títulos de las cajas ya traen su prefijo.** `#deduccion("...")`
imprime «DE DÓNDE SALE — ...» y `#definicion("...")` imprime «DEFINICIÓN —
...». Escribir `#deduccion("de dónde sale el potencial eficaz")` sale
«DE DÓNDE SALE — DE DÓNDE SALE EL POTENCIAL EFICAZ». El título que se pasa es
sólo el complemento.

**13. Una unidad escrita como texto plano se parte en la barra.** `100 rad/s`
en medio de un párrafo puede cortarse como «100 rad/» al final de un renglón y
«s» al principio del siguiente: Typst trata la barra como punto de corte
válido. No es un error y compila sin decir nada. *Las unidades van en modo
matemático como cadena*, `$100 " rad/s"$`, que no se parte.

**5b. La trampa 5 es de las FUNCIONES, no de todo lo que lleva paréntesis.**
`arctan(0,005)` **compila y sale bien**: `arctan` es un *operador* —contenido,
no una función—, así que el paréntesis que le sigue es un grupo matemático
común y la coma de adentro es una coma decimal. `sqrt`, `abs`, `frac`, `root`,
`vec`, `binom` sí son funciones, y ahí la coma parte los argumentos. La regla
corta: *si el nombre se imprime en redonda como palabra (`sin`, `cos`, `tan`,
`arctan`, `log`, `lim`), es operador y la coma no molesta; si el nombre
desaparece al imprimirse (`sqrt`, `abs`, `frac`), es función y la coma rompe.*

**9. El heredoc de Bash + una cadena de Python se comen el `\` final de línea.**
Escribir figuras con `python - << 'EOF'` y un `u'''...'''` adentro hizo
desaparecer los saltos de línea de Typst (el `\` al final de un renglón), y el
rótulo salió como un párrafo de una sola línea que estiró el lienzo. *Los
bloques de Typst con `\` se escriben con la herramienta de archivos, o a un
archivo aparte que después se inserta leyéndolo* — nunca pegados dentro de un
heredoc.

**9b. La misma trampa 9, con la otra mitad del daño: la barra invertida no
sólo desaparece — se convierte en un carácter de control invisible.** Escribir
`\times`, `\frac`, `\alpha` o `\beta` dentro de una cadena de Python que viaja
por un heredoc de Bash deja en el archivo un TAB (de `\t`), un salto de página
(de `\f`), un BEL (de `\a`) o un backspace (de `\b`): Python los interpreta
como secuencias de escape y avisa sólo de las que no reconoce (`\d`, `\O`),
que son justo las que salen bien. El archivo queda corrupto y **se ve normal
en la terminal**: un TAB dentro de `\times` se lee como un espacio.

Pasado dos veces en este proyecto, y la primera recién se descubrió en la
tercera: el `$E_"mec" = \frac12 …$` de la errata de la cátedra vivió con un
salto de página en lugar de la `\f` desde la fase 3 hasta el 2026-08-31.

*Regla: ningún texto con barras invertidas se escribe con `python - << EOF`.*
Va con la herramienta de archivos, o a un archivo aparte que después se lee y
se inserta. Y el chequeo que lo atrapa —tres segundos— es:

```bash
python -c "
import io
s = io.open('ARCHIVO', encoding='utf-8').read()
print({ord(c) for c in s if c != chr(10) and ord(c) < 32} or 'limpio')
"
```

**14. Una `@referencia` a una ecuación de OTRO módulo imprime el número del
contador del módulo de destino, no del propio.** El contador de ecuaciones se
resetea en cada `#modulo`, así que `@m9-e-E` citada desde el módulo 16 se
imprime «ec. (16)» — el número que esa ecuación tiene *dentro del módulo 9*.
El lector, parado en el módulo 16, busca la ecuación 16 de la página que está
mirando y no la encuentra. El enlace funciona (es clicable) y el compilador no
tiene nada que decir: sale mal impreso, nada más.

*Regla: toda referencia cruzada entre módulos nombra el módulo en el texto* —
«la @m9-e-E del módulo 9», «la vis-viva del módulo 9 (@m9-visviva)»—, nunca
`@m9-e-E` sola. Adentro del mismo módulo no hace falta.

**15. Typst no tiene `cosh` ni `sinh` en `calc`.** Hizo falta para la rama
vacía de la hipérbola (`fig-hiperbola-geometria`), que se parametriza
$x = c + a\cosh t$, $y = \pm b\sinh t$. Se arman a mano con `calc.exp`:
`(calc.exp(t) + calc.exp(-t)) / 2` y `(calc.exp(t) - calc.exp(-t)) / 2`.

**16. En una figura con asíntotas, el hueco visualmente vacío no está vacío.**
Los rótulos `r_p` y `a` de `fig-hiperbola-geometria` se pusieron debajo de la
línea de ábsides —donde a ojo no hay nada— y quedaron atravesados: por ahí
pasa la asíntota, que en el render es una línea de puntos finita y en la
cabeza del que escribe el código no existe. Se resolvió subiéndolos a la
franja entre el eje y la barra de medida, que sí es angosta pero está libre.
*Antes de colocar un rótulo, listar TODAS las curvas de la figura y evaluarlas
en esa coordenada* — no alcanza con mirar la protagonista.

**9c. El chequeo de la trampa 9b mide UNA de las dos fallas, y la otra pasó
igual.** El heredoc puede hacerle dos cosas distintas a una barra invertida:
*convertirla* en un carácter de control (`\t`, `\f`, `\a`, `\b`) o *dejarla
pasar como texto*. El chequeo de tres segundos —listar
`{ord(c) for c in s if ord(c) < 32}`— sólo ve la primera.

Pagado el 2026-09-07, escribiendo el M17: un `\` de fin de renglón de Typst,
dentro de un `str.replace()` de Python, dentro de un heredoc **entrecomillado**
(`<< 'PY'`, que es el que uno cree seguro), quedó en el archivo como `\n`
literal — dos caracteres imprimibles. El chequeo dijo «limpio», Typst compiló
sin una palabra, y el PDF salió con **`,n` impreso en el medio de una frase**.

*Regla, sin cambios: ningún texto con barras invertidas pasa por un heredoc —
va con la herramienta de archivos.* Y si igual pasó, lo único que lo atrapa es
`grep` de la secuencia literal esperada, o mirar el render. La comilla del
heredoc protege de **bash**; no protege del resto del canal.

**9d. La trampa 9 es del CANAL, no del tipo de archivo — y por escribirla
pensando en `.typ` se volvió a pagar en un `.md`.** El 2026-09-08, actualizando
`docs/figuras.md` con un `python - << 'PY'`, un `\boldsymbol` de la tabla dejó
un **backspace** (de `\b`) adentro del archivo y todas las demás barras
quedaron **duplicadas** (`\\hat` en vez de `\hat`). Las dos fallas de la 9b y
la 9c, juntas, en un archivo que no es de Typst.

Lo único que avisó fue un `SyntaxWarning: invalid escape sequence` de Python
—y avisó, como siempre, de las secuencias que **no** rompen nada—. El chequeo
de caracteres de control sí lo atrapó, porque `\b` es control; las barras
duplicadas no las atrapa nadie más que `grep`.

*La regla, corregida:* **ningún texto con barras invertidas pasa por un
heredoc, sea `.typ`, `.md` o lo que sea.** Va con la herramienta de archivos.
Y el chequeo de cierre son **dos** greps, no uno:

```bash
python -c "
import io
s = io.open('ARCHIVO', encoding='utf-8').read()
print('control:', {ord(c) for c in s if c != chr(10) and ord(c) < 32} or 'limpio')
print('barras dobles:', s.count(chr(92)*2))
"
```

**18. La coma decimal de la plantilla vuelve ilegible cualquier terna de
componentes.** `plantilla.typ` trae un `show ","` que le saca el espacio a la
coma para que `$29,3$` salga bien. La consecuencia no prevista: `$(7000, 9000,
0)$` se imprime **`(7000,9000,0)`**, que en un apunte donde la coma *es* el
separador decimal se lee como un solo número gigante. Compila sin decir nada y
sólo se ve mirando la página.

*Regla: un vector con componentes numéricas nunca se escribe como terna entre
paréntesis; va con versores* — `$7000 hat(i) + 9000 hat(j)$` —, que además es
como se lo escribe en el resto del apunte. La terna sólo es segura con letras
($(bold(r), bold(v))$ sale bien), porque ahí no hay ambigüedad con un decimal.

**17. Una figura y su epígrafe pueden decir dos veces lo mismo, y sólo se ve
en el render.** El texto que va *adentro* del lienzo (con `rotulo`) y el que va
en el `#fig([...])` se escriben en archivos distintos, con horas de diferencia,
y es fácil que terminen repitiendo la misma frase — que impresa queda a cuatro
centímetros de sí misma. Pasó con `fig-conicas-parcheadas`. *Al mirar el render
de una figura nueva, leer los dos textos juntos: el de adentro explica los
elementos del dibujo, el epígrafe explica qué hay que sacar de él.*

## Lo que se resolvió en la fase 2 y ya no está pendiente

**El huérfano de caja, arreglado.** El título de un cuadro ya no puede quedar
solo al pie de una página: en `plantilla.typ`, `caja()` lo envuelve en un
`block(sticky: true)`, que lo obliga a viajar con el cuerpo. Estaba anotado
para la fase 5 «porque la paginación va a cambiar igual», y esa espera era el
error: el arreglo no depende de la paginación, y con cuatro módulos más el
problema apareció tres veces en una sola compilación. Verificado con el chequeo
de arriba: **cero huérfanos en 35 páginas**.

**Las referencias a ecuaciones.** `@etiqueta` salía «Ecuación 7», que no combina
con las citas del apunte. Un `show ref` en `plantilla.typ` las deja como
«ec. (7)», igual que el número impreso al costado.

## Lo que sigue abierto, a propósito

**Las referencias entre módulos son texto plano.** Muchos módulos dicen
«módulo 7», «módulo 9», «módulo 12» en el cuerpo del texto. Si el orden
cambia, el compilador **no avisa** — sólo las etiquetas `<m1-*>` a `<m19-*>`
son reales y las valida el compilador. **Validada en la sesión 5 de la fase
5 (2026-09-13), los 19 módulos, contra el índice renderizado** (ver el
detalle de qué se corrigió y cómo en «Fase 5 — CERRADA» más arriba):

| Módulo | Apunta a |
|---|---|
| 1 | módulos 7, 9, 11, 12, 13 |
| 2 | módulos 3, 4, 5, 7, 14 |
| 3 | módulos 2, 4, 8, 13 |
| 4 | módulos 11, 12; sección de cuerpo rígido de la guía |
| 5 | módulos 1, 2, 3, 4, 6, 7, 9, 10 |
| 6 | módulos 4, 5, 7, 8, 9, 10, 11 |
| 7 | módulos 1, 2, 3, 5, 6, 9, 10, 11, 14 |
| 8 | módulos 3, 6, 7, 9, 10 |
| 9 | módulos 1, 5, 6, 7, 8, 10, 11 |
| 10 | módulos 6, 7, 8, 9, 11 |
| 11 | módulos 6, 8, 9, 10 |
| 12 | módulos 1, 3, 7, 13, 14, 15 |
| 13 | módulos 7, 8, 12, 14, 15 |
| 14 | módulos 12, 13, 15 |
| 15 | módulos 7, 12, 13, 14 |
| 16 | módulos 6, 7, 9, 11, 17 |
| 17 | módulos 4, 6, 8, 9, 11, 16, 19 |
| 18 | módulos 1, 7, 8, 9, 16, 17, 19 |
| 19 | módulos 5, 6, 8, 9, 10, 12, 16, 17, 18 |

**Ninguna referencia apunta a un módulo que no existe.** Es un dato de texto
plano, no de etiquetas: si un módulo se reordena en el futuro, esta tabla
queda vieja y hay que rehacer el mismo grep (comando en «Fase 5 — CERRADA»).

**El blanco al pie de la pág. 30 impresa: mirado y declarado aceptable** —
ver el detalle en «Fase 5 — CERRADA» más arriba. No se vuelve a tocar salvo
que la paginación cambie por los anexos de la fase 6.

## Hallazgos de bibliografía que hay que llevarse puestos

**Roederer, ec. (4.8), pág. 114: le falta el factor $|v_r|$ delante del
logaritmo.** Confirmado, no sospechado: la ecuación del renglón anterior —en la
misma página— sí lo lleva, y todas las de la pág. 115 también. Además el
logaritmo es adimensional, así que la ecuación impresa suma un número a una
velocidad. El apunte imprime la forma correcta y explica la errata en un cuadro
rojo del módulo 4.

**Roederer, pág. 115: el paso intermedio del cohete de dos etapas suma dos veces
$-g m/\mu$.** Las pérdidas de las dos etapas son $-g m_1/\mu$ y $-g m_2/\mu$,
que juntas dan *una sola* vez $-g m/\mu$ — y el miembro derecho del mismo
renglón ya está bien. Es tipográfico y no afecta la conclusión.

**La fórmula cerrada de Roederer para la ganancia por etapas no se le puede
aplicar a los problemas de Beer.** Roederer supone la misma fracción de
combustible sobre masa total en cada etapa, y un cohete con carga útil rompe
esa hipótesis. En el ejemplo a fondo del módulo 4 la ganancia se calcula tramo
por tramo, y da $1,31$ km/s donde la fórmula de Roederer diría $2,19$.

**Dos erratas de signo en el apunte de clase de la cátedra (23/9), las dos
en la página 1 y las dos invisibles si se copia sólo la fórmula recuadrada.**
Confirmadas ampliando el escaneo a 300 dpi, no sospechadas:

- La ecuación **recuadrada** dice $\ddot r = \mu r/r^3$, **sin el signo menos**.
  El renglón inmediatamente anterior, en la misma hoja, dice
  $\ddot r = -G(m_1+m_2)/r^2\,\hat u_r$ — o sea la misma ecuación, con su
  menos. Sin el menos, la gravedad repele.
- Las dos aceleraciones de partida, $\ddot R_1 = Gm_2 r/r^3$ y
  $\ddot R_2 = Gm_1 r/r^3$, están escritas **con el mismo signo**. Restarlas
  daría $G(m_2-m_1)r/r^3$ y los dos cuerpos se acelerarían para el mismo lado.
  Es el desliz del que la errata del recuadro es consecuencia.

La cátedra llega igual al resultado correcto; el problema es para quien copie
el recuadro. Está documentado en un cuadro rojo del módulo 8.

**Y una tercera, en la página 3 del mismo escaneo, que toca el módulo 9:**
$E_"mec" = \frac12 m\dot r^2 + L^2/(2mr^2) - U(r)$ lleva un **menos** delante
de $U(r)$, y debe ser un más. La misma hoja define $U(r) = -Gm_1m_2/r$ (pág. 2)
y la llave de abajo agrupa los dos últimos términos bajo el nombre «potencial
eficaz», que es la **suma**. Confirmada ampliando a 300 dpi. **Ya está escrita
bien en el módulo 9**, con su cuadro rojo.

**Los dos escaneos de `potencial eficaz` ya están leídos, y son distintos entre
sí.** `potencial eficaz.pdf` (1 pág.) es el gráfico a mano de la cátedra: las
dos ramas $V_g=-\alpha/r$ y $V_c=\ell^2/2mr^2$, su suma $V_{eff}$, y al costado
la deducción de $T = \tfrac12 m\dot r^2 + \ell^2/(2mr^2)$.
`potencial eficaz_2.pdf` (1 pág.) es una **figura de libro** —«Figura 4.1,
Potencial efectivo en una dimensión»— con los cuatro niveles rotulados
*circunferencia, elipse, parábola, hipérbola* y el radio de la órbita circular
anotado como $r_0 = M^2/(m\alpha)$. Ésa es la que se redibujó en
`fig-potencial-eficaz`.

**Y una cuarta errata de la cátedra, en la primera de esas dos hojas:** anota
$\alpha = GM$, y para que $V_g$ sea una *energía* tiene que ser $\alpha = GMm$
— si no, no se le puede sumar $V_c$, que sí lleva la $m$. Documentada en el
cuadro de notación del módulo 9.

**El offset de Beer: página impresa = página del PDF + 575.** Medido el
2026-08-31. Es el tercer offset del proyecto, junto con S&Z vol. 1 (+28) y
Roederer (0).

**Dónde está de verdad la ecuación de la órbita en el Beer, y por qué el plan
apuntaba mal.** El plan de la fase decía «§12.11 y 12.12, ec. 12.26 y 12.45,
páginas impresas 726 en adelante». Medido: la ec. 12.26 es
$m r^2\dot\theta = H_O$ —la conservación del momento angular, pág. 725, que ya
se usó en el módulo 7— y §12.11 empieza recién en la **pág. impresa 736**. El
mapa correcto, todo confirmado leyendo la capa de texto del PDF:

| Qué | Beer | Pág. impresa |
|---|---|---|
| ecuaciones de movimiento en polares, fuerza central | ecs. 12.31 y 12.32 | 736 |
| $r^2\dot\theta = h$ como sustituto de la segunda | ec. 12.33 | 736 |
| el cambio de variable $u = 1/r$ | ecs. 12.35 y 12.36 | 736 |
| **la ecuación de Binet**, $u'' + u = F/(mh^2u^2)$ | ec. 12.37 | 736 |
| la misma, con gravedad: $u'' + u = GM/h^2$ | ec. 12.38 | 737 |
| **la solución**, $1/r = GM/h^2 + C\cos\theta$ | ec. 12.39 | 737 |
| excentricidad $\varepsilon = Ch^2/GM$, y la forma con $(1+\varepsilon\cos\theta)$ | ec. 12.40 y 12.39′ | 737 |
| clasificación por $\varepsilon$ (hipérbola / parábola / elipse) | — | 738 |
| $v_{esc}$ y $v_{circ}$ | ecs. 12.43 y 12.44 | 739 |
| período orbital $\tau = 2\pi ab/h$ | ec. 12.45 | 739 |
| $a = (r_0+r_1)/2$ y $b = \sqrt{r_0 r_1}$ | ecs. 12.46 y 12.47 | 740 |
| las tres leyes de Kepler | §12.13 | 740 |
| $1/r_0 + 1/r_1 = 2GM/h^2$ (del problema 12.102) | — | 744 |

**El mapa del Beer para la Parte IV (cuerpo rígido), medido el 2026-08-31.**
Mismo offset de siempre: *página impresa = página del PDF + 575*. Leído por la
capa de texto sección por sección, sin renderizar el capítulo.

*Cinemática — capítulo 15 (módulo 12):*

| Qué | Beer | Pág. impresa |
|---|---|---|
| razón de cambio de un vector en un sistema rotante, (Q̇)_OXYZ = (Q̇)_Oxyz + Ω × Q | §15.10, ec. 15.31 | 975–976 |
| movimiento alrededor de un punto fijo; **teorema de Euler** | §15.12 | 988–989 |
| v = ω × r; a = α × r + ω × (ω × r); α = dω/dt | ecs. 15.37 a 15.39 | 989 |
| cono espacial y cono corporal | §15.12, fig. 15.33 | 989 |
| ω = ω₁ + ω₂ (las velocidades angulares son vectores) | ec. 15.40 | 990–991 |
| movimiento general: v_B = v_A + ω × r_(B/A), y su aceleración | ecs. 15.43 y 15.44 | 991 |
| partícula en un sistema rotante, **Coriolis en 3-D** | ecs. 15.45 y 15.47 | 1002 |
| a_c no vale 2Ω·v_rel en 3-D; los dos casos en que se anula | §15.14 | 1003 |
| sistema de referencia en movimiento general | ecs. 15.52 y 15.54 | 1004 |

*Cinética — capítulo 18 (módulos 13, 14 y 15):*

| Qué | Beer | Pág. impresa |
|---|---|---|
| ΣF = m·a_G y ΣM_G = Ḣ_G siguen valiendo en 3-D | ecs. 18.1 y 18.2 | 1150 |
| H_G por integrales; momentos y **productos** de inercia | ecs. 18.4 a 18.6 | 1151–1152 |
| H_x = I_x ω_x − I_xy ω_y − I_xz ω_z (las tres) | ec. 18.7 | 1152 |
| **el tensor de inercia**, y su forma diagonal en ejes principales | ecs. 18.8 y 18.9 | 1153 |
| H_x = I_x ω_x, etc., y **H_G es paralelo a ω sólo si ω va sobre un eje principal** | ec. 18.10 | 1153 |
| H_O = r̄ × m·v̄ + H_G | ec. 18.11 | 1154 |
| H_O directo, para un cuerpo con punto fijo | ec. 18.13 | 1155 |
| impulso–cantidad de movimiento en 3-D (fig. 18.6) | §18.3 | 1155–1156 |
| energía cinética, caso general y en ejes principales | ecs. 18.16 y 18.17 | 1157 |
| energía cinética con un punto fijo | ecs. 18.19 y 18.20 | 1157 |
| Ḣ_G = (Ḣ_G)_Gxyz + Ω × H_G — **acá entra la ec. 15.31** | ecs. 18.22 y 18.23 | 1169–1170 |
| el sistema puede girar MENOS que el cuerpo (Ω ≠ ω) | §18.5, último párrafo | 1170 |
| **ecuaciones de Euler** | ec. 18.25 | 1170 |
| cuerpo con un punto fijo: ΣM_O = (Ḣ_O)_Oxyz + Ω × H_O | ecs. 18.27 y 18.28 | 1171–1172 |
| giróscopo, **ángulos de Euler** φ (precesión), θ (nutación), ψ (giro) | §18.9, fig. 18.15 | 1187 |
| ω, H_O y Ω escritos en ángulos de Euler | ecs. 18.35 a 18.38 | 1187–1188 |
| las tres ecuaciones diferenciales del giróscopo | ec. 18.39 | 1188 |
| **precesión estable**: ΣM_O = Ω × H_O | ecs. 18.40 a 18.44 | 1189 |
| caso θ = 90°: ΣM_O = I·φ̇·ψ̇·ĵ | ec. 18.45 | 1189 |
| **cuerpo simétrico sin cuplas**: H_G constante define el eje de precesión | ecs. 18.46 a 18.48 | 1190 |
| tan γ = (I/I′) tan θ | ec. 18.49 | 1190 |
| **precesión directa** (I' > I, achatado) y **retrógrada** (I' < I, alargado) | §18.11, figs. 18.23 y 18.24 | 1191 |
| el método completo, paso a paso (ley de los senos para φ̇ y ψ̇) | resumen §18.9–18.11 | 1193–1194 |
| problema resuelto 18.6 — el satélite golpeado por un meteorito | — | 1192 |

**La fila de directa/retrógrada de arriba estuvo invertida hasta el módulo
15.** La nota original de esta tabla decía «directa: I < I′, alargado;
retrógrada: I > I′, achatado» — anotada de memoria al mapear el capítulo,
sin haberla deducido todavía. Al escribir el módulo 15 se rededujo desde
cero, dos veces, con la @m14-precesion-estable en $sum bold(M)_O = 0$:
$dot(psi)\/dot(phi) = ((I'-I)\/I') cos theta$, así que el signo lo decide
$I' - I$, no al revés. Se verificó además contra un caso conocido —la Tierra
es achatada ($I'_"polar" > I_"ecuatorial"$) y su precesión libre (Chandler)
es directa, dato astronómico independiente— y coincide con la fila
corregida. *Regla: una nota de mapeo escrita antes de deducir la fórmula no
es evidencia de la fórmula, es sólo un recordatorio de dónde está — y hay que
volver a mirarla con sospecha cuando el módulo que la usa por fin se
escribe.*

**Lo que el Beer de la cátedra NO trae, y hay que suplir.** El temario manda
«Beer vol. 1, secciones 9.16 y 9.17» para *ejes de inercia y elipsoide de
inercia*; ese volumen es la **Estática**, y el PDF que hay en `Libros de
Fisica` es sólo la **Dinámica** (capítulos 11 a 19, páginas impresas 576 a
1359). El §18.2, pág. 1153, define los ejes principales y afirma que siempre
existen, pero no los deduce. Para el módulo 13 alcanza con eso más los radios
de giro (I = m k²), que es como la guía da todos los datos.

**De la lista del temario, la mitad no hace falta — y eso se midió, no se
supuso.** El temario manda §§14.x, 15.1 a 15.7, 16.2 y 17.x además de las de
arriba. Medido: 14.x y 15.1–15.7 son *movimiento plano*, ya cubierto por los
módulos 3 y 7 de este apunte; lo que la Parte IV necesita de verdad empieza en
**§15.10** y sigue en **§15.12 a §15.15**. Los capítulos 16 y 17 son
movimiento plano de placas y no aportan nada nuevo en tres dimensiones — lo
dice el propio Beer en la introducción del cap. 18 (pág. 1150), y por eso ese
capítulo empieza aclarando qué resultados del movimiento plano *sobreviven* y
cuál —H_G = I ω— hay que tirar.

**Dónde están las figuras de los problemas de la guía, y qué dicen.** Los
enunciados de cuerpo rígido son texto, pero las figuras son imagen; se leen
renderizando las páginas 15 a 18 del PDF de la guía. Ya miradas, las cinco:

| Problema | Qué agrega la figura |
|---|---|
| 2 | el eje de giro del disco es **horizontal** y el vertical es el de la horquilla. El enunciado dice «gira … alrededor de un eje vertical», que la figura contradice: **se tomó la figura**, y el módulo 12 lo resuelve así |
| 3 | los ejes *xyz* están clavados **al gimbal** (lo dice dentro de la figura, no en el texto); el torquer actúa sobre el eje x; la plataforma gira alrededor de y |
| 4 | H_G apunta hacia arriba (+Z) y el eje z del cuerpo está a 2° de él; el cuerpo es **achatado**, coherente con k_z = 720 > k_t = 540 |
| 7 | la cápsula es un **tronco de cono** con el eje z hacia arriba: 2 m de diámetro abajo, 1,25 m arriba, 2 m de alto. A y B son dos cohetes sobre el borde, A del lado de y y B más arriba. **Las coordenadas exactas de A y B hay que volver a medirlas sobre la figura al escribir el módulo 15**: de ellas depende el brazo de palanca, y de ahí todo el resultado |
| 9 | el octógono con y vertical (eje de giro), los thrusters A, B, C, D en la tapa superior y F_s abajo; 2,4 m de alto, 1,2 m de lado |

**El Beer no trae el potencial eficaz.** Lo resuelve todo por la ecuación
diferencial de la trayectoria, sin diagrama de energía. El potencial eficaz
sale sólo del material de la cátedra, y por eso el módulo 9 lo deduce entero.

**La capa de texto del Beer se lee, pero mastica los símbolos.** `get_text()`
devuelve el texto (no hace falta renderizar la página como imagen), pero
**pierde los signos `=`, `−` y `+` de las fórmulas** y desarma las fracciones.
Sirve perfecto para ubicar una sección y leer la prosa; para copiar una
ecuación hay que reconstruirla del contexto o mirar la página. Todas las
ecuaciones de la tabla de arriba se reconstruyeron así y se verificaron contra
el problema resuelto 12.9 (pág. 741), que las usa con números.

**Curtis y Bate ya no están sólo en `Downloads`.** Los seis libros están ahora
en `…\SistemasEspaciales\Libros de Fisica\`. `fuentes/RUTAS.md` quedó
actualizado; ojo que el archivo de Bate ahí tiene un `(1)` en el nombre.

## Decisión de estilo tomada, para no rediscutirla

La arquitectura del fuente es **la misma que la del apunte de Electrónica
Analógica**: `plantilla.typ` + `biblioteca/` + `modulos/`, con `galeria.typ`
aparte. Se copió la *arquitectura*, no los archivos.

Y una decisión de contenido de la fase 2, que conviene mantener: **cuando la
guía no trae un ejercicio propio de un tema** —le pasó al centro de masa—, no
se inventa uno: se reusa un ejercicio de la guía resuelto con la herramienta
nueva, y el cuadro violeta lo dice explícitamente. Un ejemplo inventado enseña
a resolver algo que no se va a tomar.
