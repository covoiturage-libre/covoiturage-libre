FROM ruby:2.5.0

LABEL maintainer="https://github.com/covoiturage-libre/covoiturage-libre" \
      description="Carpooling Open Source platform"

EXPOSE 3000

ENV HOME=/covoiturage-libre \
    PATH=/covoiturage-libre/bin:$PATH \
    PORT=3000

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt-get update -qq && \
    apt-get install -y g++-6 gcc-6 \
      build-essential \
      libpq-dev \
      nodejs

WORKDIR /covoiturage-libre

COPY Gemfile Gemfile.lock /covoiturage-libre/

RUN bundle install

COPY . $WORKDIR

CMD ["/bin/bash", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
