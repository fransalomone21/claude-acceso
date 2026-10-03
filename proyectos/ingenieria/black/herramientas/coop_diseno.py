#!/usr/bin/env python3
"""coop_diseno.py -- mide que el plano del COOP (docs/14-coop-diseno.md) y el mod no se separen (PDP §4, COOP-B).

    python herramientas/coop_diseno.py verificar [--doc RUTA] [--mods CARPETA]

Lee el bloque ```coop-rangos del documento y exige, en este orden:
  1. cada programa de coop_mod.programas() (salvo los ganchos) tiene una fila de CODIGO/DATOS con el mismo
     rango [desde, hasta): si el codigo crecio y el plano no, rojo;
  2. cada gancho que escribe el mod (incluidos los de la escena de pantalla_dividida.py) cae en una fila
     de tipo gancho o en un sitio de la escena declarado en la fuente;
  3. ningun par de filas se pisa;
  4. ninguna `direccion = 0x...` de los otros mods de mods/ cae en un rango del coop;
  5. toda fila tiene fuente: una entrada `(NN)` (o `(NN, nube)`) que existe en docs/03-bitacora.md, o un archivo de kb/;
  6. (104) el bloque ```coop-plan-b (el DISENO de COOP-B, todavia sin codigo): sus filas no se pisan entre si
     ni con coop-rangos; cada `gancho` espera en el ELF la instruccion que declara (varias separadas por `;`
     para palabras seguidas), porque el diseno se apoya en ella; y cada fila tiene fuente como en 5;
  7. (111) la IA (coop_ia.py) esta PRENDIDA por defecto en coop_mod (decision del 2026-10-02) y cada sitio suyo
     tiene en el ELF la instruccion que reemplaza; su codigo y sus ganchos ya viven en coop-rangos (reglas 1-3).
     Hasta (110) era: el codigo cae en su reserva del plan.
  8. (115, COOP-C pieza 1) el HUD doble (coop_hud.py): su codigo cae en la reserva «HUD de J2 (codigo)» del plan, o
     (cuando la pieza pase su prueba y sus filas se muden) en una fila de codigo de coop-rangos con su rango exacto;
     cada gancho suyo cae en una fila gancho del plan o de coop-rangos; y coop_hud.problemas() vacio (capstone,
     saltos, floats del PDP, la sombra en sus reservas, lo que pisa y en lo que se apoya contra el ELF, el listado).
 10. (119, COOP-C pieza 2b) el sub propio del aparejo de J2 (coop_sub3.py): coop_sub3.problemas() vacio -- lo que
     incluye la GUARDA de plantilla viva, sin la cual la regla del dueno escribe cuatro palabras sobre memoria ajena
     en el caso NORMAL del juego ((118), 14 de 16 volcados)--; su codigo en la reserva «sub3 (codigo)» del plan o en
     una fila de coop-rangos CON EL RANGO EXACTO (y ahi, prendida por defecto); su gancho con fila; y que con la
     pieza PRENDIDA los tres programas que reciben bloque sigan ensamblando y sin pisar ninguna otra fila (lo que
     (120) midio que faltaba: los bloques hacian pasar «por cuadro» de 81 a 90 palabras sobre un tope de 88).
  9. (116, COOP-C pieza 2a) el sonido del disparo de J2 (coop_sonido.py): su codigo en la reserva «sonido de J2 (codigo)»
     del plan o en su fila de coop-rangos (y ahi prendido por defecto); coop_sonido.problemas() vacio; y el envoltorio
     4 del aislador sale por `j SONJ2` con la pieza prendida y por `jr ra` con la pieza apagada.
Sale 0 si todo esta bien y 1 si algo falla (y dice que). Su saboteador: pruebas/probar-coop-diseno.py.
"""
import argparse
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ / "herramientas"))


def leer_rangos(doc: Path):
    t = doc.read_text(encoding="utf-8")
    m = re.search(r"```coop-rangos\n(.*?)```", t, re.S)
    if not m:
        return None
    filas = []
    for l in m.group(1).splitlines():
        if not l.strip() or l.lstrip().startswith("#"):
            continue
        c = [x.strip() for x in l.split("|")]
        filas.append({"nombre": c[0], "desde": int(c[1], 16), "hasta": int(c[2], 16), "tipo": c[3], "fuente": c[4]})
    return filas


