if (!require(tidyverse)) install.packages("tidyverse")
if (!require(data.table)) install.packages("data.table")

# Зададим настройки отображения дробных чисел в tibble
options(pillar.sigfig = 8)

#### Как открыть файл в R ####

# Открыть текстовый файл
data_csv <-
  read.table(
    file = "crf.csv",    # Название файла
    header = TRUE,            # В файле есть заголовок
    sep = ",",                # Разделитель полей
    quote = '"',              # Ограничитель текста
    na.strings = "",          # Замена для пустых полей
    stringsAsFactor = FALSE,  # Читать строки как фактор
    encoding = "Windows-1251" # Кодировка текста
  )

# Для чтения текстовых файлов удобно использовать пакет `readr`
if (!require(readr)) install.packages(readr)

##### Файл TSV #####

# Чтение с read.table
tsv1 <- read.table("data.tsv",
                   header = TRUE, # Первая строка содержит заголовки
                   quote = "",    # Ограничитель текста: отсутствует
                   sep = "\t",    # Разделитель столбцов: табуляция
                   dec =".")      # Десятичный разделитель: точка .
head(tsv1)
str(tsv1)

tsv2 <- read_tsv("data.tsv")
head(tsv2)
str(tsv2)


##### Файл CSV #####

# Чтение с read.table
csv1 <- read.table("data_comma.csv",
                   header = TRUE, # Первая строка содержит заголовки
                   quote = '"',   # Ограничитель текста: кавычки "
                   sep = ",",     # Разделитель столбцов: запятая ,
                   dec ="." )     # Десятичный разделитель: точка .

# Псевдоним для read.table
csv2 <- read.csv("data_comma.csv")
head(csv2)
str(csv2)

# Чтение с readr
csv3 <- read_csv("data_comma.csv")
head(csv2)
str(csv2)


##### Файл CSV2 #####

# Чтение с read.table
csv1 <- read.table("data_semi.csv",
                   header = TRUE, # Первая строка содержит заголовки
                   quote  = '"',   # Ограничитель текста: кавычки "
                   sep   = ";",     # Разделитель столбцов: точка с запятой ;
                   dec ="," )     # Десятичный разделитель: запятая ,
head(csv1)
str(csv1)

# Псевдоним для read.table
csv2 <- read.csv2("data_semi.csv")
head(csv2)
str(csv2)

# Чтение с readr
csv3 <- read_csv2("data_semi.csv")
head(csv3)
str(csv3)


##### Особенности пакета readr #####

# Определение типов столбцов
data_csv <- read_csv("crf.csv",
                     skip = 1,
                     col_names = c("case", "sex", "birthdate", "datestart", "height", "weight", "is_complete", "material", "unique_id"),
                     col_types = "ccDTnilcc")
head(data_csv)
str(data_csv)

##### Кодировка файлов #####

# Открыть CSV с разделителями запятыми (по умолчанию кодировка UTF-8)
data_csv <- read.csv2("crf-excel-utf8.csv")
head(data_csv)

data_csv <- read.csv2("crf-excel-utf8.csv", encoding = "UTF-8")
head(data_csv)


# Открыть CSV с разделителями точка с запятой (как в Excel)
data_csv <- read.csv2("crf-excel-1251.csv")

# Открыть CSV с разделителями точка с запятой (как в Excel с указанием кодировки)
data_csv <- read.csv2("crf-excel-1251.csv", encoding = "Windows-1251")

##### Файл Excel #####

library(readxl)
data_xls <-  read_excel("crf.xlsx")

data_xls <-  read_excel("crf.xlsx", sheet = "Sheet1")

data_zdr <- read_excel("zdr2-1.xlsx", 
                       sheet = "1", 
                       range = "A7:W24", 
                       col_names = c("Болезни", as.character(2000:2021)))

##### Файлы других форматов #####

if (!require(haven)) install.packages("haven")
library(haven)

# SAS
data_sas <- read_sas("medical.sas7bdat")

# SPSS
data_spss <- read_sav("accidents.sav")

# Stata
data_stata <- read_dta("medical.dta")


##### Загрузить таблицу из буфера обмена #####

copydat <- read.delim("clipboard")

#### Быстрая оценка набора данных ####

data <- read_csv("crf.csv")

# Типы данных столбцов
spec(data)

# Первые шесть строк
head(data)

# Последние шесть строк
tail(data)

# Показать структуру таблицы: список столбцов, тип данных и примеры значений
str(data)

# Показать метрики по столбцам таблицы
summary(data)

# Таблица частотности для одного столбца с текстовыми даннными
table(data$`Пол`)

# Таблицы сопряженности для двух столбцов
table(data$`Пол`, data$`Завершил исследование`)

