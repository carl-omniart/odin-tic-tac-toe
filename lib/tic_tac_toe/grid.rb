# frozen_string_literal: true

module TicTacToe
  # TicTacToe::Grid is a big hashtag for competitive doodling.
  class Grid
    LINES = [
      [6, 7, 8], [3, 4, 5], [0, 1, 2], # rows
      [6, 3, 0], [7, 4, 1], [8, 5, 2], # columns
      [0, 4, 8], [2, 4, 6]             # diagonals
    ].map(&:freeze)

    def initialize(mark1, mark2)
      @marks   = [mark1, mark2]
      @squares = Array.new 9
    end

    attr_reader :marks, :squares

    def active_mark
      marks.first
    end

    def winning_mark
      winning_line&.first
    end

    def empty_squares
      squares.each_index.reject { |square| squares[square] }
    end

    def mark(square)
      raise(OccupiedError, square) if squares[square]

      squares[square] = active_mark
      squares.freeze if done?
      marks.reverse!
      self
    end

    def full?
      squares.all?
    end

    def winner?
      !!winning_mark
    end

    def cats?
      full? && !winner?
    end

    def done?
      full? || winner?
    end

    def to_s
      squares
        .map { |square| square ? square.to_s : ' ' }
        .each_slice(3)
        .map { |row| row.join '|' }
        .reverse # => ['6|7|8', '3|4|5', '0|1|2']
        .join("\n-+-+-\n")
    end

    private

    def each_line(&)
      return enum_for(:each_line) unless block_given?

      LINES.each { |line| yield line.map { |square| squares[square] } }
    end

    def winning_line
      each_line.find { |line| line.each_cons(2).all? { |a, b| a && a == b } }
    end
  end
end
