if (!require(tidyverse)) install.packages("tidyverse")
if (!require(lubridate)) install.packages("lubridate")

##### Чтение из базы данных #####

if (!require(DBI)) install.packages("DBI")
if (!require(RSQLite)) install.packages("RSQLite")

# Создаем драйвер для подключения
sqlite <- dbDriver("SQLite")

# Создаем подключение к базе данных
conn <- dbConnect(sqlite,"data/study.db")

# Запрос списка таблиц в базе данных
dbListTables(conn)

# Загрузка таблицы из базы данных
data <- dbReadTable(conn, "PAT")
head(data)

# Запрос списка полей таблицы
dbListFields(conn, "PAT")

# Получение запроса из базы данных
data <- dbGetQuery(conn, "SELECT study_subject_id, DateStart, STRAIN FROM PAT")
head(data)

# Получение запроса из базы данных с параметрами
data <- dbGetQuery(conn, "SELECT study_subject_id, DateStart, STRAIN, center FROM PAT WHERE CENTER = 75")
head(data)

# Запросы с параметрами https://solutions.posit.co/connections/db/best-practices/run-queries-safely/
query <- dbSendQuery(conn, "SELECT study_subject_id, DateStart, STRAIN, center FROM PAT WHERE center = ?")
# Задаем значение для знака вопроса
dbBind(query, list("292"))
# Получаем набор данных
data <- dbFetch(query)
head(data)
# Закрываем запрос
dbClearResult(query)

query <- dbSendQuery(conn, "SELECT study_subject_id, DateStart, STRAIN, center FROM PAT WHERE center = ? AND study_subject_id > ?")
# Задаем значение для знака вопроса
dbBind(query, list("292", "960"))
# Получаем набор данных
data <- dbFetch(query)
head(data)
# Закрываем запрос
dbClearResult(query)

# Запросы с glue
if (!require(glue)) install.packages("glue")
library(glue)

sql <- glue_sql("SELECT study_subject_id, DateStart, STRAIN, center FROM PAT WHERE center = ? AND study_subject_id > ?")
query <- dbSendQuery(conn, sql)
dbBind(query, list("292", "960"))
data <- dbFetch(query)
dbClearResult(query)

# Запросы с glue со звездочкой
sql <- glue_sql("SELECT study_subject_id, DateStart, STRAIN, center FROM PAT WHERE center IN ({centers*})",
                centers = c("292", "75"),
                .con = conn)
query <- dbSendQuery(conn, sql)
data <- dbFetch(query)
dbClearResult(query)

# Еще один способ параметризированных запросов
sql <- sqlInterpolate(conn, 
                      "SELECT study_subject_id, DateStart, STRAIN FROM PAT WHERE center = ?center", 
                      center = "75")
data <- dbGetQuery(conn, sql)

# Завершения соединения с базой данных
dbDisconnect(conn)



##### Скачивание файлов из интернета #####

# Ссылка на наборы открытых данных Минздрава
# https://minzdrav.gov.ru/opendata

# Скачивание файла
url <- "https://minzdrav.gov.ru/opendata/7707778246-grls/data-20170301T0000-structure-20151217T0000.csv"
savePath <- "data/grls-download.csv"
download.file(url, savePath)

# Таким жже образом можно скачивать и обычные HTML-страницы
url <- "https://ya.ru"
savePath <- "data/ya.html"
download.file(url, savePath)

# Чтобы скачивать не текстовые файлы (например архивы или картинки)
# нужно добавить дополнительный атрибут
url <- "https://static-0.minzdrav.gov.ru/system/attachments/attaches/000/059/757/original/%D0%9F%D1%80%D0%B8%D0%BA%D0%B0%D0%B7_%D0%9C%D0%B8%D0%BD%D0%B8%D1%81%D1%82%D0%B5%D1%80%D1%81%D1%82%D0%B2%D0%B0_%D0%B7%D0%B4%D1%80%D0%B0%D0%B2%D0%BE%D0%BE%D1%85%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F_%D0%A0%D0%A4_%D0%BE%D1%82_10.07.2015_%E2%84%96_434%D0%BD.pdf?1653904985"
savePath <- "data/document.pdf"
# Можно скачать и так, но файл не откроется
download.file(url, savePath)
# Нужно скачивать именно в бинарном формате
download.file(url, savePath, mode = "wb")

