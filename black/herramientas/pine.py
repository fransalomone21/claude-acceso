#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pine.py — cliente PINE (el IPC de PCSX2). Sólo librería estándar.

PROTOCOLO (verificado contra pcsx2/PINE.cpp, agosto 2026)

    Pedido    : [u32 LE tamaño_total][cmd][cmd]...
    Respuesta : [u32 LE tamaño_total][u8 código][datos...]

    - `tamaño_total` SE INCLUYE a sí mismo, en los dos sentidos.
    - Un pedido puede encadenar N comandos; la respuesta trae UN SOLO
      código de resultado (0x00 OK / 0xFF FAIL) y después los datos de
      cada comando, en orden.
    - lectura   : [u8 opcode][u32 LE dirección]                -> 1/2/4/8 bytes
    - escritura : [u8 opcode][u32 LE dirección][valor 1/2/4/8] -> 0 bytes
    - strings   : respuesta = [u32 LE largo][bytes...] (largo incluye el \\0)

TRANSPORTE
    Linux/macOS : socket UNIX en $XDG_RUNTIME_DIR/pcsx2.sock (o /tmp/pcsx2.sock)
    Windows     : TCP en 127.0.0.1, puerto = número de slot (por defecto 28011)

USO RÁPIDO
    from pine import Pine
    with Pine() as p:
        print(p.titulo(), p.id_juego())
        print(hex(p.leer32(0x00100000)))
        p.escribir32(0x00100000, 0xDEADBEEF)
        datos = p.leer_bloque(0x00100000, 0x1000)

CLI
    python3 pine.py info
    python3 pine.py leer 0x1FF320 --tipo u32
    python3 pine.py escribir 0x1FF320 100 --tipo u32
    python3 pine.py volcar 0x00100000 0x10000 salida.bin
