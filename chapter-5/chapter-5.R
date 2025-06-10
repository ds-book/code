# Создание вектора случайных 1000 числовых значений уровня гемоглобина для мужчин со средним значением 145 и разбросом (стандартным отклонением) в 10.
hb <- rnorm(n = 1000, mean = 145, sd = 10)
# Создание вектора из 1000 значений "male".
sex <- rep(x = "male", 1000)
# Объединение вектора sex и hb в таблицу данных, в которой будет содержаться уровень гемоглобина для мужчин.
male_hb <- data.frame(hb = hb, sex = sex)
# Создание вектора случайных 1000 числовых значений уровня гемоглобина для женщин со средним значением 130 и разбросом (стандартным отклонением) в 10.
hb <- rnorm(n = 1000, mean = 130, sd = 10)
# Создание вектор из 1000 значений "female".
sex <- rep(x = "female", 1000)
# Объединение вектора sex и hb в таблицу данных, в которой будет содержаться уровень гемоглобина для мужчин.
female_hb <- data.frame(hb = hb, sex = sex)
# Объединение таблицы построчно male_hb и female_hb в единую таблицу.
all_hb <- rbind(male_hb, female_hb)
# Просмотр первых 10 строк таблицы, чтобы ознакомиться с результатом.
head(all_hb, 10)
hb  sex
1  121.0623 male
2  136.6906 male
3  133.5448 male
4  151.9570 male
5  136.1877 male
6  149.4126 male
7  159.3978 male
8  140.7717 male
9  133.6316 male
10 146.2105 male

# Более короткий вариант генерации таблицы.
male_hb <- data.frame(hb = rnorm(1000, mean = 145, sd = 10), sex = "male")
female_hb <- data.frame(hb = rnorm(1000, mean = 130, sd = 10), sex = "female")
all_hb <- rbind(male_hb, female_hb)

library(ggplot2)
ggplot(data = all_hb, aes(x = hb, fill = sex, color = sex)) +
  geom_histogram(alpha = 0.6, position ="identity") +
  theme_light() +
  labs(y = "Кол-во", x = "Уровень гемоглобина, мг/л")


# Создание вектора случайных 1000 числовых значений уровня гемоглобина для мужчин со средним значением 145 и разбросом  (стандартным отклонением) в 10 и добавляем 1000 одинаковых значений равных 100 для создания перекоса в распределении.
assym_hb <- c(rnorm(1000, mean = 145, sd = 10), c(rep(100, 1000)))
# Отображение гистограммы и вертикальной линии, соответствующей среднему арифметическому.
ggplot() + 
  aes(assym_hb) + 
  geom_histogram(alpha = 0.6, position ="identity", fill = "#66d9dc", color = "#66d9dc") +
  theme_light() +
  labs(y = "Кол-во", x = "Уровень гемоглобина, мг/л") +
  geom_vline(xintercept = mean(assym_hb), linetype="dashed", color = "red",   size = 1)

# Пример расчета среднего арифметического.
mean(x = assym_hb, trim = 0, na.rm = TRUE)


ggplot() + 
  aes(assym_hb) + 
  geom_histogram(alpha = 0.6, position ="identity", fill = "#66d9dc", color = "#66d9dc") +
  theme_light() +
  labs(y = "Кол-во", x = "Уровень гемоглобина, мг/л") +
  geom_vline(xintercept = median(assym_hb), linetype="dashed", color = "red", size = 1)


# Пример расчета медианы.
median(x = assym_hb, na.rm = TRUE)


# Создание функции для расчета моды.
getmode <- function(x) {
  uniqx <- unique(x)
  uniqx[which.max(tabulate(match(x, uniqx)))]
}
# Вызов созданной функции.
getmode(x = assym_hb)


library(dplyr)
# Создание новой таблицы all_hb_summary в которой будут храниться результаты расчетов и передача таблицы all_hb далее в обработку.
all_hb_summary <- all_hb %>% 
  # Объявление группирующего столбца - далее все операции будут выполняться отдельно для категорий male и female столбца sex. Передача таблицы далее.
  group_by(sex) %>% 
  # Создание новых столбцов median_hb, mean_hb и mode_hb, которые формируются на основе использования функций median, mean и mode соответственно (учитывая, что ранее таблица была сгруппирована, все расчеты делаются автоматически отдельно для категорий male и female).
  summarise(median_hb = median(hb, na.rm = TRUE),
            mean_hb = mean(hb, na.rm = TRUE),
            mode_hb = getmode(hb)
  )

