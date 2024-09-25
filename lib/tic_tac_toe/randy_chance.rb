# frozen_string_literal: true

require_relative 'player'

module TicTacToe
  # TicTacToe::RandyChance is a player who chooses moves at random.
  class RandyChance < Player
    def request_move(grid)
      grid.empty_squares.sample
    end
  end
end
