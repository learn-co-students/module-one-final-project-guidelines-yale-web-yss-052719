class List < ActiveRecord::Base
    belongs_to :user
    has_many :list_books
    has_many :books, through: :list_books

    # def add_book_to_list(book)
    #     # list_book = ListBook.new
    #     # list_book.book = book
    #     # list_book.list = List.find_by(name: "#{listname}")
    #     # list_book.save
    # end

    def book_hash
       
    end

end