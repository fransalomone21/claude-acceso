#!/usr/bin/env python3
"""probar-da054.py -- el saboteador de DA-054: arquitectura-se tiene senal FUERTE en el catalogo (2026-10-12 noche).

Sin senal propia, el vocabulario de otro proyecto en un pedido del metodo no cedia: un retome con 'puntero' entraba
frenado por software-de-vuelo. Requisito: L1-03 de docs/10-requisitos.md (la puerta niega entre el 0 % y el 5 % de
las decisiones). Corre sobre el catalogo REAL (.claude/cascada.json) con inferidos_de de la puerta:

  (a) el retome del metodo con 'puntero' infiere arquitectura-se por FUERTE y software-de-vuelo CEDE;
  (b) CONTROL: un pedido de apunte con 'el metodo de Hohmann' NO infiere arquitectura-se (la senal no se come
      la palabra suelta 'metodo');
  (c) CONTROL: un ejercicio de C sin nombrar materia sigue infiriendo software-de-vuelo (el caso 331 vive);
  (m) MUTANTE: el mismo catalogo sin las senales de arquitectura-se tiene que hacer fallar (a).

Sale 0 si (a)-(c) pasan y el mutante se ve; 1 si algo falla o el mutante pasa (la prueba esta ciega).
Uso:  python proyectos/ingenieria/arquitectura-se/probar-da054.py
"""
import copy
import json
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(RAIZ / ".claude" / "hooks"))
import cascada_puerta as cp  # noqa: E402

RETOME = "Retomo el MÉTODO (proyectos/ingenieria/arquitectura-se): un ROJO se arregla en la copia (puntero o fecha)"
APUNTE = "en fisica espacial explicame el metodo de Hohmann para el parcialito"
EJERCICIO_C = "explicame punteros en C con un ejercicio"


def caso_a(cat) -> bool:
    inf, ced = cp.inferidos_de(cat, RETOME)
    return ("arquitectura-se", False) in [(p, d) for p, _, d in inf] and \
        ("software-de-vuelo", "arquitectura-se") in [(p, o) for p, _, o in ced]


def main() -> int:
    cat = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    mal = 0
    for nombre, ok in (
            ("(a) retome con 'puntero': arquitectura-se fuerte, software-de-vuelo cede", caso_a(cat)),
            ("(b) CONTROL: 'el metodo de Hohmann' no infiere arquitectura-se",
             "arquitectura-se" not in [p for p, _, _ in cp.inferidos_de(cat, APUNTE)[0]]),
            ("(c) CONTROL: ejercicio de C suelto sigue en software-de-vuelo",
             "software-de-vuelo" in [p for p, _, _ in cp.inferidos_de(cat, EJERCICIO_C)[0]])):
        mal += not ok
        print("%s  %s" % ("ok " if ok else "MAL", nombre))
    mut = copy.deepcopy(cat)
    mut["proyectos"]["arquitectura-se"].pop("senales", None)
    visto = not caso_a(mut)
    mal += not visto
    print("%s  (m) MUTANTE sin la senal de arquitectura-se: (a) %s" % ("ok " if visto else "MAL",
                                                                     "falla, lo ve" if visto else "PASA IGUAL: ciega"))
    print("probar-da054: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
