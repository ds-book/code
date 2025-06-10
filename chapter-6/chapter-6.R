#### критерий согласия Пирсона ####

# Создание таблицы с примером.
thrombosis_placebo <- c(rep("yes", 30), rep("no", 17))
thrombosis_new_drug <- c(rep("yes", 16), rep("no", 32))
all_result <- c(thrombosis_placebo, thrombosis_new_drug)
therapy_type <- c(rep("placebo", length(thrombosis_placebo)), 
                  rep("new_drug", length(thrombosis_new_drug)))
# Объединение данных.
data <- data.frame(treatment = therapy_type, thrombosis = all_result)
# Просмотр таблицы с данными по группе терапии и тромбозу.
head(data)

# Создание таблицы сопряженности.
tb1 <- table(data$treatment, data$trombosis)
# Расчет критерия хи-квадрат, при установлении значении correct = FALSE не выполняется поправка Йейтса, по умолчанию поправка выполняется.
chisq.test(tb1)

####  Точный критерий Фишера ####

# Создание таблицы с примером.
low_activity <- c(rep("yes", 10), rep("no", 2))
middle_activity <- c(rep("yes", 4), rep("no", 12))
diabetes <- c(low_activity, middle_activity)
activity <- c(rep("low", length(low_activity)), 
              rep("middle", length(middle_activity)))
# Объединение данных.
data <- data.frame(activity = activity, diabetes = diabetes)
# Просмотр таблицы с данными.
head(data)
# Создание таблицы сопряженности.
tb1 <- table(data$activity, data$diabetes)
tb1
# Расчет точного критерия Фишера.
fisher.test(tb1)


#### Критерий МакНемара для зависимых групп ####

# Создание таблицы с примером.
age_7no9no <- data.frame(year7 = rep("no", 27), year9 = rep("no", 27))
age_7no9yes <- data.frame(year7 = rep("no", 33), year9 = rep("yes", 33))
age_7yes9no <- data.frame(year7 = rep("yes", 21), year9 = rep("no", 21))
age_7yes9yes <- data.frame(year7 = rep("yes", 28), year9 = rep("yes", 28))
all_data <- rbind(age_7no9no, age_7no9yes, age_7yes9no, age_7yes9yes)
# Просмотр таблицы.
head(all_data)


# Создание таблицы сопряженности.
tb1 <- table(all_data$year7, all_data$year9)
# Просмотр таблицы сопряженности.
tb1


# Задание имен для строк и столбцов таблицы сопряженности.
tb1 <- matrix(tb1, nrow = 2, dimnames = list( c("7 лет (заболеваний нет)", "7 лет (заболевания есть)"), c("9 лет (заболеваний нет)", "9 лет (заболевания есть)")))
tb1

# Расчет критерия МакНемара без поправки на непрерывность.
mcnemar.test(tb1, correct = FALSE)


#### Нормальное распределение. ####


# Создание вектора значений, соответствующего измеренному уровню щелочной фосфатазы ЕД/л.
ALP = c(454, 439, 544, 449, 413, 486, 394, 319, 504, 528, 459, 
        456, 628, 500, 457, 478, 511, 365, 407, 440, 357, 298, 
        594, 395, 617, 505, 541, 458, 381) 

# Указание атрибута pnorm, указание значения среднего и стандартного отклонения, основанные на данных: mean(ALP) и sd(ALP).

ks.test(ALP, "pnorm", mean=mean(ALP), sd=sd(ALP))


# Создание вектора значений, соответствующего измеренному уровню щелочной фосфатазы ЕД/л.
ALP = c(454, 439, 544, 449, 413, 486, 394, 319, 504, 528, 459, 
        456, 628, 500, 457, 478, 511, 365, 407, 440, 357, 298, 
        594, 395, 617, 505, 541, 458, 381) 


# В функции необходимо указать вектор значений ALP.
shapiro.test(ALP)
# Создание вектора значений ALP.
ALP <- c(454, 439, 544, 449, 413, 486, 394, 504, 528, 459, 
         456, 500, 457, 478, 511, 365, 407, 440, 357, 298, 
         594, 395, 617, 505, 541, 458, 381)

# Настройка графического вывода.
qqnorm(ALP, main = "QQ-Plot для ALP", xlab = "Теоретические квантили нормального распределения", ylab = "Квантили данных ALP",)

# Добавление линии, соответствующей нормальному распределению.
qqline(ALP, col = "red")  

set.seed(42) # Для воспроизводимости результатов
# Создание таблицы со 100 случайными числовыми значениями уровня холестерина у пациентов с диетой, исключающей животные жиры, со средним значением 5 ммоль/л и разбросом (стандартным отклонением) в 1,5 ммоль/л. С помощью функции round() происходит округление значения до одного знака после запятой.
value1 <- data.frame(chol = round(rnorm(n = 100, mean = 5, sd = 1.5), digits = 1), group = "fat-free")
# Создание таблицы со 100 случайными числовыми значениями уровня холестерина у пациентов с диетой, включающей животные жиры, со средним значением 5,5 ммоль/л и разбросом (стандартным отклонением) в 1,8 ммоль/л. С помощью функции round() происходит округление значения до одного знака после запятой.
value2 <- data.frame(chol = round(rnorm(n = 100, mean = 5.5, sd = 1.8), digits = 1), group = "20g butter")
# Объединение таблиц.
cholest <- rbind(value1, value2)
# Вывод первых 10 строк полученной итоговой таблицы.
head(cholest, 10)


