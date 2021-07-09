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

Int S_ActStamina
Int S_ActMagicka
Int S_ActSprinting
Int S_ActRunning
Int S_ActSneaking
Int S_ActGalloping
Int S_ActWorking

Int S_WetnessMin
Int S_WetnessMax
Int S_WetnessRateMax
Int S_GlossinessMin
Int S_GlossinessMax
Int B_GlossinessHead
Int B_GlossinessBody
Int B_GlossinessHands
Int B_GlossinessFeet
Int B_GlossinessOther
Int S_SpecularMin
Int S_SpecularMax
Int B_SpecularHead
Int B_SpecularBody
Int B_SpecularHands
Int B_SpecularFeet
Int B_SpecularOther

Function ShowPageGeneral()
	SetTitleText("$GW_Title_General")
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	AddHeaderOption("$GW_Header_ModStatus")
	B_ModActive = AddToggleOption("$GW_Toggle_ModActive", Main.IsRunning())

	AddEmptyOption()
	AddEmptyOption()
	AddEmptyOption()
	AddHeaderOption("$GW_Header_Apply")
	B_ApplyGlobal = AddToggleOption("$GW_Toggle_TypeGlobal", Config.ApplyGlobal)
	B_ApplyPlayer = AddToggleOption("$GW_Toggle_TypePlayer", Config.ApplyPlayer)
	B_ApplyNPC = AddToggleOption("$GW_Toggle_TypeNPC", Config.ApplyNPC)
	B_ApplyMale = AddToggleOption("$GW_Toggle_TypeMale", Config.ApplyMale)
	B_ApplyFemale = AddToggleOption("$GW_Toggle_TypeFemale", Config.ApplyFemale)
	B_ApplyBeast = AddToggleOption("$GW_Toggle_TypeBeast", Config.ApplyBeast)
	B_UpdateAll = AddTextOption("", "$GW_Toggle_UpdateAll")

	AddEmptyOption()
	AddHeaderOption("$GW_Header_Activity")
	S_ActStamina = AddSliderOption("$GW_Slider_RangeStep", Config.ActStamina)
	S_ActMagicka = AddSliderOption("$GW_Slider_RangeStep", Config.ActMagicka)
	S_ActSprinting = AddSliderOption("$GW_Slider_RangeStep", Config.ActSprinting)
	S_ActRunning = AddSliderOption("$GW_Slider_RangeStep", Config.ActRunning)
	S_ActSneaking = AddSliderOption("$GW_Slider_RangeStep", Config.ActSneaking)
	S_ActGalloping = AddSliderOption("$GW_Slider_RangeStep", Config.ActGalloping)
	S_ActWorking = AddSliderOption("$GW_Slider_RangeStep", Config.ActWorking)

	SetCursorPosition(1)

	AddHeaderOption("$GW_Header_Wetness")
	S_WetnessMin = AddSliderOption("$GW_Slider_RangeMin", Config.WetnessMin)
	S_WetnessMax = AddSliderOption("$GW_Slider_RangeMax", Config.WetnessMax)
	S_WetnessRateMax = AddSliderOption("$GW_Slider_RateMax", Config.WetnessRateMax)

	AddEmptyOption()
	AddHeaderOption("$GW_Header_Glossiness")
	S_GlossinessMin = AddSliderOption("$GW_Slider_RangeMin", Config.GlossinessMin, "{0}")
	S_GlossinessMax = AddSliderOption("$GW_Slider_RangeMax", Config.GlossinessMax, "{0}")
	B_GlossinessHead = AddToggleOption("$GW_Toggle_PartHead", Config.GlossinessHead)
	B_GlossinessBody = AddToggleOption("$GW_Toggle_PartBody", Config.GlossinessBody)
	B_GlossinessHands = AddToggleOption("$GW_Toggle_PartHands", Config.GlossinessHands)
	B_GlossinessFeet = AddToggleOption("$GW_Toggle_PartFeet", Config.GlossinessFeet)
	B_GlossinessOther = AddToggleOption("$GW_Toggle_PartOther", Config.GlossinessOther)

	AddEmptyOption()
	AddHeaderOption("$GW_Header_Specular")
	S_SpecularMin = AddSliderOption("$GW_Slider_RangeMin", Config.SpecularMin, "{1}")
	S_SpecularMax = AddSliderOption("$GW_Slider_RangeMax", Config.SpecularMax, "{1}")
	B_SpecularHead = AddToggleOption("$GW_Toggle_PartHead", Config.SpecularHead)
	B_SpecularBody = AddToggleOption("$GW_Toggle_PartBody", Config.SpecularBody)
	B_SpecularHands = AddToggleOption("$GW_Toggle_PartHands", Config.SpecularHands)
	B_SpecularFeet = AddToggleOption("$GW_Toggle_PartFeet", Config.SpecularFeet)
	B_SpecularOther = AddToggleOption("$GW_Toggle_PartOther", Config.SpecularOther)
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Actor
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int M_ActorList
Int T_ActorSetPreset
Int S_ActorWetnessMin
Int S_ActorWetnessMax
Int S_ActorGlossinessMin
Int S_ActorGlossinessMax
Int S_ActorSpecularMin
Int S_ActorSpecularMax
Int B_ActorForceWetness
Int B_ActorForceGlossiness
Int B_ActorForceSpecular
Int B_UpdateActor

