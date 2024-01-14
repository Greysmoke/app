FROM python:3.4

RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list

RUN apt update && apt install -y \
    sudo \
    python-dev \
    libsasl2-dev \
    build-essential \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r uwsgi && useradd -r -g uwsgi uwsgi 

RUN sudo python -m pip install --upgrade pip Flask==0.10.1 uWSGI==2.0.8 requests==2.5.1 redis==2.10.3

WORKDIR /app

COPY app /app

COPY cmd.sh /

EXPOSE 9090 9191

USER uwsgi

CMD ["/cmd.sh"]
