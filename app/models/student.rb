class Student < ActiveRecord::Base
    has_many :applications
    has_many :colleges, through: :applications

    validates :first_name, :presence => true
    validates :last_name, :presence => true

    def create_application_by_name(college_name)
        college = College.find_by(name: college_name)
        Application.create(student_id: self.id, college_id: college.id)
    end

    def create_application_by_school_id(school_id)
        college = College.find_by(school_id: school_id)
        Application.create(student_id: self.id, college_id: college.id)
    end

    def find_random_colleges_by_attributes(attributes)

    end
end