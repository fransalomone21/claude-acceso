# Naturaleza: `ingenieria`

Trabajo sobre un sistema técnico que **no se conoce del todo**: ingeniería
reversa, diagnóstico, hardware, herramientas. Lo que se produce no es un
documento sino **conocimiento verificado** sobre un sistema, y un cambio que
lo aprovecha.

Se lee al entrar a cualquier proyecto de esta clase, antes del `PROYECTO.md`.

## Lo que define a esta naturaleza

Hay una **realidad externa que puede contradecirte**. Esa es la diferencia con
las otras dos, y de ahí sale todo lo demás.

## Lo que se lee siempre

| Archivo | Por qué |
|---|---|
| `ESTADO_ACTUAL.md` | entero. Qué está confirmado y qué es hipótesis, hoy |
| `PDP.md` §4 | la fase en curso y qué la cierra |
| `HANDOFF.md` | lo que la sesión anterior dejó a medias |

`docs/bitacora.md` **no** se lee al abrir: se lee cuando hace falta saber
*cómo* se llegó a algo o *qué ya se probó y falló*.

## Las cinco cosas que no se negocian

1. **Confirmado = intervine y vi el efecto.** Nada más cuenta. Todo lo demás
   se anota como `hipotesis` o `probable`, y con esa palabra. Reportar un
   escalón más arriba de lo que se midió es el error más caro del oficio.

2. **Todo dato lleva su versión.** Una dirección, un offset, un registro o un
   comportamiento valen para **una** versión del sistema. Sin eso, el dato es
   una trampa que cobra en tres meses.

3. **El repo es la memoria.** Un hallazgo que no quedó escrito se perdió, por
   más obvio que parezca en el momento. Anotarlo es parte de encontrarlo, y se
   anota **apenas se confirma**, no al cerrar la sesión.

4. **El éxito también se audita.** Si algo empezó a andar después de tocar
   varias cosas, sacar las que no entendés es más barato ahora que después.
   Un éxito que no sabés explicar es una coincidencia que todavía no se
   descubrió.

5. **Nada de volcados crudos en el chat.** Los hexdumps y los listados largos
   van a archivo y se referencian por ruta y offset.

## Verificación y validación — no son lo mismo

- **Verificación:** ¿el sistema hace lo que el requisito dice? Se mide contra
  la especificación.
- **Validación:** ¿esto sirve para lo que hacía falta? Se mide contra la
  necesidad real.

Se puede verificar perfecto y fallar la validación entera: construir con
precisión la cosa equivocada. Antes de una fase larga, preguntar las dos.

## Antes de creerle a una herramienta

- Un resultado de **cero** acusa al parámetro de la búsqueda, no al mundo.
  Igual que uno que da demasiados.
- Un número absurdo es un síntoma, no un dato.
- Una herramienta que nunca dio negativo está sin probar: hacela fallar a
  propósito una vez y mirá que se ponga en rojo.
- Antes de culpar al sistema, al emulador o a la biblioteca: huellas de cascos
  son caballos, no cebras. Que los workarounds no funcionen es la señal de que
  el modelo está mal, no de que falta otro workaround.

## Riesgo

Antes de una intervención que pueda romper algo: **guardar el estado
reversible** (savestate, backup, rama) y probar el mecanismo en un blanco
inocuo primero. Se anota en `PDP.md` §5 con su disparador observable.
