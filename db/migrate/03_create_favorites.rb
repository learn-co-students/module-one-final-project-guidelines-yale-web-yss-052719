class CreateFavorites < ActiveRecord::Migration[4.2]

	def change
		create_table :favorites do |t|
			t.integer :user_id
			t.integer :park_id
			t.string :review
			# t.string :operating_hours
			# t.string :entrance_fee
			# t.string :weather
		end
	end
end 