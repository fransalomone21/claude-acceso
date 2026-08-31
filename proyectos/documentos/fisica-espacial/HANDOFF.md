# HANDOFF — Apunte de Física Espacial

Lo que quedó a medias y las trampas ya pagadas. **El plan de fases y el
criterio de salida no están acá: están en `PDP.md` §4.** Este archivo no los
repite, porque un dato que vive en dos lados diverge.

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

**Las referencias entre módulos son texto plano.** Los módulos 1 a 5 dicen
«módulo 7», «módulo 9», «módulo 12», «módulo 13» en muchos lugares. Si el orden
cambia, el compilador **no avisa**. Se revisan en la fase 5, todas juntas:

| Módulo | Apunta a |
|---|---|
| 1 | módulos 7, 9, 11, 12, 13 |
| 2 | módulos 4, 5, 7, 14 |
| 3 | módulos 4, 8, 13 |
| 4 | módulos 11, 12; sección de cuerpo rígido de la guía |
| 5 | módulos 6, 7, 9, 10 |
| 6 | módulos 5, 8, 9, 10, 11 |
| 7 | módulos 1, 2, 3, 5, 9, 10, 11, 14 |
| 8 | módulos 3, 6, 7, 9, 10 |
| 9 | módulos 1, 5, 6, 7, 8, 10, 11 |
| 10 | módulos 6, 7, 8, 9, 11 |
| 11 | módulos 6, 8, 9, 10 |

Los `<m1-*>` a `<m11-*>` sí son etiquetas reales:
esas las valida el compilador. Ninguna referencia entre módulos apunta
todavía a un módulo que no exista (12 en adelante), así que el chequeo de la
fase 5 —revisarlas todas juntas— sigue sin encontrar nada roto, sólo texto
plano que confirmar.

**Un blanco grande al pie de la pág. 30**, porque la figura siguiente no
entraba. No se toca hasta la fase 5, por el mismo motivo de siempre: la
paginación va a cambiar.

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
