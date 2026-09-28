# chequeo-completo.ps1 -- TODA la bateria de verificadores del sistema, en un comando.
#
# POR QUE EXISTE
#   Hasta el 2026-08-29 la bateria eran siete scripts sueltos, cada uno
#   nombrado en una linea distinta de CLAUDE.md, y correrlos dependia de que
#   alguien se acordara. Eso no es una regla: es una intencion (la misma
#   razon por la que existe cascada.ps1). Peor todavia, la unica capa que
#   avisaba era el HANDOFF de la sesion anterior -- o sea, el estado del
#   sistema dependia de un texto escrito por otra sesion en vez de medirse.
#
#   Una regla que se incumple no se escribe mas fuerte: se le agrega el flujo
#   de informacion que falta (Meadows). El flujo que faltaba es este comando,
#   y el hook SessionStart que corre su mitad rapida y EMITE EL RESULTADO.
#
# LAS DOS CAPAS, Y POR QUE ESTAN SEPARADAS  (medido el 2026-08-29)
#   medidores    7,0 s   miden el estado. No escriben nada. Corren en CADA
#                        arranque, por el hook: entran en el timeout.
#   saboteadores 96,2 s  rompen cada alarma a proposito y exigen el rojo.
#                        Escriben y restauran archivos reales. NO entran en
#                        un arranque: van por ANTIGUEDAD, y el hook avisa
#                        cuando se pasaron de viejos.
#
#   Los saboteadores son los que hacen que los medidores valgan algo: un
#   chequeo que nunca fallo esta sin verificar. Por eso no alcanza con
#   correr la capa rapida y darse por servido.
#
# USO
#   .\chequeo-completo.ps1                  las dos capas (~103 s)
#   .\chequeo-completo.ps1 -SoloMedidores   la capa rapida (~7 s)
#   .\chequeo-completo.ps1 -Compacto        una linea por chequeo, sin cuerpo
#
# Sale con codigo 1 si algo esta en rojo.
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [switch]$SoloMedidores,
    [switch]$SoloSaboteadores,
    [switch]$Compacto,
    [int]$DiasSaboteadores = 7,
    # > 0: los medidores corren EN PARALELO y a los N segundos se entrega lo
    # que termino y se NOMBRA lo que no. Lo usa el hook de arranque (T1 de
    # arquitectura-se): en serie tardaban ~58 s contra un timeout de 60 y el
    # harness se corto en 13 de 30 sesiones -- y un hook cortado no entrega
    # NADA, ni lo que ya habia medido.
    [int]$FechaLimite = 0
)

$ErrorActionPreference = 'Stop'
$raiz  = $PSScriptRoot
$sello = Join-Path $raiz '.claude\ultimo-chequeo.json'

$medidores = @(
    @{ nombre = 'estructura del repo';      cmd = '.\verificar-estructura.ps1' }
    @{ nombre = 'perfil global instalado';  cmd = '.\perfil-global\verify-install.ps1' }
    @{ nombre = 'triage de lecciones';      cmd = 'python perfil-global\herramientas\aprender.py sin-triage' }
    # Bimodal, medido el 2026-09-28: 10-11 s o 45-46 s, corriendo SOLO. Con
    # -FechaLimite 40 el modo lento sale "SIN MEDIR", que es lo que tiene que
    # decir. (La sonda S3 de T1 lo atribuyo a correr junto al de abajo; corrido
    # solo tambien tarda 45: la causa es otra y no esta medida.)
    @{ nombre = 'apuntes publicados en Drive'; cmd = '.\publicar-apuntes.ps1 -Verificar' }
    # El de arriba mide si lo que esta en el REPO llego a Drive. Este mide lo
    # de al lado y no se solapa: si algo en Drive quedo PUBLICO POR LINK donde
    # no corresponde. Un verificador solo ve donde vive -- el publicador mira
    # el repo, asi que no podia ver los dos informes del grupo que estuvieron
    # publicos 25 dias sin estar declarados en ningun lado. 5 s.
    @{ nombre = 'estructura y permisos de Drive'; cmd = '.\verificar-drive.ps1' }
    # Con una sola maquina este medidor no tenia sentido: no habia otra copia
    # que pudiera estar mas adelante. Con dos, abrir una sesion sobre un arbol
    # atrasado es la falla nueva, y es de las que no duelen el mismo dia.
    @{ nombre = 'sincronia con origin';     cmd = '.\verificar-sincronia.ps1' }
    # La senal de desuso (criterio C6 del trade study de arquitectura-se).
    # Una matriz de cumplimiento se deja de usar por el camino comodo: marcar
    # 'recortado' y dejar la justificacion vacia. Nadie miente, nadie discute,
    # y la disciplina se evapora sin dejar rastro, porque ahi el silencio es el
    # DEFAULT. Va en la capa rapida a proposito: es de las que no duelen el
    # mismo dia.
    @{ nombre = 'restas de las matrices';   cmd = 'python perfil-global\herramientas\medir-matriz.py' }
    # Pieza P4: un criterio de salida sin su medidor es una intencion, y el
    # medidor escrito DESPUES se elige sabiendo que resultado se quiere.
    @{ nombre = 'certificacion de las fases'; cmd = 'python perfil-global\herramientas\medir-fase.py' }
    # T1 de arquitectura-se: el harness corta cada hook a 10 000 caracteres y
    # la sesion ve 2 000; un hook que pasa su timeout no entrega nada. Mide lo
    # emitido (corriendo los hooks) y lo que el harness hizo (transcripts).
    # ~3,5 s. No se mide a si mismo en bucle: ver MEDIR_INYECCION en el script.
    @{ nombre = 'presupuesto de inyeccion';  cmd = 'python perfil-global\herramientas\medir-inyeccion.py' }
)

