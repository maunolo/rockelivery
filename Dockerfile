FROM elixir:1.13.4

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y postgresql-client git-core

# Install Dependencies
RUN mkdir /opt/app
COPY . /opt/app
WORKDIR /opt/app
RUN mix local.hex --force && mix deps.get && mix do compile

ENV PORT 4000

EXPOSE $PORT

CMD ["/opt/app/entrypoint.sh"]