# Оценка нормальности распределения для первой группы. Нулевая гипотеза - данные распределены в соответствии с нормальным законом.
shapiro.test(cholest$chol[1:100])

# Оценка нормальности распределения для второй группы. Нулевая гипотеза - данные распределены в соответствии с нормальным законом.
shapiro.test(cholest$chol[101:200])

# Тест Бартлетта для оценки равенства дисперсий. Нулевая гипотеза - группы имеют одинаковые дисперсии.
bartlett.test(chol ~ group, data = cholest) 

# Тест Флигнера-Киллина для оценки равенства дисперсий. Нулевая гипотеза - группы имеют одинаковые дисперсии.
fligner.test(chol ~ group, data = cholest)

# Проведение независимого выборочного t-критерия Стьюдента (двусторонний).
t.test(chol ~ group, data = cholest, alternative = "two.sided", var.equal = TRUE)

set.seed(42) # Для воспроизводимости результатов
# Создание вектора с 250 случайными числовыми значениями уровня систолического артериального давления со средним значением 135 мм.рт.ст и разбросом (стандартным отклонением) в 4 мм.рт.ст.
blood_pressure <- rnorm(n = 250, mean = 135, sd = 4)
# Проведение оценки нормальности распределения вектора значений систолического артериального давления. Нулевая гипотеза - данные распределены нормально
shapiro.test(blood_pressure)

# Проведение одновыборочного t-критерия Стьюдента (двусторонний). mu - это среднее значение, с которым сравниваются экспериментальные данные.
t.test(blood_pressure, mu = 140)

set.seed(142) # Для воспроизводимости результатов
# Создание таблицы с 50 случайными числовыми значениями уровня глюкозы, средним значением 4,2 ммоль/л и разбросом (стандартным отклонением) в 0,5 ммоль/л, соответствующие первому измерению. Округление значений до 1 знака после запятой с функцией round().
value1 <- data.frame(pre = round(rnorm(n = 50, mean = 4.2, sd = 0.5), digits = 1))
# Создание таблицы с 50 случайными числовыми значениями уровня глюкозы, средним значением 4,0 ммоль/л и разбросом (стандартным отклонением) в 0,6 ммоль/л, соответствующие второму измерению. Округление значений до 1 знака после запятой с функцией round().
value2 <- data.frame(post = round(rnorm(n = 50, mean = 4.0, sd = 0.6), digits = 1))
# Объединение таблицы и просмотр первых 10 строк.
glucose <- cbind(value1, value2)
head(glucose, 10)


# Проведение оценки нормальности распределения для первой группы.
shapiro.test(glucose$pre)

# Проведение оценки нормальности распределения для второй группы.
shapiro.test(glucose$post)

Согласно проведенным тестам на оценку нормальности распределения отклонить нулевую гипотезу нельзя, что позволяет использовать парный тест Стьюдента.
# Применение парного t-теста Стьюдента.
t.test(glucose$pre,glucose$post, paired = TRUE)


#### Распределение, отличное от нормального ####

set.seed(42) # Для воспроизводимости результатов
# Создание таблицы с числовыми значениями количества дней восстановления для 20 пациентов возрастной группы “до 60 лет”, минимальное значение 67 дней, максимальное 108. 
value1 <- data.frame(day = sample(67:108, 20), group = "aged under 60")
# Создание таблицы с числовыми значениями количества дней восстановления для 20 пациентов возрастной группы “до 60 лет”, минимальное значение 75 дней, максимальное 125. 
value1 <- data.frame(day = sample(75:125, 20), group = "aged over 60")
# Объединение таблицы и вывод первых 10 строк.
period <- rbind(value1, value2)
head(period, 10)

# Выполнение теста Манна-Уитни.
wilcox.test(day ~ group, data = period)

# Создание таблицы с числовыми значениями массы тела пациентов “до терапии”. 
value1 <- data.frame(weight1 = c(65, 68, 77, 89, 109, 78.7, 72.1, 96.2, 64.3, 75.5), group1 = "before treatment")
# Создание таблицы с числовыми значениями массы тела пациентов “после терапии”. 
value2 <- data.frame(weight2 = c(71, 67,74, 94, 100,80, 76, 99, 68, 73), group2 = "after treatment")
# Объединение и просмотр  таблицы.
patient <- cbind(value1, value2)
head(patient, 10)

# Применение критерия Вилкоксона для парных выборок.
wilcox.test(patient$weight1, patient$weight2, paired = TRUE)

# Создание вектора чисел, соответствующих ИМТ пациентов. 
bmi_after <- c(32, 26, 29, 35, 22, 33, 27, 24, 30, 34, 36, 38, 37, 31, 28)

# Обозначение целевого уровня ИМТ. 
target_bmi <- 25

# Применение одновыборочного критерия Вилкоксона.
wilcox.test(bmi_after, mu = target_bmi, alternative = "two.sided")


#### Количественные сравнения нескольких групп ####

