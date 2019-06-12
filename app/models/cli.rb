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
            see_info
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
        username = PROMPT.ask('Please create a unique username. We recommend a combination of letters and numbers!', required: true)
        # binding.pry
        if Student.find_by(username: username)
            puts "Error. Username already taken."
            create_username
        else
            @student = Student.create(username: username)
            enter_info
        end
        @log_in = 0
        main_menu_student
    end

    def log_in
        ## currently if someone says they're in college, than it pushes them through to main_menu_college. I need to fix this bug.
        username = PROMPT.ask('Please enter your username', required: true)
        if @s_o_c == 1
            @student = Student.find_by(username: username)
            main_menu_student
        elsif @s_o_c == -1
            @college = College.find_by(username: username)
            main_menu_college
        end
        

        ## put username into database
        ## get find and insert into self
        ## if name does not exist in username returns to beginning of method
    end

    def enter_info
        first_name = PROMPT.ask('Please enter your first name', required: true)
        last_name = PROMPT.ask('Please enter your last name', required: true)
        high_school = PROMPT.ask('Please enter your high school', required: true)
        grade = PROMPT.ask('Please enter your grade', required: true)
        grad_year = PROMPT.ask('Please enter your graduation year', required: true)
        act_score = PROMPT.ask('Please enter your predicted or real ACT score', default: nil, required: true)
        sat_score = PROMPT.ask('Please enter your predicted or real SAT score', default: nil, required: true)
        @student.update(first_name: first_name, last_name: last_name, high_school: high_school, grade: grade, grad_year: grad_year, act_score: act_score, sat_score: sat_score)
        ## only returns last value input (how do we store rest)
        ## need to make ACT or SAT optional (people might not have both)
    end

    def main_menu_student
        choices = [
            {name: 'Get College Recommendations', value: 1},
            {name: 'Create an Application', value: 2},
            {name: 'See Applications', value: 3},
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
        input = PROMPT.select("Do you want to find safety, target, or reach schools?", choices)
        @main_menu = 0
        main_menu_student
    end

    def create_an_application
        college = PROMPT.ask("What college do you want to apply to? (enter the school id or name)", default: ENV['USER'])
        @main_menu = 0
        main_menu_student
        # if college == college.to_s
        #     @student.create_application_by_name(college)
        #     puts "Application Created!"
        # elsif college == college.to_i
        #     @student.create_application_by_school_id(college)
        #     puts "Application Created!"
        # else
        #     puts "Not valid input."
        # end
    end

    def see_applications
        @student.applications
        @main_menu = 0
        main_menu_student
    end

    def see_info
        @student
        @main_menu = 0
        main_menu_student
    end
    
    def update_info
        enter_info
        @main_menu = 0
        main_menu_student
        ## takes you to the enter_info
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
            {name: 'Logout', value: 3}
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

end

