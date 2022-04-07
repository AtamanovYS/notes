// Доработана типовая функция РазностьДат из ОбщегоНазначенияУТ.РазностьДат
// - Текущая функция может вызываться, как с сервера, так и с клиента (помещаем в клиент-серверный модуль)
// - Добавлено больше видов периодов, сам вид периода передается строкой, а не перечислением (так оптимальней + временных периодов нет у стандартного перечисления)

// Возвращает разницу между двумя датами с нужной периодичностью
//
// Параметры:
//  ДатаНачала - Дата - начальная дата периода
//  ДатаОкончания - Дата - конечная дата периода
//  Периодичность - Строка со следующими значениями:
//Год, Полугодие, Квартал, Месяц, Декада, Неделя, День, Час, Минута, Секунда        
//
// Возвращаемое значение:
//   Число - количество секунд/минут/час/дней/декад/недель/месяцев/кварталов/полугодий/годов между двумя датами
//
Функция РазностьДат(ДатаНачала, ДатаОкончания, Периодичность = "День") Экспорт
	
	СекундВМинуте = 60;
	МинутВЧасе = 60;
	ЧасовВДне = 24;
	
	Если Периодичность = "Год" Тогда
		Возврат Год(ДатаОкончания) - Год(ДатаНачала);
		
	ИначеЕсли Периодичность = "Полугодие" Тогда
		Возврат ?(Месяц(ДатаОкончания)>6, 2, 1) - ?(Месяц(ДатаНачала)>6, 2, 1) + 2*(Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = "Квартал" Тогда
		Возврат Цел(Месяц(НачалоКвартала(ДатаОкончания))/3) - Цел(Месяц(НачалоКвартала(ДатаНачала))/3) + 4*(Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = "Месяц" Тогда
		Возврат Месяц(ДатаОкончания) - Месяц(ДатаНачала) + 12*(Год(ДатаОкончания) - Год(ДатаНачала));
		
	ИначеЕсли Периодичность = "Декада" Тогда
		Возврат Цел((ДатаОкончания - ДатаНачала)/(10 * СекундВМинуте*МинутВЧасе*ЧасовВДне));
		
	ИначеЕсли Периодичность = "Неделя" Тогда
		Возврат Цел((НачалоНедели(ДатаОкончания) - НачалоНедели(ДатаНачала))/(7 * СекундВМинуте*МинутВЧасе*ЧасовВДне));
		
	ИначеЕсли Периодичность = "День" Тогда
		Возврат (ДатаОкончания - ДатаНачала)/(СекундВМинуте*МинутВЧасе*ЧасовВДне);
		
	ИначеЕсли Периодичность = "Час" Тогда
		Возврат (ДатаОкончания - ДатаНачала)/(СекундВМинуте*МинутВЧасе);	
		
	ИначеЕсли Периодичность = "Минута" Тогда
		Возврат (ДатаОкончания - ДатаНачала)/(СекундВМинуте);
		
	ИначеЕсли Периодичность = "Секунда" Тогда
		Возврат ДатаОкончания - ДатаНачала;
	
	КонецЕсли;
	
КонецФункции
