# Jugar BLACK — teclado, mouse, parches y 60 FPS

Esta capa no es reversing: es la que hace que el juego **se pueda jugar bien**
mientras el reversing avanza por otro lado. Todo lo de acá es reversible y
está en scripts commiteados, no en clicks que se olvidan.

Abierta el **2026-09-04**.

---

## Los dos accesos directos del Escritorio

| Acceso | Qué hace |
|---|---|
| **BLACK** | cierra nada, verifica el mapeo de controles, levanta el agachado-mantenido y abre el juego a pantalla completa |
| **BLACK - Parches** | menú para prender y apagar parches (60 FPS, widescreen, mods del proyecto) y el overclock del EE |

Se regeneran con `lanzadores/crear-accesos-directos.ps1` (se puede correr
cuantas veces se quiera; pisa los `.lnk`).

El ISO por defecto es el **original** (`Black.iso`). Los mods de gameplay
viven como **pnach**, no como ISO: se prenden y apagan sin tocar el ISO, se
acumulan entre sí, y no obligan a reconstruir 3,9 GB por cada cambio.
`JUGAR-BLACK.ps1 -Iso mod-armas` o `-Iso mod-7b` abren los otros dos.

**Los tres ISO arrancan con el mismo CRC `5C891FF1`** — medido en
`emulog.txt`, no supuesto. Así que la lista de parches vale para los tres.

---

## El mapeo de teclado y mouse

La fuente es `herramientas/configurar-controles.ps1`, **no el ini**. PCSX2
reescribe `Documents\PCSX2\inis\PCSX2.ini` al salir con lo que tiene en
memoria: cualquier edición hecha con el emulador abierto se pierde, y el
mapeo ya se perdió una vez por eso. Ahora el ini es la *salida* de un archivo
del repo.

```powershell
.\herramientas\configurar-controles.ps1              # aplica
.\herramientas\configurar-controles.ps1 -Verificar   # dice si el ini coincide (sale 1 si no)
.\herramientas\configurar-controles.ps1 -Restaurar   # vuelve al backup anterior
```

| Acción en BLACK | Botón PS2 | Tecla |
|---|---|---|
| disparar | R1 | click izquierdo |
| apuntar / mira | L1 | click derecho |
| recargar | Cross | **R** |
| granada | R2 | **Q** |
| silenciador | Triangle | **Z** |
| modo de ráfaga | D-pad ↑ | **X** |
| agacharse | L2 | **Shift** (mantenido, ver abajo) |
| arma anterior / siguiente | D-pad ← / → | **1** / **2**, y la rueda del mouse |
| agarrar / cambiar arma | Square | **E** |
| cuerpo a cuerpo | Circle | **F** |
| botiquín | D-pad ↓ | **H** |
| moverse | stick izq | WASD |
| mirar | stick der | mouse |

El mando SDL sigue mapeado en paralelo: PCSX2 admite varios bindings por
botón, así que se puede alternar sin reconfigurar.

**Por qué los números no seleccionan un arma concreta.** BLACK no tiene un
botón por arma: la cambia **ciclando**. `1` y `2` son anterior/siguiente,
que es lo máximo que puede dar un binding. La selección absoluta por número
necesita saber qué arma tiene puesta el jugador para calcular cuántos pasos
dar — es leíble por PINE, pero es una fase de trabajo, no una línea de ini.
Anotado como candidato.

---

## El mouse: por qué no era lineal, y qué lo arregla

El síntoma era: moviendo despacio y parejo se llega al máximo del stick,
pero un manotazo rápido y largo gira **muchas veces menos** de lo que
corresponde a esa distancia.

La causa está en el código de PCSX2 2.8.0
(`InputManager::GenerateRelativeMouseEvents`), verbatim:

```cpp
s_pointer_pos[axis] += delta * s_pointer_axis_speed[axis];
value = std::clamp(s_pointer_pos[axis], -1.0f, 1.0f);
s_pointer_pos[axis] -= value;          // lo que no entró queda de resto
s_pointer_pos[axis] *= s_pointer_inertia;   // y el resto se DECAE
```

El eje del stick está topeado en `1.0`. Un movimiento rápido produce más de
`1.0`; el sobrante queda guardado **y se multiplica por la inercia**. Con el
default de PCSX2 (`PointerInertia = 10` → factor `0.10`) se tira el **90 % del
sobrante en cada frame**. Un movimiento lento nunca genera sobrante y entra
entero; un manotazo genera casi todo sobrante y se pierde casi todo. Eso es
exactamente el síntoma, y no es una impresión: sale de la fórmula.

