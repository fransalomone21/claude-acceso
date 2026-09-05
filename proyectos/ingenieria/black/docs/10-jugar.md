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
distancia**. Ninguna configuración del emulador cambia eso; lo único que sube
el tope es la sensibilidad **dentro del juego** (Options → Controls), y por eso
conviene ponerla al máximo ahí y bajar `Speed` acá. Con el tope más alto, menos
movimientos generan sobrante y menos hay que drenar.

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
