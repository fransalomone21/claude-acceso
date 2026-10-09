// Controles de contacto-vns.js, con sus sabotajes: cada control tiene que dar verde con el dato bueno
// y rojo con el dato roto, POR SU MOTIVO. node docs/probar-contacto.js -> sale 1 si algo falla.
const C = require('./contacto-vns.js');
const { rotAbout } = require('./geometria-vns.js');
const G = C.computeVNS(C.P_V105), t = G.plateT;
let fallas = 0;
const ok = (cond, msg) => { console.log(`${cond ? 'OK  ' : 'FALLA'} ${msg}`); if (!cond) fallas++; };
const f = (x, d) => x.toFixed(d == null ? 3 : d);
const cantos = [0, 1].map((i) => C.cantoEnvolvente(G, i, 0.011, t, false));

// C1 -- independiente de la cuenta: con el canto trazado por el punto de arriba, en el centro de la
// carrera la chapa sube r(1/cos b - 1), con b la pendiente EN EL MUNDO de la velocidad de la mesa en
// el punto de contacto (d x (Pt - C)). Una cuenta de una linea contra el Newton entero.
{
  const R = G.rollers[0], v = (() => { const r = [R.Pt[0] - G.C[0], R.Pt[1] - G.C[1], R.Pt[2] - G.C[2]], d = G.d;
    return [d[1] * r[2] - d[2] * r[1], d[2] * r[0] - d[0] * r[2], d[0] * r[1] - d[1] * r[0]]; })();
  const b = Math.atan(Math.abs(v[2]) / Math.hypot(v[0], v[1])), pred = 0.011 * (1 / Math.cos(b) - 1);
  const h0 = [0, 1].map((i) => C.subidaIdeal(G, i, 0.011, 'proyeccion', 0));
  ok(h0.every((h) => Math.abs(h - pred) < 2e-5), `C1 la chapa sube ${f(h0[0] * 1000)} mm en el centro; la cuenta de una linea da ${f(pred * 1000)} (a menos de 0,02)`);
  // S1 -- sabotaje de C1: con la chapa trazada como envolvente, la subida es cero y C1 tiene que dar rojo.
  const hEnv = C.subidaIdeal(G, 0, 0.011, 'envolvente', 0);
  ok(Math.abs(hEnv - pred) > 2e-4, `S1 con el canto bien trazado la subida es ${f(hEnv * 1000)} mm: C1 lo distingue`);
}
// C2 -- con el canto bien trazado (envolvente) la mesa gira sobre el eje: nada corre la estrella.
const base = C.barrer(G, { rr: 0.011, cantos });
ok(base.corrido60 < 0.02 && base.hMax < 1e-9, `C2 envolvente: ${f(base.corrido60)}" por foto (< 0,02) y el Newton cierra (${base.hMax.toExponential(1)} m)`);
// S2 -- sabotaje de C2: las chapas cambiadas de lado (la del este en el oeste). Tiene que dar rojo.
{
  const r = C.barrer(G, { rr: 0.011, cantos: [cantos[1], cantos[0]] });
  ok(r.corrido60 > 0.5 || r.hMax > 1e-6, `S2 chapas cambiadas de lado: ${f(r.corrido60)}" por foto (tiene que pasar 0,5)`);
}
// C3 -- independiente: los dos rodillos 0,5 mm mas altos, con la transmision ideal ('eje'), giran la mesa
// sobre el eje este-oeste por el pivote: alfa = dz / (dy + f' dz_c U_y), ~1,66' con esta geometria.
{
  const dz = 0.0005, R = G.rollers[0], dy = R.Pt[1] - G.pivot[1], dzc = R.Pt[2] - G.pivot[2];
  const fp = (() => { const e = C.cantoProyeccion(G, 0); return (e(2e-5) - e(-2e-5)) / 4e-5; })();
  const pred = Math.abs(dz / (dy + fp * dzc * R.uh[1])) * C.AS / 60;
  const r = C.barrer(G, { rr: 0.011, cantos, trans: 'eje', err: [{ off: [0, 0, dz] }, { off: [0, 0, dz] }] });
  ok(Math.abs(r.fijoMin - pred) < 0.05 && r.corrido60 < 0.05, `C3 rodillos 0,5 mm mas altos: la mesa gira ${f(r.fijoMin, 2)}' fijo (la palanca da ${f(pred, 2)}') y no corre la estrella (${f(r.corrido60)}")`);
}
// S3 -- sabotaje del detector: un escalon de 0,01 mm en el canto tiene que verse (> 1,5" en una foto,
// en el minuto en que el rodillo pasa por u = -50 mm), y sacarlo tiene que devolver el verde.
{
  const esc = (u) => 1e-5 * Math.min(1, Math.max(0, (u + 0.05) / 0.0005));
  const r = C.barrer(G, { rr: 0.011, cantos, defecto: [esc, null] });
  const mnEsperado = Math.round(-((-0.05) / (G.rollers[0].R)) / (15 * Math.PI / 180) * 60);
  ok(r.corrido60 > 1.5 && Math.abs(r.mnPeor - mnEsperado) <= 2, `S3 escalon de 0,01 mm: ${f(r.corrido60, 2)}" en el minuto ${r.mnPeor} (se espera cerca de ${mnEsperado})`);
  const r0 = C.barrer(G, { rr: 0.011, cantos, defecto: [(u) => 0, null] });
  ok(r0.corrido60 < 0.02, `S3' sin el escalon vuelve a ${f(r0.corrido60)}"`);
}
// C4 / S4 -- el rodillo de cuatro 608 sin diferencias ni chaflan es un cilindro: tiene que dar lo mismo
// que el rodillo entero; con diferencias de diametro, rojo.
{
  const cen = (base.recorridoEje[0][0] + base.recorridoEje[0][1]) / 2;
  const liso = C.rodillo608(cen + 0.0035, [0, 0, 0, 0], 0);
  const r = C.barrer(G, { rr: 0.011, cantos, err: [{ rFn: liso }, { rFn: liso }] });
  ok(r.corrido60 < 0.02, `C4 cuatro 608 iguales y sin chaflan: ${f(r.corrido60)}" (igual que el rodillo entero)`);
  const malo = C.rodillo608(cen, [0, -4.5e-6, 3e-6, -2e-6]);
  const r2 = C.barrer(G, { rr: 0.011, cantos, err: [{ rFn: malo }, { rFn: malo }] });
  ok(r2.corrido60 > 1, `S4 cuatro 608 con 4,5 um de diferencia y una costura en el medio: ${f(r2.corrido60, 2)}" (tiene que pasar 1)`);
}
// C5 -- la excentricidad tiene el periodo de una vuelta del rodillo: 2 pi r / R de giro de la mesa.
{
  const r = C.barrer(G, { rr: 0.011, cantos, trans: 'eje', err: [{ exc: 1e-5 }, {}] });
  const per = 2 * Math.PI * 0.011 / G.rollers[0].R / (15 * Math.PI / 180) * 60;   // minutos
  const amp = r.corrido60 / (2 * Math.PI / per);                                      // amplitud, segundos de arco
  ok(amp > 2 && amp < 4.5, `C5 excentricidad 0,01 mm: vuelta cada ${f(per, 1)} min, amplitud ${f(amp, 2)}" (la palanca da ~3,6"; 13 decia 2,9" con el de 32)`);
}
console.log(fallas ? `\n${fallas} FALLA(S)` : '\nTodo en verde.');
process.exit(fallas ? 1 : 0);
