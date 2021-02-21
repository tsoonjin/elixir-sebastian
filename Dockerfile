FROM bitwalker/alpine-elixir-phoenix:latest

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

ARG MIX_ENV
ENV MIX_ENV=$MIX_ENV

CMD mix deps.get && mix phx.server
