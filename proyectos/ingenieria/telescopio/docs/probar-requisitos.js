// node docs/probar-requisitos.js -- la Prueba_De_Requisitos del telescopio (T16 de arquitectura-se, L1-11).
// Imprime una linea 'REQ <ID> PASA|FALLA <detalle>' por cada requisito que el concepto ya permite calcular; la lee
// matriz-verificacion.py (la cascada la corre al entrar). Un requisito de ANALISIS queda verificado por esta cuenta;
// uno de ensayo, inspeccion o demostracion queda solo PREDICHO: la cuenta es del diseno, no del objeto.
//
// No copia ningun dato (ley de cero divergencias, T20). Cada numero se lee de su dueno:
//   - el punto de diseno vigente (v10.5): los valores por defecto de los controles y MESA en 06-modelo-3d.html;
//   - la envolvente del 300: el glosario de 10-requisitos.md;
//   - el CRITERIO de cada requisito: su propio enunciado ('no menos de 22 grados').
// Si un dueno cambia de forma y el patron no lo encuentra, sale con codigo 2: la matriz lo da ROJO (L2-MVR-07) en vez
// de seguir comparando contra un numero viejo. Las unicas constantes son dos supuestos, con su fuente, abajo.
//
// Se evalua en los EXTREMOS de la envolvente (NASA, apendice D: el criterio de exito en los bordes de tolerancia).
//   node docs/probar-requisitos.js             las lineas REQ
//   node docs/probar-requisitos.js --sabotaje  base angosta y rodillos juntos: L1-13 y L1-14 TIENEN que dar FALLA
const fs = require('fs');
const path = require('path');
const { computeVNS, dNEquilibrio } = require('./geometria-vns.js');

const SUPUESTOS = {
  M12liviano: 40,    // kg: el 12" mas liviano de la envolvente (docs/14 §3), hipotesis hasta comprar el modelo
  H200bajo: 62.7,    // cm: el CdM mas bajo del 200, medido 63,2 +- 0,5 por el vuelco (docs/08 §3.3, 2026-10-17)
};

function falla(msg) { console.error('probar-requisitos: ' + msg); process.exit(2); }
function num(s) { return parseFloat(String(s).replace(',', '.')); }

