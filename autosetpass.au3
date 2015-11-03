#include <GuiEdit.au3>
#include "passwd.au3"
#include "data.au3"
#include "func.au3"

$uniq_script_name = 'AUTOSETPASS'
If WinExists($uniq_script_name, '') Then
    MsgBox(0, "Ошибка!", "Предыдущий скрипт не был завершен!", $MSGWAID)
    Exit
Else
    AutoItWinSetTitle($uniq_script_name)
EndIf

;начальное сообщение
FileWrite($log_fle, @CRLF & get_datetime() & ': Автологинер запущен...' & @CRLF)

;закрываем лог в случае завершения программы
OnAutoItExitRegister('_req_exit')

;завершение...
$openlog    = TrayCreateItem("Открыть лог")
$exititem   = TrayCreateItem("")
$poweroff   = TrayCreateItem("Завершение работы (Shift+Pause)")
$exititem   = TrayCreateItem("")
$exititem   = TrayCreateItem("Выход (Shift+Esc)")
TrayItemSetOnEvent($openlog,    '_OpenLog')
TrayItemSetOnEvent($poweroff,   '_PowerOff')
TrayItemSetOnEvent($exititem,   '_Exit')
HotKeySet('+{PAUSE}', '_PowerOff') ;Shift+Pause - завершение работы компьютера
HotKeySet('+{Esc}',   '_Exit') ;Shift+Esc - выход

If @Compiled Then
    _RegRun() ;для записи скрипта в автозагрузку
EndIf

;каждую секунду изменяем счетчик времени
AdlibRegister("time_count", 1000)

;уст. промежуток для проверки запущенных процессов
AdlibRegister("ps_test", 100000)

While 1
    
    ;тест-крипто
    if Not $f_test_old Then
        $handle = WinWait ( "Сканирование папок и криптография", "", 1)
        If $handle Then 
            If ControlClick($handle, "", "[TEXT:Тест крипто]") Then
                $f_test_old = 1
                FileWrite($log_fle, get_datetime() & ': Тест крипто запущен' & @CRLF)
            Else
                FileWrite($log_fle, get_datetime() & ': Тест крипто не удалось запустить!' & @CRLF)
            EndIf
        EndIf
    EndIf
    
    ;вкл. автоотправку
    if Not $f_test_new Then
        $handle = WinWait ( "Передача файла", "", 1)
        If $handle Then 
            $test = ControlCommand($handle, "", "TCheckBox1", "Check", "")
            If @error Then
                FileWrite($log_fle, get_datetime() & ': Режим автоматической отправки включить не удалось!' & @CRLF)
            Else
                $f_test_new = 1
                FileWrite($log_fle, get_datetime() & ': Режим автоматической отправки включен' & @CRLF)
            EndIf
        EndIf
    EndIf
    
    ;отслеживаем работу программ и в случае падения перезапускаем
    If $f_ps_auto = "1" Then 
        If $f_ps_test Then
            For $index = 0 To Ubound($ps_arr) - 1
                If Not ProcessExists($ps_arr[$index][0] & $ps_arr[$index][1]) Then
                    FileWrite($log_fle, get_datetime() & ': Процесс <' & $ps_arr[$index][1] & '> не обнаружен!' & @CRLF)
                    ps_start($ps_arr[$index][0], $ps_arr[$index][1])
                EndIf
            Next
            $f_ps_test = 0
        EndIf
    EndIf
    
    ;Проходимся по массиву и вызываем функции
    For $index = 0 To Ubound($dlg_arr) - 1
        $dlg_arr[$index][2]($dlg_arr, $index)
        Sleep(100)
    Next

WEnd