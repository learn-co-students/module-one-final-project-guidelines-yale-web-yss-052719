def clear_screen
    system "clear"
end

def start
    clear_screen
    prompt = TTY::Prompt.new
    option = prompt.select("Choose your option:") do |menu|
        menu.choice 'Login', -> do
            login_user
        end
        
        menu.choice 'Search a book', -> do
            search_book
        end
    end
end

def login_user
    prompt = TTY::Prompt.new
    input = prompt.ask('What is your username?', required: true)
    clear_screen
    if User.all.find_by(username: input)
        user = User.all.find_by(username: input)
    else
        option = prompt.select("Would you like to create an account?") do |menu|
            menu.choice 'Yes', -> do
                User.create(username: input)
            end
            menu.choice 'No', -> do
                quit
            end
        end
    end
end

def quit
    puts "Bye!"
    exit
end