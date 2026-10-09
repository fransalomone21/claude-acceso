#!/usr/bin/env python3
"""Saboteador de coop_diseno.py: rompe el plano de a una cosa por vez (en copias temporales) y exige ROJO;
el plano sin tocar tiene que dar VERDE. Sale 0 sólo si todas se cumplen (veinte desde (115): tres del plan de COOP-B, cuatro de la IA y seis del HUD doble; veinticinco desde (116), con cinco
del sonido de J2; treinta y uno desde (119), con seis de la pieza 2b; y nueve mas desde (125), de la pieza 2d)."""
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
# (119) la pieza 2a, ya en coop-rangos, tiene que ir PRENDIDA por defecto: si no, el acceso COOP instala sin ella
APAGAR_SONIDO = ("import coop_mod; coop_mod.CON_SONIDO = False", "CON_SONIDO apagado")
# (119)/(120) regla 10, la pieza 2b: la GUARDA de plantilla viva sacada (sin ella la regla del dueno escribe cuatro
# palabras sobre un puntero colgado en el caso NORMAL del juego, (118)); el apoyo del que DERIVA los tamanos cambiado
# a algo que el ELF no tiene; un salto a una funcion que el diseno no nombra. Los otros dos tocan el plano.
GUARDA_SUB3_MAL = ("import coop_sub3; coop_sub3.FUENTE = coop_sub3.FUENTE.replace('lw t2, 0x1c(t5)', "
                   "'lw t2, 0x20(t5)')", "falta la guarda de plantilla viva")
APOYO_SUB3_MAL = ("import coop_sub3; coop_sub3.APOYO[0x001A8148] = 'li a0, 17000'", "sub3: apoyo 0x1a8148")
SALTO_SUB3_MAL = ("import coop_sub3; coop_sub3.FUENTE = coop_sub3.FUENTE.replace('jal 0x1a8168', 'jal 0x1a816c')",
                  "no es FUN_001A80F8 ni FUN_001A8168")
MARCA_RESERVA_SUB3 = ("pass", "sub3: el codigo")
APAGAR_SUB3 = ("import coop_mod; coop_mod.CON_SUB3 = False", "CON_SUB3 apagada")
# el tope del envoltorio devuelto al valor de antes del corrimiento de (120): con la pieza prendida «por cuadro»
# necesita 90 palabras y ahi solo hay 88. Es el caso que la regla 10 agrego, y sin el sabotaje no estaria probado
TOPE_SUB3_MAL = ("import coop_mod; coop_mod.R3_ENVOLTORIO = 0x0046E4A0", "con la pieza prendida el mod no ensambla")
# (122) regla 11, el TESTIGO del sub3 por cuadro. Los tres sabotajes apuntan al HALLAZGO CONCRETO, no a la regla
# entera, y ninguno trae la direccion literal adentro: la sacan de coop_sub3, que es su dueno (si el mapa se corre,
# el sabotaje se corre con el -- la leccion que (120) pago con `0x0046E580` escrito a mano).
TESTIGO_SIN_COMPARAR = ("import coop_sub3 as c; c.POR_CUADRO_BLOQUE = c.POR_CUADRO_BLOQUE.replace("
                        "'bne t8, t2, @SUB3NO2', 'nop')", "no COMPARA SUB3_IDX")
TESTIGO_SIN_GUARDAR = ("import coop_sub3 as c; c.FUENTE = c.FUENTE.replace('sw s5, %d(t0)' % c._o(c.SUB3_IDX), "
                       "'nop')", "no guarda el indice de arma")
TESTIGO_SIN_LIMPIAR = ("import coop_sub3 as c; c.DESARME_BLOQUE = c.DESARME_BLOQUE.replace("
                       "'sw zero, %d(t2)' % c._o(c.SUB3_IDX), 'nop')", "no pone SUB3_IDX")
# (123) el PUNTERO DE TABLA del sub3 (sin el, la junta de J2 cuelga el juego). Tres al hallazgo: el `sw` sacado, el
# `sw` sobre OTRA base (la relacion, no el inmediato suelto), y la constante que ya no es la del constructor del ELF.
VPTR_SIN_SW = ("import coop_sub3 as c; c.FUENTE = c.FUENTE.replace('sw t2, 0x%x(t4)' % c.VPTR_OFF, 'nop')",
               "puntero de tabla virtual")
VPTR_OTRA_BASE = ("import coop_sub3 as c; c.FUENTE = c.FUENTE.replace('sw t2, 0x%x(t4)' % c.VPTR_OFF, "
                  "'sw t2, 0x%x(t0)' % c.VPTR_OFF)", "puntero de tabla virtual")
VPTR_NO_ES_DEL_ELF = ("import coop_sub3 as c; c.APOYO[0x00382DB0] = 'addiu v0, v0, %d' % ((c.VPTR_SUB & 0xFFFF) + 0x70)",
                      "sub3: apoyo 0x382db0")
