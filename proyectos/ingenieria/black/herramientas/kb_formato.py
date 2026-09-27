#!/usr/bin/env python3
"""kb_formato.py -- escribe kb/subsistemas.json en SU formato (un subsistema por linea).

`json.dump(..., indent=2)` reformatea el archivo entero y deja un diff de
cientos de lineas donde cambio una: paso en (63) con conceptos.json y otra vez
en (78). Este modulo tiene el formato; `verificar` comprueba que reproduce HEAD
byte a byte (su control positivo).

    from kb_formato import volcar          # volcar(dict) -> str
    python herramientas/kb_formato.py verificar
"""

import json
import subprocess
import sys


def volcar(d: dict) -> str:
    out = ["{"]
    ks = list(d.keys())
    for n, k in enumerate(ks):
        coma = "," if n < len(ks) - 1 else ""
        if k == "subsistemas":
            out.append('  "subsistemas": [')
            lista = d[k]
            for i, x in enumerate(lista):
                out.append("    " + json.dumps(x, ensure_ascii=False) + ("," if i < len(lista) - 1 else ""))
            out.append("  ]" + coma)
        else:
            v = json.dumps(d[k], ensure_ascii=False, indent=2).replace("\n", "\n  ")
            out.append("  " + json.dumps(k) + ": " + v + coma)
    out.append("}")
    return "\n".join(out) + "\n"


def main() -> int:
    if sys.argv[1:] != ["verificar"]:
        print(__doc__)
        return 2
    orig = subprocess.run(["git", "show", "HEAD:./kb/subsistemas.json"], capture_output=True).stdout.decode("utf-8")
    ok = volcar(json.loads(orig)) == orig.replace("\r\n", "\n")
    print("reproduce HEAD:", ok)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
