# Diagnóstico MSI Sword 15 — batería, Secure Boot, arranque

**Fecha de captura:** 2026-08-21, entre 15:43 y 16:08 (hora local)
**Máquina:** la del usuario, medida en vivo — no reconstruida de memoria ni de documentos.

Este documento **separa a propósito lo medido de lo inferido**. Cada afirmación
lleva su grado. Los datos crudos que la respaldan están en `datos-crudos/`,
sin editar.

| Grado | Qué significa |
|---|---|
| **CONFIRMADO** | Salió de un comando que corrí en esta máquina. El archivo crudo está en `datos-crudos/`. |
| **PROBABLE** | Inferencia con apoyo, pero con al menos una explicación alternativa viva que no maté. |
| **HIPÓTESIS** | Idea plausible sin evidencia propia. No actuar sobre esto sin medir antes. |
| **DESCARTADO** | Lo revisé y no es. Anotado para que nadie lo vuelva a perseguir. |

---

## 0. Advertencia operativa antes que nada

**No hacer reset de EC en esta notebook sin considerar esto primero.**

Según `informe-previo-gpt-2026.txt` (sección 3), la secuencia previa fue:
batería trabada en ~13 % → desenchufar → mantener el botón de encendido ~1 min
→ ciclo de encendido/apagado → otra pulsación del botón → **apareció
`Secure Boot Violation`**.

- Que la relación temporal existe: **CONFIRMADO** por ese informe.
- Que el reset de EC *causó* la falla de Secure Boot: **HIPÓTESIS**. No está
  demostrado y el informe previo también lo marca como no demostrado.

Aun así, alcanza para no repetir el procedimiento a ciegas. En una sesión
anterior de hoy yo mismo lo recomendé sin conocer este antecedente; queda
retirado.

---

## 1. Identidad del equipo — CONFIRMADO

Fuente: `datos-crudos/01-bios-y-modelo.txt`, `02-sistema-operativo.txt`

| Campo | Valor medido |
|---|---|
| Modelo (marketing) | MSI Sword 15 A12VF |
| Baseboard Product | **MS-1585** |
| SystemSKUNumber | 1585.3 |
| Serie | K2308N0016693 |
| BIOS (SMBIOSBIOSVersion) | **E1585IMS.30D** |
| Fecha BIOS | 2023-06-26 |
| Fabricante BIOS | American Megatrends International, LLC. |
| SO | Windows 11 Pro, build 26200 |

### Corrección al informe previo

El informe de GPT dice en dos lugares que la BIOS es **`E18IMS.30D`**, y lo
declara como "la identificación crítica para cualquier procedimiento de BIOS".

**Está mal. Es `E1585IMS.30D`.** Medido por `Win32_BIOS.SMBIOSBIOSVersion`.

Esto importa mucho: buscar el archivo equivocado en el sitio de MSI y flashearlo
es la clase de error que deja la máquina inservible. El resto de la
identificación del informe (MS-1585) sí es correcta.

---

## 2. Secure Boot — estado actual

### 2.1 Está DESACTIVADO — CONFIRMADO

Fuente: `datos-crudos/04-secureboot-estado.txt`

```
HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State
    UEFISecureBootEnabled = 0        [0 = desactivado]
```

**Esa es la "opción de seguridad" que desactivaste y no recordabas.** La máquina
arranca porque Secure Boot está apagado. El problema del `Secure Boot Violation`
**no está resuelto: está esquivado.** Si lo volvés a activar, hay que asumir que
vuelve el error, porque nada de lo que se hizo después atacó la causa.

### 2.2 Los archivos de arranque están bien firmados — CONFIRMADO

Fuente: `datos-crudos/06-boot-manager-firma.txt`

Los tres componentes verifican firma correctamente en Windows:

| Archivo | Versión | Status |
|---|---|---|
| `C:\Windows\Boot\EFI\bootmgfw.efi` | 10.0.28000.342 | **Valid** |
| `C:\Windows\Boot\EFI\bootmgr.efi` | 10.0.28000.342 | **Valid** |
| `C:\Windows\System32\winload.efi` | 10.0.26100.8875 | **Valid** |

Cadena completa, idéntica en los tres:

```
CN=Microsoft Windows                              [hasta 2026-10-17]
CN=Microsoft Windows Production PCA 2011          [hasta 2026-10-19]
CN=Microsoft Root Certificate Authority 2010      [hasta 2035-06-23]
```

**Ojo con la conclusión fácil.** Estos son los archivos **fuente** en `C:\Windows`,
no necesariamente los que están en la partición EFI y que el firmware realmente
ejecuta. Comparar ambos requiere admin y **todavía no se hizo** (ver §6).

### 2.3 Transición de certificados 2011 → 2023 — CONFIRMADO (los valores)

Fuente: `datos-crudos/04-secureboot-estado.txt`

```
HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing
    WindowsUEFICA2023Capable     = 0
    UEFICA2023Status             = InProgress
    RebootRequestedDB            = 1
    RebootRequested3POROMDB      = 1
    RebootRequested3PUEFICADB    = 1
    ConfidenceLevel              = High Confidence
    UEFICA2023Error              = 0
HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot
    AvailableUpdates             = 0
```

Los valores son un hecho. **Lo que significan, no.** Concretamente:

- Que Windows tiene actualizaciones de la base de certificados marcadas como
  pendientes de reinicio: **CONFIRMADO** (los `RebootRequested*` = 1).
- Que **estar Secure Boot apagado sea lo que impide aplicarlas**:
  **HIPÓTESIS**. Suena razonable y es un mecanismo conocido, pero no lo verifiqué
  en esta máquina. No lo di por cierto.
- Que el vencimiento de los certificados 2011 (octubre 2026) sea la causa del
  `Invalid signature detected`: **HIPÓTESIS, y de las flojas.** El firmware UEFI
  normalmente **no chequea fechas de vencimiento** al validar firmas de arranque,
  porque en ese momento no tiene reloj confiable. Lo anoto para que nadie pierda
  tiempo persiguiéndolo como si fuera la explicación.

Lo que sí es un hecho con fecha: **la PCA 2011 que firma el boot manager de esta
máquina vence el 2026-10-19**, o sea en menos de dos meses, y el firmware está
marcado `WindowsUEFICA2023Capable = 0`. Eso es un problema que viene, con o sin
el problema actual.

### 2.4 Lo que ya se probó y NO sirvió — CONFIRMADO por el informe previo

No repetir como primera medida:

- `Install All Factory Default Keys`
- Alternar Secure Boot Mode entre Custom y Standard
- Cambiar Boot Option #1

---

## 3. Batería

### 3.1 Se descargó hasta morir, de verdad — CONFIRMADO

Fuente: `datos-crudos/12-eventos-energia.txt`, `batteryreport.html`

- **10:26:55** — evento 524 de Kernel-Power: *"Critical desencadenador de batería
  cumplido"*. Hibernó.
- **14:43:57** — eventos de Kernel-Boot + *"Cambio de fuente de energía"*.
  Se enchufó y arrancó.

El `batteryreport` muestra el drenaje: entre 02:10 y 14:44 estuvo en
**Connected standby, a batería**, consumiendo entre ~320 mW y ~880 mW hasta
vaciarse. No fue una lectura falsa: se vació.

### 3.2 No está cargando — CONFIRMADO

Serie completa, muestreada cada 30 s (`Rem` = capacidad restante, `Rate` = tasa
de carga):

```
15:43:00   9698 mV   Rem=0   Rate=0
15:46:50   9701 mV   Rem=0   Rate=0
15:47:20   9703 mV   Rem=0   Rate=0
15:47:51   9703 mV   Rem=0   Rate=0
15:48:21   9704 mV   Rem=0   Rate=0
15:48:51   9704 mV   Rem=0   Rate=0
15:49:21   9706 mV   Rem=0   Rate=0
15:49:52   9706 mV   Rem=0   Rate=0
15:50:22   9708 mV   Rem=0   Rate=0
15:50:52   9706 mV   Rem=0   Rate=0    <- reversión
15:51:23   9708 mV   Rem=0   Rate=0
15:51:53   9708 mV   Rem=0   Rate=0
15:52:23   9711 mV   Rem=0   Rate=0
15:52:53   9710 mV   Rem=0   Rate=0    <- reversión
16:04:48   9723 mV   Rem=0   Rate=0
```

