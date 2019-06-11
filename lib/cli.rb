require_relative '../config/environment.rb'

class CLI

    def initialize
        starting_program
        userinput
        preferences

    end

 
    def starting_program
        puts "Welcome user. Please enter your name here:"
        @user_name = gets.chomp
    end

    def userinput
        puts "Hello, #{@user_name}!"
    end

    # def printgenericparks
    #     puts "Here are all the park selections below"
    #     Park.all
    # end

    def preferences
        puts "Will now take in preferences"
        puts "Please input a desired state code:"
        @state_code = gets.chomp # temporary
        puts "Desired day of the week"
        @operating_hours = gets.chomp # temporary
        puts "Lower than certain fee"
        @entrance_fee = gets.chomp #temp
        puts "Desired weather conditions"
        @weather = gets.chomp
    end

    def user_fav 
        if gets.chomp == true
            
        end
    end


end
