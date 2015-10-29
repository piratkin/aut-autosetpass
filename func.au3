;прописываем скрипт в автозапуск
Func _RegRun()
    ;Local $sRegRun = 'HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
    ;If RegRead($sRegRun, @ScriptName) = '' Or RegRead($sRegRun, @ScriptName) <> @ScriptFullPath Then
    ;    RegWrite($sRegRun, @ScriptName, 'REG_SZ', @ScriptFullPath)
    ;EndIf
EndFunc   ;==>_RegRun

;тест пароля через заданный промежуток времени
Func time_count()
    If $countdown > 0 Then 
	    $countdown -= 1
	Else
	    $countdown = $HOUR4
		$f_test_old = 0
        $f_test_new = 0
	EndIf
EndFunc

;уст. флаг инициирующий проверку процессов
Func ps_test()
    If Not $f_ps_auto = "0" Then 
	    $f_ps_test = "1"
	Else 
	    AdlibUnRegister ("ps_test")
	EndIf
EndFunc

;текущая дата в нужном формате
Func get_datetime()
    Return @MDAY & "." & @MON & "." & @YEAR & ' ' & @HOUR & ":" & @MIN
EndFunc

;освобождаем ресурсы перед выходом
Func _req_exit()
    FileWrite($log_fle, get_datetime() & ': Завершение программы...' & @CRLF)
    FileClose($log_fle)
EndFunc   ;==>_req_exit

;завершение
Func _Exit()
    Exit
EndFunc   ;==>_Exit

Func _PowerOff () 
    Shutdown (1+4); завершение работы + принудительно 
    Exit 
EndFunc

;клацаем на кнопку
Func _click_ok($arr, $inx)
    $handle = WinGetHandle($arr[$inx][0], $arr[$inx][1])
	If @error Or Not BitAND(WinGetState($handle), 4) Then Return SetError(0)
	If ControlClick($handle, "", $dlg_arr[$inx][7]) Then
	    If WinWaitClose($handle, "", $TIMEOUT) Then
			FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - получено подтверждение' & @CRLF)
			Return SetError(0)
		Else 
			FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - не удалось получить подтверждение!' & @CRLF)
			Return SetError(1)
		EndIf
	;Else 
	;	FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
	;    Return SetError(1)
	EndIf
EndFunc   ;==>_click_ok

;вводим пароль и подтверждаем ("OK")
Func _input_dt($arr, $inx)
	$handle = WinGetHandle($arr[$inx][0], $arr[$inx][1])	
	If @error Or Not BitAND(WinGetState($handle), 4) Then Return SetError(0)
	ControlSetText($handle, "", $dlg_arr[$inx][6], $dlg_arr[$inx][5])
	If ControlClick($handle, "", $dlg_arr[$inx][7]) Then
	    If WinWaitClose($handle, "", $TIMEOUT) Then
			FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - получено подтверждение' & @CRLF)
			Return SetError(0)
		Else 
			FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - не удалось получить подтверждение!' & @CRLF)
			Return SetError(1)
		EndIf
	;Else 
	;	FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
	;    Return SetError(1)
	EndIf
EndFunc   ;==>_input_dt

;запуск программы
Func ps_start($path, $name)
    ;проверяем путь исполняемого файла
	If Not FileExists($path & $name) Then
		FileWrite($log_fle, get_datetime() & ': Не найден: ' & $path & $name & '!' & @CRLF)
		Return SetError(1)
	EndIf
	;проверяем на отсутствие запущенных копий
	If ProcessWaitClose($name, $TIMEOUT) Then
	    ;запускаем новый процесс
		If Run($path & $name, $path, @SW_SHOW ) > 0 Then
			FileWrite($log_fle, get_datetime() & ': Процесс <' & $name & '> запущен' & @CRLF)
		Else
			FileWrite($log_fle, get_datetime() & ': Не удалось запустить <' & $name & '>!' & @CRLF)
		EndIf
	Else
		FileWrite($log_fle, get_datetime() & ': Процесс <' & $name & '> не был запущен т.к. не закрыт предыдущий процесс!' & @CRLF)
	EndIf
EndFunc   ;==>ps_start