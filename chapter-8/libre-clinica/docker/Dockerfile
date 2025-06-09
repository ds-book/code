FROM tomcat:9-jdk11
# Создаем необходимые папки и настраиваем перенаправление на LibreClinica
RUN set -eux; \
    mkdir /usr/local/tomcat/webapps/LibreClinica; \
    mkdir /usr/local/tomcat/webapps/ROOT; \
    echo '<html><head><meta http-equiv="refresh" content="0; URL=LibreClinica/" /></head></html>' \
        > /usr/local/tomcat/webapps/ROOT/index.html;
# Скачиваем установочный пакет с LibreClinica и распаковываем в папку приложений Apache Tomcat 
RUN apt-get update -qq; \
    apt-get -y --no-install-recommends install unzip; \
    curl -o /tmp/LibreClinica.war https://www.libreclinica.org/downloads/LibreClinica-web-1.3.0.war; \
    unzip -q /tmp/LibreClinica.war -d /usr/local/tomcat/webapps/LibreClinica/; \
    rm /tmp/LibreClinica.war
# Добавляем тома для хранения данных и логов
VOLUME \
    /usr/local/tomcat/libreclinica.data \
    /usr/local/tomcat/logs
# Добавляем файлы конфигурации
COPY \
    ./config/ \
    /usr/local/tomcat/libreclinica.config/
# Добавляем перевод на русский язык
COPY \
    ./i18n/translation/ \
    /usr/local/tomcat/webapps/LibreClinica/WEB-INF/classes/org/akaza/openclinica/i18n/
# Добавляем виджет календаря на русском языке
COPY \
    ./i18n/calendar/ \
    /usr/local/tomcat/webapps/LibreClinica/includes/new_cal/lang/