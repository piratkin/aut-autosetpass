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
Global Const $TIMEOUT    = 30          ;общий таймаут в программе
Global Const $HOUR4      = 14400       ;4-е часа
Global Const $PSDELAY    = 1           ;задержка опроса наличия процесса программы
Global Const $MSGWAID    = 8           ;время отображения диалогового окна
Global Const $MAXRETRY   = 3           ;максимальное к-во попыток запустить процесс
Global Const $PSTESTTIME = 300000      ;промежуток времени (мс) через который происходит перезапуск процесса

;определяем расположение рабочих файлов и создаем лог
Global $name = StringRegExpReplace(@ScriptFullPath, '^.*\\|\.[^\.]*$', '')
Global $cfg_ini = @ScriptDir & "\" & $name & ".ini"
Global $cfg_log = @ScriptDir & "\" & $name & ".log"
Global $log_fle = FileOpen( $cfg_log, 1)

;массив для хранения данных диалоговых окон
Global $dlg_arr[8][8] 
Global $ps_arr[3][3]

;параметры читаемые из файла конфигурации
$ps_arr[0][0]      = IniRead($cfg_ini, "PS1", "path", "C:\Program Files\Estel IT Group\ListFolder\") 
$ps_arr[0][1]      = IniRead($cfg_ini, "PS1", "name", "ListFolder.exe")
$ps_arr[0][2]      = 0

$ps_arr[1][0]      = IniRead($cfg_ini, "PS2", "path", "D:\Crypto Service\") 
$ps_arr[1][1]      = IniRead($cfg_ini, "PS2", "name", "CryptoService33.exe")
$ps_arr[1][2]      = 0

$ps_arr[2][0]      = IniRead($cfg_ini, "PS3", "path", "D:\ListFolder\") 
$ps_arr[2][1]      = IniRead($cfg_ini, "PS3", "name", "lf.exe")
$ps_arr[2][2]      = 0

;переменные
Global $countdown     = $HOUR4      ;счетчик времени для проведения автопроверки
Global $f_test_old    = 0           ;флаг запуска автопроверки
Global $f_test_new    = 0           ;флаг запуска автопроверки
Global $f_ps_test     = 1           ;флаг инициирующ. тестирование процессов
Global $f_ps_auto     = IniRead($cfg_ini, "GENERAL", "auto", "0") ;флаг автозапуска программ

;параметры диалоговых окон:
$dlg_arr[0][0]     = "Личный ключ ЭЦП"         ;залоглвок окна
$dlg_arr[0][1]     = ""                        ;текст окна
$dlg_arr[0][2]     = _input_dt                 ;функция обратного вызова
$dlg_arr[0][3]     = 1                         ;
$dlg_arr[0][4]     = "Msg1"                    ;имя сообщения в логе
$dlg_arr[0][5]     = $new_passwd               ;пароль котор будет вводиться в поле ввода
$dlg_arr[0][6]     = "TEdit1"                  ;элемент окна для ввода пароля
$dlg_arr[0][7]     = "TButton1"                ;кнопка подтверждения (OK)

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

$dlg_arr[7][0]     = "Программа прекращает работу"
$dlg_arr[7][1]     = ""
$dlg_arr[7][2]     = _click_ok
$dlg_arr[7][3]     = 1
$dlg_arr[7][4]     = "Err5"
$dlg_arr[7][5]     = ""
$dlg_arr[7][6]     = ""
$dlg_arr[7][7]     = "Button1"