**CONFIRMADO:** en 21 minutos enchufada, `RemainingCapacity` y `ChargeRate`
valen 0 en los 15 puntos, sin una sola excepción. El voltaje sube +25 mV
(~71 mV/h), con pendiente muy lineal y ruido de ±2 mV.

**PROBABLE, no confirmado:** que esté en pre-carga por goteo (corriente chica y
constante) en vez de con la protección del pack enclavada. El argumento es que
la pendiente se mantiene lineal (73 mV/h en el primer tramo, 66 mV/h en el
segundo) y una simple relajación de voltaje decaería mucho más rápido. **No es
concluyente**: 2 mV de ruido sobre 25 mV de señal es poco margen.

### 3.3 Advertencia sobre mi propia lectura del voltaje

En mi respuesta anterior dije "9,70 V son ~3,23 V por celda, o sea casi vacío".
Eso asume que el pack es **3S** (tres celdas en serie), y **eso no lo medí**:
lo inferí de que 9,7 V cae en el rango de un 3S vacío y sería absurdo en un 4S.
Es razonable pero es **inferencia**, y toda la lectura de "cuán vacío está"
depende de que sea correcta. `Win32_Battery.DesignVoltage` devuelve 9698 mV,
exactamente igual al voltaje actual, o sea que la BIOS está repitiendo la
lectura en vivo en ese campo y **no sirve** para deducir la configuración.

### 3.4 El medidor está descalibrado — CONFIRMADO

Fuente: `batteryreport.html`, sección *Recent usage*

```
2026-08-21 00:25:12   Battery   130 %   43,354 mWh     <- ciento treinta por ciento
2026-08-21 00:30:13   Battery    87 %   29,013 mWh     <- 5 minutos después
```

Dos cosas imposibles en un medidor sano:

1. Los **mismos** 43.354 mWh figuran antes como 100 % y después como 130 %. Lo
   que se movió es el *FullChargeCapacity*, no la carga.
2. Los 14.341 mWh "perdidos" en 5 minutos serían ~172 W en reposo.

El `FullChargeCapacity` histórico oscila entre 33.350 y 46.981 mWh. Un medidor
sano baja parejo, no rebota ±6.000.

**Esto es lo que explica tu problema recurrente** — el de quedarse trabada en un
porcentaje y no llegar al 100 (13 % la vez pasada, 0 % ahora).

### 3.5 Sobre el "67 % de salud" — no creerle

`FullChargeCapacity` actual = 34.816 mWh sobre 52.007 mWh de diseño da 67 %.

**Ese número sale del mismo medidor que reportó 130 %.** Cuando estaba calibrado
marcaba 43.354 mWh al 100 %, lo que daría ~83 %. Grado: **PROBABLE** que la salud
real esté en la banda 80-85 %, pero derivado de un instrumento que ya demostró
mentir. `BatteryCycleCount` no lo reporta este EC.

### 3.6 Por qué se vació sola — CONFIRMADO

Fuente: `datos-crudos/11-powercfg.txt`

- `powercfg /a`: **sólo existe Modern Standby (S0 Low Power Idle)**. S1, S2 y S3
  están deshabilitados por firmware. Nunca se suspende de verdad.
- `powercfg /devicequery wake_armed`: mouse HID, teclado HID y **Realtek PCIe GbE**
  pueden despertarla.
- `HiberbootEnabled = 1` → **Inicio rápido activado**: "Apagar" no apaga del todo.

---

## 4. Falso culpable, ya descartado — DESCARTADO

En el Administrador de dispositivos la batería figura como
**"Microsoft Surface ACPI-Compliant Control Method Battery"**, en una MSI.
Parece el culpable perfecto: hace match genérico contra `acpi\ven_pnp&dev_0c0a`.

**No es el problema.** Su INF (`C:\Windows\INF\oem96.inf`, copiado entero en
`datos-crudos/10-bateria-driver.txt`) dice literalmente:

```
[SurfaceACPIBattery.NT]
Include=battery.inf
Needs=CmBatt_Inst
```

O sea **instala el mismo `CmBatt.sys` de siempre**. Lo único que agrega es borrar
`UpperFilters`/`LowerFilters` y sacar un `necbatt.sys` viejo. Es cosméticamente
feo y funcionalmente inocuo. No tocarlo.

---

## 5. Lo que NO está establecido

Anotado explícitamente para que nadie lo dé por cierto más adelante:

- Que el reset de EC haya causado la falla de Secure Boot.
- Que la protección del pack esté enclavada (vs. pre-carga por goteo).
- Que el pack sea 3S.
- Que Secure Boot apagado sea lo que bloquea las actualizaciones de la DB.
- Que el vencimiento de los certificados 2011 explique el `Invalid signature`.
- Que exista una BIOS más nueva que `E1585IMS.30D` para MS-1585. **No lo verifiqué.**
- Que flashear la BIOS resuelva algo. **No hay evidencia y flashear con la batería
  muerta es la forma clásica de brickear una notebook.**
- Que el `bootmgfw.efi` de la partición EFI sea el mismo que el de `C:\Windows`.
- Que el SSD, el pendrive o el cargador tengan una falla.

---

## 6. Lo que falta medir, y cuesta poco

Todo lo de acá es **sólo lectura**, no cambia nada, y requiere PowerShell
**como administrador**:

```powershell
& 'C:\Users\frans\Desktop\diagnostico-msi\recolectar.ps1'
```

Correrlo elevado completa cuatro archivos que ahora están vacíos:

| Archivo | Qué agrega | Corresponde a |
|---|---|---|
| `04-secureboot-estado.txt` | `Confirm-SecureBootUEFI`, `Get-SecureBootPolicy` | Prioridad 2 del informe previo |
| `05-secureboot-variables-uefi.txt` | Tamaños de PK, KEK, db, dbx | Prioridad 6 |
| `07-bcdedit.txt` | `bcdedit /enum all` y `/enum firmware` | **Prioridad 1**, nunca ejecutada |
| `08-particion-efi.txt` | Contenido real de la partición EFI | **Prioridad 3**, nunca ejecutada |

El 07 y el 08 son las dos prioridades más altas del informe previo que quedaron
sin hacer, y son inofensivas.

---

## 7. Qué haría ahora, en este orden

1. **Con la batería: esperar y volver a medir.** Dejarla enchufada varias horas
   sin tocar nada y volver a correr el recolector. Si `Rem` se despega de 0 o
   `Rate` deja de ser 0, estaba en pre-carga y se resuelve solo. Cuesta cero y
   es el experimento que separa las dos explicaciones vivas.
2. **Correr el recolector como administrador** para cerrar las prioridades 1 y 3
   que quedaron pendientes desde la sesión anterior.
3. **No tocar Secure Boot todavía.** Dejarlo desactivado. Volver a activarlo sin
   entender la causa sólo devuelve el error.
4. **No flashear BIOS.** Ni siquiera investigarlo en serio hasta que la batería
   cargue.
5. Recién con 1 y 2 hechos, decidir el resto.

---

## 8. Segunda captura, con administrador — 2026-08-21 16:13

El recolector se volvió a correr elevado (`Admin: True` en los 13 archivos).
Se completaron las prioridades 1 y 3 del informe previo, que nunca se habían
ejecutado.

### 8.1 Variables UEFI — CONFIRMADO

Fuente: `datos-crudos/05-secureboot-variables-uefi.txt`

