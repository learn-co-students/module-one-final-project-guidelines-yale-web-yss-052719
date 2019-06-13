require_relative "../config/environment"

describe "Student Class" do
<<<<<<< HEAD
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
=======

    student=Student.new(
        first_name: "Peter",
        last_name: "Hwang",
        grade: 12,
        high_school: "Adlai E. Stevenson High School",
        grad_year: 2014,
        act_score: 36,
        sat_score: 0,
        username: "test1"
    )

    application=student.create_application_by_name("University of North Texas at Dallas")

    college=College.find_by(name: "University of North Texas at Dallas")

    it 'should have a first name' do
        expect(student.first_name).to eq("Peter")
    end

    it 'should have a last name' do
        expect(student.last_name).to eq("Hwang")
    end

    it 'should have a grade' do
        expect(student.grade).to eq(12)
    end

    it 'should have many colleges through applications' do
        expect(student.colleges).to include(college)
    end

    it 'should have many applications' do
        expect(student).to have_many(:colleges)
    end
    
    # create_application_by_name(college_name)

>>>>>>> 231f59df22b73e1f9d4bc45aaa01c3f9c2f12bad
end