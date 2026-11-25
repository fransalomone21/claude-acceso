"""Crea una cuenta en el RPCN de la casa y la deja escrita en el rpcn.yml de RPCS3 de esta maquina.

Uso: python rpcn-cuenta.py <npid> [--servidor 10.147.20.3] [--puerto 31313] [--rpcs3 C:\\Games\\RPCS3]

El protocolo sale de RipleyTom/rpcn (src/server/client.rs y cmd_account.rs, v1.12.1): TLS; encabezado de 15
bytes little-endian (tipo u8, comando u16, largo u32 con el encabezado, id u64); Request = 0, Create = 2; el
cuerpo son cinco cadenas terminadas en 0 (npid, clave, nombre visible, avatar, mail). La respuesta trae el
codigo de error en el byte 15 (0 = sin error; el servidor corta despues de crear). Sin mail real: el RPCN de la
casa no valida mails (EmailUrl vacio). La clave se genera aca y no se imprime.
"""
import argparse, os, re, secrets, socket, ssl, struct, sys

ap = argparse.ArgumentParser()
ap.add_argument("npid")
ap.add_argument("--servidor", default="10.147.20.3")
ap.add_argument("--puerto", type=int, default=31313)
ap.add_argument("--rpcs3", default=r"C:\Games\RPCS3")
ap.add_argument("--probar", action="store_true", help="entra (Login = 0) con la cuenta del rpcn.yml; no crea nada")
a = ap.parse_args()

yml = os.path.join(a.rpcs3, "config", "rpcn.yml")
texto = open(yml, encoding="utf-8").read()
if a.probar:
    clave = re.search(r'^Password: "(.*)"', texto, re.M).group(1)
    npid = re.search(r'^NPID: "(.*)"', texto, re.M).group(1)
    cuerpo = b"".join(s.encode() + b"\0" for s in (npid, clave, ""))
    paquete = struct.pack("<BHIQ", 0, 0, 15 + len(cuerpo), 1) + cuerpo
else:
    if not re.search(r'^NPID: ""\s*$', texto, re.M):
        sys.exit(f"{yml} ya tiene una cuenta: no se pisa")
    clave = secrets.token_urlsafe(18)
    AVATAR = "https://rpcs3.net/cdn/netplay/DefaultAvatar.png"  # get_string(false): ninguna cadena puede ir vacia
    cuerpo = b"".join(s.encode() + b"\0" for s in (a.npid, clave, a.npid, AVATAR, f"{a.npid.lower()}@casa.lan"))
    paquete = struct.pack("<BHIQ", 0, 2, 15 + len(cuerpo), 1) + cuerpo

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE  # certificado propio del RPCN de la casa
with socket.create_connection((a.servidor, a.puerto), timeout=10) as crudo, ctx.wrap_socket(crudo) as s:
    def leer(n):
        b = b""
        while len(b) < n:
            c = s.recv(n - len(b))
            if not c:
                raise ConnectionError("el servidor corto")
            b += c
        return b
    tipo, cmd, largo, _ = struct.unpack("<BHIQ", leer(15))
    info = leer(largo - 15)
    print(f"servidor: paquete tipo {tipo}, {len(info)} bytes de info")
    s.sendall(paquete)
    tipo, cmd, largo, _ = struct.unpack("<BHIQ", leer(15))
    resto = leer(largo - 15)
    error = resto[0] if resto else -1
print(f"respuesta: tipo {tipo} comando {cmd} error {error}")
if a.probar:
    print(f"login de {npid}: {'OK' if error == 0 else 'FALLA'}")
    sys.exit(0 if error == 0 else 1)
if error != 0:
    sys.exit(f"no se creo la cuenta {a.npid} (codigo {error})")

texto = re.sub(r'^NPID: ""', f'NPID: "{a.npid}"', texto, flags=re.M)
texto = re.sub(r'^Password: ""', f'Password: "{clave}"', texto, flags=re.M)
open(yml, "w", encoding="utf-8", newline="\n").write(texto)
print(f"cuenta {a.npid} creada y escrita en {yml}")
