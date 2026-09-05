# Predicción del piso de la mira — escrita ANTES de abrir el emulador

**Fecha:** 2026-09-05, sesión de la mañana.
**Estado previo:** el piso está *confirmado que existe* — Fran jugó con mouse
real y reportó que moviendo despacio la mira no se mueve **nada**. Eso falsa la
hipótesis de que el piso fuera del inyector, que era lo único que quedaba
abierto de la línea J1.

Lo que sigue es la **causa** propuesta, con números, y qué mediría cada una.

## El modelo

Tres hechos, ninguno nuevo, que hasta ahora no se habían multiplicado entre sí:

1. **El eje analógico del DualShock2 viaja como UN BYTE.** No es una decisión
   de PCSX2: es el protocolo del pad de PS2. El juego no puede ver nada más
   fino que 1/127 de deflexión, porque no le llega.
2. **La ganancia del puntero de PCSX2 es `Speed × 0.0005` por cuenta de
   mouse**, y satura a `2000 / Speed` cuentas por sondeo. Está en
   `docs/03-bitacora.md` §5, leído del fuente de PCSX2
   (`ui_ctrl_range = 100.0f`, `pointer_sensitivity = 0.05f`).
3. **`pad_leer_accion` (0x00124840) NO tiene zona muerta.** Decompilada entera
   hoy: para los ejes de mira devuelve el float crudo de `pad_valor_binding`
   si es ≥ 0. El piso no lo pone el juego.

Multiplicando 1 y 2:

    piso = (1/127) / (Speed × 0.0005) = 15.75 / Speed   cuentas por sondeo

Con `Speed = 6` (lo que hay hoy): **2,625 cuentas por frame**. A 60 fps y 1600
DPI eso es **2,5 mm/s de mouse**. Por debajo de eso el byte queda en 128 y el
juego ve **cero exacto**, no "poco".

## Las predicciones, y qué las falsa

Inyectando con `mira.py curva` a paso fijo, con `Speed = 6`, `Giro = 350`:

| P | qué se inyecta | qué predigo |
|---|---|---|
| **P1** | 1 cuenta por frame, sostenido 10 s | yaw cambia **0,00 grados**. Cero exacto, no "poco". |
| **P2** | 2 cuentas por frame | **0,00 grados** también. |
| **P3** | 3 cuentas por frame | se mueve, a **2,76 grados/s** (= 1 LSB × 350/127) |
| **P4** | 4 y 5 cuentas por frame | **los mismos 2,76 grados/s**, no más |
| **P5** | 6 cuentas por frame | salta a **5,5 grados/s** (2 LSB) |

O sea: **la respuesta tiene que ser una ESCALERA, no una recta**, con escalones
cada `15.75/6 = 2,625` cuentas y de `350/127 = 2,76` grados/s de alto.

**Control negativo (la otra mitad, y es la que hace que valga algo):** repetir
el mismo barrido con `Speed = 40`. Ahí el escalón cae a `15.75/40 = 0,39`
cuentas, o sea **menos de una cuenta**: la escalera tiene que **desaparecer** y
volverse una recta, con 1 cuenta ya moviendo la mira.

**QUÉ LO FALSA.** Si a 1 cuenta por frame la mira **sí** se mueve con
`Speed = 6`, el modelo está mal y el piso es de otra cosa. Si la respuesta sale
recta en vez de escalonada, también. Si los escalones aparecen pero cada
`X ≠ 2,625` cuentas, la ganancia del puntero no es `Speed × 0.0005`.

**Variante que hay que distinguir:** si en vez de cero exacto, a 1 cuenta por
frame la mira avanza **a los tirones** (quieta varios frames y de golpe un
salto), entonces PCSX2 **está guardando el resto sub-LSB** y el piso es de
*resolución temporal*, no un piso duro. Eso cambiaría el arreglo por completo:
sería `PointerInertia`, y no habría que tocar `Speed`.

## Por qué importa el resultado

Si el modelo es cierto, el piso y el techo son **la misma perilla**: la ventana
útil en velocidad de mouse es de exactamente 127:1 y `Speed` sólo la desliza.
Bajar el piso a la mitad sube el piso de saturación a la mitad — con `Speed=6`
hoy la ventana va de 2,5 mm/s a 32 cm/s. Eso convierte la queja de Fran en una
elección con costo declarado, en vez de en un bug por buscar.

Si en cambio hay banco de resto (la variante), no hay que elegir nada: es
`PointerInertia` y sale gratis.
