# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/grid_helpers'
require_relative '../support/minimax_helpers'
require_relative '../../lib/tic_tac_toe/minnie_maxwell'

RSpec.describe TicTacToe::MinnieMaxwell do
  {
    zero: 0,
    one: [5, 100, 37, -2, -13],
    two: [[3, 12, 8], [2, 4, 6], [14, 5, 2]]
  }.each { |name, state| let(name) { MinimaxHelpers.tree state } }

  describe '::max_value' do
    it 'returns value if state is cutoff' do
      expect(described_class.max_value(zero)).to eq 0
    end

    it 'finds the max value at a depth of one' do
      expect(described_class.max_value(one)).to eq 100
    end

    it 'finds the max min_value at a depth of two' do
      expect(described_class.max_value(two)).to eq 3
    end
  end

  describe '::min_value' do
    it 'returns value if state is cutoff' do
      expect(described_class.min_value(zero)).to eq 0
    end

    it 'finds the min value at a depth of one' do
      expect(described_class.min_value(one)).to eq(-13)
    end

    it 'finds the min max_value at a depth of two' do
      expect(described_class.min_value(two)).to eq 6
    end
  end

  describe '::decision(state)' do
    it 'finds the right action at a depth of one' do
      expect(described_class.decision(one)).to eq 1
    end

    it 'finds the right action at a depth of two' do
      expect(described_class.decision(two)).to eq 0
    end
  end

  describe '#request_move(grid)' do
    let(:x) { described_class.new :x }
    let(:o) { described_class.new :o }

    context 'when there is a winning move' do
      let(:grid) { GridHelpers.grid :winning_move_next }

      it 'makes the winning move' do
        99.times { expect(x.request_move(grid)).to eq 1 }
      end
    end

    context 'when there is a blocking move' do
      let(:grid) { GridHelpers.grid :blocking_move_next }

      it 'makes the blocking move' do
        99.times { expect(o.request_move(grid)).to eq 7 }
      end
    end

    context 'when there is a forking move' do
      let(:grid) { GridHelpers.grid :forking_move_next }

      it 'makes the forking move' do
        99.times { expect(x.request_move(grid)).to eq(8).or eq(9) }
      end
    end

    context 'when baited by a corner trap' do
      let(:grid) { GridHelpers.grid :corner_trap }

      it 'avoids the trap' do
        99.times { expect(o.request_move(grid)).to be_even }
      end
    end
  end
end
