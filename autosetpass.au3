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
If $f_ps_auto = "1" Then
    AdlibRegister("ps_time_test", $PSTESTTIME)
EndIf
;запускаем процессы при старте скрипта (если флаг auto=0)
ps_test($ps_arr)

While 1
    
    ;тест-крипто
    if $ps_arr[0][3] = 1 Then
        $handle = WinWait ( "Сканирование папок и криптография", "", 1)
        If $handle Then 
            If ControlClick($handle, "", "[TEXT:Тест крипто]") Then
                $ps_arr[0][3] = 0
                FileWrite($log_fle, get_datetime() & ': Тест крипто запущен' & @CRLF)
            EndIf
        EndIf
    EndIf
    
    ;вкл. автоотправку
    If $ps_arr[2][3] = 1 Then
        $handle = WinWait ( "Передача файла", "", 1)
        If $handle Then 
            $test = ControlCommand($handle, "", "TCheckBox1", "Check", "")
            If @error Then
                FileWrite($log_fle, get_datetime() & ': Режим автоматической отправки включить не удалось!' & @CRLF)
            Else
                $ps_arr[2][3] = 0
                FileWrite($log_fle, get_datetime() & ': Режим автоматической отправки включен' & @CRLF)
            EndIf
        EndIf
    EndIf
    
    If $f_clr_block = 1 Then
        For $index = 0 To Ubound($ps_arr) - 1
            $ps_arr[$index][2] = 0
            $ps_arr[$index][3] = 1
        Next
        $f_clr_block = 0
    EndIf
    
    ;отслеживаем работу программ и в случае падения перезапускаем
    If $f_ps_auto = "1" Then 
        ps_test($ps_arr)
    EndIf
    
    ;Проходимся по массиву и вызываем функции
    For $index = 0 To Ubound($dlg_arr) - 1
        $dlg_arr[$index][2]($dlg_arr, $index)
        Sleep(100)
    Next

WEnd