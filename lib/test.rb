require './config/environment.rb'

def test
	parks = ["Park1", "Park2", "Park3", "Park4"]
	prompt = TTY::Prompt.new
	num = prompt.select("Please choose from one of the options below:") do |menu|
	    menu.default 1

	    parks.each do |park|
	    	menu.choice park
	    end
	end
end

test
