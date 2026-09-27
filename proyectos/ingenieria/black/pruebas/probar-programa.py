"""Saboteador de programa.py verificar: rompe cada traza y exige ver el rojo.

    python pruebas/probar-programa.py

Control positivo: sobre los archivos reales, verificar sale 0.
Cinco sabotajes, cada uno sobre una COPIA en un directorio temporal:
un NGO inexistente, un habilitador fuera del mapa, un K1 sin sonda, el
catalogo editado a mano, y pesos sin fuente. Cada uno tiene que salir 1.
Y 'trade' sin pesos tiene que salir 2.
"""
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
PROG = RAIZ / "herramientas" / "programa.py"


def correr(raiz, accion="verificar"):
    r = subprocess.run([sys.executable, str(PROG), accion, "--raiz", str(raiz)],
                       capture_output=True, text=True)
    return r.returncode


def copia():
    d = Path(tempfile.mkdtemp(prefix="probar-programa-"))
    (d / "kb").mkdir()
    (d / "docs").mkdir()
    for f in ("subsistemas.json", "conceptos.json"):
        shutil.copy(RAIZ / "kb" / f, d / "kb" / f)
    shutil.copy(RAIZ / "docs" / "12-catalogo.md", d / "docs" / "12-catalogo.md")
    return d


def editar_json(d, archivo, fn):
    p = d / "kb" / archivo
    x = json.load(open(p, encoding="utf-8"))
    fn(x)
    json.dump(x, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=1)


def main():
    fallas = 0
    rc = correr(RAIZ)
    print(f"control positivo (archivos reales)      : sale {rc}  {'OK' if rc == 0 else 'FALLA'}")
    fallas += rc != 0

    def ngo_falso(c):
        next(x for x in c["conceptos"] if x.get("estado", "candidato") == "candidato")["ngos"] = ["N99"]

    def habilitador_falso(c):
        next(x for x in c["conceptos"] if x.get("estado", "candidato") == "candidato")["habilitadores"].append("no-existe")

    def k1_sin_sonda(s):
        x = next(x for x in s["subsistemas"] if x["k"] <= 1)
        x.pop("sonda", None)

    def pesos_sin_fuente(c):
        c["pesos"] = {"C1": 50, "C2": 50}

    casos = [
        ("NGO inexistente", "conceptos.json", ngo_falso),
        ("habilitador fuera del mapa", "conceptos.json", habilitador_falso),
        ("K1 sin sonda", "subsistemas.json", k1_sin_sonda),
        ("pesos sin fuente", "conceptos.json", pesos_sin_fuente),
    ]
    for nombre, archivo, fn in casos:
        d = copia()
        editar_json(d, archivo, fn)
        if archivo == "conceptos.json" or archivo == "subsistemas.json":
            # regenerar el catalogo de la copia: el sabotaje tiene que caer por SU regla,
            # no por el catalogo desactualizado
            subprocess.run([sys.executable, str(PROG), "catalogo", "--raiz", str(d)], capture_output=True)
        rc = correr(d)
        print(f"sabotaje: {nombre:<30}: sale {rc}  {'OK' if rc == 1 else 'FALLA'}")
        fallas += rc != 1
        shutil.rmtree(d, ignore_errors=True)
    d = copia()
    p = d / "docs" / "12-catalogo.md"
    p.write_text(p.read_text(encoding="utf-8") + "\nuna linea escrita a mano\n", encoding="utf-8")
    rc = correr(d)
    print(f"sabotaje: {'catalogo editado a mano':<30}: sale {rc}  {'OK' if rc == 1 else 'FALLA'}")
    fallas += rc != 1
    rc = correr(d, "trade")
    print(f"trade sin pesos del interesado          : sale {rc}  {'OK' if rc == 2 else 'FALLA'}")
    fallas += rc != 2
    # un habilitador en K0 tiene que contar como freno (el K0 es falsy en Python:
    # 'k or 9' lo tragaba y el coop, que depende de la camara en K0, no aparecia)
    r = subprocess.run([sys.executable, str(PROG), "resumen", "--raiz", str(RAIZ)],
                       capture_output=True, text=True)
    ok = "M1" in r.stdout.split("frenados")[-1]
    print(f"resumen: M1 (camara en K0) cuenta como frenado: {'OK' if ok else 'FALLA'}")
    fallas += not ok
    shutil.rmtree(d, ignore_errors=True)
    print("TODO EN ROJO DONDE TENIA QUE ESTARLO" if fallas == 0 else f"{fallas} FALLAS")
    return 1 if fallas else 0


if __name__ == "__main__":
    sys.exit(main())
