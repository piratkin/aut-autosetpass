#include <GuiEdit.au3>
#include "passwd.au3"
#include "data.au3"
#include "func.au3"

$uniq_script_name = 'AUTOSETPASS'
If WinExists($uniq_script_name, '') Then
	MsgBox(0, "Ошибка!", "Предыдущий скрипт не был завершен!", 8)
    Exit
Else
    AutoItWinSetTitle($uniq_script_name)
EndIf

;текущая дата в нужном формате
$CRDATE = @MDAY & "." & @MON & "." & @YEAR & ' ' & @HOUR & ":" & @MIN

;определяем расположение рабочих файлов и создаем лог
$name = StringRegExpReplace(@ScriptFullPath, '^.*\\|\.[^\.]*$', '')
$cfg_ini = @ScriptDir & "\" & $name & ".ini"
$cfg_log = @ScriptDir & "\" & $name & ".log"
$log_fle = FileOpen( $cfg_log, 1)

;начальное сообщение
FileWrite($log_fle, @CRLF & $CRDATE & ': Автологинер запущен...' & @CRLF)

;закрываем лог в случае завершения программы
OnAutoItExitRegister('_req_exit')

;завершение...
$exititem   = TrayCreateItem("Выход (Shift+Esc)")
TrayItemSetOnEvent($exititem,   '_Exit')
HotKeySet('+{Esc}', '_Exit') ;Shift+Esc - выход

If @Compiled Then
    _RegRun() ;для записи скрипта в автозагрузку
EndIf

;каждую секунду изменяем счетчик времени
AdlibRegister("time_count", 1000)

While 1
    ;тест-крипто
    if Not $f_test_old Then
	    $handle = WinWait ( "Сканирование папок и криптография", "", 1)
		If $handle Then 
		    If ControlClick($handle, "", "[TEXT:Тест крипто]") Then
			    $f_test_old = 1
			    FileWrite($log_fle, $CRDATE & ': Тест крипто запущен' & @CRLF)
			Else
			    FileWrite($log_fle, $CRDATE & ': Тест крипто не удалось запустить!' & @CRLF)
			EndIf
		EndIf
	EndIf
    
	;вкл. автоотправку
	if Not $f_test_new Then
	    $handle = WinWait ( "Передача файла", "", 1)
	    If $handle Then 
		    $test = ControlCommand($handle, "", "TCheckBox1", "Check", "")
			If @error Then
			    FileWrite($log_fle, $CRDATE & ': Режим автоматической отправки включить не удалось!' & @CRLF)
			Else
			    $f_test_new = 1
			    FileWrite($log_fle, $CRDATE & ': Режим автоматической отправки включен' & @CRLF)
			EndIf
		EndIf
	EndIf
	
	;Проходимся по массиву и вызываем функции
	For $index = 0 To Ubound($dlg_arr) - 1
		$dlg_arr[$index][2]($dlg_arr, $index)
		Sleep(100)
	Next
WEnd