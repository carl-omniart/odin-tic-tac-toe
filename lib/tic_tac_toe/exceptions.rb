# frozen_string_literal: true

module TicTacToe
  # A general TicTacToe exception.
  class Error < StandardError; end

  # Raised by Grid when attempting to mark a marked square.
  class OccupiedError < Error
    def initialize(square)
      super("Square #{square} has already been marked")
    end
  end
end
