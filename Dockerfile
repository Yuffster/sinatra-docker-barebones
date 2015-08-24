FROM ruby:2.2.0
MAINTAINER OpenTrons

# Update the system
RUN apt-get update -qq

# Install command-line tools we'll need.
RUN apt-get install -y build-essential

ENV APP_HOME /var/www
ENV PORT 8080
ENV WEB_ENV production

# Create a working directory for our app
RUN echo Creating app directory in $APP_HOME
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Take the files from our Git repo and them to $APP_HOME
# Never edit these files from within containers; make another build.
ADD . $APP_HOME

# Install all the gems
RUN bundle install

EXPOSE $PORT

ENTRYPOINT rackup -p $PORT -o 0.0.0.0