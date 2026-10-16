"""Saboteador de T16 (L2-MVR-02, L2-MVR-04, L2-MVR-07): tres mutantes de matriz-verificacion.py, cada uno visto en SU
caso del autotest. Un autotest que sale BIEN al primer intento no prueba nada hasta que un medidor roto lo pone en rojo.

    python proyectos/ingenieria/arquitectura-se/probar-t16.py      sale 0 si el original pasa y cada mutante cae

Cada mutante exige que su reemplazo APLIQUE (si el texto cambio, el sabotaje no sabotea: NO APLICA es MAL) y que el
autotest lo marque MAL en el caso de su requisito -- no un MAL cualquiera, ni un REVENTO.
"""
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
MEDIDOR = RAIZ / "matriz-verificacion.py"

MUTANTES = (
    ("todo como analisis", "L2-MVR-02",
     'grado = "verificado" if reqs[i]["metodo"] == "analisis" else "predicho"', 'grado = "verificado"'),
    ("sin el chequeo de ID", "L2-MVR-04",
     'rojos.append("la prueba \'%s\' informa %s, que NO existe en %s (L2-MVR-04)" % (cmd, i, entrada["requisitos"]))',
     "pass"),
    ("ignora el codigo de salida", "L2-MVR-07",
     "if p.returncode != 0:                 # MVR-07", "if False:                 # MVR-07"),
)


def veredicto(script: Path, caso: str) -> str:
    p = subprocess.run([sys.executable, str(script), "--autotest"], capture_output=True, text=True,
                       encoding="utf-8", errors="replace", cwd=str(RAIZ))
    if "REVENTO" in p.stdout or p.returncode not in (0, 1):
        return "REVENTO"
    linea = next((l for l in p.stdout.splitlines() if caso in l), "")
    return "MAL" if linea.startswith("MAL") else ("ok" if linea.startswith("ok") else "SIN CASO")


def main() -> int:
    fuente = MEDIDOR.read_text(encoding="utf-8")
    malos = 0
    orig = subprocess.run([sys.executable, str(MEDIDOR), "--autotest"], capture_output=True, text=True,
                          encoding="utf-8", errors="replace").returncode
    print("%s  original: autotest %s" % ("ok " if orig == 0 else "MAL", "BIEN" if orig == 0 else "con MAL"))
    malos += orig != 0
    for n, (nombre, caso, viejo, nuevo) in enumerate(MUTANTES):
        if fuente.count(viejo) != 1:
            print("MAL  mutante (%s): NO APLICA, el texto cambio (%d apariciones)" % (nombre, fuente.count(viejo)))
            malos += 1
            continue
        m = RAIZ / ("_mutante_t16_%d.py" % n)
        try:
            m.write_text(fuente.replace(viejo, nuevo), encoding="utf-8")
            v = veredicto(m, caso)
        finally:
            m.unlink(missing_ok=True)
        print("%s  mutante (%s) -> %s en %s" % ("ok " if v == "MAL" else "MAL", nombre, "lo ve" if v == "MAL" else v, caso))
        malos += v != "MAL"
    print("probar-t16: %s" % ("BIEN" if not malos else "%d MAL" % malos))
    return 1 if malos else 0


if __name__ == "__main__":
    sys.exit(main())
