ScriptName qdx_gw_QuestMCM extends SKI_ConfigBase

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                     Version                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int Function GetVersion()
    {report a version number}
    
    Return 1
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Event OnGameReload()
    {the game has "loaded"}

    parent.OnGameReload()

    Main.Config.LoadFiles()

    Return
EndEvent

String PageCurrentKey

Event OnConfigInit()
    {setup pages}

    self.Pages = new String[4]

    ; enable/disable
    self.Pages[0] = "$GW_Menu_General"

    ; visuals
    self.Pages[1] = "$GW_Menu_Visual"

    ; actors
    self.Pages[2] = "$GW_Menu_Actor"

    ; debug stuff
    self.Pages[3] = "$GW_Menu_Debug"
    
    Return
EndEvent

Event OnConfigOpen()
    {menu is opening}

    self.OnConfigInit()

    Return
EndEvent

Event OnConfigClose()
    {menu is closing}

    Return
EndEvent

Event OnPageReset(String Page)
    {tab was selected}

    self.UnloadCustomContent()

    PageCurrentKey = Page

    If (Page == "$GW_Menu_General")
        self.ShowPageGeneral()
    ElseIf (Page == "$GW_Menu_Visual")
        self.ShowPageVisual()
    ElseIf (Page == "$GW_Menu_Actor")
        self.ShowPageActor()
    ElseIf (Page == "$GW_Menu_Debug")
        self.ShowPageDebug()
    EndIf

    Return
EndEvent

Event OnOptionSelect(Int Item)
    Bool Value = False

    If (Item == ItemVisualGlossinessHead)
        Value = !Main.Config.GetBool(".VisualGlossinessHead")
        Main.Config.SetBool(".VisualGlossinessHead", Value)

    ElseIf (Item == ItemVisualGlossinessBody)
        Value = !Main.Config.GetBool(".VisualGlossinessBody")
        Main.Config.SetBool(".VisualGlossinessBody", Value)

    ElseIf (Item == ItemVisualGlossinessHands)
        Value = !Main.Config.GetBool(".VisualGlossinessHands")
        Main.Config.SetBool(".VisualGlossinessHands", Value)

    ElseIf (Item == ItemVisualGlossinessFeet)
        Value = !Main.Config.GetBool(".VisualGlossinessFeet")
        Main.Config.SetBool(".VisualGlossinessFeet", Value)

    ElseIf (Item == ItemVisualSpecularHead)
        Value = !Main.Config.GetBool(".VisualSpecularHead")
        Main.Config.SetBool(".VisualSpecularHead", Value)
    
    ElseIf (Item == ItemVisualSpecularBody)
        Value = !Main.Config.GetBool(".VisualSpecularBody")
        Main.Config.SetBool(".VisualSpecularBody", Value)

    ElseIf (Item == ItemVisualSpecularHands)
        Value = !Main.Config.GetBool(".VisualSpecularHands")
        Main.Config.SetBool(".VisualSpecularHands", Value)

    ElseIf (Item == ItemVisualSpecularFeet)
        Value = !Main.Config.GetBool(".VisualSpecularFeet")
        Main.Config.SetBool(".VisualSpecularFeet", Value)

    ElseIf (Item == ItemApplyNPC)
        Value = !Main.Config.GetBool(".ApplyNPC")
        Main.Config.SetBool(".ApplyNPC", Value)

    ElseIf (Item == ItemApplyMale)
        Value = !Main.Config.GetBool(".ApplyMale")
        Main.Config.SetBool(".ApplyMale", Value)

    ElseIf (Item == ItemApplyFemale)
        Value = !Main.Config.GetBool(".ApplyFemale")
        Main.Config.SetBool(".ApplyFemale", Value)

    ElseIf (Item == ItemDebug)
        Value = !Main.Config.DebugMode
        Main.Config.DebugMode = Value

    ElseIf (Item == ItemModStatus)
        If Main.IsRunning()
            Main.Reset()
            Main.Stop()
            Main.Util.Print("Shutting down.")
        Else
            Value = True
            Main.Start()
        EndIf
        
    EndIf

    self.SetToggleOptionValue(Item, Value)
    Return
EndEvent

