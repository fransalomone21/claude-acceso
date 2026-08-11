# acceso

Kit de diagnóstico, limpieza y optimización para teléfonos **Samsung Galaxy**, vía ADB
desde una PC. Sin root, sin apps de terceros en el teléfono y todo reversible.

No "acelera" el teléfono con magia. Hace tres cosas concretas y medibles: te muestra
exactamente qué está consumiendo batería y espacio, saca del medio lo que no usás, y
audita el equipo buscando las señales que deja el malware real.

---

## Requisitos

- Un Samsung Galaxy con **Depuración por USB** activada.
- Una PC con **[Android Platform Tools](https://developer.android.com/tools/releases/platform-tools)** (`adb` en el PATH).
- Bash: nativo en Linux y macOS; en Windows usá **Git Bash** o **WSL**.

Activar la depuración en el teléfono:

1. `Ajustes > Información del teléfono > Información de software`
2. Tocá **Número de compilación** siete veces.
3. `Ajustes > Opciones de desarrollador > Depuración por USB: ON`
4. Conectá el cable, elegí **Transferencia de archivos** y aceptá el diálogo de autorización.

> Si tenés Auto Blocker en Restricciones máximas, desactivalo mientras usás el kit:
> bloquea las conexiones ADB a propósito. Volvé a activarlo al terminar.

---

## Uso

```bash
chmod +x acceso.sh
./acceso.sh todo          # los cuatro diagnósticos, sin modificar nada
```

Todos los informes quedan en `informes/` con fecha y hora.

### Comandos

| Comando | Qué hace | ¿Modifica? |
|---|---|---|
| `diagnostico` | Hardware, Android, batería, almacenamiento, RAM, apps, integridad Knox | No |
| `seguridad` | Auditoría antimalware y de privacidad | No |
| `bateria` | Consumo por app, wakelocks, alarmas, Doze | No |
| `bateria reset` | Pone los contadores a cero para medir limpio | Contadores |
| `bateria informe` | Bugreport para Battery Historian | No |
| `limpieza` | Muestra la basura acumulada | No |
| `limpieza ejecutar` | Vacía cachés, miniaturas y temporales | Sí — nunca tus archivos |
| `debloat` | Lista el bloatware presente en tu equipo | No |
| `debloat aplicar` | Elimina el nivel 1 (seguro) | Sí — reversible |
| `debloat opcional` | Nivel 2, preguntando app por app | Sí — reversible |
| `optimizar` | Muestra los ajustes propuestos | No |
| `optimizar aplicar` | Animaciones, escaneos pasivos, recompilación | Sí — reversible |
| `restringir <pkg>` | Corta el segundo plano de una app | Sí — reversible |
| `restaurar` | Reinstala todo lo que quitó el debloat | Sí |

Nada que modifique el teléfono corre sin que escribas `CONFIRMO`.

---

## Qué busca la auditoría de seguridad

No es un antivirus por firmas: busca las **capacidades** que necesita el malware
Android para hacer daño, que es lo que sobrevive a que el binario cambie.

- Apps instaladas fuera de Play Store o Galaxy Store (navegador, mensajería, APK suelto).
- Servicios de **Accesibilidad** activos — leen toda tu pantalla y tocan por vos. Es el
  permiso de los troyanos bancarios.
- **Administradores de dispositivo** — pueden bloquear o borrar el teléfono y resisten
  la desinstalación.
- **Lectores de notificaciones** — ven tus códigos 2FA.
- Apps con `REQUEST_INSTALL_PACKAGES` — los droppers instalan el payload real.
- Apps con `SYSTEM_ALERT_WINDOW` — superponen pantallas de login falsas.
- Permisos de SMS, micrófono, cámara, ubicación y contactos en apps de terceros.
- **Proxy HTTP global** y VPNs no configuradas por vos.
- Integridad del arranque: Knox, bootloader, verified boot, binario `su`.

---

## Por qué el debloat es seguro

Se usa `pm uninstall -k --user 0`. Eso **no borra el APK**: lo desinstala solo para tu
usuario y lo deja en la partición del sistema.

- Se revierte entero con `./acceso.sh restaurar` (`cmd package install-existing`).
- Un reinicio de fábrica también lo devuelve todo.
- No requiere root, no toca el bootloader, **no quema Knox y no afecta la garantía**.

Tres capas de protección:

1. **`datos/NO-TOCAR.txt`** — lista de paquetes críticos que el script se niega a
   eliminar aunque los agregues por error a otra lista.
2. **Niveles separados** — el nivel 1 es bloat puro sin dependencias; el nivel 2 se
   pregunta app por app.
3. **Registro** — cada paquete eliminado se anota en `informes/paquetes-eliminados.txt`.

---

## Estructura

```
acceso.sh              lanzador
lib/comun.sh           funciones compartidas y guardas de seguridad
modulos/               un archivo por función
datos/
  NO-TOCAR.txt         paquetes críticos, bloqueados por el script
  nivel1-seguro.txt    bloatware sin dependencias
  nivel2-opcional.txt  apps que quizá usás — se preguntan una por una
docs/
  ajustes-manuales.md  lo que hay que tocar a mano en el teléfono
  para-vos.md          decisiones y tareas que te tocan a vos
informes/              salida de cada ejecución, con fecha
```

---

## Leé esto también

- **[docs/ajustes-manuales.md](docs/ajustes-manuales.md)** — los ajustes de One UI que
  más rinden, ordenados por impacto real. Varios superan a cualquier cosa que haga este kit.
- **[docs/para-vos.md](docs/para-vos.md)** — backup, antivirus, salud de batería y las
  decisiones que no puede tomar un script.

---

## Fuentes

- [Android Platform Tools](https://developer.android.com/tools/releases/platform-tools) · [Battery Historian](https://developer.android.com/topic/performance/power/battery-historian) · [Test power-related issues](https://developer.android.com/topic/performance/power/test-power)
- [Samsung Auto Blocker](https://www.samsung.com/latin_en/support/mobile-devices/protect-your-galaxy-device-with-the-new-auto-blocker-feature/) · [Samsung Knox — Auto Blocker](https://docs.samsungknox.com/admin/fundamentals/whitepaper/samsung-knox-mobile-security/system-security/samsung-auto-blocker/)
- [Universal Android Debloater NG](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation) · [Samsung Android Debloat List](https://github.com/Willie169/Samsung-Android-Debloat-List)
- [AV-TEST Android — 2026](https://www.av-test.org/en/antivirus/mobile-devices/)
