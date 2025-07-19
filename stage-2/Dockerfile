FROM postgres:13

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    postgresql-server-dev-13 \
    build-essential

RUN git clone https://github.com/madeinqc/pgfaker.git /tmp/pgfaker && \
    cd /tmp/pgfaker && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pgfaker

RUN apt-get remove -y git gcc make build-essential postgresql-server-dev-13 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN ls -la /usr/share/postgresql/13/extension/pgfaker* && \
    ls -la /usr/lib/postgresql/13/lib/pgfaker*