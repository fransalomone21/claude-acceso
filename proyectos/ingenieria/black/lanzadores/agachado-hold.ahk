#Requires AutoHotkey v2.0
#SingleInstance Force
; agachado-hold.ahk -- convierte el agachado de BLACK en "mantener Shift".
;
; POR QUE HACE FALTA UN SCRIPT Y NO ALCANZA UN BINDING DE PCSX2:
; en BLACK el agachado es un TOGGLE del juego: L2 alterna agachado/parado. Un
; binding de emulador solo puede decir "L2 esta apretado"; no puede inventar
; el segundo apreton que hace falta para volver a pararse. Por eso lo unico
; que arregla esto sin tocar el codigo del juego es mandar DOS toques: uno al
; apretar Shift y otro al soltarlo.
;
; La alternativa de verdad -- parchear la rutina del juego para que el
; agachado lea el estado del boton en vez de alternar -- es trabajo de
; reversing, y esta anotado en el proyecto como candidato. Esto anda hoy.
;
; MODO_TOGGLE = false lo desactiva sin desinstalar nada: si algun dia BLACK
; resulta agachar mientras se mantiene (o se parchea para que lo haga), esta
; es la unica linea que hay que tocar.

global MODO_TOGGLE := true

; Shift esta mapeado a L2 en PCSX2 (ver herramientas/configurar-controles.ps1).
; Solo actua con la ventana del emulador al frente: fuera de ahi, Shift es Shift.
#HotIf WinActive("ahk_exe pcsx2-qt.exe") && MODO_TOGGLE

$LShift:: {
    Send "{Blind}{LShift down}"
    Sleep 45
    Send "{Blind}{LShift up}"
}

$LShift up:: {
    Send "{Blind}{LShift down}"
    Sleep 45
    Send "{Blind}{LShift up}"
}

#HotIf
