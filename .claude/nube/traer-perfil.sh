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
#   - DA-106: antes de instalar, prueba la CREDENCIAL por su efecto (leer el remoto y push en seco a claude-acceso y
#     perfil-global) y da ROJO con la cuenta de GitHub que ve la sesion.
#
# Uso:   bash .claude/nube/traer-perfil.sh            (al abrir CUALQUIER sesion sin el perfil)
#        bash .claude/nube/traer-perfil.sh --probar
#        bash .claude/nube/traer-perfil.sh --sabotaje  (sin la prueba de credencial, --probar tiene que dar rojo)
set -u

MARCA='Perfil global'
ARCHIVOS=(apertura-proyecto.md recordatorio-transversal.md chequeo-nucleo.md chequeo-de-trabajo.md pilares.md)
DUENO='fransalomone21'

# La cuenta de GitHub con la que corre ESTA sesion (DA-106, 2026-11-05: tres sesiones de la noche arrancaron con otra
# cuenta, sin leer lo privado ni pushear, y desde la PC nada podia verlo: alla gh es la de Fran). Se pregunta a GitHub,
# no al mail de git (que en la nube es el de Claude).
cuenta() {
    local c
    c="$(eval "${CUENTA_CMD:-timeout 20 gh api user --jq .login}" 2>/dev/null | head -1)"
    printf '%s' "${c:-desconocida (gh api user no contesto)}"
}

# La CREDENCIAL se mide por su efecto: un push en seco a cada repo que la sesion tiene que escribir, y una lectura del
# remoto de lo privado. Lo que da verde en la PC no prueba la credencial de la nube. Devuelve 1 y da ROJO con la
# cuenta y lo que fallo. Los repos se pueden cambiar con CREDENCIAL_REPOS (el saboteador lo usa).
credencial() {
    local perfil="$1" raiz repo malos=0 c
    raiz="$(git rev-parse --show-toplevel 2>/dev/null)"
    c="$(cuenta)"
    for repo in ${CREDENCIAL_REPOS:-$raiz $perfil}; do
        [ -n "$repo" ] || continue
        if ! timeout 30 git -C "$repo" ls-remote -q origin HEAD >/dev/null 2>&1; then
            echo "[ROJO] credencial: la cuenta '$c' no puede LEER el remoto de $repo ($(git -C "$repo" config --get remote.origin.url 2>/dev/null))"
            malos=$((malos+1)); continue
        fi
        if ! timeout 30 git -C "$repo" push -q --dry-run origin HEAD:refs/heads/claude/prueba-permisos >/dev/null 2>&1; then
            echo "[ROJO] credencial: la cuenta '$c' no puede PUSHEAR a $(git -C "$repo" config --get remote.origin.url 2>/dev/null)"
            malos=$((malos+1))
        fi
    done
    if [ $malos -gt 0 ]; then
        echo "  Esta sesion no puede dejar nada en GitHub: se cierra YA con una linea (cuenta '$c', que fallo)."
        echo "  Lo arregla Fran conectando SU cuenta en claude.ai (Settings > Connectors > GitHub), no la sesion."
        return 1
    fi
    case "$c" in
        "$DUENO") echo "[OK] credencial: cuenta '$c', lee y pushea ${CREDENCIAL_REPOS:-claude-acceso y perfil-global}" ;;
        *) echo "[OK] credencial: lee y pushea, con la cuenta '$c' (no es la de Fran, '$DUENO': mirar si es la que se quiso)" ;;
    esac
    return 0
}