# Удалим скачанный файл
file.remove(savePath)

# Часто приходится скачивать архивы.

# Запакуем скаченный файл
zip("data/grls-download.zip", "data/grls-download.csv")
# Их можно прямо в R распаковывать
archive <- "data/grls-download.zip"
folder <- "data/extracted-folder/"
# Создаем папку для распаковки архива
dir.create(folder)
# Распаковываем архив
unzip(archive, exdir = folder)
# Проверим результат распаковки
dir(path = folder)


#### Работа с HTTP запросами (httr2) ####

if (!require(httr2)) install.packages("httr2")

# Работа с httr2 начинается с создания HTTP запроса. 
# Это ключевое отличие от предшественника httr, в предыдущей версии вы одной командой выполняли сразу 
# несколько действий: создавали запрос, отправляли его, и получали ответ. 
# httr2 имеет явный объект запроса, что значительно упрощает процесс компоновки сложных запросов. 
# Процесс построения запроса начинается с базового URL:

req <- request("https://httpbin.org/get")
req

req <- request("https://nominatim.openstreetmap.org")
req

# Перед отправкой запроса на сервер мы можем посмотреть, что именно будет отправлено

req %>% req_dry_run()

# Чтобы получить ответ от запроса нужно выполнить запрос с помощью команды req_perform()
resp <- req %>% req_perform()
resp

# Посмотреть полученный ответ можно с помощью resp_raw():
resp %>% resp_raw()

# Структура HTTP ответа очень похожа на структуру запроса. 
# В первой строке указывается версия используемого HTTP и код состояния, 
# за которым (необязательно) следует его краткое описание. 
# Затем идут заголовки, за которыми следует пустая строка, за которой следует тело ответа. 
# В отличие от запросов большинство ответов будет иметь тело.
# Вы можете извлечь данные из ответа с помощью функций семейства resp_():

resp %>% resp_status()
resp %>% resp_status_desc()
resp %>% resp_content_type()

# Вы можете извлечь все заголовки используя resp_headers() или 
# получить значение конкретного заголовок с помощью resp_header()

resp %>% resp_headers()
resp %>% resp_header("Content-Length")

# Тело ответа, так же как и тело запроса, в зависимости от устройства API может приходить в разных форматах. 
# Для извлечения тела ответа используйте функции семейства  resp_body_*(). 
# В наше случае результат пришел в формате HTML. 
# В нашем примере мы получили ответ в виде JSON структуры, поэтому для его извлечения необходимо 
# использовать resp_body_json()

html <- resp %>% resp_body_html() 
str(html)
class(html)

###### Заголовки в запросе ######

# Попробуем добавить заголовки в запрос

# Сохраняем JWT для авторизации
jwt <- "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
# Формируем запрос
req <- request("https://httpbin.org/bearer") %>% 
  req_headers(
    Authorization = paste("Bearer", jwt), # Добавляем JWT в заголовок
    Accept = "application/json" # Указываем ожидаемый формат ответа 
  )     
req %>% req_dry_run()


# Отправим запрос
resp <- req %>% req_perform()
resp %>% resp_raw()

###### Параметры запроса ######

# Для запросов можно задавать и дополнительные параметры запроса. В запросах они могут передаваться как в адресной строке

req <- request("https://nominatim.openstreetmap.org/search?q=Smolensk&addressdetails=1&format=jsonv2&limit=1")
resp <- req %>% req_perform()
resp %>% resp_raw()

# Так и указанием в качестве дополнительных параметров при создании объекта запроса. 
# Это может быть удобно при создании запросов в цикле 

