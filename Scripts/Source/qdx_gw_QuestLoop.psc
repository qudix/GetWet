ScriptName qdx_gw_QuestLoop Extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestMain Property Main Auto
qdx_gw_QuestConfig Property Config Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Loop
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Bool Updated = False

; Initialize update loop
Event OnInit()
    ; If controller isn't running, abort
	If (Main.IsStopped())
		Main.PrintDebug("Aborting Loop Init: Controller is not running.")
		Return
	EndIf

	Main.PrintDebug("Update Loop Enabled")
	OnUpdate()
EndEvent

; Timed update
Event OnUpdate()
	If (Updated)
		Updated = False
	Else
    	Update()
	EndIf

    ; Is it still running?
    If (Self.IsRunning())
        RegisterForSingleUpdate(Config.UpdateLoopFreq)
    EndIf
EndEvent

Function Update()
	Updated = True
	qdx_gw.Update(Main.IsRunning())
EndFunction
