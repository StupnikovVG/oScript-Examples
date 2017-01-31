# oScript-Examples
Различные примеры скриптов на oscript http://oscript.io/ для автоматизации работы программиста 1С



# CopyBase.os [В разработке]

Нужна для копирования одной базы в другую с переподключением к хранилищу. Например, когда для поиска ошибки нужно оперативно развернуть себе в базу разработки актуальную копию рабочей базы.

Выполняет 4 действия:

1. Выгружает базу данных (База данных базы источника) из MS SQL с использованием SQLCMD (используется скрипт-обертка ExecQuery_SQLCMD.os) в указанный файл
2. Выполняет произвольный скрипт. Подразумевается, что в этом скрипте будет загрузка из файла в нужную базу и настройка параметров. (Загрузка базы данных базы приемника)
3. Отключает от хранилища базы приемника
4. Подключает к указанному хранилищу базу приемника

# Обработка "Изменение настроек"

Позволяет настроить конфигурационный файл для скрипта CopyBase.os. Работает только в управляемом режиме.
