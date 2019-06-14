class CreateUsers < ActiveRecord::Migration[4.2]

	def change
		create_table :users do |t|
			t.string :name
			t.string :state
			# t.string :operating_hours
			# t.string :entrance_fee
			# t.string :weather
		end
	end
end 