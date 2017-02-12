﻿#Использовать 1commands
#Использовать logos

#Использовать "../Модули"

Перем _Сервер;
Перем _Пользователь;
Перем _Пароль;
Перем _ИмяБазы;

Перем _ВыводКоманды;

Перем _Лог;

// Получить имя лога продукта
//
// Возвращаемое значение:
//  Строка   - имя лога продукта
//
Функция ИмяЛога() Экспорт
	Возврат "oscript.app.РаботаСSQL";
КонецФункции

Процедура УстановитьСервер( Знач пСервер ) Экспорт
	_Сервер = пСервер;
	_Лог.Отладка( "Установлен сервер: " + _Сервер );
КонецПроцедуры

Процедура УстановитьПользователя( Знач пПользователь ) Экспорт
	_Пользователь = пПользователь;
	_Лог.Отладка( "Установлен пользователь: " + _Пользователь );
КонецПроцедуры

Процедура УстановитьПароль( Знач пПароль ) Экспорт
	_Пароль = пПароль;
	Если _Пароль = "" Тогда
		_Лог.Отладка( "Установлен пароль: " );
	Иначе
		_Лог.Отладка( "Установлен пароль" );
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьИмяБазы( Знач пИмяБазы ) Экспорт
	_ИмяБазы = пИмяБазы;
	_Лог.Отладка( "Установлен сервер " + _ИмяБазы );
КонецПроцедуры

Функция ПроверитьЗаполнение( Знач пПроверятьИмяБазы )
	
	отказ = Ложь;

	Если Не ЗначениеЗаполнено( _Сервер ) Тогда
		
		_Лог.Ошибка( "Сервер не указан" );
		отказ = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено( _Пользователь ) Тогда
		
		_Лог.Ошибка( "Пользователь не указан" );
		отказ = Истина;
		
	КонецЕсли;

	Если пПроверятьИмяБазы
		И Не ЗначениеЗаполнено( _ИмяБазы ) Тогда
		
		_Лог.Ошибка( "Имя базы для бекапа не указано" );
		отказ = Истина;
		
	КонецЕсли;

	Возврат Не отказ;

КонецФункции

Функция ВыполнитьБекап( Знач пИмяФайлаБекапа ) Экспорт
	
	отказ = Ложь;

	Если Не ПроверитьЗаполнение( Истина ) Тогда
		отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено( пИмяФайлаБекапа ) Тогда
		
		_Лог.Ошибка( "Файл для бекапа не указан" );
		отказ = Истина;
		
	КонецЕсли;

	Если отказ Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	параметрСТекстомЗапроса = "-Q""" + ТекстЗапроса_ВыполнитьБекап( пИмяФайлаБекапа ) + """";
	
	Возврат ВыполнитьЧерезSQLCMD( параметрСТекстомЗапроса );
	
КонецФункции

Функция ПолучитьКоличествоСоединений() Экспорт
	
	Если Не ПроверитьЗаполнение( Истина ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	//параметрСТекстомЗапроса = "-Q""" + ТекстЗапроса_ВыполнитьБекап( _ИмяБазы, пИмяФайлаБекапа ) + """";
	
	//Возврат ВыполнитьЧерезSQLCMD( параметрСТекстомЗапроса );

КонецФункции

Функция ВыполнитьСкрипт( Знач пИмяФайлаСкрипта ) Экспорт
	
	отказ = Ложь;

	Если Не ПроверитьЗаполнение( Истина ) Тогда
		отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено( пИмяФайлаСкрипта ) Тогда		
		_Лог.Ошибка( "Файл скрипта не указан" );
		отказ = Истина;		
	КонецЕсли;

	Если отказ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	текстЗапроса = ОбщегоНазначения.ПолучитьТекстИзФайла( пИмяФайлаСкрипта );
	
	Если текстЗапроса = Ложь Тогда
		_Лог.Ошибка( "Не удалось прочитать текст запроса из " + пИмяФайлаСкрипта );
		Возврат Ложь;
	КонецЕсли;
	
	параметрСТекстомЗапроса = "-i """ + пИмяФайлаСкрипта + """";
	
	Возврат ВыполнитьЧерезSQLCMD(параметрСТекстомЗапроса);
	
КонецФункции

Функция ВыводКоманды() Экспорт
	Возврат _ВыводКоманды;
КонецФункции

Функция ТекстЗапроса_ВыполнитьБекап( Знач пИмяФайла)
	
	шаблонЗапросБекапа = "BACKUP DATABASE [%1] TO  DISK = N'%2' WITH NOFORMAT, INIT,  NAME = N'%1 FULL Backup', SKIP, NOREWIND, NOUNLOAD,COMPRESSION, STATS = 10";
	Возврат СтрШаблон( шаблонЗапросБекапа, _ИмяБазы, пИмяФайла);
	
КонецФункции

Функция ВыполнитьЧерезSQLCMD( Знач пПараметрСТекстомЗапроса )
	
	командаЗапуска = Новый Команда;
	
	Если _Лог.Уровень() = УровниЛога.Отладка Тогда
		
		логКомандыЗапуска = Логирование.ПолучитьЛог(командаЗапуска.ИмяЛога());
		логКомандыЗапуска.УстановитьУровень(УровниЛога.Отладка);
		
	КонецЕсли;
	
	командаЗапуска.УстановитьКоманду("sqlcmd");
	командаЗапуска.ДобавитьПараметр("-S" + _Сервер);
	командаЗапуска.ДобавитьПараметр("-U" + _Пользователь);
	командаЗапуска.ДобавитьПараметр("-P" + _Пароль);
	командаЗапуска.ДобавитьПараметр( пПараметрСТекстомЗапроса );
	командаЗапуска.ДобавитьПараметр("-b");
	
	командаЗапуска.УстановитьИсполнениеЧерезКомандыСистемы( Ложь );
	
	кодВозврата = командаЗапуска.Исполнить();
	
	Если КодВозврата = 0 Тогда
		_ВыводКоманды = командаЗапуска.ПолучитьВывод();
	Иначе
		_Лог.Ошибка(командаЗапуска.ПолучитьВывод());
	КонецЕсли;
	
	Возврат кодВозврата = 0;
	
КонецФункции

_Лог = Логирование.ПолучитьЛог(ИмяЛога());
_ВыводКоманды = "";

