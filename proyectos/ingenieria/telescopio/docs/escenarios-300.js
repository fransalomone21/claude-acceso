// Escenarios de concepto (docs/14 §4): el 200 de Fran y un 12" comercial sobre la MISMA plataforma v9.
// Uso: node docs/escenarios-300.js  -- los datos del 12" son hipotesis (docs/14 §3).
const { computeVNS } = require('./geometria-vns.js');
const base = { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.63, dN: 0, dE: 0, shim: 0.02, runMin: 45, half: 0.25, postH: 0.10, baseW: 1.20, mTab: 8, zTab: -0.02 };
const f = (x, n = 1) => x.toFixed(n);
function show(tag, P) {
  const r = computeVNS(P);
  console.log(`${tag}: M=${P.M} Hreal=${f(P.Hreal*100)} dN=${f(P.dN*100)} shim=${f(P.shim*100)} | offAxis=${f(r.offAxis*100)} cm tauMax=${f(r.tauMax,2)} N.m vuelco=${f(r.vuelco)} deg empuje=${f(r.empujeMesa)} kg cargas piv/E/O=${f(r.loads.pivote)}/${f(r.loads.este)}/${f(r.loads.oeste)} kg R=${f(r.rollers[0].R*100)} cm mesa=${f(r.ztt*100)} cm`);
  return r;
}
const r0 = show('v9 (200, H 63)', base);
const tanp = Math.tan(34.5 * Math.PI / 180);
console.log('tan(phi) =', tanp.toFixed(3), '-> 10 cm de corredera N-S mueven el eje', (10 * tanp).toFixed(1), 'cm en altura');
// El 12": misma plataforma, el dobson se corre al NORTE (dN>0) para bajar el punto del eje
for (const [M, H] of [[40, 0.52], [40, 0.57], [50, 0.52], [50, 0.62]]) {
  // CdM combinado (dobson+mesa) tiene que caer en el eje: buscar dN que lo pone
  let best = null;
  for (let dN = -0.30; dN <= 0.40; dN += 0.005) {
    const r = computeVNS({ ...base, M, Hreal: H, dN, shim: 0 });
    if (!best || r.offAxis < best.r.offAxis) best = { dN, r };
  }
  show(`12" M ${M} H ${f(H*100,0)} corrido`, { ...base, M, Hreal: H, dN: best.dN, shim: 0 });
}
// el 200 en los bordes de su rango
for (const H of [0.58, 0.69]) {
  let best = null;
  for (let dN = -0.30; dN <= 0.40; dN += 0.005) {
    const r = computeVNS({ ...base, Hreal: H, dN, shim: 0.02 });
    if (!best || r.offAxis < best.r.offAxis) best = { dN, r };
  }
  show(`200 H ${f(H*100,0)} corrido`, { ...base, Hreal: H, dN: best.dN });
}
// v10 (el modelo 3D desde el 2026-10-07): mesa universal -- rieles de 2 cm arriba del marco, mesa
// hasta 53 cm al norte, 11 kg, chapa de 5/16", sin suplemento. La muesca sale de dNEquilibrio.
{
  const { dNEquilibrio } = require('./geometria-vns.js');
  const v10 = { ...base, shim: 0, mTab: 11, tabN: 0.53, railH: 0.02, plateT: 0.00794 };
  console.log('--- v10, mesa universal ---');
  for (const [tag, M, H] of [['200 H 63', 40, 0.63], ['200 H 58', 40, 0.58], ['200 H 69', 40, 0.69], ['12" 40 kg H 52', 40, 0.52], ['12" 50 kg H 52', 50, 0.52], ['12" 50 kg H 62', 50, 0.62]]) {
    const q = { ...v10, M, Hreal: H }; q.dN = dNEquilibrio(q); show('v10 ' + tag, q);
  }
}
// Correa dentada pegada al canto (Kevin): periodo del diente y paso angular
const R = r0.rollers[0].R, w = 2 * Math.PI / 86164;   // rad/s sidereo
const v = R * w;                                        // m/s en el canto
console.log(`canto a R=${f(R*100)} cm avanza ${f(v*1e6,1)} um/s = ${f(v*3600*100,1)} cm/h; un diente GT2 (2 mm) pasa cada ${f(0.002/v,0)} s`);
console.log(`un error de 5 um en el canto mueve la estrella ${f(5e-6/R*206265,1)} arcsec`);
const pin = 20 * 0.002;                                  // pinon de 20 dientes: 40 mm por vuelta
console.log(`piñon GT2 20T directo: 1 micropaso (1/16) = ${f(pin/3200/R*206265,1)} arcsec en el cielo`);
