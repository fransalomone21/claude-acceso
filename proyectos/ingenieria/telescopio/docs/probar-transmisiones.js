// node docs/probar-transmisiones.js -- controles de transmisiones.js, con el mismo molde que
// probar-geometria.js: cada control corre con la entrada buena (verde) y con una saboteada (tiene que
// dar rojo). Si el saboteado da verde, el control no mide nada y el script sale con error.
// Los valores esperados salen de cuentas a mano escritas al lado, no de correr la funcion.
const T = require('./transmisiones.js');
const R = 0.7453, dxdth = 0.7689;   // geometria-vns.js (v10.4, valores de partida) y DRV.dxdth del modelo

const cerca = (x, y, tol) => Math.abs(x - y) <= tol;
const controles = [
  // pi * 0,032 / 4 / 200 / 0,7453 * 206265 = 34,8″ por paso entero (cuenta a mano)
  ['F de hoy: 34,8″ por paso entero', () => cerca(T.evaluar(T.CONCEPTOS.F1, R, dxdth).pasoCielo, 34.8, 0.1),
    () => cerca(T.evaluar({ ...T.CONCEPTOS.F1, red: 2 }, R, dxdth).pasoCielo, 34.8, 0.1)],
  // 0,008 / 200 / 0,7689 * 206265 = 10,7″
  ['V de la foto: 10,7″ por paso entero', () => cerca(T.evaluar(T.CONCEPTOS.V8, R, dxdth).pasoCielo, 10.73, 0.05),
    () => cerca(T.evaluar(T.CONCEPTOS.V8, R, dxdth / 2).pasoCielo, 10.73, 0.05)],
  // un motor de 0,9 grados parte el paso a la mitad, exacto
  ['motor de 0,9°: la mitad del paso', () => cerca(T.evaluar(T.CONCEPTOS.F09, R, dxdth).pasoCielo * 2, T.evaluar(T.CONCEPTOS.F1, R, dxdth).pasoCielo, 1e-9),
    () => cerca(T.evaluar({ ...T.CONCEPTOS.F09, pasos: 200 }, R, dxdth).pasoCielo * 2, T.evaluar(T.CONCEPTOS.F1, R, dxdth).pasoCielo, 1e-9)],
  // sin error de micropaso la estrella es redonda; con error, menos
  ['sin error de micropaso la estrella es redonda (1)', () => cerca(T.redondez(34.8, 0, 2.5), 1, 1e-12),
    () => cerca(T.redondez(34.8, 0.05, 2.5), 1, 1e-12)],
  // la cuenta de docs/14 §6b: la polea de 20 con 0,02 mm de descentrado corre la estrella ≈ 2,7″ en 60 s
  ['polea de 20 de la F: ≈ 2,7-2,8″ en 60 s (docs/14 §6b)', () => cerca(T.evaluar(T.CONCEPTOS.F1, R, dxdth).per[0].a * 2 * Math.sin(Math.PI * 60 / T.evaluar(T.CONCEPTOS.F1, R, dxdth).per[0].T), 2.75, 0.1),
    () => { const p = T.evaluar({ ...T.CONCEPTOS.F1, d: 0.016 }, R, dxdth).per[0]; return cerca(T.corrimiento(p.a, p.T, 60), 2.75, 0.1); }],
  // el borron: con +-5 % la F de hoy cae debajo de 0,8 de redondez (L0-02) solo con el micropaso
  ['F de hoy con ±5 %: redondez < 0,8 por el micropaso solo', () => T.redondez(T.evaluar(T.CONCEPTOS.F1, R, dxdth).pasoCielo, 0.05, 2.5) < 0.8,
    () => T.redondez(T.evaluar(T.CONCEPTOS.F2, R, dxdth).pasoCielo, 0.05, 2.5) < 0.8],
];

let fallas = 0;
for (const [nombre, bueno, saboteado] of controles) {
  const ok = bueno(), rojo = !saboteado();
  if (!ok || !rojo) fallas++;
  console.log((ok ? '[OK  ] ' : '[FAIL] ') + nombre + ' -- ' + (rojo ? 'saboteado da ROJO, bien' : 'SABOTEADO DA VERDE: el control no mide'));
}
process.exit(fallas ? 1 : 0);
