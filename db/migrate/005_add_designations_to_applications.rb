class AddDesignationsToApplications < ActiveRecord::Migration[4.2]
    def change
        add_column :applications, :type, :string
    end
end