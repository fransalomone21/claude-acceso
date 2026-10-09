// Como apoya la chapa en el rodillo, y que le hace eso a la estrella -- funcion pura.
// Sale de geometria-vns.js (las mismas chapas, rodillos y pivote que el modelo 3D v10.5)
// y contesta lo que el modelo no mide (2026-10-08, decimoseptima sesion):
//  1. el rodillo se TUERCE respecto de la chapa a lo largo de la carrera: la chapa apoya
//     en una arista y no en todo su espesor (cuanto, y desde que minuto);
//  2. el METODO DE TRAZADO: computeVNS traza el canto como el lugar del punto mas alto del
//     rodillo. Con un rodillo de radio r el canto correcto es la ENVOLVENTE del cilindro, y
//     la diferencia, r(1/cos b - 1), cambia con la pendiente b del canto a lo largo de la chapa;
//  3. las TOLERANCIAS: cuanto corre la estrella en 60 s cada error de fabricacion o de armado
//     (rodillo corrido, chapa girada, escalon, excentricidad, las costuras del rodillo de 608).
// Metodo: la mesa es un cuerpo rigido que gira sobre la rotula del pivote (un punto fijo, en el
// eje) y apoya en dos chapas. Para cada angulo de la carrera se calcula cuanto tiene que subir
// cada chapa para tocar su rodillo SIN penetrarlo (h = max sobre el canto de [techo del
// cilindro - canto], en el espesor entero de la chapa), y de esas dos subidas sale la rotacion
// chica que hace la mesa fuera del eje (omega, perpendicular al eje: el giro alrededor del eje
// lo fija la transmision). Lo LINEAL en el angulo es una inclinacion fija del eje y lo absorbe la
// puesta en estacion; lo que queda (el residuo) es lo que corre la estrella adentro de una foto.
// Metros, radianes, ejes ENU (x este, y norte, z arriba), como geometria-vns.js.
// Corre en node (require) y en el navegador (planos.html, despues de geometria-vns.js: queda en window.CONTACTO).

