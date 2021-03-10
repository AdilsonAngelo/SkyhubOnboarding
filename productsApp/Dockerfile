FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y curl wget
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update
RUN apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev \
    libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
    software-properties-common libffi-dev nodejs yarn tzdata

RUN wget http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz
RUN tar -xzvf ruby-2.3.0.tar.gz
RUN cd ruby-2.3.0 \
    && ./configure \
    && make \
    && make install

RUN gem install bundler -v 1.17.3

COPY . .

RUN bundle _1.17.3_ install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]