req <- request("https://nominatim.openstreetmap.org") %>% # Определяем основной URL
  req_url_path_append("search") %>%  # Задаем метод API, к которому обращаемся
  req_url_query(q = "Smolensk") %>%  # Определяем параметры
  req_url_query(addressdetails = "1") %>% 
  req_url_query(format = "jsonv2") %>% 
  req_url_query(limit = 1)

# Проверим результат
req %>% req_dry_run()
# Выполним запрос
resp <- req %>% req_perform()
resp %>% resp_raw()
json <- resp %>% resp_body_json()
str(json)

# Можем изменить формат ответа и получить результат в виде XML

req <- request("https://nominatim.openstreetmap.org") %>% # Определяем основной URL
  req_url_path_append("search") %>%  # Задаем метод API, к которому обращаемся
  req_url_query(q = "Smolensk") %>%  # Определяем параметры
  req_url_query(addressdetails = "1") %>% 
  req_url_query(format = "xml") %>%  # Меняем формат на XML
  req_url_query(limit = 1)
resp <- req %>% req_perform()
resp %>% resp_raw()

###### Передача формы ######

# В качестве примера мы используем req_body_form() для добавления данных в виде формы
# Попробуем получить данные по АТХ препаратов с сайта https://www.whocc.no/atc_ddd_index/

req <- request("https://atcddd.fhi.no/atc_ddd_index/") %>% 
  req_body_form(code = "ATC code", 
                name = "amikacin", 
                namesearchtype = "containing")
req %>% req_dry_run()

resp <- req %>% req_perform()
resp
resp %>%  resp_raw()

# Выделим интересующую нас таблицу из ответа
if (!require(rvest)) install.packages("rvest")
if (!require(xml2)) install.packages("xml2")

html <- resp %>% resp_body_html()
html %>% 
  html_element(xpath = '//div[@id="content"]/table') %>% 
  html_table()

###### Передача данных в теле запроса ######

# В качестве примера мы используем req_body_json() для добавления данных в виде JSON структуры
req <- request("https://httpbin.org/anything") %>% 
  req_body_json(list(x = 1, y = "a"))
req %>% req_dry_run()

resp <- req %>% req_perform()
resp %>% resp_raw()

json <- resp %>% resp_body_json()
json$origin

###### Обработка ошибок ######

# Ответы с кодами состояния 4xx и 5xx являются ошибками HTTP. httr2 автоматически преобразует их в ошибки R:

request("https://httpbin.org/status/404") %>% req_perform()

request("https://httpbin.org/status/500") %>% req_perform()

tryCatch(
  {
    request("https://httpbin.org/status/500") %>% req_perform()
    print("OK")
  },
  error = function(cond) {
    print("ERROR")
  }
)

# req_cache() позволяет кешировать запросы и их ответы, чтобы избегать повторных запросов к серверу, 
# если входящие параметры запроса не изменились, и вы получите те же результаты.

# req_throttle() автоматически добавит небольшую паузу перед отправкой каждого запроса, 
# поскольку многие API имеют ограничения на количество отправляемых запросов в единицу времени.

# req_retry() устанавливает стратегию повторных попыток отправки запросов. 
# В случае сбоя запроса или получения временной ошибки HTTP запрос будет отправлен повторно после небольшой паузы.


#### Работа с JSON ####

###### Работа с JSON как со списком #####

# Рассмотрим пример с получением JSON от внешнего API.

req <- request("https://nominatim.openstreetmap.org") %>% 
  req_url_path_append("search") %>% 
  req_url_query(q = "Smolensk") %>% 
  req_url_query(addressdetails = "1") %>% 
  req_url_query(format = "jsonv2") %>% 
  req_url_query(limit = 10)
resp <- req %>% req_perform()
json <- resp %>% resp_body_json()

class(json)
str(json)

# Прочитаем JSON как строку
txt <- resp %>% resp_body_string()
txt

# Для красивого отображения JSON можно воспользоваться функцией prettify()
txt %>% prettify()

# Получим значение координат

json[[1]]$lat # Широта
json[[1]]$lon # Долгота

