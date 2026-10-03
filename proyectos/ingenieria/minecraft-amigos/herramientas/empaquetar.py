"""Empaqueta la instancia de Prism para los amigos: zip + instalador en una carpeta.

Uso: python empaquetar.py <instancia> <carpeta salida> <carpeta del instalador en el repo>
Saca lo que es personal o cache: mundos, mapas de Xaero, logs, capturas, cache de Fabric.
"""
import shutil
import sys
import zipfile
from pathlib import Path

FUERA = {"saves", "xaero", ".fabric", "logs", "crash-reports", "screenshots", ".cache",
         "debug", "downloads", "moddata", "command_history.txt"}


def main():
    inst, salida, instalador = map(Path, sys.argv[1:4])
    salida.mkdir(parents=True, exist_ok=True)
    zpath = salida / "juntada-1.21.4.zip"
    n = 0
    with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as z:
        for p in inst.rglob("*"):
            rel = p.relative_to(inst)
            partes = rel.parts
            mc = partes[1:] if partes and partes[0] == ".minecraft" else ()
            if mc and (mc[0] in FUERA or mc[0].startswith("XaeroWaypoints")):
                continue
            if p.is_file():
                z.write(p, rel.as_posix())
                n += 1
    for f in ("instalar-juntada.bat", "instalar-juntada.ps1", "LEEME.txt"):
        if (instalador / f).exists():
            shutil.copy2(instalador / f, salida / f)
    print(f"[ok] {zpath} : {n} archivos, {zpath.stat().st_size / 2**20:.0f} MB")


if __name__ == "__main__":
    main()