set.seed(42)# Для воспроизводимости результатов.
# Создание таблицы с числовыми значениями уровня холестерина у пациентов разных возрастных периодов и с разными вариантами терапии.
treatment <- factor(c(rep("A", 30), rep("B", 30), rep("C", 30)))
age <- factor(rep(c("до 40 лет", "41-60 лет", "61 и старше"), 30))
cholesterol <- round(rnorm(90, mean = rep(c(5, 5.5, 7), each = 30), sd = 1), digits = 1)
df_chol <- data.frame(treatment, age, cholesterol)
# Просмотр данных.
head(df_chol)


# Выполнение двухфакторного дисперсионного анализа. Перечень независимых факторов, по которым проводится оценка влияния на зависимый показатель проводится после знака “~”.
model <- aov(cholesterol ~ treatment * age, data = df_chol) 
# зависимый показатель - cholesterol, независимые факторы - treatment, age.


# Вывод результатов модели.
summary(model)

# Однофакторный дисперсионный анализ.
model <- aov(cholesterol ~ treatment, data = df_chol)
# Вывод результатов.
summary(model)
# Для визуализации результатов используются пакеты broom и ggplot2.
library(broom)
library(ggplot2)

# Выполнение теста Тьюки с моделью, где в качестве фактора, статистически значимо влияющего на уровень холестерина, выбран вариант терапии - treatment.

TukeyOW <- TukeyHSD(model, 'treatment', conf.level=0.95) # model - результат ранее выполненного дисперсионного анализа.

TukeyOW <- tidy(TukeyOW) # функция структурирования результатов расчета в виде таблицы.

print(TukeyOW)


ggplot(TukeyOW,
       aes(x = estimate, y = contrast, group = 1)) +
  geom_point(size = 3, color = "red") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "darkgrey") +
  geom_errorbar(aes(xmin = conf.low,
                    xmax = conf.high),
                width = .1) +
  theme_bw() +
  labs(y = "Вариант терапии",
       x = "Разность между групповыми средними")


set.seed(42)# Для воспроизводимости результатов.

# Создание таблицы с числовыми значениями уровня витамина у пациентов, придерживающихся разных вариантов диет.
value1 <- data.frame(vitamin= sample(36:55, 20), group = "mediter_diet")
value2 <- data.frame(vitamin = sample(20:40, 20), group = "vegetarian_diet")
value3 <- data.frame(vitamin = sample(30:60, 20), group = "Atkinson_diet")
diet <- rbind(value1, value2,value3)

head(diet, 10)# Просмотр таблицы.


# Проведение теста Краскала-Уоллиса, где зависимый показатель (vitamin) располагается в начале функции, а независимый (group) после знака ~
result_D <- kruskal.test(vitamin ~ group, data = diet)

# Вывод результатов.
print(result_D)


library(dunn.test) # Подключение пакета для расчета теста Данна.

# Расчет теста Данна, где по очереди перечислены зависимый показатель, независимый показатель, при этом с помощью атрибута kw отключается тест Краскала-Уоллиса, а method - поправка на множественные сравнения по методу Холма.
dunn.test(diet$vitamin, diet$group, kw = FALSE, method = "holm")


#### Практическое применение поправок по методу Бонферрони и Холма ####

# p-значения.
p_values <- c(0.01, 0.03, 0.005, 0.08, 0.02, 0.04)

# Применение поправки Бонферрони. Поправка проводится путем
adjusted_p_values <- p.adjust(p_values, method = "bonferroni")
# Вывод скорректированных p-значений.
adjusted_p_values
0.06 0.18 0.03 0.48 0.12 0.24

# Проверка значимости с поправкой (alpha = 0.05).
adjusted_p_values <= 0.05


# p-значения.
p_values <- c(0.01, 0.03, 0.005, 0.08, 0.02, 0.04)

# Применение поправки Холма
adjusted_p_values <- p.adjust(p_values, method = "holm")

# Вывод скорректированных p-значений.
adjusted_p_values
0.05 0.09 0.03 0.09 0.08 0.09

# Проверка значимости с поправкой (alpha = 0.05).
adjusted_p_values <= 0.05


#### Примеры использования критериев для нескольких групп. ####

library(fmsb) #Подключение пакета с соответствующей функцией

# Синтез набора данных. Предположим, что необходимо оценить положительный результат от разных вариантов терапии (всего 4 группы, соответствующие 4 вариантам терапии). Количество положительных ответов на терапию среди участников соответствует значениям  positive_results, общее количество участников - total_results.

# Количество пациентов с положительным результатом в каждой из вариантов терапии.
positive_results <- c(20,15,5,10) 

# Общее количество пациентов в каждой из групп терапии соответственно вектору positive_results. 
total_results <- c(30,40,37,35)

# Выполнение точного теста Фишера для множественных сравнений.
results <- pairwise.fisher.test(positive_results, total_results, p.adjust.method= "bonferroni")

# Вывод результатов.
print(results)


# Синтез набора данных. Предположим, что необходимо оценить эффективность диагностической процедуры при 3 разных методах диагностики (всего 3 группы, соответствующие 3 методам диагностики). Количество положительных результатов диагностики среди участников соответствует значениям positive, общее количество участников - totals.

# Количество позитивных результатов в каждой группе.
positive <- c(10, 20, 30) 

# Общее количество наблюдений в каждой группе.
totals <- c(50, 50, 50) 

# Выполнение парного теста пропорций.
result <- pairwise.prop.test(positive, totals, p.adjust.method = "holm")
# Вывод результатов
print(result)