traer() {
    local perfil="$1" destino="$2"
    if ! git -C "$perfil" rev-parse --git-dir >/dev/null 2>&1; then
        echo "[ROJO] el perfil no esta en $perfil. NO se arranca ninguna tarea sin el. Cuenta de GitHub: '$(cuenta)'."
        echo "  1. herramienta add_repo: owner fransalomone21, repo perfil-global, access push"
        echo "  2. git clone --depth 1 https://github.com/fransalomone21/perfil-global $perfil"
        echo "  3. volver a correr: bash .claude/nube/traer-perfil.sh"
        return 1
    fi
    git -C "$perfil" pull -q --ff-only >/dev/null 2>&1 || echo "  (aviso: no se pudo actualizar el perfil; se usa el que hay)"
    # La credencial va ANTES de instalar nada: sin poder pushear ni leer lo privado, la sesion no trabaja (DA-106).
    credencial "$perfil" || return 1
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
    # Todas las herramientas, no solo aprender.py (2026-11-05, DA de la nube: los compiladores y el guardia llaman a
    # ~/.claude/herramientas/lint-typst.py, y en la nube no estaba: se compilaba sin la llave fija de DA-079).
    cp "$perfil/herramientas/"*.py "$destino/herramientas/" 2>/dev/null
    # Los dos guardias del perfil que estan en python: los registra .claude/settings.json, solo donde no hay powershell.
    mkdir -p "$destino/hooks"
    local g
    for g in guardia-typst.py al-paso.py; do
        [ -f "$perfil/hooks/$g" ] && cp "$perfil/hooks/$g" "$destino/hooks/"
    done
    # Los paquetes de Typst, con la version exacta que usa la PC: compilar no depende de que la nube llegue a
    # packages.typst.org, y una version distinta no re-maqueta el documento.
    local cache="${TYPST_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/typst/packages}"
    if [ -d "$perfil/typst-packages/preview" ]; then
        mkdir -p "$cache" && cp -r "$perfil/typst-packages/preview" "$cache/"
    fi
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
    # La auto-memoria (preferencias de Fran, cursada, criterios). En la PC vive solo en ~/.claude/projects/<raiz>/
    # memory y la puerta exige leer seis de ellas para 'materia': en la nube daban NO EXISTE y la puerta negaba toda
    # sesion de materia (2026-10-06). El espejo es perfil-global/memoria (privado), lo escribe
    # '.claude/nube/estado-nube.py --sincronizar-memoria' en la PC, y estado-nube.py da rojo si quedo viejo.
    local raiz slug mem=""
    raiz="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -d "$perfil/memoria" ] && [ -n "$raiz" ]; then
        slug="$(printf '%s' "$raiz" | sed 's#[:\\/]#-#g')"
        mem="$destino/projects/$slug/memory"
        mkdir -p "$mem" && cp "$perfil/memoria/"*.md "$mem/" 2>/dev/null
        if [ "$(ls "$perfil/memoria/"*.md 2>/dev/null | wc -l)" -ne "$(ls "$mem/"*.md 2>/dev/null | wc -l)" ]; then
            echo "[ROJO] memoria: no se copio entera a $mem."
            return 1
        fi
    fi
    # Se mide el EFECTO: lo instalado tiene la marca y no esta vacio, y estan todas las skills.
    if ! grep -q "$MARCA" "$destino/CLAUDE.md" 2>/dev/null; then
        echo "[ROJO] se copio pero $destino/CLAUDE.md no tiene el perfil."
        return 1
    fi
    if [ "$puestas" -ne "$esperadas" ]; then
        echo "[ROJO] skills: $puestas de $esperadas instaladas en $destino/skills."
        return 1
    fi
    if [ "$(ls "$perfil/herramientas/"*.py 2>/dev/null | wc -l)" -ne "$(ls "$destino/herramientas/"*.py 2>/dev/null | wc -l)" ]; then
        echo "[ROJO] herramientas: no se copiaron todas a $destino/herramientas."
        return 1
    fi
    if [ -d "$perfil/typst-packages/preview" ] && [ "$(find "$perfil/typst-packages/preview" -name typst.toml | wc -l)" -ne "$(find "$cache/preview" -name typst.toml 2>/dev/null | wc -l)" ]; then
        echo "[ROJO] paquetes de Typst: no quedaron todos en $cache/preview."
        return 1
    fi
    echo "[OK] perfil instalado en $destino (de $perfil, commit $(git -C "$perfil" rev-parse --short HEAD 2>/dev/null)), $puestas skills"
    echo
    echo "LEER AHORA, con Read, ENTEROS y en este orden, ANTES de cualquier tarea:"
    echo "  1. $perfil/CLAUDE-global.md        las reglas (y la 16: el libro primero)"
    echo "  2. $perfil/apertura-proyecto.md    el cuadro de cada respuesta y el retome"
    echo "  3. $perfil/chequeo-nucleo.md       las lecciones, por momento de aplicacion"
    echo "  4. $perfil/recordatorio-transversal.md"
    [ -n "$mem" ] && echo "  5. $mem/MEMORY.md   la memoria de Fran (en la nube llega despues de que el harness la buscara)"
    echo "Proyecto con repo propio (catedras, coaching...): python3 .claude/nube/estado-nube.py --traer <proyecto>"
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
    mkdir -p "$tmp/p/memoria" && echo '- [x](x.md)' > "$tmp/p/memoria/MEMORY.md"
    echo 'print(2)' > "$tmp/p/herramientas/lint-typst.py"
    mkdir -p "$tmp/p/hooks" && echo 'print(3)' > "$tmp/p/hooks/guardia-typst.py"
    mkdir -p "$tmp/p/typst-packages/preview/cetz/0.5.2" && echo '[package]' > "$tmp/p/typst-packages/preview/cetz/0.5.2/typst.toml"
    export TYPST_CACHE_DIR="$tmp/cache"
    # La credencial (DA-106) se prueba contra remotos locales: el perfil falso con un origin que se lee y se pushea.
    git -C "$tmp/p" -c user.email=t@t -c user.name=t add -A >/dev/null && git -C "$tmp/p" -c user.email=t@t -c user.name=t commit -qm p
    git init -q --bare "$tmp/remoto.git" && git -C "$tmp/p" remote add origin "$tmp/remoto.git"
    export CREDENCIAL_REPOS="$tmp/p" CUENTA_CMD="echo cuenta-de-prueba"
    out="$(traer "$tmp/p" "$tmp/d2")"; rc=$?
    if [ $rc -eq 0 ] && grep -q "$MARCA" "$tmp/d2/CLAUDE.md" && [ -f "$tmp/d2/chequeo-nucleo.md" ] \
       && [ -f "$tmp/d2/skills/una-skill/SKILL.md" ] && ls "$tmp/d2/projects/"*/memory/MEMORY.md >/dev/null 2>&1; then
        echo "[OK] perfil valido -> verde, ~/.claude/CLAUDE.md con el perfil, la skill y la memoria"
    else echo "[FALLA] perfil valido tenia que instalar y dar verde (rc=$rc)"; malos=$((malos+1)); fi
    # 2b. lo que la PC tiene y la nube no recibia (DA de la nube, 2026-11-05)
    if [ -f "$tmp/d2/herramientas/lint-typst.py" ] && [ -f "$tmp/d2/hooks/guardia-typst.py" ] \
       && [ -f "$tmp/cache/preview/cetz/0.5.2/typst.toml" ]; then
        echo "[OK] el lint, el guardia de Typst y los paquetes quedan instalados"
    else echo "[FALLA] falta el lint, el guardia o los paquetes de Typst"; malos=$((malos+1)); fi
    # 2c. sabotaje: un destino donde herramientas/ no se puede completar tiene que dar rojo, no verde
    mkdir -p "$tmp/d4" && : > "$tmp/d4/herramientas"
    out="$(traer "$tmp/p" "$tmp/d4" 2>/dev/null)"; rc=$?
    if [ $rc -ne 0 ]; then echo "[ROJO OK] herramientas sin copiar -> rojo"
    else echo "[FALLA] con herramientas sin copiar tenia que dar rojo"; malos=$((malos+1)); fi
    # 2d. DA-106: la credencial se ve en el verde, con la cuenta
    out="$(traer "$tmp/p" "$tmp/d5")"; rc=$?
    if [ $rc -eq 0 ] && grep -q "credencial: lee y pushea, con la cuenta 'cuenta-de-prueba'" <<<"$out"; then
        echo "[OK] credencial sana -> verde, y dice la cuenta (y que no es la de Fran)"
    else echo "[FALLA] con la credencial sana tenia que dar verde nombrando la cuenta (rc=$rc)"; malos=$((malos+1)); fi
    # 2e. sabotaje DA-106: se lee y NO se pushea (el 403 de la primera vuelta del 2026-11-05) -> rojo con la cuenta
    git -C "$tmp/p" remote set-url --push origin "$tmp/no-se-pushea.git"
    out="$(traer "$tmp/p" "$tmp/d6")"; rc=$?
    if [ $rc -ne 0 ] && grep -q "la cuenta 'cuenta-de-prueba' no puede PUSHEAR" <<<"$out" && [ ! -f "$tmp/d6/CLAUDE.md" ]; then
        echo "[ROJO OK] sin push -> rojo con la cuenta, y no instala nada"
    else echo "[FALLA] sin push tenia que dar rojo con la cuenta antes de instalar (rc=$rc)"; malos=$((malos+1)); fi
    # 2f. sabotaje DA-106: no se lee el remoto (lo privado con otra cuenta) -> rojo con la cuenta
    git -C "$tmp/p" remote set-url origin "$tmp/no-existe.git"
    out="$(traer "$tmp/p" "$tmp/d7")"; rc=$?
    if [ $rc -ne 0 ] && grep -q "la cuenta 'cuenta-de-prueba' no puede LEER" <<<"$out"; then
        echo "[ROJO OK] sin leer lo privado -> rojo con la cuenta"
    else echo "[FALLA] sin leer el remoto tenia que dar rojo con la cuenta (rc=$rc)"; malos=$((malos+1)); fi
    git -C "$tmp/p" remote set-url origin "$tmp/remoto.git" && git -C "$tmp/p" remote set-url --push origin "$tmp/remoto.git"
    # 3. perfil sin la marca (repo equivocado o vacio): rojo
    printf 'otra cosa\n' > "$tmp/p/CLAUDE-global.md"
    out="$(traer "$tmp/p" "$tmp/d3")"; rc=$?
    if [ $rc -ne 0 ] && grep -q "no es el perfil" <<<"$out"; then echo "[ROJO OK] perfil sin la marca -> rojo"
    else echo "[FALLA] perfil sin la marca tenia que dar rojo (rc=$rc)"; malos=$((malos+1)); fi
    rm -rf "${tmp:?}"
    if [ $malos -eq 0 ]; then echo "TODO BIEN"; return 0; else echo "$malos caso(s) en FALLA"; return 1; fi
}

sabotaje() {
    # DA-106: un traer-perfil sin la prueba de credencial tiene que poner --probar en ROJO. Sale 0 si lo detecta.
    local m rc
    m="$(mktemp)"
    sed 's/^    credencial "\$perfil" || return 1$/    true  # MUTANTE: sin credencial/' "${BASH_SOURCE[0]}" > "$m"
    if ! grep -q 'MUTANTE: sin credencial' "$m"; then echo "[FALLA] no pude armar el mutante"; rm -f "$m"; return 1; fi
    bash "$m" --probar >/dev/null 2>&1; rc=$?
    rm -f "$m"
    if [ $rc -ne 0 ]; then echo "sabotaje DETECTADO: sin la prueba de credencial, --probar da rojo"; return 0; fi
    echo "sabotaje NO detectado: --probar no mira la credencial"; return 1
}

if [ "${1:-}" = "--probar" ]; then
    probar
elif [ "${1:-}" = "--sabotaje" ]; then
    sabotaje
else
    traer "${PERFIL_DIR:-/home/user/perfil-global}" "${CLAUDE_HOME_DIR:-$HOME/.claude}"
fi
