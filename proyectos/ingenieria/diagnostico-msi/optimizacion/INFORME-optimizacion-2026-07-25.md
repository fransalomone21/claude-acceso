# Informe de optimización — MSI Sword 15 A12VF
**Fecha:** 25/07/2026 · **Equipo:** MS-1585 · i7-12650H · RTX 4060 Laptop · 24 GB DDR5 · BIOS E1585IMS.30D

---

## 1. Diagnóstico: de dónde venían los 95 °C

Dos causas, ambas identificadas y corregidas:

**Causa raíz — ThrottleStop nunca arrancaba.** La tarea programada `throttle` estaba
configurada con `RunLevel: Limited`. ThrottleStop necesita privilegios elevados para
escribir los registros MSR del procesador. Sin ellos, la tarea fallaba en silencio en
cada arranque y los límites de fábrica de MSI (PL2 ≈ 95 W+) quedaban vigentes. Los
límites de 40/42 W solo se aplicaban cuando se abría el programa a mano.

**Causa agravante — Estado mínimo del procesador al 100 %.** El plan de energía forzaba
al CPU a no bajar nunca de la frecuencia máxima. Medido: **4025 MHz con 9 % de carga**.
El procesador vivía en turbo permanente, sin margen térmico para absorber picos.

---

## 2. Cambios aplicados

### Plan de energía de Windows (verificado en registro)

| GUID | Ajuste | Antes | Después |
|---|---|---|---|
| `893dee8e` | Estado mínimo procesador | AC 100 % | **AC 5 % / DC 5 %** |
| `bc5038f7` | Estado máximo procesador | AC 95 % / DC 90 % | **AC 100 % / DC 70 %** |
| `be337238` | Modo de mejora de rendimiento | Agresiva (2) | **Eficiencia agresiva (4)** |
| `94d3a615` | Directiva de refrigeración | pasiva | **activa en AC** |
| `36687f9e` | EPP | (no fijado) | **AC 50 / DC 75** |

### ThrottleStop

- Tarea programada `throttle` → **RunLevel: Highest**. Arranca solo y con privilegios.
- `PowerLimitEAX0` → `0x001C8168` (PL1 45 W, tau 16 s)
- `PowerLimitEDX0` → `0x004281C0` (PL2 56 W)
- `OneAD_EAX0` → `0x2C2C2F2F` (P-cores 47/47/44/44 — de fábrica, estaba capado a 40x)
- `OneAD_EDX0` → `0x29292929` (P-cores 41/41/41/41)
- `Six50_EAX0/EDX0` → `0x23232323` (E-cores 35 — de fábrica)
- C1E activado y guardado (`Options1`: `0x61DF20A0` → `0x61DF29A0`)

### Otros

- GameDVR desactivado (`GameDVR_Enabled = 0`)
- Arranque: quitados `utweb`, `RobloxPlayerBeta`, `MicrosoftEdgeAutoLaunch`,
  `EpicGamesLauncher`, `EADM`. Se mantuvieron OneDrive, Steam y ZeroTierUI.

---

## 3. Resultados medidos

Metodología: telemetría 1 Hz leída de la memoria compartida de MSI Afterburner
(`MAHMSharedMemory`), carga sintética en 16 hilos (FP escalar + sqrt), mismo script
en todas las corridas.

| Métrica | Antes | Después |
|---|---|---|
| Reposo — potencia | 28.4 W | **~7-11 W** |
| Reposo — temperatura | 69-74 °C | **46.4 °C** |
| Frecuencia en reposo (9 % carga) | 4025 MHz | **~2300 MHz** |
| Carga sostenida | — | 39 W · **76.6-80.4 °C** |
| Pico bajo carga | 95 °C (reportado) | **84 °C** |
| Turbo 1-2 hilos | 4.0 GHz | 4.0 GHz — **sin cambio, ver nota** |

> **CORRECCIÓN (medida, no inferida).** Se afirmó que restaurar los ratios de turbo en
> el `.ini` devolvía el turbo de 1-2 hilos a 4.7 GHz. **Es falso.** Medido con el
> contador `PercentProcessorPerformance` de Windows (vía independiente del sensor de
> Afterburner):
>
> ```
> 1 hilo    max 4.025 MHz      (esperado si aplicara: 4.700 MHz)
> 16 hilos  max 4.048 MHz · promedio 3.027 MHz
> ```
>
> Los valores `OneAD_EAX0 = 0x2C2C2F2F` sí están escritos en el `.ini` y ThrottleStop
> los muestra, pero **el procesador descarta la escritura al MSR 0x1AD**, igual que
> ocurría con los límites de potencia. 4.025 MHz es el mismo número medido al inicio de
> la sesión, antes de cualquier cambio.
>
> Nota adicional: el sensor `CPUn clock` de Afterburner **no** reporta el máximo por
> núcleo — daba 2.987 MHz cuando el contador de Windows medía 4.048 MHz en el mismo
> instante. No usarlo para conclusiones sobre frecuencia pico.

