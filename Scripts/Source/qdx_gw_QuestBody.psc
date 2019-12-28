ScriptName qdx_gw_QuestBody extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

Keyword Property ActorTypeNPC Auto
Keyword Property IsBeastRace Auto

String Property KeyActors = ".Actors" AutoReadOnly Hidden
String Property KeyActorFormID = ".FormID" AutoReadOnly Hidden
String Property KeyActorName = ".Name" AutoReadOnly Hidden
String Property KeyActorGlossiness = ".Glossiness" AutoReadOnly Hidden
String Property KeyActorSpecular = ".Specular" AutoReadOnly Hidden

String Property KeyEvActorUpdate = "GW.Actor.Update" AutoReadOnly Hidden

Float Property DefaultActorGlossiness = 30.0 AutoReadOnly Hidden
Float Property DefaultActorSpecular = 5.0 AutoReadOnly Hidden

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Body                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

String Function ActorSet(Actor Who)
    ActorBase Base = Who.GetActorBase()

    String Path = ActorFind(Who)
    String Name = Who.GetDisplayName()
    Int FormID = Base.GetFormID()
    
    ActorSet_Name(Path, Name)
    ActorSet_FormID(Path, FormID)

    Return Path
EndFunction

Function ActorSet_Name(String Path, String Value)
    Main.Config.SetString(Path + KeyActorName, Value)

    Return
EndFunction

Function ActorSet_FormID(String Path, Int Value)
    Main.Config.SetInt(Path + KeyActorFormID, Value)

    Return
EndFunction

Function ActorSet_Glossiness(String Path, Float Value)
    Main.Config.SetFloat(Path + KeyActorGlossiness, Value)

    Return
EndFunction

Function ActorSet_Specular(String Path, Float Value)
    Main.Config.SetFloat(Path + KeyActorSpecular, Value)

    Return
EndFunction

Int Function ActorGet_FormID(String Path)
    Return Main.Config.GetInt(Path + KeyActorFormID)
EndFunction

Float Function ActorGet_Glossiness(String Path)
    Float Value = Main.Config.GetFloat(Path + KeyActorGlossiness)

    If (!Value)
        Value = Main.Config.GetFloat(".VisualGlossinessMin")
    EndIf

    Return Value
EndFunction

Float Function ActorGet_Specular(String Path)
    Float Value = Main.Config.GetFloat(Path + KeyActorSpecular)

    If (!Value)
        Value = Main.Config.GetFloat(".VisualSpecularMin")
    EndIf

    Return Value
EndFunction

String Function ActorFind(Actor Who)
    ActorBase Base = Who.GetActorBase()

    Int FormID = Base.GetFormID()
    Int Count = Main.Config.GetCount(KeyActors)
    Int Index = Count

    String Path = KeyActors + "[" + Count + "]"

    While (Index > 0)
        Index -= 1

        String TempPath = KeyActors + "[" + Index + "]"
        String TempFormID = ActorGet_FormID(TempPath)

        If (FormID == TempFormID)
            Index = 0
            Path = TempPath
        EndIf

    EndWhile 

    Return Path
EndFunction

Bool Function CanUpdate(Actor Who, Bool Female)
    {is the actor eligible to update}

    If !Who.HasKeyword(ActorTypeNPC)
        Return False
    EndIf

    Bool ApplyNPC = Main.Config.GetBool(".ApplyNPC")

    If (!ApplyNPC && (Who != Main.Player))
        Return False
    EndIf

    Bool ApplyMale = Main.Config.GetBool(".ApplyMale")
    Bool ApplyFemale = Main.Config.GetBool(".ApplyFemale")

    If ((!ApplyMale && !Female ) || (!ApplyFemale && Female))
        Return False
    EndIf

    Bool ApplyBeast = Main.Config.GetBool(".ApplyBeast")

    If (!ApplyBeast && Who.HasKeyword(IsBeastRace))
        Return False
    EndIf

    Return True
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Visual                       
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

String Function GetHead(Actor Who)
    {get the head part name}

    ActorBase Base = Who.GetActorBase()

    Int Index = Base.GetIndexOfHeadPartByType(1)
    HeadPart Part = Base.GetNthHeadPart(Index)
    ;String Name = Part.GetName()

    ; AddNodeOverride seems to expect an EditorID instead of a Name.
    ; Currently no way to get that, so we have to devise one using
	; the HDPT object itself and casting that to a string
	; Latest RaceMenu now has HDPT.GetFullName

    ; TEMPORARY!: Hacky solution to getting the EditorID
    String Object = Part
    Int First = StringUtil.Find(Object, "<")
    Int Last = StringUtil.Find(Object, "(") - 2
    Int Len = Last - First

    String Name = StringUtil.Substring(Object, First + 1, Len)
    ; END TEMPORARY!

    Return Name
