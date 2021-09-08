FROM elixir:1.12.2-alpine

ARG USER_ID
ARG GROUP_ID
ARG GITHUB_API_TOKEN

RUN addgroup --gid ${GROUP_ID} user && \
    adduser --disabled-password --ingroup user --uid ${USER_ID} user

RUN apk update && apk upgrade && \
    apk add --update --no-cache \
    build-base yarn nodejs-current \
    inotify-tools git

USER user

RUN mkdir -p /home/user/app

WORKDIR /home/user/app

RUN mix do local.rebar --force, local.hex --force
