# -*- coding: utf-8 -*-
"""comparar-matematica.py -- una pasada de PROSA no puede tocar la matematica.

Fase 5 del PDP (la voz de la casa sobre los modulos 7 a 15): se reescribe la
prosa y nada mas. Este script es lo que lo garantiza: saca de cada modulo, en
la version de un commit base y en la del disco,

  - cada segmento de matematica ($...$), normalizado en espacios;
  - cada numero que aparece en la prosa (con coma o punto decimal);
  - cada titulo de seccion (= / == / ===), que verificar-cobertura.py usa de ancla;
  - cada llamada a una figura (#fig-..., #graf-...) y cada #ejercicio("titulo");

y exige que las listas sean IGUALES, en el mismo orden. Una ecuacion movida de
lugar dentro de la prosa da igual; una cambiada, agregada o borrada da rojo.

Uso (desde electronica-analogica/):
    python comparar-matematica.py <commit-base>              # rojo si algo cambio
    python comparar-matematica.py <commit-base> --sabotaje   # cambia un numero, una
        ecuacion y un titulo en copias en memoria y exige rojo por CADA uno, y verde
        con la copia sana (control positivo)
"""

import re
import subprocess
import sys

MODULOS = ["m7-kirchhoff", "m8-nodos-mallas", "m9-teoremas", "m10-transitorios", "m11-fasores",
           "m12-bode", "m13-cuadripolos-ao", "m14-operacional", "m15-simulacion"]
RUTA = "apunte/modulos/%s.typ"


def sin_comentarios(t):
    return "\n".join(l for l in t.split("\n") if not l.lstrip().startswith("//"))


def extraer(texto):
    t = sin_comentarios(texto)
    mates = [re.sub(r"\s+", " ", m).strip() for m in re.findall(r"(?<!\\)\$(.+?)(?<!\\)\$", t, flags=re.S)]
    prosa = re.sub(r"(?<!\\)\$(.+?)(?<!\\)\$", " ", t, flags=re.S)
    numeros = re.findall(r"(?<![\w.,])\d+(?:[.,]\d+)?", prosa)
    titulos = [l.strip() for l in t.split("\n") if re.match(r"^=+ ", l.strip())]
    figuras = re.findall(r"#((?:fig|graf)-[a-z0-9-]+)", t)
    ejercicios = re.findall(r'#ejercicio\("([^"]*)"', t)
    return {"matematica": mates, "numeros": numeros, "titulos": titulos,
            "figuras": figuras, "ejercicios": ejercicios}


def comparar(base_txt, nuevo_txt, nombre):
    a, b = extraer(base_txt), extraer(nuevo_txt)
    malos = []
    for k in a:
        if a[k] != b[k]:
            # el primer elemento distinto, para que el rojo se explique solo
            for i, (x, y) in enumerate(zip(a[k], b[k])):
                if x != y:
                    malos.append("%s: %s #%d cambio: '%s' -> '%s'" % (nombre, k, i + 1, x[:60], y[:60]))
                    break
            else:
                malos.append("%s: %s cambio de cantidad: %d -> %d" % (nombre, k, len(a[k]), len(b[k])))
    return malos


def base(commit, mod):
    return subprocess.run(["git", "show", "%s:./%s" % (commit, RUTA % mod)], capture_output=True,
                          text=True, encoding="utf-8", check=True).stdout


def disco(mod):
    return open(RUTA % mod, encoding="utf-8").read()


def main():
    if len(sys.argv) < 2:
        sys.exit("uso: python comparar-matematica.py <commit-base> [--sabotaje]")
    commit = sys.argv[1]
    if "--sabotaje" in sys.argv:
        b = base(commit, "m11-fasores")
        def numero_de_prosa(t):
            # el primer numero que esta FUERA de la matematica: se le agrega un 9
            partes = re.split(r"((?<!\\)\$.+?(?<!\\)\$)", t, flags=re.S)
            for i, parte in enumerate(partes):
                if i % 2 == 0:
                    nueva = re.sub(r"(?<![\w.,])(\d+)(?![\w])", r"\g<1>9", parte, count=1)
                    if nueva != parte:
                        partes[i] = nueva
                        return "".join(partes)
            return t
        casos = {   # nombre: (texto roto, categoria que TIENE que dar el rojo)
            "un numero de la prosa": (numero_de_prosa(b), "numeros"),
            "una ecuacion": (re.sub(r"\$([^$]+)\$", r"$\1 + 0$", b, count=1), "matematica"),
            "un titulo": (re.sub(r"(?m)^== (.+)$", r"== \1 (bis)", b, count=1), "titulos"),
        }
        fallas = 0
        for nombre, (roto, cat) in casos.items():
            assert roto != b, "el sabotaje '%s' no cambio nada: no sabotea" % nombre
            r = comparar(b, roto, "m11")
            ok = bool(r) and all((": %s " % cat) in x for x in r)
            fallas += not ok
            print("[%s] sabotaje: %s -> %s" % ("ROJO OK" if ok else "FALLA", nombre, r[0] if r else "VERDE (ciego)"))
        prosa = b.replace("El Módulo", "El famoso Módulo", 1)
        r = comparar(b, prosa, "m11")
        print("[%s] control positivo: cambiar solo prosa da verde" % ("OK" if not r else "FALLA"))
        sys.exit(1 if fallas or r else 0)
    todos = []
    for mod in MODULOS:
        r = comparar(base(commit, mod), disco(mod), mod)
        todos += r
        print("[%s] %s" % ("ROJO" if r else "OK", mod))
    for m in todos:
        print("   ", m)
    print("\n%d modulos, %d diferencias de matematica, numeros, titulos, figuras o ejercicios" % (len(MODULOS), len(todos)))
    sys.exit(1 if todos else 0)


if __name__ == "__main__":
    main()
