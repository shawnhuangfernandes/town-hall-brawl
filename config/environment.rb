require 'bundler'
Bundler.require
require_all 'lib'
require 'colorize'
require 'colorized_string'
     

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
ActiveRecord::Base.logger = nil

