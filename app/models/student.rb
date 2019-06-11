class Student < ActiveRecord::Base
    has_many :applications
    has_many :colleges, through: :applications
end