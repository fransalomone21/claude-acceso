# Mensaje de retome — BLACK (134): controlar la PC desde la notebook y dejarla lista para jugar

```
Retomo BLACK (proyectos/ingenieria/black). Sesión (134). Vengo de (133) con el plan al 98 %.
0. EL LIBRO PRIMERO (en la PC llega solo). `.\cascada.ps1 black -Necesidad investigar,diseno` y leer lo que pida.
   Fase: PLAT-PreA (NASA Pre-Phase A). La cierra: el KDP de Fran DESPUÉS de jugar el coop con Agustín.
1. YA HECHO en (133), no rehacer: requisitos ampliados acordados; plataforma = black-seamless-coop (port XBERecomp +
   coop) en C:\Games\BLACK\coop de la NOTEBOOK; S1 y S2 cumplidas (PREDICCIONES-133.md); puente de mandos con los
   controles de PS2; lanzadores en lanzadores\: PREPARAR-BLACK, JUGAR-COOP-RED (-Anfitrion/-Preguntar/-Solo),
   PROBAR-COOP-PC (-DosMonitores), SERVIR-A-LA-PC (cable, -Carpeta), PAQUETE-PC (-Destino pendrive), TRAER (en la PC).
   Notebook preparada (accesos en Escritorio\Juegos\BLACK). Guía: docs/23-jugar-coop.md.
2. LO QUE FALTA (lo pidió Fran):
   a) CONTROL TOTAL DE LA PC DESDE LA NOTEBOOK, sin tipear nada en la PC: la PC sólo tiene Ethernet (sin Wi-Fi) y va
      por cable directo a la notebook (IP 169.254.x.x sola). Fran no puede pasarle texto (ni WhatsApp). Opciones a
      medir, de menos a más trabajo para Fran: (1) un pendrive con un .bat de doble clic que corra TRAER desde el
      pendrive y además prenda el acceso remoto; (2) Escritorio remoto (RDP) si la PC es Windows Pro: Fran activa un
      interruptor en Configuración > Sistema > Escritorio remoto y la sesión se conecta con mstsc a la IP del cable;
      (3) si es Home: una herramienta de control remoto por LAN. Los cambios de configuración de la PC los hace Fran
      (la sesión no toca seguridad del sistema). Elegir la que menos le pida y dejarla como medio fijo para el futuro.
   b) Pasarle todo a la PC (SERVIR-A-LA-PC o PAQUETE-PC + TRAER; probados en la notebook, el servicio por cable
      nunca se abrió de verdad) y que PREPARAR deje la PC con su calidad gráfica y accesos.
   c) Probar el coop por red real notebook (anfitriona) <-> PC (unirse a la 169.254 de la notebook).
   d) Después de jugar: el KDP de Fran (¿el coop les gustó?) y cerrar PLAT-PreA en el PDP §6.
   e) Dificultad más alta que Black Ops = mod de reglas (L1-29), en la fase siguiente; anotado en docs/23.
3. MOTOR: Sonnet, esfuerzo medio (runbook ya decidido); Opus si hay que diseñar el control remoto.
4. TRAMPAS: la puerta del cascada niega todo hasta leer; `git add` sólo de lo propio (SVG ajenos de
   fisica-espacial); los ejecutables de terceros los abre Fran por los lanzadores.
PRIMER COMANDO: .\cascada.ps1 black -Necesidad investigar,diseno
```
