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