# Build time container
FROM elixir:1.11-alpine as builder

ARG app_name=sebastian
ARG PORT=5000
ARG build_env=prod
ARG dashboard_username
ARG dashboard_password
ARG phoenix_subdir=.
ENV MIX_ENV=${build_env}
ENV HTTP_BASIC_AUTH_USERNAME=${dashboard_username}
ENV HTTP_BASIC_AUTH_PASSWORD=${dashboard_password}

RUN apk update \
  && mix local.rebar --force \
  && mix local.hex --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix do deps.get, compile
RUN mix phx.digest
RUN mix release ${app_name} \
  && mv _build/${build_env}/rel/${app_name} /opt/release \
  && mv /opt/release/bin/${app_name} /opt/release/bin/start_server

# Runtime container
FROM alpine:latest
RUN apk update \
  && apk --no-cache --update add bash ca-certificates openssl-dev \
  && mkdir -p /usr/local/bin

ENV REPLACE_OS_VARS=true

# For local dev, heroku will ignore this
EXPOSE $PORT

WORKDIR /opt/app
COPY --from=builder /opt/release .
RUN addgroup -S elixir && adduser -H -D -S -G elixir elixir
RUN chown -R elixir:elixir /opt/app
USER elixir

# Heroku sets magical $PORT variable
CMD PORT=$PORT exec /opt/app/bin/start_server start
