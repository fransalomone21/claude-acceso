# Paso a paso — qué hacer y en qué orden

**Para Fran y Kevin.** Versión 2 (simplificada), 5 de octubre de 2026. Fuente
en el repo: `proyectos/ingenieria/telescopio/docs/11-paso-a-paso.md`.

> **Esto es sólo lo que hay que hacer.** El porqué está en «1 - El proyecto».
> **Hoy no se corta, no se suelda y no se compra nada grande.** Primero hay que
> cerrar un número: la **altura del centro de masa** (hoy «63 cm, pero puede ser
> entre 58 y 69»). De ese número depende la forma de las chapas de aluminio, que
> es lo único que no se arregla después.

## Los pasos

| # | Qué hacer | Quién | Lleva |
|---|---|---|---|
| 1 | Anotar la balanza | Fran | 5 min |
| 2 | **Pesar la montura inclinada** | Fran y Kevin | una tarde |
| 3 | Pesar todo junto, plano (el control) | Fran y Kevin | 1 hora |
| 4 | Medidas chicas y peso de la planchuela | Fran | 30 min |
| 5 | Mirar el inventario de cerca | Fran | 30 min |
| 6 | Imprimir un rodillo de prueba | Kevin | una tarde |
| 7 | Probar el motor sobre la mesa de trabajo | Fran y Kevin | una tarde |
| 8 | Cerrar el centro de masa y rehacer el modelo | yo | una vez |
| 9 | Revisar juntos y elegir el tiempo de foto | Fran y Kevin | una charla |

**En paralelo:** 1, 4, 5, 6 y 7 arrancan todos juntos. El 2 y el 3 esperan al 1.

### 1. Anotar la balanza
Marca y modelo, hasta cuántos kilos pesa, de cuánto en cuánto lee, y una foto
de la etiqueta. Sin eso, los 40 kg son un número sin margen de error.

### 2. Pesar la montura inclinada
Es **el paso importante**. Da la altura del centro de masa.

- **Qué pesás:** la montura **con la caja puesta y sin el tubo** (los 19,7 kg).
- **Qué necesitás:** una tabla rígida de 80 cm, dos caños redondos iguales, la
  balanza de baño, un bloque de la altura de la balanza y otro de 7 cm, y una
  soga o cinta para atar la montura.
