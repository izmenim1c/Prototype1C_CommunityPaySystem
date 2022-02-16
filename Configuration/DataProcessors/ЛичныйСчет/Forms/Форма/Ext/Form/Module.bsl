﻿&НаКлиенте
Процедура РаспределитьПоПроектамЗавершение(Результат,ДополнительныеПраметры) Экспорт
	ОбновитьСуммыНаФорме();	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРаспределитьПоПроектам(Команда)
	ОткрытьФорму("ОбщаяФорма.кплФормаРаспределенияСредствПоПроектам",,,,,,
		Новый ОписаниеОповещения("РаспределитьПоПроектамЗавершение",ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
	
&НаСервере
Процедура ОбновитьСуммыНаФорме()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗапросПоРегистрам.УчастникСделки КАК УчастникСделки,
	               |	СУММА(ЗапросПоРегистрам.СуммаВОФ) КАК СуммаВОФ,
	               |	СУММА(ЗапросПоРегистрам.СуммаПоПроектам) КАК СуммаПоПроектам
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		СделкиОбороты.УчастникСделки КАК УчастникСделки,
	               |		СделкиОбороты.СуммаВОбщественныйФондОборот КАК СуммаВОФ,
	               |		0 КАК СуммаПоПроектам
	               |	ИЗ
	               |		РегистрНакопления.Сделки.Обороты КАК СделкиОбороты
	               |	ГДЕ
	               |		СделкиОбороты.УчастникСделки = &УчастникСделки
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		кплРаспределениеСуммПоПроектамОбороты.УчастникСделки,
	               |		0,
	               |		кплРаспределениеСуммПоПроектамОбороты.СуммаОборот
	               |	ИЗ
	               |		РегистрНакопления.кплРаспределениеСуммПоПроектам.Обороты(, , , ) КАК кплРаспределениеСуммПоПроектамОбороты
	               |	ГДЕ
	               |		кплРаспределениеСуммПоПроектамОбороты.УчастникСделки = &УчастникСделки) КАК ЗапросПоРегистрам
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ЗапросПоРегистрам.УчастникСделки";
	
	Запрос.УстановитьПараметр("УчастникСделки",ПараметрыСеанса.ТекущийПользователь.ФизическоеЛицо );
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		СтрокаСумм = Результат.Выгрузить()[0];
		СуммаВОФ = СтрокаСумм.СуммаВОФ;
		СуммаРаспределить = СтрокаСумм.СуммаВОФ - СтрокаСумм.СуммаПоПроектам;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьСуммыНаФорме();
КонецПроцедуры
