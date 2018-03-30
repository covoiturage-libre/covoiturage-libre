FROM ruby:2.5

LABEL maintainer="https://github.com/covoiturage-libre/covoiturage-libre" \
      description="Carpooling Open Source platform"

EXPOSE 3000

ENV HOME=/covoiturage-libre \
    PATH=/covoiturage-libre/bin:$PATH \
    PORT=3000

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs

WORKDIR /covoiturage-libre

COPY Gemfile Gemfile.lock /covoiturage-libre/

RUN bundle install

COPY . $WORKDIR

CMD ["/bin/bash", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
