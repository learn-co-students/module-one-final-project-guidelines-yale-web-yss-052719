class CreateStates < ActiveRecord::Migration[4.2]

	def change
		create_table :states do |t|
			t.string :abb
			t.string :state
		end
	end
end 