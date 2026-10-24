// Revision independiente del concepto del telescopio (2026-10-24).
// Fisica propia; de geometria-vns.js se toman SOLO posiciones (patas, pivote, rodillos, CdM).
// node revision.js
const path = __dirname + '/../';
const { computeVNS, dNEquilibrio } = require(path + 'geometria-vns.js');
const D2R = Math.PI / 180, AS = 206264.806, SID = 7.2921e-5, CIELO = SID * AS;
const f = (x, k = 2) => (typeof x === 'number' ? x.toFixed(k) : String(x));
const sub = (a, b) => a.map((v, i) => v - b[i]), dot = (a, b) => a.reduce((s, v, i) => s + v * b[i], 0);
const mul = (a, k) => a.map((v) => v * k), norm = (a) => Math.sqrt(dot(a, a)), unit = (a) => mul(a, 1 / norm(a));
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];

// punto de diseno v10.6 (deslizadores por defecto + MESA del modelo)
const P0 = { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.632, dE: 0, shim: 0, runMin: 45, half: 0.29, postH: 0.10,
  baseW: 1.30, mTab: 11, zTab: -0.02, tabN: 0.53, railH: 0.02, plateT: 0.00794 };
const caso = (M, H) => { const q = { ...P0, M, Hreal: H }; q.dN = dNEquilibrio(q); return computeVNS(q); };
const CASOS = [['200 medido', 40, 0.632], ['200 CdM bajo', 40, 0.627], ['12in 40 kg CdM 50', 40, 0.50],
  ['12in 40 kg CdM 62', 40, 0.62], ['12in 50 kg CdM 50', 50, 0.50], ['12in 50 kg CdM 62', 50, 0.62]];

console.log('=== A. Chequeos analiticos de geometria (sin el modelo) ===');
{ const s = Math.sin(34.5 * D2R), c = Math.cos(34.5 * D2R);
  const tilt = (min) => Math.acos(s * s + c * c * Math.cos(min / 4 * D2R)) / D2R;
  console.log('inclinacion de la mesa a 45 min', f(tilt(45)), 'grados; a 51 min (talon)', f(tilt(51)));
  console.log('con la base inclinada 4 grados N-S (no pitagorico, compuesto):');
  // normal de la mesa girada 51 min y despues la base girada 4 grados alrededor de E-O
  const d = [0, -c, s]; const rod = (v, k, th) => { const cs = Math.cos(th), sn = Math.sin(th);
    return v.map((_, i) => v[i] * cs + cross(k, v)[i] * sn + k[i] * dot(k, v) * (1 - cs)); };
  const n = rod(rod([0, 0, 1], d, 51 / 4 * D2R), [1, 0, 0], 4 * D2R);
  console.log('  inclinacion total', f(Math.acos(n[2]) / D2R), 'grados (L2-MON-02/03 piden 12)');
  console.log('deriva por alineacion 7 arcmin en 30 s:', f(7 / 60 * D2R * CIELO * 30), '"; 30 arcmin en 10 s:', f(30 / 60 * D2R * CIELO * 10), '"');
  console.log('presupuesto L1-01 en cuadratura 1,5/0,5/1:', f(Math.hypot(1.5, 0.5, 1)), '"');
  console.log('corredera 2 mm -> fuera del eje', f(2 * s), 'mm');
  console.log('coma tangencial f/6 1200 mm a 7 mm:', f(3 * 7 / (16 * 36 * 1200) * AS), '"; en la esquina APS-C (14,1 mm):', f(3 * 14.1 / (16 * 36 * 1200) * AS), '"');
  console.log('escala ZV-E10 (3,92 um) a 1200 mm:', f(3.92e-3 / 1200 * AS, 3), '"/px; a 1500 mm', f(3.92e-3 / 1500 * AS, 3));
  console.log('dobson solo, vuelco: atan(21,5/63,2) =', f(Math.atan(21.5 / 63.2) / D2R), 'grados');
}

