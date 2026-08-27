# Plataforma ecuatorial para dobson 200/1200

**Estado: DORMIDO.** No hay trabajo abierto. Antes de retomar, medir el estado
real de las piezas construidas: este documento describe el diseño, no lo que
efectivamente está armado hoy.

**Naturaleza:** `ingenieria` — ver
[`plantillas/naturalezas/ingenieria.md`](../../../plantillas/naturalezas/ingenieria.md).
Los cálculos de este proyecto son predicciones: nada se da por confirmado hasta
que se mide sobre la plataforma real.

> **Nota de estructura (2026-08-27):** vivía suelto en `Desktop\claude\PROYECTO
> TELESCOPIO`, fuera de todo repositorio y sin historial. Ahora está versionado.

## Contexto
Proyecto de astrofotografía. Telescopio newtoniano 200 mm de diámetro, 1200 mm
de focal (f/6), construido en una facultad hace años, montado sobre una base
dobson casera. Cámara Sony ZV-E10 (APS-C, 6000x4000, píxel 3.92 um).
Objetivo: plataforma ecuatorial motorizada para exposiciones largas.
Ubicación: Don Torcuato, Buenos Aires. Latitud de diseño: 34.5 S.

Electrónica disponible: Arduino Nano, placa HW-130, motores y correas GT2
recuperados de impresoras. Presupuesto acotado.

## Medidas del telescopio y la montura (medidas, no estimadas)
- Tubo: 25 cm de diámetro, 135.5 cm de largo
- Base inferior fija: 40 x 43 cm
- Base móvil: 40.5 x 37.5 cm, gira 360 grados sobre niple central
- Paredes grandes: 82 cm de alto x 37.5 cm de ancho
- Paredes chicas: 37.5 cm de ancho x 20 cm de alto
- Ancho total de frente: 44.5 cm
- Eje de altura: 78 cm sobre el piso de la base móvil
- Ancho entre paredes: 37 cm abajo, 36 cm arriba (las paredes flexan)
- Caja sujetadora: 40 cm de ancho x 31 cm de alto
- Sándwich base fija + base móvil: 5 cm de espesor total
- Centro de masa: 59 cm sobre el piso de la base móvil
- Masa estimada del conjunto: 45 kg (pendiente de confirmar)

## Parámetros de diseño ya cerrados
Origen: centro de la cara superior de la tabla móvil de la plataforma.
Eje y positivo hacia el sur, z positivo hacia arriba. Latitud phi = 34.5 grados.

- H (centro de masa sobre la tabla) = 64 cm
- Rodamientos: y_r = +/- 21 cm, z_r = -9 cm
- Radio sector norte = 48.3 cm
- Radio sector sur = 72.0 cm
- Centro de curvatura sobre el eje, desde el centro de masa hacia el norte:
  58.7 cm (norte) y 24.0 cm (sur)
- Recorrido en 60 min: +/- 6.3 cm (norte), +/- 9.5 cm (sur)
- Largo mínimo de sector: 32 cm (norte), 40 cm (sur)
- Tabla móvil: 50 x 50 cm. Base fija: 70 (E-O) x 50 (N-S) cm
- Balanceo lateral de la tabla: +/- 8.4 cm
- Carrera de seguimiento: +/- 7.52 grados = 60 minutos
- Rodamientos 608ZZ sobre bloques inclinados 34.5 grados
- Planos de los sectores perpendiculares al eje polar (inclinados 34.5
  grados respecto de la vertical, con el pie hacia el sur)

### Fórmulas paramétricas
    R = (H - z_r) * cos(phi) + y_r * sin(phi)
    t = y_r * cos(phi) + (z_r - H) * sin(phi)

donde R es el radio del sector y t la posición del centro de curvatura sobre
el eje polar medida desde el centro de masa (negativo = hacia el norte).

## Transmisión
- Brazo tangencial sobre el sector sur, L = 72 cm
- Velocidad: 3.15 mm/min de varilla; 189 mm de recorrido en 60 min
- Varilla roscada M8, paso 1.25 mm, husillo a 2.52 rpm
- Reducción por correa GT2 4:1 desde el motor
- Driver TMC2208 o TMC2209 (comprar; no usar A4988)
- Resorte de precarga contra el juego de la tuerca
- CORRECCIÓN DE TANGENTE OBLIGATORIA: x(t) = L * tan(omega * t), con
  omega = 7.2921e-5 rad/s. Sin esto hay 1.75% de error de velocidad en los
  extremos, equivalente a 16 arcsec de deriva en 60 s.
- Resolución con microstepping 1/16 y reducción 4:1: 0.026 arcsec por micropaso

## Decisiones tomadas
- Arquitectura: plataforma de segmentos circulares (CS) con DOS sectores
  curvos, no sector + pivote. Elegida porque permite poner el eje polar
  exactamente en el centro de masa, lo que anula el momento de gravedad
  sobre el eje en toda la carrera.
- La asimetría de 1.8 cm de la montura NO se corrige cortando madera: se
  compensa desplazando el dobson sobre la tabla de la plataforma.
- La caja sujetadora fuera de escuadra NO se corrige. El error de cono es
  irrelevante porque los ejes se bloquean durante la exposición.
- Los tacos de PVC y el disco de vinilo del eje de azimut se dejan como están.

## Mejoras pendientes en la montura (por prioridad)
1. Reemplazar los tornillos con puntas de goma por dos cunas semicirculares
   de radio 125 mm forradas en corcho o fieltro duro. La goma fluye bajo
   carga y el presupuesto de estabilidad es de 2 micrones en 40 cm de vano.
2. Casquillos rígidos en los ejes de altura para que apretar no cierre las
   paredes.
3. Tornillos de bloqueo en los ejes de altura y azimut (la plataforma se
   inclina hasta 7.5 grados y el telescopio se corre solo).

## Datos pendientes de medir
- Balance lateral del conjunto (corrimiento del centro de masa respecto del
  eje de azimut, se estima 0.9 cm)
- Masa total real
- Diámetro del eje menor del secundario (si es 50 mm, el campo plenamente
  iluminado es de solo 8 mm y las esquinas del APS-C viñetean)
- Coaxialidad de los dos agujeros del eje de altura
- Qué motores exactamente se recuperaron de las impresoras
- Qué es realmente la placa HW-130

## Temas abiertos
- Material del canto de los sectores: multilaminado desnudo vs planchuela
  de aluminio 12x2 mm vs perfil ángulo. Define la suavidad y la vida útil.
- Firmware del Arduino: seguimiento con corrección de tangente, retorno
  rápido, finales de carrera, entradas ópticas tipo ST-4 para PHD2, y
  disparo del obturador de la ZV-E10 por el terminal Multi/Micro USB.

## Expectativas de resultado
- Escala: 0.67 arcsec/píxel. Campo: 67' x 45'
- Sin guiado y con alineación polar de 5 a 10 arcmin: subs de 20 a 30 s
- Con autoguiado: subs de 2 a 4 minutos según el error periódico del husillo

## Primer entregable sugerido
Macro VBA para la API de SolidWorks que genere la geometría paramétrica de
la plataforma, más los perfiles de los dos arcos en DXF para plantilla de
corte 1:1.
