# Apunte de Aplicaciones de Electrónica Analógica — contrato de contexto

Apunte teórico-práctico completo de la materia de **4.º año** de la E.E.S.T.
N.º 1 de Vicente López. Fuente única en **Typst**, se compila a PDF.
Destinatario primario: **el docente**; en segundo lugar, los alumnos.

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md):
el render se mira, las fuentes se anotan donde se usan, y las referencias
cruzadas de texto plano no las valida el compilador.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber qué partes están cerradas | `ESTADO_ACTUAL.md` (entero) |
| saber qué cierra la fase en curso, o por qué se decidió algo | `PDP.md` |
| lo que quedó a medias y las trampas de Typst ya pagadas | `HANDOFF.md` |
| tocar o agregar una figura | `docs/figuras.md` |
| verificar un dato contra la bibliografía | `fuentes/` y `docs/referencia/` |
| **escribir o tocar algo que responda a un TP** | [`fuentes/consignas-tp.md`](fuentes/consignas-tp.md) — las 43 consignas de la guía del II cuatrimestre, cada una con el **título exacto** de la sección que la responde. Si la sección cambia de nombre, se corrige ahí también: lo mide `verificar-cobertura.py` |
| generar el PDF | `.\compilar.bat` (o `compilar.bat galeria`). El flujo y el chequeo visual: `/pdf-con-codigo` |

## Las reglas propias

**1. Ninguna sección se da por cerrada sin haber mirado su página compilada.**
Que Typst compile no dice nada sobre si los rótulos se cruzan, si una figura
entró, o si una tabla se cortó. Ya costó dos rondas de correcciones sobre
material que "estaba listo".

**2. Una figura legible puede estar eléctricamente mal, y son dos chequeos
distintos.** Toda figura con semiconductor u operacional pasa además por
**recorte de pixel**: se amplía el símbolo y se mira para qué lado apunta.
`fig-puente-graetz` estuvo mal una quincena y los cinco chequeos la dieron por
buena; `fig-fuente-doble` nació con el ramal B y el riel negativo **a la misma
altura**, fundidos en una sola línea, y compilaba igual.

**3. El número de un ejercicio es texto plano y no lo valida el compilador.**
Insertar un `#ejercicio(...)` en el medio de un módulo corre todos los que le
siguen y deja las referencias apuntando al circuito equivocado, sin un solo
warning. Lo mide el **chequeo 6** de `verificar.py`, que nació el día que ese
error se cometió de verdad.

## El estado en un comando

```powershell
cd apunte; python verificar.py       # los SEIS chequeos del apunte
cd ..; python verificar-cobertura.py        # que el apunte cubra las consignas de los TP
cd ..; python probar-verificar-cobertura.py # y que ESE chequeo no esté ciego
```

## Dónde está cada cosa

```
apunte/        el fuente Typst y el PDF compilado, y verificar.py
docs/          figuras.md (el catalogo) y referencia/ (material de consulta)
fuentes/       bibliografia, las guias de TP y consignas-tp.md
verificar-cobertura.py · probar-verificar-cobertura.py
PDP.md · ESTADO_ACTUAL.md · HANDOFF.md
```

## Estructura (al 2026-09-22)

`PDP.md` existe, y es donde viven **el plan de fases, el criterio de salida de
la fase en curso y las decisiones de contenido con su porqué**. Estaba escrito
en `HANDOFF.md` y había divergido —seguía pidiendo circuitos en ASCII borrados
cinco días antes—, así que el handoff ahora apunta al PDP en vez de repetirlo.

Desde el **2026-09-22** el PDP está **migrado al molde nuevo** de
`arquitectura-se`: §3 lleva el rigor **por aspecto** (cuatro aspectos, dos
ejes) en vez de una criticidad única, §4 lleva la columna *Cómo se certifica*,
y §8 es la **matriz de cumplimiento** (16 filas, 3 recortadas, todas con su
resta escrita). Lo miden `medir-fase.py` y `medir-matriz.py` del perfil.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
