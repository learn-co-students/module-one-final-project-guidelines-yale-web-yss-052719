require_relative "../config/environment"

describe "Student Class" do
    student = Student.new(
        first_name: "Max",
        last_name: "Sun",
        grade: 12,
        high_school: "Crescent Valley High School",
        grad_year: 2018,
        act_score: 36,
        sat_score: 1530,
        username: "maxsun"
    )

    it "should have a first name" do
        expect(student.first_name).to eq("Max")
    end

    app1 = student.create_application_by_name("Oregon State University")

    it "should have applications" do
        expect(students).to have_many(:applications)
    end
end