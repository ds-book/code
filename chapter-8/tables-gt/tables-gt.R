if (!require(medicaldata)) { 
  install.packages("medicaldata")
  library(medicaldata)
}

if (!require(tidyverse)) { 
  install.packages("tidyverse")
  library(tidyverse)
}

if (!require(gt)) install.packages("gt") else library(gt)

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

#### Таблицы gt ####

if (!require(gt)) install.packages("gt") else library(gt)

gt <- data %>%  gt()
gt

# Заменяем пустые значения 
gt %>% sub_missing(missing_text = "")
gt %>% sub_missing(columns = "diagnosis", missing_text = "")
gt %>% sub_missing(columns = starts_with("percent_"), missing_text = "")

gt <- gt %>% sub_missing(missing_text = "")
gt

#### Заголовки и примечания ####

gt <- gt %>%
  # Определим названия столбцов
  cols_label(diagnosis = "Диагноз", sex = "Пол", n = "Случаев",
             percent_diag = "в группе", percent_overall = "всего") %>% 
  # Разделим столбцы по разделителям
  tab_spanner(label = "Процент", columns = starts_with("percent_"))
gt


# Добавим заголовки и примечания к таблице
gt <- gt %>%  
  tab_header(title = "Типы диагнозов", subtitle = "Вторая строка заголовка")
gt

# Для заголовков можно использовать Html и markdown
gt %>% 
  tab_header(
    title = md("**Типы** диагнозов"),
    subtitle = html("<p style='color:red;'>Вторая строка заголовка</p>")
  )

# Комментарии-сноски
gt <- gt %>% 
  tab_source_note(source_note = md("На основании данных из набора `cytomegalovirus`")) %>% 
  tab_footnote(footnote = "Доля пациента в рамках диагноза",
               locations = cells_column_labels(columns = percent_diag)) %>% 
  tab_footnote(footnote = "Доля пациентов в рамках исследования",
               locations = cells_column_labels(columns = percent_overall))
gt  

#### Форматирование значений ####

gt <- gt %>% 
  fmt(columns = c(1:2), fns = str_to_title ) %>% 
  fmt_percent(columns = starts_with("percent"), decimals = 2, scale_values = FALSE)
gt

#### Ширина столбцов ####

gt <- gt %>% 
  cols_width(diagnosis:sex ~ px(100), 
             n ~ px(75), 
             starts_with("percent_") ~ px(90))
gt

#### Шрифты и выравнивание ####

# Установка шрифтов в целом для таблицы
gt <- gt %>% 
  tab_options(
    # Таблица в целом
    table.font.names = 'Times New Roman',
    table.font.color = 'black',
    table.font.size = 14,
    # Заголовок и подзаголовок
    heading.title.font.size = 18,
    heading.title.font.weight = "bold",
    heading.subtitle.font.size = 16,
    # Заголовки столбцов
    column_labels.font.weight = 'bold',
    # Сноски
    footnotes.font.size = 12,
    # Примечания
    source_notes.font.size = 12
  )
gt
gt <- gt %>% 
  # Ячейки таблицы
  tab_style(
    style = cell_text(font = "Arial", size = 12),
    locations = list(
      cells_body(),
      cells_column_labels(),
      cells_column_spanners())
  ) %>% 
  # Столбец Диагноз
  tab_style(
    style = cell_text(font = "Times New Roman", style = 'italic', size = 16, v_align = "middle" ),
    locations = cells_body(columns = diagnosis)
  ) %>% 
  # Строка итогов
  tab_style(
    style = cell_text(font = "Arial", weight = 'bold', style = 'normal', size = 12 ),
    locations = cells_body(rows = length(diagnosis))
  ) %>% 
  # Сноски и источники
  tab_style(
    style = cell_text(style = 'italic'),
    locations = list(
      cells_footnotes(),
      cells_source_notes())
  )  %>% 
  # Выравнивание по центру для столбца Случаев
  tab_style(
    style = cell_text(align = "center"),
    locations = list(
      cells_body(columns = n),
      cells_column_labels(columns = n))
  ) %>%
  # Выравнивание по левому краю для подзаголовка
  tab_style(
    style = cell_text(align = "left"),
    locations = cells_title(c("subtitle"))
  ) %>% 
  # Выравнивание по правому краю для источника
  tab_style(
    style = cell_text(align = "right"),
    locations = cells_source_notes()
  ) %>% 
  # Выравнивание по центру для заголовков столбцов
  tab_style(
    style = cell_text(v_align = "middle"),
    locations = list(
      cells_column_labels(),
      cells_column_spanners())
  )
