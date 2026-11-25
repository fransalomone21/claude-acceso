"""Prueba en el server de prueba de la tienda una seleccion SIN publicar (lo publicado no se toca).
  python mc_probar_nuevas.py nuevas            -> todas las cartas nuevas juntas
  python mc_probar_nuevas.py combo:<id>        -> una combinacion
  python mc_probar_nuevas.py cartas:a,b,c      -> esas cartas
"""
import hashlib, json, os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import armar as A

NUEVAS = None
pub = os.path.join(A.PUBLICADO, "lista.json")
antes = hashlib.sha1(open(pub, "rb").read()).hexdigest() if os.path.exists(pub) else None
cat, cur = A.cargar()
arg = sys.argv[1]
combo, cartas = None, []
if arg == "nuevas":
    viejas = set(json.load(open(sys.argv[2], encoding="utf-8"))) if len(sys.argv) > 2 else set()
    cartas = [c["id"] for c in cur["cartas"] if c["id"] not in viejas]
elif arg.startswith("combo:"):
    combo = arg[6:]
else:
    cartas = arg[7:].split(",")
n, slugs, todo = A.resolver(cat, cur, cartas, combo)
es = A.entradas(cat, slugs, todo)
print(f"seleccion: {len(cartas) or combo} -> {len(es)} mods ({sum(e['bytes'] for e in es) / 1e6:.0f} MB)", flush=True)
for e in es:
    A.al_cache(e, lambda m: None)
ok, motivo = A.probar(es, lambda m: print(m, flush=True), tope=900)
despues = hashlib.sha1(open(pub, "rb").read()).hexdigest() if os.path.exists(pub) else None
print(f"RESULTADO: {'ARRANCO' if ok else 'NO ARRANCO: ' + motivo}; publicado {'igual' if antes == despues else 'CAMBIO'}")
