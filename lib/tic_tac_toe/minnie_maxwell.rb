# frozen_string_literal: true

require_relative 'player'

module TicTacToe
  # TicTacToe::MinnieMaxwell is a player who implements the Minimax algorithm
  # to decide on the next move.
  class MinnieMaxwell < Player
    # GridState is a wrapper for grid that adapts grid for use with the minimax
    # algorithm.
    GridState = Struct.new(:grid, :mark) do
      def cutoff?(_depth)
        grid.done?
      end

      def value
        case grid.winner
        when mark
          1
        when nil
          0
        else
          -1
        end
      end

      def each_action(&block)
        return enum_for(:each_action) unless block

        grid.empty_squares.shuffle.each(&block)
      end

      def successor(action)
        GridState.new grid.dup.mark!(action), mark
      end
    end

    # The Minimax algorithm is implemented as class methods.
    Infinity = Float::INFINITY

    class << self
      def decision(state)
        state.each_action.max_by { |action| min_value state.successor(action) }
      end

      def max_value(state, depth: 0, alpha: -Infinity, beta: Infinity)
        return state.value if state.cutoff? depth

        state.each_action.reduce(-Infinity) do |max, action|
          successor = state.successor action
          min       = min_value(successor, depth: depth + 1, alpha:, beta:)
          max       = [min, max].max
          alpha     = [max, alpha].max

          max >= beta ? (break max) : max
        end
      end

      def min_value(state, depth: 0, alpha: -Infinity, beta: Infinity)
        return state.value if state.cutoff? depth

        state.each_action.reduce(Infinity) do |min, action|
          successor = state.successor action
          max       = max_value(successor, depth: depth + 1, alpha:, beta:)
          min       = [min, max].min
          beta      = [min, beta].min

          min <= alpha ? (break min) : min
        end
      end
    end

    def request_move(grid)
      self.class.decision GridState.new(grid, mark)
    end
  end
end
