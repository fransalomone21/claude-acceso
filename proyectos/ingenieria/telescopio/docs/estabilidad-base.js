// node docs/estabilidad-base.js -- compara bases al piso por cuanto aguantan
// antes de volcar (pregunta de Kevin, 2026-10-05: triangular o cuadrada mas grande).
// Usa los valores de diseno del modelo (40 kg, CdM 63, mesa 8 kg, eje 54, poste 10).
// Vuelco = grados que hay que inclinar el conjunto para que se caiga, con la mesa
// en el medio de la carrera. No suma la inclinacion de la mesa (1 a 2 grados
// mas optimista que el calculo fino de 09-estructura-hierro.md): vale la comparacion.
const { computeVNS } = require('./geometria-vns.js');
const D2R = Math.PI / 180;
const P = { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.63, dN: 0, dE: 0, shim: 0.02, runMin: 45, half: 0.19, postH: 0.10, mTab: 8, zTab: -0.02 };
const g0 = computeVNS(P);
const [x, y, h] = g0.Cg, ySur = g0.ySouthBase, yNorte = g0.yNorthBase, Mtot = g0.Mtot;
const dist = (a, b) => Math.abs((b[1] - a[1]) * (x - a[0]) - (b[0] - a[0]) * (y - a[1])) / Math.hypot(b[0] - a[0], b[1] - a[1]);
const fila = (nombre, patas, pata3) => {
  const lados = patas.map((p, i) => dist(p, patas[(i + 1) % patas.length]));
  const m = Math.min(...lados);
  console.log(nombre.padEnd(34), 'margen', (m * 100).toFixed(1).padStart(5), 'cm | vuelco', (Math.atan(m / h) / D2R).toFixed(1).padStart(5), 'grados | empuje que vuelca a 1,3 m:', ((Mtot * m) / 1.3).toFixed(1).padStart(5), 'kgf | patas', pata3 ? 3 : 4);
};
console.log('CdM de todo lo que gira a', (h * 100).toFixed(1), 'cm del piso; masa', Mtot, 'kg; base de', (g0.baseLength * 100).toFixed(0), 'cm de largo\n');
for (const w of [0.80, 1.0, 1.2, 1.4]) {
  const g = computeVNS({ ...P, baseW: w });
  console.log(('triangulo ancho ' + g.baseWidth.toFixed(2) + ' m').padEnd(34), 'vuelco costado', g.vuelcoLado.toFixed(1).padStart(5), '| vuelco al sur', g.vuelcoSur.toFixed(1).padStart(5), '| manda', g.vuelcoLado < g.vuelcoSur ? 'el costado' : 'el sur');
}
console.log('');
const L = yNorte - ySur;
// las patas van 4 cm hacia adentro de la esquina, igual que en el triangulo del modelo
const cuadro = (ancho, largo) => { const a = ancho / 2 - 0.04, s = ySur + 0.04, n = ySur + largo - 0.04; return [[-a, s], [a, s], [a, n], [-a, n]]; };
for (const w of [0.80, 1.2]) fila('cuadrada ' + w.toFixed(2) + ' x ' + L.toFixed(2) + ' m', cuadro(w, L), false);
fila('cuadrada 1,6 x 1,6 m', cuadro(1.6, 1.6), false);
// lastre: 10 kg de arena o ladrillos sobre la base (a 5 cm del piso) bajan el CdM
const lastre = 10, hL = (Mtot * h + lastre * 0.05) / (Mtot + lastre);
console.log('\ncon ' + lastre + ' kg de lastre bajo: CdM a', (hL * 100).toFixed(1), 'cm; vuelco al sur', (Math.atan(dist(g0.feet[0], g0.feet[1]) / hL) / D2R).toFixed(1), 'grados (antes', g0.vuelcoSur.toFixed(1) + ')');
