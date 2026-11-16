# Recta final de Física Espacial — del 16/11 al 26/11/2026

Armado el 2026-11-15 con todo lo que bajó Fran (ANI-R17 en `catedras`) y el estado del repo. Es el plan de **qué
estudia Fran cada día** y de **qué produce cada sesión**, en ese orden de prioridad. Lo que cambie Aníbal entra a
`catedras` y se corrige acá en el mismo turno.

## A dónde hay que llegar

- **Jueves 26/11: 2.º parcial**, y ese día el recuperatorio de lo que haga falta del 1.º (ANI-74).
- **Para aprobar: entregar resueltos todos los problemas de «la última guía»** (ANI-73). Cuál es y para cuándo, sin
  dato: **preguntarle a Aníbal en la próxima clase**. Si es la sección de cuerpo rígido, la guía resuelta del 15/11 es
  la base; si la entrega tiene que ser de puño y letra de Fran, lo decide él.

## Qué entra (inferido, no dicho)

| Bloque | Por qué se cree que entra | Grado |
|---|---|---|
| Cuerpo rígido: cap. 18 del Beer entero (Euler, giróscopo, precesión estable y libre, directa/retrógrada, ley de los senos) | es lo que se dio después del 1.º parcial; el parcialito 5 y la guía de CR | probable |
| Actitud: CMG, rueda de reacción, saturación y desaturación, _coning_ y reorientación por impulsos | parcialito 6 (CMG) y el material del 15/11 (Martz, Sevilla, Curtis, apunte de CMG) | probable / hipótesis (coning) |
| Órbitas: elementos orbitales desde **r** y **v** (los ocho pasos de Aníbal), Hohmann, hipérbola | clases del 11/11 y «18 nov» (Bate); el recuperatorio del 1.º | probable para el recuperatorio |
| Formato del parcial: un numérico del Beer con figura, uno de dibujo 3D con preguntas, uno de «escriba (o deduzca)» con un «opine» | el 1.er parcial (ANI-41, 43, 45) | inferido |

## Lo que ya está hecho (dónde está, en Drive `Fisica Espacial/`)

- **La guía de CR entera resuelta con el workflow** (P1 a P9, los dos adicionales y los extras: PR 18.6, 18.127, la
  Tierra 18.117/18.123, el satélite GEO, _coning_, CMG), en `3 - Guia de problemas`, «Cuerpo rigido - guia completa
  resuelta (workflow)». Fuente: `practica/resueltos-cr.typ` + `resueltos-cr-extras.typ` + `workflow.typ`.
- El apunte (258 págs.; CR en m18 a m22), la hoja de fórmulas, los resueltos de CR 1 a 4, la guía y el modelo del
  parcialito 5 (CR), la guía del parcialito de CMG, los modelos del 1.er parcial y el 1.er parcial resuelto.

## El calendario de Fran

| Día | Qué | Con qué |
|---|---|---|
| Lun 16 | Leer el capítulo del workflow y **la tarjeta** (última página). Resolver el **P7 tapando la solución**, sólo con la tarjeta; comparar con la hoja de Aníbal. Después P1 a P4. | guía de CR resuelta |
| Mar 17 | P5, P6, P8, P9, Ad. 1 y Ad. 2, cada uno primero solo (los ocho pasos) y después comparar | guía de CR resuelta |
| Mié 18 | Los extras: PR 18.6, 18.127 (con el cuaderno de Aníbal), la Tierra (forzada contra libre), GEO, _coning_, CMG | capítulo de extras |
| Jue 19 | Clase. Repasar elementos orbitales desde r y v (los ocho pasos) | apunte, módulo perifocal |
| Vie 20 | **Modelo del 2.º parcial con reloj** (2 h), sin mirar nada más que la hoja de fórmulas | modelo nuevo (abajo) |
| Sáb 21 – Dom 22 | Corregir el modelo con la resolución; repasar lo que falló. Si hay que recuperar el 1.º: modelos 1 a 5 y el 1.er parcial resuelto | Drive, `4 - Parciales y parcialitos` |
| Lun 23 – Mar 24 | Segundo modelo; las preguntas «Para el oral» de cada problema, en voz alta | modelo 2, guía de CR |
| Mié 25 | Hoja de fórmulas final impresa; dormir | hoja de fórmulas |
| Jue 26 | Parcial | — |

## Lo que producen las próximas sesiones, en orden

1. **Modelo del 2.º parcial** (para el vie 20): tres problemas con el formato de ANI-41 sobre CR y actitud (un
   numérico del Beer con figura, uno de dibujo 3D, uno de «escriba/deduzca» con «opine»), resuelto con el workflow,
   números en `validar.py`, consignas enteras. Y un segundo modelo para el lun 23.
2. **Hoja de fórmulas**: sumar lo que falta del bloque de actitud (coning: $\sin\theta_0 = |\sin(R_2/2)/\sin(\Phi_f/2)|$
   y $\Delta\psi$; la cupla de precesión estable a 90°; desaturación), sólo fórmulas y títulos.
3. **Apunte — pendientes de incorporar** (lo nuevo del 15/11, medido el 15/11 contra los módulos: `coning`,
   `reorientaci` y `Martz` dan **0**):
   - _Coning_ impulsivo y reorientación por dos o tres impulsos (Martz TN D-8452, Curtis cap. 12, Sevilla lección 7,
     Satak 2012, Hall y Lowry) → módulo `actitud` (m22).
   - La Tierra: precesión forzada de los equinoccios (18.117) contra libre del polo (18.123, Chandler) → `peonza`
     (m21), que hoy nombra a Chandler una sola vez; los equinoccios están en `rotacion` (m17).
   - El satélite GEO con el spin hacia la Tierra (por qué no se hace: doble spin, rueda de momento normal a la órbita)
     → ejemplo en `euler-giroscopo` (m20).
   - Elementos orbitales desde r y v: contrastar el módulo `perifocal-lagrange` (m15) con los ocho pasos de Aníbal
     (sus $\Pi = \Omega + \omega$ y $l_0 = \Omega + \omega + \nu_0$, «no confundir ascensión recta con nodo
     ascendente») y sumar lo que falte.
   - El apunte de clase de CMG (`CMG_actuador_de_actitud.pdf`) contra «El CMG por dentro» de m22: lo que falte.
   - El workflow de ocho pasos como sección corta en m20 o m21, que remita a la guía.
4. **Preguntas para Aníbal** (las lleva Fran a clase): ¿cuál es «la última guía» y para cuándo? ¿Entra _coning_?
   ¿Entra la determinación de elementos desde r y v?
