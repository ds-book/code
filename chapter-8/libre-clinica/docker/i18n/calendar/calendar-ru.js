// full day names
Calendar._DN = new Array
("Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье");
// short day names
Calendar._SDN = new Array
("ВСК", "ПНД", "ВТР", "СРД", "ЧТВ", "ПТН", "СБТ", "ВСК");
// First day of the week. "0" means display Sunday first, "1" means display
// Monday first, etc.
Calendar._FD = 1;
// full month names
Calendar._MN = new Array
("Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь");
// short month names
Calendar._SMN = new Array
("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "About the calendar";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"For latest version visit: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Выбор даты:\n" +
"- Используйте \xab, \xbb кнопки, чтобы выбрать год\n" +
"- Используйте " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " кнопки, чтобы выбрать месяц\n" +
"- Удерживайте кнопку мыши над любой из кнопок для быстрого выбора.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Выбор времени:\n" +
"- Нажмите на любую часть времени, чтобы увеличить ее\n" +
"- или с нажатой клавишей Shift для уменьшения\n" +
"- или кликните и перетащите для быстрого выбора.";

Calendar._TT["PREV_YEAR"] = "Предыдущий год";
Calendar._TT["PREV_MONTH"] = "Предыдущий месяц";
Calendar._TT["GO_TODAY"] = "Сегодня";
Calendar._TT["NEXT_MONTH"] = "Следующий месяц";
Calendar._TT["NEXT_YEAR"] = "Следующий год";
Calendar._TT["SEL_DATE"] = "Выберите дату";
Calendar._TT["DRAG_TO_MOVE"] = "Перетащите";
Calendar._TT["PART_TODAY"] = " (сегодня)";

// the following is to inform that "%s" is to be the first day of week
// %s will be replaced with the day name.
Calendar._TT["DAY_FIRST"] = "Display %s first";

// This may be locale-dependent.  It specifies the week-end days, as an array
// of comma-separated numbers.  The numbers are from 0 to 6: 0 means Sunday, 1
// means Monday, etc.
Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Закрыть";
Calendar._TT["TODAY"] = "Сегодня";
Calendar._TT["TIME_PART"] = "(Shift-)Click or drag to change value";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%Y-%m-%d";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "нд";
Calendar._TT["TIME"] = "Время:";