**El arreglo: `PointerInertia = 100` → factor `1.00`, no se tira nada.** El
sobrante se guarda y se drena a stick máximo en los frames siguientes, así que
el giro total queda proporcional al desplazamiento total del mouse. Eso es la
linealidad pedida.

**El precio, que es real:** un manotazo grande sigue girando después de que el
mouse se frenó, hasta que el buffer se vacía. Es inevitable con un mando de
velocidad: **el juego controla velocidad angular con tope, y el mouse manda
distancia**.

> **CORREGIDO EL 2026-09-05.** Esta sección decía antes que lo único que sube
> el tope es la sensibilidad dentro del juego, y que había que ponerla al
> máximo. Las dos cosas resultaron mal: **no aparece ninguna cadena de
> sensibilidad en el ELF** (`ensitiv`, `Sensit`, `SENSIT`, `urnRate`,
> `ookSpeed`: cero apariciones en los 3.371.868 B), así que probablemente
> BLACK no tenga ese ajuste — `probable`, porque los textos del menú podrían
> vivir en un archivo de idioma del ISO. Y sobre todo: **la causa principal no
> era el tope, era una curva cúbica**. Ver la sección de abajo.

**Y hay una segunda cosa que ajustar, que es la que produce las vueltas
enteras.** `Inertia = 100` no tira nada, pero eso sólo sirve si la deuda es
chica, y la deuda sólo es chica si `Speed` hace que casi nunca satures. Con
`Speed = 40` se satura a **50 cuentas de mouse por sondeo**, que con un mouse
de 1600 DPI es un movimiento lento: un manotazo de 12.000 cuentas deja unos
200 sondeos de deuda, o sea más de tres segundos girando a fondo *después* de
soltar el mouse. Por eso el default pasó a **`Speed = 5`** (satura a 400) y
**`Inertia = 25`**.

El número que importa para elegir `Speed` es uno solo:

    SATURACIÓN = 2000 / Speed    cuentas de mouse por sondeo (~60 por segundo)

y sale de las constantes reales del fuente de PCSX2 (`ui_ctrl_range = 100.0f`,
`pointer_sensitivity = 0.05f`), no de una estimación.

## La causa de fondo: BLACK eleva el stick al CUBO

Medido el 2026-09-05, en frío. El juego registra cuatro parámetros de control
contra su propia base de valores, y uno de ellos se llama **`Analogue Control
Power`**. **Vale 3.0.**

    stick 1.00  ->  1.000     velocidad máxima
    stick 0.50  ->  0.125     ocho veces menos
    stick 0.25  ->  0.016     sesenta y cuatro veces menos
    stick 0.10  ->  0.001     mil veces menos

Eso explica **las dos mitades de la queja con una sola causa**: los movimientos
lentos casi no mueven la mira —no es una zona muerta, es que la curva es plana
abajo— y la respuesta se siente de todo-o-nada porque se empina de golpe
arriba. Y explica por qué **ningún ajuste del emulador lo iba a arreglar**:
PCSX2 entrega un valor lineal y el juego lo cubica *después*.

Los cuatro parámetros viven contiguos en la estructura del jugador:

| dirección | parámetro | valor |
|---|---|---|
| `0x005A9050` | Max Hold Modifier Increment | 0.5 |
| `0x005A9054` | Max Hold Modifier | 0.5 |
| **`0x005A9058`** | **Analogue Control Power** | **3.0** |
| `0x005A905C` | Percentage Catch Up | 0.5 |

El mod `mods/mira-lineal.toml` escribe **1.0** en `0x005A9058`, y ya está
prendido en el menú de parches. Los otros tres son hipótesis leídas del nombre
y van aparte en `mods/mira-sin-suavizado.toml`, **apagado**: se prueban después
y de a uno. La cadena completa de cómo se llegó a esas direcciones está en
`kb/mapa-memoria.json`, entradas `analogue_control_power` y las tres hermanas.

**Falta confirmarlo por efecto.** Está medido en diez volcados, que es mucho
más que una corazonada, pero en este proyecto `confirmado` significa que se vio
el cambio en pantalla.

Los tres knobs, todos parámetros del script:

| knob | qué es | default acá |
|---|---|---|
| `Speed` | sensibilidad real (giro por centímetro de mouse) | 40 |
| `DeadZone` | piso que se suma a todo valor distinto de cero, para vencer la zona muerta del juego | 20 |
| `Inertia` | 100 = lineal (nada se tira); 10 = default de PCSX2 | **100** |

