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
    board.populate_board
    until board.over?
      board.render
      puts "Current player is: #{current_color}"
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
    move.map {|coord| convert_to_position(coord)}
  end

  def convert_to_position(letter_num)
    letter_hash = Hash[("a".."h").to_a.zip((0..7).to_a)]
    [ (7-letter_num[1].to_i + 1), letter_hash[letter_num[0]] ]
  end

  def check_move(move)
    start_pos = move[0]
    raise "Not your piece" if board[start_pos].color != current_color
  end

  def switch_player
    self.current_color = current_color == :white ? :black : :white
  end

end

# game = Game.new
# game.board.populate_board
# # game.play
# game.board.render
# white_pawn = game.board[[6,0]]
# game.board.move([6, 0], [4, 0])
# game.board.render
# p white_pawn.possible_moves
# game.board.move([4, 0], [3, 0])



if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.board.populate_board
  game.play
  # game.board.render
  # game.board.move([6, 0], [4, 0])
  # game.board.render
  # game.board.move([4, 0], [3, 0])
  # game.board.render
end
