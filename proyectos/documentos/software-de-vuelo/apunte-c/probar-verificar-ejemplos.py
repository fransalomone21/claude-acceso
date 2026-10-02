"""probar-verificar-ejemplos.py -- rompe verificar-ejemplos.py a proposito y exige el rojo correcto.

Trabaja sobre una COPIA del apunte en una carpeta temporal: el original no se toca.
Una sabotaje por entrada del mecanismo (ver el docstring del verificador), y cada uno exige
ver en las lineas del bloque [ROJO] el motivo QUE LE TOCA, no un rojo cualquiera. Mas el
control positivo: la copia sin tocar tiene que dar verde.
"""
import pathlib
import shutil
import subprocess
import sys
import tempfile

AQUI = pathlib.Path(__file__).resolve().parent


def correr(dir_):
    r = subprocess.run([sys.executable, str(dir_ / "verificar-ejemplos.py")], capture_output=True,
                       text=True, encoding="utf-8")
    rojo = r.stdout.split("[ROJO]", 1)[1] if "[ROJO]" in r.stdout else ""
    return r.returncode, rojo, r.stdout


def primer_con_salida(ej):
    # Se DERIVA del disco, no se escribe el nombre: si manana se renombra, el sabotaje sigue aplicando.
    for c in sorted(ej.glob("*.c")):
        if c.with_suffix(".salida").exists() and "ESPERA-WARNING" not in c.read_text(encoding="utf-8"):
            return c
    raise SystemExit("REVENTO: no hay un ejemplo con .salida para sabotear")


def con_warning(ej):
    for c in sorted(ej.glob("*.c")):
        if "ESPERA-WARNING" in c.read_text(encoding="utf-8"):
            return c
    raise SystemExit("REVENTO: no hay un ejemplo con ESPERA-WARNING para sabotear")


def sab_warning_nuevo(d):
    c = primer_con_salida(d / "ejemplos")
    t = c.read_text(encoding="utf-8").replace("int main(void) {", "int main(void) {\n\tint sin_usar = 0;", 1)
    c.write_text(t, encoding="utf-8")


def sab_salida(d):
    s = primer_con_salida(d / "ejemplos").with_suffix(".salida")
    s.write_text(s.read_text(encoding="utf-8") + "una linea que el programa no imprime\n", encoding="utf-8")


def sab_huerfano(d):
    (d / "ejemplos" / "zz-huerfano.c").write_text("int main(void) { return 0; }\n", encoding="utf-8")


def sab_cita_sin_archivo(d):
    m = sorted((d / "modulos").glob("*.typ"))[0]
    m.write_text(m.read_text(encoding="utf-8") + '\n#codigo("zz-no-existe")\n', encoding="utf-8")


def sab_warning_esperado_ausente(d):
    c = con_warning(d / "ejemplos")
    t = c.read_text(encoding="utf-8")
    c.write_text(t.replace("printf(\"Reporte enviado\\n\");", "printf(\"Reporte enviado %d\\n\", temperatura);"), encoding="utf-8")


CASOS = [
    ("un ejemplo con un warning nuevo", sab_warning_nuevo, "NO COMPILA"),
    ("una salida que el programa no imprime", sab_salida, "la salida NO coincide"),
    ("un .c que ningun modulo cita", sab_huerfano, "ejemplo huerfano"),
    ("un #codigo sin su .c", sab_cita_sin_archivo, "sin ejemplos/zz-no-existe.c"),
    ("un ESPERA-WARNING cuyo warning ya no sale", sab_warning_esperado_ausente, "esperaba un warning"),
]


def main():
    malos = 0
    with tempfile.TemporaryDirectory() as tmp:
        base = pathlib.Path(tmp) / "base"
        shutil.copytree(AQUI, base, ignore=shutil.ignore_patterns("*.pdf", "__pycache__"))
        rc, rojo, out = correr(base)
        if rc == 0 and not rojo:
            print("[OK] control positivo: la copia sin tocar da verde")
        else:
            print("[FALLA] control positivo: la copia sin tocar NO da verde\n" + out)
            malos += 1
        for i, (nombre, sabotear, motivo) in enumerate(CASOS):
            d = pathlib.Path(tmp) / f"s{i}"
            shutil.copytree(base, d)
            sabotear(d)
            rc, rojo, out = correr(d)
            linea = next((l for l in rojo.splitlines() if motivo in l), None)
            if rc == 1 and linea:
                print(f"[ROJO OK] {nombre}  <- {linea.strip()[:90]}")
            else:
                print(f"[FALLA] {nombre}: esperaba un rojo con '{motivo}' (exit={rc})\n{out}")
                malos += 1
    print("\nTODO BIEN" if malos == 0 else f"\n{malos} caso(s) en FALLA")
    return 1 if malos else 0


if __name__ == "__main__":
    sys.exit(main())
