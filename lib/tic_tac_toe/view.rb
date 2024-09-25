# frozen_string_literal: true

require_relative 'io'
require_relative 'grid'

module TicTacToe
  # TicTacToe::User ...
  class View
    WELCOME = [
      '#############################',
      '#  Welcome to TIC-TAC-TOE!  #',
      '#  Created by Carl Omniart  #',
      '#############################'
    ].freeze

    GOODBYE = [
      '#############################',
      '#      Good-Bye! XOXOX      #',
      '#############################'
    ].freeze

    HELP = [
      '#############################',
      '#                           #',
      '#  7|8|9  Q|W|E  Esc: Exit  #',
      '#  -+-+-  -+-+-             #',
      '#  4|5|6  A|S|D             #',
      '#  -+-+-  -+-+-             #',
      '#  1|2|3  Z|X|C             #',
      '#                           #',
      '#############################'
    ].freeze

    KEY_PADS = [
      %w[ 7 8 9
          4 5 6
          1 2 3 ].zip(Grid::SQUARES),
      %w[ Q W E
          A S D
          Z X C ].zip(Grid::SQUARES)
    ].flatten(1).to_h.freeze

    def initialize(**)
      @io = IO.new(**)
    end

    attr_reader :io

    def welcome
      io.post(*WELCOME)
    end

    def goodbye
      io.post(*GOODBYE)
    end

    def help
      io.post(*HELP)
    end

    def yes_or_no?(question)
      io.request_char("#{question} (Y)es or (N)o:", 'Y', 'N') == 'Y'
    end

    def show(lines)
      io.post lines
    end

    def request_move(*squares)
      key_pads       = KEY_PADS.select { |_, square| squares.include? square }
      key_pads["\e"] = :exit
      key_press      = io.request_char 'Move:', *key_pads.keys
      key_pads[key_press]
    end

    def request_player(mark, *players)
      name = io.choose "Player #{mark}:", *players.map(&:default_name)
      players.find { |player| player.default_name == name }
    end
  end
end
