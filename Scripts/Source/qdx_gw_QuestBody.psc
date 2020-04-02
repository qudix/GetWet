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
    
    self.ActorSet_Name(Path, Name)
    self.ActorSet_FormID(Path, FormID)

    Return Path
EndFunction

Function ActorSet_Name(String Path, String Value)
    Main.Config.SetString(Path + KeyActorName, Value)
EndFunction

Function ActorSet_FormID(String Path, Int Value)
    Main.Config.SetInt(Path + KeyActorFormID, Value)
EndFunction

Function ActorSet_Glossiness(String Path, Float Value)
    Main.Config.SetFloat(Path + KeyActorGlossiness, Value)
EndFunction

Function ActorSet_Specular(String Path, Float Value)
	Main.Config.SetFloat(Path + KeyActorSpecular, Value)
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
    Int Count = Main.Config.GetCount(self.KeyActors)

    String Path = self.KeyActors + "[" + Count + "]"

	Int Index = Count
    While (Index > 0)
        Index -= 1

        String TempPath = self.KeyActors + "[" + Index + "]"
        String TempFormID = self.ActorGet_FormID(TempPath)

        If (FormID == TempFormID)
            Index = 0
            Path = TempPath
        EndIf

    EndWhile 

    Return Path
EndFunction

; Is the actor eligible to update
Bool Function CanUpdate(Actor Who, Bool Female)
    
	If (!Who.Is3DLoaded())
		Return False
	EndIf

    If (!Who.HasKeyword(self.ActorTypeNPC))
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

    If (!ApplyBeast && Who.HasKeyword(self.IsBeastRace))
        Return False
    EndIf

    Return True
EndFunction

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Visual                       
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Get the actor's head part name
String Function GetHead(Actor Who)
    ActorBase Base = Who.GetActorBase()

    Int Index = Base.GetIndexOfHeadPartByType(1)
    HeadPart Part = Base.GetNthHeadPart(Index)
    String Name = Part.GetPartName()

    Return Name
EndFunction

; Update the actor's visuals
Function UpdateVisual(Actor Who, Bool Female)
    String Head = self.GetHead(Who)
    String Path = self.ActorFind(Who)
    
    Float Glossiness = self.ActorGet_Glossiness(Path)
	Float Specular = self.ActorGet_Specular(Path)
	
    Main.Util.PrintDebug("Update: " + Who.GetActorBase().GetName())

    ; Slots - https://www.creationkit.com/index.php?title=Slot_Masks_-_Armor

    ; Head
    If Main.Config.GetBool(".VisualGlossinessHead")
        self.AddVisual_Float(Who, Female, 2, Glossiness, Node = Head)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHead")
        self.AddVisual_Float(Who, Female, 3, Specular, Node = Head)
    EndIf
    
    ; Body
    If Main.Config.GetBool(".VisualGlossinessBody")
        self.AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x4)
    EndIf

    If Main.Config.GetBool(".VisualSpecularBody")
        self.AddVisual_Float(Who, Female, 3, Specular, Slot = 0x4)
    EndIf

    ; Hands
    If Main.Config.GetBool(".VisualGlossinessHands")
        self.AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x8)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHands")
        self.AddVisual_Float(Who, Female, 3, Specular, Slot = 0x8)
    EndIf

    ; Feet
    If Main.Config.GetBool(".VisualGlossinessFeet")
        self.AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x80)
    EndIf

    If Main.Config.GetBool(".VisualSpecularFeet")
        self.AddVisual_Float(Who, Female, 3, Specular, Slot = 0x80)
    EndIf

    ; Other
    If Main.Config.GetBool(".VisualGlossinessOther")
        self.AddVisual_Float(Who, Female, 2, Glossiness, Slot = 0x400000)
    EndIf

    If Main.Config.GetBool(".VisualSpecularOther")
        self.AddVisual_Float(Who, Female, 3, Specular, Slot = 0x400000)
    EndIf
EndFunction

; Add slot/node overrides
Function AddVisual_Float(Actor Who, Bool Female, Int NifKey, Float Value, Int Slot = 0, String Node = "")
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
EndFunction

; Reset the actor's visuals
Function RemoveVisual(Actor Who, Bool Female)
    String Head = self.GetHead(Who)

    self.RemoveVisual_Override(Who, Female, 2, Node = Head)
    self.RemoveVisual_Override(Who, Female, 3, Node = Head)

    self.RemoveVisual_Override(Who, Female, 2, Slot = 0x4)
    self.RemoveVisual_Override(Who, Female, 3, Slot = 0x4)

    self.RemoveVisual_Override(Who, Female, 2, Slot = 0x8)
    self.RemoveVisual_Override(Who, Female, 3, Slot = 0x8)

    self.RemoveVisual_Override(Who, Female, 2, Slot = 0x80)
    self.RemoveVisual_Override(Who, Female, 3, Slot = 0x80)

    self.RemoveVisual_Override(Who, Female, 2, Slot = 0x400000)
    self.RemoveVisual_Override(Who, Female, 3, Slot = 0x400000)
EndFunction

; Remove slot/node overrides
Function RemoveVisual_Override(Actor Who, Bool Female, Int NifKey, Int Slot = 0, String Node = "")
    If Slot
        NiOverride.RemoveSkinOverride(Who, Female, False, Slot, NifKey, -1)
        If (Who == Main.Player)
            NiOverride.RemoveSkinOverride(Who, Female, True, Slot, NifKey, -1)
        EndIf
    Else
        NiOverride.RemoveNodeOverride(Who, Female, Node, NifKey, -1)
	EndIf
EndFunction