#### Удаление пустых строк и столбцов ####

# Проверка на пустые значения в столбце

age <- c(18,56,NA)
is.na(age)

# Загрузим файл
data <- read.csv("crf_empty.csv")
# Проверим значения в столбце
table(data$`Пол`)
# Проверим на пропущенные значения
is.na(data$`Пол`)

# Заменим пустые строки на NA
data[data == ""]<-NA
# Проверим на пропущенные значения
is.na(data$`Пол`)

# Прочитаем файл с заменой пустых строк на NA
data <- read.csv("crf_empty.csv", na.strings = "")
# Проверим на пропущенные значения
is.na(data$`Пол`)

# Функции чтения файлов из пакета readr сразу производят такую замену
data <- read_csv("crf_empty.csv")
# Проверим на пропущенные значения
is.na(data$`Пол`)

# Прочитаем файл заново
data <- read.csv("crf_empty.csv", na.strings = "")
# Посчитаем количество столбцов в таблице
ncol(data)
# Посчитаем количество строк в таблице
nrow(data)
# Определяем, какие столбцы сколько содержат в себе пустых строк
colSums(is.na(data) | data == "")
# Получаем логический вектор, показывающий какие столбцы пустые
empty_columns <- colSums(is.na(data) | data == "") == nrow(data)
empty_columns
# Удаляем пустые столбцы из таблицы
data <- data[, !empty_columns]
# Посчитаем количество столбцов в таблице
ncol(data)

# Посчитаем количество строк в таблице
nrow(data)
# Получаем логический вектор, показывающий какие строки пустые
empty_rows <- rowSums(is.na(data) | data == "") == ncol(data)
empty_rows
# Удаляем пустые строки
data <- data[!empty_rows,]
# Посчитаем количество строк в таблице
nrow(data)

# Удаление строк с NA
library(tidyr)
?drop_na

nrow(data)

# Удалим строки где NA в столбце Пол
data <- drop_na(data, `Пол`)
nrow(data)

# Удалим все строки, где встречается NA
data <- drop_na(data)
nrow(data)

#### Добавление уникального идентификатора ####
data <- read_csv("crf.csv")

# Посмотрим на row_id
head(data)
rownames(data)

# Создадим уникальный идентификатор
data$id <- rownames(data)
str(data)

# Посмотрим на row_id в mtcars
head(mtcars)
rownames(mtcars)

# Создадим числовой уникальный идентификатор в виде номеров строк
data$id <- 1:nrow(data)
str(data)


#### Переименование столбцов ####

data <- read_csv("crf.csv")

# Показать имена столбцов
colnames(data)

# Переименование одного столбца
colnames(data)[1] <- "case_history"
colnames(data)

# Заменим пробел на нижнее подчеркивание и приведем к нижнему регистру
library(stringr)
colnames(data) <- tolower(str_replace(colnames(data), " ", "_"))
colnames(data)

# Автоматическое преобразование имен стобцов
if (!require(janitor)) install.packages("janitor")
library(janitor)
data <- read_csv("crf.csv")
colnames(data)
data <- clean_names(data)
colnames(data)


#### Замена пропущенных данных ####

library(janitor)

data <- read_csv("crf_empty2.csv")
data <- clean_names(data)
colnames(data)

# Удалим пустые строки и столбцы
data <- data[, !(colSums(is.na(data)) == nrow(data))]
data <- data[!(rowSums(is.na(data)) == ncol(data)),]

# Проверим на пропущенные значения
is.na(data$pol)

# Заполнение пропущенных значений
data[is.na(data)] <- ""
# Заполнение пустых значений
data[data == ""] <- "Не применимо"

# Замена пропущенных значений для каждого столбца
data[is.na(data$pol), ]$pol <- ""
data[data$material == "" | is.na(data$material), ]$material <- "Неуточненный"
data[is.na(data$ves), ]$ves <- -1
data[is.na(data$data_rozdenia), ]$data_rozdenia <- "01.01.1900"

# Для замены в текстовых столбцах может быть удобнее функция  str_replace_na
library(stringr)
?str_replace_na
data$pol <- str_replace_na(data$pol, "")

# Замена с использованием пакета tidyr
library(tidyr)
?replace_na

data <- replace_na(data, 
                   list(
                     pol = "", 
                     material = "Неуточненный", 
                     ves = -1, 
                     data_rozdenia = "01.01.1900")
)

# Замена пропущенных данных на основе существующих с использованием пакета tidyr
data <- read_csv2("therapy.csv")
head(data, 10)

# Восстановим даты для patient_id
library(tidyr)
?fill
data <- fill(data, date_start, .direction = "down")
head(data, 10)

