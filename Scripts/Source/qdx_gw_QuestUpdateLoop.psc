ScriptName qdx_gw_QuestUpdateLoop extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

MagicEffect Property EffectWet Auto
Spell Property SpellWet Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Initialize update loop
Event OnInit()
    ; If controller isn't running, abort
	If (Main.IsStopped())
		Main.Util.PrintDebug("Aborting UpdateLoop Init: Controller is not running.")
		Return
    EndIf
    
    Main.Util.PrintDebug("Update Loop Enabled")

    self.ActorScan()
    self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))
EndEvent

; Timed update
Event OnUpdate()
    self.ActorScan()

    ; Is it still running?
    If (self.IsRunning())
        self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))
    EndIf
EndEvent

; Call update on real actors
Function ActorScan()
	Actor[] Whom = MiscUtil.ScanCellNPCs(Main.Player, Main.Config.GetFloat(".UpdateLoopRange"))

    Int Index = Whom.Length
    While (Index > 0)
    	Index -= 1

		Actor Who = Whom[Index]

        ; Check if the actor actually exists
        If (Who != None)
            ; Update actor
            self.ActorUpdate(Who)

            ; Delay operations between each actor
            Utility.Wait(Main.Config.GetFloat(".UpdateLoopDelay"))
        EndIf
    EndWhile
EndFunction

; Update eligible actors
Function ActorUpdate(Actor Who)
    ActorBase Base = Who.GetLeveledActorBase()

	Bool Female = Base.GetSex() As Bool

    ; Is this actor eligible?
    If Main.Body.CanUpdate(Who, Female)
        If !Who.HasMagicEffect(self.EffectWet)
            Who.AddSpell(self.SpellWet, False)
            ;SpellWet.Cast(self, Who)

            Return
        EndIf
    EndIf

    ; Send update event
    Int Ev = ModEvent.Create(Main.Body.KeyEvActorUpdate)
    ModEvent.PushForm(Ev, Who)
    ModEvent.Send(Ev)
EndFunction
