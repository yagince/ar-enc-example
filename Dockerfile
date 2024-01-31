FROM ruby:3.3.0-alpine3.18 AS ruby

## Development
FROM ruby AS dev

RUN apk update \
    && apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        linux-headers \
        make \
        libpq \
        tzdata \
        git \
        openssl \
    && apk add --virtual build-dependencies --no-cache \
        libpq-dev \
        libxml2-dev \
        build-base \
        curl-dev \
        openssl-dev

RUN mkdir -p /app
ENV HOME /app

WORKDIR $HOME

COPY ./Gemfile* ./
ARG bundle_install_options="--without development test doc --jobs 4"
RUN bundle config github.https true \
  && bundle install $bundle_install_options \
  && apk del build-dependencies

COPY . /app

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

## Production
FROM ruby AS prod

LABEL maintainer "lecto <lecto@lecto.jp>"

RUN apk update \
    && apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        linux-headers \
        make \
        libpq \
        tzdata \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && apk del --purge tzdata

RUN mkdir -p /app
ENV HOME /app
ENV RAILS_ENV production

WORKDIR $HOME

COPY --from=dev /usr/local/bundle /usr/local/bundle
COPY --from=dev /app/app $HOME/app
COPY --from=dev /app/bin $HOME/bin
COPY --from=dev /app/config $HOME/config
COPY --from=dev /app/db $HOME/db
COPY --from=dev /app/lib $HOME/lib
COPY --from=dev /app/public $HOME/public
COPY --from=dev /app/Gemfile* $HOME/
COPY --from=dev /app/Rakefile $HOME/
COPY --from=dev /app/config.ru $HOME/

RUN mkdir -p tmp/pids

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