#### Манипуляции со столбцами дат ####

data <- read_csv("crf.csv")
data <- clean_names(data)
str(data)

# Дату рождения представим как дату
data$date_birth <- as.Date(data$data_rozdenia, format = "%d.%m.%Y")
# Дату начала представим как дату и время
data$date_start <- as.POSIXct(data$data_nacala, format = "%Y-%m-%d %H:%M")

# Проверим результат
head(data[,c("data_rozdenia", "date_birth")])
head(data[,c("data_nacala", "date_start")])

# Использование пакета lubridate
data$date_birth <- dmy(data$data_rozdenia)
data$date_start <-  ymd_hms(data$data_nacala)

# Проверим результат
head(data[,c("data_rozdenia", "date_birth")])
head(data[,c("data_nacala", "date_start")])

str(data)

# Сделаем столбец с датой через неделю
data$date_next <- data$date_start + weeks(1)
head(data[,c("date_start", "date_next")])

# Расчет длительности
data$length <- difftime(data$date_next, data$date_start, units = "weeks")
head(data[,c("date_start", "date_next", "length")])

data$length <- as.numeric(difftime(data$date_next, data$date_start, units = "weeks"))
head(data[,c("date_start", "date_next", "length")])

# Расчет возраста
data$age <- interval(data$date_birth, data$date_start) / years(1)
head(data[,c("date_birth", "date_start", "age")])


#### Манипуляции с числовыми столбцами ####

v <- c("1", "1.5", "2,5")

# Преобразование текстового вектора в числовой
as.numeric(v)

# Преобразование с заменой десятичного разделителя
as.numeric(str_replace(v, ",", "."))

# Преобразование единиц измерения

data <- read_csv("crf.csv")
data <- clean_names(data)

# Оценим распределение по росту
summary(data$rost)

# Переведем рост в сантиметры
data$rost_cm <- ifelse(data$rost < 50, data$rost * 100, data$rost)

# Проверим результат
summary(data$rost_cm)
head(data[,c("rost", "rost_cm")])

# Запишем рост в метрах
data$rost <- data$rost_cm / 100

# Проверим результат
summary(data$rost)
head(data[,c("rost", "rost_cm")])

# Создадим столбец с индексом массы тела
data$imt <- data$ves / ( data$rost ^ 2)
summary(data$imt)

# Создадим функцию для расчета индекса массы тела
funcIMT <- function(weight_kg, height_m) { 
  weight_kg / ( height_m ^ 2)
}
# Создадим столбец с индексом массы тела
data$imt <- funcIMT(data$ves, data$rost)
summary(data$imt)

# Операции округления
4/3
# округление (до целой части)
round(4/3)
# до второго знака после запятой
round(4/3, 2)
# в большую сторону
ceiling(4/3)
# в меньшую сторону
floor(4/3)


# Расчет возраста
data$age <- interval(dmy(data$data_rozdenia), data$data_nacala) / years(1)
head(data[,c("data_rozdenia", "data_nacala", "age")])

# Округление возраста до количества полных лет
data$age_round <- floor(data$age)
head(data[,c("age", "age_round")])

# Округление индекса массы тела
data$imt_round <- round(data$imt, 1)
tail(data[,c("imt", "imt_round")])

# Категоризация

# Создаем пустой столбец
data$imt_text <- NA
# Начинаем заполнять новый столбец значениями
data$imt_text[data$age >= 18 & data$imt <= 16] <- 'Выраженный дефицит массы тела'
data$imt_text[data$age >= 18 & data$imt > 16 & data$imt <= 18.5] <- 'Недостаточная (дефицит) масса тела'
data$imt_text[data$age >= 18 & data$imt > 18.5 & data$imt <= 25] <- 'Норма'
data$imt_text[data$age >= 18 & data$imt > 25 & data$imt <= 30] <- 'Избыточная масса тела'
data$imt_text[data$age >= 18 & data$imt > 30 & data$imt <= 35] <- 'Ожирение первой степени'
data$imt_text[data$age >= 18 & data$imt > 35 & data$imt <= 40] <- 'Ожирение второй степени'
data$imt_text[data$age >= 18 & data$imt > 40] <- 'Ожирение третьей степени'
head(data[,c("age", "imt", "imt_text")])

# Заполним значения, которые не удалось определить
data$imt_text[is.na(data$imt_text)] <- "Не применимо"

