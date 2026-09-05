# Handoff — Clase Asincrónica 3

**Escrito el:** 2026-09-04 · **Fase al cerrar:** 1 (construcción) **cerrada**;
fase 2 (segunda pasada y redacción) abierta.

## Arrancá por acá

**PRIMERO: el push quedó pendiente.** El 2026-09-04 no había red a
`github.com` (dos intentos, `Failed to connect ... after 21 s`). Los commits
están hechos **en local**, en los dos repos:

```bash
cd C:\Users\frans\Desktop\claude-acceso   && git push origin main
cd C:\Users\frans\Desktop\claude-acceso\perfil-global && git push origin main
```

`claude-acceso` → `cd915b0` · `perfil-global` → `1efea67`. Mientras eso no
suba, el trabajo existe en un solo disco.

Después:

```bash
cd proyectos/documentos/clase-asincronica-3
python verificar.py
```

Tiene que decir `[OK] 97 controles, todos dentro de 2%`. Tarda unos 40
segundos: regenera los diecisiete `.asc` y los corre en LTspice.

**Medir antes de leer.** Si `verificar.py` da rojo, lo que sigue de este archivo
describe un estado que ya cambió, y lo primero es entender por qué — no seguir
el plan.

## Lo que quedó a medias

Nada a medias en la fase 1: los diecisiete archivos están generados, corridos y
verificados, y el verificador está probado rompiéndolo.

Lo que **no** se empezó, y es la fase 2:

1. **Las cinco preguntas de "Para pensar"** de la última página de la guía. Hay
   que contestar **dos**, en un párrafo cada una. Ninguna está escrita. Las dos
   más baratas de contestar con lo que ya está medido:
   - *"¿Qué error conceptual puede quedar oculto si sólo se observa la forma
     cualitativa de una curva simulada?"* → el material está en el 8.1 (una
     sobreamortiguada que cruza el cero se ve "igual de rara" que una que
     oscila) y en el X3 (un cambio de régimen que no se ve en la curva).
   - *"¿Qué efectos podrían tener las tolerancias, la temperatura y el
     envejecimiento sobre α, τ y ω₀?"* → el X2 tiene el escenario de
     envejecimiento medido (fuga de 10 M a 100 k → τ de 39,98 a 38,46 ms) y el
     X3 tiene el argumento de que el amortiguamiento crítico es una condición de
     medida cero que cualquier tolerancia rompe.

2. **La carpeta de entrega.** El punto 3 del entregable mínimo pide *"captura
   legible del circuito implementado en el simulador"* y el punto 5 *"gráficas
   con nombres de señales, unidades y cursores"*. Eso **hay que sacarlo a mano
   desde la GUI**: no hay forma de generarlo en batch. Cada `.asc` dice
   exactamente qué graficar y en cuántos paneles.

## Lo que NO hay que volver a intentar

- **`Rser=0` en las bobinas.** Rompe el 6.2 y el 7.8 con `over-defined circuit
  matrix`. Va `Rser=1u`, que está puesto y documentado.
- **Editar un `.asc` a mano.** Se pierde en la próxima corrida de
  `verificar.py`. Se edita `herramientas/*.py`.
- **Generar `.plt`.** Ver `ESTADO_ACTUAL.md`, callejones sin salida.
- **Leer los `.raw` binarios.** LTspice mezcla `double` y `float`; se corre con
  `-ascii`.
- **Sacar una pendiente restando dos muestras vecinas** de una curva simulada.
  Ver el 8.38.
- **"Ajustar" un esperado de `verificar.py` para que pase.** Si un control da
  rojo, el problema está en el circuito o en la cuenta.

## Datos que no se pueden aproximar

- **LTspice 26.0.1 for Windows**, en
  `C:\Users\frans\AppData\Local\Programs\ADI\LTspice\LTspice.exe`.
  Batch: `LTspice.exe -b -ascii archivo.asc`.
