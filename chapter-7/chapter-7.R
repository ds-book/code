#### Модель линейной регрессии  ####

part_lifes <- lifes %>% select("Life.expectancy", "Adult.Mortality", "infant.deaths","Alcohol", "Measles","Schooling", "BMI", "GDP")
colSums(is.na(part_lifes))
part_lifes <- part_lifes %>% na.omit()
colSums(is.na(part_lifes))
scaled_lifes = scale(part_lifes)


cor(scaled_lifes)

# Нормализация таблицы part_lifes
scaled_lifes <- scale(part_lifes)        
# Вычисление среднего значения и дисперсии из атрибутов нормализованной таблицы
mean_val <- attr(scaled_lifes, "scaled:center")[c('Life.expectancy')]
std_val <- attr(scaled_lifes, "scaled:scale")[c('Life.expectancy')]
# Приведение стандартизированного значения продолжительности жизни обратно к исходному масштабу по формуле xstd+mean
recovered_column = scaled_lifes[, 'Life.expectancy']*std_val + mean_val
head(recovered_column)
# Выбор случайных номеров строк без повторов из таблицы, при этом количество выбранных строк равно 80% от количества строк во всей таблице
index_for_train <- sample(1:nrow(scaled_lifes), 0.8*nrow(scaled_lifes))
# Выбор строк таблицы для использования в обучении
train_set <- scaled_lifes[ index_for_train,]
# Выбор строк таблицы (исключение строк) для проверки работы модели
val_set <- scaled_lifes[ -index_for_train,]

train_set <- as.data.frame(train_set)
val_set <- as.data.frame(val_set)


model <- lm(Life.expectancy ~ Adult.Mortality + infant.deaths + Alcohol + Measles + Schooling + BMI + GDP, data = train_set)
summary(model)
#  Установка пакета
install.packages('Metrics')
# Загрузка пакета
library(Metrics)
# Расчет метрики MAE
mae(val_set$Life.expectancy, predict(model))


saveRDS(model, file = "model.rds")
loaded_model <- readRDS("model.rds")

summary(loaded_model)

# Генерация случайных данных, похожих на настоящие
data <- data.frame(Adult.Mortality = sample(1:300, 5, replace = TRUE),
                   infant.deaths = sample(1:100, 5, replace = TRUE),
                   Alcohol = sample(0.01:10, 5),
                   Measles = sample(100:2000, 5, replace = TRUE),
                   Schooling = sample(7:12, 5),
                   BMI = sample(5:20, 5),
                   GDP = sample(25:800, 5))


attr(scaled_lifes, "scaled:center")
attr(scaled_lifes, "scaled:scale")
# Выбор среднего значения и стандартного отклонения всех признаков, кроме Life.expectancy
mean_val <- attr(scaled_lifes, "scaled:center")[-1]
std_val <- attr(scaled_lifes, "scaled:scale")[-1]
# Нормализация новых данных, используя известные параметры
norm_new_data <- scale(data, center = mean_val, scale = std_val)
# Преобразование данных norm_new_data в формат таблицы
norm_new_data <- as.data.frame(norm_new_data)
# Предсказание результата, используя загруженную модель и новые данные
predict(loaded_model, norm_new_data)

# Выбор среднего значения для продолжительности жизни в исходных данных (обучающая выборка)
mean_val_lifes <- attr(scaled_lifes, "scaled:center")[c('Life.expectancy')]
# Выбор стандартного отклонения для продолжительности жизни
std_val_lifes <- attr(scaled_lifes, "scaled:scale")[c('Life.expectancy')]
# Приведение стандартизированного значения продолжительности жизни обратно к исходному масштабу по формуле xstd+mean
recoverd_predict = predicted_vals*std_val_lifes + mean_val_lifes
head(recoverd_predict)

new_model <- lm(Life.expectancy ~ BMI + GDP + BMI:GDP, data = train_set)
summary(new_model)



#### Логистическая регрессия ####

# Загрузка csv файла в виде таблицы.
mydata <- read.csv("Путь_к_папке_с_файлом\\diabetes.csv")
# Вывод первых строк таблицы.
head(mydata)

# Загрузка csv файла в виде таблицы.
mydata <- read.csv("Путь_к_папке_с_файлом\\diabetes.csv")
# Выбор признаков, на которых обучается модель.
X <- mydata %>% select("Pregnancies","Glucose","BloodPressure", "SkinThickness","Insulin", "BMI", "DiabetesPedigreeFunction", "Age")

