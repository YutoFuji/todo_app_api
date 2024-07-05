FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app

RUN gem install bundler && bundle install

COPY ./src /app

RUN apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y vim

RUN bundle install
