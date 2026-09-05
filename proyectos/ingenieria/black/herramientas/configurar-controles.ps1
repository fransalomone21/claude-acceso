# configurar-controles.ps1 -- deja PCSX2.ini con el mapeo teclado+mouse de BLACK.
#
# POR QUE EXISTE ESTE SCRIPT Y NO SE EDITA EL INI A MANO:
# PCSX2 reescribe Documents\PCSX2\inis\PCSX2.ini al SALIR, con lo que tenia en
# memoria. Todo lo que se toque con el emulador abierto se pierde. El mapeo
# vivia solo en ese archivo (que no esta en el repo) y ya se perdio una vez.
# Ahora la fuente es ESTE archivo, que esta commiteado, y el ini es su salida.
#
#   .\configurar-controles.ps1              aplica el mapeo
#   .\configurar-controles.ps1 -Verificar   solo dice si el ini coincide
#   .\configurar-controles.ps1 -Restaurar   vuelve al backup anterior
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

[CmdletBinding()]
param(
    [switch]$Verificar,
    [switch]$Restaurar,
    # Preset del mouse. 'lineal' es el default; los otros estan mas abajo.
    [ValidateSet('lineal','preciso','rapido','pcsx2')]
    [string]$Preset = 'lineal',
    # ...o los tres knobs a mano, que pisan al preset.
    [double]$Speed    = -1,
    [double]$DeadZone = -1,
    [double]$Inertia  = -1
)

$ErrorActionPreference = 'Stop'
$ini = Join-Path $env:USERPROFILE 'Documents\PCSX2\inis\PCSX2.ini'

# Set-Content -Encoding UTF8 en PowerShell 5.1 escribe BOM, y un ini que
# empieza con BOM le llega a PCSX2 con la primera seccion corrupta. Se escribe
# siempre por esta funcion, nunca con Set-Content.
function Escribir-Sin-BOM([string]$ruta, [string[]]$lineas) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ruta, (($lineas -join "`r`n") + "`r`n"), $enc)
}


# ---------------------------------------------------------------------------
# EL MOUSE: por que Inertia = 100 y no el default 10
# ---------------------------------------------------------------------------
# PCSX2 2.8.0 convierte el movimiento relativo del mouse en un eje de stick asi
# (InputManager::GenerateRelativeMouseEvents, verbatim del fuente):
#
#     s_pointer_pos[axis] += delta * s_pointer_axis_speed[axis];
#     value = std::clamp(s_pointer_pos[axis], -1.0f, 1.0f);
#     s_pointer_pos[axis] -= value;          <- lo que NO entro queda de resto
#     s_pointer_pos[axis] *= s_pointer_inertia;   <- y el resto se DECAE
#
# El stick esta topeado en 1.0. Un movimiento rapido genera mas de 1.0, el
# sobrante queda en s_pointer_pos... y se multiplica por la inercia. Con el
# default (PointerInertia = 10 -> factor 0.10) se TIRA el 90% del sobrante en
# cada frame: por eso un manotazo grande gira mucho menos de lo que deberia,
# mientras que un movimiento lento y constante entra entero y llega al maximo.
# Ese es exactamente el sintoma.
#
# PointerInertia = 100 -> factor 1.00 -> no se tira NADA. El sobrante se
# guarda y se drena a stick maximo en los frames siguientes: el giro total
# queda proporcional al desplazamiento total del mouse. Eso es la linealidad.
#
# El precio, que es real y hay que saberlo: un manotazo grande sigue girando
# despues de que el mouse se freno, hasta que el buffer se vacia. Es inevitable
# -- el juego controla VELOCIDAD de giro con tope, y el mouse manda DISTANCIA.
# Lo unico que sube el tope es la sensibilidad DENTRO del juego (Options ->
# Controls), asi que conviene subirla al maximo ahi y bajar Speed aca.
#
#   Speed     sensibilidad real (giro por centimetro de mouse). Sube -> mas
#             giro y mas lag en los manotazos.
#   DeadZone  piso que se suma a cualquier valor distinto de cero, para vencer
#             la zona muerta del juego. 0 = mas lineal pero los movimientos
#             chiquitos no mueven nada.
#   Inertia   100 = lineal (nada se tira). 10 = default de PCSX2. Bajarlo
#             cambia linealidad por respuesta inmediata.
#
# OJO: las claves son PointerXSpeed / PointerYSpeed / PointerXDeadZone /
# PointerYDeadZone / PointerInertia, en la seccion [Pad] (global, no [Pad1]).
# PointerXScale / PointerYScale son de PCSX2 viejo: 2.8.0 NO las lee. El ini
# tenia PointerXScale = 8 en [Pad] y = 40 en [Pad1]. Las dos eran letra muerta.


