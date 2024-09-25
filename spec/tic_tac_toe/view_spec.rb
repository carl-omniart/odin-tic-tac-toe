# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require 'io/console'
require_relative '../../lib/tic_tac_toe/view'
require_relative '../../lib/tic_tac_toe/player'

RSpec.describe TicTacToe::View do
  let(:view) do
    string_io = StringIO.new
    described_class.new input: string_io, output: string_io
  end

  describe '#welcome' do
    it 'posts a welcome message' do
      view.welcome
      expect(view.io.output.string.upcase).to include 'WELCOME'
    end
  end

  describe '#goodbye' do
    it 'posts a good-bye message' do
      view.goodbye
      expect(view.io.output.string.upcase).to include 'GOOD-BYE'
    end
  end

  describe '#help' do
    it 'posts a help message' do
      view.help
      expect(view.io.output.string.upcase).to include 'HELP'
    end
  end

  describe '#yes_or_no?(question)' do
    it "returns true when answered 'Y'" do
      allow(view.io.input).to receive(:getch).and_return 'Y'
      expect(view.yes_or_no?('Does this work?')).to be true
    end

    it "returns false when answered 'N'" do
      allow(view.io.input).to receive(:getch).and_return 'N'
      expect(view.yes_or_no?('Will this fail?')).to be false
    end
  end

  describe '#request_move(*moves)' do
    let(:keypads) { described_class::KEY_PADS }
    let(:moves)   { described_class::KEY_PADS.values.uniq }

    it 'gets a move from user keypads' do
      keypads.each do |keypress, move|
        allow(view.io.input).to receive(:getch).and_return keypress
        expect(view.request_move(*moves)).to eq move
      end
    end

    it 'only gets permitted moves' do
      allow(view.io.input).to receive(:getch).and_return '0', 'G', '6'
      expect(view.request_move(*moves)).to eq 6
    end
  end

  describe '#request_player(mark, *players)' do
    let(:players) do
      %w[
        Alvin
        Betsy
        Chris
        Diane
      ].map { |name| class_double TicTacToe::Player, default_name: name }
    end

    it 'gets a player from a numbered list' do
      allow(view.io.input).to receive(:getch).and_return '2'
      expect(view.request_player(:x, *players).default_name).to eq 'Betsy'
    end
  end
end
