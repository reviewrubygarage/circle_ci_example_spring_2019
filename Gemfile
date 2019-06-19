# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'rake'
gem 'activerecord-import'
gem 'activerecord'
gem 'pg'
gem 'standalone_migrations'
gem 'aws-sdk-s3'

group :development, :test do
  gem 'dotenv'
  gem 'rspec'
  gem 'pry-byebug'
  gem 'factory_bot'
  gem 'ffaker'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
end
