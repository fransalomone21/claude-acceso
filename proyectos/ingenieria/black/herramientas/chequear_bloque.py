import json, sys
sys.path.insert(0, r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas")
from pine import Pine
from mips import ensamblar
import coop_mod as c
import pantalla_dividida as pd
progs = dict(c.programas())
with Pine() as p:
    malos = [(nombre, hex(pc), hex(p.leer32(pc)), hex(w)) for nombre, prog in progs.items()
             for pc, w, _ in prog if p.leer32(pc) != w]
    print(json.dumps({"palabras": sum(len(x) for x in progs.values()), "distintas": malos[:12],
                      "gancho_filtro": hex(p.leer32(pd.SITIO_FILTRO)), "flag_3C": p.leer32(pd.DATOS + 0x3C),
                      "prop_38": p.leer32(pd.DATOS + 0x38), "llamadas": p.leer32(pd.DATOS + 0x88)}))
