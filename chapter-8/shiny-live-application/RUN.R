# Необходимо установить пакет shinylive.
install.packages("shinylive")

# Для экспорта приложения необходимо выполнить команду shinylive::export().
shinylive::export(".", "site")

# Открыть скомпилированный сайт в браузере можно с помощью пакета httpuv и функции runStaticServer().
httpuv::runStaticServer("site/")

# Можно добавить Workflow для автоматической сборки и публикации собранного статического сайта на GitHub Pages с помощью команды: 
usethis::use_github_action(url="https://github.com/posit-dev/r-shinylive/blob/actions-v1/examples/deploy-app.yaml")
