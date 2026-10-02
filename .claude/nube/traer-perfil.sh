#!/usr/bin/env bash
# traer-perfil.sh -- EL LIBRO PRIMERO. Ninguna sesion trabaja sin el perfil de Fran cargado.
#
# Por que existe (2026-10-02): una sesion en la nube escribio doce modulos y cuatro herramientas
# SIN el perfil. El retome decia "el perfil no existe en la nube, no pelear con eso" y nadie lo
# midio: perfil-global estaba en GitHub y se sumaba con add_repo en un minuto. Resultado: seis de
# sus errores ya estaban escritos como lecciones en el nucleo, y la regla 15 no la conocia.
# "Si Claude es un arquitecto que depende de llevar su libro a todos lados y se lo olvida, deja
# de ser arquitecto" (Fran). Por eso este aviso vive AFUERA del libro: en el CLAUDE.md de
# claude-acceso, que es lo unico que llega solo a cualquier clon.
#
# Que hace:
#   - si el perfil NO esta clonado: ROJO, y dice exactamente como traerlo (add_repo + clone).
#   - si esta: lo actualiza, lo instala en ~/.claude (CLAUDE.md, apertura, recordatorio, nucleo,
#     chequeo, pilares, aprender.py), MIDE que quedo (no que se copio), y lista que leer YA.
#   - --probar: el saboteador. Sin perfil exige rojo; con un perfil falso exige verde e instalado;
#     con un perfil sin la marca exige rojo. Corre en carpetas temporales: no toca ~/.claude.
#
# Uso:   bash .claude/nube/traer-perfil.sh            (al abrir CUALQUIER sesion sin el perfil)
#        bash .claude/nube/traer-perfil.sh --probar
set -u

MARCA='Perfil global'
ARCHIVOS=(apertura-proyecto.md recordatorio-transversal.md chequeo-nucleo.md chequeo-de-trabajo.md pilares.md)

