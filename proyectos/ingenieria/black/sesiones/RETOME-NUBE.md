# Mensaje de retome para una sesión NUEVA en la nube

> **Al 2026-09-27 lo que sigue es LOCAL** (`sesiones/RETOME-LOCAL.md`). Este mensaje es para la próxima tanda en frío, cuando la notebook haya corrido su lote.

Copiar y pegar tal cual al abrir la sesión (repo `claude-acceso`):

```
Retomo BLACK en la NUBE (claude-acceso, proyectos/ingenieria/black). Proyecto LOCAL: todo vuelve a main y queda documentado para la notebook.
0. git log --oneline -3 y fijate que main tenga el último commit de BLACK de sesiones/HANDOFF.md. Si no, pará.
1. Agregá el repo PRIVADO fransalomone21/black-datos (add_repo), clonalo en /home/user/black-datos y corré:
   bash proyectos/ingenieria/black/herramientas/nube/preparar.sh
   (verifica SHA-256, instala capstone y numpy, corre los controles positivos).
   Después: bash proyectos/ingenieria/black/herramientas/nube/instalar_ghidra.sh
   (Ghidra 12.1.2 + extensión EE + el proyecto ya analizado; termina con el control positivo de decompilar.py info).
2. Leé SOLO: el primer bloque de sesiones/HANDOFF.md, PDP.md §4 «Proyecto COOP» y las 3 primeras entradas de docs/03-bitacora.md.
3. Fase: COOP-A. El PLAN DEL ELF (docs/14-plan-elf.md) está COMPLETO (E1-E7). Lo que queda en frío está en el bloque «CIERRE» de sesiones/HANDOFF.md, «Pendiente en frío»: frontend-datos (K1), el consumidor de GLOBDATA s5, los objetos del módulo tipo 0x24 y las claves sin nombre de ANDY.AKU. Si hay un volcado nuevo de la notebook en black-datos, medir primero contra él. El decompilado se lee sin Ghidra con herramientas/leer_c.py; herramientas/perfil_singleton.py perfila un singleton.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo (hipótesis/probable/confirmado).
6. Lo que necesite emulador se anota como sonda para la notebook; no se simula.
7. AUTONOMÍA: trabajá solo, ítem tras ítem de la lista «Pendiente en frío», sin pedirme permiso para lo técnico. Pará sólo si (a) el contexto llega al 40 %, (b) necesitás una decisión de valor mía, o (c) algo pide la notebook y no hay otra etapa que se pueda hacer en la nube.
8. Checkpoint después de CADA etapa (bitácora + kb/ + commit + push a main), no sólo al final. Al parar: ESTADO_ACTUAL + HANDOFF + actualizar este mensaje de retome si cambió algo.
```
