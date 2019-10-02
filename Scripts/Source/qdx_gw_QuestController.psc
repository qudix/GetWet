ScriptName qdx_gw_QuestController extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                     Version                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int Function GetVersion() Global
    {report a version number}
    
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

qdx_gw_QuestController Function Get() Global
    {static method for grabbing a quick handle to the api}
    
    Return Game.GetFormFromFile(0x800, "qdx-get-wet.esp") As qdx_gw_QuestController
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Event OnInit()
    {do stuff}

    Int Wait = 0

    If (self.IsStopped())
        self.Util.PrintDebug("Startup Aborted: Controller is stopped.")
        Return
    EndIf

    ; check dependencies
    If (!self.CheckForDeps(True))
        self.Reset()
        self.Stop()
        Return
    EndIf

    ; start the config menu
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

    ; start the background processor
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

    Return
EndEvent

Function ResetConfig()
    {reset the config menu library}
    
    self.Config.Reset()
    self.Config.Stop()
    self.Config.Start()

    Return
EndFunction

Function ResetLoop()
    {reset the background processor library}
    
    self.Loop.Reset()
    self.Loop.Stop()
    self.Loop.Start()

    Return
EndFunction

Function ResetMod()
    {reset the entire mod}
    
    self.Reset()
    self.Stop()
    self.Start()

    Return
EndFunction

Bool Function CheckForDeps(Bool Popup)
    {make sure we have everything}

    Bool Result = True

    If !self.CheckForDeps_SKSE(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_SkyUI(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_PapyrusUtil(Popup)
        Result = False
    EndIf

    If !self.CheckForDeps_RaceMenu(Popup)
        Result = False
    EndIf

    Return Result
EndFunction

Bool Function CheckForDeps_SKSE(Bool Popup)
    {is SKSE available}

    If (SKSE.GetScriptVersionRelease() < 56)
        If Popup
            self.Util.PopupError("You need to update your SKSE to 2.0.7 or newer.")
        EndIf

        Return False
    EndIf

    Return True
EndFunction

Bool Function CheckForDeps_SkyUI(Bool Popup)
    {is SkyUI available}

    If (!Game.IsPluginInstalled("SkyUI_SE.esp"))
        If Popup
            self.Util.PopupError("SkyUI SE 5.2 or newer must be installed.")
        EndIf

        Return False
    EndIf

    Return True
EndFunction

Bool Function CheckForDeps_PapyrusUtil(Bool Popup)
    {is PapyrusUtil available}

    If (PapyrusUtil.GetScriptVersion() < 34)
        If Popup
            self.Util.PopupError("Your PapyrusUtil is out of date. It is likely some other mod overwrote the version that came in SexLab.")
        EndIf

        Return False
    EndIf

    Return True
EndFunction

Bool Function CheckForDeps_RaceMenu(Bool Popup)
    {is RaceMenu available}
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