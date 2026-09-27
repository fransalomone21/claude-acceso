"""B7 (85): la bala de J2 sale de la ranura de personaje (J2+0x330, FUN_0013B4C0 -> FUN_001A68B0(ranura, 5)),
que J2 COMPARTE con J: el disparo de J2 nace en el arma de J. Sonda: J2 le dispara a un enemigo con la ranura
compartida (control) y despues con la ranura 1 propia (*(ranura1) = J2). Mide la vida del enemigo en cada tramo.

    python herramientas/ranura_j2.py <enemigo_hex> <segundos_por_tramo> [--compartida] [--dejar]

--compartida: el segundo tramo pone J2+0x330 = ranura 0 (la de J). Sin eso: ranura 1 con dueno J2.

Sin --dejar, al final vuelve J2+0x330 y *(ranura1) a lo que tenian. Esperar >= 12 s despues de hacer nacer
al enemigo (el recien nacido no recibe dano)."""
import json, subprocess, sys
from pathlib import Path
AQUI = Path(__file__).resolve().parent
sys.path.insert(0, str(AQUI))
from pine import Pine
if '--help' in sys.argv or len(sys.argv) < 3:
    print(__doc__)
    sys.exit(0)
J, J2 = 0x005A8AB0, 0x0046CDF0
E, seg = sys.argv[1], sys.argv[2]


def tirar():
    r = subprocess.run([sys.executable, str(AQUI / 'tirador.py'), 'J2', E, seg], capture_output=True, text=True)
    return json.loads(r.stdout.strip().splitlines()[-1])


with Pine() as p:
    pers = p.leer32(0x0040F50C)
    r0, r1 = pers + 0x470, pers + 0x470 + 0x240
    viejo = {'J2_330': p.leer32(J2 + 0x330), 'r1_dueno': p.leer32(r1), 'J_330': p.leer32(J + 0x330), 'r0_dueno': p.leer32(r0)}
a = tirar()
with Pine() as p:
    if '--compartida' in sys.argv:      # J2 usa la ranura 0 (la de J, animada); su dueno sigue siendo J
        p.escribir32(J2 + 0x330, r0)
    else:
        p.escribir32(r1, J2)
        p.escribir32(J2 + 0x330, r1)
b = tirar()
with Pine() as p:
    nuevo = {'J2_330': hex(p.leer32(J2 + 0x330)), 'r1_dueno': hex(p.leer32(r1))}
    if '--dejar' not in sys.argv:
        p.escribir32(J2 + 0x330, viejo['J2_330'])
        p.escribir32(r1, viejo['r1_dueno'])
print(json.dumps({'personajes': hex(pers), 'ranura0': hex(r0), 'ranura1': hex(r1),
                  'antes': {k: hex(v) for k, v in viejo.items()}, 'puesto': nuevo,
                  'tramo_1_como_estaba': a, 'tramo_2_cambiado': b}, indent=1))
