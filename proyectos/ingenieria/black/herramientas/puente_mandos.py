"""El puente de mandos: dos copias del coop en la misma PC, cada una con SU mando (sesion 133).

Por que existe: con dos copias de black-seamless-coop en una PC, la que no tiene el foco no lee ningun mando
(`patches/upstream.patch`, CoopBackground). Con `--coop-control <puerto>` la copia toma su mando del canal de control
(UDP en 127.0.0.1) este adelante o no (`coop_control.cpp`, Override). Este puente lee los mandos fisicos con SDL
(pygame) y le manda a cada copia el suyo:

    mando 1 (el primero que ve SDL) -> 127.0.0.1:45501 (copia --instance 1)
    mando 2                         -> 127.0.0.1:45502 (copia --instance 2)

Formato del canal (coop_control.cpp, Run): `pad a,rt,up 60` (botones que vencen a los 60 ms), `stick lx ly rx ry 60`
(-1..1, y para arriba positivo), `state`. Los gatillos y A/B/X/Y/hombros pasan como todo-o-nada (el canal los pone en
0xFF): un gatillo cuenta apretado desde el UMBRAL_GATILLO.

Perfiles (sesion 133, pedido de Fran: "los controles iguales a los que usaba"): `ps2` (por defecto) es el de BLACK de
PS2 que Fran jugaba en PCSX2 (docs/10-jugar.md): R1 dispara, L1 apunta, R2 granada, L2 agacharse; el resto en el mismo
lugar. El juego de Xbox espera RT dispara, RS (click) apunta, LT granada, LS (click) agacharse (el mapa por defecto del
port: BLACK-XBERecomp src/common/mouse_keyboard.cpp, kActions), asi que el perfil los traduce. `--xbox` deja el de Xbox.
L3 y R3 siguen pasando tal cual: L3+R3 mantenidos es el "llevame con mi companero" del coop.

    python herramientas/puente_mandos.py                 # corre el puente hasta Ctrl+C (o hasta que cierren las copias)
    python herramientas/puente_mandos.py --xbox          # el mapa de Xbox, sin traducir
    python herramientas/puente_mandos.py --cruzar        # control: mando 1 -> copia 2 y mando 2 -> copia 1
    python herramientas/puente_mandos.py --listar        # que mandos ve SDL, y sus valores en vivo 5 s (sin mandar nada)
    python herramientas/puente_mandos.py --estado        # pregunta `state` a las dos copias (el testigo)
    python herramientas/puente_mandos.py --autotest      # el mapeo y el envio por UDP real, sin el juego

Registro: volcados/puente/<fecha-hora>.log (cuantos paquetes por copia, y un renglon por segundo con lo que lleva
cada mando). Salida: 0 = bien, 1 = rojo, 2 = ENTORNO (falta pygame).
"""
from __future__ import annotations

import argparse
import os
import socket
import sys
import time
from pathlib import Path

PUERTOS = (45501, 45502)
HZ = 120
VENCE_MS = 60  # mas que dos ticks: un paquete perdido no suelta el boton
UMBRAL_GATILLO = 0.3
ZONA_MUERTA = 0.0  # la pone el juego; aca no se recorta nada
RAIZ = Path(__file__).resolve().parent.parent

# SDL GameController -> nombre del canal. A B X Y son analog[0..3]; RB es "black" y LB "white" (input.cpp, kAnalog)
BOTONES = (
    ("A", "a"), ("B", "b"), ("X", "x"), ("Y", "y"),
    ("RIGHTSHOULDER", "black"), ("LEFTSHOULDER", "white"),
    ("DPAD_UP", "up"), ("DPAD_DOWN", "down"), ("DPAD_LEFT", "left"), ("DPAD_RIGHT", "right"),
    ("START", "start"), ("BACK", "back"), ("LEFTSTICK", "ls"), ("RIGHTSTICK", "rs"),
)


# boton fisico de SDL (o gatillo) -> nombre del canal, por perfil. Los gatillos van como "TRIGGERLEFT"/"TRIGGERRIGHT".
PERFILES = {
    "xbox": {**{sdl: canal for sdl, canal in BOTONES}, "TRIGGERLEFT": "lt", "TRIGGERRIGHT": "rt"},
    "ps2": {**{sdl: canal for sdl, canal in BOTONES},
            "RIGHTSHOULDER": "rt",   # R1 dispara
            "LEFTSHOULDER": "rs",    # L1 apunta
            "TRIGGERRIGHT": "lt",    # R2 granada
            "TRIGGERLEFT": "ls"},    # L2 agacharse
}


