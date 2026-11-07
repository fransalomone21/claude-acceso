# Retome — una dificultad más alta para el coop (escrito en (136), 2026-11-06)

Pedido de Fran: plantear un aumento de dificultad, para otra sesión. Esto es SÓLO el mensaje para pegar; no se diseñó
ni se tocó nada.

```
BLACK: subir la dificultad del coop, para Fran y Agustín. Sesión en la NOTEBOOK (C:\Users\frans\Desktop\claude-acceso).
0. El libro primero: si ~/.claude/CLAUDE.md no empieza con "# Perfil global", bash .claude/nube/traer-perfil.sh.
1. Primera llamada, sola: .\cascada.ps1 black -Necesidad diseno,ingenieria-inversa  y leer lo que pida.
   Después: docs/20-requisitos.md §2 (la v1 dice "No entra: dificultad o balance para dos") y §10 (L0-07, L1-29),
   docs/23-jugar-coop.md "La dificultad", docs/24-fallos-coop.md (F-RED-3: el reparto justo va antes que la dificultad).
   NO leer la bitácora entera ni los PREDICCIONES viejos.
2. Fase: PLAT-PreA (Pre-Fase A, estudio de conceptos). Subir la dificultad CAMBIA EL ALCANCE de la v1: se hace como
   alternativas + preguntas a Fran + su sí (KDP), no se fabrica. La cierra: requisito L1 nuevo escrito (GtWR en verde)
   y acordado por Fran, con la alternativa elegida y su prueba de control escrita antes.
3. Motor: Opus, esfuerzo medio, sin fan-out (es diseño con pocas piezas y preguntas de valor a Fran).
4. Máquina: coop en C:\Games\BLACK\coop (exe con parches 01+02, sha C420CBC5E5D1; respaldo BLACK-release.exe). Fuente
   del port en C:\Games\BLACK\src\black-recomp; parches nuestros en black\parches-coop\ (03 = diagnóstico). Upstream
   v2026.11.01 (port V3) sin migrar (decisión de (136)). La dificultad del juego: 0..3 en *(0x2D45F0)+0x2014C, la elige el
   anfitrión; la 3 (Black Ops) quizá bloqueada (hipótesis).
5. Ya resuelto, no rehacer: en el port un cambio de reglas es "una función propia en lugar de la del juego" (X86_FUNC, como
   hace el mod: TakeDamage en coop_npcs.cpp ~714). El daño que RECIBE el jugador sale de la tabla de armas (Power) y el que
   HACE, de zona*100 (fases 4 y 4b del PDP, medido en PS2; en Xbox, por la Rosetta: rosetta.py).
6. Primer paso concreto: preguntarle a Fran (son de valor, no técnicas): (a) ¿qué es "más difícil" para ustedes? daño
   recibido, menos munición/botiquines, enemigos más certeros, más enemigos, sin regeneración; (b) ¿igual para los dos
   o el anfitrión con alguna desventaja para compensar? (c) ¿Black Ops está desbloqueado en su partida? Después, en frío,
   para cada perilla elegida: dónde vive en el port, si corre en el anfitrión (enemigos) o en las DOS copias (daño al
   jugador, munición), y cómo se manda el ajuste del anfitrión al compañero para que sea el mismo en las dos.
7. Riesgo a medir antes de prometer: "más enemigos" choca con el tope de 16 ranuras de comportamiento de la IA
   (coop_npcs.cpp, BehaviourFree) y con los títeres; es la perilla más cara. Lo que se mide del ajuste: el EFECTO en las
   dos copias (la vida de cada jugador ante el mismo disparo, con el ajuste y sin él como control).
```
