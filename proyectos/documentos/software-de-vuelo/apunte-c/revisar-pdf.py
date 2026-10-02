"""revisar-pdf.py -- que ningun bloque del PDF se salga por abajo de la pagina.

Un bloque de codigo que no se puede partir y es mas alto que una pagina no da error en
Typst: se sale por abajo y se pisa con el numero de pagina. Paso dos veces (modulo 9,
2026-10-02) y se vio recien mirando el render. Esto lo mide en todas las paginas.

  python revisar-pdf.py [apunte.pdf]   mide; sale 1 si alguna pagina tiene texto a la
                                       altura del numero de pagina o mas abajo
  python revisar-pdf.py --probar       el saboteador: compila un PDF con un bloque de 80
                                       lineas que no se parte y EXIGE ver el rojo; despues,
                                       uno de 20 lineas y exige el verde

Necesita pymupdf (pip install pymupdf) y, para --probar, typst en el PATH.
"""
import pathlib
import subprocess
import sys
import tempfile

AQUI = pathlib.Path(__file__).resolve().parent


def desbordes(pdf):
    import pymupdf
    malas = []
    with pymupdf.open(pdf) as doc:
        for i, pag in enumerate(doc):
            bloques = pag.get_text("blocks")
            numeros = [b for b in bloques if b[4].strip().isdigit()]
            if not numeros:
                continue
            y_numero = max(b[1] for b in numeros)
            pisan = [b for b in bloques if not b[4].strip().isdigit() and b[3] > y_numero - 2]
            if pisan:
                malas.append((i + 1, pisan[0][4].strip().splitlines()[0][:50]))
    return malas


def probar():
    plantilla = '#set page(paper: "a4", numbering: "1")\n= Prueba\n#block(breakable: false)[#raw("{lineas}", lang: "c", block: true)]\n'
    casos = [(80, True), (20, False)]
    bien = True
    with tempfile.TemporaryDirectory() as tmp:
        for n, espera_rojo in casos:
            typ = pathlib.Path(tmp) / f"p{n}.typ"
            typ.write_text(plantilla.replace("{lineas}", "\\n".join(f"int x{k} = {k};" for k in range(n))),
                           encoding="utf-8")
            r = subprocess.run(["typst", "compile", str(typ)], capture_output=True, text=True,
                               encoding="utf-8", errors="replace")  # typst escribe UTF-8; en Windows el defecto es cp1252
            if r.returncode != 0:
                print(f"[ROJO] no compila la prueba de {n} lineas: {r.stderr.strip()}")
                return 1
            malas = desbordes(typ.with_suffix(".pdf"))
            if espera_rojo and not malas:
                print(f"[FALLA] {n} lineas sin partir: tenia que dar rojo y dio verde")
                bien = False
            elif not espera_rojo and malas:
                print(f"[FALLA] {n} lineas: tenia que dar verde y dio {malas}")
                bien = False
            else:
                print(f"[OK] {n} lineas: {'rojo' if espera_rojo else 'verde'}, como debe")
    print("TODO BIEN" if bien else "HAY FALLAS")
    return 0 if bien else 1


def main():
    if "--probar" in sys.argv:
        return probar()
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    pdf = pathlib.Path(args[0]) if args else AQUI / "apunte.pdf"
    if not pdf.exists():
        print(f"[ROJO] no existe {pdf}: compilar primero")
        return 1
    malas = desbordes(pdf)
    if malas:
        print("[ROJO] texto a la altura del numero de pagina (un bloque se sale por abajo):")
        for pag, texto in malas:
            print(f"  - pagina {pag}: {texto!r}")
        return 1
    print(f"Verde: ninguna pagina de {pdf.name} tiene texto pisando el numero de pagina.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
