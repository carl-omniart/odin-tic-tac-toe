# frozen_string_literal: true

module TicTacToe
  # TicTacToe::Player is the proud parent of many varied Tic-Tac-Toe-playing
  # children.
  class Player
    class << self
      def default_name
        name.split('::').last.gsub(/(.)([A-Z])/, '\1 \2')
      end
    end

    def initialize(mark)
      @mark = mark
      @name = self.class.default_name
    end

    attr_accessor :mark, :name

    def request_move(grid)
      raise NotImplementedError,
            "#{self.class} has not implemented method 'request_move'."
    end
  end
end
