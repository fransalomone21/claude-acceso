# Retome para la nube: ampliar el apunte de Física Espacial

Escrito el 2026-11-05 por la sesión local, que leyó todo esto y lo cotejó. Fran aprobó el plan al pedir que se avance. Antes
de nada, leé [`NOCHE.md`](NOCHE.md): hora de cierre, quién toca qué y cómo se escribe en lo compartido.

## 0. El libro primero

```bash
bash .claude/nube/traer-perfil.sh
python3 .claude/nube/estado-nube.py --traer catedras
```

Rojo: hacé lo que dice (`add_repo` de `fransalomone21/perfil-global` y `fransalomone21/catedras`, con push). Leé enteros los
archivos que lista.

## 1. Alistar y medir, antes de tocar nada

```bash
curl -fsSL https://github.com/typst/typst/releases/download/v0.15.1/typst-x86_64-unknown-linux-musl.tar.xz | tar -xJ -C /tmp
sudo cp /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/ || cp /tmp/typst-x86_64-unknown-linux-musl/typst ~/.local/bin/
pip install pymupdf matplotlib
cd proyectos/documentos/fisica-espacial/apunte
typst compile --ignore-system-fonts --creation-timestamp=1767225600 apunte.typ /tmp/f.pdf && md5sum /tmp/f.pdf
```

**Tiene que dar 218 páginas y MD5 `f3d880cd7b714d5a92faeb7e4b644a63`** (fuentes del commit `1fd939e`). MD5 distinto con mismas
páginas y texto: anotalo y seguí. Páginas distintas o Typst que no baja: frená el contenido, informe y defecto.

## 2. Entrar

```bash
bash .claude/cascada.sh fisica-espacial -Necesidad materia
```

Leé lo que exija la puerta. La fase activa, 17, es mantenimiento y **no declara su tipo NASA**: abrí en `PDP.md` la **fase 18**,
con su tipo y este criterio de salida: los dos ejercicios nuevos resueltos en el apunte y comprobados por dos caminos,
`verificar-apunte.py`, `indice-temas.py`, `verificar-anexos.py` y `validar.py` en verde, todo símbolo presentado y medido, y
cada página nueva mirada en render.

## 3. Las fuentes en la nube

`proyectos/documentos/catedras/fisica-espacial/fuentes-nube/`: Curtis caps. 11-12, Beer cap. 18, la guía (5), «Precesiones»,
el material del 27/10 y el Meriam 7/11. **Son recortes: su número de página no es el del libro.** En el Beer, la impresa es
la del recorte + 1145 (medí una antes de citar). `fuentes/GUIA-ENUNCIADOS.md` ya tiene los dos enunciados nuevos.
No hay Sears ni Roederer enteros: si hace falta citar algo de ellos, mirá lo que el apunte ya cita y no inventes página.

## 4. El tono

Buen profesor, completo, sarcástico y en criollo, con el humor en la prosa y nunca anunciado: regla 8 del contrato, con
`m17-rotacion.typ` de referencia. Idea en palabras antes de la primera ecuación (regla 4). Cuadro `#posta` en cada tema no
trivial (regla 3). `#lectura` con capítulo y por qué ese libro (regla 4 bis). Cambios de variable mostrados (regla 2 bis).

Lo que Fran pidió hoy, textual: *«que hayan muchos dibujos explicativos y que no quede ninguna variable sin presentar ni
decir de donde salio, por que y que representan conceptual y matematicamente»*.

## 5. El trabajo, en este orden

**A. Módulo nuevo** (después de `peonza`; clave sugerida `actitud`; el «Cierre de la Parte V, y del apunte» de m21 se muda al
final de éste). El cuerpo que cambia de forma y la actitud que se controla desde adentro:

- **Masa que se mueve con $omega$ fija: el Adicional 1.** Primero la idea: al alejar masa, $H_z$ tiene que crecer, y alguien lo
  paga. Dos caminos. Por $dot(H)_z$: $H_z = (I_0 + 2 m r^2) omega_0$, entonces $tau = 4 m r dot(r) omega_0$. Por Coriolis: cada módulo
  necesita $2 m dot(r) omega_0$ tangencial, a brazo $r$. Con la pareja de 1,1 m por lado: $T dot 2,2 = 4 dot 10 dot r dot 0,0275 dot 1,25$,
  o sea $T = 0,625 r$, $T(t) = 0,75 + 0,0172 t$ N, de 0,75 a 2,81 N. Recalculalo: esto es una cuenta de la sesión local, no una
  cita. Enganchá con la bailarina de m17 y con Coriolis de m18.
