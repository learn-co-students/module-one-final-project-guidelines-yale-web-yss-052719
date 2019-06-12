require_relative '../config/environment.rb'
require 'pry'

class CLI

    def initialize
        clean_screen
        starting_program
        menu 


    end

 
    def clean_screen
        system "clear"
    end

    def starting_program
        banner = "
        ██████╗  █████╗ ██████╗ ██╗  ██╗██████╗ 
        ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔══██╗
        ██████╔╝███████║██████╔╝█████╔╝ ██████╔╝
        ██╔═══╝ ██╔══██║██╔══██╗██╔═██╗ ██╔══██╗
        ██║     ██║  ██║██║  ██║██║  ██╗██║  ██║
        ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝
"
    print banner
        Catpix::print_image "./img/npark1.jpg",
            :limit_x => 1.0,
            :limit_y => 0,
            :center_x => true,
            :center_y => true,
            :bg => "white",
            :bg_fill => true,
            :resolution => "high"


        puts "Welcome to Parkr. The premier environmentalism application <3"
        @prompt = TTY::Prompt.new

        #Create user
        @user_name = @prompt.ask('What is your name?', default: ENV['USER'])
        @users = User.create(:name => @user_name, :state => nil)
        @users.save

        #Greet user
        puts "Hello, #{@user_name}!"
        @user_state = statename(@prompt.ask('Which state are you from?', default: 'CT'))
        @users.update(:state => @user_state)
        @users.save
    end

    
    #Main menu
    def menu
        # prompt = TTY::Prompt.new
        num = @prompt.select("Please choose from one of the options below:") do |menu|
            menu.default 1

            menu.choice 'See all national parks from a state?', 1
            menu.choice 'See information about a specific park?', 2
            menu.choice 'Update information for user', 3
            menu.choice "See saved favorites", 4
            menu.choice 'Quit Application', 5

        end

        case num
        when 1
            #function for narrow down state
            clean_screen
            findbystate
        when 2 
            #function for specific park
            clean_screen
            findapark
        when 3 
            #function to update state info
            clean_screen
            updateuser
        when 4
            #function for favorites
            clean_screen
            user_fav
        when 5
            abort
        end

    end

    def statename(string)
        State.all.each do |state|
            if string == state.abb || string == state.state
                return state.abb
            end
        end
    end

    def listInfo(park)
        user_park = Park.find_by name: park

        puts user_park.name, user_park.state, 
        user_park.description, user_park.operating_hours, 
        user_park.entrance_fee, user_park.weather

        favorite(user_park)
    end

    def listParks(state)
        parkList = Park.where state: state
            

        if parkList == []
            puts "There are no parks in this state :("
            menu
        else
            pick = @prompt.select("Select a park to find out more information:") do |menu|
                menu.default 1

                parkList.each do |park|
                    menu.choice park.name
                end
                menu.choice '<- Back to main menu'
            end

            if pick == "<- Back to main menu"
                menu
            else
                listInfo(pick)
            end
        end
    end

    def user_fav
        if @users.favorites[0] == nil
            
            puts "There are no saved favorites."
            menu
        else
            @users.favorites.map do |fav|
                puts "#{fav.park.name}"
            end
            menu
        end
    end

    #Function to handle creation of favorites
    def favorite(park)
        prompt = TTY::Prompt.new
        fav = prompt.yes?('Would you like to favorite this park?')

        if fav
            Favorite.create(user_id: @users.id, park_id: park.id, :review => "")
            prompt.ok("'#{park.name}' was added to your favorites")
            menu
        else
            menu
        end
    end


    def findbystate

        choice = @prompt.select("Where would you like to find national parks from?") do |menu|
            menu.choice 'My Home State!'
            menu.choice 'Another State.'
        end
        

        if choice == 'My Home State!'
            listParks(@users.state)

        else
            state = @prompt.ask('What state?')
            listParks(statename(state))
        end

    end



    def findapark
        # prompt = TTY::Prompt.new
        temp = @prompt.ask("Which park do you want to learn about?", required: true)

        if Park.all.find { |park| park.name == temp} == nil
            puts "Please input an actual park"
        else
            listInfo(temp)
        end

        menu
    end




    def updateuser
        # prompt = TTY::Prompt.new
        num = @prompt.select("What would you like to update?") do |menu|
            menu.choice 'My username', 1
            menu.choice 'My Home State', 2
        end

        case num
        when 1
            temp = @prompt.ask("What would you like to update your username to?")
            @users.update(name: temp)
            @users.save
            puts "Username updated to: #{@users.name}"
            menu
        when 2
            temp1 = @prompt.ask("What would you like to update your home state to?")
            @users.update(name: temp1)
            @users.save
            puts "HomeState updated to: #{@users.state}"
            menu
        end
    end

end
