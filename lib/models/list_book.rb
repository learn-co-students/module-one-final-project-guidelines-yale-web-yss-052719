class ListBook < ActiveRecord::Base
    belongs_to :list
    belongs_to :book
end