gt

#### Группировка строк ####

gtg <- data %>% gt(groupname_col = "diagnosis")
gtg

gtg <- data %>% gt(groupname_col = "diagnosis", rowname_col = "sex")
gtg

gtg <- data %>% 
  filter(diagnosis != "Всего") %>% 
  gt(groupname_col = "diagnosis", rowname_col = "sex") %>% 
  summary_rows(
    groups = c("lymphoid", "myeloid"),
    columns = n,
    fns = list(
      `Всего` = ~ sum(., na.rm = TRUE)
    ),
    side = "bottom"
  )
gtg

gt <- data %>% gt(groupname_col = "diagnosis", row_group_as_column = TRUE)

gt <- gt %>% 
  # Заменяем пустые значения
  sub_missing(missing_text = "") %>% 
  # Определим названия столбцов
  cols_label(diagnosis = "Диагноз", sex = "Пол", n = "Случаев",
             percent_diag = "в группе", percent_overall = "всего") %>% 
  # Разделим столбцы по разделителям
  tab_spanner(label = "Процент", columns = starts_with("percent_")) %>% 
  # Добавим заголовки и примечания к таблице
  tab_header(title = "Типы диагнозов", subtitle = "Вторая строка заголовка") %>% 
  tab_source_note(source_note = md("На основании данных из набора `cytomegalovirus`")) %>% 
  tab_footnote(footnote = "Доля пациента в рамках диагноза",
               locations = cells_column_labels(columns = percent_diag)) %>% 
  tab_footnote(footnote = "Доля пациентов в рамках исследования",
               locations = cells_column_labels(columns = percent_overall)) %>% 
  # Форматирование значений
  fmt(columns = c(1:2), fns = str_to_title ) %>% 
  fmt_percent(columns = starts_with("percent"), decimals = 2, scale_values = FALSE) %>% 
  # Ширина столбцов
  cols_width(diagnosis:sex ~ px(100), 
             n ~ px(75), 
             starts_with("percent_") ~ px(90)) %>% 
  # Оформляем таблицу
  tab_options(
    # Таблица в целом
    table.font.names = 'Times New Roman',
    table.font.color = 'black',
    table.font.size = 14,
    # Заголовок и подзаголовок
    heading.title.font.size = 18,
    heading.title.font.weight = "bold",
    heading.subtitle.font.size = 16,
    # Заголовки столбцов
    column_labels.font.weight = 'bold',
    # Сноски
    footnotes.font.size = 12,
    # Примечания
    source_notes.font.size = 12
  ) %>% 
  # Ячейки таблицы
  tab_style(
    style = cell_text(font = "Arial", size = 12),
    locations = list(
      cells_body(),
      cells_column_labels(),
      cells_column_spanners())
  ) %>% 
  # Столбец Диагноз
  tab_style(
    style = cell_text(font = "Times New Roman", style = 'italic', size = 16, v_align = "middle" ),
    locations = cells_body(columns = diagnosis)
  ) %>% 
  # Строка итогов
  tab_style(
    style = cell_text(font = "Arial", weight = 'bold', style = 'normal', size = 12 ),
    locations = cells_body(rows = length(diagnosis))
  ) %>% 
  # Сноски и источники
  tab_style(
    style = cell_text(style = 'italic'),
    locations = list(
      cells_footnotes(),
      cells_source_notes())
  )  %>% 
  # Выравнивание по центру для столбца Случаев
  tab_style(
    style = cell_text(align = "center"),
    locations = list(
      cells_body(columns = n),
      cells_column_labels(columns = n))
  ) %>%
  # Выравнивание по левому краю для подзаголовка
  tab_style(
    style = cell_text(align = "left"),
    locations = cells_title(c("subtitle"))
  ) %>% 
  # Выравнивание по правому краю для источника
  tab_style(
    style = cell_text(align = "right"),
    locations = cells_source_notes()
  ) %>% 
  # Выравнивание по центру для заголовков столбцов
  tab_style(
    style = cell_text(v_align = "middle"),
    locations = list(
      cells_column_labels(),
      cells_column_spanners())
  )
gt

