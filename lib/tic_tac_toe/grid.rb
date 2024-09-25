# frozen_string_literal: true

module TicTacToe
  # TicTacToe::Grid is an oversized hashtag for competitive doodling.
  class Grid
    SQUARES = [7, 8, 9, 4, 5, 6, 1, 2, 3].freeze

    SQUARE_GROUPS =
      {
        center: [4],
        corners: [0, 2, 6, 8],
        sides: [1, 3, 5, 7]
      }.transform_values { |group| SQUARES.values_at(*group).freeze }
      .merge(
        {
          rows: [[0, 1, 2], [3, 4, 5], [6, 7, 8]],
          columns: [[0, 3, 6], [1, 4, 7], [2, 5, 8]],
          diagonals: [[0, 4, 8], [2, 4, 6]]
        }.transform_values { |sets| sets.map { |set| SQUARES.values_at(*set) } }
      )
      .transform_values(&:freeze)
      .freeze

    SETS = %i[
      rows
      columns
      diagonals
    ].flat_map { |group| SQUARE_GROUPS[group] }.freeze

    SETS_BY_SQUARE = SQUARES.to_h do |square|
      [square, SETS.each_index.select { |i| SETS[i].include? square }.freeze]
    end.freeze

    def initialize(mark1, mark2)
      @marks = [mark1, mark2]
      @moves = Hash.new { |_, square| SQUARES.include?(square) ? :' ' : nil }
      @sets  = Array.new(8) { [] }
    end

    attr_reader :marks, :moves, :sets

    def active_mark
      marks.first
    end

    def marked_squares
      moves.keys
    end

    def empty_squares
      SQUARES - marked_squares
    end

    def winner
      sets.find { |set| set == [set.first] * 3 }&.first
    end

    def full?
      marked_squares.size == SQUARES.size
    end

    def winner?
      !!winner
    end

    def cats?
      full? && !winner?
    end

    def done?
      winner? || full?
    end

    def mark!(square)
      raise(StandardError, "Game's over, bro.") if done?
      raise(ArgumentError, 'Not a square, bro.') unless SQUARES.include? square
      raise(ArgumentError, 'O-cu-pa-do!') if marked_squares.include? square

      each_set_with(square) { |set| set << active_mark }
      moves[square] = active_mark
      marks.reverse!
      self
    end

    def to_a
      SQUARES.map { |square| moves[square] }.each_slice(3).to_a
    end

    def to_s
      SQUARES.map { |square| moves[square].to_s }
             .each_slice(3)
             .map { |row| row.join '|' }
             .join "\n-+-+-\n"
    end

    def inspect
      "<#{self.class}: #{to_a}>"
    end

    private

    def each_set_with(square)
      return enum_for(:each_set_with, square) unless block_given?

      SETS_BY_SQUARE[square].each { |s| yield sets[s] }
    end

    def initialize_copy(orig)
      @moves  = orig.moves.dup
      @sets   = orig.sets.dup.map(&:dup)
      @marks  = orig.marks.dup
      @winner = orig.winner

      super
    end
  end
end
