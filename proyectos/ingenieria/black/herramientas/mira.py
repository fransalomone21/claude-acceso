#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mira.py -- mide la funcion de transferencia REAL del mouse a la mira de BLACK.

POR QUE EXISTE
    Elegir Speed/DeadZone/Inertia por formula ya fallo una vez y de la peor
    manera: la sesion 55 dedujo correctamente la formula de PCSX2, entrego
    media receta (Inertia=100 sin ajustar Speed) y produjo el sintoma OPUESTO
    al que venia a arreglar. La formula del emulador es solo la mitad de la
    cadena; la otra mitad es el juego, y el juego no publica sus constantes.

    Este modulo cierra el lazo: inyecta un movimiento de mouse MEDIDO y lee
    cuantos GRADOS giro la camara. Con eso los tres knobs dejan de elegirse
    por argumento y pasan a elegirse por medicion.

LAS DOS PUNTAS, Y COMO SE MIDIERON
    entrada : pcsx2_mouse.ps1 (SendInput relativo, foco verificado por efecto)
    salida  : 0x005A8DA0 = YAW de la camara EN GRADOS.

    Como se ubico el yaw (2026-09-05): diferencial con CONTROL DE RUIDO sobre
    0x00500000-0x00680000 -- foto, 1.5 s sin tocar nada, foto (eso da el
    conjunto de palabras que cambian SOLAS: 4757), despues foto, inyeccion de
    +2000 cuentas, foto. Candidato = cambia con input y NO cambia solo. El
    segundo control fue inyectar -2000 y exigir que el valor VUELVA.

    Confirmado por una via independiente que no se buscaba: en 0x005A8B20 y
    0x005A8B28 hay un par (0.69411, -0.71987) cuyo atan2 da -46.05 grados,
    exactamente el valor de 0x005A8DA0 (46.04337). Son el coseno y el seno del
    mismo angulo, y siguen coincidiendo despues de girar (0.79635/-0.60484 ->
    -37.22, contra 37.21717). El escalar y su par vectorial se confirman entre
    si.

    0x005A8DA0 esta a -8 de la vida del jugador (0x005A8DA8), o sea DENTRO de
    la estructura del jugador cuya base 0x005A8AB0 ya estaba confirmada.

USO
    python herramientas/mira.py yaw                 # lee el angulo actual
    python herramientas/mira.py mover 2000          # inyecta y reporta el giro
    python herramientas/mira.py curva               # barrido de cuentas/sondeo
    python herramientas/mira.py sens 350            # velocidad de giro EN VIVO
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from pine import Pine  # noqa: E402

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INYECTOR = os.path.join(RAIZ, "herramientas", "pcsx2_mouse.ps1")

YAW = 0x005A8DA0        # grados, float. Ver cabecera.
CTRL = 0x005A8FA0       # objeto de controles = jugador(0x005A8AB0) + 0x4F0
GIRO_X = CTRL + 0xA8    # 0x005A9048  velocidad de giro horizontal, grados/seg
GIRO_Y = CTRL + 0xAC    # 0x005A904C  velocidad de giro vertical
POWER = CTRL + 0xB8     # 0x005A9058  Analogue Control Power (exponente)
CATCHUP = CTRL + 0xBC   # 0x005A905C  Percentage Catch Up (suavizado)
VIDA = 0x005A8DA8       # para abortar si al jugador lo estan matando
COS_YAW = 0x005A8B20
SIN_YAW = 0x005A8B28


def leer_yaw(p: Pine) -> float:
    return p.leer_f32(YAW)


def delta_angular(antes: float, despues: float) -> float:
    """Diferencia de angulos en grados, resolviendo el salto de +-180."""
    d = despues - antes
    while d > 180.0:
        d -= 360.0
    while d < -180.0:
        d += 360.0
    return d


def inyectar(dx: int = 0, dy: int = 0, paso: int = 40, pausa_ms: int = 16) -> None:
    r = subprocess.run(
        ["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", INYECTOR,
         "-DX", str(dx), "-DY", str(dy), "-Paso", str(paso), "-PausaMs", str(pausa_ms)],
        capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"inyector fallo: {r.stderr.strip() or r.stdout.strip()}")


def medir(p: Pine, dx: int, paso: int, pausa_ms: int, reposo: float = 0.6):
    """Inyecta y devuelve (grados_girados, sondeos_estimados)."""
    a = leer_yaw(p)
    inyectar(dx=dx, paso=paso, pausa_ms=pausa_ms)
    time.sleep(reposo)          # deja drenar la deuda de inercia
    b = leer_yaw(p)
    pasos = (abs(dx) + paso - 1) // paso
    return delta_angular(a, b), pasos


