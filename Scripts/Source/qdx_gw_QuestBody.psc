ScriptName qdx_gw_QuestBody extends Quest

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                    Properties                      
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

qdx_gw_QuestController Property Main Auto

String Property KeyActors = ".Actors" AutoReadOnly Hidden

String Property KeyActorFormID = ".FormID" AutoReadOnly Hidden
String Property KeyActorName = ".Name" AutoReadOnly Hidden
String Property KeyActorGlossiness = ".Glossiness" AutoReadOnly Hidden
String Property KeyActorSpecular = ".Specular" AutoReadOnly Hidden

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

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Visual                       
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Int KeyNifGlossiness = 2
Int KeyNifSpecular = 3

String Function GetHead(Actor Who)
    ActorBase Base = Who.GetActorBase()

    Int Parts = Base.GetNumHeadParts()
    Int Index = Parts

    String Head

    While (Index > 0)
        Index -= 1

        String Part = Base.GetNthHeadPart(Index).GetName()

        If (StringUtil.Find(Part, "Head") >= 0)
            Head = Part
        EndIf
    EndWhile

    Return Head
EndFunction

Function UpdateVisual(Actor Who, Bool Female)
    {update slot/node visuals}

    ;String Head = self.GetHead(Who)

    String Path = ActorFind(Who)
    
    Float Glossiness = ActorGet_Glossiness(Path)
    Float Specular = ActorGet_Specular(Path)

    Main.Util.PrintDebug("Update Visual: " + Who.GetDisplayName())
    ;Main.Util.PrintDebug("Node Head: " + Head)

    ; slot masks
    ; https://www.creationkit.com/index.php?title=Slot_Masks_-_Armor

    ; head
    If Main.Config.GetBool(".VisualGlossinessHead")
        UpdateVisual_Float(Who, Female, KeyNifGlossiness, Glossiness, 0x01)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHead")
        UpdateVisual_Float(Who, Female, KeyNifSpecular, Specular, 0x01)
    EndIf

    ; body
    If Main.Config.GetBool(".VisualGlossinessBody")
        UpdateVisual_Float(Who, Female, KeyNifGlossiness, Glossiness, 0x04)
    EndIf

    If Main.Config.GetBool(".VisualSpecularBody")
        UpdateVisual_Float(Who, Female, KeyNifSpecular, Specular, 0x04)
    EndIf

    ; hands
    If Main.Config.GetBool(".VisualGlossinessHands")
        UpdateVisual_Float(Who, Female, KeyNifGlossiness, Glossiness, 0x08)
    EndIf

    If Main.Config.GetBool(".VisualSpecularHands")
        UpdateVisual_Float(Who, Female, KeyNifSpecular, Specular, 0x08)
    EndIf

    ; feet
    If Main.Config.GetBool(".VisualGlossinessFeet")
        UpdateVisual_Float(Who, Female, KeyNifGlossiness, Glossiness, 0x80)
    EndIf

    If Main.Config.GetBool(".VisualSpecularFeet")
        UpdateVisual_Float(Who, Female, KeyNifSpecular, Specular, 0x80)
    EndIf

    ; other
    ;If Main.Config.GetBool(".VisualGlossinessHead")
    UpdateVisual_Float(Who, Female, KeyNifGlossiness, Glossiness, 0x400000)
    UpdateVisual_Float(Who, Female, KeyNifSpecular, Specular, 0x400000)

    If (Who == Main.Player)
        ;
    EndIf

    Return
EndFunction

Function UpdateVisual_Float(Actor Who, Bool Female, Int NifKey, Float Value, Int Slot = 0, String Node = "")
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
            NiOverride.AddSkinOverrideFloat(Who, Female, True, Slot, NifKey, -1, Value, False)
        Else
            NiOverride.AddNodeOverrideFloat(Who, Female, Node, NifKey, -1, Value, False)
        EndIf
    EndIf

    Return
EndFunction