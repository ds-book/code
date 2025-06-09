if (!require(dplyr)) { 
  install.packages("dplyr")
  library(dplyr)
}
if (!require(here)) { 
  install.packages("here")
  library(here)
}

raw <- read.csv2(here("data", "raw", "cytomegalovirus.csv"))

#### Перекодируем исходные данные ####

data <- raw %>%
  mutate(
    sex = recode(sex, `1` = "Male", `0` = "Female"),
    race = recode(race, `1`= "White", `0` = "African American"),
    diagnosis.type = recode(diagnosis.type, `1` = "Myeloid", `0` = "Lymphoid"),
    prior.radiation = recode(prior.radiation, `0` = "No", `1` = "Yes"),
    prior.transplant = recode(prior.transplant, `0` = "No", `1` = "Yes"),
    recipient.cmv = recode(recipient.cmv, `0` = "Negative", `1` = "Positive"),
    donor.cmv = recode(donor.cmv, `0` = "Negative", `1` = "Positive"),
    donor.sex = recode(donor.sex, `1` = "Male", `0` = "Female"),
    C1.C2 = recode(C1.C2, `1` = "Homozygous", `0` = "Heterozygous"),
    cmv = recode(cmv, `0` = "No", `1` = "Yes"),
    agvhd = recode(agvhd, `0` = "No", `1` = "Yes"),
    cgvhd = recode(cgvhd, `0` = "No", `1` = "Yes")
  )
head(data)  

#### Определим группы возраста ####

data <- data %>% 
  mutate(
    age.group = case_when(
      age < 18 ~ "детский",
      age >= 18 & age <= 44 ~ "молодой",
      age >= 45 & age <= 59 ~ "средний",
      age >= 60 & age <= 74 ~ "пожилой",
      age >= 75 & age <= 90 ~ "старческий",
      age > 90 ~ "долголетие",
      is.na(age) ~ "нет данных"
    )
  ) %>% 
  relocate(age.group, .after = age)
head(data)  

#### Сохраним подготовленный набор данных ####

saveRDS(data, here("data" , "clean", "cytomegalovirus.rds"))
  