| Variable | Tamaño | Lectura |
|---|---|---|
| `PK` | 826 bytes | **Hay Platform Key.** La máquina **no** está en Setup Mode. |
| `KEK` | 3.066 bytes | Presente |
| `db` | 3.143 bytes | Lista de lo permitido |
| `dbx` | 10.444 bytes | Lista de revocados — **grande**, tiene updates de Microsoft aplicados |
| `SetupMode` / `SecureBoot` | 1 byte c/u | — |

`Confirm-SecureBootUEFI` devuelve **False**, coherente con
`UEFISecureBootEnabled = 0`.

### 8.2 El arranque, medido — CONFIRMADO

Fuente: `datos-crudos/07-bcdedit.txt`, `08-particion-efi.txt`

```
{bootmgr}   device  partition=\Device\HarddiskVolume1
            path    \EFI\Microsoft\Boot\bootmgfw.efi
```

La partición EFI es la #1 del disco 0, 300 MB, `IsSystem = True`. La ruta del
BCD coincide con un archivo que **existe** ahí. **No es un problema de que el
BCD apunte a un archivo faltante.**

### 8.3 Dos hipótesis mías, muertas

- **"El boot manager de la partición EFI es viejo y quedó revocado en dbx"** —
  **DESCARTADA.** El de la ESP es del **2026-07-17**, misma generación que el
  de `C:\Windows`. No es viejo.
- **"Es un boot manager de preview / flight-signed"** — **DESCARTADA.** Llegó con
  **KB5120102, instalado el 2026-07-18** por Windows Update normal
  (`Get-HotFix`), y la máquina **no está inscripta en Windows Insider**
  (`WindowsSelfHost\UI\Selection` y `\Account` no existen).

### 8.4 Dos cosas raras que anoto sin explicarlas

**a) `flightsigning Yes`** aparece en el BCD, en `{bootmgr}` **y** en `{current}`,
en una máquina que no es Insider. Es raro. Pero **probablemente no es la
explicación** del `Invalid signature detected`: ese flag gobierna qué acepta el
boot manager *de Windows* más adelante en la cadena, no qué acepta el *firmware*
del `bootmgfw.efi`. Lo dejo anotado como cabo suelto, no como causa.

**b) El `bootmgfw.efi` de la ESP y el de `C:\Windows` no son idénticos:**
3.086.728 vs 3.086.848 bytes → **120 bytes de diferencia**, con la misma fecha.
No sé qué significa. Puede ser normal. El script de §8.6 saca el SHA256 y la
firma de los dos para comparar de verdad.

### 8.5 Hallazgo útil: `SecureBootRecovery.efi` ya está en la máquina

```
S:\EFI\Microsoft\Boot\SecureBootRecovery.efi    174.584 bytes    2026-07-17
```

La sección 13 del informe previo lo trataba como algo a **descargar** y poner en
un pendrive, con la preocupación de no bajarlo de una fuente no oficial — y ahí
se trabó, porque además el pendrive fallaba.

**Ya está en la partición EFI, puesto por Windows** en la misma tanda de
servicing de julio 2026. No hace falta pendrive ni descarga.

Esto **no** significa que haya que ejecutarlo. Es una acción que toca firmware.
Sólo significa que esa rama dejó de estar bloqueada por el problema del pendrive.

### 8.6 La pregunta que queda, y el script que la contesta

Todo apunta a una sola pregunta sin responder:

> **¿La `db` del firmware contiene el certificado con el que está firmado el
> `bootmgfw.efi` que se ejecuta?**

Concretamente, si `db` sólo tiene los certificados **2011** y el boot manager
nuevo necesita el **Windows UEFI CA 2023**, el firmware lo rechaza y el síntoma
es exactamente `Invalid signature detected`. Es coherente con
`WindowsUEFICA2023Capable = 0` y con los tres rollouts pendientes que figuran en
`StateAttributes`:

```
DBUpdateExternalRollout | DBUpdate3PUEFICARollout | DBUpdate3POROMRollout
```

**Sigue siendo HIPÓTESIS.** No la doy por buena: la firma que medí sobre la copia
de `C:\Windows` dice *Production PCA 2011*, lo que juega **en contra**. Pero no
medí la copia de la ESP, que es la que el firmware valida y que difiere en 120
bytes.

Para cerrarlo, correr **como administrador**:

```powershell
& 'C:\Users\frans\Desktop\diagnostico-msi\analizar-secureboot.ps1'
```

Es **sólo lectura**: parsea `PK`, `KEK`, `db` y `dbx` y lista cada certificado con
su emisor y vencimiento, saca SHA256 y firma de las dos copias del boot manager,
y desmonta la partición EFI al terminar. No escribe ninguna variable UEFI, ni el
BCD, ni la ESP.

### 8.7 Batería, seguimiento

```
15:43:00   9698 mV   Rem=0   Rate=0
16:04:48   9723 mV   Rem=0   Rate=0
16:14:12   9733 mV   Rem=0   Rate=0     <- +35 mV en 31 min (~68 mV/h)
```

Sin cambios cualitativos: pendiente igual de lineal, `Rem` y `Rate` clavados en
0. Sigue sin decidirse entre pre-carga por goteo y protección enclavada.

---

## 9. La cadena de confianza, medida — 2026-08-21 16:38 y 16:41

Fuente: `datos-crudos/14-secureboot-analisis.txt`, `15-firmas-pe.txt`

### 9.1 Qué hay realmente en las variables — CONFIRMADO

**`PK`** — 1 certificado:

```
CN=MSI NB PK 2022          [2022-10-28 -> 2042-10-28]
```

Es la Platform Key de fábrica de MSI, vigente. La máquina **no** está en Setup Mode.

**`KEK`** — 2 certificados:

```
CN=Microsoft Corporation KEK CA 2011      [hasta 2026-06-24]   *** VENCIDO ***
CN=Microsoft Corporation KEK 2K CA 2023   [hasta 2038-03-02]
```

**El KEK 2023 YA ESTÁ instalado.** O sea que la migración de Microsoft avanzó
hasta acá.

**`db`** (lo que el firmware acepta) — 2 certificados:

```
CN=Microsoft Corporation UEFI CA 2011      [hasta 2026-06-27]  *** VENCIDO ***
CN=Microsoft Windows Production PCA 2011   [hasta 2026-10-19]
    huella 580A6F4CC4E4B669B9EBDC1B2B3E087B80D0678D
```

**No hay ningún certificado 2023 en `db`.** La migración quedó a mitad de camino:
KEK sí, db no. Coherente con `RebootRequestedDB = 1`.

**`dbx`** (lo que el firmware rechaza) — **0 certificados, 217 hashes SHA256**.

### 9.2 Con qué está firmado el boot manager — CONFIRMADO

`15-firmas-pe.txt` recorre el array `WIN_CERTIFICATE` del PE, que es lo que
`Get-AuthenticodeSignature` no muestra completo:

```
bootmgfw.efi -> TOTAL DE FIRMAS: 1
                tipo 0x0002 (PKCS#7 SignedData), 9.728 bytes
                emisor: CN=Microsoft Windows Production PCA 2011
                sin firma anidada (OID 1.3.6.1.4.1.311.2.4.1 ausente)
```

**Una sola firma. Sin firma anidada. Emitida por la PCA 2011.**

### 9.3 Las tres hipótesis, resueltas

| Hipótesis | Veredicto | Por qué |
|---|---|---|
| A `db` le falta el certificado que firma el boot manager | **MUERTA** | La PCA 2011 **está** en `db` |
| La PCA 2011 está revocada en `dbx` | **MUERTA** | `dbx` no tiene **ningún** certificado, sólo hashes |
| El boot manager lleva dos firmas y el firmware elige la mala | **MUERTA** | Tiene **una** sola, sin anidar |

### 9.4 Conclusión: la cadena que se validaría HOY está intacta

Con lo medido, el `bootmgfw.efi` que hoy está en la partición EFI **debería
validar bien** bajo Secure Boot: firmado por una CA presente en `db`, no
revocada, sin firmas ambiguas.

