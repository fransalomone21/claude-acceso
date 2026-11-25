"""El indice de juegos de la casa (fase 1 de juegos-casa): L1-01, L1-02, L1-03, L1-07, L1-11, L1-12, L2-*.

  python indice.py inventario --maquina note|pc|ambas   mide la maquina (scripts/inventario.ps1) y lo guarda
  python indice.py plan       --maquina ...             que haria el generador, sin tocar nada
  python indice.py generar    --maquina ...             arma Escritorio\\Juegos desde el catalogo (L2-GEN-01)
  python indice.py verificar  --maquina ...             0 = el indice esta completo; 1 = falta algo, nombrado (L2-VER-01)
  python indice.py sabotaje   --maquina ...             saca un juego del indice a proposito y exige el rojo con su nombre

Como queda Escritorio\\Juegos de cada maquina:
  1 - Todos los juegos\\   un acceso por juego (o una carpeta si tiene varias formas de arrancar)
  2 - De a dos\\           una carpeta por juego de a dos, con sus accesos y «Como jugar de a dos.txt» (L1-07)
  3 - Por modo\\, 4 - Por tipo\\, 5 - Por version\\   los ejes de clasificacion (L1-02, L1-11)
  Minecraft\\              destacado: los accesos de Minecraft juntos
  BLACK, Emuladores, Utilidades, Mods, Juegos de PC, Juegos instalados, Juegos de emulador: NO se tocan
  (son de otros proyectos o tienen juegos instalados adentro).

Los accesos del indice viejo (los sueltos de Juegos\\, «Juegos de a dos», «Sega - los dos en la PC», «Juegos de
PC\\Accesos» y «Minecraft») se MUEVEN al almacen de lanzadores C:\\Games\\_indice\\accesos\\ con su ruta, y el
indice los copia de ahi (L2-GEN-03/04): nada se borra. Lo que el generador mismo genero (carpetas con la marca
.indice-generado) lo regenera.

Las rutas de cada maquina viven en inventario/ (ignorado por git): el catalogo del repo no las lleva.
"""
import base64, csv, datetime, json, os, re, subprocess, sys, tempfile

AQUI = os.path.dirname(os.path.abspath(__file__))
PROY = os.path.dirname(AQUI)
CATALOGO = os.path.join(AQUI, "catalogo.json")
INVENTARIO_PS1 = os.path.join(AQUI, "inventario.ps1")
DATOS = os.path.join(PROY, "inventario")          # ignorado por git
LLAVE = os.path.expanduser(r"~\.ssh\pc-cable")
PC = "Fran@10.147.20.3"
ALMACEN = r"C:\Games\_indice\accesos"
PCSX2 = r"C:\Games\PCSX2-2.8.2\pcsx2-qt.exe"
MARCA = ".indice-generado"
RAICES = ["1 - Todos los juegos", "2 - De a dos", "3 - Por modo", "4 - Por tipo", "5 - Por version"]
MIGRAR = ["Juegos", r"Juegos\Juegos de a dos", r"Juegos\Sega - los dos en la PC", r"Juegos\Juegos de PC\Accesos", r"Juegos\Minecraft"]
MODOS_DE_A_DOS = {"dos jugadores", "cooperativo", "pantalla dividida", "cada uno en su pantalla"}
INVALIDOS = re.compile(r'[\\/:*?"<>|]')


# ---------------------------------------------------------------- correr en una maquina
def correr_ps(maquina, texto, nombre):
    """Corre un script de PowerShell en la maquina y devuelve stdout. La PC, por scp + ssh (nunca cmd: el SSH de
    la PC abre PowerShell; leccion de juegos-casa del 2026-11-25)."""
    with tempfile.NamedTemporaryFile("w", suffix=".ps1", delete=False, encoding="utf-8-sig") as f:
        f.write(texto)
        tmp = f.name
    try:
        if maquina == "note":
            r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", tmp],
                               capture_output=True, text=True, encoding="utf-8", errors="replace")
        else:
            remoto = f"C:/Games/_scripts/{nombre}"
            c = subprocess.run(["scp", "-q", "-i", LLAVE, tmp, f"{PC}:{remoto}"], capture_output=True, text=True)
            if c.returncode != 0:
                raise SystemExit(f"la PC no contesta (scp exit {c.returncode}): {c.stderr.strip()[:200]}")
            r = subprocess.run(["ssh", "-o", "ConnectTimeout=15", "-i", LLAVE, PC,
                                f"powershell -NoProfile -ExecutionPolicy Bypass -File {remoto}"],
                               capture_output=True, text=True, encoding="utf-8", errors="replace")
    finally:
        os.remove(tmp)
    if r.returncode != 0:
        raise SystemExit(f"[{maquina}] el script {nombre} fallo (exit {r.returncode}): {r.stderr.strip()[:500]}")
    return r.stdout


