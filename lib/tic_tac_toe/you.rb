# frozen_string_literal: true

module TicTacToe
  # TicTacToe::User ...
  class You < Player
    attr_accessor :view

    def request_move(grid)
      view.request_move(*grid.empty_squares)
    end
  end
end
