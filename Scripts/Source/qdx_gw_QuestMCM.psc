ScriptName qdx_gw_QuestMCM Extends SKI_ConfigBase

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestMain Property Main Auto
qdx_gw_QuestConfig Property Config Auto

Sound Property SoundTickSmall Auto
Sound Property SoundTickBig Auto
Sound Property SoundDing Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                  Page: General
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int B_ModActive
Int B_ApplyGlobal
Int B_ApplyPlayer
Int B_ApplyNPC
Int B_ApplyMale
Int B_ApplyFemale
Int B_ApplyBeast
Int B_UpdateAll

Int S_VisualGlossinessMin
Int S_VisualGlossinessMax
Int B_VisualGlossinessHead
Int B_VisualGlossinessBody
Int B_VisualGlossinessHands
Int B_VisualGlossinessFeet
Int B_VisualGlossinessOther
Int S_VisualSpecularMin
Int S_VisualSpecularMax
Int B_VisualSpecularHead
Int B_VisualSpecularBody
Int B_VisualSpecularHands
Int B_VisualSpecularFeet
Int B_VisualSpecularOther

Function ShowPageGeneral()
	SetTitleText("$GW_Title_General")
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	AddHeaderOption("$GW_Header_ModStatus")
	B_ModActive = AddToggleOption("$GW_Toggle_ModActive", Main.IsRunning())

	AddEmptyOption()
	AddHeaderOption("$GW_Header_Apply")
	B_ApplyGlobal = AddToggleOption("$GW_Toggle_TypeGlobal", Config.ApplyGlobal)
	B_ApplyPlayer = AddToggleOption("$GW_Toggle_TypePlayer", Config.ApplyPlayer)
	B_ApplyNPC = AddToggleOption("$GW_Toggle_TypeNPC", Config.ApplyNPC)
	B_ApplyMale = AddToggleOption("$GW_Toggle_TypeMale", Config.ApplyMale)
	B_ApplyFemale = AddToggleOption("$GW_Toggle_TypeFemale", Config.ApplyFemale)
	B_ApplyBeast = AddToggleOption("$GW_Toggle_TypeBeast", Config.ApplyBeast)
	B_UpdateAll = AddTextOption("", "$GW_Toggle_UpdateAll")

	SetCursorPosition(1)

	AddHeaderOption("$GW_Header_Glossiness")
	S_VisualGlossinessMin = AddSliderOption("$GW_Slider_RangeMin", Config.VisualGlossinessMin, "{0}")
	S_VisualGlossinessMax = AddSliderOption("$GW_Slider_RangeMax", Config.VisualGlossinessMax, "{0}")
	B_VisualGlossinessHead = AddToggleOption("$GW_Toggle_PartHead", Config.VisualGlossinessHead)
	B_VisualGlossinessBody = AddToggleOption("$GW_Toggle_PartBody", Config.VisualGlossinessBody)
	B_VisualGlossinessHands = AddToggleOption("$GW_Toggle_PartHands", Config.VisualGlossinessHands)
	B_VisualGlossinessFeet = AddToggleOption("$GW_Toggle_PartFeet", Config.VisualGlossinessFeet)
	B_VisualGlossinessOther = AddToggleOption("$GW_Toggle_PartOther", Config.VisualGlossinessOther)

	AddEmptyOption()
	AddHeaderOption("$GW_Header_Specular")
	S_VisualSpecularMin = AddSliderOption("$GW_Slider_RangeMin", Config.VisualSpecularMin, "{1}")
	S_VisualSpecularMax = AddSliderOption("$GW_Slider_RangeMax", Config.VisualSpecularMax, "{1}")
	B_VisualSpecularHead = AddToggleOption("$GW_Toggle_PartHead", Config.VisualSpecularHead)
	B_VisualSpecularBody = AddToggleOption("$GW_Toggle_PartBody", Config.VisualSpecularBody)
	B_VisualSpecularHands = AddToggleOption("$GW_Toggle_PartHands", Config.VisualSpecularHands)
	B_VisualSpecularFeet = AddToggleOption("$GW_Toggle_PartFeet", Config.VisualSpecularFeet)
	B_VisualSpecularOther = AddToggleOption("$GW_Toggle_PartOther", Config.VisualSpecularOther)
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Actor
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int M_ActorList
Int T_ActorSetCustom
Int S_ActorGlossinessMin
Int S_ActorGlossinessMax
Int S_ActorSpecularMin
Int S_ActorSpecularMax
Int B_UpdateActor

