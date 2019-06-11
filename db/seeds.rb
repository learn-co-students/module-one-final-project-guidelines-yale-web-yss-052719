#add sample instances of classes
# require 'open-uri'
# require 'json'
# require 'httparty'
# require 'pry'
require_relative '../config/environment.rb'

html = HTTParty.get("https://developer.nps.gov/api/v1/parks?fields=operatingHours&fields=entranceFees&fields=standardHours&fields=addresses&api_key=ahCwYCRHHdChX6whIHBu794OfHMQPTzIrb5e3aUb", {headers:{"Accept" => "application/json"}})
json = JSON.parse(html.body)

json["data"].each do |park|
	Park.create(name: json["data"][park]["name"], 
		state: json["data"][park]["states"], 
		description: json["data"][park]["description"], 
		operating_hours: json["data"][park]["standardHours"], 
		entrance_fee: json["data"][park]["entranceFees"], 
		weather: json["data"][park]["weatherInfo"])
end

binding.pry
