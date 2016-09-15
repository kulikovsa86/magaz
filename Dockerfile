FROM ruby:2.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
    && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

WORKDIR /usr/src/app
COPY . .
RUN bundle install --local

WORKDIR /usr/src/app/spec/test_app

RUN bin/rake magaz:install:migrations
RUN bin/rake db:migrate SCOPE=magaz
RUN bin/rake magaz:seed

EXPOSE 3000
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