# Создадим специальную функцию для перекодировки
funcImtText <- function(AgeYears, IMT) {
  ifelse(AgeYears >= 18 & IMT <= 16, 'Выраженный дефицит массы тела',
         ifelse(AgeYears >= 18 & IMT > 16 & IMT <= 18.5, 'Недостаточная (дефицит) масса тела',
                ifelse(AgeYears >= 18 & IMT > 18.5 & IMT <= 25 , 'Норма',
                       ifelse(AgeYears >= 18 & IMT > 25 & IMT <= 30, 'Избыточная масса тела',
                              ifelse(AgeYears >= 18 & IMT > 30 & IMT <= 35, 'Ожирение первой степени',
                                     ifelse(AgeYears >= 18 & IMT > 35 & IMT <= 40, 'Ожирение второй степени',
                                            ifelse(AgeYears >= 18 & IMT > 40, 'Ожирение третьей степени',
                                                   "Не применимо")))))))
}

# Применим фукнцию перекодирования
data$imt_text <- funcImtText(data$age, data$imt)
head(data[,c("age", "imt", "imt_text")])

#### Манипуляции с текстовыми столбцами #####

##### Висячие пробелы #####
data <- read.csv("crf_empty.csv")
data <- clean_names(data)
table(data$pol)
sort(unique(data$pol))
# Удалим висячие пробелы
data$pol <- str_trim(data$pol)
table(data$pol)
sort(unique(data$pol))

# Пакет readr решает проблему висячих пробелов автоматически
data <- read_csv("crf_empty.csv")
data <- clean_names(data)
table(data$pol)
sort(unique(data$pol))


##### Приведение к единому регистру #####

v <- c("нижний", "ВЕРХНИЙ", "Комбинировнный")
tolower(v)
toupper(v)

# Приводим к нижнему регистру
data$pol <- tolower(data$pol)
table(data$pol)

##### Дополнение строк #####
data$no_istorii_bolezni <- as.character(data$no_istorii_bolezni)
sort(data$no_istorii_bolezni)

# Дополним строки до 6 символов
data$no_istorii_bolezni <- str_pad(data$no_istorii_bolezni, width = 6, side = "left", pad = 0)
sort(data$no_istorii_bolezni)

##### Поиск и замена значений #####
v <- sort(unique(data$pol))
v
grep("муж", v)
grepl("муж", v)

grep("муж", v, value = TRUE)

# Заменим все значения, где встречается м на мужской
data$pol[grepl("м", data$pol, ignore.case = TRUE)] <- "male"
sort(unique(data$pol))

# Заменим все значения, где встречается ж на женский
data$pol[grepl("ж", data$pol, ignore.case = TRUE)] <- "female"
sort(unique(data$pol))

# Заменим все значения, где первый символ m
data$pol[grepl("^m", data$pol, ignore.case = TRUE)] <- "мужской"
sort(unique(data$pol))

# Заменим все значения, где первый символ f
data$pol[grepl("^f", data$pol, ignore.case = TRUE)] <- "женский"
sort(unique(data$pol))

# Поиск с использованием регулярных выражений
v <- c(
  "AACACA","BBCCBC","CCABBB","ABABAA","ACBCAA","BCACBC",
  "BABABA","CACABA","BBABAB","BCCBAB","CAABCC","BCCBCA",
  "CAAABA","BAABCB","CCABBC","ABABBA","CABAAC","CAABCC",
  "CABCAC","AABCAA","CAAACB","BBACCA","BCAAAB","BBACBC",
  "CCCCBC","ACABCA","BCBBBC","AABBCC","CCBBBB","BBABBA","BBCAAC"
)

