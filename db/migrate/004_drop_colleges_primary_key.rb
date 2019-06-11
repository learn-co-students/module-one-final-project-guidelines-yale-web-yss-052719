class CreateColleges < ActiveRecord::Migration[4.2]
    def change
        remove_column :colleges, :id
        add_column :colleges, :id, :primary_key
    end
end