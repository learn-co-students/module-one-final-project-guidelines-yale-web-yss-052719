class Favorite < ActiveRecord::Base

    attr_accessor :user, :national_park

    @@all = []

    def initialize(user, national_park)
        @user = user
        @national_park = national_park

        @@all << self
    end

    def self.all
        @@all
    end

end