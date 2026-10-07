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
// half (m, medio ancho entre rodillos), postH (m, pivote elevado), baseW (m,
// ancho pedido de la base al piso; nunca menos de lo que piden las chapas).
// Limites (min de MAS sobre runMin): swMin, el fin de carrera que corta el
// motor; stopMin, el talon de la chapa que choca el rodillo (tope fisico).
// La chapa se estira mas alla del tope un radio de rodillo + 2 mm, para que
// el talon sea lo que frena y no la punta de la chapa cayendose del rodillo.
function computeVNS(P) {
  const phi = P.phi * D2R, s = Math.sin(phi), c = Math.cos(phi);
  const d = [0, -c, s];                       // hacia el polo sur celeste
  const swMin = P.swMin != null ? P.swMin : 3, stopMin = P.stopMin != null ? P.stopMin : 6;
  const thRun = (P.runMin / 60) * 15 * D2R;
  const thSw = ((P.runMin + swMin) / 60) * 15 * D2R, thStop = ((P.runMin + stopMin) / 60) * 15 * D2R;
  const FEET = 0.020, BASE = 0.050, TAB = 0.040, RROLL = 0.016, TALON = 0.012;
  let thMax = thStop;                         // lo cubre la chapa; se estira abajo
  const groundTop = FEET + BASE;
  // v10 (mesa universal): la mesa se alarga al norte (tabN) para la corredera, y
  // el dobson apoya sobre rieles de railH montados ARRIBA del marco. Sin esos
  // dos parametros la geometria es la del v9.
  const ySouth = -0.27, yNorthTab = P.tabN != null ? P.tabN : 0.27, yPlate = ySouth - 0.012;
  const railH = P.railH || 0;

  // Todo se calcula con la cara de arriba de la mesa en z = 0 y despues se
  // sube: el conjunto movil + eje es invariante a una traslacion vertical.
  // BASE y TAB: planchuela de hierro DE CANTO (base 50 mm, marco de la mesa 40 mm).
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
    thMax = thStop + (RROLL + 0.002) / Math.min(...rs.map((r) => r.R));
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
    // Donde cae el contacto a lo ancho del rodillo (a lo largo de su eje), con
    // signo. Es CUADRATICO en el angulo: 0 en el centro de la carrera y hacia el
    // MISMO lado en las dos puntas. No es deslizamiento: la chapa va girada
    // respecto del rodillo y el punto de contacto camina por el rodillo, como el
    // cruce de las hojas de una tijera (2026-10-07). El rodillo se centra en el
    // medio de ese recorrido (latCenter) y su ancho tiene que cubrir latSwing.
    let latMax = 0, latLo = 0, latHi = 0, latRunLo = 0, latRunHi = 0;
    for (let k = 0; k <= N; k++) {
      const th = -thMax + (2 * thMax * k) / N;
      const Q = rotAbout(Pt, C, d, -th);
      const w = sub(Q, Pt);
      const lat = dot(w, nh);
      latMax = Math.max(latMax, Math.abs(lat));
      latLo = Math.min(latLo, lat); latHi = Math.max(latHi, lat);
      if (Math.abs(th) <= thRun + 1e-12) { latRunLo = Math.min(latRunLo, lat); latRunHi = Math.max(latRunHi, lat); }
      edge.push({ th, u: dot(w, uh), z: Q[2] });
    }
    const sp = [];
    for (let k = 1; k <= N; k++) sp.push(Math.hypot(edge[k].u - edge[k - 1].u, edge[k].z - edge[k - 1].z));
    const mean = sp.reduce((a, b) => a + b, 0) / sp.length;
    const speedVar = ((Math.max(...sp) - Math.min(...sp)) / 2 / mean) * 100;
    edge.sort((a, b) => a.u - b.u);
    const us = edge.map((q) => q.u), zs = edge.map((q) => q.z);
    const angBeta = Math.atan2(uh[1], uh[0]) / D2R;
    // donde cae el rodillo sobre la chapa (coordenada u) a cada angulo de limite
    const uAt = (th) => dot(sub(rotAbout(Pt, C, d, -th), Pt), uh);
    const lim = { run: [uAt(-thRun), uAt(thRun)], sw: [uAt(-thSw), uAt(thSw)], stop: [uAt(-thStop), uAt(thStop)] };
    const latSwing = latHi - latLo, latCenter = (latHi + latLo) / 2;
    return { Pt, uh, nh, R, edge, latMax, latLo, latHi, latSwing, latCenter, latRunSwing: latRunHi - latRunLo, speedVar, beta: angBeta, lim,
      chord: Math.max(...us) - Math.min(...us), uMin: Math.min(...us), uMax: Math.max(...us),
      zEdgeMin: Math.min(...zs), zEdgeMax: Math.max(...zs) };
  }); }

  const chord = Math.max(...rollers.map((r) => r.chord));
  const W = Math.max(0.30, e + chord / 2 + 0.02);
  const corners = [[W, ySouth, -TAB], [-W, ySouth, -TAB], [W, yNorthTab, -TAB], [-W, yNorthTab, -TAB]];
  const platePts = [];
  rollers.forEach((r) => r.edge.forEach((q) => platePts.push([r.Pt[0] + r.uh[0] * q.u, r.Pt[1] + r.uh[1] * q.u, q.z])));
  // los talones cuelgan TALON debajo de cada punta: tambien tienen que pasar sobre la base
  rollers.forEach((r) => [r.edge[0], r.edge[r.edge.length - 1]].forEach((q) => platePts.push([r.Pt[0] + r.uh[0] * q.u, r.Pt[1] + r.uh[1] * q.u, q.z - TALON])));
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

  // Centro de masa real, cargas en los tres apoyos y desbalance.
  // Lo que gira es el telescopio MAS la mesa: con una mesa de hierro (mTab, kg,
  // centro a zTab de la cara de arriba de la mesa) el centro de masa de todo lo
  // que gira baja, y es ESE el que tiene que caer sobre el eje (Hbal).
  const Creal = [P.dE, P.dN, ztt + railH + P.shim + P.Hreal];
  const mT = P.mTab || 0, zT = P.zTab != null ? P.zTab : -TAB / 2;
  const Ctab = [0, (ySouth + yNorthTab) / 2, ztt + zT];
  const Mtot = P.M + mT;
  const Cg = mul(add(mul(Creal, P.M), mul(Ctab, mT)), 1 / Mtot);
  const Hbal = Cg[2] - ztt;
  const sup = [pivotAbs, rollers[0].Pt, rollers[1].Pt];
  const F = solve3([[1, 1, 1], sup.map((q) => q[0]), sup.map((q) => q[1])], [Mtot, Mtot * Cg[0], Mtot * Cg[1]]);
  const rr = sub(Cg, Cabs);
  const offAxis = norm(sub(rr, mul(d, dot(rr, d))));
  let tauMax = 0;
  for (let k = 0; k <= 32; k++) {
    const th = -thRun + (2 * thRun * k) / 32;
    const tau = dot(cross(sub(rotAbout(Cg, Cabs, d, th), Cabs), [0, 0, -Mtot * G]), d);
    tauMax = Math.max(tauMax, Math.abs(tau));
  }
  const nrm = rotAbout([0, 0, 1], [0, 0, 0], d, thRun);
  const tilt = Math.acos(nrm[2]) / D2R;

  const ySouthBase = Math.min(...rollers.map((r) => r.Pt[1])) - 0.07, yNorthBase = pivotAbs[1] + 0.08;
  // Ancho de la base: lo que piden las chapas es el MINIMO; baseW (m) lo agranda
  // (las patas del sur se abren). Vuelco = cuanto hay que inclinar el conjunto
  // para que se caiga, con la mesa en el medio de la carrera (no suma la
  // inclinacion de la mesa: da 1 a 2 grados mas optimista que el calculo fino).
  const baseWidth = Math.max(2 * (e + chord / 2 + 0.04), P.baseW || 0);
  const wB = baseWidth / 2;
  const feet = [[wB - 0.04, ySouthBase + 0.04], [-(wB - 0.04), ySouthBase + 0.04], [0, yNorthBase - 0.04]];
  const distEdge = (a, b) => Math.abs((b[1] - a[1]) * (Cg[0] - a[0]) - (b[0] - a[0]) * (Cg[1] - a[1])) / Math.hypot(b[0] - a[0], b[1] - a[1]);
  const mSur = distEdge(feet[0], feet[1]), mLado = Math.min(distEdge(feet[0], feet[2]), distEdge(feet[1], feet[2]));
  const vuelcoSur = Math.atan(mSur / Cg[2]) / D2R, vuelcoLado = Math.atan(mLado / Cg[2]) / D2R;

  // La mesa APOYA en sus tres puntos (pivote y dos rodillos), no esta abulonada:
  // un empujon de costado en la boca del tubo la levanta de un rodillo. Margen =
  // distancia del CdM de lo que gira a la linea pivote-rodillo; empuje = los kg
  // que la levantan, aplicados a 1,3 m del piso (la convencion de estabilidad-base.js).
  const lineDist = (a, b) => Math.abs((b[1] - a[1]) * (Cg[0] - a[0]) - (b[0] - a[0]) * (Cg[1] - a[1])) / Math.hypot(b[0] - a[0], b[1] - a[1]);
  const mesaMargen = Math.min(...rollers.map((r) => lineDist(pivotAbs, r.Pt)));
  const empujeMesa = Mtot * mesaMargen / Math.max(0.1, 1.3 - rollers[0].Pt[2]);
  // Rodillo (ancho rollW) y chapa (espesor plateT): el contacto tiene que quedar
  // sobre el rodillo en todo el recorrido, con 3 mm de changui a cada lado.
  const rollW = P.rollW != null ? P.rollW : 0.030, plateT = P.plateT != null ? P.plateT : 0.00635;
  const rollNeed = Math.max(...rollers.map((r) => r.latSwing)) + plateT + 0.006;
  return {
    mesaMargen, empujeMesa, rollW, plateT, rollNeed, rollOK: rollNeed <= rollW + 1e-12,
    d, thMax, thRun, thSw, thStop, swMin, stopMin, TALON, ztt, railH, groundTop, ySouth, yNorthTab, yPlate, W, TAB, RROLL, FEET, BASE,
    C: Cabs, pivot: pivotAbs, rollers, Creal, Cg, Ctab, Mtot, Hbal,
    loads: { pivote: F[0], este: F[1], oeste: F[2] },
    offAxis, tauMax, tilt,
    baseLength: yNorthBase - ySouthBase, baseWidth, feet, vuelcoSur, vuelcoLado, vuelco: Math.min(vuelcoSur, vuelcoLado),
    ySouthBase, yNorthBase, pivotDist: pivotAbs[1] - Cabs[1],
  };
}

// La corredera (v10): cuanto hay que correr el dobson al norte (dN, m) para que
// el centro de masa de TODO lo que gira caiga sobre el eje. Forma cerrada: la
// altura del CdM no depende de dN, y el eje sube hacia el sur tan(phi) por
// metro (0,687 a 34,5 grados), asi que basta pedir rr paralelo a d en el plano y-z.
// Las chapas no dependen de dN: una sola corrida de computeVNS alcanza.
function dNEquilibrio(P) {
  const g = computeVNS({ ...P, dN: 0 });
  const c = -g.d[1], s = g.d[2];
  const yCg = g.C[1] - (c / s) * (g.Cg[2] - g.C[2]);
  const mT = P.mTab || 0;
  return (g.Mtot * yCg - mT * g.Ctab[1]) / P.M;
}

if (typeof module !== 'undefined') module.exports = { computeVNS, rotAbout, dNEquilibrio };
