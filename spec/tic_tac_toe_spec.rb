# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/tic_tac_toe'

RSpec.describe 'TicTacToe' do
  it 'has a constant with major text banners' do
    expect(TicTacToe::BANNERS).not_to be_empty
  end
end
