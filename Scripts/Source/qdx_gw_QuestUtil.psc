ScriptName qdx_gw_QuestUtil extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Print text
Function Print(String Msg)
	Debug.Notification("[GW] " + Msg)
EndFunction

; Print debug text
Function PrintDebug(String Msg)
	If (Main.Config.DebugMode)
		MiscUtil.PrintConsole("[GW] " + Msg)
		Debug.Trace("[GW] " + Msg)
	EndIf
EndFunction

; Display an error message to the user
Function PopupError(String Msg)
	String Output = ""

	Output += "Get Wet Error:\n"
	Output += Msg

	Debug.MessageBox(Output)
EndFunction