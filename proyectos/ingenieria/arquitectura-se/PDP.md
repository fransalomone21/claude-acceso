# PDP — arquitectura de ingeniería de sistemas

**Abierto:** 2026-09-16. **Naturaleza:** ingeniería.

## 1. El problema

La arquitectura de trabajo actual (cascada de 6 niveles, PDP, naturalezas,
cuadro de fase, frenos) creció por acumulación: cada pieza resolvió un fallo
real y quedó. Funciona, y las necesidades que la generaron **siguen vigentes y
no se negocian**. Pero nunca se la contrastó contra el cuerpo formal de
ingeniería de sistemas, y tiene huecos que se sienten sin poder nombrarse.

**El hueco que sí se pudo nombrar,** leyendo el handbook: no hay **matriz de
cumplimiento**. Las naturalezas (`ingenieria` / `documentos` / `seguimiento`)
tipifican el proyecto pero no declaran, producto por producto, qué se exige,
qué se tailorea y qué no aplica — ni con qué justificación. Es una etiqueta,
no un contrato. NASA resolvió exactamente esto en el cap. 3.11 (p. 34-42):
tipos A-F + Matriz de Cumplimiento con rationale por línea, adjunta al SEMP.

Y el mecanismo correcto **ya está inventado en este repo, dos veces**:
`.claude/datos-permitidos.json` y `.claude/apuntes-publicos.json` son
deny-by-default con excepción declarada y motivo al lado. Falta aplicárselo
al método mismo.

## 2. Qué se produce

1. La **ficha destilada** de cada fuente, con anclas verificables (capa 2 del
   protocolo de `perfil-global/pilares/README.md`).
2. El **pilar** foldeado de cada una: sólo lo que cambia una decisión.
3. La **arquitectura nueva**: matriz de cumplimiento del método, tipificación
   de proyectos, y el ciclo de vida con puertas y criterios de salida.
4. La **migración** de lo vivo (`CLAUDE.md`, `cascada.ps1`, plantillas,
   naturalezas) y sus medidores.

## 3. Qué NO se produce

- Ceremonia. El propio handbook manda tailorear (p. 34): aplicar esto entero a
  un proyecto de una persona es malinterpretarlo. Cada requisito que entre
  lleva escrita su justificación de por qué entra.
- MBSE / SysML. Es herramienta buscando problema hasta que la arquitectura
  esté decidida.
- Nada que no se pueda medir con un script.

## 4. Las fases, y QUÉ CIERRA CADA UNA

El criterio de salida es un **resultado verificable**, nunca una cantidad de
trabajo hecho. Una fase por chat.

| # | Fase | Qué la cierra |
|---|---|---|
| **0** | **Leer el handbook NASA** | **CERRADA 2026-09-16.** 15/17 tramos destilados con anclas en `perfil-global/pilares/nasa-seh/`, medidor de citas corriendo, 8 fuentes indexadas con MD5 |
| **1** | **Cerrar la base documental y medirla de verdad** | **CERRADA 2026-09-16.** 17/17 tramos; `verificar-citas.py` depurado (5 defectos suyos, hallados auditando 77 fallos a mano), saboteado con `probar-verificar-citas.ps1`, y re-medido: **1424/1437 (99,1%)**, con los 13 fallos que quedan clasificados uno por uno |
| **2** | **Requisitos: INCOSE GtWR** | **CERRADA 2026-09-16.** Ficha con las 41 reglas y las 14 características ancladas a página impresa (`pilares/incose-gtwr/reglas.md`, citas **74/74**), **y** el chequeo mecánico `verificar-requisito.py`: cubre **32 de las 41**, declara las 9 que no con el motivo (`--cobertura`), y su saboteador exige rojo regla por regla **más** cero falsos rojos sobre 17 ejemplos que el libro marca como aceptables |
| **3** | **Marco e híbrido: INCOSE SEH 5.ª ed.** | **CERRADA 2026-09-17.** `pilares/incose-seh/mapeo-15288.md`: el mapeo de los 17 procesos de NASA contra los 30 del ISO/IEC/IEEE 15288 (2023), proceso por proceso, con **10 filas que no son 1:1** explicadas en las dos direcciones; y lo que INCOSE tiene y NASA no, con el ciclo iterativo/ágil en cuatro capas separadas. Citas **73/73**, ancla `impresa = PDF − 25` medida por **dos caminos** (321 encabezados + 41 de 41 entradas del índice), saboteador en verde |
| 4 | **Forma: Rechtin & Maier** | Ficha con las heurísticas de arquitectura que aplican a un sistema de trabajo de una persona, cada una con un caso propio ya vivido |
| 5 | **Diseñar la arquitectura nueva** | Documento de arquitectura + matriz de cumplimiento, con **trade study explícito** (cap. 6.8): 2-3 alternativas, criterios ponderados, y por qué perdieron las que perdieron. **Sin tocar un solo archivo vivo** |
| 6 | **Migrar** | `chequeo-completo.ps1` en verde, los cuatro saboteadores corridos, y **un proyecto real ya migrado** a la matriz |
| 7 | **Validar** (≠ verificar) | Una sesión real trabajada bajo la arquitectura nueva, con el costo medido contra la anterior |

**La fase 7 es la que hoy no existe en ninguna parte del método**, y es la
distinción más cara del handbook (p. 11): se puede verificar perfecto y fallar
la validación entera — construir con precisión la cosa equivocada. Todos los
verificadores del repo miden *cumplimiento con lo que escribimos*. Ninguno
mide *si sirvió*.

## 5. Riesgos, con disparador observable

| Riesgo | P×C | Disparador | Respuesta |
|---|---|---|---|
| La arquitectura nueva es más pesada que la vieja y se deja de usar | alta × alta | la fase 7 mide más costo por sesión que antes | volver al baseline; la matriz se recorta, no se explica mejor |
| El fan-out se come el límite del plan | **ya pasó** el 2026-09-16: 2,07 M tokens y un límite de 5 h en 6,6 min | cualquier propuesta de `Workflow` o `Agent` | de la fase 1 en adelante, **inline**. El fan-out se gastó donde el libro no entraba en una ventana; eso ya no vuelve a pasar |
| Destilados infieles, que se ven idénticos a los fieles | media × alta | `verificar-citas.py` por debajo de 90 % | no avanzar de fase hasta repararlo |
| Se reforma el método y se pierde lo que resolvía | media × alta | una necesidad vieja sin línea en la matriz nueva | cada freno actual entra a la matriz con su impacto original escrito, o no sale |

## 6. Fuentes

Las ocho, con MD5, en `perfil-global/pilares/fuentes/INDICE.md`.
**Faltan dos:** Douglass, *Agile Systems Engineering* (2015) y Reinertsen,
*Principles of Product Development Flow* (2009). Sin el primero, la mitad
*agile* de la arquitectura se apoya sólo en el capítulo de INCOSE 5.ª ed.
