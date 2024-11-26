# Use the official Ruby image as a base
FROM ruby:3.2.0

# Set environment variables
ENV APP_HOME=/usr/src/app \
    BUNDLE_PATH=/usr/local/bundle \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Set working directory
WORKDIR $APP_HOME

# Copy Gemfile and Gemfile.lock for dependency installation
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install --jobs=4 --retry=3

# Copy the rest of the application code
COPY . .

# Expose a port (if necessary, adjust based on your app)
EXPOSE 4567

# Run the application
CMD ["ruby", "assignment.rb"]
