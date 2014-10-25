class Board

  require 'pry'

  MODIFIERS = ([-1,0,1].product([-1,0,1]- [[0,0]])).freeze
  attr_accessor :board, :generation, :stats

  def initialize(board=[])
    @out = $stdout
    @board = board
    puts MODIFIERS if ENV['debug']
    @board.map!{ |x,y| [x+10,y+20] }
    @generation = 0
    @stats = {}
  end

  #                    [x,y]
  def find_neighbors_of(coordinate)
    #@stats[:t_find_neighbors_of_start] = Time.now
    MODIFIERS.map do |x,y|
      [coordinate[0] + x, coordinate[1] + y]
    end
    #@stats[:t_find_neighbors_of_end] = Time.now
  end

  def find_living_neighbors(coordinate)
    neighborhood = find_neighbors_of(coordinate)
    (@board & neighborhood - [coordinate]).uniq
  end

  def count_living_neighbors(coordinate)
    find_living_neighbors(coordinate).size
  end

  def print_board
    screen_x, screen_y = get_window_width_and_height
    output_string = ""
    (screen_x-2).times do |i|
 #output_string << ((i  == 0 ) ? j.to_s : "X")
      (screen_y-1).times do |j|
        if board.include? [i,j]
 #output_string << ((i  == 0 && screen_y-5 == j) ? (j.to_s+"/n") : "")
         output_string << ((i  == 0 ) ? j.to_s : "X")
         #print "X"
         #output_string << "X"
        else
 #output_string << ((i  == 0 && screen_y-5 == j) ? (j.to_s+"/n") : "")
          output_string << (( j == 0 ) ? i.to_s : ".")
          #print "."
        end
        #puts  if j == (screen_y-2)
        output_string << "\n" if j == (screen_y-2)
       end
    end
    @generation += 1
    @out.print output_string
    #@out.print "Generation: " + @generation.to_s + (@stats[:t_find_neighbors_of_start] - @stats[:t_find_neighbors_of_start]).to_s + "\n"
    @out.print "Generation: " + @generation.to_s + "\n"
    @out.flush
 #   sleep 0.001
  end

  #Get terminal height and width (os x, ubuntu)
  def get_window_width_and_height
    `stty size`.scan(/\d+/).map { |s| s.to_i }
  end

end

class Game

  attr_accessor :b
  def initialize

    #setup = Struct.new(:name, :living_fields)
    #setup.new("acron", [[3,5],[5,6],[3,6],[4,8],[5,9],[5,10],[5,11]])

    #@b = Board.new([[3,5],[5,6],[3,6],[4,8],[5,9],[5,10],[5,11]]) #acron
    # @b = Board.new([[5,5],[5,6],[4,6],[6,6], [4,7]]) #F-pentomino
    #@b = Board.new([[5,5],[5,6],[4,5],[4,6], [4,10],[4,12],[6,11],[5,11]]) #die hard
    #@b = Board.new([[5,5],[5,6],[5,7],[5,8],[4,8],[3,8],[2,7],[4,4],[2,4]]) #lightweight spaceship
    #@b = Board.new([[3,3],[3,4],[3,5],[2,5],[1,4]]) #Glider
    @b = Board.new([[3,3],[3,4],[3,5]]) #blinker
  end

  def play(times=100)
  end

  def find_all_fields_to_visit
    @all_fields = []
    @b.board.map do |x,y|
        puts @b.find_neighbors_of([x,y]).inspect if @debug
        @b.find_neighbors_of([x,y]).each do |element|
          @all_fields << element
        end
    end
    @all_fields.uniq.sort
  end

  def dead_fields
    find_all_fields_to_visit - @b.board
  end

  def evolve_board
    @next_gen = []
    find_all_fields_to_visit.each do |field|
      #puts "*** field " + field.to_s
      if dead_fields.include? field  then
        @next_gen << field if ( @b.count_living_neighbors(field) == 3 )
        #@b.board << field if ( @b.count_living_neighbors(field) == 3 )
      else
        if [0,1].include? (@b.count_living_neighbors(field))
           #puts "it dies"
        elsif [2,3].include? (@b.count_living_neighbors(field))
           #puts "zjivej"
           @next_gen << field
        else (@b.count_living_neighbors(field)) > 3
           #puts "it dies"
        end
      end
    end
    @b.board = @next_gen
    @next_gen = []
  end

end

g = Game.new
n = g.find_all_fields_to_visit
puts n.inspect
puts g.b.inspect
199.times {
g.b.print_board
#puts "#" * 88 + "\n"
g.evolve_board
#puts g.b.inspect
}

