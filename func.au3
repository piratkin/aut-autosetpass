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
		$f_test_old    = 0
        $f_test_new    = 0
	EndIf
EndFunc

;освобождаем ресурсы перед выходом
Func _req_exit()
    FileWrite($log_fle, $CRDATE & ': Завершение программы...' & @CRLF)
    FileClose($log_fle)
EndFunc   ;==>_req_exit

;завершение
Func _Exit()
    Exit
EndFunc   ;==>_Exit

;клацаем на кнопку
Func _click_ok($arr, $inx)
    $handle = WinGetHandle($arr[$inx][0], $arr[$inx][1])
	If @error Or Not BitAND(WinGetState($handle), 4) Then Return SetError(0)
	If ControlClick($handle, "", $dlg_arr[$inx][7]) Then
	    If WinWaitClose($handle, "", $TIMEOUT) Then
			FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - получено подтверждение' & @CRLF)
			Return SetError(0)
		Else 
			FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - не удалось получить подтверждение!' & @CRLF)
			Return SetError(1)
		EndIf
	;Else 
	;	FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
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
			FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - получено подтверждение' & @CRLF)
			Return SetError(0)
		Else 
			FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - не удалось получить подтверждение!' & @CRLF)
			Return SetError(1)
		EndIf
	;Else 
	;	FileWrite($log_fle, $CRDATE & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
	;    Return SetError(1)
	EndIf
EndFunc   ;==>_input_dt