require_relative '../config/environment'

Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
  
      # Keep as many of these lines as are necessary:
      with.library :active_record
      with.library :active_model
    end
  end

describe "User Class" do
    user = User.new(name: "Richard", state: "CT")
    favorite = Favorite.new(user_id: 1, park_id: 3, review: "")
    it 'should have a name and state' do
        expect(user.name).to eq("Richard")
        expect(user.state).to eq("CT")
    end
    # it 'should have user include favorites' do
    #     expect(user).to have_many(Favorite.all)
    # end
end

