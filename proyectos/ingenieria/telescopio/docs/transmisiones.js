// Transmisiones de la plataforma: cuanto mueve el cielo cada paso del motor y que le hace eso a la
// estrella en una foto. Funcion pura: la usan 06-modelo-3d.html (seccion «La estrella en la foto») y
// docs/15-mecanismos-y-proveedores.md (node docs/transmisiones.js imprime la tabla). Controles:
// node docs/probar-transmisiones.js.
//
// Lo nuevo (2026-10-08, decimosexta sesion): el error de MICROPASO. Un paso a paso comun de 1,8 grados
// cae en cada paso entero con +-5 % de error (dato de hoja de datos: «step angle accuracy +-5 %, full
// step, no load»), y el micropaso NO lo achica: da resolucion, no exactitud (Analog Devices/Trinamic).
// Ese error se repite cada 1 a 4 pasos enteros, o sea cada pocos segundos: adentro de una foto de 60 s
// no es un corrimiento, es un BORRON que estira la estrella en ascension recta. Lo que lo achica es que
// cada paso entero mueva poco el cielo: reduccion.
//
// Convencion: metros, segundos, segundos de arco (″). El cielo gira 15,04″ por segundo.

const SID = 7.2921e-5;           // rad/s, rotacion sidérea
const AS = 206264.806;           // ″ por radian
const CIELO = SID * AS;          // 15,04″ por segundo

// Los conceptos. tipo 'rodillo': el motor gira (por una reduccion) un cilindro que mueve el canto de la
// chapa por friccion o por cable; 'varilla': el motor gira un tornillo y la tuerca empuja la mesa por una
// biela (la V de la foto de Fran, o un tornillo de bolas). red = reduccion entre motor y rodillo/tornillo.
// pulley: dientes de la polea chica de cada etapa (su descentrado es el error periodico mas grande).
const CONCEPTOS = {
  F1:  { nombre: 'F de hoy: rodillo Ø32 + una correa 20:80', tipo: 'rodillo', d: 0.032, red: 4, pasos: 200, etapas: 1 },
  F2:  { nombre: 'F con dos correas 20:80 (16:1)', tipo: 'rodillo', d: 0.032, red: 16, pasos: 200, etapas: 2 },
  F09: { nombre: 'F con motor de 0,9° (400 pasos)', tipo: 'rodillo', d: 0.032, red: 4, pasos: 400, etapas: 1 },
  C:   { nombre: 'C: cable sobre el eje de 8 mm (cabrestante) + 20:80', tipo: 'rodillo', d: 0.0085, red: 4, pasos: 200, etapas: 1 },
  V8:  { nombre: 'V de la foto: varilla de paso 8 + biela', tipo: 'varilla', paso: 0.008, red: 1, pasos: 200, etapas: 0 },
  T5:  { nombre: 'T2: tornillo de bolas SFU1605 (paso 5) + biela', tipo: 'varilla', paso: 0.005, red: 1, pasos: 200, etapas: 0 },
  T4:  { nombre: 'T2: tornillo de bolas SFU1204 (paso 4) + biela', tipo: 'varilla', paso: 0.004, red: 1, pasos: 200, etapas: 0 },
};

// Referencia: monturas comerciales. EQ6: 9.024.000 micropasos (64) por vuelta -> 9,2″ por paso entero;
// HEQ5-R Pro: 6.144.000 (64) -> 13,5″ (foro IceInSpace y ficha de Sky-Watcher; 2026-10-08).
const MONTURAS = { EQ6: 1296000 / (9024000 / 64), HEQ5R: 1296000 / (6144000 / 64) };

