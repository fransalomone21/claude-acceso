#!/usr/bin/env python3
"""probar-t13.py -- el saboteador de T13, «la fase manda» (2026-10-12).

Requisitos que prueba: L2-PTA-01, L2-AUD-01, L2-CMP-03 y L2-VER-01 de docs/10-requisitos.md. Cada pieza ya trae su
autotest con casos de T13; esto rompe la pieza en una COPIA (al lado del original, para que resuelva las mismas rutas)
y exige que SU autotest de rojo EN EL CASO QUE LE TOCA, no un rojo cualquiera (un sabotaje que da rojo por el motivo
equivocado se ve igual que uno que anda). La copia se borra siempre; el original no se toca.

Sale 0 si los cuatro mutantes se ven; 1 si alguno pasa (la prueba esta ciega); 2 si el sabotaje no aplica (el texto
a reemplazar cambio: el saboteador quedo viejo) o algo revienta. Es el --saboteador de defectos.py para DA-027 a
DA-029 y DA-033.

Uso:  python proyectos/ingenieria/arquitectura-se/probar-t13.py
"""
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
HOOKS = RAIZ / ".claude" / "hooks"

MUTANTES = [
    # (pieza, texto original, texto mutado, el caso de su autotest que tiene que dar MAL)
    (HOOKS / "cascada_puerta.py", 'FASES_DESARROLLO = ("Fase A", "Fase B", "Fase C", "Fase D")',
     "FASES_DESARROLLO = ()", "T13 SABOTAJE: Fase C sin requisitos, editar diseno"),
    (HOOKS / "cascada_puerta.py", 'elif f[1] in FASES_DESARROLLO and not ent.get(n, {}).get("requisitos"):',
     "elif False:", "T13 --verificar LISTA expuestos"),
    (RAIZ / "auditar-sesion.py", "if fase and fase[1] in g.FASES_DESARROLLO:", "if False:",
     "T13: Fase C SIN requisitos -> P7 ROJO"),
    (HOOKS / "fase_activa.py", 'if t[0].split(" (")[0] in FASES_DESARROLLO:', "if False:",
     "T13: Fase C lista requisitos NO DECLARADO"),
]


def main() -> int:
    ciegos, viejos = 0, 0
    for pieza, viejo, nuevo, caso in MUTANTES:
        fuente = pieza.read_text(encoding="utf-8")
        if fuente.count(viejo) < 1:
            viejos += 1
            print("NO APLICA  %s: el texto a mutar ya no esta (%s)" % (pieza.name, viejo[:50]))
            continue
        copia = pieza.with_name(pieza.stem.replace("-", "_") + "_mutante_t13.py")
        try:
            copia.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
            r = subprocess.run([sys.executable, str(copia), "--autotest"], capture_output=True, timeout=900)
            sal = (r.stdout + r.stderr).decode("utf-8", "replace")
        finally:
            copia.unlink(missing_ok=True)
        linea = next((l for l in sal.splitlines() if l.startswith("MAL") and caso in l), "")
        visto = r.returncode != 0 and bool(linea)
        ciegos += not visto
        print("%s  %-18s %-40s -> %s" % ("ok " if visto else "MAL", pieza.name, nuevo[:40],
                                          linea.strip()[:90] if visto else "NO LO VE (exit %d)" % r.returncode))
    if viejos:
        print("probar-t13: %d mutante(s) NO APLICAN: el saboteador quedo viejo" % viejos)
        return 2
    print("probar-t13: %s" % ("los %d mutantes, vistos en su caso" % len(MUTANTES) if not ciegos
                              else "%d CIEGO(S)" % ciegos))
    return 1 if ciegos else 0


if __name__ == "__main__":
    sys.exit(main())
