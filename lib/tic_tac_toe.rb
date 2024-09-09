# frozen_string_literal: true

require_relative 'tic_tac_toe/game'
require_relative 'tic_tac_toe/grid'
require_relative 'tic_tac_toe/io'
require_relative 'tic_tac_toe/exceptions'

module TicTacToe
  BANNERS = {
    welcome: [
      '#############################',
      '#  Welcome to TIC-TAC-TOE!  #',
      '#  Created by Carl Omniart  #',
      '#############################'
    ],
    help: [
      '#############################',
      '# 7|8|9   Q|W|E   Esc: Exit #',
      '# -+-+-   -+-+-     H: Help #',
      '# 4|5|6   A|S|D             #',
      '# -+-+-   -+-+-             #',
      '# 1|2|3   Z|X|C             #',
      '#############################'
    ],
    goodbye: [
      '#############################',
      '#      Good-Bye! XOXOX      #',
      '#############################'
    ]
  }.transform_values(&:freeze)
end
