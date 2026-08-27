# Ajustes manuales en el teléfono

Lo que ADB no puede tocar y hay que hacer a mano. Ordenado por **impacto real**, no por
lo que suele repetirse en los blogs. Los nombres de menú son de One UI 7/8; en versiones
anteriores están casi en el mismo lugar.

---

## Batería

### 1. Límites de uso en segundo plano — el ajuste que más rinde

`Ajustes > Batería > Límites de uso en segundo plano`

Samsung tiene cuatro cajones y casi nadie los usa bien:

| Cajón | Qué hace | Qué poner adentro |
|---|---|---|
| **Apps en suspensión** | La app no corre en segundo plano, sí abre normal | Todo lo que uses menos de una vez por semana |
| **Apps en suspensión profunda** | Nunca corre sola, cero notificaciones | Juegos, apps de viaje, trámites, compras |
| **Apps nunca en suspensión** | Excepción total | Solo mensajería y despertador |
| **Poner apps sin usar en suspensión** | Automático | **Activado** |

Regla práctica: **nada de banco, mensajería ni despertador en suspensión profunda**, o vas a
perder avisos importantes. Todo lo demás, adentro sin culpa.

### 2. Optimización adaptativa

`Ajustes > Batería > Más ajustes de batería > Batería adaptativa: ON`

Aprende tu rutina en unos días y recorta la actividad de lo que no tocás. Necesita
una semana para dar resultados, no lo juzgues al día siguiente.

### 3. Ahorro de energía bien configurado

`Ajustes > Batería > Ahorro de energía`

En One UI 8.5 hay dos niveles, Estándar y Máximo. Lo útil es entrar en las opciones
y activar solo **"Limitar velocidad de CPU al 70%"**: se nota poquísimo en uso normal
y baja bastante el consumo. Dejá el brillo y los datos en segundo plano sin tocar,
porque ahí sí molesta.

### 4. Frecuencia de refresco

`Ajustes > Pantalla > Fluidez de movimiento > Estándar (60 Hz)`

Es el cambio con **más impacto medible** de toda la lista. Pasar de 120 Hz a 60 Hz
suele dar entre 15 % y 25 % más de autonomía. Es también el más notorio al usar el
teléfono, así que probalo unos días y decidí vos si vale el intercambio.

### 5. Resolución

`Ajustes > Pantalla > Resolución de pantalla > FHD+`

Solo aplica a modelos QHD+ (línea S Ultra, Note, Fold). A distancia normal no se ve la
diferencia y la GPU trabaja bastante menos.

### 6. Always On Display

`Ajustes > Pantalla > Always On Display`

Si lo querés, ponelo en **"Mostrar al tocar"**. Encendido permanente cuesta entre 3 % y
8 % de batería por día para algo que mirás dos segundos por hora.

### 7. Ubicación

`Ajustes > Ubicación > Servicios de ubicación`

Apagá **"Búsqueda de Wi-Fi"** y **"Búsqueda de Bluetooth"**. Con eso el teléfono deja de
escanear el entorno cuando tenés Wi-Fi y BT apagados. (El script `optimizar` también lo
hace, pero One UI a veces lo revierte tras una actualización: revisalo cada tanto.)

### 8. Sincronización

`Ajustes > Cuentas y copia de seguridad > Administrar cuentas`

Entrá en cada cuenta y desactivá lo que no usás. Una cuenta de Google sincronizando
catorce servicios despierta la radio constantemente.

---

## Rendimiento

### 9. Modo de procesamiento

`Ajustes > Batería > Más ajustes de batería > Modo de procesamiento`

Poné **Estándar**. "Alto" solo tiene sentido si jugás fuerte, y calienta bastante.

### 10. Sacar Game Optimizing Service del medio

Si jugás, el GOS de Samsung limita el rendimiento de los juegos por temperatura. Si no
jugás, es un servicio corriendo al pedo. El script `debloat opcional` te lo ofrece.

### 11. Espacio libre

Android necesita **al menos 10-15 % del almacenamiento libre** para escribir sin
fragmentar. Por debajo de eso el teléfono se arrastra por más que lo optimices. Si estás
al límite, esto es más importante que cualquier otro ajuste de esta guía.

### 12. Widgets y pantalla de inicio

Cada widget que se actualiza solo es un proceso vivo. El clima con actualización cada
15 minutos cuesta más de lo que parece.

---

## Seguridad

### 13. Auto Blocker

`Ajustes > Seguridad y privacidad > Auto Blocker: ON`

Es gratis, es de Samsung y no molesta. Bloquea la instalación desde fuentes no
autorizadas, analiza apps y bloquea comandos por USB. Encendelo sí o sí.

**Restricciones máximas** (dentro de Auto Blocker) además bloquea apps de administración
de dispositivo y redes 2G — las 2G son la vía de los interceptores IMSI. Es un buen
nivel de protección, pero **desactivalo antes de usar este kit** porque bloquea ADB.

### 14. Play Protect

`Play Store > tu foto > Play Protect > Analizar`

Activá también **"Mejorar detección de apps dañinas"**. Escanea gratis y todo el tiempo.

### 15. Revisión de permisos

`Ajustes > Seguridad y privacidad > Administrador de permisos`

Mirá especialmente **SMS**, **Teléfono**, **Accesibilidad** y **Ubicación**. Si una app
sin motivo aparente tiene SMS, sacáselo: es cómo se roban los códigos 2FA.

### 16. Actualizaciones

`Ajustes > Actualización de software > Descargar e instalar`

Activá la descarga automática. Un parche de seguridad de más de seis meses te deja
expuesto a fallos que ya son públicos y tienen exploit disponible.

---

## Lo que NO hay que hacer

- **No instales apps "cleaner", "booster" ni "RAM optimizer".** Están medidas: aumentan
  el uso de CPU en segundo plano y el consumo en reposo, además de que varias
  históricamente terminaron siendo adware o algo peor. Android ya gestiona su RAM;
  la RAM libre no sirve para nada.
- **No uses "cerrar todas las apps" como rutina.** Matar una app que Android tenía
  cacheada obliga a recargarla entera después: gastás más batería, no menos.
- **No borres la carpeta `.nomedia` ni carpetas `Android/data` a mano.** Rompés apps.
- **No instales APKs de "Samsung optimizado" ni módulos de terceros.** Es la vía de
  entrada más común de malware en Galaxy.
