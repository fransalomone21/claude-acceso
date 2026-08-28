ARRANQUE DE PROYECTO -- lo que NO esta en ninguna otra capa que se lea sola.

El enrutador de proyectos (que hay y donde) es CLAUDE.md y se carga solo: no
se repite aca, porque un dato que vive en dos lados diverge. Lo de abajo es
lo que hoy vive en archivos que NO se leen solos, y por eso se olvidaba.

AUTORIZACIONES PERMANENTES -- no se piden de nuevo cada sesion
  - Los .bat de arranque los ABRE LA SESION, no Fran. Estan en
    proyectos/ingenieria/black/lanzadores/ y se lanzan con la herramienta de
    PowerShell. Pedirle a Fran que abra el emulador es hacerle de secretario
    de algo que la sesion puede hacer sola. Lo unico que Fran tiene que hacer
    con el emulador es JUGAR cuando el experimento necesita llegar a un nivel.
  - Instalar lo que haga falta (winget, pip) sin preguntar. Vigente desde
    2026-08-17.

EL DEFAULT ES EN FRIO
  El trabajo se hace sobre el ELF, sobre el ISO y sobre los volcados ya
  tomados. El emulador se abre SOLO cuando hay que contrastar o confirmar
  algo por efecto, y en ese caso se escribe la prediccion ANTES de abrirlo.
  Abrir el emulador "para ver" cuesta una sesion y no produce evidencia.

BLACK -- lo primero, y es UN comando
    .\proyectos\ingenieria\black\abrir-sesion.ps1
  Corre los tres controles de apertura (ubicaciones, inventario, Ghidra) mas
  la integridad de los archivos protegidos, y sale en rojo si algo falta.
  Con -Rapido saltea Ghidra, que es el unico lento.
  El HANDOFF de BLACK esta en sesiones/HANDOFF.md, no en la raiz.

EL ISO ORIGINAL ES INTOCABLE, Y AHORA HAY QUIEN LO MIDA
  Black.iso esta en ReadOnly y hay un guardia PreToolUse. Las dos capas se
  desinstalan con .claude\desinstalar-hooks.ps1. Si un comando legitimo queda
  bloqueado, NO se saca el guardia: se corrige .claude\protegidos.json y se
  vuelve a correr .\probar-hooks.ps1.
