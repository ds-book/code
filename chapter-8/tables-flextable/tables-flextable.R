if (!require(medicaldata)) { 
  install.packages("medicaldata")
  library(medicaldata)
}

if (!require(tidyverse)) { 
  install.packages("tidyverse")
  library(tidyverse)
}

# Справка по набору данных
help("cytomegalovirus")

#### Подготовка данных ####

# Посчитаем статистику по диагнозам и полу пациентов
data <- cytomegalovirus %>% mutate(
  sex = ifelse(sex == 1, "Мужской", "Женский"),
  diagnosis.type = ifelse(diagnosis.type == 1, "lymphoid", "myeloid")
) %>% 
  select(sex, diagnosis.type) %>% 
  rename(diagnosis = 'diagnosis.type') %>% 
  group_by(sex, diagnosis) %>% 
  summarise(n = n(), .groups = 'drop') %>%
  group_by(diagnosis) %>%
  mutate(total_diag = sum(n), percent_diag = (n / total_diag) * 100) %>%
  ungroup() %>%
  mutate(total_overall = sum(n), percent_overall = (n / total_overall) * 100) %>%
  select(diagnosis, sex, n, percent_diag, percent_overall) %>% 
  arrange(diagnosis, sex)
data

# Сформируем строку итогов
data_sum <- data %>% 
  group_by() %>% 
  summarise(n = sum(n), percent_overall = sum(percent_overall)) %>% 
  ungroup() %>% 
  mutate(diagnosis = "Всего", sex = "Всего", percent_diag = NA)
data_sum

# Объединим две таблицы
data <- bind_rows(data, data_sum)
data_sum <- NULL
data

# Посчитаем статистику по возрасту
data_age <- cytomegalovirus %>% mutate(
  sex = ifelse(sex == 1, "Мужской", "Женский"),
  diagnosis.type = ifelse(diagnosis.type == 1, "lymphoid", "myeloid")
) %>% 
  select(sex, age, diagnosis.type) %>%
  rename(diagnosis = 'diagnosis.type') %>% 
  group_by(diagnosis, sex) %>% 
  summarize(n = n(), 
            age_min = min(age, na.rm = TRUE), 
            age_avg = mean(age, na.rm = TRUE), 
            age_max = max(age, na.rm = TRUE), 
            .groups = 'drop') 
data_age

# Сформируем строку итогов
data_age_sum <- cytomegalovirus %>% mutate(
  sex = ifelse(sex == 1, "Мужской", "Женский"),
  diagnosis.type = ifelse(diagnosis.type == 1, "lymphoid", "myeloid")
) %>% 
  select(sex, age, diagnosis.type) %>%
  rename(diagnosis = 'diagnosis.type') %>% 
  summarize(diagnosis = "Всего",
            sex = "Всего",
            n = n(),
            age_min = min(age),
            age_avg = mean(age),
            age_max = max(age))
data_age_sum

# Объединим две таблицы
data_age <- bind_rows(data_age, data_age_sum)
data_age_sum <- NULL
data_age

#### Таблицы flextable #### 

# https://ardata-fr.github.io/flextable-book/index.html
# https://blog.djnavarro.net/posts/2024-07-04_flextable/

if (!require(flextable)) { 
  install.packages("flextable")
  library(flextable)
}

if (!require(officer)) { 
  install.packages("officer")
  library(officer)
}

# Создадим таблицу
ft <- flextable(data)
ft 

# Создадим таблицу с параметрами
ft <- flextable(data, col_keys = c("diagnosis","sex","n","percent_overall"))
ft
# Добавим заголовок и футер
ft <- add_header_row(ft, values = c("Категория", "Значение"), colwidths = c(2, 2))
ft <- add_header_row(ft, values = "Первая строка заголовка", colwidths = 4)
ft <- add_footer_lines(ft, "Примечание к таблице")
ft

ft <- data %>% flextable(col_keys = c("diagnosis","sex","n", "percent_overall")) %>% 
  add_header_row(values = c("Категория", "Значение"), colwidths = c(2, 2)) %>% 
  add_header_row(values = "Первая строка заголовка", colwidths = 4) %>% 
  add_footer_lines("Примечание к таблице")
ft

ft %>% theme_booktabs()
ft %>% theme_apa()
ft %>% theme_box()
ft %>% theme_alafoli()
ft %>% theme_vanilla()
ft %>% theme_zebra()

# Создадим заготовку таблицы
ft <- data %>% flextable() %>% theme_booktabs()
ft

#### Заголовки и примечания ####