Lo que queda como explicación más probable del `Secure Boot Violation`:

> **El error es anterior al 2026-07-17.** Ese día KB5120102 reemplazó el boot
> manager de la partición EFI. **Nadie volvió a probar Secure Boot desde
> entonces.** El binario que fallaba pudo haber sido reemplazado por uno bueno.

Grado: **HIPÓTESIS**, pero es la única que sobrevive a todo lo medido, y es
barata de probar — activar Secure Boot en BIOS, y si falla, desactivarlo de
nuevo ahí mismo.

**PERO NO AHORA.** Con la batería en 0 y sin cargar, cualquier corte de energía
a mitad de un cambio de firmware repite exactamente el escenario que precedió al
problema original. **La batería va primero.**

### 9.5 Una inconsistencia que anoto sin explicar

`Get-AuthenticodeSignature` y mi parser de PE reportan **huellas distintas para
el certificado hoja del mismo archivo**:

| Archivo | Get-AuthenticodeSignature | Parser de PE |
|---|---|---|
| `bootmgfw.efi` | `BAC13DF1...` (2026-04-16 →) | `CB320963...` (2025-10-16 →) |
| `bootmgr.efi` | `BAC13DF1...` | `DC91E564...` |

No sé a qué se debe. **No cambia la conclusión**: por los dos métodos, en todos
los archivos, el **emisor** es `Microsoft Windows Production PCA 2011`, y el
emisor es lo que `db` valida. Pero queda anotado como medición inconsistente sin
resolver, no barrido bajo la alfombra.

### 9.6 Lo que sigue sin medirse

- Si el hash Authenticode del boot manager está entre los **217 de `dbx`**.
  No lo comparé: `dbx` guarda hashes **Authenticode** (que excluyen el checksum
  y el bloque de firma) y yo saqué el SHA256 del **archivo entero**. Son valores
  distintos y no se pueden comparar directamente. Es la última vía técnica
  abierta, y requiere implementar el hash Authenticode.
- Si el error todavía ocurre. **Nadie lo probó después del 2026-07-17.**

---

## Archivos de este directorio

| Archivo | Qué es |
|---|---|
| `INFORME.md` | Este documento. Interpretación, con grados. |
| `recolectar.ps1` | Recolector general. Re-ejecutable, sólo lectura. |
| `analizar-secureboot.ps1` | Parsea db/dbx y compara las dos copias del boot manager. **Requiere admin.** Sólo lectura. |
| `firmas-pe.ps1` | Recorre el array WIN_CERTIFICATE de un PE y lista todas las firmas, incluidas las anidadas. No requiere admin. |
| `datos-crudos/` | Salida verbatim de cada comando. **La fuente de verdad.** |
| `datos-crudos/batteryreport.html` | Informe oficial de batería de Windows, 60 días. |
| `informe-previo-gpt-2026.txt` | El informe de la sesión anterior, sin modificar. |

---

## 10. Sesión 2026-08-22 (madrugada): por qué no carga

### 10.1 La serie de medición

Serie cada 5 min, `datos-crudos/bateria-serie-2026-08-22.txt`:

| Hora | Voltage | RemainingCapacity | ChargeRate | Charging |
|---|---|---|---|---|
| 00:55 | 9955 | 80 | 0 | False |
| 01:00 | 9956 | 80 | 0 | False |
| 01:05 | 9957 | 80 | 0 | False |
| 01:10 | 9959 | 80 | 0 | False |
| 01:15 | 9959 | 80 | 0 | False |
| 01:20 | 9960 | 80 | 0 | False |

**CONFIRMADO:** `RemainingCapacity` se despegó de 0 (llegó a 80 mWh) pero está
**clavado** ahí. 80 mWh sobre 34.816 es 0,23 %: no es carga, es el gauge
saliendo del piso.

**CONFIRMADO:** el voltaje sube pero se aplana asintóticamente —
67 mV/h (21/08 tarde) -> 24,6 mV/h (noche) -> **12 mV/h** (madrugada).
Converge apenas por encima del nominal (`DesignVoltage` = 9955 mV). Una carga
real en CC subiría hacia ~12,6 V en un pack 3S y movería la capacidad.

**DESCARTADO — precarga por celda baja:** el pack está a 9960 mV = 3,32 V/celda
(3S). Cualquier cargador Li-ion sale de precarga por encima de ~3,0 V/celda.
Ya pasó ese umbral y el EC sigue sin entrar en carga: la decisión de no cargar
**no viene del voltaje del pack**.

### 10.2 El historial de capacidad — el dato que da vuelta el diagnóstico

De `powercfg /batteryreport` (`datos-crudos/batteryreport-2026-08-22.html`),
`FullChargeCapacity` por día:

| Fecha | FullChargeCapacity | % del diseño (52.007 mWh) |
|---|---|---|
| 2026-08-13 | 42.973 mWh | 82,6 % |
| 2026-08-14 a 08-19 | ~43.040 mWh | 82,8 % |
| 2026-08-20 | 43.354 mWh | 83,4 % |
| **2026-08-21** | **34.026 mWh** | **65,4 %** |
| 2026-08-22 | 34.816 mWh | 66,9 % |

**CONFIRMADO:** el pack estuvo estable en ~43.000 mWh del 13 al 20 de agosto y
se derrumbó a 34.026 el **21**, el día del incidente.

**CONFIRMADO:** esto corrobora, por una fuente independiente, el "83-85 % de
salud real" que la sección anterior daba como estimación. 43.040/52.007 = 82,8 %.

**CONFIRMADO:** el "67 % de salud" es un artefacto **posterior** al derrumbe del
gauge. No mide el pack.

**Un pack no pierde 20 % de capacidad física en un día.** Lo que cambió el 21 de
agosto es el **fuel gauge**, no la batería.

### 10.3 La causa probable

`HKLM:\SOFTWARE\WOW6432Node\MSI\MSI Center\Component\Base Module\GeneralSetting`

    BatteryMode = 1

En MSI Center / Battery Master: `0` = Best for Mobility (100 %), **`1` = Balanced
(tope ~80 %)**, `2` = Best for Battery (~60 %).

**HIPÓTESIS (la única que explica todas las mediciones a la vez):** el gauge
quedó descalibrado el 21/08 creyendo internamente que el pack está **por encima
del tope del 80 %**, mientras le reporta 0 % al sistema operativo. El EC ve
"ya superó el umbral" y **no inicia la carga**, aunque el pack esté físicamente
casi vacío.

Encaja con: `Charging=False` + `PowerOnline=True`, `ChargeRate=0`, voltaje
subiendo sólo por goteo, capacidad clavada, y el historial de estimaciones
absurdas del gauge (130 %, 916 %, 845 % en el battery report).

### 10.4 El test que la falsa

Poner Battery Master en **Best for Mobility** (100 %) desde la GUI de MSI Center
— reversible en un clic, no toca firmware.

- Si el EC arranca la carga (`Charging=True` o `ChargeRate>0` y `Rem` subiendo)
  -> hipótesis **confirmada**, y sigue la recalibración del paso 4.
- Si no pasa nada en ~30 min -> hipótesis **muerta**; queda el gauge en fallo
  permanente y la decisión pasa a reemplazo de pack vs servicio técnico.

**No se cambió por registro a propósito:** MSI Center manda el comando al EC
desde su servicio; escribir la clave con el servicio corriendo deja las dos
mitades inconsistentes y contamina el test.

### 10.5 CORRECCIÓN a 10.1: `RemainingCapacity` no está clavado

A las 01:35 pasó de **80 a 91 mWh**, tras 40 min inmóvil. La afirmación
"clavado" de 10.1 queda **corregida**: hay carga, pero a ~16,5 mWh/h.

