require_relative '../config/environment.rb'

class CLI

    def initialize
        starting_program
        userinput
        options
        
        
    end

 
    def starting_program
        puts "Welcome user. Please enter your name here:"
        prompt = TTY::Prompt.new

        @user_name = prompt.ask('What is your name?', default: ENV['USER'])
        # user = User.new(:name => @user_name)
        # user.save
        puts "Hello, #{@user_name}!"
        @user_state = prompt.ask('Which state are you from?', default: ENV['USER'])
        # user.(:state => @user_state)
        # user.save
    end

    


    # def printgenericparks
    #     puts "Here are all the park selections below"
    #     Park.all
    # end

    def options
        if prompt.yes?('Do you want a more specific search?').UPPERCASE == y.UPPERCASE
            spec_list = []
            Park.find_each do |park|
                if park.state == @user_state
                    spec_list << park.state
                end
            end
        else
            puts "do you want to find a specific park?"
            if gets.chomp == true
                findbyname
                puts "do you want to favorite it?"
                if gets.chomp == true
                    user_fav
                end
            end
        end

            puts "do you want to update preferences?"
            if gets.chomp == true
                #needs a update to userpreferences
            end
        
    end


    def preferences
        puts "Will now take in preferences"
        puts "Please input a desired state code:"
        @state_code = gets.chomp # temporary
        puts "Lower than certain fee"
        @entrance_fee = gets.chomp #temp
        puts "Desired weather conditions"
        @weather = gets.chomp
    end

    def findbyname
            puts "Which park do you want?"
            @user_park_temp = gets.chomp 
    end

    def user_fav 
        if gets.chomp == true
            Favorite.new(@user_name, @user_park_temp)
        end
    end

    def findbystate
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


end
