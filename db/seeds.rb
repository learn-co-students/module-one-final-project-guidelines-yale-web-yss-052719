#add sample instances of classes
# require 'open-uri'
# require 'json'
# require 'httparty'
# require 'pry'
require 'csv'
require './config/environment.rb'
Park.destroy_all
State.destroy_all

html = HTTParty.get("https://developer.nps.gov/api/v1/parks?fields=operatingHours&fields=entranceFees&fields=standardHours&fields=addresses&api_key=ahCwYCRHHdChX6whIHBu794OfHMQPTzIrb5e3aUb", {headers:{"Accept" => "application/json"}})
json = JSON.parse(html.body)

# binding.pry
json["data"].each do |park|
	Park.create(name: park["name"], 
		state: park["states"], 
		description: park["description"], 
		operating_hours: park["standardHours"], 
		entrance_fee: park["entranceFees"], 
		weather: park["weatherInfo"])
end

path = File.join(File.dirname(__FILE__), "states.csv")
meep = CSV.read(path)

meep[1..51].each do |row|
	State.create(abb: row[1], state: row[0])
end

binding.pry

