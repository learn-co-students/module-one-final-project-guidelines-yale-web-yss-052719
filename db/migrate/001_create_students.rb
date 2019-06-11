class CreateStudents < ActiveRecord::Migration[4.2]
    def change
      create_table :students do |t|
        t.string :first_name
        t.string :last_name
        t.integer :grade
        t.string :high_school
        t.integer :grad_year
      end
    end
end