def cmd_sens(args):
    """Cambia la velocidad de giro EN VIVO, sin reiniciar ni recompilar nada.

    Es la perilla real de sensibilidad de BLACK: el juego no la expone en
    ningun menu (no hay ninguna cadena 'sensitivity' en el ELF) y ningun
    ajuste de PCSX2 la toca, porque el emulador entrega un eje de 0 a 1 y los
    grados por segundo los pone el juego.
    """
    y = args.y if args.y is not None else args.x
    with Pine() as p:
        ax, ay = p.leer_f32(GIRO_X), p.leer_f32(GIRO_Y)
        p.escribir_f32(GIRO_X, float(args.x))
        p.escribir_f32(GIRO_Y, float(y))
        print(f"  horizontal  {ax:7.1f} -> {p.leer_f32(GIRO_X):7.1f} grados/seg")
        print(f"  vertical    {ay:7.1f} -> {p.leer_f32(GIRO_Y):7.1f} grados/seg")
        print()
        print("  Se pierde al reiniciar el emulador. Cuando encuentres el numero,")
        print("  escribilo en mods/mira-sensibilidad.toml y recompila el pnach.")


def cmd_yaw(args):
    with Pine() as p:
        import math
        c, s = p.leer_f32(COS_YAW), p.leer_f32(SIN_YAW)
        print(f"yaw           {leer_yaw(p):9.4f} grados")
        print(f"atan2(sin,cos){math.degrees(math.atan2(s, c)):9.4f}  (control cruzado)")
        print(f"vida          {p.leer_f32(VIDA):9.2f}")


def cmd_mover(args):
    with Pine() as p:
        d, n = medir(p, args.dx, args.paso, args.pausa)
        print(f"DX={args.dx} en pasos de {args.paso}  ->  {d:+.3f} grados "
              f"({d / abs(args.dx) * 1000:+.3f} grados por cada 1000 cuentas)")


def cmd_curva(args):
    """Barrido del tamano de paso = cuentas de mouse por sondeo.

    El total de cuentas se mantiene FIJO. Si la cadena fuera lineal y sin
    recortes, el giro total no dependeria del tamano del paso. Toda desviacion
    es la no-linealidad que se viene a medir: zona muerta abajo, saturacion
    arriba.
    """
    total = args.total
    print(f"total fijo = {total} cuentas por prueba; se varia cuentas/sondeo")
    print()
    print("  cuentas/    stick     grados     grados/     ida y vuelta")
    print("   sondeo    teorico    girados   1000 cuentas   (deberia dar ~0)")
    with Pine() as p:
        vida0 = p.leer_f32(VIDA)
        for paso in args.pasos:
            if p.leer_f32(VIDA) < vida0 * 0.5:
                print("  ABORTADO: la vida del jugador bajo a la mitad.")
                break
            ida, _ = medir(p, total, paso, args.pausa)
            vuelta, _ = medir(p, -total, paso, args.pausa)
            stick = min(1.0, paso * 0.0005 * args.speed)
            gpk = ida / total * 1000
            print(f"   {paso:6d}   {stick:7.3f}   {ida:+8.3f}   {gpk:+9.3f}"
                  f"      {ida + vuelta:+8.3f}")


def main():
    ap = argparse.ArgumentParser(description="Mide la respuesta de la mira de BLACK")
    sub = ap.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("yaw", help="lee el angulo actual y su control cruzado")
    a.set_defaults(f=cmd_yaw)

    b = sub.add_parser("mover", help="inyecta un movimiento y reporta el giro")
    b.add_argument("dx", type=int)
    b.add_argument("--paso", type=int, default=40)
    b.add_argument("--pausa", type=int, default=16)
    b.set_defaults(f=cmd_mover)

    d = sub.add_parser("sens", help="cambia la velocidad de giro EN VIVO")
    d.add_argument("x", type=float, help="grados/segundo horizontales (de fabrica 70)")
    d.add_argument("--y", type=float, default=None,
                   help="grados/segundo verticales (de fabrica 25). Por defecto, igual que x")
    d.set_defaults(f=cmd_sens)

    c = sub.add_parser("curva", help="barrido de cuentas por sondeo")
    c.add_argument("--total", type=int, default=2400)
    c.add_argument("--pasos", type=int, nargs="+",
                   default=[2, 5, 10, 20, 40, 80, 160, 400])
    c.add_argument("--pausa", type=int, default=16)
    c.add_argument("--speed", type=float, default=5.0,
                   help="PointerXSpeed del ini, solo para la columna teorica")
    c.set_defaults(f=cmd_curva)

    args = ap.parse_args()
    args.f(args)


if __name__ == "__main__":
    main()
