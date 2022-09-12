# syntax=docker/dockerfile:1
FROM python:3.10.7-alpine3.16

RUN addgroup --system app \
    && adduser --system \
    --home /app \
    --ingroup app \
    --shell /bin/sh \
    --disabled-password \
    app

USER app

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

CMD [ "python3", "-m", "flask", "--app", "main", "run", "--host=0.0.0.0" ]