"""

from __future__ import annotations

import argparse
import os
import platform
import socket
import struct
import sys

# --- Opcodes -----------------------------------------------------------------
MSG_READ8 = 0x00
MSG_READ16 = 0x01
MSG_READ32 = 0x02
MSG_READ64 = 0x03
MSG_WRITE8 = 0x04
MSG_WRITE16 = 0x05
MSG_WRITE32 = 0x06
MSG_WRITE64 = 0x07
MSG_VERSION = 0x08
MSG_SAVESTATE = 0x09
MSG_LOADSTATE = 0x0A
MSG_TITLE = 0x0B
MSG_ID = 0x0C
MSG_UUID = 0x0D
MSG_GAMEVERSION = 0x0E
MSG_STATUS = 0x0F

IPC_OK = 0x00
IPC_FAIL = 0xFF

MAX_IPC_SIZE = 650_000
MAX_IPC_RETURN_SIZE = 450_000

SLOT_POR_DEFECTO = 28011

# opcode de lectura y de escritura, indexado por ancho en bytes
_OP_LEER = {1: MSG_READ8, 2: MSG_READ16, 4: MSG_READ32, 8: MSG_READ64}
_OP_ESCRIBIR = {1: MSG_WRITE8, 2: MSG_WRITE16, 4: MSG_WRITE32, 8: MSG_WRITE64}
_FMT = {1: "<B", 2: "<H", 4: "<I", 8: "<Q"}

ESTADOS = {0: "corriendo", 1: "pausado", 2: "apagado"}


class PineError(RuntimeError):
    """Cualquier fallo de protocolo, transporte o del lado de PCSX2."""


# --- Descubrimiento del socket ----------------------------------------------
def rutas_socket(slot: int = SLOT_POR_DEFECTO) -> list[str]:
    """Rutas candidatas del socket UNIX, en orden de preferencia."""
    sufijo = "" if slot == SLOT_POR_DEFECTO else f".{slot}"
    bases = []
    xdg = os.environ.get("XDG_RUNTIME_DIR")
    if xdg:
        bases.append(os.path.join(xdg, "pcsx2.sock"))
    bases.append("/tmp/pcsx2.sock")
    # macOS usa TMPDIR
    tmp = os.environ.get("TMPDIR")
    if tmp:
        bases.append(os.path.join(tmp, "pcsx2.sock"))
    return [b + sufijo for b in bases]


class Pine:
    """Conexión a PCSX2 por PINE. Reconecta sola si PCSX2 corta."""

    def __init__(
        self,
        slot: int = SLOT_POR_DEFECTO,
        host: str = "127.0.0.1",
        ruta_socket: str | None = None,
        timeout: float = 10.0,
    ):
        self.slot = slot
        self.host = host
        self.ruta_socket = ruta_socket
        self.timeout = timeout
        self.sock: socket.socket | None = None
        self._descripcion = ""
        self.conectar()

    # -- transporte -----------------------------------------------------------
    def conectar(self) -> None:
        self.cerrar()
        errores = []

        # En Windows PINE es TCP; en el resto, socket UNIX (con fallback a TCP).
        candidatos: list[tuple[str, object]] = []
        if platform.system() != "Windows":
            rutas = [self.ruta_socket] if self.ruta_socket else rutas_socket(self.slot)
            candidatos += [("unix", r) for r in rutas if r]
        candidatos.append(("tcp", (self.host, self.slot)))

        for clase, destino in candidatos:
            try:
                if clase == "unix":
                    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
                    s.settimeout(self.timeout)
                    s.connect(destino)  # type: ignore[arg-type]
                    self._descripcion = f"unix:{destino}"
                else:
                    s = socket.create_connection(destino, timeout=self.timeout)  # type: ignore[arg-type]
                    s.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                    self._descripcion = f"tcp:{destino[0]}:{destino[1]}"  # type: ignore[index]
                self.sock = s
                return
            except OSError as e:
                errores.append(f"  {clase}:{destino} -> {e}")

        raise PineError(
            "No pude conectarme a PCSX2 por PINE. Probé:\n"
            + "\n".join(errores)
            + "\n\nRevisá que PCSX2 esté abierto CON UN JUEGO CARGADO y que PINE esté\n"
            "activado en Settings > Advanced > PINE Settings (Enable + Slot 28011)."
        )

    def cerrar(self) -> None:
        if self.sock is not None:
            try:
                self.sock.close()
            except OSError:
                pass
            self.sock = None

    def __enter__(self) -> "Pine":
        return self

    def __exit__(self, *_exc) -> None:
        self.cerrar()

    @property
    def descripcion(self) -> str:
        return self._descripcion

    def _recibir_exacto(self, n: int) -> bytes:
        assert self.sock is not None
        buf = bytearray()
        while len(buf) < n:
            trozo = self.sock.recv(n - len(buf))
            if not trozo:
                raise PineError("PCSX2 cerró la conexión a mitad de una respuesta")
            buf += trozo
        return bytes(buf)

    def _transaccion(self, cuerpo: bytes, _reintento: bool = True) -> bytes:
        """Manda un pedido armado y devuelve el payload de la respuesta."""
        if 4 + len(cuerpo) > MAX_IPC_SIZE:
            raise PineError(
                f"pedido de {4 + len(cuerpo)} bytes supera MAX_IPC_SIZE ({MAX_IPC_SIZE}); "
                "dividí el lote"
            )
        mensaje = struct.pack("<I", 4 + len(cuerpo)) + cuerpo
        try:
            assert self.sock is not None
            self.sock.sendall(mensaje)
            cabecera = self._recibir_exacto(4)
            total = struct.unpack("<I", cabecera)[0]
            if total < 5 or total > MAX_IPC_RETURN_SIZE + 5:
                raise PineError(f"tamaño de respuesta inválido: {total}")
            resto = self._recibir_exacto(total - 4)
        except (OSError, PineError) as e:
            if _reintento:
                # PCSX2 corta la conexión al cambiar de juego o al pausar/reanudar.
                self.conectar()
                return self._transaccion(cuerpo, _reintento=False)
            raise PineError(f"fallo de transporte PINE: {e}") from e

        codigo = resto[0]
        if codigo != IPC_OK:
            raise PineError(
                f"PCSX2 devolvió FAIL (0x{codigo:02X}). Causa habitual: dirección fuera "
                "de rango, o no hay juego cargado."
            )
        return resto[1:]

    # -- lectura / escritura --------------------------------------------------
    def leer(self, direccion: int, ancho: int = 4, con_signo: bool = False) -> int:
        if ancho not in _OP_LEER:
            raise ValueError("ancho debe ser 1, 2, 4 u 8")
        payload = self._transaccion(
            struct.pack("<BI", _OP_LEER[ancho], direccion & 0xFFFFFFFF)
        )
        if len(payload) != ancho:
            raise PineError(f"esperaba {ancho} bytes, llegaron {len(payload)}")
        return int.from_bytes(payload, "little", signed=con_signo)

    def escribir(self, direccion: int, valor: int, ancho: int = 4) -> None:
        if ancho not in _OP_ESCRIBIR:
            raise ValueError("ancho debe ser 1, 2, 4 u 8")
        mascara = (1 << (ancho * 8)) - 1
        cuerpo = struct.pack("<BI", _OP_ESCRIBIR[ancho], direccion & 0xFFFFFFFF)
        cuerpo += struct.pack(_FMT[ancho], valor & mascara)
        self._transaccion(cuerpo)

    def leer8(self, d: int, con_signo: bool = False) -> int:
        return self.leer(d, 1, con_signo)

    def leer16(self, d: int, con_signo: bool = False) -> int:
        return self.leer(d, 2, con_signo)

    def leer32(self, d: int, con_signo: bool = False) -> int:
        return self.leer(d, 4, con_signo)

    def leer64(self, d: int, con_signo: bool = False) -> int:
        return self.leer(d, 8, con_signo)

    def escribir8(self, d: int, v: int) -> None:
        self.escribir(d, v, 1)

    def escribir16(self, d: int, v: int) -> None:
        self.escribir(d, v, 2)

    def escribir32(self, d: int, v: int) -> None:
        self.escribir(d, v, 4)

    def escribir64(self, d: int, v: int) -> None:
        self.escribir(d, v, 8)

    def leer_f32(self, direccion: int) -> float:
        return struct.unpack("<f", struct.pack("<I", self.leer32(direccion)))[0]

    def escribir_f32(self, direccion: int, valor: float) -> None:
        self.escribir32(direccion, struct.unpack("<I", struct.pack("<f", valor))[0])

    # -- lotes (lo que hace viable escanear) ----------------------------------
    def _tope_lote(self, ancho: int) -> int:
        """Cuántos comandos entran en un pedido sin pasarse de ningún límite."""
        por_pedido = (MAX_IPC_SIZE - 4 - 64) // 5  # 5 bytes por comando de lectura
        por_respuesta = (MAX_IPC_RETURN_SIZE - 5 - 64) // ancho
        return max(1, min(por_pedido, por_respuesta))

    def leer_muchas(
        self, direcciones, ancho: int = 4, con_signo: bool = False
    ) -> list[int]:
        """Lee N direcciones sueltas en la menor cantidad de viajes posible."""
        if ancho not in _OP_LEER:
            raise ValueError("ancho debe ser 1, 2, 4 u 8")
        direcciones = list(direcciones)
        op = _OP_LEER[ancho]
        tope = self._tope_lote(ancho)
        salida: list[int] = []
        for i in range(0, len(direcciones), tope):
            trozo = direcciones[i : i + tope]
            cuerpo = b"".join(
                struct.pack("<BI", op, d & 0xFFFFFFFF) for d in trozo
            )
            payload = self._transaccion(cuerpo)
            esperado = len(trozo) * ancho
            if len(payload) != esperado:
                raise PineError(
                    f"lote inconsistente: esperaba {esperado} bytes, llegaron {len(payload)}"
                )
            salida.extend(
                int.from_bytes(payload[j : j + ancho], "little", signed=con_signo)
                for j in range(0, esperado, ancho)
            )
        return salida

    def escribir_muchas(self, pares, ancho: int = 4) -> None:
        """`pares` = iterable de (direccion, valor)."""
        if ancho not in _OP_ESCRIBIR:
            raise ValueError("ancho debe ser 1, 2, 4 u 8")
        pares = list(pares)
        op = _OP_ESCRIBIR[ancho]
        mascara = (1 << (ancho * 8)) - 1
        tam_cmd = 5 + ancho
        tope = max(1, (MAX_IPC_SIZE - 4 - 64) // tam_cmd)
        for i in range(0, len(pares), tope):
            cuerpo = b"".join(
                struct.pack("<BI", op, d & 0xFFFFFFFF)
                + struct.pack(_FMT[ancho], v & mascara)
                for d, v in pares[i : i + tope]
            )
            self._transaccion(cuerpo)

    def leer_bloque(self, direccion: int, largo: int) -> bytes:
        """Lee `largo` bytes contiguos. Usa lecturas de 64 bits cuando puede."""
        salida = bytearray()
        pos = direccion
        restante = largo

        # cabecera desalineada, byte a byte
        while restante and pos % 8:
            salida.append(self.leer8(pos))
            pos += 1
            restante -= 1

        if restante >= 8:
            n = restante // 8
            palabras = self.leer_muchas(range(pos, pos + n * 8, 8), ancho=8)
            for w in palabras:
                salida += w.to_bytes(8, "little")
            pos += n * 8
            restante -= n * 8

        while restante:
            salida.append(self.leer8(pos))
            pos += 1
            restante -= 1

        return bytes(salida)

    def escribir_bloque(self, direccion: int, datos: bytes) -> None:
        pos, i = direccion, 0
        while i < len(datos) and (pos % 4 or len(datos) - i < 4):
            self.escribir8(pos, datos[i])
            pos += 1
            i += 1
        n = (len(datos) - i) // 4
        if n:
            pares = [
                (pos + k * 4, int.from_bytes(datos[i + k * 4 : i + k * 4 + 4], "little"))
                for k in range(n)
            ]
            self.escribir_muchas(pares, ancho=4)
            pos += n * 4
            i += n * 4
        while i < len(datos):
            self.escribir8(pos, datos[i])
            pos += 1
            i += 1

    # -- metadatos y control --------------------------------------------------
    def _string(self, opcode: int) -> str:
        payload = self._transaccion(struct.pack("<B", opcode))
        if len(payload) < 4:
            raise PineError("respuesta de string demasiado corta")
        largo = struct.unpack("<I", payload[:4])[0]
        crudo = payload[4 : 4 + largo]
        return crudo.split(b"\x00", 1)[0].decode("utf-8", "replace")

    def version(self) -> str:
        return self._string(MSG_VERSION)

    def titulo(self) -> str:
        return self._string(MSG_TITLE)

    def id_juego(self) -> str:
        return self._string(MSG_ID)

    def uuid(self) -> str:
        return self._string(MSG_UUID)

    def version_juego(self) -> str:
        return self._string(MSG_GAMEVERSION)

    def estado(self) -> str:
        payload = self._transaccion(struct.pack("<B", MSG_STATUS))
        v = struct.unpack("<I", payload[:4])[0]
        return ESTADOS.get(v, f"desconocido({v})")

    def guardar_estado(self, slot: int = 0) -> None:
        """Pide un savestate en el slot dado. PCSX2 lo hace de forma asíncrona."""
        self._transaccion(struct.pack("<BB", MSG_SAVESTATE, slot & 0xFF))

    def cargar_estado(self, slot: int = 0) -> None:
        self._transaccion(struct.pack("<BB", MSG_LOADSTATE, slot & 0xFF))

    def info(self) -> dict:
        return {
            "transporte": self.descripcion,
            "version_pcsx2": self.version(),
            "titulo": self.titulo(),
            "serial": self.id_juego(),
            "crc": self.uuid(),
            "version_juego": self.version_juego(),
            "estado": self.estado(),
        }


# --- CLI ---------------------------------------------------------------------
def _entero(texto: str) -> int:
    return int(texto, 0)


ANCHOS = {"u8": 1, "u16": 2, "u32": 4, "u64": 8,
          "i8": 1, "i16": 2, "i32": 4, "i64": 8}


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Cliente PINE para PCSX2")
    ap.add_argument("--slot", type=int, default=SLOT_POR_DEFECTO)
    sub = ap.add_subparsers(dest="cmd", required=True)

    sub.add_parser("info", help="datos del juego cargado y de PCSX2")

    p_leer = sub.add_parser("leer", help="lee una dirección")
    p_leer.add_argument("direccion", type=_entero)
    p_leer.add_argument("--tipo", default="u32", choices=list(ANCHOS) + ["f32"])

    p_esc = sub.add_parser("escribir", help="escribe una dirección")
    p_esc.add_argument("direccion", type=_entero)
    p_esc.add_argument("valor")
    p_esc.add_argument("--tipo", default="u32", choices=list(ANCHOS) + ["f32"])

    p_vol = sub.add_parser("volcar", help="vuelca un rango a un archivo")
    p_vol.add_argument("direccion", type=_entero)
    p_vol.add_argument("largo", type=_entero)
    p_vol.add_argument("salida")

    p_ss = sub.add_parser("savestate", help="pide un savestate")
    p_ss.add_argument("--slot", dest="ss_slot", type=int, default=0)

    # `cargarestado` estaba implementado en la clase Pine desde siempre y sin
    # exponer. Es lo que permite correr un experimento sin nadie al teclado:
    # cargar un estado conocido, medir, cargarlo de nuevo, medir otra cosa.
    # Sin esto, cada condición experimental depende de que alguien vuelva a
    # ponerse en la misma posición, que es justo lo que no se puede repetir.
    p_ls = sub.add_parser("cargarestado",
                          help="carga un savestate: el punto de partida "
                               "reproducible de cualquier experimento")
    p_ls.add_argument("--slot", dest="ss_slot", type=int, default=0)

    args = ap.parse_args(argv)

    try:
        with Pine(slot=args.slot) as p:
            if args.cmd == "info":
                for k, v in p.info().items():
                    print(f"{k:16} {v}")
            elif args.cmd == "leer":
                if args.tipo == "f32":
                    print(p.leer_f32(args.direccion))
                else:
                    ancho = ANCHOS[args.tipo]
                    v = p.leer(args.direccion, ancho, con_signo=args.tipo[0] == "i")
                    print(f"{v}  (0x{v & ((1 << ancho * 8) - 1):0{ancho * 2}X})")
            elif args.cmd == "escribir":
                if args.tipo == "f32":
                    p.escribir_f32(args.direccion, float(args.valor))
                else:
                    p.escribir(args.direccion, _entero(args.valor), ANCHOS[args.tipo])
                print("ok")
            elif args.cmd == "volcar":
                datos = p.leer_bloque(args.direccion, args.largo)
                with open(args.salida, "wb") as f:
                    f.write(datos)
                print(f"{len(datos)} bytes -> {args.salida}")
                # armas.py, clases.py, zonas.py y xref.py (sin --base) asumen
                # que el byte 0 del archivo ES la dirección EE 0. Un volcado
                # parcial corre TODAS las direcciones y hace que las cosas
                # parezcan haberse mudado. Pasó el 2026-08-17: se dio por
                # movido un heap que no se había movido. Barato avisar acá.
                if args.direccion != 0:
                    print(
                        f"  AVISO: este volcado arranca en 0x{args.direccion:08X},"
                        f" no en 0.\n"
                        f"  Las herramientas de análisis leen el byte 0 como la"
                        f" dirección 0, así que\n"
                        f"  van a informar todo 0x{args.direccion:X} más abajo."
                        f" Para analizar, volcá desde 0."
                    )
            elif args.cmd == "savestate":
                p.guardar_estado(args.ss_slot)
                print(f"savestate pedido en slot {args.ss_slot}")
            elif args.cmd == "cargarestado":
                p.cargar_estado(args.ss_slot)
                print(f"savestate {args.ss_slot} pedido para cargar")
                print("  PCSX2 lo hace de forma ASÍNCRONA: esperá a que la "
                      "lectura de una dirección conocida dé el valor esperado "
                      "antes de medir nada.")
    except PineError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