def verificar(doc: Path, mods: Path) -> list[str]:
    import coop_mod as cm
    import pantalla_dividida as pd
    errores = []
    filas = leer_rangos(doc)
    if not filas:
        return ["no hay bloque coop-rangos en %s" % doc]
    cm.SIN_R3 = False   # (93v) el plano describe el mod entero, con la ranura 3 (apagada por defecto al instalar)
    con_ia_por_defecto = cm.CON_IA
    cm.CON_IA = True    # (111) y con la IA, que ademas tiene que estar prendida por defecto (regla 7)
    errores += verificar_ia(con_ia_por_defecto)
    con_hud_por_defecto = cm.CON_HUD
    cm.CON_HUD = True   # (115) y con el HUD doble, que desde que vive en coop-rangos va prendido por defecto (regla 8)
    errores += verificar_hud(doc, filas, con_hud_por_defecto)
    errores += verificar_sonido(doc, filas, cm.CON_SONIDO)   # (116) regla 9; programas() la incluye segun su default
    errores += verificar_sub3(doc, filas, cm.CON_SUB3)       # (119) regla 10; apagada hasta su prueba en vivo
    errores += verificar_testigo_sub3(doc, filas)            # (122) regla 11; el testigo por cuadro es el INDICE
    progs = cm.programas()
    # 1. los programas contra el plano
    for nombre, prog in progs[:-1]:
        desde, hasta = min(pc for pc, _, _ in prog), max(pc for pc, _, _ in prog) + 4
        if not any(f["tipo"] in ("codigo", "datos") and f["desde"] <= desde and hasta <= f["hasta"] and
                   (f["tipo"] == "datos" or (f["desde"], f["hasta"]) == (desde, hasta)) for f in filas):
            errores.append("programa '%s' [%#x, %#x) sin fila que lo declare igual" % (nombre, desde, hasta))
    # 2. los ganchos
    escena = set(pd.SITIOS)
    for pc, _, texto in progs[-1][1]:
        if pc in escena:
            continue
        if not any(f["tipo"] == "gancho" and f["desde"] <= pc < f["hasta"] for f in filas):
            errores.append("gancho %#x (%s) sin fila" % (pc, texto))
    # 3. solapes entre filas (y con los sitios de la escena)
    todos = filas + [{"nombre": "sitio de la escena %#x" % s, "desde": s, "hasta": s + 4, "tipo": "gancho",
                      "fuente": "pantalla_dividida.py"} for s in escena]
    for i, a in enumerate(todos):
        for b in todos[i + 1:]:
            if a["desde"] < b["hasta"] and b["desde"] < a["hasta"]:
                errores.append("se pisan '%s' y '%s'" % (a["nombre"], b["nombre"]))
    # 4. los otros mods
    for toml in sorted(mods.glob("*.toml")):
        if toml.name in ("coop.toml", "ejemplo-plantilla.toml"):
            continue
        for m in re.finditer(r"(?m)^\s*direccion\s*=\s*(0x[0-9A-Fa-f]+)", toml.read_text(encoding="utf-8")):
            d = int(m.group(1), 16)
            for f in todos:
                if f["desde"] <= d < f["hasta"]:
                    errores.append("%s escribe %#x, dentro de '%s'" % (toml.name, d, f["nombre"]))
    # 5. fuentes
    bit = (RAIZ / "docs" / "03-bitacora.md").read_text(encoding="utf-8")
    for f in filas:
        m = re.fullmatch(r"\((\d+[a-z]?)\)", f["fuente"])
        if m:
            if not re.search(r"(?m)^#{2,3} .*\(%s(?:, [^)]*)?\)" % re.escape(m.group(1)), bit):
                errores.append("'%s': la entrada %s no esta en la bitacora" % (f["nombre"], f["fuente"]))
        elif not (f["fuente"].startswith("kb/") and (RAIZ / f["fuente"]).exists()):
            errores.append("'%s': fuente '%s' no es (NN) ni un archivo de kb/" % (f["nombre"], f["fuente"]))
    errores += verificar_plan(doc, todos, bit)
    return errores


def leer_plan(doc: Path):
    t = doc.read_text(encoding="utf-8")
    m = re.search(r"```coop-plan-b\n(.*?)```", t, re.S)
    if not m:
        return None
    filas = []
    for l in m.group(1).splitlines():
        if not l.strip() or l.lstrip().startswith("#"):
            continue
        c = [x.strip() for x in l.split("|")]
        filas.append({"nombre": c[0], "desde": int(c[1], 16), "hasta": int(c[2], 16), "tipo": c[3],
                      "espera": c[4], "fuente": c[5]})
    return filas


