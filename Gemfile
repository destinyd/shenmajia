require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
#source 'https://rubygems.org'
source 'http://ruby.taobao.org/'

gem 'rails', '3.2.16'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier'#, '>= 1.0.3'
  if HOST_OS =~ /linux/i
    gem 'therubyracer', '>= 0.8.2'
  end
  gem "yui-compressor"
end


gem 'geocoder'#, :github => "alexreisner/geocoder"
gem "bootstrap-sass", ">= 2.3.0.0"
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 0.1.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'

#gem 'acts-as-taggable-on'#, '~>2.1.0'
gem 'mongoid_taggable_on'
# sitemap
gem 'sitemap_generator'

group :development do
  #gem "nifty-generators"
  gem "rspec-rails", "~> 2.0"
  gem 'guard-rspec'#, '0.5.5'
  #gem 'debugger', git: 'git://github.com/cldwalker/debugger.git'
end

case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
    gem 'guard-pow', :group => :development
    gem 'thin'
  when /linux/i
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
    gem 'thin'
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

gem 'quiet_assets', :group => :development
gem "devise"#, ">= 2.1.0.rc"
gem 'oauth2', :group => [:development,:test]
gem 'doorkeeper', '~> 0.6.2'
#gem 'omniauth-oauth2'
#gem 'omniauth-jiepang',:git => 'git://github.com/transist/omniauth-jiepang.git'
gem 'guid'

gem 'meta-tags', :require => 'meta_tags',git: 'git://github.com/destinyd/meta-tags.git'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'mini_magick','~>3.4'
gem 'routes_for_page'
gem 'cells'
gem 'rspec-cells'
gem "mongoid", ">= 3.1.2"
gem "mongoid-rspec", ">= 1.7.0", :group => :test
gem "crummy", "~> 1.7.1"
gem "figaro", ">= 0.6.3"
gem "better_errors", ">= 0.7.2", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development#, :platforms => [:mri_19, :rbx]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
#nested form
#gem "cocoon"

#gem 'client_side_validations'
#gem 'client_side_validations-simple_form'

gem 'rest-client'
gem 'sunspot_mongoid2'
gem 'sunspot_rails'
gem 'sunspot_solr'

# for ruby 2.2.0 +
gem "test-unit"
