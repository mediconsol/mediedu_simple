#!/usr/bin/env bash
# exit on error
set -o errexit

echo "=== Starting Render build ==="
echo "Ruby version: $(ruby -v)"
echo "Bundler version: $(bundler -v)"

echo "=== Installing dependencies ==="
bundle install

echo "=== Precompiling assets ==="
bundle exec rails assets:precompile
bundle exec rails assets:clean

echo "=== Database setup ==="
bundle exec rails db:create db:migrate db:seed

echo "=== Build completed successfully ==="