# Вывод таблицы all_hb_summary.
all_hb_summary


# Столбчатая гистограмма, отражающая уровень гемоглобина для мужчин и женщин. Сохранение в plot1.
plot1 <- ggplot(data = all_hb, aes(x = hb, fill = sex, color = sex)) +
  geom_histogram(alpha = 0.6, position = "identity") +
  theme_light() +
  labs(y = "Кол-во", x = "Уровень гемоглобина, мг/л")
# Добавление к графику plot1 новых элементов из таблицы all_hb_summary: медианы, моды и среднего арифметического.
plot1 +
  # Добавление пунктирной вертикальной линии, отражающей медиану.
  geom_vline(data = all_hb_summary, aes(xintercept = median_hb, color = sex), size = 1, linetype = "dashed") +
  # Добавление непрерывной вертикальной линии, отражающей среднее арифметическое.
  geom_vline(data = all_hb_summary, aes(xintercept = mean_hb, color = sex), size = 0.7) +
  # Добавление точечной вертикальной линии, отражающей моду.
  geom_vline(data = all_hb_summary, aes(xintercept = mode_hb, color = sex), size = 1.3, linetype = "dotted")


# Пример расчета разброса.
max(x = assym_hb, na.rm = TRUE)
min(x = assym_hb, na.rm = TRUE)
# Пример расчета квантилей.
quantile(x = assym_hb)
# Пример расчета квартилей и прочих мер с использованием функции summary.
summary(assym_hb)
# Пример расчета стандартного отклонения.
sd(x = assym_hb, na.rm = TRUE)
# Пример расчета стандартной ошибки среднего.
sd(assym_hb, na.rm = TRUE) /  
  sqrt(length(assym_hb[!is.na(assym_hb)]))
# Пример расчета дисперсии.
sd(x = assym_hb)^2


library(dplyr)
# Создание новой таблицы all_hb_summary в которой будут храниться результаты расчетов и передаем таблицу all_hb далее в обработку.
all_hb_summary <- all_hb %>% 
  # Объявление группирующего столбца - далее все операции будут выполняться отдельно для категорий male и female столбца sex. Передача таблицы далее.
  group_by(sex) %>% 
  # Создание новых столбцов с мерами центральных тенденций и мерами разброса которые создаются на основе использования ранее описанных функций (учитывая, что ранее таблица была сгруппирована, все расчеты делаются автоматически отдельно для категорий male и female).
  summarise(median_hb = median(hb, na.rm = TRUE),
            mean_hb = mean(hb, na.rm = TRUE),
            mode_hb = getmode(hb),
            min_hb = min(hb),
            max_hb = max(hb),
            min_hb = min(hb),
            Q1_hb = quantile(hb, prob = c(.25)),
            Q3_hb = quantile(hb, prob = c(.75)),
            sd_hb = sd(hb),
            d_hb = sd(hb)^2
  )
# Вывод таблицы all_hb_summary.
all_hb_summary


# Столбчатая гистограмма, отражающая уровень гемоглобина для мужчин и женщин. Сохранение в plot1.
plot1 <- ggplot(data = all_hb, aes(x = hb, fill = sex, color = sex)) +
  geom_histogram(alpha = 0.6, position ="identity") +
  theme_light() +
  labs(y = "Кол-во", x = "Уровень гемоглобина, мг/л")
