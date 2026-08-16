from pypdf import PdfReader
import pathlib

for n in ["AEA_Conceptos", "TPX", "TP_II_completo"]:
    r = PdfReader(n + ".pdf")
    partes = []
    for i, p in enumerate(r.pages, 1):
        partes.append("\n== p%d ==\n" % i + (p.extract_text() or ""))
    t = "".join(partes)
    pathlib.Path(n + ".txt").write_text(t, encoding="utf-8")
    print(n, len(r.pages), "pags", len(t), "chars")
