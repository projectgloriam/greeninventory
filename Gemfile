source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use postgresql as the database for Active Record
#gem 'pg', '~> 1.1'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#Active directory authentication gem
gem 'adauth'

#Paperclip: for uploading images to database
#gem "paperclip", "~> 6.0.0"
#Paperclip is deprecated.
gem 'kt-paperclip', '~> 7.0'

#To enable loading of Javascripts after clicking a link to another page
#gem 'jquery-turbolinks'

#To enable active record 'OR' condition
#gem 'activerecord_any_of'

#The system should have an Audit Trail
gem 'public_activity'

#for paginating
gem 'will_paginate', '~> 3.1.0'

#schedule tasks: send email to clients
gem 'rufus-scheduler', '~> 3.8', '>= 3.8.1'

#use thin gem for production deployment
#gem 'thin', '~> 1.6', '>= 1.6.3'

# Use Puma as the app server
gem 'puma', '~> 5.0'

#gem for creating jQuery context-menu
gem 'jquery_context_menu-rails'

#view pdf files, even as thumbnails. (buuut, its useless...for now)
#gem 'pdfjs_viewer-rails'

#For compressing and combining assets(JavaScripts, CSS, Fonts) to reduce load time, hence increasing performance
gem 'sprockets-rails', :require => 'sprockets/railtie'

#Thumbnail preview of images in websites
gem 'link_thumbnailer'

#The gems below are for reading documents
#microsoft word documents
gem 'docx'

#excel files
gem "roo"

#outlook .msg files
gem 'ruby-msg', '~> 1.5', '>= 1.5.2'

#gem for generating thumbnail for pdf
gem "mini_magick"

#gem for merging pdf files into one
gem "combine_pdf"

# for generating app favicons
gem 'rails_real_favicon'

#For resolving SSL3 certificate error
#gem "net_http_ssl_fix"

#Gem for querying active directory users
gem 'net-ldap'

#Gem for parsing and converting to JSON
gem 'json'

#nice animation for page loading
gem 'pace-rails'

# Devise is a flexible authentication solution for Rails based on Warden
gem 'devise'