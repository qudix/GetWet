ScriptName qdx_gw_QuestController extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                     Version                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Report a version number
Int Function GetVersion() Global
    Return 1
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Actor Property Player Auto

; Libraries
qdx_gw_QuestConfig Property Config Auto
qdx_gw_QuestUpdateLoop Property Loop Auto
qdx_gw_QuestUtil Property Util Auto
qdx_gw_QuestBody Property Body Auto

; Main
String Property KeyESP = "qdx-get-wet.esp" AutoReadOnly Hidden

; Static method for grabbing a quick handle to the api
qdx_gw_QuestController Function Get() Global
    Return Game.GetFormFromFile(0x800, "qdx-get-wet.esp") As qdx_gw_QuestController
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Do stuff
Event OnInit()
    Int Wait = 0

    If (self.IsStopped())
        self.Util.PrintDebug("Startup Aborted: Controller is stopped.")
        Return
    EndIf

    ; Check dependencies
    If (!self.CheckForDeps(True))
        self.Reset()
        self.Stop()
        Return
    EndIf

    ; Start the config menu
    self.ResetConfig()

    Wait = 0
    While (!self.Config.IsRunning() && Wait < 10)
        Wait += 1
        self.Util.PrintDebug("Waiting for qdx_gw_QuestConfig to start (" + Wait + ")...")
        Utility.Wait(1.0)
    EndWhile

    If (!self.Config.IsRunning())
		self.Util.PrintDebug("Startup Aborted: Config did not reset.")
		Return
    EndIf

    ; Start the background processor
    self.ResetLoop()

    Wait = 0
    While (!self.Loop.IsRunning() && Wait < 10)
        Wait += 1
        self.Util.PrintDebug("Waiting for qdx_gw_QuestUpdateLoop to start (" + Wait + ")...")
        Utility.Wait(1.0)
    EndWhile

    If (!self.Loop.IsRunning())
		self.Util.PrintDebug("Startup Aborted: Loop did not reset.")
		Return
    EndIf
EndEvent

; Reset the config menu library
Function ResetConfig()
    self.Config.Reset()
    self.Config.Stop()
    self.Config.Start()
EndFunction

; Reset the background processor library
Function ResetLoop()
    self.Loop.Reset()
    self.Loop.Stop()
    self.Loop.Start()
EndFunction

; Reset the entire mod
Function ResetMod()
    self.Reset()
    self.Stop()
    self.Start()
EndFunction

; Make sure we have everything
Bool Function CheckForDeps(Bool Popup)
    Bool Result = True

    If !self.CheckForDeps_SKSE(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_SkyUI(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_RaceMenu(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_PapyrusUtil(Popup)
        Result = False
    EndIf

    Return Result
EndFunction

; Is SKSE available
Bool Function CheckForDeps_SKSE(Bool Popup)
    If (SKSE.GetScriptVersionRelease() < 56)
        If Popup
            self.Util.PopupError("You need to update your SKSE to 2.0.7 or newer.")
        EndIf

        Return False
    EndIf

    Return True
EndFunction

; Is SkyUI available
Bool Function CheckForDeps_SkyUI(Bool Popup)
    If (!Game.IsPluginInstalled("SkyUI_SE.esp"))
        If Popup
            self.Util.PopupError("SkyUI SE 5.2 or newer must be installed.")
        EndIf

        Return False
    EndIf

    Return True
EndFunction

; Is RaceMenu available
Bool Function CheckForDeps_RaceMenu(Bool Popup)
    Bool Result = True

    If (!Game.IsPluginInstalled("RaceMenu.esp"))
        If Popup
            self.Util.PopupError("RaceMenu SE 0.2.4 or newer must be installed.")
        EndIf

        Result = False
    EndIf

    If (NiOverride.GetScriptVersion() < 6)
        If Popup
            self.Util.PopupError("NiOverride is out of date. Install Racemenu SE 0.2.4 or newer and make sure nothing has overwritten it with older versions.")
        EndIf

        Result = False
    EndIf

    Return Result
EndFunction

; Is PapyrusUtil available
Bool Function CheckForDeps_PapyrusUtil(Bool Popup)
    If (PapyrusUtil.GetScriptVersion() < 34)
        If Popup
            self.Util.PopupError("Your PapyrusUtil is out of date. It is likely some other mod overwrote the version that came in SexLab.")
		EndIf
		
        Return False
	EndIf
	
    Return True
EndFunction