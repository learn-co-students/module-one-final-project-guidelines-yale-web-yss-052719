require 'bundler/setup'
Bundler.require(:default)

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development')
require_all 'lib'
