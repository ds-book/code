##### Опрятные данные #####

library(tidyverse)
library(tidyr)
library(dplyr)
library(stringr)
library(lubridate)

##### Заголовки столбцов содержат значения, а не названия переменных #####

# Здесь три переменных: Страна, Возраст, Количество пациентов
# Нужно развернуть таблицу - превратить столбцы в строки.

# Исходная таблица
raw <- readRDS("1.rds")
head(raw)

# Опрятная таблица
res <- readRDS("1_res.rds")
head(res)

# Разворачивать таблицу будем с помощью функции pivot_longer из пакета tidyr
# Укажем, какие конкретно столбцы будем разворачивать и сразу зададим новые имена столбцов
res <- pivot_longer(raw,
                    cols = "<18":">80", # Какие столбцы разворачиваем
                    names_to = "ages",  # Названия запишем в столбец ages
                    values_to = "count" # Значения запишем в столбец count
)
head(res)



##### Несколько переменных сохранены в одном столбце #####

# Здесь m - кодирует мужской пол, f - женский, число - возраст.
# Нужно разделить на такие переменные.
# На первом этапе нужно развернуть таблицу.
# На втором - выделить новые столбцы.

# Исходная таблица
raw <- readRDS("2.rds")
head(raw)

# Ожидаемый результат
res <- readRDS("2_res.rds")
head(res)

# Разворачиваем таблицу, чтобы столбцы с полом и возрастом стали строками
dt <- pivot_longer(raw,   
                   cols = -c("country", "year"), # Столбцы country и year не нужно разворачивать
                   names_to = "sexages",  
                   values_to = "count",
                   values_drop_na = TRUE  # Исключим пропущенные значения
)
head(dt)

# Выделяем пол в новый столбец, на основании первого символа
?str_sub

dt$sex <- str_sub(dt$sexages, 1, 1)
head(dt)

# Создаем вектор для перекодировки
ages <- c("04" = "0-4",
          "514" = "5-14",
          "014" = "0-14",
          "1524" = "15-24",
          "2534" = "25-34",
          "3544" = "35-44",
          "4554" = "45-54",
          "5564" = "55-64",
          "65" = "65+",
          "u" = NA)
# Столбец с возрастом в виде фактора
dt$age <- factor(ages[str_sub(dt$sexages, 2)], levels = ages)
head(dt)

# Оставляем только необходимые для анализа столбцы в нужном порядке
res <- dt %>% select(-sexages)
head(res)

##### Переменные и данные записаны в заголовках столбцов #####

household

res <- pivot_longer(household,
                    cols = !family,                  # Исключаем столбец из разворота
                    names_to = c(".value", "child"), # Первый сегмент используем для столбца, второй как значение
                    names_sep = "_",                 # Разделитель сегментов
                    values_drop_na = TRUE
)
head(res)

##### Переменные хранятся как в строках, так и в столбцах #####

# Набор данных содержим минимальную и максимальную температуру пациентов
# по дням в течении года
# Есть переменные в столбцах (id, year, month),
# распределенные среди столбцов (day, d1-d31), распределенные среди строк.
# При этом столбец element содержит названия переменных.
# Нужно развернуть таблицу так, чтобы года, месяцы и дни превратились в
# нормальную дату. Перенести значения столбца element в столбцы.

# Исходная таблица
raw <- readRDS("3.rds")
head(raw)

# Ожидаемый результат
res <- readRDS("3_res.rds")
head(res)

# Разворачиваем таблицу так, чтобы дни оказались в строках
dt <- pivot_longer(raw,
                   cols = starts_with("d"),
                   names_to = "day",
                   values_to = "temp",
                   values_drop_na = TRUE
)
head(dt)

# Сделаем новый столбец, с числовым значением дня
dt$day <- as.integer(str_replace(dt$day, "d", ""))
head(dt)

# Создадим столбец с полноценной датой
dt$date <- as.Date(ISOdate(dt$year, dt$month, dt$day))

# Оставляем только нужные столбцы
dt <- select(dt, c("id", "date", "element", "temp"))
head(dt)

# Теперь нужно превратить тип нашей температуры (минимальную и максимальную),
# записанную в строках превратить в отдельные переменные, т.е. в столбцы
res <- pivot_wider(dt, 
                   names_from = "element", # Названия новых столбцов берем из столбца element
                   values_from = "temp"    # Значения новых столбцов берем из столбца temp
)
head(res)



# Рассмотрим расширенный пример использования функции pivot_wider
# Создадим дубли значений в таблице
dbl <- rbind(dt, dt) %>% arrange(id, date, element)
head(dbl)

