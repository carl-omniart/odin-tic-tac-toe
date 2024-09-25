# frozen_string_literal: true

require 'io/console'

require_relative 'tic_tac_toe/main'
require_relative 'tic_tac_toe/grid'
require_relative 'tic_tac_toe/io'
require_relative 'tic_tac_toe/view'
require_relative 'tic_tac_toe/game'
require_relative 'tic_tac_toe/player'
require_relative 'tic_tac_toe/minnie_maxwell'
require_relative 'tic_tac_toe/centro_cornerside'
require_relative 'tic_tac_toe/randy_chance'
require_relative 'tic_tac_toe/you'

# TicTacToe ...
module TicTacToe
  def self.play
    Main.new.start
  end
end