# Добавление к графику plot1 новых элементов из таблицы all_hb_summary: стандартного отклонения, 1-го и 3-квартиля. 
plot1 +
  # Добавление стандартного отклонения в правую сторону от среднего (для этого к значениям столбца mean_hb прибавляем значения столбца sd_hb). 
  geom_vline(data = all_hb_summary, aes(xintercept = mean_hb + sd_hb, color = sex), size = 1)+
  # Добавление стандартного отклонения в левую сторону от среднего (для этого из значений столбца mean_hb вычитаем значения столбца sd_hb). 
  geom_vline(data = all_hb_summary, aes(xintercept = mean_hb - sd_hb, color = sex), size = 1)+
  # Добавление 1-го квартиля.
  geom_vline(data = all_hb_summary, aes(xintercept = Q1_hb, color = sex), linetype = "dotted", size = 1.3) +
  # Добавление 3-го квартиля.
  geom_vline(data = all_hb_summary, aes(xintercept = Q3_hb, color = sex), linetype = "dotted", size = 1.3)


# Создание таблицы для первой группы, содержащей 100 строк (записей пациентов): 30 пациентов имеют положительный ответ на терапию, 60 пациентов не имеют ответа на терапию.
group_1 <- data.frame(group = "group1", outcome = c(rep("yes", 30), rep("no", 70)))
# Создание таблицы для второй группы, содержащей 100 строк (записей пациентов): 60 пациентов имеют положительный ответ на терапию, 40 пациентов не имеют ответа на терапию.
group_2 <- data.frame(group = "group2", outcome = c(rep("yes", 60), rep("no", 40)))
# Объединение таблицы построчно group_1 и group_2 в единую таблицу.
trt_data <- rbind(group_1, group_2)
# Вывод на просмотр первые 10 строк таблицы для ознакомления с результатом.
head(trt_data)


# Пример использования функции table.
table(trt_data$group, trt_data$outcome)


# Для смены столбцов и строк местами в результатах расчетов необходимо  в функции table поменять последовательность столбцов.
table(trt_data$outcome, trt_data$group)

# Создание таблицы абсолютных частот и сохранение ее в result.
result <- table(trt_data$group, trt_data$outcome)
result    
# Расчет относительных частот (доля): за 100% берется общее количество по всем ячейкам.
prop.table(result)     
# Расчет относительных частот (доля): за 100% берется общее количество отдельно по каждой строке.
prop.table(result, margin = 1)
# Расчет относительных частот (доля): за 100% берется общее количество отдельно по каждому столбцу.
prop.table(result, margin = 2) 
# Для получения процентов необходимо доли умножить 100.
# Пример расчета процентов.
prop.table(result, margin = 1) * 100



# Добавление столбца пол (sex), с случайным заполнением.
trt_data$sex <- sample(c("male", "female"),size = nrow(trt_data), replace = TRUE)
# Добавление столбца стадия (stage), с случайным заполнением.
trt_data$stage <- sample(c("1st", "2nd", "3rd", "4th"),size = nrow(trt_data), replace = TRUE)
# Вывод на просмотр первые 10 строк таблицы для ознакомления с результатом.
head(trt_data)


trt_data %>%
  # Группировка по столбцам group и outcome (далее все расчеты автоматически выполняются отдельно для каждой группы, и внутри каждой группы для исхода).
  group_by(group, outcome) %>%
  # Расчет абсолютной частоты количества исходов каждого типа для каждой группы (результат записывается в столбец n).
  summarise(n = n()) %>%
  # Расчет суммы абсолютных частот по группам (результат записывается в столбец all).
  mutate(all = sum(n)) %>%
  # Деление столбца n на столбец all (т.е. нахождение доли n из N, результат записывается в столбец freq)
  mutate(freq = round(n / all, 3))


trt_data %>%
  group_by(group, sex, stage, outcome) %>%
  summarise(n = n()) %>%
  mutate(all = sum(n)) %>%
  mutate(freq = round(n / all, 3))


trt_data %>%
  group_by(group, sex, stage, outcome) %>%
  summarise(n = n()) %>%
  # Разгруппировка. 
  ungroup() %>%
  # Группировка: далее все расчеты производятся отдельно для каждой группы терапии, указанной в столбце group.
  group_by(group) %>%
  mutate(all = sum(n)) %>%
  mutate(freq = round(n / all, 3))


male_hb <- data.frame(hb = rnorm(1000, mean = 145, sd = 10), sex = "male")
female_hb <- data.frame(hb = rnorm(1000, mean = 130, sd = 10), sex = "female")
all_hb <- rbind(male_hb, female_hb)

