class Cli

    PROMPT = TTY::Prompt.new

    def initialize
        starting_method
    end


    def starting_method
        PROMPT.ask('What is your name?', default: ENV['USER'])
    end
end

