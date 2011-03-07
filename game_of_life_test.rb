require 'test/unit'
require './game_of_life'

class GameOfLifeTest < Test::Unit::TestCase
  
  def setup
    @g = Game.new
  end 

  def test_board_is_array
    assert_equal @g.b.board.class, Array
  end

  def test_fields_are_two_elements_arrays
    @g.b.board.each{|f|  assert_equal f.class, Array}
  end

  def test_fields_coordinates_are_fixnums
    @g.b.board.each{|f|  assert [f[0].class,f[1].class].include? Fixnum }
  end

  def test_play
199.times {
@g.b.print_board
##puts "#" * 88 + "\n"
@g.evolve_board
#puts g.b.inspect
}
   

  end
#199.times {
#g.b.print_board
##puts "#" * 88 + "\n"
#g.evolve_board
##puts g.b.inspect
#}


end