Event OnOptionSliderOpen(Int Item)
    Float Val = 0.0
    Float Min = 0.0
    Float Max = 0.0
    Float Interval = 0.0

    If (Item == ItemUpdateLoopFreq)
        Val = Main.Config.GetFloat(".UpdateLoopFreq")
        Min = 10.0
        Max = 300.0
        Interval = 1
    ElseIf (Item == ItemUpdateLoopDelay)
        Val = Main.Config.GetFloat(".UpdateLoopDelay")
        Min = 0.05
        Max = 2.0
        Interval = 0.05
    ElseIf (Item == ItemUpdateLoopRange)
        Val = Main.Config.GetFloat(".UpdateLoopRange")
        Min = 100
        Max = 10000
        Interval = 100
    ElseIf (Item == ItemVisualGlossinessMin)
        Val = Main.Config.GetFloat(".VisualGlossinessMin")
        Min = 5.0
        Max = 1000.0
        Interval = 5.0
    ElseIf (Item == ItemVisualGlossinessMax)
        Val = Main.Config.GetFloat(".VisualGlossinessMax")
        Min = 5.0
        Max = 1000.0
        Interval = 5.0
    ElseIf (Item == ItemVisualSpecularMin)
        Val = Main.Config.GetFloat(".VisualSpecularMin")
        Min = 0.2
        Max = 100.0
        Interval = 0.2
    ElseIf (Item == ItemVisualSpecularMax)
        Val = Main.Config.GetFloat(".VisualSpecularMax")
        Min = 0.2
        Max = 100.0
        Interval = 0.2
    EndIf

    self.SetSliderDialogStartValue(Val)
    self.SetSliderDialogRange(Min, Max)
    self.SetSliderDialogInterval(Interval)

    Return
EndEvent

Event OnOptionSliderAccept(Int Item, Float Val)
    String Fmt = "{0}"

    If (Item == ItemUpdateLoopFreq)
        Fmt = "{2} sec"
        Main.Config.SetFloat(".UpdateLoopFreq", Val)
    ElseIf (Item == ItemUpdateLoopDelay)
        Fmt = "{2} sec"
        Main.Config.SetFloat(".UpdateLoopDelay", Val)
    ElseIf (Item == ItemUpdateLoopRange)
        Fmt = "{2} m"
        Main.Config.SetFloat(".UpdateLoopRange", Val)
    ElseIf (Item == ItemVisualGlossinessMin)
        Fmt = "{2}"
        Main.Config.SetFloat(".VisualGlossinessMin", Val)
    ElseIf (Item == ItemVisualGlossinessMax)
        Fmt = "{2}"
        Main.Config.SetFloat(".VisualGlossinessMax", Val)
    ElseIf (Item == ItemVisualSpecularMin)
        Fmt = "{2}"
        Main.Config.SetFloat(".VisualSpecularMin", Val)
    ElseIf (Item == ItemVisualSpecularMax)
        Fmt = "{2}"
        Main.Config.SetFloat(".VisualSpecularMax", Val)
    EndIf

    self.SetSliderOptionValue(Item, Val, Fmt)

    Return
EndEvent

Event OnOptionMenuOpen(Int Item)

EndEvent

Event OnOptionMenuAccept(Int Item, Int Selected)

EndEvent

Event OnOptionInputOpen(Int Opt)

EndEvent

Event OnOptionInputAccept(Int Opt, String Txt)

EndEvent

Event OnOptionHighlight(Int Item)
	
	String Txt = "$GW_Mod_TitleFull"

	If (Item == ItemModStatus)
		Txt = "$GW_MenuTip_IsModActive"
	ElseIf (Item == ItemUpdateLoopFreq)
        Txt = "$GW_MenuTip_UpdateLoopFreq"	
    ElseIf (Item == ItemUpdateLoopDelay)
        Txt = "$GW_MenuTip_UpdateLoopDelay"
    ElseIf (Item == ItemUpdateLoopRange)
        Txt = "$GW_MenuTip_UpdateLoopRange"
    ElseIf (Item == ItemVisualGlossinessHead)
        Txt = "$GW_MenuTip_PartHead"
    ElseIf (Item == ItemVisualGlossinessBody)
        Txt = "$GW_MenuTip_PartBody"    
    ElseIf (Item == ItemVisualGlossinessHands)
        Txt = "$GW_MenuTip_PartHands"
    ElseIf (Item == ItemVisualGlossinessFeet)
        Txt = "$GW_MenuTip_PartFeet"
    ElseIf (Item == ItemApplyNPC)
        Txt = "$GW_MenuTip_ApplyNPC"
    ElseIf (Item == ItemApplyMale)
        Txt = "$GW_MenuTip_ApplyMale"
    ElseIf (Item == ItemApplyFemale)
		Txt = "$GW_MenuTip_ApplyFemale"
	ElseIf (Item == ItemDebug)
		Txt = "$GW_MenuTip_Debug"
	EndIf

	self.SetInfoText(Txt)
	Return
EndEvent

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                  Page: General                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int ItemModStatus

Int ItemUpdateLoopFreq
Int ItemUpdateLoopDelay
Int ItemUpdateLoopRange