gt <- gt %>% 
  # Курсив и форматирование для названий групп
  tab_style(
    style = cell_text(style = "italic"),
    locations = cells_row_groups()
  ) %>% 
  text_transform(
    locations = cells_row_groups(),
    fn = function(x) {
      lapply(x, function(x) {
        x <- str_to_title(x)
      })
    }
  ) %>% 
  # Замена NA в названиях групп
  text_transform(
    locations = cells_row_groups(groups = "NA"),
    fn = function(x){ "Неуточненный" }
  ) %>% 
  # Замена Всего в столбце Пол
  text_transform(
    locations = cells_body(columns = sex, rows = sex == "Всего"),
    fn = function(x){ "" }
  ) %>% 
  # Выделение строки итогов
  tab_style(
    style = cell_text(font = "Arial", style = "normal", weight = "bold"),
    locations = cells_row_groups(groups = "Всего")
  ) %>% 
  # Добавление заголовка с столбцу с названиями групп
  tab_stubhead(label = "Диагноз") %>% 
  tab_style(
    style = cell_text(font = "Arial", style = "normal", weight = "bold", 
                      v_align = "middle"),
    locations = cells_stubhead()
  )
gt


#### Выделение границ ####

# Настройка границ глобально для всей таблицы
# Возможные значения стилей границ "solid" (the default), "dashed", "dotted", "hidden", or "double"
gt_colored <- gt %>% 
  tab_options(
    # Убираем верхние и нижние границы для таблицы
    table.border.top.style = "hidden",
    table.border.bottom.style = "hidden",
    # Задаем границы для заголовка
    heading.border.bottom.style = "solid",
    heading.border.bottom.width = 2,
    heading.border.bottom.color = "green",
    # Задаем линии в заголовках столбцов
    column_labels.border.top.style = "solid",
    column_labels.border.top.width = 2,
    column_labels.border.top.color = "red",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = 2,
    column_labels.border.bottom.color = "red",
    # Устанавливаем верхние и нижние границы для тела таблицы
    table_body.border.top.style = "solid",
    table_body.border.top.color = "blue",
    table_body.border.top.width = 2,
    table_body.border.bottom.style = "solid",
    table_body.border.bottom.color = "black",
    table_body.border.bottom.width = 2,
    # Задаем вертикальные и горизонтальные линии в теле таблицы
    table_body.hlines.style = "solid",
    table_body.hlines.width = 1,
    table_body.hlines.color = "orange",
    table_body.vlines.style = "hidden",
    # Группы строк
    row_group.border.top.width = 1, 
    row_group.border.bottom.width = 1
  )
gt_colored


gt <- gt %>% 
  tab_options(
    # Убираем верхние и нижние границы для таблицы
    table.border.top.style = "hidden",
    table.border.bottom.style = "hidden",
    # Задаем границы для заголовка
    heading.border.bottom.style = "solid",
    heading.border.bottom.width = 2,
    heading.border.bottom.color = "black",
    # Задаем линии в заголовках столбцов
    column_labels.border.top.style = "solid",
    column_labels.border.top.width = 2,
    column_labels.border.top.color = "black",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = 2,
    column_labels.border.bottom.color = "black",
    # Устанавливаем верхние и нижние границы для тела таблицы
    table_body.border.top.style = "solid",
    table_body.border.top.color = "black",
    table_body.border.top.width = 2,
    table_body.border.bottom.style = "solid",
    table_body.border.bottom.color = "black",
    table_body.border.bottom.width = 2,
    # Задаем вертикальные и горизонтальные линии в теле таблицы
    table_body.hlines.style = "solid",
    table_body.hlines.width = 1,
    table_body.hlines.color = "gray90",
    table_body.vlines.style = "single",
    # Группы строк
    row_group.border.top.width = 1, 
    row_group.border.bottom.width = 1,
    stub_row_group.border.width = 1,
    stub_row_group.border.color = "white"
  )
gt


# Зададим индивидуальные границы для ячеек

gt <- gt %>% 
  # Граница для столбца Случаев
  tab_style(
    locations = list(
      cells_body(columns = c("n")),
      cells_column_labels(columns = c("n"))),
    style = cell_borders(sides = 'right', color = 'black', weight = px(2))
  ) %>% 
  # Убираем горизонтальные линии у ячеек с диагнозами
  tab_style(
    locations = cells_body(columns = "diagnosis", rows = seq(1, 5, by=2)),
    style = cell_borders(sides = 'bottom', color = "white", weight = 1)
  ) %>% 
  # Граница для итоговой строки
  tab_style(
    locations = list( 
      cells_body( rows = diagnosis == "Всего" ),
      cells_row_groups(groups = "Всего" )
    ),
    style = cell_borders(sides = 'top', color = 'black', weight = px(2))
  ) 
