// Dibujos de los mecanismos (2026-10-08, decimosexta sesion). FUENTE UNICA: los usan el modelo 3D
// (06-modelo-3d.html, seccion «Cuatro maneras de mover la mesa») y dibujo-mecanismos.html, de donde
// dibujos-mecanismos.ps1 saca los PNG de docs/img/ que van al Doc «3 - Mecanismos, proveedores y cielo».
// Necesita transmisiones.js (y geometria-vns.js para el del empujon) cargados antes.
// Colores por variables CSS con respaldo: en el modelo siguen el modo oscuro; en el PNG salen claros.
(function (global) {
  const T = global.TRANS || (typeof require !== 'undefined' ? require('./transmisiones.js') : null);
  const ST = '<style>.k{stroke:var(--ink,#15202c);fill:none;stroke-width:1.6}.km{stroke:var(--muted,#5a6878);fill:none;stroke-width:1.1}'
    + '.ka{stroke:var(--accent,#b8650a);fill:none;stroke-width:2.2}.kr{stroke:var(--axis,#c83a32);fill:none;stroke-width:1.6}'
    + '.fs{fill:color-mix(in srgb,var(--muted,#5a6878) 22%,transparent);stroke:var(--ink,#15202c);stroke-width:1.4}'
    + '.fa{fill:color-mix(in srgb,var(--accent,#b8650a) 22%,transparent);stroke:var(--accent,#b8650a);stroke-width:1.4}'
    + '.fk{fill:var(--ink,#15202c)}.fac{fill:var(--accent,#b8650a)}.fr{fill:var(--axis,#c83a32)}'
    + '.t{font:13px Arial,Helvetica,sans-serif;fill:var(--muted,#5a6878)}.tb{font:bold 15px Arial,Helvetica,sans-serif;fill:var(--ink,#15202c)}'
    + '.th{font:bold 18px Arial,Helvetica,sans-serif;fill:var(--ink,#15202c)}.ta{font:bold 15px Arial,Helvetica,sans-serif;fill:var(--accent,#b8650a)}'
    + '.tr{font:bold 14px Arial,Helvetica,sans-serif;fill:var(--axis,#c83a32)}.tg{font:bold 14px Arial,Helvetica,sans-serif;fill:var(--ok,#2f7d4f)}</style>';
  const f = (x, k = 1) => x.toLocaleString('es-AR', { minimumFractionDigits: k, maximumFractionDigits: k });
  const tx = (x, y, s, c, a) => '<text x="' + x.toFixed(1) + '" y="' + y.toFixed(1) + '" class="' + (c || 't') + '"' + (a ? ' text-anchor="' + a + '"' : '') + '>' + s + '</text>';
  const ci = (x, y, r, c) => '<circle cx="' + x.toFixed(1) + '" cy="' + y.toFixed(1) + '" r="' + r.toFixed(1) + '" class="' + c + '"/>';
  const li = (x1, y1, x2, y2, c, extra) => '<line x1="' + x1.toFixed(1) + '" y1="' + y1.toFixed(1) + '" x2="' + x2.toFixed(1) + '" y2="' + y2.toFixed(1) + '" class="' + c + '"' + (extra || '') + '/>';
  const re = (x, y, w, h, c, rx) => '<rect x="' + x.toFixed(1) + '" y="' + y.toFixed(1) + '" width="' + w.toFixed(1) + '" height="' + h.toFixed(1) + '" class="' + c + '"' + (rx ? ' rx="' + rx + '"' : '') + '/>';
  // correa abierta entre dos poleas (tangentes exteriores)
  function correa(x1, y1, r1, x2, y2, r2, c) {
    const d = Math.hypot(x2 - x1, y2 - y1), a = Math.atan2(y2 - y1, x2 - x1), b = Math.acos((r1 - r2) / d);
    const p = (x, y, r, t) => [x + r * Math.cos(t), y + r * Math.sin(t)];
    const [a1, a2] = [a + b, a - b];
    const P1 = p(x1, y1, r1, a1), P2 = p(x2, y2, r2, a1), Q1 = p(x1, y1, r1, a2), Q2 = p(x2, y2, r2, a2);
    return li(P1[0], P1[1], P2[0], P2[1], c) + li(Q1[0], Q1[1], Q2[0], Q2[1], c);
  }
  // la chapa vista de frente: el canto de abajo es un arco con el punto mas bajo en el medio (ahi
  // apoya el rodillo en el centro de la carrera) y las puntas mas altas; arriba, la cara de la mesa
  // (recta). Como en el plano de la chapa del modelo: mas alta en el medio que en las puntas.
  const arcoU = (cx, yB, R, half) => { const cy = yB - R, a = half / R, p = []; for (let k = 0; k <= 30; k++) { const t = Math.PI / 2 + a - 2 * a * k / 30; p.push([cx + R * Math.cos(t), cy + R * Math.sin(t)]); } return p; };
  function chapa(cx, yB, R, half, h) {
    const pts = arcoU(cx, yB, R, half), e = pts[pts.length - 1], s = pts[0], top = Math.min(s[1], e[1]) - h;
    return '<path d="M' + pts.map((q) => q[0].toFixed(1) + ',' + q[1].toFixed(1)).join(' L') + ' L' + e[0].toFixed(1) + ',' + top.toFixed(1) + ' L' + s[0].toFixed(1) + ',' + top.toFixed(1) + ' Z" class="fs"/>';
  }
  const motor = (x, y, s) => re(x - s / 2, y - s / 2, s, s, 'fk', 3) + ci(x, y, s * 0.18, 'km');

  // A. Cuatro maneras de mover la mesa (esquemas, no a escala), con los numeros de transmisiones.js
  function trans(el, R, dxdth) {
    const tab = T.tabla(R || 0.7685, dxdth || 0.7848, { eps: 0.05, fwhm: 2.5, t: 60 });
    const by = Object.fromEntries(tab.map((r) => [r.id, r]));
    const W = 360, H = 300, pan = [];
    const pie = (r, l1, l2) => tx(14, 222, 'Cada paso entero: <tspan class="tb">' + f(r.pasoCielo) + '″</tspan> en el cielo', 't')
      + tx(14, 241, 'Micropaso ±5 %: borrón de <tspan class="' + (r.redondez >= 0.8 ? 'tg' : 'tr') + '">' + f(r.ppMicro, 1) + '″ · redondez ' + f(r.redondez, 2) + '</tspan>', 't')
      + tx(14, 262, l1, 't') + tx(14, 280, l2 || '', 't');
    // F de hoy
    {
      let s = tx(14, 24, 'F · rodillo + una correa 20:80', 'th') + tx(14, 44, 'la de hoy (opción 1 del modelo)', 't');
      s += chapa(210, 100, 420, 120, 34) + tx(110, 64, 'chapa: el canto es la pista', 't');
      s += ci(210, 116, 16, 'fa') + ci(210, 116, 30, 'km') + tx(246, 150, 'rodillo Ø32', 't') + tx(246, 166, '+ polea de 80', 't');
      s += motor(84, 176, 34) + ci(84, 176, 8, 'ka') + correa(210, 116, 30, 84, 176, 8, 'ka') + tx(108, 200, 'NEMA 17 + polea de 20', 't');
      s += pie(by.F1, 'Sin dientes. Patina si el centro de masa', 'queda mal (se mide en el banco).');
      pan.push(s);
    }
    // F con dos correas
    {
      let s = tx(14, 24, 'F2 · la misma, con dos correas', 'th') + tx(14, 44, '16:1, con un eje intermedio', 't');
      s += chapa(240, 100, 420, 105, 34) + ci(240, 116, 16, 'fa') + ci(240, 116, 30, 'km');
      s += ci(140, 150, 30, 'km') + ci(140, 150, 8, 'ka') + correa(240, 116, 30, 140, 150, 8, 'ka');
      s += motor(52, 186, 30) + ci(52, 186, 8, 'ka') + correa(140, 150, 30, 52, 186, 8, 'ka');
      s += tx(118, 196, 'eje intermedio', 't');
      s += pie(by.F2, 'Lo mismo que F, más un eje con dos', 'rulemanes y otra correa.');
      pan.push(s);
    }
    // V de la foto
    {
      let s = tx(14, 24, 'V · varilla roscada + biela', 'th') + tx(14, 44, 'la de la foto (opción 2)', 't');
      s += re(20, 168, 320, 10, 'fs') + motor(42, 150, 34) + re(62, 145, 16, 10, 'fa');
      for (let x = 82; x < 320; x += 6) s += li(x, 146, x + 4, 154, 'km');
      s += li(80, 150, 322, 150, 'k');
      s += re(196, 136, 30, 28, 'fa', 3) + tx(150, 196, 'tuerca en su carro', 't');
      s += li(211, 136, 262, 82, 'k') + ci(211, 136, 5, 'fk') + ci(262, 82, 5, 'fk') + tx(244, 124, 'biela', 't');
      s += li(262, 82, 262, 64, 'k') + re(140, 56, 200, 8, 'fs') + tx(140, 82, 'brazo de la mesa', 't');
      s += pie(by.V8, 'No patina. Con tornillo de bolas es T2;', 'con varilla común no llega (paso desparejo).');
      pan.push(s);
    }
    // C: cable
    {
      let s = tx(14, 24, 'C · cable sobre el eje (cabrestante)', 'th') + tx(14, 44, 'idea nueva, de los brazos de robot', 't');
      s += chapa(190, 100, 420, 130, 34);
      const p = arcoU(190, 100, 420, 130), iL = 12, iR = 18;
      s += '<path d="M' + p.slice(0, iL + 1).map((q) => q[0].toFixed(1) + ',' + (q[1] + 2).toFixed(1)).join(' L') + ' C' + p[iL][0].toFixed(1) + ',140 ' + p[iR][0].toFixed(1) + ',140 ' + p[iR][0].toFixed(1) + ',' + (p[iR][1] + 2).toFixed(1)
        + ' L' + p.slice(iR).map((q) => q[0].toFixed(1) + ',' + (q[1] + 2).toFixed(1)).join(' L') + '" class="ka"/>';
      s += ci(190, 124, 6, 'fk') + ci(p[0][0], p[0][1] + 2, 4, 'fr') + ci(p[30][0], p[30][1] + 2, 4, 'fr');
      s += tx(26, 76, 'anclado', 't') + tx(286, 76, 'resorte', 't') + tx(206, 140, 'eje de 8: 2-3 vueltas', 't') + tx(206, 156, 'de cable de acero', 't');
      s += motor(84, 184, 30) + ci(84, 184, 8, 'ka') + ci(190, 124, 22, 'km') + correa(190, 124, 22, 84, 184, 8, 'ka');
      s += pie(by.C, 'No patina, sin dientes ni juego. Riesgo:', 'nadie lo probó en una plataforma.');
      pan.push(s);
    }
    const cols = 2, svg = ['<svg viewBox="0 0 ' + (W * cols + 20) + ' ' + (H * 2 + 10) + '" role="img" aria-label="Cuatro maneras de mover la mesa: F, F con dos correas, V y C, con lo que mueve cada paso del motor">' + ST];
    pan.forEach((s, i) => { svg.push('<g transform="translate(' + (10 + (i % cols) * W) + ',' + (5 + Math.floor(i / cols) * H) + ')">' + re(2, 2, W - 8, H - 10, 'km', 8) + s + '</g>'); });
    el.innerHTML = svg.join('') + '</svg>';
  }

  // B. La estrella en una foto de 60 s: el aire (campana redonda) + el borron del micropaso (en AR).
  // Se integra de verdad sobre los pixeles de la Sony (0,67″) y la redondez se MIDE en la imagen
  // (segundos momentos), no se copia de la formula.
  function estrella(el, R, dxdth, opt) {
    const o = { eps: 0.05, fwhm: 2.5, px: 0.67, ...(opt || {}) };
    const tab = T.tabla(R || 0.7685, dxdth || 0.7848, { eps: o.eps, fwhm: o.fwhm });
    const by = Object.fromEntries(tab.map((r) => [r.id, r]));
    const casos = [['ideal', 'sin error', 0], ['F1', 'F de hoy', by.F1.micro], ['F2', 'F con 2 correas', by.F2.micro], ['V8', 'V de la foto', by.V8.micro], ['T5', 'tornillo de bolas', by.T5.micro]];
    const N = 15, cel = 10, sg = o.fwhm / 2.3548, gap = 34, W = casos.length * (N * cel + gap) + 10;
    let s = '<svg viewBox="0 0 ' + W + ' ' + (N * cel + 92) + '" role="img" aria-label="Cinco estrellas simuladas en una foto de 60 segundos, una por transmision">' + ST;
    casos.forEach(([id, nom, A], i) => {
      const img = [], x0 = 10 + i * (N * cel + gap);
      let tot = 0, mx = 0, my = 0;
      for (let j = 0; j < N; j++) for (let k = 0; k < N; k++) {
        let v = 0;
        for (let a = 0; a < 3; a++) for (let b = 0; b < 3; b++) {
          const x = (k - (N - 1) / 2 + (a - 1) / 3) * o.px, y = (j - (N - 1) / 2 + (b - 1) / 3) * o.px;
          for (let q = 0; q < 24; q++) { const dx = x - A * Math.sin(2 * Math.PI * (q + 0.5) / 24); v += Math.exp(-(dx * dx + y * y) / (2 * sg * sg)); }
        }
        img.push(v); tot += v;
      }
      const pk = Math.max(...img);
      let sxx = 0, syy = 0;
      img.forEach((v, n) => { const k = n % N - (N - 1) / 2, j = Math.floor(n / N) - (N - 1) / 2; sxx += v * k * k; syy += v * j * j; });
      const rd = Math.sqrt(Math.min(sxx, syy) / Math.max(sxx, syy));
      img.forEach((v, n) => { const g = Math.round(255 * Math.pow(v / pk, 0.55)); s += '<rect x="' + (x0 + (n % N) * cel) + '" y="' + (8 + Math.floor(n / N) * cel) + '" width="' + cel + '" height="' + cel + '" fill="rgb(' + g + ',' + g + ',' + g + ')"/>'; });
      s += tx(x0 + N * cel / 2, N * cel + 32, nom, 'tb', 'middle');
      s += tx(x0 + N * cel / 2, N * cel + 52, 'redondez ' + f(rd, 2), rd >= 0.8 ? 'tg' : 'tr', 'middle');
      s += tx(x0 + N * cel / 2, N * cel + 70, A ? 'borrón ±' + f(A, 1) + '″' : 'solo el aire', 't', 'middle');
    });
    el.innerHTML = s.replace('viewBox="0 0 ' + W + ' ' + (N * cel + 92) + '"', 'viewBox="0 0 ' + W + ' ' + (N * cel + 112) + '"')
      + tx(10, N * cel + 90, 'Aire de ' + f(o.fwhm, 1) + '″, píxel de ' + f(o.px, 2) + '″ (Sony a 1200 mm), micropaso ±' + f(o.eps * 100, 0) + ' % de un paso entero; la AR va de izquierda a derecha.', 't')
      + tx(10, N * cel + 108, 'La redondez se mide sobre los píxeles dibujados. La foto apilada pide 0,8 o más (L0-02), y esto es sólo el micropaso.', 't') + '</svg>';
  }

  // C. El banco de la palanca optica: un puntero laser, un espejito en el eje del motor y una pared.
  function palanca(el, D) {
    D = D || 2;
    const paso = 1.8 * Math.PI / 180, enPared = 2 * paso * D * 1000;   // el espejo duplica el angulo
    let s = '<svg viewBox="0 0 760 330" role="img" aria-label="Banco de la palanca optica: un laser rebota en un espejito pegado al eje del motor y marca en una pared lejana">' + ST;
    s += li(20, 250, 560, 250, 'k') + tx(24, 270, 'mesa', 't');
    s += motor(110, 222, 52) + li(110, 196, 110, 176, 'k') + re(96, 160, 28, 16, 'fa', 2) + tx(40, 150, 'espejito pegado al eje', 't');
    s += re(330, 214, 70, 18, 'fk', 4) + tx(318, 206, 'puntero láser', 't');
    s += li(330, 223, 124, 170, 'kr') + li(124, 170, 700, 80, 'kr') + li(124, 170, 700, 120, 'kr', ' stroke-dasharray="6 4"');
    s += li(700, 30, 700, 300, 'k') + tx(706, 46, 'pared', 't');
    for (let k = 0; k <= 16; k++) s += li(694, 60 + k * 5, 706, 60 + k * 5, 'km');
    s += tx(560, 70, 'un paso entero', 'tb') + tx(560, 140, 'el siguiente', 't');
    s += li(200, 290, 700, 290, 'km') + tx(420, 310, 'distancia D = ' + f(D, 0) + ' m', 't', 'middle');
    s += tx(20, 24, 'Un paso entero (1,8°) gira el haz 3,6°: en la pared son ' + f(enPared, 0) + ' mm.', 'tb');
    s += tx(20, 46, 'Un micropaso de 1/16 son ' + f(enPared / 16, 1) + ' mm; un error de ±5 % del paso son ±' + f(enPared * 0.05, 1) + ' mm: se ve con una regla.', 't');
    el.innerHTML = s + '</svg>';
  }

  // D. El empujon, visto desde arriba: el triangulo de apoyo (pivote y rodillos) y donde cae el centro
  // de masa de cada telescopio en su muesca. El margen es la distancia a la linea pivote-rodillo.
  // P: los parametros de la plataforma (los del modelo); alt: otra separacion de rodillos, en trazos.
  function empujon(el, P, alt) {
    const base = P || { phi: 34.5, M: 40, Hdis: 0.54, Hreal: 0.63, dN: 0, dE: 0, runMin: 45, half: 0.29, postH: 0.10, baseW: 1.3, mTab: 11, zTab: -0.02, tabN: 0.53, railH: 0.02, shim: 0, plateT: 0.00794 };
    alt = alt || { half: 0.25 };   // por defecto: la v10.5 (58 cm) contra la v10.4 (50 cm), en trazos
    const casos = [['200 (63 cm)', 40, 0.63], ['12" liviano (52)', 40, 0.52], ['12" GoTo (62)', 50, 0.62]];
    // vista desde arriba con el NORTE A LA DERECHA (el triangulo es largo norte-sur: asi entra)
    const g0 = computeVNS({ ...base, dN: dNEquilibrio(base) });
    const yS = g0.rollers[0].Pt[1], k = 560, ox = 40, oy = 240;   // px por metro
    const X = (q) => ox + (q[1] - yS) * k, Y = (q) => oy - q[0] * k;
    let s = '<svg viewBox="0 0 760 520" role="img" aria-label="El triangulo de apoyo visto desde arriba y el centro de masa de cada telescopio">' + ST;
    const tri = (g, c, dash) => '<polygon points="' + [g.pivot, g.rollers[0].Pt, g.rollers[1].Pt].map((q) => X(q).toFixed(1) + ',' + Y(q).toFixed(1)).join(' ') + '" class="' + c + '"' + (dash ? ' stroke-dasharray="7 5"' : '') + '/>';
    const g58 = computeVNS({ ...base, half: alt.half, dN: dNEquilibrio({ ...base, half: alt.half }) });
    const cm = (h) => f(h * 200, 0) + ' cm';
    s += tri(g58, 'km', true) + tri(g0, 'fs');
    s += tx(X(g58.rollers[0].Pt) + 6, Y(g58.rollers[0].Pt) + (alt.half > base.half ? -8 : 20), 'rodillos a ' + cm(alt.half), 't');
    s += ci(X(g0.pivot), Y(g0.pivot), 6, 'fk') + tx(X(g0.pivot) - 40, Y(g0.pivot) - 14, 'pivote', 'tb');
    g0.rollers.forEach((r, i) => { s += ci(X(r.Pt), Y(r.Pt), 6, 'fk') + tx(X(r.Pt) + 12, Y(r.Pt) + (i ? 22 : -10), i ? 'rodillo oeste (' + cm(base.half) + ')' : 'rodillo este', 'tb'); });
    const liv = (h) => { const q = { ...base, half: h, M: 40, Hreal: 0.52 }; q.dN = dNEquilibrio(q); return computeVNS(q).empujeMesa; };
    const lastre = (() => { const q = { ...base, M: 45, Hreal: (40 * 0.52 + 5 * 0.05) / 45 }; q.dN = dNEquilibrio(q); return computeVNS(q).empujeMesa; })();
    casos.forEach(([n, M, H], i) => {
      const q = { ...base, M, Hreal: H }; q.dN = dNEquilibrio(q); const g = computeVNS(q);
      const cx = X(g.Cg), cy = Y(g.Cg);
      s += ci(cx, cy, 7, i === 1 ? 'fr' : 'fac') + li(cx, cy, cx, cy - 40 - i * 34, 'km') + tx(cx + 4, cy - 46 - i * 34, n + ': ' + f(g.empujeMesa, 1) + ' kg', i === 1 ? 'tr' : 'ta');
    });
    s += li(560, 500, 700, 500, 'k') + '<path d="M700,500 l-10,-5 l0,10 z" class="fk"/>' + tx(706, 505, 'N', 'tb');
    s += tx(20, 30, 'El empujón que levanta la mesa de un rodillo depende de cuán lejos queda el centro de masa', 'tb');
    s += tx(20, 50, 'de la línea pivote-rodillo. Más bajo el centro de masa, más al norte va el telescopio, y menos margen.', 't');
    s += tx(20, 450, 'Un lastre de 5 kg abajo casi no cambia nada (' + f(liv(base.half), 1) + ' → ' + f(lastre, 1) + ' kg): suma masa, pero corre la muesca al norte y achica el margen.', 't');
    s += tx(20, 470, 'La separación de los rodillos sí: con ' + cm(alt.half) + ' el 12" liviano da ' + f(liv(alt.half), 1) + ' kg (trazos). Desde arriba, a escala, norte a la derecha.', 't');
    s += tx(20, 490, 'Pide 6 kg o más, como el dobson solo (L1-13).', 't');
    el.innerHTML = s + '</svg>';
  }

  global.DIBUJOS = { trans, estrella, palanca, empujon };
})(typeof window !== 'undefined' ? window : globalThis);