def verificar_plan(doc: Path, rangos, bit) -> list[str]:
    from mips import desensamblar
    from perfil_singleton import palabra_elf
    plan = leer_plan(doc)
    if plan is None:
        return ["no hay bloque coop-plan-b en %s" % doc]
    errores = []
    for i, a in enumerate(plan):
        if a["tipo"] not in ("gancho", "reserva"):
            errores.append("plan '%s': tipo '%s' (gancho o reserva)" % (a["nombre"], a["tipo"]))
        for b in plan[i + 1:] + rangos:
            if a["desde"] < b["hasta"] and b["desde"] < a["hasta"]:
                errores.append("plan: se pisan '%s' y '%s'" % (a["nombre"], b["nombre"]))
        m = re.fullmatch(r"\((\d+[a-z]?)\)", a["fuente"])
        if not m or not re.search(r"(?m)^#{2,3} .*\(%s(?:, [^)]*)?\)" % re.escape(m.group(1)), bit):
            errores.append("plan '%s': fuente '%s' no esta en la bitacora" % (a["nombre"], a["fuente"]))
        if a["tipo"] == "gancho":
            for k, esp in enumerate(x.strip() for x in a["espera"].split(";")):
                pc = a["desde"] + 4 * k
                w = palabra_elf(pc)
                real = desensamblar(w, pc) if w is not None else "(sin ELF)"
                if " ".join(real.lower().split()) != " ".join(esp.lower().split()):
                    errores.append("plan '%s': en %#x el ELF tiene '%s', el diseno espera '%s'"
                                   % (a["nombre"], pc, real, esp))
    return errores


def verificar_ia(con_ia_por_defecto) -> list[str]:
    """(111) regla 7: la IA es parte del mod POR DEFECTO (decision del 2026-10-02) y sus sitios tienen en el ELF
    la instruccion que el codigo reemplaza. Sus rangos y ganchos los miden las reglas 1-3, porque viven en coop-rangos."""
    from mips import desensamblar
    from perfil_singleton import palabra_elf
    import coop_ia
    errores = [] if con_ia_por_defecto else ["coop_mod.CON_IA apagada por defecto: el acceso COOP instalaria sin la IA"]
    for pc, _, texto in coop_ia.ganchos():
        w = palabra_elf(pc)
        real = " ".join((desensamblar(w, pc) if w is not None else "(sin ELF)").split())
        if real.lower() != coop_ia.ORIGINAL[pc].lower():
            errores.append("gancho de la IA %#x (%s): el ELF tiene '%s', se esperaba '%s'"
                           % (pc, texto, real, coop_ia.ORIGINAL[pc]))
    return errores


def verificar_hud(doc: Path, filas_rangos, con_hud_por_defecto=True) -> list[str]:
    """(115) regla 8: el HUD doble contra el plano, mientras vive en coop-plan-b y despues de mudarse a coop-rangos
    (y ahi, prendido por defecto en coop_mod: si no, el acceso COOP instalaria sin la pieza)."""
    import coop_hud
    errores = ["HUD: " + e for e in coop_hud.problemas()]
    plan = leer_plan(doc) or []
    prog = coop_hud.programa()
    desde, hasta = prog[0][0], prog[-1][0] + 4
    en_plan = any(f["tipo"] == "reserva" and f["nombre"].startswith("HUD de J2") and f["desde"] <= desde
                  and hasta <= f["hasta"] for f in plan)
    en_rangos = any(f["tipo"] == "codigo" and (f["desde"], f["hasta"]) == (desde, hasta) for f in filas_rangos)
    if not (en_plan or en_rangos):
        errores.append("HUD: el codigo [%#x, %#x) no cae en su reserva del plan ni en una fila de coop-rangos"
                       % (desde, hasta))
    if en_rangos and not con_hud_por_defecto:
        errores.append("HUD: coop_mod.CON_HUD apagado por defecto con sus filas en coop-rangos: el acceso COOP "
                       "instalaria sin la pieza")
    for pc, _, texto in coop_hud.ganchos():
        if not any(f["tipo"] == "gancho" and f["desde"] <= pc < f["hasta"] for f in plan + filas_rangos):
            errores.append("HUD: gancho %#x (%s) sin fila en el plan ni en coop-rangos" % (pc, texto))
    return errores


