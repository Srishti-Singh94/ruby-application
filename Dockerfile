FROM ruby:2.7.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y curl gnupg2 build-essential libpq-dev postgresql-client

# Install Node.js 16
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && apt-get install -y yarn

# Create and set working directory
RUN mkdir /sample_rails_application
WORKDIR /sample_rails_application

# Copy Gem and Yarn dependencies
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v '2.2.15'
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

# Copy the full app
COPY . .

# Expose the Rails port
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
