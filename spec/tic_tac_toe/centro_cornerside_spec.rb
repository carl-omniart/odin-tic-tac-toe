# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/grid_helpers'
require_relative '../../lib/tic_tac_toe/centro_cornerside'

RSpec.describe TicTacToe::CentroCornerside do
  describe '#request_move(grid)' do
    let(:x) { described_class.new :x }
    let(:o) { described_class.new :o }

    context 'when there is a winning move' do
      let(:grid) { GridHelpers.grid :winning_move_next }

      it 'makes the winning move' do
        42.times { expect(x.request_move(grid)).to eq 1 }
      end
    end

    context 'when there is a blocking move' do
      let(:grid) { GridHelpers.grid :blocking_move_next }

      it 'makes the blocking move' do
        42.times { expect(o.request_move(grid)).to eq 7 }
      end
    end

    context 'when the center square is vacant' do
      let(:grid) { GridHelpers.grid :vacant_center }

      it 'marks the center square' do
        42.times { expect(o.request_move(grid)).to eq 5 }
      end
    end

    context 'when a corner square is vacant' do
      let(:grid) { GridHelpers.grid :corner_trap }

      it 'marks a corner square' do
        42.times { expect(o.request_move(grid)).to eq(1).or eq(9) }
      end
    end
  end
end
