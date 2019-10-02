ScriptName qdx_gw_QuestUpdateLoop extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

MagicEffect Property EffectWet Auto
Spell Property SpellWet Auto

Keyword Property ActorTypeNPC Auto

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Event OnInit()
    {do other stuff}

	If(Main.IsStopped())
		Main.Util.PrintDebug("Aborting UpdateLoop Init: Controller is not running.")
		Return
    EndIf
    
    Main.Util.PrintDebug("Update Loop Enabled")

    self.Apply()

    self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))
    Return
EndEvent

Event OnUpdate()
    {clock on the wall}

    self.Apply()

    ; is it still going?
    If (self.IsRunning())
        self.RegisterForSingleUpdate(Main.Config.GetFloat(".UpdateLoopFreq"))
    EndIf

    Return
EndEvent

Function Apply()

    Bool ApplyNPC = Main.Config.GetBool(".ApplyNPC")
    Bool ApplyFemale = Main.Config.GetBool(".ApplyFemale")
    Bool ApplyMale = Main.Config.GetBool(".ApplyMale")

    ; actors
    Actor[] Whom = MiscUtil.ScanCellNPCs(Main.Player, Main.Config.GetFloat(".UpdateLoopRange"))

    Int Number = Whom.Length
    While (Number > 0)
        Number -= 1

        Actor Who = Whom[Number]

        If (Who != None)
            ActorBase Base = Who.GetActorBase()
            Bool Female = Base.GetSex() As Bool

            If (ApplyNPC || (Who == Main.Player))
                If ((!Female && ApplyMale) || (Female && ApplyFemale))
                    Main.Body.UpdateVisual(Who, Female)
                EndIf
            EndIf
    
            Utility.Wait(Main.Config.GetFloat(".UpdateLoopDelay"))
        EndIf
    EndWhile

    Return
EndFunction