EndFunction

Function UpdateVisual(Actor Who, Bool Female)
    {update actor visuals}

    String Head = self.GetHead(Who)
    String Path = self.ActorFind(Who)
    
    Float Glossiness = self.ActorGet_Glossiness(Path)
    Float Specular = self.ActorGet_Specular(Path)


    ; slots
    ; https://www.creationkit.com/index.php?title=Slot_Masks_-_Armor

    ; head
    If Main.Config.GetBool(".VisualGlossinessHead")
        AddVisual_Float(Who, Female, 2, Glossiness, Node = Head)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHead")
        AddVisual_Float(Who, Female, 3, Specular, Node = Head)
    EndIf
    
    ; body
    If Main.Config.GetBool(".VisualGlossinessBody")
        AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x4)
    EndIf

    If Main.Config.GetBool(".VisualSpecularBody")
        AddVisual_Float(Who, Female, 3, Specular, Slot = 0x4)
    EndIf

    ; hands
    If Main.Config.GetBool(".VisualGlossinessHands")
        AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x8)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHands")
        AddVisual_Float(Who, Female, 3, Specular, Slot = 0x8)
    EndIf

    ; feet
    If Main.Config.GetBool(".VisualGlossinessFeet")
        AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x80)
    EndIf

    If Main.Config.GetBool(".VisualSpecularFeet")
        AddVisual_Float(Who, Female, 3, Specular, Slot = 0x80)
    EndIf

    ; other
    If Main.Config.GetBool(".VisualGlossinessOther")
        AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x400000)
    EndIf

    If Main.Config.GetBool(".VisualSpecularOther")
        AddVisual_Float(Who, Female, 3, Specular, Slot = 0x400000)
    EndIf

    Return
EndFunction

Function AddVisual_Float(Actor Who, Bool Female, Int NifKey, Float Value, Int Slot = 0, String Node = "")
    {update slot/node overrides}

    Float Current

    If Slot
        Current = NiOverride.GetSkinPropertyFloat(Who, False, Slot, NifKey, -1)
    ElseIf Node
        Current = NiOverride.GetNodePropertyFloat(Who, False, Node, NifKey, -1)
    Else
        Return
    EndIf

    If (Current != Value)
        If Slot
            NiOverride.AddSkinOverrideFloat(Who, Female, False, Slot, NifKey, -1, Value, False)
            If (Who == Main.Player)
                NiOverride.AddSkinOverrideFloat(Who, Female, True, Slot, NifKey, -1, Value, False)
            EndIf
        Else
            NiOverride.AddNodeOverrideFloat(Who, Female, Node, NifKey, -1, Value, False)
        EndIf
    EndIf

    Return
EndFunction

Function RemoveVisual(Actor Who, Bool Female)
    {reset actor visuals}

    String Head = self.GetHead(Who)

    RemoveVisual_Override(Who, Female, 2, Node = Head)
    RemoveVisual_Override(Who, Female, 3, Node = Head)

    RemoveVisual_Override(Who, Female, 2, Slot = 0x4)
    RemoveVisual_Override(Who, Female, 3, Slot = 0x4)

    RemoveVisual_Override(Who, Female, 2, Slot = 0x8)
    RemoveVisual_Override(Who, Female, 3, Slot = 0x8)

    RemoveVisual_Override(Who, Female, 2, Slot = 0x80)
    RemoveVisual_Override(Who, Female, 3, Slot = 0x80)

    RemoveVisual_Override(Who, Female, 2, Slot = 0x400000)
    RemoveVisual_Override(Who, Female, 3, Slot = 0x400000)

    Return
EndFunction

Function RemoveVisual_Override(Actor Who, Bool Female, Int NifKey, Int Slot = 0, String Node = "")
    {remove slot/node overrides}

    If Slot
        NiOverride.RemoveSkinOverride(Who, Female, False, Slot, NifKey, -1)
        If (Who == Main.Player)
            NiOverride.RemoveSkinOverride(Who, Female, True, Slot, NifKey, -1)
        EndIf
    Else
        NiOverride.RemoveNodeOverride(Who, Female, Node, NifKey, -1)
    EndIf

    Return
EndFunction