console.log('\n=== B. Patas y vuelco con la base inclinada DE VERDAD (patas extendidas) ===');
// En el marco de la plataforma: patas en (x,y,0) al ras del piso nominal. Una pata extendida dh baja su contacto a z=-dh.
// Se busca el 'arriba' = normal del plano de los tres contactos (piso plano). Vuelco de cada borde = angulo entre el
// vector borde->CdM (perpendicular al borde) y el arriba, en el plano perpendicular al borde.
function vuelcoReal(g, dh, extra) {
  const C = extra ? extra(g) : g.Cg;
  const pts = g.feet.map((p, i) => [p[0], p[1], -dh[i]]);
  let u = unit(cross(sub(pts[1], pts[0]), sub(pts[2], pts[0]))); if (u[2] < 0) u = mul(u, -1);
  const borde = (A, B) => { const e = unit(sub(B, A)); let r = sub(C, A); r = sub(r, mul(e, dot(r, e)));
    let w = sub(u, mul(e, dot(u, e))); return Math.acos(dot(unit(r), unit(w))) / D2R; };
  return { sur: borde(pts[0], pts[1]), lado: Math.min(borde(pts[0], pts[2]), borde(pts[1], pts[2])),
    incl: Math.acos(u[2]) / D2R };
}
for (const [tag, M, H] of CASOS) {
  const g = caso(M, H); const L = g.feet[2][1] - g.feet[0][1];
  const h4 = L * Math.tan(4 * D2R);
  const r = [];
  for (const [lat, dh] of [['34,5 plano', [0, 0, 0]], ['38,5 (sur +' + f(h4 * 100, 1) + ')', [h4, h4, 0]], ['30,5 (norte +' + f(h4 * 100, 1) + ')', [0, 0, h4]],
    ['38,5 + desnivel 3 cm', [h4 + 0.03, h4, 0]], ['30,5 + desnivel 3 cm', [0, 0.03, h4]]]) {
    const v = vuelcoReal(g, dh); r.push(lat + ': sur ' + f(v.sur, 1) + ' lado ' + f(v.lado, 1) + ' (incl ' + f(v.incl, 1) + ')');
  }
  console.log(tag.padEnd(20), 'L patas N-S', f(L, 3), 'm | CdM giratorio', f(g.Cg[2], 3), 'm\n   ', r.join('\n    '));
}

console.log('\n=== C. Empujon en la boca del tubo: la altura real de la boca ===');
// boca: eje de altura a 82,5 cm del piso del dobson; boca a ~0,80 m del eje (tubo de 135,5 balanceado cerca del eje)
for (const [tag, M, H] of CASOS.slice(0, 1)) {
  const g = caso(M, H); const piso = g.ztt + g.railH, zRod = g.rollers[0].Pt[2];
  for (const alt of [30, 45, 70, 90]) {
    const boca = piso + 0.825 + 0.80 * Math.sin(alt * D2R);
    const kg = g.Mtot * g.mesaMargen / (boca - zRod);
    const bocaSolo = 0.825 + 0.80 * Math.sin(alt * D2R), kgSolo = 40 * 0.215 / bocaSolo;
    console.log(`  altura ${alt}: boca a ${f(boca)} m -> levanta la mesa con ${f(kg, 1)} kg | dobson solo: boca a ${f(bocaSolo)} m, vuelca con ${f(kgSolo, 1)} kg`);
  }
  console.log('  convencion del repo (1,3 m):', f(g.empujeMesa, 1), 'kg; margen mesa', f(g.mesaMargen, 3), 'm; rodillo a', f(zRod, 3), 'm; piso del dobson a', f(piso, 3), 'm');
}

console.log('\n=== D. Par de desbalance: cambia de signo en el medio de la carrera ===');
{ const g = caso(40, 0.632); const d = g.d, Mt = g.Mtot;
  // CdM corrido dz en altura (error de la medida, 0,5 cm) o dN en la corredera (2 mm): par alrededor del eje
  const par = (off, th) => { const cs = Math.cos(th), sn = Math.sin(th);
    const v = off.map((_, i) => off[i] * cs + cross(d, off)[i] * sn + d[i] * dot(d, off) * (1 - cs));
    return dot(cross(v, [0, 0, -Mt * 9.81]), d); };
  for (const [tag, off] of [['CdM 5 mm alto', [0, 0, 0.005]], ['CdM 10 mm alto (el borde de L1-15)', [0, 0, 0.010]], ['corredera 2 mm al norte', [0, 0.002, 0]], ['CdM 5 mm al este', [0.005, 0, 0]]]) {
    const xs = [-45, -20, 0, 20, 45].map((mn) => f(par(off, mn / 4 * D2R), 3));
    console.log('  ' + tag.padEnd(36), 'par (N m) a -45/-20/0/20/45 min:', xs.join(' / '));
  }
  // friccion de rodadura que tendria que vencer CAL-1 (mesa quieta sin correa): 608 + camisa
  const Fn = 245, mu = 0.0015, rb = 0.004, rr = 0.016, Rcanto = g.rollers[0].R;
  const tauFr = 2 * Fn * mu * rb / rr * Rcanto;
  console.log('  par de friccion de dos rodillos locos (608, mu 0,0015):', f(tauFr, 3), 'N m -> CdM fuera del eje que CAL-1 detecta:', f(tauFr / (Mt * 9.81) * 1000, 2), 'mm (L1-15 admite 10)');
}

