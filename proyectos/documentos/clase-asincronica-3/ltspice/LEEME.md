# Las simulaciones de la Actividad Asincrónica 3

**Todo lo que hay que saber para usar un archivo está adentro del archivo.**
Cada `.asc` se abre con doble clic y trae, escrito en la hoja como comentarios
de LTspice: el enunciado, cómo está armado el circuito, qué hace cada
directiva línea por línea, cómo se arma la gráfica paso a paso, y los números
calculados a mano **antes** de simular.

Este índice sólo dice qué archivo es cuál.

---

## Cómo se corre

Doble clic en el `.asc` → **Run** (o `Simulate > Run`). Los resultados de los
`.meas` no se dibujan: salen en el log, que se abre con **Ctrl+L**
(`View > SPICE Error Log`).

Para correr los diecisiete de una y comparar todo contra el cálculo:

```bash
python verificar.py
```

Instalado y medido con **LTspice 26.0.1 for Windows**
(`%LOCALAPPDATA%\Programs\ADI\LTspice\LTspice.exe`).

---

## Los archivos

### Bloque 1 — bobinas y capacitores

| Archivo | Problema | Qué contesta |
|---|---|---|
| `P6-01_bobina_pulso_triangular.asc` | 6.1 | `i`, `v`, `p` y `w` de una bobina de 20 mH con un pulso triangular de corriente (fuente `PWL`) |
| `P6-02_bobina_tension_a_corriente.asc` | 6.2 | la corriente que resulta de integrar una tensión por tramos, en 200 µH |
| `P6-17_capacitor_pulso_corriente.asc` | 6.17 | carga, tensión y energía de un capacitor de 0,25 µF con un pulso de corriente |
| `P6-25_capacidad_equivalente.asc` | 6.25 | `Ceq` entre a y b, **medida** con `.ac` por la corriente de entrada, contra el capacitor equivalente |

### Bloque 2 — RL de primer orden

| Archivo | Problema | Qué contesta |
|---|---|---|
| `P7-01_conmutacion_continuidad_iL.asc` | 7.1 | por qué `i₁` es continua y `i₂` salta. **Con el conmutador dibujado**, para ver el antes y el después |
| `P7-01b_estado_previo_con_op.asc` | 7.1 (a) | el mismo estado previo con `.op`, sin simular tiempo |
| `P7-04_RL_reconstruir_parametros.asc` | 7.4 | reconstruir `R`, `τ`, `L`, `w(0)` y el instante del 80 % de energía disipada |
| `P7-08_RL_descarga_balance_energia.asc` | 7.8 | descarga sobre 8 Ω con **dos bobinas**: energía disipada, energía atrapada, y el 95 % |
| `P7-08b_estado_previo_con_op.asc` | 7.8 | `iL(0⁻) = 10 A` con `.op` |

### Bloque 3 — RC de primer orden

| Archivo | Problema | Qué contesta |
|---|---|---|
| `P7-21_RC_energia_atrapada.asc` | 7.21 | el 80 % de la energía se va en calor aunque los dos capacitores sean ideales |
| `P7-23_RC_identificar_R_C_tau.asc` | 7.23 | identificar `R`, `C` y `τ` desde la respuesta, y el control `v/i = R` constante |
| `P7-25_RC_energia_disipada.asc` | 7.25 | dos conmutadores que operan juntos; energía a los 12 ms y tiempo del 75 % |

### Bloque 4 — RLC de segundo orden

| Archivo | Problema | Qué contesta |
|---|---|---|
| `P8-01_RLC_paralelo_clasificacion.asc` | 8.1 | las tres `R` superpuestas con `.step`: sobre, crítico y subamortiguado |
| `P8-38_RLC_serie_critico.asc` | 8.38 | `R` crítica, `i(0⁺)`, `di/dt(0⁺)` y `vC(t)`, con ±20 % |

### Segunda pasada — no idealidades

| Archivo | Sobre | Parásito y valor supuesto |
|---|---|---|
| `X1_no_ideal_RL_con_DCR.asc` | 7.4 | DCR del bobinado = **25 Ω** (supuesto, no hoja de datos) |
| `X2_no_ideal_RC_con_fuga.asc` | 7.23 | ESR = 0,5 Ω; fuga = 1 G / **10 M** (nuevo) / **100 k** (envejecido) |
| `X3_no_ideal_RLC_con_DCR_ESR.asc` | 8.38 | DCR = 6 Ω y ESR = 0,2 Ω (supuestos) |

