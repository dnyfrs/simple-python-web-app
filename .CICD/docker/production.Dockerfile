# syntax=docker/dockerfile:1
FROM python:3.10.7-alpine3.16

RUN addgroup --system app \
    && adduser --system \
    --home /app \
    --ingroup app \
    --shell /bin/sh \
    --disabled-password \
    app \
    && apk add --no-cache \
    uwsgi-python3 \
    uwsgi-http

USER app

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir \
    -r requirements.txt

COPY . .

CMD [ "uwsgi", "--plugins", "http,python", "--http", ":5000",  "--wsgi-file", "uwsgi.py" ]