def verificar_sonido(doc: Path, filas_rangos, con_sonido_por_defecto=False) -> list[str]:
    """(116) regla 9: la pieza 2a (coop_sonido.py) contra el plano. Su codigo cae en la reserva «sonido de J2» del plan
    o en su fila de coop-rangos (y ahi, prendida por defecto); coop_sonido.problemas() vacio; y con la pieza prendida
    el envoltorio 4 del aislador (FUN_001D6F90) sale por `j SONJ2` y no por `jr ra` (si no, la pieza no corre)."""
    import coop_mod as cm
    import coop_sonido
    from mips import ensamblar
    errores = ["sonido: " + e for e in coop_sonido.problemas()]
    plan = leer_plan(doc) or []
    prog = coop_sonido.programa()
    desde, hasta = prog[0][0], prog[-1][0] + 4
    en_plan = any(f["tipo"] == "reserva" and f["nombre"].startswith("sonido de J2") and f["desde"] <= desde
                  and hasta <= f["hasta"] for f in plan)
    # (119) el rango EXACTO, como el HUD: con `startswith` a secas, una fila mudada con el rango viejo pasaba la
    # regla 9 y el rojo lo tenia que dar la regla 1, asi que el saboteador de la regla quedaba midiendo otra cosa
    en_rangos = any(f["tipo"] == "codigo" and f["nombre"].startswith("sonido de J2")
                    and (f["desde"], f["hasta"]) == (desde, hasta) for f in filas_rangos)
    if not (en_plan or en_rangos):
        errores.append("sonido: el codigo [%#x, %#x) no cae en su reserva del plan ni en una fila de coop-rangos"
                       % (desde, hasta))
    if en_rangos and not con_sonido_por_defecto:
        errores.append("sonido: coop_mod.CON_SONIDO apagado por defecto con sus filas en coop-rangos: el acceso COOP "
                       "instalaria sin la pieza")
    k = [f for f, _, _ in cm.FP_ENTRADAS].index(coop_sonido.DISPARO_V)
    salida = cm.AISLAR + 0x3C * k + 13 * 4
    viejo = cm.CON_SONIDO
    try:
        for prendida, esperada in ((True, "j 0x%x" % coop_sonido.ENTRADA), (False, "jr ra")):
            cm.CON_SONIDO = prendida
            w = {pc: x for pc, x, _ in cm.aislar()[0]}.get(salida)
            if w != ensamblar(esperada, salida):
                errores.append("sonido: con la pieza %s, el envoltorio %d en %#x no es '%s'"
                               % ("prendida" if prendida else "apagada", k, salida, esperada))
    finally:
        cm.CON_SONIDO = viejo
    return errores


