#add sample instances of classes
require 'open-uri'
require 'json'
require 'httparty'
require 'pry'


html = HTTParty.get("https://developer.nps.gov/api/v1/parks?&api_key=ahCwYCRHHdChX6whIHBu794OfHMQPTzIrb5e3aUb", {headers:{"Accept" => "application/json"}})
json_html = JSON.parse(html.body)

binding.pry