;*************************************************************;
;Made by Jack
;Created at 150816
;Last Modified 150816 17:14
;This script is just for Record items
;*************************************************************;

;Include------------------------------------------------
#Include, F:\Work\Lib\tf.ahk

;Var define------------------------------------------
WorkDir := "F:\Work\Memo"  ;WARNING: NO \ AT END
Name := "a"
;Define  above two Var
FileName = %WorkDir%\%Name%.txt
FileNameCopy = %WorkDir%\%Name%_copy.txt   ;;This is just a temp storage
FileNameDone = %WorkDir%\%Name%_done.txt
FileNameLog = %WorkDir%\%Name%_log.txt
BackupDir = %WorkDir%\Backup
None :=  ""
SleepTime = 100

;Function define------------------------------------
FilePrepend( text, Filename ) {
    file:= FileOpen(Filename, "rw")
    text = %text%`r`n
    text .= file.Read()   ;text=text+file.read()
    file.pos:=0
    file.Write(text)
    file.Close()
}
FilePrependWithTime( text, Filename ) {
    file:= FileOpen(Filename, "rw")
    FormatTime, Now ,,yyMMdd,HH:mm:ss
    text = %Now%  %text%`r`n
    text .= file.Read()   ;text=text+file.read()
    file.pos:=0
    file.Write(text)
    file.Close()
}
TimeNow(){
	FormatTime, TimeNow ,,yyMMdd,HH:mm:ss
	return TimeNow
}
BackupTime(){
    FormatTime, BackupTime ,,yyMMdd_HHmmss
    return BackupTime
}

;Draw Gui -------------------------------------------------
gui, font, s10, Verdana  
Gui, Add, Text, x22 y9 w200 h20 vFileNameText, FileNameText
Gui, Add, Edit, x22 y39 w430 h50 vInfoInput, 
Gui, Add, Edit, x22 y109 w430 h410 vNumOn, 
Gui, Add, Button, x482 y39 w140 h60 , AddItem
Gui, Add, Edit, x22 y529 w430 h60 vMainEdit2, 
Gui, Add, Button, x482 y179 w130 h60 , DelItem
Gui, Add, Button, x482 y259 w130 h60 , Done
Gui, Add, Button, x482 y379 w130 h60 , Read
Gui, Add, Button, x482 y459 w130 h60 , Write
Gui, Add, Edit, x482 y109 w130 h50 vLineNum, 
Gui, Add, Button, x22 y599 w120 h30 , DisplayLineNum
Gui, Add, Button, x152 y599 w80 h30 , Backup
Gui, Add, Button, x242 y599 w80 h30 , CleanAll

; Generated using SmartGUI Creator 4.0
Gui, Show, x323 y145 h649 w654, Jack Memo
;PreLoad
GuiControl,, FileNameText, %FileName%  ; Put the text into the control.
Gosub ButtonDisplayLineNum
Return

;Macro-----------------------------------------
#IfWinActive, ahk_class AutoHotkeyGUI
	Enter::
	Goto, ButtonAddItem
	Return
#If

;Respond----------------------------------------------
ButtonAddItem:
GuiControlGet, InfoInput
if(InfoInput = ""){
    Return
}
FilePrependWithTime( InfoInput, Filename )
;Initial
GuiControl,, InfoInput, %None%  ; Put the text into the control.
GuiControl, Focus, InfoInput
;Log
TimeAdd := TimeNow()
NewEntry = New %TimeAdd%  %InfoInput%
FilePrependWithTime( NewEntry, FileNameLog )
;Display Log Copy
Sleep, %SleepTime%
FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Goto ButtonDisplayLineNum
Return

ButtonDelItem:
GuiControlGet, LineNum
if(LineNum = ""){
    Return
}
LineToRemove := TF_ReadLines(FileName, LineNum, LineNum,1)
TF_RemoveLines("!"FileName, LineNum, LineNum)
;Log
RemoveEntry = RM  %LineToRemove%
FilePrependWithTime( RemoveEntry, FileNameLog)
;Display Log Copy
FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Goto ButtonDisplayLineNum
return

