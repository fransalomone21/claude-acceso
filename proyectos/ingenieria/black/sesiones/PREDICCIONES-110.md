# Predicciones de la tanda (110), escritas ANTES de medir

## P1 — percepción de J2 (2026-10-01, antes del prototipo por PINE)
Mecanismo (en frío, `0x0018FBE0`: `a1` = id del blanco): `FUN_0018FB88` sólo anota un blanco si el bit de su id está
en la máscara de percepción `agente+0x6F0+0x2C`, que llena `FUN_00184DE0` recorriendo las 4 ranuras del escuadrón
(`S = *(0x0040F4D4)+0x22800`, `S+0x64..+0x70`: aliados 0–2 y J en la 3). J2 no está → nunca se anota, aunque VER2 lo
pregunte (medido: `con-ia-2`, enemigo a 3 m de J2, bit 0x2 nunca, bit 0x1 a los 0,77 s).
Prototipo: `0x00185184` `slti v0,s3,4` → `slti v0,s3,5` y `S+0x74` = J2 (0 en los 7 volcados).
**Predicción:** un enemigo nacido a ~3 m de J2 tiene el bit 0x2 en `+0x274` y/o el id 1 en una amenaza en < 2 s; el
bit 0x1 de J sigue apareciendo. Control: la corrida `con-ia-2` (mismo bloque, sin el prototipo).
Refuta: 10 s sin bit 0x2 con el prototipo puesto → la percepción tiene otra condición (el rayo de `FUN_00185318`).

**Resultado P1 (prototipo por PINE):** la percepción procesa a J2 (máscara `0x7`), pero J2 NO entra a las amenazas:
«ver»/«visibles» son nodos de BUSCAR y no corren en combate. La predicción se refuta en su segunda mitad.

## P2 — PERC2 desde el pnach (diseño de (110), condición «en combate»)
**Predicción:** con `instalar --con-ia` (PERC2 incluido), en City Streets, enemigos en combate que perciben a J2 lo
anotan (id 1 en `+0x150/+0x1B0/+0x210`, bit 0x2 en `+0x274`). Control: `con-ia-1`/`con-ia-2` (VER2 sin PERC2): nunca.
**Resultado (`perc2-2`):** dos enemigos en combate con el aliado Tom tienen el id 1 desde t = 0 (vis `0xa`); su amenaza
actual sigue siendo Tom. Confirmado en RAM, con control. (La versión «ya conoce a J», `perc2-1`, no anotó: el enemigo
peleaba con el títere.)
