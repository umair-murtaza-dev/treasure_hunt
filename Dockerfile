FROM ruby:2.7.5
RUN apt-get update -qq && apt-get install -y vim nano postgresql-client
RUN mkdir /treasure_hunter
WORKDIR /treasure_hunter
COPY Gemfile /treasure_hunter/Gemfile
COPY Gemfile.lock /treasure_hunter/Gemfile.lock
RUN gem uninstall bundler
RUN gem install bundler -v 2.1.4
RUN bundle update --bundler
RUN bundle install
COPY . /treasure_hunter

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
RUN echo 'alias ll="ls -l"' >> ~/.bashrc

EXPOSE 3000

# Start the main process.

CMD ["rails", "server", "-b", "0.0.0.0"]