# ---------------------------------------------------------------------------
# LOS PRESETS, y de donde salen los numeros
# ---------------------------------------------------------------------------
# La formula de PCSX2 2.8.0, con las constantes del fuente ya sustituidas
# (ui_ctrl_range = 100.0f, pointer_sensitivity = 0.05f):
#
#     ganancia = Speed * 0.0005      por cada CUENTA de mouse
#     pos     += delta * ganancia
#     value    = clamp(pos, -1, 1)
#     pos     -= value               <- la deuda: lo que no entro
#     pos     *= Inertia / 100       <- y cuanto de la deuda se conserva
#     out      = value * (1 - DZ/100) + signo(value) * DZ/100
#
# De ahi sale el unico numero que importa para elegir Speed:
#
#     SATURACION = 2000 / Speed   cuentas de mouse por sondeo (~60 por segundo)
#
# Arriba de esa velocidad el stick ya esta al maximo y todo lo demas es DEUDA.
# Con el default de PCSX2 (Speed 40) satura a 50 cuentas por sondeo: con un
# mouse de 1600 DPI eso es un movimiento LENTO. Por eso saturaba siempre.
#
# Y la deuda es la que produce las vueltas enteras: con Inertia 100 no se
# pierde nada, asi que un manotazo de 12.000 cuentas deja ~200 sondeos de
# deuda = mas de tres segundos girando a fondo DESPUES de soltar el mouse.
# Inertia 100 es lineal, si -- pero solo sirve si la deuda es chica, y la
# deuda solo es chica si Speed hace que casi nunca satures.
#
#   lineal   Speed  5  -> satura a  400 cuentas/sondeo. El default de aca.
#   preciso  Speed  3  -> satura a  666. Sin zona muerta, para apuntar fino.
#   rapido   Speed 12  -> satura a  166. Gira mas, satura antes.
#   pcsx2    Speed 40  -> satura a   50. El de fabrica, para comparar.
#
# DeadZone es un piso que se SUMA a todo valor distinto de cero, para vencer
# la atenuacion del juego en los movimientos chiquitos. Sube el piso pero
# rompe la proporcionalidad justo abajo: 0 es lo mas lineal, 5-10 lo mas
# usable. Inertia baja = la deuda se descarta rapido (no gira de mas, pero
# pierde algo del manotazo); alta = se paga entera (lineal, pero gira de mas).

$PRESETS = @{
    'lineal'  = @{ Speed =  5; DeadZone =  5; Inertia = 25 }
    'preciso' = @{ Speed =  3; DeadZone =  0; Inertia = 10 }
    'rapido'  = @{ Speed = 12; DeadZone =  8; Inertia = 20 }
    'pcsx2'   = @{ Speed = 40; DeadZone = 20; Inertia = 10 }
}
$pre = $PRESETS[$Preset]
if ($Speed    -lt 0) { $Speed    = $pre.Speed }
if ($DeadZone -lt 0) { $DeadZone = $pre.DeadZone }
if ($Inertia  -lt 0) { $Inertia  = $pre.Inertia }

$padGlobal = @(
    'MultitapPort1 = false'
    'MultitapPort2 = false'
    "PointerXSpeed = $Speed"
    "PointerYSpeed = $Speed"
    "PointerXDeadZone = $DeadZone"
    "PointerYDeadZone = $DeadZone"
    "PointerInertia = $Inertia"
)

