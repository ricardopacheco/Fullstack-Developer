FROM ruby:3.2.0

ENV DEBIAN_FRONTEND noninteractive

# Enable parallel downloads in apt
RUN echo 'Acquire::Queue-Mode "host";' >> /etc/apt/apt.conf # Change host for access to disable parallel downloads

# Force apt to retry downloads
RUN echo 'APT::Acquire::Retries=10;' >> /etc/apt/apt.conf

RUN apt-get update && apt-get install -y \
  autoconf bison build-essential libcurl4-openssl-dev libdb-dev libffi-dev \
  libgdbm-dev libgdbm6 liblzma-dev libncurses5-dev libpq-dev libreadline-dev \
  libreadline6-dev libssl-dev libxml2-dev libxslt-dev libyaml-dev imagemagick \
  patch pkg-config postgresql-client uuid-dev zlib1g-dev

RUN echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc

RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -
RUN apt-get install -y nodejs
RUN npm install npm@9.6.6 -g
RUN npm install yarn@1.22.19 -g

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem uninstall -i /usr/local/lib/ruby/gems/3.2.0 bundler
RUN gem install bundler -v 2.4.6

ENV APP_HOME /usr/src/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
COPY package*.json $APP_HOME/
RUN yarn install
RUN bundle install --jobs 3

ADD . $APP_HOME
