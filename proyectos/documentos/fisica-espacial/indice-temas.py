#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
indice-temas.py — emite docs/INDICE-TEMAS.md: el mapa de TODO lo que el
apunte ya cubre, por titulo y subtitulo, sin abrir el PDF ni los .typ.

POR QUE EXISTE. Hasta el 2026-09-17, contestar "¿esto ya esta en el apunte?"
obligaba a una de dos cosas caras: leer el PDF de 163 paginas, o grepear a
ciegas los veinte modulos. Las dos se pagaban ENTERAS cada vez que aparecia
material nuevo de la catedra. El indice es el flujo de informacion que
faltaba: una pasada de lectura barata que dice si el tema esta, y si esta,
en que modulo y en que seccion.

NO SE ESCRIBE A MANO. Un indice escrito a mano diverge del apunte en el
primer modulo que se toque, y diverge en silencio. Este se DERIVA del fuente
—el orden sale de apunte.typ, igual que los numeros de modulo (regla propia
5 del contrato)— y se regenera:

    python indice-temas.py            # reescribe docs/INDICE-TEMAS.md
    python indice-temas.py --check    # NO escribe; sale 1 si quedo viejo

El --check es lo que lo vuelve verificable: si alguien agrega una seccion y
no regenera, el chequeo se pone en rojo en vez de dejar un indice que miente.
"""

import io
import os
import re
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
APUNTE = os.path.join(RAIZ, "apunte")
SALIDA = os.path.join(RAIZ, "docs", "INDICE-TEMAS.md")


def leer(ruta):
    return io.open(ruta, encoding="utf-8").read()


def orden_modulos():
    """El orden vive en apunte.typ y en ningun otro lado."""
    ap = leer(os.path.join(APUNTE, "apunte.typ"))
    return re.findall(r'#include "modulos/(m\d+-[a-z-]+)\.typ"', ap)


def partes():
    """{nombre-de-archivo -> (numero de parte, titulo de parte)}"""
    ap = leer(os.path.join(APUNTE, "apunte.typ"))
    mapa, parte = {}, (0, "(sin parte)")
    for m in re.finditer(r'#parte\((\d+),\s*"([^"]+)"|#include "modulos/(m\d+-[a-z-]+)\.typ"', ap):
        if m.group(1):
            parte = (int(m.group(1)), m.group(2))
        else:
            mapa[m.group(3)] = parte
    return mapa


# `#M("clave")` se escribe en la prosa y se resuelve al compilar; en el indice
# molesta, asi que se lo reemplaza por la clave entre comillas simples.
def limpiar(texto):
    texto = re.sub(r'#M\("([a-z-]+)"\)', r"‹\1›", texto)
    texto = texto.replace('#";"', ";").replace("\\/", "/")
    return " ".join(texto.split())


def temas_de(fuente):
    """Todo lo que en un modulo se puede buscar: secciones, deducciones,
    ejemplos, cajas de guia y etiquetas de ecuacion."""
    salida = []
    for linea in fuente.splitlines():
        s = linea.strip()
        # El titulo de Typst va SIEMPRE en la columna 0. Pedirlo asi no es
        # cosmetica: sin eso, un renglon de continuacion de una ecuacion que
        # empieza con `=` entra al indice como si fuera una seccion, y ya
        # metio una ("m bold(a)$ con $bold(F)$...") en la primera corrida.
        m = re.match(r"^(=+)\s+(.*)$", linea) if linea[:1] == "=" else None
        if m:
            salida.append(("sec", len(m.group(1)), limpiar(m.group(2))))
            continue
        for fn, etiq in (("deduccion", "de donde sale"), ("ejemplo", "ejemplo"),
                         ("guia", "guia de la catedra")):
            m = re.match(r'^#%s\("([^"]*)"' % fn, s)
            if m:
                salida.append((etiq, 3, limpiar(m.group(1))))
    return salida


def ecuaciones(fuente):
    # `#repaso(destino: <etiqueta>)` en plantilla.typ linkea a donde se dedujo
    # un resultado la primera vez -- es una REFERENCIA a otro modulo, no una
    # definicion nueva. Sacar `destino: <etiqueta>` antes de buscar: si no,
    # cada uso de #repaso() hace aparecer la etiqueta ajena como si este
    # modulo la hubiera definido.
    fuente = re.sub(r"destino:\s*<[a-z0-9-]+>", "", fuente)
    # Sin deduplicar, una etiqueta aparece dos veces cuando la ecuacion se
    # reescribe mas abajo en el mismo modulo. El indice pregunta "¿existe?",
    # no "¿cuantas veces?".
    vistas, salida = set(), []
    for e in re.findall(r"<([a-z0-9-]+)>", fuente):
        if e not in vistas:
            vistas.add(e)
            salida.append(e)
    return salida


def construir():
    orden, mapa_partes = orden_modulos(), partes()
    L = []
    L.append("# Índice de temas del apunte — qué está y dónde")
    L.append("")
    L.append("**Este archivo lo genera `indice-temas.py`. No se edita a mano:**")
    L.append("se deriva de `apunte/apunte.typ` y de los `.typ` de cada módulo, y se")
    L.append("regenera con `python indice-temas.py`. Si quedó viejo, `python")
    L.append("indice-temas.py --check` lo dice en rojo.")
    L.append("")
    L.append("Para qué sirve: contestar **«¿el apunte ya cubre esto?»** sin abrir el")
    L.append("PDF de 163 páginas ni leer veinte módulos. Se busca acá el tema; si")
    L.append("está, la fila dice el módulo y la sección exacta que hay que tocar.")
    L.append("Si no está, hay que escribirlo — y el módulo donde entra también sale")
    L.append("de acá, por vecindad.")
    L.append("")
    L.append("Las etiquetas `<...>` son los nombres de las ecuaciones numeradas: es")
    L.append("la forma más rápida de saber si una FÓRMULA ya está deducida en algún")
    L.append("lado. Se referencian en la prosa como `@etiqueta`.")
    L.append("")

    parte_actual = None
    for i, archivo in enumerate(orden, 1):
        fuente = leer(os.path.join(APUNTE, "modulos", archivo + ".typ"))
        clave = re.search(r'clave:\s*"([a-z-]+)"', fuente).group(1)
        titulo = re.search(r'#modulo\("([^"]+)"', fuente).group(1)
        parte = mapa_partes.get(archivo, (0, "(sin parte)"))
        if parte != parte_actual:
            parte_actual = parte
            L.append("")
            L.append("## Parte %s — %s" % (parte[0], parte[1]))
        L.append("")
        L.append("### %d. %s  ·  `%s`" % (i, titulo, clave))
        L.append("")
        L.append("<small>`apunte/modulos/%s.typ`</small>" % archivo)
        L.append("")
        for tipo, nivel, texto in temas_de(fuente):
            if tipo == "sec":
                L.append("%s- **%s**" % ("  " * (nivel - 2), texto))
            else:
                L.append("  - *(%s)* %s" % (tipo, texto))
        ecs = ecuaciones(fuente)
        if ecs:
            L.append("")
            L.append("  Ecuaciones: %s" % ", ".join("`<%s>`" % e for e in ecs))

    anexo = os.path.join(APUNTE, "anexos", "a1-guia-ejercicios.typ")
    if os.path.exists(anexo):
        fuente = leer(anexo)
        L.append("")
        L.append("## Anexo A — la guía de la cátedra, ficha por ficha")
        L.append("")
        for t in re.findall(r'#subtitulo-anexo\("([^"]+)"\)', fuente):
            L.append("- **%s**" % limpiar(t))
        L.append("")
        L.append("Los enunciados completos están transcriptos en")
        L.append("`fuentes/GUIA-ENUNCIADOS.md`; las fichas del anexo son")
        L.append("enunciado + «resuelve:» + respuesta, sin desarrollo.")
    L.append("")
    return "\n".join(L)


def main():
    nuevo = construir()
    if "--check" in sys.argv:
        viejo = leer(SALIDA) if os.path.exists(SALIDA) else ""
        if viejo != nuevo:
            print("INDICE-TEMAS.md quedo VIEJO respecto de los .typ.")
            print("Arreglo:  python indice-temas.py")
            return 1
        print("OK  INDICE-TEMAS.md coincide con el fuente del apunte.")
        return 0
    io.open(SALIDA, "w", encoding="utf-8", newline="\n").write(nuevo)
    print("Escrito: %s  (%d lineas)" % (SALIDA, nuevo.count("\n") + 1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