gt


#### Окрашивание элементов ####

gt <- gt %>%  
  # Заголовки столбцов для всей таблицы
  tab_options(
    column_labels.background.color = 'grey95'
  ) %>% 
  # Выделим строки, в которых проценты в группе больше 50
  tab_style(
    locations = cells_body(
      columns = c("sex", "n", "percent_diag", "percent_overall"), 
      rows = percent_diag > 50),
    style = cell_fill(color = '#ffa50040')
  ) %>% 
  # Выделим текст, где процент в группе больше 50
  tab_style(
    locations = cells_body(columns = "percent_diag", rows = percent_diag > 50),
    style = cell_text( color = 'red', weight = 'bold')
  )
gt


# Черезстрочное окрашивание 
gt %>% opt_row_striping(row_striping = TRUE)

# gtExtras

if (!require(gtExtras)) install.packages("gtExtras") else library(gtExtras)

gt %>% 
  gt_highlight_rows(rows = diagnosis == "Всего")

#### Весь код полностью #### 

gt <- data %>% gt(groupname_col = "diagnosis", row_group_as_column = TRUE)  %>% 
  # Заменяем пустые значения
  sub_missing(missing_text = "") %>% 
  # Определим названия столбцов
  cols_label(diagnosis = "Диагноз", sex = "Пол", n = "Случаев",
             percent_diag = "в группе", percent_overall = "всего") %>% 
  # Разделим столбцы по разделителям
  tab_spanner(label = "Процент", columns = starts_with("percent_")) %>% 
  # Добавим заголовки и примечания к таблице
  tab_header(title = "Типы диагнозов", subtitle = "Вторая строка заголовка") %>% 
  tab_source_note(source_note = md("На основании данных из набора `cytomegalovirus`")) %>% 
  tab_footnote(footnote = "Доля пациента в рамках диагноза",
               locations = cells_column_labels(columns = percent_diag)) %>% 
  tab_footnote(footnote = "Доля пациентов в рамках исследования",
               locations = cells_column_labels(columns = percent_overall)) %>% 
  # Форматирование значений
  fmt(columns = c(1:2), fns = str_to_title ) %>% 
  fmt_percent(columns = starts_with("percent"), decimals = 2, scale_values = FALSE) %>% 
  # Ширина столбцов
  cols_width(diagnosis:sex ~ px(100), 
             n ~ px(75), 
             starts_with("percent_") ~ px(90)) %>% 
  # Оформляем таблицу
  tab_options(
    # Таблица в целом
    table.font.names = 'Times New Roman',
    table.font.color = 'black',
    table.font.size = 14,
    # Заголовок и подзаголовок
    heading.title.font.size = 18,
    heading.title.font.weight = "bold",
    heading.subtitle.font.size = 16,
    # Заголовки столбцов
    column_labels.font.weight = 'bold',
    # Сноски
    footnotes.font.size = 12,
    # Примечания
    source_notes.font.size = 12
  ) %>% 
  # Ячейки таблицы
  tab_style(
    style = cell_text(font = "Arial", size = 12),
    locations = list(
      cells_body(),
      cells_column_labels(),
      cells_column_spanners())
  ) %>% 
  # Столбец Диагноз
  tab_style(
    style = cell_text(font = "Times New Roman", style = 'italic', size = 16, v_align = "middle" ),
    locations = cells_body(columns = diagnosis)
  ) %>% 
  # Строка итогов
  tab_style(
    style = cell_text(font = "Arial", weight = 'bold', style = 'normal', size = 12 ),
    locations = cells_body(rows = length(diagnosis))
  ) %>% 
  # Сноски и источники
  tab_style(
    style = cell_text(style = 'italic'),
    locations = list(
      cells_footnotes(),
      cells_source_notes())
  )  %>% 
  # Выравнивание по центру для столбца Случаев
  tab_style(
    style = cell_text(align = "center"),
    locations = list(
      cells_body(columns = n),
      cells_column_labels(columns = n))
  ) %>%
  # Выравнивание по левому краю для подзаголовка
  tab_style(
    style = cell_text(align = "left"),
    locations = cells_title(c("subtitle"))
  ) %>% 
  # Выравнивание по правому краю для источника
  tab_style(
    style = cell_text(align = "right"),
    locations = cells_source_notes()
  ) %>% 
  # Выравнивание по центру для заголовков столбцов
  tab_style(
    style = cell_text(v_align = "middle"),
    locations = list(
      cells_column_labels(),
      cells_column_spanners())
  ) %>% 
  # Курсив и форматирование для названий групп
  tab_style(
    style = cell_text(style = "italic"),
    locations = cells_row_groups()
  ) %>% 
  text_transform(
    locations = cells_row_groups(),
    fn = function(x) {
      lapply(x, function(x) {
        x <- str_to_title(x)
      })
    }
  ) %>% 
  # Замена NA в названиях групп
  text_transform(
    locations = cells_row_groups(groups = "NA"),
    fn = function(x){ "Неуточненный" }
  ) %>% 
  # Замена Всего в столбце Пол
  text_transform(
    locations = cells_body(columns = sex, rows = sex == "Всего"),
    fn = function(x){ "" }
  ) %>% 
  # Выделение строки итогов
  tab_style(
    style = cell_text(font = "Arial", style = "normal", weight = "bold"),
    locations = cells_row_groups(groups = "Всего")
  ) %>% 
  # Добавление заголовка с столбцу с названиями групп
  tab_stubhead(label = "Диагноз") %>% 
  tab_style(
    style = cell_text(font = "Arial", style = "normal", weight = "bold", 
                      v_align = "middle"),
    locations = cells_stubhead()
  ) %>% 
  tab_options(
    # Убираем верхние и нижние границы для таблицы
    table.border.top.style = "hidden",
    table.border.bottom.style = "hidden",
    # Задаем границы для заголовка
    heading.border.bottom.style = "solid",
    heading.border.bottom.width = 2,
    heading.border.bottom.color = "black",
    # Задаем линии в заголовках столбцов
    column_labels.border.top.style = "solid",
    column_labels.border.top.width = 2,
    column_labels.border.top.color = "black",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = 2,
    column_labels.border.bottom.color = "black",
    # Устанавливаем верхние и нижние границы для тела таблицы
    table_body.border.top.style = "solid",
    table_body.border.top.color = "black",
    table_body.border.top.width = 2,
    table_body.border.bottom.style = "solid",
    table_body.border.bottom.color = "black",
    table_body.border.bottom.width = 2,
    # Задаем вертикальные и горизонтальные линии в теле таблицы
    table_body.hlines.style = "solid",
    table_body.hlines.width = 1,
    table_body.hlines.color = "gray90",
    table_body.vlines.style = "single",
    # Группы строк
    row_group.border.top.width = 1, 
    row_group.border.bottom.width = 1,
    stub_row_group.border.width = 1,
    stub_row_group.border.color = "white"
  ) %>% 
  # Граница для столбца Случаев
  tab_style(
    locations = list(
      cells_body(columns = c("n")),
      cells_column_labels(columns = c("n"))),
    style = cell_borders(sides = 'right', color = 'black', weight = px(2))
  ) %>% 
  # Убираем горизонтальные линии у ячеек с диагнозами
  tab_style(
    locations = cells_body(columns = "diagnosis", rows = seq(1, 5, by=2)),
    style = cell_borders(sides = 'bottom', color = "white", weight = 1)
  ) %>% 
  # Граница для итоговой строки
  tab_style(
    locations = list( 
      cells_body( rows = diagnosis == "Всего" ),
      cells_row_groups(groups = "Всего" )
    ),
    style = cell_borders(sides = 'top', color = 'black', weight = px(2))
  ) %>% 
  # Заголовки столбцов для всей таблицы
  tab_options(
    column_labels.background.color = 'grey95'
  ) %>% 
  # Выделим строки, в которых проценты в группе больше 50
  tab_style(
    locations = cells_body(
      columns = c("sex", "n", "percent_diag", "percent_overall"), 
      rows = percent_diag > 50),
    style = cell_fill(color = '#ffa50040')
  ) %>% 
  # Выделим текст, где процент в группе больше 50
  tab_style(
    locations = cells_body(columns = "percent_diag", rows = percent_diag > 50),
    style = cell_text( color = 'red', weight = 'bold')
  )
