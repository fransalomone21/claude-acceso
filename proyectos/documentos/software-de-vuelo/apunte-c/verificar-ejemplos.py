"""verificar-ejemplos.py -- que todo programa del apunte de C compile y diga lo que el apunte dice.

Las ENTRADAS del mecanismo (y cada una tiene su sabotaje en probar-verificar-ejemplos.py):
  - ejemplos/<nombre>.c      : compila en el gcc de Ubuntu (WSL, el de la catedra) con
                               -Wall -Wextra -std=c11 -Werror: cero warnings (LEA-01).
                               Excepcion DECLARADA en la ultima linea del .c:
                                 // ESPERA-WARNING: <texto>
                               compila SIN -Werror y EXIGE que gcc avise con <texto>
                               (el ejemplo existe para mostrar ese warning).
  - ejemplos/<nombre>.salida : lo que el apunte imprime como "la corrida real". Se corre el
                               programa (con <nombre>.entrada como stdin, si existe) y stdout
                               tiene que ser IGUAL. --regenerar lo reescribe (solo a proposito).
  - los .typ                 : cada .c citado con #codigo("<nombre>") y cada #codigo con su .c.
  - ejemplos/<nombre>/       : un PROYECTO de varios archivos (.c y .h). Se compilan juntos
                               todos sus .c, con los mismos flags y -Werror, y se compara
                               ejemplos/<nombre>.salida (y .entrada) como en un ejemplo suelto.
                               Se cita con #proyecto("<nombre>", archivos: ("a.h", "a.c", ...))
                               y la lista tiene que ser EXACTAMENTE los .c y .h de la carpeta:
                               un archivo del proyecto que el apunte no muestra es rojo.
  - el entorno               : sin WSL o sin gcc, ROJO (falla cerrado, no verde mudo).

Sale con 0 si todo da, 1 si algo falla.
"""
import pathlib
import re
import subprocess
import sys

AQUI = pathlib.Path(__file__).resolve().parent
EJ = AQUI / "ejemplos"
FLAGS = "-Wall -Wextra -std=c11"


def ruta_wsl(p):
    if sys.platform != "win32":  # Linux nativo (la sesion en la nube): la ruta ya es la de bash
        return str(p)
    s = str(p).replace("\\", "/")
    return "/mnt/" + s[0].lower() + s[2:]


def wsl(cmd, entrada=""):
    prefijo = ["wsl", "-e"] if sys.platform == "win32" else []
    try:
        r = subprocess.run(prefijo + ["bash", "-c", cmd], input=entrada, capture_output=True,
                           text=True, encoding="utf-8", timeout=60)
    except (OSError, subprocess.TimeoutExpired) as e:
        return 127, "", str(e)
    return r.returncode, r.stdout, r.stderr


def citados():
    usos = {}
    for typ in AQUI.rglob("*.typ"):
        for m in re.finditer(r'#codigo\(\s*"([^"]+)"', typ.read_text(encoding="utf-8")):
            usos.setdefault(m.group(1), []).append(typ.name)
    return usos


def proyectos_citados():
    """{nombre: (lista de archivos que muestra el apunte, [archivos .typ que lo citan])}"""
    usos = {}
    for typ in AQUI.rglob("*.typ"):
        texto = typ.read_text(encoding="utf-8")
        for m in re.finditer(r'#proyecto\(\s*"([^"]+)"\s*,\s*archivos:\s*\(([^)]*)\)', texto):
            archivos = re.findall(r'"([^"]+)"', m.group(2))
            previo = usos.get(m.group(1), (archivos, []))
            usos[m.group(1)] = (previo[0], previo[1] + [typ.name])
    return usos


def correr_y_comparar(exe, base, nombre, regenerar, fallas):
    """Corre el ejecutable con base.entrada como stdin y compara contra base.salida."""
    ent = base.with_suffix(".entrada")
    rc, out, err = wsl(exe, ent.read_text(encoding="utf-8") if ent.exists() else "")
    sal = base.with_suffix(".salida")
    if regenerar:
        sal.write_text(out, encoding="utf-8", newline="\n")
    elif sal.exists() and out != sal.read_text(encoding="utf-8"):
        fallas.append(f"{nombre}: la salida NO coincide con {nombre}.salida\n"
                      f"      corrida: {out!r}\n      apunte : {sal.read_text(encoding='utf-8')!r}")
        return False
    return sal.exists()


