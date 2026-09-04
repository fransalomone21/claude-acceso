# Clase Asincrónica 3 — contrato de contexto

Resolución completa de la **Actividad Asincrónica** de *Teoría de Circuitos
para Sistemas Espaciales* (UNSAM): bobinas, capacitores y circuitos RL, RC y
RLC. Doce problemas de **Nilsson y Riedel**, capítulos 6, 7 y 8, cada uno
resuelto a mano y contrastado con **LTspice**.

**Naturaleza:** `documentos` — ver
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md)
para lo que se lee siempre en esta clase de proyecto.

**El plan y las fases están en [`PDP.md`](PDP.md).** Este archivo no los
repite: un dato que vive en dos lados diverge.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber en qué anda | `ESTADO_ACTUAL.md` (entero — es corto) |
| saber qué sigue y qué la cierra | `PDP.md`, sección 4 |
| usar o entregar las simulaciones | [`ltspice/LEEME.md`](ltspice/LEEME.md) |
| entender un problema puntual | el `.asc` de ese problema, **y nada más** |
| agregar o corregir una simulación | `herramientas/asc.py` y el `bloque*.py` que corresponda |
| saber qué pide la cátedra | `guia/guia-asincronica-texto.txt` |

**No leas todo "por las dudas".** Cada `.asc` es autosuficiente a propósito:
esa es la regla de abajo.

## Las reglas propias de este proyecto

1. **La explicación vive adentro del `.asc`, no en un README.** Un README no se
   abre cuando alguien hace doble clic en un esquemático, y así es como se usa
   un archivo de simulación. Todo lo que la guía pide registrar —el circuito, la
   configuración del análisis, cómo se arma cada gráfica, la comparación contra
   el cálculo— va como comentarios de LTspice (`;`) en la propia hoja.

2. **Los `.asc` no se editan a mano.** Se editan `herramientas/*.py` y se
   regeneran, para que las diecisiete hojas no diverjan entre sí. Un archivo
   tocado a mano se pierde en la próxima corrida de `verificar.py`, sin aviso.

3. **La predicción se escribe antes de correr la simulación**, y va en el bloque
   `CONTROL` del `.asc`. Si un `.meas` no da lo predicho, se corrige el circuito
   o la cuenta — nunca la predicción a posteriori, y nunca la tabla de
   `verificar.py`. Cuando la equivocada resultó ser la predicción (pasó una vez,
   en el 8.1), se corrige la predicción **y** queda escrito que se corrigió.

## Cómo se verifica

```bash
python verificar.py                 # regenera, corre los 17 y compara 97 controles
python verificar.py --sin-correr    # sólo compara los .log que ya están
python probar-verificador.py        # rompe el verificador y exige ver el rojo
```

`probar-verificador.py` mete cinco defectos de clases distintas, exige rojo en
los cinco, restaura, y **vuelve a correr el verificador entero**. Esa última
pasada no es adorno: restaurar el fuente no alcanza, porque los `.asc` y los
`.log` generados quedan con el sabotaje adentro. Es la misma ceguera que ya
costó una vez en `probar-chequeo-lecciones.ps1`.

## Dónde está cada cosa

```
guia/             la consigna de la catedra (PDF + texto extraido)
ltspice/          los 17 .asc, sus .log, y LEEME.md con la tabla de resultados
ltspice/catedra/  los 6 .asc originales del profesor, sin tocar
herramientas/     asc.py (geometria de los simbolos), comun.py (texto
                  compartido), generar.py + bloque2.py + bloque3.py
verificar.py · probar-verificador.py
PDP.md · CLAUDE.md · ESTADO_ACTUAL.md · HANDOFF.md
```

## Dónde corre esto

**LTspice 26.0.1 for Windows**, en
`%LOCALAPPDATA%\Programs\ADI\LTspice\LTspice.exe`. Sin eso, `verificar.py` no
puede correr nada, y lo dice en vez de inventar resultados.

Las coordenadas de los pines que usa `asc.py` salen de
`%LOCALAPPDATA%\LTspice\lib\sym\*.asy`, campo `PIN` — no de adivinar mirando un
dibujo.

Los `.raw` (178 MB entre los diecisiete) y los `.net` están en `.gitignore`: se
regeneran en 40 segundos. Los `.log` **sí** se commitean, porque son la
evidencia de qué dio cada corrida y con qué versión.

## Al cerrar cualquier sesión

1. `python verificar.py` en verde **antes** del commit.
2. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
3. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
4. Commit y push a `main`.