# (125) regla 12, la pieza 2d (J2 con su soporte, coop_soporte2.py). Cada sabotaje apunta a un HALLAZGO de la lectura
# en frio y saca sus valores de coop_soporte2 (su duenio), nunca literales.
SOP2_REAPUNTA_ANTES = ("import coop_soporte2 as c; f = c.fuente; c.fuente = lambda: f().replace('lw t0, 0x328(s0)', "
                       "'sw t1, 0x328(s0)\\nlw t0, 0x328(s0)', 1)", "reapunta J2+0x328 antes")
SOP2_BUF_DE_124 = ("import coop_soporte2 as c; c.TAM_B = 0x60", "soporte2: registros B")   # el 0x60 de (124): desborda
SOP2_ACC_DE_J = ("import coop_soporte2 as c; f = c.fuente; c.fuente = lambda: f().replace('move a1, s0', "
                 "'move a1, s1', 1)", "FUN_00142E90(acc, J2)")
SOP2_CAMBIO_PRIMERO = ("import coop_soporte2 as c; f = c.fuente; X = 'addiu a0, s1, %d\\nsw a0, 0x270(s0)' % c._o(c.ACC); "
                       "c.fuente = lambda: f().replace('jal 0x13c868\\nmove a0, s0', 'nop\\nnop').replace("
                       "X, 'jal 0x13c868\\nmove a0, s0\\n' + X)", "FUN_0013C868 corre antes")
SOP2_ANTES_DEL_CONSTRUCTOR = ("import coop_mod as m; m.ENVOLTORIO_MOD = m.ENVOLTORIO_MOD.replace('SOPORTE2_BLOQUE\\n', "
                              "'').replace('jal 0x139c68', 'SOPORTE2_BLOQUE\\njal 0x139c68')",
                              "no queda despues del constructor")
SOP2_APAGADA_LLAMA = ("import coop_mod as m, coop_soporte2 as c; m._soporte2_bloque = lambda: c.BLOQUE_ENVOLTORIO",
                      "con la pieza APAGADA el envoltorio igual llama")
SOP2_APOYO_MAL = ("import coop_soporte2 as c; c.APOYO[0x0013C8CC] = 'lw a0, 812(s2)'", "soporte2: apoyo 0x13c8cc")
MARCA_RESERVA_SOP2 = ("pass", "soporte2: el codigo")


def fila_sub3(n=0) -> str:
    """La fila de coop-rangos de la pieza 2b, DERIVADA del codigo: `n` = palabras de menos (nunca un literal, que es
    lo que dejo ciego al sabotaje del sonido en (119))."""
    sys.path.insert(0, str(VERIF.parent))
    import coop_sub3
    return "sub3 de J2                  | 0x%08X | 0x%08X | codigo | (119)" % (
        coop_sub3.BASE, coop_sub3.BASE + 4 * (len(coop_sub3.programa()) - n))


def reserva_sop2(cual, cortar=False) -> str:
    """(125) el pedazo de la fila de reserva de la pieza 2d, DERIVADO de coop_soporte2 (nunca literal): `cual` = "c"
    (codigo) o "d" (datos); `cortar` = la reserva termina UNA PALABRA antes de lo que ocupa la pieza (el final del
    codigo, o el del ultimo accesorio). Achicarla un monto fijo no sirve: con 0x40 de menos la reserva de codigo
    todavia contenia las 45 palabras y el caso salio rc=99 (medido en (125)). Si la fila del documento no coincide,
    el reemplazo no aplica y el caso sale SABOTAJE SIN EFECTO, que es lo que tiene que pasar."""
    sys.path.insert(0, str(VERIF.parent))
    import coop_soporte2 as c
    d, h = (c.BASE, c.FIN) if cual == "c" else (c.DATOS, c.DATOS_FIN)
    if cortar:
        h = (c.BASE + 4 * len(c.programa()) if cual == "c" else c.ACC + c.N_ACC * c.PASO_ACC) - 4
    return "| 0x%08X | 0x%08X | reserva" % (d, h)


