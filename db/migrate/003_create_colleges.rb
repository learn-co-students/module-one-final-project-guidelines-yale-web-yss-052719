class CreateColleges < ActiveRecord::Migration[4.2]
    def change
      create_table :colleges do |t|
        t.integer :school_id
        t.string :name
        t.string :city
        t.string :state
        t.string :url
        t.float :admission_rate_overall_2017
        t.float :sat_scores_average_overall_2017
        t.float :act_scores_average_cumulative_2013
      end
    end
end