# Попробуем развернуть
res <- pivot_wider(dbl, names_from = "element", values_from = "temp")

# Развернем таблицу
# В функции можно указать агрегирующую функцию, которая будет использоваться,
# если при развороте в ячеке окажется несколько значений,
# а также функцию для пустых ячеек
res <- pivot_wider(dbl, names_from = "element", values_from = "temp",
                   values_fn = max, # Берем максимальное из значений
                   values_fill = 0  # Пропуски заполняем нулями
) 
head(res)


##### Несколько типов наблюдений хранится в одной таблице (пациенты и препараты) #####

# Исходная таблица
raw <- readRDS("5.rds")
head(raw)

# Ожидаемый результат
res_patients <- readRDS("5_res_patients.rds")
head(res_patients)

res_drugs <- readRDS("5_res_drugs.rds")
head(res_drugs)


# Наблюдения о пациентах
head(raw[c("patient", "gender", "age", "city")])

# Наблюдения о препаратах
head(raw[c("drug", "date", "dosage", "frequency")])

# Выберем уникальные значения для таблицы пациентов
patients <- distinct(raw[c("patient", "gender", "age", "city")])
head(patients)

# Сделаем номера строк столбцом с идентификатором
patients$id <- 1:nrow(patients)
patients <- relocate(patients, id, .before = patient)
head(patients)

# Добавим идентификатор пациента к исходной таблице чтобы сделать таблицу с антибиотиками
drugs <- left_join(raw, patients)
head(drugs)

# Переименуем столбец, чтобы стало понятнее
drugs <- rename(drugs, "patient_id" = "id")
head(drugs)

# Удалим столбцы про пациентов
drugs <- select(drugs, -c("patient", "gender", "age", "city"))
head(drugs)

# Создадим идентификаторы уже для препаратов
drugs$id <- 1:nrow(drugs)
drugs <- relocate(drugs, id, .before = drug)
head(drugs)

# Переместим его в начало таблицы
head(drugs)

# Теперь у нас есть отдельные таблицы для каждого типа наблюдений
head(patients)
head(drugs)

# При необходимости мы можем объединить их обратно
combo <- inner_join(patients, drugs,              # Объединяем две таблицы
                    by = c("id" = "patient_id"))  # Столбцы сопоставления
head(combo)

# Чтобы сделать возможное переименование столбцов более предсказуемым, можно определить суффиксы для таблиц
combo <- inner_join(patients, drugs,                 # Объединяем две таблицы
                    by = c("id" = "patient_id"),     # Столбцы сопоставления
                    suffix = c("_patient", "_drug")) # Суффиксы для таблиц
head(combo)



##### Один тип наблюдения хранится в разных таблицах #####

# В простейшем случае объединения можно использовать rbind

# Прочитаем файлы
data1 <- read.csv2("data_center_1.csv", encoding = "UTF-8")
nrow(data1)
data2 <- read.csv2("data_center_2.csv", encoding = "UTF-8")
nrow(data2)
data3 <- read.csv2("data_center_3.csv", encoding = "UTF-8")
nrow(data3)

# Обозначим источники данных
data1$center_id <- "center 1"
data2$center_id <- "center 2"
data3$center_id <- "center 3"
# Объединим таблицы
data_all <- rbind(data1, data2, data3)
nrow(data_all)

# Можно пакетно обрабатывать сразу несколько файлов с диска, без указания конкретного имени

# Получаем список файлов
paths <- dir(path = ".",               # Путь к папке, где ищем файлы - текущая
             pattern = "data_center*", # Нам нужны файлы, которые начинаются с data_center
             full.names = TRUE)        # Использовать полные пути к файлам
head(paths)

# Создаем именованный вектор, чтобы использовать имена файлов
names(paths) <- basename(paths)
paths

# Читаем все файлы в один датафрейм
csv <- do.call(rbind, lapply(paths, read.csv2))
head(csv)

# Перенесем rowid в отдельный столбец
csv <- csv %>% mutate(id = rownames(.))
# Сбросим названия строк - они нам больше не нужны
rownames(csv) <- NULL
head(csv)

# Сформируем столбец с названием файла
csv <- separate(csv,
                col = id,                          # Берем столбец id
                into = c("center", "row_number"),  # Разделяем на два столбца
                sep = ".csv.")                     # Разделитель
head(csv)

# Сгенерируем уникальный идентификатор и переместим в начало таблицы
csv <- csv %>% mutate(id = 1:nrow(.)) %>% relocate(id)
head(csv)





##### Валидация данных #####

library(validate)
library(tidyverse)

people <- read.csv("people.txt", stringsAsFactors = FALSE)
print(people)

