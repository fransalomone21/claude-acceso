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

Los `<m1-*>`, `<m2-*>`, `<m3-*>`, `<m4-*>` y `<m5-*>` sí son etiquetas reales:
esas las valida el compilador.

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
