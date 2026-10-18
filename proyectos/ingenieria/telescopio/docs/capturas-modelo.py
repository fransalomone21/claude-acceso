"""Saca imagenes del modelo 3D para los Docs (vistas por boton, explotada, el 12")."""
import sys
from pathlib import Path
from playwright.sync_api import sync_playwright

html = Path(sys.argv[1]).resolve().as_uri()
out = Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)

def vista(page, texto):
    page.locator(".views button", has_text=texto).first.click()
    page.wait_for_timeout(1800)

def explotar(page, v):
    page.evaluate("v => { const e = document.getElementById('explode'); e.value = v; e.dispatchEvent(new Event('input', {bubbles: true})); }", v)
    page.wait_for_timeout(1500)

with sync_playwright() as p:
    b = p.chromium.launch(channel="chrome", args=["--use-angle=swiftshader", "--enable-unsafe-swiftshader"])
    page = b.new_page(viewport={"width": 1500, "height": 1100})
    errores = []
    page.on("pageerror", lambda e: errores.append(str(e)))
    page.goto(html)
    page.wait_for_timeout(4000)
    v = page.locator("#viewer")
    v.scroll_into_view_if_needed()
    tomas = [
        ("conjunto", lambda: vista(page, "De costado")),
        ("desde-el-sur", lambda: vista(page, "Desde el sur")),
        ("rodillo-motor", lambda: vista(page, "rodillo y motor")),
        ("chapa", lambda: vista(page, "Detalle: chapa")),
        ("explotada", lambda: (vista(page, "De costado"), explotar(page, 100))),
    ]
    for nombre, accion in tomas:
        accion()
        v.screenshot(path=str(out / f"modelo-{nombre}.png"))
        print(nombre, (out / f"modelo-{nombre}.png").stat().st_size)
    explotar(page, 0)
    page.locator("input[name=tel][value='300']").check()
    page.wait_for_timeout(1500)
    vista(page, "De costado")
    v.screenshot(path=str(out / "modelo-12.png"))
    print("12", (out / "modelo-12.png").stat().st_size)
    print("errores de pagina:", errores or "ninguno")
    b.close()
