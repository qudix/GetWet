@echo off
set Compiler=F:\Games\Steam\steamapps\common\Skyrim Special Edition\Tools\Papyrus Compiler\PapyrusCompiler.exe
set Mods=F:\Mods\Skyrim SE\mods
set Game=%Mods%\[Core] Game\Scripts\Source
set SexLab=%Mods%\[Core] SexLab Framework SE\Scripts\Source
set SexLabAroused=%Mods%\[Core] SexLab Aroused SSE\Scripts\Source
set SkyUI=%Mods%\[Interface] SkyUI\Scripts\Source
set RaceMenu=%Mods%\[SKSE] RaceMenu SE\Scripts\Source
set UIExtensions=%Mods%\[Interface] UIExtensions\Scripts\Source
set Mod=%Mods%\[Effect] Get Wet\Scripts

"%Compiler%" "%Mod%\Source" -f="TESV_Papyrus_Flags.flg" -i="%Game%;%SexLab%;%SexLabAroused%;%SkyUI%;%RaceMenu%;%UIExtensions%" -o="%Mod%" -all
pause