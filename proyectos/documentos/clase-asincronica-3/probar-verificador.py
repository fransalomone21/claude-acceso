# probar-verificador.py -- rompe verificar.py a proposito y exige ver el rojo.
#
#   python probar-verificador.py
#
# Por que existe: verificar.py dio verde la primera vez que corrio. Un
# chequeo que nunca dijo otra cosa esta SIN VERIFICAR -- no se sabe si mide
# algo o si devuelve verde pase lo que pase. Aca se le mete un defecto por
# vez, se exige que se ponga en rojo, y se restaura.
#
# Y hay un cuarto paso que no es decorativo: despues de restaurar, se vuelve
# a correr verificar.py ENTERO. Restaurar el archivo fuente no alcanza --
# los .asc, los .log y los .raw generados quedan con el sabotaje adentro, y
# un chequeo posterior que mire solo el fuente daria verde sobre un disco
# sucio. Esa ceguera ya paso en este repo con probar-chequeo-lecciones.ps1.

import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
HERR = RAIZ / "herramientas"

# (archivo, texto_original, texto_saboteado, que_tiene_que_detectar)
SABOTAJES = [
    ("generar.py",
     'c1 = s.sym("cap", "C1", (480, TOP), "R0", value="0.25u")',
     'c1 = s.sym("cap", "C1", (480, TOP), "R0", value="0.30u")',
     "un valor de componente cambiado (C del 6.17: 0,25 uF -> 0,30 uF)"),

    ("bloque2.py",
     '".ic I(L1)=10 V(wR)=0",',
     '".ic I(L1)=9 V(wR)=0",',
     "una condicion inicial cambiada (7.4: iL(0) 10 A -> 9 A)"),

    ("bloque3.py",
     '".step param R list 640 800 960",',
     '".step param R list 640 800 1000",',
     "un valor barrido por .step cambiado (8.38: 960 -> 1000 ohm)"),

    ("generar.py",
     'value="200u", value2="Rser=1u"',
     'value="200u", value2="Rser=0"',
     "un circuito que directamente NO CORRE (matriz sobredefinida en el 6.2)"),

    ("bloque2.py",
     '".meas TRAN t80   WHEN V(wR)=320",',
     "",
     "una medicion BORRADA (si falta el .meas, no puede haber comparacion)"),
]


def correr_verificador():
    r = subprocess.run([sys.executable, str(RAIZ / "verificar.py")],
                       capture_output=True, text=True)
    return r.returncode, (r.stdout or "") + (r.stderr or "")


def main():
    fallas = []

    print("=" * 74)
    print("CONTROL POSITIVO -- sin tocar nada, tiene que dar VERDE")
    print("=" * 74)
    rc, out = correr_verificador()
    print("   ", out.strip().splitlines()[-1] if out.strip() else "(sin salida)")
    if rc != 0:
        print("\n[X] el control positivo ya viene en rojo: no tiene sentido")
        print("    sabotear nada hasta que el estado limpio pase.")
        return 1

    for archivo, viejo, nuevo, descripcion in SABOTAJES:
        ruta = HERR / archivo
        original = ruta.read_text(encoding="utf-8")
        if viejo not in original:
            fallas.append(f"NO SE PUDO SABOTEAR {archivo}: no aparece el texto "
                          f"{viejo!r}. El sabotaje quedo desactualizado -- y un "
                          f"sabotaje que no se aplica da verde por la razon "
                          f"equivocada.")
            continue
        print()
        print("=" * 74)
        print(f"SABOTAJE: {descripcion}")
        print("=" * 74)
        try:
            ruta.write_text(original.replace(viejo, nuevo, 1), encoding="utf-8")
            rc, out = correr_verificador()
            lineas = [l for l in out.splitlines() if l.strip()]
            for l in lineas[-8:]:
                print("   ", l)
            if rc == 0:
                fallas.append(f"CIEGO ante {descripcion}: verificar.py dio "
                              f"VERDE con el defecto puesto.")
            else:
                print("    -> rojo, como corresponde.")
        finally:
            ruta.write_text(original, encoding="utf-8")

    print()
    print("=" * 74)
    print("LIMPIEZA -- restaurar el fuente no alcanza: los .asc y los .log")
    print("generados todavia tienen el ultimo sabotaje adentro.")
    print("=" * 74)
    rc, out = correr_verificador()
    print("   ", out.strip().splitlines()[-1] if out.strip() else "(sin salida)")
    if rc != 0:
        fallas.append("el disco quedo SUCIO despues de restaurar: verificar.py "
                      "sigue en rojo. Correr 'python verificar.py' a mano.")

    print()
    if fallas:
        print(f"[X] {len(fallas)} problemas:")
        for f in fallas:
            print("   ", f)
        return 1
    print(f"[OK] los {len(SABOTAJES)} sabotajes se detectaron, y el disco "
          f"quedo limpio.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
