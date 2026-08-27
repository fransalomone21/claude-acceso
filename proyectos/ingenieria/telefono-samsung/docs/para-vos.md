# Cosas que tenés que hacer vos

Todo lo que no puedo hacer desde acá, o que no correspondería que haga sin que lo
decidas vos. Ordenado por prioridad.

---

## 1. Antes de conectar el teléfono

**Hacé un backup.** Nada de este kit borra datos tuyos, pero cualquier trabajo sobre el
sistema merece red de seguridad.

- Fotos y videos → Google Fotos o copiar la carpeta `DCIM` a la PC.
- WhatsApp → Ajustes > Chats > Copia de seguridad > Guardar ahora.
- Samsung → Ajustes > Cuentas y copia > Smart Switch > Copia de seguridad a PC.

**Anotá tus contraseñas de Samsung y Google.** Si algo sale mal y hay que hacer un
reinicio de fábrica, el bloqueo de activación (FRP) te pide la cuenta de Google que
estaba configurada. Sin esa contraseña el teléfono queda inutilizable.

**Desactivá Auto Blocker temporalmente** si lo tenés en Restricciones máximas: bloquea
la conexión ADB. Volvé a activarlo al terminar.

---

## 2. Instalar las Platform Tools (5 minutos)

Es lo único que necesitás instalar en la PC. Vienen de Google, no de terceros.

**Descarga oficial:** https://developer.android.com/tools/releases/platform-tools

- **Windows**: descomprimí el ZIP en `C:\platform-tools`. Necesitás además
  [Git for Windows](https://git-scm.com/download/win) para tener Git Bash y poder
  correr los scripts. Si Windows no reconoce el teléfono, instalá también el
  [driver USB de Samsung](https://developer.samsung.com/android-usb-driver).
- **macOS**: `brew install --cask android-platform-tools`
- **Linux**: `sudo apt install android-tools-adb` (o `pacman -S android-tools`)

Verificá con `adb devices`: tiene que aparecer tu serial y la palabra `device`.

---

## 3. Antivirus: cuál instalar y cuál no

**La verdad primero:** con Play Protect activo, Auto Blocker encendido y sin instalar
APKs de fuera, el riesgo real es bajo. Un antivirus permanente cuesta batería. Mi
recomendación es un escaneo puntual ahora y después vivir sin residente.

**Para el escaneo puntual — elegí uno:**

- **Bitdefender Mobile Security** — 6/6 en protección en AV-TEST, prueba gratis de
  14 días, huella muy liviana. Es el que usaría.
- **ESET Mobile Security** — resultados de laboratorio muy sólidos y el menor consumo
  de RAM del grupo (~70 MB). Buena opción si querés dejar algo instalado.
- **Malwarebytes** — versión gratuita muy buena para un escaneo único; el residente es
  de pago.

**Evitá:** cualquier app que se llame "Cleaner", "Booster", "Speed", "RAM Master",
"Antivirus Gratis" de desarrollador desconocido, y todo lo que prometa "acelerar" el
teléfono. Esa categoría concentra adware y troyanos. Si alguna te aparece instalada,
el módulo `seguridad` te la va a marcar.

**Si el escaneo encuentra algo:** no lo borres desde el antivirus todavía. Primero
corré `./acceso.sh seguridad` y fijate si esa app tiene accesibilidad o administrador
de dispositivo activo. Si los tiene, hay que sacarle esos permisos **antes**, o no se
va a dejar desinstalar.

---

## 4. Salud de la batería — decisión de hardware

El módulo `diagnostico` te dice la capacidad restante. Interpretación:

| Salud | Qué significa |
|---|---|
| **> 90 %** | Como nueva. Ningún ajuste te va a dar más que esto. |
| **80-90 %** | Normal. La optimización rinde. |
| **< 80 %** | Degradada. Ningún software lo arregla: es química. |

Si estás por debajo de 80 %, **cambiar la batería es el único cambio con impacto
real** y cuesta mucho menos que un teléfono. Buscá servicio oficial Samsung o un
técnico que use celda original; las genéricas de mercado duran meses.

Para alargar la que tenés:
- Activá `Ajustes > Batería > Más ajustes > Protección de la batería > Básica` (corta la
  carga en 85 %). Perdés algo de autonomía diaria y ganás vida útil.
- Evitá cargar rápido de noche. Carga lenta mientras dormís es lo mejor que le podés dar.
- No la dejes calentar al sol ni cargando con funda gruesa y juego pesado.

---

## 5. Lo que decidís vos, no yo

**Debloat nivel 2.** El script te pregunta app por app justamente porque no sé qué usás.
Samsung Pay con tarjetas cargadas, Samsung Notes con notas adentro o SmartThings con
dispositivos configurados no se tocan sin que lo sepas.

**Cuenta Samsung.** Si no usás ninguno de sus servicios, cerrar sesión corta una
cantidad grande de sincronización de fondo. Pero perdés Find My Mobile, que es
genuinamente útil si te roban el teléfono. Es un intercambio, no una mejora.

**Reinicio de fábrica.** Si el teléfono viene lento hace años y arrastra migraciones de
equipos anteriores, un reset limpio supera cualquier optimización de este kit. Es la
opción nuclear y lleva una tarde de reconfigurar todo. Solo si el resto no alcanzó.

---

## 6. Orden sugerido de trabajo

```
1. Backup + Platform Tools instaladas
2. ./acceso.sh todo               # los cuatro diagnósticos, sin tocar nada
3. Leé los informes de informes/
4. ./acceso.sh limpieza ejecutar  # ganás espacio, riesgo cero
5. ./acceso.sh debloat            # mirá qué propone
6. ./acceso.sh debloat aplicar    # nivel 1
7. Reiniciá el teléfono
8. ./acceso.sh optimizar aplicar
9. Ajustes manuales de docs/ajustes-manuales.md (empezá por el punto 1 y el 4)
10. ./acceso.sh bateria reset     # y medí de nuevo en 2 días
```

Entre el paso 7 y el 8 usá el teléfono un día normal. Si algo se rompió, ya sabés que
fue el debloat y lo revertís con `./acceso.sh restaurar`.

---

## 7. Si algo sale mal

| Síntoma | Solución |
|---|---|
| Una app del sistema crashea | `./acceso.sh restaurar` y reiniciá |
| No funciona el teclado | `adb shell cmd package install-existing com.samsung.android.honeyboard` |
| No hay llamadas o datos | `./acceso.sh restaurar` — probablemente cayó un paquete de operador |
| No arranca la cámara | Restaurá y reiniciá |
| Nada de eso funciona | Reinicio de fábrica: devuelve todos los paquetes del sistema |

Todo lo que hace este kit sobrevive a un reinicio pero **no** a una actualización mayor
de One UI: después de actualizar, los paquetes vuelven y hay que correr el debloat de nuevo.
