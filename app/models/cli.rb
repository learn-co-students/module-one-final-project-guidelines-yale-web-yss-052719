require_all "app"

class Cli

    PROMPT = TTY::Prompt.new

    attr_accessor :student, :college, :log_in, :s_o_c, :main_menu, :college_menu, :students_by

    def initialize
        log_in_menu
    end

    def logic
    # begin with log_in_menu
        if @log_in == 1
            student_or_college
        elsif @log_in == -1
            create_username
    # takes people to login
        elsif @s_o_c == 1
            log_in
        elsif @s_o_c == -1
            log_in
        end
        # else
        #     return nil
        # end
    end

    def main_menu_logic
        if @main_menu == 1
            get_college_recommendations
        elsif @main_menu == 2
            create_an_application
        elsif @main_menu == 3
            see_applications
        elsif @main_menu == 4
            see_info_student
        elsif @main_menu == 7
            look_up_a_college
        elsif @main_menu == 5
            update_info
        elsif @main_menu == 6
            log_out
        end
    end

    def college_menu_logic
        if @college_menu == 1
            look_up_students
        elsif @college_menu == 2
            look_up_students_by
        elsif @college_menu == 3
            see_info_college
        elsif @college_menu == 4
            log_out
        end
    end

    def opening_image
        puts "   
          _____                         __                
         /  _  \\ ______ ______  _______/  |_  ___________ 
        /  /_\\  \\\\____ \\\\____ \\/  ___/\\   __\\/ __ \\_  __ \\
       /    |    \\  |_> >  |_> >___ \\  |  | \\  ___/|  | \\/
       \\____|__  /   __/|   __/____  > |__|  \\___  >__|   
               \\/|__|   |__|       \\/            \\/       "
        # puts "catpix app/models/'college_photo.jpeg'"
        Catpix::print_image "app/images/college_photo.jpeg",
            :limit_x => 1.0,
            :limit_y => 0,
            :center_x => true,
            :center_y => true,
            :resolution => "low"
    end

    def log_in_menu
        opening_image
        choices = [
            {name: 'Login', value: 1},
            {name: 'Create Account', value: -1}
          ]
        @log_in = PROMPT.select("Education advising made easy!", choices)
        logic
    end

    def student_or_college
        choices = [
            {name: 'Student', value: 1},
            {name: 'College', value: -1}
          ]
        @s_o_c = PROMPT.select("Which kind of user are you?", choices)
        @log_in = 0
        logic
    end

    def create_username
        ## we need to create option for colleges to create username
        username = PROMPT.ask('Please create a unique username. We recommend a combination of letters and numbers!', required: true)
        # binding.pry
        if Student.find_by(username: username)
            puts "Error. Username already taken."
            create_username
        else
            enter_info(username)
        end
        @log_in = 0
        main_menu_student
    end

    def log_in
        username = PROMPT.ask('Please enter your username', required: true)
        if @s_o_c == 1 && Student.find_by(username: username)
            @student = Student.find_by(username: username)
            main_menu_student
        elsif @s_o_c == -1 && College.find_by(username: username)
            @college = College.find_by(username: username)
            main_menu_college
        else
            puts "That is not a valid username. Try again."
            log_in
        end
    end

    # prompt.ask('How spicy on scale (1-5)? ') do |q|
    #     q.in '1-5'
    #     q.messages[:range?] = '%{value} out of expected range #{in}'
    #   end

    def enter_info(username)
        ## ADD: Defensive Coding -- require different data types for each PROMPT
        first_name = PROMPT.ask('Please enter your first name (required) ', required: true, convert: :string)

        last_name = PROMPT.ask('Please enter your last name (required) ', required: true, convert: :string)

        high_school = PROMPT.ask('Please enter your high school (required) ', required: true, convert: :string)

        grade = PROMPT.ask('Please enter your grade (1-12) (required) ') do |q|
            q.required true
            q.in '1-12'
            q.messages[:range?] = 'Not in expected grade range 1-12'
        end

        grad_year = PROMPT.ask('Please enter your graduation year (required) ') do |q|
            q.required true
            q.in "#{Time.now.year - 30}-#{Time.now.year + 12}"
            q.messages[:range?] = "Error. Not in the range #{Time.now.year - 30}-#{Time.now.year + 12}."
        end

        act_score = PROMPT.ask('Please enter your predicted or real ACT score (optional: press enter to continue) ') do |q|
            if @input != nil
                q.in '1-36'
                q.messages[:range?] = 'Not a valid ACT score'
            end
        end

        sat_score = PROMPT.ask('Please enter your predicted or real SAT score (optional: press enter to continue) ', default: nil) do |q|
            if @input != nil
                q.in '400-1600'
                q.messages[:range?] = 'Not a valid SAT score'
            end
        end

        @student = Student.create(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, act_score: act_score, sat_score: sat_score, username: username)

        # Only creates a Student instance (and a row in the database) once all the info is filled in
    end

    def main_menu_student
        choices = [
            {name: 'Get College Recommendations', value: 1},
            {name: 'Create an Application', value: 2},
            {name: 'See Applications', value: 3},
            {name: 'Look up a College', value: 7},
            {name: 'See Info', value: 4},
            {name: 'Update Info', value: 5},
            {name: 'Logout', value: 6}
          ]
        @main_menu = PROMPT.select("What do you want to do today?", choices)
        main_menu_logic
    end

    def get_college_recommendations
        choices = [
            {name: "Safety", value: 1},
            {name: "Target", value: 2},
            {name: "Reach", value: 3}
        ]
        input = PROMPT.select("Do you want to find safety, target, or reach schools? (Gives 3 random schools in the category you choose)", choices)

        ## FIX: need to get info about the colleges, just returns 3 names right now

        if input == 1
            if @student.act_score
                colleges = @student.find_safety_colleges_by_act_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            elsif @student.sat_score
                colleges = @student.find_safety_colleges_by_sat_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            else
                puts "Please enter your ACT or SAT score before using this feature."
            end
        elsif input == 2
            if @student.act_score
                colleges = @student.find_target_colleges_by_act_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            elsif @student.sat_score
                colleges = @student.find_target_colleges_by_sat_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            else
                puts "Please enter your ACT or SAT score before using this feature."
            end
        elsif input == 3
            if @student.act_score
                colleges = @student.find_reach_colleges_by_act_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            elsif @student.sat_score
                colleges = @student.find_reach_colleges_by_sat_score
                colleges.each do |college|
                    puts "\n#{college.name}".bold
                    puts "School ID: " + "#{college.school_id}".bold
                end
            else
                puts "Please enter your ACT or SAT score before using this feature."
            end
        end
        @main_menu = 0
        main_menu_student
    end

    def create_an_application
        college = PROMPT.ask("What college do you want to apply to? Enter the school id or full name.", default: ENV['USER'])
        if college.numeric?
            if @student.create_application_by_school_id(college)
                puts "Application Created!"
            else
                puts "Not a valid school id."
            end
        else
            if @student.create_application_by_name(college)
                puts "Application Created!"
            else
                puts "Not a valid college name."
            end
        end

        @main_menu = 0
        main_menu_student
    end

    def see_applications
        @student.applications.reload.each do |application|
            puts "College: #{application.college.name}"
            puts "Designation: #{application.designation}"
            puts "School ID: #{application.college.school_id}"
            puts "City: #{application.college.city}"
            puts "State: #{application.college.state}"
            puts "URL: #{application.college.url}"
            puts "Admissions Rate: #{application.college.admission_rate_overall_2017}"   
            puts "Average SAT Scores: #{application.college.sat_scores_average_overall_2017}"   
            puts "Average ACT Scores: #{application.college.act_scores_average_cumulative_2013}"   
        end

        @main_menu = 0
        
        delete = PROMPT.yes?("Would you like to remove any applications at this time?")
        if delete == false
            main_menu_student
        elsif delete == true
            delete_applications
        else
            puts "error"
            main_menu_student
        end
        ## this isn't working
    end

    def delete_applications
        input = PROMPT.ask('Which college would you like to remove from your applications? (Enter college name or school id)', required: true)
        if input.numeric?
            if app = Application.find_by(student_id: @student.id, college_id: College.find_by(school_id: input).id)
                ## get no method error if nil is called becaused nil.id doesn't exist
                app.destroy
                puts "Succesfully deleted!"
            else
                puts "Not a valid school id."
            end
        else
            if app = Application.find_by(student_id: @student.id, college_id: College.find_by(name: input).id)
                app.destroy
                puts "Succesfully deleted!"
            else
                puts "Not a valid college name."
            end
        end
            
        ## FIX: complete this method

        main_menu_student
    end

    def see_info_student
        puts "First Name: #{@student.first_name}"
        puts "Last Name: #{@student.last_name}"
        puts "Grade: #{@student.grade}"
        puts "High School: #{@student.high_school}"
        puts "Grad Year: #{@student.grad_year}"
        puts "ACT Score: #{@student.act_score}"
        puts "SAT Score: #{@student.sat_score}"
        puts "Username: #{@student.username}"
        
        @main_menu = 0
        main_menu_student
    end
    
    def look_up_a_college
        input = PROMPT.ask("Enter a college's name or school id.", default: ENV['USER'])

        if input.numeric?
            if college = College.find_by(school_id: input)
                puts "Name: #{college.name}"
                puts "School ID: #{college.school_id}"
                puts "City: #{college.city}"
                puts "State: #{college.state}"
                puts "URL: #{college.url}"
                puts "Admissions Rate: #{college.admission_rate_overall_2017}"   
                puts "Average SAT Scores: #{college.sat_scores_average_overall_2017}"   
                puts "Average ACT Scores: #{college.act_scores_average_cumulative_2013}" 
            else
                puts "Not a valid school id."
            end
        else
            if college = College.find_by(name: input)
                puts "Name: #{college.name}"
                puts "School ID: #{college.school_id}"
                puts "City: #{college.city}"
                puts "State: #{college.state}"
                puts "URL: #{college.url}"
                puts "Admissions Rate: #{college.admission_rate_overall_2017}"   
                puts "Average SAT Scores: #{college.sat_scores_average_overall_2017}"   
                puts "Average ACT Scores: #{college.act_scores_average_cumulative_2013}" 
            else
                puts "Not a valid college name."
            end
        end

        @main_menu = 0
        main_menu_student
    end
    
    def update_info
        choices = [
            {name: 'First Name', value: 1},
            {name: 'Last Name', value: 2},
            {name: 'Grade', value: 3},
            {name: 'High School', value: 4},
            {name: 'Graduation Year', value: 5},
            {name: 'ACT Score', value: 6},
            {name: 'SAT Score', value: 7},
            {name: 'Exit', value: 8}
        ]

        value = 0

        unless value == 8
            value = PROMPT.select("What do you want to edit?", choices)

            if value == 1
                first_name = PROMPT.ask('Please enter your first name: ', required: true, convert: :string)
                @student.update(first_name: first_name)
                puts "Updated!"
            elsif value == 2
                last_name = PROMPT.ask('Please enter your last name: ', required: true, convert: :string)
                @student.update(last_name: last_name)
                puts "Updated!"
            elsif value == 3
                grade = PROMPT.ask('Please enter your grade (1-12): ') do |q|
                    q.required true
                    q.in '1-12'
                    q.messages[:range?] = 'Not in expected grade range 1-12'
                end
                @student.update(grade: grade)
                puts "Updated!"
            elsif value == 4
                high_school = PROMPT.ask('Please enter your high school: ', required: true, convert: :string)
                @student.update(high_school: high_school)
                puts "Updated!"
            elsif value == 5
                grad_year = PROMPT.ask('Please enter your graduation year: ') do |q|
                    q.required true
                    q.in "#{Time.now.year - 30}-#{Time.now.year + 12}"
                    q.messages[:range?] = "Error. Not in the range #{Time.now.year - 30}-#{Time.now.year + 12}."
                end
                @student.update(grad_year: grad_year)
                puts "Updated!"
            elsif value == 6
                act_score = PROMPT.ask('Please enter your predicted or real ACT score (optional: press enter to continue) ', default: nil) do |q|
                    if @input != nil
                        q.in '1-36'
                        q.messages[:range?] = 'Not a valid ACT score'
                    end
                end
                @student.update(act_score: act_score)
                puts "Updated!"
            elsif value == 7
                sat_score = PROMPT.ask('Please enter your predicted or real SAT score (optional: press enter to continue) ', default: nil) do |q|
                    if @input != nil
                        q.in '400-1600'
                        q.messages[:range?] = 'Not a valid SAT score'
                    end
                end
                @student.update(sat_score: sat_score)
                puts "Updated!"
            end
        end
        
        @main_menu = 0
        main_menu_student
    end

    def log_out
        @main_menu = 0
        @college_menu = 0
        log_in_menu
    end

    def main_menu_college
        choices = [
            {name: 'Look at students interested in you?', value: 1},
            {name: 'Look up students by ___?', value: 2},
            {name: 'See info', value: 3},
            {name: 'Logout', value: 4}
          ]
        @college_menu = PROMPT.select("What do you want to do today?", choices)
        college_menu_logic
    end

    def look_up_students
        @college_menu = 0
        main_menu_college
    end

    def look_up_students_by
        @college_menu = 0
        choices = [
            {name: 'Look up students by grade?', value: 1},
            {name: 'Look up students by school?', value: 2},
            {name: 'Look up students by ACT score?', value: 3},
            {name: 'Look up students by SAT score?', value: 4}
          ]
        @students_by = PROMPT.select("Look up students by ___?", choices)
        if @students_by == 1
            grade = PROMPT.ask('Which grade?', required: true)
            Student.find_by(grade: grade)
            @students_by = 0
            main_menu_college
        elsif @students_by == 2
            school = PROMPT.ask('Which school?', required: true)
            Student.find_by(high_school: school)
            @students_by = 0
            main_menu_college
        elsif @students_by == 3
            act_score = PROMPT.ask('What range of scores?', required: true)
            Student.find_by(act_score: act_score)
            @students_by = 0
            main_menu_college
        elsif @students_by == 4
            sat_score = PROMPT.ask('What range of scores?', required: true)
            Student.find_by(sat_score: sat_score)
            @students_by = 0
            main_menu_college
        end

    end

    def see_info_college
        puts "Name: #{@college.name}"
        puts "ID: #{@college.school_id}"
        puts "City: #{@college.city}"
        puts "State: #{@college.state}"
        puts "URL: #{@college.url}"
        puts "Admission Rate: #{@college.admission_rate_overall_2017}"
        puts "Average SAT Scores: #{@college.sat_scores_average_overall_2017}"
        puts "Average ACT Scores: #{@college.act_scores_average_cumulative_2013}"
        puts "Username: #{@college.username}"
     
        @main_menu = 0
        main_menu_student
    end

end

