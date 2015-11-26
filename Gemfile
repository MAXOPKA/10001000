source "https://rubygems.org"

ruby '2.2.2'

gem 'rack'
gem 'unicorn'
gem 'sinatra'
gem 'slim'

group :development, :test do
  gem 'sinatra-reloader'
  gem 'rspec'
  gem 'factory_girl'
  gem 'faker'
  gem 'capybara'
  gem 'cucumber'
end

group :deployment do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-secrets-yml', '~> 1.0.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'
end
