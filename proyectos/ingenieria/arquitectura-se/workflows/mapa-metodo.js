export const meta = {
  name: 'mapa-metodo-v2',
  description: 'Mapa del metodo (v2, acotado): un lector por subsistema con presupuesto de herramientas, y un redactor que escribe docs/mapa-metodo-2026-10-12.md',
  phases: [
    { title: 'Mapa', detail: 'un lector por subsistema, solo lectura, esfuerzo bajo, ~15 llamadas' },
    { title: 'Consolidar', detail: 'un redactor escribe el documento' },
  ],
}

const RAIZ = 'C:\\Users\\frans\\Desktop\\claude-acceso'
const AS = RAIZ + '\\proyectos\\ingenieria\\arquitectura-se'
const COMUN = `Estas mapeando el METODO de trabajo de Fran: el sistema de hooks, puerta, cascada, perfil, verificadores y documentos que gobierna sus sesiones de Claude Code. Raiz: ${RAIZ}. El perfil global vive en ${RAIZ}\\perfil-global (repo propio) y se instala en C:\\Users\\frans\\.claude. Sesion de ARQUITECTURA: DESCRIBIR con evidencia, no arreglar.

PRESUPUESTO (importante: la version anterior de este mapa se comio un limite de plan entero en 4 minutos y no devolvio nada):
- A lo sumo ~15 llamadas a herramientas. Primero los DOCUMENTOS DE DISENO que ya describen tu subsistema (te los nombro abajo; leelos con Grep por encabezados y Read con offset/limit de las secciones que importan), despues Grep dirigido sobre el codigo para confirmar o refutar. Read de un archivo entero solo si tiene menos de 300 lineas.
- SOLO LECTURA. Nada de escribir, instalar, correr saboteadores ni probar-*.ps1. Una medicion = un comando simple, sin encadenar. Si una puerta (hook) te niega algo, no la pelees: anotalo en comandos_negados y segui con Read/Grep.
- Salida compacta: hasta 15 componentes, 10 interfaces, 8 modos de falla, 8 observaciones. Evidencia como ruta:linea o la medicion con su comando. Grado: medido / leido (codigo) / declarado (documento) / hipotesis.

QUE IMPORTA: (1) que DISPARA cada componente: la FASE del proyecto, una PALABRA del pedido, un ARCHIVO tocado, una CADENCIA, un evento del harness (SessionStart, UserPromptSubmit, PreToolUse, PostToolUse), una accion MANUAL, o NADA; (2) si FRENA o solo INFORMA; (3) su costo (bytes o segundos, por sesion/turno/entrada); (4) modos de falla de Leveson: no actua, actua mal, tarde, deja de actuar; (5) observaciones CONCEPTUALES que no esten ya en los defectos registrados (lista abajo; relacionalos por id, no los re-describas).

LINEA DE BASE YA MEDIDA (no la re-midas): ses.met mediana 87 712 caracteres (con T12 validada era 78 070); recordatorio por turno 1 154-1 683, cuadro 1 144-1 187; la puerta exigio 105 697 caracteres a la entrada de esta sesion (metodo + lluvia-de-ideas, 14 rangos) y 448 352 en una de BLACK; 12 medidores del arranque que suman 109,7 s; 46 negadas en 2 115 decisiones de la puerta en 21 sesiones auditadas; 6 de 22 proyectos en fase A-D sin requisitos; 0 de 38 defectos validados.

DEFECTOS YA REGISTRADOS:
${args.defectos}
`

