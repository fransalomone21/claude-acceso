"""Que cada .ps1 de lanzadores/ PARSEE en PowerShell 5.1 (BLACK (138)).

Por que existe: MISION.ps1 llego a main con "$Puerto:" adentro de un string (PS lo lee como unidad de disco) y no
corrio NUNCA; se vio recien al usarlo. Un lanzador que no parsea falla entero y en silencio hasta que alguien lo
abre. Este control lo ve antes, con el parser del propio PowerShell (no con un regex que adivine).

    python pruebas/parsear-lanzadores.py            # el control (sale 1 si alguno no parsea)
    python pruebas/parsear-lanzadores.py --sabotaje # rojo con un .ps1 roto a proposito, verde con uno sano

Sin powershell.exe (la nube, Linux) dice SALTEADO con el motivo y sale 0: el objeto que mide no esta aca.
"""
import os
import shutil
import subprocess
import sys
import tempfile

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LANZADORES = os.path.join(RAIZ, "lanzadores")

# El parser de PS recibe la carpeta y devuelve una linea por archivo con error: "ARCHIVO<TAB>n<TAB>mensaje".
SCRIPT = (
    "$ErrorActionPreference='Continue'; $n=0; "
    "Get-ChildItem -LiteralPath $env:PARSEAR_DIR -Filter *.ps1 -Recurse | ForEach-Object { $n++; $e=$null; "
    "[void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName,[ref]$null,[ref]$e); "
    "if ($e) { '{0}{3}{1}{3}{2}' -f $_.Name,$e.Count,$e[0].Message,[char]9 } }; 'CONTADOS' + [char]9 + $n"
)


def parsear(carpeta):
    """Devuelve (contados, [(archivo, n_errores, mensaje)]) o None si no hay powershell."""
    ps = shutil.which("powershell.exe") or shutil.which("powershell")
    if not ps:
        return None
    env = dict(os.environ, PARSEAR_DIR=carpeta)
    r = subprocess.run([ps, "-NoProfile", "-NonInteractive", "-Command", SCRIPT],
                       capture_output=True, text=True, errors="replace", env=env)
    malos, contados = [], -1
    for linea in r.stdout.splitlines():
        partes = linea.strip().split("\t")
        if partes[0] == "CONTADOS" and len(partes) == 2:
            contados = int(partes[1])
        elif len(partes) == 3:
            malos.append((partes[0], partes[1], partes[2]))
    return contados, malos


def control():
    res = parsear(LANZADORES)
    if res is None:
        print("SALTEADO: no hay powershell.exe en esta maquina (los lanzadores son de Windows)")
        return 0
    contados, malos = res
    if contados <= 0:
        print("MAL: el parser no conto ningun .ps1 en %s (el control no llego a medir)" % LANZADORES)
        return 1
    for nombre, n, msg in malos:
        print("MAL %s: %s error(es) de sintaxis -- %s" % (nombre, n, msg))
    print("lanzadores: %d .ps1, %d sin parsear" % (contados, len(malos)))
    return 1 if malos else 0


def sabotaje():
    """Rojo con un .ps1 roto (el caso real de MISION.ps1) y verde con su version arreglada."""
    if parsear(LANZADORES) is None:
        print("SALTEADO: no hay powershell.exe")
        return 0
    ok = True
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "roto.ps1")
        # armado por partes: la forma rota no aparece literal en este archivo
        var = "$" + "Puerto"
        with open(p, "w", encoding="utf-8") as f:
            f.write('param([int]%s = 1)\nWrite-Host "no contesta en %s: abrilo"\n' % (var, var))
        contados, malos = parsear(d)
        visto = contados == 1 and len(malos) == 1 and malos[0][0] == "roto.ps1"
        print("%s sabotaje: variable pegada a ':' -> %s" % ("ok " if visto else "MAL", malos or "no lo vio"))
        ok &= visto
        with open(p, "w", encoding="utf-8") as f:
            f.write('param([int]%s = 1)\nWrite-Host "no contesta en ${%s}: abrilo"\n' % (var, "Puerto"))
        contados, malos = parsear(d)
        sano = contados == 1 and not malos
        print("%s control positivo: la misma linea con ${} -> %s" % ("ok " if sano else "MAL", malos or "parsea"))
        ok &= sano
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(sabotaje() if "--sabotaje" in sys.argv else control())
