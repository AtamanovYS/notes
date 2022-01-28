// Быстрая процедурау сравнения коллекций
// За секунд 10-20 получается дельта двух ТЗ, в которых почти 400 тысяч строк
// За основу взят код на просторах, доработан и дооформлен

// Процедура сравнивает две таблицы значений с выводом разницы по каждой из строк
// Работает быстро, потому что основана на платформенном механизме сворачиваниия ТЗ
// 
// Параметры:
//  Таблица1 - Сравниваемая коллекция произвольного типа (если это не ТаблицаЗначений, то у переменной должен быть метод Выгрузить())
//  Таблица2 - Сравниваемая коллекция произвольного типа (если это не ТаблицаЗначений, то у переменной должен быть метод Выгрузить())
//  МассивСтрокиТаблицы1 - Массив строк таблицы значений, в котором хранятся строки первой таблицы, которые отличаются от строк второй таблицы
//  МассивСтрокиТаблицы2 - Массив строк таблицы значений, в котором хранятся строки второй таблицы, которые отличаются от строк первой таблицы
//  ПереченьКолонок - Строка, перечень колонок, разделенных запятыми, которые сравниваются, если не указано, то сравниваются все
//  ИсключемыеКолонки - Строка, перечень колонок, разделенных запятыми, которые не будут участвовать в сравнении
//  УчитыватьПорядок - Булево, признак, по которому определяется, нужно ли при сравнении учитывать нумерацию строк или нет	
//
Процедура НайтиОтличияТаблиц(Таблица1, Таблица2, МассивСтрокиТаблицы1 = Неопределено, МассивСтрокиТаблицы2 = Неопределено, ПереченьКолонок = "", ИсключемыеКолонки = "", УчитыватьПорядок = Ложь)
	
	Если ТипЗнч(Таблица1) <> Тип("ТаблицаЗначений") Тогда
		Таблица1 = Таблица1.Выгрузить();
	КонецЕсли;
	
	Если ТипЗнч(Таблица2) <> Тип("ТаблицаЗначений") Тогда
		Таблица2 = Таблица2.Выгрузить();
	КонецЕсли;
	
    СтруктураИсключаемыеКолонки = Новый Структура(ИсключемыеКолонки);
    
    Если ЗначениеЗаполнено(ПереченьКолонок) Тогда            
        Если ЗначениеЗаполнено(ИсключемыеКолонки) Тогда
            РеальныйПереченьКолонок = "";
            СтруктураПереченьКолонок = Новый Структура(ПереченьКолонок);
            
            Для каждого ЭлементСтруктуры Из СтруктураПереченьКолонок Цикл
                ИмяКолонки = ЭлементСтруктуры.Ключ;
                Если Не СтруктураИсключаемыеКолонки.Свойство(ИмяКолонки) Тогда
                    РеальныйПереченьКолонок = РеальныйПереченьКолонок + ?(РеальныйПереченьКолонок = "", "", ", ") + ИмяКолонки;
                КонецЕсли;
            КонецЦикла;
        Иначе
            РеальныйПереченьКолонок = ПереченьКолонок;
        КонецЕсли;         
    Иначе
        
        РеальныйПереченьКолонок = "";
        
        Если ТипЗнч(Таблица1) = Тип("ТаблицаЗначений") Тогда
            Колонки = Таблица1.Колонки;
        Иначе
            Колонки = Таблица1.ВыгрузитьКолонки().Колонки;
        КонецЕсли;
        
        Для каждого Колонка Из Колонки Цикл
            Если Не СтруктураИсключаемыеКолонки.Свойство(Колонка.Имя) Тогда
                РеальныйПереченьКолонок = РеальныйПереченьКолонок + ?(РеальныйПереченьКолонок = "", "", ", ") + Колонка.Имя;
            КонецЕсли;
        КонецЦикла;
        
    КонецЕсли;

    Если ТипЗнч(Таблица1) = Тип("ТаблицаЗначений") Тогда
        ТаблицаОбщая = Таблица1.Скопировать(, РеальныйПереченьКолонок);
    Иначе
        ТаблицаОбщая = Таблица1.Выгрузить(, РеальныйПереченьКолонок);
    КонецЕсли;
	
    ТаблицаОбщая.Колонки.Добавить("Служебный_ПоказательТаблицы");
	ТаблицаОбщая.Колонки.Добавить("Служебный_ИндексСтроки");
	
	ИндексСтроки = 0;
    Для каждого СтрокаОбщейТаблицы Из ТаблицаОбщая Цикл
        СтрокаОбщейТаблицы.Служебный_ПоказательТаблицы = 1;
		СтрокаОбщейТаблицы.Служебный_ИндексСтроки = ИндексСтроки;	
		ИндексСтроки = ИндексСтроки + 1;
    КонецЦикла;
	
	ИндексСтроки = 0;
    Для каждого СтрокаТаблицы2 Из Таблица2 Цикл
        СтрокаОбщейТаблицы = ТаблицаОбщая.Добавить();
        ЗаполнитьЗначенияСвойств(СтрокаОбщейТаблицы, СтрокаТаблицы2);
        СтрокаОбщейТаблицы.Служебный_ПоказательТаблицы = 2;
		СтрокаОбщейТаблицы.Служебный_ИндексСтроки = ИндексСтроки;
		ИндексСтроки = ИндексСтроки + 1;
    КонецЦикла;
	
    Если УчитыватьПорядок Тогда
        ТаблицаОбщая.Свернуть("Служебный_ИндексСтроки, " + РеальныйПереченьКолонок, "Служебный_ПоказательТаблицы");
    Иначе
        ТаблицаОбщая.Свернуть(РеальныйПереченьКолонок, "Служебный_ПоказательТаблицы");
    КонецЕсли;
	
    // Строки ОбщейТаблицы, у которых Служебный_ПоказательТаблицы = 3, это совпавшие строки Таблицы1 и Таблицы2
	
    МассивСтрокиТаблицы1 = Новый Массив;
    СтрокиСПоказателем1 = ТаблицаОбщая.НайтиСтроки(Новый Структура("Служебный_ПоказательТаблицы", 1));
    Для каждого СтрокаОбщейТаблицы Из СтрокиСПоказателем1 Цикл
        МассивСтрокиТаблицы1.Добавить(СтрокаОбщейТаблицы);
    КонецЦикла;
    
    МассивСтрокиТаблицы2 = Новый Массив;
    СтрокиСПоказателем2 = ТаблицаОбщая.НайтиСтроки(Новый Структура("Служебный_ПоказательТаблицы", 2));
    Для каждого СтрокаОбщейТаблицы Из СтрокиСПоказателем2 Цикл
        МассивСтрокиТаблицы2.Добавить(СтрокаОбщейТаблицы);
    КонецЦикла;
       	    
КонецПроцедуры