# ---------------------------------------------------------------------------
# EL TECLADO: el mapeo sale del layout REAL de BLACK, no del que se supuso
# ---------------------------------------------------------------------------
#   Cross    = recargar          -> R
#   Square   = agarrar/cambiar   -> E
#   Circle   = cuerpo a cuerpo   -> F
#   Triangle = silenciador       -> Z
#   L1       = apuntar / mira    -> boton derecho del mouse
#   L2       = agacharse         -> Shift   (en el juego es TOGGLE, ver el .ahk)
#   R1       = disparar          -> boton izquierdo del mouse
#   R2       = granada           -> Q
#   D-pad Up    = modo de fuego  -> X
#   D-pad Left  = arma anterior  -> 1  y rueda del mouse arriba
#   D-pad Right = arma siguiente -> 2  y rueda del mouse abajo
#   D-pad Down  = botiquin       -> H
#
# BLACK NO TIENE un boton por arma: el arma se CICLA. Por eso 1 y 2 son
# anterior/siguiente y no "arma 1" y "arma 2". Seleccion absoluta por numero
# necesita leer que arma tiene puesta el jugador -- se puede (el proyecto lee
# RAM viva por PINE), pero es una fase, no una linea de ini.
#
# Cada boton lleva DOS lineas: la del joystick SDL y la del teclado/mouse.
# PCSX2 admite varios bindings por boton, asi que el mando sigue andando.

$pad1 = @(
    'Type = DualShock2'
    'InvertL = 0'
    'InvertR = 0'
    'Deadzone = 0'
    # AxisScale = 1.0 y no 1.33: con 1.33 cualquier valor arriba de 0.75 ya
    # satura el eje del DualShock, y eso rompe la linealidad justo arriba.
    'AxisScale = 1'
    'LargeMotorScale = 1'
    'SmallMotorScale = 1'
    'ButtonDeadzone = 0'
    'PressureModifier = 0.5'

    # cruceta: modo de fuego, armas, botiquin
    'Up = SDL-0/DPadUp'
    'Up = Keyboard/X'
    'Right = SDL-0/DPadRight'
    'Right = Keyboard/2'
    'Right = Pointer-0/WheelY-'
    'Down = SDL-0/DPadDown'
    'Down = Keyboard/H'
    'Left = SDL-0/DPadLeft'
    'Left = Keyboard/1'
    'Left = Pointer-0/WheelY+'

    # cara
    'Triangle = SDL-0/FaceNorth'
    'Triangle = Keyboard/Z'
    'Circle = SDL-0/FaceEast'
    'Circle = Keyboard/F'
    'Cross = SDL-0/FaceSouth'
    'Cross = Keyboard/R'
    'Square = SDL-0/FaceWest'
    'Square = Keyboard/E'

    'Select = SDL-0/Back'
    'Select = Keyboard/Backspace'
    'Start = SDL-0/Start'
    'Start = Keyboard/Return'

    # gatillos
    'L1 = SDL-0/LeftShoulder'
    'L1 = Pointer-0/Button1'
    'L2 = SDL-0/+LeftTrigger'
    'L2 = Keyboard/Shift'
    'R1 = SDL-0/RightShoulder'
    'R1 = Pointer-0/Button0'
    'R2 = SDL-0/+RightTrigger'
    'R2 = Keyboard/Q'
    'L3 = SDL-0/LeftStick'
    'L3 = Keyboard/Control'
    'R3 = SDL-0/RightStick'
    'R3 = Keyboard/C'

    # stick izquierdo: moverse
    'LUp = SDL-0/-LeftY'
    'LUp = Keyboard/W'
    'LRight = SDL-0/+LeftX'
    'LRight = Keyboard/D'
    'LDown = SDL-0/+LeftY'
    'LDown = Keyboard/S'
    'LLeft = SDL-0/-LeftX'
    'LLeft = Keyboard/A'

    # stick derecho: mirar (mouse + flechas)
    'RUp = SDL-0/-RightY'
    'RUp = Pointer-0/Y-'
    'RUp = Keyboard/Up'
    'RRight = SDL-0/+RightX'
    'RRight = Pointer-0/X+'
    'RRight = Keyboard/Right'
    'RDown = SDL-0/+RightY'
    'RDown = Pointer-0/Y+'
    'RDown = Keyboard/Down'
    'RLeft = SDL-0/-RightX'
    'RLeft = Pointer-0/X-'
    'RLeft = Keyboard/Left'

    'Analog = SDL-0/Guide'
    'LargeMotor = SDL-0/LargeMotor'
    'SmallMotor = SDL-0/SmallMotor'
)

