#!/usr/bin/env python3
"""Saboteador de coop_diseno.py: rompe el plano de a una cosa por vez (en copias temporales) y exige ROJO;
el plano sin tocar tiene que dar VERDE. Sale 0 sólo si todas se cumplen (veinte desde (115): tres del plan de COOP-B, cuatro de la IA y seis del HUD doble; veinticinco desde (116), con cinco
del sonido de J2)."""
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
DOC = RAIZ / "docs" / "14-coop-diseno.md"
MODS = RAIZ / "mods"
VERIF = RAIZ / "herramientas" / "coop_diseno.py"


# (111) sabotajes que no tocan el plano sino el codigo: (codigo previo, marca que tiene que salir en el rojo)
APAGAR_IA = ("import coop_mod; coop_mod.CON_IA = False", "CON_IA apagada")
ORIGINAL_IA_MAL = ("import coop_ia; coop_ia.ORIGINAL[0x0018FC4C] = 'jal 0x0018FB90'", "gancho de la IA 0x18fc4c")
# (115) regla 8, el HUD doble: el ELF no tiene lo que el gancho pisa; un float del rectangulo que no es el del PDP;
# un j/jal del stub a una funcion que el diseno no nombra
ORIGINAL_HUD_MAL = ("import coop_hud; coop_hud.ORIGINAL[0x001F25DC] = 'jal 0x001F1610'", "HUD: gancho 0x1f25dc")
ESCALA_HUD_MAL = ("import coop_hud; coop_hud.ESCALA = 0.8", "HUD: rectangulo")
SALTO_HUD_MAL = ("import coop_hud; f = coop_hud.fuente; coop_hud.fuente = lambda: f().replace('j 0x1f1608', 'j 0x1f1610')",
                 "j/jal a 0x1f1610")
# sabotajes del plano con marca propia (el rojo tiene que ser el de la regla 8, no otro)
MARCA_PASO = ("pass", "HUD: gancho 0x1fbfd4")
MARCA_RESERVA = ("pass", "HUD: el codigo")
APAGAR_HUD = ("import coop_mod; coop_mod.CON_HUD = False", "CON_HUD apagado")
# (116)/(117) regla 9, el sonido de J2: la llamada de la original que no es la del ELF; un salto a otra funcion; SONJ2
# que pisa a0 (= V) antes del salto; SONJ2 que lee otro campo de V; el envoltorio de otra entrada; la reserva achicada
APOYO_SON_MAL = ("import coop_sonido; coop_sonido.APOYO[0x001D6FC4] = 'lw a0, 7140(s0)'", "sonido: apoyo 0x1d6fc4")
SALTO_SON_MAL = ("import coop_sonido; coop_sonido.FUENTE = coop_sonido.FUENTE.replace('j 0x1f0678', 'j 0x1f067c')",
                 "no es FUN_001F0678")
A0_SON_MAL = ("import coop_sonido; coop_sonido.FUENTE = coop_sonido.FUENTE.replace('lw t9, 0x1be0(a0)', "
              "'lw a0, 0x1be0(a0)')", "escribe a0")
CUE_SON_MAL = ("import coop_sonido; coop_sonido.FUENTE = coop_sonido.FUENTE.replace('lw t9, 0x1be0(a0)', "
               "'lw t9, 0x1be4(a0)')", "no lee el cue")
ENTRADA_SON_MAL = ("import coop_sonido; coop_sonido.DISPARO_V = 0x001D7360", "el envoltorio 1")
MARCA_RESERVA_SON = ("pass", "sonido: el codigo")


def fin_sonido_achicado() -> str:
    """(117) la reserva del sonido achicada a UNA palabra menos que el codigo actual: derivado, no literal (la de
    (116) achicaba a 0x0046EE20 fijo y quedo ciega cuando el codigo bajo de 13 a 7 palabras)."""
    sys.path.insert(0, str(VERIF.parent))
    import coop_sonido
    return "0x%08X" % (coop_sonido.BASE + 4 * (len(coop_sonido.programa()) - 1))


def correr(doc: Path, mods: Path, previo=None) -> int:
    args = ["verificar", "--doc", str(doc), "--mods", str(mods)]
    if not previo:
        return subprocess.run([sys.executable, str(VERIF)] + args, capture_output=True, text=True).returncode
    codigo = ("import sys; sys.path.insert(0, %r); %s; import coop_diseno; sys.exit(coop_diseno.main(%r))"
              % (str(VERIF.parent), previo[0], args))
    r = subprocess.run([sys.executable, "-c", codigo], capture_output=True, text=True)
    # el rojo vale solo si es el de la regla que se saboteo
    return r.returncode if previo[1] in r.stdout else 99


