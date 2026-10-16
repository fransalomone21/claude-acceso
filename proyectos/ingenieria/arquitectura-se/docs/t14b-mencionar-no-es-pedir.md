# T14b — mencionar no es pedir

**Diseño y construcción, 2026-10-16.** Fase 7, tipo D. Requisitos: L2-PTA-05, L2-PTA-06 y L2-AUD-02
([`10-requisitos.md`](10-requisitos.md) §6). Fila 1c-b de la lluvia §6; el pedido de Fran está en la lluvia §7: «lo
nombrado como contexto, necesidad secundaria o pendiente de confirmar se REGISTRA; se trabaja sólo en lo que pide, y
cuando lo pide explícitamente».

## 1. El problema, medido

T14 sacó de la inferencia lo pegado y lo automático. Lo que **Fran tipea** sigue infiriendo, y ahí la puerta no puede
distinguir «hacé X» de «ojo que otra sesión está con X». Medido en `~/.claude/hooks/cascada-excepciones.log` desde el
2026-10-12 20:00 (después de T14): **10 excepciones** (sesión × proyecto), y **8 no eran pedidos**:

| Clase | Casos | Ejemplo del motivo |
|---|---|---|
| nombrado como contexto u otra sesión en paralelo | 5 | «Fran avisa que OTRA sesión paralela trabaja apunte-iise» |
| una palabra suelta (señal débil) | 3 | «la señal sale del nombre de la carpeta de Drive del TP Cohete» |
| excepción de verdad | 2 | «pregunta suelta urgente (defensa de Priscila)» |

La salida era la **Excepción**, y eso tiene dos costos: pinta P2 y P5 de la auditoría de AMARILLO (y P10 pide
lección), así que el canal de excepciones —el que tiene que avisar cuando se salteó la cascada de verdad— quedó con 8
de 10 falsos; y la Excepción **habilita a tocar el proyecto**, que para una mención es de más.

**Pregunta de marco:** ¿qué tendría que ser verdad para que esto sea el problema equivocado? Que la puerta pudiera
leer la intención. No puede: por palabras («otra sesión», «después») sería un disparador por palabra, el defecto que
T13 y T14 sacaron. La sesión sí la lee. Así que lo que falta no es inteligencia en el hook sino **un canal para que la
sesión registre lo que leyó**, distinto del de la excepción.

## 2. La corrección

**La Mención**: `.\cascada.ps1 <p> -Mencion "motivo"` (y `bash .claude/cascada.sh <p> -Mencion "motivo"`). La puerta la
registra en el estado de la sesión, como la excepción, con tres diferencias:

1. **Sólo libera lo de afuera** (L2-PTA-05). Un Proyecto_Inferido con Mención deja de cubrir las acciones que no caen
   en ningún proyecto (el caso 331), y nada más.
2. **No habilita el proyecto** (L2-PTA-06). Si la acción toca la ruta del proyecto mencionado, la puerta pide la
   necesidad como siempre. La Excepción sí lo habilita; por eso sigue existiendo, para lo que de verdad es excepción.
3. **No colorea la auditoría** (L2-AUD-02). P5 cuenta las excepciones; las menciones van como dato, sin color. P2
   no la ve: P2 mira acciones sobre el proyecto, y una Mención no las permite.

`cascada.ps1 -Mencion` sale **antes** de imprimir la cascada (costo proporcional, N-07: registrar una mención no
cuesta leer el proyecto). El aviso de UserPromptSubmit y la negación de la puerta ofrecen las dos salidas.

**Lo que no se hace:** inferir la mención por palabras; vencer la mención por turno (si Fran después pide el
proyecto, la primera acción sobre su ruta frena igual, que es lo que importa); tocar las señales débiles (DA-054 y la
lección 372 ya las tratan; la Mención cubre su falso positivo restante).

**Riesgo declarado:** la sesión registra como Mención algo que era un pedido, y lo trabaja fuera de las carpetas del
proyecto (el 331 con otro disfraz). Lo cubre que la Mención queda escrita con su motivo en la caja negra y en el
informe de la auditoría, donde se ve; no lo cubre la puerta, porque eso pide leer la intención.

## 3. Verificación

- **Autotest de la puerta, caso 18:** pedido tipeado con la señal fuerte de un proyecto; control: con Mención, un
  Write fuera de todo proyecto pasa (L2-PTA-05); sabotajes: sin Mención el mismo Write se niega (el 331 sigue), y con
  Mención un Write DENTRO del proyecto se niega (L2-PTA-06). Mutante: la Mención tratada como Excepción deja pasar
  el Write adentro, y se tiene que ver en su caso.
- **Autotest de la auditoría:** una sesión con Mención y sin excepciones da P5 VERDE, y la evidencia nombra la Mención.
- **`chequeo-completo`** en verde, y el efecto real en la próxima sesión que nombre otro proyecto de pasada.

## 4. Construido y medido (2026-10-16)

Commits `429e2c6` (requisitos) y `dade03b` (construcción): `-Mencion` en `cascada.ps1` (sale antes de imprimir la
cascada) y en `.claude/cascada.sh`; en la puerta, el evento `mencion` en el estado, la exclusión en la inferencia
pendiente, en el contexto de las débiles y en el aviso de UserPromptSubmit, y la salida ofrecida en la negación sólo
cuando la acción cae afuera; en la auditoría, P5 informa la Mención sin color.

- **Autotest de la puerta, caso 18:** BIEN (control, dos sabotajes y dos mutantes vistos en su caso: la Mención
  tratada como Excepción, y sin leer `-Mencion`). Autotest entero BIEN.
- **Autotest de la auditoría:** caso T14b BIEN; [`probar-t14b.py`](../probar-t14b.py) ve los dos mutantes (la Mención
  contada como excepción; la Mención sin nombrar). Un primer MAL fue del autotest, no de la auditoría: el caso nuevo
  se insertó entre dos que comparten `res` y pisó al de abajo; ahora usa nombres propios.
- **Efecto real, en la sesión que lo construyó:** `.\cascada.ps1 telescopio -Mencion "…"` dejó
  `menciones: {telescopio}` en `--estado` (por el hook, la frontera real) sin tocar `excepciones`; y un Write en
  `proyectos/ingenieria/telescopio/` se negó pidiendo la necesidad, sin ofrecer la Mención (L2-PTA-06, `confirmado`).
- **`chequeo-completo`:** 13 medidores y 24 saboteadores en verde; un solo rojo, «listo para la nube», por los dos
  commits sin pushear (verde después del push).

Falta: el efecto en una sesión real donde Fran nombre otro proyecto de pasada (que la sesión registre la Mención en
vez de la Excepción), y que la auditoría la muestre sin color.
