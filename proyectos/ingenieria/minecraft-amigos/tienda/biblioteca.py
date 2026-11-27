"""L1-11: guarda en la PC una copia de CADA jar del catalogo, ordenada por familia de contenido.

  python biblioteca.py                  -> C:\\Games\\Minecraft-mods\\<familia>\\ en la PC (por SSH), con el SHA-1 verificado
  python biblioteca.py --solo-verificar -> no copia nada: solo compara la PC contra el catalogo (0 completo, 1 faltan)

Lo esperado es el catalogo entero (datos/catalogo.json + datos/locales.json), no lo que haya en el cache: un mod que
falta en el cache se baja primero (armar.al_cache, con su SHA-1). Antes (2026-11-25) se esperaba solo lo del cache y
dos mods del catalogo que no estaban ahi (crash-assistant, towns-and-towers) quedaban afuera sin que nada lo dijera.
Solo se copia lo que la PC no tiene (por SHA-1), asi que correrlo de nuevo es barato.

Los mods que no son de ninguna carta van a 'Base y rendimiento' (el nucleo) o a 'Bibliotecas y de Better MC 5'.
"""
import base64, os, subprocess, sys

import armar as A
from perfil import VERSION

LLAVE = os.path.expanduser(r"~\.ssh\pc-cable")
PC = "Fran@10.147.20.3"
# la 1.21.1 en la raiz (como estaba); la 1.21.4 en su propia carpeta: los jars de una no sirven en la otra
DESTINO = "C:/Games/Minecraft-mods" + ("" if VERSION == "1.21.1" else f"/{VERSION}")
OTRAS = "Bibliotecas y de Better MC 5" if VERSION == "1.21.1" else "Bibliotecas y del mundo con Agus"


def plan_por_familia(cat, cur):
    fam = {}
    for c in cur["cartas"]:
        for m in c["mods"]:
            fam[m] = cur["familias"][c["familia"]]
    for m in cur["nucleo"]:
        fam.setdefault(m, "Base y rendimiento")
    plan = {}
    for e in A.entradas(cat, list(cat["versiones"]), True):
        familia = OTRAS if e["slug"].startswith("local:") else fam.get(e["slug"], OTRAS)
        plan.setdefault(familia, []).append(e)
    return plan


def en_pc(cmd):
    """Todo comando a la PC va como PowerShell codificado: el SSH de la PC abre PowerShell, no cmd, y las rutas
    llevan acentos (2026-11-25: un 'if not exist ... mkdir' de cmd fallo en silencio y no se copio nada)."""
    enc = base64.b64encode(cmd.encode("utf-16-le")).decode()
    r = subprocess.run(["ssh", "-o", "ConnectTimeout=15", "-i", LLAVE, PC, f"powershell -NoProfile -EncodedCommand {enc}"],
                       capture_output=True, text=True, encoding="utf-8", errors="replace")
    if r.returncode != 0:
        raise SystemExit(f"la PC no contesta o el comando fallo (exit {r.returncode}): {r.stderr.strip()[:300]}")
    return r.stdout


def hashes_en_pc():
    out = en_pc(f"if (Test-Path '{DESTINO}') {{ Get-ChildItem '{DESTINO}' -Recurse -File -Filter *.jar | "
                f"ForEach-Object {{ (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA1).Hash }} }}")
    return {l.strip().lower() for l in out.splitlines() if len(l.strip()) == 40}


def main(argv):
    solo = "--solo-verificar" in argv
    cat, cur = A.cargar()
    plan = plan_por_familia(cat, cur)
    esperados = {e["sha1"].lower() for es in plan.values() for e in es}
    if not solo:
        hay = hashes_en_pc()
        for familia, es in sorted(plan.items()):
            nuevos = [e for e in es if e["sha1"].lower() not in hay]
            if not nuevos:
                print(f"{familia}: {len(es)} jars, ya estaban")
                continue
            rutas = [A.al_cache(e, print) for e in nuevos]
            d = f"{DESTINO}/{familia}"
            en_pc(f"New-Item -ItemType Directory -Force -Path '{d}' | Out-Null")
            r = subprocess.run(["scp", "-i", LLAVE, "-q"] + rutas + [f"{PC}:{d}/"], capture_output=True, text=True,
                               encoding="utf-8", errors="replace")
            print(f"{familia}: {len(nuevos)} de {len(es)} jars copiados {'OK' if r.returncode == 0 else 'FALLO ' + r.stderr.strip()}")
    hay = hashes_en_pc()
    faltan = esperados - hay
    print(f"biblioteca en la PC: catalogo {len(esperados)} jars; SHA-1 presentes {len(esperados & hay)}/{len(esperados)}"
          + (f"; FALTAN {len(faltan)}" if faltan else ""))
    for familia, es in sorted(plan.items()):
        for e in es:
            if e["sha1"].lower() in faltan:
                print(f"  falta: {familia} / {e['archivo']}")
    return 1 if faltan else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
