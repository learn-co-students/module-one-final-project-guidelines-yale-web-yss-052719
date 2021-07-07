class CreateUsersTable < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|
            t.string :username, unique: true
            t.integer :age
            t.string :favourite_genre
            t.string :favourite_book
        end
    end
end