def comandos(botones: dict[str, bool], ejes: dict[str, float], perfil: str = "ps2") -> list[str]:
    """Lo que se le manda a una copia en un tick, desde el estado crudo de SDL (ejes en -1..1, gatillos en 0..1).

    SDL tiene la Y de los sticks para abajo; el canal la quiere para arriba (input.cpp: ly = -1 - eje SDL).
    """
    mapa = PERFILES[perfil]
    apretados = [sdl for sdl, _ in BOTONES if botones.get(sdl)]
    apretados += [g for g in ("TRIGGERLEFT", "TRIGGERRIGHT") if ejes.get(g, 0.0) >= UMBRAL_GATILLO]
    nombres = []
    for sdl in apretados:
        if mapa[sdl] not in nombres:  # L1 y R3 dan los dos "rs": va una vez
            nombres.append(mapa[sdl])
    salida = []
    if nombres:
        salida.append(f"pad {','.join(nombres)} {VENCE_MS}")
    lx, ly = ejes.get("LEFTX", 0.0), -ejes.get("LEFTY", 0.0)
    rx, ry = ejes.get("RIGHTX", 0.0), -ejes.get("RIGHTY", 0.0)
    salida.append(f"stick {lx:.4f} {ly:.4f} {rx:.4f} {ry:.4f} {VENCE_MS}")
    return salida


def abrir_sdl():
    os.environ.setdefault("SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS", "1")
    os.environ.setdefault("PYGAME_HIDE_SUPPORT_PROMPT", "1")
    try:
        import pygame
        from pygame._sdl2 import controller
    except ImportError:
        print("ENTORNO: falta pygame (python -m pip install pygame)")
        raise SystemExit(2)
    pygame.display.init()  # el bombeo de eventos de SDL lo pide; no abre ventana
    pygame.joystick.init()
    controller.init()
    return pygame, controller


def mandos(pygame, controller) -> list:
    pygame.event.pump()
    return [controller.Controller(i) for i in range(controller.get_count()) if controller.is_controller(i)]


def leer(pygame, c) -> tuple[dict[str, bool], dict[str, float]]:
    botones = {sdl: bool(c.get_button(getattr(pygame, f"CONTROLLER_BUTTON_{sdl}"))) for sdl, _ in BOTONES}
    ejes = {}
    for nombre in ("LEFTX", "LEFTY", "RIGHTX", "RIGHTY", "TRIGGERLEFT", "TRIGGERRIGHT"):
        v = c.get_axis(getattr(pygame, f"CONTROLLER_AXIS_{nombre}")) / 32767.0
        ejes[nombre] = max(-1.0, min(1.0, v))
    return botones, ejes


def preguntar(puerto: int, texto: str, espera: float = 0.5) -> str | None:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(espera)
    try:
        s.sendto(texto.encode(), ("127.0.0.1", puerto))
        return s.recvfrom(65536)[0].decode(errors="replace")
    except OSError:
        return None
    finally:
        s.close()


def correr(cruzar: bool, segundos: float | None, perfil: str = "ps2") -> int:
    pygame, controller = abrir_sdl()
    puertos = PUERTOS[::-1] if cruzar else PUERTOS
    dir_log = RAIZ / "volcados" / "puente"
    dir_log.mkdir(parents=True, exist_ok=True)
    log_path = dir_log / time.strftime("%Y%m%d-%H%M%S.log")
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.setblocking(False)
    lista = mandos(pygame, controller)
    print(f"puente: {len(lista)} mando(s) -> copias en {puertos[:len(lista)]}{' (CRUZADO)' if cruzar else ''}, "
          f"controles {perfil.upper()}")
    for i, c in enumerate(lista[:2]):
        print(f"  mando {i + 1}: {c.as_joystick().get_name()} -> 127.0.0.1:{puertos[i]}")
    if len(lista) < 2:
        print("  AVISO: hace falta un segundo mando encendido; el puente lo toma apenas aparece")
    enviados, ultimo_seg, inicio = [0, 0], 0.0, time.monotonic()
    with open(log_path, "w", encoding="utf-8") as log:
        log.write(f"puente {time.strftime('%Y-%m-%d %H:%M:%S')} cruzar={cruzar} puertos={puertos} perfil={perfil}\n")
        try:
            while segundos is None or time.monotonic() - inicio < segundos:
                t0 = time.monotonic()
                for e in pygame.event.get():
                    if e.type in (pygame.CONTROLLERDEVICEADDED, pygame.CONTROLLERDEVICEREMOVED):
                        lista = mandos(pygame, controller)
                        log.write(f"{t0 - inicio:8.2f} mandos: {len(lista)}\n")
                resumen = []
                for i, c in enumerate(lista[:2]):
                    b, ej = leer(pygame, c)
                    cmds = comandos(b, ej, perfil)
                    for cmd in cmds:
                        try:
                            s.sendto(cmd.encode(), ("127.0.0.1", puertos[i]))
                            enviados[i] += 1
                        except OSError:
                            pass
                    resumen.append(cmds[0])
                try:  # las respuestas del canal se descartan: que no se llene el buffer
                    while True:
                        s.recvfrom(65536)
                except OSError:
                    pass
                if t0 - ultimo_seg >= 1.0:
                    ultimo_seg = t0
                    log.write(f"{t0 - inicio:8.2f} enviados={enviados} " + " | ".join(resumen) + "\n")
                    log.flush()
                time.sleep(max(0.0, 1.0 / HZ - (time.monotonic() - t0)))
        except KeyboardInterrupt:
            pass
    print(f"puente cerrado: paquetes {enviados}; registro {log_path}")
    return 0


