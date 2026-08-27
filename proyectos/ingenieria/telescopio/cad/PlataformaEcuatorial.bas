Attribute VB_Name = "PlataformaEcuatorial"
Option Explicit

' ============================================================================
' PLATAFORMA ECUATORIAL CS (dos sectores curvos) - Dobson 200/1200
' Don Torcuato, Buenos Aires - latitud de diseno 34.5 S
'
' Genera la geometria parametrica de la plataforma en un part nuevo de
' SolidWorks y escribe los perfiles de los dos sectores en DXF 1:1 para
' plantilla de corte.
'
' USO: importar el modulo en una macro .swp y ejecutar Main().
'      Al terminar muestra los valores calculados y un registro de los pasos
'      que no se hayan podido completar.
'
' Los valores provienen de CLAUDE.md ("Parametros de diseno ya cerrados" y
' "Formulas parametricas"). R y t se calculan en runtime con esas formulas y
' se verifican contra los valores cerrados (48.3 / 72.0 / 58.7 / 24.0 cm).
'
' ---------------------------------------------------------------------------
' NOTAS DE ROBUSTEZ (todas son correcciones de errores reales observados)
'
'  1. Los sketches y planos se manipulan por REFERENCIA al objeto Feature y se
'     seleccionan con Feature.Select2, nunca por nombre con SelectByID2. Los
'     nombres fallan por idioma ("Planta" vs "Top Plane") y SelectByID2 con
'     tipo "SKETCH" no encontraba los sketches 3D aunque existieran.
'
'  2. Un sketch 3D se cierra con Insert3DSketch (es un TOGGLE), no con
'     InsertSketch, que es para sketches 2D. Cerrar un sketch 3D con
'     InsertSketch lo dejaba abierto y el siguiente Insert3DSketch lo cerraba
'     en vez de crear uno nuevo, fusionando geometria y perdiendo sketches.
'
'  3. No se cachean punteros COM en variables de modulo: se re-obtienen del
'     documento activo en cada uso (evita el error 91 cuando VBA reinicia el
'     estado del proyecto o si se ejecuta una sub suelta).
'
'  4. FeatureByPositionReverse es metodo de ModelDoc2, NO de FeatureManager.
'
'  5. Se evitan los nombres simbolicos de enums cuya existencia no este
'     confirmada en esta version: un identificador inexistente es error de
'     COMPILACION y aborta el macro entero antes de ejecutar nada.
'
'  6. Los DXF los escribe este mismo modulo como texto plano, sin pasar por
'     la exportacion de SolidWorks. El perfil del sector es plano por
'     definicion (su plano es perpendicular al eje polar), asi que se emite
'     directo en 2D y el resultado es exacto y 1:1, sin depender de como
'     SolidWorks aplane un sketch 3D.
' ============================================================================

' ---- Parametros de diseno cerrados (CLAUDE.md) ----------------------------
Const PHI_DEG As Double = 34.5             ' latitud de diseno
Const H_CM As Double = 64#                 ' centro de masa sobre la tabla movil
Const YR_CM As Double = 21#                ' |y_r| de los rodamientos
Const ZR_CM As Double = -9#                ' z_r de los rodamientos
Const TRAVEL_NORTE_CM As Double = 6.3      ' recorrido +/- sector norte
Const TRAVEL_SUR_CM As Double = 9.5        ' recorrido +/- sector sur
Const LMIN_NORTE_CM As Double = 32#        ' largo minimo de sector, norte
Const LMIN_SUR_CM As Double = 40#          ' largo minimo de sector, sur
Const MESA_MOVIL_CM As Double = 50#        ' tabla movil 50x50
Const BASE_FIJA_EO_CM As Double = 70#      ' base fija, este-oeste
Const BASE_FIJA_NS_CM As Double = 50#      ' base fija, norte-sur

' Valores cerrados, solo para verificar el calculo.
Const R_NORTE_DOC_CM As Double = 48.3
Const R_SUR_DOC_CM As Double = 72#
Const T_NORTE_DOC_CM As Double = 58.7
Const T_SUR_DOC_CM As Double = 24#

' ---- Parametros de fabricacion (PLACEHOLDER - ver "Temas abiertos") -------
Const SECTOR_ANCHO_CM As Double = 4#        ' ancho radial del sector
Const MARGEN_LARGO_CM As Double = 3#        ' margen extra sobre el largo minimo
Const MESA_MOVIL_ESPESOR_CM As Double = 2.5 ' no medido; suma 5 cm de sandwich
Const BASE_FIJA_ESPESOR_CM As Double = 2.5  ' no medido
Const BLOQUE_RODAMIENTO_LADO_CM As Double = 3#   ' placeholder, bloque 608ZZ

Const ARC_DIR As Long = 1                   ' si sale el arco mayor, poner -1

' Sentido de extrusion "hacia arriba" desde el plano Planta. Si el conjunto
' entero apareciera espejado en vertical (la montura bajo la plataforma),
' alcanza con invertir esta constante.
Const SENTIDO_ARRIBA_FLIP As Boolean = False

' ---- Montura dobson y telescopio (CLAUDE.md, "Medidas ... no estimadas") --
' El dobson apoya sobre la cara superior de la tabla movil (z = 0).
Const DOB_BASE_INF_EO_CM As Double = 40#      ' base inferior fija 40 x 43
Const DOB_BASE_INF_NS_CM As Double = 43#
Const DOB_BASE_MOV_EO_CM As Double = 40.5     ' base movil 40.5 x 37.5
Const DOB_BASE_MOV_NS_CM As Double = 37.5
Const DOB_SANDWICH_CM As Double = 5#          ' espesor total de las dos bases

Const DOB_PARED_GRANDE_ALTO_CM As Double = 82#    ' paredes grandes 82 x 37.5
Const DOB_PARED_GRANDE_NS_CM As Double = 37.5
Const DOB_PARED_CHICA_ALTO_CM As Double = 20#     ' paredes chicas 37.5 x 20
Const DOB_PARED_CHICA_EO_CM As Double = 37.5
Const DOB_ENTRE_PAREDES_CM As Double = 37#        ' luz entre paredes, abajo
Const DOB_EJE_ALTURA_CM As Double = 78#           ' sobre el piso de la base movil

Const DOB_ENTRE_PAREDES_SUP_CM As Double = 36#    ' luz entre paredes, arriba

' Caja sujetadora, 40 x 31 cm. Los 40 van PARALELOS al tubo (o sea en
' vertical, con el tubo apuntando al cenit) y los 31 son la seccion que lo
' abraza: 31 menos las dos maderas de 2 cm deja 27 cm de luz interior, con lo
' que el tubo de 25 cm entra con tolerancia. Como 31 < 36, la caja pasa
' holgada entre las paredes grandes.
Const DOB_CAJA_LARGO_CM As Double = 40#       ' a lo largo del tubo
Const DOB_CAJA_SECCION_CM As Double = 31#     ' seccion exterior que abraza al tubo
Const DOB_CAJA_ESPESOR_CM As Double = 2#      ' espesor de las maderas de la caja

Const TUBO_DIAM_CM As Double = 25#            ' tubo 25 de diametro, 135.5 de largo
Const TUBO_LARGO_CM As Double = 135.5

' Sandwich del eje de azimut: dos placas de madera (la fija y la movil, con
' las medidas ya listadas) y entre ellas los tacos de PVC y el disco de vinilo.
' Las tres capas suman los 5 cm medidos de sandwich.
Const DOB_BASE_ESPESOR_CM As Double = 1.8     ' espesor de cada placa de madera
Const DOB_VINILO_RADIO_CM As Double = 6#      ' disco de vinilo, en el niple central
Const DOB_TACO_RADIO_CM As Double = 2#        ' tacos de PVC
Const DOB_TACO_DIST_CM As Double = 15#        ' radio al que se reparten los tacos

' PLACEHOLDER: espesor de las paredes del dobson, no medido (la caja si tiene
' su espesor confirmado, 2 cm, mas arriba).
Const DOB_ESPESOR_CM As Double = 1.8          ' espesor del multilaminado

' Espesor del material de los sectores curvos (ver "Temas abiertos").
Const SECTOR_ESPESOR_CM As Double = 1.8

Const DXF_OUTPUT_FOLDER As String = "C:\Users\frans\OneDrive\Desktop\claude\PROYECTO TELESCOPIO\cad\DXF\"

' Carpeta de las piezas sueltas y del ensamblaje (ver CrearEnsamblaje).
' En VBA todas las declaraciones de modulo (Const, Dim, Type) van ANTES del
' primer procedimiento; una Const en el medio del archivo da el error
' "Los comentarios solamente pueden aparecer despues de End Sub".
Const CARPETA_PIEZAS As String = "C:\Users\frans\OneDrive\Desktop\claude\PROYECTO TELESCOPIO\cad\piezas\"

' ---- Constantes de la API (valores numericos, ver nota 5) -----------------
Const SW_REFPLANE_DISTANCE As Long = 8      ' swRefPlaneReferenceConstraint_Distance
Const SW_END_COND_BLIND As Long = 0         ' swEndCondBlind

