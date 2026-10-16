"""Saboteador de T17 en el verificador (L2-VER-03): la puerta desenganchada de los conectores tiene que dar ROJO.

Los casos de la puerta (L2-PTA-07..17) y sus cuatro mutantes viven en el autotest de la puerta (caso 19), que ya corre
chequeo-completo. Este cubre la otra forma de fallar: DEJAR DE ACTUAR (Leveson), que es un registro de hooks sin el
matcher de los conectores. Mide el EFECTO del matcher (si atrapa un nombre real de conector), no que el texto este.
Diseno: docs/t17-conectores-bajo-la-puerta.md.

    python proyectos/ingenieria/arquitectura-se/probar-t17.py      sale 0 si cada caso da lo que tiene que dar
"""
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
PUERTA = RAIZ / ".claude" / "hooks" / "cascada_puerta.py"
REG = RAIZ / ".claude" / "settings.json"
MARCA = "los CONECTORES no pasan por la puerta"


def verificar(settings: Path) -> str:
    """'ROJO' (la marca de T17), 'verde' (sin la marca) o 'REVENTO': tres resultados, no dos."""
    r = subprocess.run([sys.executable, str(PUERTA), "--verificar"], capture_output=True, cwd=str(RAIZ),
                       env=dict(os.environ, CASCADA_SETTINGS=str(settings)))
    out = r.stdout.decode("utf-8", "replace")
    if "cascada.json:" not in out:
        return "REVENTO"
    return "ROJO" if MARCA in out else "verde"


def con_matcher(f: Path, cambiar) -> Path:
    d = json.loads(REG.read_text(encoding="utf-8-sig"))
    for x in d["hooks"]["PreToolUse"]:
        if "puerta-lanzador.py" in json.dumps(x):
            x["matcher"] = cambiar(x["matcher"])
    f.write_text(json.dumps(d), encoding="utf-8")
    return f


def main() -> int:
    tmp = Path(tempfile.mkdtemp(prefix="probar-t17-"))
    sin = lambda m: "|".join(p for p in m.split("|") if not p.startswith("mcp__"))   # noqa: E731
    casos = (
        ("CONTROL: el registro real -> verde", REG, "verde"),
        ("SABOTAJE: sin el matcher de los conectores -> ROJO", con_matcher(tmp / "sin.json", sin), "ROJO"),
        ("SABOTAJE: matcher que NO atrapa un id real (mcp__drive__.*) -> ROJO",
         con_matcher(tmp / "malo.json", lambda m: sin(m) + "|mcp__drive__.*"), "ROJO"),
        ("CONTROL: matcher minimo que atrapa (mcp__.*) -> verde",
         con_matcher(tmp / "amplio.json", lambda m: sin(m) + "|mcp__.*"), "verde"),
    )
    mal = 0
    for nombre, f, espera in casos:
        r = verificar(f)
        mal += r != espera
        print("%s  %-66s -> %s" % ("ok " if r == espera else "MAL", nombre, r))
    print("probar-t17: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
