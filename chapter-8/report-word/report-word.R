#### Подготовка данных ####

source("data-table.R")

#### Отчеты в Word с officer ####

# https://davidgohel.github.io/officer/

if (!require(officer)) install.packages("officer") 
if (!require(flextable)) install.packages("flextable")
if (!require(gt)) install.packages("gt")
if (!require(gto)) install.packages("gto")
# Sys.setlocale("LC_ALL","ru_RU")

# Создаем новый документ в памяти
doc <- read_docx()
# Записываем в него заголовок
doc <- doc %>% body_add_par("Заголовок документа", style = "heading 1")
# Вставляем оглавление
doc <- body_add_toc(doc, style = "toc 1")
# После оглавления вставим разрыв страницы
doc <- body_add_break(doc)
# Сохраняем результат в файл на диске
print(doc, target = "officer_report.docx")

#### Текст ####

# Обычный текст
doc <- body_add_par(doc, "Текст", style = "heading 2")
doc <- body_add_par(doc, "Это пример обычного текста со стандартным оформлением")
doc <- body_add_par(doc, "")
print(doc, target = "officer_report.docx")


# Форматированный текст
doc <- body_add_fpar(doc, ftext(
  "This text is red",
  fp_text(color = "#C32900", bold = TRUE, font.size = 16)
))
print(doc, target = "officer_report.docx")

# Форматированный текст можно объединять друг с другом
paragraph <- fpar(
  ftext("Этот текст красный", fp_text(color = "#C32900", bold = TRUE, font.size = 16)),
  " а следом идет уже ",
  ftext("синий текст", fp_text(color = "#006699"))
)
doc <- body_add_fpar(doc, paragraph)
print(doc, target = "officer_report.docx")

# Дополнительные настройки для абзаца
paragraph2 <- fpar(
  ftext("Этот текст красный", fp_text(color = "red", bold = TRUE, font.size = 16)),
  " а следом идет уже ",
  ftext("зеленый текст", fp_text(color = "green")),
  fp_p = fp_par(
    padding = 5,
    line_spacing = 2,
    text.align = "center",
    border.top = fp_border(
      width = 5,
      color = "#C32900"
    ))
)
doc <- body_add_fpar(doc, paragraph2)
print(doc, target = "officer_report.docx")

doc <- body_add_par(doc, "Таблицы", style = "heading 2")

#### Таблица ####

# Добавим таблицу
doc <- body_add_par(doc, "Простая таблица", style = "Table Caption")
doc <- body_add_table(doc, data)
doc <- body_add_par(doc, "")

# Добавим таблицу со стилем
doc <- body_add_par(doc, "Таблица со стилем Table Professional", style = "Table Caption")
doc <- body_add_table(doc, data, style = "Table Professional")
doc <- body_add_par(doc, "")

# Добавим таблицу со стилем
doc <- body_add_par(doc, "Таблица со стилем table_template", style = "Table Caption")
doc <- body_add_table(doc, data, style = "table_template")
doc <- body_add_par(doc, "")

print(doc, target = "officer_report.docx")

#### Таблица flextable ####

source("flextable.R")

# Добавим таблицу flextable
doc <- body_add_break(doc)
doc <- body_add_par(doc, "Таблица flextable", style = "heading 3")
doc <- body_add_flextable(doc, ft_full)
doc <- body_add_par(doc, "")

print(doc, target = "officer_report.docx")

# Добавим таблицу flextable на всю ширину страницы
doc <- body_add_par(doc, "Таблица flextable во всю ширину", style = "heading 3")
doc <- body_add_flextable(doc, ft_full %>% set_table_properties(width = 1, layout = "autofit"))
doc <- body_add_par(doc, "")

print(doc, target = "officer_report.docx")

#### Таблица gt ####

source("gt.R")

# Добавим таблицу gt
if (!require(gto)) install.packages("gto")

doc <- body_add_break(doc)
doc <- body_add_par(doc, "Таблица gt", style = "heading 3")
doc <- body_add_gt(doc, gt_table)
doc <- body_add_par(doc, "")

print(doc, target = "officer_report.docx")

#### Изображения ####

# Добавление изображений
doc <- body_add_par(doc, "Графики", style = "heading 2")
print(doc, target = "officer_report.docx")

# Добавим файл изображения в документ
doc <- body_add_par(doc, "Это график из файла", style = "Image Caption")
doc <- body_add_img(doc, src = "boxplot.png", width = 5, height = 5)
doc <- body_add_par(doc, "")

# Добавим график из кода
doc <- body_add_par(doc, "Это график из кода", style = "Image Caption")
doc <- body_add_plot(doc, value = boxplot(age ~ sex, cytomegalovirus, col = "green"), 
                     width = 4, height = 4, res = 300)
doc <- body_add_par(doc, "")

# Добавим график ggplot
if (!require(ggplot2)) install.packages("ggplot2")
gg <- ggplot(cytomegalovirus %>% mutate(sex = ifelse(sex == 1, "M", "F")), aes(sex, age)) + geom_boxplot()
doc <- body_add_par(doc, "Это график из ggplot", style = "Image Caption")
doc <- body_add_gg(doc, value = gg, width = 4, height = 4, res = 300)
doc <- body_add_par(doc, "")

# Добавим график MS Office
if (!require(mschart)) install.packages("mschart")
doc <- body_add_break(doc)
bc <- ms_barchart(data = cytomegalovirus %>% mutate(sex = ifelse(sex == 1, "M", "F")), 
                  x = "sex", y = "age", group = "diagnosis")
doc <- body_add_par(doc, "Это график MS Office", style = "Image Caption")
doc <- body_add_chart(doc, chart = bc, style = "Normal", width = 6, height = 8)
doc <- body_add_par(doc, "")

print(doc, target = "officer_report.docx")

#### Оглавление ####

# Вставляем оглавление
doc <- body_add_toc(doc, style = "toc 1")
print(doc, target = "officer_report.docx")

