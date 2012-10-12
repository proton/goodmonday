source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'mongoid', '~> 3.0.0'
gem 'moped', '~> 1.3.0', :git => 'git://github.com/mongoid/moped.git' #remove this string after moped 1.3.0 stabilization

gem 'symbolize', :require => 'symbolize/mongoid'

gem 'haml'
gem 'haml-rails'

gem 'mongoid_auto_increment'
#gem 'mongoid_activity'
gem 'mongoid_denormalize'
#gem 'mongoid_slug'
gem 'mongoid_slug', :git => 'git://github.com/digitalplaywright/mongoid-slug.git'
gem 'mongoid-eager-loading'

gem 'mongoid_money_field'

gem 'simple_form'
gem 'bootstrap-sass'

#gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'carrierwave-mongoid', :git => 'git://github.com/jnicklas/carrierwave-mongoid.git', :branch => "mongoid-3.0"
gem 'mini_magick'
gem 'fog', "~> 1.3.1"

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'compass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
	gem 'execjs'
	gem 'therubyracer'
  gem 'uglifier'
  gem 'jquery-fileupload-rails'
end

gem 'coffee-rails', '~> 3.2.1'
gem 'jquery-rails'
gem 'gon'

gem 'devise'

gem 'russian'
gem 'ru_propisju'

gem 'imperavi-rails', '>= 0.0.12.beta'
gem 'chosen-rails'
gem 'bootstrap-datepicker-rails'

gem 'detect_timezone_rails'

gem 'crummy', :git => 'git://github.com/proton/crummy.git' #waiting for fixing html_list format

gem 'agent_orange'

gem 'rb-inotify' #for sass

group :development, :test do
	gem 'rnotify'
	gem 'ruby_parser'
  gem 'capistrano'
  gem 'rvm-capistrano'
	gem 'thin'
end

group :production do
	gem 'unicorn'
end

#for task achievements:confirm
gem 'hpricot', :require => false
gem 'mechanize', :require => false
gem 'mechanize', :require => false
gem 'php_serialize', :require => false

gem 'cucumber' #хз зачем, но без него не стартует ( O_o )