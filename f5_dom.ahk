#IfWinActive, ahk_class PX_WINDOW_CLASS
	F5::
	st_save()
	sleep, 500
	run_target()
	WinActivate, ahk_class PX_WINDOW_CLASS
	return
#If

st_save(){
	send,^s
}

run_target(){
	run, D:\Jack\Desktop\dom\com.ahk
}