- **El yo-yo, Curtis §12.8:** el mismo mecanismo sin propulsores, y por eso $omega$ cae. Ya lo menciona m20.
- **La rueda de reacción: el Adicional 2.** El par es interno, así que el $H$ total sigue en cero: $I omega_"nave" + I_R omega_"rel" = 0$; la rueda
  recibe $M T = I_R (omega_"nave" + omega_"rel")$. Sale $omega_"nave" = - M T \/ (I - I_R)$ y $omega_"rel" = I M T \/ (I_R (I - I_R))$. Control contra el Curtis
  (ec. de la pág. pdf 680: $Delta omega_"rel" = -(1 + I_p \/ I_w) Delta omega$, con $I_p = I - I_R$). Avisá que la figura le dice $I_w$ y el texto $I_R$.
- **Rueda, CMG y propulsor:** quién cambia el $H$ total y quién sólo lo reparte, saturación y desaturación. El CMG ya está en m20: se
  referencia con `#M()`, no se repite.

**Dibujos, unos diez:** nave con los brazos en dos instantes, velocidad radial y fuerza de Coriolis sobre el módulo, $H_z(t)$ y el
torque que lo paga, pareja de propulsores, yo-yo, corte de la nave con la rueda, par y contrapar, $H$ repartido entre nave y rueda,
velocidad de la rueda hasta saturar, y la comparación de actuadores. Redibujados, nunca copiados; figura de libro con su fuente
en el epígrafe. **El humor no va adentro de una ecuación.**

**B. Lo que hoy sólo está en la guía del parcialito** (`practica/resumen-cuerpo-rigido.typ`), a m20 y m21. Medido: no aparece en los
módulos por su nombre.
- La extensión de d'Alembert (Beer §18.6) y el disco torcido en sus cojinetes.
- Las dos soluciones de la precesión estable con el eje inclinado (cuadrática).

Cotejá y, si falta, traé: las dos reglas de la mano derecha para el giróscopo, las explicaciones «con las manos», y la figura
«Precesiones» ($beta$ contra $gamma$, con la errata de la hoja 1 que dice la guía). No traigas «cómo pregunta Aníbal» ni las
preguntas probables: eso es de la guía.

**C. Ningún símbolo en el aire, medido.** `practica/verificar-simbolos.py` hoy mira sólo `practica/`. Hacé que mida el módulo nuevo
(y su sabotaje siga rojo), firmando con `// simbolos:`. Después pasale `--listar` a m17-m21 y corregí sólo lo que de verdad no esté
presentado. Una línea `// simbolos:` en medio de un párrafo no lo corta.

**D. La guía y el Anexo.** Fichas nuevas en el Anexo A (A.5), con `#M()`; ecuaciones nuevas en el formulario (`verificar-anexos.py`
da rojo a propósito hasta que estén); `practica/ejercicios.toml` con los dos ejercicios, su tip y su resultado, y los números en
`validar.py` (regla 12: el contador tiene que SUBIR).

**E. DA-102, si queda tiempo.** Copiá la guía a `~/Downloads`, volvé a medir los `recortes` de cuerpo rígido contra la (5) y fijá en
`ejercicios.toml` el MD5 de la guía, con rojo si no coincide. **`compilar.ps1` no corre acá y no se publica nada:** queda para la PC,
y lo decís en el informe.

## 6. Trampas ya pagadas

$I$ es axial e $I'$ transversal, como el Beer. $bold(L)$ es momento angular; «impulso angular» es la integral del torque (regla 9). Con
la coma fijada por `show`, las componentes de un vector van con punto y coma. Subíndice de una letra pegado a un paréntesis: con
espacio. Número de módulo sólo por `#M("clave")`. Una consigna no se parte entre páginas. La figura de un enunciado no lleva la
respuesta. Los rótulos se miden, no se ajustan a ojo.

## 7. Cerrar

Al cerrar el contrato pide `verificar-apunte.py`, `indice-temas.py` y `verificar-anexos.py`, con ESTADO y HANDOFF. Después, lo de
`NOCHE.md`. Primer comando de todo esto: `bash .claude/nube/traer-perfil.sh`.