def verificar_sub3(doc: Path, filas_rangos, con_sub3_por_defecto=False) -> list[str]:
    """(119) regla 10: la pieza 2b (coop_sub3.py), el sub propio del aparejo de J2.

    Exige, en este orden: `coop_sub3.problemas()` vacio (capstone, la reserva, los saltos, lo que el gancho pisa y
    el apoyo del que DERIVA los tamanos contra el ELF, el listado, y la GUARDA de plantilla viva); el codigo en su
    reserva «sub3 (codigo)» del plan o en una fila de coop-rangos CON EL RANGO EXACTO -- la correccion que (119) le
    hizo a la regla 9, porque con `startswith` a secas una fila mudada con el rango viejo pasaba y el rojo lo daba
    otra regla--; que ahi vaya PRENDIDA por defecto; su gancho con fila; y que con la pieza PRENDIDA los tres
    programas que reciben bloque (R3 por cuadro, R3 envoltorio y el desarme) sigan ENSAMBLANDO y sin pisar ninguna
    otra fila. Esto ultimo no estaba y es lo que (120) midio que faltaba: los bloques hacen crecer «por cuadro» de
    81 a 90 palabras sobre un tope de 88, y sin la regla el desborde solo lo veia la excepcion de ensamblar."""
    import coop_mod as cm
    import coop_sub3
    errores = ["sub3: " + e for e in coop_sub3.problemas()]
    plan = leer_plan(doc) or []
    prog = coop_sub3.programa()
    desde, hasta = prog[0][0], prog[-1][0] + 4
    en_plan = any(f["tipo"] == "reserva" and f["nombre"].startswith("sub3 (c") and f["desde"] <= desde
                  and hasta <= f["hasta"] for f in plan)
    en_rangos = any(f["tipo"] == "codigo" and f["nombre"].startswith("sub3")
                    and (f["desde"], f["hasta"]) == (desde, hasta) for f in filas_rangos)
    if not (en_plan or en_rangos):
        errores.append("sub3: el codigo [%#x, %#x) no cae en su reserva del plan ni en una fila de coop-rangos "
                       "con el rango exacto" % (desde, hasta))
    if en_rangos and not con_sub3_por_defecto:
        errores.append("sub3: coop_mod.CON_SUB3 apagada por defecto con sus filas en coop-rangos: el acceso COOP "
                       "instalaria sin la pieza")
    for pc, _, texto in coop_sub3.ganchos():
        if not any(f["tipo"] == "gancho" and f["desde"] <= pc < f["hasta"] for f in plan + filas_rangos):
            errores.append("sub3: gancho %#x (%s) sin fila en el plan ni en coop-rangos" % (pc, texto))
    # los tres bloques, con la pieza PRENDIDA: tienen que entrar donde el mod los pone y no pisar nada ajeno
    viejo = cm.CON_SUB3
    try:
        cm.CON_SUB3 = True
        progs = cm.programas()
    except Exception as e:                                       # noqa: BLE001
        progs = None
        errores.append("sub3: con la pieza prendida el mod no ensambla (%s: %s) -- los bloques no entran en la "
                       "reserva de su programa" % (type(e).__name__, e))
    finally:
        cm.CON_SUB3 = viejo
    if progs is not None:
        propios = {n for n, _ in progs[:-1]}
        for nombre, p in progs[:-1]:
            d, h = min(pc for pc, _, _ in p), max(pc for pc, _, _ in p) + 4
            for f in list(filas_rangos) + plan:
                if f["nombre"] in propios or f["tipo"] == "gancho":
                    continue
                if d < f["hasta"] and f["desde"] < h and not (f["desde"] <= d and h <= f["hasta"]):
                    # el solape PARCIAL es el rojo; que un programa entre ENTERO en una fila es su casa (su reserva
                    # del plan, o su propia fila de coop-rangos), no un choque
                    errores.append("sub3: con la pieza prendida '%s' [%#x, %#x) pisa '%s'" % (nombre, d, h, f["nombre"]))
    return errores


