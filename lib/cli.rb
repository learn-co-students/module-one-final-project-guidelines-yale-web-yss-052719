require_relative '../config/environment.rb'

class CLI

    def initialize

        starting_program
        menu
        
    end

 
    def starting_program
        banner = "
.___________..______       _______  _______     _______.
|           ||   _  \     |   ____||   ____|   /       |
`---|  |----`|  |_)  |    |  |__   |  |__     |   (----`
    |  |     |      /     |   __|  |   __|     \   \    
    |  |     |  |\  \----.|  |____ |  |____.----)   |   
    |__|     | _| `._____||_______||_______|_______/    
                                                        
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


        
        puts "Welcome user. Please enter your name here:"
        prompt = TTY::Prompt.new

        @user_name = prompt.ask('What is your name?', default: ENV['USER'])
        @users = User.create(:name => @user_name, :state => nil)
        @users.save
        puts "Hello, #{@user_name}!"
        @user_state = prompt.ask('Which state are you from?', default: 'CT')
        @users.update(:state => @user_state)
        @users.save
    end

    # Menu
    # 1, Specific state
    #     your state or another state
    # 2. specific park
    #     give us a park name
    # 3. Update state
    # 4. Quit


    def menu
        prompt = TTY::Prompt.new
        num = prompt.select("Please choose from one of the options below:") do |menu|
            menu.default 4

            menu.choice 'See all national parks from a state?', 1
            menu.choice 'See information about a specific park?', 2
            menu.choice 'Update state information for user', 3
            menu.choice 'Quit Application', 4
        end

        case num
        when 1
            #function for narrow down state
            findbystate
        when 2 
            #function for specific park
            findapark
        when 3 
            #function to update state info
            updateuser
        when 4
            abort
        end

    end

    def updateuser
        prompt = TTY::Prompt.new
        num = prompt.select("What would you like to update?") do |menu|
            menu.choice 'My username', 1
            menu.choice 'My Home State', 2
        end

        case num
        when 1
            temp = prompt.ask("What would you like to update your username to?")
            @users.update(name: temp)
            @users.save
            puts "Username updated to: #{@users.name}"
            menu
        when 2
            temp1 = prompt.ask("What would you like to update your home state to?")
            @users.update(name: temp1)
            @users.save
            puts "HomeState updated to: #{@users.state}"
            menu
        end
    end


    def findbystate
        prompt = TTY::Prompt.new
        choice = prompt.select("Where would you like to find national parks from?") do |menu|
            menu.choice 'My Home State!'
            menu.choice 'Another State'
        end
        
        if choice == 'My Home State!'
            my_park = Park.where state: @user_state
            my_park.each do |park|
                puts park.name
            end
            menu

        else
            state = prompt.ask('What state?')
            not_park = Park.where state: state
            not_park.each do |park|
                puts park.name
            end
            menu

        end

    end


    def findapark
        prompt = TTY::Prompt.new
        temp = prompt.ask("Which park do you want to learn about?", required: true)
        user_park = Park.find_by name: temp
        #format prettier
        puts user_park.name, user_park.state, user_park.description, user_park.operating_hours, user_park.entrance_fee, user_park.weather
        menu
    end


end






# def options
#     if prompt.yes?('Do you want a more specific search?').UPPERCASE == Y
#         spec_list = []
#         Park.find_each do |park|
#             if park.state == @user_state
#                 spec_list << park.name
#             end
#         end
#         spec_list
        
#     else
#         puts "do you want to find a specific park?"
#         if gets.chomp == true
#             findbyname
#             puts "do you want to favorite it?"
#             if gets.chomp == true
#                 user_fav
#             end
#         end
#     end

#         puts "do you want to update preferences?"
#         if gets.chomp == true
#             #needs a update to userpreferences
#         end
    
# end


# def preferences
#     puts "Will now take in preferences"
#     puts "Please input a desired state code:"
#     @state_code = gets.chomp # temporary
#     puts "Lower than certain fee"
#     @entrance_fee = gets.chomp #temp
#     puts "Desired weather conditions"
#     @weather = gets.chomp
# end

# def findbyname
#         puts "Which park do you want?"
#         @user_park_temp = gets.chomp 
# end

# def user_fav 
#     if gets.chomp == true
#         Favorite.new(@user_name, @user_park_temp)
#     end
# end


    # def printgenericparks
    #     puts "Here are all the park selections below"
    #     Park.all
    # end
