# frozen_string_literal: true

require_relative 'player'

module TicTacToe
  # TicTacToe::CentroCornerside is a player who plays (1) a winning move,
  # (2) a blocking move, (3) center square, (4) corner square, or (5) side
  # square.
  class CentroCornerside < Player
    def request_move(grid)
      %i[
        winning_moves
        blocking_moves
        center_moves
        corner_moves
        side_moves
      ].each do |move_type|
        moves = send(move_type, grid)
        return moves.sample unless moves.empty?
      end
    end

    private

    def winning_moves(grid)
      grid.empty_squares.find_all { |x| grid.dup.mark!(x).winner? }
    end

    def blocking_moves(grid)
      losers = grid.empty_squares.find_all do |x|
        next_grid = grid.dup.mark! x
        next_grid.empty_squares.any? { |o| next_grid.dup.mark!(o).winner? }
      end

      losers.empty? ? [] : grid.empty_squares - losers
    end

    def center_moves(grid)
      Grid::SQUARE_GROUPS[:center] & grid.empty_squares
    end

    def corner_moves(grid)
      Grid::SQUARE_GROUPS[:corners] & grid.empty_squares
    end

    def side_moves(grid)
      Grid::SQUARE_GROUPS[:sides] & grid.empty_squares
    end
  end
end
