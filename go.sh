set -ex

docker run \
  --rm \
  -v $(pwd):/opt/app \
  -w /opt/app \
  ruby:2.5.0-alpine \
  /bin/ash -c "
    apk add --update postgresql-dev alpine-sdk \
      && gem install rails -v 5.1.3 \
      && rails new . -d postgresql --skip-git"

################################################################################

cat <<EOT > ./Dockerfile

FROM ruby:2.5.0-alpine

RUN apk add --update postgresql-dev alpine-sdk nodejs tzdata

COPY Gemfile* /opt/bundle/
WORKDIR /opt/bundle

RUN bundle update && bundle install

COPY . /opt/app

WORKDIR /opt/app
ENTRYPOINT ["/bin/ash", "-c"]

EOT

################################################################################

cat <<EOT > ./config/database.yml

default: &default
adapter: postgresql
encoding: unicode
pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
<<: *default
url: <%= ENV['DATABASE_URL'] %>

test:
<<: *default
url: <%= ENV['TEST_DATABASE_URL'] %>

production:
<<: *default
url: <%= ENV['DATABASE_URL'] %>

EOT

################################################################################

cat <<EOT > ./wait-for-postgres.rb

#!/usr/local/bin/ruby -w

require "pg"
require "uri"

if ENV['DATABASE_URL']
  url = URI.parse(ENV['DATABASE_URL'])
  puts "Waiting for database with URL=#{url}..."
  30.times do
    begin
      PG.connect(url.hostname, url.port, nil, nil, url.path[1..-1], url.user, url.password)
      puts "Success!"
      exit 0
    rescue => e
      print "."
    end
    sleep 1
  end

  exit 1
else
  STDERR.puts "ENV['DATABASE_URL'] is not set; skipping"
end

EOT

################################################################################

cat <<EOT > ./docker-compose.yml

version: "3"
services:
  app:
    container_name: app
    build: .
    ports:
      - "3000:3000"
    environment:
      - RAILS_ENV=development
      - DATABASE_URL=postgresql://tattersail:whiskeyjack@appdb:5432/app_development
      - TEST_DATABASE_URL=postgresql://tattersail:whiskeyjack@appdb:5432/app_test
    depends_on:
      - appdb
    command:
      - "ruby ./wait-for-postgres.rb && rails db:migrate && rails tmp:clear && rails server -p 3000 -b 0.0.0.0"
    volumes:
      - .:/opt/app
  appdb:
    container_name: appdb
    image: postgres:9.6.5-alpine
    environment:
      - POSTGRES_USER=tattersail
      - POSTGRES_PASSWORD=whiskeyjack
      - POSTGRES_DB=app_development
EOT

################################################################################

docker-compose run --rm app "ruby ./wait-for-postgres.rb && rails generate scaffold post title body:text published:boolean"

################################################################################

docker-compose run --rm app "ruby ./wait-for-postgres.rb && rails db:migrate RAILS_ENV=test"

docker-compose run --rm app "ruby ./wait-for-postgres.rb && rails test"
