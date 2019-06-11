class College < ActiveRecord::Base
    has_many :applications
    has_many :students, through: :applications
end