Actor[] Property ActorList Auto Hidden
String[] Property ActorNameList Auto Hidden

Actor ActorTarget
Int ActorTargetIndex
Bool ActorTargetPreset

Float Property ActorWetnessMin = 0.0 Auto Hidden
Float Property ActorWetnessMax = 0.0 Auto Hidden
Float Property ActorGlossinessMin = 0.0 Auto Hidden
Float Property ActorGlossinessMax = 0.0 Auto Hidden
Float Property ActorSpecularMin = 0.0 Auto Hidden
Float Property ActorSpecularMax = 0.0 Auto Hidden
Bool Property ActorForceWetness = False Auto Hidden
Bool Property ActorForceGlossiness = False Auto Hidden
Bool Property ActorForceSpecular = False Auto Hidden

Function GetActorData()
	qdx_gw.GetActorList()

	If (!ActorTarget && ActorList[0])
		ActorTarget = ActorList[0]
	EndIf

	If (ActorTarget)
		qdx_gw.UpdateActor(ActorTarget)
		ActorTargetPreset = qdx_gw.GetActorPreset(ActorTarget)
	EndIf
EndFunction

Function ShowPageActor()
	SetTitleText("$GW_Title_Actor")
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	GetActorData()
	If (ActorTarget && ActorTargetPreset)
		AddHeaderOption("$GW_Header_Wetness")
		S_ActorWetnessMin = AddSliderOption("$GW_Slider_RangeMin", ActorWetnessMin, "{1}")
		S_ActorWetnessMax = AddSliderOption("$GW_Slider_RangeMax", ActorWetnessMax, "{1}")
		B_ActorForceWetness = AddToggleOption("$GW_Toggle_Force", ActorForceWetness)
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Glossiness")
		S_ActorGlossinessMin = AddSliderOption("$GW_Slider_RangeMin", ActorGlossinessMin, "{1}")
		S_ActorGlossinessMax = AddSliderOption("$GW_Slider_RangeMax", ActorGlossinessMax, "{1}")
		B_ActorForceGlossiness = AddToggleOption("$GW_Toggle_Force", ActorForceGlossiness)
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Specular")
		S_ActorSpecularMin = AddSliderOption("$GW_Slider_RangeMin", ActorSpecularMin, "{1}")
		S_ActorSpecularMax = AddSliderOption("$GW_Slider_RangeMax", ActorSpecularMax, "{1}")
		B_ActorForceSpecular = AddToggleOption("$GW_Toggle_Force", ActorForceSpecular)
	Else
		AddHeaderOption("$GW_Header_Wetness")
		S_ActorWetnessMin = AddSliderOption("$GW_Slider_RangeMin", Config.WetnessMin, "{1}", OPTION_FLAG_DISABLED)
		S_ActorWetnessMax = AddSliderOption("$GW_Slider_RangeMax", Config.WetnessMax, "{1}", OPTION_FLAG_DISABLED)
		B_ActorForceWetness = AddToggleOption("$GW_Toggle_Force", False, OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Glossiness")
		S_ActorGlossinessMin = AddSliderOption("$GW_Slider_RangeMin", Config.GlossinessMin, "{1}", OPTION_FLAG_DISABLED)
		S_ActorGlossinessMax = AddSliderOption("$GW_Slider_RangeMax", Config.GlossinessMax, "{1}", OPTION_FLAG_DISABLED)
		B_ActorForceGlossiness = AddToggleOption("$GW_Toggle_Force", False, OPTION_FLAG_DISABLED)
		AddEmptyOption()
		AddHeaderOption("$GW_Header_Specular")
		S_ActorSpecularMin = AddSliderOption("$GW_Slider_RangeMin", Config.SpecularMin, "{1}", OPTION_FLAG_DISABLED)
		S_ActorSpecularMax = AddSliderOption("$GW_Slider_RangeMax", Config.SpecularMax, "{1}", OPTION_FLAG_DISABLED)
		B_ActorForceSpecular = AddToggleOption("$GW_Toggle_Force", False, OPTION_FLAG_DISABLED)
	EndIf

	SetCursorPosition(1)
	AddHeaderOption("$GW_Header_ActorList")
	If (ActorTarget && ActorList.Length > 0)
		M_ActorList = AddMenuOption("$GW_Menu_Target", ActorNameList[ActorTargetIndex])
	Else
		M_ActorList = AddMenuOption("$GW_Menu_Target", "[None]")
	EndIf

	If (ActorTarget)
		If (ActorTargetPreset)
			T_ActorSetPreset = AddTextOption("$GW_Text_ActorPreset", "Remove")
		Else
			T_ActorSetPreset = AddTextOption("$GW_Text_ActorPreset", "Add")
		EndIf
		B_UpdateActor = AddTextOption("", "$GW_Toggle_UpdateActor")
	Else
		T_ActorSetPreset = AddTextOption("$GW_Text_ActorPreset", "Unknown", OPTION_FLAG_DISABLED)
		B_UpdateActor = AddTextOption("", "$GW_Toggle_UpdateActor", OPTION_FLAG_DISABLED)
	EndIf
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Debug
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int B_MiscDebug

Function ShowPageMisc()
	SetTitleText("$GW_Title_Misc")
	SetCursorFillMode(TOP_TO_BOTTOM)

	SetCursorPosition(0)
	AddHeaderOption("$GW_Header_DependencyCheck")
	AddToggleOption("$GW_Dependency_SKSE", Main.CheckDep_SKSE(False), OPTION_FLAG_DISABLED)
	AddToggleOption("$GW_Dependency_SkyUI", Main.CheckDep_SkyUI(False), OPTION_FLAG_DISABLED)

	SetCursorPosition(1)
	AddHeaderOption("$GW_Header_DebugOptions")
	B_MiscDebug = AddToggleOption("$GW_Toggle_MiscDebug", Config.MiscDebug)
	AddEmptyOption()
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Function ResetTarget()
	ActorTarget = None
	ActorTargetIndex = 0
	ActorTargetPreset = False
EndFunction

Event OnGameReload()
	Parent.OnGameReload()
	qdx_gw.GetConfig()
EndEvent

Event OnConfigInit()
	Self.Pages = new String[3]
	Self.Pages[0] = "$GW_Page_General"
	Self.Pages[1] = "$GW_Page_Actor"
	Self.Pages[2] = "$GW_Page_Misc"

	ResetTarget()
EndEvent

Event OnConfigOpen()
	qdx_gw.GetConfig()
	Self.OnConfigInit()
EndEvent

Event OnConfigClose()
EndEvent

Event OnPageReset(String Page)
	If (Page == "")
		SoundDing.Play(Main.Player)
	EndIf

	qdx_gw.GetConfig()
	UnloadCustomContent()

	If (Page == "$GW_Page_General")
		SoundTickBig.Play(Main.Player)
		ShowPageGeneral()
	ElseIf (Page == "$GW_Page_Actor")
		SoundTickBig.Play(Main.Player)
		ResetTarget()
		ShowPageActor()
	ElseIf (Page == "$GW_Page_Misc")
		SoundTickBig.Play(Main.Player)
		ShowPageMisc()
	EndIf
EndEvent

Event OnOptionSelect(Int Item)
	SoundTickBig.Play(Main.Player)
	Bool Value = False
	If (Item == B_GlossinessHead)
		Value = !Config.GlossinessHead
		Config.GlossinessHead = Value
	ElseIf (Item == B_GlossinessBody)
		Value = !Config.GlossinessBody
		Config.GlossinessBody = Value
	ElseIf (Item == B_GlossinessHands)
		Value = !Config.GlossinessHands
		Config.GlossinessHands = Value
	ElseIf (Item == B_GlossinessFeet)
		Value = !Config.GlossinessFeet
		Config.GlossinessFeet = Value
	ElseIf (Item == B_GlossinessOther)
		Value = !Config.GlossinessOther
		Config.GlossinessOther = Value
	ElseIf (Item == B_SpecularHead)
		Value = !Config.SpecularHead
		Config.SpecularHead = Value
	ElseIf (Item == B_SpecularBody)
		Value = !Config.SpecularBody
		Config.SpecularBody = Value
	ElseIf (Item == B_SpecularHands)
		Value = !Config.SpecularHands
		Config.SpecularHands = Value
	ElseIf (Item == B_SpecularFeet)
		Value = !Config.SpecularFeet
		Config.SpecularFeet = Value
	ElseIf (Item == B_SpecularOther)
		Value = !Config.SpecularOther
		Config.SpecularOther = Value
	ElseIf (Item == B_ApplyGlobal)
		Value = !Config.ApplyGlobal
		Config.ApplyGlobal = Value
	ElseIf (Item == B_ApplyPlayer)
		Value = !Config.ApplyPlayer
		Config.ApplyPlayer = Value
	ElseIf (Item == B_ApplyNPC)
		Value = !Config.ApplyNPC
		Config.ApplyNPC = Value
	ElseIf (Item == B_ApplyMale)
		Value = !Config.ApplyMale
		Config.ApplyMale = Value
	ElseIf (Item == B_ApplyFemale)
		Value = !Config.ApplyFemale
		Config.ApplyFemale = Value
	ElseIf (Item == B_ApplyBeast)
		Value = !Config.ApplyBeast
		Config.ApplyBeast = Value
	ElseIf (Item == B_MiscDebug)
		Value = !Config.MiscDebug
		Config.MiscDebug = Value
	ElseIf (Item == B_ActorForceWetness)
		Value = !ActorForceWetness
		ActorForceWetness = Value
	ElseIf (Item == B_ActorForceGlossiness)
		Value = !ActorForceGlossiness
		ActorForceGlossiness = Value
	ElseIf (Item == B_ActorForceSpecular)
		Value = !ActorForceSpecular
		ActorForceSpecular = Value
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
	ElseIf (Item == T_ActorSetPreset)
		If (ActorTarget && ActorTargetPreset)
			qdx_gw.RemoveActorPreset(ActorTarget)
			Main.PrintDebug("Remove Preset")
		Else
			qdx_gw.AddActorPreset(ActorTarget)
			Main.PrintDebug("Add Preset")
		EndIf

		ForcePageReset()
		Return
	EndIf

	If (ActorTarget && ActorTargetPreset)
		qdx_gw.SetActorPreset(ActorTarget)
	EndIf

	qdx_gw.SetConfig()
	SetToggleOptionValue(Item, Value)
EndEvent

Event OnOptionSliderOpen(Int Item)
	SoundTickBig.Play(Main.Player)
	Float Val = 0.0
	Float Min = 0.0
	Float Max = 0.0

	Float Interval = 0.0
	Float WetnessStep = 0.2
	Float WetnessRateStep = 0.1
	Float GlossinessStep = 5.0
	Float SpecularStep = 0.5

	If (Item == S_WetnessMin)
		Val = Config.WetnessMin
		Min = 5.0
		Max = 20.0
		Interval = WetnessStep
	ElseIf (Item == S_WetnessMax)
		Val = Config.WetnessMax
		Min = 5.0
		Max = 20.0
		Interval = WetnessStep
	ElseIf (Item == S_WetnessRateMax)
		Val = Config.WetnessMax
		Min = 5.0
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActStamina)
		Val = Config.ActStamina
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActMagicka)
		Val = Config.ActMagicka
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActSprinting)
		Val = Config.ActSprinting
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActRunning)
		Val = Config.ActRunning
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActSneaking)
		Val = Config.ActSneaking
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActGalloping)
		Val = Config.ActGalloping
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_ActWorking)
		Val = Config.ActWorking
		Min = 0.2
		Max = 10.0
		Interval = WetnessRateStep
	ElseIf (Item == S_GlossinessMin)
		Val = Config.GlossinessMin
		Min = 5.0
		Max = 1000.0
		Interval = GlossinessStep
	ElseIf (Item == S_GlossinessMax)
		Val = Config.GlossinessMax
		Min = 5.0
		Max = 1000.0
		Interval = GlossinessStep
	ElseIf (Item == S_SpecularMin)
		Val = Config.SpecularMin
		Min = 0.5
		Max = 100.0
		Interval = SpecularStep
	ElseIf (Item == S_SpecularMax)
		Val = Config.SpecularMax
		Min = 0.5
		Max = 100.0
		Interval = SpecularStep
	ElseIf (Item == S_ActorWetnessMin)
		Val = ActorWetnessMin
		Min = 0.1
		Max = 10.0
		Interval = WetnessStep
	ElseIf (Item == S_ActorWetnessMax)
		Val = ActorWetnessMax
		Min = 0.1
		Max = 10.0
		Interval = WetnessStep
	ElseIf (Item == S_ActorGlossinessMin)
		Val = ActorGlossinessMin
		Min = 5.0
		Max = 1000.0
		Interval = GlossinessStep
	ElseIf (Item == S_ActorGlossinessMax)
		Val = ActorGlossinessMax
		Min = 5.0
		Max = 1000.0
		Interval = GlossinessStep
	ElseIf (Item == S_ActorSpecularMin)
		Val = ActorSpecularMin
		Min = 0.5
		Max = 100.0
		Interval = SpecularStep
	ElseIf (Item == S_ActorSpecularMax)
		Val = ActorSpecularMax
		Min = 0.5
		Max = 100.0
		Interval = SpecularStep
	EndIf

	SetSliderDialogStartValue(Val)
	SetSliderDialogRange(Min, Max)
	SetSliderDialogInterval(Interval)
