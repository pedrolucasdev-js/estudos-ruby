# syntax = docker/dockerfile:1

# Defina a versão do Ruby
ARG RUBY_VERSION=3.4.8
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Diretório do Rails
WORKDIR /rails

# Ambiente de produção e configuração do Bundler
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# -----------------------------
# Stage de build (para compilar gems)
# -----------------------------
FROM base as build

# Instala pacotes necessários para compilar gems nativas
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libvips \
      pkg-config \
      libyaml-dev \
      zlib1g-dev \
      libffi-dev

# Copia Gemfile e Gemfile.lock e instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia o código da aplicação
COPY . .

# Precompila bootsnap para acelerar boot do Rails
RUN bundle exec bootsnap precompile app/ lib/

# Ajusta binários para Linux
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# -----------------------------
# Stage final (imagem leve para produção)
# -----------------------------
FROM base

# Instala pacotes runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libvips \
      postgresql-client \
      libyaml-dev \
      zlib1g \
      libffi7 && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copia gems compiladas e código da aplicação
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Cria usuário não-root e ajusta permissões
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

# Entrypoint (prepara DB)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Porta do servidor
EXPOSE 3000

# Comando padrão
CMD ["./bin/rails", "server"]
