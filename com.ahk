#SingleInstance Force

; gui, font, s10, Verdana  
Gui, Add, Button, , EnableTelnet
Gui, Add, Button,, Ipconfig

Gui, Show,, Jack Memo

return 

ButtonEnableTelnet:
Run, %comspec% /c DISM /online /enable-feature /featurename:TelnetClient
return

ButtonIpconfig:
Run, %comspec% /k ipconfig
return







	






