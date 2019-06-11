class User < ActiveRecord::Base
    has_many :lists
    has_many :books, through: :lists
    
    def create_list(name)
        list = List.new
        list.name = name
        list.user_id = self.id
        list.save
    end

    def assign_favourite_genre

    end

    def assign_favourite_book
    end
end