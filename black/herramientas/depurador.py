#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
depurador.py — cliente del DebugServer de PCSX2. Sólo librería estándar.

Lo que PINE nunca pudo: breakpoints, watchpoints, registros, desensamblado
nativo y stack walk. Requiere el PCSX2 **parcheado** (proyecto PCSX2-MCP),
no el oficial: el oficial no abre el 21512.

PROTOCOLO (verificado contra source/DebugServer.cpp del release v1.0.0)

    JSON delimitado por newline sobre TCP 127.0.0.1:21512.
    Pedido    : {"cmd":"read_memory","cpu":"ee","address":"0x100000"}\\n
    Respuesta : {"ok":true,...}\\n   |   {"ok":false,"error":"..."}\\n

    Las direcciones se mandan como string "0x...": el `getNum` del C++
    (línea 255) acepta número o string hexadecimal. Se usa string porque
    es el camino que ya ejercita el cliente JS del release.

    OJO CON LA FORMA DE LA RESPUESTA — no es uniforme:
      status, read_registers   -> los datos van adentro de "data"
      read_memory, disassemble -> van al nivel de arriba, al lado de "ok"
    Leer el campo del lado equivocado devuelve None en silencio, que es
    la peor clase de bug. Cada método de acá abajo dice de dónde saca lo suyo.

DOS COSAS QUE SON STUBS Y HAY QUE SABER
    1. `OnBreakpointHit()` (DebugServer.cpp:1006) está VACÍO: dice
       "Future: notify connected clients". **No hay aviso asincrónico** de
       que un breakpoint disparó. Por eso `esperar` hace polling de
       `status.paused`, y no se queda escuchando el socket para siempre.
    2. Es el mismo patrón del `MemCheck::Log()` del PCSX2 oficial, que
       también es un stub vacío. No planificar alrededor de "el log".

