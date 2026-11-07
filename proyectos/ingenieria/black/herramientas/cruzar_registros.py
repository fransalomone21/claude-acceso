"""Cruza el registro del anfitrion con el del companero: que enemigos del anfitrion (npc+) no tienen titere en el
companero, y cuando. Offset: el companero arranco 378 s despues (02:23:36 contra 02:29:54)."""
import re, sys
host, joiner, off = sys.argv[1], sys.argv[2], float(sys.argv[3])
rx_t = re.compile(r'^\[\s*([\d.]+)\]\s*(.*)')
def lines(p):
    for l in open(p, encoding='utf-8', errors='replace'):
        m = rx_t.match(l)
        if m: yield float(m.group(1)), m.group(2)
hspawn = {}
for t, s in lines(host):
    m = re.match(r'npc\+ s\d+ ([0-9A-F]{16}) #(\d+) type (\d+) team (\d+) unit (\d+)', s)
    if m: hspawn.setdefault((m.group(1), m.group(2)), (t, m.group(3), m.group(4), m.group(5)))
jmade, jother = {}, []
last = None
for t, s in lines(joiner):
    m = re.match(r'npc\+ s\d+ ([0-9A-F]{16}) #(\d+)', s)
    if m: last = (m.group(1), m.group(2), t)
    if 'made by its spawner' in s and last: jmade.setdefault((last[0], last[1]), t)
    if s.startswith('npc:') and 'made by its spawner' not in s: jother.append((t, s))
print('anfitrion npc+:', len(hspawn), ' titeres hechos en el companero:', len(jmade))
falta = [(v[0], k, v) for k, v in hspawn.items() if k not in jmade and v[0] - off > 0]
print('enemigos del anfitrion sin titere en el companero (despues de que el companero arranco):', len(falta))
for t, k, v in sorted(falta)[:80]:
    print(f'  anfitrion {t:8.1f} (companero {t-off:8.1f})  {k[0]} #{k[1]}  type {v[1]} team {v[2]} unit {v[3]}')
lat = sorted(jmade[k] - (hspawn[k][0] - off) for k in jmade if k in hspawn)
if lat:
    print('demora del titere (s): mediana %.2f  p90 %.2f  max %.2f' % (lat[len(lat)//2], lat[int(len(lat)*.9)], lat[-1]))
    tarde = [(k, jmade[k] - (hspawn[k][0] - off), hspawn[k][0]) for k in jmade if k in hspawn and jmade[k] - (hspawn[k][0] - off) > 3]
    for k, d, ht in sorted(tarde, key=lambda x: x[2])[:40]:
        print(f'  tarde {d:7.1f} s  {k[0]} #{k[1]}  anfitrion {ht:.1f}')
print('otras lineas npc: del companero:', len(jother))
for t, s in jother[:30]: print(f'  {t:8.1f} {s}')
