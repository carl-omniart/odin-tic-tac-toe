# frozen_string_literal: true

module TicTacToe
  # TicTacToe::Main ...
  class Main
    def initialize
      @view    = View.new spacing: 1, char_transform: :upcase
      @players = []
    end

    attr_reader :view, :players

    def start
      intro
      game
      outro
    end

    def intro
      view.welcome
      setup_players
      view.help
    end

    def game
      until :pigs == :fly
        Game.new(*players).each_state { |state| view.show state.to_s }
        break unless view.yes_or_no?('Play again?')

        players.reverse!
      end
    end

    def outro
      view.goodbye
    end

    def setup_players
      @players = %i[x o].map do |mark|
        klass  = view.request_player mark, *Player.subclasses
        player = klass.new mark
        player.view = view if player.is_a? TicTacToe::You
        player
      end
    end
  end
end