EL CAMINO NO INTRUSIVO (preferilo)
    `list_memchecks` devuelve `hits`, `last_pc` y `last_addr` por watchpoint.
    Con --accion log el watchpoint **cuenta sin pausar**: se deja corriendo,
    se cosecha `last_pc` y ahí está la instrucción que escribió. Cero riesgo
    de colgar la emulación (issue #5343 de PCSX2) y cero riesgo de perder la
    partida. Ver el subcomando `cosechar`.

USO RÁPIDO
    from depurador import Depurador
    with Depurador() as d:
        print(d.estado())
        d.poner_vigilante(0x005A8DA8, tipo="write", accion="log")
        print(d.listar_vigilantes())

CLI
    python depurador.py estado
    python depurador.py desensamblar 0x00100000 --n 20
    python depurador.py vigilante poner 0x005A8DA8 --accion log
    python depurador.py cosechar --segundos 60
"""

from __future__ import annotations

import argparse
import json
import os
import socket
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from salida import tolerar_salida_pobre  # noqa: E402

PUERTO_POR_DEFECTO = 21512
ANFITRION_POR_DEFECTO = "127.0.0.1"

# Espera de una respuesta. read_registers y disassemble --n 200 son grandes,
# pero el servidor las arma de una; 10 s es holgado y evita colgarse.
TIMEOUT_POR_DEFECTO = 10.0

# Direcciones donde escribir es una mala idea conocida. No es una lista de
# seguridad completa: es la memoria de los accidentes que ya pasaron.
PROHIBIDAS = {
    0x006CF54C: "índice del render del HUD (rango 0..8) — escribirle 999 "
                "crasheó el emulador a pantalla negra",
}


class DepuradorError(Exception):
    """Falla de transporte, de protocolo, o un {"ok":false} del servidor."""


class Depurador:
    """Cliente del DebugServer. Un pedido, una respuesta, en orden."""

    def __init__(self, anfitrion=ANFITRION_POR_DEFECTO, puerto=PUERTO_POR_DEFECTO,
                 timeout=TIMEOUT_POR_DEFECTO, cpu="ee"):
        self.anfitrion = anfitrion
        self.puerto = puerto
        self.timeout = timeout
        self.cpu = cpu
        self._sock = None
        self._buffer = b""

    # --- transporte ----------------------------------------------------------
    def conectar(self) -> "Depurador":
        try:
            self._sock = socket.create_connection(
                (self.anfitrion, self.puerto), timeout=3.0)
            self._sock.settimeout(self.timeout)
            self._sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        except OSError as e:
            raise DepuradorError(
                f"no pude conectarme a {self.anfitrion}:{self.puerto} ({e}).\n"
                "  Revisá:\n"
                "  - ¿está corriendo el pcsx2-qt.exe PARCHEADO (el de "
                "PCSX2-MCP), y no el de Program Files?\n"
                "  - ¿dice '[DebugServer] Listening on 127.0.0.1:21512' en su "
                "consola?\n"
                "  - ¿hay un juego cargado y corriendo?"
            ) from e
        return self

    def cerrar(self) -> None:
        if self._sock is not None:
            try:
                self._sock.close()
            finally:
                self._sock = None

    def __enter__(self):
        return self.conectar()

    def __exit__(self, *_):
        self.cerrar()

    def _pedir(self, cmd: str, **campos) -> dict:
        """Manda un comando y devuelve el objeto JSON de la respuesta.

        El buffer se acumula hasta el \\n: una respuesta puede venir partida
        en varios segmentos TCP, y pueden llegar dos respuestas juntas en uno
        solo. Lo que sobra queda para el próximo `_pedir`.
        """
        if self._sock is None:
            raise DepuradorError("no conectado; llamá a conectar() primero")

        pedido = {"cmd": cmd, "cpu": self.cpu}
        # Un campo en None significa "no lo mandes": el C++ aplica su default.
        pedido.update({k: v for k, v in campos.items() if v is not None})

        try:
            self._sock.sendall((json.dumps(pedido) + "\n").encode("utf-8"))
        except OSError as e:
            raise DepuradorError(f"se cortó al enviar '{cmd}': {e}") from e

        limite = time.monotonic() + self.timeout
        while b"\n" not in self._buffer:
            if time.monotonic() > limite:
                raise DepuradorError(f"venció la espera de la respuesta a '{cmd}'")
            try:
                trozo = self._sock.recv(65536)
            except socket.timeout as e:
                raise DepuradorError(f"venció la espera de la respuesta a '{cmd}'") from e
            except OSError as e:
                raise DepuradorError(f"se cortó al recibir '{cmd}': {e}") from e
            if not trozo:
                raise DepuradorError(
                    f"el servidor cerró la conexión durante '{cmd}'")
            self._buffer += trozo

        linea, self._buffer = self._buffer.split(b"\n", 1)
        try:
            resp = json.loads(linea.decode("utf-8", errors="replace"))
        except json.JSONDecodeError as e:
            raise DepuradorError(f"respuesta no es JSON válido: {linea[:200]!r}") from e

        if not resp.get("ok"):
            raise DepuradorError(
                f"'{cmd}' falló: {resp.get('error', 'sin detalle')}")
        return resp

    # --- estado y ejecución --------------------------------------------------
    def estado(self) -> dict:
        """{'alive','paused','pc','cycles'} — vienen adentro de 'data'."""
        return self._pedir("status")["data"]

    def pausar(self) -> str:
        """Devuelve el PC. Viene al nivel de arriba."""
        return self._pedir("pause")["pc"]

    def continuar(self) -> None:
        self._pedir("resume")

    def paso(self) -> dict:
        """Una instrucción. La respuesta trae new_pc/opcode/disasm arriba."""
        return self._pedir("step")

    def paso_sobre(self) -> dict:
        return self._pedir("step_over")

    def esperar_pausa(self, segundos=60.0, intervalo=0.25) -> dict | None:
        """Bloquea hasta que el emulador se pause, o hasta que venza.

        Polling, no push: `OnBreakpointHit` es un stub vacío (ver encabezado).
        Devuelve el estado si se pausó, None si venció el plazo.
        """
        limite = time.monotonic() + segundos
        while time.monotonic() < limite:
            st = self.estado()
            if st.get("paused"):
                return st
            time.sleep(intervalo)
        return None

    # --- memoria -------------------------------------------------------------
    def leer(self, direccion: int, largo=256) -> bytes:
        """El hex viene al NIVEL DE ARRIBA ('hex'), no adentro de 'data'."""
        r = self._pedir("read_memory", address=_hex(direccion), length=largo)
        return bytes.fromhex(r["hex"])

    def escribir(self, direccion: int, datos: bytes) -> int:
        if direccion in PROHIBIDAS:
            raise DepuradorError(
                f"{_hex(direccion)} está en la lista de prohibidas: "
                f"{PROHIBIDAS[direccion]}")
        r = self._pedir("write_memory", address=_hex(direccion),
                        data=datos.hex())
        return r["written"]

    def cadena(self, direccion: int, maximo=256) -> str:
        return self._pedir("read_string", address=_hex(direccion),
                           max_length=maximo)["string"]

    def direccion_valida(self, direccion: int) -> bool:
        return self._pedir("is_valid_address", address=_hex(direccion))["valid"]

    # --- registros y código --------------------------------------------------
    def registros(self, categoria=None) -> dict:
        """Adentro de 'data'. categoría: 0=GPR 1=CP0 2=FPR 3=FCR 4=VU0F 5=VU0I 6=GSPRIV."""
        return self._pedir("read_registers", category=categoria)["data"]

    def desensamblar(self, direccion: int, cantidad=20, simplificar=True) -> list:
        """'instructions' al nivel de arriba: [{address, opcode, disasm}, ...]."""
        return self._pedir("disassemble", address=_hex(direccion),
                           count=cantidad, simplify=simplificar)["instructions"]

    def evaluar(self, expresion: str) -> dict:
        """'v0 + 0x100', 'gp - 4'. Devuelve la respuesta cruda."""
        return self._pedir("evaluate", expression=expresion)

    def pila(self, maximo=32) -> list:
        return self._pedir("get_backtrace", max_frames=maximo)["frames"]

    def hilos(self) -> list:
        return self._pedir("get_threads")["threads"]

    def modulos(self) -> list:
        d = Depurador(self.anfitrion, self.puerto, self.timeout, cpu="iop")
        d._sock, d._buffer = self._sock, self._buffer
        return d._pedir("get_modules")["modules"]

    # --- breakpoints ---------------------------------------------------------
    def poner_bp(self, direccion: int, condicion=None, descripcion=None,
                 temporal=False) -> None:
        self._pedir("set_breakpoint", address=_hex(direccion),
                    condition=condicion, description=descripcion,
                    temporary=temporal)

    def quitar_bp(self, direccion: int) -> None:
        self._pedir("remove_breakpoint", address=_hex(direccion))

    def listar_bp(self) -> list:
        return self._pedir("list_breakpoints")["breakpoints"]

    def limpiar_bp(self) -> None:
        self._pedir("clear_breakpoints")

    # --- watchpoints (el camino no intrusivo) --------------------------------
    def poner_vigilante(self, direccion: int, fin=None, tipo="write",
                        accion="log", condicion=None, descripcion=None) -> dict:
        """Watchpoint. Por defecto accion='log': cuenta SIN pausar.

        tipo  : write | read | readwrite | onchange
        accion: log | break | both   ('break' pausa la emulación — ojo)
        """
        fin = fin if fin is not None else direccion + 4
        return self._pedir("set_memcheck", address=_hex(direccion),
                           end=_hex(fin), type=tipo, action=accion,
                           condition=condicion, description=descripcion)

    def quitar_vigilante(self, direccion: int, fin=None) -> None:
        fin = fin if fin is not None else direccion + 4
        self._pedir("remove_memcheck", address=_hex(direccion), end=_hex(fin))

    def listar_vigilantes(self) -> list:
        """[{start,end,hits,last_pc,last_addr,description}, ...]"""
        return self._pedir("list_memchecks")["memchecks"]


def _hex(v: int) -> str:
    return f"0x{v:08X}"


# --- formato de salida -------------------------------------------------------
def _volcado_hex(datos: bytes, base: int) -> str:
    lineas = []
    for i in range(0, len(datos), 16):
        trozo = datos[i:i + 16]
        hexa = " ".join(f"{b:02x}" for b in trozo).ljust(47)
        texto = "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in trozo)
        lineas.append(f"{base + i:08x}  {hexa}  |{texto}|")
    return "\n".join(lineas)


def _imprimir_instrucciones(instrs) -> None:
    for i in instrs:
        print(f"{i.get('address','?')}:  {i.get('opcode',''):<12}  {i.get('disasm','')}")


def _imprimir_vigilantes(vs) -> None:
    if not vs:
        print("no hay vigilantes puestos.")
        return
    print(f"{'rango':<24} {'hits':>8}  {'ultimo_pc':<12} {'ultima_dir':<12} descripcion")
    for v in vs:
        rango = f"{v.get('start','?')}-{v.get('end','?')}"
        print(f"{rango:<24} {v.get('hits',0):>8}  "
              f"{v.get('last_pc','-'):<12} {v.get('last_addr','-'):<12} "
              f"{v.get('description','')}")


# --- CLI ---------------------------------------------------------------------
def _entero(texto: str) -> int:
    return int(texto, 0)


def main(argv=None) -> int:
    tolerar_salida_pobre()

    ap = argparse.ArgumentParser(
        description="Cliente del DebugServer de PCSX2 (PCSX2-MCP, puerto 21512)")
    ap.add_argument("--puerto", type=int, default=PUERTO_POR_DEFECTO)
    ap.add_argument("--anfitrion", default=ANFITRION_POR_DEFECTO)
    ap.add_argument("--cpu", default="ee", choices=["ee", "iop"])
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("estado", help="PC, si esta pausado, ciclos")

    p_reg = sub.add_parser("registros", help="lee los registros")
    p_reg.add_argument("--categoria", type=int, default=None,
                       help="0=GPR 1=CP0 2=FPR 3=FCR 4=VU0F 5=VU0I 6=GSPRIV")

    p_des = sub.add_parser("desensamblar", help="desensambla con el motor nativo")
    p_des.add_argument("direccion", type=_entero)
    p_des.add_argument("--n", type=int, default=20)

    p_ev = sub.add_parser("evaluar", help="evalua una expresion MIPS: 'v0 + 0x100'")
    p_ev.add_argument("expresion")

    p_leer = sub.add_parser("leer", help="volcado hexadecimal de un rango")
    p_leer.add_argument("direccion", type=_entero)
    p_leer.add_argument("--bytes", type=int, default=256)

    p_esc = sub.add_parser("escribir", help="ESCRIBE en memoria (peligroso)")
    p_esc.add_argument("direccion", type=_entero)
    p_esc.add_argument("hex", help="bytes en hexadecimal, ej: 0000c842")
    p_esc.add_argument("--si-estoy-seguro", action="store_true",
                       help="obligatorio: sin esto no escribe nada")

    p_cad = sub.add_parser("cadena", help="lee una cadena terminada en cero")
    p_cad.add_argument("direccion", type=_entero)
    p_cad.add_argument("--max", type=int, default=256)

    p_bp = sub.add_parser(
        "bp", help="breakpoints de ejecucion (PELIGROSO: crashean el emulador)")
    sbp = p_bp.add_subparsers(dest="accion", required=True)
    b1 = sbp.add_parser("poner")
    b1.add_argument("direccion", type=_entero)
    b1.add_argument("--condicion", default=None)
    b1.add_argument("--descripcion", default=None)
    b1.add_argument("--se-que-crashea", action="store_true",
                    help="obligatorio: set_breakpoint mato el emulador en la "
                         "prueba del 2026-08-15. Usa 'vigilante' en su lugar.")
    b2 = sbp.add_parser("quitar")
    b2.add_argument("direccion", type=_entero)
    sbp.add_parser("listar")
    sbp.add_parser("limpiar")

    p_vg = sub.add_parser("vigilante", help="watchpoints de memoria")
    svg = p_vg.add_subparsers(dest="accion", required=True)
    v1 = svg.add_parser("poner")
    v1.add_argument("direccion", type=_entero)
    v1.add_argument("--fin", type=_entero, default=None)
    v1.add_argument("--tipo", default="write",
                    choices=["write", "read", "readwrite", "onchange"])
    # dest distinto de 'accion': ese nombre ya lo usa el subparser de arriba.
    v1.add_argument("--accion", dest="modo", default="log",
                    choices=["log", "break", "both"],
                    help="log NO pausa la emulacion (recomendado)")
    v1.add_argument("--condicion", default=None)
    v1.add_argument("--descripcion", default=None)
    v2 = svg.add_parser("quitar")
    v2.add_argument("direccion", type=_entero)
    v2.add_argument("--fin", type=_entero, default=None)
    svg.add_parser("listar")

    p_cos = sub.add_parser(
        "cosechar",
        help="deja correr y reporta que instruccion toco cada vigilante")
    p_cos.add_argument("--segundos", type=float, default=30.0)
    p_cos.add_argument("--intervalo", type=float, default=1.0)

    p_esp = sub.add_parser("esperar", help="bloquea hasta que se pause")
    p_esp.add_argument("--segundos", type=float, default=60.0)
    p_esp.add_argument("--contexto", type=int, default=8,
                       help="instrucciones a desensamblar alrededor del PC")

    sub.add_parser("pausar")
    sub.add_parser("continuar")
    p_paso = sub.add_parser("paso")
    p_paso.add_argument("--n", type=int, default=1)
    sub.add_parser("paso-sobre")
    sub.add_parser("hilos")
    sub.add_parser("modulos")
    p_pila = sub.add_parser("pila", help="stack walk")
    p_pila.add_argument("--max", type=int, default=32)

    args = ap.parse_args(argv)

    # Los chequeos de seguridad van ANTES de conectar: son validación de
    # argumentos, no dependen del emulador, y si el usuario se equivocó
    # conviene decírselo aunque el emulador esté caído.
    if args.cmd == "bp" and args.accion == "poner" and not args.se_que_crashea:
        print(
            "error: los breakpoints de EJECUCION crashean esta build.\n"
            "  Evidencia: 2026-08-15, 'bp poner 0x0013C120' cerro el\n"
            "  pcsx2-qt.exe en el acto (conexion cortada a mitad del comando,\n"
            "  proceso muerto, nada escuchando en 21512).\n"
            "  Los WATCHPOINTS en cambio funcionan bien:\n"
            "    python depurador.py vigilante poner <dir> --tipo write --accion break\n"
            "  Si igual querés intentarlo: --se-que-crashea (con savestate antes).",
            file=sys.stderr)
        return 2

    try:
        with Depurador(args.anfitrion, args.puerto, cpu=args.cpu) as d:
            return _despachar(d, args)
    except DepuradorError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\ninterrumpido", file=sys.stderr)
        return 130


def _despachar(d: Depurador, args) -> int:
    c = args.cmd

    if c == "estado":
        for k, v in d.estado().items():
            print(f"{k:12} {v}")

    elif c == "registros":
        datos = d.registros(args.categoria)
        for nombre, cat in datos.items():
            if not isinstance(cat, dict) or "regs" not in cat:
                continue
            print(f"--- {nombre} ({cat.get('size','?')} bits x {cat.get('count','?')}) ---")
            for r in cat["regs"]:
                print(f"  {r.get('name',''):<10} = {r.get('display','')}")
            print()
        for k in ("pc", "hi", "lo"):
            if k in datos:
                print(f"{k.upper()} = {datos[k]}")

    elif c == "desensamblar":
        _imprimir_instrucciones(d.desensamblar(args.direccion, args.n))

    elif c == "evaluar":
        r = d.evaluar(args.expresion)
        print(f"{args.expresion} = {r.get('hex')} ({r.get('result')})")

    elif c == "leer":
        print(_volcado_hex(d.leer(args.direccion, args.bytes), args.direccion))

    elif c == "escribir":
        if not args.si_estoy_seguro:
            print("error: 'escribir' exige --si-estoy-seguro.\n"
                  "  Guardá un savestate antes. Escribir al azar cuelga el "
                  "emulador y perdés la partida.", file=sys.stderr)
            return 2
        n = d.escribir(args.direccion, bytes.fromhex(args.hex.replace(" ", "")))
        print(f"{n} bytes escritos en {_hex(args.direccion)}")

    elif c == "cadena":
        print(repr(d.cadena(args.direccion, args.max)))

    elif c == "bp":
        if args.accion == "poner":
            # El guard vive en main(), antes de conectar.
            d.poner_bp(args.direccion, args.condicion, args.descripcion)
            print(f"breakpoint en {_hex(args.direccion)}")
        elif args.accion == "quitar":
            d.quitar_bp(args.direccion)
            print("quitado")
        elif args.accion == "listar":
            bps = d.listar_bp()
            if not bps:
                print("no hay breakpoints.")
            for b in bps:
                extra = f" [cond: {b.get('condition')}]" if b.get("has_condition") else ""
                print(f"{b.get('address')} {'on' if b.get('enabled') else 'off'}"
                      f"{extra} {b.get('description','')}")
        elif args.accion == "limpiar":
            d.limpiar_bp()
            print("breakpoints y vigilantes borrados")

    elif c == "vigilante":
        if args.accion == "poner":
            r = d.poner_vigilante(args.direccion, args.fin, args.tipo,
                                  args.modo, args.condicion, args.descripcion)
            print(f"vigilante {args.tipo}/{args.modo} en "
                  f"{r.get('start')}-{r.get('end')}")
        elif args.accion == "quitar":
            d.quitar_vigilante(args.direccion, args.fin)
            print("quitado")
        elif args.accion == "listar":
            _imprimir_vigilantes(d.listar_vigilantes())

    elif c == "cosechar":
        return _cosechar(d, args.segundos, args.intervalo)

    elif c == "esperar":
        print(f"esperando hasta {args.segundos:.0f}s a que se pause...")
        st = d.esperar_pausa(args.segundos)
        if st is None:
            print("no se pauso: el breakpoint no disparo en ese plazo.")
            return 1
        print(f"PAUSADO en PC={st.get('pc')}  ciclos={st.get('cycles')}\n")
        pc = int(str(st.get("pc", "0x0")), 16)
        print("--- codigo alrededor del PC ---")
        _imprimir_instrucciones(d.desensamblar(max(0, pc - 4 * args.contexto),
                                               args.contexto * 2))
        print("\n--- vigilantes ---")
        _imprimir_vigilantes(d.listar_vigilantes())

    elif c == "pausar":
        print(f"pausado en PC={d.pausar()}")

    elif c == "continuar":
        d.continuar()
        print("corriendo")

    elif c == "paso":
        for i in range(args.n):
            r = d.paso()
            print(f"paso {i+1}: PC={r.get('new_pc')}  {r.get('opcode','')}  {r.get('disasm','')}")

    elif c == "paso-sobre":
        r = d.paso_sobre()
        print(f"{r.get('old_pc')} -> {r.get('new_pc')}  {r.get('disasm','')}")

    elif c == "hilos":
        for t in d.hilos():
            print(f"TID {t.get('id')}: PC={t.get('pc')} estado={t.get('status')} "
                  f"espera={t.get('wait_type')}")

    elif c == "modulos":
        for m in d.modulos():
            print(f"{m.get('name')} (v{m.get('version')})")

    elif c == "pila":
        for i, f in enumerate(d.pila(args.max)):
            print(f"#{i} entrada={f.get('entry')} pc={f.get('pc')} "
                  f"sp={f.get('sp')} tam={f.get('stack_size')}  {f.get('disasm','')}")

    return 0


def _cosechar(d: Depurador, segundos: float, intervalo: float) -> int:
    """Deja correr el juego y mira cómo evolucionan los vigilantes.

    Es el modo de trabajo recomendado: los vigilantes en `--accion log` no
    pausan la emulación, así que esto se puede dejar corriendo sin riesgo
    de colgar nada ni de perder la partida.
    """
    inicial = d.listar_vigilantes()
    if not inicial:
        print("no hay vigilantes puestos. Poné uno primero:\n"
              "  python depurador.py vigilante poner 0x005A8DA8 --accion log",
              file=sys.stderr)
        return 2

    previos = {f"{v['start']}-{v['end']}": v.get("hits", 0) for v in inicial}
    print(f"cosechando {segundos:.0f}s sobre {len(inicial)} vigilante(s)...\n")
    _imprimir_vigilantes(inicial)

    limite = time.monotonic() + segundos
    while time.monotonic() < limite:
        time.sleep(intervalo)
        try:
            actuales = d.listar_vigilantes()
        except DepuradorError as e:
            print(f"\nse corto la cosecha: {e}", file=sys.stderr)
            return 1
        for v in actuales:
            clave = f"{v['start']}-{v['end']}"
            antes = previos.get(clave, 0)
            ahora = v.get("hits", 0)
            if ahora > antes:
                print(f"  +{ahora - antes:>6} hits  {clave}  "
                      f"ultimo_pc={v.get('last_pc')}  ultima_dir={v.get('last_addr')}")
                previos[clave] = ahora

    print("\n--- estado final ---")
    finales = d.listar_vigilantes()
    _imprimir_vigilantes(finales)

    tocados = [v for v in finales if v.get("hits", 0) > 0]
    if not tocados:
        print("\nNINGUN vigilante disparo. O nadie escribe/lee ahi mientras el\n"
              "juego esta quieto, o el watchpoint no quedo puesto. Probá con\n"
              "--tipo onchange, o provocá el evento (recargar nivel, recibir dano).")
        return 1

    print("\nInstrucciones a investigar (desensamblá cada ultimo_pc):")
    for v in tocados:
        print(f"  python depurador.py desensamblar {v.get('last_pc')} --n 12")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
