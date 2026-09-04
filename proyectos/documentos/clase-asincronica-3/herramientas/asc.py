# asc.py -- generador de esquematicos .asc de LTspice.
#
# Por que existe: los doce circuitos de la guia se dibujan a mano moviendo
# coordenadas de a 16 pixeles, y un cable que no llega a tocar un pin no da
# error de compilacion: da "This node is floating" cincuenta lineas mas
# abajo, o peor, da un resultado con un elemento colgado. Aca las
# coordenadas de los pines NO se adivinan: salen de los .asy de la propia
# instalacion de LTspice (lib/sym/*.asy, campo PIN), y los cables se tienden
# de pin a pin.
#
# ASCII puro a proposito, igual que el resto del repo: la consola de Windows
# lee cp1252 y los .asc de la catedra tampoco llevan acentos.

from pathlib import Path

# Coordenadas de los pines en R0, leidas de lib/sym/<simbolo>.asy.
# El orden es el SpiceOrder: pin[0] es el nodo "+" del netlist.
PIN = {
    "res":     [(16, 16), (16, 96)],
    "ind":     [(16, 16), (16, 96)],
    "cap":     [(16,  0), (16, 64)],
    "voltage": [(0,  16), (0,  96)],
    "current": [(0,   0), (0,  80)],
    "bi":      [(0,   0), (0,  80)],
    "bv":      [(0,  16), (0,  96)],
    "sw":      [(0,  16), (0,  96), (-48, 80), (-48, 32)],
}

# La rotacion de LTspice, en el sistema de coordenadas de la hoja (y hacia
# abajo). Verificado contra los .asc de la catedra: un `res` en R90 con
# origen (208,80) tiene los pines en (112,96) y (192,96).
ROT = {
    "R0":   lambda x, y: (x, y),
    "R90":  lambda x, y: (-y, x),
    "R180": lambda x, y: (-x, -y),
    "R270": lambda x, y: (y, -x),
}


class Sch:
    """Una hoja de LTspice que se arma por pines, no por pixeles."""

    def __init__(self, ancho=1600, alto=1000):
        self.ancho, self.alto = ancho, alto
        self.wires, self.flags, self.syms, self.texts = [], [], [], []

    # -- colocacion ---------------------------------------------------------

    def sym(self, kind, name, pin1, rot="R0", value=None, value2=None,
            desplazar_rotulo=None):
        """Coloca `kind` de modo que su PIN 1 caiga exactamente en `pin1`.

        Devuelve la lista de coordenadas absolutas de todos sus pines.
        Trabajar desde el pin 1 y no desde el origen del simbolo es lo que
        evita el error clasico: el origen de un simbolo NO esta sobre
        ninguno de sus pines."""
        r = ROT[rot]
        rel = [r(x, y) for (x, y) in PIN[kind]]
        ox, oy = pin1[0] - rel[0][0], pin1[1] - rel[0][1]
        self.syms.append((kind, name, ox, oy, rot, value, value2,
                          desplazar_rotulo))
        return [(ox + dx, oy + dy) for (dx, dy) in rel]

    def wire(self, a, b, por="h"):
        """Cable ortogonal de `a` a `b`. `por='h'` va primero en horizontal.

        LTspice no admite diagonales, y un WIRE de longitud cero es basura
        que ademas confunde al lector del netlist: los dos casos se filtran
        aca en vez de en la pantalla."""
        if a == b:
            return
        if a[0] == b[0] or a[1] == b[1]:
            self.wires.append((a, b))
            return
        c = (b[0], a[1]) if por == "h" else (a[0], b[1])
        self.wires.append((a, c))
        self.wires.append((c, b))

    def rail(self, y, x0, x1):
        self.wires.append(((x0, y), (x1, y)))

    def flag(self, p, nombre):
        """FLAG con nombre pone etiqueta de nodo; con '0' pone la masa."""
        self.flags.append((p, nombre))

    def tierra(self, p):
        self.flag(p, "0")

    # -- texto --------------------------------------------------------------

    def directiva(self, p, *lineas):
        """Directiva SPICE: en el .asc va con '!' adelante."""
        for i, l in enumerate(lineas):
            self.texts.append(((p[0], p[1] + 32 * i), "!" + l))

    def nota(self, p, *lineas, paso=28):
        """Comentario: en el .asc va con ';' adelante. Es lo que queda
        escrito adentro de la simulacion y se lee sin abrir ningun README."""
        for i, l in enumerate(lineas):
            self.texts.append(((p[0], p[1] + paso * i), ";" + l))

    # -- salida -------------------------------------------------------------

    def render(self):
        out = ["Version 4", f"SHEET 1 {self.ancho} {self.alto}"]
        for (a, b) in self.wires:
            out.append(f"WIRE {a[0]} {a[1]} {b[0]} {b[1]}")
        for (p, n) in self.flags:
            out.append(f"FLAG {p[0]} {p[1]} {n}")
        for (kind, name, ox, oy, rot, value, value2, desp) in self.syms:
            out.append(f"SYMBOL {kind} {ox} {oy} {rot}")
            if kind in ("voltage", "current", "bi", "bv"):
                # Apaga los dos campos de texto que LTspice deja vacios y que
                # si no se apagan aparecen como un "0" suelto sobre la fuente.
                out.append("WINDOW 123 0 0 Left 0")
                out.append("WINDOW 39 0 0 Left 0")
            if desp:
                out.append(f"WINDOW 0 {desp[0]} {desp[1]} Left 2")
                out.append(f"WINDOW 3 {desp[2]} {desp[3]} Left 2")
            out.append(f"SYMATTR InstName {name}")
            if value is not None:
                out.append(f"SYMATTR Value {value}")
            if value2 is not None:
                out.append(f"SYMATTR Value2 {value2}")
        for (p, t) in self.texts:
            out.append(f"TEXT {p[0]} {p[1]} Left 2 {t}")
        return "\n".join(out) + "\n"

    def guardar(self, ruta):
        ruta = Path(ruta)
        ruta.parent.mkdir(parents=True, exist_ok=True)
        texto = self.render()
        # Alarma temprana y con nombre: si se cuela un acento, el
        # write_text de mas abajo tira un UnicodeEncodeError que dice la
        # POSICION en bytes y no la linea. Esto dice la linea.
        for n, l in enumerate(texto.splitlines(), 1):
            malos = [c for c in l if ord(c) > 127]
            if malos:
                raise ValueError(
                    f"{ruta.name}: caracter no ASCII {malos!r} en la linea "
                    f"{n}: {l[:90]}")
        # LTspice lee el .asc como texto plano; se escribe en ASCII y con
        # saltos \n, que es lo que traen los archivos de la catedra.
        ruta.write_text(self.render(), encoding="ascii", newline="\n")
        return ruta


# --- bloque de texto comun a los doce archivos -----------------------------

CABECERA = [
    "=" * 78,
]


def encabezado(sch, p, titulo, subtitulo=None):
    lineas = [titulo]
    if subtitulo:
        lineas.append(subtitulo)
    sch.nota(p, *lineas, paso=32)


def bloque(sch, p, titulo, lineas, paso=28):
    sch.nota(p, titulo, *lineas, paso=paso)
