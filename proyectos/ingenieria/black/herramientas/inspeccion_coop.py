"""inspeccion_coop.py -- (110) recorrido MACRO del coop: escenas cortas con fotos, audio y numeros, para ver los
problemas grandes de J2 de una mirada y despues bajar a cada uno (pedido de Fran, 2026-10-01).

Con un nivel cargado y J2 armado. Una sola conexion PINE; las capturas (capturar-pantalla.ps1) y el audio
(grabar_audio.py, WASAPI loopback) corren en procesos aparte y no tocan PINE.

    python herramientas/inspeccion_coop.py [escena ...]      # sin escenas: todas, en orden
Escenas:
  quieto      2 s sin tocar nada (la referencia de audio y de imagen)
  fuego-J2    J2 dispara 3 s (mando falso 2)   -> ¿suena?, ¿que arma se ve en cada mitad?
  fuego-J     J dispara 3 s (mando falso 1)    -> el control de nivel de audio
  agacha-J    J se agacha 2 s                  -> ¿baja tambien la mitad de J2? (F6)
  agacha-J2   J2 se agacha 2 s                 -> el espejo
  mirar-J     J2 gira hasta mirar a J          -> ¿J tiene cuerpo en la mitad de J2? (F3)
  mirar-J2    J gira hasta mirar a J2          -> el titere en la mitad de J
  recarga-J2  J2 recarga                        -> ¿se ve en la mitad de J? (E1/F7)
Salida: volcados/inspeccion/<fecha-hora>/<escena>-N.png, <escena>.wav y resumen.json (con el nivel de audio por
ventana de 100 ms y los numeros de cada escena).
"""
import array
import json
import math
import struct
import subprocess
import sys
import time
import wave
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402

J, J2 = cj.J, cj.J2
FALSO = {"J": 0x00472000, "J2": cj.FALSO2}
CTRL1 = 0x005858A0
MIRA_YAW = {"J": J + 0x4F0 + 8, "J2": J2 + 0x4F0 + 8}
BOTON = {"disparar": 12, "recargar": 2, "agacharse": 11, "melee": 3, "agarrar": 1}
ESCENAS = ["quieto", "fuego-J2", "fuego-J", "agacha-J", "agacha-J2", "mirar-J", "mirar-J2", "recarga-J2"]


def f32(p, d):
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def pos(p, b, o=0xA0):
    return [round(f32(p, b + o + 4 * k), 3) for k in range(3)]


def poner_falso(p, quien):
    ctrl = p.leer32(J2 + 0x588) if quien == "J2" else CTRL1
    fuente = p.leer32(ctrl + 0xC)
    if fuente != FALSO[quien]:
        f = bytearray(p.leer_bloque(fuente, 0xF0))
        for o in range(0x8C, 0xCC, 4):
            f[o:o + 4] = bytes(4)
        f[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
        p.escribir_bloque(FALSO[quien], bytes(f))
        p.escribir32(ctrl + 0xC, FALSO[quien])


def boton(p, quien, nombre, apretado):
    i = BOTON[nombre]
    p.escribir8(FALSO[quien] + 0x0E + i, 0)
    p.escribir8(FALSO[quien] + 0x2A + i, 1 if apretado else 0)
    p.escribir_f32(FALSO[quien] + 0x4C + 4 * i, 1.0 if apretado else 0.0)


def cargador(p, quien):
    b = J if quien == "J" else J2
    sub = p.leer32(p.leer32(b + 0x2A4) + 0xF4)
    return struct.unpack("<H", p.leer_bloque(sub + 0x18, 2))[0] if sub else None


def numeros(p):
    return {"vJ": round(f32(p, J + 0x2F8), 1), "vJ2": round(f32(p, J2 + 0x2F8), 1),
            "cJ": cargador(p, "J"), "cJ2": cargador(p, "J2"),
            "ojoJ_y": round(f32(p, J + 0x104), 3), "ojoJ2_y": round(f32(p, J2 + 0x104), 3),
            "agachJ": p.leer8(p.leer32(J + 0x32C) + 0x30), "agachJ2": p.leer8(p.leer32(J2 + 0x32C) + 0x30),
            "armaJ": p.leer8(J + 0x2C3), "armaJ2": p.leer8(J2 + 0x2C3),
            "J": pos(p, J), "J2": pos(p, J2)}


def captura(dir_, nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(dir_ / nombre)], capture_output=True)


def audio_inicio(dir_, nombre, s):
    return subprocess.Popen([sys.executable, str(H / "grabar_audio.py"), str(dir_ / nombre), str(s)],
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)


def nivel_audio(ruta):
    """RMS por ventana de 100 ms (0-32767) y el maximo."""
    try:
        with wave.open(str(ruta), "rb") as w:
            n, ch, sr = w.getnframes(), w.getnchannels(), w.getframerate()
            datos = array.array("h", w.readframes(n))
    except Exception as ex:  # noqa: BLE001
        return {"error": str(ex)}
    paso = int(sr * 0.1) * ch
    rms = []
    for k in range(0, len(datos) - paso, paso):
        v = datos[k:k + paso]
        rms.append(int(math.sqrt(sum(x * x for x in v[::4]) / max(1, len(v[::4])))))
    return {"rms_100ms": rms, "max": max(rms) if rms else 0, "media": int(sum(rms) / len(rms)) if rms else 0}


