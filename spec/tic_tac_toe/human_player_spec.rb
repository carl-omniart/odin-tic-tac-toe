# # frozen_string_literal: true

# require 'spec_helper'
# require_relative '../../lib/tic_tac_toe/player'
# require_relative '../../lib/tic_tac_toe/human_player'
# require_relative '../../lib/tic_tac_toe/grid'

# RSpec.describe TicTacToe::HumanPlayer do
#   describe '::new' do
#     it 'returns an instance of itself' do
#       expect(described_class.new(:t, 'Mr. T')).to be_a described_class
#     end

#     it 'accepts 2 arguments' do
#       expect { described_class.new(1, 2) }.not_to raise_error
#     end

#     [[], [1], [1, 2, 3]].each do |args|
#       it "does not accept #{args.size} arguments" do
#         expect { described_class.new(*args) }.to raise_error ArgumentError
#       end
#     end
#   end

#   it 'takes a mark' do
#     player      = described_class.new :mark, :name
#     player.mark = :new_mark

#     expect(player.mark).to eq :new_mark
#   end

#   it 'takes a name' do
#     player      = described_class.new :mark, :name
#     player.name = :new_name

#     expect(player.name).to eq :new_name
#   end
# end
