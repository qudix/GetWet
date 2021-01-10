ScriptName qdx_gw Hidden

Function Update(Bool a_running) Global Native

; Actor

Actor[] Function GetActorList() Global Native
String[] Function GetActorNameList() Global Native

Float[] Function GetActorFloatSettings(Actor a_actor) Global Native
Function SetActorFloatSetting(Actor a_actor, String a_key, Float a_val) Global Native

Function AddActorSettings(Actor a_actor) Global Native
Function RemoveActorSettings(Actor a_actor) Global Native

; Default

Int[] Function GetIntSettings() Global Native
Float[] Function GetFloatSettings() Global Native
Bool[] Function GetBoolSettings() Global Native

Function SetIntSetting(String a_key, Int a_val) Global Native
Function SetFloatSetting(String a_key, Float a_val) Global Native
Function SetBoolSetting(String a_key, Bool a_val) Global Native

; Util

Function PrintConsole(String a_message) Global Native
