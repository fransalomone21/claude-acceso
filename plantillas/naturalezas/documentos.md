# Naturaleza: `documentos`

Producir un artefacto de contenido que alguien va a leer: un apunte, un
informe, una guía, un repaso. Lo que se entrega es **el documento**, y su
calidad se juzga por lo que le pasa al lector, no por lo que dice el fuente.

Se lee al entrar a cualquier proyecto de esta clase, antes del `PROYECTO.md`.

## Lo que define a esta naturaleza

**No hay una realidad externa que te contradiga en el momento**: un documento
mal armado compila igual. La contradicción llega tarde y por otro lado — el
lector que no entiende, la referencia que apuntaba a la sección equivocada, la
figura que salió cortada. Por eso el riesgo acá no es equivocarse: es **no
enterarse**.

## Lo que se lee siempre

| Archivo | Por qué |
|---|---|
| `ESTADO_ACTUAL.md` | qué partes están cerradas y cuáles en borrador |
| `PDP.md` §4 | la fase en curso y qué la cierra |
| `HANDOFF.md` | las trampas de sintaxis ya pagadas y lo que quedó a medias |

## Las cinco cosas que no se negocian

1. **El destinatario está escrito.** Para quién es el documento, qué sabe ya y
   qué no. Sin eso no hay criterio para decidir qué explicar y qué asumir, y
   cada sección se escribe con un lector distinto en la cabeza.

2. **El render se mira, no se supone.** Que compile no es que esté bien. Un
   documento no está terminado hasta que se **vio** la página: rótulos que no
   se cruzan, figuras que entran, tablas que no se cortan. Ver
   `/pdf-con-codigo` para el flujo y el chequeo visual.

3. **Toda afirmación tiene fuente, y la fuente se anota donde se usa.** Si el
   documento lo afirma, en algún lado está de dónde salió. Un dato sin origen
   es una hipótesis con tipografía linda.

4. **Las decisiones de contenido se registran.** Qué se decidió incluir, qué
   se decidió dejar afuera y por qué. Es lo que evita rediscutir el índice en
   cada sesión — y lo que hace que la versión siguiente no revierta la
   anterior sin darse cuenta.

5. **Se escribe con código, no a mano.** El documento se genera desde fuente
   versionada. Editar el PDF a mano produce un resultado que no se puede
   regenerar, y eso es una fuente de verdad que se pierde en el primer cambio.

## La trampa propia de esta naturaleza

**Las referencias cruzadas de texto plano no las valida el compilador.** "Ver
la sección 4.2" no falla si la 4.2 se renumeró: sale impreso, mal, y nadie se
entera. Toda referencia va por el mecanismo que el compilador chequea
(`@etiqueta`, `\ref`), y si tiene que ser texto plano, se verifica a mano y se
anota que se verificó.

## Verificación y validación

- **Verificación:** ¿dice lo que tenía que decir, y compila y se ve bien?
- **Validación:** ¿el lector para el que es entiende lo que necesitaba?

Un apunte técnicamente impecable que el destinatario no puede seguir falló la
validación entera. Cuando se pueda, se prueba con un lector real; cuando no,
se lee una sección entera poniéndose en su lugar, no en el del autor.