ButtonDone:
GuiControlGet, LineNum
if(LineNum = ""){
    Return
}
LineDone:=TF_ReadLines(FileName, LineNum, LineNum,1)
FilePrependWithTime( LineDone, FileNameDone)
TF_RemoveLines("!"FileName, LineNum, LineNum)
;Log
DoneEntry = OK  %LineDone%
FilePrependWithTime( DoneEntry, FileNameLog)
;Display Log Copy
FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Goto ButtonDisplayLineNum
return


;------------------------------------------------------------------
ButtonRead:
FileRead, FileContents, %FileName% ; Read the file's contents into the variable.
GuiControl,, NumOn, %FileContents%  ; Put the text into the control.

ButtonWrite:
IfExist %FileName%
{
    FileDelete %FileName%
    if ErrorLevel
    {
        MsgBox The attempt to overwrite "%FileName%" failed.
        return
    }
}
GuiControlGet, NumOn
FileAppend, %NumOn%, %FileName%  ; Save the contents to the file.

;Display
Sleep, %SleepTime%
FileRead, FileContents, %FileName% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Return

;---------------------------------------------------
ButtonDisplayLineNum:
TF_LineNumber(FileName,1,100,A_Space)
FileRead, FileContents, %FileNameCopy% ; Read the file's contents into the variable.
GuiControl,, NumOn, %FileContents%  ; Put the text into the control.
Return

ButtonBackup:
BackupTime := BackupTime()
IfNotExist, %BackupDir%
    FileCreateDir, %BackupDir%
IfExist, %BackupDir%\%BackupTime%.txt
{
    i := i + 1
    BackupDestination=%BackupDir%\%BackupTime%_%i%.txt
    FileRead, FileContents, %FileName% ; Read the file's contents into the variable.
    FileAppend, %FileContents%, %BackupDestination%  ; Save the contents to the file.
    ;Log
    BackupEntry = BK %BackupDestination%
    FilePrependWithTime( BackupEntry, FileNameLog)
    return
    ;Display
    Sleep, %SleepTime%
    FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
    GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
    Goto ButtonDisplayLineNum
}    
BackupDestination=%BackupDir%\%BackupTime%.txt
i := 0
FileRead, FileContents, %FileName% ; Read the file's contents into the variable.
FileAppend, %FileContents%, %BackupDestination%  ; Save the contents to the file.
;Log
BackupEntry = BK %BackupDestination%
FilePrependWithTime( BackupEntry, FileNameLog)
;Display
Sleep, %SleepTime%
FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Goto ButtonDisplayLineNum
Return

ButtonCleanAll:
IfExist %FileName%
{
    FileDelete %FileName%
    if ErrorLevel
    {
        MsgBox The attempt to overwrite "%FileName%" failed.
        return
    }
}
FileAppend, %None%, %FileName%  ; Save the contents to the file.
;Log
RemoveEntry = RM All
FilePrependWithTime( RemoveEntry, FileNameLog)
;Display
Sleep, %SleepTime%
FileRead, FileContents, %FileNameLog% ; Read the file's contents into the variable.
GuiControl,, MainEdit2, %FileContents%  ; Put the text into the control.
Goto ButtonDisplayLineNum
Return








GuiClose:
ExitApp













;Unuse*******************************************************

; Log -------------------------------
; TimeAdd := TimeNow()
; Add = Add %TimeAdd% %Add%
; FilePrependWithTime( Add, FileNameLog )

;This is File Append----------------
; ButtonAdd:
; GuiControlGet, Add
; FormatTime, Now ,,yyMMdd,HH:mm:ss
; FileAppend,
; (
;  `n%Now% %Add%
; ), D:\Desktop\ahk\a.txt
; Sleep, %SleepTime%
; FileRead, FileContents, %FileName% ; Read the file's contents into the variable.
; GuiControl,, MainEdit, %FileContents%  ; Put the text into the control.
; Return