gt

#### Создание собственной темы #### 

# Стандартные темы
gt %>% opt_stylize(style = 6, color = 'pink')

gt1 <- data %>% gt() %>% opt_stylize(style = 1, color = 'blue')
gt1


gt2 <- data %>% gt() %>% opt_stylize(style = 6, color = 'green')
gt2



# Темы gtExtras
# https://r-graph-gallery.com/369-custom-theme-in-gt-table-with-gtextras.html

gt3 <- data %>% gt() %>% gt_theme_excel(color = "lightgrey")
gt3
gtsave(gt3, "gt-extra-excel.png")

# Своя тема
format_my_gt_table <- function(data) { 
  data %>% gt() %>%  tab_options(
    # Убираем верхние и нижние границы для таблицы
    table.border.top.style = "hidden",
    table.border.bottom.style = "hidden",
    # Задаем границы для заголовка
    heading.border.bottom.style = "solid",
    heading.border.bottom.width = 2,
    heading.border.bottom.color = "black",
    # Задаем линии в заголовках столбцов
    column_labels.border.top.style = "solid",
    column_labels.border.top.width = 2,
    column_labels.border.top.color = "black",
    column_labels.border.bottom.style = "solid",
    column_labels.border.bottom.width = 2,
    column_labels.border.bottom.color = "black",
    # Устанавливаем верхние и нижние границы для тела таблицы
    table_body.border.top.style = "solid",
    table_body.border.top.color = "black",
    table_body.border.top.width = 2,
    table_body.border.bottom.style = "solid",
    table_body.border.bottom.color = "black",
    table_body.border.bottom.width = 2,
    # Задаем вертикальные и горизонтальные линии в теле таблицы
    table_body.hlines.style = "solid",
    table_body.hlines.width = 1,
    table_body.hlines.color = "gray90",
    table_body.vlines.style = "single",
    # Группы строк
    row_group.border.top.width = 1, 
    row_group.border.bottom.width = 1,
    stub_row_group.border.width = 1,
    stub_row_group.border.color = "white",
  )
}

