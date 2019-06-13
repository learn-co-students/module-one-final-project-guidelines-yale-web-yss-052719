def clear_screen
    system "clear"
end

def welcome_user
    puts "Welcome #{$user.username}!"
end


def help
    puts "Read the options."
end

def quit
    puts "Bye!"
    exit
end

def home_message
    puts "Welcome to Bad Reads!"
end

def main_menu(type="user")
    type == "home" ? home_message : nil
    $user ? welcome_user : nil
    prompt = TTY::Prompt.new
    option = prompt.select("Choose your option:") do |menu|

        if type == "user"
            menu.choice 'Profile', -> do
                profile
            end
            menu.choice 'Search for a book', -> do
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
    prompt = TTY::Prompt.new
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
    prompt = TTY::Prompt.new
    option = prompt.select("Your profile:") do |menu|
        menu.choice 'Show my lists', -> do
            view_lists
            profile
        end
        menu.choice 'Show my books', -> do
            view_books
            profile
        end
        menu.choice 'Edit my lists', -> do
            # view_books
            edit_lists
            main_menu
        end
        menu.choice 'Back to main menu', -> do
            main_menu
        end
    end
end

def edit_lists
    prompt = TTY::Prompt.new
    if (choices = $user.list_names).empty?
        puts "\tYou don't have any lists!"
        return
    end
 
    remove_lists = prompt.multi_select("Remove?:", choices)
    remove_lists.each do |name|
        $user.lists.where(name: name).delete_all
    end
end

def view_lists
    prompt = TTY::Prompt.new
    if (choices = $user.book_hash).empty?
        puts "\tYou don't have any lists!"
        return
    end
    choices["exit"] = nil
    book_titles = prompt.select("Your lists:", choices)

    book_titles == "exit" ? return : nil

    selected_books = {}
    book_titles.each do |title|
        selected_books[title] = {}
        book = $user.books.find_by(book_title: title)
        selected_books[title] = {
            id: book.book_id,
            author: book.author_name,
            genre: [book.genre_1, book.genre_2],
            publication_date: book.publish_date,
            rating: book.book_average_rating,
            url: book.book_fullurl,
            pages: book.pages
        }
    end
    view_books(selected_books)
    # selected_books["exit"] = nil
    # book_info = prompt.select("Your books:", selected_books)
    # book_info == "exit" ? return : nil

    # book_info.each do |key, value|
    #     puts "\t#{key}: #{value}"
    # end
end

def view_books(books)
    prompt = TTY::Prompt.new
    if (choices = $user.books.map {|book| book.hash }).empty?
        puts "\tYou don't have any books!"
        return
    end
    choices << "exit"
 
    book_info = prompt.select("Your books:", choices)
    book_info == "exit" ? return : nil
    book_info.each do |key, value|
        puts "\t#{key}: #{value}"
    end
end

def display_books(books)
    books.each_with_index do |book, i|
        puts "#{book.id}. #{book.book_title}"
    end
end

def search_book
    prompt = TTY::Prompt.new
    input = prompt.select("Find by:") do |menu|
        menu.enum '.'
        menu.choice 'Author Name', -> do
            input = prompt.ask('Enter author name: ', required: true)
            books_found = Book.where(author_name: input)
            if !books_found.empty?
                choices = books_found.map {|book| book.book_title }
                book_titles = prompt.multi_select("We have found the following book(s):", choices)
                selected_books = book_titles.map {|t| Book.all.find_by(book_title: t) }
                store_books(selected_books)
            else
                puts "Sorry, we found no matching results."
            end
        end

        menu.choice 'Book Title', -> do
            input = prompt.ask('Enter book title: ', required: true)
            books_found = Book.where(book_title: input)
            if !books_found.empty?
                choices = books_found.map {|book| book.book_title }
                book_titles = prompt.multi_select("We have found the following book(s):", choices)
                selected_books = book_titles.map {|t| Book.all.find_by(book_title: t) }
                store_books(selected_books)
            else
                puts "Sorry, we found no matching results"
            end

        end

        menu.choice 'Book Genre', -> do
            input = prompt.ask('Enter book genre: ', required: true)
            books_found = Book.where(genre_1: input)
            if !books_found.empty?
                choices = books_found.map {|book| book.book_title }
                book_titles = prompt.multi_select("We have found the following book(s):", choices)
                selected_books = book_titles.map {|t| Book.all.find_by(book_title: t) }
                store_books(selected_books)
            else
                puts "Sorry, we found no matching results"
            end

        end

        menu.choice 'Exit', -> do
            quit
        end
    end
end

def select_book_by_index
    prompt = TTY::Prompt.new
    input = prompt.ask('Please select a book by entering its id.', required: true)
    book = Book.find(input)
    puts "Book information: #{book.book_title}, #{book.author_name}"
    book
end

def store_books(books)
    prompt = TTY::Prompt.new
    # book = select_book_by_index
    input = prompt.select("Would you like to store the book(s) to your list?", required: true) do |menu|
        menu.choice 'Yes', -> do
            if $user == nil
                puts "You are not logged in!"
                login
            end
                
            if $user.lists == []
                input = prompt.ask("You don't have any lists. Please create a new list. Enter the name of your new list: ")
                list = $user.create_list(input)
                books.each do |book| 
                    list.books << book
                    puts "Your book #{book.book_title} is successfully stored in your list #{input}."
                end
            else 
                input = prompt.ask("Please enter a list name. ")
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
                    input = prompt.select("The list you entered doesn't seem to exist. Would you like to create one?") do |menu|
                        menu.choice 'Yes', -> do
                            input = prompt.ask("Enter the name for your list: ", required: true)
                            list = $user.create_list(input)
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
        end
    end
    main_menu
end




