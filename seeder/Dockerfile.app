FROM python:3.13-slim

# Установка java и нужных пакетов за один RUN для кеширования
RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        gcc \
        libpq-dev \
        python3-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*


# Добавляем системного пользователя postgres в системную группу postgres
RUN addgroup --system postgres && adduser --system --ingroup postgres postgres

# Скачиваем и устанавливаем flyway в /usr/local/bin
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.22.3/flyway-commandline-9.22.3-linux-x64.tar.gz | tar xvz \
    && mv flyway-9.22.3/flyway /usr/local/bin/flyway \
    && chmod +x /usr/local/bin/flyway \
    && rm -rf flyway-9.22.3

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

# Переключаемся на пользователя postgres (важно, чтобы у него был доступ к /app)
USER postgres

CMD ["python", "main.py"]