$saboteadores = @(
    @{ nombre = 'saboteador de la estructura';   cmd = '.\probar-verificador.ps1' }
    @{ nombre = 'saboteador de los frenos';      cmd = '.\probar-hooks.ps1' }
    @{ nombre = 'saboteador del guardia fanout'; cmd = '.\perfil-global\probar-guardia-fanout.ps1' }
    @{ nombre = 'saboteador del triage';         cmd = '.\perfil-global\probar-chequeo-lecciones.ps1' }
    @{ nombre = 'saboteador del ASCII puro';    cmd = '.\perfil-global\probar-chequeo-ascii.ps1' }
    @{ nombre = 'saboteador del desuso';      cmd = '.\perfil-global\probar-medidor-matriz.ps1' }
    @{ nombre = 'saboteador del molde de fase'; cmd = '.\perfil-global\probar-medidor-fase.ps1' }
    @{ nombre = 'saboteador del heredoc';    cmd = '.\perfil-global\probar-guardia-heredoc.ps1' }
    @{ nombre = 'saboteador de la inyeccion'; cmd = '.\perfil-global\probar-medir-inyeccion.ps1' }
    @{ nombre = 'saboteador del publicador';      cmd = '.\probar-publicacion.ps1' }
    @{ nombre = 'saboteador de Drive';            cmd = '.\probar-verificar-drive.ps1' }
    @{ nombre = 'saboteador de la sincronia';     cmd = '.\probar-sincronia.ps1' }
    @{ nombre = 'saboteador de la cascada';       cmd = '.\probar-cascada.ps1' }
)

function Correr($lista, $titulo) {
    if (-not $Compacto) { Write-Host ""; Write-Host $titulo }
    $rojos = 0
    foreach ($c in $lista) {
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $salida = & powershell -NoProfile -ExecutionPolicy Bypass -Command `
                    "Set-Location '$raiz'; $($c.cmd); exit `$LASTEXITCODE" 2>&1 | Out-String
        $code = $LASTEXITCODE
        $sw.Stop()

        # El codigo de salida es la senal; la salida de texto es el detalle.
        # No se lee el texto para decidir: eso ata el chequeo a la redaccion
        # de cada script y se rompe cuando alguien cambia una palabra.
        if ($code -eq 0) {
            Write-Host ("  [OK  ] {0,-32} {1,5:N1} s" -f $c.nombre, $sw.Elapsed.TotalSeconds) -ForegroundColor Green
        } else {
            Write-Host ("  [FAIL] {0,-32} {1,5:N1} s   exit={2}" -f $c.nombre, $sw.Elapsed.TotalSeconds, $code) -ForegroundColor Red
            Write-Host ("         {0}" -f $c.cmd) -ForegroundColor Red
            if (-not $Compacto) {
                foreach ($l in ($salida -split "`r?`n" | Where-Object { $_ -match '\[FAIL\]|FALLIDA|FALLA|FALLO|CIEGO|RUIDO|ALARMA|no discrimin' })) {
                    Write-Host ("         {0}" -f $l.Trim()) -ForegroundColor Red
                }
            }
            $rojos++
        }
    }
    return $rojos
}

