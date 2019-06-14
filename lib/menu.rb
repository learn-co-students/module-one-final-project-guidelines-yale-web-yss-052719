def clear_screen
    system "clear"
end

def welcome_user
    line_break
    puts "Welcome #{$user.username}!"
end

def help
    puts "Read the options."
end

def quit
    puts "Bye!"
    line_break
    exit
end

def home_message
    line_break
    puts "Welcome to Bad Reads!"
end

def line_break
    puts "----------------------"
end

def main_menu(type="user")

    type == "home" ? home_message : nil
    type == "user" ? $user = User.find($user.id) : nil
    $user ? welcome_user : nil
    prompt = TTY::Prompt.new(active_color: :blue)
    option = prompt.select("Main menu:") do |menu|

        if type == "user"
            menu.choice 'Profile', -> do
                profile
            end
            menu.choice 'Search', -> do
                search_book
            end
        else
            menu.choice 'Login', -> do
                login
                main_menu("user")
            end
        end
        
        menu.choice 'Help', -> do
            help
            main_menu(type)
        end

        menu.choice 'Exit', -> do
            quit
        end

    end
end

def run
    main_menu("home")
end

def login
    prompt = TTY::Prompt.new(active_color: :blue)
    input = prompt.ask("What is your username?", required: true)
    if User.all.find_by(username: input)
        $user = User.all.find_by(username: input)
    else
        input = prompt.select("You don't seem to have an account. Would you like to create one?") do |menu|
            menu.choice 'Yes', -> do
                $user = User.create(username: input)
            end
            menu.choice 'No', -> do
                main_menu("home")
            end
        end
    end
end

def profile
    $user = User.find($user.id)
    prompt = TTY::Prompt.new(active_color: :blue)
    option = prompt.select("Profile menu:") do |menu|
        menu.choice 'Show lists', -> do
            view_lists($user.lists)
            profile
        end
        menu.choice 'Show books', -> do
            view_books($user.books.uniq)
            profile
        end
        menu.choice 'Back to main menu', -> do
            main_menu
        end
    end
end

def remove_lists(lists=[])
    prompt = TTY::Prompt.new(active_color: :blue)
    choices = lists.map {|list| list.name }
    prompt.multi_select("Remove lists?:", choices).each do |name|
        $user.lists.where(name: name).delete_all
        puts "Your list #{name} was successfully removed."
    end
end


def view_lists(lists=[])
    prompt = TTY::Prompt.new(active_color: :blue)
    if (choices = lists.map {|list| list.name }).empty?
        puts "\tYou don't have any lists!"
        return
    end
    choices << "Remove lists"
    choices << "Go back"
    result = prompt.select("Your lists:", choices)

    result == "Go back" ? return : nil
    if result == "Remove lists"
        remove_lists(lists)
        return 
    end
    
    selected_books = []
    list = List.all.find_by(name: result)
    list.hash.values[0].each do |title|
        selected_books << $user.books.find_by(book_title: title)
    end

    view_books(selected_books, list) ? nil : view_lists(lists)

end

def view_books(books=[], list=nil)
    prompt = TTY::Prompt.new(active_color: :blue)
    if (choices = books.map {|book| book.hash }).empty?
        puts "\tYou don't have any books!"
        return
    end
    list ? choices << "Remove books" : nil
    choices << "Go back"
    book_info = prompt.select("Your books:", choices)

    if book_info == "Go back"
        return
    elsif book_info == "Remove books"
        list.remove_books_from_list
        return
    else
        book_info.each do |key, value|
            puts "\t#{key}: #{value}"
        end
        view_books(books, list)
    end
end

def check_books_found(books_found)
    prompt = TTY::Prompt.new(active_color: :blue)
    if !books_found.empty?
        choices = {}
        
        books_found.each {|book| choices["#{book.book_title} - #{book.author_name}"] = book.book_title }
        book_titles = prompt.multi_select("We have found the following book(s):", choices, cycle: true)
        selected_books = book_titles.map {|t| Book.all.find_by(book_title: t) }
        binding.pry
        if selected_books != nil
            store_books(selected_books)
        else
            puts "You didn't select any books!"
            main_menu
        end
    else
        puts "Sorry, we found no matching results."
        main_menu
    end
end

def search_book
    prompt = TTY::Prompt.new(active_color: :blue)
    input = prompt.select("Find by:") do |menu|
        # menu.enum '.'
        menu.choice 'Author Name', -> do
            input = prompt.ask('Enter author name: ', required: true)
            books_found = Book.where("author_name like ?", "%#{input}%")
            check_books_found(books_found)
        end

        menu.choice 'Book Title', -> do
            input = prompt.ask('Enter book title: ', required: true, filter: true)
            # books_found = Book.where(book_title: input)
            books_found = Book.where("book_title like ?", "%#{input}%")
            check_books_found(books_found)
        end

        menu.choice 'Book Genre', -> do
            input = prompt.ask('Enter book genre: ', required: true) do |q|
                q.modify :capitalize
            end
            books_found = Book.where(genre_1: input)
            check_books_found(books_found)

        end

        menu.choice 'Exit', -> do
            quit
        end
    end
end


def store_books(books)
    prompt = TTY::Prompt.new(active_color: :blue)
    input = prompt.select("Would you like to store the book(s) to your list?", required: true) do |menu|
        menu.choice 'Yes', -> do
                
            if $user.lists == []
                puts "You don't have any lists. Please create a new list."
                input = prompt.ask("Enter the name of your new list:")
                list = $user.create_list(input)
                puts books
                books.each do |book|
                    list.books << book
                    puts "Your book #{book.book_title} is successfully stored in your list #{input}."
                end
            else
                input = prompt.ask("Please enter a list name:")
                if $user.list_names.include?(input)
                    list = $user.lists.find_by(name: input)
                    books.each do |book|
                        if list.books.include?(book)
                            puts "Your book #{book.book_title} already exists in your list #{input}."
                        else
                            list.books << book
                            puts "Your book #{book.book_title} is successfully stored in your list #{input}."
                        end
                    end
                else
                    prompt.select("The list you entered doesn't seem to exist.\nWould you like to create one?") do |menu|
                        menu.choice 'Yes', -> do
                            # input = prompt.ask("Enter the name for your list: ", required: true)
                            list = $user.create_list(input)
                            binding.pry
                            books.each do |book| 
                                list.books << book
                                puts "Your book #{book.book_title} is successfully stored in your list #{input}."
                            end
                        end
                        menu.choice 'No', -> do 

                        end
                    end
                end
            end
        end
        menu.choice 'No', -> do
            return
        end
    end
    main_menu
end




