ScriptName qdx_gw_QuestUtil extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Function Print(String Msg)
    {print text}

	Debug.Notification("[GW] " + Msg)
	Return
EndFunction

Function PrintDebug(String Msg)
    {print debug text}

	If(Main.Config.DebugMode)
		MiscUtil.PrintConsole("[GW] " + Msg)
		Debug.Trace("[GW] " + Msg)
	EndIf

	Return
EndFunction

Function PopupError(String Msg)
    {display an error message to the user}

	String Output = ""

	Output += "Get Wet Error:\n"
	Output += Msg

	Debug.MessageBox(Output)
	Return
EndFunction