```powershell
.\herramientas\configurar-controles.ps1 -Speed 25 -Inertia 100
```

### Dos hallazgos de paso

- **`PointerXScale` / `PointerYScale` son de PCSX2 viejo: 2.8.0 no las lee.**
  El ini tenía `PointerXScale = 8` en `[Pad]` y `= 40` en `[Pad1]`, las dos
  letra muerta. Las claves vivas son `PointerXSpeed`, `PointerYSpeed`,
  `PointerXDeadZone`, `PointerYDeadZone` y `PointerInertia`, y van en `[Pad]`
  (global), **no** en `[Pad1]`.
- **`AxisScale` estaba en `1.33`.** Con eso, cualquier valor arriba de `0.75`
  ya satura el eje del DualShock: un segundo recorte encima del primero, justo
  en la zona donde se está peleando por la linealidad. Bajado a `1`.

---

## Agacharse manteniendo Shift

En BLACK el agachado es un **toggle del juego**: L2 alterna agachado/parado.
Un binding de emulador sólo puede decir "L2 está apretado"; no puede inventar
el segundo apretón que hace falta para volver a pararse. Por eso hay un script
de AutoHotkey (`lanzadores/agachado-hold.ahk`) que manda **dos toques**: uno al
apretar Shift y otro al soltarlo.

Sólo actúa con la ventana de PCSX2 al frente. `JUGAR-BLACK.ps1` lo levanta
solo si AutoHotkey está instalado; si no está, avisa y el agachado queda en
toggle. `MODO_TOGGLE := false` en la primera línea del `.ahk` lo desactiva sin
desinstalar nada.

**El arreglo de fondo** —parchear la rutina del juego para que el agachado lea
el estado del botón en vez de alternar— es reversing y está anotado como
candidato. Esto anda hoy.

---

## Parches y 60 FPS

`lanzadores/PARCHES-BLACK.ps1` junta en **una** lista:

- los parches oficiales de PCSX2 para BLACK, que viven comprimidos en
  `C:\Program Files\PCSX2\resources\patches.zip`;
- los mods propios del proyecto (`construido/*.pnach`, generados de
  `mods/*.toml` con `pnach.py`);
- el overclock del EE.

Los escribe juntos en `Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach` — así
PCSX2 los muestra en la misma lista sin importar si la carpeta de usuario tapa
o complementa al zip — y prende/apaga por nombre en
`Documents\PCSX2\gamesettings\SLUS-21376_5C891FF1.ini`.

Lo disponible hoy:

| Parche | Autor | Nota |
|---|---|---|
| 60 FPS | Gabominated & PeterDelta | *"Might need EE Overclock (180%)"* |
| Widescreen 16:9 | No.47 | |
| Video Mode | Gabominated | fuerza el selector de 480p |
| No Blur While Reload | Gabominated | saca el desenfoque al recargar |
| Dificultad x2 | proyecto BLACK | daño de **salida** del jugador, fase 5a |

### El 60 FPS: qué está medido y qué no

El parche está **prendido desde el 2026-07-18** en el ini de gamesettings, y
sin embargo la medición de R1 (2026-09-01) dio **29.97 FPS** — exactamente la
mitad de los 59.94 de V-Blank. Las dos cosas no pueden ser ciertas a la vez.
`hipótesis`, sin resolver:

1. el parche no se está aplicando (el nombre en `Enable =` no coincide, o
   `EnablePatches` no llega a ese ISO);
2. se aplica y el EE no da: sin overclock, el juego no sostiene 60 y cae al
   múltiplo de abajo. El propio autor lo advierte.

**Se distingue en 30 segundos y sin instrumental:** abrir el juego, mirar el
FPS del OSD. Si dice ~59.94, andaba y R1 midió antes de que el ini estuviera.
Si dice 29.97, subir el overclock del EE a 180 % desde el menú de parches y
volver a mirar. La escalera del overclock es `100 → 130 → 180 → 300`
(`EECycleRate` 0/1/2/3 en `PCSX2.ini`).

---

## Lo que NO se puede hacer desde acá

Y por qué, para no volver a intentarlo:

