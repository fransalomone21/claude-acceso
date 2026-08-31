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
python -c "import pymupdf; d=pymupdf.open('apunte/apunte.pdf'); [p.get_pixmap(dpi=105).save(f'p{i+1}.png') for i,p in enumerate(d)]"
```

`pdftoppm` **no está instalado**, así que el lector de PDF de la sesión no
puede rasterizar solo: hay que pasar por PyMuPDF. Vale también para leer los
escaneos de la cátedra (ver `fuentes/RUTAS.md`).

## Las trampas de Typst ya pagadas

**1. Una fracción se come sólo el átomo siguiente.** `X / |bold(A)|` sale como
$X$ sobre la barra vertical, con el resto colgando afuera; `b / cos theta` sale
como $b/\cos$ multiplicado por $\theta$. Las dos aparecieron en el módulo 1 y
las dos son *invisibles en el fuente*: compilan perfecto y salen mal impresas.

- Para módulos: usar **`abs(...)`**, nunca `|...|` dentro de una fracción.
- Para funciones trigonométricas: **paréntesis explícitos**, `b / (cos theta)`.

**2. El título de una caja pasa por `upper()`.** Un título escrito como fórmula
—`#deduccion("d r̂ / dt = θ̇ θ̂")`— sale «D R̂ / DT = Θ Θ̂» y no se lee. *Los
títulos de las cajas van en palabras.*

**3. CeTZ quiere `angle` en `arc`, y el resto de la figura quiere números.**
Resuelto dentro del helper `angulo`, que recibe números y convierte. Si aparece
`cannot compare angle and integer`, es un `arc` llamado a mano sin `* 1deg`.

**4. El rótulo de un vector corto, en la punta.** Ver `docs/figuras.md`, regla 1.

## Lo que quedó abierto, a propósito

**El huérfano de caja.** Una caja corta que cae al final de una página puede
dejar su título solo y el cuerpo en la siguiente (pasó con el cuadro violeta
de la guía, pág. 8 del PDF de 11 páginas). *No se arregló ahora* porque la
paginación entera va a cambiar en cuanto entren los módulos 2 a 15: arreglarlo
hoy es trabajo que se tira. **Va en la fase 5, de cierre, junto con la
revisión de referencias cruzadas.**

**Las referencias entre módulos son texto plano.** El módulo 1 dice «módulo 7»,
«módulo 9», «módulo 12» y «módulo 13» en varios lugares. Si el orden de los
módulos cambia, el compilador **no avisa**. Están listadas acá para que se
revisen en la fase 5:

| Dónde, en `m1-vectores.typ` | Dice | Debería apuntar a |
|---|---|---|
| §1.2, cuadro de deducción | «módulo 7» y «módulo 13» | momento angular; momento de inercia |
| §1.3, idea clave | «módulo 7», «módulo 9» | momento angular; órbita y cónicas |
| §1.6 y §1.7 | «módulos 7 al 11», «módulo 12» | Parte III; cinemática del cuerpo rígido |

Los `<m1-escalar>`, `<m1-dobles>`, `<m1-derivada>` y `<m1-polares>` sí son
etiquetas reales: esas las valida el compilador.

## Decisión de estilo tomada, para no rediscutirla

La arquitectura del fuente es **la misma que la del apunte de Electrónica
Analógica** (`proyectos/documentos/electronica-analogica/`): `plantilla.typ` +
`biblioteca/` + `modulos/`, con `galeria.typ` aparte. Se copió la
*arquitectura*, no los archivos: la paleta tiene un color más (verde azulado,
para los choques de notación entre libros) y las cajas son otras — no hay
«laboratorio» ni «TP», y sí hay «de dónde sale» y «cuidado geométrico y
vectorial», que son los dos que el destinatario pidió explícitamente.