# Сделаем таблицу и заполним ее данными из json
table <- tibble(
  display_name = character(),
  city = character(),
  region = character(),
  area = character(),
  country = character(),
  lat = numeric(),
  lon = numeric(),
)

# Последовательно будем считывать каждое значение списка и добавим заполнение пропущенных значений
for (i in 1:length(json)) {
  d <- list()
  d$display_name <- ifelse(!is.null(json[[i]]$display_name), json[[i]]$display_name, "")
  d$city <- ifelse(!is.null(json[[i]]$address$city), json[[i]]$address$city, "")
  d$region <- ifelse(!is.null(json[[i]]$address$state), json[[i]]$address$state, "")
  d$area <- ifelse(!is.null(json[[i]]$address$region), json[[i]]$address$region, "")
  d$country <- ifelse(!is.null(json[[i]]$address$country), json[[i]]$address$country, "")
  d$lat <- as.numeric(json[[i]]$lat)
  d$lon <- as.numeric(json[[i]]$lon)
  table <- bind_rows(table, d)
}
table

###### Работа с JSON как с таблицей #####

if (!require(jsonlite)) install.packages("jsonlite")

# Можно читать создавать JSON-объект из текста из файла на диске
json_from_file <- jsonlite::read_json("data/search.json")
class(json_from_file)

# Прочитам текст в список
json_parsed <- jsonlite::parse_json(txt)
class(json_parsed)

# Универсальная функция для чтения JSON в data.frame
?fromJSON
df  <- jsonlite::fromJSON("data/search.json")
class(df)
str(df)

# Сделаем таблицу плоской
df  <- jsonlite::fromJSON(txt)
str(df)
df  <- jsonlite::fromJSON(txt, simplifyVector = TRUE, flatten = TRUE)
str(df)

# Координаты остались в виде списка
df$boundingbox <- toString(df$boundingbox)
str(df)

# Для преобразования списка, полученного из json в таблицу можно также использовать пакет tidyjson

if (!require(tidyjson)) install.packages("tidyjson")

# Преобразуем в таблицу
table <- json %>% spread_all(recursive = TRUE, sep = ".")

###### Работа с JSONpath ######

if (!require(httr2)) install.packages("httr2")
if (!require(dplyr)) install.packages("dplyr")
if (!require(jsonlite)) install.packages("jsonlite")
if (!require(rjsoncons)) install.packages("rjsoncons")

req <- request("https://nominatim.openstreetmap.org") %>% 
  req_url_path_append("search") %>% 
  req_url_query(q = "Смоленск") %>% 
  req_url_query(addressdetails = "1") %>% 
  req_url_query(format = "jsonv2") %>% 
  req_url_query(limit = 10)
resp <- req %>% req_perform()
json <- resp %>% resp_body_string()

json %>%  jsonlite::prettify()

# Извлечем только нужные нам элементы
path <- "$[?(@.addresstype == 'city' && @.category == 'place')]"
json_small <- j_query(json, path)
json_small %>% prettify()

# Сформируем формат нужной нам таблицы с использованием выражений JSONpath
path <- '{
    place_id: [].place_id,
    name:     [].name,
    state:    [].address.state,
    region:   [].address.region,
    type:     [].addresstype,
    category: [].category,
    lat: [].lat,
    lon: [].lon,
    bb1: [].boundingbox[0],
    bb2: [].boundingbox[1],
    bb3: [].boundingbox[2],
    bb4: [].boundingbox[3]
}'

tbl <- j_query(json_small, path, as = "R") %>% data.frame() %>% tibble()
tbl



###### JSON в текст ######

# Создадим объект для отправки
obj <- list(
  Id = "1",
  Organism = "Staphylococcus aureus",
  Date = dmy("23-09-2023"),
  Antibiotics = list(
    list(
      Antibiotic = "eravacycline",
      Method = "SIR",
      Value = "R"
    ),
    list(
      Antibiotic = "norfloxacin",
      Method = "DD",
      Value = "12"
    )
  )
)
# Преобразуем в текстовый JSON
json <- toJSON(obj)
json %>% prettify()

