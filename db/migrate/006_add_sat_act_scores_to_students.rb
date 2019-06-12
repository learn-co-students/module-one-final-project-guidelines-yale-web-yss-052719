class AddSatActScoresToStudents < ActiveRecord::Migration[4.2]
    def change
        add_column :students, :act_score, :integer
        add_column :students, :sat_score, :integer
    end
end