# Добавление столбца группа терапии (group), с случайным заполнением.
all_hb$group <- sample(c("group1", "group2"),size = nrow(all_hb), replace = TRUE)
# Добавление столбца стадия (stage), с случайным заполнением.
all_hb$stage <- sample(c("1st", "2nd", "3rd", "4th"),size = nrow(all_hb), replace = TRUE)
# Добавление столбца исход лечения (outcome), с случайным заполнением.
all_hb$outcome <- sample(c("yes", "no"),size = nrow(all_hb), replace = TRUE)
# Вывод на просмотр первые 10 строк таблицы для ознакомления с результатом.
head(all_hb)


summary(all_hb)

library(Hmisc)
describe(all_hb)

library(psych)
describe(all_hb)


library(skimr)
skim(all_hb)


all_hb %>%
  group_by(sex) %>%
  skim()


all_hb %>%
  group_by(sex) %>%
  skimr::skim() %>%
  as.data.frame()

library(dlookr)
library(dplyr)
# Вывод базовых характеристик по всей таблице all_hb.
diagnose(all_hb)


# Вывод распределения абсолютных (N - общее число наблюдений, freq - число наблюдений для указанной категории) и относительных частот (ratio) для каждой категориальной переменной, встречающейся в таблице all_hb. 
diagnose_category(all_hb)

# Вывод ключевых описательных характеристик для каждой количественной переменной, встречающейся в таблице all_hb.
diagnose_numeric(all_hb)


# С помощью функции group_by из пакета dplyr можно задать произвольную группировку по столбцам, а затем по группам произвести расчеты по описательных характеристик каждой количественной переменной, встречающейся в таблице all_hb.
all_hb %>% 
  group_by(sex) %>%
  diagnose_numeric()


# Двойная группировка по sex и stage и последующий расчет описательных характеристик для всех количественных переменных таблицы all_hb.
all_hb %>% 
  group_by(sex, stage) %>%
  diagnose_numeric()

# Создание вектора, состоящего из 4000 светлых шаров и 6000 темных шаров. С помощью функции sample() происходит перемешивание созданного вектора, т.е. значения red и blue стоят в случайном порядке.
color <- sample(c(rep("red", 4000), rep("blue", 6000)))
# Подсчет частоты red и blue в генеральной совокупности (данная манипуляция недоступна исследователям и приведена для проверки).
table(color)
color
blue   red
6000   4000
# Демонстрация работы функции sample(), которая способна возвращать случайно выбранные числа из заданного диапазона, например три числа из диапазона 1-10. Вызов функции каждый раз возвращает три случайных числа.
sample(1:10, 3)
sample(1:10, 3)
sample(1:10, 3)
sample(1:10, 3)
sample(1:10, 3)


# С помощью функции sample имитируется работа исследователей, которые извлекают случайно 10 шаров из генеральной совокупности color.
general[sample(1:10000, 10),]
general[sample(1:10000, 10),]
general[sample(1:10000, 10),]

# Исследователи каждый раз подсчитывают долю red и blue.
prop.table(table(general[sample(1:10000, 10),]))

prop.table(table(general[sample(1:10000, 10),]))


# Для автоматизации данного процесса представлена функция которая проводит данную манипуляцию 1000 раз и записывает доли red и blue в таблицу в соответствующие столбцы.
# Создание пустой таблицы из 1000 строк и двух столбцов: red и blue.
sample_data_frame <- data.frame(red = numeric(1000), blue = numeric(1000))
# Каждый раз извлекается случайно 10 значений из генеральной совокупности general и подсчитывается количество red и blue. Результат записывается в таблицу построчно (с 1 по 1000) в соответствующие колонки (red и blue). 
for (i in 1:1000) {
  x <- prop.table(table(general[sample(1:10000, 10),]))
  sample_data_frame[i, "red"] <- x["red"]
  sample_data_frame[i, "blue"] <- x["blue"]
}
# Вывод первых 10 строк получившейся таблицы.
head(sample_data_frame)

# Расчеты среднего арифметического, медианы и процентилей для светлых шариков
median(sample_data_frame$red, na.rm = TRUE)
mean(sample_data_frame$red, na.rm = TRUE)
quantile(sample_data_frame$red, prob=c(.025), na.rm = TRUE)
quantile(sample_data_frame$red, prob=c(.975), na.rm = TRUE)