| Pedido | Por qué no alcanza con configurar | Dónde vive el arreglo |
|---|---|---|
| número → arma concreta | el juego cicla, no indexa | leer el arma actual por PINE + macro, o parchear la selección |
| agacharse sin script externo | el toggle es del juego | parchear la rutina de agachado |
| mouse sin lag en el manotazo | el juego integra velocidad con tope | subir el tope de giro en el código, no en el emulador |
| más de 60 FPS | el motor está atado al V-Blank de PS2 | fuera de alcance; 60 es el techo real |

---

## La sensibilidad de mira EXISTE, y es un float — 2026-09-05

Todo lo de arriba trataba a los tres knobs de PCSX2 como si fueran lo único que
había, porque se creía que el techo de velocidad de giro era del juego y no se
podía tocar. **El techo es del juego, sí — pero se puede escribir.**

`FUN_001404a8` (`0x001404A8`) es la función de mira completa. Su último tramo,
en limpio:

```
factor_zoom = 1 / ((jugador[+0x2AC] - 1) * 0.8 + 1)    # con zoom, gira más lento
si (x² + y² > 0.95):                                    # stick casi a fondo
    hold += MaxHoldIncrement * |eje| * dt   (tope MaxHoldModifier)
    eje  += hold                                        # aceleración por MANTENER
sino: hold = 0
si (apuntando con L1): eje *= 0.7                       # 30% más lento con la mira
eje   = signo(eje) * powf(|eje|, AnalogueControlPower)  # LA CURVA
suave = suave + (eje - suave) * PercentageCatchUp       # EL FILTRO
yaw   += suave_x * GiroX * dt * factor_zoom
pitch += suave_y * GiroY * dt * factor_zoom
pitch se recorta a ±70   ;   yaw se envuelve a ±180
```

Y `GiroX` / `GiroY` son **datos**, en la estructura de controles del jugador
(`0x005A8FA0`, que es jugador + `0x4F0`):

| dirección | qué es | de fábrica |
|---|---|---|
| **`0x005A9048`** | **velocidad de giro HORIZONTAL, grados/segundo** | **70.0** |
| **`0x005A904C`** | **velocidad de giro VERTICAL, grados/segundo** | **25.0** |
| `0x005A9050` | Max Hold Modifier Increment | 0.5 |
| `0x005A9054` | Max Hold Modifier | 0.5 |
| `0x005A9058` | Analogue Control Power (exponente) | 3.0 |
| `0x005A905C` | Percentage Catch Up (suavizado) | 0.5 |

**70 grados por segundo son cinco segundos para dar una vuelta completa.** A
1600 DPI y con `Speed = 5`, eso son **casi dos metros de mousepad por vuelta**.
Ésa es la causa medida de "muevo el mouse y la mira casi no se mueve", y no hay
combinación de `Speed`/`DeadZone`/`Inertia` que la arregle: PCSX2 entrega un eje
de 0 a 1 y los grados por segundo los pone el juego, acá.

### Cómo se confirmó, y cuál fue el control

Se escribió `210.0` (×3) en `0x005A9048` y se midió la velocidad angular real
leyendo el yaw de la cámara por PINE:

| GiroX | horizontal medido | **vertical medido (el control)** |
|---|---|---|
| 70.0 | 87.7 grados/s | 25.7 grados/s |
| **210.0** | **264.4 grados/s** (×3.01) | 25.7 grados/s |
| 70.0 (vuelta) | 88.3 grados/s | 25.8 grados/s |

El factor salió **3.01** contra 3.00 predicho, es **reversible**, y el eje que
no se tocó **no se movió**. Un cambio que mueve exactamente lo que se tocó y
deja quieto lo de al lado no es una coincidencia.

### El instrumento que lo hizo posible

Medir esto necesitaba las dos puntas del lazo, y ninguna existía:

- **entrada** — `herramientas/pcsx2_mouse.ps1`: inyecta movimiento relativo de
  mouse con `SendInput`, en pasos chicos, y **verifica que tomó el foco por
  efecto** (`GetForegroundWindow` después, no que la llamada no tire error).
- **salida** — el yaw de la cámara en `0x005A8DA0`, **en grados**. Se encontró
  con un diferencial **con control de ruido**: foto, 1,5 s sin tocar nada, foto
  (eso da las 4757 palabras que cambian solas), y recién después foto /
  inyección / foto. Candidato = cambia con input y **no** cambia solo. El
  segundo control fue inyectar el movimiento contrario y exigir que **vuelva**.
