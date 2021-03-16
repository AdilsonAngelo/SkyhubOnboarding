FROM elixir:1.8.1

RUN mkdir /app
WORKDIR /app
COPY mix.* /app/

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

COPY . /app

RUN mix do compile

CMD ["mix", "phx.server"]