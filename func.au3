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
        $f_clr_block = 1
    EndIf
EndFunc

;уст. флаг инициирующий проверку процессов
Func ps_time_test() 
    $f_ps_test = 1
    ;FileWrite($log_fle, get_datetime() & ': +ps_time_test' & @CRLF)
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

Func _OpenLog () 
    Run("notepad.exe autosetpass.log", "", @SW_SHOW )
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
    ;    FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
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
    ;    FileWrite($log_fle, get_datetime() & ': ' & $arr[$inx][4]  & ' - окно не отвечает!' & @CRLF)
    ;    Return SetError(1)
    EndIf
EndFunc   ;==>_input_dt

;тестируем процессы
Func ps_test(ByRef $arr)
        If $f_ps_test Then
            For $index = 0 To Ubound($arr) - 1
                If $arr[$index][2] < $MAXRETRY Then
                    If Not ProcessExists($arr[$index][1]) Then
                        FileWrite($log_fle, get_datetime() & ': Процесс <' & $arr[$index][1] & '> не обнаружен!' & @CRLF)
                        ps_start($arr[$index][0], $arr[$index][1])
                        $arr[$index][2] += 1
                        $arr[$index][3] = 1
                    EndIf 
                ElseIf $arr[$index][2] = $MAXRETRY Then
                    FileWrite($log_fle, get_datetime() & ': Не удалось запустить процесс <' & $arr[$index][1] & '> в течении (' & $MAXRETRY & ') попыток!' & @CRLF)
                    $arr[$index][2] += 1
                    $arr[$index][3] = 0
                EndIf
            Next
            $f_ps_test = 0
        EndIf
EndFunc   ;==>ps_test

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