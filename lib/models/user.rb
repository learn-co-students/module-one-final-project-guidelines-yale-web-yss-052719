class User < ActiveRecord::Base
    has_many :lists
    has_many :books, through: :lists
    
    def create_list(name)
        # list = List.new
        # list.name = name
        # list.user_id = self.id
        # list.save
        # list = List.create(name: name)
        # self.lists << list
        # list
    end

    

    def assign_favourite_genre

    end

    def assign_favourite_book
    end

    def list_names
        self.lists.map {|list| list.name}
    end

    def book_hash
        hash = {}
        self.lists.each do |list|
            hash[list.name] = list.books.map {|book| book.book_title }
        end
        hash
    end

    def delete_my_lists
        self.lists.destroy_all
    end

    def create_list(name)
        list = List.create(name: name)
        self.lists << list
        list
    end
    
end