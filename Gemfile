source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# for attachement
gem 'carrierwave', '~> 1.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Added by Minh

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'sqlite3' # Use sqlite3 as the database for Active Record
end

gem "capybara",                 :group => [:test]
gem "factory_girl_rails",       :group => [:test]
gem "bootstrap-sass"            # formating
gem "bootstrap-will_paginate" # formating
gem 'will_paginate'           # formating
gem "font-awesome-rails"        # formating
gem "simple_form"             # formating
gem 'devise'                    # Authorization
gem 'devise_security_extension', git: 'https://github.com/phatworx/devise_security_extension.git' # Extra security for devise
gem 'rails_email_validator'     # email validator for devise
gem 'stripe'                  # credit card handing
gem 'redcarpet'               # markup html
gem 'pundit'                  # Access control
gem 'figaro'                  # environment variables hidden
gem 'faker'                   # test data
group :production do
  gem 'pg'
  gem 'rails_12factor'
end
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