- **Cómo:**
  1. Tabla sobre los dos caños, **separados 40 cm**; uno arriba de la balanza, el
     otro sobre el bloque de igual altura. Medí la separación.
  2. Montura en el medio, **bien atada**. Leé la balanza (R_A); pasala al otro
     caño y leé (R_B). La suma tiene que dar ≈ 19,7 kg.
  3. Girá la montura 90° y repetí las dos lecturas.
  4. Volvé a la primera posición, subí la balanza al bloque de 7 cm (la tabla
     queda a unos 10°, **nunca más de 12°**) y leé otra vez (R_A').
     La diferencia tiene que dar entre 3 y 4 kg.
- **Anotá:** todas las lecturas, la separación y la altura del bloque.
- **Seguridad:** uno sostiene y otro lee. Si no confiás en la atada, no inclines.
- **Salió bien si:** la suma da 19,7 ± 0,5 kg y cada lectura repetida da lo mismo.

### 3. Todo junto, plano
Es la prueba del nueve: el paso 2 suma partes y éste mide todo junto. Igual que
el 2, pero con el tubo puesto (horizontal, trabado, **sin cámara**) y **sin
inclinar** (40 kg inclinados son peligrosos para nada). Entre dos.
**Salió bien si:** la masa da 40 ± 0,5 kg y el centro de masa coincide con el
del paso 2 más el tubo dentro de 1 kg y 1 cm. Si no coincide, **se frena y se
busca el error**.

### 4. Medidas chicas
Con cinta o calibre, y anotá con qué:
**(a)** el hueco entre la base fija y la móvil; **(b)** del borde de la pared al
centro del rulemán del eje de altura; **(c)** el espesor de cada planchuela (30,
40, 50 y 60 mm); **(d)** el peso de 1 metro de cada una y cuántos metros hay.
Con (d) sabemos cuánto pesa la mesa de verdad (hoy es una estimación de 8 kg).

### 5. Inventario
Mirá de cerca con luz y sacale una foto **donde se lea el texto**:
rulemanes (¿cuántos y qué dice? `608ZZ`), Arduino Nano (¿original o clon?),
la placa «HW-130» por los dos lados, la fuente de 12 V (cuántos amperes),
tuercas mariposa M8 y bulones M8 (cuántos), escuadra y nivel.

### 6. Rodillo de prueba (Kevin)
Un cilindro de **32 mm de diámetro por 26 mm de ancho**, agujero de 8 mm, y en
cada cara un alojamiento de 22 mm y 7 mm de profundidad para un rulemán 608ZZ
(+0,1 o 0,2 mm de holgura). PETG, 4 paredes, 50 % de relleno.
**Salió bien si:** los dos rulemanes entran a presión con la morsa, el rodillo
gira libre sin juego, y mide 32 ± 0,2 mm.

### 7. Motor sobre la mesa de trabajo
Se compran el **motor NEMA 17 de ≈ 4 kg·cm** (≈ $24.640) y el **driver TMC2209**;
el Arduino Nano y la fuente 12 V ya están. Un programa le da pasos al ritmo del
cielo: con la reducción 4:1 es **un pasito cada dos segundos** (0,46 por segundo).
**Dos cuidados:** nunca conectes ni desconectes el motor con la fuente
prendida (se quema el driver), y regulá la corriente del driver debajo de la del
motor (empezá en 1 A) con un disipador.
**Salió bien si:** gira parejo y silencioso 10 minutos, y a los 10 minutos dio
**275 pasos** (1,4 vueltas; marcalo con fibrón).

### 8. Cerrar el centro de masa (yo)
Con las lecturas del 2 y el 3 calculo el centro de masa, rehago el modelo,
republico al mismo link y actualizo estos documentos.

### 9. Revisar juntos
Con el modelo abierto: ¿el dobson entra sobre los largueros?, ¿la base de 1,2 m
se desarma y entra en el baúl?, ¿se parece a lo que tienen en el patio?
Y una decisión **que sólo Fran puede tomar**: **¿cuánto tiempo querés dejar abierto
el obturador por foto?** (30 s, 1 min, 2 min). Cuanto más largo, más exacta
tiene que ser la plataforma. Con eso se abre la fase 1.

## La cámara y el foco están aparcados

Ningún paso de arriba usa la cámara. Queda abierta la prueba de foco (10 minutos
de día) y **hay que cerrarla antes de comprar el aluminio ($66 mil)**. Cuando
vuelva la cámara, pesa 0,5 kg: se rebalancea el tubo 1 o 2 cm hacia la cola.

## Después (resumen)

| Fase | Qué se hace | Termina cuando |
|---|---|---|
| 1 | cuenta de cuánto error se tolera, según el tiempo de foto | la cuenta cierra |
| 2 | preparar el dobson para subir a la mesa (ranuras, mariposas) | el centro de masa, medido de nuevo, cae en el eje |
| 3 | planos 1:1, lista de corte y compras cotizadas; **se cierra la prueba de foco** | plantillas y lista listas |
| 4 | construir y calibrar (tabla de abajo) | una estrella sale redonda en 60 s y la mesa corre 60 min sola |
| 5 | la foto | existe la imagen |

## Construir y calibrar (fase 4, formal)

Cada paso pasa su criterio de aceptación o no está hecho.

| Paso | Qué se hace | Aceptación |
|---|---|---|
| FAB-1 | imprimir la plantilla 1:1 de las chapas a escala 100 % | la regla impresa mide 300 mm ±0,5 |
| FAB-2 | cortar y armar base, mesa y brazo (soldar lo fijo, abulonar lo que se desarma; prensas, punteo y tramos cortos) | diagonales de la mesa iguales ±2 mm y la mesa apoya plana |
| FAB-3 | patas y pivote | la base no se mueve al apretar cada esquina |
| FAB-4 | rodillos con sus rulemanes | giran libres, sin juego ni puntos duros |
| FAB-5 | calar y limar las chapas de aluminio | el canto copia la plantilla ±0,5 mm |
| FAB-6 | montar las chapas en la mesa | la mesa rueda sin saltos y frena en los dos talones |
| FAB-7 | electrónica y dos switches **normalmente cerrados** | cada switch apretado lo detiene, y un cable cortado también |
| FAB-8 | fijar el dobson a los largueros (bulón fresado, buje, mariposa) | un empujón fuerte no lo mueve |
| CAL-1 | balancear: mesa en 5 posiciones, motor desacoplado | en las cinco se queda quieta |
| CAL-2 | velocidad: 10 minutos con cronómetro | el giro difiere del cielo en menos de 0,5 % |
| CAL-3 | probar cada tope por separado | las tres capas frenan solas |
| CAL-4 | alineación polar por deriva | la estrella no se corre más de 3 píxeles en 60 s |
| CAL-5 | fotos de 30 s, 60 s y 2 min | estrellas redondas en la de 60 s |
