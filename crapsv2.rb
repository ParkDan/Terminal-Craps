require 'money'
require './lib/craps_interface'
require './lib/die'

class CrapsGame
  include CrapsInterface
  def initialize
    @point=0
    @game_over=false
    @buyin=Money.new(0, "USD")
    @stack=Money.new(0, "USD")
    @dice=[Die.new, Die.new]
    @roll_sum=0
  end

  def run
    buyin
    start_game
  end
end

game=CrapsGame.new
game.run