EndEvent

Event OnOptionSliderAccept(Int Item, Float Val)
	SoundTickBig.Play(Main.Player)
	String Fmt = "{1}"

	If (Item == S_ActStamina)
		Config.ActStamina = Val
	ElseIf (Item == S_ActMagicka)
		Config.ActMagicka = Val
	ElseIf (Item == S_ActSprinting)
		Config.ActSprinting = Val
	ElseIf (Item == S_ActRunning)
		Config.ActRunning = Val
	ElseIf (Item == S_ActSneaking)
		Config.ActSneaking = Val
	ElseIf (Item == S_ActGalloping)
		Config.ActGalloping = Val
	ElseIf (Item == S_ActWorking)
		Config.ActWorking = Val
	ElseIf (Item == S_WetnessMax)
		Config.WetnessMax = Val
	ElseIf (Item == S_WetnessRateMax)
		Config.WetnessRateMax = Val
	ElseIf (Item == S_GlossinessMin)
		Config.GlossinessMin = Val
	ElseIf (Item == S_GlossinessMax)
		Config.GlossinessMax = Val
	ElseIf (Item == S_SpecularMin)
		Config.SpecularMin = Val
	ElseIf (Item == S_SpecularMax)
		Config.SpecularMax = Val
	ElseIf (Item == S_ActorWetnessMin)
		ActorWetnessMin = Val
	ElseIf (Item == S_ActorWetnessMax)
		ActorWetnessMax = Val
	ElseIf (Item == S_ActorGlossinessMin)
		ActorGlossinessMin = Val
	ElseIf (Item == S_ActorGlossinessMax)
		ActorGlossinessMax = Val
	ElseIf (Item == S_ActorSpecularMin)
		ActorSpecularMin = Val
	ElseIf (Item == S_ActorSpecularMax)
		ActorSpecularMax = Val
	EndIf

	If (ActorTarget && ActorTargetPreset)
		qdx_gw.SetActorPreset(ActorTarget)
	EndIf

	qdx_gw.SetConfig()
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
		If (ActorList[Selected])
			ActorTarget = ActorList[Selected]
			ActorTargetIndex = Selected
		Else
			ActorTarget = None
			ActorTargetIndex = 0
		EndIf
		SetMenuOptionValue(M_ActorList, ActorNameList[ActorTargetIndex])
		ForcePageReset()
	EndIf