# Определим названия столбцов
ft %>% set_header_labels(diagnosis = "Диагноз", 
                         sex = "Пол", 
                         n = "Случаев", 
                         percent_diag = "% в группе", 
                         percent_overall = "% всего")

# Разделим столбцы
ft <- ft %>% separate_header(split = "_") %>% 
  labelizor(part = "header", 
            labels = c("diagnosis" = "Диагноз", 
                       "sex" = "Пол",
                       "n" = "Случаев",
                       "percent" = "Процент",
                       "diag" = "в группе",
                       "overall" = "всего")) 
ft

# Зададим заголовки и примечания для таблицы
ft <- ft %>% 
  # Подпись таблицы
  set_caption("Типы диагнозов") %>% 
  # Добавим строку заголовка
  add_header_lines("Вторая строка заголовка") %>% 
  # Добавим строку примечания
  add_footer_lines("На основании данных из набора cytomegalovirus")
ft

# Комментарии-сноски
ft <- ft %>% 
  # Комментарий к процентам в группе
  flextable::footnote(i = 3, j = 4, part = "header",
                      ref_symbols = "1", value = as_paragraph("Доля пациента в рамках диагноза")) %>%  
  # Комментарий к процентам всего
  flextable::footnote(i = 3, j = 5, part = "header",
                      ref_symbols = "2", value = as_paragraph("Доля пациентов в рамках исследования"))
ft

#### Форматирование значений ####
ft <- ft %>% 
  set_formatter(diagnosis = str_to_title) %>% 
  colformat_double(digits = 2, suffix = "%")
ft

#### Ширина столбцов ####

ft %>% autofit()

ft %>% 
  width(j = c(1,2), width = 3, unit = "cm") %>% 
  width(j = c(3,4,5), width = 2, unit = "cm")

ft %>%  set_table_properties(width = 1, layout = "autofit")

ft <- ft %>% autofit()

#### Шрифты и выравнивание ####

# Шрифты
ft <- ft %>% 
  # Выбираем первую строку заголовка 
  font(fontname = "Times New Roman", i = 1, part = "header") %>% 
  # Оформляем примечания
  font(fontname = "Times New Roman", part = "footer") %>% 
  fontsize(size = 9, part = "footer") %>% 
  italic(part = "footer") %>% 
  # Заголовки столбцов у нас включают две строки
  bold(i = c(2,3), part = "header") %>% 
  # Выделяем столбец диагнозов курсивом
  italic(j = "diagnosis", part = "body")  %>% 
  # Выделяем строку итогов на основе значения ячейки
  bold(i = ~ diagnosis == "Всего", part = "body")
ft

ft <- ft %>% 
  # Общее выравнивание таблицы
  align_nottext_col(align = "right") %>% 
  align_text_col(align = "left") %>% 
  # Заголовки по вертикали выравниваем по центру
  valign(valign = "center", part = "header") %>% 
  # Заголовок Процент выравниваем по горизонтали по центру
  align(i = 2, j = 4, align = "center", part = "header") %>% 
  # Примечание выравниваем по правому краю
  align(align = "right", part = "footer") %>% 
  # Комментарии-сноски выравниваем по левому краю
  align(i = c(2,3), align = "left", part = "footer") %>%
  # Количество случаев выровним по горизонтали по центру
  align(align = "center", j = "n", part = "body") %>% 
  align(i = 2, j = "n", align = "center", part = "header")
ft  

# Сделаем примечания компактнее
ft <- ft %>% line_spacing(part = "footer", space = 0.25)
ft

#### Объединение ячеек ####

ft <- ft %>% 
  # Объединяем ячейки с диагнозами
  merge_v(j = "diagnosis") %>% 
  # Объединяем ячейки в строке итогов
  merge_at(i = ~ diagnosis == "Всего", j = c(1:2), part = "body")
ft

# Выровним столбец диагнозов
ft <- ft %>% valign(j = 1, valign = "top", part = "body")
ft

#### Выделение границ ####

# Определим линии
line_black2 = fp_border(color="black", width = 2)
line_black1 = fp_border(color="black", width = 1)
line_gray = fp_border(color="gray", width = 1)

# Нарисуем линии
ft <- ft %>%   
  # Горизонтальная линию для заголовков столбцов
  hline(part = "header", border = line_black1) %>% 
  # Горизонтальная линию для тела таблицы
  hline(part = "body", border = line_gray) %>% 
  # Вертикальная линия для столбца с процентами
  surround(i = 2, j = 3, part = "header", border.right = line_black1 ) %>% 
  # Вертикальная линия для отделения процентов в теле таблицы
  surround(j = 3, part = "body", border.right = line_black1 ) %>% 
  # Горизонтальная линия для строки итогов
  surround(i = ~ diagnosis == "Всего", border.top = line_black2, border.bottom = line_black2 )