# Синтез набора данных. Предположим, что необходимо сравнить влияние трех вариантов диет на уровень глюкозы, в представленном ниже примере не проводилась оценка данных на применимость критерия Стьюдента (поскольку основная цель - объяснения логики работы функции для множественных сравнений), при расчете данных в реальной ситуации такая оценка применимости должна проводиться в обязательном порядке. 

set.seed(123)# Для воспроизводимости результатов

value1 <- data.frame(glu_level = round(rnorm(n = 50, mean = 4.2, sd = 0.5), digits = 1), group = "diet1")
value2 <- data.frame(glu_level = round(rnorm(n = 50, mean = 3.9, sd = 0.7), digits = 1), group = "diet2")
value3 <- data.frame(glu_level = round(rnorm(n = 50, mean = 4.3, sd = 0.4), digits = 1), group = "diet3")

# Объединение данных 3 групп. Итоговая таблица содержит два столбца: glu_level - уровень глюкозы и group - тип диеты.
glucose <- rbind(value1, value2, value3)

#  Выполнение t-теста. 
result <- pairwise.t.test(glucose$glu_level, glucose$group, p.adjust.method = "bonferroni")

# Вывод результатов.
print(result)


# Синтез набора данных. Предположим, что необходимо оценить уровень холестерина в зависимости от варианта диеты (всего 3 группы, соответствующие 3 вариантам диеты). Показатели уровня холестерина во всех группах соответствуют вектору data, а отношение пациента к группе определено вектором groups.  

set.seed(121)# Для воспроизводимости результатов
group1 <- round(rnorm(10, mean = 4.5, sd = 0.4), digits = 2)
group2 <- round(rnorm(10, mean = 4, sd = 0.5), digits = 2)
group3 <- round(rnorm(10, mean = 5.5, sd = 0.6), digits = 2)

# Объединение данных в один вектор и создание групп.
data <- c(group1, group2, group3)
groups <- rep(c("Group1", "Group2", "Group3"), each = 10)

# Выполнение теста Манна-Уитни для множественных сравнений, атрибут paired по умолчанию имеет значение FALSE. 
result <- pairwise.wilcox.test(data, groups, p.adjust.method = "bonferroni")

# Вывод результатов.
print(result)


#### Коэффициент корреляции Пирсона ####

# Подготовка данных.
# Первый показатель (независимый) - уровень физической активности (в минутах умеренной активности в неделю).
activity <- c(150, 300, 75, 200, 100, 0, 250, 175, 350, 50, 0, 120, 220, 280, 100, 50, 180, 210, 300, 80)

# Второй показатель (зависимый) - систолическое артериальное давление (мм рт. ст.), измеренное во время физической активности.
blood_pressure <- c(130, 120, 140, 125, 135, 150, 122, 130, 115, 145, 155, 128, 120, 118, 132, 148, 125, 128, 110, 138)

# Создание таблицы.
data <- data.frame(activity, blood_pressure)

# Проверка линейности и гомоскедастичности (визуальная).
# Загрузка библиотеки ggplot2
library(ggplot2)
# Создание точечного графика
ggplot(data, aes(x = activity, y = blood_pressure)) +
  geom_point() +  # Добавление точек на график
  geom_smooth(method = "lm", se = FALSE, color = "red") +  # Добавление линии регрессии (lm = линейная модель, se = FALSE скрывает доверительный интервал)
  labs(x = "Физическая активность (мин/неделя)",
       y = "Систолическое АД (мм рт. ст.)",
       title = "Физическая активность и артериальное давление") +
  theme_bw() # Использование темы без дополнительных


# Проведение оценки нормальности распределения для первого показателя. H0 - данные распределены в согласии с нормальным распределением, H1 - распределение данных не согласуется с нормальным.
shapiro_activity <- shapiro.test(data$activity)
print(shapiro_activity)


# Проведение оценки нормальности распределения для второго показателя. H0 - данные распределены в согласии с нормальным распределением, H1 - распределение данных не согласуется с нормальным.
shapiro_bp <- shapiro.test(data$blood_pressure)
print(shapiro_bp)


# Проведение теста на корреляцию Пирсона.
correlation_test <- cor.test(data$activity, data$blood_pressure, method = "pearson")
print(correlation_test)


#### Коэффициент корреляции Спирмена ####

# Подготовка данных. hba1c - значения гликированного гемоглобина, period - продолжительность сахарного диабета в годах.
hba1c <- c(6.5, 7.0, 7.6, 8.1, 8.9, 6.7, 7.3, 7.7, 8.0, 8.5, 7.1, 7.5, 7.9, 8.2, 8.4, 7.2, 7.8, 8.6, 8.3, 8.8)
period <- c(1, 3, 7, 9, 12, 2, 5, 8, 10, 13, 4, 6, 11, 14, 16, 15, 17, 18, 19, 20)

# Вычисление корреляции Спирмена.
corr <- cor.test(period, hba1c, method = "spearman")
# Вывод результатов.
print(corr)


#### Анализ времени до наступления события ####

library(survival)
library(survminer)
# Просмотр первых строк таблицы.
head(lung)

# Построение модели Каплана-Мейера для пациентов различного пола.
km_model <- survfit(Surv(time, status) ~ sex, data = lung)
print(km_model)


