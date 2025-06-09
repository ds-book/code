if (!require(reportfactory)) install.packages("reportfactory") 
library(reportfactory)

# Просмотр фабрики
factory_overview()

# Доступные отчеты
list_reports()

# Компиляция всех отчетов
compile_reports()

# Компиляция отчета по имени
compile_reports(reports = "study_report_gt")

# Компиляция отчетов из папки
compile_reports(reports = "report_sources/")

# Компиляция отчета с параметрами
compile_reports(reports = "study_report_gt", 
                params = list(age.group = "средний" , report.date = "2024-11-07"))
# Компиляция нескольких отчетов
compile_reports(reports = c("study_report_gt", "example_report"))

# Компиляция нескольких отчетов с параметрами
compile_reports(reports =  c("study_report_gt", "study_report_ft"),
                params = list(age.group = "средний" , report.date = "2024-11-07"),
                subfolder = "средний возраст")

# Просмотр результатов
list_outputs()

# Просмотр зависимостей
list_deps()

# Установка зависимостей
install_deps()

# Проверка содержимого фабрики
validate_factory()