# Нормализация таблицы.
X = scale(X)

# Добавление колонки "Outcome" к матрице X.
Outcome <- mydata$Outcome
X <- cbind(X, Outcome)

# Обращение матрицы X в таблицу df.
df <- as.data.frame(X)

# Установка seed для воспроизводимости эксперимента. 
set.seed(123)
# Создание случайных номеров строк.
train_indices <- sample(1:nrow(df), 0.8*nrow(df)) # 80% данных будет обучающей выборке
# Строки с порядковым номером из train_indices переносятся в обучающий набор.
train_data <- df[train_indices, ]
# Строки с порядковым номером не из train_indices переносятся в проверочный набор.
test_data <- df[-train_indices, ]


# Обучение модели.
model <- glm(Outcome ~ Pregnancies + Glucose  + BloodPressure + SkinThickness + Insulin  + BMI + DiabetesPedigreeFunction + Age, data = train_data, family = "binomial")

summary(model)


# Предсказание на проверочном наборе данных.
predictions <- predict(model, newdata = test_data, type = "response")

# Преобразование вероятностей в 0 и 1, используя порог 0.5.
predicted_classes <- ifelse(predictions > 0.5, 1, 0)


# Выбор истинных значений.
real_classes <- test_data$Outcome
# Расчет чувствительности.
accuracy <- mean(predicted_classes == real_classes)


library(caret)
confusionMatrix(as.factor(predicted_classes), as.factor(real_classes))

exp(model$coeff) 


#### Деревья принятия решений. Случайный лес ####

# Загрузка библиотеки для обработки данных.
library("tidyr")
# Загрузка таблицы данных.
students_data = read.csv("Путь_к_файлу\\medical_students_dataset.csv")
# Удаление колонки Student.ID
students_data <- subset(students_data, select = - c(Student.ID))
# Значения в некоторых строках пропущены, заполнение их как NA.
students_data[students_data == ''] <- NA
# Удаление всех строк, где есть NA
students_data <- drop_na(students_data)


# Приведение столбцов из текстового формата в факторы.
students_data$Diabetes <- as.factor(students_data$Diabetes)
students_data$Smoking <- as.factor(students_data$Smoking)
students_data$Gender <- as.factor(students_data$Gender)
# Перевод каждой группы крови из текста в факторы.
students_data$Blood.Type <- factor(students_data$Blood.Type, levels = c("O", "A", "AB", "B"))


# Установка seed для воспроизводимости операции.
set.seed(71)
# Деление данных на обучающую и тестовую выборки.  
sample <- sample(c(TRUE,FALSE), nrow(students_data), replace=TRUE, prob=c(0.9,0.1))
# Обучающая выборка.
train  <- students_data[sample, ]
# Тестовая выборка.
test <- students_data[!sample, ]


# Установка пакета randomForest.
install.packages('randomForest')
# Загрузка пакета randomForest.
library(randomForest)
# Обучение случайного леса.
rf <- randomForest(x = train[colnames(test) != 'Diabetes'], y = train$Diabetes, 
                   ntree=50, mtry = 3, importance=TRUE, keep.forest=TRUE,
                   xtest = test[colnames(test) != 'Diabetes'],
                   ytest = test$Diabetes)


# Вызов модели без аргументов.
rf
# Вывод важности признаков с точки зрения падения точности предсказания.
importance(rf, type = 1)
# Важность с точки зрения падения прироста информативности.
importance(rf, type = 2)
# График важности признаков.
varImpPlot(rf)
# Получаем предсказания наличия/отсутствия диабета на тестовой выборке, предварительно удалив из нее столбец Diabetes.
predictions <- predict(rf, newdata = test[colnames(test) != 'Diabetes'], type = "response")
# Создание матрицы ошибок.
conf_matrix <- table(predictions, test$Diabetes)
# Установка пакета caret.
install.packages('caret') 
# Импортирт пакета caret.
library("caret")
# В функцию confusionMatrix() подаются предсказания и истинные метки.
matrix <- confusionMatrix(predictions, test$Diabetes)
# Вывод результата.
matrix



#### Бустинг ####

# Загрузка таблицы.
diabetes <- read.csv("Путь_к_папке_с_файлом\\diabetes.csv")
# Вывод столбцов таблицы diabetes. 
names(diabetes)
# Количество строк в таблице.
nrow(diabetes)


