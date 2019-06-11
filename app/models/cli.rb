require_relative "../lib/tty-prompt"

PROMPT = TTY::Prompt.new

class Prompt

    def initialize
        prompt.ask('What is your name?', default: ENV['USER'])
    end

end

