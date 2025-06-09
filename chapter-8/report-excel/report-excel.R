#### Подготовка данных ####

source("data-table.R")

#### Отчеты в Excel с openxlsx ####

library(openxlsx)
library(tidyverse)

data_excel <- data %>% 
  dplyr::mutate(diagnosis = ifelse(is.na(diagnosis), "Неуточненный", diagnosis),
                percent_diag = round(ifelse(is.na(percent_diag), 0, percent_diag), 2),
                percent_overall = round(percent_overall, 2))

# Создаем книгу
wb <- createWorkbook()

# Добавляем лист
sheet = "Данные"
addWorksheet(wb, sheetName = sheet, gridLines = TRUE)

#### Текст ####

# Пишем заголовок
writeData(wb, sheet, "Заголовок для таблицы", startCol = 1, startRow = 1)
# Объединяем первые три ячейки, чтобы записать заголовок
mergeCells(wb, sheet, cols = 1:ncol(data_excel), rows = 1)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Пишем на новый лист таблицу со второй строки
writeData(wb, sheet, data_excel, colNames = TRUE, rowNames = FALSE, startCol = 1, startRow = 2)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Создадим стиль для заголовка
headerStyle <- createStyle(fontSize = 12, fontColour = "black",
                           halign = "center", valign = "center", fgFill = "mistyrose",
                           border = "TopBottomLeftRight", borderColour = "black",
                           textDecoration = "bold", wrapText = TRUE)
# Применим стиль для текста заголовка таблицы
addStyle(wb, sheet, headerStyle, rows = 1, cols = 1, gridExpand = TRUE)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Создадим стиль для заголовков столбцов таблицы
tableHeaderStyle <- createStyle(fontSize = 12, fontColour = "black",
                                halign = "center", valign = "center", fgFill = "lightcyan2",
                                border = "TopBottomLeftRight", borderColour = "black",
                                textDecoration = "bold", wrapText = TRUE)
# Применим стиль для заголовков столбцов таблицы
addStyle(wb, sheet, tableHeaderStyle, rows = 2, cols = 1:ncol(data_excel), gridExpand = TRUE)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Зададим ширину столбцов таблицы
setColWidths(wb, sheet, cols = 1:ncol(data_excel), widths = "auto")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

#### Изображения ####

# Добавим изображение
insertImage(wb, sheet, "boxplot.png", width = 6, height = 6, units = "cm", startCol = 6, startRow = 1)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Добавим график ggplot2
library(ggplot2)
gg <- ggplot(cytomegalovirus %>% dplyr::mutate(sex = ifelse(sex == 1, "M", "F")), aes(sex, age)) + geom_boxplot()
print(gg)
insertPlot(wb, sheet, width = 6, height = 6, units = "cm", xy= c("F", 1), fileType = "png")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

#### Стили и оформление ####

# Стили для окрашивания ячеек
# Добавляем лист
sheet2 = "cytomegalovirus"
addWorksheet(wb, sheet2, gridLines = TRUE)
writeData(wb, sheet2, cytomegalovirus, colNames = TRUE, rowNames = FALSE, na.string = "")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Условное форматирование на равенство/неравенство
conditionalFormatting(wb, sheet2,
                      style = createStyle(bgFill = "salmon"),
                      cols = 3, rows = 1:(1+nrow(cytomegalovirus)),
                      type = "expression",
                      rule = "==1")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Градиентное окрашивание
conditionalFormatting(wb, sheet2,
                      style = c("white", "red"),
                      cols = 2, rows = 1:(1+nrow(cytomegalovirus)),
                      type = "colourScale",
                      rule = c(29, 70))
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Подсветка одинаковых значений
conditionalFormatting(wb, sheet2,
                      style = createStyle(bgFill = "gold"),
                      cols = 7, rows = 1:(1+nrow(cytomegalovirus)),
                      type = "duplicates")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Топ значений
conditionalFormatting(wb, sheet2,
                      style = createStyle(bgFill = "cyan"),
                      cols = 7, rows = 1:(1+nrow(cytomegalovirus)),
                      type = "topN",
                      rank = 10, percent = TRUE)
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

# Значения которые начинаются
conditionalFormatting(wb, sheet2,
                      style = createStyle(bgFill = "green"),
                      cols = 5, rows = 3:(3+nrow(cytomegalovirus)),
                      type = "beginsWith",
                      rule = "Hodgkin")
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

#### Пароль ####

# Можно даже защитить документ паролем
protectWorksheet(wb, sheet, password = "123")
protectWorkbook(wb, password = "123")

# Сохраним документ
saveWorkbook(wb, "openxlsx_report.xlsx", overwrite = TRUE)

