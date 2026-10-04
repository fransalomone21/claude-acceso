// Geometria de la plataforma VNS para el hemisferio sur -- funcion pura.
// Unica fuente de los numeros que muestra el modelo 3D (06-modelo-3d.html
// la copia adentro: si se cambia aca, se cambia alla, y el test lo compara).
// Convencion: metros, ejes ENU (x = este, y = norte, z = arriba).
// En el sur el eje polar SUBE hacia el sur: el pivote va al NORTE (extremo
// bajo del eje) y los segmentos verticales al SUR (extremo alto). Es el
// espejo del VNS de Vogel, que esta hecho para el norte.

const D2R = Math.PI / 180;
const G = 9.81;
const add = (a, b) => [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
const sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
const mul = (a, k) => [a[0] * k, a[1] * k, a[2] * k];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const norm = (a) => Math.hypot(a[0], a[1], a[2]);
const unit = (a) => mul(a, 1 / norm(a));

// Rodrigues: rota p un angulo th alrededor del eje que pasa por c con direccion d.
function rotAbout(p, c, d, th) {
  const v = sub(p, c), cs = Math.cos(th), sn = Math.sin(th);
  return add(c, add(mul(v, cs), add(mul(cross(d, v), sn), mul(d, dot(d, v) * (1 - cs)))));
}

function solve3(A, b) { // Cramer, alcanza para 3x3
  const det = (m) => m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1]) - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  const D = det(A);
  return [0, 1, 2].map((k) => det(A.map((row, i) => row.map((v, j) => (j === k ? b[i] : v)))) / D);
}

