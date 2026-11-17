"""Cobertura: cada termino del glosario de las unidades 7 a 13 en el texto del PDF del resumen.
uso: python cobertura.py <dir apunte-iise> [--romper]  (--romper saca 'holgura' del texto y exige rojo)"""
import re, sys, unicodedata
from pathlib import Path
import fitz

D = Path(sys.argv[1])
norm = lambda t: re.sub(r"\s+", " ", "".join(c for c in unicodedata.normalize("NFD", t.lower()) if unicodedata.category(c) != "Mn"))
bloque = (D / "fuentes/glosario.md").read_text(encoding="utf-8").split("## Unidad 7", 1)[1].split("## Pendiente", 1)[0]
terminos = re.findall(r"^### (.+)$", bloque, re.M)
texto = norm(" ".join(p.get_text() for p in fitz.open(D / "resumenes/resumen-2do-parcial.pdf")))
if "--romper" in sys.argv:
    texto = texto.replace("holgura", "")
faltan = [t for t in terminos if norm(re.split(r" — | \(", t)[0].strip()) not in texto]
if "holgura" not in texto:
    faltan.append("holgura")
print(f"{len(terminos)} terminos; faltan {len(faltan)}")
for f in faltan:
    print("  FALTA:", f)
sys.exit(1 if faltan else 0)
