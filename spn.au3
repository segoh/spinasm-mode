#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         segoh

 Script Function:
	Control SpinAsm

#ce ----------------------------------------------------------------------------

#CS
NOTE: Change the following variables to fit your system and language
#CE
Dim $spinasm_exe = "C:\Programme\SpinAsm IDE\SpinAsm.exe"
Dim $open_window_title = "Öffnen"

Func SpnStart()
	If WinExists("SpinAsm") Then
		WinActivate("SpinAsm")
	Else
		Run($spinasm_exe)
	EndIf
	WinWaitActive("SpinAsm")
EndFunc

Func SpnOpen($file)
	Send("^o")
	WinWaitActive($open_window_title)
	Send($file)
	Send("!f")
	WinWaitActive("SpinAsm", "Ready")
EndFunc

Func SpnClose()
	If WinGetText("SpinAsm") <> "Ready" Then
		Send("!f")
		Send("c")
		Send("{ENTER}")
	EndIf
EndFunc

Func SpnAssemble()
	ControlClick("SpinAsm", "", "[ID:59392]", "left", 1, 16, 11)
	Dim $result
	If WinWait("Program Stats", "", 1) Then
		$result = WinGetText("Program Stats")
		WinClose("Program Stats")
	ElseIf WinWait("Error Log", "", 1) Then
		$result = WinGetText("Error Log")
		WinClose("Error Log")
	EndIf
	ConsoleWrite($result)
EndFunc

Func GetFilename()
	If $CmdLine[0] > 0 Then
		Return $CmdLine[1]
	Else
		Return ""
	EndIf
EndFunc

SpnStart()
SpnClose()
SpnOpen(GetFilename())
SpnAssemble()
