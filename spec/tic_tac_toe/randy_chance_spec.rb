# frozen_string_literal: true

require 'spec_helper'
require_relative '../support/grid_helpers'
require_relative '../../lib/tic_tac_toe/randy_chance'

RSpec.describe TicTacToe::RandyChance do
  let(:randy) { described_class.new :r }

  context 'when winning move next' do
    let(:grid) { GridHelpers.grid :winning_move_next }
    let(:empty_squares) { GridHelpers.empty_squares :winning_move_next }

    it 'chooses a random move' do
      actual = Array.new(42) { randy.request_move grid }.uniq
      expect(actual).to match_array empty_squares
    end
  end

  context 'when blocking move next' do
    let(:grid) { GridHelpers.grid :blocking_move_next }
    let(:empty_squares) { GridHelpers.empty_squares :blocking_move_next }

    it 'chooses a random move' do
      actual = Array.new(42) { randy.request_move grid }.uniq
      expect(actual).to match_array empty_squares
    end
  end
end
