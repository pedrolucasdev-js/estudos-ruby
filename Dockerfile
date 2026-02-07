# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.8
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# -----------------------------
# Stage de build (compila gems nativas)
# -----------------------------
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libvips \
      pkg-config \
      libyaml-dev \
      zlib1g-dev \
      libffi-dev \
      libgmp-dev \
      curl

# Copia Gemfile e Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instala gems
RUN bundle config set without 'development test' && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia todo código
COPY . .

# Precompila bootsnap app/lib
RUN bundle exec bootsnap precompile app/ lib/

# Ajusta binários para Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# -----------------------------
# Stage final (runtime leve)
# -----------------------------
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq-dev \
      libvips \
      libyaml-dev \
      zlib1g \
      libffi7 \
      curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copia gems compiladas e código
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Cria usuário não-root
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server"]
