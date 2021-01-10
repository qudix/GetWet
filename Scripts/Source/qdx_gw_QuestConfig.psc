ScriptName qdx_gw_QuestConfig Extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestMain Property Main Auto

Float Property UpdateLoopFreq = 0.0 Auto Hidden
Float Property UpdateLoopRange = 0.0 Auto Hidden

Float Property VisualGlossinessMin = 0.0 Auto Hidden
Float Property VisualGlossinessMax = 0.0 Auto Hidden
Float Property VisualSpecularMin = 0.0 Auto Hidden
Float Property VisualSpecularMax = 0.0 Auto Hidden

Bool Property ApplyPlayer = False Auto Hidden
Bool Property ApplyNPC = False Auto Hidden
Bool Property ApplyFemale = False Auto Hidden
Bool Property ApplyMale = False Auto Hidden
Bool Property ApplyBeast = False Auto Hidden

Bool Property VisualGlossinessHead = False Auto Hidden
Bool Property VisualSpecularHead = False Auto Hidden
Bool Property VisualGlossinessBody = False Auto Hidden
Bool Property VisualSpecularBody = False Auto Hidden
Bool Property VisualGlossinessHands = False Auto Hidden
Bool Property VisualSpecularHands = False Auto Hidden
Bool Property VisualGlossinessFeet = False Auto Hidden
Bool Property VisualSpecularFeet = False Auto Hidden
Bool Property VisualGlossinessOther = False Auto Hidden
Bool Property VisualSpecularOther = False Auto Hidden

Bool Property DebugMode = True Auto Hidden

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Handle getting the mod config during init and reload
Event OnInit()
    If (Main.IsStopped())
        Main.PrintDebug("Aborting Config Init: Controller is not running.")
        Return
    EndIf

    GetConfig()
    Main.PrintDebug("Config Loaded")
EndEvent

Event OnReload()
    GetConfig()
EndEvent

Function GetConfig()
    Float[] Floats = qdx_gw.GetFloatSettings()
    UpdateLoopFreq = Floats[0]
    UpdateLoopRange = Floats[1]
    VisualGlossinessMin = Floats[2]
    VisualGlossinessMax = Floats[3]
    VisualSpecularMin = Floats[4]
    VisualSpecularMax = Floats[5]

	Bool[] Bools = qdx_gw.GetBoolSettings()
	ApplyPlayer = Bools[0]
	ApplyNPC = Bools[1]
	ApplyFemale = Bools[2]
	ApplyMale = Bools[3]
	ApplyBeast = Bools[4]
	VisualGlossinessHead = Bools[5]
    VisualSpecularHead = Bools[6]
    VisualGlossinessBody = Bools[7]
    VisualSpecularBody = Bools[8]
    VisualGlossinessHands = Bools[9]
    VisualSpecularHands = Bools[10]
    VisualGlossinessFeet = Bools[11]
    VisualSpecularFeet = Bools[12]
    VisualGlossinessOther = Bools[13]
	VisualSpecularOther = Bools[14]
EndFunction
