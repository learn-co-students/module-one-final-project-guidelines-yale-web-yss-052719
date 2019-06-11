require_relative '../config/environment'
require 'pry'

start
binding.pry
User.destroy_all
puts "HELLO WORLD"