# Установка seed для воспроизводимости операции.
set.seed(71)
# Разделение данных на обучающую и тестовую выборки. 
sample <- sample(c(TRUE,FALSE), nrow(diabetes),replace=TRUE, prob=c(0.9,0.1)) 
# Обучающая выборка.
train  <- diabetes[sample, ]
# Тестовая выборка.
test <- diabetes[!sample, ]

# Выделение целевой метки из обучающих данных.
X_train <- as.matrix(train[,!names(train) %in% c("Outcome")])
y_train <- train[,'Outcome']
# Выделение целевой метки из тестовых данных.
X_test <- as.matrix(test[,!names(train) %in% c("Outcome")])
y_test <- test[,'Outcome']


install.packages("lightgbm")
library(lightgbm)

# Обучение модели бустинга.
model <- lightgbm(data = X_train, label = y_train, 
                  params = list(bagging_fraction = 0.5, max_depth=2, feature_fraction=0.5,
                                learning_rate = 0.1, objective = "binary"), nrounds = 50,verbose = -1)


data$gender <- as.numeric(as.factor(data$gender))

# Предсказание на тестовой выборке.
pred_test <- predict(model, X_test)
# Перевод значений вероятностей в номера классов, используя порог 0.5.
pred_test <- as.numeric(pred_test > 0.5)
# Создание Confusion matrix.
conf_matrix <- table(pred_test, y_test)
# Сортировка строк в матрице.
conf_matrix <- conf_matrix[c(2,1),c(2,1)]

# Импорт библиотеки “caret” для подсчета метрик качества. 
library("caret")
matrix <- confusionMatrix(conf_matrix)
matrix



#### Нейронные сети ####
# Установка пакета tensorflow.
install.packages("tensorflow")
# Импорт библиотеки tensorflow.
library(tensorflow)
# Установка и импортирование библиотеки Keras.
install.packages("keras")
library(keras)
install_keras()
# Установка и импорт пакета tidyverse.
install.packages("tidyverse")
library(tidyverse)
# Создание папки train.
dir.create("train")
# Создание папки test.
dir.create("test")
# Создание папок для обучающей и тестовой выборки
dir.create("~/train/Normal")
dir.create("~/train/Tuberculosis")
dir.create("~/test/Normal")
dir.create("~/test/Tuberculosis")
# Запись пути к папкам Normal и Tuberculosis.
path_normal <- "~/TB_Chest_Radiography_Database/Normal"
path_tb <- "~/TB_Chest_Radiography_Database/Tuberculosis"
# Перечисление полных путей к каждому изображению в папке Normal.
normal_files <- list.files(path_normal, full.names = TRUE)
# Перечисление полных путей к каждому изображению в папке Tuberculosis.
tb_files <- list.files(path_tb, full.names = TRUE)
# Создание двух таблиц с адресами изображений класса Normal и Tuberculosis
data_normal <- data.frame(files = normal_files)
data_tb <- data.frame(files = tb_files)
head(data_normal)
# Установка set.seed для воспроизводимости результатов.
set.seed(123)
# Создание случайных индексов для классов Normal и Tuberculosis (по 80% каждого класса от исходных данных). 
normal_index <- sample(1:nrow(data_normal), 0.8*nrow(data_normal))
tb_index <- sample(1:nrow(data_tb), 0.8*nrow(data_tb))

# Выбор адресов изображений, которые будут использоваться для обучения и тестирования из класса Normal.
train_normal <- data_normal[normal_index,]
test_normal <- data_normal[-normal_index,]
# Выбор адресов изображений, которые будут использоваться для обучения и тестирования из класса Tuberculosis.
train_tb <- data_tb[tb_index,]
test_tb <- data_tb[-tb_index,]


# Выбор адресов изображений, которые будут использоваться для обучения и тестирования из класса Normal.
train_normal <- data_normal[normal_index,]
test_normal <- data_normal[-normal_index,]
# Выбор адресов изображений, которые будут использоваться для обучения и тестирования из класса Tuberculosis.
train_tb <- data_tb[tb_index,]
test_tb <- data_tb[-tb_index,]



model <- keras_model_sequential() %>%
  layer_conv_2d(filter = 32, kernel_size = c(3,3), input_shape = c(256, 256, 1), activation = 'relu') %>%
  layer_conv_2d(filter = 32, kernel_size = c(3,3), activation = 'relu') %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_conv_2d(filter = 64, kernel_size = c(3,3), activation = 'relu') %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_conv_2d(filter = 64, kernel_size = c(3,3), activation = 'relu') %>%
  layer_max_pooling_2d(pool_size = c(2,2)) %>%
  layer_flatten() %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 1, activation = 'sigmoid')