# La misma bateria, en paralelo y con fecha limite. Lo que termino se informa
# igual que en Correr; lo que no, se NOMBRA ("sin medir"), que es distinto de
# verde y distinto de rojo: no se sabe. Un arranque que se corta entero por
# timeout no dice ni eso.
function CorrerConFecha($lista, $titulo, [int]$segundos) {
    if (-not $Compacto) { Write-Host ""; Write-Host $titulo }
    $dir = Join-Path $env:TEMP ('chequeo-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $res   = @{}
    $vivos = @{}
    $reloj = [Diagnostics.Stopwatch]::StartNew()

    function Lanzar($i) {
        $script = "Set-Location '$raiz'; $($lista[$i].cmd); exit `$LASTEXITCODE"
        $enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($script))
        $out = Join-Path $dir "$i.out"
        $p = Start-Process powershell -NoNewWindow -PassThru `
                -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $enc" `
                -RedirectStandardOutput $out -RedirectStandardError "$out.err"
        $null = $p.Handle   # sin esto, ExitCode sale vacio en PS 5.1
        $vivos[$i] = @{ p = $p; i = $i; sw = [Diagnostics.Stopwatch]::StartNew(); out = $out }
    }

    try {
        for ($i = 0; $i -lt $lista.Count; $i++) { Lanzar $i }
        while ($vivos.Count -gt 0) {
            foreach ($k in @($vivos.Keys)) {
                $v = $vivos[$k]
                if (-not $v.p.HasExited) { continue }
                $v.p.WaitForExit()
                $res[$v.i] = @{ estado = 'fin'; seg = $v.sw.Elapsed.TotalSeconds; code = $v.p.ExitCode; out = $v.out }
                $vivos.Remove($k)
            }
            if ($reloj.Elapsed.TotalSeconds -ge $segundos) {
                foreach ($k in @($vivos.Keys)) {
                    $v = $vivos[$k]
                    # /T: matar powershell no mata a sus hijos (rclone, git, python)
                    # Y taskkill escribe a stderr por cada hijo que ya habia
                    # muerto: con EAP=Stop eso tiraba el chequeo entero, que
                    # es justo lo que la fecha limite existe para evitar.
                    Start-Process taskkill -ArgumentList "/T /F /PID $($v.p.Id)" -NoNewWindow -Wait `
                        -RedirectStandardOutput (Join-Path $dir 'tk.out') -RedirectStandardError (Join-Path $dir 'tk.err')
                    $res[$v.i] = @{ estado = 'corte'; seg = $v.sw.Elapsed.TotalSeconds }
                }
                $vivos.Clear()
                break
            }
            Start-Sleep -Milliseconds 200
        }

        $rojos = 0; $sinMedir = 0
        for ($i = 0; $i -lt $lista.Count; $i++) {
            $c = $lista[$i]; $r = $res[$i]
            if (-not $r) {
                Write-Host ("  [----] {0,-32}   SIN MEDIR: no llego a arrancar antes de los {1} s" -f $c.nombre, $segundos) -ForegroundColor Yellow
                $sinMedir++
            } elseif ($r.estado -eq 'corte') {
                Write-Host ("  [----] {0,-32} {1,5:N1} s   SIN MEDIR: cortado a los {2} s" -f $c.nombre, $r.seg, $segundos) -ForegroundColor Yellow
                $sinMedir++
            } elseif ($r.code -eq 0) {
                Write-Host ("  [OK  ] {0,-32} {1,5:N1} s" -f $c.nombre, $r.seg) -ForegroundColor Green
            } else {
                Write-Host ("  [FAIL] {0,-32} {1,5:N1} s   exit={2}" -f $c.nombre, $r.seg, $r.code) -ForegroundColor Red
                Write-Host ("         {0}" -f $c.cmd) -ForegroundColor Red
                if (-not $Compacto -and (Test-Path -LiteralPath $r.out)) {
                    foreach ($l in (Get-Content -LiteralPath $r.out | Where-Object { $_ -match '\[FAIL\]|FALLIDA|FALLA|FALLO|CIEGO|RUIDO|ALARMA|no discrimin' })) {
                        Write-Host ("         {0}" -f $l.Trim()) -ForegroundColor Red
                    }
                }
                $rojos++
            }
        }
        if ($sinMedir -gt 0) {
            Write-Host ("  {0} medidor(es) SIN MEDIR en este arranque: no es verde. A mano:  .\chequeo-completo.ps1 -SoloMedidores" -f $sinMedir) -ForegroundColor Yellow
        }
        return @{ rojos = $rojos; sinMedir = $sinMedir }
    } finally {
        Remove-Item -LiteralPath $dir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function LeerSello {
    if (-not (Test-Path -LiteralPath $sello)) { return $null }
    try { return (Get-Content -LiteralPath $sello -Raw -Encoding UTF8 | ConvertFrom-Json) }
    catch { return $null }   # sello ilegible se trata como ausente: falla CERRADO
}

function EscribirSello($capa, $verde) {
    $s = LeerSello
    $o = [ordered]@{}
    if ($s) { foreach ($p in $s.PSObject.Properties) { $o[$p.Name] = $p.Value } }
    $o[$capa] = [ordered]@{ fecha = (Get-Date -Format 'yyyy-MM-dd'); verde = [bool]$verde }
    $o | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $sello -Encoding UTF8
}

# Antiguedad de la capa lenta. Un sello ausente o ilegible cuenta como
# "nunca se corrio": se avisa, no se calla.
function EstadoSaboteadores {
    $s = LeerSello
    if (-not $s -or -not $s.saboteadores) {
        return @{ texto = 'NUNCA se corrieron (o el sello no se puede leer)'; viejo = $true }
    }
    $d = (New-TimeSpan -Start ([datetime]$s.saboteadores.fecha) -End (Get-Date)).Days
    if (-not $s.saboteadores.verde) {
        return @{ texto = ("la ultima corrida ({0}, hace {1} dia(s)) quedo EN ROJO" -f $s.saboteadores.fecha, $d); viejo = $true }
    }
    if ($d -gt $DiasSaboteadores) {
        return @{ texto = ("corridos hace {0} dia(s) -- pasaron los {1} de tolerancia" -f $d, $DiasSaboteadores); viejo = $true }
    }
    return @{ texto = ("corridos hace {0} dia(s), en verde -- al dia" -f $d); viejo = $false }
}

# ---------------------------------------------------------------------------

if (-not $Compacto) {
    Write-Host "=== chequeo completo del sistema ==="
    Write-Host "  Raiz: $raiz"
}

$rojos = 0

if (-not $SoloSaboteadores) {
    $titulo = "MEDIDORES -- que mide el estado (rapido, no escribe nada)"
    if ($FechaLimite -gt 0) {
        $rf = CorrerConFecha $medidores $titulo $FechaLimite
        $rojos += $rf.rojos
        EscribirSello 'medidores' ($rf.rojos -eq 0 -and $rf.sinMedir -eq 0)
    } else {
        $r = Correr $medidores $titulo
        $rojos += $r
        EscribirSello 'medidores' ($r -eq 0)
    }
}

if (-not $SoloMedidores) {
    $r = Correr $saboteadores "SABOTEADORES -- rompen cada alarma y exigen el rojo (lento, escribe y restaura)"
    $rojos += $r
    EscribirSello 'saboteadores' ($r -eq 0)

    # Los medidores otra vez, DESPUES de sabotear. Un saboteador que restaura
    # el archivo fuente pero deja sucio el efecto (la copia instalada, un
    # atributo, un settings.json) da verde en su propio control positivo y
    # ensucia la maquina en silencio. Eso paso de verdad el 2026-08-29:
    # probar-chequeo-lecciones dejaba "las 76 lecciones" en ~/.claude.
    # Con este segundo pase la clase entera de suciedad se ve, no solo la
    # que ya conocemos.
    # Sin guardia por -SoloSaboteadores: esa es JUSTO la corrida en la que
    # mas importa mirar si la maquina quedo limpia.
    if ($true) {
        $r2 = Correr $medidores "LIMPIEZA -- los mismos medidores, ya saboteado y restaurado"
        if ($r2 -gt 0) {
            Write-Host "  >>> Un saboteador restauro la FUENTE y no el EFECTO: la maquina quedo sucia." -ForegroundColor Red
        }
        $rojos += $r2
        EscribirSello 'medidores' ($r2 -eq 0)
    }
} else {
    $e = EstadoSaboteadores
    $color = if ($e.viejo) { 'Yellow' } else { 'DarkGray' }
    Write-Host ("  saboteadores: {0}" -f $e.texto) -ForegroundColor $color
    if ($e.viejo) {
        Write-Host "                los medidores no valen si nadie probo que discriminan:" -ForegroundColor Yellow
        Write-Host "                .\chequeo-completo.ps1 -SoloSaboteadores   (~96 s)" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($rojos -gt 0) {
    Write-Host "CHEQUEO CON $rojos ROJO(S). Corregir antes de seguir con la tarea." -ForegroundColor Red
    exit 1
}
Write-Host "Chequeo OK. Ningun rojo." -ForegroundColor Green
exit 0