# Можно задавать дополнительное форматирование JSON
json <- toJSON(obj, auto_unbox = TRUE, pretty = TRUE,
               factor = "string", na = "null", null = "null")
json




##### Работа с XML #####

if (!require(xml2)) install.packages("xml2")

# Читаем файл
# Ссылка на набор данных
# http://nsi.rosminzdrav.ru/#!/refbook/1.2.643.5.1.13.13.11.1005/version/2.21
data <- read_xml("data/ICD-10.xml")

# Корневой элемент
xml_name(data)

# Проверим дочерние элементы
xml_children(data)
xml_child(data, search = 1)

# Посмотрим на первый элемент
first_record <- xml_find_first(data, "/book/entries/entry[1]")
first_record
first_record <- xml_find_first(data, ".//entry[1]")
first_record
as.character(xml_contents(first_record))

# Выберем все элементы entry
entries <- xml_find_all(data, ".//entry")
length(entries)

# Выберем актуальные элементы
entries <- xml_find_all(data, './/entry[ACTUAL[text()="1"]]')
length(entries)

# Посмотрим первый элемент
as.character(xml_contents(entries[1]))

# Можно комбинировать условия. Например выберем Болезни органов дыхания
entries <- xml_find_all(data, './/entry[ACTUAL[text()="1"] and MKB_CODE[starts-with(text(), "J")]]')
length(entries)

# Посмотрим первый элемент
as.character(xml_contents(entries[1]))

# Посмотрим последний элемент
as.character(xml_contents(entries[length(entries)]))

# Получим описание последнего элемента
xml_text(xml_find_first(entries[length(entries)], "MKB_NAME"))

# Получим вектора значений для тегов
mkb_code <- xml_text(xml_find_all(entries, "MKB_CODE"))
mkb_name <- xml_text(xml_find_all(entries, "MKB_NAME"))
# Сохраним элементы таблицу
tbl <- tibble(mkb_code, mkb_name)
head(tbl)

######  XML. Быстрое чтение в data.frame с помощью пакета xmlconvert ######

if (!require(xmlconvert)) install.packages("xmlconvert")

?xml_to_df

tbl <- xml_to_df("data/ICD-10.xml", records.tag = "entry")
head(tbl)





##### HTML. Работа с файлом на диске #####

if (!require(rvest)) install.packages("rvest")
if (!require(xml2)) install.packages("xml2")

# Загрузка HTML страницы
html <- read_html("data/response.html")

# Просмотр структуры HTML-документа
html_structure(html)

# Ищем элемент по его Id
# //*[@id="table-sir"] 
# /html/body/table[1] 
node <- html %>% html_element(xpath = ".//table[@id='table-sir']")
as.character(xml_contents(node)[1])

# Преобразуем в таблицу
data <- html_table(node)
head(data)

# Получаемый текст может зависеть от типа функции
guideline <- html %>% html_element(xpath = ".//h3[@id='guideline']") 
as.character(guideline)
guideline %>% html_text() 
guideline %>% html_text2() 

##### HTML. Парсинг страницы mic.eucast.org #####

if (!require(rvest)) install.packages("rvest")
if (!require(htmltools)) install.packages("htmltools")
if (!require(stringr)) install.packages("stringr")
if (!require(purrr)) install.packages("purrr")
if (!require(rvest)) install.packages("rvest")
if (!require(xml2)) install.packages("xml2")
if (!require(tidyverse)) install.packages("tidyverse")

URLencode("сумамед")
URLdecode("%D1%81%D1%83%D0%BC%D0%B0%D0%BC%D0%B5%D0%B4")

# Получаем стартовую страницу
html <- read_html("https://mic.eucast.org/search/")

# Получим список антибиотиков из фильтров с помощью идентификатора объекта
select_ab <- html_element(html, xpath = '//select[@id="search_antibiotic"]')