summary(model)


model %>% compile(loss = 'binary_crossentropy',
                  optimizer = optimizer_adam(),
                  metrics = c(metric_true_positives(), metric_true_negatives(),  metric_false_negatives(), metric_false_positives()))


train_generator <- flow_images_from_directory("train",
                                              generator = image_data_generator(rescale = 1/255,
                                                                               horizontal_flip = TRUE, brightness_range = c(0.5,2)),
                                              color_mode = "grayscale",
                                              save_to_dir = "processed_images",
                                              target_size = c(256, 256), 
                                              class_mode = "binary",
                                              shuffle = TRUE,
                                              classes = c('Normal', 'Tuberculosis'),
                                              batch_size = 4)

test_generator <- flow_images_from_directory("test", 
                                             generator = image_data_generator(rescale = 1/255),
                                             color_mode = "grayscale", 
                                             target_size = c(256, 256), 
                                             class_mode = "binary",
                                             shuffle = FALSE,
                                             classes = c('Normal', 'Tuberculosis')
                                             batch_size = 4)

history <- model %>% 
  fit(train_generator, epochs = 3, validation_data = test_generator, class_weight = list("0"=1,"1"=5))
# Список адресов файлов внутри папки Normal.
files <-  list.files('~/train/Normal/', pattern = ".", all.files = FALSE, recursive = TRUE, full.names = TRUE)
# Вывести количество файлов в папке Normal.
length(files)

files <-  list.files('~/train/Tuberculosis/', pattern = ".", all.files = FALSE, recursive = TRUE, full.names = TRUE)
# Вывести количество файлов в папке Normal.
length(files)


theme_set(theme_minimal()) 
plot(history)

sensivity <- 135/(135 + 5)
specifity <- 662/(38 + 662)
print(sensivity)
print(specifity)


# Сохранение модели в папку my_model.
save_model_tf(model, "~/my_model")


# Загрузка модели и запись в переменную new_model.
new_model <- load_model_tf('~/my_model')
# Вывод структуры загруженной модели.
summary(new_model)



#### Алгоритмы кластеризации ####
# Загрузка таблицы.
data <- read.csv(file = '~/daiabet.csv') 
# Выбор столбцов blood.sugar и blood.pressure.
data_subset <- data[, c("blood.sugar", "blood.pressure")]

set.seed(1)
kmeans_model <- kmeans(data_norm, centers = 2)
print(kmeans_model)

library(factoextra)
fviz_cluster(kmeans_model, data = data_subset)
# Определение числа кластеров методом локтя.
wss <- numeric(10)
for (i in 1:10){
  wss[i] <- sum(kmeans(data_norm, centers=i)$withinss)
}
plot(1:10, wss, type="b", xlab="Количество кластеров", ylab="Расстояние")
hc <- hclust(dist(data_norm), method="complete")



#### Методы понижения размерности ####
library(ggplot2)
library(caret)
# Загрузка таблицы.
data <- read.csv(file = '~/daiabet.csv')

# Удаление столбцов Sex и Complications.of.diabetes.
data <- data[ , !names(data) %in% c("Sex", "Complications.of.diabetes", "Family.history")]
# Применение PCA к данным. Из данных исключен столбец с целевой меткой.
pca <- prcomp(data[, names(data) != "type.of.diabetes"], scale. = TRUE)
# Получение первой и второй компоненты.
pca_data <- as.data.frame(pca$x[,c("PC1", "PC2")])
# Добавление к данным после PCA целевой метки с типом сахарного диабета. 
pca_data$type.of.diabetes <- data$type.of.diabetes
ggplot(pca_data, aes(x = PC1, y = PC2, color = as.factor(type.of.diabetes))) +
  geom_point() +
  labs(color = "Типы диабета") +
  theme_light()
# Разделение данных на обучающую и тестовую выборки.
set.seed(123)
trainIndex <- createDataPartition(pca_data$type.of.diabetes, p = 0.8, list = FALSE)
train_data <- pca_data[trainIndex, ]
test_data <- pca_data[-trainIndex, ]