const SUBSISTEMAS = [
  { key: 'inyeccion-arranque', foco: `INYECCION Y ARRANQUE: que entra al contexto sin pedirlo y cuando (hooks SessionStart y UserPromptSubmit, el hook "al paso" PreToolUse, pilares, apertura-proyecto, chequeo-nucleo, MEMORY.md, CLAUDE.md), y el arranque que mide (chequeo-completo -SoloMedidores, su tope de tiempo, si corren en paralelo y cuanto tarda de pared). Documentos de diseno: ${AS}\\docs\\t1-presupuesto-inyeccion.md, ${AS}\\docs\\t12-simplificar.md (secciones 6, 9 y 10). Codigo: ${RAIZ}\\.claude\\settings.json, C:\\Users\\frans\\.claude\\settings.json (solo la clave hooks), ${RAIZ}\\perfil-global\\hooks\\, ${RAIZ}\\chequeo-completo.ps1, ${RAIZ}\\.claude\\arranque.md.` },
  { key: 'puerta-cascada-fase', foco: `LA PUERTA, LA CASCADA Y LA FASE. Ya se leyo (no lo releas entero): ${RAIZ}\\.claude\\hooks\\cascada_puerta.py tiene exigido() l.183-245 (base + requisitos opt-in + necesidades + conceptos), pre() l.487-580 (niega por necesidad sin declarar, por rango sin leer, por exigido inexistente y SIN REQUISITOS), cli_exige l.753, cli_verificar l.824 (el rojo de requisitos solo si el proyecto declara 'diseno' por defecto); fase_activa.py informa la fase tipada una vez por sesion y falla abierto; medir-fases.py mide 6 de 22 en A-D sin requisitos. Te toca: como se INFIERE el proyecto (proyecto_de l.278, inferidos_de l.321, senales fuertes/debiles del catalogo ${RAIZ}\\.claude\\cascada.json; hoy la palabra BLACK de un retome pegado nego una accion de otro proyecto), el lanzador ${RAIZ}\\.claude\\hooks\\puerta-lanzador.py, perfil-global\\hooks\\puerta-afuera.py, el tamano de lo exigido por necesidad y por concepto (sumando rangos del catalogo), y el diseno en ${AS}\\docs\\t11-cascada-obligatoria.md (secciones 4.x).` },
  { key: 'pdp-plantillas-cuadro', foco: `PDP, PLANTILLAS, NATURALEZAS Y CUADRO: ${RAIZ}\\plantillas\\ (PDP.md: ya tiene secciones 1 El problema, 2 Que NO es, 3 rigor por aspecto, 4 fases, 5 Riesgos, 6 Decisiones, 7 Verificacion, 8 Matriz; naturalezas\\*.md), ${RAIZ}\\nuevo-proyecto.ps1, los PDP reales (proyectos\\*\\*\\PDP.md: si las secciones 2, 5 y 7 estan llenas o son la plantilla, cuantas fases tipadas), medir-fase.py y medir-matriz.py, el cuadro (${RAIZ}\\perfil-global\\apertura-proyecto.md y la skill cuadro-de-fase), el libro de bolsillo perfil-global\\pilares\\nucleo-ise.md. Diseno: ${AS}\\docs\\arquitectura.md (D1-D14, piezas P1-P10) y ${AS}\\docs\\matriz-cumplimiento.md.` },
  { key: 'lecciones-defectos-auditoria', foco: `LECCIONES, CHEQUEO, DEFECTOS Y AUDITORIA: ${RAIZ}\\perfil-global\\herramientas\\aprender.py y aprendizaje\\lecciones.jsonl (379 lecciones: distribucion de nivel y triage con un comando), chequeo-de-trabajo.md y su nucleo generado (nucleo-chequeo.py), perfil-global\\herramientas\\defectos.py, ${RAIZ}\\auditar-sesion.py (P1-P11; P7 da NO APLICA si el proyecto no declara requisitos, l.333; P10 rojo si hubo excepcion sin leccion), ${RAIZ}\\.claude\\auditorias\\ (21 informes), ${RAIZ}\\lluvia-de-ideas.py. Para cada uno: que lazo cierra (deteccion -> registro -> que cambia en la sesion siguiente), quien lo dispara y que pasa si nadie lo corre.` },
  { key: 'verificadores-saboteadores', foco: `VERIFICADORES Y SABOTEADORES: ${RAIZ}\\chequeo-completo.ps1 (inventario de medidores, saboteadores y limpieza, con sus tiempos si los registra), verificar-estructura.ps1, probar-hooks.ps1, los guardias (.claude\\hooks\\guardia-iso.ps1, perfil-global\\hooks\\guardia-escapes.ps1, guardia-fanout.ps1), publicar-apuntes.ps1, verificar-drive.ps1, verificar-sincronia.ps1. Para cada uno: mide el OBJETO o la precondicion, FRENA o informa, quien lo dispara y cada cuanto, y su saboteador. El inventario con conteo; el diagnostico previo esta en ${AS}\\docs\\diagnostico-2026-09-28.md (A5, A6) y en ${RAIZ}\\MAPA.md.` },
  { key: 'estado-handoff-retomes', foco: `ESTADO, HANDOFF, BITACORA Y RETOMES: tamanos de todos los ESTADO_ACTUAL.md y HANDOFF.md (un solo Get-ChildItem recursivo filtrado), cuales crecen sin techo, que datos duplican (fase, estado) que viven en el PDP o en el enrutador, cuanto exige leer la puerta de ellos (rangos en ${RAIZ}\\.claude\\cascada.json, clave 'base' y 'vistas'), los RETOME*.md, la especificacion del retome en ${RAIZ}\\perfil-global\\apertura-proyecto.md, la regla 5 del perfil (checkpoint). Diagnostico previo: ${AS}\\docs\\diagnostico-2026-09-28.md (A2, A3, A7).` },
  { key: 'nube-paridad', foco: `NUBE Y PARIDAD: ${RAIZ}\\.claude\\nube\\ (traer-perfil.sh, estado-nube.py), el settings.json trackeado con $CLAUDE_PROJECT_DIR, perfil-global\\install.ps1 y verify-install.ps1, el espejo perfil-global\\memoria, bootstrap.ps1, MAQUINA-NUEVA.md, verificar-sincronia.ps1, el exportador de metodo-agustin. Que capacidades tiene la PC y no la nube, que llega solo y que depende de leer un aviso, que se desincroniza. Diseno: ${AS}\\docs\\t7-paridad-nube.md (seccion 4 quinquies).` },
]