def listar() -> int:
    pygame, controller = abrir_sdl()
    lista = mandos(pygame, controller)
    print(f"{len(lista)} mando(s)")
    for i, c in enumerate(lista):
        print(f"  {i + 1}: {c.as_joystick().get_name()}")
    fin = time.monotonic() + 5
    while lista and time.monotonic() < fin:
        pygame.event.pump()
        print("  " + "  ||  ".join(" ".join(comandos(*leer(pygame, c))) for c in lista[:2]))
        time.sleep(0.5)
    return 0 if lista else 1


def estado() -> int:
    rojo = 0
    for p in PUERTOS:
        r = preguntar(p, "state")
        print(f"copia {p}: {r if r is not None else 'SIN RESPUESTA'}")
        rojo |= r is None
    return 1 if rojo else 0


def autotest() -> int:
    fallas = []
    # 1) el mapeo, con un caso de cada cosa
    reposo = comandos({}, {})
    if reposo != [f"stick 0.0000 -0.0000 0.0000 -0.0000 {VENCE_MS}"] and reposo != [f"stick 0.0000 0.0000 0.0000 0.0000 {VENCE_MS}"]:
        fallas.append(f"reposo: {reposo}")
    c = comandos({"A": True, "RIGHTSHOULDER": True, "START": True}, {"TRIGGERRIGHT": 0.9, "TRIGGERLEFT": 0.1, "LEFTY": -1.0}, "xbox")
    if c[0] != f"pad a,black,start,rt {VENCE_MS}":
        fallas.append(f"botones xbox: {c[0]}")
    # el perfil de PS2: R1 dispara (rt), L1 apunta (rs), R2 granada (lt), L2 agacharse (ls); L1 + R3 da "rs" una vez
    p = comandos({"RIGHTSHOULDER": True, "LEFTSHOULDER": True, "RIGHTSTICK": True, "A": True},
                 {"TRIGGERRIGHT": 0.9, "TRIGGERLEFT": 0.9})
    if p[0] != f"pad a,rt,rs,ls,lt {VENCE_MS}":
        fallas.append(f"botones ps2: {p[0]}")
    if not c[1].startswith("stick 0.0000 1.0000"):  # SDL arriba = -1 -> canal arriba = +1
        fallas.append(f"eje Y: {c[1]}")
    # 2) control negativo: el gatillo por debajo del umbral no aprieta
    if any("lt" in x for x in c):
        fallas.append("gatillo izquierdo flojo contado como apretado")
    # 3) la frontera real: dos sockets UDP en puertos de prueba, cada mando a su puerto y no al otro
    rx = []
    for _ in range(2):
        r = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        r.bind(("127.0.0.1", 0))
        r.settimeout(0.5)
        rx.append(r)
    tx = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    for i, r in enumerate(rx):
        tx.sendto(f"pad {'a' if i == 0 else 'b'} {VENCE_MS}".encode(), r.getsockname())
    for i, r in enumerate(rx):
        try:
            got = r.recvfrom(1024)[0].decode()
        except OSError:
            got = None
        esperado = f"pad {'a' if i == 0 else 'b'} {VENCE_MS}"
        if got != esperado:
            fallas.append(f"udp copia {i + 1}: {got!r} en vez de {esperado!r}")
    for r in rx + [tx]:
        r.close()
    for f in fallas:
        print(f"ROJO {f}")
    print("autotest: " + ("TODO BIEN (mapeo, umbral del gatillo, envio UDP a cada puerto)" if not fallas else f"{len(fallas)} rojo(s)"))
    return 1 if fallas else 0


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--cruzar", action="store_true")
    ap.add_argument("--xbox", action="store_true", help="el mapa de botones de Xbox, sin traducir al de PS2")
    ap.add_argument("--listar", action="store_true")
    ap.add_argument("--estado", action="store_true")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--segundos", type=float, default=None)
    a = ap.parse_args(argv)
    if a.autotest:
        return autotest()
    if a.listar:
        return listar()
    if a.estado:
        return estado()
    return correr(a.cruzar, a.segundos, "xbox" if a.xbox else "ps2")


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
