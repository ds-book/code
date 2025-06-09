if (!require(gt))
  install.packages("gt")

gt_table <- data %>% gt(groupname_col = "diagnosis", row_group_as_column = TRUE) %>% 
  # Заменяем пустые значения
  sub_missing(missing_text = "") %>%
  # Определим названия столбцов
  cols_label(
    diagnosis = "Диагноз",
    sex = "Пол",
    n = "Случаев",
    percent_diag = "в группе",
    percent_overall = "всего"
  ) %>%
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
  fmt(columns = c(1:2), fns = str_to_title) %>%
  fmt_percent(
    columns = starts_with("percent"),
    decimals = 2,
    scale_values = FALSE
  ) %>%
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
    locations = list(cells_body(), cells_column_labels(), cells_column_spanners())
  ) %>%
  # Столбец Диагноз
  tab_style(
    style = cell_text(
      font = "Times New Roman",
      style = 'italic',
      size = 16,
      v_align = "middle"
    ),
    locations = cells_body(columns = diagnosis)
  ) %>%
  # Строка итогов
  tab_style(
    style = cell_text(
      font = "Arial",
      weight = 'bold',
      style = 'normal',
      size = 12
    ),
    locations = cells_body(rows = length(diagnosis))
  ) %>%
  # Сноски и источники
  tab_style(
    style = cell_text(style = 'italic'),
    locations = list(cells_footnotes(), cells_source_notes())
  )  %>%
  # Выравнивание по центру для столбца Случаев
  tab_style(
    style = cell_text(align = "center"),
    locations = list(cells_body(columns = n), cells_column_labels(columns = n))
  ) %>%
  # Выравнивание по левому краю для подзаголовка
  tab_style(style = cell_text(align = "left"), locations = cells_title(c("subtitle"))) %>%
  # Выравнивание по правому краю для источника
  tab_style(style = cell_text(align = "right"), locations = cells_source_notes()) %>%
  # Выравнивание по центру для заголовков столбцов
  tab_style(
    style = cell_text(v_align = "middle"),
    locations = list(cells_column_labels(), cells_column_spanners())
  ) %>% 
 # Курсив и форматирование для названий групп
  tab_style(style = cell_text(style = "italic"), locations = cells_row_groups()) %>%
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
    fn = function(x) {
      "Неуточненный"
    }
  ) %>%
  # Замена Всего в столбце Пол
  text_transform(
    locations = cells_body(columns = sex, rows = sex == "Всего"),
    fn = function(x) {
      ""
    }
  ) %>%
  # Выделение строки итогов
  tab_style(
    style = cell_text(
      font = "Arial",
      style = "normal",
      weight = "bold"
    ),
    locations = cells_row_groups(groups = "Всего")
  ) %>%
  # Добавление заголовка с столбцу с названиями групп
  tab_stubhead(label = "Диагноз") %>%
  tab_style(
    style = cell_text(
      font = "Arial",
      style = "normal",
      weight = "bold",
      v_align = "middle"
    ),
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
    locations = list(cells_body(columns = c("n")), cells_column_labels(columns = c("n"))),
    style = cell_borders(
      sides = 'right',
      color = 'black',
      weight = px(2)
    )
  ) %>%
  # Убираем горизонтальные линии у ячеек с диагнозами
  tab_style(
    locations = cells_body(columns = "diagnosis", rows = seq(1, 5, by = 2)),
    style = cell_borders(
      sides = 'bottom',
      color = "white",
      weight = 1
    )
  ) %>%
  # Граница для итоговой строки
  tab_style(
    locations = list(
      cells_body(rows = diagnosis == "Всего"),
      cells_row_groups(groups = "Всего")
    ),
    style = cell_borders(
      sides = 'top',
      color = 'black',
      weight = px(2)
    )
  ) %>% 
  # Заголовки столбцов для всей таблицы
  tab_options(column_labels.background.color = 'grey95') %>%
  # Выделим строки, в которых проценты в группе больше 50
  tab_style(
    locations = cells_body(
      columns = c("sex", "n", "percent_diag", "percent_overall"),
      rows = percent_diag > 50
    ),
    style = cell_fill(color = '#ffa50040')
  ) %>%
  # Выделим текст, где процент в группе больше 50
  tab_style(
    locations = cells_body(columns = "percent_diag", rows = percent_diag > 50),
    style = cell_text(color = 'red', weight = 'bold')
  )
