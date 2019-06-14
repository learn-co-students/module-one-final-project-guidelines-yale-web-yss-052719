require_all "app"

class Cli

    PROMPT = TTY::Prompt.new

    attr_accessor :student, :college, :log_in, :s_o_c, :main_menu, :college_menu, :students_by

    def initialize
        clear_screen
        opening_image
        log_in_menu
    end

    def logic
        if @log_in == 1
            log_in
        elsif @log_in == -1
            student_or_college
        elsif @s_o_c == 1
            create_username
        elsif @s_o_c == -1
            create_username
        end
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
        sleep(0.5)
        Catpix::print_image "app/images/college_photo.jpeg",
            :limit_x => 1.0,
            :limit_y => 0,
            :center_x => true,
            :center_y => true,
            :resolution => "low"
    end

    def log_in_menu
        puts "\n"
        choices = [
            {name: 'Create Account', value: -1},
            {name: 'Login', value: 1},
          ]
        puts "Hi, I'm Owly! The College Advising Owl! 🦉\n"
        @log_in = PROMPT.select("To begin: create a username or login!", choices)
        logic
    end

    def student_or_college
        choices = [
            {name: 'Student', value: 1},
            {name: 'College', value: -1}
          ]
        puts "\n"
        @s_o_c = PROMPT.select("Which kind of user are you? ", choices)
        @log_in = 0
        logic
    end

    def create_username
        ## we need to create option for colleges to create username
        puts "\nWho who whooooooo are you? 🦉\n(Please create a unique username. I recommend a combination of letters and numbers!)\n"
        username = PROMPT.ask("Type Exit if you want to return to the main menu.", required: true)
        # binding.pry
        if username.downcase == "exit"
            clear_screen
            log_in_menu
        elsif Student.find_by(username: username) || College.find_by(username: username)
            puts "Error. Username already taken.".bold
            create_username
        elsif @s_o_c == 1
            @s_o_c = 0
            enter_info(username)
            main_menu_student
        elsif @s_o_c == -1
            @s_o_c = 0
            college_name = PROMPT.ask("Which college are you? (enter the school id or name)", required: true)
            @college = College.find_by(name: college_name)
            @college.update(username: username)
            main_menu_college
        end
        @log_in = 0 
    end

    def log_in
        puts "\nWho who whooooooo are you? 🦉 \n(Please enter your username)\n"
        username = PROMPT.ask("Type Exit if you want to return to the main menu.", required: true)
        if username.downcase == "exit"
            clear_screen
            log_in_menu
            ## think we can change delete the @s_o_c conditions
        elsif Student.find_by(username: username)
            @student = Student.find_by(username: username)
            main_menu_student
        elsif College.find_by(username: username)
            @college = College.find_by(username: username)
            main_menu_college
        else
            puts "That is not a valid username. Try again.".bold
            log_in
        end
    end

    def get_act_score
        PROMPT.ask('Please enter your predicted or real ACT score (optional: press enter to continue) ') do |q|
            q.in '1-36'
            q.messages[:range?] = 'Not a valid ACT score'.bold
        end
    end

    def get_sat_score
        PROMPT.ask('Please enter your predicted or real SAT score (optional: press enter to continue) ') do |q|
            q.in '400-1600'
            q.messages[:range?] = 'Not a valid SAT score'.bold
        end
    end

    def enter_info(username)
        ## ADD: Defensive Coding -- require different data types for each PROMPT
        first_name = PROMPT.ask('Please enter your first name (required) ') do |q|
            q.required true
            q.validate /^[a-zA-Z]+$/
            q.modify :capitalize
        end

        last_name = PROMPT.ask('Please enter your last name (required) ') do |q|
            q.required true
            q.validate /^[a-zA-Z]+$/
            q.modify :capitalize
        end

        high_school = PROMPT.ask('Please enter your high school name (required) ') do |q|
            q.required true
            q.validate /^[a-zA-Z]+\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*$/
            q.modify :up
        end

        grade = PROMPT.ask('Please enter your grade (1-12) (required) ') do |q|
            q.required true
            q.in '1-12'
            q.messages[:range?] = 'Not in expected grade range 1-12'.bold
        end

        grad_year = PROMPT.ask('Please enter your graduation year (required) ') do |q|
            q.required true
            q.in "#{Time.now.year - 30}-#{Time.now.year + 12}"
            q.messages[:range?] = "Error. Not in the range #{Time.now.year - 30}-#{Time.now.year + 12}.".bold
        end

        choices = [
            {name: 'ACT', value: 1},
            {name: 'SAT', value: 2},
            {name: 'Both', value: 3},
            {name: 'Neither', value: 4}
          ]
        puts "\n"
        tests = PROMPT.select("Have you taken the ACT and/or SAT? ", choices)

        if tests == 1
            act_score = get_act_score
            @student = Student.create(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, act_score: act_score, username: username)
            puts "Account Created!"
        elsif tests == 2
            sat_score = get_sat_score
            @student = Student.create(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, sat_score: sat_score, username: username)
            puts "Account Created!"
        elsif tests == 3
            act_score = get_act_score
            sat_score = get_sat_score
            @student = Student.create(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, act_score: act_score, sat_score: sat_score, username: username)
            puts "Account Created!"
        elsif tests == 4
            @student = Student.create(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, username: username)
            puts "\nAccount Created! But you probably should take the SAT or ACT to get the most out of this app! 🦉\n"
        end

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
        @main_menu = PROMPT.select("\nWhat do you want to do today?", choices)
        main_menu_logic
    end

    def get_college_recommendations
        clear_screen
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
                if colleges.empty?
                    puts "\nNo safety schools found :( 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            elsif @student.sat_score
                colleges = @student.find_safety_colleges_by_sat_score
                if colleges.empty?
                    puts "\nNo safety schools found :( 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            else
                puts "\nPlease enter your ACT or SAT score before using this feature.".bold
            end
        elsif input == 2
            if @student.act_score
                colleges = @student.find_target_colleges_by_act_score
                if colleges.empty?
                    puts "\nNo target schools found :( 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            elsif @student.sat_score
                colleges = @student.find_target_colleges_by_sat_score
                if colleges.empty?
                    puts "\nNo target schools found :( 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            else
                puts "\nPlease enter your ACT or SAT score before using this feature.".bold
            end
        elsif input == 3
            if @student.act_score
                colleges = @student.find_reach_colleges_by_act_score
                if colleges.empty?
                    puts "\nNo reach schools found :) 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            elsif @student.sat_score
                colleges = @student.find_reach_colleges_by_sat_score
                if colleges.empty?
                    puts "\nNo reach schools found :) 🦉"
                else
                    colleges.each do |college|
                        puts "\n#{college.name}".bold
                        puts "School ID: " + "#{college.school_id}".bold
                    end
                end
            else
                puts "\nPlease enter your ACT or SAT score before using this feature.".bold
            end
        end
        @main_menu = 0
        main_menu_student
    end

    def create_an_application
        clear_screen
        puts "What college do you want to apply to? " + "\n(enter the school id or name)\n".bold
        input = PROMPT.ask("Make sure to capitalize and do not forget to include 'University' or 'College' in the full school name!")
        # do |q|
        #     q.modify :capitalize
        # end
        if input.numeric?
            if college = College.find_by(school_id: input)
                if Application.find_by(student_id: @student.id, college_id: college.id)
                    puts "\nApplication already created for this school."
                else
                    @student.create_application_by_school_id(input)
                    puts "\nApplication Created!"
                end
            else
                puts "Not a valid school id.".bold
            end 
        else
            if college = College.find_by(name: input)
                if Application.find_by(student_id: @student.id, college_id: college.id)
                    puts "\nApplication already created for this school."
                else
                    @student.create_application_by_name(input)
                    puts "\nApplication Created!"
                end
            else
                puts "Not a valid school name.".bold
            end 
        end
        @main_menu = 0
        main_menu_student
    end

    def see_applications
        ## add numbering system
        clear_screen
        @student.applications.reload.each do |application|
            puts "🦉\nCollege: " + "#{application.college.name}".bold
            puts "Designation: #{application.designation}"
            puts "School ID: #{application.college.school_id}"
            puts "City: #{application.college.city}"
            puts "State: #{application.college.state}"
            puts "URL: #{application.college.url}"
            puts "Admissions Rate: #{application.college.admission_rate_overall_2017}"   
            puts "Average SAT Scores: #{application.college.sat_scores_average_overall_2017}"   
            puts "Average ACT Scores: #{application.college.act_scores_average_cumulative_2013}\n"   
        end

        @main_menu = 0
        
        ## make sure this only takes boolean
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
        clear_screen
        puts "Which college would you like to remove from your applications?" + "\n(Enter college name or school id)\n".bold
        input = PROMPT.ask("Make sure to capitalize and do not forget to include 'University' or 'College' in the full school name!", required: true)

        if input.numeric?
            if college = College.find_by(school_id: input)
                if app = Application.find_by(student_id: @student.id, college_id: college.id)
                    ## get no method error if nil is called becaused nil.id doesn't exist
                    app.destroy
                    puts "\nSuccesfully deleted!"
                else
                    puts "\nYou don't have an application for this school anyways."
                end
            else
                puts "Not a valid school id.".bold
            end
        else
            if college = College.find_by(name: input)
                if app = Application.find_by(student_id: @student.id, college_id: college.id)
                    app.destroy
                    puts "\nSuccesfully deleted!"
                else
                    puts "\nYou don't have an application for this school anyways."
                end
            else
                puts "Not a valid college name.".bold
            end
        end
            
        ## FIX: complete this method

        main_menu_student
    end

    def see_info_student
        clear_screen
        puts "🦉\nFirst Name: #{@student.first_name}"
        puts "Last Name: #{@student.last_name}"
        puts "Grade: #{@student.grade}"
        puts "High School: #{@student.high_school}"
        puts "Grad Year: #{@student.grad_year}"
        puts "ACT Score: #{@student.act_score}"
        puts "SAT Score: #{@student.sat_score}"
        puts "Username: #{@student.username}\n"
        
        @main_menu = 0
        main_menu_student
    end
    
    def look_up_a_college
        clear_screen
        puts "Enter a college's name or school id.\n".bold
        input = PROMPT.ask("Make sure to capitalize and do not forget to include 'University' or 'College' in the full school name!")
        # do |q|
        #     q.modify :capitalize
        # end

        if input.numeric?
            if college = College.find_by(school_id: input)
                puts "🦉\nName: #{college.name}"
                puts "School ID: #{college.school_id}"
                puts "City: #{college.city}"
                puts "State: #{college.state}"
                puts "URL: #{college.url}"
                puts "Admissions Rate: #{college.admission_rate_overall_2017}"   
                puts "Average SAT Scores: #{college.sat_scores_average_overall_2017}"   
                puts "Average ACT Scores: #{college.act_scores_average_cumulative_2013}\n" 
            else
                puts "🦉\nNot a valid school id.\n"
            end
        else
            if college = College.find_by(name: input)
                puts "🦉\nName: #{college.name}"
                puts "School ID: #{college.school_id}"
                puts "City: #{college.city}"
                puts "State: #{college.state}"
                puts "URL: #{college.url}"
                puts "Admissions Rate: #{college.admission_rate_overall_2017}"   
                puts "Average SAT Scores: #{college.sat_scores_average_overall_2017}"   
                puts "Average ACT Scores: #{college.act_scores_average_cumulative_2013}\n" 
            else
                puts "🦉\nNot a valid college name.\n"
            end
        end

        @main_menu = 0
        main_menu_student
    end
    
    def update_info
        clear_screen
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
                first_name = PROMPT.ask('Please enter your first name: ') do |q|
                    q.required true
                    q.validate /^[a-zA-Z]+$/
                    q.modify :capitalize
                end
                @student.update(first_name: first_name)
                puts "Updated!"
            elsif value == 2
                last_name = PROMPT.ask('Please enter your last name: ') do |q|
                    q.required true
                    q.validate /^[a-zA-Z]+$/
                    q.modify :capitalize
                end
                @student.update(last_name: last_name)
                puts "Updated!"
            elsif value == 3
                grade = PROMPT.ask('Please enter your grade (1-12): ') do |q|
                    q.required true
                    q.in '1-12'
                    q.messages[:range?] = 'Not in expected grade range 1-12'.bold
                end
                @student.update(grade: grade)
                puts "Updated!"
            elsif value == 4
                high_school = PROMPT.ask('Please enter your high school: ') do |q|
                    q.required true
                    q.validate /^[a-zA-Z]+\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*\s?[a-zA-Z]*$/
                    q.modify :up
                end
                @student.update(high_school: high_school)
                puts "Updated!"
            elsif value == 5
                grad_year = PROMPT.ask('Please enter your graduation year: ') do |q|
                    q.required true
                    q.in "#{Time.now.year - 30}-#{Time.now.year + 12}"
                    q.messages[:range?] = "Error. Not in the range #{Time.now.year - 30}-#{Time.now.year + 12}.".bold
                end
                @student.update(grad_year: grad_year)
                puts "Updated!"
            elsif value == 6
                act_score = get_act_score
                @student.update(act_score: act_score)
                puts "Updated!"
            elsif value == 7
                sat_score = get_sat_score
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
        clear_screen
        Catpix::print_image "app/images/owl_image.jpeg",
            :limit_x => 1.0,
            :limit_y => 0,
            :center_x => true,
            :center_y => true,
            :resolution => "high"
        puts "\nThank you for joining me on this journey! Owl miss you 🦉"
        sleep(2)
        clear_screen
        opening_image
        log_in_menu
    end

    def main_menu_college
        choices = [
            {name: 'Look at students interested in you?', value: 1},
            {name: 'Look up students by ___?', value: 2},
            {name: 'See info', value: 3},
            {name: 'Logout', value: 4}
          ]
        @college_menu = PROMPT.select("\nWhat do you want to do today?", choices)
        college_menu_logic
    end

    def look_up_students
        clear_screen
        @college.students.each do |student|
            puts "\n#{student.first_name} #{student.last_name}".bold
            puts "#{student.high_school}, #{student.grad_year}"
            puts "ACT: #{student.act_score}"
            puts "SAT: #{student.sat_score}"
        end
        @college_menu = 0
        main_menu_college
    end

    def look_up_students_by
        clear_screen
        @college_menu = 0
        choices = [
            {name: 'Look up students by grade?', value: 1},
            {name: 'Look up students by school?', value: 2},
            {name: 'Look up students by graduation year?', value: 3}
            # {name: 'Look up students by ACT score?', value: 3},
            # {name: 'Look up students by SAT score?', value: 4}
          ]
        @students_by = PROMPT.select("Look up students by ___?", choices)
        if @students_by == 1
            grade = PROMPT.ask('Which grade? (1-12)') do |q|
                q.required true
                q.in '1-12'
                q.messages[:range?] = 'Not in expected grade range 1-12'
            end
            if @college.students.where(grade: grade).empty?
                puts "\nNo students in this grade has applied to your college."
            else
                @college.students.where(grade: grade).each do |student|
                    puts "\n#{student.first_name} #{student.last_name}".bold
                    puts "#{student.high_school}, #{student.grad_year}"
                    puts "ACT: #{student.act_score}"
                    puts "SAT: #{student.sat_score}"
                end
            end
            @students_by = 0
            main_menu_college
        elsif @students_by == 2
            school = PROMPT.ask('Which school?') do |q|
                q.required true
                q.modify :up
            end
            if @college.students.where(high_school: school).empty?
                puts "\nNo students in this high school has applied to your college."
            else
                @college.students.where(high_school: school).each do |student|
                    puts "\n#{student.first_name} #{student.last_name}".bold
                    puts "#{student.high_school}, #{student.grad_year}"
                    puts "ACT: #{student.act_score}"
                    puts "SAT: #{student.sat_score}"
                end
            end
            @students_by = 0
            main_menu_college
        elsif @students_by == 3
            grad_year = PROMPT.ask('Which graduation year?') do |q|
                q.required true
            end
            if @college.students.where(grad_year: grad_year).empty?
                puts "\nNo students in this graduation year has applied to your college."
            else
                @college.students.where(grad_year: grad_year).each do |student|
                    puts "\n#{student.first_name} #{student.last_name}".bold
                    puts "#{student.high_school}, #{student.grad_year}"
                    puts "ACT: #{student.act_score}"
                    puts "SAT: #{student.sat_score}"
                end
            end
            @students_by = 0
            main_menu_college
        # elsif @students_by == 3
        #     act_score_range = PROMPT.ask('What range of scores?', required: true, convert: :range)
        #     for i in act_score_range
        #         @college.students.where(act_score: i)
        #     end
        #     @students_by = 0
        #     main_menu_college
        # elsif @students_by == 4
        #     sat_score_range = PROMPT.ask('What range of scores?', required: true, convert: :range)
        #     for i in sat_score_range
        #         @college.students.where(sat_score: i)
        #     end
        #     @students_by = 0
        #     main_menu_college
        end

    end

    def see_info_college
        clear_screen
        puts "\nName: #{@college.name}"
        puts "ID: #{@college.school_id}"
        puts "City: #{@college.city}"
        puts "State: #{@college.state}"
        puts "URL: #{@college.url}"
        puts "Admission Rate: #{@college.admission_rate_overall_2017}"
        puts "Average SAT Scores: #{@college.sat_scores_average_overall_2017}"
        puts "Average ACT Scores: #{@college.act_scores_average_cumulative_2013}"
        puts "Username: #{@college.username}\n"
     
        @college_menu = 0
        main_menu_college
    end

    def clear_screen
        system "clear"
    end

end

