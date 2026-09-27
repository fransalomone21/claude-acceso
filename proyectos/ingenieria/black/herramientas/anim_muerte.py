"""Vigilante de LECTURA (break) sobre 0x0040D9A3 mientras matar_sin_manos.py mata a un enemigo.
En 0x0011CBDC (FUN_0011ca28, despues de elegir la animacion) s0 = ranura: se lee
ranura+0x4B4. Los disparos en 0x0011C948 (FUN_0011c930, uno por cuadro) se saltean.
Uso: python herramientas/anim_muerte.py <enemigo_hex> <bandera> [segundos]"""
import json, subprocess, sys, time
from pathlib import Path
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent))
from depurador import Depurador
from pine import Pine
if "--help" in sys.argv or len(sys.argv) < 3:
    print(__doc__)
    sys.exit(0)

E, BANDERA = sys.argv[1], sys.argv[2]
LIMITE = float(sys.argv[3]) if len(sys.argv) > 3 else 90
MATAR = str(Path(__file__).with_name("matar_sin_manos.py"))
hits, otros = [], {}
with Depurador() as d:
    if not d.estado().get("paused"):
        d.pausar()
        d.esperar_pausa(segundos=5)
    d.poner_vigilante(0x0040D9A3, tipo="read", accion="break", descripcion="anim")
    d.continuar()
    proc = subprocess.Popen([sys.executable, MATAR, E, BANDERA], stdout=subprocess.PIPE, text=True)
    t0 = time.time()
    try:
        while time.time() - t0 < LIMITE:
            e = d.esperar_pausa(segundos=2, intervalo=0.01)
            if not e:
                if proc.poll() is not None:
                    break
                continue
            pc = e.get("pc")
            pc = pc if isinstance(pc, int) else int(str(pc), 0)
            if pc != 0x0011C948:
                r = d.registros(0)
                try:
                    regs = {x["name"]: int(x["value"][-8:], 16) for x in r["GPR"]["regs"]}
                    s0 = regs["s0"]
                except Exception:
                    hits.append({"pc": hex(pc), "registros_crudos": str(r)[:1500]})
                    d.continuar()
                    continue
                with Pine() as p:
                    h = {"pc": hex(pc), "s0": hex(s0), "t": round(time.time() - t0, 2)}
                    if pc == 0x0011CBDC:
                        h.update({"anim_4B4": p.leer32(s0 + 0x4B4), "tirador_D8": hex(p.leer32(s0 + 0xD8)),
                                  "dist_C4": round(p.leer_f32(s0 + 0xC4), 2),
                                  "arma_id_tirador": p.leer8(p.leer32(p.leer32(s0 + 0xD8) + 0x2A4))
                                  if p.leer32(s0 + 0xD8) else None})
                    hits.append(h)
            else:
                otros[hex(pc)] = otros.get(hex(pc), 0) + 1
            d.continuar()
    finally:
        d.quitar_vigilante(0x0040D9A3)
        if d.estado().get("paused"):
            d.continuar()
    salida = proc.communicate(timeout=60)[0].strip()
print(json.dumps({"hits": hits, "otros": otros, "matar": json.loads(salida) if salida else None},
                 ensure_ascii=False))