(function (root) {
const { computeVNS, rotAbout } = typeof require !== 'undefined' ? require('./geometria-vns.js') : root;
const AS = 180 / Math.PI * 3600;
const add = (a, b) => [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
const sub = (a, b) => [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
const mul = (a, k) => [a[0] * k, a[1] * k, a[2] * k];
const dot = (a, b) => a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const norm = (a) => Math.hypot(a[0], a[1], a[2]);
const O3 = [0, 0, 0];

// Golden-section: maximo de una funcion unimodal en [a, b].
function maxGolden(f, a, b, tol) {
  const g = (Math.sqrt(5) - 1) / 2;
  let x1 = b - g * (b - a), x2 = a + g * (b - a), f1 = f(x1), f2 = f(x2);
  while (b - a > tol) {
    if (f1 < f2) { a = x1; x1 = x2; f1 = f2; x2 = a + g * (b - a); f2 = f(x2); }
    else { b = x2; x2 = x1; f2 = f1; x1 = b - g * (b - a); f1 = f(x1); }
  }
  const x = (a + b) / 2; return { x, f: f(x) };
}

// Los parametros del modelo v10.5 (06-modelo-3d.html: P() con MESA y los deslizadores por defecto).
const P_V105 = { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.63, dN: 0.028, dE: 0, shim: 0, runMin: 45, half: 0.29,
  postH: 0.10, baseW: 1.3, mTab: 11, zTab: -0.02, tabN: 0.53, railH: 0.02, plateT: 0.00794 };

// El rodillo en el mundo: eje horizontal a lo largo de nh (asi lo pone el modelo), con el punto mas
// alto en Pt (el punto de contacto de computeVNS). err: off (m, mundo), yaw (gira el eje en planta),
// roll (levanta una punta del eje: una cuna en un angulo), dr (radio de mas), rFn(k) (radio segun
// la posicion k a lo largo del eje: las costuras de cuatro 608), exc (excentricidad, m) y fase.
function rodillo(G, i, rr, err) {
  const R = G.rollers[i];
  let a = R.nh.slice();
  if (err.yaw) a = rotAbout(a, O3, [0, 0, 1], err.yaw);
  if (err.roll) a = rotAbout(a, O3, R.uh, err.roll);
  const A = add(sub(R.Pt, [0, 0, rr]), err.off || O3);
  return { A, a, rr: rr + (err.dr || 0), rFn: err.rFn || null, exc: err.exc || 0, fase: err.fase || 0, R };
}

// La chapa en el marco de la mesa: origen en Pt, U a lo largo de la chapa, N el espesor, Z arriba.
// err: dz (la chapa entera mas alta), yaw (girada en planta), lean (inclinada fuera de la vertical).
function chapa(G, i, err) {
  const R = G.rollers[i];
  let U = R.uh.slice(), N = R.nh.slice(), Z = [0, 0, 1];
  if (err.yaw) { U = rotAbout(U, O3, [0, 0, 1], err.yaw); N = rotAbout(N, O3, [0, 0, 1], err.yaw); }
  if (err.lean) { N = rotAbout(N, O3, U, err.lean); Z = rotAbout(Z, O3, U, err.lean); }
  return { O: add(R.Pt, [0, 0, err.dz || 0]), U, N, Z };
}

// u del punto mas alto del rodillo visto desde la mesa girada th (el metodo de computeVNS).
const uTop = (G, i, th) => { const R = G.rollers[i]; return dot(sub(rotAbout(R.Pt, G.C, G.d, -th), R.Pt), R.uh); };
function thDeU(G, i, u) {           // inversa por secante: u(th) es monotona en la carrera
  let a = -0.25, b = 0.25, fa = uTop(G, i, a) - u, fb = uTop(G, i, b) - u;
  for (let k = 0; k < 60 && Math.abs(b - a) > 1e-13; k++) { const c = b - fb * (b - a) / (fb - fa); a = b; fa = fb; b = c; fb = uTop(G, i, b) - u; }
  return b;
}
// El canto como lo traza hoy computeVNS: el lugar del punto mas alto del rodillo, proyectado en la chapa.
function cantoProyeccion(G, i) {
  return (u) => rotAbout(G.rollers[i].Pt, G.C, G.d, -thDeU(G, i, u))[2] - G.rollers[i].Pt[2];
}

// El rodillo visto desde la mesa: la mesa esta girada th sobre el eje y, encima, la rotacion chica Om
// (mundo, sobre el pivote). Mundo = R_Om(R_th(mesa)), asi que mesa = R_th^-1(R_Om^-1(mundo)).
function rodilloEnMesa(G, ro, th, Om) {
  let A = ro.A, a = ro.a;
  const nO = Om ? norm(Om) : 0;
  if (nO > 0) { const k = mul(Om, 1 / nO); A = rotAbout(A, G.pivot, k, -nO); a = rotAbout(a, O3, k, -nO); }
  return { At: rotAbout(A, G.C, G.d, -th), at: rotAbout(a, O3, G.d, -th) };
}

// Altura (en Z de la chapa) del techo del cilindro sobre el punto (u, w) de la chapa, con la mesa
// girada th (y Om). -Infinity si la vertical por ese punto no corta el cilindro.
function techo(G, ro, ch, th, u, w, Om) {
  const { At, at } = rodilloEnMesa(G, ro, th, Om);
  const Pv = add(ch.O, add(mul(ch.U, u), mul(ch.N, w)));
  let rr = ro.rr;
  for (let it = 0; it < 2; it++) {
    const q = sub(Pv, At), qp = sub(q, mul(at, dot(q, at))), vp = sub(ch.Z, mul(at, dot(ch.Z, at)));
    const A2 = dot(vp, vp), B = dot(qp, vp), C = dot(qp, qp) - rr * rr, disc = B * B - A2 * C;
    if (disc < 0) return -Infinity;
    const lam = (-B + Math.sqrt(disc)) / A2;
    if (!ro.rFn && !ro.exc) return lam;
    const X = add(Pv, mul(ch.Z, lam)), k = dot(sub(X, At), at);
    rr = ro.rr + (ro.rFn ? ro.rFn(k) : 0);
    if (ro.exc) { // excentricidad: el radio que mira a la chapa cambia con lo que roto el rodillo (rueda sin patinar)
      const giro = (ro.R.R * th) / ro.rr;    // arco rodado / radio
      rr += ro.exc * Math.cos(giro + ro.fase);
    }
    if (it === 1) return lam;
    if (rr <= 0) return -Infinity;
  }
}

// Lo que tiene que subir la chapa i (en su Z) para tocar el rodillo sin penetrarlo, con la mesa en th.
// soloCentro: el rodillo basculante (se acuesta sobre el canto y apoya en el medio del espesor).
function subida(G, i, ro, ch, f, th, t, soloCentro, Om) {
  const u0 = uTop(G, i, th), W = soloCentro ? [0] : [];
  if (!soloCentro) for (let k = 0; k <= 8; k++) W.push(-t / 2 + (t * k) / 8);
  const enU = (w) => maxGolden((u) => techo(G, ro, ch, th, u, w, Om) - f(u), u0 - 0.012, u0 + 0.012, 1e-9);
  let best = { h: -Infinity };
  W.forEach((w, k) => { const m = enU(w); if (m.f > best.h) best = { h: m.f, u: m.x, w, k }; });
  if (!soloCentro && best.k > 0 && best.k < 8) {     // el maximo cayo adentro del espesor: se refina en w
    const m = maxGolden((w) => enU(w).f, W[best.k - 1], W[best.k + 1], 1e-8), mu = enU(m.x);
    if (mu.f > best.h) best = { h: mu.f, u: mu.x, w: m.x };
  }
  best.arista = !soloCentro && Math.abs(Math.abs(best.w) - t / 2) < 1e-6;
  const c = add(ch.O, add(mul(ch.U, best.u), add(mul(ch.N, best.w), mul(ch.Z, f(best.u) + best.h))));
  const de = 2e-5, fp = (f(best.u + de) - f(best.u - de)) / (2 * de);
  return { ...best, c, m: sub(ch.Z, mul(ch.U, fp)), tg: add(ch.U, mul(ch.Z, fp)) };
}

// El canto correcto para un rodillo de radio rr: la envolvente del cilindro en toda la carrera y
// en todo el espesor (o solo en el medio, con el rodillo basculante). Tabla cada 0,25 mm.
function cantoEnvolvente(G, i, rr, t, soloCentro, extraMin) {
  const ro = rodillo(G, i, rr, {}), ch = chapa(G, i, {});
  const thL = ((G.thRun / (15 * Math.PI / 180)) * 60 + (extraMin || 8)) / 60 * 15 * Math.PI / 180;
  const ua = uTop(G, i, thL), ub = uTop(G, i, -thL), u0 = Math.min(ua, ub), u1 = Math.max(ua, ub);
  const du = 0.00025, n = Math.ceil((u1 - u0) / du), tab = new Float64Array(n + 1);
  const W = soloCentro ? [0] : Array.from({ length: 9 }, (_, k) => -t / 2 + (t * k) / 8);
  for (let j = 0; j <= n; j++) {
    const u = u0 + j * du, th0 = thDeU(G, i, u);
    let mx = -Infinity;
    W.forEach((w) => { const m = maxGolden((th) => techo(G, ro, ch, th, u, w), th0 - 0.012, th0 + 0.012, 1e-10); if (m.f > mx) mx = m.f; });
    tab[j] = mx;
  }
  return (u) => { const x = (u - u0) / du, j = Math.max(0, Math.min(n - 1, Math.floor(x))), s = x - j; return tab[j] * (1 - s) + tab[j + 1] * s; };
}

// La rotacion chica de la mesa con la mesa en th: tres incognitas (omega en 3D, sobre el pivote) y
// tres condiciones: los dos apoyos y la TRANSMISION, que traba un movimiento:
//  'V' (la V de la foto y la T2): la punta del brazo no se mueve a lo largo de la varilla (este-oeste);
//  'F' (fricción, F2): el canto oeste no resbala sobre el rodillo motriz (no se mueve a lo largo del canto);
//  'eje': la transmision ideal, que fija el giro alrededor del eje polar.
// Lo que sale a lo largo del eje es error de VELOCIDAD (lo puede corregir una tabla del programa si la
// posicion de la mesa se sabe); lo que sale perpendicular es BAMBOLEO del eje, y eso no lo corrige nada.
const BRAZO_V = [0, -0.44, 0.135];   // punta del brazo de la V en el modelo (VARI.yJ, VARI.zN): hipotesis, a ojo de la foto
function omega(G, apoyos, th, trans) {
  const p = G.pivot, E = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
  const fila = (rc, m, h) => [...E.map((e) => dot(cross(e, rc), m)), h];
  const rows = apoyos.map((s) => fila(sub(s.c, p), s.m, s.h));
  if (trans === 'F') { const s = apoyos[1]; rows.push(fila(sub(s.c, p), s.tg, 0)); }
  else if (trans === 'eje') rows.push([...G.d, 0]);
  else rows.push(fila(sub(BRAZO_V, p), rotAbout([1, 0, 0], O3, G.d, -th), 0));
  const det3 = (m) => m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1]) - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  const A = rows.map((r) => r.slice(0, 3)), b = rows.map((r) => r[3]), Dt = det3(A);
  const w = [0, 1, 2].map((k) => det3(A.map((r, i) => r.map((v, j) => (j === k ? b[i] : v)))) / Dt);
  return rotAbout(w, O3, G.d, th);   // al mundo
}

// Barre la carrera minuto a minuto (un minuto de carrera = una foto de 60 s) y devuelve:
// corrido60 = lo maximo que corre la estrella en una foto (residuo, despues de la puesta en estacion);
// sinAlinear = lo mismo sin sacar lo lineal; ejeMin = cuanto se inclina el eje (lo absorbe la
// puesta en estacion); fijoMin = el giro fijo de la mesa (no hace nada); aristas = minutos en que
// alguna chapa apoya en una arista.
function barrer(G, conf) {
  const t = conf.t != null ? conf.t : G.plateT, runMin = conf.runMin || Math.round(G.thRun / (15 * Math.PI / 180) * 60);
  const rr = conf.rr || 0.011, soloCentro = !!conf.basculante;
  const err = conf.err || [{}, {}], errCh = conf.errChapa || [{}, {}];
  const cantos = conf.cantos || [0, 1].map((i) => (conf.metodo === 'proyeccion' ? cantoProyeccion(G, i) : cantoEnvolvente(G, i, rr, t, soloCentro)));
  const f = [0, 1].map((i) => (conf.defecto && conf.defecto[i] ? ((u) => cantos[i](u) + conf.defecto[i](u)) : cantos[i]));
  const ros = [0, 1].map((i) => rodillo(G, i, rr, err[i])), chs = [0, 1].map((i) => chapa(G, i, errCh[i]));
  const serie = [], aristas = new Set(), kAx = [[Infinity, -Infinity], [Infinity, -Infinity]];
  let Om = [0, 0, 0], hMax = 0;
  for (let mn = -runMin; mn <= runMin; mn++) {
    const th = mn / 60 * 15 * Math.PI / 180;
    // Newton: se gira la mesa (Om) hasta que las dos chapas tocan sin penetrar (h = 0). La solucion
    // no depende de donde la linealizacion pone el punto de contacto: eso solo cambia el camino.
    let ap;
    for (let it = 0; it < 8; it++) {
      ap = [0, 1].map((i) => subida(G, i, ros[i], chs[i], f[i], th, t, soloCentro, Om));
      if (Math.max(...ap.map((s) => Math.abs(s.h))) < 1e-10) break;
      Om = add(Om, omega(G, ap, th, conf.trans || 'V'));
    }
    hMax = Math.max(hMax, ...ap.map((s) => Math.abs(s.h)));
    ap.forEach((s, i) => { if (s.arista) aristas.add(mn);
      const { At, at } = rodilloEnMesa(G, ros[i], th, Om);
      const k = dot(sub(add(chs[i].O, add(mul(chs[i].U, s.u), mul(chs[i].N, s.w))), At), at);
      kAx[i][0] = Math.min(kAx[i][0], k); kAx[i][1] = Math.max(kAx[i][1], k); });
    serie.push({ mn, th, w: Om.slice(), h: ap.map((s) => s.h) });
  }
  // lo lineal en el angulo por cuadrados minimos, componente a componente: a lo largo del eje es un
  // error de velocidad constante (lo saca CAL-2); perpendicular, una inclinacion fija del eje (la saca
  // la puesta en estacion). El residuo es lo que corre la estrella adentro de una foto.
  const n = serie.length, mt = serie.reduce((s, q) => s + q.th, 0) / n, vt = serie.reduce((s, q) => s + (q.th - mt) ** 2, 0);
  const a = [0, 1, 2].map((c) => serie.reduce((s, q) => s + q.w[c], 0) / n);
  const b = [0, 1, 2].map((c) => serie.reduce((s, q) => s + (q.th - mt) * (q.w[c] - a[c]), 0) / vt);
  serie.forEach((q) => { q.res = [0, 1, 2].map((c) => q.w[c] - a[c] - b[c] * (q.th - mt)); q.resPerp = sub(q.res, mul(G.d, dot(q.res, G.d))); });
  let c60 = 0, p60 = 0, v60 = 0, s60 = 0, mnPeor = 0;
  for (let k = 1; k < n; k++) {
    const dr = sub(serie[k].res, serie[k - 1].res), d1 = norm(dr) * AS, d2 = norm(sub(serie[k].w, serie[k - 1].w)) * AS;
    if (d1 > c60) { c60 = d1; mnPeor = serie[k].mn; } s60 = Math.max(s60, d2);
    p60 = Math.max(p60, norm(sub(serie[k].resPerp, serie[k - 1].resPerp)) * AS);
    v60 = Math.max(v60, Math.abs(dot(dr, G.d)) * AS);
  }
  const bPerp = sub(b, mul(G.d, dot(b, G.d)));
  return { corrido60: c60, bamboleo60: p60, velocidad60: v60, mnPeor, sinAlinear: s60, ejeMin: norm(bPerp) * AS / 60,
    velPct: dot(b, G.d) * 100, fijoMin: norm(a) * AS / 60, hMax,
    aristas: aristas.size, desdeMin: aristas.size ? Math.min(...[...aristas].map(Math.abs)) : null,
    recorridoEje: kAx.map(([lo, hi]) => [lo, hi]), serie };
}

// El desalineo entre el eje del rodillo y el canto (gamma) y la luz que deja en el espesor.
function desalineo(G, i, mn, t) {
  const R = G.rollers[i], th = mn / 60 * 15 * Math.PI / 180, f = cantoProyeccion(G, i), u = uTop(G, i, th);
  const de = 2e-5, fp = (f(u + de) - f(u - de)) / (2 * de);
  const ne = (() => { const v = sub([0, 0, 1], mul(R.uh, fp)); return mul(v, 1 / norm(v)); })();
  const at = rotAbout(R.nh, O3, G.d, -th), g = Math.asin(dot(at, ne));
  return { mn, gammaMin: g * 180 / Math.PI * 60, luz: Math.tan(g) * (t || G.plateT), pendiente: fp };
}

// Presion de contacto (Hertz, acero sobre acero, E* = 115 GPa): linea (todo el espesor) y arista
// (un canto vivo de radio rho que cruza el rodillo: esfera equivalente de radio raiz(r rho)).
function hertz(Fn, rr, t, rho) {
  const E = 115e9;
  return { linea: Math.sqrt(Fn * E / (Math.PI * t * rr)), arista: Math.cbrt(6 * Fn * E * E / (Math.PI ** 3 * rr * rho)) };
}

// Las costuras del rodillo de cuatro 608: radio de cada aro (diferencias de fabricacion, m) y un
// chaflan de 0,3 mm en cada borde. k es la posicion a lo largo del eje, medida desde el centro.
function rodillo608(centro, difs, chaflan) {
  const ch = chaflan != null ? chaflan : 0.0003, ancho = 0.007;
  return (k) => {
    const x = k - centro, j = Math.floor((x + 0.014) / ancho);
    if (j < 0 || j > 3) return -0.002;                       // fuera del rodillo
    const borde = Math.min(x + 0.014 - j * ancho, (j + 1) * ancho - (x + 0.014));
    return difs[j] - Math.max(0, ch - borde);
  };
}

// Las tolerancias: cada error, solo, sobre chapas trazadas bien (envolvente del rodillo de radio rr).
// cota = la medida del plano a la que se le pide la tolerancia; mag = un error de taller tipico;
// tol = el error que deja la estrella en PORCION segundos de arco por foto (lineal en el error).
// La PORCION es una propuesta de la sesion (TBR, fase 1): de los 1,5" de toda la plataforma
// (L2-PLT-02), 0,5" para la geometria de chapas y rodillos, repartidos en cuadratura entre los
// errores que pesan: ~0,2" cada uno.
const PORCION = 0.2;
const D = Math.PI / 180;
const ESCENARIOS = [
  { id: 'rod-z', cota: 'altura de un rodillo', mag: 0.0005, u: 'mm', conf: (m) => ({ err: [{ off: [0, 0, m] }, {}] }) },
  { id: 'rod-x', cota: 'posicion este-oeste de un rodillo (separacion)', mag: 0.001, u: 'mm', conf: (m) => ({ err: [{ off: [m, 0, 0] }, {}] }) },
  { id: 'rod-y', cota: 'posicion norte-sur de un rodillo', mag: 0.002, u: 'mm', conf: (m) => ({ err: [{ off: [0, m, 0] }, {}] }) },
  { id: 'rod-yaw', cota: 'eje de un rodillo girado en planta', mag: 1 * D, u: 'grados', conf: (m) => ({ err: [{ yaw: m }, {}] }) },
  { id: 'rod-roll', cota: 'eje de un rodillo inclinado (una punta mas alta)', mag: 0.5 * D, u: 'grados', conf: (m) => ({ err: [{ roll: m }, {}] }) },
  { id: 'chapa-z', cota: 'altura de una chapa (agujeros ovalados)', mag: 0.0005, u: 'mm', conf: (m) => ({ errChapa: [{ dz: m }, {}] }) },
  { id: 'chapa-yaw', cota: 'chapa girada en planta', mag: 0.5 * D, u: 'grados', conf: (m) => ({ errChapa: [{ yaw: m }, {}] }) },
  { id: 'chapa-lean', cota: 'chapa fuera de plomo', mag: 0.5 * D, u: 'grados', conf: (m) => ({ errChapa: [{ lean: m }, {}] }) },
  { id: 'piv-y', cota: 'posicion norte-sur del pivote', mag: 0.002, u: 'mm', conf: (m) => ({ err: [{ off: [0, -m, 0] }, { off: [0, -m, 0] }] }) },
  { id: 'piv-z', cota: 'altura del pivote', mag: 0.002, u: 'mm', conf: (m) => ({ err: [{ off: [0, 0, -m] }, { off: [0, 0, -m] }] }) },
  { id: 'rod-dr', cota: 'diametro de un rodillo distinto del de diseno', mag: 0.00002, u: 'mm', conf: (m) => ({ err: [{ dr: m }, {}] }) },
  { id: 'rod-exc', cota: 'excentricidad (salto) de un rodillo', mag: 0.00001, u: 'mm', conf: (m) => ({ err: [{ exc: m }, {}] }) },
  { id: 'canto-50', cota: 'ondulacion del canto, largo de onda 50 mm', mag: 0.00001, u: 'mm', conf: (m) => ({ defecto: [(u) => m * Math.sin(2 * Math.PI * u / 0.05), null] }) },
  { id: 'canto-5', cota: 'ondulacion del canto, largo de onda 5 mm', mag: 0.000002, u: 'mm', conf: (m) => ({ defecto: [(u) => m * Math.sin(2 * Math.PI * u / 0.005), null] }) },
  { id: 'canto-esc', cota: 'escalon en el canto (en 0,5 mm)', mag: 0.00001, u: 'mm', conf: (m) => ({ defecto: [(u) => m * Math.min(1, Math.max(0, (u + 0.05) / 0.0005)), null] }) },
];

// tol: sin tabla de posicion; tolB: con la tabla de posicion en el programa (solo la V/T2, que no
// patina: corrige todo lo que sale a lo largo del eje y queda el bamboleo).
function tolerancias(G, rr, t, trans) {
  const cantos = [0, 1].map((i) => cantoEnvolvente(G, i, rr, t, false));
  const tolDe = (mag, c1, c2) => { if (c1 < 1e-4) return null; const L = c2 / c1; return mag * PORCION / c1 * (L > 2.5 ? Math.sqrt(2 / L) : 1); };
  return ESCENARIOS.map((e) => {
    const r1 = barrer(G, { rr, t, cantos, trans, ...e.conf(e.mag) }), r2 = barrer(G, { rr, t, cantos, trans, ...e.conf(2 * e.mag) });
    const esc = e.u === 'grados' ? 180 / Math.PI : 1000, mag = e.mag * esc;
    return { id: e.id, cota: e.cota, unidad: e.u, mag, corrido60: r1.corrido60, bamboleo60: r1.bamboleo60, ejeMin: r1.ejeMin,
      lineal: r1.corrido60 > 1e-3 ? r2.corrido60 / r1.corrido60 : null,
      tol: tolDe(mag, r1.corrido60, r2.corrido60), tolB: tolDe(mag, r1.bamboleo60, r2.bamboleo60) };
  });
}

// Cuanto tiene que subir la chapa i, con la mesa en su pose ideal (sin la rotacion chica), al minuto mn.
function subidaIdeal(G, i, rr, metodo, mn) {
  const t = G.plateT, f = metodo === 'proyeccion' ? cantoProyeccion(G, i) : cantoEnvolvente(G, i, rr, t, false);
  return subida(G, i, rodillo(G, i, rr, {}), chapa(G, i, {}), f, mn / 60 * 15 * Math.PI / 180, t, false, null).h;
}

const API = { P_V105, PORCION, ESCENARIOS, computeVNS, subidaIdeal, barrer, desalineo, hertz, rodillo608, cantoProyeccion, cantoEnvolvente, tolerancias, uTop, AS };
if (typeof module !== 'undefined' && module.exports) module.exports = API; else root.CONTACTO = API;

if (typeof require !== 'undefined' && require.main === module) {
  const G = computeVNS(P_V105), t = G.plateT, f1 = (x, d) => x.toFixed(d == null ? 2 : d);
  console.log('Contacto chapa-rodillo, modelo v10.5 (rodillos a 58 cm, chapa 5/16"), carrera +-45 min\n');
  console.log('1. El rodillo se tuerce respecto de la chapa (igual a los dos lados de la carrera):');
  [5, 15, 30, 45, 51].forEach((mn) => { const q = desalineo(G, 0, mn, t); console.log(`   ${mn} min: ${f1(q.gammaMin, 1)}' -> ${f1(q.luz * 1e6, 0)} um de luz en los 7,94 mm`); });
  const Fn = 25 * 9.81, hz = hertz(Fn, 0.011, t, 0.0005);
  console.log(`   con 25 kg sobre un 608: linea ${f1(hz.linea / 1e6, 0)} MPa, arista viva ${f1(hz.arista / 1e6, 0)} MPa\n`);
  const casos = [
    ['hoy: canto trazado por el punto de arriba, 608 (r 11 mm)', { metodo: 'proyeccion', rr: 0.011 }],
    ['hoy, con rodillo torneado de 32 (r 16 mm)', { metodo: 'proyeccion', rr: 0.016 }],
    ['canto trazado como envolvente del 608 (control)', { rr: 0.011 }],
    ['envolvente + rodillo basculante', { rr: 0.011, basculante: true }],
  ];
  console.log('2. El metodo de trazado (corrido de la estrella en una foto de 60 s, lo peor de la carrera):');
  casos.forEach(([n, c]) => { const r = barrer(G, c); console.log(`   ${n}: ${f1(r.corrido60)}" (bamboleo ${f1(r.bamboleo60)}", min ${r.mnPeor}); eje inclinado ${f1(r.ejeMin)}'; arista en ${r.aristas} de 91 min`); });
  ['F', 'eje'].forEach((tr) => { const r = barrer(G, { metodo: 'proyeccion', rr: 0.011, trans: tr }); console.log(`   hoy, 608, transmision ${tr}: ${f1(r.corrido60)}" (bamboleo ${f1(r.bamboleo60)}")`); });

  console.log(`\n3. Tolerancias (V/T2, 608, chapas trazadas bien; cada error solo; tol = el error que deja ${PORCION}" por foto;`);
  console.log('   con tabla = si el programa corrige con una tabla por posicion de la mesa lo que sale a lo largo del eje):');
  const tl = tolerancias(G, 0.011, t, 'V');
  const tx = (v, u) => (v == null ? 'libre' : f1(v, 3) + ' ' + u);
  tl.forEach((q) => console.log(`   ${q.cota}: ${f1(q.mag, 3)} ${q.unidad} -> ${f1(q.corrido60, 3)}" (bamboleo ${f1(q.bamboleo60, 3)}", eje ${f1(q.ejeMin, 2)}')  tol ${tx(q.tol, q.unidad)}; con tabla ${tx(q.tolB, q.unidad)}`));

  console.log('\n4. El rodillo de cuatro 608 (aros de 7 mm, chaflan 0,3 mm, diametros que difieren 0 / -4,5 / +3 / -2 um):');
  const cantos = [0, 1].map((i) => cantoEnvolvente(G, i, 0.011, t, false));
  const base = barrer(G, { rr: 0.011, cantos }), [k0, k1] = base.recorridoEje[0], cen = (k0 + k1) / 2;
  console.log(`   el contacto camina ${f1((k1 - k0) * 1000, 1)} mm a lo largo del rodillo en +-45 min`);
  [['un aro centrado en el camino', cen + 0.0035], ['una costura en el medio del camino', cen]].forEach(([n, c0]) => {
    const fn = rodillo608(c0, [0, -4.5e-6, 3e-6, -2e-6]);
    const r = barrer(G, { rr: 0.011, cantos, err: [{ rFn: fn }, { rFn: fn }] });
    console.log(`   ${n}: ${f1(r.corrido60)}" (bamboleo ${f1(r.bamboleo60)}", min ${r.mnPeor})`);
  });
}
})(typeof window !== 'undefined' ? window : globalThis);
