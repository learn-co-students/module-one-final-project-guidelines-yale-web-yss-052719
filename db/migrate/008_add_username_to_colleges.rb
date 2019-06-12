class AddUsernameToColleges < ActiveRecord::Migration[4.2]
    def change
        add_column :colleges, :username, :string
    end
end