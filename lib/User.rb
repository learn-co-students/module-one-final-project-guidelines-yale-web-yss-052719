class User < ActiveRecord::Base
    has_many :favorites
    has_many :parks, through: :favorites

end