ft

#### Окрашивание элементов ####

ft <- ft %>% 
  # Фон заголовков столбцов сделаем серым
  bg(bg = "grey95", part = "header") %>% 
  # Подсветим строки, где доля диагноза более 50% 
  bg(i = ~ percent_diag > 50, bg = "#ffa50040") %>% 
  # Выделим значения, где доля диагноза более 50% 
  color(i = ~ percent_diag > 50, j = 4, color = "red") %>% 
  # Выделим количество, где доля диагноза более 50% 
  highlight(i = ~ percent_diag > 50, j = 3, color = "pink")
ft

#### Создание собственной темы #####

# Полный скрипт для оформления таблицы
ft_full <- data %>% flextable() %>% 
  # Разделим столбцы
  separate_header(split = "_") %>% 
  labelizor(part = "header", 
            labels = c("diagnosis" = "Диагноз", 
                       "sex" = "Пол",
                       "n" = "Случаев",
                       "percent" = "Процент",
                       "diag" = "в группе",
                       "overall" = "всего")) %>% 
  # Зададим заголовки и примечания для таблицы
  set_caption("Типы диагнозов") %>% 
  add_header_lines("Вторая строка заголовка") %>% 
  add_footer_lines("На основании данных из набора cytomegalovirus") %>% 
  flextable::footnote(i = 3, j = 4, part = "header",
                      ref_symbols = "1", value = as_paragraph("Доля пациента в рамках диагноза")) %>%  
  flextable::footnote(i = 3, j = 5, part = "header",
                      ref_symbols = "2", value = as_paragraph("Доля пациентов в рамках исследования")) %>% 
  # Форматирование значений
  set_formatter(diagnosis = str_to_title) %>% 
  colformat_double(digits = 2, suffix = "%") %>% 
  # Шрифты
  font(fontname = "Times New Roman", i = 1, part = "header") %>% 
  font(fontname = "Times New Roman", part = "footer") %>% 
  fontsize(size = 9, part = "footer") %>% 
  italic(part = "footer") %>% 
  bold(i = c(2,3), part = "header") %>% 
  italic(j = "diagnosis", part = "body")  %>% 
  bold(i = ~ diagnosis == "Всего", part = "body") %>% 
  # Выравнивание
  align_nottext_col(align = "right") %>% 
  align_text_col(align = "left") %>% 
  valign(valign = "center", part = "header") %>% 
  align(i = 2, j = 4, align = "center", part = "header") %>% 
  align(align = "right", part = "footer") %>% 
  align(i = c(2,3), align = "left", part = "footer") %>%
  align(align = "center", j = "n", part = "body") %>% 
  align(i = 2, j = "n", align = "center", part = "header") %>% 
  line_spacing(part = "footer", space = 0.25) %>% 
  # Объединение ячеек 
  merge_v(j = "diagnosis") %>% 
  merge_at(i = ~ diagnosis == "Всего", j = c(1:2), part = "body")  %>% 
  valign(j = 1, valign = "top", part = "body")  %>% 
  # Выделение границ
  hline(part = "header", border = fp_border(color="black", width = 1)) %>% 
  hline(part = "body", border = fp_border(color="gray", width = 1)) %>% 
  surround(i = 2, j = 3, part = "header", 
           border.right = fp_border(color="black", width = 1) ) %>% 
  surround(j = 3, part = "body", 
           border.right = fp_border(color="black", width = 1) ) %>% 
  surround(i = ~ diagnosis == "Всего", 
           border.top = fp_border(color="black", width = 2), 
           border.bottom = fp_border(color="black", width = 2) ) %>% 
  # Окрашивание элементов
  bg(bg = "grey95", part = "header") %>% 
  bg(i = ~ percent_diag > 50, bg = "#ffa50040") %>% 
  color(i = ~ percent_diag > 50, j = 4, color = "red") %>% 
  highlight(i = ~ percent_diag > 50, j = 3, color = "pink") %>% 
  # Автоматическая ширина столбцов
  flextable::autofit()
ft_full

# Задание настроек по умолчанию для таблиц
set_flextable_defaults(
  font.size = 10, 
  theme_fun = theme_vanilla,
  padding = 6,
  table.layout = "autofit",
  background.color = "#EFEFEF")

# Сброс настроек по умолчанию
init_flextable_defaults()

