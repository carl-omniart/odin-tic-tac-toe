# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/grid_helpers'
require_relative '../../lib/tic_tac_toe/grid'

RSpec.describe TicTacToe::Grid do
  describe '::SQUARES' do
    subject(:squares) { described_class::SQUARES }

    it('returns nine squares') { expect(squares.size).to eq 9 }
    it('is frozen') { expect(squares).to be_frozen }
  end

  describe '::new(mark1, mark2)' do
    it 'returns an instance of itself' do
      expect(described_class.new(:x, :o)).to be_a described_class
    end

    it 'accepts 2 arguments' do
      expect { described_class.new(1, 2) }.not_to raise_error
    end

    [[], [1], [1, 2, 3]].each do |args|
      it "does not accept #{args.size} arguments" do
        expect { described_class.new(*args) }.to raise_error ArgumentError
      end
    end
  end

  describe '#marks' do
    subject(:marks) { GridHelpers.grid(:new).marks }

    it('returns a pair') { expect(marks.size).to eq 2 }
    it('returns marks passed to ::new') { expect(marks).to eq %i[x o] }
  end

  describe '#active_mark' do
    subject(:grid) { GridHelpers.grid :new }

    it('returns a mark') { expect(grid.marks).to include grid.active_mark }
  end

  describe '#mark!(square)' do
    subject(:grid) { GridHelpers.grid :new }

    it('returns itself') { expect(grid.mark!(4)).to be grid }

    it 'adds a move' do
      expect { grid.mark! 3 }.to change { grid.moves.size }.from(0).to 1
    end

    it 'raises an error if square is not a square' do
      expect { grid.mark! 13 }.to raise_error ArgumentError
    end

    it 'raises an error if square is already marked' do
      expect { grid.mark!(8).mark!(8) }.to raise_error ArgumentError
    end

    it 'toggles the active mark' do
      expect { grid.mark!(1) }.to change(grid, :active_mark).from(:x).to :o
    end

    it 'toggles the active mark back again' do
      expect { grid.mark!(1).mark!(2) }.not_to change grid, :active_mark
    end
  end

  describe '#to_a' do
    subject(:grid) { GridHelpers.grid :incomplete_without_winner }

    it 'returns a 3x3 array of marks' do
      expected = [[:x, :' ', :x], [:' ', :o, :x], [:' ', :' ', :o]]
      expect(grid.to_a).to eq(expected)
    end
  end

  context 'when grid is new' do
    subject(:grid) { GridHelpers.grid :new }

    it('returns a nil winner') { expect(grid.winner).to be_nil }
    it('is not a winner') { expect(grid).not_to be_winner }
    it('is not full') { expect(grid).not_to be_full }
    it("is not a cat's game") { expect(grid).not_to be_cats }
    it('is not done') { expect(grid).not_to be_done }

    it 'has empty squares' do
      empty_squares = GridHelpers.empty_squares :new
      expect(grid.empty_squares).to match_array empty_squares
    end

    it 'does not have marked squares' do
      expect(grid.marked_squares).to be_empty
    end
  end

  context 'when grid is incomplete' do
    context 'without a winner' do
      subject(:grid) { GridHelpers.grid :incomplete_without_winner }

      it('returns a nil winner') { expect(grid.winner).to be_nil }
      it('is not a winner') { expect(grid).not_to be_winner }
      it('is not full') { expect(grid).not_to be_full }
      it("is not a cat's game") { expect(grid).not_to be_cats }
      it('is not done') { expect(grid).not_to be_done }

      it 'has empty squares' do
        empty_squares = GridHelpers.empty_squares :incomplete_without_winner
        expect(grid.empty_squares).to match_array empty_squares
      end

      it 'has marked squares' do
        marked_squares = GridHelpers.marked_squares :incomplete_without_winner
        expect(grid.marked_squares).to match_array marked_squares
      end
    end

    context 'with a winner' do
      subject(:grid) { GridHelpers.grid :incomplete_with_winner }

      it('returns a winner') { expect(grid.winner).to eq :o }
      it('is a winner') { expect(grid).to be_winner }
      it('is not full') { expect(grid).not_to be_full }
      it("is not a cat's game") { expect(grid).not_to be_cats }
      it('is done') { expect(grid).to be_done }

      it 'has empty squares' do
        empty_squares = GridHelpers.empty_squares :incomplete_with_winner
        expect(grid.empty_squares).to match_array empty_squares
      end

      it 'has marked squares' do
        marked_squares = GridHelpers.marked_squares :incomplete_with_winner
        expect(grid.marked_squares).to match_array marked_squares
      end
    end
  end

  context 'when grid is complete' do
    context 'without a winner' do
      subject(:grid) { GridHelpers.grid :complete_without_winner }

      it('returns a nil winner') { expect(grid.winner).to be_nil }
      it('is not a winner') { expect(grid).not_to be_winner }
      it('is full') { expect(grid).to be_full }
      it("is a cat's game") { expect(grid).to be_cats }
      it('is done') { expect(grid).to be_done }

      it 'does not have empty squares' do
        expect(grid.empty_squares).to be_empty
      end

      it 'has marked squares' do
        marked_squares = GridHelpers.marked_squares :complete_without_winner
        expect(grid.marked_squares).to match_array marked_squares
      end

      it 'raises an error on further mark! attempts' do
        expect { grid.mark! 5 }.to raise_error StandardError
      end
    end

    context 'with a winner' do
      subject(:grid) { GridHelpers.grid :complete_with_winner }

      it('return a winner') { expect(grid.winner).to eq :x }
      it('is a winner') { expect(grid).to be_winner }
      it('is full') { expect(grid).to be_full }
      it("is not a cat's game") { expect(grid).not_to be_cats }
      it('is done') { expect(grid).to be_done }

      it('does not have empty squares') do
        expect(grid.empty_squares).to be_empty
      end

      it 'has marked squares' do
        marked_squares = GridHelpers.marked_squares :complete_with_winner
        expect(grid.marked_squares).to match_array marked_squares
      end

      it('raises an error on further mark! attempts') do
        expect { grid.mark! 3 }.to raise_error StandardError
      end
    end
  end
end
