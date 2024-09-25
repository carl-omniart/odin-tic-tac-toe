# frozen_string_literal: true

require_relative '../../lib/tic_tac_toe/grid'

module GridHelpers
  GRIDS = {
    new: [],
    incomplete_without_winner: [
      6, 5, # x _ x
      9, 3, # _ o x
      7     # _ _ o
    ],
    incomplete_with_winner: [
      2, 5, # o x o
      8, 7, # x o _
      3, 1, # o x x
      4, 9
    ],
    complete_without_winner: [
      5, 1, # o x x
      3, 7, # x x o
      4, 6, # o o x
      8, 2,
      9
    ],
    complete_with_winner: [
      3, 5, # x x x
      7, 6, # x o o
      4, 1, # o o x
      9, 2,
      8
    ],
    winning_move_next: [
      5, 2, # o _ x
      3, 7, # _ x o
      9, 6  # _ o x
    ],
    blocking_move_next: [
      1, 5, # _ x x
      9, 2, # _ o _
      8     # x o _
    ],
    forking_move_next: [
      5, 4, # x _ _
      7, 3  # o x _
      #     # _ _ o
    ],
    corner_trap: [
      3, 5, # x _ _
      7     # _ o _
      #     # _ _ x
    ],
    vacant_center: [
      3, 6, # _ _ _
      4     # x _ o
      #     # _ _ x
    ]
  }.transform_values(&:freeze).freeze

  def self.grid(name)
    new_grid = TicTacToe::Grid.new :x, :o
    GRIDS[name].reduce(new_grid) { |grid, square| grid.mark! square }
  end

  def self.empty_squares(name)
    (1..9).to_a - GRIDS[name]
  end

  def self.marked_squares(name)
    (1..9).to_a & GRIDS[name]
  end
end