# Попробуем найти выбросы возраста
people[which(!(people$age >= 0 & people$age <= 100)),]
people

# Присвоим значение-заглушку
people[which(!(people$age >= 0 & people$age <= 150)), "age"] <- -1
people

# Оставим только строки с корректным возрастом
data_good <- people[people$age >= 0 & people$age <= 150,]
data_good <- filter(people, age >= 0 & age <= 150)
data_good
data_bad <- filter(people, !(age >= 0 & age <= 150))
data_bad

# Оставим в исходной таблице те строки, которые корректны
people <- people[!(people$id %in% data_bad$id), ]
people

##### Валидация данных с пакетом validate #####

library(validate)

people <- read.csv("people.txt", stringsAsFactors = FALSE)
print(people)

# Зададим набор правил валидации
rules <- validator(
  # Идентификатор должен быть уникальным
  unique_id = is_unique(id), 
  # Возраст не может быть пустым
  empty_age = !is.na(age),    
  # Рост должен записываться в формате 1.78
  height_format = number_format(height, max_digit = 2, min_dig = 2),
  # Возраст может быть от 0 до 150
  normal_age = age >= 0 & age <= 150,
  # Брак не может быть заключен до 18 лет
  marriage_check = (status != "single" & age >= 18) | (status == "single"),
  # Человек либо взрослый, либо ребенок
  agegroup_check = agegroup %in% c("child", "adult"),
  # Должны быть обязательно заполнены id, возраст и рост
  fullfil_columns = is_complete(id, age, height),
  # Длительность брака меньше 0 может быть только у холостых
  marriage_length = if (status == "single") is.na(yearsmarried) else yearsmarried >= 0,
  # Рост должен быть числом (работает на весь набор данных)
  numeric_height = is.numeric(height),
  # Медиана возраста не может быть меньше 14 (работает на весь набор данных)
  mean_age = mean(age, na.omit = TRUE) >= 14
)

# Прогоним правила по набору данных и посмотрим результат
res <- confront(people, rules)

# В текстовом виде
summary(res)

# В графическом виде
plot(res)

# В виде списка матриц
values(res)

# В виде датафрейма
as.data.frame(values(res))

# Какие строки не прошли валидацию
violating(people, rules)
# Работает только на правила для строк
data_bad <- violating(people, rules[1:8])
data_bad

# Какие строки прошли валидацию
data_good <- satisfying(people, rules[1:8])
data_good

# Выберем строки, которые не прошли правило на допустимый диапазон возраста
data_bad <- violating(people, rules["normal_age"])
data_bad

# Сохранение валидатора в файл
export_yaml(rules, file = "my_rules.yaml")
# Чтение валидатора из файла
new_rules <- validator(.file = "my_rules.yaml")


##### Отчет о валидации с пакетом data.validation #####

if (!require(data.validator))  install.packages("data.validator")
library(data.validator)

if (!require(assertr))  install.packages("assertr")
library(assertr)

library(dplyr)
library(validate)

people <- read.csv("people.txt", stringsAsFactors = FALSE)

# Создаем отчет, в который будем писать
report <- data_validation_report()

# Создаем цепочку функций валидаций
validate(people, description = "Отчет валидации данных пациентов") %>% 
  # Валидация переменных (столбцов)
  validate_cols(description = "Идентификатор должен быть уникальным", is_unique, id) %>% 
  validate_cols(description = "Возраст не может быть пустым", not_na, age) %>% 
  validate_cols(description = "Возраст может быть от 0 до 150", within_bounds(0, 150), age) %>% 
  validate_cols(description = "Рост должен быть числом", is.numeric, height) %>% 
  # Валидация строк
  # validate_rows(description = "Должны быть обязательно заполнены id, возраст и рост",
  #               row_reduction_fn = is_complete, within_bounds(0, 2), vs:am) %>%
  # Валидация по условиям
  validate_if(description = "Брак не может быть заключен до 18 лет", (status != "single" & age >= 18) | (status == "single")) %>%
  validate_if(description = "Человек либо взрослый, либо ребенок", agegroup %in% c("child", "adult")) %>%
  validate_if(description = "Должны быть обязательно заполнены id, возраст и рост", is_complete(id, age, height)) %>%
  validate_if(description = "Длительность брака меньше 0 может быть только у холостых", if (status == "single") is.na(yearsmarried) else yearsmarried >= 0) %>%
  validate_if(description = "Медиана возраста не может быть меньше 14 ", mean(age, na.omit = TRUE) >= 14) %>%
  # Выводим все в отчет
  add_results(report)

# Выводим результат в консоль
print(report)
# Сохраняем отчет в файл
save_report(report, "validation_report.html")
browseURL("validation_report.html")