def main():
    regenerar = "--regenerar" in sys.argv
    fuentes = sorted(EJ.glob("*.c"))
    if not fuentes:
        print("[ROJO]\n  - no hay ningun ejemplo en ejemplos/: el verificador no esta midiendo nada")
        return 1
    rc, out, err = wsl("gcc --version | head -1")
    if rc != 0 or not out.strip():
        print("[ROJO]\n  - no hay gcc en WSL (" + (err.strip() or "sin salida") + "): sin compilador no se verifica nada")
        return 1
    print("compilador:", out.strip())
    fallas = []
    for c in fuentes:
        nombre = c.stem
        lineas = c.read_text(encoding="utf-8").splitlines()
        # La marca va en la ULTIMA linea (asi no corre la numeracion que cita gcc); se busca en todas.
        espera = next((m for m in (re.match(r"\s*//\s*ESPERA-WARNING:\s*(.+)", x) for x in lineas) if m), None)
        exe = "/tmp/apunte_c_" + nombre
        werror = "" if espera else " -Werror"
        # Se compila DESDE la carpeta y con el nombre relativo: asi el warning sale como lo
        # veria el alumno ("m01-warning.c: In function..."), no con /mnt/c/Users/...
        rc, _, err = wsl(f"cd '{ruta_wsl(EJ)}' && gcc {FLAGS}{werror} {nombre}.c -o {exe}")
        if rc != 0:
            fallas.append(f"{nombre}: NO COMPILA con {FLAGS}{werror}\n      " + err.strip().replace("\n", "\n      "))
            continue
        if espera and espera.group(1).strip() not in err:
            fallas.append(f"{nombre}: esperaba un warning con '{espera.group(1).strip()}' y gcc dijo: {err.strip() or '(nada)'}")
            continue
        aviso = c.with_suffix(".warning")
        if espera and regenerar:
            aviso.write_text(err, encoding="utf-8", newline="\n")
        elif espera and aviso.exists() and err != aviso.read_text(encoding="utf-8"):
            fallas.append(f"{nombre}: el warning NO coincide con {nombre}.warning (el apunte muestra otro)")
            continue
        if not espera and err.strip():
            fallas.append(f"{nombre}: compilo pero gcc imprimio algo: {err.strip()}")
            continue
        antes = len(fallas)
        hay_salida = correr_y_comparar(exe, c, nombre, regenerar, fallas)
        if len(fallas) > antes:
            continue
        print(f"  ok  {nombre}" + ("  (warning esperado)" if espera else "")
              + ("  + salida" + (" REGENERADA" if regenerar else "") if hay_salida else ""))
    proyectos = sorted(d for d in EJ.iterdir() if d.is_dir())
    for d in proyectos:
        nombre = d.name
        fuentes_p = sorted(x.name for x in d.glob("*.c"))
        if not fuentes_p:
            fallas.append(f"{nombre}/: un proyecto sin ningun .c")
            continue
        exe = "/tmp/apunte_c_" + nombre
        rc, _, err = wsl(f"cd '{ruta_wsl(d)}' && gcc {FLAGS} -Werror {' '.join(fuentes_p)} -o {exe}")
        if rc != 0:
            fallas.append(f"{nombre}/: NO COMPILA con {FLAGS} -Werror\n      " + err.strip().replace("\n", "\n      "))
            continue
        if err.strip():
            fallas.append(f"{nombre}/: compilo pero gcc imprimio algo: {err.strip()}")
            continue
        antes = len(fallas)
        hay_salida = correr_y_comparar(exe, EJ / nombre, nombre, regenerar, fallas)
        if len(fallas) > antes:
            continue
        print(f"  ok  {nombre}/  (proyecto: {', '.join(fuentes_p)})"
              + ("  + salida" + (" REGENERADA" if regenerar else "") if hay_salida else ""))
    usos = citados()
    for c in fuentes:
        if c.stem not in usos:
            fallas.append(f"{c.stem}.c no lo cita ningun #codigo: ejemplo huerfano")
    for n, donde in sorted(usos.items()):
        if not (EJ / (n + ".c")).exists():
            fallas.append(f'#codigo("{n}") en {", ".join(donde)} sin ejemplos/{n}.c')
    usos_p = proyectos_citados()
    for d in proyectos:
        if d.name not in usos_p:
            fallas.append(f"{d.name}/ no lo cita ningun #proyecto: proyecto huerfano")
            continue
        en_disco = sorted(x.name for x in d.iterdir() if x.suffix in (".c", ".h"))
        mostrados = sorted(usos_p[d.name][0])
        for falta in sorted(set(en_disco) - set(mostrados)):
            fallas.append(f"{d.name}/{falta}: archivo del proyecto que el apunte no muestra")
        for sobra in sorted(set(mostrados) - set(en_disco)):
            fallas.append(f'#proyecto("{d.name}") muestra {sobra}, que no existe en ejemplos/{d.name}/')
    for n, (_, donde) in sorted(usos_p.items()):
        if not (EJ / n).is_dir():
            fallas.append(f'#proyecto("{n}") en {", ".join(donde)} sin la carpeta ejemplos/{n}/')
    if fallas:
        print("\n[ROJO]")
        for f in fallas:
            print("  -", f)
        return 1
    print(f"\nTodo en verde: {len(fuentes) + len(proyectos)} programas compilan con cero warnings y dicen lo que el apunte muestra.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
