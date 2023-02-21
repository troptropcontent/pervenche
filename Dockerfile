FROM ruby:3.2.1
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /pervenche
COPY Gemfile /pervenche/Gemfile
COPY Gemfile.lock /pervenche/Gemfile.lock
RUN bundle install

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]