# Сформируем вектор кодов антибиотиков
codes <- html %>% html_nodes("option") %>% html_attr("value") %>% str_trim()
# Сформируем вектор названий антибиотиков
labels <- html %>% html_nodes("option") %>% html_text() %>% str_trim()

# Собираем вместе в таблицу 
drugs <- data.frame(code = codes, label = labels, stringsAsFactors = FALSE)
# Убираем лишнее
drugs <- drugs %>% filter(code != "-1")
# Проверим содержимое
head(drugs)


# Теперь попробуем получить список граничных значений

# https://mic.eucast.org/search/?search%5Bmethod%5D=mic&search%5Bantibiotic%5D=1&search%5Bspecies%5D=-1&search%5Bdisk_content%5D=-1&search%5Blimit%5D=50
# https://mic.eucast.org/search/?search[method]=mic&search[antibiotic]=1&search[species]=-1&search[disk_content]=-1&search[limit]=50

# Кодировние
URLencode("сумамед")
# Декодирование
URLdecode("сумамед")

# Декодирование
URLdecode("https://mic.eucast.org/search/?search%5Bmethod%5D=mic&search%5Bantibiotic%5D=1&search%5Bspecies%5D=-1&search%5Bdisk_content%5D=-1&search%5Blimit%5D=50")


head(drugs)

# Создание таблицы для результатов
res <- data.frame(ab = character(), 
                  org = character(), 
                  ecoff = character(), 
                  stringsAsFactors = FALSE)

# Загрузка страницы
html <- read_html(paste0("https://mic.eucast.org/search/" , "?" , 
                         "search[method]=", "mic", "&",
                         "search[antibiotic]=", "1", "&",
                         "search[limit]=", "100"
))

# Поиск таблицы с данными
tbl <- html_element(html, xpath = '//table[@id="search-results-table"]') %>% html_table()
head(tbl)

# Первый столбец не имеет заголовка, но содержит название организма
colnames(tbl)[1] <- "org"
# Преобразование таблицы
tbl <- tbl %>% 
  # Отбор нужных столбцов
  select("org", "(T)ECOFF") %>% 
  # Фильтрация лишних значений
  filter(!(`(T)ECOFF` %in% c("-", "ID")) & `org` != "") %>% 
  # Очистка значений от скобок
  mutate(ecoff = str_remove_all(`(T)ECOFF`, "[()]")) %>% 
  # Добавление названия антибиотика
  mutate(ab = "Amikacin") %>% 
  # Выбор нужных столбцов
  select(ab, org, ecoff)

head(tbl)


# Добавим к результату
res <- res %>% bind_rows(tbl)

##### HTML. Парсинг страницы mic.eucast.org в параллельном режиме #####

if (!require(parallel)) install.packages("parallel")

# Создание функции со всеми необходимыми действиями
searchMic <- function(abcode, abname) { 
  # Загрузка необходимых пакетов
  library(rvest)
  library(stringr)
  library(purrr)
  # Генерация случайную задержку от 1 до 3 секунд
  delay <- runif(1, 1, 3)  
  # Задержка
  Sys.sleep(delay)  
  # Получение страницы
  html <- read_html(paste0("https://mic.eucast.org/search/" , "?" , 
                           "search[method]=", "mic", "&",
                           "search[antibiotic]=", abcode, "&",
                           "search[limit]=", "100"))
  # Поиск таблицы с результатами
  tbl <- html_element(html, xpath = '//table[@id="search-results-table"]') %>% html_table()
  # Работа с таблицей
  colnames(tbl)[1] <- "org"
  tbl <- tbl %>% 
    select("org", "(T)ECOFF") %>% 
    filter(!(`(T)ECOFF` %in% c("-", "ID")) & `org` != "") %>% 
    mutate(ecoff = str_remove_all(`(T)ECOFF`, "[()]")) %>% 
    mutate(ab = abname) %>% 
    select(ab, org, ecoff)
  
  # Вывод результата
  list(tbl = tbl)
}