### `catedra/`

Los seis `.asc` **originales del profesor**, sin tocar, tal como vinieron en
`SPICE.zip`. No son los problemas de la guía: son ejemplos de RC, RL y RLC que
acompañan a las filminas. Se guardan como referencia y para poder contrastar
el criterio de paso de integración.

---

## Los números medidos

Cada valor de esta tabla salió del `.log` de la corrida, y `verificar.py` lo
compara contra el cálculo analítico que está escrito en el `.asc`. Los 97
controles pasan dentro del 2 %.

| Archivo | Medición | Calculado | Medido |
|---|---|---|---|
| 6.1 | `iL_pico` / `vL_sube` / `vL_baja` | 250 mA / +1 V / −1 V | 250 mA / 1,00000 V / −1,00000 V |
| 6.1 | `w_max` | 625 µJ | 625,000 µJ |
| 6.2 | `iL(2 ms)` / pendiente | 50 mA / 25 A/s | 50,0000 mA / 24,9999 A/s |
| 6.17 | `v(5 µs)` / `v(20 µs)` / `v(30 µs)` / `v(50 µs)` | 4 / 28 / 18 / 10 V | 4,000 / 28,000 / 18,000 / 10,000 V |
| 6.17 | `q(30 µs)` / `w(50 µs)` | 4,5 µC / 12,5 µJ | 4,5000 µC / 12,500 µJ |
| 6.25 | `Ceq` medida por `.ac` | 6 µF | 6,0000 µF (`|Iin|` = 37,6991 mA) |
| 7.1 | `i₁(0⁻)` / `i₂(0⁻)` | 5 mA / 15 mA | 5,0000 mA / 15,0000 mA |
| 7.1 | `i₁(0⁺)` / `i₂(0⁺)` / `vL(0⁺)` | 5 mA / −5 mA / −40 V | 4,9991 mA / −4,9990 mA / −39,992 V |
| 7.1 | `τ` | 50 µs | 50,0008 µs |
| 7.1b | `.op`: V(A) / I(R2) / I(R3) | 30 V / 15 mA / 5 mA | 30,000 V / 15,000 mA / 5,000 mA |
| 7.4 | `R` / `τ` / `L` / `w(0)` | 40 Ω / 200 ms / 8 H / 400 J | 40,00 Ω / 199,995 ms / 7,9998 H / 400,00 J |
| 7.4 | `t` al 80 % de energía | 160,94 ms | 160,93 ms |
| 7.8 | `io(0⁺)` / `v(0⁺)` / `τ` | −10 A / −80 V / 200 µs | −10,000 A / −80,000 V / 200,000 µs |
| 7.8 | energía disipada / `t` al 95 % | 80 mJ / 299,6 µs (1,50 τ) | 80,04 mJ / 298,6 µs (1,493 τ) |
| 7.8 | `i₈(∞)` / `i₂(∞)` (atrapadas) | +8 A / −8 A | +8,0011 A / −7,9956 A |
| 7.8b | `.op`: V(n1) / I(L1) | 300 V / 10 A | 300,00 V / 10,000 A |
| 7.21 | `i(0⁺)` / `τ` / `v₁(∞)` = `v₂(∞)` | 1,6 mA / 20 ms / 8 V | 1,6000 mA / 20,000 ms / 7,9996 V |
| 7.21 | `w(0)` / atrapada / disipada | 800 / 160 / 640 µJ | 800,0 / 159,98 / 640,3 µJ |
| 7.23 | `R` / `τ` / `C` | 4 kΩ / 40 ms / 10 µF | 4000,0 Ω / 39,993 ms / 9,998 µF |
| 7.23 | `w(0)` / disipada a 60 ms | 11,52 / 10,946 mJ | 11,520 / 10,946 mJ |
| 7.23 | `v/i` a 100 ms (control) | 4 kΩ constante | 4000,0 Ω |
| 7.25 | `vC(0⁻)` / `w(0)` | 102 V / 17,34 mJ | 102,000 V / 17,340 mJ |
| 7.25 | disipada a 12 ms / `t` al 75 % | 7,824 mJ (45,1 %) / 27,73 ms | 7,8236 mJ (45,12 %) / 27,726 ms |
| 8.1 | `α` con R = 1000 / 1250 / 1562,5 | 250 / 200 / 160 rad/s | 250 / 200 / 160 rad/s |
| 8.1 | `T_d` (subamortiguada) | 52,36 ms | 52,360 ms |
| 8.38 | `R` crítica | 800 Ω | 800,0 Ω |
| 8.38 | `i(0⁺)` / `di/dt` a 2 µs | 30 mA / −50,49 A/s | 29,96 mA / −50,49 A/s |
| 8.38 | `vC(150 µs)` / `vC(1 ms)` | 12,28 / 0,4043 V | 12,282 / 0,4043 V |
| X1 | `τ` ideal / con DCR 25 Ω | 200 / 123,08 ms | 200,000 / 123,077 ms (−38,46 %) |
| X2 | `τ` con fuga 1 G / 10 M / 100 k | 40,000 / 39,984 / 38,462 ms | 39,993 / 39,977 / 38,455 ms |
| X3 | `R_total` / `α` ideal vs real | 800 → 806,2 Ω; 5000 → 5038,75 | idem, medido |
| X3 | `R` crítica corregida | 793,8 Ω | 793,8 Ω |