console.log('\n=== E. Transmisiones: errores periodicos en una foto de 30, 15 y 60 s (formula propia) ===');
{ const R = 0.7685, dxdth = 0.7848;
  const corr = (a, T, t) => 2 * a * Math.sin(Math.min(Math.PI * t / T, Math.PI / 2));
  const rp = 20 * 0.002 / (2 * Math.PI);
  const conc = {
    F1: { av: Math.PI * 0.032 / 4, br: R, etapas: 1, rod: 0.032, red: 4 },
    F2: { av: Math.PI * 0.032 / 16, br: R, etapas: 2, rod: 0.032, red: 16 },
    T5: { av: 0.005, br: dxdth, etapas: 0, tornillo: 5e-6 },
    T4: { av: 0.004, br: dxdth, etapas: 0, tornillo: 5e-6 },
  };
  for (const [id, c] of Object.entries(conc)) {
    const Tm = c.av / c.br / SID, paso = c.av / 200 / c.br * AS;
    const per = [];
    for (let k = 0; k < c.etapas; k++) { const T = Tm * 4 ** k; per.push([0.00002 / rp * CIELO * T / (2 * Math.PI), T]); }
    if (c.rod) { const T = Tm * c.red; per.push([0.00002 / (c.rod / 2) * CIELO * T / (2 * Math.PI), T]); }
    if (c.tornillo) per.push([c.tornillo / c.br * AS, Tm]);
    for (const t of [15, 30, 60]) {
      const ps = per.map(([a, T]) => corr(a, T, t)), lin = ps.reduce((s, v) => s + v, 0), q = Math.hypot(...ps);
      const vel = 0.002 * CIELO * t, micro = 0.1 * paso;
      console.log(`  ${id} t=${t}s: periodicos ${ps.map((v) => f(v)).join('+')} (lineal ${f(lin)}, cuadr ${f(q)}) | velocidad 0,2% ${f(vel)} | micropaso p-p ${f(micro)} | total cuadr ${f(Math.hypot(q, vel, micro))} contra 1,5`);
    }
  }
}

console.log('\n=== F. La pista: cuanto canto recorre el rodillo en una foto ===');
{ const g = caso(40, 0.632);
  for (const r of g.rollers) {
    const umm = (r.lim.run[1] - r.lim.run[0]) * 1000;
    console.log(`  rodillo x=${f(r.Pt[0], 2)}: ${f(Math.abs(umm), 1)} mm de canto en 90 min -> ${f(Math.abs(umm) / 90 / 60 * 10, 2)} mm en 10 s, ${f(Math.abs(umm) / 90 / 60 * 15, 2)} mm en 15 s, ${f(Math.abs(umm) / 90 / 60 * 30, 2)} mm en 30 s`);
  }
  console.log('  sensibilidad (17 §1): 0,37"/um. Para 1" de pista por foto: 2,7 um de cambio de altura del canto dentro de ese tramo');
  // rodillo como filtro: sigue una onda de amplitud a y largo L solo si a(2pi/L)^2 < 1/r
  for (const a of [5e-6, 10e-6, 20e-6]) console.log(`  rodillo r=16 mm puentea ondas de ${f(a * 1e6, 0)} um mas cortas que ${f(2 * Math.PI * Math.sqrt(a * 0.016) * 1000, 2)} mm`);
}

console.log('\n=== G. El actuador de declinacion en el pivote: corrige Dec en proporcion a cos(H) ===');
{ // giro chico eps alrededor del eje E-O de la base; estrella en (H, dec) del hemisferio sur; componente en Dec
  const phi = -34.5 * D2R;
  const star = (H, dec) => { // ENU: H en horas, dec en grados
    const h = H * 15 * D2R, de = dec * D2R;
    const x = -Math.cos(de) * Math.sin(h), y0 = Math.cos(de) * Math.cos(h), z0 = Math.sin(de);
    // ecuatorial (x hacia el oeste con H) -> ENU en latitud phi: eje polar a phi bajo el horizonte norte... sur
    const yN = -Math.sin(phi) * y0 + Math.cos(phi) * z0, zU = Math.cos(phi) * y0 + Math.sin(phi) * z0;
    return [x, yN, zU];
  };
  const pole = [0, Math.cos(phi), Math.sin(phi)]; // polo elevado: en el sur phi<0 -> apunta al sur y arriba
  for (const [H, dec] of [[0, -60], [2, -60], [4, -60], [6, -60], [0, -5], [3, -5], [5, -5]]) {
    const p = star(H, dec), e = [1, 0, 0], dp = cross(e, p); // giro unitario alrededor de E-O
    // direccion de Dec en p: hacia el polo elevado, perpendicular a p
    let ed = sub(pole, mul(p, dot(pole, p))); ed = unit(ed);
    const era = unit(cross(pole, p));
    console.log(`  H=${H} h, dec=${dec}: componente Dec ${f(dot(dp, ed), 2)} | AR ${f(dot(dp, era), 2)} (por unidad de giro)`);
  }
}