gt_data <- data %>% format_my_gt_table()
gt_data

gt_data_age <- data_age %>% format_my_gt_table()
gt_data_age

data_age %>% gt()

#### Сохранение таблиц #### 

gt

# .html, .tex, .ltx, .rtf, .docx
gt %>% gtsave("gt.html")
gt %>% gtsave("gt.docx")
gt %>% gtsave("gt.png")

# png 
if (!require(webshot2)) { 
  install.packages("webshot2")
  library(webshot2)
}
gt %>% gtsave_extra("gt.png", zoom = 3, expand = 5)

#### Тепловые карты ####
data_age

gt_color <- cytomegalovirus %>% head(10) %>% 
  select(ID, diagnosis, TNC.dose, CD34.dose, CD3.dose) %>% 
  gt() %>% data_color(columns = TNC.dose:CD3.dose, colors = c("white", "red")) 
gt_color
gtsave(gt_color, "gt-heatmap.png")

#### Добавление интерактивности ####
gt3 <- data %>%  gt() %>% 
  opt_interactive(
    use_search = TRUE,
    use_filters = TRUE,
    use_resizers = TRUE,
    use_highlight = TRUE,
    use_compact_mode = TRUE,
    use_text_wrapping = TRUE,
    use_page_size_select = TRUE
  )
gt3

#### Графики в таблицах ####
# https://jthomasmock.github.io/gtExtras/index.html
if (!require(gtExtras)) install.packages("gtExtras")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(svglite)) install.packages("svglite")


data <- cytomegalovirus %>% 
  group_by(diagnosis) %>% 
  summarise(
    mean = mean(time.to.transplant),
    sd = sd(time.to.transplant),
    time.to.transplant.data = list(time.to.transplant),
    .groups = "drop"
  )
data

data %>%
  arrange(desc(diagnosis)) %>% 
  gt() %>%
  gtExtras::gt_plt_sparkline(time.to.transplant.data) %>%
  fmt_number(columns = mean:sd, decimals = 1)

gt_plot <- data %>% arrange(desc(diagnosis)) %>% head() %>% gt() %>% 
  gt_plt_dist(time.to.transplant.data, type = "density", line_color = "blue", fill_color = "red") %>%
  fmt_number(columns = mean:sd, decimals = 1)
gt_plot
gtsave(gt_plot, "gt-plot.png")
