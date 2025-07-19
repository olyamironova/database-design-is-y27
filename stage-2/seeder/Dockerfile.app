FROM python:3.13-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        gcc \
        libpq-dev \
        python3-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN addgroup --system postgres && adduser --system --ingroup postgres postgres

RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/9.22.3/flyway-commandline-9.22.3-linux-x64.tar.gz | tar xvz \
    && mv flyway-9.22.3/flyway /usr/local/bin/flyway \
    && chmod +x /usr/local/bin/flyway \
    && rm -rf flyway-9.22.3

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

USER postgres

CMD ["python", "main.py"]
