#source 'http://rubygems.org'
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'http://ruby.taobao.org/'

gem 'rails', '3.2.8'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier'#, '>= 1.0.3'
  if HOST_OS =~ /linux/i
    gem 'therubyracer', '>= 0.8.2'
  end
end


#for Tuan
#gem 'libxml-ruby'
#for Tuan
gem 'geocoder'
gem "devise", ">= 2.1.0.rc"
#gem 'paperclip'
gem 'mime-types', :require => 'mime/types'
gem "will_paginate", ">= 3.0.3"
gem 'jquery-rails'

gem 'acts-as-taggable-on'#, '~>2.1.0'
gem 'dynamic_sitemaps'

group :development do
  #gem "nifty-generators"
  gem "rspec-rails", "~> 2.0"
  gem 'guard-rspec'#, '0.5.5'
  gem 'debugger'
end

case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
    gem 'guard-pow', :group => :development
    gem 'unicorn'
  when /linux/i
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
    gem 'unicorn'
	group :test do
	  gem "rspec-rails", "~> 2.0"
	  gem 'capybara'#, '1.1.2'
	  gem 'guard-spork'#, '0.3.2'
	  gem 'spork'#, '0.9.0'
	end
  when /mswin|windows/i
	gem 'rb-fchange', :group => :development
	gem 'win32console', :group => :development
	gem 'rb-notifu', :group => :development
end

#gem 'redis-store','~> 1.0.0.1'
#
#

#dev
gem 'inherited_resources'
gem 'simple_form'
gem 'nested_form'
#gem 'simple_nested_form'
gem 'ajax_nested_form'

gem 'quiet_assets', :group => :development
#gem 'omniauth-oauth2'
#gem 'omniauth-jiepang',:git => 'git://github.com/transist/omniauth-jiepang.git'
gem 'guid'

gem 'meta-tags', :require => 'meta_tags'
gem 'rails_kindeditor', '~> 0.3.0'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'paranoia'
gem 'carrierwave', '~>0.7'
gem 'mini_magick','~>3.4'