// P: phi (grados), M (kg), Hdis (m, altura de diseno del eje sobre la mesa),
// Hreal (m, centro de masa medido sobre el piso del dobson), dN, dE (m, CdM
// corrido), shim (m, suplemento bajo el dobson), runMin (min a cada lado),
// half (m, medio ancho entre rodillos), postH (m, pivote elevado).
function computeVNS(P) {
  const phi = P.phi * D2R, s = Math.sin(phi), c = Math.cos(phi);
  const d = [0, -c, s];                       // hacia el polo sur celeste
  const thMax = (P.runMin / 60) * 15 * D2R;
  const FEET = 0.020, BASE = 0.018, TAB = 0.018, RROLL = 0.016;
  const groundTop = FEET + BASE;
  const ySouth = -0.27, yNorthTab = 0.27, yPlate = ySouth - 0.012;

  // Todo se calcula con la cara de arriba de la mesa en z = 0 y despues se
  // sube: el conjunto movil + eje es invariante a una traslacion vertical.
  const C = [0, 0, P.Hdis];
  const zPiv = -TAB - 0.004 + P.postH;
  const tP = (C[2] - zPiv) / s;
  const pivot = [0, tP * c, zPiv];
  const e = P.half;
  const PLATE_MIN = 0.030; // la chapa nunca queda mas angosta que 3 cm
  const N = 80;
  // El borde sube mas que el primer orden (c*e*thMax): se ajusta zc hasta que
  // el punto mas alto del borde quede PLATE_MIN debajo de la cara de la mesa.
  // Y como cada chapa va girada unos grados, su punta interior se acerca a la
  // mesa: se aleja el plano de las chapas hasta dejar 8 mm de luz en la punta.
  let zc = -(c * e * thMax + PLATE_MIN), yPl = yPlate;
  for (let it = 0; it < 6; it++) {
    const rs = buildRollers(zc, yPl);
    zc += -PLATE_MIN - Math.max(...rs.map((r) => r.zEdgeMax));
    const yMax = Math.max(...rs.map((r) => r.Pt[1] + Math.max(r.uh[1] * r.uMin, r.uh[1] * r.uMax)));
    yPl -= yMax - (ySouth - 0.008);
  }
  const rollers = buildRollers(zc, yPl);

  function buildRollers(zc, yPl) { return [e, -e].map((x) => {
    const Pt = [x, yPl, zc];
    const v = cross(d, sub(Pt, C));
    let uh = unit([v[0], v[1], 0]);
    if (uh[0] < 0) uh = mul(uh, -1);
    const nh = [-uh[1], uh[0], 0];
    const r = sub(Pt, C);
    const R = norm(sub(r, mul(d, dot(r, d))));
    const edge = [];
    let latMax = 0;
    for (let k = 0; k <= N; k++) {
      const th = -thMax + (2 * thMax * k) / N;
      const Q = rotAbout(Pt, C, d, -th);
      const w = sub(Q, Pt);
      latMax = Math.max(latMax, Math.abs(dot(w, nh)));
      edge.push({ th, u: dot(w, uh), z: Q[2] });
    }
    const sp = [];
    for (let k = 1; k <= N; k++) sp.push(Math.hypot(edge[k].u - edge[k - 1].u, edge[k].z - edge[k - 1].z));
    const mean = sp.reduce((a, b) => a + b, 0) / sp.length;
    const speedVar = ((Math.max(...sp) - Math.min(...sp)) / 2 / mean) * 100;
    edge.sort((a, b) => a.u - b.u);
    const us = edge.map((q) => q.u), zs = edge.map((q) => q.z);
    const angBeta = Math.atan2(uh[1], uh[0]) / D2R;
    return { Pt, uh, nh, R, edge, latMax, speedVar, beta: angBeta,
      chord: Math.max(...us) - Math.min(...us), uMin: Math.min(...us), uMax: Math.max(...us),
      zEdgeMin: Math.min(...zs), zEdgeMax: Math.max(...zs) };
  }); }

  const chord = Math.max(...rollers.map((r) => r.chord));
  const W = Math.max(0.30, e + chord / 2 + 0.02);
  const corners = [[W, ySouth, -TAB], [-W, ySouth, -TAB], [W, yNorthTab, -TAB], [-W, yNorthTab, -TAB]];
  const platePts = [];
  rollers.forEach((r) => r.edge.forEach((q) => platePts.push([r.Pt[0] + r.uh[0] * q.u, r.Pt[1] + r.uh[1] * q.u, q.z])));
  let minRel = Infinity;
  for (let k = 0; k <= 16; k++) {
    const th = -thMax + (2 * thMax * k) / 16;
    for (const p of corners.concat(platePts)) minRel = Math.min(minRel, rotAbout(p, C, d, th)[2]);
  }
  const ztt = Math.max(groundTop + 0.010 - minRel, groundTop + 0.006 + 2 * RROLL - zc);

  // Pasar a absoluto
  const up = (p) => [p[0], p[1], p[2] + ztt];
  const Cabs = up(C), pivotAbs = up(pivot);
  rollers.forEach((r) => {
    r.Pt = up(r.Pt);
    r.edge.forEach((q) => (q.z += ztt));
    r.zEdgeMin += ztt; r.zEdgeMax += ztt;
    r.plateHmin = ztt - r.zEdgeMax;   // la chapa llega hasta la cara de arriba de la mesa
    r.plateHmax = ztt - r.zEdgeMin;
  });

  // Centro de masa real, cargas en los tres apoyos y desbalance
  const Creal = [P.dE, P.dN, ztt + P.shim + P.Hreal];
  const sup = [pivotAbs, rollers[0].Pt, rollers[1].Pt];
  const F = solve3([[1, 1, 1], sup.map((q) => q[0]), sup.map((q) => q[1])], [P.M, P.M * Creal[0], P.M * Creal[1]]);
  const rr = sub(Creal, Cabs);
  const offAxis = norm(sub(rr, mul(d, dot(rr, d))));
  let tauMax = 0;
  for (let k = 0; k <= 32; k++) {
    const th = -thMax + (2 * thMax * k) / 32;
    const tau = dot(cross(sub(rotAbout(Creal, Cabs, d, th), Cabs), [0, 0, -P.M * G]), d);
    tauMax = Math.max(tauMax, Math.abs(tau));
  }
  const nrm = rotAbout([0, 0, 1], [0, 0, 0], d, thMax);
  const tilt = Math.acos(nrm[2]) / D2R;

  const ySouthBase = Math.min(...rollers.map((r) => r.Pt[1])) - 0.07, yNorthBase = pivotAbs[1] + 0.08;
  return {
    d, thMax, ztt, groundTop, ySouth, yNorthTab, yPlate, W, TAB, RROLL, FEET, BASE,
    C: Cabs, pivot: pivotAbs, rollers, Creal,
    loads: { pivote: F[0], este: F[1], oeste: F[2] },
    offAxis, tauMax, tilt,
    baseLength: yNorthBase - ySouthBase, baseWidth: 2 * (e + chord / 2 + 0.04),
    ySouthBase, yNorthBase, pivotDist: pivotAbs[1] - Cabs[1],
  };
}

if (typeof module !== 'undefined') module.exports = { computeVNS, rotAbout };
