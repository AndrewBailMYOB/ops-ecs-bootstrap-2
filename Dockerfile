FROM alpine

RUN apk --no-cache add \
        wget \
        curl \
        python3 \
        bash

RUN pip3 install awscli

VOLUME /root/.aws

RUN mkdir -p /srv/app

COPY scripts/create-stack.sh /srv/app
COPY ecs-service/template.yml /srv/app

WORKDIR /srv/app