// --- el punto de diseno, del modelo
function puntoDeDiseno() {
  const html = fs.readFileSync(path.join(__dirname, '06-modelo-3d.html'), 'utf8');
  const def = {};
  for (const m of html.matchAll(/id="(\w+)" type="range"[^>]*?value="([-\d.]+)"/g)) def[m[1]] = num(m[2]);
  const lineaP = (html.match(/const P=\(\)=>\(\{([^\n]*)\}\);/) || [])[1];
  const mesa = (html.match(/const MESA=\{([^}]*)\}/) || [])[1];
  if (!lineaP || !mesa) falla('no encuentro P() o MESA en 06-modelo-3d.html: cambio la forma del modelo');
  const P = {};
  for (const m of lineaP.matchAll(/(\w+):([-\d.]+)(?=[,}]|$)/g)) P[m[1]] = num(m[2]);               // phi, zTab
  for (const m of lineaP.matchAll(/(\w+):\+?\$\(['"](\w+)['"]\)\.value(?:\/(\d+))?/g)) {          // M, Hdis, half...
    if (!(m[2] in def)) falla('el control ' + m[2] + ' no tiene valor por defecto en el modelo');
    P[m[1]] = def[m[2]] / (m[3] ? num(m[3]) : 1);
  }
  for (const m of mesa.matchAll(/(\w+):([-\d.]+)/g)) P[m[1]] = num(m[2]);
  for (const k of ['phi', 'M', 'Hdis', 'Hreal', 'runMin', 'half', 'postH', 'baseW', 'mTab', 'zTab', 'tabN', 'railH'])
    if (!(k in P) || Number.isNaN(P[k])) falla('el punto de diseno no trae ' + k);
  return P;
}

// --- los requisitos, de su documento
const REQ_MD = fs.readFileSync(path.join(__dirname, '10-requisitos.md'), 'utf8');
function enunciado(id) {
  const fila = REQ_MD.split('\n').find((l) => l.startsWith('| ' + id + ' |'));
  if (!fila) falla(id + ' no esta en 10-requisitos.md');
  return fila.split('|')[2];
}
function criterio(id, re) {
  const m = enunciado(id).match(re);
  if (!m) falla('el enunciado de ' + id + ' ya no tiene la forma ' + re + ': actualizar esta prueba');
  return num(m[1]);
}
function envolvente300() {
  const fila = REQ_MD.split('\n').find((l) => l.startsWith('| dobson de 300 mm |'));
  const m = fila && fila.match(/no más de (\d+) kg, centro de masa entre (\d+) y (\d+) cm/);
  if (!m) falla('el glosario ya no define la envolvente del 300 con la forma esperada');
  return { Mmax: num(m[1]), Hmin: num(m[2]), Hmax: num(m[3]) };
}

// La banda de latitud, de L1-09 ('entre 30,5 y 38,5 grados sur').
function banda() {
  const m = enunciado('L1-09').match(/entre ([\d,]+) y ([\d,]+) grados/);
  if (!m) falla('el enunciado de L1-09 ya no tiene la forma de una banda de latitud: actualizar esta prueba');
  return [num(m[1]), num(m[2])];
}
// Vuelco con la base inclinada alfa grados por las patas (alfa > 0: latitud mayor que la de diseno, el sur sube).
// En coordenadas de la plataforma el 'arriba' verdadero se inclina hacia el sur; para cada borde del triangulo de
// patas, el vuelco es cuanto mas hay que inclinar para que el CdM quede sobre el borde. Con alfa = 0 da lo mismo
// que vuelcoSur y vuelcoLado de geometria-vns.js (con la mesa en el medio de la carrera).
function vuelcoInclinado(g, alfa, C = g.Cg) {
  const r = alfa * Math.PI / 180, u = [0, -Math.sin(r), Math.cos(r)], f = g.feet;
  const cen = [(f[0][0] + f[1][0] + f[2][0]) / 3, (f[0][1] + f[1][1] + f[2][1]) / 3];
  const borde = (a, b) => {
    const le = Math.hypot(b[0] - a[0], b[1] - a[1]);
    let n = [(b[1] - a[1]) / le, -(b[0] - a[0]) / le];
    if (n[0] * (cen[0] - a[0]) + n[1] * (cen[1] - a[1]) > 0) n = [-n[0], -n[1]];
    const rn = (C[0] - a[0]) * n[0] + (C[1] - a[1]) * n[1], un = u[0] * n[0] + u[1] * n[1];
    return (Math.atan2(C[2], rn) - Math.atan2(u[2], un)) * 180 / Math.PI;
  };
  return Math.min(borde(f[0], f[1]), borde(f[0], f[2]), borde(f[1], f[2]));
}

// El CdM de lo que gira, con la mesa girada th radianes alrededor del eje polar (Rodrigues). Si el CdM esta sobre
// el eje no se mueve; si no lo esta, el vuelco en la punta de la carrera es otro.
function cdmGirado(g, th) {
  const c = g.C, k = g.d, v = [g.Cg[0] - c[0], g.Cg[1] - c[1], g.Cg[2] - c[2]], cs = Math.cos(th), sn = Math.sin(th);
  const kxv = [k[1] * v[2] - k[2] * v[1], k[2] * v[0] - k[0] * v[2], k[0] * v[1] - k[1] * v[0]];
  const kv = k[0] * v[0] + k[1] * v[1] + k[2] * v[2];
  return [0, 1, 2].map((i) => c[i] + v[i] * cs + kxv[i] * sn + k[i] * kv * (1 - cs));
}

function casos(D) {
  const e = envolvente300();
  const Hmax200 = criterio('L2-PLT-05', /entre \d+ y (\d+) cm/);
  const c = [
    ['el 200, CdM ' + SUPUESTOS.H200bajo + ' cm', D.M, SUPUESTOS.H200bajo / 100],
    ['el 200, CdM ' + Math.round(D.Hreal * 100) + ' cm (modelo)', D.M, D.Hreal],
    ['el 200, CdM ' + Hmax200 + ' cm', D.M, Hmax200 / 100],
  ];
  for (const M of [SUPUESTOS.M12liviano, e.Mmax]) for (const H of [e.Hmin, e.Hmax]) c.push(['12in ' + M + ' kg, CdM ' + H + ' cm', M, H / 100]);
  return c.map(([tag, M, H]) => { const q = { ...D, M, Hreal: H }; q.dN = dNEquilibrio(q); return { tag, M, g: computeVNS(q) }; });
}

function evaluar(D) {
  const cs = casos(D), out = [];
  const peor = (f, menor) => cs.reduce((a, b) => ((menor ? f(b) < f(a) : f(b) > f(a)) ? b : a));
  const linea = (id, ok, txt) => out.push('REQ ' + id + ' ' + (ok ? 'PASA' : 'FALLA') + ' ' + txt + ' [modelo 06]');

  const c13 = criterio('L1-13', /no menos de ([\d,]+) N/), w13 = peor((x) => x.g.empujeMesa, true);
  const v13 = w13.g.empujeMesa * 9.81;
  linea('L1-13', v13 >= c13, 'peor ' + v13.toFixed(1) + ' N (' + w13.tag + ') contra >= ' + c13 + ' N');

  // L1-14 vale en cada latitud de L1-09 (v0.3): la base se inclina con las patas y el borde que baja pierde margen.
  const [latA, latB] = D.sinBanda ? [D.phi, D.phi] : banda(), c14 = criterio('L1-14', /no menos de ([\d,]+) grados/);
  for (const x of cs) {
    x.v14 = Infinity;
    for (const lat of [latA, D.phi, latB]) for (const th of [-x.g.thMax, 0, x.g.thMax]) {
      const v = vuelcoInclinado(x.g, lat - D.phi, D.sinPunta ? x.g.Cg : cdmGirado(x.g, th));
      if (v < x.v14) { x.v14 = v; x.lat14 = lat; }
    }
  }
  const w14 = peor((x) => x.v14, true);
  linea('L1-14', w14.v14 >= c14, 'peor ' + w14.v14.toFixed(2) + ' grados (' + w14.tag + ', a ' + w14.lat14 + ' grados de latitud) contra >= ' + c14);

  const c30 = criterio('L1-30', /no más de ([\d,]+) kg/), cam = criterio('L2-CAM-03', /no más de ([\d,]+) kg/);
  const v30 = Math.max(...cs.map((x) => x.M)) + cam + D.mTab;
  linea('L1-30', v30 <= c30, 'peor ' + v30.toFixed(1) + ' kg (dobson ' + Math.max(...cs.map((x) => x.M)) + ' + tren de imagen ' + cam
    + ' por L2-CAM-03 + mesa ' + D.mTab + ') contra <= ' + c30);

  const c21 = criterio('L1-21', /no más de ([\d,]+) cm/), w21 = peor((x) => x.g.ztt + x.g.railH, false);
  const v21 = (w21.g.ztt + w21.g.railH) * 100;
  linea('L1-21', v21 <= c21, 'la cara de arriba de los rieles a ' + v21.toFixed(1) + ' cm del piso contra <= ' + c21);

  const c02 = criterio('L1-02', /no menos de ([\d,]+) min/), v02 = 2 * D.runMin;
  linea('L1-02', v02 >= c02, 'la carrera de diseno es ' + v02 + ' min (' + D.runMin + ' a cada lado) contra >= ' + c02);
  return out;
}

const D = puntoDeDiseno();
if (process.argv.includes('--sabotaje')) {
  // Base angosta y rodillos juntos: el conjunto vuelca y la mesa se levanta. Si la prueba no lo ve, no prueba.
  // El control no exige que el diseno vigente PASE (eso es de la matriz, y puede cambiar): exige que el sabotaje
  // EMPEORE el valor medido. Asi el saboteador no se rompe solo el dia que el diseno cambie.
  const malo = evaluar({ ...D, baseW: 0.80, half: 0.14 }), vig = evaluar(D);
  const linea = (ls, id) => ls.find((l) => l.startsWith('REQ ' + id + ' ')) || '';
  const valor = (l) => num((l.match(/peor ([\d.]+)/) || [])[1]);
  for (const id of ['L1-13', 'L1-14']) {
    const cae = linea(malo, id).startsWith('REQ ' + id + ' FALLA');
    const empeora = valor(linea(malo, id)) < valor(linea(vig, id));
    console.log((cae && empeora ? 'ok  ' : 'MAL ') + 'sabotaje ' + id + ': ' + valor(linea(vig, id)) + ' -> ' + valor(linea(malo, id))
      + (cae ? ', FALLA' : ', NO CAE'));
    if (!(cae && empeora)) process.exitCode = 1;
  }
  // La inclinacion por latitud es load-bearing: sin la banda, el peor vuelco tiene que salir MAS alto que con ella.
  const plano = evaluar({ ...D, sinBanda: true });
  const conBanda = valor(linea(vig, 'L1-14')), sinBanda = valor(linea(plano, 'L1-14'));
  const pesa = conBanda < sinBanda;
  console.log((pesa ? 'ok  ' : 'MAL ') + 'sabotaje L1-14 sin la banda de L1-09: ' + conBanda + ' con la banda, ' + sinBanda + ' sin ella');
  if (!pesa) process.exitCode = 1;
  // La punta de la carrera tambien se mide: con el CdM corrido 5 cm fuera del eje (el dobson corrido de su muesca),
  // girar la mesa tiene que cambiar el peor vuelco. Si no cambia, el giro no esta llegando a la cuenta.
  const corrido = (d) => evaluar({ ...d, dE: 0.05 });
  const conPunta = valor(linea(corrido(D), 'L1-14')), sinPunta = valor(linea(corrido({ ...D, sinPunta: true }), 'L1-14'));
  const gira = conPunta < sinPunta;
  console.log((gira ? 'ok  ' : 'MAL ') + 'sabotaje L1-14 con el CdM 5 cm fuera del eje: ' + conPunta + ' con la punta, ' + sinPunta + ' sin ella');
  if (!gira) process.exitCode = 1;
  return;
}
for (const l of evaluar(D)) console.log(l);
