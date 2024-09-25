# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/tic_tac_toe/player'

RSpec.describe TicTacToe::Player do
  let(:player) { described_class.new :x }

  describe '::default_name' do
    it "returns 'Player'" do
      expect(described_class.default_name).to eq 'Player'
    end
  end

  describe '::new' do
    it 'returns an instance of itself' do
      expect(player).to be_a described_class
    end

    it 'accepts 1 argument' do
      expect { described_class.new(1) }.not_to raise_error
    end

    [[], [1, 2]].each do |args|
      it "does not accept #{args.size} arguments" do
        expect { described_class.new(*args) }.to raise_error ArgumentError
      end
    end
  end

  describe '#mark & #mark = value' do
    it 'sets and gets a mark' do
      player.mark = :z
      expect(player.mark).to eq :z
    end
  end

  describe '#name & #name = value' do
    it 'sets and gets a name' do
      player.name = 'Xavier'
      expect(player.name).to eq 'Xavier'
    end
  end

  describe '#request_move(grid)' do
    it 'raises an error' do
      expect { player.request_move(:grid) }.to raise_error NotImplementedError
    end
  end
end
