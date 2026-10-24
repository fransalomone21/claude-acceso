// Segunda tanda: vuelco con piso desparejo bien modelado (la orientacion la fija la latitud; el desnivel lo absorbe
// una pata), altura de la mesa en los bordes de la banda, y el sabotaje de vuelcoInclinado de probar-requisitos.
const path = __dirname + '/../';
const { computeVNS, dNEquilibrio } = require(path + 'geometria-vns.js');
const D2R = Math.PI / 180, f = (x, k = 2) => x.toFixed(k);
const sub = (a, b) => a.map((v, i) => v - b[i]), dot = (a, b) => a.reduce((s, v, i) => s + v * b[i], 0);
const mul = (a, k) => a.map((v) => v * k), norm = (a) => Math.sqrt(dot(a, a)), unit = (a) => mul(a, 1 / norm(a));
const P0 = { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.632, dE: 0, shim: 0, runMin: 45, half: 0.29, postH: 0.10,
  baseW: 1.30, mTab: 11, zTab: -0.02, tabN: 0.53, railH: 0.02, plateT: 0.00794 };
const caso = (M, H, extra) => { const q = { ...P0, M, Hreal: H, ...(extra || {}) }; q.dN = dNEquilibrio(q); return computeVNS(q); };

// alfa > 0: latitud mayor (el sur sube). La plataforma gira alfa alrededor de x; 'arriba' en su marco = [0,-sin a, cos a].
// Cada pata i tiene su contacto en z = -dh_i (marco de la plataforma). Vuelco por borde = angulo entre (CdM - borde)
// perpendicular al borde y 'arriba' perpendicular al borde.
function vuelco(g, alfa, dh, C) {
  C = C || g.Cg;
  const a = alfa * D2R, u = [0, -Math.sin(a), Math.cos(a)];
  const pts = g.feet.map((p, i) => [p[0], p[1], -dh[i]]);
  const borde = (A, B) => { const e = unit(sub(B, A)); let r = sub(C, A); r = sub(r, mul(e, dot(r, e)));
    const w = sub(u, mul(e, dot(u, e))); return Math.acos(dot(unit(r), unit(w))) / D2R; };
  return Math.min(borde(pts[0], pts[1]), borde(pts[0], pts[2]), borde(pts[1], pts[2]));
}
const CASOS = [['200 medido', 40, 0.632], ['12in 40 kg CdM 50', 40, 0.50], ['12in 50 kg CdM 50', 50, 0.50], ['12in 50 kg CdM 62', 50, 0.62]];
console.log('Vuelco minimo (grados): patas que inclinan la base + 3 cm de desnivel bajo la peor pata (L1-18)');
for (const [tag, M, H] of CASOS) {
  const g = caso(M, H), L = g.feet[2][1] - g.feet[0][1];
  const out = [];
  for (const lat of [30.5, 34.5, 38.5]) {
    const al = lat - 34.5, h = L * Math.tan(Math.abs(al) * D2R);
    const base = al > 0 ? [h, h, 0] : al < 0 ? [0, 0, h] : [0, 0, 0];
    let peor = vuelco(g, al, base), sinPatas = vuelco(g, al, [0, 0, 0]);
    for (let i = 0; i < 3; i++) { const dh = base.slice(); dh[i] += 0.03; peor = Math.min(peor, vuelco(g, al, dh)); }
    out.push(`${lat}: modelo del repo ${f(sinPatas, 1)} | con patas ${f(vuelco(g, al, base), 2)} | +desnivel ${f(peor, 2)}`);
  }
  console.log(' ', tag.padEnd(18), out.join(' || '));
}

console.log('\nAltura de la cara de los rieles sobre el piso, en el centro de la mesa (L1-21 pide <= 30 cm):');
{ const g = caso(40, 0.632), L = g.feet[2][1] - g.feet[0][1], yC = g.C[1];
  const fr = (g.feet[2][1] - yC) / L; // fraccion de la subida del sur que llega al centro
  const h4 = L * Math.tan(4 * D2R), z0 = (g.ztt + g.railH) * 100;
  console.log(`  34,5: ${f(z0, 1)} cm | 38,5 (sur +${f(h4 * 100, 1)}): ${f(z0 + h4 * 100 * fr, 1)} cm | 30,5 (norte +${f(h4 * 100, 1)}): ${f(z0 + h4 * 100 * (1 - fr), 1)} cm | +3 cm de desnivel: hasta ${f(z0 + h4 * 100 * fr + 3, 1)} cm`);
  console.log(`  recorrido de pata pedido: ${f(h4 * 100, 1)} + 3 = ${f(h4 * 100 + 3, 1)} cm contra 12 (L2-PLT-04), si en 34,5 todas las patas estan recogidas`);
}

console.log('\nCargas por rodillo y pivote (kg), 200 medido y el 12in mas pesado:');
for (const [tag, M, H] of [['200', 40, 0.632], ['12in 50 kg', 50, 0.62]]) {
  const g = caso(M, H); console.log(`  ${tag}: pivote ${f(g.loads.pivote, 1)}, este ${f(g.loads.este, 1)}, oeste ${f(g.loads.oeste, 1)} (de ${g.Mtot} kg)`);
}
