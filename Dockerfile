FROM ruby:2.3.1

RUN apt-get update && apt-get install -y build-essential nodejs bundler

RUN mkdir -p /var/www/randsome_meetup
WORKDIR /var/www/randsome_meetup

COPY . /var/www/randsome_meetup
ENV BUNDLE_PATH /bundle
RUN bundle install

CMD ["bundle", "exec", "rails", "s", "--binding", "0.0.0.0"]