def main() -> int:
    original = DOC.read_text(encoding="utf-8")
    casos = [
        ("plano sin tocar", lambda t: t, None, 0),
        ("rango de código viejo (envoltorio hasta 0x0046DB7C)",
         lambda t: t.replace("| 0x0046DA00 | 0x0046DBB4 |", "| 0x0046DA00 | 0x0046DB7C |"), None, 1),
        ("fila nueva que pisa el por cuadro",
         lambda t: t.replace("J2 (el jugador 2)", "intruso | 0x0046D900 | 0x0046D910 | datos | (86)\nJ2 (el jugador 2)"),
         None, 1),
        ("fuente que no existe", lambda t: t.replace("| datos  | (79)", "| datos  | (999)"), None, 1),
        ("gancho sin declarar", lambda t: re.sub(r"(?m)^gancho del tinte.*\n", "", t), None, 1),
        ("otro mod escribe adentro del coop", lambda t: t,
         'nombre = "sabotaje"\n[[parche]]\ndireccion = 0x0046D804\ntipo = "u32"\nvalor = 0\n', 1),
        ("sin bloque de rangos", lambda t: t.replace("```coop-rangos", "```texto"), None, 1),
        ("plan B: el ELF no tiene lo que el diseño supone",
         lambda t: t.replace("| addiu sp, sp, -144; lui v0, 0x44", "| addiu sp, sp, -128; lui v0, 0x44"), None, 1),
        ("IA: el ELF no tiene lo que el gancho reemplaza (111)", lambda t: t, ORIGINAL_IA_MAL, 1),
        ("plan B: reserva que pisa un rango del mod",
         lambda t: t.replace("| 0x0046E580 | 0x0046E588 | reserva", "| 0x0046E4F0 | 0x0046E588 | reserva"), None, 1),
        ("IA: rango de código viejo (los dos hasta 0x0046E700)",
         lambda t: t.replace("| 0x0046E600 | 0x0046E778 | codigo", "| 0x0046E600 | 0x0046E700 | codigo"), None, 1),
        ("IA: gancho sin fila",
         lambda t: re.sub(r"(?m)^gancho IA hostil.*\n", "", t), None, 1),
        ("IA: apagada por defecto en coop_mod (111)", lambda t: t, APAGAR_IA, 1),
        ("plan B: sin bloque del plan", lambda t: t.replace("```coop-plan-b", "```texto"), None, 1),
        ("HUD: el ELF no tiene lo que el gancho pisa (115)", lambda t: t, ORIGINAL_HUD_MAL, 1),
        ("HUD: escala que no da los rectángulos del PDP (115)", lambda t: t, ESCALA_HUD_MAL, 1),
        ("HUD: salto a una función que el diseño no nombra (115)", lambda t: t, SALTO_HUD_MAL, 1),
        ("HUD: paso sin fila (115)",
         lambda t: re.sub(r"(?m)^HUD H4 paso 0 \(7\).*\n", "", t), MARCA_PASO, 1),
        ("HUD: fila de código achicada (115)",
         lambda t: t.replace("| 0x0046EA80 | 0x0046EC14 | codigo", "| 0x0046EA80 | 0x0046EB00 | codigo"),
         MARCA_RESERVA, 1),
        ("HUD: apagado por defecto en coop_mod (115)", lambda t: t, APAGAR_HUD, 1),
        ("sonido: la guarda no es la del ELF (116)", lambda t: t, APOYO_SON_MAL, 1),
        ("sonido: salto a otra función (116)", lambda t: t, SALTO_SON_MAL, 1),
        ("sonido: SONJ2 pisa a0 = V antes del salto (116)", lambda t: t, A0_SON_MAL, 1),
        ("sonido: SONJ2 no lee el cue de V+0x1BE0 (117)", lambda t: t, CUE_SON_MAL, 1),
        ("sonido: la pieza cuelga de otro envoltorio (116)", lambda t: t, ENTRADA_SON_MAL, 1),
        ("sonido: reserva achicada (116)",
         lambda t: t.replace("| 0x0046EE00 | 0x0046EE40 | reserva",
                             "| 0x0046EE00 | %s | reserva" % fin_sonido_achicado()),
         MARCA_RESERVA_SON, 1),
    ]
    fallas = 0
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        for nombre, cambio, toml, esperado in casos:
            doc = tmp / "14.md"
            doc.write_text(cambio(original), encoding="utf-8")
            mods = tmp / "mods"
            if mods.exists():
                shutil.rmtree(mods)
            shutil.copytree(MODS, mods)
            previo = toml if isinstance(toml, tuple) else None
            if toml and not previo:
                (mods / "sabotaje.toml").write_text(toml, encoding="utf-8")
            if cambio(original) == original and esperado == 1 and not toml:
                print("SABOTAJE SIN EFECTO:", nombre); fallas += 1; continue
            rc = correr(doc, mods, previo)
            ok = rc == esperado
            fallas += not ok
            print("%-4s %-55s rc=%d (esperado %d)" % ("ok" if ok else "MAL", nombre, rc, esperado))
    print("probar-coop-diseno: %s" % ("TODO BIEN" if not fallas else "%d MAL" % fallas))
    return 1 if fallas else 0


if __name__ == "__main__":
    sys.exit(main())
