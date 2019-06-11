<<<<<<< HEAD
class Cli
=======
# require_relative "../lib/tty-prompt"
>>>>>>> 083776000ec53324965477952af0977bfe06050b

    PROMPT = TTY::Prompt.new

    def initialize
        starting_method
    end


    def starting_method
        PROMPT.ask('What is your name?', default: ENV['USER'])
    end
end