- Los símbolos están en `C:\Users\frans\AppData\Local\LTspice\lib\sym\`.
  Pines en R0, del campo `PIN` de cada `.asy`:
  `res` y `ind` → (16,16) y (16,96) · `cap` → (16,0) y (16,64) ·
  `voltage` → (0,16) y (0,96) · `current` y `bi` → (0,0) y (0,80) ·
  `sw` → (0,16), (0,96), y los de mando (−48,80) y (−48,32).
  Rotación: `R90 (x,y)→(−y,x)` · `R180 (−x,−y)` · `R270 (y,−x)`.
- **El libro** es `C:\Users\frans\Downloads\CIRCUITOS ELECTRICOS NILSSON Y
  RIEDEL.pdf`, 1045 páginas, **escaneado sin capa de texto**. Hay que
  renderizarlo a imagen para leerlo (PyMuPDF). El desplazamiento es
  **página del PDF = página del libro + 27**. Problemas del cap. 6 desde la
  página 261 del libro (288 del PDF), cap. 7 desde la 317 (344), cap. 8 desde la
  386 (413).
- **La guía original** llegó en `C:\Users\frans\Downloads\SPICE.zip`, con la
  carpeta `SPICE/` de seis `.asc` del profesor y `Guia asincronica RL RC
  RLC.pdf`. Los dos están copiados adentro del proyecto.
- Los `.asc` del profesor traen la ruta
  `C:\Users\Administrator\OneDrive - Universidad Nacional de San Martin\Escritorio\SPICE\`
  en la primera línea del `.log`: son de él, no de una corrida de Fran.
- **El 8.1 tenía una predicción mía equivocada** y está corregida adentro del
  `.asc`: una respuesta sobreamortiguada **sí** cruza el cero una vez, con
  `vC(0)=1 V` e `iL(0)=0`. Lo que distingue a la subamortiguada es que cruza
  infinitas veces. Si alguien "arregla" eso pensando que es un error, lo rompe.

## Si hay que abrir un chat nuevo

```
Proyecto: proyectos/documentos/clase-asincronica-3 (repo claude-acceso, rama main)

QUE LEER, EN ORDEN
  1. proyectos/documentos/clase-asincronica-3/ESTADO_ACTUAL.md  (entero)
  2. proyectos/documentos/clase-asincronica-3/HANDOFF.md        (entero)
  3. proyectos/documentos/clase-asincronica-3/PDP.md, seccion 4
  4. proyectos/documentos/clase-asincronica-3/guia/guia-asincronica-texto.txt,
     ultima pagina ("Para pensar" y "Criterios para las graficas")
  NO leer: los .asc completos (son 14 KB de texto cada uno, y la fase 2 no los
  toca). Si hace falta uno puntual, ltspice/LEEME.md dice cual.

FASE: 2 -- segunda pasada y redaccion.
QUE LA CIERRA: dos de las cinco preguntas de "Para pensar" contestadas por
  escrito, y la carpeta de entrega armada con los .asc, sus .log y las capturas
  de las graficas (punto 3 y 5 del entregable minimo de la guia).

MODELO Y ESFUERZO: Sonnet 5, esfuerzo medium, sin fan-out. Es redaccion contra
  material ya medido y ya escrito, no diseno ni analisis nuevo. Si aparece
  fisica nueva que discutir, ahi si Opus.

ESTADO DE LA MAQUINA
  LTspice 26.0.1 en %LOCALAPPDATA%\Programs\ADI\LTspice\LTspice.exe
  Los .raw y los .net NO estan en git (178 MB): se regeneran con verificar.py.
  Los .log SI estan, y son la evidencia de la fase 1.

YA RESUELTO -- NO REHACER
  Los 17 .asc: generados, corridos, 97 controles en verde, verificador probado
  rompiendolo (5 sabotajes detectados). Las tres hojas de no idealidades (X1,
  X2, X3) ya contestan las cuatro preguntas de la segunda pasada adentro de
  cada archivo: para las preguntas de "Para pensar" hay que LEER de ahi, no
  volver a medir.

PRIMER COMANDO
  cd proyectos/documentos/clase-asincronica-3 && python verificar.py
```