# Создаем функцию для оформления таблицы
format_my_table <- function(data, caption, comment) { 
  data %>% flextable() %>% theme_booktabs() %>% 
    # Разделим столбцы
    separate_header(split = "_") %>% 
    labelizor(part = "header", 
              labels = c("diagnosis" = "Диагноз", 
                         "sex" = "Пол",
                         "n" = "Случаев"
              )) %>% 
    # Добавим заголовок и примечание
    set_caption(caption) %>% 
    add_footer_lines(comment) %>% 
    # Форматирование значений
    set_formatter(diagnosis = str_to_title) %>% 
    # Шрифты
    font(fontname = "Times New Roman", part = "footer") %>% 
    fontsize(size = 9, part = "footer") %>% 
    italic(part = "footer") %>% 
    bold(part = "header") %>% 
    italic(j = "diagnosis", part = "body")  %>% 
    bold(i = ~ diagnosis == "Всего", part = "body") %>% 
    # Выравнивание
    align_nottext_col(align = "right") %>% 
    align_text_col(align = "left") %>% 
    # Выравнивание заголовков 
    valign(valign = "center", part = "header") %>% 
    align(i = 1, j = 4, align = "center", part = "header") %>% 
    # Выравнивание количества пациентов
    align(j = "n", align = "center", part = "header") %>% 
    align(align = "center", j = "n", part = "body") %>% 
    # Выравнивание примечаний
    align(align = "right", part = "footer") %>% 
    line_spacing(part = "footer", space = 0.25) %>% 
    # Объединение ячеек 
    merge_v(j = "diagnosis") %>% 
    merge_at(i = ~ diagnosis == "Всего", j = c(1:2), part = "body")  %>% 
    valign(j = 1, valign = "top", part = "body")  %>% 
    # Выделение границ
    hline(part = "header", border = fp_border(color="black", width = 1)) %>% 
    hline(part = "body", border = fp_border(color="gray", width = 1)) %>% 
    surround(j = 3, part = "header", 
             border.right = fp_border(color="black", width = 1) ) %>% 
    surround(j = 3, part = "body", 
             border.right = fp_border(color="black", width = 1) ) %>% 
    surround(i = ~ diagnosis == "Всего", 
             border.top = fp_border(color="black", width = 2), 
             border.bottom = fp_border(color="black", width = 2) ) %>% 
    # Окрашивание элементов
    bg(bg = "grey95", part = "header")
}

# Применяем функцию 
ft_data <- data %>% format_my_table(
  caption = "Типы диагнозов", 
  comment = "На основании данных из набора cytomegalovirus")
ft_data

ft_data_age <- data_age %>% format_my_table(
  caption = "Возраст пациентов",
  comment = "На основании данных из набора cytomegalovirus"
)
ft_data_age

# Добавим недостающие функции оформления
ft_data %>% 
  # Определим недостающие заголовки
  labelizor(part = "header", 
            labels = c("percent" = "Процент",
                       "diag" = "в группе",
                       "overall" = "всего")) %>% 
  # Добавим символ процентов
  colformat_double(digits = 2, suffix = "%") %>% 
  # Зададим примечания для таблицы
  flextable::footnote(i = 2, j = 4, part = "header",
                      ref_symbols = "1", value = as_paragraph("Доля пациента в рамках диагноза")) %>%  
  flextable::footnote(i = 2, j = 5, part = "header",
                      ref_symbols = "2", value = as_paragraph("Доля пациентов в рамках исследования")) %>% 
  # Сделаем выравнивание примечаний по левому краю
  align(i = c(2,3), align = "left", part = "footer") %>%
  # Окрашивание элементов
  bg(bg = "grey95", part = "header") %>% 
  bg(i = ~ percent_diag > 50, bg = "#ffa50040") %>% 
  color(i = ~ percent_diag > 50, j = 4, color = "red") %>% 
  highlight(i = ~ percent_diag > 50, j = 3, color = "pink") %>% 
  # Подберем ширину столбцов
  autofit()
ft_data

ft_data_age %>% 
  # Оформим числовые значения
  colformat_double(j = 5, digits = 2) %>%
  # Определим недостающие заголовки
  labelizor(part = "header", 
            labels = c("age" = "Возраст",
                       "min" = "Мин",
                       "avg" = "Сред",
                       "max" = "Макс")) %>% 
  # Подберем ширину столбцов
  autofit()
ft_data_age

#### Сохранение таблиц ####

ft %>% save_as_docx(path = "flextable.docx")
ft %>% save_as_pptx(path = "flextable.pptx")
ft %>% save_as_html(path = "flextable.html")
ft %>% save_as_image(path = "flextable.png", expand = 50, res = 300)

if (!require(svglite)) { 
  install.packages("svglite")
  library(svglite)
}
ft %>% save_as_image(path = "flextable.svg")