' ---- Conversiones ---------------------------------------------------------
Const M_PER_CM As Double = 0.01             ' la API trabaja siempre en metros
Const MM_PER_CM As Double = 10#
Const PI As Double = 3.14159265358979

' ---- Tipos ----------------------------------------------------------------
' Convencion del proyecto (CLAUDE.md): origen en el centro de la cara superior
' de la tabla movil, +y hacia el SUR, +z hacia ARRIBA.
Private Type Vec3
    X As Double
    Y As Double
    Z As Double
End Type

' Una pieza del conjunto. La misma tabla alimenta la version multicuerpo y la
' generacion de piezas sueltas para el ensamblaje, para que no se desfasen.
Private Type PiezaSpec
    Nombre As String
    Tipo As Long                ' 0 = caja, 1 = cilindro, 2 = sector curvo
    AnchoEO_cm As Double        ' en cilindros, el radio
    AnchoNS_cm As Double
    Alto_cm As Double
    Cx_cm As Double             ' centro en E-O
    Cy_cm As Double             ' centro en N-S (+ = sur)
    ZBase_cm As Double          ' cara inferior
    Sector As String            ' "Norte" o "Sur", solo para Tipo = 2
End Type

Private Type SectorGeom
    Nombre As String
    R_cm As Double
    t_cm As Double
    Centro As Vec3          ' centro de curvatura, sobre el eje polar
    Rodamiento As Vec3      ' posicion del rodamiento en reposo
    Basis1 As Vec3          ' radial, hacia el rodamiento (unitaria)
    Basis2 As Vec3          ' tangencial, en el plano del sector (unitaria)
    HalfAngle As Double     ' semiangulo del sector (rad)
End Type

Private gLog As String
Private gPiezas() As PiezaSpec
Private gNPiezas As Long
Private gPlanos(1 To 3) As String   ' nombres reales de Alzado / Planta / Vista lateral

' ============================================================================
Sub Main()
    On Error GoTo ErrHandler
    gLog = ""

    If Not CreateNewPart() Then Exit Sub

    Dim axisDir As Vec3
    axisDir = AxisDirection()

    Dim secNorte As SectorGeom, secSur As SectorGeom
    secNorte = ComputeSector("Norte", -YR_CM, ZR_CM, axisDir, _
                             TRAVEL_NORTE_CM, LMIN_NORTE_CM, R_NORTE_DOC_CM, T_NORTE_DOC_CM)
    secSur = ComputeSector("Sur", YR_CM, ZR_CM, axisDir, _
                           TRAVEL_SUR_CM, LMIN_SUR_CM, R_SUR_DOC_CM, T_SUR_DOC_CM)

    BuildReferenceGeometry axisDir, secNorte, secSur
    BuildBearingBlock secNorte
    BuildBearingBlock secSur

    ' Conjunto completo como pieza multicuerpo. Los sectores curvos ya salen
    ' de la tabla de piezas (como solidos), asi que no se dibujan aparte.
    BuildTables

    AddGlobalVariables secNorte, secSur

    ' Los DXF se escriben directo a disco (ver nota 6), no via SolidWorks.
    WriteSectorDXF secNorte
    WriteSectorDXF secSur

    On Error Resume Next
    Model().ViewZoomtofit2
    On Error GoTo 0

    MsgBox ResumenFinal(secNorte, secSur), vbInformation, "Plataforma ecuatorial"
    Exit Sub

ErrHandler:
    MsgBox "Error en Main(): " & Err.Description & vbCrLf & vbCrLf & _
           "Registro previo:" & vbCrLf & gLog, vbCritical
End Sub

Private Function ResumenFinal(secNorte As SectorGeom, secSur As SectorGeom) As String
    Dim s As String
    s = "Geometria generada." & vbCrLf & vbCrLf & _
        "R_norte = " & Format(secNorte.R_cm, "0.00") & " cm" & _
        "    t_norte = " & Format(secNorte.t_cm, "0.00") & " cm" & vbCrLf & _
        "R_sur   = " & Format(secSur.R_cm, "0.00") & " cm" & _
        "    t_sur   = " & Format(secSur.t_cm, "0.00") & " cm" & vbCrLf & vbCrLf & _
        "Largo sector norte = " & Format(2 * secNorte.HalfAngle * secNorte.R_cm, "0.0") & " cm" & vbCrLf & _
        "Largo sector sur   = " & Format(2 * secSur.HalfAngle * secSur.R_cm, "0.0") & " cm" & vbCrLf & vbCrLf & _
        "Eje de altura a z = " & Format(DOB_SANDWICH_CM + DOB_EJE_ALTURA_CM, "0.0") & " cm" & vbCrLf & _
        "Centro de masa a z = " & Format(H_CM, "0.0") & " cm" & vbCrLf & vbCrLf & _
        "DXF 1:1 en:" & vbCrLf & DXF_OUTPUT_FOLDER

    If Len(gLog) > 0 Then
        s = s & vbCrLf & vbCrLf & "PASOS QUE NO SE COMPLETARON:" & vbCrLf & gLog
    Else
        s = s & vbCrLf & vbCrLf & "Todos los pasos se completaron."
    End If
    ResumenFinal = s
End Function

Private Sub LogFail(paso As String, detalle As String)
    gLog = gLog & "  - " & paso
    If Len(detalle) > 0 Then gLog = gLog & ": " & detalle
    gLog = gLog & vbCrLf
End Sub

' Igual que LogFail pero para datos que no son un fallo, solo informacion
' que conviene ver en el resumen final.
Private Sub LogInfo(texto As String)
    gLog = gLog & "  . " & texto & vbCrLf
End Sub

' ============================================================================
' ---- Acceso al documento (sin cachear punteros COM, ver nota 3) ------------

Private Function SwApp() As SldWorks.SldWorks
    Set SwApp = Application.SldWorks
End Function

Private Function Model() As SldWorks.ModelDoc2
    Set Model = SwApp().ActiveDoc
End Function

Private Function SkMgr() As SldWorks.SketchManager
    Set SkMgr = Model().SketchManager
End Function

Private Function FeatMgr() As SldWorks.FeatureManager
    Set FeatMgr = Model().FeatureManager
End Function

' ============================================================================
Private Function CreateNewPart() As Boolean
    CreateNewPart = False

    ' Estos dos nombres de enum ya resolvieron bien en esta instalacion, asi
    ' que se dejan simbolicos: un ID numerico equivocado en
    ' SetUserPreferenceInteger cambiaria otra preferencia sin avisar.
    Dim template As String
    On Error Resume Next
    template = SwApp().GetUserPreferenceStringValue(swUserPreferenceStringValue_e.swDefaultTemplatePart)
    On Error GoTo 0

    If Len(template) = 0 Then
        MsgBox "No hay plantilla de part por defecto en SolidWorks." & vbCrLf & _
               "Configurarla en Herramientas > Opciones > Plantillas predeterminadas.", vbExclamation
        Exit Function
    End If

    Dim m As SldWorks.ModelDoc2
    Set m = SwApp().NewDocument(template, 0, 0, 0)
    If m Is Nothing Then
        MsgBox "No se pudo crear el part nuevo.", vbCritical
        Exit Function
    End If

    On Error Resume Next
    m.Extension.SetUserPreferenceInteger swUserPreferenceIntegerValue_e.swUnitSystem, _
        swUserPreferenceOption_e.swDetailingNoOptionSpecified, swUnitSystem_e.swUNITSYSTEM_MMGS
    On Error GoTo 0

    CreateNewPart = True
End Function

' ============================================================================
' Direccion unitaria del eje polar en la convencion del proyecto, derivada de
' las formulas parametricas: R y t son las coordenadas del rodamiento en la
' base ortonormal (u_t, u_R) del plano (y, z) medida desde el centro de masa.
Private Function AxisDirection() As Vec3
    Dim phi As Double
    phi = Deg2Rad(PHI_DEG)
    AxisDirection.X = 0
    AxisDirection.Y = Cos(phi)
    AxisDirection.Z = Sin(phi)
End Function