def fin_sonido(n=0) -> str:
    """El fin de la fila del sonido, DERIVADO del codigo (no literal): `n` = palabras de menos. La de (116) achicaba
    a 0x0046EE20 fijo y quedo ciega cuando el codigo bajo de 13 a 7 palabras."""
    sys.path.insert(0, str(VERIF.parent))
    import coop_sonido
    return "0x%08X" % (coop_sonido.BASE + 4 * (len(coop_sonido.programa()) - n))


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
         lambda t: t.replace("| 0x0046E5C0 | 0x0046E5C8 | reserva", "| 0x0046E4F0 | 0x0046E5C8 | reserva"), None, 1),
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
        # (119) la fila se mudo de coop-plan-b (reserva) a coop-rangos (codigo) al pasar la pieza su prueba: el
        # sabotaje viejo reemplazaba el texto de la reserva, que ya no existe, y no saboteaba nada (rc=99, revento).
        # Ahora achica la fila de CODIGO una palabra, derivada del codigo actual
        ("sonido: fila de código achicada (119)",
         lambda t: t.replace("| 0x0046EE00 | %s | codigo" % fin_sonido(),
                             "| 0x0046EE00 | %s | codigo" % fin_sonido(1)),
         MARCA_RESERVA_SON, 1),
        # y el control de que la pieza quede PRENDIDA por defecto con sus filas en coop-rangos (regla 9)
        ("sonido: apagado por defecto con sus filas en coop-rangos (119)", lambda t: t, APAGAR_SONIDO, 1),
        # (119)/(120) regla 10, la pieza 2b
        ("sub3: la guarda de plantilla viva sacada (118)", lambda t: t, GUARDA_SUB3_MAL, 1),
        ("sub3: el apoyo no es el del ELF (119)", lambda t: t, APOYO_SUB3_MAL, 1),
        ("sub3: salto a una función que el diseño no nombra (119)", lambda t: t, SALTO_SUB3_MAL, 1),
        ("sub3: reserva del plan achicada (119)",
         lambda t: t.replace("sub3 (código)                  | 0x0046EC20 | 0x0046EE00 | reserva",
                             "sub3 (código)                  | 0x0046EC20 | 0x0046EC80 | reserva"),
         MARCA_RESERVA_SUB3, 1),
        # el default apagado cuando la fila YA se mudo a coop-rangos: el sabotaje hace la mudanza (saca la reserva
        # del plan y pone la fila de código con el rango exacto, derivado) y deja CON_SUB3 en False
        ("sub3: apagada por defecto con su fila ya en coop-rangos (119)",
         lambda t: t.replace("sub3 (código)                  | 0x0046EC20 | 0x0046EE00 | reserva | -                                   | (119)\n", "")
                    .replace("sonido de J2               | 0x0046EE00",
                             fila_sub3() + "\nsonido de J2               | 0x0046EE00"),
         APAGAR_SUB3, 1),
        ("sub3: los bloques no entran en la reserva de su programa (120)", lambda t: t, TOPE_SUB3_MAL, 1),
        ("testigo: el bloque por cuadro no compara el índice (122)", lambda t: t, TESTIGO_SIN_COMPARAR, 1),
        ("testigo: SUBH no guarda qué arma armó el sub3 (122)", lambda t: t, TESTIGO_SIN_GUARDAR, 1),
        ("testigo: el desarme no limpia SUB3_IDX (122)", lambda t: t, TESTIGO_SIN_LIMPIAR, 1),
        ("sub3: sin su puntero de tabla virtual (123)", lambda t: t, VPTR_SIN_SW, 1),
        ("sub3: el puntero de tabla escrito en otra base (123)", lambda t: t, VPTR_OTRA_BASE, 1),
        ("sub3: el puntero de tabla no es el del constructor del ELF (123)", lambda t: t, VPTR_NO_ES_DEL_ELF, 1),
        ("testigo: SUB3_IDX fuera de la reserva «sub3 (datos)» (122)",
         lambda t: t.replace("sub3 (datos)                   | 0x0046EF00 | 0x0046F000 | reserva",
                             "sub3 (datos)                   | 0x0046EF00 | 0x0046EF7C | reserva"),
         None, 1),
        # (125) regla 12, la pieza 2d
        ("soporte2: reapunta J2+0x328 antes de copiar el soporte (125)", lambda t: t, SOP2_REAPUNTA_ANTES, 1),
        ("soporte2: buffer B del tamaño de (124), no del juego (125)", lambda t: t, SOP2_BUF_DE_124, 1),
        ("soporte2: accesorio iniciado con otro dueño (125)", lambda t: t, SOP2_ACC_DE_J, 1),
        ("soporte2: el cambio de arma antes de reapuntar (125)", lambda t: t, SOP2_CAMBIO_PRIMERO, 1),
        ("soporte2: la llamada antes del constructor de J2 (125)", lambda t: t, SOP2_ANTES_DEL_CONSTRUCTOR, 1),
        ("soporte2: apagada y el envoltorio igual la llama (125)", lambda t: t, SOP2_APAGADA_LLAMA, 1),
        ("soporte2: el apoyo no es el del ELF (125)", lambda t: t, SOP2_APOYO_MAL, 1),
        ("soporte2: reserva de código achicada (125)",
         lambda t: t.replace(reserva_sop2("c"), reserva_sop2("c", True)), MARCA_RESERVA_SOP2, 1),
        ("soporte2: datos fuera de su reserva (125)",
         lambda t: t.replace(reserva_sop2("d"), reserva_sop2("d", True)),
         ("pass", "fuera de la reserva «soporte2 (datos)»"), 1),
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
