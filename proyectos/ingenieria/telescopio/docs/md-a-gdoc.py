"""Convierte un .md del proyecto en HTML con estilos EN LINEA, que es lo unico
que Google Docs respeta al importar (no lee <style> ni clases).

Uso:  python docs/md-a-gdoc.py docs/07-guia-armado.md salida.html
El HTML se sube a Drive con conversion a Google Doc. La fuente sigue siendo
el .md: el Doc se regenera, no se edita a mano lo que viene del repo.
Paleta: la del modelo 3D (06-modelo-3d.html), para que se reconozcan.
"""
import base64
import os
import re
import sys

import markdown

INK, MUTED, ACCENT, LINE, SOFT, CALLOUT = "#15202c", "#5a6878", "#b8650a", "#cfd7e1", "#eef1f5", "#fdf3e6"
BODY = "font-family:Arial;font-size:11pt;color:%s;line-height:1.4" % INK


def estilos(html):
    s = html
    s = s.replace("<h1>", '<p style="font-family:Arial;font-size:9pt;color:%s;letter-spacing:2px">TELESCOPIO 200/1200 · PLATAFORMA ECUATORIAL · 34,5° S</p><h1 style="font-family:Arial;font-size:26pt;color:%s;margin-bottom:4pt">' % (ACCENT, INK))
    s = s.replace("<h2>", '<h2 style="font-family:Arial;font-size:17pt;color:%s;margin-top:22pt">' % ACCENT)
    s = s.replace("<h3>", '<h3 style="font-family:Arial;font-size:13pt;color:%s;margin-top:14pt">' % INK)
    s = s.replace("<p>", '<p style="%s">' % BODY)
    s = s.replace("<li>", '<li style="%s;margin-bottom:3pt">' % BODY)
    s = s.replace("<strong>", '<strong style="color:%s">' % INK)
    s = s.replace("<code>", '<code style="font-family:Consolas;font-size:10pt;color:%s">' % MUTED)
    s = s.replace("<hr />", '<hr style="border:0;border-top:1px solid %s">' % LINE)
    # recuadro: un blockquote pasa a ser una tabla de una celda con fondo
    s = re.sub(r"<blockquote>\s*(.*?)\s*</blockquote>",
               lambda m: '<table style="border-collapse:collapse;width:100%%"><tr><td style="background:%s;border-left:4px solid %s;padding:8pt 12pt">%s</td></tr></table><p></p>' % (CALLOUT, ACCENT, m.group(1)),
               s, flags=re.S)
    s = s.replace("<table>", '<table style="border-collapse:collapse;width:100%">')
    s = s.replace("<th>", '<th style="background:%s;border:1px solid %s;padding:5pt;font-family:Arial;font-size:10pt;color:%s;text-align:left">' % (SOFT, LINE, MUTED))
    s = s.replace("<td>", '<td style="border:1px solid %s;padding:5pt;font-family:Arial;font-size:10pt;vertical-align:top">' % LINE)
    return s


def incrustar(html, base):
    """Las imagenes locales (![...](img/x.png)) van adentro del HTML en base64: Google Docs las
    guarda al importar (probado el 2026-10-07 con un borrador: la imagen volvio en el export)."""
    def una(m):
        ruta = os.path.join(base, m.group(2))
        if not os.path.exists(ruta):
            sys.exit("ROJO: la imagen %s no existe" % ruta)
        b64 = base64.b64encode(open(ruta, "rb").read()).decode()
        return '<img alt="%s" src="data:image/png;base64,%s" width="600">' % (m.group(1), b64)
    return re.sub(r'<img alt="([^"]*)" src="([^"]+\.png)" ?/?>', una, html)


def main(src, dst):
    md = open(src, encoding="utf-8").read()
    html = incrustar(markdown.markdown(md, extensions=["tables"]), os.path.dirname(os.path.abspath(src)))
    if "<h1>" not in html:
        sys.exit("ROJO: el .md no tiene titulo '# ...' y el encabezado no se puede poner")
    out = '<html><head><meta charset="utf-8"></head><body style="%s">%s</body></html>' % (BODY, estilos(html))
    open(dst, "w", encoding="utf-8").write(out)
    print("OK %s -> %s (%d caracteres, %d tablas, %d imagenes)" % (src, dst, len(out), out.count("<table"), out.count("<img")))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