result <- data.frame(time = km_model$time,
                     n.risk = km_model$n.risk,
                     n.event = km_model$n.event,
                     n.censor = km_model$n.censor,
                     surv = km_model$surv,
                     upper = km_model$upper,
                     lower = km_model$lower
)

# Просмотр первых строк таблицы.
head(result)


ggsurvplot(km_model,
           pval = TRUE, conf.int = TRUE,
           risk.table = TRUE, # Добавление таблицы выживаемости.
           risk.table.col = "strata", # Изменение цвета таблицы по группам.
           linetype = "strata", # Изменение цвета таблицы по группам.
           surv.median.line = "hv", # Отображение медианы на двух осях.
           ggtheme = theme_bw(), # Цветовая тема.
           xlab = "Время (дней)",
           ylab = "Доля выживших",
           palette = c("royalblue", "forestgreen"))

surv_diff <- survdiff(Surv(time, status) ~ sex, data = lung)
surv_diff


reg_cox <- coxph(Surv(time, status) ~ sex, data = lung)
summary(reg_cox)


reg_cox2<-coxph(Surv(time, status)~sex+age+ph.ecog+ph.karno+pat.karno+meal.cal+wt.loss, data=lung)


#### Основные меры точности диагностических тестов ####


library(epiR)
# Создание четырехпольной таблицы.
cross_table <- as.table(
  rbind(c(786, 95), c(15, 191))
)

# Присвоение имен для сторк и столбцов.
dimnames(cross_table) <- list(
  Test = c("Test +", "Test -"),
  Gold_standard = c("Gold standard +", "Gold standard -")
)

# Просмотр таблицы.
cross_table

# Расчет показателей диагностического теста.
epi.tests(cross_table, digits = 4)


#### Использование отношения правдоподобия для расчета вероятности #####

# Создание четырехпольной таблицы.
# Установка пакета TeachingDemos.
# install.packages("TeachingDemos")
library(TeachingDemos)
# Создание номограммы Фагана для положительного теста (LR=2.95).
fagan.plot(probs.pre.test = 0.15, LR = 2.95)


#### ROC-кривые ####

# install.packages("pROC")
# install.packages("plotROC")
library(pROC)
library(ggplot2)
library(plotROC)

# Создание таблицы с маркерами для пациентов с диагнозом.
data_diag_yes <- data.frame(x_marker = rnorm(100, mean = 145, sd = 10), y_marker = rnorm(100, mean = 50, sd = 10), disease = "yes")

# Создание таблицы с маркерами для пациентов без диагноза.
data_diag_no <- data.frame(x_marker = rnorm(100, mean = 100, sd = 30), y_marker = rnorm(100, mean = 30, sd = 5), disease = "no")

# Объединение таблиц в одну.
data_diag_all <- rbind(data_diag_yes, data_diag_no)

# Просмотр первых строк таблицы.
head(data_diag_all)


ggplot(data_diag_all, aes(d = disease, m = x_marker)) + 
  geom_roc(n.cuts = 0, color = "#0071BF") +
  theme(text = element_text(size = 14)) +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed') +
  scale_x_continuous(expand = c(0, 0.015)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "1 - Специфичность", y = "Чувствительность") +
  theme_bw()

# Вычисление ROC-кривой для x_marker.
roc1 <- roc(data_diag_all$disease, data_diag_all$x_marker)

# Вычисление ROC-кривой для y_marker.
roc2 <- roc(data_diag_all$disease, data_diag_all$y_marker)

# Вычисление AUC для x_marker.
auc(roc1)
# Вычисление ДИ для AUC для x_marker.
ci.auc(roc1)
# Вычисление AUC для x_marker.
auc(roc2)
# Вычисление ДИ для AUC для y_marker.
ci.auc(roc2)

# Вычисление оптимального порога и его чувствительности и специфичности для x_marker.
coords(roc1, "best", ret = c("threshold", "sensitivity", "specificity"),
       best.method="youden")
# Вычисление оптимального порога и его чувствительности и специфичности для y_marker.
coords(roc2, "best", ret = c("threshold", "sensitivity", "specificity"),
       best.method="youden")


# Разворот таблицы data_diag_all в длинный формат.
longdata <- melt_roc(data_diag_all, "disease", c("x_marker", "y_marker"))

# Просмотр первых строк таблицы после разворота.
head(longdata)

