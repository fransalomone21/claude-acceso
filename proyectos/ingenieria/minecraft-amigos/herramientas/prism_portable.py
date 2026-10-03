"""Arma un Prism PORTABLE con la instancia de la juntada adentro, listo para descomprimir y jugar.

Uso: python prism_portable.py <salida.zip>

NO lleva accounts.json (son los tokens de la cuenta de Fran): cada uno agrega la suya.
La instancia va con el perfil MEDIO (sirve en todas las PCs); con placa se suben a mano los shaders.
"""
import json
import os
import re
import sys
import zipfile
from pathlib import Path

PROG = Path(os.environ["LOCALAPPDATA"]) / "Programs" / "PrismLauncher"
DATA = Path(os.environ["APPDATA"]) / "PrismLauncher"
INST = "Juntada 1.21.4"
RAIZ = "PrismJuntada"
FUERA_MC = {"saves", "xaero", ".fabric", "logs", "crash-reports", "screenshots", ".cache",
            "debug", "downloads", "moddata", "command_history.txt"}

MEDIO_OPC = {"renderDistance": "8", "simulationDistance": "6", "graphicsMode": "0",
             "particles": "1", "entityDistanceScaling": "0.75", "renderClouds": '"false"',
             "maxFps": "75", "enableVsync": "false", "biomeBlendRadius": "0", "mipmapLevels": "2"}
INST_CFG = {"name": INST, "OverrideMemory": "true", "MaxMemAlloc": "4096", "MinMemAlloc": "1024",
            "OverrideJavaLocation": "false", "JavaPath": "", "AutomaticJava": "true",
            "JoinServerOnLaunch": "true", "JoinServerOnLaunchAddress": "10.147.20.2"}


def pisar(texto, valores, sep):
    lineas = texto.splitlines()
    for k, v in valores.items():
        pat = re.compile(rf"^{re.escape(k)}{re.escape(sep)}")
        for i, l in enumerate(lineas):
            if pat.match(l):
                lineas[i] = f"{k}{sep}{v}"
                break
        else:
            lineas.append(f"{k}{sep}{v}")
    return "\n".join(lineas) + "\n"


def main():
    out = Path(sys.argv[1])
    idx = json.loads((DATA / "assets" / "indexes" / "19.json").read_text())  # indice de 1.21.4
    objetos = {o["hash"] for o in idx["objects"].values()}
    n = 0
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=5) as z:
        def add(src, arc):
            nonlocal n
            z.write(src, f"{RAIZ}/{arc}")
            n += 1
        for p in PROG.rglob("*"):                       # el programa
            if p.is_file() and not p.name.lower().startswith("unins"):
                add(p, p.relative_to(PROG).as_posix())
        z.writestr(f"{RAIZ}/portable.txt", "")           # Prism usa esta carpeta como datos
        z.writestr(f"{RAIZ}/prismlauncher.cfg",
                   "[General]\nAutomaticJavaDownload=true\nAutomaticJavaSwitch=true\n"
                   "IgnoreJavaWizard=true\nLanguage=es_ES\nMaxMemAlloc=4096\nMinMemAlloc=1024\n"
                   f"SelectedInstance={INST}\n")
        for sub in ("java/java-runtime-delta", "libraries", "meta"):
            for p in (DATA / sub).rglob("*"):
                if p.is_file():
                    add(p, p.relative_to(DATA).as_posix())
        add(DATA / "assets" / "indexes" / "19.json", "assets/indexes/19.json")
        for h in objetos:
            p = DATA / "assets" / "objects" / h[:2] / h
            if p.exists():
                add(p, f"assets/objects/{h[:2]}/{h}")
        ib = DATA / "instances" / INST
        for p in ib.rglob("*"):
            rel = p.relative_to(ib)
            mc = rel.parts[1:] if rel.parts[0] == ".minecraft" else ()
            if mc and (mc[0] in FUERA_MC or mc[0].startswith("XaeroWaypoints")):
                continue
            if not p.is_file():
                continue
            arc = f"instances/{INST}/{rel.as_posix()}"
            if rel.as_posix() == "instance.cfg":
                z.writestr(f"{RAIZ}/{arc}", pisar(p.read_text("utf-8"), INST_CFG, "="))
            elif rel.as_posix() == ".minecraft/options.txt":
                z.writestr(f"{RAIZ}/{arc}", pisar(p.read_text("utf-8"), MEDIO_OPC, ":"))
            elif rel.as_posix() == ".minecraft/config/iris.properties":
                z.writestr(f"{RAIZ}/{arc}", p.read_text("utf-8").replace("enableShaders=true", "enableShaders=false"))
            else:
                add(p, arc)
                continue
            n += 1
    assert not any(i.filename.endswith("accounts.json") for i in zipfile.ZipFile(out).infolist()), "accounts.json adentro"
    print(f"[ok] {out} : {n} archivos, {out.stat().st_size / 2**20:.0f} MB, sin accounts.json")


if __name__ == "__main__":
    main()