# Значения, в которых встречается ABC
grep("ABC", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается 0 или более раз и есть C
grep("AB*C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается как минимум 1 раз и есть C
grep("AB+C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается 0 или 1 раз и есть C
grep("AB?C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается 2 и менее раз и есть C
grep("AB{,2}C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается 2 или более раз и есть C
grep("AB{2,}C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается от 1 до 2 раз и есть C
grep("AB{1,2}C", v, value = TRUE)

# Значения, в которых есть A, при этом B встречается 2 раза и есть C
grep("AB{2}C", v, value = TRUE)

# Значения, которые начинаются с А
grep("^A" , v, value = TRUE)

# Значения, которые оканчиваются на С
grep("C$" , v, value = TRUE)

# Значения, в которых между символами C и A есть любые два символа
grep("C..A" , v, value = TRUE)

# Значения, в которых 0 и более любых символов между C и A
grep("C.*?A" , v, value = TRUE)

# Значения, в которых как минимум 1 символ между C и A
grep("C.+A" , v, value = TRUE)

# Значения, в которых 3 символа между C и A
grep("C.{3}A" , v, value = TRUE)

v <- c("123abc", "abcdef", "abc123", "abc 123", "123456")

# Все значения, где встречаются цифры
grep("\\d" , v, value = TRUE)

# Все значения, где есть пробел
grep("\\s" , v, value = TRUE)

v <- c("A+B", "A-C", "A*B", "A/B")
# Найдем все значения, в которых втречается +
grep("\\+" , v, value = TRUE)

# Заменим пробел на точку
gsub("\\s" , replacement = ".",  v)

# Названия штатов, где встречаются z или p
grep("[zp]" , state.name, value = TRUE)

# Названия штатов, где встречаются b, c или d
grep(pattern = "[b-d]", state.name, value = TRUE)

# Названия штатов, которые оканчиваются на o или d
grep(pattern = "[od]$" , state.name, value = TRUE)

v <- c("123 abc", "a.b.c.d.e.f", "abc.123", "abc_123", "123456")
# Уберем все числа и знаки препинания, чтобы остались только буквы
gsub("[ _0-9\\.]", replacement = "", v)

# Выберем названия штатов, в которых есть th или la
grep(pattern = "(th|la)" , x = state.name , value = T)

# Выберем названия штатов, которые начинаются на New, а затем идет Y или J
grep(pattern = "^New (Y|J)" , x = state.name , value = T)

##### Разделение столбца #####

head(data[,c("material")])

# Разделение столбца с помощью str_split_fixed
library(stringr)
?str_split_fixed

splitted <- str_split_fixed(data$material, pattern = ": ", n = 2)
head(splitted)

data$loc <- str_split_fixed(data$material, ": ", n = 2)[, 1]
data$mat <- str_split_fixed(data$material, ": ", n = 2)[, 2]
head(data[,c("material", "loc", "mat")])

# Разделение столбца с помощью separate
library(tidyr)
?separate

# Удалим столбцы
data$loc <- NULL
data$mat <- NULL

data <- separate(data,   # таблица, в которой находятся столбцы
                 material,              # столбец, который требуется разделить
                 sep = ": ",            # разделитель, по которому будут делиться строки
                 remove = FALSE,        # удалять ли исходный столбец после разделения
                 into = c("loc", "mat") # названия столбцов с результатом разделения
)
head(data[,c("material", "loc", "mat")])

##### Объединение столбцов #####

?paste

data$loc_mat <- paste(data$loc, data$mat, sep = ": ")
head(data[,c("loc", "mat", "loc_mat")])

# NA будет объединяться как текст
paste("string", NA)

# Объединение с помощью str_c
library(stringr)
?str_c

str_c(c("a", NA, "b"), "-d")
paste0(c("a", NA, "b"), "-d")

str_replace_na(c("a", NA, "b"),"")
data$loc_mat <- str_c(
  str_replace_na(data$loc,""), 
  str_replace_na(data$mat,""),
  sep = ":")

#### Грамматика манипуляций с данными с использованием dplyr ####

library(dplyr)

##### Переименование #####
?rename

data <- read_csv("crf.csv")
colnames(data)
data <- rename(data, 
               "case_history" = "№ истории болезни",
               "date_birth" = "Дата рождения",
               "date_start" = "Дата начала",
               "sex" = "Пол",
               "weight" = "Вес",
               "height" = "Рост",
               "is_completed" = "Завершил исследование",
               "material" = "Материал"
)
colnames(data)

##### Выбор строк #####

?dplyr::filter

data_short <- filter(data, sex == "Мужской", weight > 70, height > 1.70)
head(data_short[,c("sex", "weight", "height")])

##### Сортировка #####

?arrange

data <- arrange(data, 
                desc(is_completed), # сортировка по убыванию
                date_start          # по умолчанию сортировка по возрастанию
)         
head(data[,c("case_history", "is_completed", "date_start")])
tail(data[,c("case_history", "is_completed", "date_start")])

##### Выбор отдельных столбцов ##### 

?select

data_compact <- select(data, case_history, date_birth, sex)
head(data_compact)

# Попробуем найти уникальные комбинации пола и статуса завршения
data_compact <- select(data, is_completed, sex)
head(data_compact)
# Проверим число строк
nrow(data_compact)
# Найдем уникальные комбинации
data_compact <- distinct(data_compact)
# Проверим число строк
nrow(data_compact)
head(data_compact)

##### Создание новых столбцов #####

?mutate

data <- mutate(data, 
               imt = weight / ( height ^ 2) ,
               age = interval(dmy(date_birth), date_start) / years(1)
)
head(data[,c("weight", "height", "imt", "date_birth", "date_start", "age")])

##### Перемещение столбцов #####

?relocate

head(data)

# По умолчанию функция помещает столбцы в начало таблицы
data <- relocate(data, unique_id)
head(data)

# Можно задать и более точную позицию
data <- relocate(data, imt, .after = weight)
head(data)

data <- relocate(data, age, .before = date_birth)
head(data)

# Можно выбирать столбцы для передвижения исключительно по типу

data <- relocate(data, where(is.character), .after = is_completed)
head(data)

data <- relocate(data, where(is.character), .after = where(is.numeric))
head(data)


##### Группировка #####

?summarize
?group_by

# Сгруппируем по статусу завершения
data_grouped <- group_by(data, is_completed)
# Посчитаем агрегирующие функции для возраста
data_summary <- summarize(data_grouped, 
                          min_age = min(age, na.rm = TRUE),
                          avg_age = mean(age, na.rm = TRUE),
                          max_age = max(age, na.rm = TRUE)
)
head(data_summary)

# Определим категорию индекса массы тела
data <- mutate(data, 
               imt_group = funcImtText(age, imt))
# Сгруппируем данные по статусу завершения и категории ИМТ
data_grouped <- group_by(data, is_completed, imt_group)
# Посчитаем агрегирующую функцию
data_summary <- summarize(data_grouped, total = n())
head(data_summary)

##### Конвейер обработки (пайплайн) #####

# Оператор пайп %>% позволяет записать несколько операций
data <- read_csv("crf.csv")
data <- rename(data, 
               "date_birth" = "Дата рождения",
               "date_start" = "Дата начала",
               "sex" = "Пол",
               "weight" = "Вес",
               "height" = "Рост",
               "is_completed" = "Завершил исследование")
data <- filter(data, sex == "Мужской")
data <- select(data, weight, height, date_birth, date_start, is_completed)
data <- mutate(data, 
               imt = weight / ( height ^ 2) ,
               age = interval(dmy(date_birth), date_start) / years(1))
data <- mutate(data, imt_group = funcImtText(age, imt))
data <- group_by(data, is_completed, imt_group)
data <- summarize(data, total = n())
data <- arrange(data, is_completed, desc(total), imt_group)

head(data)

# В одну
data <- read_csv("crf.csv") %>% 
  rename("date_birth" = "Дата рождения",
         "date_start" = "Дата начала",
         "sex" = "Пол",
         "weight" = "Вес",
         "height" = "Рост",
         "is_completed" = "Завершил исследование") %>% 
  filter(sex == "Мужской") %>% 
  select(weight, height, date_birth, date_start, is_completed) %>% 
  mutate(imt = weight / ( height ^ 2) ,
         age = interval(dmy(date_birth), date_start) / years(1)) %>% 
  mutate(imt_group = funcImtText(age, imt)) %>% 
  group_by(is_completed, imt_group) %>% 
  summarize(total = n()) %>% 
  arrange(is_completed, desc(total), imt_group)

head(data)

#### Работа с данными с использованием data.table ####

library(data.table)

# Скачаем и распакуем большой файл для теста
src <- "https://github.com/hadley/mexico-mortality/raw/master/deaths/deaths08.csv.bz2"
download.file(src, "deaths.csv.bz2", quiet = TRUE)

if (!require(R.utils)) install.packages("R.utils")
library(R.utils)
bunzip2("deaths.csv.bz2", "deaths.csv", remove = FALSE, skip = TRUE)

# Чтение с помощью стандартных функций
system.time( deaths_base <- read.csv("deaths.csv") )
# Чтение с помощью пакета readr
system.time( deaths_rdr <- read_csv("deaths.csv") )
# Чтение с помощью пакета data.table
system.time( deaths_dt <- fread("deaths.csv") )

nrow(deaths_dt)
class(deaths_dt)

# Создаем объект data.table
data <- read_csv("crf.csv")
dt <- data.table(data)
class(dt)
dt <- as.data.table(data)
class(dt)


##### Выбор отдельных столбцов ##### 

dt <- fread("crf.csv")
colnames(dt)
dt2 <- dt[, list(`Завершил исследование`, `Пол`, `Рост`, `Вес`, `Дата рождения`, `Дата начала`)]
colnames(dt2)

dt <- dt[, .(`Завершил исследование`, `Пол`, `Рост`, `Вес`, `Дата рождения`, `Дата начала`)]
colnames(dt)

##### Создание новых столбцов #####

# Создание одного столбца
dt <- dt[, `ИМТ`:=  `Вес` / ( `Рост` ^ 2)]
head(dt)

# Создание нескольких столбцов
dt <- dt[, c("ИМТ", "Возраст") :=  list(`Вес` / ( `Рост` ^ 2), interval(dmy(`Дата рождения`), `Дата начала`) / years(1))]
head(dt)

# Можно комбинировать выбор столбцов и создание новых в одной операции
dt <- dt[, .(`Завершил исследование`, `Пол`, `Рост`, `Вес`, `Возраст`, `ИМТ`, 
             `ИМТтекст` = funcImtText(`Возраст`, `ИМТ`)
)]
head(dt)

##### Переименование #####
dt <- dt[, list("is_completed" = `Завершил исследование`, 
                "height" = `Рост`,
                "weight" = `Вес`,
                "age" = `Возраст`,
                "imt" = `ИМТ`,
                "imt_text" = `ИМТтекст`)]
head(dt)

##### Выбор строк ##### 

# Выбор по условию
dt2 <- dt[is_completed == TRUE & age >= 18]
head(dt2)

# Выбор по условию и создание новых столбцов
dt <- dt[is_completed == TRUE & age >= 18, status := "Взрослые, завершившие"]
dt <- dt[is_completed == FALSE & age >= 18, status := "Взрослые, продолжающие"]
dt <- dt[is_completed == TRUE & age < 18, status := "Дети, завершившие"]
dt <- dt[is_completed == FALSE & age < 18, status := "Дети, продолжающие"]
head(dt)

##### Сортировка #####

?setorder

# Сортировка по одному столбцу
setorder(dt, age)
head(dt)

# Сортировка по двум столбцам
setorder(dt, -is_completed, age)
head(dt)
tail(dt)

##### Группировка #####

dtg <- dt[
  is_completed == TRUE,                 # Отбираем нужные строки
  .(min_age = min(age, na.rm = TRUE),   # Считаем агрегирующие функции
    mean_age = mean(age, na.rm = TRUE),
    max_age = max(age, na.rm = TRUE), 
    .N                                  # Считаем количество
  ),
  by = list(status, imt_text)         # Определяем столбцы группировки  
]
head(dtg)

# Группировка сразу по нескольким столбцам

?.SD
?lapply

dt <- fread("temperature.csv")
head(dt)

# Средняя температура по больнице
# Выберем только числовые столбцы
dtt <- dt[,.(morning, midday, evening)]
head(dtt)
# Применим функцию среднего для всех столбцов
dtt[, lapply(.SD, mean)]

# Средняя температура по дням
dtt <- dt[, .(day, morning, midday, evening)]
head(dtt)
dtt <- dtt[, lapply(.SD, mean), by = day]
setorder(dtt, day)
head(dtt)

# Средняя температура утром по дням
dtt <- dt[, .(day, morning, midday, evening)]
dtt <- dtt[, lapply(.SD, mean), by = day, .SDcols = "morning"]
setorder(dtt, day)
head(dtt)

dtt <- dt[, .(day, morning, midday, evening)]
dtt <- dtt[, lapply(.SD, mean), by = day, .SDcols = !c("midday", "evening")]
setorder(dtt, day)
head(dtt)

#### Особенности работы с data.table, data.frame, tibble ####

# Прочитаем файл
dt <- fread("temperature.csv")

# Присвоим объект dt новой переменной
dt_copy <- dt

# Добавим новый столбец в объект dt
dt[, new_column := "A"]

# Проверим объект dt
head(dt)

# Проверим объект dt_copy
head(dt_copy)

# Скопируем объект 
dt_copy <- copy(dt)
# Удалим столбец из dt
dt[, new_column := NULL]
# Проверим dt
head(dt)
# Проверим dt_copy
head(dt_copy)

# Создадим data.frame 
df <- as.data.frame(dt)
head(df)
# Скопируем data.frame
df_copy <- df
# удалим столбец patient_id из df
df$patient_id <- NULL
# Проверим содержимое df
head(df)
# Проверим содержимое df_copy
head(df_copy)


#### Сравнение dplyr и data.table ####

df <- data.frame(id = 1:10, 
                 is_completed = as.logical(sample(1:0, 10, replace = TRUE)),
                 age = sample(5:40, 10))
dt <- data.table(df)

# Выборка столбцов
select(df, id, age)

dt[, .(id, age)]

# Фильтрация строк
filter(df, age >= 18)

dt[age >= 18]

# Сортировка строк
arrange(df, desc(is_completed), age)

setorder(dt, -is_completed, age)
dt

# Группировка и агрегация
select(df, id, is_completed, age) %>%
  group_by(is_completed) %>%
  summarise(min_age = min(age, na.rm = TRUE),
            mean_age = mean(age, na.rm = TRUE),
            max_age = max(age, na.rm = TRUE),
            N = n()
  ) %>%
  arrange(desc(N))

dt[,
   .(minAge = min(age),
     meanAge = mean(age),
     maxAge = max(age),
     N = .N),
   by = is_completed] %>% 
  setorder(-N)

#### Объединение таблиц ####

?bind_rows

# Создадим тестовые таблицы
diseases1 <- data.frame(
  name = c("Александр", "Алексей", "Андрей"), 
  disease = c("диабет", "ангина", "отит")
)
diseases2 <- data.frame(
  name = c("Василиса", "Вероника", "Виктория"),
  disease = c("грипп", "тонзиллофарингит", "пневмония")
)
diseases2rev <- data.frame(
  disease = c("грипп", "тонзиллофарингит", "пневмония"),
  name = c("Василиса", "Вероника", "Виктория")
)
symptoms2 <- data.frame(
  name = c("Василиса", "Вероника", "Виктория"),
  symptom = c("слабость", "боль", "температура")
)

# Объединение строк из двух таблиц с одинаковыми столбцами
bind_rows(diseases1, diseases2)

# Объединение строк из двух таблиц с отличающимися столбцами
bind_rows(diseases2, symptoms2)

# Сохранение информации о таблице-источнике строк
bind_rows(list(
  "diseases 1" = diseases1, 
  "diseases 2" = diseases2,
  "symptoms 2" = symptoms2
), .id = "source")

# Объединение столбцов
?bind_cols

bind_cols(diseases1, diseases2)
bind_cols(diseases2, symptoms2)
bind_cols(diseases2, select(symptoms2, symptom))


#### Соединение таблиц ####

# Создадим тестовые таблицы
diseases <- data.frame(name = c("Михаил", "Иван", "Павел"), 
                       disease = c("диабет", "ангина", "отит"))
diseases

symptoms <- data.frame(name = c("Иван", "Павел", "Анна" ),
                       symptom = c("слабость", "боль", "температура"))
symptoms

##### inner join #####
?inner_join

inner_join(diseases, symptoms)

symptoms2 <- data.frame(patient_name = c("Иван", "Павел", "Анна" ),
                        symptom = c("слабость", "боль", "температура"))
inner_join(diseases, symptoms2, by = join_by(name == patient_name))

?merge

merge(x = diseases, y = symptoms)
merge(x = diseases, y = symptoms2)
merge(x = diseases, y = symptoms2, by.x = "name", by.y = "patient_name")

##### left join и right join #####
?left_join
?right_join

left_join(diseases, symptoms)
left_join(symptoms, diseases)

merge(x = diseases, y = symptoms, all.x = TRUE)

right_join(diseases, symptoms)
right_join(symptoms, diseases)

merge(x = diseases, y = symptoms, by = "name", all.y = TRUE)

##### full join #####

?full_join

full_join(diseases, symptoms)
merge(x = diseases, y = symptoms, by = "name", all = TRUE)


#### Разворот таблиц ####
library(tidyr)

?pivot_longer
?pivot_wider

data <- read_csv("temperature.csv")
head(data)

# Столбцы в строки 
data1 <- pivot_longer(data,
                      c("morning", "midday", "evening"), # Какие столбцы разворачиваем
                      names_to = "day_part",             # В этот столбец пишем названия
                      values_to = "temperature",         # В этот столбец пишем значения
                      values_drop_na = FALSE             # Игнорируем значения NA, если они встретятся
)
head(data1)

# Строки в столбцы

data2 <- pivot_wider(data1, 
                     names_from = "day_part",      # Из столбца day_part будет брать имена для новых столбцов
                     values_from = "temperature",  # Из столбца temperature будем брать значения для новых столбцов
                     values_fill = 0               # Если значения не будут найдены, чтобы не оставлять NA - запишем 0
)
head(data2)

#### Сохранение таблиц в файл ####

# Запись в буфер обмена
?write.table

write.table(data, "clipboard", sep="\t", row.names=FALSE)

# Сохранение в файл CSV
?write.csv2

write.csv2(data, "data_result.csv", row.names = FALSE)
tbl <- tibble(data)
write.csv2(data, "data_result.csv")

# Сохранение в файл Excel
if (!require(openxlsx)) install.packages("openxlsx")
library(openxlsx)
?write.xlsx

# Сохранение таблицы в Excel
write.xlsx(data, "data_result.xlsx", asTable = TRUE, overwrite = TRUE, sheetName = "data")

# Сохранение нескольких таблиц в Excel
tbls <- list("Data Sheet" = data, "Data Sheet 1" = data1, "Data Sheet 2" = data2)
write.xlsx(tbls, "data_result.xlsx", asTable = TRUE)

#### Сохранение таблиц в объекты языка R ####

saveRDS(data, "data.rds")
rm(data)
data_new <- readRDS("data.rds")

# Сохранить полный образ сессии
save.image("my_work_space.RData")
# Прочитать полный образ сессии
load("my_work_space.RData")