A ese ritmo, llenar 34.816 mWh tomaría **~88 días**. Sigue siendo inservible en
la práctica, y el resto del análisis de 10.1 (el voltaje aplanándose, el EC sin
declarar carga) no cambia. Pero "entra corriente muy lento" y "el EC no carga"
son cosas distintas, y lo medido es la primera.

`BatteryCycleCount.CycleCount = 0`: el gauge tampoco sabe cuántos ciclos lleva.
Otra evidencia de que el que perdió los datos es el gauge, no el pack.

### 10.6 Battery Master no está instalado (capturas 2026-08-22)

En MSI Center → Features sólo aparece **User Scenario**. No hay Battery Master
ni control de tope de carga visible. MSI Center instala sus módulos por demanda
desde el ícono de cuadrados de la barra superior; el módulo de batería no está.

Por lo tanto **`BatteryMode = 1` del registro no está verificado** como "tope
80 %": es la interpretación estándar de ese valor en MSI Center, pero sin el
módulo instalado no hay forma de confirmar que el EC lo esté aplicando. Baja de
causa probable a **hipótesis sin verificar**.

Las clases WMI del EC de MSI existen (`MSI_Master_Battery`, `MSI_Power`,
`MSI_ACPI`) pero no son consultables: las dos primeras devuelven `Incompatible`
y `MSI_ACPI` da **Acceso denegado** sin admin. Leer el tope desde ahí exigiría
conocer el offset del EC RAM — ingeniería reversa del EC, desproporcionada
frente a las alternativas.

### 10.7 Hipótesis nueva: presupuesto de corriente del adaptador

Estado en las capturas: User Scenario en **Extreme Performance** y GPU Switch en
**Discrete Graphics Mode**. Es la combinación de mayor consumo posible.

**HIPÓTESIS:** con el sistema consumiendo cerca del límite del adaptador, el EC
prioriza alimentar la máquina y deja para el pack sólo la corriente sobrante —
lo que produce exactamente los ~16,5 mWh/h observados.

**Test:** pasar User Scenario a **ECO-Silent** (un clic, reversible, **no pide
reboot**). Si la corriente de carga sube, hipótesis confirmada.

No se toca el GPU Switch: cambiarlo **exige reiniciar**, y un reinicio con la
batería en este estado es justo el riesgo que este diagnóstico evita.

---

## 11. LA CAUSA (2026-08-22, forense del registro de eventos)

### 11.1 La máquina nunca se apagó

**CONFIRMADO:** `LastBootUpTime` = **2026-08-16 20:54:24**. Uptime al momento de
medir: **5 días, 4 h 52 min**.

