require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development')
require_all 'lib'
require_all 'app'

ActiveRecord::Base.logger = nil