class User < ActiveRecord::Base
    has_many :lists
    has_many :books, through: :lists
    
    def create_list(name:)
        list = List.create
        list.name = name
        list.user_id = self.id
    end
    
end