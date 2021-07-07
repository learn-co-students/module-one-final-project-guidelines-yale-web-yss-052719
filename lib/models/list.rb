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

    def hash
        {
            self.name => self.books.map {|book| book.book_title }
        }
    end

    def remove_books_from_list
        prompt = TTY::Prompt.new
        choices = self.books.map { |book| book.book_title }
        prompt.multi_select("Remove books?:", choices).each do |name|
            self.books.where(book_title: name).delete_all
            puts "Your book #{name} was successfully removed."
        end
    end
end