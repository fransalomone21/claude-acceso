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

**9. El heredoc de Bash + una cadena de Python se comen el `\` final de línea.**
Escribir figuras con `python - << 'EOF'` y un `u'''...'''` adentro hizo
desaparecer los saltos de línea de Typst (el `\` al final de un renglón), y el
rótulo salió como un párrafo de una sola línea que estiró el lienzo. *Los
bloques de Typst con `\` se escriben con la herramienta de archivos, o a un
archivo aparte que después se inserta leyéndolo* — nunca pegados dentro de un
heredoc.

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
$E_"mec" = rac12 m\dot r^2 + L^2/(2mr^2) - U(r)$ lleva un **menos** delante
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
