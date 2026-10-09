#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-clon-comparte.py -- (124) el saboteador de herramientas/clon_comparte.py: el autotest tiene que dar VERDE
tal cual y ROJO (rc=1, no 2) con cada control dado vuelta. Tres resultados: verde, rojo, y revento (rc=2/excepcion)."""
import contextlib
import io
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "herramientas"))
import clon_comparte as cc  # noqa: E402


def correr(**cambios):
    viejo = {k: getattr(cc, k) for k in cambios}
    for k, v in cambios.items():
        setattr(cc, k, v)
    try:
        with contextlib.redirect_stdout(io.StringIO()) as f:
            rc = cc.autotest()
    except Exception as e:  # noqa: BLE001
        return "REVENTO", repr(e)
    finally:
        for k, v in viejo.items():
            setattr(cc, k, v)
    return rc, f.getvalue().strip().splitlines()[-1]


casos = [("tal cual", {}, 0),
         ("positivo dado vuelta (pide compartido el arma en la mano)", {"POS_COMPARTIDO": 0x2A4}, 1),
         ("negativo dado vuelta (prohibe compartido el soporte)", {"NEG_DISTINTO": 0x328}, 1)]
mal = 0
for nombre, cambios, esperado in casos:
    rc, linea = correr(**cambios)
    ok = rc == esperado
    mal += not ok
    print("%s  %-58s rc=%s  (%s)" % ("ok  " if ok else "MAL ", nombre, rc, linea))
print("probar-clon-comparte: " + ("TODO BIEN" if not mal else "%d MAL" % mal))
sys.exit(1 if mal else 0)