# ---------------------------------------------------------------------------

function Reemplazar-Seccion {
    param([string[]]$Lineas, [string]$Nombre, [string[]]$Contenido)
    $salida = New-Object System.Collections.Generic.List[string]
    $i = 0; $encontrada = $false
    while ($i -lt $Lineas.Count) {
        if ($Lineas[$i].Trim() -eq "[$Nombre]") {
            $encontrada = $true
            $salida.Add("[$Nombre]")
            foreach ($c in $Contenido) { $salida.Add($c) }
            $i++
            while ($i -lt $Lineas.Count -and $Lineas[$i] -notmatch '^\[') { $i++ }
            $salida.Add('')
        } else {
            $salida.Add($Lineas[$i]); $i++
        }
    }
    if (-not $encontrada) { throw "No se encontro la seccion [$Nombre] en el ini." }
    return ,$salida.ToArray()
}

if (-not (Test-Path -LiteralPath $ini)) { throw "No existe $ini" }

if ($Restaurar) {
    $bk = Get-ChildItem -LiteralPath (Split-Path $ini) -Filter 'PCSX2.ini.bak-*' |
          Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $bk) { throw 'No hay backup para restaurar.' }
    Copy-Item -LiteralPath $bk.FullName -Destination $ini -Force
    Write-Output "Restaurado desde $($bk.Name)"
    exit 0
}

$actual = Get-Content -LiteralPath $ini
$esperado = Reemplazar-Seccion -Lineas $actual   -Nombre 'Pad'  -Contenido $padGlobal
$esperado = Reemplazar-Seccion -Lineas $esperado -Nombre 'Pad1' -Contenido $pad1

if ($Verificar) {
    $dif = Compare-Object $actual $esperado
    if ($dif) {
        Write-Output "DIFIERE -- el ini no tiene el mapeo del repo ($($dif.Count) lineas de diferencia)."
        Write-Output "Corre el script sin -Verificar para aplicarlo."
        exit 1
    }
    Write-Output 'OK -- el ini coincide con el mapeo del repo.'
    exit 0
}

$corriendo = Get-Process -Name 'pcsx2-qt' -ErrorAction SilentlyContinue
if ($corriendo) {
    Write-Output 'PCSX2 esta ABIERTO. No se toca el ini: al salir lo pisa con lo que tiene en memoria.'
    Write-Output 'Cerra PCSX2 y volve a correr esto.'
    exit 1
}

$bak = "$ini.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
Copy-Item -LiteralPath $ini -Destination $bak
Escribir-Sin-BOM $ini $esperado

Write-Output "Mapeo aplicado.  Backup: $(Split-Path $bak -Leaf)"
$sat = [math]::Round(2000 / $Speed)
Write-Output "  mouse : preset '$Preset'  Speed=$Speed  DeadZone=$DeadZone  Inertia=$Inertia"
Write-Output "          satura a $sat cuentas de mouse por sondeo (~60 sondeos por segundo)."
Write-Output "          Arriba de eso el stick ya esta al maximo y lo demas es deuda."
Write-Output '  teclas: R recarga | Q granada | Z silenciador | X modo de fuego'
Write-Output '          Shift agachado | 1/2 y rueda cambian arma | E agarrar | F melee | H botiquin'
Write-Output ''
Write-Output ''
Write-Output 'Otros presets:  -Preset preciso | rapido | pcsx2      o a mano: -Speed 8 -DeadZone 4 -Inertia 30'