' ============================================================================
' Formulas de CLAUDE.md:
'   R = (H - z_r) * cos(phi) + y_r * sin(phi)
'   t = y_r * cos(phi) + (z_r - H) * sin(phi)
' yr_signed: +21 rodamiento sur, -21 rodamiento norte (+y = sur).
' t negativo = centro de curvatura hacia el NORTE del centro de masa, que es
' lo que corresponde para ambos sectores segun CLAUDE.md.
Private Function ComputeSector(nombre As String, yr_signed As Double, zr As Double, _
                               axisDir As Vec3, travel_cm As Double, lmin_cm As Double, _
                               r_doc_cm As Double, t_doc_cm As Double) As SectorGeom
    Dim phi As Double
    phi = Deg2Rad(PHI_DEG)

    Dim R_cm As Double, t_cm As Double
    R_cm = (H_CM - zr) * Cos(phi) + yr_signed * Sin(phi)
    t_cm = yr_signed * Cos(phi) + (zr - H_CM) * Sin(phi)

    If Abs(Abs(R_cm) - r_doc_cm) > 0.1 Or Abs(Abs(t_cm) - t_doc_cm) > 0.1 Then
        LogFail "Sector " & nombre & " no coincide con CLAUDE.md", _
                "calculado R=" & Format(R_cm, "0.00") & " t=" & Format(t_cm, "0.00")
    End If

    Dim com As Vec3, rodam As Vec3
    com.X = 0: com.Y = 0: com.Z = H_CM
    rodam.X = 0: rodam.Y = yr_signed: rodam.Z = zr

    Dim centro As Vec3, b1 As Vec3
    centro = VAdd(com, VScale(axisDir, t_cm))
    b1 = VNormalize(VSub(rodam, centro))

    Dim totalLen_cm As Double
    totalLen_cm = MaxDouble(2 * travel_cm, lmin_cm) + MARGEN_LARGO_CM

    ComputeSector.Nombre = nombre
    ComputeSector.R_cm = R_cm
    ComputeSector.t_cm = t_cm
    ComputeSector.Centro = centro
    ComputeSector.Rodamiento = rodam
    ComputeSector.Basis1 = b1
    ComputeSector.Basis2 = VNormalize(VCross(axisDir, b1))
    ComputeSector.HalfAngle = (totalLen_cm / 2#) / R_cm
End Function

' ============================================================================
' Sketch 3D de referencia: eje polar, centro de masa, centros de curvatura y
' rodamientos en reposo.
Private Sub BuildReferenceGeometry(axisDir As Vec3, secNorte As SectorGeom, secSur As SectorGeom)
    On Error GoTo Fallo

    If Not Open3DSketch() Then
        LogFail "Geometria de referencia", "no se pudo abrir el sketch 3D"
        Exit Sub
    End If

    Dim com As Vec3
    com.X = 0: com.Y = 0: com.Z = H_CM

    CreateLine3D VAdd(com, VScale(axisDir, secNorte.t_cm - 20#)), _
                 VAdd(com, VScale(axisDir, secSur.t_cm + 20#))

    CreatePoint3D com                 ' centro de masa
    CreatePoint3D secNorte.Centro     ' centro de curvatura norte
    CreatePoint3D secSur.Centro       ' centro de curvatura sur
    CreatePoint3D secNorte.Rodamiento ' rodamiento norte
    CreatePoint3D secSur.Rodamiento   ' rodamiento sur

    Close3DSketch
    RenameLastFeature "EjePolar_Referencia"
    Exit Sub

Fallo:
    LogFail "Geometria de referencia", Err.Description
    Close3DSketch
End Sub

' ============================================================================
' Perfil de un sector: arcos concentricos R +/- ancho/2 cerrados por dos
' rectas radiales. Va en sketch 3D porque su plano es perpendicular al eje
' polar y no coincide con ningun plano estandar de SolidWorks.
' Devuelve el sketch creado, para que MakeSectorSolid pueda extruirlo.
Private Function BuildSectorProfile(sec As SectorGeom) As SldWorks.Feature
    On Error GoTo Fallo

    If Not Open3DSketch() Then
        LogFail "Perfil del sector " & sec.Nombre, "no se pudo abrir el sketch 3D"
        Exit Function
    End If

    Dim rOut As Double, rIn As Double
    rOut = sec.R_cm + SECTOR_ANCHO_CM / 2#
    rIn = sec.R_cm - SECTOR_ANCHO_CM / 2#

    Dim pOutStart As Vec3, pOutEnd As Vec3, pInStart As Vec3, pInEnd As Vec3
    pOutStart = ArcPoint(sec, rOut, -sec.HalfAngle)
    pOutEnd = ArcPoint(sec, rOut, sec.HalfAngle)
    pInStart = ArcPoint(sec, rIn, -sec.HalfAngle)
    pInEnd = ArcPoint(sec, rIn, sec.HalfAngle)

    CreateArc3D sec.Centro, pOutStart, pOutEnd
    CreateArc3D sec.Centro, pInStart, pInEnd
    CreateLine3D pOutStart, pInStart
    CreateLine3D pOutEnd, pInEnd

    Close3DSketch
    RenameLastFeature "PerfilSector" & sec.Nombre
    Set BuildSectorProfile = LastFeature()
    Exit Function

Fallo:
    LogFail "Perfil del sector " & sec.Nombre, Err.Description
    Close3DSketch
End Function

' ============================================================================
' Marca del rodamiento 608ZZ: cuadrado centrado en su posicion de reposo, con
' el plano normal al eje polar (los bloques inclinados 34.5 de CLAUDE.md).
Private Sub BuildBearingBlock(sec As SectorGeom)
    On Error GoTo Fallo

    If Not Open3DSketch() Then
        LogFail "Bloque de rodamiento " & sec.Nombre, "no se pudo abrir el sketch 3D"
        Exit Sub
    End If

    Dim h As Double
    h = BLOQUE_RODAMIENTO_LADO_CM / 2#

    Dim p1 As Vec3, p2 As Vec3, p3 As Vec3, p4 As Vec3
    p1 = VAdd(sec.Rodamiento, VAdd(VScale(sec.Basis1, h), VScale(sec.Basis2, h)))
    p2 = VAdd(sec.Rodamiento, VAdd(VScale(sec.Basis1, h), VScale(sec.Basis2, -h)))
    p3 = VAdd(sec.Rodamiento, VAdd(VScale(sec.Basis1, -h), VScale(sec.Basis2, -h)))
    p4 = VAdd(sec.Rodamiento, VAdd(VScale(sec.Basis1, -h), VScale(sec.Basis2, h)))

    CreateLine3D p1, p2
    CreateLine3D p2, p3
    CreateLine3D p3, p4
    CreateLine3D p4, p1

    Close3DSketch
    RenameLastFeature "BloqueRodamiento" & sec.Nombre
    Exit Sub

Fallo:
    LogFail "Bloque de rodamiento " & sec.Nombre, Err.Description
    Close3DSketch
End Sub

' ============================================================================
' TABLA DE PIEZAS DEL CONJUNTO
' Unica fuente de verdad de la geometria. Alturas z en cm desde la cara
' superior de la tabla movil (origen del proyecto, segun CLAUDE.md).
'
'   -5.0 .. -2.5   base fija de la plataforma (70 x 50)
'   -2.5 ..  0     tabla movil de la plataforma (50 x 50)
'    0   ..  5     sandwich de las dos bases del dobson
'    5   .. 87     paredes grandes (82 de alto)
'    5   .. 25     paredes chicas (20 de alto)
'   63   .. 103    caja sujetadora (40 de largo, centrada en el eje)
'   15.25.. 150.75 tubo (centrado en el eje de altura)
'
' Disposicion de las paredes: las GRANDES van por dentro y las CHICAS las
' abrazan por fuera, apoyando contra los extremos norte y sur de las grandes.
Private Function PiezasDelConjunto() As PiezaSpec()
    gNPiezas = 0
    Erase gPiezas

    Dim zBases As Double, zEje As Double
    zBases = DOB_SANDWICH_CM
    zEje = zBases + DOB_EJE_ALTURA_CM

    ' --- Plataforma ecuatorial ---
    Agregar Caja("BaseFijaPlataforma", BASE_FIJA_EO_CM, BASE_FIJA_NS_CM, _
                 BASE_FIJA_ESPESOR_CM, 0, 0, _
                 -(MESA_MOVIL_ESPESOR_CM + BASE_FIJA_ESPESOR_CM))
    Agregar Caja("TablaMovilPlataforma", MESA_MOVIL_CM, MESA_MOVIL_CM, _
                 MESA_MOVIL_ESPESOR_CM, 0, 0, -MESA_MOVIL_ESPESOR_CM)

    ' --- Sectores curvos de la plataforma, el corazon del seguimiento ---
    Agregar Sector("SectorNorte", "Norte")
    Agregar Sector("SectorSur", "Sur")

    ' --- Sandwich del dobson: dos placas de madera con los tacos de PVC y el
    ' disco de vinilo del eje de azimut en el medio. Las tres capas suman los
    ' 5 cm medidos.
    Dim zTacos As Double, hTacos As Double
    zTacos = DOB_BASE_ESPESOR_CM
    hTacos = DOB_SANDWICH_CM - 2 * DOB_BASE_ESPESOR_CM

    Agregar Caja("DobsonBaseInferior", DOB_BASE_INF_EO_CM, DOB_BASE_INF_NS_CM, _
                 DOB_BASE_ESPESOR_CM, 0, 0, 0)
    Agregar Cilindro("DiscoVinilo", DOB_VINILO_RADIO_CM, hTacos, 0, 0, zTacos)

    Dim k As Long, ang As Double
    For k = 0 To 2
        ang = k * 2# * PI / 3#
        Agregar Cilindro("TacoPVC" & (k + 1), DOB_TACO_RADIO_CM, hTacos, _
                         DOB_TACO_DIST_CM * Cos(ang), DOB_TACO_DIST_CM * Sin(ang), zTacos)
    Next k

    Agregar Caja("DobsonBaseMovil", DOB_BASE_MOV_EO_CM, DOB_BASE_MOV_NS_CM, _
                 DOB_BASE_ESPESOR_CM, 0, 0, DOB_SANDWICH_CM - DOB_BASE_ESPESOR_CM)

    ' --- Paredes grandes: por DENTRO, separadas la luz entre paredes ---
    Dim xGrande As Double
    xGrande = (DOB_ENTRE_PAREDES_CM + DOB_ESPESOR_CM) / 2#
    Agregar Caja("ParedGrandeEste", DOB_ESPESOR_CM, DOB_PARED_GRANDE_NS_CM, _
                 DOB_PARED_GRANDE_ALTO_CM, xGrande, 0, zBases)
    Agregar Caja("ParedGrandeOeste", DOB_ESPESOR_CM, DOB_PARED_GRANDE_NS_CM, _
                 DOB_PARED_GRANDE_ALTO_CM, -xGrande, 0, zBases)

    ' --- Paredes chicas: por FUERA, contra los extremos de las grandes ---
    Dim yChica As Double
    yChica = (DOB_PARED_GRANDE_NS_CM + DOB_ESPESOR_CM) / 2#
    Agregar Caja("ParedChicaSur", DOB_PARED_CHICA_EO_CM, DOB_ESPESOR_CM, _
                 DOB_PARED_CHICA_ALTO_CM, 0, yChica, zBases)
    Agregar Caja("ParedChicaNorte", DOB_PARED_CHICA_EO_CM, DOB_ESPESOR_CM, _
                 DOB_PARED_CHICA_ALTO_CM, 0, -yChica, zBases)

    ' --- Caja sujetadora: las cuatro maderas que abrazan al tubo, no un
    ' bloque macizo. Los 40 cm van a lo largo del tubo (vertical) y la seccion
    ' de 31 cm queda centrada en el eje de altura. Las maderas norte y sur se
    ' acortan al hueco entre las del este y oeste para que no se pisen.
    Dim cCaja As Double, zCaja As Double, huecoCaja As Double
    cCaja = (DOB_CAJA_SECCION_CM - DOB_CAJA_ESPESOR_CM) / 2#
    huecoCaja = DOB_CAJA_SECCION_CM - 2 * DOB_CAJA_ESPESOR_CM
    zCaja = zEje - DOB_CAJA_LARGO_CM / 2#

    Agregar Caja("CajaSujetadoraEste", DOB_CAJA_ESPESOR_CM, DOB_CAJA_SECCION_CM, _
                 DOB_CAJA_LARGO_CM, cCaja, 0, zCaja)
    Agregar Caja("CajaSujetadoraOeste", DOB_CAJA_ESPESOR_CM, DOB_CAJA_SECCION_CM, _
                 DOB_CAJA_LARGO_CM, -cCaja, 0, zCaja)
    Agregar Caja("CajaSujetadoraSur", huecoCaja, DOB_CAJA_ESPESOR_CM, _
                 DOB_CAJA_LARGO_CM, 0, cCaja, zCaja)
    Agregar Caja("CajaSujetadoraNorte", huecoCaja, DOB_CAJA_ESPESOR_CM, _
                 DOB_CAJA_LARGO_CM, 0, -cCaja, zCaja)

    ' --- Tubo: centrado en el eje de altura, apuntando al cenit ---
    Agregar Cilindro("TuboTelescopio", TUBO_DIAM_CM / 2#, TUBO_LARGO_CM, _
                     0, 0, zEje - TUBO_LARGO_CM / 2#)

    PiezasDelConjunto = gPiezas
End Function

' Crecimiento dinamico: evita tener que llevar la cuenta de los indices a mano
' cada vez que se agrega o se saca una pieza.
Private Sub Agregar(pz As PiezaSpec)
    gNPiezas = gNPiezas + 1
    ReDim Preserve gPiezas(1 To gNPiezas)
    gPiezas(gNPiezas) = pz
End Sub

Private Function Caja(nombre As String, eo As Double, ns As Double, alto As Double, _
                      cx As Double, cy As Double, zb As Double) As PiezaSpec
    Caja.Nombre = nombre
    Caja.Tipo = 0
    Caja.AnchoEO_cm = eo
    Caja.AnchoNS_cm = ns
    Caja.Alto_cm = alto
    Caja.Cx_cm = cx
    Caja.Cy_cm = cy
    Caja.ZBase_cm = zb
End Function

Private Function Cilindro(nombre As String, radio As Double, alto As Double, _
                          cx As Double, cy As Double, zb As Double) As PiezaSpec
    Cilindro.Nombre = nombre
    Cilindro.Tipo = 1
    Cilindro.AnchoEO_cm = radio
    Cilindro.Alto_cm = alto
    Cilindro.Cx_cm = cx
    Cilindro.Cy_cm = cy
    Cilindro.ZBase_cm = zb
End Function

Private Function Sector(nombre As String, cual As String) As PiezaSpec
    Sector.Nombre = nombre
    Sector.Tipo = 2
    Sector.Sector = cual
End Function

' Construye una pieza de la tabla en el documento activo.
Private Function BuildPieza(pz As PiezaSpec) As Boolean
    If Len(pz.Nombre) = 0 Then
        BuildPieza = True
        Exit Function
    End If

    Select Case pz.Tipo
        Case 1
            BuildPieza = MakeCylinder(pz.Nombre, pz.AnchoEO_cm, pz.Alto_cm, _
                                      pz.Cx_cm, pz.Cy_cm, pz.ZBase_cm)
        Case 2
            BuildPieza = MakeSectorSolid(pz)
        Case Else
            BuildPieza = MakeBox(pz.Nombre, pz.AnchoEO_cm, pz.AnchoNS_cm, pz.Alto_cm, _
                                 pz.Cx_cm, pz.Cy_cm, pz.ZBase_cm)
    End Select
End Function

' Sector curvo solido: se dibuja el perfil en un sketch 3D (su plano es
' perpendicular al eje polar) y se extruye. Al ser un contorno plano dentro de
' un sketch 3D, SolidWorks lo extruye normal a ese plano, o sea a lo largo del
' eje polar, que es justo el espesor del sector.
Private Function MakeSectorSolid(pz As PiezaSpec) As Boolean
    MakeSectorSolid = False

    Dim axisDir As Vec3
    axisDir = AxisDirection()

    Dim sec As SectorGeom
    If pz.Sector = "Norte" Then
        sec = ComputeSector("Norte", -YR_CM, ZR_CM, axisDir, _
                            TRAVEL_NORTE_CM, LMIN_NORTE_CM, R_NORTE_DOC_CM, T_NORTE_DOC_CM)
    Else
        sec = ComputeSector("Sur", YR_CM, ZR_CM, axisDir, _
                            TRAVEL_SUR_CM, LMIN_SUR_CM, R_SUR_DOC_CM, T_SUR_DOC_CM)
    End If

    Dim sk As SldWorks.Feature
    Set sk = BuildSectorProfile(sec)
    If sk Is Nothing Then Exit Function

    If ExtrudeSketchFlip(sk, SECTOR_ESPESOR_CM, False) Then
        RenameLastFeature pz.Nombre
        MakeSectorSolid = True
    Else
        LogFail pz.Nombre, "el perfil se creo pero no se pudo extruir " & _
                           "(los sketches 3D no siempre admiten extrusion directa)"
    End If
End Function

' Version multicuerpo: todas las piezas en el documento actual.
Private Sub BuildTables()
    Dim piezas() As PiezaSpec
    piezas = PiezasDelConjunto()

    Dim i As Long
    For i = LBound(piezas) To UBound(piezas)
        BuildPieza piezas(i)
    Next i
End Sub

' Dibuja un rectangulo sobre un plano y devuelve el sketch creado.
'
' Se usa CreateCornerRectangle, la herramienta de rectangulo de la propia API:
' genera un contorno CERRADO, con las relaciones entre lados. Cuatro
' CreateLine con extremos coincidentes NO alcanzan: SolidWorks las trata como
' un contorno abierto y despues la extrusion no encuentra region que extruir
' (ese fue exactamente el fallo "el sketch se creo pero no se pudo extruir").
' Las lineas quedan solo como reserva por si CreateCornerRectangle falla.
'
' El rectangulo va centrado en (cx_cm, cy_cm) del plano.
Private Function SketchRectOnPlane(plano As SldWorks.Feature, _
                                   anchoX_cm As Double, anchoY_cm As Double, _
                                   cx_cm As Double, cy_cm As Double, _
                                   nombre As String) As SldWorks.Feature
    Dim etapa As String
    On Error GoTo Fallo

    etapa = "abrir el sketch sobre el plano"
    If Not OpenSketchOnPlane(plano) Then GoTo FalloEtapa

    etapa = "dibujar el rectangulo"
    Dim x1 As Double, y1 As Double, x2 As Double, y2 As Double
    x1 = (cx_cm - anchoX_cm / 2#) * M_PER_CM
    y1 = (cy_cm - anchoY_cm / 2#) * M_PER_CM
    x2 = (cx_cm + anchoX_cm / 2#) * M_PER_CM
    y2 = (cy_cm + anchoY_cm / 2#) * M_PER_CM

    Dim dibujado As Boolean
    dibujado = False

    On Error Resume Next
    SkMgr().CreateCornerRectangle x1, y1, 0, x2, y2, 0
    If Err.Number = 0 Then dibujado = True
    Err.Clear
    On Error GoTo Fallo

    If Not dibujado Then           ' reserva: contorno a mano
        CreateLine2D x1, y1, x2, y1
        CreateLine2D x2, y1, x2, y2
        CreateLine2D x2, y2, x1, y2
        CreateLine2D x1, y2, x1, y1
    End If

    etapa = "cerrar el sketch"
    Close2DSketch
    If Not SkMgr().ActiveSketch Is Nothing Then GoTo FalloEtapa

    RenameLastFeature nombre
    Set SketchRectOnPlane = LastFeature()
    Exit Function

Fallo:
    LogFail "Sketch " & nombre, etapa & " (" & Err.Description & ")"
    Close2DSketch
    Exit Function

FalloEtapa:
    LogFail "Sketch " & nombre, "fallo al " & etapa
    Close2DSketch
End Function

' Sketch circular sobre un plano, para el tubo del telescopio.
Private Function SketchCircleOnPlane(plano As SldWorks.Feature, radio_cm As Double, _
                                     cx_cm As Double, cy_cm As Double, _
                                     nombre As String) As SldWorks.Feature
    On Error GoTo Fallo

    If Not OpenSketchOnPlane(plano) Then
        LogFail "Sketch " & nombre, "no se pudo abrir el sketch"
        Exit Function
    End If

    SkMgr().CreateCircle cx_cm * M_PER_CM, cy_cm * M_PER_CM, 0, _
                         (cx_cm + radio_cm) * M_PER_CM, cy_cm * M_PER_CM, 0

    Close2DSketch
    RenameLastFeature nombre
    Set SketchCircleOnPlane = LastFeature()
    Exit Function

Fallo:
    LogFail "Sketch " & nombre, Err.Description
    Close2DSketch
End Function

Private Function CreateLine2D(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Object
    Set CreateLine2D = SkMgr().CreateLine(x1, y1, 0, x2, y2, 0)
End Function

' Abre un sketch 2D sobre un plano, probando por turnos las distintas formas
' de seleccionarlo hasta que una funcione. La prueba real no es lo que
' devuelve la seleccion (Select2 devolvia False aun seleccionando el plano en
' el arbol), sino si despues QUEDA UN SKETCH ACTIVO. Por eso se verifica
' ActiveSketch en cada intento, y se limpia antes de probar el siguiente.
'
' Estrategias, en orden:
'   1. Select2 sobre el objeto Feature
'   2. SelectByID2 con el nombre real del plano y tipo "PLANE"
'   3. SelectByID2 con los nombres estandar en espanol e ingles
Private Function OpenSketchOnPlane(plano As SldWorks.Feature) As Boolean
    OpenSketchOnPlane = False

    Dim nombreReal As String
    On Error Resume Next
    nombreReal = plano.Name
    On Error GoTo 0

    Dim i As Long
    For i = 1 To 4
        Close2DSketch                       ' no arrastrar un intento previo
        TrySelectPlane plano, nombreReal, i

        ' Se intenta abrir el sketch incluso si la seleccion devolvio False:
        ' lo que importa es el resultado, no el valor devuelto.
        On Error Resume Next
        SkMgr().InsertSketch True
        On Error GoTo 0

        If Not SkMgr().ActiveSketch Is Nothing Then
            OpenSketchOnPlane = True
            Exit Function
        End If
    Next i
End Function

' Aplica la estrategia de seleccion numero i sobre un plano. No devuelve si
' funciono: el llamador lo comprueba por el efecto (sketch abierto, plano
' creado), que es lo unico confiable en esta instalacion.
Private Sub TrySelectPlane(plano As SldWorks.Feature, nombreReal As String, i As Long)
    On Error Resume Next

    Model().ClearSelection2 True
    Dim ok As Boolean

    Select Case i
        Case 1
            ok = plano.Select2(False, 0)
        Case 2
            If Len(nombreReal) > 0 Then
                ok = Model().Extension.SelectByID2(nombreReal, "PLANE", 0, 0, 0, False, 0, Nothing, 0)
            End If
        Case 3
            ok = Model().Extension.SelectByID2("Planta", "PLANE", 0, 0, 0, False, 0, Nothing, 0)
        Case 4
            ok = Model().Extension.SelectByID2("Top Plane", "PLANE", 0, 0, 0, False, 0, Nothing, 0)
    End Select

    On Error GoTo 0
End Sub

' Plano paralelo a otro, desplazado una distancia dada. El signo del offset lo
' resuelve SolidWorks; si la base fija apareciera ARRIBA de la tabla movil,
' invertir el signo de dist_cm en la llamada.
Private Function OffsetPlane(plano As SldWorks.Feature, dist_cm As Double, _
                             nombre As String) As SldWorks.Feature
    On Error GoTo Fallo

    Dim nombreReal As String
    On Error Resume Next
    nombreReal = plano.Name
    On Error GoTo 0

    ' Mismo criterio que OpenSketchOnPlane: se prueban las estrategias de
    ' seleccion por turnos y se juzga por el resultado (si nacio el plano),
    ' no por lo que devuelva la seleccion. Se prueban ambos signos de la
    ' distancia porque algunas versiones rechazan uno de los dos.
    Dim f As SldWorks.Feature
    Dim i As Long
    For i = 1 To 4
        TrySelectPlane plano, nombreReal, i
        On Error Resume Next
        Set f = FeatMgr().InsertRefPlane(SW_REFPLANE_DISTANCE, dist_cm * M_PER_CM, 0, 0, 0, 0)
        On Error GoTo 0
        If Not f Is Nothing Then Exit For
    Next i

    ' Ultimo recurso: la distancia opuesta. Se avisa porque el plano puede
    ' quedar espejado respecto de z=0 y el cuerpo saldria del lado equivocado.
    If f Is Nothing Then
        For i = 1 To 4
            TrySelectPlane plano, nombreReal, i
            On Error Resume Next
            Set f = FeatMgr().InsertRefPlane(SW_REFPLANE_DISTANCE, -dist_cm * M_PER_CM, 0, 0, 0, 0)
            On Error GoTo 0
            If Not f Is Nothing Then
                LogFail "Plano " & nombre, "creado con la distancia OPUESTA " & _
                        "(" & Format(-dist_cm, "0.0") & " cm): verificar la altura"
                Exit For
            End If
        Next i
    End If

    If f Is Nothing Then
        LogFail "Plano " & nombre, "InsertRefPlane no devolvio ningun plano"
        Exit Function
    End If

    On Error Resume Next
    f.Name = nombre
    On Error GoTo 0

    Set OffsetPlane = f
    Exit Function

Fallo:
    LogFail "Plano " & nombre, Err.Description
End Function

' ============================================================================
' ---- Generador de cuerpos --------------------------------------------------
' Todo el conjunto se arma como PIEZA MULTICUERPO: cada bloque es un cuerpo
' solido independiente (Merge=False), lo que evita tener que crear archivos
' .sldprt sueltos y un .sldasm con relaciones de posicion. Si mas adelante se
' quieren piezas separadas, se usa Insertar > Operaciones > Guardar cuerpos.
'
' MakeBox arma un prisma recto: dibuja la huella en planta a la altura
' z_base_cm y la extruye hacia arriba la altura pedida.
Private Function MakeBox(nombre As String, _
                         anchoEO_cm As Double, anchoNS_cm As Double, alto_cm As Double, _
                         cx_cm As Double, cy_cm As Double, z_base_cm As Double) As Boolean
    MakeBox = False

    ' Si una de las caras cae justo en z=0 se usa el plano Planta y se extruye
    ' en el sentido que corresponda. Ahorra crear un plano auxiliar, que es la
    ' operacion con mas riesgo de todo el macro.
    Dim plano As SldWorks.Feature
    Dim haciaArriba As Boolean

    If Abs(z_base_cm) < 0.001 Then
        Set plano = StandardPlane(2)
        haciaArriba = True
    ElseIf Abs(z_base_cm + alto_cm) < 0.001 Then
        Set plano = StandardPlane(2)
        haciaArriba = False
    Else
        Set plano = PlanoAAltura(z_base_cm, "Plano_" & nombre)
        haciaArriba = True
    End If

    If plano Is Nothing Then
        LogFail nombre, "no se pudo ubicar el plano a z=" & Format(z_base_cm, "0.0") & " cm"
        Exit Function
    End If

    Dim sk As SldWorks.Feature
    Set sk = SketchRectOnPlane(plano, anchoEO_cm, anchoNS_cm, cx_cm, cy_cm, "Sk" & nombre)
    If sk Is Nothing Then Exit Function

    If ExtrudeSketch(sk, alto_cm, haciaArriba) Then
        RenameLastFeature nombre
        MakeBox = True
    Else
        LogFail nombre, "el sketch se creo pero no se pudo extruir"
    End If
End Function

' Cilindro vertical, para el tubo del telescopio.
Private Function MakeCylinder(nombre As String, radio_cm As Double, alto_cm As Double, _
                              cx_cm As Double, cy_cm As Double, z_base_cm As Double) As Boolean
    MakeCylinder = False

    Dim plano As SldWorks.Feature
    Set plano = PlanoAAltura(z_base_cm, "Plano_" & nombre)
    If plano Is Nothing Then
        LogFail nombre, "no se pudo ubicar el plano a z=" & Format(z_base_cm, "0.0") & " cm"
        Exit Function
    End If

    Dim sk As SldWorks.Feature
    Set sk = SketchCircleOnPlane(plano, radio_cm, cx_cm, cy_cm, "Sk" & nombre)
    If sk Is Nothing Then Exit Function

    If ExtrudeSketch(sk, alto_cm, True) Then
        RenameLastFeature nombre
        MakeCylinder = True
    Else
        LogFail nombre, "el sketch se creo pero no se pudo extruir"
    End If
End Function

' Devuelve un plano horizontal a la altura pedida. A z=0 es el plano Planta;
' en cualquier otra altura se crea (y se reutiliza) un plano paralelo.
Private Function PlanoAAltura(z_cm As Double, nombre As String) As SldWorks.Feature
    Dim planta As SldWorks.Feature
    Set planta = StandardPlane(2)
    If planta Is Nothing Then Exit Function

    If Abs(z_cm) < 0.001 Then
        Set PlanoAAltura = planta
    Else
        Set PlanoAAltura = OffsetPlane(planta, z_cm, nombre)
    End If
End Function

' Extruye un sketch como cuerpo independiente. Igual que con los planos, no se
' confia en lo que devuelve la seleccion: se prueban las dos vias y se juzga
' por si nacio la operacion.
' haciaArriba se traduce con SENTIDO_ARRIBA_FLIP; si el modelo entero saliera
' espejado en vertical, alcanza con invertir esa constante.
Private Function ExtrudeSketch(sk As SldWorks.Feature, espesor_cm As Double, _
                               haciaArriba As Boolean) As Boolean
    Dim flip As Boolean
    If haciaArriba Then flip = SENTIDO_ARRIBA_FLIP Else flip = Not SENTIDO_ARRIBA_FLIP
    ExtrudeSketch = ExtrudeSketchFlip(sk, espesor_cm, flip)
End Function

Private Function ExtrudeSketchFlip(sk As SldWorks.Feature, espesor_cm As Double, _
                                   flip As Boolean) As Boolean
    ExtrudeSketchFlip = False

    Dim nombreReal As String
    On Error Resume Next
    nombreReal = sk.Name
    On Error GoTo 0

    Dim f As SldWorks.Feature
    Dim i As Long
    For i = 1 To 2
        On Error Resume Next
        Model().ClearSelection2 True
        If i = 1 Then
            sk.Select2 False, 0
        ElseIf Len(nombreReal) > 0 Then
            Model().Extension.SelectByID2 nombreReal, "SKETCH", 0, 0, 0, False, 0, Nothing, 0
        End If
        On Error GoTo 0

        ' FeatureExtrusion2(Sd, Flip, Dir, T1, T2, D1, D2, Dchk1, Dchk2, Ddir1,
        '  Ddir2, Dang1, Dang2, OffsetReverse1, OffsetReverse2, TranslateSurface1,
        '  TranslateSurface2, Merge, UseFeatScope, UseAutoSelect, T0, StartOffset,
        '  FlipStartOffset).
        '
        ' Sd = TRUE significa operacion SOLIDA. No es "simetrico", como parece
        ' por el nombre: con Sd=False SolidWorks entiende una operacion de
        ' PARED DELGADA, y como no se le pasa espesor de pared rechaza la
        ' extrusion y devuelve Nothing. Ese fue el motivo de que fallaran
        ' todas las extrusiones a la vez.
        ' El sentido lo controla Flip; Dir=False extruye en una sola direccion.
        ' Merge=False deja cada bloque como cuerpo independiente (multicuerpo).
        On Error Resume Next
        Set f = FeatMgr().FeatureExtrusion2(True, flip, False, _
            SW_END_COND_BLIND, SW_END_COND_BLIND, _
            espesor_cm * M_PER_CM, 0, _
            False, False, False, False, 0, 0, _
            False, False, False, False, False, True, True, 0, 0, False)
        On Error GoTo 0

        If Not f Is Nothing Then
            ExtrudeSketchFlip = True
            Exit Function
        End If
    Next i
End Function

' ============================================================================
' Variables globales (Ecuaciones) del part. Es un extra: si la firma de Add*
' no coincide con esta version, se saltea sin afectar al resto.
Private Sub AddGlobalVariables(secNorte As SectorGeom, secSur As SectorGeom)
    On Error Resume Next

    Dim swEq As Object              ' enlace tardio a proposito
    Set swEq = Model().GetEquationMgr
    If swEq Is Nothing Then Exit Sub

    AddEquation swEq, "phi", PHI_DEG, ""
    AddEquation swEq, "H", H_CM * MM_PER_CM, "mm"
    AddEquation swEq, "y_r", YR_CM * MM_PER_CM, "mm"
    AddEquation swEq, "z_r", ZR_CM * MM_PER_CM, "mm"
    AddEquation swEq, "R_norte", secNorte.R_cm * MM_PER_CM, "mm"
    AddEquation swEq, "t_norte", secNorte.t_cm * MM_PER_CM, "mm"
    AddEquation swEq, "R_sur", secSur.R_cm * MM_PER_CM, "mm"
    AddEquation swEq, "t_sur", secSur.t_cm * MM_PER_CM, "mm"
    AddEquation swEq, "sector_ancho", SECTOR_ANCHO_CM * MM_PER_CM, "mm"
End Sub

Private Sub AddEquation(swEq As Object, nombre As String, valor As Double, unidad As String)
    Dim expr As String
    expr = """" & nombre & """ = " & Format(valor, "0.####") & unidad

    On Error Resume Next
    swEq.Add3 -1, expr, True, 0, Empty
    If Err.Number <> 0 Then
        Err.Clear
        swEq.Add2 -1, expr, True
    End If
    If Err.Number <> 0 Then
        Err.Clear
        swEq.Add -1, expr
    End If
    Err.Clear
End Sub

' ============================================================================
' ============================================================================
'  ENSAMBLAJE REAL (.sldasm con piezas .sldprt separadas)
' ============================================================================
' Ejecutar CrearEnsamblaje() como segunda macro, aparte de Main().
'
' Cada pieza se modela EN COORDENADAS GLOBALES dentro de su propio archivo, o
' sea que su geometria ya esta en el lugar que le toca del conjunto. Por eso
' los componentes se insertan todos en el origen (0,0,0) y quedan armados sin
' necesidad de una sola relacion de posicion para ubicarlos.
'
' Esto es deliberado: las relaciones de posicion por API (AddMate5) exigen
' seleccionar caras y ejes concretos de cada componente, que es justo el tipo
' de operacion que mas problemas dio en este proyecto. Posicionar por
' coordenadas es exacto y no puede fallar por seleccion.
'
' Las relaciones que SI hacen falta son las tres de MOVIMIENTO, y se explican
' al final de la ejecucion: son tres y se ponen a mano en un minuto.

Sub CrearEnsamblaje()
    On Error GoTo ErrHandler
    gLog = ""

    MkDirIfMissing CARPETA_PIEZAS

    Dim piezas() As PiezaSpec
    piezas = PiezasDelConjunto()

    ' --- 1. Una pieza .sldprt por cada bloque, en coordenadas globales ---
    Dim rutas() As String
    ReDim rutas(LBound(piezas) To UBound(piezas))

    Dim i As Long, creadas As Long
    For i = LBound(piezas) To UBound(piezas)
        rutas(i) = ""
        If Len(piezas(i).Nombre) > 0 Then
            rutas(i) = CrearPiezaSuelta(piezas(i))
            If Len(rutas(i)) > 0 Then creadas = creadas + 1
        End If
    Next i

    ' --- 2. El ensamblaje, con todos los componentes en el origen ---
    Dim insertadas As Long
    insertadas = MontarEnsamblaje(rutas)

    Dim msg As String
    msg = "Ensamblaje generado." & vbCrLf & vbCrLf & _
          "Piezas creadas: " & creadas & vbCrLf & _
          "Componentes insertados: " & insertadas & vbCrLf & vbCrLf & _
          "Carpeta de piezas:" & vbCrLf & CARPETA_PIEZAS & vbCrLf & vbCrLf & _
          "Las piezas ya estan en su posicion (van todas al origen)." & vbCrLf & _
          "Para que el conjunto sea funcional faltan 3 relaciones de" & vbCrLf & _
          "movimiento, que conviene poner a mano:" & vbCrLf & vbCrLf & _
          "  1. SEGUIMIENTO: TablaMovilPlataforma sobre BaseFijaPlataforma," & vbCrLf & _
          "     bisagra alrededor del eje polar (inclinado " & Format(PHI_DEG, "0.0") & " grados)." & vbCrLf & _
          "  2. AZIMUT: DobsonBaseMovil sobre DobsonBaseInferior," & vbCrLf & _
          "     bisagra alrededor del eje vertical." & vbCrLf & _
          "  3. ALTURA: TuboTelescopio y los dos costados de la caja," & vbCrLf & _
          "     bisagra alrededor del eje E-O a z = " & _
          Format(DOB_SANDWICH_CM + DOB_EJE_ALTURA_CM, "0.0") & " cm."

    If Len(gLog) > 0 Then
        msg = msg & vbCrLf & vbCrLf & "PASOS QUE NO SE COMPLETARON:" & vbCrLf & gLog
    End If

    MsgBox msg, vbInformation, "Ensamblaje"
    Exit Sub

ErrHandler:
    MsgBox "Error en CrearEnsamblaje(): " & Err.Description & vbCrLf & vbCrLf & gLog, vbCritical
End Sub

' Crea un part nuevo con una sola pieza y lo guarda. Devuelve la ruta, o "".
Private Function CrearPiezaSuelta(pz As PiezaSpec) As String
    CrearPiezaSuelta = ""
    On Error GoTo Fallo

    If Not CreateNewPart() Then
        LogFail pz.Nombre, "no se pudo crear el documento"
        Exit Function
    End If

    ' Los nombres de los planos estandar son los mismos en todas las piezas
    ' (misma plantilla), asi que alcanza con leerlos una vez.
    If Len(gPlanos(1)) = 0 Then CapturarNombresDePlanos

    If Not BuildPieza(pz) Then
        LogFail pz.Nombre, "no se pudo construir la geometria"
        CerrarDocActivo
        Exit Function
    End If

    Dim ruta As String
    ruta = CARPETA_PIEZAS & pz.Nombre & ".sldprt"

    Dim errs As Long, warns As Long, ok As Boolean
    ok = Model().Extension.SaveAs(ruta, 0, 1, Nothing, errs, warns)

    CerrarDocActivo

    If ok Then
        CrearPiezaSuelta = ruta
    Else
        LogFail pz.Nombre, "no se pudo guardar (error " & errs & ")"
    End If
    Exit Function

Fallo:
    LogFail pz.Nombre, Err.Description
End Function

' Crea el ensamblaje e inserta cada pieza en el origen. Devuelve cuantas entraron.
Private Function MontarEnsamblaje(rutas() As String) As Long
    MontarEnsamblaje = 0
    On Error GoTo Fallo

    Dim template As String
    On Error Resume Next
    template = SwApp().GetUserPreferenceStringValue(swUserPreferenceStringValue_e.swDefaultTemplateAssembly)
    On Error GoTo Fallo

    If Len(template) = 0 Then
        LogFail "Ensamblaje", "no hay plantilla de ensamblaje configurada"
        Exit Function
    End If

    Dim asmDoc As SldWorks.ModelDoc2
    Set asmDoc = SwApp().NewDocument(template, 0, 0, 0)
    If asmDoc Is Nothing Then
        LogFail "Ensamblaje", "no se pudo crear el documento de ensamblaje"
        Exit Function
    End If

    Dim asm As SldWorks.AssemblyDoc
    Set asm = asmDoc

    Dim i As Long, n As Long
    For i = LBound(rutas) To UBound(rutas)
        If Len(rutas(i)) > 0 Then
            ' Se abre la pieza antes de insertarla: AddComponent5 necesita que
            ' el documento este cargado en memoria.
            Dim errs As Long, warns As Long
            On Error Resume Next
            SwApp().OpenDoc6 rutas(i), 1, 0, "", errs, warns
            On Error GoTo Fallo

            Dim comp As Object
            On Error Resume Next
            Set comp = asm.AddComponent5(rutas(i), 0, "", False, "", 0, 0, 0)
            On Error GoTo Fallo

            If Not comp Is Nothing Then
                n = n + 1
            Else
                LogFail "Insertar " & rutas(i), "AddComponent5 no devolvio componente"
            End If
        End If
    Next i

    ' Relaciones de posicion: cada componente se ancla al origen del
    ' ensamblaje con tres coincidencias de plano (Alzado, Planta y Vista
    ' lateral contra sus homonimos del ensamblaje). Como cada pieza esta
    ' modelada en coordenadas globales, eso la deja exactamente donde va y
    ' COMPLETAMENTE DEFINIDA, que es lo que se espera de un ensamblaje final.
    ' Si alguna no se puede matear, se la fija, que deja el mismo resultado
    ' geometrico aunque sin las relaciones.
    Dim comps As Variant
    comps = asm.GetComponents(False)

    Dim mateadas As Long
    If Not IsEmpty(comps) Then
        For i = LBound(comps) To UBound(comps)
            If MatearAlOrigen(asm, asmDoc, comps(i)) Then
                mateadas = mateadas + 1
            Else
                FijarComponente asm, asmDoc, comps(i)
            End If
        Next i
    End If
    LogInfo "Componentes con relaciones de posicion: " & mateadas & " de " & n

    On Error Resume Next
    asmDoc.ClearSelection2 True
    asmDoc.ViewZoomtofit2
    On Error GoTo 0

    ' Guardar el ensamblaje al lado de las piezas.
    Dim errs2 As Long, warns2 As Long
    On Error Resume Next
    asmDoc.Extension.SaveAs CARPETA_PIEZAS & "ConjuntoTelescopio.sldasm", 0, 1, Nothing, errs2, warns2
    On Error GoTo 0

    MontarEnsamblaje = n
    Exit Function

Fallo:
    LogFail "Ensamblaje", Err.Description
    MontarEnsamblaje = n
End Function

' Ancla un componente al origen del ensamblaje con tres coincidencias de
' plano. Los planos se referencian por la ruta "Plano@Componente@Ensamblaje",
' que es la forma documentada de seleccionar geometria dentro de un
' componente; los nombres de los planos se leen del propio arbol para no
' depender del idioma de la instalacion.
Private Function MatearAlOrigen(asm As SldWorks.AssemblyDoc, _
                                asmDoc As SldWorks.ModelDoc2, _
                                comp As Object) As Boolean
    MatearAlOrigen = False
    On Error GoTo Fallo

    Dim nombreComp As String, tituloAsm As String
    nombreComp = comp.Name2
    tituloAsm = NombreSinExtension(asmDoc.GetTitle)

    Dim k As Long, hechas As Long
    For k = 1 To 3
        Dim nomPlano As String
        nomPlano = gPlanos(k)
        If Len(nomPlano) = 0 Then GoTo Siguiente

        asmDoc.ClearSelection2 True

        Dim okA As Boolean, okB As Boolean
        okA = asmDoc.Extension.SelectByID2(nomPlano & "@" & tituloAsm, _
                                           "PLANE", 0, 0, 0, True, 1, Nothing, 0)
        okB = asmDoc.Extension.SelectByID2(nomPlano & "@" & nombreComp & "@" & tituloAsm, _
                                           "PLANE", 0, 0, 0, True, 1, Nothing, 0)
        If Not (okA And okB) Then GoTo Siguiente

        ' AddMate5(TipoRelacion, Alineacion, Flip, Distancia, LimSup, LimInf,
        '   NumEngranaje, DenEngranaje, Angulo, AngLimSup, AngLimInf,
        '   SoloParaPosicionar, BloquearRotacion, OpcionAncho, EstadoError)
        ' 0 = coincidente, 0 = alineada.
        Dim est As Long
        Dim mate As Object
        Set mate = asm.AddMate5(0, 0, False, 0, 0, 0, 1, 1, 0, 0, 0, _
                                False, False, 0, est)
        If Not mate Is Nothing Then hechas = hechas + 1
Siguiente:
    Next k

    asmDoc.ClearSelection2 True
    MatearAlOrigen = (hechas = 3)
    Exit Function

Fallo:
    On Error Resume Next
    asmDoc.ClearSelection2 True
End Function

Private Sub FijarComponente(asm As SldWorks.AssemblyDoc, _
                            asmDoc As SldWorks.ModelDoc2, comp As Object)
    On Error Resume Next
    asmDoc.ClearSelection2 True
    comp.Select4 False, Nothing, False
    asm.FixComponent
    asmDoc.ClearSelection2 True
    On Error GoTo 0
End Sub

' Lee del arbol los nombres reales de los tres planos estandar y los guarda,
' para poder armar las rutas de seleccion del ensamblaje sin suponer idioma.
Private Sub CapturarNombresDePlanos()
    Dim k As Long
    For k = 1 To 3
        Dim f As SldWorks.Feature
        Set f = StandardPlane(k)
        If Not f Is Nothing Then
            On Error Resume Next
            gPlanos(k) = f.Name
            On Error GoTo 0
        End If
    Next k
End Sub

Private Function NombreSinExtension(s As String) As String
    Dim i As Long
    NombreSinExtension = s
    i = InStrRev(s, ".")
    If i > 1 Then NombreSinExtension = Left(s, i - 1)
End Function

Private Sub CerrarDocActivo()
    On Error Resume Next
    Dim t As String
    t = Model().GetTitle
    SwApp().CloseDoc t
    On Error GoTo 0
End Sub

' ============================================================================
' ---- DXF escrito directamente (ver nota 6) --------------------------------
' El perfil del sector es plano, asi que se emite en 2D con el centro de
' curvatura en el origen y la bisectriz sobre el eje X. Formato DXF R12
' minimo (LINE + ARC), que leen todos los programas de corte. Medidas en mm.

Private Sub WriteSectorDXF(sec As SectorGeom)
    On Error GoTo Fallo

    MkDirIfMissing DXF_OUTPUT_FOLDER

    Dim rOut As Double, rIn As Double, aDeg As Double
    rOut = (sec.R_cm + SECTOR_ANCHO_CM / 2#) * MM_PER_CM
    rIn = (sec.R_cm - SECTOR_ANCHO_CM / 2#) * MM_PER_CM
    aDeg = sec.HalfAngle * 180# / PI

    Dim s As String
    s = "0" & vbCrLf & "SECTION" & vbCrLf & "2" & vbCrLf & "ENTITIES" & vbCrLf

    ' Arcos: en DXF van siempre en sentido antihorario, de -a a +a.
    s = s & DxfArc(rOut, -aDeg, aDeg)
    s = s & DxfArc(rIn, -aDeg, aDeg)

    ' Caras radiales que cierran el perfil en cada extremo.
    s = s & DxfLine(rIn * Cos(-sec.HalfAngle), rIn * Sin(-sec.HalfAngle), _
                    rOut * Cos(-sec.HalfAngle), rOut * Sin(-sec.HalfAngle))
    s = s & DxfLine(rIn * Cos(sec.HalfAngle), rIn * Sin(sec.HalfAngle), _
                    rOut * Cos(sec.HalfAngle), rOut * Sin(sec.HalfAngle))

    s = s & "0" & vbCrLf & "ENDSEC" & vbCrLf & "0" & vbCrLf & "EOF" & vbCrLf

    Dim f As Integer
    f = FreeFile
    Open DXF_OUTPUT_FOLDER & "SectorPlantilla" & sec.Nombre & ".dxf" For Output As #f
    Print #f, s;
    Close #f
    Exit Sub

Fallo:
    LogFail "DXF del sector " & sec.Nombre, Err.Description
End Sub

Private Function DxfLine(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As String
    DxfLine = "0" & vbCrLf & "LINE" & vbCrLf & "8" & vbCrLf & "0" & vbCrLf & _
              "10" & vbCrLf & NumStr(x1) & vbCrLf & _
              "20" & vbCrLf & NumStr(y1) & vbCrLf & _
              "30" & vbCrLf & "0.0" & vbCrLf & _
              "11" & vbCrLf & NumStr(x2) & vbCrLf & _
              "21" & vbCrLf & NumStr(y2) & vbCrLf & _
              "31" & vbCrLf & "0.0" & vbCrLf
End Function

Private Function DxfArc(radio As Double, angIni As Double, angFin As Double) As String
    DxfArc = "0" & vbCrLf & "ARC" & vbCrLf & "8" & vbCrLf & "0" & vbCrLf & _
             "10" & vbCrLf & "0.0" & vbCrLf & _
             "20" & vbCrLf & "0.0" & vbCrLf & _
             "30" & vbCrLf & "0.0" & vbCrLf & _
             "40" & vbCrLf & NumStr(radio) & vbCrLf & _
             "50" & vbCrLf & NumStr(angIni) & vbCrLf & _
             "51" & vbCrLf & NumStr(angFin) & vbCrLf
End Function

' Str() usa SIEMPRE punto decimal. Format() o CStr() usarian la coma del
' Windows en espanol y el DXF saldria corrupto.
Private Function NumStr(v As Double) As String
    NumStr = Trim(Str(Round(v, 4)))
End Function

Private Sub MkDirIfMissing(ruta As String)
    On Error Resume Next
    If Len(Dir(ruta, vbDirectory)) = 0 Then MkDir ruta
    On Error GoTo 0
End Sub

' ============================================================================
' ---- Busqueda de operaciones ----------------------------------------------
' No hay un helper generico de seleccion: cada operacion prueba sus vias y se
' juzga por el efecto conseguido. Select2 devolvia False en esta instalacion
' aun cuando la seleccion se hacia, asi que su valor devuelto no sirve como
' condicion.

Private Function LastFeature() As SldWorks.Feature
    On Error Resume Next
    Set LastFeature = Model().FeatureByPositionReverse(0)
    On Error GoTo 0
End Function

' Plano estandar por posicion en el arbol (1=Alzado/Front, 2=Planta/Top,
' 3=Vista lateral/Right), filtrando por tipo "RefPlane". Independiente del
' idioma de la instalacion.
Private Function StandardPlane(indice As Long) As SldWorks.Feature
    On Error GoTo Fallo

    Dim f As SldWorks.Feature
    Dim n As Long

    Set f = Model().FirstFeature
    Do While Not f Is Nothing
        If f.GetTypeName2 = "RefPlane" Then
            n = n + 1
            If n = indice Then
                Set StandardPlane = f
                Exit Function
            End If
        End If
        Set f = f.GetNextFeature
    Loop
    Exit Function

Fallo:
End Function

Private Function RenameLastFeature(nuevoNombre As String) As String
    RenameLastFeature = ""

    Dim f As SldWorks.Feature
    Set f = LastFeature()
    If f Is Nothing Then
        LogFail "Renombrar a " & nuevoNombre, "no se encontro la ultima operacion"
        Exit Function
    End If

    On Error Resume Next
    f.Name = nuevoNombre
    RenameLastFeature = f.Name
    On Error GoTo 0
End Function

' ============================================================================
' ---- Manejo de sketches (ver nota 2) --------------------------------------
' Insert3DSketch e InsertSketch son TOGGLES: abren si no hay sketch activo y
' cierran el activo si lo hay. Por eso siempre se verifica el estado.

Private Function Open3DSketch() As Boolean
    Open3DSketch = False
    On Error Resume Next

    If Not SkMgr().ActiveSketch Is Nothing Then Close3DSketch   ' no dejar uno abierto
    Model().ClearSelection2 True
    SkMgr().Insert3DSketch True
    Open3DSketch = Not (SkMgr().ActiveSketch Is Nothing)

    On Error GoTo 0
End Function

Private Sub Close3DSketch()
    On Error Resume Next
    If Not SkMgr().ActiveSketch Is Nothing Then SkMgr().Insert3DSketch True
    On Error GoTo 0
End Sub

Private Sub Close2DSketch()
    On Error Resume Next
    If Not SkMgr().ActiveSketch Is Nothing Then SkMgr().InsertSketch True
    On Error GoTo 0
End Sub

' ============================================================================
' ---- Helpers de sketch 3D -------------------------------------------------
' Conversion de la convencion del proyecto (cm, +y sur, +z arriba) al espacio
' de modelo de SolidWorks (metros, Y vertical):
'     modelo_x = x        modelo_y = z (arriba)        modelo_z = y (sur)

Private Function CreatePoint3D(p As Vec3) As Object
    Set CreatePoint3D = SkMgr().CreatePoint(p.X * M_PER_CM, p.Z * M_PER_CM, p.Y * M_PER_CM)
End Function

Private Function CreateLine3D(p1 As Vec3, p2 As Vec3) As Object
    Set CreateLine3D = SkMgr().CreateLine(p1.X * M_PER_CM, p1.Z * M_PER_CM, p1.Y * M_PER_CM, _
                                          p2.X * M_PER_CM, p2.Z * M_PER_CM, p2.Y * M_PER_CM)
End Function

Private Function CreateArc3D(centro As Vec3, pStart As Vec3, pEnd As Vec3) As Object
    Set CreateArc3D = SkMgr().CreateArc(centro.X * M_PER_CM, centro.Z * M_PER_CM, centro.Y * M_PER_CM, _
                                        pStart.X * M_PER_CM, pStart.Z * M_PER_CM, pStart.Y * M_PER_CM, _
                                        pEnd.X * M_PER_CM, pEnd.Z * M_PER_CM, pEnd.Y * M_PER_CM, _
                                        ARC_DIR)
End Function

' Punto del sector a radio r y angulo a (rad) desde la direccion del
' rodamiento, en el plano del sector.
Private Function ArcPoint(sec As SectorGeom, r As Double, a As Double) As Vec3
    ArcPoint = VAdd(sec.Centro, _
                    VAdd(VScale(sec.Basis1, r * Cos(a)), VScale(sec.Basis2, r * Sin(a))))
End Function

' ============================================================================
' ---- Vectores y matematica ------------------------------------------------

Private Function VAdd(a As Vec3, b As Vec3) As Vec3
    VAdd.X = a.X + b.X: VAdd.Y = a.Y + b.Y: VAdd.Z = a.Z + b.Z
End Function

Private Function VSub(a As Vec3, b As Vec3) As Vec3
    VSub.X = a.X - b.X: VSub.Y = a.Y - b.Y: VSub.Z = a.Z - b.Z
End Function

Private Function VScale(a As Vec3, s As Double) As Vec3
    VScale.X = a.X * s: VScale.Y = a.Y * s: VScale.Z = a.Z * s
End Function

Private Function VDot(a As Vec3, b As Vec3) As Double
    VDot = a.X * b.X + a.Y * b.Y + a.Z * b.Z
End Function

Private Function VCross(a As Vec3, b As Vec3) As Vec3
    VCross.X = a.Y * b.Z - a.Z * b.Y
    VCross.Y = a.Z * b.X - a.X * b.Z
    VCross.Z = a.X * b.Y - a.Y * b.X
End Function

Private Function VNormalize(a As Vec3) As Vec3
    Dim L As Double
    L = Sqr(VDot(a, a))
    If L = 0 Then Exit Function
    VNormalize = VScale(a, 1# / L)
End Function

Private Function MaxDouble(a As Double, b As Double) As Double
    If a > b Then MaxDouble = a Else MaxDouble = b
End Function

Private Function Deg2Rad(d As Double) As Double
    Deg2Rad = d * PI / 180#
End Function
