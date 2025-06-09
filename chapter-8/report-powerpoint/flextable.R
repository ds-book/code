if (!require(flextable)) install.packages("flextable")
if (!require(officer)) install.packages("officer")

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