# Создание графика с ROC-кривыми для x_marker и y_marker.
plot1 <- ggplot(longdata, aes(d = D, m = M, color = name)) + 
  geom_roc(n.cuts = 0) +
  theme(text = element_text(size = 14),
        legend.position="top") +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed') +
  scale_x_continuous(expand = c(0, 0.015)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme_bw() +
  labs(x = "1 - Специфичность", y = "Чувствительность", colour="Исследуемые маркеры")

# add annotations to the plot
plot1 + annotate("text", x=0.70, y=0.35, color = "#0071BF",
                 label=paste("AUC x_marker = ", 0.9078, 
                             " (95% CI = ", 0.86, " - ", 0.9556, ")")) +
  annotate("text", x=0.70, y=0.28, color = "forestgreen",
           label= paste("AUC y_marker = ", 0.9586, 
                        "(95% CI = ", 0.9279, " - ", 0.9893, ")"))
roc.test(roc1, roc2, method=c("delong"))


#### Расчет размера выборки ####

power.t.test(d = 0.2, sig.level = 0.05, power = 0.8, type = "two.sample", alternative = "two.sided")
power.t.test(d = 0.8, sig.level = 0.05, power = 0.8, type = "two.sample", alternative = "two.sided")
power.t.test(n = 30, d = 0.2, sig.level = 0.05, type = "two.sample", alternative = "two.sided")
pwr.2p2n.test(h=ES.h(0.65, 0.6), n1=1000, power = 0.8, sig.level=0.05, alternative="two.sided")
pwr.2p2n.test(h = ES.h(0.65, 0.6), n1 = 100, n2 = 50, sig.level = 0.05, alternative="two.sided")

# Расчет таблицы абсолютных частот
table(trt_data$group, trt_data$outcome)
# Проверка статистической гипотезы.
chisq.test(table(trt_data$group, trt_data$outcome))

# Расчет относительных частот от общего числа пациентов в двух группах.
eff_tabl <- prop.table(table(trt_data$group, trt_data$outcome))
# Расчет степеней свободы в таблице частот по формуле: (кол-во строк - 1)*(кол-во столбцов - 1).
df_value <- (nrow(eff_tabl) - 1) * (ncol(eff_tabl) - 1)
# Расчет мощности критерия.  
pwr.chisq.test(w = ES.w2(eff_tabl), N = 200, df = df_tabl, sig.level = 0.05)

# Моделирование распределения частот.
prob <- matrix(c(0.3, 0.05, 0.45, 0.2), byrow = TRUE, nrow = 2)
# Проверка что сумма частот по всем ячейкам равна 1.
sum(prob)
# Подсчет степеней свободы
df_tabl <- (nrow(prob) - 1) * (ncol(prob) - 1)
# расчет мощности.
pwr.chisq.test(w = ES.w2(prob), df = df_tabl, sig.level = 0.05, power = 0.8)



library(statmod)
power.fisher.test(p1 = 0.4,  p2 = 0.6,  n1 = 50,  n2 = 60,  alpha = 0.05, nsim = 1000, alternative = "two.sided")

# Создание таблицы с пустым столбцом power для сохранения результата и столбцом n, где будут расположено число пациентов от 1 до 100.
sim_power_table <- data.frame(power = numeric(100), n = 1:100)
# Запуск цикла. Количество итераций равно количеству строк в таблице.
for(i in 1:nrow(sim_power_table)){
  # Расчет мощности: частоты p1 и p2 остаются постоянными. В n1 и n2 осуществляется подстановка значений объема выборки из таблицы sim_power_table.
  x <- power.fisher.test(p1 = 0.4,  p2 = 0.6,  n1 = sim_power_table$n[i],  n2 = sim_power_table$n[i],  alpha = 0.05, nsim = 1000, alternative = "two.sided")
  # Запись мощности в соответствующую номеру итерации цикла строку таблицы sim_power_table (столбец power).
  sim_power_table$power[i] <- x
}
# Просмотр таблицы.
sim_power_table


# Отрисовка графика.
ggplot(data = sim_power_table, aes(x = n, y = power))+
  geom_point(color = "red") + geom_line() +
  theme_light() +
  labs(y = "Мощность", x = "Кол-во пациентов в каждой группе")



#### Автоматизация процедуры рандомизации ####

library(blockrand)
# Создание страты мужчин, в которой содержится 20 испытуемых.
strata_male <- blockrand(n = 20, id.prefix = "M", block.prefix = "M", stratum = "Male", block.sizes = c(1:4), num.levels = 2, levels = c("A", "B"))
# Создание страты женщин, в которой содержится 20 испытуемых.
starta_female <- blockrand(n = 20, id.prefix = "F", block.prefix = "F", stratum = "Female", block.sizes = c(1:4), num.levels = 2, levels = c("A", "B"))
# Объединение старт в одну таблицу.
all_strata <- rbind(strata_male, starta_female)
# Просмотр таблицы
all_strata


plotblockrand(all_strata,'mystudy.pdf', top=list(text=c('My Study','Patient: %ID%','Treatment: %TREAT%'), col=c('black','black','red'),font=c(1,1,4)), middle=list(text=c("My Study","Sex: %STRAT%","Patient: %ID%"), col=c('black','blue','green'),font=c(1,2,3)), bottom="Call 777-777 to report patient entry", cut.marks=TRUE)




####  Разведочный анализ данных и концепция воспроизводимых исследований ####

### Установка рабочей директории ###
setwd("D:/DS_course")

### Загрузка Необходимых пакетов ###
# install.packages("skimr")
library(corrplot)
library(psych)
library(car)
library(dplyr)
library(ggplot2)
library(skimr)
library(stringr)
library(outliers)
library(EnvStats)
library(epitools)
library(gvlma)
library(officer)
library(broom)
library(flextable)

# I РАЗВЕДОЧНЫЙ АНАЛИЗ ДАННЫХ #
## Загрузка данных ##
data <- read.csv("insurance.csv", header = TRUE)

## Описание данных ##
# age: возраст, лет
# sex: пол (female, male)
# bmi: индекс массы тела
# children: Количество детей, охваченных медицинским страхованием
# smoker: статус курения (yes/no)
# region: регион (northeast, southeast, southwest, northwest).
# charges: индивидуальные медицинские расходы, оплаченные страховой компанией

# 1. Общий просмотр данных #
head(data)
str(data)
summary(data)

# 2. Конвертация количественной переменной children в фактор (упорядоченная качественная переменная) #
data$children <- as.factor(data$children)
# 3. Описание данных по группам #
x <- dplyr::group_by(data, sex, smoker) %>% skimr::skim() %>% as.data.frame()
skimr::skim(data)

# 4. Поиск выбросов в стоимости страховки: визуализация данных #
data %>% 
  mutate(region = str_to_title(region)) %>% 
  
  ggplot(aes(region, charges))+
  geom_boxplot()+
  geom_jitter(aes(color = region),alpha = 0.4)+
  theme_light() +
  scale_y_continuous(labels = scales::unit_format(suffix = "$"))+
  theme(legend.position = "none")+
  labs(title = "Distribution of Medical Costs per Region",
       x = "Region",
       y = "Cost")

# 5. Поиск выбросов в стоимости страховки: проведение формальной оценки с помощью критерия Grubbs #
# Проверка гипотезы: является ли макисмальное значение выбросом
test <- grubbs.test(data$charges)
# Проверка гипотезы: является ли минимальное значение выбросом
test <- grubbs.test(data$charges, opposite = TRUE)

# 6. Поиск выбросов в стоимости страховки: проведение формальной оценки с помощью критерия Dixon #
# Проверка гипотезы: является ли максимальное значение выбросом
test <- dixon.test(data$charges)
# Проверка гипотезы: является ли минимальное значение выбросом
test <- dixon.test(data$charges, opposite = TRUE)

# 7. Поиск выбросов в стоимости страховки: проведение формальной оценки с помощью критерия Rosner (проверка гипотезы: является ли 5 наибольших значений выбросами) #
test <- rosnerTest(data$charges, k = 5)

# 8. Определение формы распределения стоимости страховки #
## 8.1. Графически ##
ggplot(data, aes(charges))+
  geom_density(aes(fill = smoker), color = NA, alpha = 0.6) +
  facet_wrap(~sex)+
  theme_light()+
  theme(legend.position = "top")+
  labs( y = "Density",
        x = "Charges",
        title = "Distribution of Medical Costs for Smokers in Each Gender")

## 8.2. С помощью графика Q-Q plot (отдельно для курящих женщин)##
dat <- filter(data, smoker == "yes" & sex == "female")
qqPlot(dat$charges)


## 8.3. Проверка согласия формы распределения стоимости страховых выплат с нормальным законом с помощью теста Shapiro (для курящих женщин)##
shapiro.test(dat$charges)

# 9. Поиск взаимосвязи между переменными #
## 9.1. Визуализация ##
pairs.panels(dat, 
             method = "spearman", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = TRUE # show correlation ellipses
)

## 9.2. Корреляционная матрица ##
corr_matrix <- cor(dat[, c(1,3,7)], method = "spearman")
corrplot(corr_matrix, method="circle")
corrplot(corr_matrix, method="ellipse")
corrplot.mixed(corr_matrix, lower = 'shade', upper = 'pie', order = 'hclust')

## 9.3. Проведение отдельных корреляционных тестов ##
cor.test(dat$age, dat$bmi,method = "spearman")
cor.test(dat$age, dat$charges,method = "spearman")
cor.test(dat$bmi, dat$charges,method = "spearman")

# II ФОРМИРОВАНИЕ ОТЧЕТА В ФОРМАТЕ .DOCX ДЛЯ ИЗБРАННЫХ ЧАСТЕЙ АНАЛИЗА #

## Загрузка данных ##
data <- read.csv("insurance.csv", header = TRUE)

## Описание данных ##
# age: возраст, лет
# sex: пол (female, male)
# bmi: индекс массы тела
# children: Количество детей, охваченных медицинским страхованием
# smoker: статус курения (yes/no)
# region: регион (northeast, southeast, southwest, northwest).
# charges: индивидуальные медицинские расходы, оплаченные страховой компанией



# Создание пустого файла .docx #
doc_general <- read_docx()

#########################################

# 1. Создание таблицы с описательными характеристиками по региону и полу #
result1 <- data %>% 
  group_by(region, sex) %>% 
  summarise(median = median(age),
            mean = mean(age),
            sd = sd(age),
            q1 = quantile(age, prob=c(.25)),
            q3 = quantile(age, prob=c(.75))
  )

# Создание таблицы с описательными характеристиками: объединение столбцов median, q1, q3 в один
result1 <- mutate(result1,
                  "Me" = paste0(median, " (", q1,"; ", q3, ")")) %>%
  select(-median, -q1, -q3)

# Создание таблицы с описательными характеристиками: объединение столбцов mean и sd в один 
result1 <- mutate(result1,
                  "M" = paste0(round(mean, 2), " (", round(sd, 2), ")")) %>%
  select(-mean, -sd)


# Подготовка таблицы result1 для отправки в .docx
myft1 <- flextable(result1, cwidth = 1)
# Добавление темы визуального оформления
myft1 <- theme_box(myft1)

# Объединение строк в столбце регион и пол по группам
myft1 <- merge_v(myft1, j = ~ region + sex)

# Добавление таблицы в созданный файл .docx
doc_general <- doc_general %>%  
  # добавление заголовка
  body_add_par("Возраст по полу и регионам", style = "heading 1") %>% 
  # Добавление таблицы
  body_add_flextable(value = myft1)

###################################################

# 2. Создание таблицы с описательными характеристиками по региону и статусу курения 
result2 <- data %>% 
  group_by(region, smoker) %>% 
  summarise(median = median(age),
            mean = mean(age),
            sd = sd(age),
            q1 = quantile(age, prob=c(.25)),
            q3 = quantile(age, prob=c(.75))
  ) %>%
  mutate("Me" = paste0(median, " (", q1,"; ", q3, ")")) %>%
  select(-median, -q1, -q3) %>%
  mutate("M" = paste0(round(mean, 2), " (", round(sd, 2), ")")) %>%
  select(-mean, -sd)

# Подготовка таблицы result2 для отправки в .docx
myft1 <- flextable(result2, cwidth = 1)
# Добавление темы визуального оформления
myft1 <- theme_box(myft1)

# Объединение строк в столбце регион и статус курения по группам
myft1 <- merge_v(myft1, j = ~ region + smoker)

# Добавление таблицы в созданный файл .docx
doc_general <- doc_general %>%  
  body_add_par("Возраст по статусу курения и регионам", style = "heading 1") %>% 
  body_add_flextable(value = myft1)

#########################################
# 3. Создание таблицы с описательными характеристиками по региону, полу и статусу курения #
result3 <- data %>% 
  group_by(region, sex, smoker) %>% 
  summarise(median = median(age),
            mean = mean(age),
            sd = sd(age),
            q1 = quantile(age, prob=c(.25)),
            q3 = quantile(age, prob=c(.75))
  )  %>%
  mutate("Me" = paste0(median, " (", q1,"; ", q3, ")")) %>%
  select(-median, -q1, -q3) %>%
  mutate("M" = paste0(round(mean, 2), " (", round(sd, 2), ")")) %>%
  select(-mean, -sd)


# Подготовка таблицы result3 для отправки в .docx
myft1 <- flextable(result3, cwidth = 1.5)
# Добавление темы визуального оформления
myft1 <- theme_box(myft1)

# Объединение строк в столбце регион, пол и статус курения по группам
myft1 <- merge_v(myft1, j = ~ region + sex + smoker)

# Добавление таблицы в созданный файл .docx
doc_general <- doc_general %>%  
  body_add_par("Возраст по статусу курения, регионам, полу", style = "heading 1") %>% 
  body_add_flextable(value = myft1)

##################################

# 4. Создание графика с боксплотами по стоимости страховых выплат для различных регионов #
myplot1 <- 
  ggplot(data, aes(region, charges))+
  geom_boxplot()+
  geom_jitter(aes(color = region),alpha = 0.4)+
  theme_light() +
  scale_y_continuous(labels = scales::unit_format(suffix = "$"))+
  theme(legend.position = "none")+
  labs(title = "Страховые выплаты для различных регионов",
       x = "Регион",
       y = "Сумма выплат")

# Добавление созданного графика myplot1 к документу .docx
doc_general <- doc_general %>%  
  body_add_par("Стоимость страховки для различных регионов", style = "heading 1") %>% 
  body_add_gg(value = myplot1, style = "centered", width = 5, height = 4)

################################################

# 5. Создание выборки курящих женщин #
dat <- filter(data, smoker == "yes" & sex == "female")

###############################################

# 6. Расчет корреляции Спирмена #
corr_matrix <- cor(dat[, c(1,3,7)], method = "spearman")
# Визуализация корреляций
corrplot(corr_matrix, method = "ellipse")


# Добавление графика корреляций для курящих женщин в .docx
doc_general <- doc_general %>%  
  body_add_par("Корреляция для возраста, ИМТ, суммы страховых выплат для курящих женщин", style = "heading 1") %>% 
  body_add_plot(
    value = plot_instr(
      code = {corrplot(corr_matrix, method="ellipse")}
    ),
    style = "centered" )

##############################################

# 7. График оценки взаимосвязи между ИМТ и страховыми выпалтами для курящих женщин #
myplot1 <- ggplot(dat, aes(x = bmi, y = charges)) +
  geom_point() +
  stat_smooth(method = lm)


# Добавление графика к файлу .docx
doc_general <- doc_general %>%  
  body_add_par("Стоимость страховых выплат в зависимости от ИМТ для курящих женщин", style = "heading 1") %>% 
  body_add_gg(value = myplot1, style = "centered", width = 5, height = 4)

###############################################

# 8. Построение линейной модели зависимости стоимости страховых выплат в зависимости от возраста и ИМТ для курящих женщин #
model3 <- lm(charges ~ bmi + age, data = dat)
summary(model3)

# Извлечение результатов построения линейной модели в виде таблицы с помощью функции tidy
reg_table <- tidy(model3)
options(scipen = 999)
# Округление значения p
reg_table$p.value <- round(ifelse(reg_table$p.value < 0.0001, 0.0001, reg_table$p.value),4)

# Подготовка таблицы reg_table для отправки в .docx
myft1 <- flextable(reg_table, cwidth = 1.5)

# Добавление созданной таблицы с результатами линейной модели (регрессии) к документу .docx
doc_general <- doc_general %>%  
  body_add_par("Результаты регрессионного анализа (подгруппа курящих женщин)", style = "heading 1") %>% 
  body_add_flextable(value = myft1)

###############################################
# 9. Сохранение документа в виде файла с именем results.docx #
print(doc_general, target = "results.docx")