# Преобразование значений столбца type.of.diabetes в 0 и 1.
train_data$type.of.diabetes <- ifelse(train_data$type.of.diabetes == 1, 0, 1)
test_data$type.of.diabetes <- ifelse(test_data$type.of.diabetes == 1, 0, 1)

# Обучение логистической регрессии.
model <- glm(type.of.diabetes ~ ., data = train_data, family = "binomial")
# Предсказание значений на тестовой выборке.
pred <- predict(model, newdata = test_data, type = "response")
# Перевод вероятности в значения классов (0 или 1).
pred_class <- ifelse(pred > 0.5, 1, 0)
# Вычисление точность предсказания на тестовых данных.
accuracy <- mean(pred_class == test_data$type.of.diabetes)
cat("Accuracy:", accuracy)
# Вывод истинных значений.
cat(test_data$type.of.diabetes)
# Вывод предсказанных значений.
cat(pred_class)


#### Автоматизация подходов к построению моделей машинного обучения ####

install.packages("tidymodels")
library(tidymodels)
heart_data <- read.csv(file = '~/heart.csv')

split_data <- initial_split(heart_data, prop = 0.9)
# Получение таблицы с обучающей и тестовой выборками.
train_data <- training(split_data)
test_data <- testing(split_data)
# Создание рецепта.
data_recipe <- recipe(target ~., data = heart_data) %>%
  step_mutate(across(c(sex, cp, fbs, restecg, exang, slope, ca, thal, target),    factor)) %>%
  step_dummy(c("sex", "cp", "fbs", "restecg", "exang", "slope", "ca", "thal"), 
             one_hot = TRUE) %>%
  step_corr(all_predictors()) %>% 
  step_center(c("age", "trestbps", "chol", "thalach", "oldpeak")) %>%
  step_scale(c("age", "trestbps", "chol", "thalach", "oldpeak"))


data_train_preprocessed <- data_recipe %>% 
  prep(train_data) %>%
  juice()
head(data_train_preprocessed)


colnames(data_train_preprocessed)

data_test_preprocessed <- data_recipe %>% 
  prep %>%
  bake(test_data)
head(data_test_preprocessed)


model<-
  # Указание, что модель представляет собой случайный лес.
  rand_forest() %>%
  # Выбор пакета, лежащий в основе модели.
  set_engine("randomForest") %>%
  # Выбор режима: регрессии или классификации.
  set_mode("classification") 

# Настройка рабочего процесса.
model_workflow <- workflow() %>%
  # Добавление "рецепта".
  add_recipe(data_recipe) %>%
  # Добавление модели.
  add_model(model)


# Обучение модели случайного леса.
model_fit <- model_workflow %>%
  last_fit(split_data)


test_performance <- model_fit %>% collect_metrics()

test_predictions <- model_fit %>% collect_predictions()


# Создание матрицы ошибок
test_predictions %>%
  conf_mat(truth = target, estimate = .pred_class)


# Обучение финальной модели.
final_model <- fit(model_workflow, heart_data)

model <-
  # Указание, что модель представляет собой случайный лес.
  rand_forest() %>%
  # Указание гиперпарметров, которые необходимо подобрать: `mtry`, trees, min_n. 
  set_args(mtry = tune(), trees = tune(), min_n = tune()) %>%
  # Выбор пакета, который лежит в основе модели.
  set_engine("randomForest") %>%
  # Выбор режима регрессии или классификации.
  set_mode("classification") 

# Настройка рабочего процесса.
model_workflow <- workflow() %>%
  # Добавление "рецепта".
  add_recipe(data_recipe) %>%
  # Добавление модели.
  add_model(model)


# Создание данных с кросс-валидацией.
cv <- vfold_cv(train_data, v = 5)

# Создание вариантов гиперпараметров.
params <- grid_regular(
  mtry(range = c(2, 4)),
  trees(range = c(100, 500)),
  min_n(range = c(2, 5))
)


# Получение результатов.
model_tune <- tune_grid(object = model_workflow, #рабочий процесс 
                        resamples = cv, # объект кросс-валидации
                        grid = params, # сетка значений, гиперпараметров для поиска оптимальных
                        metrics = metric_set(accuracy, roc_auc, recall) # метрики, которые будут считаться
)

all_metrics <- collect_metrics(model_tune)

best_params <- model_tune %>%
  select_best(metric = "recall")

show_best(model_tune, metric = "recall")

model_workflow <- model_workflow %>%
  finalize_workflow(best_params)

final_model_tune <- fit(model_workflow, heart_data)
