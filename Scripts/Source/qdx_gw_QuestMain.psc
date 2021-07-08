ScriptName qdx_gw_QuestMain Extends Quest

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

qdx_gw_QuestConfig Property Config Auto

String Property KeyESP = "qdx-get-wet.esp" AutoReadOnly Hidden

; Static method for grabbing a quick handle to the api
qdx_gw_QuestMain Function Get() Global
	Return Game.GetFormFromFile(0x800, "qdx-get-wet.esp") As qdx_gw_QuestMain
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Main
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Do stuff
Event OnInit()
	; Reset the config quest
	ResetConfig()

	If (Self.IsStopped())
		PrintDebug("Startup Aborted: Main Quest is stopped.")
		Return
	EndIf

	; Check dependencies
	If (!CheckDep(True))
		Self.Reset()
		Self.Stop()
		Return
	EndIf
EndEvent

; Reset the config menu library
Function ResetConfig()
	Config.Reset()
	Config.Stop()
	Config.Start()
	qdx_gw.GetConfig()
EndFunction

; Reset the entire mod
Function ResetMod()
	Self.Reset()
	Self.Stop()
	Self.Start()
EndFunction

; Make sure we have everything
Bool Function CheckDep(Bool Popup)
	Bool Result = True

	If (!CheckDep_SKSE(Popup))
		Result = False
	EndIf

	If (!CheckDep_SkyUI(Popup))
		Result = False
	EndIf

	Return Result
EndFunction

; Is SKSE available
Bool Function CheckDep_SKSE(Bool Popup)
	If (SKSE.GetScriptVersionRelease() < 56)
		If (Popup)
			PopupError("You need to update your SKSE to 2.0.7 or newer.")
		EndIf

		Return False
	EndIf

	Return True
EndFunction

; Is SkyUI available
Bool Function CheckDep_SkyUI(Bool Popup)
	If (!Game.IsPluginInstalled("SkyUI_SE.esp"))
		If (Popup)
			PopupError("SkyUI SE 5.2 or newer must be installed.")
		EndIf

		Return False
	EndIf

	Return True
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Util
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Print text
Function Print(String Msg)
	Debug.Notification("GW: " + Msg)
EndFunction

; Print debug text
Function PrintDebug(String Msg)
	If (Config.MiscDebug)
		qdx_gw.PrintConsole("GW: " + Msg)
		Debug.Trace("GW: " + Msg)
	EndIf
EndFunction

; Display an error message to the user
Function PopupError(String Msg)
	String Output = ""
	Output += "Get Wet Error:\n"
	Output += Msg
	Debug.MessageBox(Output)
EndFunction