Function ShowPageGeneral()
    self.SetTitleText("$GW_MenuTitle_General")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
    self.SetCursorPosition(0)
    
    self.AddHeaderOption("$GW_MenuOpt_ModStatus")
    ItemModStatus = self.AddToggleOption("$GW_MenuOpt_IsModActive", Main.IsRunning())
    self.AddEmptyOption()
    self.AddEmptyOption()
	self.AddEmptyOption()
    
    self.AddHeaderOption("$GW_MenuOpt_Performance")
    ItemUpdateLoopFreq = AddSliderOption("$GW_MenuOpt_UpdateLoopFreq", Main.Config.GetFloat(".UpdateLoopFreq"), "{1} sec")
    ItemUpdateLoopDelay = AddSliderOption("$GW_MenuOpt_UpdateLoopDelay", Main.Config.GetFloat(".UpdateLoopDelay"), "{2} sec")
    ItemUpdateLoopRange = AddSliderOption("$GW_MenuOpt_UpdateLoopRange", Main.Config.GetFloat(".UpdateLoopRange"), "{2} m")
	self.AddEmptyOption()
    self.AddEmptyOption()
	self.AddEmptyOption()
    
    Return
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Visual                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int ItemVisualGlossinessMin
Int ItemVisualGlossinessMax
Int ItemVisualGlossinessHead
Int ItemVisualGlossinessBody
Int ItemVisualGlossinessHands
Int ItemVisualGlossinessFeet

Int ItemVisualSpecularMin
Int ItemVisualSpecularMax
Int ItemVisualSpecularHead
Int ItemVisualSpecularBody
Int ItemVisualSpecularHands
Int ItemVisualSpecularFeet

Int ItemApplyNPC
Int ItemApplyMale
Int ItemApplyFemale

Function ShowPageVisual()
    self.SetTitleText("$GW_MenuTitle_Visual")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
    self.SetCursorPosition(0)

    self.AddHeaderOption("$GW_MenuOpt_VisualGlossiness")
    ItemVisualGlossinessMin = AddSliderOption("$GW_MenuOpt_RangeMin", Main.Config.GetFloat(".VisualGlossinessMin"), "{1}")
    ItemVisualGlossinessMax = AddSliderOption("$GW_MenuOpt_RangeMax", Main.Config.GetFloat(".VisualGlossinessMax"), "{1}")
    ItemVisualGlossinessHead = AddToggleOption("$GW_MenuOpt_PartHead", Main.Config.GetBool(".VisualGlossinessHead"))
    ItemVisualGlossinessBody = AddToggleOption("$GW_MenuOpt_PartBody", Main.Config.GetBool(".VisualGlossinessBody"))
    ItemVisualGlossinessHands = AddToggleOption("$GW_MenuOpt_PartHands", Main.Config.GetBool(".VisualGlossinessHands"))
    ItemVisualGlossinessFeet = AddToggleOption("$GW_MenuOpt_PartFeet", Main.Config.GetBool(".VisualGlossinessFeet"))
    self.AddEmptyOption()

    self.AddHeaderOption("$GW_MenuOpt_VisualSpecular")
    ItemVisualSpecularMin = AddSliderOption("$GW_MenuOpt_RangeMin", Main.Config.GetFloat(".VisualSpecularMin"), "{1}")
    ItemVisualSpecularMax = AddSliderOption("$GW_MenuOpt_RangeMax", Main.Config.GetFloat(".VisualSpecularMax"), "{1}")
    ItemVisualSpecularHead = AddToggleOption("$GW_MenuOpt_PartHead", Main.Config.GetBool(".VisualSpecularHead"))
    ItemVisualSpecularBody = AddToggleOption("$GW_MenuOpt_PartBody", Main.Config.GetBool(".VisualSpecularBody"))
    ItemVisualSpecularHands = AddToggleOption("$GW_MenuOpt_PartHands", Main.Config.GetBool(".VisualSpecularHands"))
    ItemVisualSpecularFeet = AddToggleOption("$GW_MenuOpt_PartFeet", Main.Config.GetBool(".VisualSpecularFeet"))
    self.AddEmptyOption()

    self.SetCursorPosition(1)

    self.AddHeaderOption("$GW_MenuOpt_Apply")
    ItemApplyNPC = AddToggleOption("$GW_MenuOpt_TypeNPC", Main.Config.GetBool(".ApplyNPC"))
    ItemApplyMale = AddToggleOption("$GW_MenuOpt_TypeMale", Main.Config.GetBool(".ApplyMale"))
    ItemApplyFemale = AddToggleOption("$GW_MenuOpt_TypeFemale", Main.Config.GetBool(".ApplyFemale"))
    self.AddEmptyOption()

    Return
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Actor                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Function ShowPageActor()
    self.SetTitleText("$GW_MenuTitle_Actor")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
    self.SetCursorPosition(0)

    Return
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                   Page: Debug                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int ItemDebug

Function ShowPageDebug()
    self.SetTitleText("$GW_MenuTitle_Debug")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
    self.SetCursorPosition(0)

    self.SetCursorPosition(1)
    self.AddHeaderOption("$GW_MenuOpt_Debugging")
	ItemDebug = AddToggleOption("$GW_MenuOpt_Debug", Main.Config.DebugMode)
	self.AddEmptyOption()

    Return
EndFunction