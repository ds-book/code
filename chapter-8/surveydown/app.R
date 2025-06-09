# remotes::install_github("surveydown-dev/surveydown", force = TRUE)
library(surveydown)

# Database setup

# surveydown stores data on a database that you define at https://supabase.com/
# To connect to a database, update the sd_database() function with details
# from your supabase database. For this demo, we set ignore = TRUE, which will
# ignore the settings and won't attempt to connect to the database. This is
# helpful for local testing if you don't want to record testing data in the
# database table. See the documentation for details:
# https://surveydown.org/store-data

db <- sd_database(
  host   = Sys.getenv("POSTGRES_HOST"),
  dbname = Sys.getenv("POSTGRES_DB"),
  port   = Sys.getenv("POSTGRES_PORT"),
  user   = Sys.getenv("POSTGRES_USER"),
  table  = Sys.getenv("POSTGRES_TABLE"),
  ignore = FALSE
)


# Server setup
server <- function(input, output, session) {

  # Define any conditional skip logic here (skip to page if a condition is true)
  sd_skip_if(
    any(input$diag %in% c("N30.0")) ~ "acss"
  )

  # Вычисление значения на основе заполненных вопросов
  observe({
    # Вычисляем суммарный индекс на основе ввода пользователя
    acss_1_1 <- as.numeric(input$acss_1_1)
    acss_1_2 <- as.numeric(input$acss_1_2)
    acss_2 <- as.numeric(input$acss_2)
    acss_3 <- as.numeric(input$acss_3)
    acss_4 <- as.numeric(input$acss_4)
    acss_5 <- as.numeric(input$acss_5)
    acss_6 <- as.numeric(input$acss_6)
    acss_sum <- acss_1_1 + acss_1_2 + acss_2 +
      acss_3 + acss_4 + acss_5 + acss_6
    # Сохраняем значение в переменную, доступную на странице
    sd_store_value(acss_sum)
    # Формируем предзаполненный вопрос, чтобы сохранить в базу
    if (length(as.character(acss_sum)) > 0) {
      options <- c(as.character(acss_sum))
      names(options)[1] <- as.character(acss_sum)
      sd_question(
        type   = "slider",
        id     = "acss_summary",
        label  = "Суммарное количество баллов",
        option = options,
        selected = as.character(acss_sum)
      )
    }
  })

  # Define any conditional display logic here (show a question if a condition is true)
  sd_show_if(
    input$sex == "female" ~ "pregnancy",
    input$pregnancy == "yes" ~ "pregnancy_weeks"
  )

  # Database designation and other settings
  sd_server(
    db = db,
    language = "ru",
    required_questions = c("sex", "dob"),
    admin_page = TRUE
  )

}

# shinyApp() initiates your app - don't change it
shiny::shinyApp(ui = sd_ui(), server = server)
