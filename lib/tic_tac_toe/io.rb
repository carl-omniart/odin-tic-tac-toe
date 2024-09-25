# frozen_string_literal: true

require 'io/console'

module TicTacToe
  # TicTacToe::IO provides the basic input and output methods necessary to
  # interact with the console.
  class IO
    DEFAULTS = {
      input: $stdin,
      output: $stdout,
      spacing: 0,
      char_transform: :itself
    }.freeze

    class << self
      def open(...)
        yield new(...)
      end
    end

    def initialize(**opts)
      opts = DEFAULTS.merge opts

      self.input          = opts[:input]
      self.output         = opts[:output]
      self.spacing        = opts[:spacing]
      self.char_transform = opts[:char_transform]
    end

    attr_accessor :input, :output, :spacing, :char_transform

    def post(*lines)
      lines = lines.map { |line| clear_control_chars line }
      output.puts lines
      space
    end

    def post_list(enumerable_object, &)
      list = enumerable_object.map(&)
      post(*list)
    end

    def prompt(string)
      output.print "#{clear_control_chars(string)} "
    end

    def space
      spacing.times { output.puts }
      nil
    end

    def request_string(message)
      prompt message
      user_string
    end

    def request_char(message, *valid_chars)
      prompt message
      user_char(*valid_chars)
    end

    def choose(message, *choices)
      choices = numbered(*choices)
      post_list(choices) { |(num, choice)| "(#{num}) #{choice}" }
      numbers = choices.keys
      num     = request_char message, *numbers
      choices[num]
    end

    private

    def user_string
      string = clear_control_chars input.gets.chomp
      space
      string
    end

    def user_char(*valid_chars)
      valid_chars = valid_chars.map(&char_transform).uniq
      char = input.getch.send(char_transform) until valid_chars.include?(char)
      post char
      char
    end

    def numbered(*array)
      array.each.with_index(1).to_h { |item, index| [index.to_s, item] }
    end

    def clear_control_chars(string)
      string.gsub(/[\p{c}&&[^\n]]/, '')
    end
  end
end
