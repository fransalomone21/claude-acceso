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
  // 2026-10-07: el contacto camina por el rodillo para UN solo lado (0 en el centro).
  // La nube lo leyo como +-13,7 y pidio un rodillo de 40 mm; centrado alcanza con 30.
  ['el contacto camina para un solo lado (cuadratico, 0 en el centro)', (g) => g.rollers.every((r) => Math.min(-r.latLo, r.latHi) < 0.0005 && r.latSwing > 0.005), null],
  ['rodillo de 30 mm centrado: el contacto no se sale en todo el recorrido', (g) => g.rollOK, { rollW: 0.012 }],
  // La mesa apoya, no esta atada: un empujon de costado en la boca la levanta de un rodillo.
  ['la mesa aguanta un empujon de costado de 4 kg o mas en la boca del tubo', (g) => g.empujeMesa >= 4, { half: 0.04 }],
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
// v10, la corredera: dNEquilibrio pone el CdM de todo lo que gira sobre el eje, para el 200 y para
// un 12" de la envolvente, con la mesa universal (rieles arriba, mesa larga). Sabotaje: la muesca
// corrida 2 cm tiene que sacar el CdM del eje (si da verde igual, el control no mide).
{
  const { dNEquilibrio } = require('./geometria-vns.js');
  const v10 = { ...base, Hdis: 0.54, half: 0.25, postH: 0.10, mTab: 11, zTab: -0.02, tabN: 0.53, railH: 0.02 };
  const ok = (g) => g.offAxis < 1e-6;
  let bueno = true, rojo = true;
  for (const [M, H] of [[40, 0.63], [50, 0.52], [40, 0.69]]) {
    const q = { ...v10, M, Hreal: H }; q.dN = dNEquilibrio(q);
    bueno = bueno && ok(computeVNS(q));
    rojo = rojo && !ok(computeVNS({ ...q, dN: q.dN + 0.02 }));
  }
  if (!bueno || !rojo) fallas++;
  console.log((bueno ? '[OK  ] ' : '[FAIL] ') + 'corredera: la muesca de cada telescopio pone el CdM sobre el eje -- ' + (rojo ? 'saboteado da ROJO, bien' : 'SABOTEADO DA VERDE: el control no mide'));
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
