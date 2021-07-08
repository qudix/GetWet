ScriptName qdx_gw_QuestConfig Extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestMain Property Main Auto

Float Property ActStamina = 0.0 Auto Hidden
Float Property ActMagicka = 0.0 Auto Hidden
Float Property ActSprinting = 0.0 Auto Hidden
Float Property ActRunning = 0.0 Auto Hidden
Float Property ActSneaking = 0.0 Auto Hidden
Float Property ActGalloping = 0.0 Auto Hidden
Float Property ActWorking = 0.0 Auto Hidden

Float Property WetnessMin = 0.0 Auto Hidden
Float Property WetnessMax = 0.0 Auto Hidden
Float Property WetnessRateMax = 0.0 Auto Hidden

Float Property GlossinessMin = 0.0 Auto Hidden
Float Property GlossinessMax = 0.0 Auto Hidden
Bool Property GlossinessHead = False Auto Hidden
Bool Property GlossinessBody = False Auto Hidden
Bool Property GlossinessHands = False Auto Hidden
Bool Property GlossinessFeet = False Auto Hidden
Bool Property GlossinessOther = False Auto Hidden

Float Property SpecularMin = 0.0 Auto Hidden
Float Property SpecularMax = 0.0 Auto Hidden
Bool Property SpecularHead = False Auto Hidden
Bool Property SpecularBody = False Auto Hidden
Bool Property SpecularHands = False Auto Hidden
Bool Property SpecularFeet = False Auto Hidden
Bool Property SpecularOther = False Auto Hidden

Bool Property ApplyGlobal = False Auto Hidden
Bool Property ApplyPlayer = False Auto Hidden
Bool Property ApplyNPC = False Auto Hidden
Bool Property ApplyFemale = False Auto Hidden
Bool Property ApplyMale = False Auto Hidden
Bool Property ApplyBeast = False Auto Hidden

Bool Property MiscDebug = True Auto Hidden

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Event OnInit()
	qdx_gw.GetConfig()
EndEvent

Event OnReload()
	qdx_gw.GetConfig()
EndEvent