# Проверим работу функции
searchMic("1", "Amikacin")

# Определим количество ядер процессора 
num_cores <- detectCores() 
num_cores
# Создадим кластер для параллельной обработки
cluster <- makeCluster(num_cores) 

# Запутим функцию для вектора значений в параллельном режиме 
# Используем функцию parLapply из пакета parallel
drugs5 <- head(drugs)

# Запуск в параллельном режиме
results <- mcmapply(
  searchMic,               # Функция, которая будет запускаться
  drugs5$code,             # Коды антибиотиков
  drugs5$label,            # Названия антибиотиков
  mc.cores = detectCores() # Определим количество ядер процессора 
)
str(results)

# Объединим результаты работы каждой функции в data.frame
res <- do.call("rbind", results) %>% data.frame()
head(res)


##### Веб-скраппинг с помощью RSelenium #####

if (!require(RSelenium)) install.packages("RSelenium")
if (!require(wdman)) install.packages("wdman")
if (!require(netstat)) install.packages("netstat")
if (!require(rvest)) install.packages("rvest")

drv <- rsDriver(port = 4445L, browser = "firefox")
brw <- drv[["client"]]

# Протестируем команды браузера 
brw$open() # открыть браузер
brw$navigate("http://www.google.com") # перейти на указанный адрес
brw$getCurrentUrl() # получить текуший url
brw$navigate("http://www.yandex.com")
brw$goBack() # вернуться на предыдушую страницу
brw$goForward() # перейти на страницу вперед
brw$refresh() # обновить страницу
brw$maxWindowSize() # браузер на весь экран
brw$screenshot(display = FALSE)
brw$close() # закрыть браузер

# Закроем браузер
brw$closeall()
drv <- drv$server$stop()

##### Веб-скраппинг grls.rosminzdrav.ru с помощью RSelenium #####

selenium(retcommand=T)
drv <- rsDriver(port = 4444L, browser = "firefox", chromever = NULL)
brw <- drv[["client"]]
brw$navigate("https://grls.rosminzdrav.ru/PriceLims.aspx")

# Заполнение поля МНН
frmName <- brw$findElement(using = "id", value = "ctl00_plate_txtINN")
# Передача значения в форму
frmName$sendKeysToElement(list("азитромицин"))


frmTrade <- brw$findElement(using = "id", value = "ctl00_plate_txtTradeName")
frmTrade$sendKeysToElement(list(""))

# Поиск и нажатие кнопки Найти
frmBtn <- brw$findElement(using = "xpath", value = '//input[@type="submit"]')
frmBtn$clickElement()

# Получение содержимого страницы
html <- brw$getPageSource()[[1]]

# Получение таблицы с результатами ctl00_plate_gr
tbl <- read_html(html) %>% 
  html_element(xpath = '//table[@id="ctl00_plate_gr"]') %>% 
  html_table()
head(tbl)

# Индикатор наличия следующей страницы
hasPages <- TRUE
# Номер текущей страницы
page <- 1
# Цикл обработки страницы
while (hasPages == TRUE) { 
  tryCatch({
    # Поиск кнопки перехода на следующую страницу
    frmBtnNext <- brw$findElement(using = "xpath", "//button[text()='>']")
    # Нажатие кнопки перехода на страницу
    frmBtnNext$clickElement()
    # Вывод номера текущей страницы
    page <- page + 1
    print(page)
    # Ожидание загрузки страницы
    Sys.sleep(10)
    # Получение содержимого страницы
    html <- brw$getPageSource()[[1]]
    # Извлечение результатов во временную таблицу
    tmp <- read_html(html) %>% 
      html_element(xpath = '//table[@id="ctl00_plate_gr"]') %>% 
      html_table()
    # Добавление в таблицу-аккумулятор
    tbl <- rbind(tbl, tmp)
  }, error = function(e) {
    # Вывод ошибки
    print(e)
    # Остановка цикла
    hasPages <<- FALSE
  })
}


# Закроем браузер
brw$closeall()
drv$server$stop()
