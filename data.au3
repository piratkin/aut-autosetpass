;директивы
;#NoTrayIcon

;настройки системы
Opt("TrayOnEventMode", 1)
Opt("GUIOnEventMode", 1)
Opt("SendCapslockMode", 0)
Opt("TrayMenuMode", 1 + 2)
Opt("WinWaitDelay", 0)
Opt("WinTitleMatchMode", 2) 

;константы
Dim Const $TIMEOUT = 30          ;общий таймаут в программе
Dim Const $HOUR4   = 14400       ;4-е часа

;переменные
Dim $countdown     = $HOUR4      ;счетчик времени для проведения автопроверки
Dim $f_test_old    = 0           ;флаг запуска автопроверки
Dim $f_test_new    = 0           ;флаг запуска автопроверки

;масив для хранения данных диалоговых окон
Global  $dlg_arr[7][8] 

$dlg_arr[0][0]     = "Личный ключ ЭЦП"
$dlg_arr[0][1]     = ""
$dlg_arr[0][2]     = _input_dt
$dlg_arr[0][3]     = 1
$dlg_arr[0][4]     = "Msg1"
$dlg_arr[0][5]     = $new_passwd
$dlg_arr[0][6]     = "TEdit1"
$dlg_arr[0][7]     = "TButton1"

$dlg_arr[1][0]     = "Ошибка"
$dlg_arr[1][1]     = ""
$dlg_arr[1][2]     = _click_ok
$dlg_arr[1][3]     = 1
$dlg_arr[1][4]     = "Err1"
$dlg_arr[1][5]     = ""
$dlg_arr[1][6]     = ""
$dlg_arr[1][7]     = "[TEXT:OK]"

$dlg_arr[2][0]     = "Файл отсутствует"
$dlg_arr[2][1]     = ""
$dlg_arr[2][2]     = _click_ok
$dlg_arr[2][3]     = 1
$dlg_arr[2][4]     = "Err2"
$dlg_arr[2][5]     = ""
$dlg_arr[2][6]     = ""
$dlg_arr[2][7]     = "[TEXT:OK]"

$dlg_arr[3][0]     = "Error"
$dlg_arr[3][1]     = ""
$dlg_arr[3][2]     = _click_ok
$dlg_arr[3][3]     = 1
$dlg_arr[3][4]     = "Err3"
$dlg_arr[3][5]     = ""
$dlg_arr[3][6]     = ""
$dlg_arr[3][7]     = "[TEXT:OK]"

$dlg_arr[4][0]     = "Listfolder"
$dlg_arr[4][1]     = ""
$dlg_arr[4][2]     = _click_ok
$dlg_arr[4][3]     = 1
$dlg_arr[4][4]     = "Msg2"
$dlg_arr[4][5]     = ""
$dlg_arr[4][6]     = ""
$dlg_arr[4][7]     = "[TEXT:OK]"

$dlg_arr[5][0]     = "Ввод пароля"
$dlg_arr[5][1]     = ""
$dlg_arr[5][2]     = _input_dt
$dlg_arr[5][3]     = 1
$dlg_arr[5][4]     = "Msg3"
$dlg_arr[5][5]     = $old_passwd
$dlg_arr[5][6]     = "TMaskEdit1"
$dlg_arr[5][7]     = "[TEXT:OK]"

$dlg_arr[6][0]     = "lf"
$dlg_arr[6][1]     = ""
$dlg_arr[6][2]     = _click_ok
$dlg_arr[6][3]     = 1
$dlg_arr[6][4]     = "Err4"
$dlg_arr[6][5]     = ""
$dlg_arr[6][6]     = ""
$dlg_arr[6][7]     = "Button1"