# Расчеты среднего арифметического, медианы и процентилей для темных шариков  
median(sample_data_frame$blue, na.rm = TRUE)
mean(sample_data_frame$blue, na.rm = TRUE)
quantile(sample_data_frame$blue, prob=c(.025), na.rm = TRUE)
quantile(sample_data_frame$blue, prob=c(.975), na.rm = TRUE)


plot1 <- ggplot() +
  geom_histogram(data = sample_data_frame, aes(x=red), alpha = 0.6, position ="identity", fill = "red", color = "red") +
  geom_histogram(data = sample_data_frame, aes(x=blue), alpha = 0.3, position ="identity", fill = "blue", color = "blue") +
  theme_light() +
  labs(y = "Кол-во раз, когда встретилась доля", x = "Рассчитанная в эксперименте доля")

plot1 +
  geom_vline(data = sample_data_frame, aes(xintercept = mean(blue, na.rm = TRUE)), color = "blue", linetype = "dashed", size = 1) +
  geom_vline(data = sample_data_frame, aes(xintercept = mean(red, na.rm = TRUE)), color = "red", linetype = "dashed", size = 1) +
  geom_errorbarh(data = sample_data_frame, aes(y = 200, xmin = quantile(blue, prob=c(.025), na.rm = TRUE), xmax=quantile(blue, prob=c(.975), na.rm = TRUE)), size=1.1, color="blue") +
  geom_errorbarh(data = sample_data_frame, aes(y = 175, xmin = quantile(red, prob=c(.025), na.rm = TRUE), xmax=quantile(red, prob=c(.975), na.rm = TRUE)), size=1.1, color="red")


library(dplyr)
# Выбор строк, где в столбце sex установлено значение male.
male_hb <- filter(all_hb, sex=="male")
# Расчет среднего арифметического.
M <- mean(male_hb$hb, na.rm = TRUE)
# Расчет стандартного отклонения
SD <- sd(male_hb$hb, na.rm = TRUE)
# Расчет количества записей (объем выборки).
N <- length(male_hb$hb)
# Подстановка значений в формулу.
lower <- M-1.96*(SD/sqrt(N))
upper <- M+1.96*(SD/sqrt(N))
# show lower ci, mean, and upper ci
lower; M; upper


# С помощью пакета Rmisc и функции CI, где можно задать уровень доверия (в данном примере 95%). 
library(Rmisc)
CI(male_hb$hb, ci = 0.95)  


# С помощью функции t.test для проведения теста Стьюдента.
t.test(male_hb$hb, conf.level = 0.95) 


# С помощью функции binom.test можно получить оценку ДИ для доли (например 30 из 100 пациентов имели положительный ответ на терапию). 
binom.test(x = 30, n = 100, alternative = "two.sided", conf.level = 0.95)


# С помощью функции binom.confint из пакета binom можно произвести расчеты ДИ с помощью различных методов (аргумент methods = "all"). Например 30 из 100 пациентов имели положительный ответ на терапию.
library(binom)
binom.confint(x = 20, n = 100, conf.level = 0.95, methods = "all")

# Аналогичный пример с использованием одного метода (methods = "wilson") и расчета сразу для нескольких групп: 20 из 100 пациентов имели положительный ответ, а 30 из 150 имели отрицательный ответ.
binom.confint(x = c(20, 30), n = c(100, 150), conf.level = 0.95, methods = "wilson")


library(DescTools)
MeanCI(male_hb$hb, method = "boot", type = "norm", R = 1000)


# Определение функции для расчета медианы.
BootFunction = function(x, index) {                        
  return(median(x[index], na.rm = TRUE))
}
# Применение функции к данным для получения множества оценк медианы по подвыборкам.
Bootstrapped_data <- boot(data = male_hb$hb,     
                          statistic = BootFunction,
                          R = 1000)
# Расчет ДИ на основе множеств оценок медиан.
boot.ci(Bootstrapped_data, conf = 0.95) 



