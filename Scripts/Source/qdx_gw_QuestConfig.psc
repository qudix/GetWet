ScriptName qdx_gw_QuestConfig Extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestMain Property Main Auto

Float Property ActivityStamina = 0.0 Auto Hidden
Float Property ActivityMagicka = 0.0 Auto Hidden
Float Property ActivitySprinting = 0.0 Auto Hidden
Float Property ActivityRunning = 0.0 Auto Hidden
Float Property ActivitySneaking = 0.0 Auto Hidden
Float Property ActivityGalloping = 0.0 Auto Hidden
Float Property ActivityWorking = 0.0 Auto Hidden

Float Property VisualWetnessMax = 0.0 Auto Hidden
Float Property VisualWetnessRateMax = 0.0 Auto Hidden
Float Property VisualGlossinessMin = 0.0 Auto Hidden
Float Property VisualGlossinessMax = 0.0 Auto Hidden
Float Property VisualSpecularMin = 0.0 Auto Hidden
Float Property VisualSpecularMax = 0.0 Auto Hidden

Bool Property ApplyGlobal = False Auto Hidden
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
	VisualWetnessMax = Floats[0]
	VisualWetnessRateMax = Floats[1]
	VisualGlossinessMin = Floats[2]
	VisualGlossinessMax = Floats[3]
	VisualSpecularMin = Floats[4]
	VisualSpecularMax = Floats[5]

	Bool[] Bools = qdx_gw.GetBoolSettings()
	ApplyGlobal = Bools[0]
	ApplyPlayer = Bools[1]
	ApplyNPC = Bools[2]
	ApplyFemale = Bools[3]
	ApplyMale = Bools[4]
	ApplyBeast = Bools[5]
	VisualGlossinessHead = Bools[6]
	VisualSpecularHead = Bools[7]
	VisualGlossinessBody = Bools[8]
	VisualSpecularBody = Bools[9]
	VisualGlossinessHands = Bools[10]
	VisualSpecularHands = Bools[11]
	VisualGlossinessFeet = Bools[12]
	VisualSpecularFeet = Bools[13]
	VisualGlossinessOther = Bools[14]
	VisualSpecularOther = Bools[15]
EndFunction
