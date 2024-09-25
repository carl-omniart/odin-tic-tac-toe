# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/tic_tac_toe'

require_relative 'tic_tac_toe/grid_spec'
require_relative 'tic_tac_toe/io_spec'
require_relative 'tic_tac_toe/view_spec'
require_relative 'tic_tac_toe/player_spec'
require_relative 'tic_tac_toe/randy_chance_spec'
require_relative 'tic_tac_toe/centro_cornerside_spec'
require_relative 'tic_tac_toe/minnie_maxwell_spec'

RSpec.describe TicTacToe do
  it 'responds to ::play' do
    expect(described_class).to respond_to :play
  end
end
