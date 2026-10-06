// node docs/probar-geometria.js -- controles de geometria-vns.js.
// Cada control corre dos veces: con la entrada buena (tiene que dar verde) y
// con una entrada saboteada (tiene que dar rojo). Si el saboteado da verde,
// el control no mide nada y el script sale con error.
const { computeVNS } = require('./geometria-vns.js');
const base = { phi: 34.5, M: 50, Hdis: 0.64, Hreal: 0.64, dN: 0, dE: 0, shim: 0, runMin: 45, half: 0.19, postH: 0, baseW: 1.2 };

const controles = [
  ['CdM sobre el eje => torque nulo', (g) => g.tauMax < 1e-9, { Hreal: 0.60 }],
  ['las cargas suman la masa', (g) => Math.abs(g.loads.pivote + g.loads.este + g.loads.oeste - 50) < 1e-9, { M: 51 }],
  ['velocidad dentro de +-1 % (Vogel)', (g) => g.rollers.every((r) => r.speedVar < 1), { runMin: 600 }],
  ['chapa de 3 cm minimo', (g) => g.rollers.every((r) => r.plateHmin > 0.0299), null],
  ['el pivote esta sobre el eje', (g) => { const v = [0, 1, 2].map((i) => g.pivot[i] - g.C[i]); const t = v[0] * g.d[0] + v[1] * g.d[1] + v[2] * g.d[2]; return Math.hypot(...v.map((x, i) => x - t * g.d[i])) < 1e-9; }, null],
  ['el pivote queda al NORTE (hemisferio sur)', (g) => g.pivot[1] > g.C[1], { phi: -34.5 }],
  // Pregunta de Kevin: la base ancha (1,2 m) tiene que aguantar mas vuelco que la angosta.
  ['base de 1,2 m: respeta el ancho pedido y el costado aguanta 24 grados o mas', (g) => g.baseWidth >= 1.2 - 1e-9 && g.vuelcoLado >= 24, { baseW: 0.80 }],
  // Limites en orden, a los dos lados: programa < fin de carrera < talon, y
  // la chapa sigue un radio de rodillo mas alla del talon (no se cae antes).
  ['limites en orden: programa < fin de carrera < tope < punta de chapa', (g) => g.rollers.every((r) => [0, 1].every((i) => {
    const L = r.lim, sg = Math.sign(L.run[i]);   // que lado de la chapa es cual lo dice la geometria, no el indice
    return sg * L.run[i] < sg * L.sw[i] && sg * L.sw[i] < sg * L.stop[i] && sg * L.stop[i] + g.RROLL < (sg > 0 ? r.uMax : -r.uMin);
  })), { stopMin: 2 }],
];

let fallas = 0;
// La mesa de hierro gira con el telescopio: con el eje puesto en el CdM de
// TODO lo que gira (Hbal), el torque es nulo; si se la ignora (mTab 0 con el
// mismo eje), queda el telescopio solo fuera del eje y el torque aparece.
{
  const mesa = { ...base, mTab: 6 };
  const ok = (g) => g.tauMax < 1e-6;
  const conEje = { ...mesa, Hdis: computeVNS(mesa).Hbal };
  const bueno = ok(computeVNS(conEje)), rojo = !ok(computeVNS({ ...conEje, mTab: 0 }));
  if (!bueno || !rojo) fallas++;
  console.log((bueno ? '[OK  ] ' : '[FAIL] ') + 'mesa de hierro: eje en el CdM de todo lo que gira => torque nulo -- ' + (rojo ? 'saboteado da ROJO, bien' : 'SABOTEADO DA VERDE: el control no mide'));
}
for (const [nombre, ok, sabotaje] of controles) {
  const bueno = ok(computeVNS(base));
  let malo = '(sin sabotaje: es una cota del diseno)';
  if (sabotaje) {
    const rojo = !ok(computeVNS({ ...base, ...sabotaje }));
    malo = rojo ? 'saboteado da ROJO, bien' : 'SABOTEADO DA VERDE: el control no mide';
    if (!rojo) fallas++;
  }
  if (!bueno) fallas++;
  console.log((bueno ? '[OK  ] ' : '[FAIL] ') + nombre + ' -- ' + malo);
}
process.exit(fallas ? 1 : 0);
