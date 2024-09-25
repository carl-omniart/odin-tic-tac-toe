# frozen_string_literal: true

require_relative 'grid'

module TicTacToe
  # TicTacToe::Game plays a game of Tic-Tac-Toe. It connects the grid to the
  # players.
  class Game
    def initialize(player1, player2)
      @players = [player1, player2].to_h { |player| [player.mark, player] }
      @grid    = Grid.new(*players.keys)
    end

    attr_reader :players, :grid

    def each_state
      return enum_for(:each_state) unless block_given?

      until grid.done?
        yield self

        move = active_player.request_move grid.dup
        break if move == :exit

        grid.mark! move
      end

      yield self
    end

    def active_player
      players[grid.active_mark]
    end

    def title
      players.values.map(&:name).join ' vs. '
    end

    def status
      return "#{active_player.name}'s turn." unless grid.done?
      return "Cat's game." if grid.cats?

      "#{players[grid.winner].name} wins!"
    end

    def to_s
      [title, grid.to_s, status].join "\n\n"
    end
  end
end
