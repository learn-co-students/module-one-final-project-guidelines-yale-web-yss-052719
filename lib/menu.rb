def clear_screen
    system "clear"
end

def create_list(name)
    list = List.new
    list.name = name
    list.user_id = $user.id
    list.save
end

def start
    clear_screen
    prompt = TTY::Prompt.new
    option = prompt.select("Choose your option:") do |menu|
        menu.choice 'Login', -> do
            login_user
        end
        
        menu.choice 'Search for a book', -> do
            search_book
        end

        menu.choice 'Help', -> do
            help
        end
    end
end

def quit
    puts "Bye!"
    exit
end

def help
    puts 'Use "Login" to login to your account. Use "Search for a book" to search for a book.'
    prompt = TTY::Prompt.new
    option = prompt.select("Choose your option:") do |menu|
        menu.choice 'Login',  -> do
            login_user
        end
        
        menu.choice 'Search for a book', -> do
            search_book
        end
    end
end

def login_user
    prompt = TTY::Prompt.new
    input = prompt.ask('What is your username?', required: true)
    clear_screen
    if User.all.find_by(username: input)
        $user = User.all.find_by(username: input)
        clear_screen
        profile
    else
        option = prompt.select("You don't seem to have an account. Would you like to create one?") do |menu|
            menu.choice 'Yes', -> do
                $user = User.create(username: input)
                profile
            end
            menu.choice 'No', -> do
                quit
            end
        end
    end
end


def profile
    puts "***** My profile *****
    username: #{$user.username}
    favourite_genre: #{$user.favourite_genre}
    favourite_book: #{$user.favourite_book}
    list(s): #{$user.lists.map {|list| list.name}}
    "
end

def list(books)
    books.each_with_index do |book, i|
        puts "#{i+1}. #{book.book_title}"
    end
end

def search_book
    prompt = TTY::Prompt.new
    input = prompt.select("Find by:") do |menu|
        menu.enum '.'
        menu.choice 'Author name', -> do
            input = prompt.ask('Enter author name: ', required: true)
            if Book.all.map {|book| book.author_name}.include?("#{input}")
                clear_screen
                books = []
                books << Book.all.find_by(author_name: "#{input}")
                puts "We have found the following book(s):"
                list(books)
                store_book
            else
                puts "Sorry, we found no matching results"
                no_login_next_step
            end
            # find_by(author_name)
        end

        menu.choice 'Author genre', -> do
        end

        menu.choice 'Book Rating', -> do
        end

        menu.choice 'Book Title', -> do
        end

        menu.choice 'Genre', -> do
        end

        menu.choice 'Publication Date', -> do
        end

        menu.choice 'Exit', -> do
            quit
        end
    end
end

# def find_by(column_name)
#     if Book.all.map {|book| book.column_name}.include?("#{input}")
#         clear_screen
#         books = []
#         books << Book.all.find_by(column_name: "#{input}")
#         puts "We have found the following book(s):"
#         list(books)
#         store_book
#     else
#         puts "Sorry, we found no matching results"
#         no_login_next_step
#     end
# end

def select_book
    prompt = TTY::Prompt.new
    input = prompt.ask('Please select a book by entering the book name.', required: true)
    $book = Book.all.find_by(book_title: "#{input}")
    puts "Book information:"
    $book
end

def store_book
    prompt = TTY::Prompt.new
    select_book
    input = prompt.select("Would you like to store the book to your your list?", required: true) do |menu|
        menu.choice 'Yes', -> do
            login_user
            if $user.lists == []
                input = prompt.ask("You don't have any lists. Please create a new list. Enter the name of your new list: ") 
                create_list("#{input}")
                add_book_to_list($book, "#{input}")
            else input = prompt.ask("Please enter a list name. ")
                if $user.lists_names.include?("#{input}")
                    add_book_to_list($book, "#{input}")
                    puts "Your book #{$book} is successfully stored in your list #{input}."
                else
                    puts input = prompt.select("The list you entered doesn't seem to exist. Would you like to create one?") do |menu|
                        menu.choice 'Yes', -> do
                            input = prompt.ask("Enter the name for your list: ", required: true)
                            $user.create_list(input)
                            add_book_to_list($book, "#{input}")
                            puts "Your book is successfully stored in your list #{input}."
                        end
                        menu.choice 'No', -> do 
                            next_step
                        end
                    end
                end
            end
        end
        menu.choice 'No', -> do
            no_login_next_step
        end
    end
end

def no_login_next_step
    prompt = TTY::Prompt.new
    input = prompt.select("What would you like to do next?", required: true) do |menu|
        menu.choice 'Search for a book', -> do
            search_book
        end
        menu.choice 'Exit', -> do
            exit
        end
    end
end

def next_step
    prompt = TTY::Prompt.new
    input = prompt.select("What would you like to do next?", required: true) do |menu|
        menu.choice 'Create a list', -> do
            input = prompt.ask("Enter the name for your list: ", required: true)
            $user.create_list(input)
            clear_screen
            puts "Your list has been created."
            next_step
        end

        menu.choice 'Search for a book', -> do
            search_book
        end

        menu.choice 'Exit', -> do
            exit
        end
    end
end

def add_book_to_list(bookname, listname)
    list_book = ListBook.new
    list_book.book = $book
    list_book.list = List.find_by(name: "#{listname}")
    list_book.save
end

