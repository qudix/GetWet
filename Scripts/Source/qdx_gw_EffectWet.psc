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

Event OnEffectStart(Actor Who, Actor From)
    {effect started}

    self.Target = Who

    self.RegisterForModEvent(Main.Body.KeyEvActorUpdate, "OnModEvent")

    self.ActorUpdate()
    
    Return
EndEvent

Event OnModEvent(Form What)
    {mod event occured}

    If (What != self.Target)
        Return
    EndIf

    self.ActorUpdate()

    Return
EndEvent

Event OnEffectFinish(Actor Who, Actor From)
    {effect finished}
EndEvent

Event OnObjectEquipped(Form Base, ObjectReference Reference)
    {object was equipped}

    self.ObjectChanged(Base, Reference)

    Return
EndEvent

Event OnObjectUnequipped(Form Base, ObjectReference Reference)
    {object was unequipped}

    self.ObjectChanged(Base, Reference)

    Return
EndEvent

Function ObjectChanged(Form Base, ObjectReference Reference)
    {object changed in some way}

    ; actor changed armor/clothing
    If (Base As Armor)
        self.ActorUpdate()
    EndIf

    Return
EndFunction

Function ActorUpdate()
    {update actor}

    If (IsDispeling || (self.Target == None))
        Return
    EndIf

    ActorBase Base = self.Target.GetActorBase()
    Bool Female = Base.GetSex() As Bool

    ; check for updates
    If Main.Body.CanUpdate(self.Target, Female)
        Main.Body.UpdateVisual(self.Target, Female)
    Else
        self.IsDispeling = True
        Main.Util.PrintDebug("Stopping")
        Main.Body.RemoveVisual(self.Target, Female)
        self.Dispel()
    EndIf

    Return
EndFunction
