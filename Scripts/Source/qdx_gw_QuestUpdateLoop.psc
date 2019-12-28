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

Event OnInit()
    {do other stuff}

    ; if controller isn't running, abort
	If(Main.IsStopped())
		Main.Util.PrintDebug("Aborting UpdateLoop Init: Controller is not running.")
		Return
    EndIf
    
    Main.Util.PrintDebug("Update Loop Enabled")

    ; apply effect and register for more
    self.ActorScan()
    self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))

    Return
EndEvent

Event OnUpdate()
    {clock on the wall}

    self.ActorScan()

    ; is it still going?
    If (self.IsRunning())
        self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))
    EndIf

    Return
EndEvent

Function ActorScan()
    {apply effect to eligible actors}

    ; actors
    Actor[] Whom = MiscUtil.ScanCellNPCs(Main.Player, Main.Config.GetFloat(".UpdateLoopRange"))

    Int Index = Whom.Length
    While (Index > 0)
    Index -= 1

        Actor Who = Whom[Index]

        ; check if actor actually exists
        If (Who != None)
            ; update actor
            self.ActorUpdate(Who)

            ; delay operations between each actor
            Utility.Wait(Main.Config.GetFloat(".UpdateLoopDelay"))
        EndIf
         
    EndWhile

    Return
EndFunction

Function ActorUpdate(Actor Who)
    ActorBase Base = Who.GetLeveledActorBase()

    Bool Female = Base.GetSex() As Bool

    ; is this actor eligible?
    If Main.Body.CanUpdate(Who, Female)
        If !Who.HasMagicEffect(EffectWet)
            Who.AddSpell(SpellWet, False)
            ;SpellWet.Cast(self, Who)

            Return
        EndIf
    EndIf

    ; send update event
    Int Ev = ModEvent.Create(Main.Body.KeyEvActorUpdate)
    ModEvent.PushForm(Ev, Who)
    ModEvent.Send(Ev)

    Return
EndFunction
