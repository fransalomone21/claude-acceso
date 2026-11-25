"""L1-12 y L1-13: el server de la tienda acepta conexiones desde la red de la casa y desde ZeroTier.

  python probar_red.py      prende el server de la tienda (lo publicado), espera el Done, prueba desde la PC el
                            puerto 25568 por ZeroTier (10.147.20.2) y por la red de la casa (la IP 192.168.x de la
                            notebook), y lo apaga con 'stop' (guarda el mundo). 0 = las dos pasan.

El control es un puerto donde no escucha nadie (25599): tiene que dar que NO conecta, o la prueba no discrimina.
"""
import base64, os, socket, subprocess, sys, time

import armar as A

LLAVE = os.path.expanduser(r"~\.ssh\pc-cable")
PC = "Fran@10.147.20.3"
PUERTO = 25568
CONTROL = 25599


def ip_casa():
    out = subprocess.run(["powershell", "-NoProfile", "-Command",
                          "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like '192.168.*' } | Select-Object -First 1).IPAddress"],
                         capture_output=True, text=True).stdout.strip()
    return out


def desde_pc(ip, puerto):
    cmd = (f"$c = New-Object Net.Sockets.TcpClient; $r = $c.BeginConnect('{ip}', {puerto}, $null, $null); "
           f"$ok = $r.AsyncWaitHandle.WaitOne(4000) -and $c.Connected; $c.Close(); if ($ok) {{ 'CONECTA' }} else {{ 'NO' }}")
    enc = base64.b64encode(cmd.encode("utf-16-le")).decode()
    r = subprocess.run(["ssh", "-o", "ConnectTimeout=15", "-i", LLAVE, PC, f"powershell -NoProfile -EncodedCommand {enc}"],
                       capture_output=True, text=True, encoding="utf-8", errors="replace")
    return "CONECTA" in r.stdout


def main():
    A.sincronizar_server()
    srv = A.SERVER
    java = A.JAVA
    args = [java, "@user_jvm_args.txt", f"@libraries/net/neoforged/neoforge/{A.NEOFORGE}/win_args.txt", "nogui"]
    p = subprocess.Popen(args, cwd=srv, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         text=True, encoding="utf-8", errors="replace")
    t0, listo = time.time(), False
    while time.time() - t0 < 300:
        linea = p.stdout.readline()
        if not linea:
            break
        if "Done (" in linea:
            listo = True
            print(f"server: arranco en {time.time() - t0:.0f} s")
            break
    rc = 1
    import threading
    threading.Thread(target=lambda: [None for _ in p.stdout], daemon=True).start()   # que el log no trabe al server
    if listo:
        casa = ip_casa()
        zt = desde_pc("10.147.20.2", PUERTO)
        lan = desde_pc(casa, PUERTO) if casa else False
        ctl = desde_pc("10.147.20.2", CONTROL)
        print(f"desde la PC por ZeroTier 10.147.20.2:{PUERTO}: {'CONECTA' if zt else 'NO'} (L1-13)")
        print(f"desde la PC por la red de la casa {casa}:{PUERTO}: {'CONECTA' if lan else 'NO'} (L1-12)")
        print(f"control, puerto sin server {CONTROL}: {'CONECTA (la prueba no discrimina)' if ctl else 'NO, como debe'}")
        rc = 0 if (zt and lan and not ctl) else 1
    else:
        print("server: no llego al Done")
    try:
        p.stdin.write("stop\n")
        p.stdin.flush()
        p.wait(timeout=180)
        print("server: apagado con stop")
    except Exception as e:
        p.kill()
        print(f"server: no se apago solo ({e}); se corto")
    return rc


if __name__ == "__main__":
    sys.exit(main())
