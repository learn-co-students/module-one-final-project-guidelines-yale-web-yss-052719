class CreateListsTable < ActiveRecord::Migration[5.2]
    def change
        create_table :lists do |t|
            t.string :name
        end
    end
end