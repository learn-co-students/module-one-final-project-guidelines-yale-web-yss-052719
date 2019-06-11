require_relative '../config/environment.rb'
def findbystate
	@user_state = "TX"
    prompt = TTY::Prompt.new
    choice = prompt.select("Where would you like to find national parks from?") do |menu|
  		menu.choice 'My Home State!'
  		menu.choice 'Another State'
	end
	if choice == 'My Home State!'
		Park.find_by state: @user_state
	else
		state = prompt.ask('What state?')
		Park.find_by state: state
	end

end

findbystate