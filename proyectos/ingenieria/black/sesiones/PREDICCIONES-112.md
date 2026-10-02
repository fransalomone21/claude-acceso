# Predicciones de la tanda (112), escritas ANTES de medir

## H — el HUD de dos jugadores del juego, prendido a mano (2026-10-02, fork solo, City Streets)

Mecanismo (`docs/16`, «HUD separado», (112); bitácora (112)): el arranque construye dos paneles en `*(0x0040F518)`;
`FUN_001F2340(hud)` activa los `hud+0x23C` primeros con su rectángulo (`panel+0x78..+0x84`); `FUN_001F1B98(panel,
tipo)` les pone el tipo (con 0 no dibujan su lista); `FUN_001F2618` dibuja los `hud+0x23C` paneles. Herramienta:
`herramientas/hud_doble.py` (en pausa escribe los rectángulos y la cuenta; `llamar_una_vez.py` llama la activación y
los tipos; capturas antes, con dos y después de deshacer).

**Predicción:** con la cuenta en 2, el panel 0 en (30, 22)–(290, 458) y el panel 1 en (350, 22)–(610, 458), activados
y con el tipo del panel 0 (1): se ven **dos HUD, uno en cada mitad**, los dos con los valores de J (todavía sin H4).
El de la izquierda queda corrido dentro de su mitad (no achicado). El juego sigue corriendo (contador por cuadro).
**Control:** la foto antes (un HUD a pantalla entera) y la de después de deshacer (cuenta 1, rectángulo entero,
activar otra vez): un HUD como antes.
**Refuta:** con la cuenta en 2 se ve un solo HUD (el panel 1 no dibuja: falta otra cosa que lo prenda), o los dos
HUD encimados en el mismo lugar (las posiciones no salen del rectángulo del panel: el corrimiento es otro).
**Inválida:** si el EE se cuelga en la activación (se mira el contador del mod antes de concluir nada del HUD).

**Resultado H (`volcados/hud/doble-20261002-040213/`):** las cinco llamadas corrieron (EE vivo) y el panel 2 registró
sus elementos. **Dos HUD, uno en cada mitad: confirmado en pantalla, con control** (antes y después de deshacer: uno).
La retícula del panel 1 se corrió al centro de la mitad izquierda. **Dos diferencias con la predicción:** (1) el HUD
de la izquierda queda **apretado**: la caja de la vida y la de la munición se enciman (se corren, no se achican, como
decía el riesgo (iv)); (2) el de la derecha **no** muestra los valores de J sino `000` y `0/000`: los elementos que
indexan por panel leen `jugadores[1]` = memoria después de J (en cero). La predicción estaba mal en ese punto (decía
«los dos con J»); el modelo de (112) lo explica (11 constantes `panel · 0x8C0`).

## H4a — los 11 pasos en 0 (escrita antes de escribirlos, con el HUD doble prendido)
**Predicción:** con las 11 constantes `li rX, 2240` en `li rX, 0` (en pausa), el HUD de la derecha pasa de `000` a los
valores de J (`015`, `0/030`): los dos paneles leen `jugadores[0]`. La izquierda no cambia. **Control:** al devolver
las 11 palabras, la derecha vuelve a `000`. **Refuta:** la derecha sigue en `000` (los valores salen de otro lado).

**Resultado H4a: INVÁLIDA, por el instrumento** (`volcados/hud/doble-20261002-064507/`). La sesión volvió de una pausa
con ventanas de Fran adelante (Configuración, Administrador de tareas): `capturar-pantalla.ps1` se negó a tomar el
foco (bien: su alarma), las fotos de la corrida `…-064347` no se escribieron y el script lo callaba. Con
`capturar-ventana.ps1` (PrintWindow, sin foco) las fotos salen, pero **viejas**: tres capturas a 1,5 s con el md5
idéntico y el EE corriendo (no en pausa). Las palabras se escribieron y se devolvieron (`pasos_devueltos` = true);
qué mostró la pantalla, no se sabe. `hud_doble.py` ahora intenta las dos capturas, guarda el md5 de cada foto y marca
`FOTOS_INVALIDAS` si falta una o hay dos iguales (probado: rojo con repetidas o faltantes, verde con distintas).
**Se repite con la pantalla libre** (o Fran presente).
