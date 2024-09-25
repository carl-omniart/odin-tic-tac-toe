# frozen_string_literal: true

require 'spec_helper'
require 'support/grid_helpers'
require_relative '../../lib/tic_tac_toe/game'
require_relative '../../lib/tic_tac_toe/player'

RSpec.describe TicTacToe::Game do
  let(:x) { instance_double TicTacToe::Player, mark: :x, name: 'Ximena' }
  let(:o) { instance_double TicTacToe::Player, mark: :o, name: 'Oscar' }

  #   let(:new_game) { described_class.new double(mark: :x), double(mark: :o) }

  describe '::new(player1, player2)' do
    it 'returns an instance of Game' do
      expect(described_class.new(x, o)).to be_a described_class
    end

    it 'accepts 2 players as arguments' do
      expect { described_class.new x, o }.not_to raise_error
    end

    [[], [1], [1, 2, 3]].each do |args|
      it "does not accept #{args.size} arguments" do
        expect { described_class.new(*args) }.to raise_error ArgumentError
      end
    end
  end

  describe '#players' do
    subject(:players) { described_class.new(x, o).players }

    it('returns a hash') { expect(players).to be_a Hash }
    it('returns a pair') { expect(players.size).to eq 2 }

    it('returns players passed to ::new as values') do
      expect(players.values).to eq [x, o]
    end
  end

  describe '#active_player' do
    subject(:game) { described_class.new x, o }

    it('returns a player') { expect(game.active_player).to eq x }
  end

  describe '#grid' do
    subject(:game) { described_class.new x, o }

    it('returns a grid') { expect(game.grid).to be_a TicTacToe::Grid }
  end

  describe '#title' do
    subject(:game) { described_class.new x, o }

    it('returns a title') { expect(game.title).to eq 'Ximena vs. Oscar' }
  end

  describe '#status' do
    context 'when in progress' do
      subject(:game) { described_class.new x, o }

      it 'returns name of active player' do
        expect(game.status).to eq "Ximena's turn."
      end
    end

    context "when cat's game" do
      subject(:game) { described_class.new x, o }

      it("returns 'Cat's Game.'", skip: 'Not sure how to setup grid') do
        expect(game.status).to eq "Cat's Game."
      end
    end

    context 'when winner' do
      subject(:game) { described_class.new x, o }

      it("returns winner's name", skip: 'Not sure how to setup grid') do
        expect(game.status).to eq 'Ximena wins!'
      end
    end
  end
end