**Estabilidad — 8 minutos de carga sostenida:**
- Deriva térmica: **−2.2 °C** (la temperatura baja con el tiempo)
- Muestras sobre 90 °C: **0 de 422**
- Muestras sobre 85 °C: **0 de 422**
- Desbalance máximo entre núcleos: 14 °C (normal en arquitectura híbrida P/E)

Pendiente térmica del chasis medida: **≈ 0.82 °C por watt**.

---

## 4. El límite de 40 W: investigación

Se probaron tres palancas para superar los ~39.5 W sostenidos. Ninguna funcionó:

| Prueba | Variable | Resultado sostenido | Frecuencia |
|---|---|---|---|
| 1 | PL 40/42 · MSI Balanced | 39.80 W · 80.0 °C | 2987 MHz |
| 2 | PL 45/56 · MSI Balanced | 39.65 W · 80.0 °C | 2987 MHz |
| 3 | PL 45/56 · MSI **Extreme** | 40.01 W · 79.9 °C | 2987 MHz |
| 4 | Barrido EPP 127 → 0 | 39.35-39.72 W | 2987 MHz |

Frecuencia idéntica en las cuatro. **Causa:** Intel Innovation Platform Framework
(`ipfsvc`) reescribe el límite de potencia por MMIO más rápido de lo que ThrottleStop
puede fijarlo, y **gana el valor más bajo**. Los ratios de turbo sí se aplicaron porque
IPF no toca ese registro.

**Solución identificada:** la casilla **`MMIO Lock`** en la ventana TPL de ThrottleStop.
Fija los valores de MSR y MMIO aunque el controlador embebido intente reescribirlos.
Es la opción quirúrgica: IPF conserva el resto de sus funciones (coordinación térmica,
sensor de superficie, tablas de ventilador) y solo pierde el control del watt.

> **Advertencia:** el bit de bloqueo persiste hasta reiniciar. Verificar que TPL muestre
> PL1=45 / PL2=56 **antes** de marcar la casilla.

### RESUELTO — el "techo de 40 W" era un artefacto del banco de pruebas

> **CORRECCIÓN FINAL (25/07/2026, medido con Minecraft + shaders Photon).**
> Todo el análisis de esta sección concluía que los 45 W no se aplicaban. **Es falso.**
> Bajo carga de juego real el CPU marca **45,0 W de promedio y 45,6 W de pico**: clavado
> en PL1 = 45 W. El límite funciona.
>
> El error estaba en la carga sintética usada en las ocho corridas: FP escalar + `sqrt`
> en 16 hilos tira solo ~39,5 W porque **nunca llega a pedir 45 W**. No topaba contra un
> límite de la plataforma, topaba contra lo poco exigente que era el propio test.
> Minecraft, con mezcla de instrucciones real y fallos de caché, saca 45 W a **menor**
> frecuencia media (2.831 MHz frente a los 2.987 MHz del sintético): más vatios por MHz.
>
> **Lección:** una carga sintética que no satura el límite de potencia no puede
> usarse para concluir nada sobre ese límite. Validar siempre con carga real antes de
> declarar una limitación de hardware.

### Historial de la investigación (ocho corridas sintéticas, conclusión errónea)

Se probaron **cinco palancas** a lo largo de **ocho corridas** con el mismo script:

| # | Contexto | Sostenido | Frecuencia |
|---|---|---|---|
| 1 | PL 40/42 · MSI Balanced | 39.80 W | 2.987 MHz |
| 2 | PL 45/56 · MSI Balanced | 39.65 W | 2.987 MHz |
| 3 | PL 45/56 · MSI Extreme | 40.01 W | 2.987 MHz |
| 4 | Barrido EPP 127 → 0 | 39.35-39.72 W | 2.987 MHz |
| 5 | Estabilidad 8 min | 39.0-39.5 W | 2.987 MHz |
| **6** | **Post-reinicio + MMIO Lock** | **43.14 W** | **3.057 MHz** |
| 7 | Post-mudanza a C:\ThrottleStop | 39.28 W | 2.989 MHz |
| 8 | Post-reinicio + HVCI desactivado | 39.54 W | 2.987 MHz |

