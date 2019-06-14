class ChangeColumnDesignationInApplications < ActiveRecord::Migration[4.2]
    def change
        rename_column :applications, :type, :designation
    end
end