def girar_hacia(p, quien, blanco, pasos=6):
    """Corrige el yaw (mira+8) hasta que el 'adelante' de la matriz apunte al blanco; el signo se mide."""
    b = J if quien == "J" else J2
    signo = None
    for _ in range(pasos):
        yo = pos(p, b)
        obj = math.atan2(blanco[0] - yo[0], blanco[2] - yo[2])
        err = math.remainder(obj - math.atan2(f32(p, b + 0x90), f32(p, b + 0x98)), math.tau)
        if abs(math.degrees(err)) < 3:
            break
        yaw = f32(p, MIRA_YAW[quien])
        if signo is None:
            p.escribir_f32(MIRA_YAW[quien], yaw + 10.0)
            time.sleep(0.25)
            e2 = math.remainder(obj - math.atan2(f32(p, b + 0x90), f32(p, b + 0x98)), math.tau)
            signo = 1.0 if abs(e2) <= abs(err) else -1.0
            yaw, err = f32(p, MIRA_YAW[quien]), e2
        p.escribir_f32(MIRA_YAW[quien], yaw + signo * math.degrees(err))
        time.sleep(0.25)
    return signo


def escena(p, nombre, dir_):
    r = {"antes": numeros(p)}
    if nombre == "quieto":
        a = audio_inicio(dir_, "quieto.wav", 3)
        time.sleep(1.5); captura(dir_, "quieto-1.png")
        a.wait()
    elif nombre in ("fuego-J2", "fuego-J"):
        q = nombre.split("-")[1]
        poner_falso(p, q)
        a = audio_inicio(dir_, nombre + ".wav", 5)
        time.sleep(1.0)
        boton(p, q, "disparar", True)
        serie = []
        for k in range(30):
            serie.append(numeros(p)["cJ2" if q == "J2" else "cJ"])
            if k in (8, 20):
                captura(dir_, "%s-%d.png" % (nombre, k // 10 + 1))
            time.sleep(0.1)
        boton(p, q, "disparar", False)
        r["cargador_serie"] = serie
        a.wait()
    elif nombre in ("agacha-J", "agacha-J2"):
        q = nombre.split("-")[1]
        poner_falso(p, q)
        boton(p, q, "agacharse", True)
        serie = []
        for k in range(20):
            n = numeros(p)
            serie.append([n["ojoJ_y"], n["ojoJ2_y"], n["agachJ"], n["agachJ2"]])
            if k == 12:
                captura(dir_, nombre + "-1.png")
            time.sleep(0.1)
        boton(p, q, "agacharse", False)
        r["ojo_y_J_J2_agach_J_J2"] = serie
        time.sleep(1.0)
    elif nombre == "mirar-J":
        r["signo"] = girar_hacia(p, "J2", pos(p, J))
        time.sleep(0.5); captura(dir_, "mirar-J-1.png")
    elif nombre == "mirar-J2":
        r["signo"] = girar_hacia(p, "J", pos(p, J2))
        time.sleep(0.5); captura(dir_, "mirar-J2-1.png")
    elif nombre == "recarga-J2":
        poner_falso(p, "J2")
        boton(p, "J2", "recargar", True); time.sleep(0.2); boton(p, "J2", "recargar", False)
        for k in range(3):
            time.sleep(0.35); captura(dir_, "recarga-J2-%d.png" % (k + 1))
        time.sleep(1.5)
    r["despues"] = numeros(p)
    wav = dir_ / (nombre + ".wav")
    if wav.exists():
        r["audio"] = nivel_audio(wav)
    return r


def main():
    tolerar_salida_pobre()
    pedidas = [a for a in sys.argv[1:] if not a.startswith("-")] or ESCENAS
    for e in pedidas:
        if e not in ESCENAS:
            raise SystemExit("escena desconocida: %s (hay: %s)" % (e, ", ".join(ESCENAS)))
    dir_ = H.parent / "volcados" / "inspeccion" / time.strftime("%Y%m%d-%H%M%S")
    dir_.mkdir(parents=True, exist_ok=True)
    res = {}
    with Pine() as p:
        if [p.leer32(0x0046D790), p.leer32(0x0046D784)] != [2, 3]:
            raise SystemExit("J2 no esta armado")
        for e in pedidas:
            res[e] = escena(p, e, dir_)
            a = res[e].get("audio", {})
            print("%-11s %s  audio max %s media %s" % (e, json.dumps({k: res[e]["despues"][k] for k in
                  ("vJ", "vJ2", "cJ", "cJ2", "agachJ", "agachJ2")}), a.get("max"), a.get("media")), flush=True)
    (dir_ / "resumen.json").write_text(json.dumps(res, ensure_ascii=False), encoding="utf-8")
    print(dir_)


if __name__ == "__main__":
    main()
