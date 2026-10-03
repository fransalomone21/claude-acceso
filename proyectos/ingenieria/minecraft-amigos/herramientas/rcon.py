"""Manda comandos al server por RCON (la clave vive en el server, no en el repo).

Uso: python rcon.py "chunky radius 1500" "chunky start"
"""
import socket
import struct
import sys
from pathlib import Path

SERVER = Path(r"C:\Users\frans\MinecraftServer\juntada")


def paquete(rid, tipo, cuerpo):
    datos = struct.pack("<ii", rid, tipo) + cuerpo.encode("utf-8") + b"\x00\x00"
    return struct.pack("<i", len(datos)) + datos


def leer(s):
    n = struct.unpack("<i", s.recv(4))[0]
    datos = b""
    while len(datos) < n:
        datos += s.recv(n - len(datos))
    rid, _ = struct.unpack("<ii", datos[:8])
    return rid, datos[8:-2].decode("utf-8", "replace")


def main():
    clave = (SERVER / "rcon-password.txt").read_text().strip()
    with socket.create_connection(("127.0.0.1", 25575), timeout=30) as s:
        s.sendall(paquete(1, 3, clave))
        if leer(s)[0] == -1:
            sys.exit("[ROJO] RCON rechazo la clave")
        for i, cmd in enumerate(sys.argv[1:], start=2):
            s.sendall(paquete(i, 2, cmd))
            print(f"> {cmd}\n{leer(s)[1]}")


if __name__ == "__main__":
    main()