traer() {
    local perfil="$1" destino="$2"
    if ! git -C "$perfil" rev-parse --git-dir >/dev/null 2>&1; then
        echo "[ROJO] el perfil no esta en $perfil. NO se arranca ninguna tarea sin el."
        echo "  1. herramienta add_repo: owner fransalomone21, repo perfil-global, access push"
        echo "  2. git clone --depth 1 https://github.com/fransalomone21/perfil-global $perfil"
        echo "  3. volver a correr: bash .claude/nube/traer-perfil.sh"
        return 1
    fi
    git -C "$perfil" pull -q --ff-only >/dev/null 2>&1 || echo "  (aviso: no se pudo actualizar el perfil; se usa el que hay)"
    if ! grep -q "$MARCA" "$perfil/CLAUDE-global.md" 2>/dev/null; then
        echo "[ROJO] $perfil/CLAUDE-global.md no existe o no es el perfil (falta '$MARCA')."
        return 1
    fi
    mkdir -p "$destino/herramientas" "$destino/aprendizaje"
    cp "$perfil/CLAUDE-global.md" "$destino/CLAUDE.md"
    local f
    for f in "${ARCHIVOS[@]}"; do
        [ -f "$perfil/$f" ] && cp "$perfil/$f" "$destino/$f"
    done
    [ -f "$perfil/herramientas/aprender.py" ] && cp "$perfil/herramientas/aprender.py" "$destino/herramientas/"
    [ -d "$perfil/aprendizaje/fichas" ] && cp -r "$perfil/aprendizaje/fichas" "$destino/aprendizaje/"
    # Las skills (perfil-global/<s>/SKILL.md -> ~/.claude/skills/<s>/, como install.ps1). La puerta exige leer
    # varias, y sin esto en la nube no estaban: la puerta las salteaba en silencio (T7, 2026-10-02).
    local d s esperadas=0 puestas=0
    for d in "$perfil"/*/; do
        [ -f "$d/SKILL.md" ] || continue
        s="$(basename "$d")"
        esperadas=$((esperadas+1))
        mkdir -p "$destino/skills/$s" && cp -r "$d". "$destino/skills/$s/"
        [ -f "$destino/skills/$s/SKILL.md" ] && puestas=$((puestas+1))
    done
    # Se mide el EFECTO: lo instalado tiene la marca y no esta vacio, y estan todas las skills.
    if ! grep -q "$MARCA" "$destino/CLAUDE.md" 2>/dev/null; then
        echo "[ROJO] se copio pero $destino/CLAUDE.md no tiene el perfil."
        return 1
    fi
    if [ "$puestas" -ne "$esperadas" ]; then
        echo "[ROJO] skills: $puestas de $esperadas instaladas en $destino/skills."
        return 1
    fi
    echo "[OK] perfil instalado en $destino (de $perfil, commit $(git -C "$perfil" rev-parse --short HEAD 2>/dev/null)), $puestas skills"
    echo
    echo "LEER AHORA, con Read, ENTEROS y en este orden, ANTES de cualquier tarea:"
    echo "  1. $perfil/CLAUDE-global.md        las reglas (y la 16: el libro primero)"
    echo "  2. $perfil/apertura-proyecto.md    el cuadro de cada respuesta y el retome"
    echo "  3. $perfil/chequeo-nucleo.md       las lecciones, por momento de aplicacion"
    echo "  4. $perfil/recordatorio-transversal.md"
    echo "Lecciones nuevas: python3 $perfil/herramientas/aprender.py agregar ... (y commit + push de perfil-global)"
    echo "Buscar antes de pelear: python3 $perfil/herramientas/aprender.py buscar \"<sintoma>\""
    return 0
}

probar() {
    local tmp malos=0 out rc
    tmp="$(mktemp -d)"
    # 1. sin perfil: rojo, con la instruccion de add_repo
    out="$(traer "$tmp/no-existe" "$tmp/d1")"; rc=$?
    if [ $rc -ne 0 ] && grep -q add_repo <<<"$out"; then echo "[ROJO OK] sin perfil -> rojo y dice add_repo"
    else echo "[FALLA] sin perfil tenia que dar rojo con add_repo (rc=$rc)"; malos=$((malos+1)); fi
    # 2. perfil falso valido: verde e instalado (control positivo)
    mkdir -p "$tmp/p/herramientas" && git -C "$tmp/p" init -q
    printf '# %s -- Fran (prueba)\n' "$MARCA" > "$tmp/p/CLAUDE-global.md"
    echo nucleo > "$tmp/p/chequeo-nucleo.md"; echo 'print(1)' > "$tmp/p/herramientas/aprender.py"
    mkdir -p "$tmp/p/una-skill" && echo '# skill' > "$tmp/p/una-skill/SKILL.md"
    out="$(traer "$tmp/p" "$tmp/d2")"; rc=$?
    if [ $rc -eq 0 ] && grep -q "$MARCA" "$tmp/d2/CLAUDE.md" && [ -f "$tmp/d2/chequeo-nucleo.md" ] \
       && [ -f "$tmp/d2/skills/una-skill/SKILL.md" ]; then
        echo "[OK] perfil valido -> verde, ~/.claude/CLAUDE.md con el perfil y la skill en skills/"
    else echo "[FALLA] perfil valido tenia que instalar y dar verde (rc=$rc)"; malos=$((malos+1)); fi
    # 3. perfil sin la marca (repo equivocado o vacio): rojo
    printf 'otra cosa\n' > "$tmp/p/CLAUDE-global.md"
    out="$(traer "$tmp/p" "$tmp/d3")"; rc=$?
    if [ $rc -ne 0 ] && grep -q "no es el perfil" <<<"$out"; then echo "[ROJO OK] perfil sin la marca -> rojo"
    else echo "[FALLA] perfil sin la marca tenia que dar rojo (rc=$rc)"; malos=$((malos+1)); fi
    rm -rf "${tmp:?}"
    if [ $malos -eq 0 ]; then echo "TODO BIEN"; return 0; else echo "$malos caso(s) en FALLA"; return 1; fi
}

if [ "${1:-}" = "--probar" ]; then
    probar
else
    traer "${PERFIL_DIR:-/home/user/perfil-global}" "${CLAUDE_HOME_DIR:-$HOME/.claude}"
fi