---

## Las cuatro trampas de LTspice que costaron una corrida cada una

Están explicadas en detalle adentro de los `.asc` correspondientes. El
resumen, para no volver a pisarlas:

1. **Toda bobina trae `Rser = 1 mΩ` por defecto y LTspice no lo avisa.** No
   aparece en el netlist. En un circuito donde la bobina queda en corto —contra
   una fuente apagada o contra otra bobina— ese miliohm es la única resistencia
   del lazo y se vuelve la que manda. Medido: el 6.2 daba 49,75 mA en vez de
   50 mA y seguía cayendo. **Pero `Rser=0` exacto tampoco sirve**: hace singular
   la matriz justo en esos casos (`over-defined circuit matrix`). La salida es un
   valor chico *declarado* — acá `Rser=1u`.

2. **Un nodo integrador (`B` + `C` de 1 F) necesita `.ic V(nodo)=0`.** Sin eso,
   el punto de reposo resuelve esa rama con la potencia inicial entrando a un
   resistor de 1 TΩ y el nodo arranca en 10¹⁴ V. El `.meas` no falla: devuelve un
   número enorme, del tipo que se confunde con un error de unidades. Medido: daba
   4·10¹⁴ J donde tenía que dar 80 mJ.

3. **`.meas` sobre un `.ac` imprime en decibeles.** `ceq_medida` salía como
   `−104,437 dB` en vez de `6 µF`. Se arregla con
   `.options meascplxfmt=polar`.

4. **`DERIV ... AT 0` devuelve 0**, y la diferencia finita a mano tampoco sirve:
   el `.ic` de una bobina tiene ~0,1 % de tolerancia, y ese error es del mismo
   tamaño que el cambio real de corriente en 2 µs. `(i(2µs)−i(0))/2µs` daba
   −30 A/s en vez de −50 A/s. Se mide con `DERIV` en un instante distinto de cero.

Y una del propio dibujo, no de LTspice: **el símbolo `sw` en `R0` tiene los dos
pines de mando en la misma columna**, así que un stub vertical desde cada uno los
cortocircuita y el interruptor no conmuta nunca. Pasó con el S2 del 7.25, y el
único síntoma fue `Node nc_01 is floating` más un circuito que no cargaba. Los
interruptores van horizontales (`R270`).

---

## Una corrección al cálculo, no al modelo

En el 8.1 la predicción escrita decía que las respuestas sobreamortiguada y
crítica **no cruzan el cero**. Los tres `t_cruce1` medidos —4,62 / 5,00 / 5,36 ms—
dijeron lo contrario, y la cuenta a mano confirmó que la equivocada era la
predicción:

    v(t) = −(1/3)·e^(−100t) + (4/3)·e^(−400t)     cruza en ln(4)/300 = 4,621 ms

Con `vC(0) = 1 V` e `iL(0) = 0` los dos coeficientes tienen signos distintos y hay
**un** cruce. Lo que distingue a la subamortiguada no es que cruce: es que cruza
infinitas veces. La corrección está escrita adentro de
`P8-01_RLC_paralelo_clasificacion.asc`, con la deducción completa.
