#### Подготовка данных ####

source("data-table.R")

#### Отчеты в PowerPoint с officer ####

if (!require(officer)) install.packages("officer")

# Создаем презентацию
doc <- read_pptx() 

# Добавляем слайд
doc <- add_slide(doc, layout = "Title and Content", master = "Office Theme")

# Работаем со слайдом
doc <- ph_with(doc, value = "Hello world", location = ph_location_type(type = "title"))
doc <- ph_with(doc, value = "A footer", location = ph_location_type(type = "ftr"))
doc <- ph_with(doc, value = format(Sys.Date()), location = ph_location_type(type = "dt"))
doc <- ph_with(doc, value = "slide 1", location = ph_location_type(type = "sldNum"))
doc <- ph_with(doc, value = head(letters), location = ph_location_type(type = "body"))

#### Текст ####

# Добавим текст
doc <- add_slide(doc, "Title and Content")
doc <- ph_with(doc, "Текст с оформлением", ph_location_type(type = "title"))
# Создадим параграф
par1 <- fpar(
  # Первый блок текста
  ftext("Это жирный и большой текст", prop = fp_text(bold = TRUE, font.size = 40)),
  # Второй блок текста
  ftext("Этот текст красный и поменьше", prop = fp_text(color = "red", font.size = 20))
)
# Еще один параграф с текстом без оформления
par2 <- fpar(ftext("А этот текст будет обычным"))
# Объединим параграфы в блок. Второй параграф продублируем
bl <- block_list(par1, par2, par2)
# Добавим блок текста на слайд
doc <- ph_with(doc, bl, ph_location_type(type = "body"))

#### Таблица ####

# Добавим таблицу
doc <- add_slide(doc, "Title and Content")
doc <- ph_with(doc, "Таблица", ph_location_type(type = "title"))
doc <- ph_with(doc, head(data), ph_location_type(type = "body") )

#### Таблица flextable ####

source("flextable.R")

# Добавим таблицу flextable
doc <- add_slide(doc, "Title and Content")
doc <- ph_with(doc, "Таблица flextable", ph_location_type(type = "title"))
doc <- ph_with(doc, ft_full, ph_location_type(type = "body"), alignment = "c", use_loc_size = TRUE)

#### Таблица gt ####

source("gt.R")

# Добавим таблицу gt
doc <- add_slide(doc, "Title and Content")
doc <- ph_with(doc, "Таблица gt", ph_location_type(type = "title"))
doc <- ph_with(doc, gt_table, ph_location_type(type = "body"), alignment = "c", use_loc_size = TRUE)
# Добавление таблиц gt в PowerPoint не поддерживается

#### Изображения ####

# Добавим слайд с двумя колонками
doc <- add_slide(doc, "Two Content")
doc <- ph_with(doc, "Картинка из файла", ph_location_type(type = "title"))
# Получим полный путь к картинке
img <- file.path( getwd(), "boxplot.png" )
# С ручным заданием размеров добавим в левую колонку
doc <- ph_with(doc, external_img(img, width = 2.78, height = 2.12), ph_location_left(), use_loc_size = FALSE )
# С автоматическим заданием размера добавим в правую колонку
doc <- ph_with(doc, external_img(img), location = ph_location_right(), use_loc_size = TRUE )

# Добавим слайд с двумя колонками для ggplot
if (!require(ggplot2)) install.packages("ggplot2")
gg <- ggplot(cytomegalovirus %>% mutate(sex = ifelse(sex == 1, "M", "F")), aes(sex, age)) + geom_boxplot()

doc <- add_slide(doc, "Two Content")
doc <- ph_with(doc, "График ggplot", ph_location_type(type = "title"))
doc <- ph_with(doc, "График ggplot занимает всю предоставленную ему область", location = ph_location_left())
doc <- ph_with(doc, gg, location = ph_location_right())

# Добавим пустой слайд для графика ggplot2
doc <- add_slide(doc, layout = "Blank")
doc <- ph_with(doc, gg, ph_location_fullsize() )

# Добавим график MS Office
if (!require(mschart)) install.packages("mschart")
bc <- ms_barchart(data = cytomegalovirus %>% mutate(sex = ifelse(sex == 1, "M", "F")), 
                  x = "sex", y = "age", group = "diagnosis")

doc <- add_slide(doc, layout = "Two Content")
doc <- ph_with(doc, "График MS Office", ph_location_type(type = "title"))
doc <- ph_with(doc, "Это редактируемый график, созданный средствами MS Office", 
               ph_location_left())
doc <- ph_with(doc, bc, ph_location_right())

# Сохраним презентацию
print(doc, target = "officer_report.pptx") 