def verificar_testigo_sub3(doc: Path, filas_rangos) -> list[str]:
    """(122) regla 11: el TESTIGO del sub3 por cuadro es el INDICE DE ARMA, no el puntero del sub.

    POR QUE existe (docs/16, «Lo que la lectura en frio de (122) dejo»): el camino rapido de
    `R3_POR_CUADRO_MOD` es `bne t5, a2` con `t5` = `R3+0x50` y `a2` = `pers+0x398+i*0x6C`, que DEPENDE de `i`:
    es la unica senal que el mod tiene de que J2 cambio de arma. `SUB3_POR_CUADRO_BLOQUE` reemplaza `a2` por
    `SUB3`, que es el MISMO valor para todo `i`, asi que sin un tercer termino la comparacion se cumple para
    siempre en cuanto R3 queda cargada y R3 nunca se vuelve a recargar. El tercer termino es
    `SUB3_IDX == *(J2+0x2C3)`.

    Lo que exige, y se exige por RELACION y no por inmediatos sueltos -- el agujero que (120) ya pago con la
    guarda de plantilla (un `lw t4, 0x1c(sp)` de la pila cumplia «algun lw con 0x1C» y sacar la guarda daba
    verde): (1) `SUBH` guarda el indice con un `sw rX, SUB3_IDX(rB)` donde `rB` es el mismo registro con el que
    el programa escribe `SUB3_MOLDE` (o sea, la base `lui 0x47` del mod, no una base cualquiera); (2) el bloque
    por cuadro LEE `SUB3_IDX` y lo COMPARA con `bne`/`beq` contra el registro en el que `R3_POR_CUADRO_MOD` dejo
    `lb t2, 0x2c3(a1)`, y la rama sale del bloque; (3) el desarme pone `SUB3_IDX` en cero, por la misma razon
    por la que pone `SUB3_MOLDE`; (4) `SUB3_IDX` tiene fila -- cae adentro de la reserva «sub3 (datos)».
    """
    import jugador2 as j2
    import coop_mod as cm
    import coop_sub3 as cs

    errores = []
    off_idx, off_molde = cs._o(cs.SUB3_IDX) & 0xFFFF, cs._o(cs.SUB3_MOLDE) & 0xFFFF

    def pal(fuente, base, fin):
        return [w for _, w, _ in j2.ensamblar_programa(fuente, base, fin)]

    def rs(w):
        return (w >> 21) & 0x1F

    def rt(w):
        return (w >> 16) & 0x1F

    def imm(w):
        return w & 0xFFFF

    # (1) SUBH guarda el indice, con la MISMA base con la que guarda el molde
    prog = [w for _, w, _ in cs.programa()]
    bases_molde = {rs(w) for w in prog if (w >> 26) == 0x2B and imm(w) == off_molde}
    bases_idx = {rs(w) for w in prog if (w >> 26) == 0x2B and imm(w) == off_idx}
    if not bases_idx:
        errores.append("testigo sub3: SUBH no guarda el indice de arma (`sw rX, %#x(rB)`): sin eso el bloque por "
                       "cuadro no tiene con que comparar" % off_idx)
    elif not (bases_idx & bases_molde):
        errores.append("testigo sub3: el `sw` de SUB3_IDX usa la base %s y el de SUB3_MOLDE la base %s: no es la "
                       "misma base del mod" % (sorted(bases_idx), sorted(bases_molde)))

    # (2) el bloque por cuadro lo lee y lo COMPARA contra el registro del indice de J2
    cuadro = pal(cs.POR_CUADRO_BLOQUE, cm.R3_POR_CUADRO, cm.R3_ENVOLTORIO)
    destinos_idx = {rt(w) for w in cuadro if (w >> 26) == 0x23 and imm(w) == off_idx}
    # el registro en el que R3_POR_CUADRO_MOD deja `lb rI, 0x2c3(a1)` (0x20 = lb)
    base = cm.R3_POR_CUADRO_MOD.replace("SUB3_POR_CUADRO_BLOQUE", "")
    regs_indice = {rt(w) for w in pal(base, cm.R3_POR_CUADRO, cm.R3_ENVOLTORIO)
                   if (w >> 26) == 0x20 and imm(w) == 0x2C3}
    if not regs_indice:
        errores.append("testigo sub3: R3_POR_CUADRO_MOD ya no lee `lb rI, 0x2c3(a1)`: el testigo se quedo sin "
                       "fuente y la regla estaria midiendo otra cosa")
    pares = {frozenset((rs(w), rt(w))) for w in cuadro if (w >> 26) in (4, 5)}
    if not any(frozenset((d, i)) in pares for d in destinos_idx for i in regs_indice):
        errores.append("testigo sub3: el bloque por cuadro no COMPARA SUB3_IDX (%#x) contra el registro del "
                       "indice de J2 %s con bne/beq: sin ese termino `a2` es constante para todo i y el codigo "
                       "por cuadro no puede volver a enterarse de un cambio de arma"
                       % (off_idx, sorted(regs_indice)))

    # (3) el desarme lo pone en cero
    desarme = pal(cs.DESARME_BLOQUE, cm.DESARME, cm.DESARME + 0x100)
    if not any((w >> 26) == 0x2B and imm(w) == off_idx and rt(w) == 0 for w in desarme):
        errores.append("testigo sub3: el bloque del desarme no pone SUB3_IDX (%#x) en cero: un indice de un nivel "
                       "que ya no esta habilitaria el sub3 en la carga siguiente" % off_idx)

    # (4) SUB3_IDX tiene fila: cae en la reserva «sub3 (datos)»
    plan = leer_plan(doc) or []
    if not any(f["tipo"] == "reserva" and f["nombre"].startswith("sub3 (d")
               and f["desde"] <= cs.SUB3_IDX < f["hasta"] for f in list(plan) + list(filas_rangos)):
        errores.append("testigo sub3: SUB3_IDX (%#x) no cae en la reserva «sub3 (datos)» del plan" % cs.SUB3_IDX)
    return errores


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    v = sub.add_parser("verificar")
    v.add_argument("--doc", type=Path, default=RAIZ / "docs" / "14-coop-diseno.md")
    v.add_argument("--mods", type=Path, default=RAIZ / "mods")
    a = ap.parse_args(argv)
    errores = verificar(a.doc, a.mods)
    for e in errores:
        print("ROJO:", e)
    print("coop_diseno: %d problema(s)" % len(errores))
    return 1 if errores else 0


if __name__ == "__main__":
    sys.exit(main())
