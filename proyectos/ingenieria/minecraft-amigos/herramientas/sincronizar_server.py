"""Deja la carpeta mods de un server con los jars de servidor de una instancia.

Uso: python sincronizar_server.py <instancia de Prism> <carpeta del server> <manifiesto.json>

Copia de la instancia todo jar cuyo 'servidor' en el manifiesto no sea 'unsupported'.
Los jars del server que NO estan en el manifiesto se mueven a mods_viejos/ (no se borran).
Con el server apagado: un jar en uso no se puede pisar.
"""
import json
import shutil
import sys
from pathlib import Path


def main():
    inst, srv, man = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
    mods_cli = inst / ".minecraft" / "mods"
    mods_srv = srv / "mods"
    mods_srv.mkdir(exist_ok=True)
    filas = json.loads(man.read_text("utf-8"))["mods"]
    quiero = {f["archivo"] for f in filas if f["servidor"] != "unsupported"}
    faltan = [a for a in quiero if not (mods_cli / a).exists()]
    if faltan:
        sys.exit(f"[ROJO] la instancia no tiene: {faltan}")
    viejos = srv / "mods_viejos"
    movidos = 0
    for j in mods_srv.glob("*.jar"):
        if j.name not in quiero:
            viejos.mkdir(exist_ok=True)
            shutil.move(str(j), viejos / j.name)
            movidos += 1
    nuevos = 0
    for a in sorted(quiero):
        if not (mods_srv / a).exists():
            shutil.copy2(mods_cli / a, mods_srv / a)
            nuevos += 1
    total = len(list(mods_srv.glob("*.jar")))
    print(f"[ok] server con {total} mods (esperados {len(quiero)}); +{nuevos} nuevos, {movidos} a mods_viejos/")
    if total != len(quiero):
        sys.exit("[ROJO] la cuenta no coincide")


if __name__ == "__main__":
    main()