Actor[] ActorList
String[] ActorNameList
Actor ActorTarget
Int ActorTargetIndex
Float[] ActorTargetSettings

Function InitActorData()
	ActorList = qdx_gw.GetActorList()

	If (ActorList.Length > 0)
		ActorNameList = qdx_gw.GetActorNameList()
	EndIf

	If (!ActorTarget)
		ActorTarget = ActorList[0]
	EndIf

	If (ActorTarget)
		qdx_gw.UpdateActor(ActorTarget)
		ActorTargetSettings = qdx_gw.GetActorFloatSettings(ActorTarget)
	EndIf
EndFunction

Function ShowPageActor()
	SetTitleText("$GW_Title_Actor")
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	InitActorData()

	If (ActorTarget && ActorTargetSettings.Length > 1)
		AddHeaderOption("$GW_Header_Glossiness")
		S_ActorGlossinessMin = AddSliderOption("$GW_Slider_RangeMin", ActorTargetSettings[0], "{1}")
		S_ActorGlossinessMax = AddSliderOption("$GW_Slider_RangeMax", ActorTargetSettings[1], "{1}")
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Specular")
		S_ActorSpecularMin = AddSliderOption("$GW_Slider_RangeMin", ActorTargetSettings[2], "{1}")
		S_ActorSpecularMax = AddSliderOption("$GW_Slider_RangeMax", ActorTargetSettings[3], "{1}")
	Else
		AddHeaderOption("$GW_Header_Glossiness")
		S_ActorGlossinessMin = AddSliderOption("$GW_Slider_RangeMin", 0.0, "{1}", OPTION_FLAG_DISABLED)
		S_ActorGlossinessMax = AddSliderOption("$GW_Slider_RangeMax", 0.0, "{1}", OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Specular")
		S_ActorSpecularMin = AddSliderOption("$GW_Slider_RangeMin", 0.0, "{1}", OPTION_FLAG_DISABLED)
		S_ActorSpecularMax = AddSliderOption("$GW_Slider_RangeMax", 0.0, "{1}", OPTION_FLAG_DISABLED)
	EndIf

	SetCursorPosition(1)
	AddHeaderOption("$GW_Header_ActorList")
	If (ActorTarget && ActorList.Length > 0)
		M_ActorList = AddMenuOption("$GW_Menu_Target", ActorNameList[ActorTargetIndex])
	Else
		M_ActorList = AddMenuOption("$GW_Menu_Target", "[None]")
	EndIf

	If (ActorTarget)
		If (ActorTargetSettings.Length > 1)
			T_ActorSetCustom = AddTextOption("$GW_Text_ActorCustom", "Remove")
		Else
			T_ActorSetCustom = AddTextOption("$GW_Text_ActorCustom", "Add")
		EndIf
	Else
		T_ActorSetCustom = AddTextOption("$GW_Text_ActorCustom", "Unknown", OPTION_FLAG_DISABLED)
	EndIf

	B_UpdateActor = AddTextOption("", "$GW_Toggle_UpdateActor")
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Debug
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int B_DebugActive

Function ShowPageDebug()
	SetTitleText("$GW_Title_Debug")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("$GW_Header_DependencyCheck")
	AddToggleOption("$GW_Dependency_SKSE", Main.CheckDep_SKSE(False), OPTION_FLAG_DISABLED)
	AddToggleOption("$GW_Dependency_SkyUI", Main.CheckDep_SkyUI(False), OPTION_FLAG_DISABLED)

	SetCursorPosition(1)
	AddHeaderOption("$GW_Header_DebugStatus")
	B_DebugActive = AddToggleOption("$GW_Toggle_DebugActive", Config.DebugMode)
	AddEmptyOption()
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Event OnGameReload()
	Parent.OnGameReload()
	Config.GetConfig()
EndEvent

Event OnConfigInit()
	Self.Pages = new String[3]
	Self.Pages[0] = "$GW_Page_General"
	Self.Pages[1] = "$GW_Page_Actor"
	Self.Pages[2] = "$GW_Page_Debug"

	ActorTarget = None
	ActorTargetIndex = 0
EndEvent

Event OnConfigOpen()
	Config.GetConfig()
	Self.OnConfigInit()
EndEvent

Event OnConfigClose()
EndEvent

Event OnPageReset(String Page)
	If (Page == "")
		SoundDing.Play(Main.Player)
	EndIf

	UnloadCustomContent()
	Config.GetConfig()

	If (Page == "$GW_Page_General")
		SoundTickBig.Play(Main.Player)
		ShowPageGeneral()
	ElseIf (Page == "$GW_Page_Actor")
		SoundTickBig.Play(Main.Player)
		ShowPageActor()
	ElseIf (Page == "$GW_Page_Debug")
		SoundTickBig.Play(Main.Player)
		ShowPageDebug()
	EndIf
EndEvent

Event OnOptionSelect(Int Item)
	SoundTickBig.Play(Main.Player)
	Bool Value = False
	String Setting = ""

	If (Item == B_VisualGlossinessHead)
		Value = !Config.VisualGlossinessHead
		Config.VisualGlossinessHead = Value
		Setting = "VisualGlossinessHead"
	ElseIf (Item == B_VisualGlossinessBody)
		Value = !Config.VisualGlossinessBody
		Config.VisualGlossinessBody = Value
		Setting = "VisualGlossinessBody"
	ElseIf (Item == B_VisualGlossinessHands)
		Value = !Config.VisualGlossinessHands
		Config.VisualGlossinessHands = Value
		Setting = "VisualGlossinessHands"
	ElseIf (Item == B_VisualGlossinessFeet)
		Value = !Config.VisualGlossinessFeet
		Config.VisualGlossinessFeet = Value
		Setting = "VisualGlossinessFeet"
	ElseIf (Item == B_VisualGlossinessOther)
		Value = !Config.VisualGlossinessOther
		Config.VisualGlossinessOther = Value
		Setting = "VisualGlossinessOther"
	ElseIf (Item == B_VisualSpecularHead)
		Value = !Config.VisualSpecularHead
		Config.VisualSpecularHead = Value
		Setting = "VisualSpecularHead"
	ElseIf (Item == B_VisualSpecularBody)
		Value = !Config.VisualSpecularBody
		Config.VisualSpecularBody = Value
		Setting = "VisualSpecularBody"
	ElseIf (Item == B_VisualSpecularHands)
		Value = !Config.VisualSpecularHands
		Config.VisualSpecularHands = Value
		Setting = "VisualSpecularHands"
	ElseIf (Item == B_VisualSpecularFeet)
		Value = !Config.VisualSpecularFeet
		Config.VisualSpecularFeet = Value
		Setting = "VisualSpecularFeet"
	ElseIf (Item == B_VisualSpecularOther)
		Value = !Config.VisualSpecularOther
		Config.VisualSpecularOther = Value
		Setting = "VisualSpecularOther"
	ElseIf (Item == B_ApplyGlobal)
		Value = !Config.ApplyGlobal
		Config.ApplyGlobal = Value
		Setting = "ApplyGlobal"
	ElseIf (Item == B_ApplyPlayer)
		Value = !Config.ApplyPlayer
		Config.ApplyPlayer = Value
		Setting = "ApplyPlayer"
	ElseIf (Item == B_ApplyNPC)
		Value = !Config.ApplyNPC
		Config.ApplyNPC = Value
		Setting = "ApplyNPC"
	ElseIf (Item == B_ApplyMale)
		Value = !Config.ApplyMale
		Config.ApplyMale = Value
		Setting = "ApplyMale"
	ElseIf (Item == B_ApplyFemale)
		Value = !Config.ApplyFemale
		Config.ApplyFemale = Value
		Setting = "ApplyFemale"
	ElseIf (Item == B_ApplyBeast)
		Value = !Config.ApplyBeast
		Config.ApplyBeast = Value
		Setting = "ApplyBeast"
	ElseIf (Item == B_DebugActive)
		Value = !Config.DebugMode
		Config.DebugMode = Value
	ElseIf (Item == B_UpdateAll)
		qdx_gw.Update()
	ElseIf (Item == B_UpdateActor)
		if (ActorTarget)
			qdx_gw.UpdateActor(ActorTarget)
		EndIf
	ElseIf (Item == B_ModActive)
		If Main.IsRunning()
			Main.Reset()
			Main.Stop()
			Main.Print("Shutting down.")
		Else
			Value = True
			Main.Start()
		EndIf
	ElseIf (Item == T_ActorSetCustom)
		If (ActorTarget && ActorTargetSettings.Length > 0)
			qdx_gw.RemoveActorSettings(ActorTarget)
			Main.PrintDebug("Remove")
		Else
			qdx_gw.AddActorSettings(ActorTarget)
			Main.PrintDebug("Add")
		EndIf

		ForcePageReset()
		Return
	EndIf

	If (Setting != "")
		qdx_gw.SetBoolSetting(Setting, Value)
	EndIf

	SetToggleOptionValue(Item, Value)
EndEvent

Event OnOptionSliderOpen(Int Item)
	SoundTickBig.Play(Main.Player)
	Float Val = 0.0
	Float Min = 0.0
	Float Max = 0.0
	Float Interval = 0.0

	If (Item == S_VisualGlossinessMin)
		Val = Config.VisualGlossinessMin
		Min = 5.0
		Max = 1000.0
		Interval = 5.0
	ElseIf (Item == S_VisualGlossinessMax)
		Val = Config.VisualGlossinessMax
		Min = 5.0
		Max = 1000.0
		Interval = 5.0
	ElseIf (Item == S_VisualSpecularMin)
		Val = Config.VisualSpecularMin
		Min = 0.5
		Max = 100.0
		Interval = 0.5
	ElseIf (Item == S_VisualSpecularMax)
		Val = Config.VisualSpecularMax
		Min = 0.5
		Max = 100.0
		Interval = 0.5
	ElseIf (Item == S_ActorGlossinessMin)
		Val = ActorTargetSettings[0]
		Min = 5.0
		Max = 1000.0
		Interval = 5.0
	ElseIf (Item == S_ActorGlossinessMax)
		Val = ActorTargetSettings[1]
		Min = 5.0
		Max = 1000.0
		Interval = 5.0
	ElseIf (Item == S_ActorSpecularMin)
		Val = ActorTargetSettings[2]
		Min = 0.5
		Max = 100.0
		Interval = 0.5
	ElseIf (Item == S_ActorSpecularMax)
		Val = ActorTargetSettings[3]
		Min = 0.5
		Max = 100.0
		Interval = 0.5
	EndIf

	SetSliderDialogStartValue(Val)
	SetSliderDialogRange(Min, Max)
	SetSliderDialogInterval(Interval)
EndEvent

Event OnOptionSliderAccept(Int Item, Float Val)
	SoundTickBig.Play(Main.Player)
	String Fmt = "{0}"
	String Setting = ""

	If (Item == S_VisualGlossinessMin)
		Fmt = "{1}"
		Config.VisualGlossinessMin = Val
		Setting = "VisualGlossinessMin"
	ElseIf (Item == S_VisualGlossinessMax)
		Fmt = "{1}"
		Config.VisualGlossinessMax = Val
		Setting = "VisualGlossinessMax"
	ElseIf (Item == S_VisualSpecularMin)
		Fmt = "{1}"
		Config.VisualSpecularMin = Val
		Setting = "VisualSpecularMin"
	ElseIf (Item == S_VisualSpecularMax)
		Fmt = "{1}"
		Config.VisualSpecularMax = Val
		Setting = "VisualSpecularMax"
	ElseIf (Item == S_ActorGlossinessMin)
		Fmt = "{1}"
		qdx_gw.SetActorFloatSetting(ActorTarget, "VisualGlossinessMin", Val)
	ElseIf (Item == S_ActorGlossinessMax)
		Fmt = "{1}"
		qdx_gw.SetActorFloatSetting(ActorTarget, "VisualGlossinessMax", Val)
	ElseIf (Item == S_ActorSpecularMin)
		Fmt = "{1}"
		qdx_gw.SetActorFloatSetting(ActorTarget, "VisualSpecularMin", Val)
	ElseIf (Item == S_ActorSpecularMax)
		Fmt = "{1}"
		qdx_gw.SetActorFloatSetting(ActorTarget, "VisualSpecularMax", Val)
	EndIf

	If (Setting != "")
		qdx_gw.SetFloatSetting(Setting, Val)
	EndIf

	If (ActorTarget)
		ActorTargetSettings = qdx_gw.GetActorFloatSettings(ActorTarget)
	EndIf

	SetSliderOptionValue(Item, Val, Fmt)
EndEvent

Event OnOptionMenuOpen(Int Item)
	SoundTickBig.Play(Main.Player)
	If (Item == M_ActorList)
		SetMenuDialogOptions(ActorNameList)
		SetMenuDialogStartIndex(ActorTargetIndex)
		SetMenuDialogDefaultIndex(0)
	EndIf
EndEvent

Event OnOptionMenuAccept(Int Item, Int Selected)
	SoundTickBig.Play(Main.Player)
	If (Item == M_ActorList)
		ActorTarget = ActorList[Selected]
		ActorTargetIndex = Selected
		SetMenuOptionValue(M_ActorList, ActorNameList[ActorTargetIndex])
		ForcePageReset()
	EndIf
EndEvent

Event OnOptionHighlight(Int Item)
	String Text = ""

	If (Item == B_ModActive)
		Text = "$GW_Tip_ModActive"
	ElseIf ((Item == S_VisualGlossinessMin) || (Item == S_VisualSpecularMin))
		Text = "$GW_Tip_PartMin"
	ElseIf ((Item == S_VisualGlossinessMax) || (Item == S_VisualSpecularMax))
		Text = "$GW_Tip_PartMax"
	ElseIf ((Item == B_VisualGlossinessHead) || (Item == B_VisualSpecularHead))
		Text = "$GW_Tip_PartHead"
	ElseIf ((Item == B_VisualGlossinessBody) || (Item == B_VisualSpecularBody))
		Text = "$GW_Tip_PartBody"
	ElseIf ((Item == B_VisualGlossinessHands) || (Item == B_VisualSpecularHands))
		Text = "$GW_Tip_PartHands"
	ElseIf ((Item == B_VisualGlossinessFeet) || (Item == B_VisualSpecularFeet))
		Text = "$GW_Tip_PartFeet"
	ElseIf ((Item == B_VisualGlossinessOther) || (Item == B_VisualSpecularOther))
		Text = "$GW_Tip_PartOther"
	ElseIf (Item == B_ApplyGlobal)
		Text = "$GW_Tip_TypeGlobal"
	ElseIf (Item == B_ApplyPlayer)
		Text = "$GW_Tip_TypePlayer"
	ElseIf (Item == B_ApplyNPC)
		Text = "$GW_Tip_TypeNPC"
	ElseIf (Item == B_ApplyMale)
		Text = "$GW_Tip_TypeMale"
	ElseIf (Item == B_ApplyFemale)
		Text = "$GW_Tip_TypeFemale"
	ElseIf (Item == B_ApplyBeast)
		Text = "$GW_Tip_TypeBeast"
	ElseIf (Item == B_UpdateAll)
		Text = "$GW_Tip_UpdateAll"
	ElseIf (Item == B_UpdateActor)
		Text = "$GW_Tip_UpdateActor"
	ElseIf (Item == B_DebugActive)
		Text = "$GW_Tip_DebugActive"
	EndIf

	SetInfoText(Text)
EndEvent
