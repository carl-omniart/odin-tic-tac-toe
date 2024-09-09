# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/tic_tac_toe/grid'

RSpec.describe TicTacToe::Grid do
  {
    new_grid: [],
    incomplete_without_winner: [
      5, 4, # x o x
      8, 2, #   o x
      6, 7  #     o
    ],
    incomplete_and_won_by_o: [
      1, 4, # o x o
      7, 6, # x o
      2, 0, # o x x
      3, 8
    ],
    complete_and_without_winner: [
      4, 0, # o x x
      2, 6, # x x o
      3, 5, # o o x
      7, 1,
      8
    ],
    complete_and_won_by_x: [
      2, 4, # x x x
      6, 5, # x o o
      3, 0, # o o x
      8, 1,
      7
    ]
  }.each do |name, moves|
    let(name) do
      new_grid = described_class.new :x, :o
      moves.reduce(new_grid) { |grid, square| grid.mark square }
    end
  end

  describe '::new(mark1, mark2)' do
    it 'returns an instance of itself' do
      expect(described_class.new(:x, :o)).to be_a(described_class)
    end

    it 'accepts 2 arguments' do
      expect { described_class.new(1, 2) }.not_to raise_error
    end

    [[], [1], [1, 2, 3]].each do |args|
      it "does not accept #{args.size} arguments" do
        expect { described_class.new(*args) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#marks' do
    it 'returns a pair' do
      expect(new_grid.marks.size).to eq(2)
    end

    it 'returns marks passed to ::new' do
      marks = %i[j k]
      grid  = described_class.new(*marks)
      expect(grid.marks).to eq(marks)
    end
  end

  describe '#active_mark' do
    it 'returns a mark' do
      expect(new_grid.marks).to include(new_grid.active_mark)
    end

    context 'when new grid' do
      it 'returns the first mark passed to ::new' do
        expect(new_grid.active_mark).to eq(:x)
      end
    end
  end

  describe '#squares' do
    it 'returns nine squares' do
      expect(new_grid.squares.size).to eq(9)
    end
  end

  describe '#mark(square)' do
    it 'returns itself' do
      expect(new_grid.mark(4)).to be(new_grid)
    end

    it 'marks square with active mark' do
      active_mark = new_grid.active_mark
      square      = 3

      expect { new_grid.mark square }
        .to change { new_grid.squares[square] }.from(nil).to(active_mark)
    end

    it 'raises an error if square is already marked' do
      expect { new_grid.mark(8).mark(8) }
        .to raise_error(TicTacToe::OccupiedError)
    end

    it 'raises an error if grid is done' do
      expect { incomplete_and_won_by_o.mark 5 }.to raise_error(FrozenError)
    end

    it 'toggles the active mark' do
      expect { new_grid.mark(1) }
        .to change(new_grid, :active_mark).from(:x).to(:o)
    end

    it 'toggles the active mark back again' do
      expect { new_grid.mark(1).mark(2) }
        .not_to change(new_grid, :active_mark)
    end
  end

  describe '#empty_squares' do
    {
      new_grid: [0, 1, 2, 3, 4, 5, 6, 7, 8],
      incomplete_without_winner: [0, 1, 3],
      incomplete_and_won_by_o: [5],
      complete_and_without_winner: [],
      complete_and_won_by_x: []
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).empty_squares).to eq(expected) }
      end
    end
  end

  describe '#winning_mark' do
    {
      new_grid: nil,
      incomplete_without_winner: nil,
      complete_and_without_winner: nil,
      incomplete_and_won_by_o: :o,
      complete_and_won_by_x: :x
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).winning_mark).to eq(expected) }
      end
    end
  end

  describe '#winner?' do
    {
      new_grid: false,
      incomplete_without_winner: false,
      complete_and_without_winner: false,
      incomplete_and_won_by_o: true,
      complete_and_won_by_x: true
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).winner?).to eq(expected) }
      end
    end
  end

  describe '#full?' do
    {
      new_grid: false,
      incomplete_without_winner: false,
      incomplete_and_won_by_o: false,
      complete_and_without_winner: true,
      complete_and_won_by_x: true
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).full?).to eq(expected) }
      end
    end
  end

  describe '#cats?' do
    {
      new_grid: false,
      incomplete_without_winner: false,
      incomplete_and_won_by_o: false,
      complete_and_won_by_x: false,
      complete_and_without_winner: true
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).cats?).to eq(expected) }
      end
    end
  end

  describe '#done?' do
    {
      new_grid: false,
      incomplete_without_winner: false,
      incomplete_and_won_by_o: true,
      complete_and_without_winner: true,
      complete_and_won_by_x: true
    }.each do |grid, expected|
      context "when #{grid.to_s.tr('_', ' ')}" do
        it { expect(send(grid).done?).to eq(expected) }
      end
    end
  end

  describe '#to_s' do
    it 'displays a pretty grid' do
      expect(incomplete_without_winner.to_s).to eq(['x|o|x',
                                                    '-+-+-',
                                                    ' |o|x',
                                                    '-+-+-',
                                                    ' | |o'].join("\n"))
    end
  end
end
