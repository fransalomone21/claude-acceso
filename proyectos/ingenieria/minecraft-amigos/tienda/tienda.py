"""La tienda: pagina local para tildar mods o elegir una combinacion, y el pack publicado que leen las instancias.

  python tienda.py            -> http://localhost:8765  (desde la PC o Kevin: http://10.147.20.2:8765)
  /               la pagina
  /api/catalogo   cartas, familias, combinaciones y lo publicado
  /api/armar      POST {"combo": id} o {"cartas": [...], "nombre": "..."}: resuelve, prueba y publica
  /api/estado     el avance del armado en curso
  /pack/...       lo publicado (lista.json y los jars que no estan en Modrinth)
"""
import json, math, os, sys, threading
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler

import armar as A
from perfil import P, PERFILES, VERSION

PUERTO = P["puerto_web"]   # 8765 la 1.21.1, 8766 la 1.21.4 (TIENDA_VERSION=1.21.4)
WEB = os.path.join(A.AQUI, "web")
_estado = {"ocupado": False, "log": [], "resultado": None}
_lock = threading.Lock()


def memoria_gb(es):
    """Estimada, calibrada con la recomendacion de Better MC 5 (269 mods -> 8 GB)."""
    mb = sum(e["bytes"] for e in es) / 1e6
    return max(4, math.ceil(2.5 + len(es) * 0.0155 + mb * 0.004))


def catalogo():
    cat, cur = A.cargar()
    cartas = []
    for c in cur["cartas"]:
        ps = [cat["proyectos"][m] for m in c["mods"]]
        mb = sum(cat["versiones"][m]["bytes"] for m in c["mods"]) / 1e6
        # 2 o 3 fotos del mod (las que el autor eligio en Modrinth): primero las del mod principal de la carta
        fotos = []
        for p in ps:
            fotos += [u for u in p.get("galeria", []) if u not in fotos]
        cartas.append({"id": c["id"], "nombre": c["nombre"], "familia": c["familia"], "sub": c.get("sub"), "desc": c["desc"],
                       "fotos": fotos[:3],
                       "icono": next((p["icono"] for p in ps if p.get("icono")), None), "mods": len(c["mods"]),
                       "mb": round(mb, 1), "peso": "liviano" if mb < 10 else ("medio" if mb < 40 else "pesado")})
    combos = []
    for c in cur["combos"]:
        n, slugs, todo = A.resolver(cat, cur, combo=c["id"])
        es = A.entradas(cat, slugs, todo)
        combos.append({"id": c["id"], "nombre": c["nombre"], "desc": c["desc"], "cartas": c["cartas"],
                       "recomendada": bool(c.get("recomendada")), "todo_bmc5": bool(c.get("todo_bmc5")),
                       "mods_total": len(es), "memoria_gb": memoria_gb(es)})
    pub = os.path.join(A.PUBLICADO, "lista.json")
    publicado = None
    if os.path.exists(pub):
        d = json.load(open(pub, encoding="utf-8"))
        publicado = {"nombre": d["nombre"], "combo": d.get("combo"), "publicado": d["publicado"], "mods": len(d["mods"])}
    otras = [{"version": v, "nombre": p["nombre"], "puerto": p["puerto_web"]} for v, p in PERFILES.items() if v != VERSION]
    return {"version": VERSION, "version_nombre": P["nombre"], "otras": otras, "instancia": P["instancia"],
            "base_nombre": cur.get("base_nombre", "Better MC 5 entero (sin estaciones)"), "familias": cur["familias"], "subfamilias": cur.get("subfamilias", {}), "cartas": cartas, "combos": combos,
            "publicado": publicado,
            "nucleo": len(cur["nucleo"])}


def _trabajo(pedido):
    def log(m):
        with _lock:
            _estado["log"].append(m)
    try:
        r = A.armar(cartas=pedido.get("cartas", []), combo=pedido.get("combo"), nombre=pedido.get("nombre"), log=log)
    except Exception as e:   # cualquier rotura del armado es un no-publicado, nunca un publicado a medias
        log(f"ERROR: {e}")
        r = {"ok": False, "motivo": str(e)}
    with _lock:
        _estado["resultado"], _estado["ocupado"] = r, False


class H(SimpleHTTPRequestHandler):
    def __init__(self, *a, **k):
        super().__init__(*a, directory=WEB, **k)

    def log_message(self, *a):
        pass

    def _json(self, obj, code=200):
        b = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(b)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(b)

    def translate_path(self, path):
        if path.startswith("/pack/"):
            rel = path[len("/pack/"):].split("?")[0]
            ruta = os.path.normpath(os.path.join(A.PUBLICADO, rel))
            return ruta if ruta.startswith(os.path.normpath(A.PUBLICADO)) else A.PUBLICADO
        return super().translate_path(path)

    def do_GET(self):
        if self.path.startswith("/api/catalogo"):
            return self._json(catalogo())
        if self.path.startswith("/api/estado"):
            with _lock:
                return self._json(dict(_estado))
        return super().do_GET()

    def do_POST(self):
        if not self.path.startswith("/api/armar"):
            return self._json({"error": "no existe"}, 404)
        n = int(self.headers.get("Content-Length", 0))
        pedido = json.loads(self.rfile.read(n) or b"{}")
        with _lock:
            if _estado["ocupado"]:
                return self._json({"error": "ya hay un armado en curso"}, 409)
            _estado.update(ocupado=True, log=[], resultado=None)
        threading.Thread(target=_trabajo, args=(pedido,), daemon=True).start()
        return self._json({"ok": True}, 202)


if __name__ == "__main__":
    puerto = int(sys.argv[1]) if len(sys.argv) > 1 else PUERTO
    print(f"Tienda de mods {P['nombre']} en http://localhost:{puerto}  (desde otra maquina: http://10.147.20.2:{puerto})")
    ThreadingHTTPServer(("0.0.0.0", puerto), H).serve_forever()
