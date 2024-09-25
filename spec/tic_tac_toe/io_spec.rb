# frozen_string_literal: true

require 'spec_helper'
require 'stringio'
require_relative '../../lib/tic_tac_toe/io'

RSpec.describe TicTacToe::IO do
  let(:io) do
    StringIO.new.then { |io| described_class.new input: io, output: io }
  end
  let(:control_chars) { "\a\b\e\f\r\t\v".chars }

  describe '#post(message)' do
    it 'posts a string with trailing newline' do
      io.post 'Hello!'
      expect(io.output.string).to end_with "Hello!\n"
    end

    it 'posts multiple strings' do
      io.post '1', '2', '3'
      expect(io.output.string).to end_with "1\n2\n3\n"
    end

    it 'spaces posts' do
      1.upto(5) do |spacing|
        io.spacing = spacing
        io.post 'line'
        expect(io.output.string).to end_with "line#{"\n" * spacing}\n"
      end
    end

    it 'posts interior newlines' do
      io.post "first\nsecond"
      expect(io.output.string.chomp).to end_with "first\nsecond"
    end

    it 'does not post other control characters' do
      io.post "H#{control_chars.join}i"
      expect(io.output.string.chomp).to end_with 'Hi'
    end
  end

  describe '#post_list(enumerable_object) { |item| block }' do
    it 'formats array items' do
      ary = [[:a, 1], [:b, 2], [:c, 3]]
      io.post_list(ary) { |(a, b)| "*#{a}+#{b}_" }
      expect(io.output.string).to end_with "*a+1_\n*b+2_\n*c+3_\n"
    end

    it 'formats hash pairs' do
      hash = { a: 1, b: 2, c: 3 }
      io.post_list(hash) { |(key, value)| "- #{key}: #{value}" }
      expect(io.output.string).to end_with "- a: 1\n- b: 2\n- c: 3\n"
    end
  end

  describe '#prompt(string)' do
    it 'prints a string with a trailing space' do
      io.prompt 'Name:'
      expect(io.output.string).to end_with 'Name: '
    end

    it 'does not print other control characters' do
      io.prompt "H#{control_chars.join}i"
      expect(io.output.string).to end_with 'Hi '
    end
  end

  describe '#request_string(message)' do
    it 'prints a message with a trailing space' do
      allow(io.input).to receive(:gets).and_return 'Humpty Dumpty\n'
      io.request_string 'Name:'
      expect(io.output.string).to include 'Name: '
    end

    it 'gets a string from the user' do
      allow(io.input).to receive(:gets).and_return "John Q. Public\n"
      expect(io.request_string('Name:')).to eq 'John Q. Public'
    end

    it 'filters out newlines' do
      allow(io.input).to receive(:gets).and_return "line\n"
      expect(io.request_string('Line:')).to eq 'line'
    end

    it 'filters out control characters' do
      allow(io.input).to receive(:gets).and_return "H#{control_chars.join}i"
      expect(io.request_string('Welcome:')).to eq 'Hi'
    end
  end

  describe '#request_char(message, *valid_chars)' do
    it 'prints a message with a trailing space' do
      allow(io.input).to receive(:getch).and_return 'Y'
      io.request_char '(Y)es or (N)o?', 'Y', 'N'
      expect(io.output.string).to include '(Y)es or (N)o? '
    end

    it 'gets a character from the user' do
      allow(io.input).to receive(:getch).and_return 'Y'
      expect(io.request_char('(Y)es or (N)o?', 'Y', 'N')).to eq 'Y'
    end

    it 'does not filter out newline' do
      allow(io.input).to receive(:getch).and_return "\n"
      expect(io.request_char('New Line:', "\n")).to eq "\n"
    end

    it 'does not filter out control characters' do
      control_chars.each do |char|
        allow(io.input).to receive(:getch).and_return char
        expect(io.request_char('Control:', *control_chars)).to eq char
      end
    end
  end

  describe '#choose(message, *choices)' do
    before { allow(io.input).to receive(:getch).and_return '2' }

    let(:pets) { %w[Bird Cat Dog Fish Gerbil Hamster Lizard Mouse] }

    it 'posts a numbered list of choices' do
      io.choose 'Pet:', *pets
      expect(io.input.string).to include "(1) Bird\n(2) Cat\n(3) Dog"
    end

    it 'prints a message with a trailing space' do
      io.choose 'Pet:', *pets
      expect(io.output.string).to include 'Pet: '
    end

    it 'gets a choice from the user' do
      expect(io.choose('Pet:', *pets)).to eq 'Cat'
    end
  end
end
