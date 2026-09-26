# Handoff — metodo-agustin

**Escrito el:** 2026-09-26 · **Fase al cerrar:** 0 cerrada, 1 abierta sin empezar

## Arrancá por acá

Leer `PDP.md` §2, §4 y §6: qué va al núcleo, qué cierra la fase 1 y por qué
se decidió así. Después, **medir** antes de escribir el exportador: la lista de
abajo es el punto de partida, no el inventario. El inventario sale del disco.

## Lo que quedó a medias

Nada tocado. La fase 1 no empezó.

## Lo que NO hay que volver a intentar

- **Correr el `install.ps1` del export en esta máquina.** Pisa
  `%USERPROFILE%\.claude` de Fran: no tiene parámetro de destino.
- **Invitar a Agustín a `perfil-global`** o **partirlo en dos**: descartado en
  PDP §6, con el motivo.
- **Reemplazar "Fran" en todo**: sólo en los archivos operativos.

## Datos que no se pueden aproximar

- Repos de origen: `C:\Users\frans\Desktop\claude-acceso` (público,
  `fransalomone21/claude-acceso`) y adentro `perfil-global\` (privado,
  `fransalomone21/perfil-global`, ignorado por el de afuera).
- "Fran" en archivos operativos (conteo por archivo, 2026-09-26):
  `perfil-global/CLAUDE.md` 5, `apertura-proyecto.md` 4,
  `recordatorio-transversal.md` 2, `hooks/guardia-fanout.ps1` 6,
  `hooks/guardia-heredoc.ps1` 3, `.claude/arranque.md` 3.
- Rutas `frans` fijas: `aprendizaje/fichas/entorno.md`,
  `aprendizaje/fichas/medicion.md`, `aprendizaje/LECCIONES.md`,
  `manifiesto.ps1`, `pilares/pragmatic-programmer.md`,
  `pilares/thinking-in-systems.md`, `probar-guardia-heredoc.ps1`. Las fichas
  se **regeneran** desde `lecciones.jsonl`: filtrar el `.jsonl` y regenerar,
  no editar las fichas.
- Lecciones: 248 en total, 18 `fuera`, 13 de `seguimiento/` (coaching 11,
  haberes-docentes 2), que son las que van a lectura humana.
- `bootstrap.ps1:102` clona `https://github.com/fransalomone21/perfil-global.git`.
- `chequeo-completo.ps1`: Drive en las líneas 51 (`publicar-apuntes`),
  57 (`verificar-drive`) y 84 (saboteador de Drive).
- Probable **fuera** del núcleo, del lado de `claude-acceso` (verificarlo al
  medir): `publicar-apuntes.ps1`, `verificar-drive.ps1`,
  `probar-publicacion.ps1`, `probar-verificar-drive.ps1`,
  `.claude/apuntes-publicos.json`, `.claude/estructura-drive.json`,
  `.claude/protegidos.json`, `.claude/hooks/guardia-iso.ps1`, `proyectos/`,
  `archivo/`, `tmp-render/`, los `.html` sueltos de la raíz. El enrutador
  `CLAUDE.md` va **sin** las tablas de proyectos ni las secciones de Drive.

## Si hay que abrir un chat nuevo

El bloque de retome es el de la respuesta que cerró la fase 0. Es este:

```
Proyecto metodo-agustin (proyectos/ingenieria/metodo-agustin/), fase 1.
Leer en orden: CLAUDE.md del proyecto, ESTADO_ACTUAL.md, HANDOFF.md,
PDP.md secciones 2, 4 y 6. NO leer los proyectos de Fran ni MAPA.md.
Fase 1: exportador y verificador de privacidad. La cierra: el export
generado en una carpeta de scratch pasa el verificador en verde, y
probar-exportador.ps1 lo pone en rojo 5 de 5 (ruta frans, mail, DNI,
leccion 'fuera', "Fran" en archivo operativo) y vuelve al verde.
Modelo: Sonnet (implementar con el diseño ya decidido). Esfuerzo:
medium, sin fan-out (la lista es secuencial: medir, filtrar, verificar).
Estado de la maquina: nada instalado para este proyecto. PROHIBIDO
correr el install.ps1 del export aca: pisa ~/.claude de Fran.
Resuelto: transporte GitHub, nucleo generado, solo ida, nombre
reemplazado solo en archivos operativos, pasan las lecciones no 'fuera'.
OJO: el arranque del 2026-09-26 avisaba que los saboteadores quedaron
EN ROJO en su ultima corrida (2026-09-22). No se exportan alarmas en
rojo: antes del exportador, correrlos y ver que den verde.
Primer comando: .\cascada.ps1 metodo-agustin
Segundo: .\chequeo-completo.ps1 -SoloSaboteadores   (~96 s)
```