# Создание таблицы абсолютных частот и сохранение ее в result.
result <- table(trt_data$group, trt_data$outcome)
# Расчет относительных частот (доля): за 100% берется общее количество отдельно по каждой строке.
prop.table(result, margin = 1)


# Создание таблицы абсолютных частот и сохранение ее в result.
result <- table(trt_data$group, trt_data$outcome)
library(epitools)
# Расчет RR с использованием таблицы абсолютных частот.
riskratio.wald(result)

library(epitools)
# Расчет OR с использованием таблицы абсолютных частот.
oddsratio.wald(result)


riskratio.wald(result, rev = "rows")



# Создание пустой таблицы. В столбец group копируются значения из одноименного столбца group таблицы trt_data. Столбец outcome остается пустым.
sample_trt_data <- data.frame(group = trt_data$group, outcome = character(nrow(trt_data)))
# Создание пустого вектора из 1000 пустых элементов. На каждом этапе перемешивания данных и последующего расчета RR в данный вектор будет добавляться значение RR.  
rr_1000_random <- numeric(1000)
# Цикл на 1000 итераций перемешивания данных
for (i in 1:1000) {
  # Выбор из исходной таблицы столбца outcome и случайная перестановка значений.
  random_outcome <- sample(trt_data$outcome, size = 200, replace = FALSE)
  # Подстановка перемешанного столбца в таблицу sample_trt_data.
  sample_trt_data$outcome <- random_outcome
  # Подсчет таблиц абсолютных частот на перемешанных данных.
  sample_result <- table(sample_trt_data$group, sample_trt_data$outcome)
  # Расчет RR для перемешанных данных на основании таблицы абсолютных частот
  sample_rr <- riskratio.wald(sample_result)
  # Запись полученного RR в пустой вектор на позицию соответствующую номеру цикла.
  rr_1000_random[i] <- sample_rr$measure[2,1]
}

# Вывод первых нескольких значений RR, которые были рассчитаны на перемешанных данных.
head(rr_1000_random)


plot1 <- ggplot() +
  aes(rr_1000_random) +
  geom_histogram(alpha = 0.3, position ="identity", fill = "blue", color = "blue") +
  theme_light() +
  labs(y = "Кол-во раз, когда встретилось такое значение RR", x = "Значение RR")
plot1

# Расчет абсолютного количества случаев из нулевого распределения, который больше или равны исходному значению RR.
length(which(rr_1000_random >= 2))
# Расчет относительного количества (доли/вероятности) встретить значение >= 2 в нулевом распределении. 
0/length(rr_1000_random)

quantile(rr_1000_random, probs = 0.95)


plot1 <- ggplot() +
  aes(rr_1000_random) +
  geom_histogram(alpha = 0.3, position ="identity", fill = "blue", color = "blue") +
  theme_light() +
  labs(y = "Кол-во раз, когда встретилось такое значение RR", x = "Значение RR") +
  geom_vline(xintercept = 2, color = "blue", linetype = "dashed",             size = 1) +
  geom_vline(xintercept = quantile(rr_1000_random, probs = 0.95), color = "red", linetype = "dashed", size = 1)
plot1


quantile(rr_1000_random, probs = 0.05)

# Расчет абсолютного количества случаев из нулевого распределения, который меньше или равны исходному значению RR.
length(which(rr_1000_random <= 0.5))
0/length(rr_1000_random)


plot1 <- ggplot() +
  aes(rr_1000_random) +
  geom_histogram(alpha = 0.3, position ="identity", fill = "blue", color = "blue") +
  theme_light() +
  labs(y = "Кол-во раз, когда встретилось такое значение RR", x = "Значение RR") +
  geom_vline(xintercept = 2, color = "blue", linetype = "dashed", size = 1) +
  geom_vline(xintercept = 0.5, color = "blue", linetype = "dashed", size = 1) +
  geom_vline(xintercept = quantile(rr_1000_random, probs = 0.975), color = "red", linetype = "dashed", size = 1) +
  geom_vline(xintercept = quantile(rr_1000_random, probs = 0.025), color = "red", linetype = "dashed", size = 1) 
plot1


library(epitools)
# Расчет RR и 95%-го ДИ с использованием таблицы абсолютных частот.
riskratio.wald(result)