Corroborado por cuatro eventos `6013` independientes ("el tiempo límite del
sistema es de N segundos"), que apuntan todos al mismo arranque:

| Evento 6013 | Uptime declarado | Arranque implícito |
|---|---|---|
| 18/08 20:05 | 169.875 s (1,97 d) | 16/08 ~20:54 |
| 19/08 15:47 | 240.809 s (2,79 d) | 16/08 ~20:50 |
| 21/08 00:25 | 358.247 s (4,15 d) | 16/08 ~20:53 |
| 21/08 14:43 | 409.772 s (4,74 d) | 16/08 ~20:52 |

**CONFIRMADO:** **cero** eventos `41` (apagado inesperado) y **cero** `6008` en
todo el rango 20-22/08. No hubo apagado por batería agotada.

Por lo tanto: **no hubo un "la apagué y la prendí con el cargador"**. El equipo
venía corriendo desde el 16 y siguió corriendo todo el tiempo.

### 11.2 Por qué parecía apagada: sólo hay Modern Standby

**CONFIRMADO** (`powercfg /a`): **S1, S2 y S3 no existen** en este firmware.
El único estado de suspensión es **S0 Low Power Idle (Modern Standby)**.

Cerrar la tapa no suspende: baja a S0ix y **sigue consumiendo**. El log está
lleno de pares `506`/`507` (entrar/salir de espera moderna) y de saltos de reloj
de **4 h, 8 h y hasta 24 h** entre un `506` y su `507` — sesiones largas de
espera moderna drenando el pack sin cargador.

Que se vea idéntico a estar apagada es la razón por la que la reconstrucción
inicial era otra. No es un error de memoria: es lo que Modern Standby aparenta.

### 11.3 La cadena causal completa

1. Uptime continuo desde el **16/08 20:54**, sin un solo apagado.
2. Sin cargador, **Modern Standby** drena el pack en las sesiones largas.
3. El gauge **ya venía descalibrado** (130 %, y estimaciones de 916 % y 845 %
   en el battery report).
4. El pack cruza el **corte lógico de 0 mWh del gauge con el sistema todavía
   corriendo** — no hay apagado que congele el estado.
5. En ese cruce el gauge **pierde su bloque de datos**: `FullChargeCapacity`
   reescrita 43.354 -> 34.026, `SerialNumber` vacío, `CycleCount` 0,
   `DesignCapacity` vacío, y `DesignVoltage` degradado a **espejo del voltaje
   instantáneo** (9955 con Voltage 9955; 9965 con Voltage 9965).
6. Sin datos válidos del pack, **el EC no sabe cuánta corriente entregar** y
   aplica sólo mantenimiento: **~27,6 mWh/h**, con `Charging=False`.

**El pack no está muerto.** El 20/08 daba 43.354 mWh (83,4 % de salud). Lo que
se rompió es el **fuel gauge**, y se rompió por un drenaje en Modern Standby que
nunca terminó en un apagado.

### 11.4 Por qué nada de lo probado funcionó

Todo lo intentado fue **software sobre un EC que lleva 5 días corriendo con
datos corruptos**. El EC no vuelve a leer el pack mientras no pierda la
alimentación. Driver, Secure Boot, modos de MSI Center: ninguno toca eso.

### 11.5 La trampa: "Apagar" no apaga

**CONFIRMADO:** `HiberbootEnabled = 1` — **Inicio rápido activado**.

Con Inicio rápido, el botón **Apagar** de Windows hiberna el kernel y **no hace
un arranque en frío**. Apagar, esperar y encender **no cambiaría nada**, y el
resultado natural sería concluir "la batería está muerta" por una prueba que
nunca se hizo de verdad.

Lo que sí fuerza un arranque en frío:

    shutdown /s /full /t 0

`/full` ignora el Inicio rápido. (**Reiniciar** también hace ciclo completo,
pero un reinicio no suelta la alimentación del EC.)

### 11.6 Sobre el riesgo — el freno estaba puesto contra otra cosa

El handoff prohibía reiniciar con la batería en este estado. Ese freno fue
diseñado contra dos impactos concretos, y hoy **ninguno de los dos está armado**:

- *No arranca por batería vacía*: no aplica **con el cargador conectado**.
- *Secure Boot Violation*: **Secure Boot está desactivado**
  (`UEFISecureBootEnabled=0`), que es justamente por lo que hoy arranca.

Queda como riesgo residual que el equipo quede sin arrancar por una causa no
prevista. **No se ejecuta sin autorización explícita** — el handoff lo marca
como prohibido sin avisar, y avisar es esto.

---

## 12. Reconsideración de la acción (con evidencia externa)

### 12.1 Mi propuesta de §11.5 era insuficiente

`shutdown /s /full /t 0` fuerza un arranque en frío, pero **no corta la
alimentación del EC**: el EC sigue alimentado mientras haya AC o pack conectado.
Lo que la documentación de campo describe como capaz de resincronizar el gauge
es **quitar toda alimentación** (botón de encendido 15-30 s sin AC) o el
**agujero de reset**, no un apagado por software.

Sigue valiendo como primer escalón —fuerza la re-enumeración ACPI del pack, es
barato y de bajo riesgo— pero **no hay que esperar que alcance**.

### 12.2 El caso está documentado y el pronóstico es bueno

En el foro oficial de MSI hay un caso con el mismo cuadro (0 %, enchufada, sin
cargar) resuelto así: desinstalar el driver de batería en Administrador de
dispositivos -> esperar 5 min -> **EC reset** -> esperar 5 min -> enchufar ->
encender. Resultado: **la batería mostró 100 % al instante**, con la conclusión
de que el pack se estuvo cargando todo el tiempo y el software creía que no.

Encaja con lo medido acá: el pack daba **83,4 % de salud el 20/08**.

### 12.3 El riesgo real es otro del que anoté en §11.6

En §11.6 escribí que el freno del handoff no estaba armado porque Secure Boot
está desactivado. **Eso vale para un apagado por software, no para el EC reset
por hardware.**

**HIPÓTESIS (no confirmada):** si el procedimiento de reset del MS-1585 toca la
NVRAM/CMOS, Secure Boot volvería a su **default de fábrica (activado)**, y ahí
sí reaparecería el Secure Boot Violation. Eso explicaría por qué el violation
siguió al reset de EC la vez anterior — cuya causa la §9 declara **no resuelta**.

**No se pudo confirmar** si el reset del MS-1585 toca la CMOS: las páginas
oficiales de MSI devuelven **HTTP 403** y las búsquedas no lo aclaran. Queda
como vacío declarado, no como riesgo descartado.

### 12.4 Escalera de acción

| # | Acción | Riesgo | Estado |
|---|---|---|---|
| 1 | `shutdown /s /full /t 0` con AC conectada | bajo — no toca NVRAM ni firmware | **recomendado** |
| 2 | Desinstalar driver de batería + repetir 1 | bajo — Windows lo reinstala solo | si 1 falla |
| 3 | **EC reset por hardware** | **puede reactivar Secure Boot** | **NO todavía** |

El paso 3 es el que probablemente funciona y el único que puede dejar el equipo
sin arrancar. No se ejecuta hasta tener verificado el camino de vuelta: cómo
entrar al BIOS y volver a desactivar Secure Boot.

### 12.5 Nota aparte: `HiberbootEnabled = 1`

El Inicio rápido explica por qué el EC nunca se limpió en cinco días: **ningún
apagado del usuario fue un apagado real**. Desactivarlo es reversible y evita
que el problema se repita, pero es un cambio persistente y va aparte.

### 12.6 CORRECCIÓN: `/full` no existe en esta build

`shutdown /s /full /t 0` es **inválido** en Win11 26200. La ayuda de
`shutdown.exe` lista `/hybrid` (que hace lo contrario: prepara arranque rápido)
y **no lista `/full`**.

Forma correcta, sin cambios persistentes:

> **Menú Inicio -> mantener SHIFT presionado -> clic en Apagar.**

Shift omite el Inicio rápido y produce un apagado completo, sin tocar
`HiberbootEnabled` ni `powercfg /h`.

**Verificador del efecto** (regla del saboteador — se mira el efecto, no la
precondición). Tras encender, el evento `Kernel-Boot` **27** debe decir:

- `tipo de arranque 0x0` -> **arranque en frío real**. La prueba se hizo.
- `tipo de arranque 0x2` -> fue Inicio rápido otra vez. **La prueba NO se hizo**
  y cualquier conclusión sobre la batería sería inválida.

Dato que lo corrobora: **los cinco eventos 27 del 18 al 21/08 dicen todos
`0x2`**. Ni un solo arranque en frío en toda la ventana. Es la confirmación
independiente de §11.5.

---

## 13. CORRECCIÓN a §11: sí hubo hibernación por batería crítica

### 13.1 El error

En §11.1 escribí *"la máquina nunca se apagó"* y *"no hubo un 'la apagué y la
prendí con el cargador'"*. **Las dos afirmaciones son falsas**, y la §3.1 de este
mismo documento ya lo decía desde el 21/08:

- **21/08 10:26:55** — Kernel-Power evento **524**: *"Critical desencadenador de
  batería cumplido"*. **Hibernó.**
- **21/08 14:43:57** — Kernel-Boot + *"Cambio de fuente de energía"*. Se enchufó
  y arrancó.

Busqué los IDs 41, 42, 107, 109, 506, 507, 6008, 1, 12 y 13. **No busqué el
524**, que es justo el de batería crítica. Concluí "no hubo apagado" de una
búsqueda que no podía encontrarlo.

**La reconstrucción del usuario era correcta**: se descargó hasta el fondo, se
apagó sola, y arrancó al enchufarla.

### 13.2 Qué se cae y qué queda en pie

**Se cae:**
- "Nunca se apagó" -> **hibernó por batería crítica el 21/08 a las 10:26**.
- "La historia no es lo que pasó" -> **era exacta**.
- Que `DesignVoltage` espejando `Voltage` fuera hallazgo mío: **§3.3 ya lo
  documentaba el 21/08**.

**Queda en pie, y es lo que gobierna la acción:**
- Modern Standby como mecanismo del drenaje (ya estaba en §3.6).
- `HiberbootEnabled = 1`: ningún apagado fue un arranque en frío (ya en §3.6).
- Los **5 eventos Kernel-Boot 27 = `0x2`** del 18 al 21/08: ni un cold boot real
  en toda la ventana. **Hallazgo nuevo y verificado.**
- El derrumbe de `FullChargeCapacity` 43.354 -> 34.026 entre el 20 y el 21.
  **Hallazgo nuevo y verificado.**
- La pérdida del bloque de datos del gauge (serial, ciclos, capacidades).
  **Hallazgo nuevo y verificado.**

**La conclusión operativa no cambia:** una hibernación **no** resetea el EC ni el
gauge. Sigue haciendo falta un arranque en frío real (SHIFT + Apagar), y la
escalera de §12.4 se mantiene entera.

### 13.3 La causa de mi error, para no repetirla

El mensaje de retome decía leer `INFORME.md` **COMPLETO**. Salté directo a medir.
Resultado: re-deriví cosas ya documentadas (§3.3, §3.4, §3.5, §3.6), presenté
como hallazgo lo que ya estaba escrito, y **contradije al usuario con una
conclusión falsa** construida sobre una búsqueda incompleta.

Medir antes de leer no es "ir al grano": es rehacer el trabajo con menos
información de la que ya había en el repo.

---

## 14. Resultado del arranque en frío — 2026-08-22 18:23

### 14.1 El apagado fue real — CONFIRMADO

```
22/08 15:41:53   El tipo de arranque fue 0x0    <- ARRANQUE EN FRIO
22/08 15:37:38   El tipo de arranque fue 0x2
21/08 14:43:57   El tipo de arranque fue 0x2
21/08 10:26:01   El tipo de arranque fue 0x2
```

**Primer `0x0` de toda la ventana registrada.** SHIFT + Apagar funcionó: la
prueba se hizo de verdad. `LastBootUpTime` = 22/08 15:41:52, uptime 2 h 41 min
al momento de medir.

### 14.2 La batería no cambió donde importa

| Dato | 01:55 (antes) | 18:23 (después) |
|---|---|---|
| `Voltage` | 9967 | 10036 |
| `RemainingCapacity` | 103 | 171 |
| `FullChargedCapacity` | 34.816 | 39.284 |
| `ChargeRate` | **0** | **0** |
| `Charging` | **False** | **False** |
| `Pct` | **0** | **0** |
| `SerialNumber` | **vacío** | **vacío** |
| `CycleCount` | **0** | **0** |
| `DesignVoltage` | espeja Voltage | **espeja Voltage** (10036 = 10036) |

**La firma de corrupción de §11.3 sigue intacta**: sin serial, sin ciclos, y
`DesignVoltage` todavía espejando el voltaje instantáneo. El gauge **no** se
reinicializó.

Volt y Rem siguen la misma curva de goteo que ya traían: +68 mWh en 16,5 h
(**4,1 mWh/h**, aún más lento que los 23 mWh/h de la madrugada).

### 14.3 El salto de `FullChargedCapacity` no prueba nada

34.816 -> 39.284 mWh parece recuperación. **No se puede afirmar.**

§3.4 ya documentó que el `FullChargeCapacity` de este gauge **oscila entre
33.350 y 46.981 mWh**. Un salto de 4.468 cae holgadamente dentro de ese ruido.
Además, la tabla de capacidad por día del battery report **no tiene fila para el
22/08**: el último valor consolidado sigue siendo 34.026 del 21.

Grado: **indistinguible del ruido que este instrumento ya demostró tener.**
No se cuenta como evidencia de mejora.

### 14.4 Veredicto: el paso 1 no funcionó

Contra el criterio de §12.4 y la tabla de lectura:

- `Pct` ≠ 0, `Charging=True` o `Rate` > 0 -> **ninguno se cumple**.
- `DesignVoltage` fijo y distinto de `Voltage` -> **no se cumple**, sigue espejando.

Pasaron 2 h 41 min desde el arranque en frío, muy por encima de los ~20 min del
criterio. **Un arranque en frío por software no alcanza para que el EC
reinicialice el gauge.** Queda confirmado por experimento lo que §12.1
anticipaba: apagar no le quita alimentación al EC.

**Siguiente: paso 2 de la escalera** — desinstalar el driver de batería, esperar
5 min, repetir SHIFT + Apagar. Es lo que el caso resuelto del foro de MSI hizo
**antes** del EC reset. El paso 3 sigue sin autorizar.

---

## 15. Resultado del paso 2 — 2026-08-22 18:34

### 15.1 Ejecutado correctamente — CONFIRMADO

Driver de batería desinstalado (sin quitar el paquete), espera, y segundo
arranque en frío:

```
22/08 18:32:40   El tipo de arranque fue 0x0    <- segundo cold boot real
22/08 15:41:53   El tipo de arranque fue 0x0
```

El dispositivo se remontó solo: `Microsoft Surface ACPI-Compliant Control Method
Battery`, `Status = OK`, `ConfigManagerErrorCode = 0`.

### 15.2 Cero cambios — CONFIRMADO

| Dato | 18:23 (antes) | 18:34 (después) |
|---|---|---|
| `Voltage` | 10036 | **10036** |
| `RemainingCapacity` | 171 | **171** |
| `ChargeRate` | 0 | **0** |
| `Charging` | False | **False** |
| `Pct` | 0 | **0** |
| `SerialNumber` | vacío | **vacío** |
| `CycleCount` | 0 | **0** |
| `DesignVoltage` | espeja Voltage | **espeja Voltage** |
| `FullChargedCapacity` | 39.284 | 39.273 |

**Valores idénticos, no parecidos.** Volt y Rem no se movieron ni un dígito.
El paso 2 **no hizo nada**.

### 15.3 Hipótesis nueva que cambia el pronóstico

`SerialNumber` y `CycleCount` **no viven en el EC ni en Windows**: viven en el
**data flash del IC de gauge, dentro del pack**. El EC sólo los relee y los pasa.

**HIPÓTESIS:** si esos campos están vacíos porque el data flash del gauge se
corrompió, **ningún reset de EC los restaura** — el EC seguiría leyendo un gauge
que no tiene los datos. El paso 3 sólo ayuda si lo que está mal es la copia que
el EC cachea, no el original del pack.

Cómo se distingue: **es exactamente lo que el paso 3 mide.** Tras un EC reset,
si `SerialNumber` vuelve, era caché del EC. Si sigue vacío, el daño está en el
pack y la vía de software se agotó del todo.

Esto no invalida el paso 3 —el caso del foro de MSI se resolvió así— pero baja
la probabilidad de éxito y aclara qué significa cada resultado.

### 15.4 Estado de la escalera

| # | Acción | Resultado |
|---|---|---|
| 1 | SHIFT + Apagar | **ejecutado — sin efecto** |
| 2 | Driver de batería + cold boot | **ejecutado — sin efecto** |
| 3 | EC reset por hardware | pendiente, requiere decisión |

La vía de software **está agotada**. Lo que queda toca hardware o firmware.

---

## 16. Dato nuevo del usuario y estado de la BIOS — 2026-08-22

### 16.1 El EC reset YA resolvió este cuadro en ESTA máquina

Aporte del usuario, no registrado en ningún documento previo:

> Cuando la batería quedó trabada en 13 %, hizo el procedimiento del informe
> previo y **la batería volvió a cargar hasta 100 % y se mantuvo así durante
> meses**, hasta la descarga del 20-21/08.

El `informe-previo-gpt-2026.txt` documentaba la secuencia (líneas 49-55) pero
**se cortaba en el Secure Boot Violation y nunca registró que la batería se
hubiera arreglado.**

Esto cambia el peso de la evidencia: el paso 3 deja de apoyarse en un caso de
foro ajeno y pasa a tener **precedente positivo en esta misma máquina, con este
mismo síntoma**. Grado: **CONFIRMADO por el usuario**, no medido por mí.

Debilita además la hipótesis de §15.3 (data flash del pack corrupto): si el
reset funcionó una vez, lo que se recupera es el estado del EC.

### 16.2 El error a NO repetir

Del informe previo, pasos 5 y 6:

> 5. la notebook comenzó un comportamiento de encendido/apagado o ciclo de power
> 6. **mientras se estaba encendiendo y apagando, el usuario presionó nuevamente
>    el botón de encendido una vez**
> 7. posteriormente apareció el problema de Secure Boot

**HIPÓTESIS:** esa pulsación *en medio del ciclo de power* es el candidato más
plausible para haber dejado la NVRAM en mal estado — no el reset en sí.

Si el equipo entra en ciclo de encendido/apagado, **no tocar nada y dejarlo
terminar**. Es la diferencia entre repetir el procedimiento y repetir el
accidente.

### 16.3 BIOS: no flashear

| Dato | Valor |
|---|---|
| Versión actual | **E1585IMS.30D** |
| Fecha | 2023-06-26 |
| Fabricante | American Megatrends International |

**No se pudo verificar si existe una versión más nueva para el A12VF.** Las
páginas de MSI devuelven **HTTP 403** al fetch y las búsquedas no lo aclaran.
Sigue siendo el vacío declarado en §5.

**Trampa detectada:** las búsquedas devuelven `E1585IMS.108` — pero es del
**Sword 15 A13U**, otro modelo. Comparte el chasis MS-1585 y **no** la CPU
(13ª gen vs 12ª). Flashear ese archivo en un A12VF es la forma clásica de
inutilizar el equipo. **No usarlo.**

**Recomendación: NO flashear**, por cuatro razones acumuladas:
1. No hay versión más nueva verificada para este modelo exacto.
2. No hay evidencia de que resuelva este problema.
3. Flashear con la batería en 0 % es el escenario de brickeo por excelencia.
4. Ya existe una vía con precedente positivo en esta máquina (§16.1).

La única fuente confiable para el punto 1 es la página oficial del A12VF, que
hay que abrir en el navegador:
`https://www.msi.com/Laptop/Sword-15-A12VX/support`

### 16.4 El riesgo de Secure Boot es menor de lo calculado en §12.3

Si el reset reactiva Secure Boot, **es probable que ya no falle**: §9.4 estableció
que la cadena que se validaría hoy está intacta — el boot manager fue reemplazado
por **KB5120102 el 2026-07-17**, está firmado por una CA presente en `db`, no
revocada y sin firmas ambiguas. **Nadie volvió a probar Secure Boot desde
entonces.**

Y si igual falla: se entra a la BIOS y se desactiva, que es exactamente lo que ya
se hizo una vez con éxito.

### 16.5 Procedimiento autorizado

1. **SHIFT + Apagar.** Apagado completo.
2. **Desenchufar el cargador.**
3. **Mantener el botón de encendido 60 segundos.**
4. **Esperar 5 minutos.**
5. **Enchufar el cargador.** (MSI: el adaptador debe estar conectado al encender
   por primera vez tras el reset.)
6. **Encender una sola vez.** Si entra en ciclo de encendido/apagado, **no tocar
   nada** — ver §16.2.

### 16.6 Qué hacer si entra en ciclo de encendido/apagado

**No presionar el botón de encendido.** Es lo único que separa el intento
anterior —que arregló la batería pero dejó Secure Boot roto— de un intento
limpio. Y se mantiene el grado: que la pulsación causara el problema es
**HIPÓTESIS**, no está demostrado. Justamente por eso no se repite la parte que
no hace falta.

1. **Esperar 3 minutos sin tocar nada.** La mayoría de los ciclos tras un reset
   se resuelven solos en una o dos pasadas.
2. **Si a los 3 minutos sigue:** desenchufar el cargador — el equipo se apaga,
   porque el pack no lo sostiene. Esperar 1 minuto, enchufar, encender **una**
   vez. Se corta por el cargador, no por el botón.
3. **Si vuelve a ciclar:** parar. Es servicio técnico. El SSD y los datos no se
   tocan en ninguno de estos pasos.

Si después aparece `Secure Boot Violation`: **no es una emergencia.** BIOS con
`Supr` o `F2` -> Security -> Secure Boot -> **Disabled** -> guardar y salir. Es
el estado en el que está hoy y por eso arranca.

---

## 17. RESUELTO — el EC reset funcionó — 2026-08-22 18:57

### 17.1 Los números

| Dato | 18:34 (antes) | 18:57 (después) |
|---|---|---|
| `Charging` | False | **True** |
| `ChargeRate` | 0 | **26.183** (≈26 W) |
| `RemainingCapacity` | 171 | **1.972** |
| `Voltage` | 10.036 | **11.773** |
| `Pct` | 0 % | **5 %**, subiendo |

**CONFIRMADO:** carga real, no goteo. 26 W es la corriente de carga normal de
este equipo, tres órdenes de magnitud por encima de los ~4 mWh/h del goteo.

### 17.2 El gauge se reinicializó — CONFIRMADO

```
DesignVoltage = 11792   /   Voltage = 11773   ->   YA NO ESPEJA
```

Era **la** firma de corrupción de §11.3 y §14.2. Se rompió el espejo: ahora
`DesignVoltage` es una constante y `Voltage` una medición, como debe ser.

**Beneficio colateral — cae un "no establecido" de §5:** con `DesignVoltage`
real en **11.792 mV**, el pack es **3S** (3 × 3,93 V nominal). §3.3 había
advertido que ese campo no servía por estar espejado; ahora sirve, y confirma la
inferencia que aquella sección marcaba como no medida.
52.007 mWh / 11.792 mV ≈ 4.410 mAh, coherente.

### 17.3 Lo que NO volvió

`SerialNumber` sigue vacío y `CycleCount` sigue en 0.

La hipótesis de §15.3 era **parcialmente correcta**: esos campos viven en el data
flash del pack y el reset del EC no los restauró. **Pero no impedían cargar.**
El bloqueo estaba en el estado del EC, no en ellos.

### 17.4 Secure Boot NO se reactivó — CONFIRMADO

```
UEFISecureBootEnabled = 0
```

Sigue desactivado, y el usuario confirma que **no entró a la BIOS**.

**Muere la hipótesis de §12.3:** el reset de EC del MS-1585 **no toca la
NVRAM/CMOS**. La preocupación que ordenó toda la escalera de riesgo era
infundada. Queda anotado: el freno estaba bien puesto —no se sabía— pero apuntaba
a un impacto que este procedimiento no produce.

### 17.5 El ciclo de arranque, y la diferencia con la vez pasada

Tras enchufar, el equipo mostró el logo MSI ~1 s y se apagó, **tres veces**. En
la cuarta arrancó normal. `Kernel-Boot 27 = 0x0` a las 18:49:26.

**El usuario no tocó nada durante el ciclo.** Es la única diferencia operativa
con el intento anterior (informe previo, paso 6: pulsación del botón en medio
del ciclo), y esta vez **no apareció Secure Boot Violation**.

Grado: **PROBABLE** que la pulsación fuera lo que rompió la NVRAM la vez pasada.
Un caso no es prueba, pero ahora hay un control: mismo procedimiento, sin la
pulsación, sin el daño.

### 17.6 Auditoría del éxito — por qué funcionó

Regla: un éxito que no se sabe explicar es una coincidencia sin descubrir. Acá
está explicado:

- El EC guardaba estado corrupto del gauge desde el 21/08.
- **Sólo se limpia perdiendo alimentación.** Los pasos 1 y 2 fallaron porque un
  apagado por software **no** desalimenta el EC (§12.1 lo anticipaba y §14.4 lo
  confirmó por experimento). El botón 60 s sin AC sí lo hace.
- Los saltos aparentemente imposibles tienen explicación mecánica:
  - `Voltage` 10.036 -> 11.773 en minutos = **voltaje terminal bajo carga**. Con
    26 W entrando el voltaje sube al instante; no es energía acumulada.
  - `Rem` 171 -> 1.972 = **el gauge recalculó su estimación** al reinicializarse.
    No cargó 1.800 mWh en minutos.

Sin cabos sueltos: no queda ningún paso del procedimiento cuyo efecto no se
entienda.

### 17.7 Lo que falta

1. **Recalibrar:** cargar al 100 % y dejarla enchufada **2 h más** sin
   desconectar.
2. **La causa raíz sigue viva.** Lo que vació el pack fue **Modern Standby**
   (§11.2): esta máquina no tiene S3 y cerrar la tapa no la suspende. Si se
   repite una noche larga sin cargador, se repite todo esto.

---

## 18. CORRECCIÓN a §17.2: el medidor NO se reinicializó — 2026-08-23

### 18.1 El error

§17.2 afirmó **CONFIRMADO** que `DesignVoltage` había dejado de espejar
`Voltage`, con una sola lectura (11.792 vs 11.773, 19 mV de diferencia) tomada
justo cuando arrancaba la carga.

**Repetí exactamente el error de la lección registrada tras §10.5**: declarar
confirmado a partir de una lectura, no de una serie estable.

### 18.2 La prueba correcta

Fuente: `datos-crudos/` (sesión 2026-08-23), 6 muestras cada 1,5 s, con
`Win32_Battery` y `BatteryStatus` consultados por separado y con timestamp de
cada subconsulta:

```
DesignV=12210  Voltage=12210  Diff=0
DesignV=12210  Voltage=12210  Diff=0
DesignV=12211  Voltage=12211  Diff=0
DesignV=12210  Voltage=12210  Diff=0
DesignV=12211  Voltage=12211  Diff=0
DesignV=12210  Voltage=12210  Diff=0
```

**`DesignVoltage` sigue exactamente `Voltage`, muestra a muestra, incluido el
ruido de ±1 mV.** Nunca dejó de espejar. Los 19 mV de diferencia de §17.2 se
explican por el **salto de tensión por caída IR** al arrancar la corriente de
carga — ocurre en milisegundos, y las dos subconsultas WMI (`Win32_Battery` y
`BatteryStatus` son namespaces distintos, dos llamadas separadas) cayeron a
ambos lados de ese salto. No fue el gauge reinicializándose: fue timing.

### 18.3 Qué cambia y qué no

**Se cae:** que el bloque de datos del gauge se haya restaurado. `DesignVoltage`
sigue sin servir como fuente de la configuración del pack — la inferencia 3S de
§17.2 pierde su respaldo (vuelve a ser lo que ya era: razonable, no medida).

**No cambia:** el resultado real. La batería **cargó de 0 a 100 %**, con
`Charging=True` y ~27 W sostenidos toda la curva (ver `datos-crudos/
bateria-carga-2026-08-22.txt`, 9 muestras limpias). Eso no depende de que
`DesignVoltage` se haya arreglado. **El EC reset resolvió el problema real —
que no cargaba— por el mecanismo correcto:** perder alimentación limpió el
estado atascado. Sólo estaba mal explicado un detalle secundario.

`SerialNumber` y `CycleCount` siguen vacíos, como ya anotaba §17.3.
