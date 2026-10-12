#!/usr/bin/env python3
"""probar-t14.py -- el saboteador de T14, «la puerta infiere el proyecto sólo de lo que escribe Fran» (2026-10-12).

Requisito que prueba: L2-PTA-04 de docs/10-requisitos.md (diseño en docs/t14-lo-que-pide-fran.md). La puerta trae su
autotest con el caso 17; esto rompe la puerta en una COPIA (al lado del original, para que resuelva las mismas rutas)
y exige que el autotest dé rojo EN EL CASO QUE LE TOCA, no un rojo cualquiera. Un mutante por mecanismo: el recorte
entero, una etiqueta del recorte (cada etiqueta es una entrada), y la compuerta de fase como lectura pura. La copia se
borra siempre; el original no se toca.

Sale 0 si los tres mutantes se ven; 1 si alguno pasa (la prueba está ciega); 2 si el sabotaje no aplica (el texto a
reemplazar cambió: el saboteador quedó viejo). Es el --saboteador de defectos.py para DA-045.

Uso:  python proyectos/ingenieria/arquitectura-se/probar-t14.py
"""
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
PUERTA = RAIZ / ".claude" / "hooks" / "cascada_puerta.py"

MUTANTES = [
    # (texto original, texto mutado, el caso del autotest que tiene que dar MAL)
    ('sin_ajeno(str(ev.get("prompt", "")))', 'str(ev.get("prompt", ""))',
     "T14 CONTROL: senal en pasted_content"),
    ("<(pasted_content|task-notification|system-reminder)", "<(pasted_content|system-reminder)",
     "T14 CONTROL: senal en task-notification"),
    (r"fase_activa\.py\s+(?!-)\S", r"fase_activa\.py\s+ZZNUNCA",
     "T14 CONTROL: fase_activa.py <ruta de black>"),
]


def main() -> int:
    ciegos, viejos = 0, 0
    fuente = PUERTA.read_text(encoding="utf-8")
    for viejo, nuevo, caso in MUTANTES:
        if fuente.count(viejo) < 1:
            viejos += 1
            print("NO APLICA  el texto a mutar ya no esta (%s)" % viejo[:50])
            continue
        copia = PUERTA.with_name("cascada_puerta_mutante_t14.py")
        try:
            copia.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
            r = subprocess.run([sys.executable, str(copia), "--autotest"], capture_output=True, timeout=900)
            sal = (r.stdout + r.stderr).decode("utf-8", "replace")
        finally:
            copia.unlink(missing_ok=True)
        linea = next((l for l in sal.splitlines() if l.startswith("MAL") and caso in l), "")
        visto = r.returncode != 0 and bool(linea)
        ciegos += not visto
        print("%s  %-40s -> %s" % ("ok " if visto else "MAL", nuevo[:40],
                                   linea.strip()[:90] if visto else "NO LO VE (exit %d)" % r.returncode))
    if viejos:
        print("probar-t14: %d mutante(s) NO APLICAN: el saboteador quedo viejo" % viejos)
        return 2
    print("probar-t14: %s" % ("los %d mutantes, vistos en su caso" % len(MUTANTES) if not ciegos
                              else "%d CIEGO(S)" % ciegos))
    return 1 if ciegos else 0


if __name__ == "__main__":
    sys.exit(main())
