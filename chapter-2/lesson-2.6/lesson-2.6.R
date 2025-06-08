#### Подготовка данных ####

if (!require(medicaldata)) install.packages("medicaldata")
if (!require(tidyverse)) install.packages("tidyverse")

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

# Сформируем строку итогов
data_sum <- data %>% 
  group_by() %>% 
  summarise(n = sum(n), percent_overall = sum(percent_overall)) %>% 
  ungroup() %>% 
  mutate(diagnosis = "Всего", sex = "Всего", percent_diag = NA)

# Объединим две таблицы
data <- bind_rows(data, data_sum)
data_sum <- NULL

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

# Объединим две таблицы
data_age <- bind_rows(data_age, data_age_sum)
data_age_sum <- NULL

#### Сохранение в буфер обмена ####

# Запись в буфер обмена
write.table(data, "clipboard", sep="\t", row.names=FALSE)

# Чтение из буфера обмена
data_from_cb <- read.delim("clipboard")  

#### Сохранение таблиц в текстовые форматы ####

if (!require(readr)) install.packages("readr")

write_tsv(data, file = "data/data_tsv.txt")

write_csv(data, file = "data/data_csv.csv")

write_csv2(data, file = "data/data_csv2.csv")

write_excel_csv(data, file = "data/data_excel_csv.csv")

write_excel_csv2(data, file = "data/data_excel_csv2.csv")

write_delim(data,  file = "data/data_delim.csv", 
            delim = "|", 
            na = "-",
            append = FALSE,
            quote = "all",
            escape = "backslash",
            eol = "\n"
)

#### Сохранение таблиц в форматы SAS, SPSS, Stata ####

if (!require(haven)) install.packages("haven")
if (!require(stringr)) install.packages("haven")

# STATA
write_dta(data = data,
          path = "data/data.dta",  
          version = 14,
          label = attr(data, "label"),
          strl_threshold = 2045,
          adjust_tz = TRUE
)

# Чтобы исправить ошибку, нужно переделать имена столбцов
colnames(data) <- str_replace_all(colnames(data),  "\\.", "_")
write_dta(data = data,
          path = "data/data.dta",
          version = 14,
          label = attr(data, "label"),
          strl_threshold = 2045,
          adjust_tz = TRUE
)

# SPSS
write_sav(data, 
          path = "data/data.sav", 
          compress = c("byte", "none", "zsav"), 
          adjust_tz = TRUE)

# SAS
write_xpt(data,
          path = "data/data.xpt",
          version = 8,
          name = NULL,
          label = attr(data, "label"),
          adjust_tz = TRUE
)

#### Сохранение таблиц в Excel ####

if (!require(openxlsx)) install.packages("openxlsx")

# Сохранение таблицы
write.xlsx(data, "data/myworkbook.xlsx")

# Сохранение каждой таблицы на отдельном листе
write.xlsx(list("Количество" = data, "Возраст" = data_age), 
           file = "data/myworkbook.xlsx",
           asTable = TRUE)

##### Сохранение графиков. Растровые форматы #####

# В формате png
png("data/boxplot.png", height=800, width=800, res=250, pointsize=8)
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

# В формате jpg
jpeg("data/boxplot.jpg", height=800, width=800, res=250, pointsize=8)
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

# В формате bmp
bmp("data/boxplot.bmp", height=800, width=800, res=250, pointsize=8)
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

# В формате tiff
tiff("data/boxplot.tiff", height=800, width=800, res=250, pointsize=8)
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

##### Сохранение графиков. Векторные форматы #####

# В формате svg
svg("data/boxplot.svg")
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

# В формате postscript
postscript("boxplot.ps")
boxplot(age ~ sex, cytomegalovirus, col = "green")
dev.off()

