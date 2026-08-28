# BLACK — atajos

Todo a mano, sin buscar nada.

## Para empezar a trabajar

1. Doble clic en **`ABRIR-EMULADOR.bat`** (abre el PCSX2 parcheado, no el de
   Program Files — el parcheado es el único que tiene el DebugServer).
2. Cargar BLACK y meterse al nivel.
3. En Claude Code, decir: *"leé black/CLAUDE.md y el HANDOFF, seguimos"*.

## Verificar que el debugger responde

```
cd C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black
python herramientas\depurador.py estado
```

Tiene que decir `alive True` y un `pc` que empiece con `0x001` o `0x002`.

## El paso que cierra la Fase 2 (2 minutos, necesita que juegues)

```
cd C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black
python herramientas\pine.py savestate --slot 5
python herramientas\depurador.py vigilante poner 0x005A8DA8 --tipo write --accion break
python herramientas\depurador.py esperar --segundos 120
```

Ahora **dejate pegar por un enemigo**. Si el emulador se congela y el comando
imprime `PAUSADO`, está confirmado: ahí está la instrucción que te resta la vida.

Para soltarlo después:

```
python herramientas\depurador.py vigilante quitar 0x005A8DA8
python herramientas\depurador.py continuar
```

> **No uses `bp poner`.** Los breakpoints de *ejecución* matan el emulador en
> esta build (probado el 2026-08-15). Los `vigilante` (watchpoints) andan bien.
> La herramienta ya te frena si lo intentás.

## Si algo se cuelga

`vigilante quitar <dir>` + `continuar`. Si no responde, cerrar y reabrir el
emulador — no se rompe nada permanente, se pierde la partida no guardada.

## Dónde está todo lo demás

- Proyecto: `C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black`
- Estado del proyecto: `black\ESTADO_ACTUAL.md`
- Para retomar una sesión: `black\sesiones\HANDOFF.md`
