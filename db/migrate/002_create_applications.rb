class CreateApplications < ActiveRecord::Migration[4.2]
    def change
      create_table :applications do |t|
        t.integer :student_id
        t.integer :college_id
      end
    end
end