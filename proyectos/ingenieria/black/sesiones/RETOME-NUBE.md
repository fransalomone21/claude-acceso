# Mensaje de retome para una sesión NUEVA en la nube

> **Al 2026-09-27 (después de la bitácora (79)) hay una tanda en frío que le ahorra sondas a la notebook.** Lo que pide emulador sigue en `sesiones/RETOME-LOCAL.md`; esta tanda prepara su paso 3a y hace el 3b en frío. Si la nube corrió, la notebook lee primero la entrada «(80, nube)» de la bitácora.

Copiar y pegar tal cual al abrir la sesión (repo `claude-acceso`):

```
Retomo BLACK en la NUBE (claude-acceso, proyectos/ingenieria/black). Tanda en frío que prepara el paso «J2 camina» para la notebook. Todo vuelve a main.
0. git log --oneline -3 y fijate que main tenga 8ba1b65 o posterior (último commit de BLACK sobre sesiones/HANDOFF.md). Si no, pará.
1. Agregá el repo PRIVADO fransalomone21/black-datos (add_repo), clonalo en /home/user/black-datos y corré:
   bash proyectos/ingenieria/black/herramientas/nube/preparar.sh
   Ghidra (instalar_ghidra.sh) SOLO si leer_c.py no alcanza para alguna función: el decompilado ya está en black-datos.
2. Leé SOLO: el bloque «(79)» de sesiones/HANDOFF.md (líneas 11-35), PDP.md §4 «Proyecto COOP» fila 5 y la entrada (79) de docs/03-bitacora.md. NO leas lo viejo.
3. Fase: COOP-A. La cierra: habilitadores críticos en K5 y un prototipo por PINE donde el mando 2 MUEVE a un segundo jugador. Ya hecho (NO rehacer): J2 construido por el juego, a 60 Hz, el mando 2 le gira la mira. FALTA que camine; la hipótesis (probable) es que comparte la RANURA DE PERSONAJE de J0 (sistema de personajes *(0x0040F50C) = 0x004ED380, 0x970 B, 2 ranuras en +0x470/+0x6B0 de 0x240, 2 instancias en +0x398/+0x404).
   Volcado de referencia: black-datos/ee-03.bin = slot 3 (LEVEL_00, J0 construido, SIN J2). Medido ya en él: *(0x0040F50C) = 0x004ED380, 180 palabras no nulas, y SOLO 2 autopunteros: +0x4C0 y +0x700 (uno por ranura, +0x50 de cada una).
   Etapas, en orden, cada una con su predicción escrita en la bitácora ANTES de medir:
   N1. ¿La copia sirve? Todos los lectores de 0x0040F50C en el ELF (capstone sobre lui/lw, no sólo Ghidra), y para cada uno: ¿corre en la construcción o por cuadro? Si FUN_001334e0 o su árbol por cuadro llega a la ranura por el GLOBAL y no por J+0x330, cambiar el global sólo alrededor del constructor NO alcanza: decirlo y proponer el gancho (en qué jal envolver por cuadro).
   N2. El camino de atado: FUN_00143d90 -> FUN_001ac960 -> FUN_001a51c8 (qué escribe en la ranura y en J, qué significa +0xB8, qué libera). Qué hace el constructor FUN_00139c68 con el molde 2 vs 0x1C (¿carga modelo? ¿por qué colgarían con índice bueno?). Salida: los argumentos exactos del atado a mano (a2) y la lista de campos que hay que dejar en cero en la copia.
   N3. Quién escribe J+0x7C (y +0x8C) en la construcción de J0 (J2 los tiene en 0), y qué lee FUN_001334e0 para escribir la posición (0x001338B4 / 0x00133B08 / 0x00133B2C): de qué campo sale el desplazamiento que en J2 da 0.
   N4. Herramienta: subcomando `jugador2.py ranura-copiar` (copia a 0x0046DC00, reubica los autopunteros que mida EN VIVO, no la lista de ee-03, pone +0xB8 = 0 en las dos ranuras de la copia) y la opción del envoltorio que pone *(0x0040F50C) = copia alrededor del jal 0x139c68 de J2 y restaura después. Probala en frío contra ee-03.bin con un modo --seco que imprime lo que escribiría. Agregá su prueba a pruebas/prueba_herramientas.py.
   N5. kb/subsistemas.json: 0x0040F50C NO es `audio` (es el sistema de personajes/animación). Con herramientas/kb_formato.py, después programa.py catalogo y verificar (0 rojos) antes del commit.
   Al terminar: actualizá sesiones/RETOME-LOCAL.md paso 3a/3b con lo que cambió (argumentos exactos, qué ya no hace falta sondear) y dejá la entrada «(80, nube)» arriba en docs/03-bitacora.md.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo: lo de la nube llega a «probable» como techo; «confirmado» es sólo efecto en RAM/pantalla con control, y eso es de la notebook.
6. Lo que necesite emulador se anota como sonda para la notebook; no se simula.
7. AUTONOMÍA: trabajá solo, N1 a N5 en orden. Pará sólo si (a) el contexto llega al 40 %, (b) necesitás una decisión de valor mía, o (c) N1 dice que la copia no puede funcionar y el resto pierde sentido: en ese caso documentá por qué y el gancho alternativo, y pará.
8. Checkpoint después de CADA etapa (bitácora + kb/ + commit + push a main). Al parar: ESTADO_ACTUAL + HANDOFF + actualizar este mensaje de retome.
```