const SCHEMA = {
  type: 'object',
  properties: {
    subsistema: { type: 'string' },
    resumen: { type: 'string' },
    componentes: { type: 'array', maxItems: 15, items: { type: 'object', properties: {
      nombre: { type: 'string' }, ruta: { type: 'string' }, rol: { type: 'string' },
      disparador: { type: 'string' }, frena: { type: 'string' }, costo: { type: 'string' }, saboteador: { type: 'string' },
    }, required: ['nombre', 'ruta', 'rol', 'disparador', 'frena', 'costo', 'saboteador'] } },
    interfaces: { type: 'array', maxItems: 10, items: { type: 'object', properties: {
      desde: { type: 'string' }, hacia: { type: 'string' }, dato: { type: 'string' }, dueno_del_dato: { type: 'string' }, evidencia: { type: 'string' },
    }, required: ['desde', 'hacia', 'dato', 'dueno_del_dato', 'evidencia'] } },
    mediciones: { type: 'array', items: { type: 'object', properties: {
      que: { type: 'string' }, valor: { type: 'string' }, como: { type: 'string' },
    }, required: ['que', 'valor', 'como'] } },
    modos_de_falla: { type: 'array', maxItems: 8, items: { type: 'object', properties: {
      forma: { type: 'string', enum: ['no-actua', 'actua-mal', 'tarde', 'deja-de-actuar'] },
      descripcion: { type: 'string' }, evidencia: { type: 'string' }, grado: { type: 'string' },
    }, required: ['forma', 'descripcion', 'evidencia', 'grado'] } },
    observaciones_conceptuales: { type: 'array', maxItems: 8, items: { type: 'object', properties: {
      observacion: { type: 'string' }, evidencia: { type: 'string' }, grado: { type: 'string' }, relacion: { type: 'string' },
    }, required: ['observacion', 'evidencia', 'grado', 'relacion'] } },
    comandos_negados: { type: 'array', items: { type: 'string' } },
  },
  required: ['subsistema', 'resumen', 'componentes', 'interfaces', 'mediciones', 'modos_de_falla', 'observaciones_conceptuales', 'comandos_negados'],
}

phase('Mapa')
const mapas = (await parallel(SUBSISTEMAS.map(s => () =>
  agent(`${COMUN}\n\nTU SUBSISTEMA: ${s.foco}`, { label: `mapa:${s.key}`, phase: 'Mapa', schema: SCHEMA, effort: 'low' })))).filter(Boolean)
log(`${mapas.length} de ${SUBSISTEMAS.length} subsistemas mapeados`)
if (mapas.length < SUBSISTEMAS.length) log('FALTAN subsistemas: el documento los va a declarar ausentes')

phase('Consolidar')
const redaccion = await agent(`Sos el redactor del MAPA del metodo de trabajo de Fran. Abajo van ${mapas.length} mapas (JSON), uno por subsistema (de ${SUBSISTEMAS.length} previstos: ${SUBSISTEMAS.map(s => s.key).join(', ')}; si falta alguno, declaralo ausente). Escribi con Write el archivo ${AS}\\docs\\mapa-metodo-2026-10-12.md, en espanol rioplatense formal, sin acentos raros en las rutas:
1. Un parrafo: que es (insumo de la busqueda de defectos de la sesion de arquitectura del 2026-10-12) y que el grado de cada dato viene del lector.
2. Por subsistema: resumen; tabla de componentes (nombre | ruta | disparador | frena/informa | costo | saboteador); interfaces; mediciones; modos de falla por forma de Leveson; observaciones conceptuales con evidencia, grado y relacion.
3. Transversal: (a) N2 de interfaces entre subsistemas; (b) tabla "que dispara a que" con el conteo de componentes por fase / palabra / archivo / cadencia / evento del harness / manual / nada; (c) costos sumables por sesion, turno y entrada, sin inventar; (d) comandos negados.
No inventes; si dos lectores se contradicen, las dos versiones. Las evidencias (ruta:linea) se copian. Devolve SOLO la ruta escrita y 10-25 lineas con las observaciones conceptuales mas fuertes (subsistema, relacion). Si la escritura falla, devolve el documento entero empezando con "NO SE PUDO ESCRIBIR".

MAPAS:
${JSON.stringify(mapas)}`, { label: 'redactor', phase: 'Consolidar', effort: 'low' })

return { n: mapas.length, mapas, redaccion }
