# ESTADO ACTUAL — arquitectura-se

**Fase 6 CERRADA** el 2026-09-17. Cerró por lo que la cerraba (`PDP.md` §4):
**`chequeo-completo.ps1` en verde, todos los saboteadores corridos, y un
proyecto real migrado a la matriz.** Los tres, medidos:

```
Chequeo OK. Ningun rojo.      7 medidores + 10 saboteadores + 7 de limpieza
```

**Fue la primera fase que tocó archivos vivos**, con rigor **pleno**
(`docs/matriz-cumplimiento.md` §4, aspecto `c`): saboteador antes de dar por
puesta cada pieza, no después. **Abre la fase 7** (validar ≠ verificar).

## Lo que quedó instalado

| Pieza | Estado | Lo que la hace cobrable |
|---|---|---|
| **P2** matriz por proyecto | **cumple** | `medir-matriz.py` + `probar-medidor-matriz.ps1` (6 casos) |
| **P3** rigor por aspecto | **cumple** | `plantillas/PDP.md` §3, y la instancia en el PDP de este proyecto |
| **P4** molde de fase | **cumple** | `medir-fase.py` + `probar-medidor-fase.ps1` (6 casos) |
| **P5** heurísticas al paso | **recortado**, mitad puesta | `hooks/guardia-escapes.ps1` + `probar-guardia-escapes.ps1` (10 casos) |
| **P6** criterio de entrada | **cumple** | `aprender.py --opuesto` + 3 casos en `probar-chequeo-lecciones.ps1` |
| **P7** System 2 / System 3 | **cumple** | `perfil-global/README.md`, sin reescribir la cascada |
| **P1** catálogo derivado | **no aplica — todavía** | difiere, con la resta escrita |
| **P10** medidor de validación | **fase 7** | a propósito |

**Los tres defectos vivos, cerrados:** D12 (el conteo se **deriva**: el
`INDICE.md` pasó solo de 186 a 212), D14 (el chequeo de requisitos dejó de ser
de idioma inglés) y el medidor de desuso (C6 dejó de ser una intención).

**El proyecto migrado es este mismo:** su `PDP.md` lleva el rigor por aspecto
(§3 bis), la columna *Cómo se certifica* con la salida `cancelar` (§4) y la
matriz de cumplimiento (§8). **38 filas, 33 cumple, 2 no aplica, 3 recortado**,
todas las recortadas con su resta escrita.

## Lo que se encontró midiendo, y no estaba en el plan

- **El freno de D12 existía, y su saboteador daba verde sobre el defecto
  vivo.** El patrón de `install.ps1` estaba anclado a la **primera línea** y el
  saboteador rompía el archivo **ahí mismo**; el `186` real vivía en la línea
  19. **Un saboteador escrito por el autor del freno hereda su punto ciego.**
  Es el argumento más fuerte que tiene el proyecto para que **P8 siga declarada
  como hueco sin respuesta** en vez de darse por cubierta con los saboteadores.
- **Cinco archivos vivos tenían un carácter de control adentro**, invisible en
  cualquier editor: `chequeo-de-trabajo.md` (que **se inyecta en cada
  sesión**), `MAQUINA-NUEVA.md`, `verificar-requisito.py` —donde **apagaba en
  silencio una excepción de R16**— y **dos datos técnicos de BLACK medidos
  contra el ELF y contra la máquina**. Los cinco eran un escape de C en un
  string no-raw. Ahora lo mide la **regla 8** de `verificar-estructura.ps1`
  sobre los 288 archivos que el repo trackea.
- **La lección de ese error ya estaba escrita, con triage `propia`, e
  inyectada en `chequeo-de-trabajo.md` línea 553.** Estuvo en el contexto todo
  el tiempo y el error se cometió **cinco veces igual**. A 95 KB, 1347 líneas y
  154 viñetas, **la inyección dejó de ser entrega** — que es, palabra por
  palabra, lo que Rechtin p. 35 describe como hojear una ferretería. Es P5
  medido en carne propia, y es lo que decidió construir su guardia.
- **Dos saboteadores sanos reportados en rojo** por no cerrar con `exit 0`:
  heredaban el código del último comando nativo, que en un saboteador es por
  construcción uno que **tiene** que fallar.

## Lo que FALTA, para la fase 7

- **P10, el medidor de validación** — *timely / affordable / predictable /
  comprehensive* (SEH p. 165-166), contra el costo por fase ya registrado acá
  abajo. Es lo que cierra la fase 7.
- **P1, el catálogo derivado**, diferido con su resta escrita en la matriz.
- **La mitad de P5 que falta:** partir `chequeo-de-trabajo.md`, que sigue
  pesando **95 KB**. Criterio ya escrito: lo que se inyecta pesa menos, **y**
  la lección del paso en curso está adentro.
- **`ingenieria-de-sistemas.md`** con las 4 correcciones de `arquitectura.md`
  §8, y la pregunta abierta: ¿sigue haciendo falta, o el catálogo P1 más las
  cuatro fichas ya lo reemplazan?
- **Migrar los otros 7 PDP.** `medir-fase.py` los cuenta: hoy **1 en verde, 7
  sin migrar**, y ese número tiene que bajar.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  **La matriz lo reclasificó de tailoring a error**, con la resta escrita.
- **Fases 1-5:** inline, entre 7 y 12 puntos del límite de 5 h cada una.
- **Fase 6:** inline, sin un solo subagente, **cero PDF extraídos**. Los tres
  defectos vivos, cinco piezas instaladas, **cinco saboteadores nuevos**, dos
  medidores nuevos, una regla de estructura nueva, un guardia nuevo y ocho
  lecciones, por **~31 puntos** del límite de 5 h (dos ventanas: 39→55 % y
  9→17 %+) y **4** del semanal (82 % → 86 %), medidos al cerrar.
  **Sexta fase seguida sin fan-out.**
