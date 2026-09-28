"""(93g) B5 -- la maquina de estados del controlador de jugador, en vivo, para J y J2. Lanza el fork con el
bloque del pnach (campana_coop.lanzar), carga City Streets, espera el juego y lee, para P en {J, J2}:
ctrl = *(P+0x32C), tipo ctrl+0x80, vtable ctrl+0x84, indice ctrl+0x4B4, las 9 ranuras ctrl+0x490..+0x4B0 y,
de cada estado, su vtable (+0x4C), el metodo de dano (vtable+0x2C, ajuste short vtable+0x28) y +0x44.
Pregunta: J2 tiene controlador propio o el de J (molde)? y que estado atiende el dano.
Salida: volcados/campana/estados93.json"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402


def foto(p, P):
    ctrl = p.leer32(P + 0x32C)
    d = {"P": hex(P), "ctrl": hex(ctrl)}
    if not (0x100000 <= ctrl < 0x2000000):
        return d
    d["tipo"] = p.leer32(ctrl + 0x80)
    d["vt84"] = hex(p.leer32(ctrl + 0x84))
    d["ind"] = p.leer32(ctrl + 0x4B4, con_signo=True)
    d["e4e8"] = p.leer32(ctrl + 0x4E8)
    est = []
    for i in range(9):
        s = p.leer32(ctrl + 0x490 + 4 * i)
        e = {"i": i, "s": hex(s)}
        if 0x100000 <= s < 0x2000000:
            vt = p.leer32(s + 0x4C)
            e.update({"vt": hex(vt), "f2c": hex(p.leer32(vt + 0x2C)), "adj": p.leer16(vt + 0x28, con_signo=True),
                      "x44": p.leer32(s + 0x44, con_signo=True)})
        est.append(e)
    d["estados"] = est
    return d


def main():
    res = {}
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", "0", "0")
    cc.run("selector_depuracion.py", "aceptar")
    t0 = time.time()
    while time.time() - t0 < 90:
        with Pine() as p:
            a = p.leer32(cm.CONTADOR)
        time.sleep(1.5)
        with Pine() as p:
            if p.leer32(cm.CONTADOR) - a > 5:
                break
    time.sleep(5)
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        res["J_temprano"] = foto(p, J)
        res["J2_temprano"] = foto(p, cj.J2)
    time.sleep(15)
    with Pine() as p:
        res["J"] = foto(p, J)
        res["J2"] = foto(p, cj.J2)
        serie = []
        for i in range(10):
            serie.append([p.leer32(p.leer32(J + 0x32C) + 0x4B4, con_signo=True),
                          p.leer32(p.leer32(cj.J2 + 0x32C) + 0x4B4, con_signo=True)])
            time.sleep(0.3)
        res["serie_ind_J_J2"] = serie
    (cc.SAL / "estados93.json").write_text(json.dumps(res, indent=1))
    print(json.dumps(res, indent=1))
    cc.matar_fork()


if __name__ == "__main__":
    main()
