require_relative '../config/environment.rb'
require 'pry'

class CLI

    #Start the program
    def initialize
        clean_screen
        starting_program
        menu    
    end
 
    #Clear command line window
    def clean_screen
        system "clear"
    end

    #Convert state names to their abbreviations
    def statename(string)
        #case for DoC + capitlizing statenames
        if string.split.count > 2 && string.split[1].upcase == "OF"
            nstring = "District of Columbia"
        else
            nstring = string.split.map(&:capitalize).join(' ')
        end

        #checks for abb or statename
        if State.exists?(:state => nstring) || State.exists?(:abb => string.upcase)
            State.all.each do |state|
                if string.upcase == state.abb || nstring == state.state
                    return state.abb
                end
            end
        else
            puts "Not a valid state."
            statename(@prompt.ask('Please enter a valid state', default: 'CT'))

        end
    end

    def starting_program
    #Welcome sequence
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


        puts "🌲Welcome to PARKR, the premier environmentalist application.🌲"
        @prompt = TTY::Prompt.new

        login

    end

    def login
        num = @prompt.select("Would you like to login or create a new account?") do |menu|
            menu.default 1

            menu.choice 'I would like to login to my existing account', 1
            menu.choice 'I would like to create a new account', 2
        end

        case num
        when 1
            @user_name = @prompt.ask('Please enter your username:', default: ENV['USER'])
            if User.exists?(:name => @user_name)
                @users = User.find_by :name => @user_name
                @prompt.ok("Weclome back, #{@user_name}!")
            else
                puts "Sorry, we don't have that username..."
                login
            end
        when 2 
          #Create user
            @user_name = @prompt.ask('What is your name?', default: ENV['USER'])
            while User.exists?(:name => @user_name)
                @user_name = @prompt.ask('Sorry, that name is already taken!', default: ENV['USER'])
            end
            @users = User.create(:name => @user_name, :state => nil)

            #Greet user
            puts "🤠 Hello, #{@user_name}!"
            @user_state = statename(@prompt.ask('Which state are you from?', default: 'CT'))
            @users.update(:state => @user_state)
        end
    end

    #Main menu
    def menu
        # prompt = TTY::Prompt.new
        
        num = @prompt.select("Please choose from one of the options below:") do |menu|
            menu.default 1

            menu.choice 'See all national parks from a state?', 1
            menu.choice 'See information about a specific park?', 2
            menu.choice 'Update information for user', 3
            menu.choice 'Favorites', 4
            menu.choice 'Reviews', 5
            menu.choice 'Quit Application', 6

        end

        case num
        when 1
            #function for narrow down state
            clean_screen
            find_by_state
        when 2 
            #function for specific park
            clean_screen
            find_a_park
        when 3 
            #function to update state info
            clean_screen
            update_user
        when 4
            #function for favorites
            clean_screen
            user_fav
        when 5
            #function for reviews
            clean_screen
            user_rev
        when 6
            abort
        end

    end
 
    def find_by_state

        choice = @prompt.select("🌲🌱Where would you like to find national parks from?🌵🌾") do |menu|
            menu.choice 'My Home State!'
            menu.choice 'Another State.'
        end
        
        if choice == 'My Home State!'
            list_parks(@users.state)

        else
            state = @prompt.ask('What state?')
            list_parks(statename(state))
        end

    end

    #Find a specific park by name
    def find_a_park
        # prompt = TTY::Prompt.new
        temp = @prompt.ask("⛰ Which park do you want to learn about?🏕 ", required: true)

        if Park.all.find { |park| park.name == temp} == nil
            puts "Please input an actual park"
        else
            list_info(temp, 0)

        end

        menu
    end

    #List all parks from a state
    def list_parks(state)
        parkList = Park.where state: state
            

        if parkList == []
            Catpix::print_image "./img/pikachu.png",
            :limit_x => 1.0,
            :limit_y => 0,
            :center_x => true,
            :center_y => true,
            :bg => "white",
            :bg_fill => true,
            :resolution => "high"
            puts "There are no parks in this state :("
            menu
        else
            pick = @prompt.select("🍃Select a park to find out more information:") do |menu|
                menu.default 1

                parkList.each do |park|
                    menu.choice park.name
                end
                menu.choice '<- Back to main menu'
            end

            if pick == "<- Back to main menu"
                menu
            else
                list_info(pick, 0)
            end
        end
    end

    #List info for a specific park
    def list_info(park, code)
        user_park = Park.find_by name: park

        puts user_park.name, user_park.state, 
        user_park.description, user_park.weather

        favorite(user_park, code)
    end

    #Allow user to update username or home state
    def update_user
        # prompt = TTY::Prompt.new
        num = @prompt.select("What would you like to update?") do |menu|
            menu.choice '🤠 My Username', 1
            menu.choice '⛺️ My Home State', 2
            menu.choice '<-- Back to Menu', 3
        end

        case num
        when 1
            temp = @prompt.ask("🌚 What would you like to update your username to? 🌝")
            @users.update(name: temp)
            @prompt.ok("Username updated to: #{@users.name}")
            menu
        when 2
            temp1 = @prompt.ask("🇺🇸  What would you like to update your home state to? 🇺🇸")
            @users.update(state: statename(temp1))
            @prompt.ok("Home State updated to: #{@users.state}")
            menu
        when 3
            menu
        end
    end


    #Display user favorites
    def user_fav

        if @users.favorites[0] == nil
            
            puts "There are no saved favorites."
            menu
        else
            pick = @prompt.select("💚 Select a favorite to find out more information:") do |menu|
                menu.default 1

                @users.favorites.reload.each do |fav|
                    menu.choice fav.park.name
                end
                menu.choice '<- Back to main menu'
            end

            if pick == "<- Back to main menu"
                menu
            else
                list_info(pick, 1)
            end
        end
    end

    #Function to handle creation of favorites
    def favorite(park, code)

        # If code input is 0, take the favorite sequence
        if code == 0
            fav = @prompt.yes?('Would you like to favorite this park?', default: 'Y')

            if fav
                #through activerecord auto creates connection
                @users.parks << park
                # Favorite.create(user_id: @users.id, park_id: park.id, :review => "")
                @prompt.ok("💚 '#{park.name}' was added to your favorites")
                menu
            else
                menu
            end

        #If code input is 1, take to unfavorite sequence
        else
            thisFav = Favorite.find_by user_id: @users.id, park_id: park.id
            parkName = thisFav.park.name

            review = @prompt.yes?('✨Would you like to write a review for this park?', default: 'Y')

            if review
                userreview = @prompt.ask("Write your review here:")
                while userreview == "" || userreview == nil
                    userreview = @prompt.ask("Please input an actual review:")
                end

                thisFav.update(review: userreview)
                @prompt.ok("You have added a review for '#{parkName}'")
                
            end

            unfav = @prompt.yes?('Would you like to remove this park from your favorites?')

            if unfav
                thisFav.destroy
                @prompt.ok("💔 '#{parkName}' was removed from your favorites")
                user_fav
            else
                user_fav
            end
        end
    end

    #Shows all parks that have reviews
    def user_rev
        revParks = Favorite.all.select do |fav|
            fav.review != nil && fav.review != ""
        end.map do |fav|
            fav.park.name
        end.uniq
     
        # arr.each do |a|
        #     puts "#{a.park.name}: #{a.review}"
        # end

        pick = @prompt.select("⭐️ Select a park to read reviews about:") do |menu|
            menu.default 1

            revParks.each do |park|
                menu.choice park
            end
            menu.choice '<- Back to main menu'
        end

        if pick == "<- Back to main menu"
            menu
        else
            show_revs(pick)
        end
    end

    def show_revs(park)
        search = Park.find_by name: park
        parkRevs = Favorite.where park_id: search.id
        
        parkRevs.each do |fav|
            if fav.review != nil && fav.review != ""
                puts "User: #{fav.user.name}\n"
                puts "#{fav.review}"
            end
        end

        @prompt.keypress("Press space or enter to go back", keys: [:space, :return])
        user_rev
    end

end