// R: radio del canto de la chapa desde el eje (geometria-vns.js, rollers[i].R). dxdth: cuanto avanza la
// tuerca por radian de mesa (m/rad), de la geometria de la biela (06-modelo-3d.html, DRV.dxdth).
function evaluar(c, R, dxdth) {
  const avancePorVuelta = c.tipo === 'rodillo' ? Math.PI * c.d / c.red : c.paso / c.red;  // m de canto o de tuerca por vuelta del motor
  const brazo = c.tipo === 'rodillo' ? R : dxdth;                                        // m por radian de mesa
  const pasoCielo = avancePorVuelta / c.pasos / brazo * AS;                             // ″ por paso entero
  const tPaso = pasoCielo / CIELO;                                                       // s por paso entero
  const vueltaMotor = avancePorVuelta / brazo / SID;                                     // s por vuelta del motor
  // errores que se repiten (amplitud en el cielo, ″, y periodo, s), con la tolerancia de cada pieza
  const per = [];
  if (c.etapas >= 1) {
    // descentrado e de la polea chica de CADA etapa: modula la velocidad e/r_paso (0,31 % con 0,02 mm,
    // sea cual sea lo que venga despues); su periodo es una vuelta de su eje: la del motor en la etapa 1,
    // la del eje intermedio (4 veces mas lento) en la 2
    const rp = 20 * 0.002 / (2 * Math.PI), e = 0.00002;
    for (let k = 0; k < c.etapas; k++) {
      const T = vueltaMotor * Math.pow(4, k);
      per.push({ que: 'polea de 20' + (c.etapas > 1 ? ' (etapa ' + (k + 1) + ')' : '') + ', 0,02 mm de descentrado', a: (e / rp) * CIELO * T / (2 * Math.PI), T });
    }
  }
  if (c.tipo === 'rodillo') {
    const T = vueltaMotor * c.red, e = 0.00002;   // una vuelta del rodillo (o del eje del cable)
    per.push({ que: (c.d < 0.02 ? 'eje del cable' : 'rodillo') + ', 0,02 mm de descentrado', a: (e / (c.d / 2)) * CIELO * T / (2 * Math.PI), T });
  } else {
    const T = vueltaMotor * c.red, e = 0.000005;  // una vuelta del tornillo: 5 µm de alabeo (hipotesis; una varilla comun, mucho peor)
    per.push({ que: 'tornillo, 5 µm de alabeo por vuelta', a: e / dxdth * AS, T });
  }
  return { ...c, pasoCielo, tPaso, vueltaMotor, per };
}

// Corrimiento de un error periodico (amplitud a, periodo T) en una foto de t segundos, en la peor fase.
const corrimiento = (a, T, t) => 2 * a * Math.sin(Math.min(Math.PI * t / T, Math.PI / 2));

// La estrella: el aire (seeing, FWHM en ″) es una campana redonda; el error de micropaso (+-eps de un
// paso entero, mucho mas rapido que la foto) la estira en ascension recta. Redondez = ancho menor / mayor
// (segundos momentos, que es lo que mide Siril). L0-02 pide 0,8 o mas en la imagen apilada.
function redondez(pasoCielo, eps, fwhm) {
  const s = fwhm / 2.3548, A = eps * pasoCielo;
  return s / Math.sqrt(s * s + A * A / 2);
}

function tabla(R, dxdth, opt) {
  const o = { eps: 0.05, fwhm: 2.5, t: 60, ...(opt || {}) };
  return Object.entries(CONCEPTOS).map(([id, c]) => {
    const r = evaluar(c, R, dxdth);
    return { id, nombre: c.nombre, pasoCielo: r.pasoCielo, tPaso: r.tPaso, micro: o.eps * r.pasoCielo,
      ppMicro: 2 * o.eps * r.pasoCielo, redondez: redondez(r.pasoCielo, o.eps, o.fwhm),
      per: r.per.map((p) => ({ ...p, enFoto: corrimiento(p.a, p.T, o.t) })), vueltaMotor: r.vueltaMotor };
  });
}

if (typeof module !== 'undefined') {
  module.exports = { CONCEPTOS, MONTURAS, evaluar, redondez, corrimiento, tabla, CIELO };
  if (require.main === module) {
    // R y dxdth del modelo v10.4 con los valores de partida (geometria-vns.js + VARI de 06-modelo-3d.html)
    const R = 0.7453, dxdth = 0.7689;
    const f = (x, k = 1) => x.toFixed(k).replace('.', ',');
    console.log('Monturas comerciales: EQ6 ' + f(MONTURAS.EQ6) + '″ y HEQ5-R ' + f(MONTURAS.HEQ5R) + '″ por paso entero');
    for (const eps of [0.03, 0.05, 0.10]) {
      console.log('\n--- error de micropaso ±' + eps * 100 + ' % de un paso entero, aire de 2,5″, foto de 60 s ---');
      for (const r of tabla(R, dxdth, { eps })) {
        console.log(r.id.padEnd(4) + ' paso entero ' + f(r.pasoCielo).padStart(5) + '″ (cada ' + f(r.tPaso, 2) + ' s)  borron ' + f(r.ppMicro, 2) + '″ p-p  redondez ' + f(r.redondez, 2)
          + (eps === 0.05 ? '   | ' + r.per.map((p) => p.que + ': ' + f(p.a) + '″ cada ' + f(p.T / 60) + ' min -> ' + f(p.enFoto) + '″ en 60 s').join(' ; ') : ''));
      }
    }
  }
}