- El control cruzado que apareció solo: en `0x005A8B20` / `0x005A8B28` hay un
  par `(0.69411, -0.71987)` cuyo `atan2` da 46,05 grados — el mismo número que
  el yaw. Son su coseno y su seno, y siguen coincidiendo después de girar.

```powershell
python herramientas/mira.py yaw          # el angulo, con su control cruzado
python herramientas/mira.py sens 350     # cambia la sensibilidad EN VIVO
python herramientas/mira.py curva        # la curva de respuesta medida
```

`sens` escribe por PINE y se pierde al reiniciar; para que quede, el valor va a
`mods/mira-sensibilidad.toml` y se recompila el pnach.

### La curva quedó lineal — `mira-lineal` confirmado por efecto

Con el exponente en 1.0, la respuesta medida es **lineal con zona muerta**:
`grados/s ≈ 155 · (eje − 0,089)`, y el ajuste da la misma constante en cinco
puntos (eje 0,10 → 1,56 grados/s; 0,15 → 9,23; 0,25 → 24,70; 0,55 → 76,31).
Una curva **cúbica** habría dado una razón de 10,6 entre los dos últimos puntos;
la medida es 3,09 y la lineal predice 2,88. **La cúbica queda descartada por un
factor de tres.**

### Lo que NO se pudo cerrar, y por qué

Queda un **piso**: por debajo de cierta velocidad de mouse la mira no se mueve
**nada** (0,000 grados exacto, no "poco"), y ese piso **no se movió** al cambiar
`DeadZone` (5 → 0), `Inertia` (25 → 0), `Speed` (5 → 6), la sensibilidad (×5)
ni la aceleración de puntero de Windows. Cinco variables, ningún efecto: la
hipótesis de que la deuda de inercia de PCSX2 lo causaba **quedó falsada**.

**Y hay una razón para desconfiar del piso mismo:** el inyector manda ráfagas
discretas con huecos, y un mouse real manda movimiento continuo en *todos* los
sondeos. El piso puede ser del instrumento y no del juego. Eso lo decide una
mano sobre el mouse, no otra medición sintética — es lo único de esta sección
que queda para verificar jugando.

### Qué quedó configurado

| knob | antes | ahora | por qué |
|---|---|---|---|
| `PointerXSpeed` | 5 | **6** | satura a 333 cuentas/sondeo (~12 pulgadas/s a 1600 DPI) |
| `PointerXDeadZone` | 5 | **0** | con Giro 350 un piso de 10 sería un salto mínimo de 35 grados/s |
| `PointerInertia` | 25 | **0** | sin deuda no hay giro-de-más después de soltar el mouse |
| **GiroX** | 70 | **350** | ×5 — 0,0175 grados por cuenta ≈ 32 cm por vuelta a 1600 DPI |
| **GiroY** | 25 | **350** | igualado al horizontal: con mouse la escala de los dos ejes es la misma |
| **zona muerta del JUEGO** | 0,1 | **0** | `mods/zona-muerta-cero.toml`. Era el piso: ~33 cuentas/sondeo, ~3 cm/s de mouse. No es del emulador |
| **auto-apuntado** | on | **off** | `mods/auto-apuntado.toml`. Cono de 5,7° y 30 unidades; con Giro 350 dejó de estar tapado y se siente como un tirón |

Y **la aceleración de puntero de Windows quedó APAGADA**
(`herramientas/aceleracion-mouse.ps1`), porque PCSX2 no lee el mouse crudo sino
los eventos ya pasados por la balística del sistema: con la aceleración
prendida, la misma distancia de mouse produce distinto giro según la velocidad
con que se movió. Es un ajuste **del escritorio entero**, así que se guardó el
estado previo y vuelve con un comando:

```powershell
python herramientas/../herramientas/aceleracion-mouse.ps1 -Restaurar
```

### Lo que sigue, si todavía falta o sobra

- **Falta giro** → subir `GiroX`, no `Speed`. `Speed` alto satura antes y tira
  movimiento; el Giro no tiene tope aguas abajo.
- **Se pasa / es brusco** → bajar `GiroX`.
- **Se siente "blando" o con retardo** → es `Percentage Catch Up` (`0x005A905C`,
  vale 0.5): la mira recorre por frame sólo la mitad de lo que le falta. Está en
  `mods/mira-sin-suavizado.toml`, **apagado**, y se prueba de a uno.
- **Mirar más arriba y más abajo** → el recorte de ±70 grados del pitch es un
  **inmediato del código** (`0x428C0000` dentro de `0x001404A8`), no un dato.
  Sin probar.