> **ADVERTENCIA SOBRE LA CORRIDA 6.** Una versión anterior de este informe la presentaba
> como éxito ("+8,4 % de potencia, +70 MHz"). **Era un dato aislado y no se replicó.**
> La corrida 6 se ejecutó 2 minutos después de un arranque, con Windows todavía en su
> trabajo de inicio (OneDrive, Steam, servicios MSI, indexado); esa actividad de fondo
> sumó vatios al paquete e infló el promedio. La corrida 8 —también post-arranque, con
> el MMIO bloqueado en 45/56 y HVCI apagado— da 39.54 W y la refuta.

**Estado real:** ThrottleStop muestra `MSR 45 / 56 / 16` y el MMIO queda bloqueado, pero
el consumo sostenido no supera los ~40 W. Algo por debajo de lo que alcanza el software
—EC, firmware o el bit de bloqueo del BIOS sobre el MSR 0x610— impone ese techo.

Ni `MMIO Lock`, ni el escenario Extreme de MSI Center, ni el EPP, ni desactivar Memory
Integrity lo movieron. Queda como limitación de la plataforma.

---

## 5. Pendiente (requiere interfaz gráfica)

1. **ThrottleStop → TPL → marcar `MMIO Lock`** → Save. Desbloquea los 45 W.
   Esperado: ~84-86 °C sostenidos, dentro del objetivo.
2. ~~**Afterburner → undervolt de la RTX 4060.**~~ **HECHO.** Curva aplanada en
   **2401 MHz desde 925 mV** hasta el final. Guardada en `[Profile1]` y `[Startup]`
   (6448 bytes, `CoreClkBoost = -224000`). La tarea programada lanza
   `MSIAfterburner.exe /s`, que aplica `[Startup]` en cada arranque.

   > El `-224000` es correcto y **no** es un underclock: la curva stock llegaba a
   > ~2625 MHz en el tope y se aplanó a 2401, o sea −224 MHz **en el punto más alto**.
   > En el tramo medio la curva quedó ~+91 MHz **por encima** del stock. Ese es
   > justamente el mecanismo del undervolt: al no existir frecuencia disponible por
   > encima de 2401 MHz, la GPU no tiene motivo para pedir más de 925 mV.

   **Falta validarlo:** 30 min de un juego exigente. Si hay cuelgue de driver, pantalla
   negra o artefactos, bajar el punto plano a ~2350 MHz o moverlo a 950 mV.

3. **No cargar el perfil 2 de Afterburner.** Tiene `CoreClkBoost = -502296` (−502 MHz)
   y `MemClkBoost = 500000`. Ese sí es un underclock puro del núcleo.
   *(Corrección: en una lectura previa se atribuyó por error a `[PreSuspendedMode]`;
   está en `[Profile2]`, así que no se aplica solo al volver de suspensión.)*
4. **Desactivar el overclock de GPU de MSI Center** (`IsSupOC=1`, `OCrun=1`) para que
   no compita con Afterburner por el control de los relojes.
5. **Autodesk Access** en el arranque (`HKLM`, requiere elevación).

---

## 6. Notas y riesgos

