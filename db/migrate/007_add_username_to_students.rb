class AddUsernameToStudents < ActiveRecord::Migration[4.2]
    def change
        add_column :students, :username, :string
    end
end