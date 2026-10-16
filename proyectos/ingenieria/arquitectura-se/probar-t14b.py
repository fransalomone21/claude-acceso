"""Saboteador de T14b en la auditoria (L2-AUD-02): dos mutantes de auditar-sesion.py, cada uno visto en SU caso.

Los mutantes de la puerta (L2-PTA-05, L2-PTA-06) viven en el autotest de la puerta (caso 18), que ya corre
chequeo-completo. Este cubre la otra mitad: la auditoria. Diseno: docs/t14b-mencionar-no-es-pedir.md.

    python proyectos/ingenieria/arquitectura-se/probar-t14b.py      sale 0 si el original pasa y cada mutante cae
"""
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
AUD = RAIZ / "auditar-sesion.py"
CASO = "T14b: una MENCION sola"
MUTANTES = (
    ("la mencion cuenta como excepcion",
     'excs = [e for e in evs if e.get("t") == "excepcion"]',
     'excs = [e for e in evs if e.get("t") in ("excepcion", "mencion")]'),
    ("la mencion no se nombra en P5",
     'mencs = [e for e in evs if e.get("t") == "mencion"]', 'mencs = []'),
)


def caso_t14b(script: Path) -> str:
    """'ok', 'MAL' o 'FALTA' (el caso no corrio): tres resultados, no dos."""
    r = subprocess.run([sys.executable, str(script), "--autotest"], capture_output=True, cwd=str(RAIZ))
    linea = [l for l in r.stdout.decode("utf-8", "replace").splitlines() if CASO in l]
    return linea[0][:3].strip() if linea else "FALTA"


def main() -> int:
    mal = 0
    orig = caso_t14b(AUD)
    print("%s  original: el caso T14b pasa -> %s" % ("ok " if orig == "ok" else "MAL", orig))
    mal += orig != "ok"
    fuente = AUD.read_text(encoding="utf-8")
    for n, (nombre, viejo, nuevo) in enumerate(MUTANTES):
        if viejo not in fuente:
            print("MAL  mutante (%s): NO APLICA, el texto cambio" % nombre)
            mal += 1
            continue
        # al lado del original: la auditoria importa la puerta por ruta relativa a la raiz
        m = RAIZ / ("_mutante_t14b_%d.py" % n)
        m.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
        try:
            v = caso_t14b(m)
        finally:
            m.unlink()
        print("%s  mutante (%s) -> %s" % ("ok " if v == "MAL" else "MAL", nombre, "lo ve" if v == "MAL" else v))
        mal += v != "MAL"
    print("probar-t14b: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