- **ThrottleStop vive dentro de OneDrive** (`OneDrive\Desktop\Programas\`). Si se activa
  "Archivos a petición", el `.exe` puede deshidratarse y la tarea programada fallaría en
  el arranque — el mismo problema que se acaba de corregir. Conviene moverlo a
  `C:\ThrottleStop` y actualizar la ruta de la tarea.
- **Memory Integrity (HVCI) está activo.** Cuesta 5-15 % de CPU en juegos y compilación.
  No se modificó: es una función de seguridad y la decisión es del usuario.
- **MUX en modo discreto**, confirmado. La 4060 maneja el panel directamente. Es óptimo
  para juegos; penaliza la autonomía.
- **RAM despareja**: 8 GB @4800 + 16 GB @5600, ambos corriendo a 4800. Reemplazar el
  módulo de 8 GB por uno de 16 GB @5600 daría 32 GB parejos.
- El undervolt de CPU no está disponible: el BIOS bloquea el buzón de overclocking
  (visible por el candado en PROCHOT Offset).
- La carga sintética usada es FP escalar sin AVX2. Cinebench o Prime95 darán 2-3 °C más.

---

## 7. Validación final bajo carga real (GPU y simultánea)

Se generó carga de GPU con un shader WebGL servido desde un HTTP local e inyectado en
el navegador (el `<script>` de la página no se ejecuta en el panel, hubo que inyectarlo).
Resultado: 100 % de uso, estado P0, carga sostenida.

### Undervolt de GPU — A/B con la misma carga corriendo

| | Reloj | Potencia | Temp |
|---|---|---|---|
| Stock (curva sin aplicar) | 2.505 MHz | 66.0 W | 66 °C |
| Perfil 1 (undervolt) | **2.400 MHz** | **55.6 W** | 66 °C |
| | −105 MHz (−4,2 %) | **−10,4 W (−15,8 %)** | |

> Esta carga **no llega al límite de potencia** (55-66 W contra 105 W de TGP). Cuando la
> GPU no está limitada por vatios, el undervolt solo impone un techo de frecuencia más
> bajo sin ganancia compensatoria. En un juego que sí toque los 105 W, el undervolt
> permite sostener frecuencias **más altas** porque gasta menos por MHz. Este número
> subestima el beneficio real en juegos y sobreestima el costo.

### CPU + GPU simultáneos (escenario real de gaming)

```
FASE          CPU_W  CPU_C  NUCLEO  CPU_MHz | GPU_W  GPU_C  GPU_MHz
solo GPU       12.5   69.9    75.0    2.412 |   55.6   66.1    2.400
AMBOS          38.8   87.2    88.0    3.030 |   56.1   66.7    2.400
solo GPU       12.5   67.9    73.0    2.429 |   55.2   63.9    2.400

Potencia combinada: 94.9 W
Pico CPU: 89 C paquete / 91 C nucleo    Pico GPU: 69 C
Muestras CPU sobre 90 C: 0 de 37
Caida de reloj GPU por compartir disipador: 0 MHz
```

- CPU a **87,2 °C sostenido** con la GPU también al 100 %. Es el peor caso realista.
- La GPU **no perdió un solo MHz** al sumarse la carga del CPU: sin throttling cruzado.
- El CPU tampoco cedió: mantuvo 38,8 W y 3.030 MHz.
- **95 W combinados** disipados de forma estable.

### Persistencia del undervolt — problema encontrado y resuelto

Bajo carga se detectó que la GPU corría a **2.505 MHz**, o sea con la curva **sin
aplicar**, pese a que Afterburner arrancaba por tarea programada con `/s`.

Causa: la sección `[Startup]` del perfil de GPU contiene una curva **distinta** a la de
`[Profile1]` — una versión capturada antes del aplanado. Afterburner sí aplicaba algo al
inicio, pero era la curva vieja.

Solución aplicada: tarea programada **`AB-undervolt-perfil1`**, al inicio de sesión con
45 s de retardo, que ejecuta `MSIAfterburner.exe -profile1`. No depende de la interfaz
ni de `RememberSettings`.

> Comprobación: reiniciar, esperar 1 minuto y poner carga de GPU. El reloj debe quedarse
> en **2.400 MHz**. Si marca 2.505 MHz, la tarea no corrió.

---

## 8. Archivos

| Archivo | Función |
|---|---|
| `REVERTIR-optimizacion-2026-07-25.ps1` | Restaura el plan de energía y GameDVR |
| `RESTAURAR-arranque-2026-07-25.ps1` | Devuelve las 5 entradas de arranque quitadas |
| `aplicar-optimizacion-TS.ps1` | Script que aplicó la config de ThrottleStop (requiere admin) |
| `mover-throttlestop-y-limpiar.ps1` | Mudanza a `C:\ThrottleStop` + limpieza HKLM (requiere admin) |
| `REVERTIR-mudanza-2026-07-25.ps1` | Deshace la mudanza y devuelve Autodesk al arranque |
| `tarea-undervolt-gpu.ps1` | Crea la tarea que aplica el perfil 1 de Afterburner al iniciar sesión |
| `REVERTIR-tarea-undervolt.ps1` | Elimina esa tarea |
| `C:\ThrottleStop\ThrottleStop.ini.backup-2026-07-25` | Respaldo del `.ini` original |

## 9. Tareas programadas que sostienen la configuración

| Tarea | Cuándo | Qué hace |
|---|---|---|
| `throttle` | Al iniciar sesión | `C:\ThrottleStop\ThrottleStop.exe` con privilegios máximos |
| `MSIAfterburner` | Al iniciar sesión | `MSIAfterburner.exe /s` |
| `AB-undervolt-perfil1` | Al iniciar sesión, +45 s | `MSIAfterburner.exe -profile1` (aplica el undervolt) |

Las tres con `RunLevel: Highest`. Si alguna deja de funcionar, la configuración vuelve a
los valores de fábrica sin aviso — vale la pena revisarlas si algún día notás el equipo
más caliente o más lento.
