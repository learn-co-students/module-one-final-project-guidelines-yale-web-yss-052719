class Cli

    PROMPT = TTY::Prompt.new

    attr_accessor :step1

    def initialize
        opening_image
        log_in_menu
    end

    def logic
        # if @step != nil
            if @step1 == 1
                log_in
            elsif @step1 == 2
                create_username
            else
                return nil
            end
        # else
        #     return nil
        # end
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
        choices = [
            {name: 'Login', value: 1},
            {name: 'Create Account', value: 2}
          ]
        @step1 = PROMPT.select("Education advising made easy!", choices)
        logic
    end

    def student_or_college
        choices = [
            {name: 'Student', value: 1},
            {name: 'College', value: 2}
          ]
          PROMPT.select("Which kind of user are you?", choices)
    end

    def create_username
        PROMPT.ask('Please create a unique username. We recommend a combination of letters and numbers!', default: ENV['USER'])
        ## make sure to return an error message if the value received already EXISTS in the database
    end

    def log_in
        PROMPT.ask('Please enter your username', default: ENV['USER'])
        # @student = Student.find_by(username: ____)
        ## put username into database
        ## get find and insert into self
        ## if name does not exist in username returns to beginning of method
    end

    def enter_info
        PROMPT.ask('Please enter your first name', default: ENV['USER'])
        PROMPT.ask('Please enter your last name', default: ENV['USER'])
        PROMPT.ask('Please enter your high school', default: ENV['USER'])
        PROMPT.ask('Please enter your grade', default: ENV['USER'])
        PROMPT.ask('Please enter your predicted or real ACT score', default: ENV['USER'])
        PROMPT.ask('Please enter your predicted or real SAT score', default: ENV['USER'])
        ## only returns last value input (how do we store rest)
        ## need to make ACT or SAT optional (people might not have both)
    end

    def main_menu_student
        choices = [
            {name: 'Get College Recommendations', value: 1},
            {name: 'Create an Application', value: 2},
            {name: 'See Applications', value: 3},
            {name: 'Update Info', value: 4}
          ]
          PROMPT.select("What do you want to do today?", choices)
    end

    def get_college_recommendations
        # @student.____
    end

    def create_an_application
    end

    def see_applications
    end

    def update_info
        ## takes you to the enter_info
    end

    def log_out
        ## figure out how to make an invisible option in all of the choices above, which will return value 0
        ## if value is 0, return to log_in_menu
    end

    def main_menu_college
        choices = [
            {name: 'Look at students interested in you?', value: 1},
            {name: 'Look up students by ___?', value: 2}
          ]
          PROMPT.select("What do you want to do today?", choices)
    end

    def look_up_students_by
        choices = [
            {name: 'Look up students by grade?', value: 1},
            {name: 'Look up students by school?', value: 2},
            {name: 'Look up students by ACT score?', value: 3},
            {name: 'Look up students by SAT score?', value: 4}
          ]
          PROMPT.select("Look up students by ___?", choices)
    end

end

