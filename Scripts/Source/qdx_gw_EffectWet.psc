ScriptName qdx_gw_EffectWet extends ActiveMagicEffect

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

Actor Property Target Auto Hidden

Bool Property IsDispeling = False Auto Hidden

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Effect started
Event OnEffectStart(Actor Who, Actor From)
    self.Target = Who

    self.RegisterForModEvent(Main.Body.KeyEvActorUpdate, "OnModEvent")

    self.ActorUpdate()
EndEvent

; Mod event occured
Event OnModEvent(Form What)
    If (What != self.Target)
        Return
    EndIf

    self.ActorUpdate()
EndEvent

; Effect finished
Event OnEffectFinish(Actor Who, Actor From)
EndEvent

; Object was equipped
Event OnObjectEquipped(Form Base, ObjectReference Reference)
    self.ObjectChanged(Base, Reference)
EndEvent

; Object was unequipped
Event OnObjectUnequipped(Form Base, ObjectReference Reference)
    self.ObjectChanged(Base, Reference)
EndEvent

; Object changed in some way
Function ObjectChanged(Form Base, ObjectReference Reference)
    ; Actor changed armor/clothing
    If (Base As Armor)
        self.ActorUpdate()
    EndIf
EndFunction

; Update actor
Function ActorUpdate()
    If (self.IsDispeling || (self.Target == None))
        Return
    EndIf

    ActorBase Base = self.Target.GetActorBase()
    Bool Female = Base.GetSex() As Bool

    ; Check for updates
    If Main.Body.CanUpdate(self.Target, Female)
        Main.Body.UpdateVisual(self.Target, Female)
    Else
        self.IsDispeling = True
        Main.Util.PrintDebug("Stopping")
        Main.Body.RemoveVisual(self.Target, Female)
        self.Dispel()
    EndIf
EndFunction
