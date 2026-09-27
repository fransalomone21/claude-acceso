# Mensaje de retome para una sesión NUEVA en la nube

Copiar y pegar tal cual al abrir la sesión (repo `claude-acceso`):

```
Retomo BLACK en la NUBE (claude-acceso, proyectos/ingenieria/black). Proyecto LOCAL: todo vuelve a main y queda documentado para la notebook.
0. git log --oneline -3 y fijate que main tenga el último commit de BLACK de sesiones/HANDOFF.md. Si no, pará.
1. Agregá el repo PRIVADO fransalomone21/black-datos (add_repo), clonalo en /home/user/black-datos y corré:
   bash proyectos/ingenieria/black/herramientas/nube/preparar.sh
   (verifica SHA-256, instala capstone y numpy, corre los controles positivos).
2. Leé SOLO: el primer bloque de sesiones/HANDOFF.md, PDP.md §4 «Proyecto COOP» y las 3 primeras entradas de docs/03-bitacora.md.
3. Fase: COOP-A. Siguiente en la nube: el PLAN DEL ELF (docs/14-plan-elf.md), empezando por instalar Ghidra headless.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo (hipótesis/probable/confirmado).
6. Lo que necesite emulador se anota como sonda para la notebook; no se simula.
7. Checkpoint antes de parar: ESTADO_ACTUAL + HANDOFF + bitácora + commit + push a main.
```