EndEvent

Bool Function Equals(Int Value, Int First, Int Second, Int Third = -1)
	Return (Value == First) || (Value == Second) || (Value == Third)
EndFunction

Event OnOptionHighlight(Int Item)
	String Text = ""
	If (Item == B_ModActive)
		Text = "$GW_Tip_ModActive"
	ElseIf Equals(Item, S_GlossinessMin, S_SpecularMin)
		Text = "$GW_Tip_PartMin"
	ElseIf Equals(Item, S_WetnessMax, S_GlossinessMax, S_SpecularMax)
		Text = "$GW_Tip_PartMax"
	ElseIf Equals(Item, B_GlossinessHead, B_SpecularHead)
		Text = "$GW_Tip_PartHead"
	ElseIf Equals(Item, B_GlossinessBody, B_SpecularBody)
		Text = "$GW_Tip_PartBody"
	ElseIf Equals(Item, B_GlossinessHands, B_SpecularHands)
		Text = "$GW_Tip_PartHands"
	ElseIf Equals(Item, B_GlossinessFeet, B_SpecularFeet)
		Text = "$GW_Tip_PartFeet"
	ElseIf Equals(Item, B_GlossinessOther, B_SpecularOther)
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
	ElseIf (Item == B_MiscDebug)
		Text = "$GW_Tip_MiscDebug"
	EndIf

	SetInfoText(Text)
EndEvent
