class CreateListBooksTable < ActiveRecord::Migration[5.2]
    def change
       create_table :list_books do |t|
        t.integer :book_id
        t.integer :list_id
       end
    end
end