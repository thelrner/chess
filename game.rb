require_relative 'board'
require_relative 'piece'
require_relative 'stepping_piece'
require_relative 'sliding_piece'
require 'byebug'

class Game

  attr_accessor :board, :current_color

  def initialize(board = Board.new)
    @board = board
    @current_color = :white
  end

  def play
    until board.over?
      board.render
      begin
        player_move = get_move
        check_move(player_move)    # asks for move, checks if is current player's piece
        board.move(*player_move)
      rescue StandardError => e
        puts "#{e.message}"
        retry
      end
      switch_player
    end
  end

  def get_move
    puts "Where do you move? ie. f2, f5"
    move = gets.chomp
    move = move.split(',').map(&:strip)
    move.map {|coord| board.convert_to_position(coord)}
  end

  def check_move(move)
    start_pos = move[0]
    raise "Not your piece" if board[start_pos].color != current_color
  end

  def switch_player
    self.current_color = current_color == :white ? :black : :white
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