def json_de(salida):
    i = salida.find("{")
    return json.loads(salida[i:])


# ---------------------------------------------------------------- inventario
def inventario(maquina):
    texto = open(INVENTARIO_PS1, encoding="utf-8-sig").read()
    inv = json_de(correr_ps(maquina, texto, "inventario.ps1"))
    os.makedirs(DATOS, exist_ok=True)
    json.dump(inv, open(os.path.join(DATOS, f"{maquina}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    return inv


def cargar_inventario(maquina):
    p = os.path.join(DATOS, f"{maquina}.json")
    if not os.path.exists(p):
        return inventario(maquina)
    return json.load(open(p, encoding="utf-8"))


# ---------------------------------------------------------------- plan
def nombre_ok(s):
    return INVALIDOS.sub(" -", s).strip().rstrip(".")


def es_de(rel, carpeta):
    """rel (relativo al Escritorio) esta en la carpeta a migrar? 'Juegos' = solo los sueltos de Juegos\\."""
    d = os.path.dirname(rel).lower()
    if carpeta == "Juegos":
        return d == "juegos"
    return d == carpeta.lower() or d.startswith(carpeta.lower() + "\\")


def accesos_de(inv):
    """Los accesos utilizables: los del almacen, los de carpetas que se migran (con su ruta futura en el almacen) y
    los de carpetas que se dejan como estan. Los que estan adentro de lo generado no cuentan (son copias)."""
    out, migrar = [], []
    for it in inv["items"]:
        if it["clase"] not in ("acceso", "texto"):
            continue
        rel = it.get("rel") or ""
        if it.get("almacen"):
            out.append(dict(it, src=it["ruta"], origen="almacen"))
            continue
        top = rel.split("\\")
        if it.get("generado") or (len(top) > 2 and top[0].lower() == "juegos" and top[1] in RAICES):
            continue
        if rel.lower().startswith("juegos\\") and any(es_de(rel, c) for c in MIGRAR):
            if os.path.basename(rel).lower() == "leeme.txt":
                continue
            dst = os.path.join(ALMACEN, rel)
            migrar.append({"origen": it["ruta"], "destino": dst, "rel": rel})
            out.append(dict(it, src=dst, origen="migrar"))
            continue
        if rel.lower().startswith("juegos\\"):
            out.append(dict(it, src=it["ruta"], origen="queda"))
    return out, migrar


def detecciones(inv, cat):
    """Lo que el inventario detecta como juego instalado (el universo de L1-01)."""
    nos = cat["no_son_juegos"]
    out = []
    for it in inv["items"]:
        c = it["clase"]
        if c == "carpeta":
            if any(re.search(p, it["nombre"], re.I) for p in nos["carpeta"]):
                continue
        elif c == "steam":
            if any(re.search(p, it.get("appid", ""), re.I) for p in nos["steam"]):
                continue
        elif c == "ps3":
            if any(re.search(p, it.get("id") or "", re.I) for p in nos["ps3"]):
                continue
            if (it.get("categoria") or "") not in ("GD", "HG", "DISC", "DG"):
                continue
        elif c not in ("rom", "iso", "epic"):
            continue
        out.append(it)
    return out


def coincide(regla, it):
    if regla["clase"] != it["clase"]:
        return False
    if "appid" in regla:
        return bool(re.search(regla["appid"], it.get("appid", ""), re.I))
    if "id" in regla:
        return bool(re.search(regla["id"], it.get("id") or "", re.I))
    if "titulo" in regla:
        return bool(re.search(regla["titulo"], it.get("nombre") or "", re.I))
    return bool(re.search(regla["nombre"], it.get("nombre") or "", re.I))


def clave(a):
    d = (a.get("destino") or "").strip().lower()
    return (d, (a.get("args") or "").strip()) if d else ("src", a["src"].lower())


def lanzadores_de(j, dets, accesos, usados, inv):
    out, claves = [], set()

    def agregar(l, k):
        if k in claves:
            return
        claves.add(k)
        out.append(l)

    reglas = j.get("lanzadores")
    if reglas is None:
        reglas = [{"auto": True}]
    hay_acceso = False
    for r in reglas:
        if "acceso" in r or "texto" in r:
            clase = "texto" if "texto" in r else "acceso"
            if r.get("si_no_hay") and out:
                continue
            ms = [a for a in accesos if a["clase"] == clase and re.search(r.get("acceso") or r.get("texto"), a["nombre"], re.I)
                  and id(a) not in usados]
            if r.get("uno"):
                ms = ms[:1]
            for a in ms:
                usados.add(id(a))
                nombre = r.get("nombre") if (r.get("nombre") and len(ms) == 1) else a["nombre"]
                agregar({"tipo": "copiar" if clase == "acceso" else "texto-copiar", "src": a["src"], "ext": a["ext"],
                         "nombre": nombre}, clave(a))
                hay_acceso = hay_acceso or clase == "acceso"
        elif "iso" in r:
            if r.get("si_no_hay") and hay_acceso:
                continue
            for d in dets:
                if d["clase"] == "iso" and re.search(r["iso"], d["ruta"], re.I):
                    agregar({"tipo": "lnk", "destino": PCSX2, "args": f'-fullscreen -- "{d["ruta"]}"',
                             "dir": os.path.dirname(PCSX2), "nombre": r.get("nombre") or j["nombre"], "ext": ".lnk"},
                            (PCSX2.lower(), d["ruta"].lower()))
        elif "exe" in r:
            if r.get("si_no_hay") and hay_acceso:
                continue
            for d in dets:
                if d["clase"] != "carpeta":
                    continue
                for e in d.get("exes") or []:
                    if re.search(r["exe"], e, re.I):
                        p = os.path.join(d["ruta"], e)
                        agregar({"tipo": "lnk", "destino": p, "args": "", "dir": os.path.dirname(p),
                                 "nombre": r.get("nombre") or j["nombre"], "ext": ".lnk"}, (p.lower(), ""))
                        break
        elif "ps3" in r:
            vistos = set()
            for d in dets:
                if d["clase"] == "ps3" and d.get("categoria") in ("HG", "GD", "DG", "DISC") and d["id"] not in vistos \
                        and re.search(r["ps3"], f"{d['id']} {d.get('nombre') or ''}", re.I):
                    vistos.add(d["id"])
                    exe = os.path.join(d["rpcs3"], "rpcs3.exe")
                    agregar({"tipo": "lnk", "destino": exe, "args": f'--no-gui "%RPCS3_GAMEID%:{d["id"]}"', "dir": d["rpcs3"],
                             "nombre": r.get("nombre") or j["nombre"], "ext": ".lnk"}, (exe.lower(), d["id"]))
        elif "programa" in r:
            if r.get("si_no_hay_nombre") and any(l["nombre"] == r["si_no_hay_nombre"] for l in out):
                continue
            agregar({"tipo": "lnk", "destino": r["programa"], "args": "", "dir": "", "nombre": r["nombre"], "ext": ".lnk",
                     "opcional": True}, (r["programa"].lower(), ""))
        elif "carpeta" in r:
            agregar({"tipo": "carpeta", "destino": r["carpeta"], "nombre": r["nombre"], "ext": ".lnk", "opcional": True},
                    (r["carpeta"].lower(), "carpeta"))
        elif r.get("auto"):
            for d in dets:
                if d["clase"] == "steam":
                    url = f"steam://rungameid/{d['appid']}"
                    viejo = [a for a in accesos if (a.get("destino") or "").strip() == url]
                    if viejo:
                        usados.update(id(a) for a in viejo)
                        a = viejo[0]
                        agregar({"tipo": "copiar", "src": a["src"], "ext": a["ext"], "nombre": j["nombre"]}, (url, ""))
                    else:
                        agregar({"tipo": "url", "url": url, "nombre": j["nombre"], "ext": ".url"}, (url, ""))
                elif d["clase"] == "iso":
                    agregar({"tipo": "lnk", "destino": PCSX2, "args": f'-fullscreen -- "{d["ruta"]}"',
                             "dir": os.path.dirname(PCSX2), "nombre": j["nombre"], "ext": ".lnk"}, (PCSX2.lower(), d["ruta"].lower()))
    if j.get("carpeta_propia"):
        out = [{"tipo": "carpeta", "destino": os.path.join(inv["escritorio"], "Juegos", j["carpeta_propia"]),
                "nombre": j["nombre"], "ext": ".lnk"}]
    return out


def texto_de_a_dos(j, cat):
    d = dict(j["de_a_dos"])
    if "plantilla" in d:
        base = cat["plantillas"][d["plantilla"]]
        d = dict(base, **{k: v for k, v in d.items() if k != "plantilla"})
    lineas = [f"{j['nombre']} — de a dos", "", f"Cómo: {d['forma']}", f"Estado: {d['estado']}"]
    if d.get("nota"):
        lineas.append(f"Nota: {d['nota']}")
    lineas += ["", "Paso a paso:"] + [f"{i}. {p}" for i, p in enumerate(d["pasos"], 1)]
    return "\r\n".join(lineas) + "\r\n", d


def plan(maquina, cat, inv):
    accesos, migrar = accesos_de(inv)
    dets = detecciones(inv, cat)
    juegos_det = {}          # id -> detecciones
    sin_catalogar = []
    for d in dets:
        j = next((j for j in cat["juegos"] if any(coincide(r, d) for r in j.get("detectar", []))), None)
        if j is None:
            sin_catalogar.append(d)
        else:
            juegos_det.setdefault(j["id"], []).append(d)
    # los que se detectan solo por un acceso (no cuentan para L1-01, pero entran al indice)
    for j in cat["juegos"]:
        for r in j.get("detectar", []):
            if r["clase"] == "acceso" and any(re.search(r["nombre"], a["nombre"], re.I) for a in accesos if a["clase"] == "acceso"):
                juegos_det.setdefault(j["id"], [])
    usados, items, presentes, sin_lanzador = set(), [], [], []
    ejes = cat["ejes"]
    J = "Juegos"

    def item(dest, l, juego):
        items.append(dict(l, dest=os.path.join(J, dest), juego=juego))

    for j in cat["juegos"]:
        if j["id"] not in juegos_det:
            continue
        ls = lanzadores_de(j, juegos_det[j["id"]], accesos, usados, inv)
        lanz = [l for l in ls if l["tipo"] != "texto-copiar"]
        if not lanz:
            sin_lanzador.append(j["nombre"])
            continue
        presentes.append(j)
        n = nombre_ok(j["nombre"])
        todos = os.path.join(RAICES[0], n)
        unico = len(lanz) == 1
        if unico:
            item(os.path.join(RAICES[0], n + lanz[0]["ext"]), dict(lanz[0], nombre=n), j["id"])
            ref = dict(lanz[0], nombre=n)
        else:
            for l in ls:
                item(os.path.join(todos, nombre_ok(l["nombre"]) + l["ext"]), l, j["id"])
            ref = {"tipo": "carpeta", "destino": os.path.join(inv["escritorio"], J, todos), "ext": ".lnk"}
        de_a_dos = bool(MODOS_DE_A_DOS & set(j["modo"]))
        if de_a_dos and j.get("de_a_dos"):
            txt, _ = texto_de_a_dos(j, cat)
            base = os.path.join(RAICES[1], n)
            for l in ls:
                item(os.path.join(base, nombre_ok(l["nombre"]) + l["ext"]), l, j["id"])
            item(os.path.join(base, "Como jugar de a dos.txt"), {"tipo": "texto", "texto": txt}, j["id"])
        if j.get("destacado"):
            for l in ls:
                item(os.path.join(n, nombre_ok(l["nombre"]) + l["ext"]), l, j["id"])
            if j.get("de_a_dos"):
                item(os.path.join(n, "Como jugar.txt"), {"tipo": "texto", "texto": texto_de_a_dos(j, cat)[0]}, j["id"])
        for eje, raiz, valores in (("modo", RAICES[2], j["modo"]), ("tipo", RAICES[3], j["tipo"]), ("version", RAICES[4], [j["version"]])):
            for v in valores:
                item(os.path.join(raiz, ejes[eje][v], n + ref["ext"]), dict(ref, nombre=n), j["id"])
    # herramientas (no son juegos): a su carpeta, sin regenerarla
    for h in cat.get("herramientas", []):
        for a in accesos:
            if a["clase"] == "acceso" and re.search(h["acceso"], a["nombre"], re.I) and id(a) not in usados:
                usados.add(id(a))
                item(os.path.join(h["carpeta"], h["nombre"] + a["ext"]), {"tipo": "copiar", "src": a["src"], "ext": a["ext"]}, "herramienta")
    sin_lugar = [a for a in accesos if a["origen"] in ("almacen", "migrar") and id(a) not in usados]
    destacadas = [nombre_ok(j["nombre"]) for j in presentes if j.get("destacado")]
    return {"maquina": maquina, "escritorio": inv["escritorio"], "items": items, "migrar": migrar,
            "raices": RAICES + destacadas, "presentes": [j["id"] for j in presentes],
            "sin_catalogar": [f"{d['clase']}: {d.get('nombre')} ({d.get('id') or d.get('appid') or os.path.basename(d['ruta'])})" for d in sin_catalogar],
            "sin_lanzador": sin_lanzador,
            "sin_lugar": [a.get("rel") or a["ruta"] for a in sin_lugar]}


def chequear_catalogo(cat):
    """L2-CAT-01: entre 1 y 3 modos y entre 1 y 2 tipos, valores del glosario; de a dos con 1-5 pasos (L1-07)."""
    malos = []
    ids = set()
    for j in cat["juegos"]:
        if j["id"] in ids:
            malos.append(f"{j['id']}: id repetido")
        ids.add(j["id"])
        if not 1 <= len(j["modo"]) <= 3 or any(m not in cat["ejes"]["modo"] for m in j["modo"]):
            malos.append(f"{j['nombre']}: modo {j['modo']}")
        if not 1 <= len(j["tipo"]) <= 2 or any(t not in cat["ejes"]["tipo"] for t in j["tipo"]):
            malos.append(f"{j['nombre']}: tipo {j['tipo']}")
        if j["version"] not in cat["ejes"]["version"]:
            malos.append(f"{j['nombre']}: version {j['version']}")
        if MODOS_DE_A_DOS & set(j["modo"]):
            if not j.get("de_a_dos"):
                malos.append(f"{j['nombre']}: es de a dos y no dice como (L1-07)")
            else:
                _, d = texto_de_a_dos(j, cat)
                if not 1 <= len(d["pasos"]) <= 5 or d["estado"] not in ("probado", "probable", "sin probar"):
                    malos.append(f"{j['nombre']}: pasos {len(d['pasos'])} o estado '{d['estado']}'")
    return malos


# ---------------------------------------------------------------- aplicar
APLICAR = r'''
$ErrorActionPreference = 'Continue'
$plan = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('@@PLAN@@')) | ConvertFrom-Json
$escr = $plan.escritorio
$juegos = Join-Path $escr 'Juegos'
$res = [ordered]@{ migrados = 0; creados = 0; omitidos = @(); errores = @(); planilla = @() }
# 1. el indice viejo al almacen de lanzadores (L2-GEN-03, L2-GEN-04)
foreach ($m in $plan.migrar) {
    if (-not (Test-Path -LiteralPath $m.origen)) { continue }
    New-Item -ItemType Directory -Force (Split-Path $m.destino) | Out-Null
    $dst = $m.destino
    if (Test-Path -LiteralPath $dst) { $dst = [IO.Path]::ChangeExtension($dst, $null).TrimEnd('.') + ' (2)' + [IO.Path]::GetExtension($m.destino) }
    try { Move-Item -LiteralPath $m.origen -Destination $dst -ErrorAction Stop; $res.migrados++; $res.planilla += [ordered]@{ origen = $m.origen; destino = $dst } }
    catch { $res.errores += "migrar $($m.origen): $($_.Exception.Message)" }
}
foreach ($c in @('Juegos de a dos', 'Sega - los dos en la PC', 'Juegos de PC\Accesos', 'Minecraft')) {
    $p = Join-Path $juegos $c
    if ((Test-Path $p) -and -not (Test-Path (Join-Path $p '@@MARCA@@'))) {
        Get-ChildItem $p -Recurse -Directory | Sort-Object { $_.FullName.Length } -Descending | Where-Object { -not (Get-ChildItem $_.FullName -Force) } | Remove-Item
        if (-not (Get-ChildItem $p -Force)) { Remove-Item $p }
    }
}
# 2. lo generado antes se regenera (solo carpetas con la marca; solo accesos y textos)
foreach ($r in $plan.raices) {
    $p = Join-Path $juegos $r
    if (-not (Test-Path $p)) { continue }
    if (-not (Test-Path (Join-Path $p '@@MARCA@@'))) { $res.errores += "la carpeta '$r' existe y no la genero el indice: no se toca"; continue }
    Get-ChildItem $p -Recurse -File -Include *.lnk, *.url, *.txt | Remove-Item -Force
    Get-ChildItem $p -Recurse -Directory | Sort-Object { $_.FullName.Length } -Descending | Where-Object { -not (Get-ChildItem $_.FullName -Force) } | Remove-Item
}
foreach ($r in $plan.raices) {
    $p = Join-Path $juegos $r
    if ((Test-Path $p) -and -not (Test-Path (Join-Path $p '@@MARCA@@'))) { continue }
    New-Item -ItemType Directory -Force $p | Out-Null
    $mk = Join-Path $p '@@MARCA@@'
    if (-not (Test-Path $mk)) { Set-Content -LiteralPath $mk -Value 'Carpeta generada por juegos-casa/scripts/indice.py: se regenera sola.' ; (Get-Item $mk -Force).Attributes = 'Hidden' }
}
# 3. el indice nuevo
$ws = New-Object -ComObject WScript.Shell
foreach ($it in $plan.items) {
    $dst = Join-Path $escr $it.dest
    $raiz = ($it.dest -split '\\')[1]
    if (($plan.raices -contains $raiz) -and -not (Test-Path (Join-Path (Join-Path $juegos $raiz) '@@MARCA@@'))) { continue }
    New-Item -ItemType Directory -Force (Split-Path $dst) | Out-Null
    try {
        switch ($it.tipo) {
            'copiar' { if (-not (Test-Path -LiteralPath $it.src)) { throw "falta el original $($it.src)" }; Copy-Item -LiteralPath $it.src -Destination $dst -Force }
            'texto-copiar' { Copy-Item -LiteralPath $it.src -Destination $dst -Force }
            'url' { Set-Content -LiteralPath $dst -Value @('[InternetShortcut]', "URL=$($it.url)") -Encoding ascii }
            'texto' { [IO.File]::WriteAllText($dst, $it.texto, (New-Object Text.UTF8Encoding $true)) }
            'lnk' {
                $t = [Environment]::ExpandEnvironmentVariables($it.destino)
                if (-not (Test-Path -LiteralPath $t)) { if ($it.opcional) { $res.omitidos += $it.dest; continue }; throw "no existe $t" }
                $l = $ws.CreateShortcut($dst); $l.TargetPath = $t; $l.Arguments = $it.args
                $l.WorkingDirectory = $(if ($it.dir) { $it.dir } else { Split-Path $t }); $l.IconLocation = "$t,0"; $l.Save()
            }
            'carpeta' {
                if (-not (Test-Path -LiteralPath $it.destino)) { if ($it.opcional) { $res.omitidos += $it.dest; continue }; throw "no existe $($it.destino)" }
                $l = $ws.CreateShortcut($dst); $l.TargetPath = $it.destino; $l.Save()
            }
        }
        $res.creados++
    } catch { $res.errores += "$($it.dest): $($_.Exception.Message)" }
}
$j = $res | ConvertTo-Json -Depth 4 -Compress
$sb = New-Object Text.StringBuilder
foreach ($ch in $j.ToCharArray()) { if ([int]$ch -gt 127) { [void]$sb.AppendFormat('\u{0:x4}', [int]$ch) } else { [void]$sb.Append($ch) } }
$sb.ToString()
'''

LISTAR = r'''
$escr = [Environment]::GetFolderPath('Desktop'); $juegos = Join-Path $escr 'Juegos'
$out = @(); $rotos = @()
$ws = New-Object -ComObject WScript.Shell
foreach ($r in @(@@RAICES@@)) {
    $p = Join-Path $juegos $r
    if (-not (Test-Path $p)) { continue }
    foreach ($f in Get-ChildItem $p -Recurse -File -Include *.lnk, *.url, *.txt) {
        $rel = $f.FullName.Substring($escr.Length + 1); $out += $rel
        if ($f.Extension -eq '.lnk') {
            $t = $ws.CreateShortcut($f.FullName).TargetPath
            # L1-03: el acceso apunta a algo que existe (vacio = acceso de RPCS3 por id, no se puede medir asi)
            if ($t -and -not (Test-Path -LiteralPath $t)) { $rotos += [ordered]@{ rel = $rel; destino = $t; unidad = (Test-Path (Split-Path -Qualifier $t)) } }
        }
    }
}
$j = @{ archivos = $out; rotos = $rotos } | ConvertTo-Json -Depth 3 -Compress
$sb = New-Object Text.StringBuilder
foreach ($ch in $j.ToCharArray()) { if ([int]$ch -gt 127) { [void]$sb.AppendFormat('\u{0:x4}', [int]$ch) } else { [void]$sb.Append($ch) } }
$sb.ToString()
'''


def aplicar(maquina, p):
    datos = {"escritorio": p["escritorio"], "items": p["items"], "migrar": p["migrar"], "raices": p["raices"]}
    b64 = base64.b64encode(json.dumps(datos, ensure_ascii=False).encode("utf-8")).decode()
    texto = APLICAR.replace("@@PLAN@@", b64).replace("@@MARCA@@", MARCA)
    res = json_de(correr_ps(maquina, texto, "indice-aplicar.ps1"))
    if res.get("planilla"):
        os.makedirs(DATOS, exist_ok=True)
        f = os.path.join(DATOS, f"planilla-{maquina}-{datetime.datetime.now():%Y-%m-%d-%H%M}.csv")
        with open(f, "w", newline="", encoding="utf-8-sig") as fh:
            w = csv.writer(fh)
            w.writerow(["origen", "destino"])
            for m in res["planilla"]:
                w.writerow([m["origen"], m["destino"]])
        res["planilla_archivo"] = f
    return res


def listar(maquina, p):
    """Lo que hay de verdad en las carpetas del indice, y los accesos que apuntan a algo que no existe."""
    raices = ", ".join("'" + r.replace("'", "''") + "'" for r in p["raices"])
    r = json_de(correr_ps(maquina, LISTAR.replace("@@RAICES@@", raices), "indice-listar.ps1"))
    rotos = r.get("rotos") or []
    if isinstance(rotos, dict):
        rotos = [rotos]
    return [a.lower() for a in (r["archivos"] or [])], rotos


# ---------------------------------------------------------------- verificar
def verificar(maquina, cat, p, hay=None):
    rojo = []
    rojo += [f"catalogo: {m}" for m in chequear_catalogo(cat)]
    rojo += [f"sin catalogar (L1-01): {s}" for s in p["sin_catalogar"]]
    rojo += [f"sin lanzador: {s}" for s in p["sin_lanzador"]]
    rojo += [f"lanzador viejo sin lugar en el indice: {s}" for s in p["sin_lugar"]]
    rotos = []
    if hay is None:
        hay, rotos = listar(maquina, p)
    hay = set(hay)
    for x in rotos:
        if x.get("unidad"):
            rojo.append(f"acceso roto (L1-03): {x['rel']} -> {x['destino']}")
        else:
            print(f"  aviso: {x['rel']} apunta a un disco que no esta enchufado ({x['destino'][:3]})")
    esperados = {}
    for it in p["items"]:
        if it.get("opcional") or not any(it["dest"].split("\\")[1] == r for r in p["raices"]):
            continue
        esperados.setdefault(it["dest"].lower(), it["juego"])
    faltan = {}
    for d, jid in esperados.items():
        if d not in hay:
            faltan.setdefault(jid, []).append(d)
    nombres = {j["id"]: j["nombre"] for j in cat["juegos"]}
    for jid, ds in sorted(faltan.items()):
        rojo.append(f"falta en el indice (L2-VER-01): {nombres.get(jid, jid)} -- {len(ds)} acceso(s), p. ej. {ds[0]}")
    todos = [d for d in esperados if d.startswith("juegos\\" + RAICES[0].lower() + "\\")]
    print(f"[{maquina}] juegos en el indice: {len(p['presentes'])}; accesos esperados {len(esperados)}, en el disco "
          f"{len(hay & set(esperados))}; sin catalogar {len(p['sin_catalogar'])}; sin lugar {len(p['sin_lugar'])}")
    for r in rojo:
        print("  ROJO", r)
    print(f"[{maquina}] " + ("VERDE: el indice esta completo" if not rojo else f"ROJO: {len(rojo)} problema(s)"))
    return 0 if not rojo else 1


# ---------------------------------------------------------------- main
def maquinas(args):
    m = args[args.index("--maquina") + 1] if "--maquina" in args else "ambas"
    return ["note", "pc"] if m == "ambas" else [m]


def main(argv):
    if not argv or argv[0] not in ("inventario", "plan", "generar", "verificar", "sabotaje"):
        print(__doc__)
        return 2
    cmd = argv[0]
    cat = json.load(open(CATALOGO, encoding="utf-8"))
    rc = 0
    for m in maquinas(argv):
        if cmd == "inventario":
            inv = inventario(m)
            print(f"[{m}] {inv['maquina']}: {len(inv['items'])} cosas medidas")
            continue
        inv = inventario(m) if cmd in ("generar", "verificar", "sabotaje") else cargar_inventario(m)
        p = plan(m, cat, inv)
        if cmd == "plan":
            print(f"[{m}] juegos {len(p['presentes'])}, accesos a crear {len(p['items'])}, a migrar {len(p['migrar'])}")
            for k in ("sin_catalogar", "sin_lanzador", "sin_lugar"):
                for s in p[k]:
                    print(f"  {k}: {s}")
            json.dump(p, open(os.path.join(DATOS, f"plan-{m}.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
        elif cmd == "generar":
            res = aplicar(m, p)
            print(f"[{m}] migrados al almacen {res['migrados']}, creados {res['creados']}, omitidos {len(res['omitidos'])}"
                  + (f"; planilla: {res['planilla_archivo']}" if res.get("planilla_archivo") else ""))
            for e in res["errores"]:
                print("  ERROR", e)
            # el plan despues de migrar (las rutas del almacen ya existen)
            p = plan(m, cat, inventario(m))
            rc |= verificar(m, cat, p) | (1 if res["errores"] else 0)
        elif cmd == "verificar":
            rc |= verificar(m, cat, p)
        elif cmd == "sabotaje":
            rc |= sabotaje(m, cat, p)
    return rc


def sabotaje(m, cat, p):
    """Dos sabotajes con su control: (1) un juego sacado del indice -> rojo que lo nombra; (2) un juego sacado del
    catalogo -> rojo 'sin catalogar' con su deteccion. El dato sale del plan, no se copia."""
    unico = next(it for it in p["items"] if it["dest"].split("\\")[1] == RAICES[0] and it["dest"].count("\\") == 2)
    nombre = next(j["nombre"] for j in cat["juegos"] if j["id"] == unico["juego"])
    print(f"--- sabotaje 1: se borra del disco '{unico['dest']}' (lo generado se regenera)")
    ruta = os.path.join(p["escritorio"], unico["dest"]).replace("'", "''")
    correr_ps(m, f"Remove-Item -LiteralPath '{ruta}' -Force", "indice-sabotaje.ps1")
    rc1 = verificar(m, cat, p)
    ok1 = rc1 == 1
    res = aplicar(m, p)
    print(f"  regenerado: creados {res['creados']}, errores {len(res['errores'])}")
    hay, _ = listar(m, p)
    print(f"--- sabotaje 2: se saca '{nombre}' del catalogo")
    cat2 = dict(cat, juegos=[j for j in cat["juegos"] if j["id"] != unico["juego"]])
    inv = cargar_inventario(m)
    p2 = plan(m, cat2, inv)
    det = [s for s in p2["sin_catalogar"]]
    ok2 = bool(det) or not any(r["clase"] != "acceso" for r in next(j for j in cat["juegos"] if j["id"] == unico["juego"])["detectar"])
    print(f"  sin catalogar: {det}")
    print("--- control: el indice real")
    rc0 = verificar(m, cat, p, hay=hay)
    print(f"[{m}] sabotaje 1 {'ROJO como debe' if ok1 else 'VERDE: EL VERIFICADOR ESTA CIEGO'}; "
          f"sabotaje 2 {'ROJO como debe' if ok2 else 'VERDE: EL VERIFICADOR ESTA CIEGO'}; control {'VERDE' if rc0 == 0 else 'ROJO'}")
    return 0 if (ok1 and ok2 and rc0 == 0) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
